// WHERE JUDGE — a port of Sources/Court/WhereJudge.swift. A world file states
// enums with typealias tables, top-level and generic typealiases, extensions
// gated by `where` equalities, and protocols gated the same way. A parameterless
// typealias whose right side names a gated head is a certificate, judged like a
// use, and extra definition files lend their typealiases. Each use of a gated
// head and each conformer of a gated protocol is judged by normalizing its
// terms against the supplied definitions; distinct normal forms mean this court
// has not established the equality, not a proof of general inequality.

use crate::expression::{self as ex, AliasRule, Conformer, Expression, GatedExtension, GatedProtocol, Source, Span, World};
use crate::failure::{fail, fail_all, Failure};
use crate::{Answer, Loader};
use crate::lexical::*;
use regex::Regex;
use std::collections::{HashMap, HashSet};

/// Identifies the normalization rules, not evidence that a separate port
/// implements them. Version four replays source-defined reduction derivations.
pub const CANON_VERSION: u32 = 4;

fn in_span(at: usize, span: &Span) -> bool {
    at >= span.0 && at < span.1
}

fn trim_spaces(text: &str) -> &str {
    text.trim_matches(|c| c == ' ' || c == '\t')
}

// ── reading the world ──

pub fn read(text: &str, lent: &HashSet<String>) -> Result<World, Failure> {
    let clean = strip_comments(text, lent)?;
    let scope = Scope::new(&clean);
    let mut world = World::default();

    world.names = captures(r"\b(\w+)\b", &clean).into_iter().map(|c| c[0].clone()).collect();
    let (lines, file_names) = declared_names(&clean, &scope)?;
    world.declared = lines.clone();
    let mut repeated: Vec<&String> = file_names.iter().filter(|n| lines[*n].len() > 1).collect();
    repeated.sort_by_key(|n| (lines[*n][0], (*n).clone()));
    if let Some(name) = repeated.first() {
        return fail(format!(
            "cannot read '{}': it is declared at {}, and this court has no scope rule to choose between them",
            name,
            spelled_lines(&lines[*name])
        ));
    }

    // A presented declaration can have a body this flat reader cannot read.
    for hit in declarations(r"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\s*\{", &clean, &scope)? {
        world.presented_bodies.insert(hit[0].clone());
    }
    for hit in declarations(r"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\bwhere\s+[^{}]+\{", &clean, &scope)? {
        world.conditional_declarations.insert(hit[0].clone());
    }
    for hit in declarations(r"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*([\w,\s]+?)\s*\{([^{}]*)\}", &clean, &scope)? {
        let name = hit[0].clone();
        let parameters = parameter_names(&hit[1]);
        let protocols: Vec<String> = hit[2]
            .split(',')
            .map(trim_spaces)
            .filter(|p| !p.is_empty())
            .map(|p| p.to_string())
            .collect();
        let mut table: HashMap<String, String> = HashMap::new();
        for alias in read_alias_spans(&hit[3])? {
            if !alias.fields[1].is_empty() {
                continue;
            }
            if table.contains_key(&alias.fields[0]) {
                return fail(format!("duplicate definition of '{}.{}'", name, alias.fields[0]));
            }
            table.insert(alias.fields[0].clone(), alias.fields[2].clone());
        }
        world.conformers.insert(name.clone(), Conformer { name, parameters, protocols, table });
    }
    for hit in declarations(r"enum\s+(\w+)\s*<([^>]*)>", &clean, &scope)? {
        world.parameters.insert(hit[0].clone(), parameter_names(&hit[1]));
    }

    // An unconditional extension of a presented conformer adds the protocols
    // its header lists, whatever its body holds.
    for hit in declarations(r"extension\s+(\w+)\s*:\s*([\w,\s]+?)\s*\{", &clean, &scope)? {
        let listed: Vec<String> =
            hit[1].split(',').map(|p| p.trim()).filter(|p| !p.is_empty()).map(|p| p.to_string()).collect();
        if let Some(conformer) = world.conformers.get_mut(&hit[0]) {
            conformer.protocols.extend(listed);
        }
    }
    // An extension body inside the flat fragment lends its parameterless
    // aliases to a presented conformer.
    for hit in declarations(r"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}", &clean, &scope)? {
        if world.conformers.contains_key(&hit[0]) {
            for alias in read_alias_spans(&hit[1])? {
                if !alias.fields[1].is_empty() {
                    continue;
                }
                let conformer = world.conformers.get_mut(&hit[0]).unwrap();
                if conformer.table.contains_key(&alias.fields[0]) {
                    return fail(format!("duplicate definition of '{}.{}'", hit[0], alias.fields[0]));
                }
                conformer.table.insert(alias.fields[0].clone(), alias.fields[2].clone());
            }
        }
    }

    let file_type = re(r"\b(?:enum|struct|class|actor|protocol|typealias)\s+(\w+)");
    for m in file_type.captures_iter(&clean) {
        let whole = m.get(0).unwrap();
        if scope.depth[whole.start()] == 0 {
            world.file_types.insert(m.get(1).unwrap().as_str().to_string());
        }
    }
    // An extension's owner is read in full; one named through a qualifier is
    // a type this court does not resolve.
    let extended = re(r"\bextension\b");
    let units = clean.as_bytes();
    for m in extended.find_iter(&clean) {
        if m.start() > 0 && units[m.start() - 1] == b'.' {
            continue;
        }
        let line = scope.line[m.start()];
        let mut cursor = m.end();
        while cursor < units.len() && is_space_byte(units[cursor]) {
            cursor += 1;
        }
        let name_start = cursor;
        while cursor < units.len() && is_word_byte(units[cursor]) {
            cursor += 1;
        }
        if cursor == name_start {
            return fail(format!(
                "cannot read line {}: the type this extension extends is not one this court reads",
                line
            ));
        }
        let mut parts = vec![clean[name_start..cursor].to_string()];
        loop {
            while cursor < units.len() && is_space_byte(units[cursor]) {
                cursor += 1;
            }
            if cursor >= units.len() || units[cursor] != b'.' {
                break;
            }
            cursor += 1;
            while cursor < units.len() && is_space_byte(units[cursor]) {
                cursor += 1;
            }
            let part_start = cursor;
            while cursor < units.len() && is_word_byte(units[cursor]) {
                cursor += 1;
            }
            if cursor == part_start {
                return fail(format!(
                    "cannot read line {}: the type this extension extends is not one this court reads",
                    line
                ));
            }
            parts.push(clean[part_start..cursor].to_string());
        }
        let spelled = parts.join(".");
        if parts.len() > 1 {
            return fail(format!(
                "cannot read line {}: the extension of '{}' names its type through a qualifier, which this court \
                 does not resolve",
                line, spelled
            ));
        }
        let tail_start = cursor;
        let mut tail_end = cursor;
        while tail_end < units.len() && is_word_byte(units[tail_end]) {
            tail_end += 1;
        }
        let tail = &clean[tail_start..tail_end];
        if !(cursor < units.len() && (units[cursor] == b':' || units[cursor] == b'{' || tail == "where")) {
            return fail(format!(
                "cannot read line {}: the type this extension extends is not one this court reads",
                line
            ));
        }
        world.extensions.entry(spelled).or_default().push(line);
    }

    let outside = outside_bodies(&clean)?;
    for alias in read_alias_spans(&outside)? {
        if world.aliases.contains_key(&alias.fields[0]) {
            return fail(format!("duplicate definition of typealias '{}'", alias.fields[0]));
        }
        if !alias.fields[3].is_empty() {
            world.conditional_declarations.insert(alias.fields[0].clone());
        }
        world.aliases.insert(
            alias.fields[0].clone(),
            AliasRule { parameters: parameter_names(&alias.fields[1]), body: alias.fields[2].clone() },
        );
    }

    // An extension of a typealias extends the type the alias names.
    let mut through_alias: Vec<(&String, &Vec<usize>)> =
        world.extensions.iter().filter(|(k, _)| world.aliases.contains_key(*k)).collect();
    through_alias.sort_by_key(|(k, _)| (*k).clone());
    if let Some((name, lines)) = through_alias.first() {
        return fail(format!(
            "cannot read '{}': it is a typealias, extended at {}, and this court does not follow an extension \
             through an alias to its type",
            name,
            spelled_lines(lines)
        ));
    }

    // A where clause this reader cannot read as a gate is refused by name.
    let one_protocol = re(r"^\w+\s+$");
    for hit in declarations(r"extension\s+(\w+)\s*:\s*([^{}]*?)\bwhere\b", &clean, &scope)? {
        if one_protocol.is_match(&hit[1]) {
            continue;
        }
        let listed = hit[1].split_whitespace().collect::<Vec<_>>().join(" ");
        return fail(format!(
            "cannot read conditional conformance '{}: {}': this court reads one protocol per conditional extension",
            hit[0], listed
        ));
    }
    let plain_list = re(r"^\s*:\s*[\w,\s]+?\s+$");
    for hit in declarations(r"protocol\s+(\w+)\b([^{}]*?)\bwhere\b", &clean, &scope)? {
        if plain_list.is_match(&hit[1]) {
            continue;
        }
        return fail(format!(
            "cannot read conditional protocol '{}': this court reads a where clause after an inheritance list of \
             plain names",
            hit[0]
        ));
    }

    for hit in declarations(r"extension\s+(\w+)\s*:\s*(\w+)\s+where\s+([^{]+)\{", &clean, &scope)? {
        let (equalities, memberships, unjudged) = split_conjuncts(&hit[2])?;
        world.gates.push(GatedExtension { head: hit[0].clone(), proto: hit[1].clone(), equalities, memberships, unjudged });
    }
    for hit in declarations(r"protocol\s+(\w+)\s*:\s*[\w,\s]+?\s+where\s+([^{]+)\{", &clean, &scope)? {
        let (equalities, memberships, unjudged) = split_conjuncts(&hit[1])?;
        world
            .gated_protocols
            .insert(hit[0].clone(), GatedProtocol { name: hit[0].clone(), equalities, memberships, unjudged });
    }

    // the refinement ladder, read from what is presented
    for hit in declarations(r"protocol\s+(\w+)\s*:\s*([\w,\s]+?)\s*(?:\s+where|\{)", &clean, &scope)? {
        let parents: Vec<String> =
            hit[1].split(',').map(trim_spaces).filter(|p| !p.is_empty()).map(|p| p.to_string()).collect();
        world.protocol_parents.insert(hit[0].clone(), parents);
    }
    for hit in declarations(r"protocol\s+(\w+)\s*\{", &clean, &scope)? {
        world.protocol_parents.entry(hit[0].clone()).or_default();
    }
    for hit in declarations(r"protocol\s+(\w+)[^{}]*\{([^{}]*)\}", &clean, &scope)? {
        let axes: HashSet<String> =
            captures(r"associatedtype\s+(\w+)", &hit[1]).into_iter().map(|c| c[0].clone()).collect();
        world.protocol_axes.insert(hit[0].clone(), axes);
    }

    // A use is an application written as a metatype: the chain of names, dots
    // and balanced generic arguments that stands before `.self` on its line.
    let bodies = type_bodies(&clean)?;
    let mut read_spans: Vec<Span> = Vec::new();
    let metatype = re(r"\.self\b");
    let use_shape = re(r"^[\w.<>, ]+$");
    for m in metatype.find_iter(&clean) {
        let mut index = m.start() as i64 - 1;
        while index >= 0 && is_space_byte(units[index as usize]) {
            index -= 1;
        }
        let end = (index + 1) as usize;
        let mut chained = true;
        while index >= 0 {
            let i = index as usize;
            if units[i] == b'>' && (i == 0 || units[i - 1] != b'-') {
                let mut depth = 0i64;
                let mut open = index;
                while open >= 0 {
                    let o = open as usize;
                    let unit = units[o];
                    if unit == b'>' && (o == 0 || units[o - 1] != b'-') {
                        depth += 1;
                    }
                    if unit == b'<' {
                        depth -= 1;
                    }
                    if depth == 0 || unit == b'{' || unit == b'}' || unit == b';' {
                        break;
                    }
                    open -= 1;
                }
                let ok = open > 0 && units[open as usize] == b'<' && depth == 0 && is_word_byte(units[open as usize - 1]);
                if !ok {
                    chained = false;
                    break;
                }
                index = open - 1;
            }
            if index < 0 || !is_word_byte(units[index as usize]) {
                break;
            }
            while index >= 0 && is_word_byte(units[index as usize]) {
                index -= 1;
            }
            if index < 0 || units[index as usize] != b'.' {
                break;
            }
            index -= 1;
        }
        let start = (index + 1) as usize;
        if !chained || start >= end {
            continue;
        }
        let spelled = &clean[start..end];
        if !spelled.contains('<') || spelled.contains("->") || !use_shape.is_match(spelled) {
            continue;
        }
        if bodies[start] > 0 {
            return fail(format!(
                "cannot read line {}: the use '{}' sits in the body of a type or an extension, whose members this \
                 court does not read",
                scope.line[start], spelled
            ));
        }
        world.uses.push(spelled.to_string());
        world.use_lines.push(scope.line[start]);
        read_spans.push((start, end));
        world.root_application_spans.push((start, end));
    }

    // What this court reads of a gated head's applications: the uses above,
    // the right sides of the typealiases at file scope and in a presented
    // conformer's table, and the gates' where clauses.
    for span in read_alias_spans(&outside)? {
        world.certificate_lines.insert(span.fields[0].clone(), scope.line[span.declaration.0]);
        world.alias_spans.push(span.body);
        if span.fields[1].is_empty() {
            world.root_application_spans.push(span.body);
        }
    }
    read_spans.extend(world.alias_spans.iter().cloned());
    for spans in declaration_spans(r"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*([\w,\s]+?)\s*\{([^{}]*)\}", &clean, &scope)? {
        let (owner, table) = match (spans[0], spans[3]) {
            (Some(owner), Some(table)) => (owner, table),
            _ => continue,
        };
        let owner_name = &clean[owner.0..owner.1];
        for span in read_alias_spans(&clean[table.0..table.1])? {
            if !span.fields[1].is_empty() {
                continue;
            }
            world.certificate_lines.insert(
                format!("{}.{}", owner_name, span.fields[0]),
                scope.line[table.0 + span.declaration.0],
            );
            read_spans.push((table.0 + span.body.0, table.0 + span.body.1));
            world.root_application_spans.push((table.0 + span.body.0, table.0 + span.body.1));
        }
    }
    for spans in declaration_spans(r"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}", &clean, &scope)? {
        let (owner, body) = match (spans[0], spans[1]) {
            (Some(owner), Some(body)) => (owner, body),
            _ => continue,
        };
        let owner_name = &clean[owner.0..owner.1];
        if !world.conformers.contains_key(owner_name) {
            continue;
        }
        for span in read_alias_spans(&clean[body.0..body.1])? {
            if !span.fields[1].is_empty() {
                continue;
            }
            world.certificate_lines.insert(
                format!("{}.{}", owner_name, span.fields[0]),
                scope.line[body.0 + span.declaration.0],
            );
            read_spans.push((body.0 + span.body.0, body.0 + span.body.1));
            world.root_application_spans.push((body.0 + span.body.0, body.0 + span.body.1));
        }
    }
    for spans in declaration_spans(r"extension\s+(\w+)\s*:\s*(\w+)\s+where\s+([^{]+)\{", &clean, &scope)? {
        if let Some(clause) = spans[2] {
            read_spans.push(clause);
        }
    }
    for spans in declaration_spans(r"protocol\s+(\w+)\s*:\s*[\w,\s]+?\s+where\s+([^{]+)\{", &clean, &scope)? {
        if let Some(clause) = spans[1] {
            read_spans.push(clause);
        }
    }
    world.read_spans = read_spans;
    world.line_at = scope.line;
    world.clean = clean;
    Ok(world)
}

