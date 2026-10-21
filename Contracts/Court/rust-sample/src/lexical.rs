// The lexical scan of the where court, ported from the reading half of
// Sources/Court/WhereJudge.swift: comments and string contents are blanked,
// conditional blocks under a plain flag are omitted, braces give each offset a
// depth and a line, and type bodies are told from other bodies. Offsets here are
// byte offsets into the read text; the Swift reader counts UTF-16 units. Both
// place a boundary only between a word and a non-word, so the texts they cut
// out are the same.

use crate::failure::{fail, Failure};
use regex::Regex;
use std::collections::{HashMap, HashSet};

pub fn re(pattern: &str) -> Regex {
    Regex::new(&format!("(?s){}", pattern)).expect("a pattern of this reader compiles")
}

pub fn captures(pattern: &str, text: &str) -> Vec<Vec<String>> {
    let regex = re(pattern);
    regex
        .captures_iter(text)
        .map(|c| (1..c.len()).map(|i| c.get(i).map(|m| m.as_str().to_string()).unwrap_or_default()).collect())
        .collect()
}

pub fn is_word_byte(unit: u8) -> bool {
    unit.is_ascii_alphanumeric() || unit == b'_' || unit >= 0x80
}

pub fn is_space_byte(unit: u8) -> bool {
    unit == 0x20 || (0x09..=0x0D).contains(&unit)
}

/// The ASCII operator signs this reader accepts in a function name.
pub fn is_operator_byte(unit: u8) -> bool {
    matches!(
        unit,
        b'/' | b'=' | b'-' | b'+' | b'!' | b'*' | b'%' | b'<' | b'>' | b'&' | b'|' | b'^' | b'~' | b'?' | b'.'
    )
}

pub fn spelled_lines(lines: &[usize]) -> String {
    let spelled: Vec<String> = lines.iter().map(|l| l.to_string()).collect();
    if spelled.len() <= 1 {
        return format!("line {}", spelled.first().cloned().unwrap_or_default());
    }
    format!(
        "lines {} and {}",
        spelled[..spelled.len() - 1].join(", "),
        spelled[spelled.len() - 1]
    )
}

const DIRECTIVES: &[&str] = &[
    "if", "elseif", "else", "endif", "sourceLocation", "warning", "error", "available", "unavailable", "selector",
    "keyPath", "file", "fileID", "filePath", "line", "column", "function", "dsohandle", "isolation",
    "colorLiteral", "imageLiteral", "fileLiteral",
];

const ATTRIBUTES: &[&str] = &[
    "available", "frozen", "inlinable", "usableFromInline", "discardableResult", "inline", "retroactive",
    "preconcurrency", "unchecked", "escaping", "autoclosure", "Sendable", "MainActor", "objc", "nonobjc",
    "testable", "main", "unknown", "convention", "propertyWrapper", "resultBuilder", "dynamicMemberLookup",
    "dynamicCallable", "warn_unqualified_access", "_disfavoredOverload", "_exported", "_implementationOnly",
    "_spi", "_alwaysEmitIntoClient", "_transparent",
];

enum Context {
    Code { interpolated: bool, parentheses: usize },
    Comment { depth: usize },
    Str { hashes: usize, multiline: bool },
}

// The owner's source-line view: only LF, CRLF and CR are Swift line breaks.
// Do not promote other Unicode whitespace into a comment terminator.
pub fn source_lines(text: &str) -> String {
    text.replace("\r\n", "\n").replace('\r', "\n")
}

