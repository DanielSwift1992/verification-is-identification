#!/usr/bin/env node
// The reference node loader of the wasm court. It speaks the CLI words the
// contract binds (`[judge] where FILE...`, `[judge] count FILE... --predicate
// P --encoding E --sigma S`), reads the named files itself, hands their texts
// to the wasm module and writes back what the court answered: stdout, stderr
// and the exit code. The module is built from this directory's Cargo.toml for
// wasm32-unknown-unknown and bound with wasm-bindgen --target nodejs into
// pkg/node. A caller that already holds the texts (a page, a test) can call
// judge(arguments, files) directly and skip the file system.

const fs = require("fs");
const path = require("path");
const { TextDecoder } = require("util");
// Decode the same UTF-8 byte domain as Rust read_to_string; keep a supplied BOM.
const sourceDecoder = new TextDecoder("utf-8", { fatal: true, ignoreBOM: true });

const OPTIONS_WITH_VALUE = new Set(["--predicate", "--encoding", "--sigma", "--document"]);

// Node lowercases the system message of an I/O error ("ENOENT: no such file or
// directory, open '…'"); the court's line keeps the platform's own text, so the
// common codes are given back their POSIX spelling. Other errors pass as node says them.
const POSIX_TEXT = {
    ENOENT: "No such file or directory",
    EACCES: "Permission denied",
    EISDIR: "Is a directory",
    ENOTDIR: "Not a directory",
};

function sourceArguments(argv) {
    const names = [];
    for (let i = 1; i < argv.length; i++) {
        if (OPTIONS_WITH_VALUE.has(argv[i])) { i++; continue; }
        if (argv[i].startsWith("--")) continue;
        names.push(argv[i]);
    }
    return names;
}

function readSources(names) {
    return names.map((name) => {
        try {
            return { name, text: sourceDecoder.decode(fs.readFileSync(name)) };
        } catch (error) {
            if (error.code === "ERR_ENCODING_INVALID_ENCODED_DATA") {
                return { name, error: "stream did not contain valid UTF-8" };
            }
            const text = POSIX_TEXT[error.code];
            return { name, error: text ? `${text} (${error.code})` : String(error.message) };
        }
    });
}

let courtModule;
function court() {
    if (!courtModule) courtModule = require(path.join(__dirname, "..", "pkg", "node", "vi_court.js"));
    return courtModule;
}

/** Judge with CLI-shaped arguments over files given as {name, text} or {name, error}. */
function judge(argumentsList, files) {
    const args = argumentsList.slice();
    if (args[0] === "judge") args.shift();
    return JSON.parse(court().judge(JSON.stringify({ arguments: args, files })));
}

function main(argv) {
    const args = argv.slice();
    if (args[0] === "judge") args.shift();
    const answer = judge(args, readSources(sourceArguments(args)));
    process.stdout.write(answer.stdout);
    process.stderr.write(answer.stderr);
    return answer.exit;
}

module.exports = { judge, readSources, sourceArguments, version: () => court().version() };

if (require.main === module) {
    process.exitCode = main(process.argv.slice(2));
}
