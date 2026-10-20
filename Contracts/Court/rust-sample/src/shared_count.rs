// Shared terms and proof nodes for count. The where calculus remains unchanged.
// Replay rebuilds the source equations in its own arena, never in the builder's cache.
use crate::expression::{parse, Expression, Failure, Source};
use std::cell::RefCell;
use std::collections::{HashMap, HashSet};
use std::rc::Rc;

type Result<T> = std::result::Result<T, Failure>;
type Meter = Rc<RefCell<Work>>;
#[derive(Default, Debug)]
pub struct Work {
    pub remaining: usize,
    pub nodes: usize, pub edges: usize, pub substitutions: usize, pub visits: usize,
    pub proof_nodes: usize, pub proof_edges: usize,
    phase: &'static str,
}
impl Work {
    pub fn new(limit: usize, phase: &'static str) -> Meter {
        Rc::new(RefCell::new(Self { remaining: limit, phase, ..Self::default() }))
    }
    fn spend(&mut self, n: usize) -> Result<()> {
        if self.remaining < n { return Err(Failure::new(format!("count {} work limit reached; no impossibility inferred", self.phase))); }
        self.remaining -= n; Ok(())
    }
    fn visit(&mut self) -> Result<()> { self.spend(1)?; self.visits += 1; Ok(()) }
    fn proof(&mut self, edges: usize) -> Result<()> {
        self.spend(1 + edges)?; self.proof_nodes += 1; self.proof_edges += edges; Ok(())
    }
}
fn source_copy<'a>(source: &Source<'a>) -> Source<'a> { Source { world: source.world, rigid: source.rigid } }

