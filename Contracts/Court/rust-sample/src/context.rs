// The same byte-bound context/1 and source-derived join as CourtContext/WhereContext.
use crate::expression::{Conformer, World};
use crate::failure::{fail, Failure};
use crate::lexical::*;
use crate::where_judge::{self as judge, Extra, Prepared};
use serde_json::Value;
use std::collections::{HashMap, HashSet};

#[derive(Clone)]
struct Source {
    input: String,
    source: String,
    namespace: String,
    imports: Vec<String>,
    at: HashMap<String, String>,
    import_addresses: Vec<String>,
}
struct Context {
    sources: Vec<Source>,
}
fn refusal<T>(at: &str, why: impl AsRef<str>) -> Result<T, Failure> {
    fail(format!("context {}: {}", at, why.as_ref()))
}
fn keys(value: &Value, expected: &[&str]) -> bool {
    value
        .as_object()
        .map(|v| v.len() == expected.len() && expected.iter().all(|k| v.contains_key(*k)))
        .unwrap_or(false)
}
fn strings(value: &Value) -> Option<Vec<String>> {
    value
        .as_array()?
        .iter()
        .map(|v| v.as_str().map(str::to_string))
        .collect()
}
fn nonempty(value: &Value) -> Option<String> {
    value.as_str().filter(|s| !s.is_empty()).map(str::to_string)
}
impl Context {
    fn read(
        text: &str,
        paths: &[String],
        texts: &HashMap<String, String>,
    ) -> Result<Self, Failure> {
        let raw: Value = match serde_json::from_str(text) {
            Ok(v) => v,
            Err(_) => return refusal("document", "invalid JSON"),
        };
        if raw["schema"].as_str() != Some("vi.court.context/1") {
            return refusal("schema", "expected vi.court.context/1");
        }
        if !keys(&raw, &["schema", "sources", "intrinsics"])
            || !raw["sources"].is_array()
            || !raw["intrinsics"].is_array()
        {
            return refusal(
                "document",
                "expected exactly schema, sources and intrinsics",
            );
        }
        let mut parsed = Vec::new();
        let mut seen = HashSet::new();
        for (i, item) in raw["sources"].as_array().unwrap().iter().enumerate() {
            let at = format!("sources[{}]", i);
            let p = &item["at"];
            if !keys(
                item,
                &["input", "source", "sha256", "namespace", "imports", "at"],
            ) || !keys(p, &["input", "source", "sha256", "namespace", "imports"])
            {
                return refusal(&at, "unsupported or missing source fields");
            }
            let mut values = HashMap::new();
            let mut addresses = HashMap::new();
            for key in ["input", "source", "sha256", "namespace"] {
                let address = match nonempty(&p[key]) {
                    Some(v) => v,
                    None => {
                        return refusal(&format!("{}.{}", at, key), "missing provenance address")
                    }
                };
                let value = match nonempty(&item[key]) {
                    Some(v) => v,
                    None => return refusal(&address, format!("missing {}", key)),
                };
                values.insert(key.to_string(), value);
                addresses.insert(key.to_string(), address);
            }
            let imports = strings(&item["imports"]);
            let import_addresses = strings(&p["imports"]);
            let (imports, import_addresses) = match (imports, import_addresses) {
                (Some(a), Some(b))
                    if a.len() == b.len()
                        && a.iter().all(|s| !s.is_empty())
                        && b.iter().all(|s| !s.is_empty())
                        && a.iter().collect::<HashSet<_>>().len() == a.len() =>
                {
                    (a, b)
                }
                _ => {
                    return refusal(
                        &format!("{}.imports", at),
                        "imports need distinct names and provenance addresses",
                    )
                }
            };
            let input = values["input"].clone();
            if !seen.insert(input.clone()) {
                return refusal(&addresses["input"], format!("duplicate input '{}'", input));
            }
            if !paths.contains(&input) || !texts.contains_key(&input) {
                return refusal(
                    &addresses["input"],
                    format!("undeclared CLI input '{}'", input),
                );
            }
            if !re(r"^[0-9a-f]{64}$").is_match(&values["sha256"])
                || crate::digest::sha256(texts[&input].as_bytes()) != values["sha256"]
            {
                return refusal(
                    &addresses["sha256"],
                    format!("SHA-256 differs for '{}'", input),
                );
            }
            parsed.push(Source {
                input,
                source: values["source"].clone(),
                namespace: values["namespace"].clone(),
                imports,
                at: addresses,
                import_addresses,
            });
        }
        if paths.iter().collect::<HashSet<_>>().len() != paths.len() {
            return refusal("sources", "duplicate CLI source");
        }
        for path in paths {
            if !seen.contains(path) {
                return refusal(
                    "sources",
                    format!("supplied input '{}' is not declared", path),
                );
            }
        }
        let mut swift = false;
        for (i, item) in raw["intrinsics"].as_array().unwrap().iter().enumerate() {
            let p = &item["at"];
            let export_at = strings(&p["exports"]);
            if !keys(item, &["namespace", "version", "exports", "at"])
                || item["namespace"].as_str() != Some("Swift")
                || item["version"].as_str() != Some("vi.court.intrinsic-swift/1")
                || strings(&item["exports"]) != Some(vec!["Never".to_string()])
                || swift
                || !keys(p, &["namespace", "version", "exports"])
                || nonempty(&p["namespace"]).is_none()
                || nonempty(&p["version"]).is_none()
                || !export_at
                    .map(|e| e.len() == 1 && !e[0].is_empty())
                    .unwrap_or(false)
            {
                return refusal(
                    &format!("intrinsics[{}]", i),
                    "expected the closed Swift/1 export Never with provenance",
                );
            }
            swift = true;
        }
        let namespaces: HashSet<String> = parsed.iter().map(|s| s.namespace.clone()).collect();
        for source in &parsed {
            if source.namespace == "Swift" {
                return refusal(
                    &source.at["namespace"],
                    "source cannot declare intrinsic namespace Swift",
                );
            }
            for (i, imported) in source.imports.iter().enumerate() {
                if !namespaces.contains(imported) && !(swift && imported == "Swift") {
                    return refusal(
                        &source.import_addresses[i],
                        format!(
                            "namespace '{}' has no supplied source or intrinsic",
                            imported
                        ),
                    );
                }
            }
        }
        Ok(Self { sources: parsed })
    }
}
#[derive(Clone)]
struct Unit {
    context: Source,
    text: String,
    world: World,
    excluded: Option<usize>,
}
#[derive(Clone)]
struct Origin {
    unit: Unit,
    line: usize,
}
impl Origin {
    fn address(&self) -> String {
        format!("{}:{}", self.unit.context.source, self.line)
    }
}
pub fn prepare(
    paths: &[String],
    context_path: &str,
    load: &dyn Fn(&str) -> Result<String, Failure>,
) -> Result<Prepared, Failure> {
    let first = match paths.first() {
        Some(p) => p,
        None => return Err(Failure::Input(vec!["context needs a world source".into()])),
    };
    let mut texts = HashMap::new();
    for path in paths {
        texts.insert(path.clone(), load(path)?);
    }
    let context = Context::read(&load(context_path)?, paths, &texts)?;
    let mut lent = HashSet::new();
    for text in texts.values() {
        if let Ok(clean) = strip_comments(text, &HashSet::new()) {
            lent.extend(declared_builders(&clean));
        }
    }
    let mut units = Vec::new();
    for source in context.sources {
        let text = texts[&source.input].clone();
        let (view, excluded) = if &source.input == first {
            (text.clone(), None)
        } else {
            crate::definition_view::read(&text, &source.source, &lent)?
        };
        let read = judge::read(&view, &lent)?;
        for (i, line) in read.clean.split('\n').enumerate() {
            for hit in captures(r"\bimport\s+([^;\n]+)", line) {
                let imported = hit[0].trim();
                if !source.imports.iter().any(|s| s == imported) {
                    return fail(format!(
                        "{}:{}: import '{}' is not declared by the source context",
                        source.source,
                        i + 1,
                        imported
                    ));
                }
            }
        }
        units.push(Unit {
            context: source,
            text,
            world: read,
            excluded,
        });
    }
    if units.iter().any(|u| u.world.intrinsic_swift) {
        let mut ordered: Vec<_> = units.iter().collect();
        ordered.sort_by_key(|u| &u.context.source);
        for unit in ordered {
            for name in ["Swift", "Never"] {
                if let Some(line) = unit.world.declared.get(name).and_then(|v| v.first()) {
                    return fail(format!("cannot read line {} of '{}': declaration '{}' conflicts with intrinsic Swift/1",line,unit.context.source,name));
                }
            }
        }
    }
    let own = units
        .iter()
        .find(|u| &u.context.input == first)
        .cloned()
        .ok_or_else(|| Failure::Input(vec!["context has no world source".into()]))?;
    let mut origins: HashMap<String, Vec<Origin>> = HashMap::new();
    for unit in &units {
        for name in &unit.world.file_types {
            origins.entry(name.clone()).or_default().push(Origin {
                unit: unit.clone(),
                line: *unit
                    .world
                    .declared
                    .get(name)
                    .and_then(|v| v.first())
                    .unwrap_or(&1),
            });
        }
    }
    let mut names: Vec<String> = origins.keys().cloned().collect();
    names.sort();
    for name in names {
        let found = origins.get_mut(&name).unwrap();
        found.sort_by_key(|o| o.address());
        if found.len() > 1 {
            return fail(format!("{}: declaration '{}' conflicts with '{}'; qualified foreign-name resolution is outside this fragment",found[0].address(),name,found[1].address()));
        }
    }
    let mut world = own.world.clone();
    world.contextual = true;
    world.context_source = own.context.source.clone();
    world.excluded_definitions = units
        .iter()
        .filter_map(|u| {
            u.excluded
                .map(|line| format!("{}:{}", u.context.source, line))
        })
        .collect();
    world.excluded_definitions.sort();
    world.intrinsic_swift = units.iter().any(|u| u.world.intrinsic_swift);
    let own_aliases = own.world.aliases.clone();
    for unit in &units {
        for name in &unit.world.file_types {
            world
                .addresses
                .insert(name.clone(), origins[name][0].address());
        }
        for (name, line) in &unit.world.certificate_lines {
            world
                .addresses
                .insert(name.clone(), format!("{}:{}", unit.context.source, line));
        }
        if &unit.context.input == first {
            continue;
        }
        world.aliases.extend(unit.world.aliases.clone());
        world.conformers.extend(unit.world.conformers.clone());
        world.parameters.extend(unit.world.parameters.clone());
        world
            .protocol_parents
            .extend(unit.world.protocol_parents.clone());
        world.protocol_axes.extend(unit.world.protocol_axes.clone());
        world
            .gated_protocols
            .extend(unit.world.gated_protocols.clone());
        world.gates.extend(unit.world.gates.clone());
        world.namespaces.extend(unit.world.namespaces.clone());
        world.nested_names.extend(unit.world.nested_names.clone());
        world
            .presented_bodies
            .extend(unit.world.presented_bodies.clone());
        world
            .conditional_declarations
            .extend(unit.world.conditional_declarations.clone());
    }
    for unit in &units {
        let scope = Scope::new(&unit.world.clean);
        for hit in declarations(
            r"extension\s+(\w+)\s*:\s*([\w,\s]+?)\s*\{",
            &unit.world.clean,
            &scope,
        )? {
            let name = &hit[0];
            if unit.world.conformers.contains_key(name) {
                continue;
            }
            let parents = hit[1]
                .split(',')
                .map(|p| p.trim().to_string())
                .collect::<Vec<_>>();
            if name == "Never" && !world.conformers.contains_key(name) {
                world.conformers.insert(
                    name.clone(),
                    Conformer {
                        name: name.clone(),
                        parameters: vec![],
                        protocols: vec![],
                        table: HashMap::new(),
                    },
                );
            }
            if let Some(c) = world.conformers.get_mut(name) {
                c.protocols.extend(parents);
            }
        }
        for hit in declarations(
            r"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}",
            &unit.world.clean,
            &scope,
        )? {
            let name = &hit[0];
            if unit.world.conformers.contains_key(name) || !world.conformers.contains_key(name) {
                continue;
            }
            for alias in read_alias_spans(&hit[1])? {
                if !alias.fields[1].is_empty() {
                    continue;
                }
                let c = world.conformers.get_mut(name).unwrap();
                if c.table.contains_key(&alias.fields[0]) {
                    return fail(format!(
                        "{}:1: duplicate definition of '{}.{}'",
                        unit.context.source, name, alias.fields[0]
                    ));
                }
                c.table
                    .insert(alias.fields[0].clone(), alias.fields[2].clone());
            }
        }
    }
    for unit in &units {
        let refs = references(&unit.world, &world)?;
        let mut names: Vec<_> = refs.iter().collect();
        names.sort();
        for name in names {
            if let Some(found) = origins.get(name) {
                let origin = &found[0];
                if origin.unit.context.namespace != unit.context.namespace
                    && !unit
                        .context
                        .imports
                        .contains(&origin.unit.context.namespace)
                {
                    return fail(format!(
                        "{}:1: '{}' belongs to unimported namespace '{}'",
                        unit.context.source, name, origin.unit.context.namespace
                    ));
                }
            }
        }
    }
    fn named(text: &str) -> HashSet<String> {
        let mut names: HashSet<String> = captures(r"\b(\w+(?:\s*\.\s*\w+)*)\b", text)
            .into_iter()
            .map(|c| re(r"\s*\.\s*").replace_all(&c[0], ".").to_string())
            .collect();
        names.extend(
            captures(r"\b(\w+)\b", text)
                .into_iter()
                .map(|c| c[0].clone()),
        );
        names
    }
    let mut reached = own.world.names.clone();
    reached.extend(named(&own.world.clean));
    loop {
        let before = reached.clone();
        for name in &before {
            let mut words = world
                .protocol_parents
                .get(name)
                .cloned()
                .unwrap_or_default();
            if let Some(c) = world.conformers.get(name) {
                words.extend(c.protocols.clone());
                words.extend(c.table.values().cloned());
            }
            if let Some(a) = world.aliases.get(name) {
                words.push(a.body.clone());
            }
            for gate in world.gates.iter().filter(|g| &g.head == name) {
                words.push(gate.proto.clone());
                for (a, b) in gate.equalities.iter().chain(gate.memberships.iter()) {
                    words.push(a.clone());
                    words.push(b.clone());
                }
            }
            if let Some(g) = world.gated_protocols.get(name) {
                for (a, b) in g.equalities.iter().chain(g.memberships.iter()) {
                    words.push(a.clone());
                    words.push(b.clone());
                }
            }
            for text in words {
                reached.extend(named(&text));
            }
        }
        if before == reached {
            break;
        }
    }
    for unit in &units {
        let mut names: Vec<_> = references(&unit.world, &world)?.into_iter().collect();
        names.sort();
        for name in names {
            if reached.contains(&name)
                && !origins.contains_key(&name)
                && name != "Never"
                && !(name == "Swift" && world.intrinsic_swift)
            {
                world.context_unresolved.push(format!(
                    "{}: no declared definition for '{}' in the supplied context",
                    unit.context.source, name
                ));
            }
        }
    }
    world.context_unresolved.sort();
    world.gates.retain(|g| reached.contains(&g.head));
    world.gated_protocols.retain(|n, _| reached.contains(n));
    world.context_conformers = own.world.conformers.keys().cloned().collect();
    for unit in &units {
        let mut names: Vec<_> = unit.world.extensions.keys().collect();
        names.sort();
        for name in names {
            if !reached.contains(name) {
                continue;
            }
            let lines = &unit.world.extensions[name];
            let at = format!("{}:{}", unit.context.source, lines[0]);
            if world.aliases.contains_key(name) {
                return fail(format!(
                    "{}: extension through typealias '{}' is unsupported",
                    at, name
                ));
            }
            if name != "Never" {
                let origin = match origins.get(name).and_then(|v| v.first()) {
                    Some(o) => o,
                    None => {
                        return fail(format!(
                            "{}: extension target '{}' has no declared owner",
                            at, name
                        ))
                    }
                };
                if origin.unit.context.namespace != unit.context.namespace
                    && !unit
                        .context
                        .imports
                        .contains(&origin.unit.context.namespace)
                {
                    return fail(format!(
                        "{}: extension target '{}' is not imported",
                        at, name
                    ));
                }
                if origin.unit.context.input != unit.context.input
                    && re(r"\b(?:private|fileprivate)\b").is_match(&unit.world.clean)
                {
                    return fail(format!("{}: private extension members have no established cross-source reachability",at));
                }
            }
        }
        for gate in unit
            .world
            .gates
            .iter()
            .filter(|g| reached.contains(&g.head))
        {
            world.addresses.insert(
                format!("{}: {}", gate.head, gate.proto),
                format!(
                    "{}:{}",
                    unit.context.source,
                    unit.world
                        .extensions
                        .get(&gate.head)
                        .and_then(|v| v.first())
                        .unwrap_or(&1)
                ),
            );
        }
    }
    fn visit(
        name: &str,
        world: &World,
        done: &mut HashSet<String>,
        active: &mut HashSet<String>,
    ) -> Result<(), Failure> {
        if active.contains(name) {
            return fail(format!(
                "{}: protocol refinement cycle at '{}' has no independent ground",
                world
                    .addresses
                    .get(name)
                    .cloned()
                    .unwrap_or_else(|| format!("{}:1", world.context_source)),
                name
            ));
        }
        if done.contains(name) {
            return Ok(());
        }
        active.insert(name.to_string());
        let mut parents = world
            .protocol_parents
            .get(name)
            .cloned()
            .unwrap_or_default();
        parents.sort();
        for parent in parents {
            visit(&parent, world, done, active)?;
        }
        active.remove(name);
        done.insert(name.to_string());
        Ok(())
    }
    let mut done = HashSet::new();
    let mut active = HashSet::new();
    let mut names: Vec<_> = world.protocol_parents.keys().cloned().collect();
    names.sort();
    for name in names {
        if reached.contains(&name) {
            visit(&name, &world, &mut done, &mut active)?;
        }
    }
    let mut names: Vec<_> = world.gated_protocols.keys().cloned().collect();
    names.sort();
    for name in names {
        for part in &world.gated_protocols[&name].unjudged {
            return fail(format!(
                "{}: the gated protocol '{}' carries '{}', a conjunct this court does not judge",
                world
                    .addresses
                    .get(&name)
                    .cloned()
                    .unwrap_or_else(|| format!("{}:1", own.context.source)),
                name,
                part
            ));
        }
    }
    let mut gates = Vec::new();
    for gate in &world.gates {
        let at = world
            .addresses
            .get(&format!("{}: {}", gate.head, gate.proto))
            .cloned()
            .unwrap_or_else(|| format!("{}:1", own.context.source));
        for part in &gate.unjudged {
            return fail(format!(
                "{}: the gate '{}: {}' carries '{}', a conjunct this court does not judge",
                at, gate.head, gate.proto, part
            ));
        }
        let mut copy = gate.clone();
        let mut protocols: Vec<_> = judge::inherited_protocols(&[gate.proto.clone()], &world)
            .into_iter()
            .collect();
        protocols.sort();
        for proto in protocols {
            if let Some(inherited) = world.gated_protocols.get(&proto) {
                copy.equalities.extend(inherited.equalities.clone());
                copy.memberships.extend(inherited.memberships.clone());
            }
        }
        gates.push(copy);
    }
    world.gates = gates;
    select_conformers(&mut world, &own_aliases)?;
    grounded_memberships(&world)?;
    let extras = units
        .iter()
        .filter(|u| &u.context.input != first)
        .map(|u| Extra {
            path: u.context.source.clone(),
            text: u.text.clone(),
            world: u.world.clone(),
        })
        .collect();
    let excludes = units
        .iter()
        .any(|u| re(r"(?m)^\s*#if\b").is_match(&source_lines(&u.text)));
    judge::finish(own.context.source, world, own_aliases, excludes, extras)
}

