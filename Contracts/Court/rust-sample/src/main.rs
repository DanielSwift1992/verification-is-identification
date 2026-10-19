// vi-court: the CLI of the court for the questions suite 0.1. It reads the
// named files, hands them to the library's judgement and writes exactly what
// that judgement answers: stdout, stderr and the exit code the contract binds.

use std::io::Write;

fn main() {
    let arguments: Vec<String> = std::env::args().skip(1).collect();
    let load = |path: &str| std::fs::read_to_string(path).map_err(|error| error.to_string());
    let answer = vi_court::judge_with(&load, &arguments);
    print!("{}", answer.stdout);
    eprint!("{}", answer.stderr);
    let _ = std::io::stdout().flush();
    let _ = std::io::stderr().flush();
    std::process::exit(answer.exit);
}
