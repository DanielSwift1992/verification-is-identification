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

pub fn scoped(text:&str,path:&str,lent:&HashSet<String>)->Result<(String,Option<usize>),Failure> {
    let clean=strip_comments(text,lent)?;let units=clean.as_bytes();let mut view=units.to_vec();let mut consumed=0;let mut first=None;
    let pattern=re(r"\b(?:(?:public|private|fileprivate|internal|static|final|override|mutating)\s+)*(func|var|let)\b");
    let scope=crate::lexical::Scope::new(&clean);
    for hit in pattern.captures_iter(&clean) {
        let whole=hit.get(0).unwrap();let start=whole.start();
        if start<consumed || (start>0 && units[start-1]==b'.'){continue;}
        let function=&hit[1]=="func";
        let mut end=whole.end();let mut opened=false;let mut braces=0;let mut brackets=0;
        while end<units.len(){
            let c=units[end];
            if c==b'{'{opened=true;braces+=1;}
            if c==b'}'{if !opened{break;}braces-=1;if braces==0{end+=1;break;}}
            if !opened {
                if c==b'(' || c==b'['{brackets+=1;}
                if c==b')' || c==b']'{brackets-=1;}
                if brackets==0 && c==b';'{break;}
                if brackets==0 && c==b'\n'{if !function || re(r"^\s*(?:(?:public|private|static)\s+)*(?:enum|struct|class|protocol|extension|typealias|associatedtype|func|var|let|\})\b").is_match(&clean[end+1..]){break;}}
            }
            end+=1;
        }
        if braces!=0{return fail(format!("cannot read line {} of '{}': unclosed implementation body",scope.line[start],path));}
        let declaring=re(r"\b(?:enum|struct|class|actor|protocol|extension|typealias|associatedtype)\s+\w+");
        if declaring.find_iter(&clean[start..end]).any(|m|m.start()==0 || units[start+m.start()-1]!=b'.') {return fail(format!("cannot read line {} of '{}': a value declaration contains a type declaration outside the supported binding scope",scope.line[start],path));}
        if first.is_none(){first=Some(scope.line[start]);}
        for c in &mut view[start..end]{if *c!=b'\n'{*c=b' ';}}consumed=end;
    }
    Ok((String::from_utf8(view).unwrap(),first))
}