// ── source-relative reduction, with replayed derivations ──

pub fn parse_term(text: &str) -> Result<Expression, Failure> {
    ex::parse(text, false).or_else(|e| fail(format!("cannot read term: {}", e)))
}

pub fn substitute(term: &Expression, bindings: &HashMap<String, Expression>) -> Result<Expression, Failure> {
    term.substituting(bindings).or_else(|e| fail(format!("cannot substitute term: {}", e)))
}

pub fn normalize(term: &Expression, world: &World, rigid: &HashSet<String>) -> Result<Expression, Failure> {
    let source = Source { world, rigid };
    ex::normal_form(term, &source)
        .map(|ends| ends.output)
        .or_else(|e| fail(format!("unresolved definition reduction: {}", e)))
}

/// A claim meets the gate its definition names: a head spelled through an
/// alias or a member alias is unfolded before the gate is looked up.
pub fn gated_form(term: &Expression, world: &World, rigid: &HashSet<String>) -> Result<Expression, Failure> {
    let through_definition = world.aliases.contains_key(&term.head()) || matches!(term, Expression::Field(_, _));
    if world.gates.is_empty() || !through_definition {
        return Ok(term.clone());
    }
    let source = Source { world, rigid };
    ex::head_form(term, &source)
        .map(|ends| ends.output)
        .or_else(|e| fail(format!("unresolved definition reduction: {}", e)))
}

