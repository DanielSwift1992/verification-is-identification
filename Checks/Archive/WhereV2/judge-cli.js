#!/usr/bin/env node
// CLI for the frozen where-only reader; no external checkout or fallback.
const { runWhere } = require("./judge-where.js");
const args = process.argv.slice(2);
if (args.shift() !== "judge" || args.shift() !== "where") {
    process.stderr.write("archive usage: judge where FILE [DEFINITIONS...]\n");
    process.exitCode = 2;
} else process.exitCode = runWhere(args);
