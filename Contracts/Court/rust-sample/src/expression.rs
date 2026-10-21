// Definitional reduction relative to the definitions the court read. A port of
// Sources/Court/DefinitionReduction.swift: the term grammar, the world of read
// declarations, the five derivation rules and their replay. No equation is
// built in: every unfold instantiates one addressed source definition.

use std::collections::{HashMap, HashSet};
use std::fmt;

#[derive(Debug, Clone)]
pub struct Failure(pub String);

impl Failure {
    pub fn new(text: impl Into<String>) -> Failure {
        Failure(text.into())
    }
}

impl fmt::Display for Failure {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.0)
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Expression {
    Application(String, Vec<Expression>),
    Field(Box<Expression>, String),
}

impl Expression {
    pub fn name(name: &str) -> Expression {
        Expression::Application(name.to_string(), Vec::new())
    }

    pub fn text(&self) -> String {
        match self {
            Expression::Application(name, args) => {
                if args.is_empty() {
                    name.clone()
                } else {
                    let inner: Vec<String> = args.iter().map(|a| a.text()).collect();
                    format!("{}<{}>", name, inner.join(", "))
                }
            }
            Expression::Field(owner, axis) => format!("{}.{}", owner.text(), axis),
        }
    }

    /// The legacy term head: an application's name, a projection's whole spelling.
    pub fn head(&self) -> String {
        match self {
            Expression::Application(name, _) => name.clone(),
            Expression::Field(_, _) => self.text(),
        }
    }

    pub fn args(&self) -> Vec<Expression> {
        match self {
            Expression::Application(_, args) => args.clone(),
            Expression::Field(_, _) => Vec::new(),
        }
    }

    /// Simultaneous substitution: an inserted expression is not visited again.
    pub fn substituting(&self, bindings: &HashMap<String, Expression>) -> Result<Expression, Failure> {
        match self {
            Expression::Application(name, args) => {
                if let Some(replacement) = bindings.get(name) {
                    if !args.is_empty() {
                        return Err(Failure::new(format!("parameter '{}' used as a type constructor", name)));
                    }
                    return Ok(replacement.clone());
                }
                let mut replaced = Vec::with_capacity(args.len());
                for arg in args {
                    replaced.push(arg.substituting(bindings)?);
                }
                Ok(Expression::Application(name.clone(), replaced))
            }
            Expression::Field(owner, axis) => Ok(Expression::Field(Box::new(owner.substituting(bindings)?), axis.clone())),
        }
    }
}

/// Whole-input grammar: identifier [<term (, term)*>] (.identifier)*.
struct Parser {
    characters: Vec<char>,
    allow_rigid_names: bool,
    position: usize,
}

impl Parser {
    fn spaces(&mut self) {
        while self.position < self.characters.len() && self.characters[self.position].is_whitespace() {
            self.position += 1;
        }
    }

    fn take(&mut self, character: char) -> bool {
        self.spaces();
        if self.position < self.characters.len() && self.characters[self.position] == character {
            self.position += 1;
            true
        } else {
            false
        }
    }

    fn name(&mut self) -> Result<String, Failure> {
        self.spaces();
        let start = self.position;
        if self.allow_rigid_names && self.position < self.characters.len() && self.characters[self.position] == '$' {
            self.position += 1;
        }
        let first = self.characters.get(self.position).copied();
        match first {
            Some(c) if c.is_alphabetic() || c == '_' => {}
            _ => return Err(Failure::new(format!("expected an identifier at character {}", self.position))),
        }
        self.position += 1;
        while self.position < self.characters.len() {
            let c = self.characters[self.position];
            if c.is_alphabetic() || c.is_numeric() || c == '_' {
                self.position += 1;
            } else {
                break;
            }
        }
        Ok(self.characters[start..self.position].iter().collect())
    }