#[derive(Clone, Debug, Hash, PartialEq, Eq)]
pub enum Term { Application(String, Vec<usize>), Field(usize, String) }
impl Term {
    fn refs(&self) -> Vec<usize> { match self { Self::Application(_, a) => a.clone(), Self::Field(o, _) => vec![*o] } }
}
pub struct Arena<'a> {
    pub source: Source<'a>, pub work: Meter, pub terms: Vec<Term>,
    depths: Vec<usize>, interned: HashMap<Term, usize>, parsed: HashMap<String, Expression>,
}
impl<'a> Arena<'a> {
    fn new(source: Source<'a>, work: Meter) -> Self {
        Self { source, work, terms: vec![], depths: vec![], interned: HashMap::new(), parsed: HashMap::new() }
    }
    fn get(&self, id: usize) -> Result<Term> { self.terms.get(id).cloned().ok_or_else(|| Failure::new("invalid count term reference")) }
    fn add(&mut self, term: Term) -> Result<usize> {
        self.work.borrow_mut().visit()?;
        if let Some(id) = self.interned.get(&term) { return Ok(*id); }
        let refs = term.refs();
        if refs.iter().any(|i| *i >= self.terms.len()) { return Err(Failure::new("count term reference is not earlier than its node")); }
        let depth = 1 + refs.iter().map(|i| self.depths[*i]).max().unwrap_or(0);
        if depth > 128 { return Err(Failure::new("expression exceeds validation depth limit")); }
        match &term {
            Term::Application(n, a) => {
                if parse(n, true)? != Expression::name(n) { return Err(Failure::new("malformed name in derivation input")); }
                self.source.check_application(n, a.len())?;
            }
            Term::Field(_, a) => if parse(a, false)? != Expression::name(a) { return Err(Failure::new("malformed field")); },
        }
        { let mut w = self.work.borrow_mut(); w.spend(1 + refs.len())?; w.nodes += 1; w.edges += refs.len(); }
        let id = self.terms.len(); self.terms.push(term.clone()); self.depths.push(depth); self.interned.insert(term, id); Ok(id)
    }
    pub fn read(&mut self, e: &Expression) -> Result<usize> { self.substitute(e, &HashMap::new()) }
    fn substitute(&mut self, e: &Expression, bindings: &HashMap<String, usize>) -> Result<usize> {
        self.work.borrow_mut().visit()?;
        match e {
            Expression::Application(n, a) => {
                if let Some(id) = bindings.get(n) {
                    if !a.is_empty() { return Err(Failure::new(format!("parameter '{}' used as a type constructor", n))); }
                    return Ok(*id);
                }
                let children = a.iter().map(|x| self.substitute(x, bindings)).collect::<Result<_>>()?;
                self.add(Term::Application(n.clone(), children))
            }
            Expression::Field(o, a) => { let owner = self.substitute(o, bindings)?; self.add(Term::Field(owner, a.clone())) }
        }
    }
    fn body(&mut self, text: &str, bindings: &HashMap<String, usize>) -> Result<usize> {
        let e = match self.parsed.get(text) {
            Some(e) => e.clone(),
            None => { let e = parse(text, false)?; self.parsed.insert(text.to_string(), e.clone()); e }
        };
        { let mut w = self.work.borrow_mut(); w.spend(1)?; w.substitutions += 1; }
        self.substitute(&e, bindings)
    }
    fn expansion(&mut self, id: usize) -> Result<Option<usize>> {
        match self.get(id)? {
            Term::Application(n, a) => {
                self.source.check_application(&n, a.len())?;
                if self.source.rigid.contains(&n) { return Ok(None); }
                let d = match self.source.world.aliases.get(&n) { Some(d) => d.clone(), None => return Ok(None) };
                Ok(Some(self.body(&d.body, &d.parameters.into_iter().zip(a).collect())?))
            }
            Term::Field(owner, axis) => {
                let (n, a) = match self.get(owner)? { Term::Application(n, a) => (n, a), _ => return Ok(None) };
                self.source.check_application(&n, a.len())?;
                if self.source.rigid.contains(&n) { return Ok(None); }
                if !self.source.world.conformers.contains_key(&n) && self.source.world.presented_bodies.contains(&n) {
                    return Err(Failure::new(format!("cannot read declaration '{}': body outside flat-definition fragment", n)));
                }
                let d = match self.source.world.conformers.get(&n) { Some(d) => d.clone(), None => return Ok(None) };
                let body = d.table.get(&axis).ok_or_else(|| Failure::new(format!("cannot read projection '{}': no definition of '{}' on '{}'", self.text(id), axis, n)))?;
                let mut bindings: HashMap<String, usize> = d.parameters.iter().cloned().zip(a).collect();
                bindings.insert("Self".to_string(), owner);
                let mut siblings: Vec<_> = d.table.keys().collect(); siblings.sort();
                for sibling in siblings {
                    if !bindings.contains_key(sibling) { bindings.insert(sibling.clone(), self.add(Term::Field(owner, sibling.clone()))?); }
                }
                Ok(Some(self.body(body, &bindings)?))
            }
        }
    }
    fn expression(&mut self, id: usize) -> Result<Expression> {
        self.work.borrow_mut().visit()?;
        match self.get(id)? {
            Term::Application(n, a) => Ok(Expression::Application(n, a.into_iter().map(|i| self.expression(i)).collect::<Result<_>>()?)),
            Term::Field(o, a) => Ok(Expression::Field(Box::new(self.expression(o)?), a)),
        }
    }
    fn text(&self, id: usize) -> String {
        fn walk(arena: &Arena, id: usize, left: &mut usize) -> String {
            if *left == 0 || id >= arena.terms.len() { return "…".to_string(); }
            *left -= 1;
            match &arena.terms[id] {
                Term::Application(n, a) if a.is_empty() => n.clone(),
                Term::Application(n, a) => format!("{}<{}>", n, a.iter().map(|i| walk(arena, *i, left)).collect::<Vec<_>>().join(", ")),
                Term::Field(o, a) => format!("{}.{}", walk(arena, *o, left), a),
            }
        }
        walk(self, id, &mut 10_000)
    }
}