/// A comment states nothing, and a string states no declaration. A line comment
/// is dropped, a block comment reads as a space, a string keeps its delimiters
/// and its interpolations' code, and every form keeps its line breaks.
pub fn blank_comments_and_strings(text: &str, lent: &HashSet<String>) -> Result<String, Failure> {
    let scalars: Vec<char> = source_lines(text).chars().collect();
    let mut kept = String::with_capacity(text.len());
    let mut stack: Vec<Context> = vec![Context::Code { interpolated: false, parentheses: 0 }];
    let mut index = 0usize;
    let mut line = 1usize;
    let mut unread_attributes: Vec<(String, usize)> = Vec::new();

    let scalar = |index: usize, offset: usize| -> Option<char> { scalars.get(index + offset).copied() };
    let repeats = |index: usize, mark: char, from: usize, count: usize| -> bool {
        (0..count).all(|k| scalar(index, from + k) == Some(mark))
    };
    let name_after = |index: usize, offset: usize| -> String {
        let mut spelled = String::new();
        while let Some(next) = scalar(index, offset + spelled.chars().count()) {
            if next == '_'
                || next.is_ascii_lowercase()
                || next.is_ascii_uppercase()
                || (!spelled.is_empty() && next.is_ascii_digit())
            {
                spelled.push(next);
            } else {
                break;
            }
        }
        spelled
    };

    while index < scalars.len() {
        let current = scalars[index];
        let top = stack.len() - 1;
        match stack[top] {
            Context::Comment { depth } => {
                if current == '/' && scalar(index, 1) == Some('*') {
                    stack[top] = Context::Comment { depth: depth + 1 };
                    index += 2;
                } else if current == '*' && scalar(index, 1) == Some('/') {
                    if depth == 1 {
                        stack.pop();
                    } else {
                        stack[top] = Context::Comment { depth: depth - 1 };
                    }
                    index += 2;
                } else {
                    if current == '\n' {
                        kept.push('\n');
                        line += 1;
                    }
                    index += 1;
                }
            }
            Context::Str { hashes, multiline } => {
                let quotes = if multiline { 3 } else { 1 };
                if current == '\\' && repeats(index, '#', 1, hashes) {
                    if scalar(index, 1 + hashes) == Some('(') {
                        kept.push('(');
                        stack.push(Context::Code { interpolated: true, parentheses: 0 });
                    } else if scalar(index, 1 + hashes) == Some('\n') {
                        kept.push('\n');
                        line += 1;
                    }
                    index += 2 + hashes;
                } else if repeats(index, '"', 0, quotes) && repeats(index, '#', quotes, hashes) {
                    stack.pop();
                    for k in 0..(quotes + hashes) {
                        kept.push(scalars[index + k]);
                    }
                    index += quotes + hashes;
                } else if current == '\n' && !multiline {
                    return fail("unterminated string literal");
                } else {
                    if current == '\n' {
                        kept.push('\n');
                        line += 1;
                    }
                    index += 1;
                }
            }
            Context::Code { interpolated, parentheses } => {
                if current == '/' && scalar(index, 1) == Some('/') {
                    while index < scalars.len() && scalars[index] != '\n' {
                        index += 1;
                    }
                } else if current == '/' && scalar(index, 1) == Some('*') {
                    kept.push(' ');
                    stack.push(Context::Comment { depth: 1 });
                    index += 2;
                } else if current == '/' {
                    match scalar(index, 1) {
                        Some(' ') | Some('\t') | Some('\n') | Some('\r') => {
                            kept.push(current);
                            index += 1;
                        }
                        _ => {
                            return fail(format!(
                                "cannot read line {}: a slash with no whitespace after it may open a regular \
                                 expression literal, which this court does not read",
                                line
                            ))
                        }
                    }
                } else if current == '#' || current == '"' {
                    let mut hashes = 0;
                    while scalar(index, hashes) == Some('#') {
                        hashes += 1;
                    }
                    if scalar(index, hashes) == Some('"') {
                        let multiline = repeats(index, '"', hashes, 3);
                        stack.push(Context::Str { hashes, multiline });
                        let width = hashes + if multiline { 3 } else { 1 };
                        for k in 0..width {
                            kept.push(scalars[index + k]);
                        }
                        index += width;
                    } else if scalar(index, hashes) == Some('/') {
                        return fail(format!(
                            "cannot read line {}: a regular expression literal is not among the forms this court reads",
                            line
                        ));
                    } else {
                        let spelled = name_after(index, 1);
                        if !DIRECTIVES.contains(&spelled.as_str()) {
                            return fail(format!(
                                "cannot read line {}: the macro '#{}' is not among the forms this court reads",
                                line, spelled
                            ));
                        }
                        kept.push(current);
                        index += 1;
                    }
                } else if current == '@' {
                    let spelled = name_after(index, 1);
                    if !ATTRIBUTES.contains(&spelled.as_str()) {
                        unread_attributes.push((spelled, line));
                    }
                    kept.push(current);
                    index += 1;
                } else if current == '`' {
                    return fail(format!(
                        "cannot read line {}: a backquoted identifier is not among the forms this court reads",
                        line
                    ));
                } else if current == '\n' {
                    kept.push('\n');
                    line += 1;
                    index += 1;
                } else if interpolated && current == '(' {
                    stack[top] = Context::Code { interpolated: true, parentheses: parentheses + 1 };
                    kept.push(current);
                    index += 1;
                } else if interpolated && current == ')' {
                    if parentheses == 0 {
                        stack.pop();
                    } else {
                        stack[top] = Context::Code { interpolated: true, parentheses: parentheses - 1 };
                    }
                    kept.push(current);
                    index += 1;
                } else {
                    kept.push(current);
                    index += 1;
                }
            }
        }
    }
    match stack[stack.len() - 1] {
        Context::Comment { .. } => return fail("unterminated block comment"),
        Context::Str { .. } => return fail("unterminated string literal"),
        Context::Code { interpolated, .. } => {
            if interpolated {
                return fail("unterminated string interpolation");
            }
        }
    }
    let declared = declared_builders(&kept);
    // A name this text declares as a macro is this text's macro: a lent
    // builder of the same name says nothing about it, so it is not lent.
    let macro_word = re(r"\bmacro\s+(\w+)");
    let bytes = kept.as_bytes();
    let shadowed: HashSet<String> = macro_word
        .captures_iter(&kept)
        .filter(|c| {
            let start = c.get(0).unwrap().start();
            start == 0 || bytes[start - 1] != b'.'
        })
        .map(|c| c[1].to_string())
        .collect();
    if let Some((name, at)) = unread_attributes
        .iter()
        .find(|(name, _)| !declared.contains(name) && (!lent.contains(name) || shadowed.contains(name)))
    {
        return fail(format!(
            "cannot read line {}: the attribute '@{}' is not among the forms this court reads",
            at, name
        ));
    }
    Ok(kept)
}