pub fn inherited_protocols(protocols: &[String], world: &World) -> HashSet<String> {
    let mut seen = HashSet::new();
    let mut pile: Vec<String> = protocols.to_vec();
    while let Some(name) = pile.pop() {
        if seen.insert(name.clone()) {
            if let Some(parents) = world.protocol_parents.get(&name) {
                pile.extend(parents.iter().cloned());
            }
        }
    }
    seen
}

pub fn wears(conformer: &Conformer, proto: &str, world: &World) -> bool {
    inherited_protocols(&conformer.protocols, world).contains(proto)
}

pub fn conformer_context(
    conformer: &Conformer,
    world: &World,
) -> Result<(HashMap<String, Expression>, HashSet<String>), Failure> {
    let distinct: HashSet<&String> = conformer.parameters.iter().collect();
    if distinct.len() != conformer.parameters.len() {
        return fail(format!("cannot bind conformer '{}': duplicate generic parameters", conformer.name));
    }
    // Alpha-rename bound parameters outside the source identifier grammar.
    let variables: Vec<Expression> = (0..conformer.parameters.len())
        .map(|i| Expression::name(&format!("$free_{}_{}", conformer.name, i)))
        .collect();
    let owner = Expression::Application(conformer.name.clone(), variables.clone());
    let rigid: HashSet<String> = variables.iter().map(|v| v.head()).collect();
    let mut bindings: HashMap<String, Expression> =
        conformer.parameters.iter().cloned().zip(variables.into_iter()).collect();
    bindings.insert("Self".to_string(), owner.clone());
    let mut axes: HashSet<String> = conformer.table.keys().cloned().collect();
    for proto in inherited_protocols(&conformer.protocols, world) {
        if let Some(more) = world.protocol_axes.get(&proto) {
            axes.extend(more.iter().cloned());
        }
    }
    for axis in axes {
        if !conformer.parameters.contains(&axis) {
            bindings.insert(axis.clone(), Expression::Field(Box::new(owner.clone()), axis));
        }
    }
    Ok((bindings, rigid))
}