#[derive(Clone, Debug)]
pub enum Step { Name(String), Arguments(String, Vec<usize>), Field(usize, String), Unfold(usize, usize), Join(usize, usize) }
impl Step {
    fn refs(&self) -> Vec<usize> {
        match self { Self::Name(_) => vec![], Self::Arguments(_, a) => a.clone(), Self::Field(o, _) => vec![*o], Self::Unfold(_, p) => vec![*p], Self::Join(a, b) => vec![*a, *b] }
    }
}
#[derive(Clone, Debug)]
pub struct Ends { pub input: usize, pub output: usize, depth: usize }
#[derive(Clone, Debug)]
pub struct Proof { pub terms: Vec<Term>, pub steps: Vec<Step> }
pub struct Builder<'a> {
    pub arena: Arena<'a>, pub steps: Vec<Step>, pub ends: Vec<Ends>,
    memo: HashMap<(usize, bool), usize>, identity: HashMap<usize, usize>, active: HashSet<(usize, bool)>,
}
impl<'a> Builder<'a> {
    pub fn new(source: Source<'a>, work: Meter) -> Self {
        Self { arena: Arena::new(source, work), steps: vec![], ends: vec![], memo: HashMap::new(), identity: HashMap::new(), active: HashSet::new() }
    }
    fn proof(&self) -> Proof { Proof { terms: self.arena.terms.clone(), steps: self.steps.clone() } }
    fn append(&mut self, step: Step, input: usize, output: usize) -> Result<usize> {
        let refs = step.refs(); let depth = 1 + refs.iter().map(|i| self.ends[*i].depth).max().unwrap_or(0);
        if depth >= 512 { return Err(Failure::new("derivation replay limit reached")); }
        self.arena.work.borrow_mut().proof(refs.len())?;
        let id = self.steps.len(); self.steps.push(step); self.ends.push(Ends { input, output, depth }); Ok(id)
    }
    fn unchanged(&mut self, id: usize) -> Result<usize> {
        self.arena.work.borrow_mut().visit()?;
        if let Some(p) = self.identity.get(&id) { return Ok(*p); }
        let step = match self.arena.get(id)? {
            Term::Application(n, a) if a.is_empty() => Step::Name(n),
            Term::Application(n, a) => Step::Arguments(n, a.into_iter().map(|i| self.unchanged(i)).collect::<Result<_>>()?),
            Term::Field(o, a) => Step::Field(self.unchanged(o)?, a),
        };
        let p = self.append(step, id, id)?; self.identity.insert(id, p); Ok(p)
    }
    pub fn derive(&mut self, id: usize, head: bool, depth: usize) -> Result<usize> {
        self.arena.work.borrow_mut().visit()?;
        if depth > 128 { return Err(Failure::new(format!("normalization limit reached at '{}'; no impossibility inferred", self.arena.text(id)))); }
        let key = (id, head);
        if let Some(p) = self.memo.get(&key) { return Ok(*p); }
        if !self.active.insert(key) { return Err(Failure::new(format!("cyclic count definition at '{}'; no impossibility inferred", self.arena.text(id)))); }
        let p = match self.arena.get(id)? {
            Term::Application(n, a) => {
                if let Some(body) = self.arena.expansion(id)? {
                    let child = self.derive(body, head, depth + 1)?;
                    self.append(Step::Unfold(id, child), id, self.ends[child].output)?
                } else if a.is_empty() || head { self.unchanged(id)? }
                else {
                    let children = a.into_iter().map(|i| self.derive(i, false, depth + 1)).collect::<Result<Vec<_>>>()?;
                    let output = self.arena.add(Term::Application(n.clone(), children.iter().map(|i| self.ends[*i].output).collect()))?;
                    self.append(Step::Arguments(n, children), id, output)?
                }
            }
            Term::Field(owner, axis) => {
                let owner_proof = self.derive(owner, true, depth + 1)?;
                let at = self.arena.add(Term::Field(self.ends[owner_proof].output, axis.clone()))?;
                let field = self.append(Step::Field(owner_proof, axis), id, at)?;
                if let Some(body) = self.arena.expansion(at)? {
                    let child = self.derive(body, head, depth + 1)?;
                    let unfolded = self.append(Step::Unfold(at, child), at, self.ends[child].output)?;
                    self.append(Step::Join(field, unfolded), id, self.ends[child].output)?
                } else { field }
            }
        };
        self.active.remove(&key); self.memo.insert(key, p); Ok(p)
    }
}
pub struct Replay<'a> { pub arena: Arena<'a>, pub terms: Vec<usize>, pub ends: Vec<Ends> }
pub fn replay<'a>(proof: &Proof, source: Source<'a>, work: Meter) -> Result<Replay<'a>> {
    let mut arena = Arena::new(source, work.clone()); let mut terms = vec![]; let mut ends: Vec<Ends> = vec![];
    for term in &proof.terms {
        if term.refs().iter().any(|i| *i >= terms.len()) { return Err(Failure::new("count term reference is not earlier than its node")); }
        let id = match term {
            Term::Application(n, a) => arena.add(Term::Application(n.clone(), a.iter().map(|i| terms[*i]).collect()))?,
            Term::Field(o, a) => arena.add(Term::Field(terms[*o], a.clone()))?,
        }; terms.push(id);
    }
    for step in &proof.steps {
        let refs = step.refs();
        if refs.iter().any(|i| *i >= ends.len()) { return Err(Failure::new("count proof reference is not earlier than its node")); }
        let depth = 1 + refs.iter().map(|i| ends[*i].depth).max().unwrap_or(0);
        if depth >= 512 { return Err(Failure::new("derivation replay limit reached")); }
        work.borrow_mut().proof(refs.len())?;
        let (input, output) = match step {
            Step::Name(n) => { let input = arena.add(Term::Application(n.clone(), vec![]))?; (input, input) }
            Step::Arguments(n, a) => (arena.add(Term::Application(n.clone(), a.iter().map(|i| ends[*i].input).collect()))?, arena.add(Term::Application(n.clone(), a.iter().map(|i| ends[*i].output).collect()))?),
            Step::Field(o, a) => (arena.add(Term::Field(ends[*o].input, a.clone()))?, arena.add(Term::Field(ends[*o].output, a.clone()))?),
            Step::Unfold(t, p) => {
                let input = *terms.get(*t).ok_or_else(|| Failure::new("invalid count term reference"))?;
                let body = arena.expansion(input)?.ok_or_else(|| Failure::new(format!("no source definition to unfold at '{}'", arena.text(input))))?;
                if ends[*p].input != body { return Err(Failure::new(format!("unfolded body differs from source at '{}'", arena.text(input)))); }
                (input, ends[*p].output)
            }
            Step::Join(a, b) => {
                if ends[*a].output != ends[*b].input { return Err(Failure::new("derivations have different shared boundaries")); }
                (ends[*a].input, ends[*b].output)
            }
        }; ends.push(Ends { input, output, depth });
    }
    Ok(Replay { arena, terms, ends })
}