/// The names a read text declares as a result builder or a property wrapper,
/// with other attributes and modifiers allowed between the declaring attribute
/// and the type. An attribute of such a name adds no conformance, so it is a
/// form this court reads, in the text that declares it and in a world that
/// text is lent to.
pub fn declared_builders(read: &str) -> HashSet<String> {
    captures(
        r"@(?:resultBuilder|propertyWrapper)\s+(?:(?:@\w+(?:\([^()]*\))?|public|internal|fileprivate|private|package|open|final|indirect)\s+)*(?:struct|enum|class|actor)\s+(\w+)",
        read,
    )
    .into_iter()
    .map(|c| c[0].clone())
    .collect()
}

/// Conditional compilation is outside this court's scope. A block under a
/// plain flag is omitted whole, its lines kept empty; any other condition or
/// branch is refused at its line.
pub fn strip_comments(text: &str, lent: &HashSet<String>) -> Result<String, Failure> {
    let blanked = blank_comments_and_strings(text, lent)?;
    let plain_flag = re(r"^#if\s+([A-Za-z_][A-Za-z0-9_]*)$");
    let mut flagged_depth = 0usize;
    let mut kept: Vec<String> = Vec::new();
    for (index, line) in blanked.split('\n').enumerate() {
        let bare = line.trim_matches(|c| c == ' ' || c == '\t');
        if bare.starts_with("#if") && !bare[3..].starts_with(|c: char| c.is_alphanumeric() || c == '_') {
            let plain = plain_flag.captures(bare).map(|c| c[1].to_string()).filter(|n| n != "true");
            if flagged_depth == 0 && plain.is_none() {
                return fail(format!(
                    "cannot read line {}: '{}' is not a plain compilation flag, and this court omits only a block a \
                     compilation without its flag skips",
                    index + 1,
                    bare
                ));
            }
            flagged_depth += 1;
            kept.push(String::new());
            continue;
        }
        if bare.starts_with("#endif") && !bare[6..].starts_with(|c: char| c.is_alphanumeric() || c == '_') {
            if flagged_depth == 0 {
                return fail("unmatched #endif");
            }
            flagged_depth -= 1;
            kept.push(String::new());
            continue;
        }
        let branch = (bare.starts_with("#else") && !bare[5..].starts_with(|c: char| c.is_alphanumeric() || c == '_'))
            || (bare.starts_with("#elseif") && !bare[7..].starts_with(|c: char| c.is_alphanumeric() || c == '_'));
        if branch {
            if flagged_depth == 0 {
                return fail("conditional branch outside #if");
            }
            if flagged_depth == 1 {
                return fail(format!(
                    "cannot read line {}: '{}' opens a branch a compilation without the flag reads, and this court \
                     omits only a block that compilation skips",
                    index + 1,
                    bare
                ));
            }
            kept.push(String::new());
            continue;
        }
        kept.push(if flagged_depth > 0 { String::new() } else { line.to_string() });
    }
    if flagged_depth != 0 {
        return fail("unterminated #if block");
    }
    Ok(kept.join("\n"))
}

