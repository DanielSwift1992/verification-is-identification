// vi-court as a library: the two passes of the questions suite 0.1, `where`
// and `count`, judged over named texts. The courts read their sources through
// a loader the caller supplies, so the same judgement answers from files (the
// CLI in main.rs), from texts held in memory, and from a browser page through
// the wasm module. What a pass prints and how it exits is the same on every
// road; this is what the contract driver and the differential run compare.

pub mod count_court;
pub mod shared_count;
pub mod expression;
pub mod failure;
pub mod lexical;
pub mod notation;
pub mod context;
mod digest;
mod definition_view;
pub mod structural;
pub mod where_judge;
#[cfg(target_arch = "wasm32")]
pub mod wasm;

/// What a pass answered: the exit code and the two output streams, every line
/// ending in a newline, exactly as the CLI writes them.
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct Answer {
    pub exit: i32,
    pub stdout: String,
    pub stderr: String,
}

/// How a court reads a named source: the text, or the reason it is unavailable.
pub type Loader<'a> = &'a dyn Fn(&str) -> Result<String, String>;

pub const USAGE: &str = "usage: vi-court [judge] where <world.swift> [definitions.swift ...]\n       vi-court [judge] count <world.swift> [definitions.swift ...] --predicate <P> --encoding <E> --sigma <S>\n";

/// Judge with CLI-shaped arguments: an optional leading `judge`, then the pass
/// and its arguments. Sources are read through `load`.
pub fn judge_with(load: Loader, arguments: &[String]) -> Answer {
    let mut arguments = arguments.to_vec();
    if arguments.first().map(|a| a == "judge").unwrap_or(false) {
        arguments.remove(0);
    }
    match arguments.first().map(String::as_str) {
        Some("where") => where_judge::answer(load, &arguments[1..]),
        Some("count") => count_court::answer(load, &arguments[1..]),
        _ => Answer { exit: 2, stdout: String::new(), stderr: USAGE.to_string() },
    }
}

/// Judge over texts held in memory. Each argument that names a source is
/// looked up among `files` by that name; the name is also what the court's
/// messages say.
pub fn judge_texts(arguments: &[String], files: &[(String, String)]) -> Answer {
    let sources: Vec<(String, Result<String, String>)> =
        files.iter().map(|(n, t)| (n.clone(), Ok(t.clone()))).collect();
    judge_sources(arguments, &sources)
}

/// Judge over sources a caller already tried to read: each name carries its
/// text, or the reason the caller could not read it, which the court reports
/// the way it reports an unreadable file.
pub fn judge_sources(arguments: &[String], sources: &[(String, Result<String, String>)]) -> Answer {
    let load = |name: &str| -> Result<String, String> {
        match sources.iter().find(|(n, _)| n == name) {
            Some((_, Ok(text))) => Ok(text.clone()),
            Some((_, Err(reason))) => Err(reason.clone()),
            None => Err("No such file or directory (not among the supplied sources)".to_string()),
        }
    };
    judge_with(&load, arguments)
}