/// A question's formal parameters must be bound by this actual application.
pub fn gate_bindings(term: &Expression, world: &World) -> Result<HashMap<String, Expression>, Failure> {
    let head = term.head();
    let parameters = match world.parameters.get(&head).or_else(|| world.conformers.get(&head).map(|c| &c.parameters)) {
        Some(p) => p.clone(),
        None => return fail(format!("cannot bind gate '{}': no declaration parameters were read", head)),
    };
    let args = term.args();
    let distinct: HashSet<&String> = parameters.iter().collect();
    if parameters.len() != args.len() || distinct.len() != parameters.len() {
        return fail(format!(
            "cannot bind gate '{}': expected {} distinct arguments, received {}",
            head,
            parameters.len(),
            args.len()
        ));
    }
    let mut bindings: HashMap<String, Expression> = parameters.into_iter().zip(args.into_iter()).collect();
    bindings.insert("Self".to_string(), term.clone());
    if let Some(owner) = world.conformers.get(&head) {
        let mut axes: HashSet<String> = owner.table.keys().cloned().collect();
        for proto in inherited_protocols(&owner.protocols, world) {
            if let Some(more) = world.protocol_axes.get(&proto) {
                axes.extend(more.iter().cloned());
            }
        }
        for axis in axes {
            if !bindings.contains_key(&axis) {
                bindings.insert(axis.clone(), Expression::Field(Box::new(term.clone()), axis));
            }
        }
    }
    Ok(bindings)
}