/// The brace depth and the line before each byte offset of the read text.
pub struct Scope {
    pub depth: Vec<i64>,
    pub line: Vec<usize>,
}

impl Scope {
    pub fn new(text: &str) -> Scope {
        let mut depth = vec![0i64];
        let mut line = vec![1usize];
        for unit in text.bytes() {
            let last_depth = depth[depth.len() - 1];
            depth.push(last_depth + if unit == b'{' { 1 } else if unit == b'}' { -1 } else { 0 });
            let last_line = line[line.len() - 1];
            line.push(last_line + if unit == b'\n' { 1 } else { 0 });
        }
        Scope { depth, line }
    }
}

const TYPE_KEYWORDS: &[&str] = &["extension", "enum", "struct", "class", "actor", "protocol"];

/// The keywords of a header, read as they are written: a keyword after a dot
/// is a member's name, and `actor` is a keyword only before a name.
fn header_words(header: &str) -> Vec<String> {
    let keyword = re(
        r"\b(extension|enum|struct|class|actor|protocol|func|init|deinit|subscript|var|let|get|set|willSet|didSet|if|else|for|while|switch|case|default|do|catch|guard|defer)\b",
    );
    let after_actor = re(r"^\s+[A-Za-z_]");
    let bytes = header.as_bytes();
    let mut words = Vec::new();
    for m in keyword.find_iter(header) {
        if m.start() > 0 && bytes[m.start() - 1] == b'.' {
            continue;
        }
        let word = m.as_str();
        if word == "actor" && !after_actor.is_match(&header[m.end()..]) {
            continue;
        }
        words.push(word.to_string());
    }
    words
}

/// The kind an import names declares nothing, and `class` before a member's
/// keyword is that member's modifier; both read as a space.
fn without_non_declaring(header: &str) -> String {
    let import = re(r"\bimport\s+(?:struct|class|enum|protocol|typealias|func|var|let)\b");
    let class_word = re(r"\bclass\b");
    let member = re(
        r"^(?:\s+(?:public|private|fileprivate|internal|package|open|final|override|required|convenience|dynamic|nonisolated))*\s+(?:func|var|let|subscript|init)\b",
    );
    let mut cuts: Vec<(usize, usize)> = import.find_iter(header).map(|m| (m.start(), m.end())).collect();
    for m in class_word.find_iter(header) {
        if member.is_match(&header[m.end()..]) {
            cuts.push((m.start(), m.end()));
        }
    }
    cuts.sort();
    let mut out = String::new();
    let mut cursor = 0;
    for (start, end) in cuts {
        if start < cursor {
            continue;
        }
        out.push_str(&header[cursor..start]);
        out.push(' ');
        cursor = end;
    }
    out.push_str(&header[cursor..]);
    out
}

/// The text outside every bracket of a header region, or None when the
/// brackets cannot be placed. A `<` is generic only when bound to the word
/// before it and not the start of an operator; the `>` of an arrow closes none.
pub fn outside_brackets(units: &[u8]) -> Option<Vec<u8>> {
    let mut open: Vec<u8> = Vec::new();
    let mut flat: Vec<u8> = Vec::new();
    for (index, &unit) in units.iter().enumerate() {
        let before = if index > 0 { units[index - 1] } else { b' ' };
        let after = if index + 1 < units.len() { units[index + 1] } else { b' ' };
        if unit == b'(' || unit == b'[' || (unit == b'<' && is_word_byte(before) && after != b'=' && after != b'<') {
            open.push(unit);
        } else if unit == b')' || unit == b']' {
            while open.last() == Some(&b'<') {
                open.pop();
            }
            match open.pop() {
                Some(last) if last == (if unit == b')' { b'(' } else { b'[' }) => {}
                _ => return None,
            }
        } else if unit == b'>' && before != b'-' && open.last() == Some(&b'<') {
            open.pop();
        } else if open.is_empty() {
            flat.push(unit);
        }
    }
    if open.is_empty() {
        Some(flat)
    } else {
        None
    }
}

