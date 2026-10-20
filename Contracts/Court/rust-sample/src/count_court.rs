// A separate court for a declared count question, a port of
// Sources/Court/CountCourt.swift. It checks Left -> Answer on supplied
// PredicateReading applications. The finite Unit/Never/Plus interpretation is
// enabled only after checking the presented primitive definitions. This is a
// restricted source interpreter, not execution of arbitrary Swift getters.

use crate::expression::{self as ex, Expression, Failure, Source};
use crate::structural::{self as st, StructuralSource};
use crate::{Answer, Loader};
use std::collections::{HashMap, HashSet};

pub struct Block {
    pub kind: String,
    pub header: Vec<String>,
    pub body: Vec<String>,
    pub origin: String,
    pub result_builder: bool,
}

impl Block {
    fn name(&self) -> String {
        self.header.first().cloned().unwrap_or_default()
    }
}

/// Read balanced top-level regions; a comment or a string cannot plant a rule.
pub fn blocks(files: &[(String, String)]) -> Result<Vec<Block>, Failure> {
    let mut result = Vec::new();
    for (origin, text) in files {
        let tokens = st::tokens(text)?;
        let mut i = 0usize;
        while i < tokens.len() {
            let kind = tokens[i].clone();
            if ["enum", "struct", "class", "protocol", "extension"].contains(&kind.as_str()) {
                let mut before = i as i64 - 1;
                while before >= 0
                    && ["\n", "public", "internal", "private", "fileprivate", "package"].contains(&tokens[before as usize].as_str())
                {
                    before -= 1;
                }
                let result_builder =
                    before >= 1 && tokens[before as usize] == "resultBuilder" && tokens[before as usize - 1] == "@";
                i += 1;
                let start = i;
                while i < tokens.len() && tokens[i] != "{" {
                    i += 1;
                }
                let header = st::plain(&tokens[start..i]);
                let body = st::balanced(&tokens, &mut i, "{", "}")?;
                result.push(Block { kind, header, body, origin: origin.clone(), result_builder });
            } else if kind == "#" {
                // Choosing a conditional primitive definition would change the
                // reader. This court does not select compilation flags.
                if i + 1 < tokens.len() && tokens[i + 1] == "if" {
                    return Err(Failure::new(format!("conditional compilation is outside the count fragment in {}", origin)));
                }
                i += 1;
            } else if kind == "{" {
                st::balanced(&tokens, &mut i, "{", "}")?;
            } else {
                i += 1;
            }
        }
    }
    Ok(result)
}

pub fn shape(text: &str) -> Result<Vec<String>, Failure> {
    let modifiers = ["public", "internal", "private", "fileprivate", "package"];
    Ok(st::plain(&st::tokens(text)?).into_iter().filter(|t| !modifiers.contains(&t.as_str())).collect())
}

pub fn count_getters(block: &Block) -> Result<Vec<Vec<String>>, Failure> {
    let ts = st::plain(&block.body);
    let mut result: Vec<Vec<String>> = Vec::new();
    let mut i = 0usize;
    while i < ts.len() {
        if ["var", "let", "func"].contains(&ts[i].as_str()) && i + 1 < ts.len() && ts[i + 1] == "count" {
            let well_formed = ts[i] == "var"
                && i > 0
                && ts[i - 1] == "static"
                && i + 4 < ts.len()
                && ts[i + 2] == ":"
                && ts[i + 3] == "Int"
                && ts[i + 4] == "{";
            if !well_formed {
                return Err(Failure::new(format!("unsupported count member on {} in {}", block.name(), block.origin)));
            }
            i += 4;
            let body = st::balanced(&ts, &mut i, "{", "}")?;
            result.push(st::plain(&body));
        } else if ts[i] == "{" {
            st::balanced(&ts, &mut i, "{", "}")?;
        } else {
            i += 1;
        }
    }
    Ok(result)
}