#[derive(Clone, Debug)]
pub enum Rule { Zero, Unit, Plus(usize, usize) }
#[derive(Clone, Debug)]
pub struct CountNode { pub input: usize, pub reduction: usize, pub rule: Rule }
#[derive(Clone, Debug)]
pub struct CountProof { pub reduction: Proof, pub nodes: Vec<CountNode> }
pub struct Counter<'a, 'b> {
    pub builder: &'b mut Builder<'a>, pub nodes: Vec<CountNode>, memo: HashMap<usize, usize>, active: HashSet<usize>,
}
impl<'a, 'b> Counter<'a, 'b> {
    pub fn new(builder: &'b mut Builder<'a>) -> Self { Self { builder, nodes: vec![], memo: HashMap::new(), active: HashSet::new() } }
    pub fn derive(&mut self, input: usize, depth: usize) -> Result<usize> {
        self.builder.arena.work.borrow_mut().visit()?;
        if depth >= 128 { return Err(Failure::new("count expression exceeds the finite reader budget")); }
        if let Some(p) = self.memo.get(&input) { return Ok(*p); }
        if !self.active.insert(input) { return Err(Failure::new("cyclic count proof; no impossibility inferred")); }
        let reduction = self.builder.derive(input, true, 0)?;
        let output = self.builder.ends[reduction].output;
        let rule = match self.builder.arena.get(output)? {
            Term::Application(n, a) if n == "Never" && a.is_empty() => Rule::Zero,
            Term::Application(n, a) if n == "Unit" && a.is_empty() => Rule::Unit,
            Term::Application(n, a) if n == "Plus" => {
                if a.len() != 2 { return Err(Failure::new("Plus must have exactly two count operands")); }
                Rule::Plus(self.derive(a[0], depth + 1)?, self.derive(a[1], depth + 1)?)
            }
            _ => return Err(Failure::new(format!("'{}' is outside the finite Unit/Never/Plus count fragment", self.builder.arena.text(output)))),
        };
        self.builder.arena.work.borrow_mut().proof(if matches!(rule, Rule::Plus(_, _)) { 3 } else { 1 })?;
        let id = self.nodes.len(); self.nodes.push(CountNode { input, reduction, rule }); self.memo.insert(input, id); self.active.remove(&input); Ok(id)
    }
    pub fn proof(&self) -> CountProof { CountProof { reduction: self.builder.proof(), nodes: self.nodes.clone() } }
}
pub fn replay_count<'a>(proof: &CountProof, source: Source<'a>, work: Meter, roots: &[(usize, Expression)]) -> Result<(Replay<'a>, Vec<i64>)> {
    let mut checked = replay(&proof.reduction, source, work.clone())?;
    let mut values: Vec<i64> = vec![]; let mut depths: Vec<usize> = vec![];
    for node in &proof.nodes {
        if node.input >= checked.terms.len() || node.reduction >= checked.ends.len() || checked.ends[node.reduction].input != checked.terms[node.input] {
            return Err(Failure::new("count proof changes its source"));
        }
        let output = checked.ends[node.reduction].output;
        let (value, depth, edges) = match (&node.rule, checked.arena.get(output)?) {
            (Rule::Zero, Term::Application(n, a)) if n == "Never" && a.is_empty() => (0, 1, 1),
            (Rule::Unit, Term::Application(n, a)) if n == "Unit" && a.is_empty() => (1, 1, 1),
            (Rule::Plus(a, b), Term::Application(n, args)) if n == "Plus" => {
                if args.len() != 2 { return Err(Failure::new("Plus proof must have exactly two operands")); }
                if *a >= values.len() || *b >= values.len() { return Err(Failure::new("count proof reference is not earlier than its node")); }
                if checked.terms[proof.nodes[*a].input] != args[0] || checked.terms[proof.nodes[*b].input] != args[1] { return Err(Failure::new("count proof changes its operand")); }
                let value = values[*a].checked_add(values[*b]).ok_or_else(|| Failure::new(format!("count exceeds Int.max at '{}'", checked.arena.text(checked.terms[node.input]))))?;
                (value, 1 + depths[*a].max(depths[*b]), 3)
            }
            _ => return Err(Failure::new("count proof uses a rule without its source shape")),
        };
        if depth > 128 { return Err(Failure::new("count proof exceeds the replay budget")); }
        work.borrow_mut().proof(edges)?; values.push(value); depths.push(depth);
    }
    for (root, expected) in roots {
        if *root >= proof.nodes.len() || checked.terms[proof.nodes[*root].input] != checked.arena.read(expected)? {
            return Err(Failure::new("count proof belongs to a different question"));
        }
    }
    Ok((checked, values))
}

