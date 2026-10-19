// vi-court: a replacement implementation of the court CLI for the questions
// suite 0.1 (Contracts/Court/v0.1). It exposes the two passes the driver
// appends, `where` and `count`, reads the same bare Swift declarations and
// answers with the same exit codes and addressed text. Passing that finite
// suite is what this binary claims; general equivalence with the Swift court
// is not established by it.

mod count_court;
mod expression;
mod failure;
mod lexical;
mod structural;
mod where_judge;

fn main() {
    let mut arguments: Vec<String> = std::env::args().skip(1).collect();
    if arguments.first().map(|a| a == "judge").unwrap_or(false) {
        arguments.remove(0);
    }
    let code = match arguments.first().map(String::as_str) {
        Some("where") => where_judge::run(&arguments[1..]),
        Some("count") => count_court::run(&arguments[1..]),
        _ => {
            eprintln!("usage: vi-court [judge] where <world.swift> [definitions.swift ...]");
            eprintln!(
                "       vi-court [judge] count <world.swift> [definitions.swift ...] --predicate <P> --encoding <E> --sigma <S>"
            );
            2
        }
    };
    std::process::exit(code);
}