fn grounded_memberships(world: &World) -> Result<(), Failure> {
    fn address(name: &str, world: &World) -> String {
        world
            .addresses
            .get(name)
            .cloned()
            .unwrap_or_else(|| format!("{}:1", world.context_source))
    }
    fn protocols(names: &[String], at: &str, world: &World) -> Result<(), Failure> {
        let mut all: Vec<_> = judge::inherited_protocols(names, world)
            .into_iter()
            .collect();
        all.sort();
        for name in all {
            if !world.protocol_parents.contains_key(&name) {
                return fail(format!(
                    "{}: no declared protocol grounds for '{}'",
                    at, name
                ));
            }
        }
        Ok(())
    }
    fn independently_wears(
        names: &[String],
        required: &str,
        world: &World,
        seen: &HashSet<String>,
    ) -> bool {
        for name in names {
            if seen.contains(name) || world.gated_protocols.contains_key(name) {
                continue;
            }
            let mut next = seen.clone();
            next.insert(name.clone());
            if name == required
                || independently_wears(
                    world
                        .protocol_parents
                        .get(name)
                        .map(Vec::as_slice)
                        .unwrap_or(&[]),
                    required,
                    world,
                    &next,
                )
            {
                return true;
            }
        }
        false
    }
    let mut edges: HashMap<String, HashSet<String>> = HashMap::new();
    let mut locations = HashMap::new();
    let mut names: Vec<_> = world.context_conformers.iter().cloned().collect();
    names.sort();
    for name in names {
        let conformer = match world.conformers.get(&name) {
            Some(c) => c,
            None => continue,
        };
        protocols(&conformer.protocols, &address(&name, world), world)?;
        let (bindings, rigid) = judge::conformer_context(conformer, world)?;
        let mut parents: Vec<_> = judge::inherited_protocols(&conformer.protocols, world)
            .into_iter()
            .collect();
        parents.sort();
        for proto in parents {
            let gate = match world.gated_protocols.get(&proto) {
                Some(g) => g,
                None => continue,
            };
            let node = format!("{}: {}", name, proto);
            edges.insert(node.clone(), HashSet::new());
            locations.insert(node.clone(), address(&name, world));
            for (lhs, required) in &gate.memberships {
                protocols(&[required.clone()], &address(&name, world), world)?;
                let term = judge::substitute(&judge::parse_term(lhs)?, &bindings)?;
                let target = judge::normalize(&term, world, &rigid)?;
                if !target.args().is_empty() {
                    continue;
                }
                let wearer = match world.conformers.get(&target.head()) {
                    Some(w) => w,
                    None => continue,
                };
                protocols(&wearer.protocols, &address(&target.head(), world), world)?;
                if independently_wears(&wearer.protocols, required, world, &HashSet::new()) {
                    continue;
                }
                for inherited in judge::inherited_protocols(&wearer.protocols, world) {
                    if world.gated_protocols.contains_key(&inherited) {
                        edges.get_mut(&node).unwrap().insert(format!(
                            "{}: {}",
                            target.head(),
                            inherited
                        ));
                    }
                }
            }
        }
    }
    for gate in &world.gates {
        let mut names = vec![gate.proto.clone()];
        names.extend(gate.memberships.iter().map(|(_, p)| p.clone()));
        protocols(
            &names,
            &address(&format!("{}: {}", gate.head, gate.proto), world),
            world,
        )?;
    }
    fn visit(
        node: &str,
        world: &World,
        edges: &HashMap<String, HashSet<String>>,
        locations: &HashMap<String, String>,
        done: &mut HashSet<String>,
        active: &mut HashSet<String>,
    ) -> Result<(), Failure> {
        if active.contains(node) {
            return fail(format!(
                "{}: gated membership cycle at '{}' has no independent ground",
                locations
                    .get(node)
                    .cloned()
                    .unwrap_or_else(|| format!("{}:1", world.context_source)),
                node
            ));
        }
        if done.contains(node) {
            return Ok(());
        }
        let dependencies = match edges.get(node) {
            Some(d) => d,
            None => {
                return fail(format!(
                    "{}:1: dependent gated conformance '{}' was not read",
                    world.context_source, node
                ))
            }
        };
        active.insert(node.to_string());
        let mut next: Vec<_> = dependencies.iter().collect();
        next.sort();
        for n in next {
            visit(n, world, edges, locations, done, active)?;
        }
        active.remove(node);
        done.insert(node.to_string());
        Ok(())
    }
    let mut done = HashSet::new();
    let mut active = HashSet::new();
    let mut nodes: Vec<_> = edges.keys().collect();
    nodes.sort();
    for node in nodes {
        visit(node, world, &edges, &locations, &mut done, &mut active)?;
    }
    Ok(())
}
// Free references use imports; lexical parameters/axes do not borrow a world name.
fn references(source: &World, world: &World) -> Result<HashSet<String>, Failure> {
    use crate::expression::Expression;
    fn axes(name: &str, world: &World, seen: &HashSet<String>) -> HashSet<String> {
        if seen.contains(name) {
            return HashSet::new();
        }
        let mut next = seen.clone();
        next.insert(name.into());
        let mut out = world.protocol_axes.get(name).cloned().unwrap_or_default();
        for parent in world.protocol_parents.get(name).into_iter().flatten() {
            out.extend(axes(parent, world, &next));
        }
        out
    }
    fn walk(e: &Expression, bound: &HashSet<String>, world: &World, out: &mut HashSet<String>) {
        match e {
            Expression::Application(n, args) => {
                if !bound.contains(n) {
                    out.insert(n.clone());
                }
                for a in args {
                    walk(a, bound, world, out);
                }
            }
            Expression::Field(owner, _) => {
                if world.nested_names.contains(&e.text()) {
                    out.insert(e.text());
                } else {
                    walk(owner, bound, world, out);
                }
            }
        }
    }
    let mut out = HashSet::new();
    let empty = HashSet::new();
    let mut term = |text: &str, bound: &HashSet<String>| -> Result<(), Failure> {
        let e = crate::expression::parse(text, false).map_err(|e| {
            Failure::Unsupported(vec![format!(
                "context type reference '{}' is unsupported: {}",
                text, e
            )])
        })?;
        walk(&e, bound, world, &mut out);
        Ok(())
    };
    let mut names: Vec<_> = source.aliases.keys().collect();
    names.sort();
    for n in names {
        let a = &source.aliases[n];
        term(&a.body, &a.parameters.iter().cloned().collect())?;
    }
    let mut names: Vec<_> = source.conformers.keys().collect();
    names.sort();
    for n in names {
        let c = &source.conformers[n];
        let mut bound: HashSet<_> = c.parameters.iter().chain(c.table.keys()).cloned().collect();
        bound.insert("Self".into());
        for p in &c.protocols {
            term(p, &empty)?;
        }
        let mut fields: Vec<_> = c.table.keys().collect();
        fields.sort();
        for f in fields {
            term(&c.table[f], &bound)?;
        }
    }
    let mut names: Vec<_> = source.protocol_parents.keys().collect();
    names.sort();
    for n in names {
        for p in &source.protocol_parents[n] {
            term(p, &empty)?;
        }
    }
    let mut names: Vec<_> = source.gated_protocols.keys().collect();
    names.sort();
    for n in names {
        let g = &source.gated_protocols[n];
        let mut bound = axes(n, world, &empty);
        bound.insert("Self".into());
        for (l, r) in g.equalities.iter().chain(g.memberships.iter()) {
            term(l, &bound)?;
            term(r, &bound)?;
        }
    }
    for g in &source.gates {
        let mut bound = axes(&g.head, world, &empty);
        bound.extend(world.parameters.get(&g.head).into_iter().flatten().cloned());
        if let Some(c) = world.conformers.get(&g.head) {
            bound.extend(c.table.keys().cloned());
        }
        bound.insert("Self".into());
        term(&g.head, &empty)?;
        term(&g.proto, &empty)?;
        for (l, r) in g.equalities.iter().chain(g.memberships.iter()) {
            term(l, &bound)?;
            term(r, &bound)?;
        }
    }
    for n in source.extensions.keys() {
        term(n, &empty)?;
    }
    for u in &source.uses {
        term(u, &empty)?;
    }
    Ok(out)
}
fn select_conformers(
    world: &mut World,
    aliases: &HashMap<String, crate::expression::AliasRule>,
) -> Result<(), Failure> {
    use crate::expression::Expression;
    fn members(
        clauses: &[(String, String)],
        bindings: &HashMap<String, Expression>,
        rigid: &HashSet<String>,
        world: &World,
        selected: &mut HashSet<String>,
    ) -> Result<(), Failure> {
        for (lhs, _) in clauses {
            let term = judge::substitute(&judge::parse_term(lhs)?, bindings)?;
            let target = judge::normalize(&term, world, rigid)?;
            if target.args().is_empty() && world.conformers.contains_key(&target.head()) {
                selected.insert(target.head());
            }
        }
        Ok(())
    }
    fn certificate(
        term: &Expression,
        rigid: &HashSet<String>,
        world: &World,
        selected: &mut HashSet<String>,
    ) -> Result<(), Failure> {
        let claim = judge::gated_form(term, world, rigid)?;
        let matching: Vec<_> = world
            .gates
            .iter()
            .filter(|g| g.head == claim.head())
            .collect();
        if matching.is_empty() {
            return Ok(());
        }
        let bindings = judge::gate_bindings(&claim, world)?;
        for gate in matching {
            members(&gate.memberships, &bindings, rigid, world, selected)?;
        }
        Ok(())
    }
    loop {
        let mut selected = world.context_conformers.clone();
        let empty = HashSet::new();
        let mut names: Vec<_> = aliases.keys().collect();
        names.sort();
        for name in names {
            let a = &aliases[name];
            if a.parameters.is_empty() {
                certificate(&judge::parse_term(&a.body)?, &empty, world, &mut selected)?;
            }
        }
        for u in &world.uses {
            certificate(&judge::parse_term(u)?, &empty, world, &mut selected)?;
        }
        let mut names: Vec<_> = world.context_conformers.iter().collect();
        names.sort();
        for name in names {
            let c = match world.conformers.get(name) {
                Some(c) => c,
                None => continue,
            };
            let (bindings, rigid) = judge::conformer_context(c, world)?;
            let mut fields: Vec<_> = c.table.keys().collect();
            fields.sort();
            for f in fields {
                certificate(
                    &judge::substitute(&judge::parse_term(&c.table[f])?, &bindings)?,
                    &rigid,
                    world,
                    &mut selected,
                )?;
            }
            let mut protocols: Vec<_> = judge::inherited_protocols(&c.protocols, world)
                .into_iter()
                .collect();
            protocols.sort();
            for p in protocols {
                if let Some(g) = world.gated_protocols.get(&p) {
                    members(&g.memberships, &bindings, &rigid, world, &mut selected)?;
                }
            }
        }
        if selected == world.context_conformers {
            break;
        }
        world.context_conformers = selected;
    }
    Ok(())
}