pub struct Reader<'a> { pub builder: Builder<'a>, pub construction: Meter, pub replay_work: Meter }
impl<'a> Reader<'a> {
    pub fn new(source: Source<'a>) -> Self { Self::with_limits(source, 50_000, 100_000) }
    pub fn with_limits(source: Source<'a>, construction_limit: usize, replay_limit: usize) -> Self {
        let construction = Work::new(construction_limit, "construction"); let replay_work = Work::new(replay_limit, "replay");
        Self { builder: Builder::new(source, construction.clone()), construction, replay_work }
    }
    pub fn normal(&mut self, input: &Expression) -> Result<Expression> { self.normalize(input, false) }
    pub fn normal_head(&mut self, input: &Expression) -> Result<Expression> { self.normalize(input, true) }
    fn normalize(&mut self, input: &Expression, head: bool) -> Result<Expression> {
        let term = self.builder.arena.read(input)?; let proof = self.builder.derive(term, head, 0)?;
        let mut checked = replay(&self.builder.proof(), source_copy(&self.builder.arena.source), self.replay_work.clone())?;
        if checked.ends[proof].input != checked.terms[term] { return Err(Failure::new("field reduction changes its source")); }
        checked.arena.expression(checked.ends[proof].output)
    }
    pub fn reading(&mut self, root: &Expression) -> Result<(bool, i64, i64)> {
        let field = |axis: &str| Expression::Field(Box::new(root.clone()), axis.to_string());
        let right = self.builder.arena.read(&field("Right"))?; let answer = self.builder.arena.read(&field("Answer"))?;
        let input = self.builder.arena.read(&field("Left"))?;
        let right_proof = self.builder.derive(right, false, 0)?; let answer_proof = self.builder.derive(answer, false, 0)?;
        let mut count = Counter::new(&mut self.builder);
        let actual = count.derive(input, 0)?; let declared = count.derive(answer, 0)?; let proof = count.proof();
        let (checked, values) = replay_count(&proof, source_copy(&self.builder.arena.source), self.replay_work.clone(), &[(actual, field("Left")), (declared, field("Answer"))])?;
        if checked.ends[right_proof].input != checked.terms[right] || checked.ends[answer_proof].input != checked.terms[answer] { return Err(Failure::new("field reduction changes its source")); }
        Ok((checked.ends[right_proof].output == checked.ends[answer_proof].output, values[actual], values[declared]))
    }
    pub fn count(&mut self, input: &Expression) -> Result<i64> {
        let term = self.builder.arena.read(input)?; let mut counter = Counter::new(&mut self.builder);
        let root = counter.derive(term, 0)?; let proof = counter.proof();
        Ok(replay_count(&proof, source_copy(&self.builder.arena.source), self.replay_work.clone(), &[(root, input.clone())])?.1[root])
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::structural::StructuralSource;
    fn world(extra: &str, identity: bool) -> crate::expression::World {
        let base = "enum Unit {}\nenum Never {}\nenum Plus<A, B> {}\ntypealias Twice<S> = Plus<S, S>\n";
        let text = if identity { base.replace("Plus<S, S>", "S") } else { base.to_string() } + extra;
        StructuralSource::new(&[("test.swift".to_string(), text)]).unwrap().syntax
    }
    fn certified(source: Source, text: &str) -> (CountProof, usize, Expression) {
        let e = parse(text, false).unwrap(); let mut b = Builder::new(source, Work::new(50_000, "construction"));
        let input = b.arena.read(&e).unwrap(); let mut count = Counter::new(&mut b);
        let root = count.derive(input, 0).unwrap(); (count.proof(), root, e)
    }
    #[test]
    fn large_count_and_checked_overflow() {
        let mut ladder = "typealias N0 = Unit\n".to_string();
        for n in 1..=63 { ladder.push_str(&format!("typealias N{} = Twice<N{}>\n", n, n - 1)); }
        let w = world(&ladder, false); let rigid = HashSet::new(); let s = Source { world: &w, rigid: &rigid };
        let mut reader = Reader::new(source_copy(&s));
        assert_eq!(reader.count(&parse("N20", false).unwrap()).unwrap(), 1_048_576);
        assert!(reader.construction.borrow().nodes < 200);
        assert_eq!(Reader::new(source_copy(&s)).count(&parse("N62", false).unwrap()).unwrap(), 4_611_686_018_427_387_904);
        let error = Reader::new(s).count(&parse("N63", false).unwrap()).unwrap_err();
        assert!(error.0.contains("count exceeds Int.max"));
    }
    #[test]
    fn replay_rejects_forged_rules_operands_and_forward_references() {
        let w = world("", false); let rigid = HashSet::new(); let s = Source { world: &w, rigid: &rigid };
        let (proof, root, input) = certified(source_copy(&s), "Plus<Unit, Never>");
        let check = |p: &CountProof| replay_count(p, source_copy(&s), Work::new(100_000, "replay"), &[(root, input.clone())]);
        assert_eq!(check(&proof).unwrap().1[root], 1);
        let mut bad = proof.clone();
        let a = match bad.nodes[root].rule { Rule::Plus(a, _) => a, _ => panic!("missing plus") };
        bad.nodes[root].rule = Rule::Plus(a, a); assert!(check(&bad).is_err());
        bad = proof.clone(); bad.nodes[root].rule = Rule::Unit; assert!(check(&bad).is_err());
        bad = proof.clone(); bad.nodes[root].input = usize::MAX; assert!(check(&bad).is_err());
        bad = proof.clone(); bad.nodes[root].rule = Rule::Plus(root, root); assert!(check(&bad).is_err());
        bad = proof.clone(); bad.reduction.terms[0] = Term::Field(0, "Left".to_string()); assert!(check(&bad).is_err());
        bad = proof; bad.reduction.steps[0] = Step::Join(0, 0); assert!(check(&bad).is_err());
    }
    #[test]
    fn changed_source_and_changed_question_do_not_reuse_a_count() {
        let w = world("", false); let changed = world("", true); let rigid = HashSet::new();
        let s = Source { world: &w, rigid: &rigid }; let other = Source { world: &changed, rigid: &rigid };
        let (p, root, input) = certified(source_copy(&s), "Twice<Unit>");
        assert!(replay_count(&p, source_copy(&other), Work::new(100_000, "replay"), &[(root, input.clone())]).is_err());
        assert!(replay_count(&p, s, Work::new(100_000, "replay"), &[(root, parse("Plus<Unit, Never>", false).unwrap())]).is_err());
        assert_eq!(Reader::new(other).count(&input).unwrap(), 1);
    }
    #[test]
    fn binding_owner_arguments_and_nominal_shape_are_retained() {
        let w = world("typealias Answer = Never\nenum Box<A, B> {\ntypealias Left = Plus<A, Twice<B>>\ntypealias Right = Plus<A, Twice<B>>\ntypealias Answer = Right\n}\nenum Unequal {\ntypealias Left = Plus<Unit, Plus<Unit, Unit>>\ntypealias Right = Plus<Plus<Unit, Unit>, Unit>\ntypealias Answer = Plus<Unit, Plus<Unit, Unit>>\n}", false);
        let rigid = HashSet::new(); let mut reader = Reader::new(Source { world: &w, rigid: &rigid });
        assert_eq!(reader.reading(&parse("Box<Unit, Twice<Unit>>", false).unwrap()).unwrap(), (true, 5, 5));
        assert_eq!(reader.count(&parse("Box<Never, Unit>.Left", false).unwrap()).unwrap(), 2);
        assert_eq!(reader.count(&parse("Plus<Twice<Unit>, Twice<Twice<Unit>>>", false).unwrap()).unwrap(), 6);
        assert_eq!(reader.reading(&parse("Unequal", false).unwrap()).unwrap(), (false, 3, 3));
    }
    #[test]
    fn separate_modes_and_finite_accounts_include_cache_hits() {
        let w = world("typealias A = Unit", false); let rigid = HashSet::new(); let s = Source { world: &w, rigid: &rigid };
        let mut b = Builder::new(source_copy(&s), Work::new(50_000, "construction"));
        let t = b.arena.read(&parse("Plus<A, Unit>", false).unwrap()).unwrap();
        let head = b.derive(t, true, 0).unwrap(); let full = b.derive(t, false, 0).unwrap();
        let checked = replay(&b.proof(), source_copy(&s), Work::new(100_000, "replay")).unwrap();
        assert_ne!(checked.ends[head].output, checked.ends[full].output);
        let left = b.arena.work.borrow().remaining; b.derive(t, false, 0).unwrap();
        assert!(b.arena.work.borrow().remaining < left);
        b.arena.work.borrow_mut().remaining = 0; assert!(b.derive(t, false, 0).is_err());
        assert!(Reader::with_limits(source_copy(&s), 1, 100_000).count(&parse("Unit", false).unwrap()).is_err());
        let (p, root, input) = certified(source_copy(&s), "Twice<Unit>");
        assert!(replay_count(&p, s, Work::new(1, "replay"), &[(root, input)]).is_err());
        let w = world("typealias Loop = Loop", false);
        assert!(Reader::new(Source { world: &w, rigid: &rigid }).count(&parse("Loop", false).unwrap()).is_err());
    }
    #[test]
    fn changed_primitive_is_not_an_arithmetic_premise() {
        let text = include_str!("../../v0.1/fixtures/Primitive.swift");
        let files = vec![("Primitive.swift".to_string(), text.to_string())];
        crate::count_court::check_primitive_rules(&files, &StructuralSource::new(&files).unwrap()).unwrap();
        let changed = text.replace("public enum Unit: Close {}", "public enum Unit: Close { public static var count: Int { 2 } }");
        assert_ne!(text, changed);
        let files = vec![("Primitive.swift".to_string(), changed)];
        assert!(crate::count_court::check_primitive_rules(&files, &StructuralSource::new(&files).unwrap()).is_err());
    }
}