    fn expression(&mut self, depth: usize) -> Result<Expression, Failure> {
        if depth >= 128 {
            return Err(Failure::new("term exceeds the reader depth limit"));
        }
        let head = self.name()?;
        let mut arguments = Vec::new();
        if self.take('<') {
            arguments.push(self.expression(depth + 1)?);
            while self.take(',') {
                arguments.push(self.expression(depth + 1)?);
            }
            if !self.take('>') {
                return Err(Failure::new(format!("unclosed arguments of '{}'", head)));
            }
        }
        let mut result = Expression::Application(head, arguments);
        while self.take('.') {
            let axis = self.name()?;
            result = Expression::Field(Box::new(result), axis);
        }
        Ok(result)
    }
}

pub fn parse(text: &str, allow_rigid_names: bool) -> Result<Expression, Failure> {
    let mut parser = Parser { characters: text.chars().collect(), allow_rigid_names, position: 0 };
    let result = parser.expression(0)?;
    parser.spaces();
    if parser.position != parser.characters.len() {
        return Err(Failure::new(format!("unsupported term suffix at character {} in '{}'", parser.position, text)));
    }
    Ok(result)
}

// ── the world a court read ──

#[derive(Debug, Clone, Default)]
pub struct Conformer {
    pub name: String,
    pub parameters: Vec<String>,
    pub protocols: Vec<String>,
    pub table: HashMap<String, String>,
}

#[derive(Debug, Clone)]
pub struct AliasRule {
    pub parameters: Vec<String>,
    pub body: String,
}

#[derive(Debug, Clone)]
pub struct GatedExtension {
    pub head: String,
    pub proto: String,
    pub equalities: Vec<(String, String)>,
    pub memberships: Vec<(String, String)>,
    pub unjudged: Vec<String>,
}

#[derive(Debug, Clone)]
pub struct GatedProtocol {
    pub name: String,
    pub equalities: Vec<(String, String)>,
    pub memberships: Vec<(String, String)>,
    pub unjudged: Vec<String>,
}

pub type Span = (usize, usize);

#[derive(Debug, Clone, Default)]
pub struct World {
    pub contextual: bool,
    pub context_source: String,
    pub context_unresolved: Vec<String>,
    pub excluded_definitions: Vec<String>,
    pub addresses: HashMap<String, String>,
    pub context_conformers: HashSet<String>,
    pub namespaces: HashSet<String>,
    pub nested_names: HashSet<String>,
    pub intrinsic_swift: bool,
    pub conformers: HashMap<String, Conformer>,
    pub aliases: HashMap<String, AliasRule>,
    pub gates: Vec<GatedExtension>,
    pub gated_protocols: HashMap<String, GatedProtocol>,
    pub protocol_parents: HashMap<String, Vec<String>>,
    pub protocol_axes: HashMap<String, HashSet<String>>,
    pub parameters: HashMap<String, Vec<String>>,
    pub conditional_declarations: HashSet<String>,
    pub presented_bodies: HashSet<String>,
    pub uses: Vec<String>,
    pub use_lines: Vec<usize>,
    pub certificate_lines: HashMap<String, usize>,
    /// Uses and parameterless certificates are judged at their root.
    pub root_application_spans: Vec<Span>,
    /// the lines each name of this file is declared at, in any scope
    pub declared: HashMap<String, Vec<usize>>,
    /// the lines at which this file extends each name, in any form
    pub extensions: HashMap<String, Vec<usize>>,
    /// the names this file declares at file scope as a type, a protocol or a typealias
    pub file_types: HashSet<String>,
    /// every name this file's code spells
    pub names: HashSet<String>,
    pub clean: String,
    pub line_at: Vec<usize>,
    pub read_spans: Vec<Span>,
    pub alias_spans: Vec<Span>,
}

pub struct Source<'a> {
    pub world: &'a World,
    pub rigid: &'a HashSet<String>,
}