/// For each byte offset of the read text, the number of type or extension
/// bodies around it.
pub fn type_bodies(text: &str) -> Result<Vec<i64>, Failure> {
    let units = text.as_bytes();
    let mut depth: Vec<i64> = vec![0];
    let mut opened: Vec<bool> = Vec::new();
    let mut segment_start = 0usize;
    let mut line = 1usize;
    for (offset, &unit) in units.iter().enumerate() {
        let mut current = depth[depth.len() - 1];
        if unit == b'\n' {
            line += 1;
        }
        if unit == b'{' {
            let spelled = &text[segment_start..offset];
            let header = without_non_declaring(spelled);
            let mut is_type = false;
            let named: Vec<String> =
                header_words(&header).into_iter().filter(|w| TYPE_KEYWORDS.contains(&w.as_str())).collect();
            if !named.is_empty() {
                let outside = outside_brackets(header.as_bytes());
                let flat = outside.as_ref().map(|o| String::from_utf8_lossy(o).to_string()).unwrap_or_default();
                let loops = flat.trim().ends_with("repeat");
                let last = header_words(&flat).last().cloned().unwrap_or_default();
                is_type = outside.is_some() && !loops && TYPE_KEYWORDS.contains(&last.as_str());
                if !is_type {
                    return fail(format!(
                        "cannot read line {}: this court cannot tell whether the body opened here belongs to a type \
                         or an extension",
                        line
                    ));
                }
            }
            opened.push(is_type);
            if is_type {
                current += 1;
            }
            segment_start = offset + 1;
        } else if unit == b'}' {
            if let Some(was_type) = opened.pop() {
                if was_type {
                    current -= 1;
                }
            }
            segment_start = offset + 1;
        } else if unit == b';' {
            segment_start = offset + 1;
        }
        depth.push(current);
    }
    Ok(depth)
}

/// The names a generic parameter list declares, split at its top-level commas.
pub fn parameter_names(list: &str) -> Vec<String> {
    if list.is_empty() {
        return Vec::new();
    }
    let mut names = Vec::new();
    let mut depth = 0i64;
    let mut piece = String::new();
    let mut previous = ' ';
    for character in list.chars() {
        if character == '<' {
            depth += 1;
        }
        if character == '>' && previous != '-' {
            depth -= 1;
        }
        previous = character;
        if character == ',' && depth == 0 {
            names.push(std::mem::take(&mut piece));
        } else {
            piece.push(character);
        }
    }
    names.push(piece);
    names
        .into_iter()
        .map(|piece| piece.split(':').next().unwrap_or("").trim().to_string())
        .collect()
}

pub struct AliasSpan {
    /// name, parameter list, right side, "where" when conditional
    pub fields: [String; 4],
    pub body: (usize, usize),
    pub declaration: (usize, usize),
}

/// A line break inside generic arguments does not end a typealias; an
/// unbalanced right side is a reader failure, never a truncated type.
pub fn read_alias_spans(text: &str) -> Result<Vec<AliasSpan>, Failure> {
    let header = re(r"typealias\s+(\w+)\s*(?:<([^>]*)>)?\s*=\s*");
    let dot_spaces = re(r"\s*\.\s*");
    let spaces = re(r"\s+");
    let where_word = re(r"\bwhere\b");
    let where_start = re(r"^where\b");
    let bytes = text.as_bytes();
    let mut result = Vec::new();
    let mut cursor = 0usize;
    while cursor < text.len() {
        let m = match header.captures_at(text, cursor) {
            Some(m) => m,
            None => break,
        };
        let whole = m.get(0).unwrap();
        let name = m.get(1).unwrap().as_str().to_string();
        let parameters = m.get(2).map(|p| p.as_str().to_string()).unwrap_or_default();
        let start = whole.end();
        let mut end = start;
        let mut depth = 0i64;
        while end < bytes.len() {
            let character = bytes[end];
            if character == b'<' {
                depth += 1;
            }
            if character == b'>' {
                depth -= 1;
                if depth < 0 {
                    return fail(format!("cannot read typealias '{}': unbalanced generic arguments", name));
                }
            }
            if character == b'{' || character == b'}' || character == b';' {
                break;
            }
            if character == b'\n' && depth == 0 {
                let following = text[end + 1..].trim_start();
                if !following.starts_with('.') {
                    break;
                }
            }
            end += 1;
        }
        if depth != 0 {
            return fail(format!("cannot read typealias '{}': unbalanced generic arguments", name));
        }
        let body = text[start..end].trim();
        let body = dot_spaces.replace_all(body, ".").to_string();
        let body = spaces.replace_all(&body, " ").to_string();
        if body.is_empty() {
            return fail(format!("cannot read typealias '{}': empty right side", name));
        }
        let tail = text[end..].trim();
        let conditional = where_word.is_match(&body) || where_start.is_match(tail);
        result.push(AliasSpan {
            fields: [name, parameters, body, if conditional { "where".to_string() } else { String::new() }],
            body: (start, end),
            declaration: (whole.start(), whole.end()),
        });
        cursor = end;
    }
    Ok(result)
}

