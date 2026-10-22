// The browser road. One exported function takes a request as JSON: the pass
// and its arguments the way the CLI takes them, and the texts the named
// sources stand for. It returns the answer as JSON: exit, stdout, stderr. The
// judgement behind it is the one the native binary runs.

use serde::{Deserialize, Serialize};
use wasm_bindgen::prelude::*;

/// A named source: its text, or the reason the caller could not read it.
#[derive(Deserialize)]
struct NamedText {
    name: String,
    #[serde(default)]
    text: Option<String>,
    #[serde(default)]
    error: Option<String>,
}

#[derive(Deserialize)]
struct Request {
    arguments: Vec<String>,
    #[serde(default)]
    files: Vec<NamedText>,
}

#[derive(Serialize)]
struct Response {
    exit: i32,
    stdout: String,
    stderr: String,
}

/// `{"arguments": ["where", "world.swift"], "files": [{"name": "world.swift", "text": "..."}]}`
/// answers `{"exit": 0, "stdout": "...", "stderr": ""}`. A file the caller
/// could not read is given as `{"name": "...", "error": "..."}`. A request that
/// is not of this shape answers exit 2 with the parse error on stderr.
#[wasm_bindgen]
pub fn judge(request: &str) -> String {
    let answer = match serde_json::from_str::<Request>(request) {
        Ok(parsed) => {
            let sources: Vec<(String, Result<String, String>)> = parsed
                .files
                .into_iter()
                .map(|f| match (f.text, f.error) {
                    (Some(text), _) => (f.name, Ok(text)),
                    (None, Some(error)) => (f.name, Err(error)),
                    (None, None) => (f.name, Err("no text and no error were supplied".to_string())),
                })
                .collect();
            crate::judge_sources(&parsed.arguments, &sources)
        }
        Err(error) => crate::Answer { exit: 2, stdout: String::new(), stderr: format!("✗ request: {}\n", error) },
    };
    let response = Response { exit: answer.exit, stdout: answer.stdout, stderr: answer.stderr };
    serde_json::to_string(&response)
        .unwrap_or_else(|_| "{\"exit\":2,\"stdout\":\"\",\"stderr\":\"✗ response could not be encoded\\n\"}".to_string())
}

/// The version of the court this module carries, for the page to show beside its verdicts.
#[wasm_bindgen]
pub fn version() -> String {
    format!("vi-court {} canon v{}", env!("CARGO_PKG_VERSION"), crate::where_judge::CANON_VERSION)
}

/// Import declarations and count question selectors after an edit.
/// This uses the where/count notation reader and establishes no judgement.
#[wasm_bindgen]
pub fn source_notation(request: &str) -> String {
    let read = || -> Result<serde_json::Value, String> {
        #[derive(Deserialize)]
        struct MetadataRequest { files: Vec<NamedText>, questions: Vec<String> }
        let parsed:MetadataRequest=serde_json::from_str(request).map_err(|e|e.to_string())?;
        let selected:std::collections::HashSet<_>=parsed.questions.into_iter().collect();
        let files=parsed.files;
        let mut named = std::collections::BTreeMap::new();
        for file in files {
            let text=file.text.ok_or_else(||format!("{}: {}",file.name,file.error.unwrap_or_else(||"missing source text".into())))?;
            if named.insert(file.name,text).is_some(){return Err("duplicate source input".into());}
        }
        if !selected.iter().all(|name|named.contains_key(name)){return Err("question source is missing".into());}
        let mut lent=std::collections::HashSet::new();
        for text in named.values() {
            if let Ok(clean)=crate::lexical::strip_comments(text,&std::collections::HashSet::new()) {
                lent.extend(crate::lexical::declared_builders(&clean));
            }
        }
        let mut sources=Vec::new();
        for (name,text) in named {
            let imports=crate::court_notation::imports(&text,&lent).map_err(|e|e.messages().join("; "))?;
            let questions=if selected.contains(&name){crate::court_notation::count_questions(&text,&name,&lent).map_err(|e|e.messages().join("; "))?}else{Vec::new()};
            sources.push(serde_json::json!({"input":name,"sha256":crate::digest::sha256(text.as_bytes()), "questions":questions,
                "imports":imports.into_iter().map(|(module,line)|serde_json::json!({"module":module,"line":line})).collect::<Vec<_>>()}));
        }
        Ok(serde_json::json!({"schema":"vi.court.notation/1","sources":sources,"diagnostics":[]}))
    };
    read().unwrap_or_else(|reason|serde_json::json!({"schema":"vi.court.notation/1","sources":[],"diagnostics":[reason]})).to_string()
}