impl<'a> Source<'a> {
    pub fn validate(&self, expression: &Expression, depth: usize) -> Result<(), Failure> {
        if depth >= 128 {
            return Err(Failure::new("expression exceeds validation depth limit"));
        }
        match expression {
            Expression::Application(name, arguments) => {
                if parse(name, true)? != Expression::name(name) {
                    return Err(Failure::new("malformed name in derivation input"));
                }
                self.check_application(name, arguments.len())?;
                for argument in arguments {
                    self.validate(argument, depth + 1)?;
                }
                Ok(())
            }
            Expression::Field(owner, axis) => {
                if parse(axis, false)? != Expression::name(axis) {
                    return Err(Failure::new("malformed field"));
                }
                self.validate(owner, depth + 1)
            }
        }
    }

    pub fn check_application(&self, name: &str, count: usize) -> Result<(), Failure> {
        if self.rigid.contains(name) {
            if count != 0 {
                return Err(Failure::new(format!("free parameter '{}' applied to arguments", name)));
            }
            return Ok(());
        }
        if name.starts_with('$') {
            return Err(Failure::new(format!("unbound internal parameter '{}'", name)));
        }
        if self.world.conditional_declarations.contains(name) {
            return Err(Failure::new(format!("cannot read conditional declaration '{}'", name)));
        }
        if self.world.aliases.contains_key(name) && self.world.conformers.contains_key(name) {
            return Err(Failure::new(format!("ambiguous alias and nominal definition of '{}'", name)));
        }
        let parameters = self
            .world
            .aliases
            .get(name)
            .map(|a| a.parameters.clone())
            .or_else(|| self.world.parameters.get(name).cloned())
            .or_else(|| self.world.conformers.get(name).map(|c| c.parameters.clone()));
        if let Some(parameters) = parameters {
            let distinct: HashSet<&String> = parameters.iter().collect();
            if distinct.len() != parameters.len() {
                return Err(Failure::new(format!("duplicate parameters on '{}'", name)));
            }
            if parameters.len() != count {
                return Err(Failure::new(format!(
                    "'{}' requires {} arguments, received {}",
                    name,
                    parameters.len(),
                    count
                )));
            }
        }
        Ok(())
    }

    /// The only elementary equations: instantiate the addressed source definition.
    pub fn expansion(&self, expression: &Expression) -> Result<Option<Expression>, Failure> {
        match expression {
            Expression::Application(name, arguments) => {
                self.check_application(name, arguments.len())?;
                if self.rigid.contains(name) {
                    return Ok(None);
                }
                let definition = match self.world.aliases.get(name) {
                    Some(d) => d,
                    None => return Ok(None),
                };
                let bindings: HashMap<String, Expression> =
                    definition.parameters.iter().cloned().zip(arguments.iter().cloned()).collect();
                Ok(Some(parse(&definition.body, false)?.substituting(&bindings)?))
            }
            Expression::Field(owner, axis) => {
                if self.world.intrinsic_swift && expression.text()=="Swift.Never" { return Ok(Some(Expression::name("Never"))); }
                if self.world.nested_names.contains(&expression.text()) { return Ok(None); }
                if self.world.namespaces.contains(&owner.text()) { return Err(Failure::new(format!("no declaration of nested name '{}'",expression.text()))); }
                let owner_name=owner.text(); let empty=Vec::new();
                let (name, arguments) = match owner.as_ref() {
                    Expression::Application(name, arguments) => (name, arguments),
                    Expression::Field(_, _) if self.world.nested_names.contains(&owner_name) => (&owner_name,&empty),
                    _ => return Ok(None),
                };
                self.check_application(name, arguments.len())?;
                if self.rigid.contains(name) {
                    return Ok(None);
                }
                if !self.world.conformers.contains_key(name) && self.world.presented_bodies.contains(name) {
                    return Err(Failure::new(format!(
                        "cannot read declaration '{}': body outside flat-definition fragment",
                        name
                    )));
                }
                let declaration = match self.world.conformers.get(name) {
                    Some(d) => d,
                    None => return Ok(None),
                };
                let body = match declaration.table.get(axis) {
                    Some(b) => b,
                    None => {
                        return Err(Failure::new(format!(
                            "cannot read projection '{}': no definition of '{}' on '{}'",
                            expression.text(),
                            axis,
                            name
                        )))
                    }
                };
                // Generic parameters and sibling names are bound at this owner,
                // before any global alias with the same spelling can be consulted.
                let mut bindings: HashMap<String, Expression> =
                    declaration.parameters.iter().cloned().zip(arguments.iter().cloned()).collect();
                bindings.insert("Self".to_string(), owner.as_ref().clone());
                for sibling in declaration.table.keys() {
                    if !bindings.contains_key(sibling) {
                        bindings.insert(sibling.clone(), Expression::Field(owner.clone(), sibling.clone()));
                    }
                }
                Ok(Some(parse(body, false)?.substituting(&bindings)?))
            }
        }
    }
}