/// Member aliases belong to their declaration. A body's text becomes one
/// space per byte, so what stands outside keeps the read text's coordinates.
pub fn outside_bodies(text: &str) -> Result<String, Failure> {
    let mut depth = 0i64;
    let mut result: Vec<u8> = Vec::with_capacity(text.len());
    for &unit in text.as_bytes() {
        if unit == b'{' {
            depth += 1;
        }
        result.push(if depth == 0 || unit == b'\n' { unit } else { b' ' });
        if unit == b'}' {
            depth -= 1;
        }
        if depth < 0 {
            return fail("unmatched declaration brace");
        }
    }
    if depth != 0 {
        return fail("unterminated declaration body");
    }
    Ok(String::from_utf8(result).expect("spaces replace whole bytes of the read text"))
}

/// A gate's where carries three kinds of conjunct: an equality, a membership
/// of a bare protocol name, and anything else, which is named at its gate.
pub fn split_conjuncts(clause: &str) -> Result<(Vec<(String, String)>, Vec<(String, String)>, Vec<String>), Failure> {
    let mut parts: Vec<String> = Vec::new();
    let mut depth = 0i64;
    let mut piece = String::new();
    let mut previous = ' ';
    for character in clause.chars() {
        if character == '<' {
            depth += 1;
        }
        if character == '>' && previous != '-' {
            depth -= 1;
        }
        previous = character;
        if character == ',' && depth == 0 {
            parts.push(std::mem::take(&mut piece));
        } else {
            piece.push(character);
        }
    }
    parts.push(piece);
    let bare_name = re(r"^\w+$");
    let mut equalities = Vec::new();
    let mut memberships = Vec::new();
    let mut unjudged = Vec::new();
    for part in parts {
        let bare = part.trim();
        if bare.is_empty() {
            continue;
        }
        if bare.contains("->") {
            return fail(format!(
                "cannot read the where clause conjunct '{}': a function type is a term this court does not read",
                bare
            ));
        }
        let sides: Vec<&str> = part.split("==").collect();
        if sides.len() == 2 {
            equalities.push((sides[0].trim().to_string(), sides[1].trim().to_string()));
            continue;
        }
        let claim: Vec<&str> = bare.split(':').collect();
        if claim.len() == 2 {
            let lhs = claim[0].trim();
            let proto = claim[1].trim();
            if !lhs.is_empty() && bare_name.is_match(proto) {
                memberships.push((lhs.to_string(), proto.to_string()));
                continue;
            }
        }
        unjudged.push(bare.to_string());
    }
    Ok((equalities, memberships, unjudged))
}

/// The captures of a declaration read at file scope: the pattern begins at the
/// declaring keyword, and its first group is the declared name.
pub fn declarations(pattern: &str, text: &str, scope: &Scope) -> Result<Vec<Vec<String>>, Failure> {
    let regex = re(pattern);
    let mut result = Vec::new();
    for m in regex.captures_iter(text) {
        let whole = m.get(0).unwrap();
        let groups: Vec<String> =
            (1..m.len()).map(|i| m.get(i).map(|g| g.as_str().to_string()).unwrap_or_default()).collect();
        if scope.depth[whole.start()] > 0 {
            let keyword: String = whole.as_str().chars().take_while(|c| !c.is_whitespace()).collect();
            return fail(format!(
                "cannot read line {}: the {} '{}' is declared inside a body, and this court reads declarations at \
                 file scope",
                scope.line[whole.start()],
                keyword,
                groups[0]
            ));
        }
        result.push(groups);
    }
    Ok(result)
}

/// The group ranges of the same declarations, for a reader that must know
/// where each group stands.
pub fn declaration_spans(pattern: &str, text: &str, scope: &Scope) -> Result<Vec<Vec<Option<(usize, usize)>>>, Failure> {
    declarations(pattern, text, scope)?;
    let regex = re(pattern);
    Ok(regex
        .captures_iter(text)
        .map(|m| (1..m.len()).map(|i| m.get(i).map(|g| (g.start(), g.end()))).collect())
        .collect())
}