/// These checks bind the small interpreter to the actual supplied engine.
/// Other getters, result builders, overrides and modules are not inferred.
pub fn check_primitive_rules(files: &[(String, String)], source: &StructuralSource) -> Result<(), Failure> {
    let read = blocks(files)?;
    let protected: [&str; 10] =
        ["Structure", "Open", "Close", "Pair", "Null", "Never", "Unit", "Plus", "Paired", "StructureBuilder"];
    for name in protected {
        if source.conditional_subjects.contains(name) {
            return Err(Failure::new(format!("conditional definition of count primitive '{}'", name)));
        }
    }
    let declaration = |name: &str, kind: &str, header: &str, body: Option<&str>| -> Result<(), Failure> {
        let found: Vec<&Block> = read.iter().filter(|b| b.name() == name && b.kind != "extension").collect();
        let expected_header = st::plain(&st::tokens(header)?);
        if found.len() != 1 || found[0].kind != kind || found[0].header != expected_header {
            return Err(Failure::new(format!("missing or changed count primitive declaration '{}'", name)));
        }
        if name == "StructureBuilder" && !found[0].result_builder {
            return Err(Failure::new(format!("StructureBuilder is not declared @resultBuilder in {}", found[0].origin)));
        }
        if let Some(body) = body {
            if shape(&st::text(&found[0].body))? != shape(body)? {
                return Err(Failure::new(format!("changed count primitive body '{}' in {}", name, found[0].origin)));
            }
        }
        Ok(())
    };
    declaration("Unit", "enum", "Unit: Close", Some(""))?;
    declaration(
        "Plus",
        "enum",
        "Plus<A: Structure, B: Structure>: Open",
        Some("@StructureBuilder public static var body: some Structure { A.self B.self }"),
    )?;
    declaration(
        "Paired",
        "enum",
        "Paired<L: Structure, R: Structure>: Pair",
        Some("case paired(L, R)\npublic typealias Left = L\npublic typealias Right = R"),
    )?;
    declaration(
        "StructureBuilder",
        "enum",
        "StructureBuilder",
        Some(
            "public static func buildExpression<T: Structure>(_ type: T.Type) -> T { fatalError() }\n\
             public static func buildExpression(_ string: String) -> String { string }\n\
             @_disfavoredOverload public static func buildExpression<V: Structure>(_ value: V) -> V { value }\n\
             public static func buildPartialBlock<V: Structure>(first: V) -> V { first }\n\
             public static func buildPartialBlock<A: Structure, B: Structure>(accumulated: A, next: B) -> Paired<A, B> { .paired(accumulated, next) }\n\
             public static func buildBlock() -> Never { fatalError() }\n\
             public static func buildEither<A: Structure, B: Structure>(first: A) -> Paired<A, B> { fatalError() }\n\
             public static func buildEither<A: Structure, B: Structure>(second: B) -> Paired<A, B> { fatalError() }",
        ),
    )?;
    declaration("Close", "protocol", "Close: Structure", Some(""))?;
    // These parent/Body relations determine the count dispatch used above.
    let structure_is_protocol = source.declarations.get("Structure").map(|d| d.kind == "protocol").unwrap_or(false);
    let open_parents = source.declarations.get("Open").map(|d| d.parents == vec!["Structure".to_string()]).unwrap_or(false);
    let open_body = source
        .declarations
        .get("Open")
        .map(|d| d.axes.iter().any(|a| a.name == "Body" && a.fallback.as_deref() == Some("Never")))
        .unwrap_or(false);
    let pair_parents = source.declarations.get("Pair").map(|d| d.parents == vec!["Open".to_string()]).unwrap_or(false);
    let null_parents = source.declarations.get("Null").map(|d| d.parents == vec!["Pair".to_string()]).unwrap_or(false);
    let never_choices = source.conformance_choices("Never");
    let never_null = never_choices.iter().any(|(p, r)| p == "Null" && r.is_empty());
    let never_close = never_choices.iter().any(|(p, r)| p == "Close" && r.is_empty());
    if !(structure_is_protocol && open_parents && open_body && pair_parents && null_parents && never_null && never_close) {
        return Err(Failure::new("missing count-dispatch foundation (Structure/Open/Pair/Null/Never)"));
    }

    let mut rules: HashMap<String, Vec<Vec<String>>> = HashMap::new();
    for block in &read {
        let name = block.name();
        if !protected.contains(&name.as_str()) {
            continue;
        }
        // Even an empty added conformance can introduce a more specific getter
        // through its protocol. Do not infer that it is harmless.
        if block.kind == "extension" && ["Unit", "Plus", "StructureBuilder"].contains(&name.as_str()) {
            return Err(Failure::new(format!("extension changes the count primitive '{}' in {}", name, block.origin)));
        }
        for getter in count_getters(block)? {
            let key = format!("{} {}", block.kind, block.header.join(" "));
            rules.entry(key).or_default().push(getter);
        }
    }
    let strings = |items: &[&str]| -> Vec<String> { items.iter().map(|s| s.to_string()).collect() };
    let expected: HashMap<String, Vec<Vec<String>>> = HashMap::from([
        ("protocol Structure".to_string(), vec![strings(&["get"])]),
        ("extension Structure".to_string(), vec![strings(&["1"])]),
        ("extension Open where Body == Never".to_string(), vec![strings(&["1"])]),
        ("extension Open".to_string(), vec![strings(&["Body", ".", "count"])]),
        ("extension Paired".to_string(), vec![strings(&["L", ".", "count", "+", "R", ".", "count"])]),
        ("extension Never : Null".to_string(), vec![strings(&["0"])]),
    ]);
    if rules != expected {
        return Err(Failure::new(
            "changed, missing or duplicated primitive count getters; expected the supplied 0/1/Body/Paired rules",
        ));
    }
    Ok(())
}

