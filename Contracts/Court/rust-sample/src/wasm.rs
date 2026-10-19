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