/// Every declaration of a name, in any scope and of any form, and the names
/// this reader reads at file scope.
pub fn declared_names(text: &str, scope: &Scope) -> Result<(HashMap<String, Vec<usize>>, HashSet<String>), Failure> {
    let mut lines: HashMap<String, Vec<usize>> = HashMap::new();
    let mut file = HashSet::new();
    let nominal = re(r"\b(enum|struct|class|actor|protocol|typealias|associatedtype)\s+(\w+)");
    for m in nominal.captures_iter(text) {
        let kind = m.get(1).unwrap().as_str();
        let name = m.get(2).unwrap().as_str();
        let start = m.get(0).unwrap().start();
        lines.entry(name.to_string()).or_default().push(scope.line[start]);
        if scope.depth[start] == 0 && ["enum", "protocol", "typealias"].contains(&kind) {
            file.insert(name.to_string());
        }
    }
    let declaring = re(r"\b(func|enum|struct|class|actor|typealias|init|subscript)\b");
    let modifying: &[&str] = &[
        "func", "var", "let", "subscript", "init", "deinit", "static", "final", "override", "required", "convenience",
        "dynamic", "nonisolated", "public", "private", "fileprivate", "internal", "package", "open",
    ];
    let units = text.as_bytes();
    for m in declaring.captures_iter(text) {
        let whole = m.get(0).unwrap();
        if whole.start() > 0 && units[whole.start() - 1] == b'.' {
            continue;
        }
        let kind = m.get(1).unwrap().as_str();
        let mut cursor = whole.end();
        if kind == "init" && cursor < units.len() && (units[cursor] == b'?' || units[cursor] == b'!') {
            cursor += 1;
        }
        if kind != "init" && kind != "subscript" {
            while cursor < units.len() && is_space_byte(units[cursor]) {
                cursor += 1;
            }
            let name_start = cursor;
            if kind == "func" && cursor < units.len() && !is_word_byte(units[cursor]) {
                while cursor < units.len() && is_operator_byte(units[cursor]) {
                    cursor += 1;
                }
                let mut next = cursor;
                while next < units.len() && is_space_byte(units[next]) {
                    next += 1;
                }
                if cursor - name_start > 1 && units[cursor - 1] == b'<' && next < units.len() && is_word_byte(units[next]) {
                    cursor -= 1;
                }
            } else {
                while cursor < units.len() && is_word_byte(units[cursor]) {
                    cursor += 1;
                }
            }
            let name = &text[name_start..cursor];
            if kind == "class" && (name.is_empty() || modifying.contains(&name)) {
                continue;
            }
            if kind == "actor" && name.is_empty() {
                continue;
            }
            if name.is_empty() {
                return fail(format!(
                    "cannot read line {}: the name this {} declares is not one this court reads",
                    scope.line[whole.start()],
                    kind
                ));
            }
        }
        while cursor < units.len() && is_space_byte(units[cursor]) {
            cursor += 1;
        }
        if kind == "func" && (cursor == units.len() || (units[cursor] != b'<' && units[cursor] != b'(')) {
            return fail(format!(
                "cannot read line {}: the function name is not followed by a parameter list this court reads",
                scope.line[whole.start()]
            ));
        }
        if cursor >= units.len() || units[cursor] != b'<' {
            continue;
        }
        let start = cursor + 1;
        let mut depth = 1i64;
        let mut end = start;
        while end < units.len() && depth > 0 {
            let unit = units[end];
            if unit == b'{' || unit == b'}' || unit == b';' {
                break;
            }
            if unit == b'<' {
                depth += 1;
            }
            if unit == b'>' && (end == 0 || units[end - 1] != b'-') {
                depth -= 1;
            }
            end += 1;
        }
        if depth != 0 {
            return fail(format!(
                "cannot read line {}: its generic parameter list does not close where this court can read it",
                scope.line[whole.start()]
            ));
        }
        let list = &text[start..end - 1];
        for parameter in parameter_names(list) {
            let bare = parameter.split_whitespace().last().unwrap_or(&parameter).to_string();
            lines.entry(bare).or_default().push(scope.line[start]);
        }
    }
    for value in lines.values_mut() {
        value.sort();
    }
    Ok((lines, file))
}
