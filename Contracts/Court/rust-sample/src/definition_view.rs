// Owner-side declaration view, made after context byte binding. No methods run.
use crate::failure::{fail, Failure};
use crate::lexical::{re, source_lines, strip_comments};
use std::collections::HashSet;
pub fn read(
    text: &str,
    path: &str,
    lent: &HashSet<String>,
) -> Result<(String, Option<usize>), Failure> {
    let stripped = strip_comments(text, lent)?;
    let clean: Vec<&str> = stripped.split('\n').collect();
    let mut lines: Vec<String> = source_lines(text).split('\n').map(str::to_string).collect();
    let value = re(
        r"^\s*(?:(?:public|private|fileprivate|internal|static|final|override|mutating)\s+)*(?:func|var|let)\b",
    );
    let declaring =
        re(r"\b(?:enum|struct|class|actor|protocol|extension|typealias|associatedtype)\s+\w+");
    let next = re(
        r"^\s*(?:(?:public|private|fileprivate|internal|static)\s+)*(?:enum|struct|class|protocol|extension|typealias|associatedtype|func|var|let)\b",
    );
    let mut i = 0;
    let mut first = None;
    while i < clean.len() {
        if !value.is_match(clean[i]) {
            i += 1;
            continue;
        }
        let start = i;
        let mut depth = 0i64;
        let mut opened = false;
        if first.is_none() {
            first = Some(i + 1);
        }
        loop {
            if declaring
                .find_iter(clean[i])
                .any(|m| m.start() == 0 || clean[i].as_bytes()[m.start() - 1] != b'.')
            {
                return fail(format!("cannot read line {} of '{}': a value declaration contains a type declaration outside the supported binding scope",i+1,path));
            }
            for (at, c) in clean[i].char_indices() {
                if c == '{' {
                    depth += 1;
                    opened = true;
                }
                if c == '}' {
                    depth -= 1;
                    if opened && depth == 0 && !clean[i][at + c.len_utf8()..].trim().is_empty() {
                        return fail(format!(
                            "cannot read line {} of '{}': declaration after an implementation body",
                            i + 1,
                            path
                        ));
                    }
                }
            }
            if depth < 0 {
                return fail(format!(
                    "cannot read line {} of '{}': declaration boundary",
                    i + 1,
                    path
                ));
            }
            lines[i].clear();
            i += 1;
            if opened && depth == 0 {
                break;
            }
            if !opened && i < clean.len() && next.is_match(clean[i]) {
                break;
            }
            if !opened
                && (!clean[start].contains("func") || i == clean.len() || clean[i].trim() == "}")
            {
                break;
            }
            if i >= clean.len() {
                break;
            }
        }
        if depth != 0 {
            return fail(format!(
                "cannot read line {} of '{}': unclosed implementation body",
                start + 1,
                path
            ));
        }
    }
    Ok((lines.join("\n"), first))
}