fn require_protocol_grounds(protocols: &[String], world: &World) -> Result<(), Failure> {
    let mut names: Vec<String> = inherited_protocols(protocols, world).into_iter().collect();
    names.sort();
    for name in names {
        if !world.protocol_parents.contains_key(&name) && !world.gated_protocols.contains_key(&name) {
            return Err(Failure::Open(vec![format!("no declared protocol grounds for '{}'", name)]));
        }
    }
    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn judge_memberships(
    memberships: &[(String, String)],
    site: &str,
    tag: Option<&str>,
    bindings: &HashMap<String, Expression>,
    world: &World,
    counted: &mut usize,
    refusals: &mut Vec<String>,
    rigid: &HashSet<String>,
    require_grounds: bool,
) -> Result<(), Failure> {
    let mark = tag.map(|t| format!(" [{}]", t)).unwrap_or_default();
    for (lhs, proto) in memberships {
        if require_grounds {
            require_protocol_grounds(std::slice::from_ref(proto), world)?;
        }
        *counted += 1;
        let lhs_term = substitute(&parse_term(lhs)?, bindings)?;
        let resolved = normalize(&lhs_term, world, rigid)?;
        let spelled = resolved.text();
        let head = resolved.head();
        if !world.conformers.contains_key(&head) && world.presented_bodies.contains(&head) {
            return fail(format!(
                "cannot read declaration '{}': its body is outside this court's flat-definition fragment",
                head
            ));
        }
        if !resolved.args().is_empty() {
            return fail(format!(
                "cannot judge membership of '{}' in '{}' required by '{}': generic applicability is not established \
                 by this membership reader",
                spelled, proto, site
            ));
        }
        let wearer = match world.conformers.get(&head) {
            Some(w) => w,
            None => {
                if require_grounds {
                    return Err(Failure::Open(vec![format!(
                        "no declared conformance grounds for '{}' required by '{}'",
                        spelled, site
                    )]));
                }
                refusals.push(format!(
                    "'{}' requires the type '{}' (aka '{}') conform to '{}', and no conformer of that name is \
                     presented{}",
                    site, lhs, spelled, proto, mark
                ));
                continue;
            }
        };
        if require_grounds {
            require_protocol_grounds(&wearer.protocols, world)?;
            let mut inherited: Vec<String> = inherited_protocols(&wearer.protocols, world).into_iter().collect();
            inherited.sort();
            if let Some(gated) = inherited.iter().find(|p| world.gated_protocols.contains_key(*p)) {
                return fail(format!(
                    "membership of '{}' depends on gated conformance '{}'; this selected-application profile does \
                     not discharge dependent conformer obligations",
                    spelled, gated
                ));
            }
        }
        if !wears(wearer, proto, world) {
            let worn = wearer.protocols.join(", ");
            refusals.push(format!(
                "'{}' requires the type '{}' (aka '{}') conform to '{}', and '{}: {}' does not carry it{}",
                site, lhs, head, proto, head, worn, mark
            ));
        }
    }
    Ok(())
}

// ── the judgement ──

pub struct Judgment {
    pub equalities: usize,
    pub memberships: usize,
    pub uses: usize,
    pub excludes_conditional: bool,
    pub refusals: Vec<String>,
}

pub struct Prepared {
    pub path: String,
    pub world: World,
    pub own_aliases: HashMap<String, AliasRule>,
    pub excludes_conditional: bool,
}

/// Reads through the caller's loader; an unavailable source is an input failure
/// that names the path and nothing else, as the legacy CLI said.
pub fn judge_with(load: Loader, arguments: &[String]) -> Result<Judgment, Failure> {
    let read = |path: &str| load(path).map_err(|_| Failure::Input(vec![format!("cannot read {}", path)]));
    evaluate(&prepare(arguments, &read)?)
}

struct Extra {
    path: String,
    text: String,
    world: World,
}

/// A gated head applied where this court reads no use and no certificate.
fn unread(
    file: &World,
    spans: &[Span],
    spelled_path: &str,
    gated_names: &[String],
    declaring: &[&str],
    places: &mut Vec<(usize, String)>,
) {
    let units = file.clean.as_bytes();
    let mut found: Vec<(usize, String)> = Vec::new();
    for name in gated_names {
        let applied = Regex::new(&format!(r"\b{}\s*<", regex::escape(name))).expect("an escaped name compiles");
        for m in applied.find_iter(&file.clean) {
            // Comments have become spaces; qualification can still have spaces
            // before or after each dot, including across lines.
            let mut at = m.start();
            loop {
                let mut q = at;
                while q > 0 && is_space_byte(units[q - 1]) {
                    q -= 1;
                }
                if q == 0 || units[q - 1] != b'.' {
                    break;
                }
                q -= 1;
                while q > 0 && is_space_byte(units[q - 1]) {
                    q -= 1;
                }
                let word_end = q;
                while q > 0 && is_word_byte(units[q - 1]) {
                    q -= 1;
                }
                if q == word_end {
                    break;
                }
                at = q;
            }
            if at > 0 && (is_word_byte(units[at - 1]) || units[at - 1] == b'.') {
                continue;
            }
            if spans.iter().any(|s| in_span(at, s)) {
                continue;
            }
            let mut word_end = at;
            while word_end > 0 && is_space_byte(units[word_end - 1]) {
                word_end -= 1;
            }
            let mut word_start = word_end;
            while word_start > 0 && is_word_byte(units[word_start - 1]) {
                word_start -= 1;
            }
            let word = &file.clean[word_start..word_end];
            if declaring.contains(&word) {
                continue;
            }
            // a metatype whose generic arguments run across lines is a use
            // this court reads only on one line
            let mut close = m.end();
            let mut depth = 1i64;
            let mut broken = false;
            while close < units.len() && depth > 0 {
                let unit = units[close];
                if unit == b'<' {
                    depth += 1;
                }
                if unit == b'>' && units[close - 1] != b'-' {
                    depth -= 1;
                }
                if unit == b'\n' {
                    broken = true;
                }
                if unit == b'{' || unit == b'}' || unit == b';' {
                    break;
                }
                close += 1;
            }
            let mut after = close;
            while after < units.len() && is_space_byte(units[after]) {
                after += 1;
            }
            let metatype = depth == 0 && after + 4 < units.len() && &units[after..after + 5] == b".self";
            let reason = if metatype && broken {
                "a use written across lines, which this court reads on one line"
            } else {
                "a place where this court reads no use and no certificate"
            };
            found.push((
                file.line_at[at],
                format!(
                    "cannot read line {} of '{}': '{}' applies a gated head in {}",
                    file.line_at[at], spelled_path, name, reason
                ),
            ));
        }
    }
    found.sort();
    places.extend(found);
}

pub fn prepare(arguments: &[String], load: &dyn Fn(&str) -> Result<String, Failure>) -> Result<Prepared, Failure> {
    let path = match arguments.first() {
        Some(p) => p.clone(),
        None => return Err(Failure::Input(vec!["usage: judge where <world.swift> [definitions.swift ...]".to_string()])),
    };
    let conditional = re(r"(?m)^\s*#if\b");
    let text = load(&path)?;
    // A definitions file that declares a result builder or a property wrapper
    // lends that attribute to the world the way it lends its typealiases: the
    // declaration supplies the premise that the attribute adds no conformance.
    // A definitions file this scan cannot read lends nothing here; it is
    // refused below, in its turn.
    let no_lent: HashSet<String> = HashSet::new();
    let mut lent_builders: HashSet<String> = HashSet::new();
    for extra in arguments.iter().skip(1) {
        if let Ok(more) = load(extra) {
            if let Ok(clean) = strip_comments(&more, &no_lent) {
                lent_builders.extend(declared_builders(&clean));
            }
        }
    }
    let mut world = read(&text, &lent_builders)?;
    let mut excludes_conditional = conditional.is_match(&crate::lexical::source_lines(&text));
    let own_aliases = world.aliases.clone();
    // Extra files supply alias definitions, not a second version of the same
    // source; a collision is unresolved.
    let mut alias_origins: HashMap<String, String> = world.aliases.keys().map(|k| (k.clone(), path.clone())).collect();
    let mut extras: Vec<Extra> = Vec::new();
    for extra in arguments.iter().skip(1) {
        let more = load(extra)?;
        let lent = read(&more, &no_lent)?;
        extras.push(Extra { path: extra.clone(), text: more, world: lent });
    }
    // A typealias of any file may be extended from another, and such an
    // extension extends the alias's type, through the alias, as well.
    let mut any_alias: HashSet<String> = world.aliases.keys().cloned().collect();
    for extra in &extras {
        any_alias.extend(extra.world.aliases.keys().cloned());
    }
    let mut world_through_alias: Vec<(&String, &Vec<usize>)> =
        world.extensions.iter().filter(|(k, _)| any_alias.contains(*k)).collect();
    world_through_alias.sort_by_key(|(k, _)| (*k).clone());
    if let Some((name, lines)) = world_through_alias.first() {
        return fail(format!(
            "cannot read '{}': it is a typealias, extended at {}, and this court does not follow an extension \
             through an alias to its type",
            name,
            spelled_lines(lines)
        ));
    }
    // A gate binds every file of the module, and this court judges the gates
    // of the world it reads.
    let mut ancestry = world.protocol_parents.clone();
    for extra in &extras {
        for (name, parents) in &extra.world.protocol_parents {
            ancestry.entry(name.clone()).or_insert_with(|| parents.clone());
        }
    }
    for extra in &extras {
        for gate in &extra.world.gates {
            if world.names.contains(&gate.head) {
                return fail(format!(
                    "cannot read the gate '{}: {}' in '{}': this court judges the gates of the world it reads, and \
                     '{}' names '{}'",
                    gate.head, gate.proto, extra.path, path, gate.head
                ));
            }
        }
        let gated: HashSet<&String> = extra.world.gated_protocols.keys().collect();
        if gated.is_empty() {
            continue;
        }
        let mut names: Vec<&String> = world.names.iter().collect();
        names.sort();
        for name in names {
            let mut reached: HashSet<String> = HashSet::new();
            let mut walk = vec![name.clone()];
            while let Some(next) = walk.pop() {
                if !reached.insert(next.clone()) {
                    continue;
                }
                if let Some(parents) = ancestry.get(&next) {
                    walk.extend(parents.iter().cloned());
                }
            }
            let mut hits: Vec<&String> = reached.iter().filter(|r| gated.contains(r)).collect();
            hits.sort();
            if let Some(first) = hits.first() {
                return fail(format!(
                    "cannot read '{}': it reaches '{}', a gated protocol of '{}', and this court judges the gated \
                     protocols of the world it reads",
                    name, first, extra.path
                ));
            }
        }
    }
    for extra in &extras {
        excludes_conditional = excludes_conditional || conditional.is_match(&crate::lexical::source_lines(&extra.text));
        // A definitions file that extends a type, a protocol or a typealias
        // this world declares at file scope is refused rather than read.
        let mut extends_world: Vec<(&String, &Vec<usize>)> = extra
            .world
            .extensions
            .iter()
            .filter(|(k, _)| world.file_types.contains(*k) || any_alias.contains(*k))
            .collect();
        extends_world.sort_by_key(|(k, _)| (*k).clone());
        if let Some((name, lines)) = extends_world.first() {
            return fail(format!(
                "cannot read '{}': '{}' extends it at {}, and this court cannot tell that the extension is this \
                 world's type, or that its members reach this file",
                name,
                extra.path,
                spelled_lines(lines)
            ));
        }
        let mut lent: Vec<(&String, &AliasRule)> = extra.world.aliases.iter().collect();
        lent.sort_by_key(|(k, _)| (*k).clone());
        for (name, rule) in lent {
            if let Some(origin) = alias_origins.get(name) {
                return fail(format!("ambiguous definition of '{}' in '{}' and '{}'", name, origin, extra.path));
            }
            if let Some(lines) = world.declared.get(name) {
                return fail(format!(
                    "cannot read '{}': it is a typealias in '{}' and is declared at {} of '{}', and this court has \
                     no scope rule to choose between them",
                    name,
                    extra.path,
                    spelled_lines(lines),
                    path
                ));
            }
            world.aliases.insert(name.clone(), rule.clone());
            alias_origins.insert(name.clone(), extra.path.clone());
        }
    }
    // A gated head is judged where it is applied, so every application of one
    // is read, or refused at its line, never passed over.
    let word = re(r"\b(\w+)\b");
    let mut gated_names: HashSet<String> = world.gates.iter().map(|g| g.head.clone()).collect();
    let mut grown = true;
    while grown {
        grown = false;
        let mut aliases: Vec<(&String, &AliasRule)> = world.aliases.iter().collect();
        aliases.sort_by_key(|(k, _)| (*k).clone());
        for (name, rule) in aliases {
            if gated_names.contains(name) {
                continue;
            }
            let spelled: HashSet<String> = word.captures_iter(&rule.body).map(|c| c[1].to_string()).collect();
            if spelled.iter().any(|s| gated_names.contains(s)) {
                gated_names.insert(name.clone());
                grown = true;
            }
        }
    }
    for extra in &extras {
        let mut lent: Vec<(&String, &AliasRule)> = extra.world.aliases.iter().filter(|(_, r)| r.parameters.is_empty()).collect();
        lent.sort_by_key(|(k, _)| (*k).clone());
        for (name, _) in lent {
            if gated_names.contains(name) {
                return fail(format!(
                    "cannot read '{}': '{}' defines it as an application of a gated head, and this court judges \
                     certificates in the world it reads",
                    name, extra.path
                ));
            }
        }
    }
    let declaring: &[&str] = &["enum", "struct", "class", "actor", "typealias", "protocol"];
    let mut unread_places: Vec<(usize, String)> = Vec::new();
    // A use or a certificate is judged only at the head its definition
    // exposes; a gate nested inside that root is a named boundary.
    let no_rigid: HashSet<String> = HashSet::new();
    for span in world.root_application_spans.clone() {
        let spelled = world.clean[span.0..span.1].trim();
        let names: HashSet<String> = word.captures_iter(spelled).map(|c| c[1].to_string()).collect();
        if !names.iter().any(|n| gated_names.contains(n)) {
            continue;
        }
        let term = parse_term(spelled)?;
        let claim = gated_form(&term, &world, &no_rigid)?;
        let arguments: Vec<String> = term.args().iter().chain(claim.args().iter()).map(|a| a.text()).collect();
        let arguments = arguments.join(",");
        let nested: HashSet<String> =
            word.captures_iter(&arguments).map(|c| c[1].to_string()).filter(|n| gated_names.contains(n)).collect();
        if !nested.is_empty() || !world.gates.iter().any(|g| g.head == claim.head()) {
            let line = world.line_at[span.0];
            unread_places.push((
                line,
                format!(
                    "cannot read line {} of '{}': '{}' contains a gated application outside the root this court \
                     judges",
                    line, path, spelled
                ),
            ));
        }
    }
    let mut gated_sorted: Vec<String> = gated_names.iter().cloned().collect();
    gated_sorted.sort();
    unread(&world, &world.read_spans.clone(), &path, &gated_sorted, declaring, &mut unread_places);
    unread_places.sort();
    for extra in &extras {
        unread(&extra.world, &extra.world.alias_spans, &extra.path, &gated_sorted, declaring, &mut unread_places);
    }
    if !unread_places.is_empty() {
        return fail_all(unread_places.into_iter().map(|(_, m)| m).collect());
    }

    Ok(Prepared { path, world, own_aliases, excludes_conditional })
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Selection {
    Certificate(String),
    Use(usize),
    Conformer(String),
}

pub fn evaluate(prepared: &Prepared) -> Result<Judgment, Failure> {
    evaluate_selected(prepared, None, false)
}

pub fn evaluate_selected(
    prepared: &Prepared,
    selection: Option<Selection>,
    require_grounds: bool,
) -> Result<Judgment, Failure> {
    let world = &prepared.world;
    let own_aliases = &prepared.own_aliases;
    let mut refusals: Vec<String> = Vec::new();
    let mut judged = 0usize;
    let mut members = 0usize;
    let no_rigid: HashSet<String> = HashSet::new();

    // a gate that carries what no court here judges is named at once
    for gate in &world.gates {
        for part in &gate.unjudged {
            refusals.push(format!(
                "the gate '{}: {}' carries '{}', a conjunct this court does not judge",
                gate.head, gate.proto, part
            ));
        }
    }
    let mut gated: Vec<&GatedProtocol> = world.gated_protocols.values().collect();
    gated.sort_by_key(|g| g.name.clone());
    for proto in gated {
        for part in &proto.unjudged {
            refusals.push(format!(
                "the gated protocol '{}' carries '{}', a conjunct this court does not judge",
                proto.name, part
            ));
        }
    }

    // A typealias certificate is a judged point: a parameterless alias in the
    // world whose right side names a gated head states the gate's equalities
    // for those arguments. A local certificate is checked in its actual owner.
    let mut certificates: Vec<(String, Expression, HashSet<String>)> = Vec::new();
    for (name, rule) in own_aliases {
        if rule.parameters.is_empty() {
            certificates.push((name.clone(), parse_term(&rule.body)?, no_rigid.clone()));
        }
    }
    for conformer in world.conformers.values() {
        let (bindings, rigid) = conformer_context(conformer, world)?;
        for (name, body) in &conformer.table {
            certificates.push((
                format!("{}.{}", conformer.name, name),
                substitute(&parse_term(body)?, &bindings)?,
                rigid.clone(),
            ));
        }
    }
    certificates.sort_by(|a, b| a.0.cmp(&b.0));
    for (name, term, rigid) in &certificates {
        if let Some(selected) = &selection {
            if *selected != Selection::Certificate(name.clone()) {
                continue;
            }
        }
        let body = term.text();
        let claim = gated_form(term, world, rigid)?;
        let matching: Vec<&GatedExtension> = world.gates.iter().filter(|g| g.head == claim.head()).collect();
        if matching.is_empty() {
            continue;
        }
        let bindings = gate_bindings(&claim, world)?;
        for gate in matching {
            if require_grounds {
                require_protocol_grounds(std::slice::from_ref(&gate.proto), world)?;
            }
            for (left, right) in &gate.equalities {
                judged += 1;
                let left_term = substitute(&parse_term(left)?, &bindings)?;
                let right_term = substitute(&parse_term(right)?, &bindings)?;
                let left_canon = normalize(&left_term, world, rigid)?.text();
                let right_canon = normalize(&right_term, world, rigid)?.text();
                if left_canon != right_canon {
                    refusals.push(format!(
                        "'{} = {}' requires the types '{}' (aka '{}') and '{}' (aka '{}') be equivalent [{}]",
                        name, body, left, left_canon, right, right_canon, gate.proto
                    ));
                }
            }
            judge_memberships(
                &gate.memberships,
                &format!("{} = {}", name, body),
                Some(&gate.proto),
                &bindings,
                world,
                &mut members,
                &mut refusals,
                rigid,
                require_grounds,
            )?;
        }
    }

    for (index, use_text) in world.uses.iter().enumerate() {
        if let Some(selected) = &selection {
            if *selected != Selection::Use(index) {
                continue;
            }
        }
        let claim = gated_form(&parse_term(use_text)?, world, &no_rigid)?;
        let matching: Vec<&GatedExtension> = world.gates.iter().filter(|g| g.head == claim.head()).collect();
        if matching.is_empty() {
            continue;
        }
        let bindings = gate_bindings(&claim, world)?;
        for gate in matching {
            if require_grounds {
                require_protocol_grounds(std::slice::from_ref(&gate.proto), world)?;
            }
            for (left, right) in &gate.equalities {
                judged += 1;
                let left_term = substitute(&parse_term(left)?, &bindings)?;
                let right_term = substitute(&parse_term(right)?, &bindings)?;
                let left_canon = normalize(&left_term, world, &no_rigid)?.text();
                let right_canon = normalize(&right_term, world, &no_rigid)?.text();
                if left_canon != right_canon {
                    refusals.push(format!(
                        "'{}' requires the types '{}' (aka '{}') and '{}' (aka '{}') be equivalent [{}]",
                        use_text, left, left_canon, right, right_canon, gate.proto
                    ));
                }
            }
            judge_memberships(
                &gate.memberships,
                use_text,
                Some(&gate.proto),
                &bindings,
                world,
                &mut members,
                &mut refusals,
                &no_rigid,
                require_grounds,
            )?;
        }
    }

    let mut conformers: Vec<&Conformer> = world.conformers.values().collect();
    conformers.sort_by(|a, b| a.name.cmp(&b.name));
    for conformer in conformers {
        if let Some(selected) = &selection {
            if *selected != Selection::Conformer(conformer.name.clone()) {
                continue;
            }
        }
        if require_grounds {
            require_protocol_grounds(&conformer.protocols, world)?;
        }
        let mut protocols: Vec<String> = inherited_protocols(&conformer.protocols, world).into_iter().collect();
        protocols.sort();
        let (bindings, rigid) = conformer_context(conformer, world)?;
        // Membership inheritance and equality inheritance are the same
        // dependency closure. A child cannot discard a parent's gate.
        for proto_name in protocols {
            let gated = match world.gated_protocols.get(&proto_name) {
                Some(g) => g,
                None => continue,
            };
            for (left, right) in &gated.equalities {
                judged += 1;
                let left_term = substitute(&parse_term(left)?, &bindings)?;
                let right_term = substitute(&parse_term(right)?, &bindings)?;
                let left_canon = normalize(&left_term, world, &rigid)?.text();
                let right_canon = normalize(&right_term, world, &rigid)?.text();
                if left_canon != right_canon {
                    refusals.push(format!(
                        "'{}: {}' requires the types '{}' (aka '{}') and '{}' (aka '{}') be equivalent",
                        conformer.name, proto_name, left, left_canon, right, right_canon
                    ));
                }
            }
            judge_memberships(
                &gated.memberships,
                &format!("{}: {}", conformer.name, proto_name),
                None,
                &bindings,
                world,
                &mut members,
                &mut refusals,
                &rigid,
                require_grounds,
            )?;
        }
    }

    if refusals.is_empty() && judged == 0 && members == 0 {
        if require_grounds {
            return Err(Failure::Open(vec!["no equality or membership grounds for the selected application".to_string()]));
        }
        return fail("no equalities or memberships were judged; no certificate established");
    }
    Ok(Judgment {
        equalities: judged,
        memberships: members,
        uses: world.uses.len(),
        excludes_conditional: prepared.excludes_conditional,
        refusals,
    })
}

/// The original text/exit interface is retained at this single boundary: the
/// answer carries the lines the CLI prints and the code it exits with.
pub fn answer(load: Loader, arguments: &[String]) -> Answer {
    let mut out = Answer::default();
    match judge_with(load, arguments) {
        Ok(result) => {
            if result.refusals.is_empty() {
                if result.excludes_conditional {
                    out.stdout.push_str("THE WHERE scope: conditional compilation blocks are excluded.\n");
                }
                out.stdout.push_str(&format!(
                    "✓ THE WHERE holds: {} equalities and {} memberships judged across {} uses, the certificates, and \
                     the gated conformers, source-replayed definition reductions (canon v{}).\n",
                    result.equalities, result.memberships, result.uses, CANON_VERSION
                ));
                out.exit = 0;
            } else {
                for refusal in result.refusals {
                    out.stdout.push_str(&format!("✗ {}\n", refusal));
                }
                out.exit = 1;
            }
        }
        Err(failure) => {
            for message in failure.messages() {
                out.stderr.push_str(&format!("✗ THE WHERE: {}\n", message));
            }
            out.exit = 2;
        }
    }
    out
}