use crate::shared_count::Reader;

/// Metatype applications are discovered from tokens, not comment/string text.
pub fn metatypes(text: &str) -> Result<Vec<(Expression, bool)>, Failure> {
    let ts = st::plain(&st::tokens(text)?);
    let mut roots: Vec<(Expression, bool)> = Vec::new();
    let mut braces = 0i64;
    for i in 0..ts.len() {
        if ts[i] == "{" {
            braces += 1;
        }
        if ts[i] == "}" {
            braces -= 1;
        }
        if !(ts[i] == "." && i + 1 < ts.len() && ts[i + 1] == "self") {
            continue;
        }
        let mut start = i;
        let mut depth = 0i64;
        while start > 0 {
            let t = ts[start - 1].as_str();
            if t == ">" {
                depth += 1;
            }
            if t == "<" {
                depth -= 1;
            }
            if depth < 0 {
                break;
            }
            if depth == 0 && !st::identifier(t) && !["<", ">", "."].contains(&t) {
                break;
            }
            start -= 1;
        }
        if start < i {
            if let Ok(root) = ex::parse(&st::text(&ts[start..i]), false) {
                roots.push((root, braces > 0));
            }
        }
    }
    Ok(roots)
}

struct Job {
    anchor: String,
    site: String,
    input: Expression,
    nested: bool,
}

