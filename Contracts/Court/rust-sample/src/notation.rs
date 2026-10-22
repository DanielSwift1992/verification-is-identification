// Lexical ownership for the bounded 0.4 nested-enum fragment. No source rewriting.
use crate::failure::{fail, Failure};
use crate::lexical::{is_word_byte, re, Scope};
use std::collections::{HashMap, HashSet};

#[derive(Clone)]
pub struct Declaration {
    pub kind: String,
    pub name: String,
    pub qualified: String,
    pub start: usize,
    pub open: usize,
    pub close: usize,
    pub header: String,
}
#[derive(Default, Clone)]
pub struct Notation {
    pub declarations: Vec<Declaration>,
    pub nested: HashMap<usize, String>,
    pub namespaces: HashSet<String>,
}
impl Notation {
    pub fn new(clean: &str) -> Result<Self, Failure> {
        let mut result = Self::default();
        let scope = Scope::new(clean);
        let units = clean.as_bytes();
        for hit in re(r"\b(enum|struct|class|actor|protocol)\s+(\w+)[^{}]*\{").captures_iter(clean)
        {
            let whole = hit.get(0).unwrap();
            let start = whole.start();
            let open = whole.end() - 1;
            let kind = hit[1].to_string();
            let name = hit[2].to_string();
            if re(r"(?:\bimport\s*|\.\s*)$").is_match(&clean[..start]) {
                continue;
            }
            if kind=="class" && re(r"^class(?:\s+(?:public|private|fileprivate|internal|package|open|final|override|required|convenience|dynamic|nonisolated))*\s+(?:func|var|let|subscript|init)\b").is_match(&clean[start..open]) { continue; }
            let mut close = open + 1;
            let mut depth = 1;
            while close < units.len() && depth > 0 {
                if units[close] == b'{' {
                    depth += 1;
                }
                if units[close] == b'}' {
                    depth -= 1;
                }
                close += 1;
            }
            if depth != 0 {
                return fail("unterminated declaration body");
            }
            let parents: Vec<&Declaration> = result
                .declarations
                .iter()
                .filter(|p| p.open < start && start < p.close)
                .collect();
            let mut qualified = name.clone();
            if !parents.is_empty() && parents.len() as i64 == scope.depth[start] {
                if !parents
                    .iter()
                    .all(|p| p.kind == "enum" && p.header.trim() == format!("enum {}", p.name))
                {
                    return fail(format!("cannot read line {}: nested declaration '{}' has an unsupported enclosing type",scope.line[start],name));
                }
                qualified = format!("{}.{}", parents.last().unwrap().qualified, name);
                if kind != "enum" {
                    return fail(format!("cannot read line {}: nested {} '{}' is outside the declared notation fragment",scope.line[start],kind,qualified));
                }
                if clean[start..open].contains('<') {
                    return fail(format!("cannot read line {}: nested declaration '{}' has an unsupported enclosing type",scope.line[start],name));
                }
                result.nested.insert(start, qualified.clone());
                result
                    .namespaces
                    .extend(parents.iter().map(|p| p.qualified.clone()));
            }
            result.declarations.push(Declaration {
                kind,
                name,
                qualified,
                start,
                open,
                close,
                header: clean[start..open]
                    .split_whitespace()
                    .collect::<Vec<_>>()
                    .join(" "),
            });
        }
        Ok(result)
    }
    pub fn structural(&self, clean: &str, origin: &str) -> Result<Vec<crate::structural::Declaration>, Failure> {
        let mut result=Vec::new();
        for d in &self.declarations {
            if !["enum","struct","protocol"].contains(&d.kind.as_str()) { continue; }
            let header=crate::structural::tokens(&d.header).map_err(|e|Failure::Unsupported(vec![e.to_string()]))?;
            let body=crate::structural::tokens(&clean[d.open+1..d.close-1]).map_err(|e|Failure::Unsupported(vec![e.to_string()]))?;
            let mut read=crate::structural::declaration(&d.kind,&header[1..],&body,origin).map_err(|e|Failure::Unsupported(vec![e.to_string()]))?;
            let excluded=read.parameters.iter().cloned().chain(read.fields.keys().cloned()).chain(std::iter::once("Self".into())).collect();
            read.name=d.qualified.clone();
            read.fields=read.fields.into_iter().map(|(key,value)|(key,self.resolve(&value,&d.qualified,&excluded))).collect();
            result.push(read);
        }
        Ok(result)
    }
    pub fn resolve(&self, body: &str, owner: &str, excluding: &HashSet<String>) -> String {
        let known: HashSet<&String> = self.nested.values().collect();
        let mut out = body.to_string();
        let hits: Vec<(usize, usize, String)> = re(r"\b\w+\b")
            .find_iter(body)
            .map(|m| (m.start(), m.end(), m.as_str().to_string()))
            .collect();
        for (start, end, word) in hits.into_iter().rev() {
            if excluding.contains(&word)
                || (start > 0
                    && (is_word_byte(body.as_bytes()[start - 1])
                        || body.as_bytes()[start - 1] == b'.'))
            {
                continue;
            }
            let mut parent: Vec<&str> = owner.split('.').collect();
            while !parent.is_empty() {
                let candidate = format!("{}.{}", parent.join("."), word);
                if known.contains(&candidate) {
                    out.replace_range(start..end, &candidate);
                    break;
                }
                parent.pop();
            }
        }
        out
    }
}
pub fn intrinsic(clean: &str) -> Result<bool, Failure> { intrinsic_version(clean,1) }
pub fn intrinsic_version(clean: &str, version: u8) -> Result<bool, Failure> {
    let scope = Scope::new(clean);
    let mut has_swift = false;
    for hit in re(r"\bimport\s+([^\n;]+)").captures_iter(clean) {
        let start = hit.get(0).unwrap().start();
        let spelled = hit[1].trim();
        if spelled == "Swift" && scope.depth[start] == 0 {
            has_swift = true;
        } else if re(r"\bSwift\b").is_match(spelled) {
            return fail(format!(
                "cannot read line {}: this court reads only the plain intrinsic import 'Swift'",
                scope.line[start]
            ));
        }
    }
    for hit in re(r"\bSwift\s*\.\s*(\w+)").captures_iter(clean) {
        let start = hit.get(0).unwrap().start();
        let export = &hit[1];
        if !has_swift {
            return fail(format!(
                "cannot read line {}: 'Swift.{}' requires the declared intrinsic import 'Swift'",
                scope.line[start], export
            ));
        }
        if export != "Never" && !(version==2 && export=="String") {
            return fail(format!(
                "cannot read line {}: 'Swift.{}' is not exported by intrinsic Swift/{}",
                scope.line[start], export, version
            ));
        }
    }
    if has_swift {
        if let Some(hit) =
            re(&format!(r"\b(?:enum|struct|class|actor|protocol|typealias|associatedtype)\s+(Swift|Never{})\b", if version==2 {"|String"} else {""}))
                .captures(clean)
        {
            return fail(format!(
                "cannot read line {}: declaration '{}' conflicts with intrinsic Swift/{}",
                scope.line[hit.get(0).unwrap().start()],
                &hit[1], version
            ));
        }
    }
    Ok(has_swift)
}
