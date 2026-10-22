// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";

// A test adapter for the existing gate court, not another equality checker.
// The selected flat definitions are carried verbatim from their current files.
const fs = require("node:fs");
const path = require("node:path");
const assert = require("node:assert/strict");
const os = require("node:os");
const { spawnSync } = require("node:child_process");
const root = path.resolve(__dirname, "..");
const judgePath = path.join(root, "Checks/Archive/WhereV2/judge-where.js");
const nativePath = process.argv[2];
const { judgeWhereTexts } = require(path.resolve(judgePath));

function flatDeclaration(file, name) {
    const source = fs.readFileSync(path.join(root, file), "utf8");
    const marker = "public enum " + name;
    const start = source.indexOf(marker);
    assert.ok(start >= 0 && source.indexOf(marker, start + marker.length) < 0,
        "one current declaration required: " + name);
    const open = source.indexOf("{", start);
    const end = source.indexOf("\n}", open);
    assert.ok(open > start && end > open, "complete flat declaration required: " + name);
    assert.ok(!/[{}]/.test(source.slice(open + 1, end)),
        "nested syntax needs a different reader: " + name);
    return source.slice(start, end + 2);
}

const definitions = [
    flatDeclaration("Sources/VerificationIsIdentification/Primitive.swift", "Paired"),
    flatDeclaration("Sources/Examples/LocalContactPolicy.swift", "LocalPolicyAtZero"),
    flatDeclaration("Sources/Examples/LocalContactPolicy.swift", "LocalPolicyAtOne"),
    flatDeclaration("Sources/Examples/Acquisition.swift", "FirstEvidenceImage"),
    flatDeclaration("Sources/Examples/BoundaryEvolution.swift", "SecondEvidenceImage"),
    flatDeclaration("Sources/Examples/Verdict.swift", "CandidateLeaf"),
    flatDeclaration("Sources/Examples/Verdict.swift", "CandidateFork"),
    flatDeclaration("Sources/Examples/Verdict.swift", "SelectCandidateLeaf"),
    flatDeclaration("Sources/Examples/Verdict.swift", "SelectCandidateLeft"),
    flatDeclaration("Sources/Examples/Verdict.swift", "SelectCandidateRight"),
].join("\n");
const claims = fs.readFileSync(path.join(__dirname, "LocalPolicyCourt.swift"), "utf8");
const good = judgeWhereTexts(definitions + "\n" + claims);
assert.equal(good.judged, 6, "all six requested policy equalities must actually be read");
assert.deepEqual(good.refusals, []);
const cases = [["policy", definitions + "\n" + claims, 0]];

for (const [name, left, right] of [
    ["HiddenChoice", "CourtZero.Right", "FirstProjection"],
    ["UnsentMessage", "CourtZero.Left", "CourtOne.Left"],
    ["UnchangedTableAfterRenaming", "CourtZero.Right", "CourtOne.Right"],
]) {
    const attack = "\npublic typealias " + name + " = LocalCourtSame<" + left + ", " + right + ">\n";
    const result = judgeWhereTexts(definitions + "\n" + claims + attack);
    assert.equal(result.judged, 7, "the attack must be read: " + name);
    assert.equal(result.refusals.length, 1, name);
    assert.ok(result.refusals[0].includes(name), result.refusals[0]);
    cases.push([name, definitions + "\n" + claims + attack, 1]);
}

// Keep the larger, Swift-checked selection certificate intact. The where
// court does not yet read SelectCandidateLeft/Right's declaration constraints.
// A reader limit is neither a proof nor a contradictory counterexample.
const selection = fs.readFileSync(path.join(__dirname, "LocalSelectionCourt.swift"), "utf8");
cases.push(["selection-reader-limit", definitions + "\n" + claims + "\n" + selection, 2]);
const dir = fs.mkdtempSync(path.join(os.tmpdir(), "vi-local-court-"));
try {
    for (const [name, text, status] of cases) {
        const file = path.join(dir, name + ".swift");
        fs.writeFileSync(file, text);
        const port = spawnSync(process.execPath,
            [path.join(path.dirname(path.resolve(judgePath)), "judge-cli.js"), "judge", "where", file],
            { encoding: "utf8" });
        assert.equal(port.status, status, port.stdout + port.stderr);
        if (status === 2) assert.match(port.stderr, /cannot read conditional declaration 'SelectCandidateLeft'/);
        if (nativePath) {
            const native = spawnSync(path.resolve(nativePath), ["judge", "where", file], { encoding: "utf8" });
            assert.equal(native.status, status, native.stdout + native.stderr);
            assert.equal(port.stdout, native.stdout, name);
            assert.equal(port.stderr, native.stderr, name);
        }
    }
} finally {
    fs.rmSync(dir, { recursive: true, force: true });
}
console.log("local policy court: 6 current-source equalities hold; 3 substitutions refused; selection scope explicitly unread; no Swift build"
    + (nativePath ? "; native/port agree" : ""));