/// A finite proposed derivation, not a trusted verdict. Its endpoints are
/// reconstructed by replay; the caller cannot append an asserted result.
#[derive(Debug, Clone)]
pub enum Derivation {
    Name(String),
    Arguments(String, Vec<Derivation>),
    Field(Box<Derivation>, String),
    Unfold(Expression, Box<Derivation>),
    Join(Box<Derivation>, Box<Derivation>),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Ends {
    pub input: Expression,
    pub output: Expression,
}

/// Replay follows only the presented proof. It never calls derive.
pub fn replay(derivation: &Derivation, source: &Source, node_limit: usize) -> Result<Ends, Failure> {
    let mut remaining = node_limit;
    fn walk(proof: &Derivation, source: &Source, depth: usize, remaining: &mut usize) -> Result<Ends, Failure> {
        if *remaining == 0 || depth >= 512 {
            return Err(Failure::new("derivation replay limit reached"));
        }
        *remaining -= 1;
        match proof {
            Derivation::Name(name) => {
                let term = parse(name, true)?;
                if term != Expression::name(name) {
                    return Err(Failure::new("not a derivation leaf"));
                }
                source.check_application(name, 0)?;
                Ok(Ends { input: term.clone(), output: term })
            }
            Derivation::Arguments(name, arguments) => {
                if parse(name, true)? != Expression::name(name) {
                    return Err(Failure::new("not a constructor name"));
                }
                source.check_application(name, arguments.len())?;
                let mut inputs = Vec::new();
                let mut outputs = Vec::new();
                for argument in arguments {
                    let ends = walk(argument, source, depth + 1, remaining)?;
                    inputs.push(ends.input);
                    outputs.push(ends.output);
                }
                Ok(Ends {
                    input: Expression::Application(name.clone(), inputs),
                    output: Expression::Application(name.clone(), outputs),
                })
            }
            Derivation::Field(owner, axis) => {
                if parse(axis, false)? != Expression::name(axis) {
                    return Err(Failure::new("not a field name"));
                }
                let ends = walk(owner, source, depth + 1, remaining)?;
                Ok(Ends {
                    input: Expression::Field(Box::new(ends.input), axis.clone()),
                    output: Expression::Field(Box::new(ends.output), axis.clone()),
                })
            }
            Derivation::Unfold(input, continuation) => {
                source.validate(input, 0)?;
                let body = match source.expansion(input)? {
                    Some(body) => body,
                    None => return Err(Failure::new(format!("no source definition to unfold at '{}'", input.text()))),
                };
                let ends = walk(continuation, source, depth + 1, remaining)?;
                if ends.input != body {
                    return Err(Failure::new(format!("unfolded body differs from source at '{}'", input.text())));
                }
                Ok(Ends { input: input.clone(), output: ends.output })
            }
            Derivation::Join(first, second) => {
                let left = walk(first, source, depth + 1, remaining)?;
                let right = walk(second, source, depth + 1, remaining)?;
                if left.output != right.input {
                    return Err(Failure::new("derivations have different shared boundaries"));
                }
                Ok(Ends { input: left.input, output: right.output })
            }
        }
    }
    walk(derivation, source, 0, &mut remaining)
}

fn unchanged(term: &Expression) -> Derivation {
    match term {
        Expression::Application(name, args) => {
            if args.is_empty() {
                Derivation::Name(name.clone())
            } else {
                Derivation::Arguments(name.clone(), args.iter().map(unchanged).collect())
            }
        }
        Expression::Field(owner, axis) => Derivation::Field(Box::new(unchanged(owner)), axis.clone()),
    }
}

pub fn derive(
    expression: &Expression,
    source: &Source,
    depth_limit: usize,
    node_limit: usize,
    head_only: bool,
) -> Result<Derivation, Failure> {
    source.validate(expression, 0)?;
    let mut remaining = node_limit;
    fn build(
        term: &Expression,
        source: &Source,
        depth: usize,
        head_only: bool,
        depth_limit: usize,
        remaining: &mut usize,
    ) -> Result<(Derivation, Expression), Failure> {
        if depth > depth_limit || *remaining == 0 {
            return Err(Failure::new(format!(
                "normalization limit reached at '{}'; no impossibility inferred",
                term.text()
            )));
        }
        *remaining -= 1;
        match term {
            Expression::Application(name, arguments) => {
                if let Some(body) = source.expansion(term)? {
                    let (proof, end) = build(&body, source, depth + 1, head_only, depth_limit, remaining)?;
                    return Ok((Derivation::Unfold(term.clone(), Box::new(proof)), end));
                }
                if arguments.is_empty() {
                    return Ok((Derivation::Name(name.clone()), term.clone()));
                }
                if head_only {
                    return Ok((unchanged(term), term.clone()));
                }
                let mut proofs = Vec::new();
                let mut ends = Vec::new();
                for argument in arguments {
                    let (proof, end) = build(argument, source, depth + 1, false, depth_limit, remaining)?;
                    proofs.push(proof);
                    ends.push(end);
                }
                Ok((Derivation::Arguments(name.clone(), proofs), Expression::Application(name.clone(), ends)))
            }
            Expression::Field(owner, axis) => {
                let (owner_proof, owner_end) = build(owner, source, depth + 1, true, depth_limit, remaining)?;
                let field_proof = Derivation::Field(Box::new(owner_proof), axis.clone());
                let at = Expression::Field(Box::new(owner_end), axis.clone());
                let body = match source.expansion(&at)? {
                    Some(body) => body,
                    None => return Ok((field_proof, at)),
                };
                let (body_proof, end) = build(&body, source, depth + 1, head_only, depth_limit, remaining)?;
                Ok((
                    Derivation::Join(Box::new(field_proof), Box::new(Derivation::Unfold(at, Box::new(body_proof)))),
                    end,
                ))
            }
        }
    }
    Ok(build(expression, source, 0, head_only, depth_limit, &mut remaining)?.0)
}

pub fn normal_form(expression: &Expression, source: &Source) -> Result<Ends, Failure> {
    let proof = derive(expression, source, 64, 10_000, false)?;
    let ends = replay(&proof, source, 20_000)?;
    if ends.input != *expression {
        return Err(Failure::new("normalization changed the question"));
    }
    Ok(ends)
}

/// Unfolds definitions only until the outermost constructor is a name no
/// source definition rewrites. Arguments stay as written.
pub fn head_form(expression: &Expression, source: &Source) -> Result<Ends, Failure> {
    let proof = derive(expression, source, 64, 10_000, true)?;
    let ends = replay(&proof, source, 20_000)?;
    if ends.input != *expression {
        return Err(Failure::new("normalization changed the question"));
    }
    Ok(ends)
}