fn judge_with(load: Loader, arguments: &[String]) -> Result<(usize, usize, Vec<String>, Expression, Expression, Expression), Failure> {
    let mut paths: Vec<String> = Vec::new();
    let mut options: HashMap<String, String> = HashMap::new();
    let mut i = 0usize;
    while i < arguments.len() {
        let word = &arguments[i];
        if word.starts_with("--") {
            let accepted = ["--predicate", "--encoding", "--sigma"].contains(&word.as_str())
                && !options.contains_key(word)
                && i + 1 < arguments.len()
                && !arguments[i + 1].starts_with("--");
            if !accepted {
                return Err(Failure::new(format!("unsupported, duplicate or incomplete count option '{}'", word)));
            }
            options.insert(word.clone(), arguments[i + 1].clone());
            i += 2;
        } else {
            paths.push(word.clone());
            i += 1;
        }
    }
    if paths.is_empty() || options.len() != 3 {
        return Err(Failure::new(
            "usage: judge count <world.swift> [definitions.swift ...] --predicate <P> --encoding <E> --sigma <S>",
        ));
    }
    let mut files: Vec<(String, String)> = Vec::new();
    for path in &paths {
        let text = load(path).map_err(|e| Failure::new(format!("cannot read {}: {}", path, e)))?;
        files.push((path.clone(), text));
    }
    let source = StructuralSource::new(&files)?;
    check_primitive_rules(&files, &source)?;
    let no_rigid: HashSet<String> = HashSet::new();
    let mut reader = Reader::new(Source { world: &source.syntax, rigid: &no_rigid });
    let predicate = reader.normal(&ex::parse(&options["--predicate"], false)?)?;
    let encoding = reader.normal(&ex::parse(&options["--encoding"], false)?)?;
    let sigma = reader.normal(&ex::parse(&options["--sigma"], false)?)?;
    // All presented files are checked: moving a counterexample into the
    // definitions position cannot hide its selected readings.
    let mut queue: Vec<Job> = Vec::new();
    for (path, text) in &files {
        for (input, nested) in metatypes(text)? {
            queue.push(Job { anchor: format!("{}:{}", path, input.text()), site: input.text(), input, nested });
        }
    }
    let mut declared: Vec<&st::Declaration> = source.declarations.values().filter(|d| d.parameters.is_empty()).collect();
    declared.sort_by(|a, b| a.name.cmp(&b.name));
    for d in declared {
        queue.push(Job { anchor: d.name.clone(), site: d.name.clone(), input: Expression::name(&d.name), nested: false });
    }
    let mut seen: HashMap<String, HashSet<Expression>> = HashMap::new();
    let mut discovered = 0usize;
    let mut checked = 0usize;
    let mut refusals: Vec<String> = Vec::new();
    while let Some(job) = queue.pop() {
        if discovered >= 20_000 {
            return Err(Failure::new("count application discovery exceeds its budget"));
        }
        let mut reader = Reader::new(Source { world: &source.syntax, rigid: &no_rigid });
        let root = reader.normal_head(&job.input)?;
        if !seen.entry(job.anchor.clone()).or_default().insert(root.clone()) {
            continue;
        }
        discovered += 1;
        let (name, args) = match &root {
            Expression::Application(name, args) => (name, args),
            Expression::Field(_, _) => continue,
        };
        let declaration = match source.declarations.get(name) {
            Some(d) if d.kind != "protocol" => d,
            _ => continue,
        };
        if declaration.parameters.len() != args.len() {
            return Err(Failure::new(format!("unbound reading application '{}'", root.text())));
        }
        let choices: Vec<String> = source.conformance_choices(name).into_iter().map(|c| c.0).collect();
        let parents = source.protocol_closure(&choices);
        if !parents.contains("PredicateReading") {
            // Certificate fields can carry applied generic readings.
            if let Some(conformer) = source.syntax.conformers.get(name) {
                let mut axes: Vec<&String> = conformer.table.keys().collect();
                axes.sort();
                for axis in axes {
                    queue.push(Job {
                        anchor: job.anchor.clone(),
                        site: format!("{}.{}", job.site, axis),
                        input: Expression::Field(Box::new(root.clone()), axis.clone()),
                        nested: job.nested,
                    });
                }
            }
            continue;
        }
        if job.nested {
            return Err(Failure::new(format!(
                "nested reading application '{}' is outside this court's binding scope; present a closed typealias",
                job.site
            )));
        }
        let field = |axis: &str| Expression::Field(Box::new(root.clone()), axis.to_string());
        let actual_predicate = reader.normal(&field("Predicate"))?;
        if actual_predicate != predicate {
            continue;
        }
        checked += 1;
        if reader.normal(&field("Encoding"))? != encoding || reader.normal(&field("Sigma"))? != sigma {
            return Err(Failure::new(format!("'{}' changes the selected count signature", job.site)));
        }
        match reader.reading(&root) {
            Ok((equal, actual, declared)) => {
                if !equal { refusals.push(format!("'{}' requires Right == Answer [PredicateReading]", job.site)); }
                if actual != declared {
                    refusals.push(format!(
                        "'{}' count Left = {}, but Answer = {} [{}]",
                        job.site,
                        actual,
                        declared,
                        predicate.text()
                    ));
                }
            }
            Err(error) => {
                return Err(Failure::new(format!("'{}' count reading unresolved: {}", job.site, error)));
            }
        }
    }
    if checked == 0 {
        return Err(Failure::new("no closed PredicateReading for the selected count signature was checked"));
    }
    Ok((checked, files.len(), refusals, sigma, encoding, predicate))
}

pub fn answer(load: Loader, arguments: &[String]) -> Answer {
    let mut out = Answer::default();
    match judge_with(load, arguments) {
        Ok((checked, presented, refusals, sigma, encoding, predicate)) => {
            if !refusals.is_empty() {
                for refusal in refusals {
                    out.stdout.push_str(&format!("✗ COUNT: {}\n", refusal));
                }
                out.exit = 1;
                return out;
            }
            out.stdout.push_str(&format!(
                "✓ COUNT holds: {} source-bound readings checked; finite Unit/Never/Plus rules and definition/count \
                 derivations replayed.\n",
                checked
            ));
            out.stdout.push_str(&format!(
                "Scope: {} / {} / {}; all {} presented files; closed aliases/top-level metatypes; Int range and reader \
                 budgets; nominal equality and Swift conformance are separate checks.\n",
                sigma.text(),
                encoding.text(),
                predicate.text(),
                presented
            ));
            out.exit = 0;
        }
        Err(error) => {
            out.stderr.push_str(&format!("✗ COUNT unresolved: {}\n", error));
            out.exit = 2;
        }
    }
    out
}
