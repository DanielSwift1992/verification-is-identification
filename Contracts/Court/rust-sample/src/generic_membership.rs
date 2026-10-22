use crate::expression::{Expression,World,Source};
use crate::failure::{Failure,fail};
use crate::where_judge as judge;
use crate::structural::RequirementKind;
use std::collections::{HashMap,HashSet};

pub fn head(input:&Expression,world:&World,rigid:&HashSet<String>)->Result<Expression,Failure> {
    fn shared(input:&Expression,world:&World,rigid:&HashSet<String>)->Result<Expression,crate::expression::Failure> {
        use crate::shared_count::{Builder,Work,replay};
        let mut b=Builder::new(Source{world,rigid},Work::new(10_000,"membership construction")); b.depth_limit=64;
        let t=b.arena.read(input)?; let p=b.derive(t,true,0)?;
        // Reduce the full nominal term, not only its head. Existing aliases
        // may erase unused arguments; this is not a Swift validity check.
        // The full proof stays shared; only the head is returned as a tree.
        b.derive(t,false,0)?;
        let mut r=replay(&b.proof(),Source{world,rigid},Work::new(20_000,"membership replay"))?;
        if r.ends[p].input!=r.terms[t] {return Err(crate::expression::Failure::new("membership reduction changes its source"));}
        r.arena.expression(r.ends[p].output)
    }
    shared(input,world,rigid).map_err(|e|Failure::Unsupported(vec![e.to_string()]))
}
#[derive(Clone)]
enum Proof { Established,Missing(String,bool) }
fn open(term:&Expression)->bool {
    match term {Expression::Application(n,a)=>n.contains("$free_") || a.iter().any(open),Expression::Field(o,_)=>open(o)}
}
struct Membership<'a> {
    world:&'a World,rigid:&'a HashSet<String>,counted:&'a mut usize,
    facts:HashMap<String,HashSet<String>>,equations:Vec<(Expression,Expression)>,
    active:HashSet<String>,memo:HashMap<String,Proof>,remaining:usize,
}
impl Membership<'_> {
    fn equivalent(&self,left:&Expression,right:&Expression)->Result<bool,Failure> {
        if judge::compared(left,right,self.world,self.rigid)?.0 {return Ok(true);}
        let mut reachable=HashSet::from([left.text()]);
        loop {
            let old=reachable.clone();
            for (a,b) in &self.equations {let l=a.text();let r=b.text();if reachable.contains(&l){reachable.insert(r.clone());}if reachable.contains(&r){reachable.insert(l);}}
            if old==reachable {break;}
        }
        Ok(reachable.contains(&right.text()))
    }
    fn prove(&mut self,input:&Expression,required:&str,depth:usize)->Result<Proof,Failure> {
        if self.remaining==0 || depth>64 {return fail("generic membership work limit reached; no impossibility inferred");}
        self.remaining-=1;
        if !self.world.protocol_parents.contains_key(required) {return fail(format!("no declared protocol grounds for '{}'",required));}
        let term=head(input,self.world,self.rigid)?; let spelled=term.text();let key=format!("{}: {}",spelled,required);
        if self.facts.get(&spelled).map(|f|f.contains(required)).unwrap_or(false){return Ok(Proof::Established);}
        if let Some(p)=self.memo.get(&key){return Ok(p.clone());}
        if !self.active.insert(key.clone()){return fail(format!("gated membership cycle at '{}' has no independent ground",key));}
        let result=self.prove_active(&term,required,depth,&spelled,&key);
        self.active.remove(&key);result
    }
    fn prove_active(&mut self,term:&Expression,required:&str,depth:usize,spelled:&str,key:&str)->Result<Proof,Failure> {
        let name=term.head();let args=term.args();
        if open(term) && args.is_empty() && !self.world.conformers.contains_key(&name) {
            return Ok(Proof::Missing(format!("membership '{}' is not established by the declared parameter bounds",key),true));
        }
        let conformer=match self.world.conformers.get(&name){Some(c)=>c.clone(),None=>return fail(format!("no declared conformer grounds for '{}'",spelled))};
        if conformer.parameters.len()!=args.len(){return fail(format!("generic application '{}' has unbound arguments",spelled));}
        if let Some(u)=self.world.generic_unsupported.get(&name){if !u.is_empty(){return fail(format!("generic application '{}' carries unread conditions: {}",spelled,u.join(", ")));}}
        let mut bindings:HashMap<String,Expression>=conformer.parameters.iter().cloned().zip(args).collect();
        bindings.insert("Self".into(),term.clone());
        let mut axes:HashSet<String>=conformer.table.keys().cloned().collect();
        for parent in judge::inherited_protocols(&conformer.protocols,self.world){if let Some(a)=self.world.protocol_axes.get(&parent){axes.extend(a.clone());}}
        for axis in axes {bindings.entry(axis.clone()).or_insert_with(||Expression::Field(Box::new(term.clone()),axis));}
        let substituted=|text:&str|judge::substitute(&judge::parse_term(text)?,&bindings);
        let requirements=self.world.generic_requirements.get(&name).cloned().unwrap_or_default();
        for bound in requirements {
            let left=substituted(&bound.left)?;
            let reason=format!("generic application '{}' requires bound '{} {} {}'",spelled,bound.left,if bound.kind==RequirementKind::Member {":"} else {"=="},bound.right);
            if bound.kind==RequirementKind::Member {
                *self.counted+=1;
                if let Proof::Missing(message,uncertain)=self.prove(&left,&bound.right,depth+1)? {
                    if uncertain {return Ok(Proof::Missing(format!("{}: {}",reason,message),true));}
                    return Err(Failure::Refused(vec![format!("{}: {}",reason,message)]));
                }
            } else {
                let right=substituted(&bound.right)?;
                if !self.equivalent(&left,&right)? {
                    if open(&left)||open(&right){return Ok(Proof::Missing(format!("{}: equality not established",reason),true));}
                    return Err(Failure::Refused(vec![format!("{}: equality not established",reason)]));
                }
            }
        }
        if !judge::wears(&conformer,required,self.world){return Ok(Proof::Missing(format!("'{}' does not carry '{}'",spelled,required),false));}
        let mut parents:Vec<_>=judge::inherited_protocols(&conformer.protocols,self.world).into_iter().collect();parents.sort();
        for parent in parents {
            let gate=match self.world.gated_protocols.get(&parent){Some(g)=>g.clone(),None=>continue};
            if !gate.unjudged.is_empty(){return fail(format!("gated protocol '{}' carries unread conditions",parent));}
            for (left,right) in gate.equalities {if !self.equivalent(&substituted(&left)?,&substituted(&right)?)? {return Ok(Proof::Missing(format!("'{}: {}' requires '{} == {}'",spelled,parent,left,right),true));}}
            for (left,needed) in gate.memberships {
                *self.counted+=1;
                if let Proof::Missing(reason,uncertain)=self.prove(&substituted(&left)?,&needed,depth+1)? {return Ok(Proof::Missing(format!("'{}: {}' requires '{}: {}': {}",spelled,parent,left,needed,reason),uncertain));}
            }
        }
        self.memo.insert(key.into(),Proof::Established);Ok(Proof::Established)
    }
}
pub fn check(input:&Expression,proto:&str,site:&str,world:&World,rigid:&HashSet<String>,counted:&mut usize)->Result<Vec<String>,Failure> {
    let mut facts:HashMap<String,HashSet<String>>=HashMap::new();let mut equations=Vec::new();
    for conformer in world.conformers.values(){
        if conformer.parameters.is_empty(){continue;}
        let (bindings,context)=judge::conformer_context(conformer,world)?;
        if !context.is_subset(rigid){continue;}
        for requirement in world.generic_requirements.get(&conformer.name).into_iter().flatten(){
            let left=judge::substitute(&judge::parse_term(&requirement.left)?,&bindings)?;
            if requirement.kind==RequirementKind::Member {facts.entry(left.text()).or_default().extend(judge::inherited_protocols(&[requirement.right.clone()],world));}
            else {equations.push((left,judge::substitute(&judge::parse_term(&requirement.right)?,&bindings)?));}
        }
    }
    let mut reader=Membership{world,rigid,counted,facts,equations,active:HashSet::new(),memo:HashMap::new(),remaining:10_000};
    match reader.prove(input,proto,0)? {Proof::Established=>Ok(vec![]),Proof::Missing(reason,_)=>Ok(vec![format!("'{}': {}",site,reason)])}
}
