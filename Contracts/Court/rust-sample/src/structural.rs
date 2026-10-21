// Reads the declared type-relation fragment for the count court, a port of
// Sources/Court/StructuralSource.swift. Value and member-function bodies are
// retained only as balanced regions; they are not claims proved by this reader.

use crate::expression::{AliasRule, Conformer, Failure, World};
use std::collections::{HashMap, HashSet};

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum RequirementKind {
    Equal,
    Member,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Requirement {
    pub kind: RequirementKind,
    pub left: String,
    pub right: String,
}

#[derive(Debug, Clone)]
pub struct Axis {
    pub name: String,
    pub constraints: Vec<Requirement>,
    pub fallback: Option<String>,
}

#[derive(Debug, Clone)]
pub struct Declaration {
    pub name: String,
    pub kind: String,
    pub parameters: Vec<String>,
    pub parents: Vec<String>,
    pub requirements: Vec<Requirement>,
    pub fields: HashMap<String, String>,
    pub field_access: HashMap<String, String>,
    pub axes: Vec<Axis>,
    pub alias: Option<String>,
    pub unsupported: Vec<String>,
    pub body_witness: bool,
    pub origin: String,
}

#[derive(Debug, Default)]
pub struct StructuralSource {
    pub declarations: HashMap<String, Declaration>,
    pub access: HashMap<String, String>,
    pub extensions: HashMap<String, Vec<Declaration>>,
    pub default_providers: HashMap<String, HashMap<String, String>>,
    pub syntax: World,
    pub excluded_conditionals: usize,
    pub conditional_subjects: HashSet<String>,
}

const ACCESS: &[&str] = &["public", "internal", "private", "fileprivate", "package", "open"];

fn is_identifier_start(c: char) -> bool {
    c.is_alphabetic() || c == '_'
}

fn is_identifier_part(c: char) -> bool {
    c.is_alphabetic() || c.is_numeric() || c == '_'
}

/// The tokens of a source: comments dropped, each string literal one
/// `@literal`, line breaks kept as tokens, `==` one token, other punctuation
/// one token per character.
pub fn tokens(source: &str) -> Result<Vec<String>, Failure> {
    let chars: Vec<char> = crate::lexical::source_lines(source).chars().collect();
    let count = chars.len();
    let mut result: Vec<String> = Vec::new();
    let mut i = 0usize;

    fn raw_string_begins(chars: &[char], i: usize) -> bool {
        if i >= chars.len() || chars[i] != '#' {
            return false;
        }
        let mut j = i;
        while j < chars.len() && chars[j] == '#' {
            j += 1;
        }
        j < chars.len() && chars[j] == '"'
    }

    fn skip_string(chars: &[char], i: &mut usize) -> Result<(), Failure> {
        let count = chars.len();
        let triple = *i + 2 < count && chars[*i + 1] == '"' && chars[*i + 2] == '"';
        *i += if triple { 3 } else { 1 };
        while *i < count {
            if chars[*i] == '\\' {
                if *i + 1 < count && chars[*i + 1] == '(' {
                    *i += 2;
                    skip_interpolation(chars, i)?;
                } else {
                    *i += std::cmp::min(2, count - *i);
                }
                continue;
            }
            if chars[*i] == '"' && (!triple || (*i + 2 < count && chars[*i + 1] == '"' && chars[*i + 2] == '"')) {
                *i += if triple { 3 } else { 1 };
                return Ok(());
            }
            *i += 1;
        }
        Err(Failure::new("unterminated string"))
    }

    fn skip_interpolation(chars: &[char], i: &mut usize) -> Result<(), Failure> {
        let count = chars.len();
        let mut depth = 1usize;
        while *i < count {
            if raw_string_begins(chars, *i) {
                return Err(Failure::new("raw string literals are outside structural reader scope"));
            }
            if chars[*i] == '"' {
                skip_string(chars, i)?;
                continue;
            }
            if *i + 1 < count && chars[*i] == '/' && chars[*i + 1] == '/' {
                *i += 2;
                while *i < count && chars[*i] != '\n' {
                    *i += 1;
                }
                continue;
            }
            if *i + 1 < count && chars[*i] == '/' && chars[*i + 1] == '*' {
                *i += 2;
                let mut comments = 1usize;
                while *i < count && comments > 0 {
                    if *i + 1 < count && chars[*i] == '/' && chars[*i + 1] == '*' {
                        comments += 1;
                        *i += 2;
                    } else if *i + 1 < count && chars[*i] == '*' && chars[*i + 1] == '/' {
                        comments -= 1;
                        *i += 2;
                    } else {
                        *i += 1;
                    }
                }
                if comments != 0 {
                    return Err(Failure::new("unterminated interpolation comment"));
                }
                continue;
            }
            if chars[*i] == '(' {
                depth += 1;
            }
            if chars[*i] == ')' {
                depth -= 1;
                if depth == 0 {
                    *i += 1;
                    return Ok(());
                }
            }
            *i += 1;
        }
        Err(Failure::new("unterminated string interpolation"))
    }

    while i < count {
        let c = chars[i];
        if c == '\n' {
            result.push("\n".to_string());
            i += 1;
            continue;
        }
        if c.is_whitespace() {
            i += 1;
            continue;
        }
        if c == '/' && i + 1 < count && chars[i + 1] == '/' {
            i += 2;
            while i < count && chars[i] != '\n' {
                i += 1;
            }
            continue;
        }
        if c == '/' && i + 1 < count && chars[i + 1] == '*' {
            i += 2;
            let mut depth = 1usize;
            while i < count && depth > 0 {
                if i + 1 < count && chars[i] == '/' && chars[i + 1] == '*' {
                    depth += 1;
                    i += 2;
                } else if i + 1 < count && chars[i] == '*' && chars[i + 1] == '/' {
                    depth -= 1;
                    i += 2;
                } else {
                    if chars[i] == '\n' {
                        result.push("\n".to_string());
                    }
                    i += 1;
                }
            }
            if depth != 0 {
                return Err(Failure::new("unterminated block comment"));
            }
            continue;
        }
        if raw_string_begins(&chars, i) {
            return Err(Failure::new("raw string literals are outside structural reader scope"));
        }
        if c == '"' {
            skip_string(&chars, &mut i)?;
            result.push("@literal".to_string());
            continue;
        }
        if is_identifier_start(c) {
            let start = i;
            i += 1;
            while i < count && is_identifier_part(chars[i]) {
                i += 1;
            }
            result.push(chars[start..i].iter().collect());
            continue;
        }
        if c == '=' && i + 1 < count && chars[i + 1] == '=' {
            result.push("==".to_string());
            i += 2;
            continue;
        }
        result.push(c.to_string());
        i += 1;
    }
    Ok(result)
}

pub fn plain(tokens: &[String]) -> Vec<String> {
    tokens.iter().filter(|t| *t != "\n").cloned().collect()
}

pub fn text(tokens: &[String]) -> String {
    plain(tokens).join(" ")
}

pub fn identifier(word: &str) -> bool {
    let mut chars = word.chars();
    match chars.next() {
        Some(first) if is_identifier_start(first) => {}
        _ => return false,
    }
    word.chars().all(is_identifier_part)
}

pub fn split(tokens: &[String], separator: &str) -> Vec<Vec<String>> {
    let mut depth = 0i64;
    let mut parts: Vec<Vec<String>> = vec![Vec::new()];
    for t in tokens {
        if t == "<" || t == "(" || t == "[" {
            depth += 1;
        }
        if t == ">" || t == ")" || t == "]" {
            depth -= 1;
        }
        if t == separator && depth == 0 {
            parts.push(Vec::new());
        } else {
            parts.last_mut().unwrap().push(t.clone());
        }
    }
    parts
}

pub fn requirements(tokens: &[String], unsupported: &mut Vec<String>) -> Vec<Requirement> {
    let flat = plain(tokens);
    if flat.is_empty() {
        return Vec::new();
    }
    let mut result = Vec::new();
    for part in split(&flat, ",") {
        let equal_at = part.iter().position(|t| t == "==");
        if let Some(at) = equal_at {
            if !part[at + 1..].iter().any(|t| t == "==") && at > 0 && at + 1 < part.len() {
                result.push(Requirement {
                    kind: RequirementKind::Equal,
                    left: text(&part[..at]),
                    right: text(&part[at + 1..]),
                });
                continue;
            }
        }
        let colon_at = part.iter().position(|t| t == ":");
        if let Some(at) = colon_at {
            if at > 0 {
                let right = split(&part[at + 1..], "&");
                if right.iter().all(|p| p.len() == 1 && identifier(&p[0])) {
                    for p in right {
                        result.push(Requirement {
                            kind: RequirementKind::Member,
                            left: text(&part[..at]),
                            right: p[0].clone(),
                        });
                    }
                } else {
                    unsupported.push(text(&part));
                }
                continue;
            }
        }
        unsupported.push(text(&part));
    }
    result
}

pub fn balanced(tokens: &[String], index: &mut usize, open: &str, close: &str) -> Result<Vec<String>, Failure> {
    if *index >= tokens.len() || tokens[*index] != open {
        return Err(Failure::new(format!("expected {}", open)));
    }
    *index += 1;
    let begin = *index;
    let mut depth = 1usize;
    while *index < tokens.len() {
        if tokens[*index] == open {
            depth += 1;
        }
        if tokens[*index] == close {
            depth -= 1;
            if depth == 0 {
                let value = tokens[begin..*index].to_vec();
                *index += 1;
                return Ok(value);
            }
        }
        *index += 1;
    }
    Err(Failure::new(format!("unclosed {}", open)))
}

pub fn statement(tokens: &[String], index: &mut usize) -> Vec<String> {
    let begin = *index;
    let mut depth = 0i64;
    while *index < tokens.len() {
        let t = &tokens[*index];
        if depth == 0 && (t == ";" || t == "}") {
            break;
        }
        if depth == 0 && t == "\n" {
            let mut next = *index + 1;
            while next < tokens.len() && tokens[next] == "\n" {
                next += 1;
            }
            let last = plain(&tokens[begin..*index]).last().cloned();
            let continues = next < tokens.len()
                && (tokens[next] == "." || tokens[next] == "where" || last.as_deref() == Some(",") || last.as_deref() == Some("="));
            if !continues {
                break;
            }
        }
        if t == "<" || t == "(" || t == "[" {
            depth += 1;
        }
        if t == ">" || t == ")" || t == "]" {
            depth -= 1;
        }
        *index += 1;
    }
    let result = tokens[begin..*index].to_vec();
    if *index < tokens.len() && (tokens[*index] == ";" || tokens[*index] == "\n") {
        *index += 1;
    }
    result
}

pub fn declaration(kind: &str, header: &[String], body: &[String], origin: &str) -> Result<Declaration, Failure> {
    let mut h = plain(header);
    let mut errors: Vec<String> = Vec::new();
    if h.is_empty() || !identifier(&h[0]) {
        return Err(Failure::new(format!("unread declaration header in {}", origin)));
    }
    let name = h.remove(0);
    let mut params: Vec<String> = Vec::new();
    let mut reqs: Vec<Requirement> = Vec::new();
    if h.first().map(String::as_str) == Some("<") {
        let mut depth = 0i64;
        let mut close: Option<usize> = None;
        for (i, t) in h.iter().enumerate() {
            if t == "<" {
                depth += 1;
            }
            if t == ">" {
                depth -= 1;
                if depth == 0 {
                    close = Some(i);
                    break;
                }
            }
        }
        let end = match close {
            Some(end) => end,
            None => return Err(Failure::new(format!("unclosed parameters on {}", name))),
        };
        for p in split(&h[1..end], ",") {
            match p.first() {
                Some(parameter) if identifier(parameter) => params.push(parameter.clone()),
                _ => return Err(Failure::new(format!("unread parameter on {}", name))),
            }
            if p.len() > 1 {
                reqs.extend(requirements(&p, &mut errors));
            }
        }
        h.drain(0..end + 1);
    }
    let distinct: HashSet<&String> = params.iter().collect();
    if distinct.len() != params.len() {
        errors.push("duplicate generic parameter".to_string());
    }
    let mut parents: Vec<String> = Vec::new();
    let mut alias: Option<String> = None;
    let where_at = h.iter().position(|t| t == "where");
    let prefix: Vec<String> = match where_at {
        Some(at) => h[..at].to_vec(),
        None => h.clone(),
    };
    if let Some(at) = where_at {
        reqs.extend(requirements(&h[at + 1..], &mut errors));
    }
    if kind == "typealias" {
        if prefix.first().map(String::as_str) == Some("=") {
            alias = Some(text(&prefix[1..]));
        } else {
            errors.push("missing alias body".to_string());
        }
    } else if prefix.first().map(String::as_str) == Some(":") {
        for p in split(&prefix[1..], ",") {
            if p.len() == 1 && identifier(&p[0]) {
                parents.push(p[0].clone());
            } else {
                errors.push(format!("unread parent: {}", text(&p)));
            }
        }
    } else if !prefix.is_empty() {
        errors.push(format!("unread header: {}", text(&prefix)));
    }
    let mut fields: HashMap<String, String> = HashMap::new();
    let mut field_access: HashMap<String, String> = HashMap::new();
    let mut axes: Vec<Axis> = Vec::new();
    let mut body_witness = false;
    let mut member_access = "internal".to_string();
    let mut i = 0usize;
    while i < body.len() {
        let token = body[i].as_str();
        if ACCESS.contains(&token) {
            member_access = token.to_string();
            i += 1;
            continue;
        }
        if token == "let" || token == "var" || token == "func" {
            member_access = "internal".to_string();
        }
        if token == "{" {
            balanced(body, &mut i, "{", "}")?;
            member_access = "internal".to_string();
            continue;
        }
        if token == "#" {
            errors.push("conditional member declarations".to_string());
            i += 1;
            continue;
        }
        if token == "var" && i + 1 < body.len() && body[i + 1] == "body" {
            body_witness = true;
        }
        if token == "enum" || token == "struct" || token == "class" {
            errors.push("nested type declaration".to_string());
        }
        if token == "typealias" {
            i += 1;
            let line = statement(body, &mut i);
            let member = declaration("typealias", &line, &[], &format!("{}.{}", origin, name))?;
            if !member.parameters.is_empty() || !member.requirements.is_empty() || !member.unsupported.is_empty() {
                errors.push(format!("unsupported member alias {}", member.name));
            }
            if fields.contains_key(&member.name) {
                errors.push(format!("duplicate field {}", member.name));
            }
            match member.alias {
                Some(value) => {
                    fields.insert(member.name.clone(), value);
                }
                None => {
                    fields.remove(&member.name);
                }
            }
            field_access.insert(member.name.clone(), member_access.clone());
            member_access = "internal".to_string();
            continue;
        }
        if token == "associatedtype" {
            i += 1;
            let mut a = plain(&statement(body, &mut i));
            if a.is_empty() || !identifier(&a[0]) {
                errors.push("unread associatedtype".to_string());
                continue;
            }
            let axis = a.remove(0);
            let mut fallback: Option<String> = None;
            if let Some(equal) = a.iter().position(|t| t == "=") {
                fallback = Some(text(&a[equal + 1..]));
                a.truncate(equal);
            }
            let bounds = if a.is_empty() {
                Vec::new()
            } else {
                let mut with_axis = vec![axis.clone()];
                with_axis.extend(a.iter().cloned());
                requirements(&with_axis, &mut errors)
            };
            axes.push(Axis { name: axis, constraints: bounds, fallback });
            member_access = "internal".to_string();
            continue;
        }
        i += 1;
    }
    Ok(Declaration {
        name,
        kind: kind.to_string(),
        parameters: params,
        parents,
        requirements: reqs,
        fields,
        field_access,
        axes,
        alias,
        unsupported: errors,
        body_witness,
        origin: origin.to_string(),
    })
}

impl StructuralSource {
    pub fn new(files: &[(String, String)]) -> Result<StructuralSource, Failure> {
        let mut source = StructuralSource::default();
        for (origin, text_of_file) in files {
            let ts = tokens(text_of_file)?;
            let mut i = 0usize;
            let mut pending_access = "internal".to_string();
            while i < ts.len() {
                let token = ts[i].as_str();
                if ACCESS.contains(&token) {
                    pending_access = token.to_string();
                    i += 1;
                    continue;
                }
                if ["import", "let", "var", "func"].contains(&token) {
                    pending_access = "internal".to_string();
                }
                if token == "#" && i + 1 < ts.len() && ts[i + 1] == "if" {
                    source.excluded_conditionals += 1;
                    let mut depth = 1usize;
                    i += 2;
                    while i < ts.len() && depth > 0 {
                        // A skipped branch may alter a declaration used outside it.
                        if ["enum", "struct", "class", "protocol", "extension", "typealias"].contains(&ts[i].as_str())
                            && i + 1 < ts.len()
                            && identifier(&ts[i + 1])
                        {
                            source.conditional_subjects.insert(ts[i + 1].clone());
                        }
                        if ts[i] == "#" && i + 1 < ts.len() {
                            if ts[i + 1] == "if" {
                                depth += 1;
                            }
                            if ts[i + 1] == "endif" {
                                depth -= 1;
                            }
                        }
                        i += 1;
                    }
                    if depth != 0 {
                        return Err(Failure::new(format!("unclosed #if in {}", origin)));
                    }
                    pending_access = "internal".to_string();
                    continue;
                }
                let kind = ts[i].clone();
                if ["enum", "struct", "protocol", "extension", "typealias"].contains(&kind.as_str()) {
                    i += 1;
                    let header: Vec<String>;
                    let mut body: Vec<String> = Vec::new();
                    if kind == "typealias" {
                        header = statement(&ts, &mut i);
                    } else {
                        let begin = i;
                        while i < ts.len() && ts[i] != "{" {
                            i += 1;
                        }
                        header = ts[begin..i].to_vec();
                        body = balanced(&ts, &mut i, "{", "}")?;
                    }
                    let d = declaration(&kind, &header, &body, origin)?;
                    if kind == "extension" {
                        source.extensions.entry(d.name.clone()).or_default().push(d);
                    } else {
                        if source.declarations.contains_key(&d.name) {
                            return Err(Failure::new(format!("duplicate declaration {}", d.name)));
                        }
                        source.access.insert(d.name.clone(), pending_access.clone());
                        source.declarations.insert(d.name.clone(), d);
                    }
                    pending_access = "internal".to_string();
                } else if ts[i] == "{" {
                    balanced(&ts, &mut i, "{", "}")?;
                    pending_access = "internal".to_string();
                } else {
                    i += 1;
                }
            }
        }
        // An extension supplies an explicitly named external nominal subject.
        let mut external: Vec<(String, String)> = source
            .extensions
            .iter()
            .filter(|(name, _)| !source.declarations.contains_key(*name))
            .map(|(name, exts)| (name.clone(), exts[0].origin.clone()))
            .collect();
        external.sort();
        for (name, origin) in external {
            source.declarations.insert(
                name.clone(),
                Declaration {
                    name,
                    kind: "external".to_string(),
                    parameters: Vec::new(),
                    parents: Vec::new(),
                    requirements: Vec::new(),
                    fields: HashMap::new(),
                    field_access: HashMap::new(),
                    axes: Vec::new(),
                    alias: None,
                    unsupported: Vec::new(),
                    body_witness: false,
                    origin,
                },
            );
        }
        let subjects: Vec<String> = source.conditional_subjects.iter().cloned().collect();
        for name in subjects {
            if let Some(d) = source.declarations.get_mut(&name) {
                d.unsupported.push("conditional compilation can alter this declaration".to_string());
            }
        }
        source.build_syntax();
        Ok(source)
    }

    pub fn protocol_closure(&self, names: &[String]) -> HashSet<String> {
        let mut seen: HashSet<String> = HashSet::new();
        let mut work: Vec<String> = names.to_vec();
        while let Some(p) = work.pop() {
            if seen.insert(p.clone()) {
                if let Some(d) = self.declarations.get(&p) {
                    work.extend(d.parents.iter().cloned());
                }
            }
        }
        seen
    }

    pub fn conformance_choices(&self, name: &str) -> Vec<(String, Vec<Requirement>)> {
        let d = match self.declarations.get(name) {
            Some(d) => d,
            None => return Vec::new(),
        };
        let mut result: Vec<(String, Vec<Requirement>)> = d.parents.iter().map(|p| (p.clone(), Vec::new())).collect();
        if let Some(exts) = self.extensions.get(name) {
            for e in exts {
                result.extend(e.parents.iter().map(|p| (p.clone(), e.requirements.clone())));
            }
        }
        result
    }

    fn build_syntax(&mut self) {
        let mut names: Vec<String> = self.declarations.keys().cloned().collect();
        names.sort();
        for name in names {
            let mut d = self.declarations[&name].clone();
            if d.kind == "protocol" {
                self.syntax.protocol_parents.insert(name.clone(), d.parents.clone());
                self.syntax.protocol_axes.insert(name.clone(), d.axes.iter().map(|a| a.name.clone()).collect());
                continue;
            }
            if d.kind == "typealias" {
                if let Some(body) = &d.alias {
                    self.syntax.aliases.insert(name.clone(), AliasRule { parameters: d.parameters.clone(), body: body.clone() });
                }
                continue;
            }
            let mut fields = d.fields.clone();
            let mut body_witness = d.body_witness;
            let mut conditional_axes: HashSet<String> = HashSet::new();
            let empty: Vec<Declaration> = Vec::new();
            let exts = self.extensions.get(&name).unwrap_or(&empty);
            for e in exts {
                if !e.requirements.is_empty() && !e.fields.is_empty() {
                    conditional_axes.extend(e.fields.keys().cloned());
                }
            }
            for e in exts {
                if !e.requirements.is_empty() {
                    continue;
                }
                body_witness = body_witness || e.body_witness;
                if !e.fields.is_empty() {
                    d.unsupported.extend(e.unsupported.iter().cloned());
                }
                let mut sorted: Vec<(&String, &String)> = e.fields.iter().collect();
                sorted.sort();
                for (axis, value) in sorted {
                    if fields.contains_key(axis) {
                        d.unsupported.push(format!("duplicate field {}", axis));
                    }
                    fields.insert(axis.clone(), value.clone());
                }
            }
            let parents: Vec<String> = self.conformance_choices(&name).into_iter().map(|c| c.0).collect();
            for axis in &conditional_axes {
                fields.remove(axis);
            }
            let mut defaults: HashMap<String, (String, String)> = HashMap::new();
            let mut closure: Vec<String> = self.protocol_closure(&parents).into_iter().collect();
            closure.sort();
            for p in closure {
                let axes = match self.declarations.get(&p) {
                    Some(declaration) => declaration.axes.clone(),
                    None => continue,
                };
                for axis in axes {
                    let value = match &axis.fallback {
                        Some(value) if !fields.contains_key(&axis.name) && !conditional_axes.contains(&axis.name) => value.clone(),
                        _ => continue,
                    };
                    if axis.name == "Body" && body_witness {
                        continue;
                    }
                    if let Some(old) = defaults.get(&axis.name) {
                        if old.1 != value {
                            d.unsupported.push(format!("ambiguous default {}", axis.name));
                        }
                    }
                    defaults.insert(axis.name.clone(), (p.clone(), value));
                }
            }
            for (axis, (p, value)) in defaults {
                fields.insert(axis.clone(), value);
                self.default_providers.entry(name.clone()).or_default().insert(axis, p);
            }
            self.syntax.parameters.insert(name.clone(), d.parameters.clone());
            self.syntax.conformers.insert(
                name.clone(),
                Conformer { name: name.clone(), parameters: d.parameters.clone(), protocols: parents, table: fields },
            );
            self.syntax.presented_bodies.insert(name.clone());
            self.declarations.insert(name, d);
        }
    }
}
