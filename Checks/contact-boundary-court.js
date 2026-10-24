// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";

// Adapter only: current declarations are carried verbatim to the existing
// court. This file implements no equality, partition or contact solver.
const fs = require("node:fs");
const path = require("node:path");
const os = require("node:os");
const assert = require("node:assert/strict");
const { spawnSync } = require("node:child_process");
const root = path.resolve(__dirname, "..");
const judgePath = path.join(root, "Checks/Archive/WhereV2/judge-where.js");
const nativePath = process.argv[2];
const { judgeWhereTexts } = require(path.resolve(judgePath));

function declaration(file, name, flat = true) {
    const source = fs.readFileSync(path.join(root, file), "utf8");
    const marker = "public enum " + name;
    const start = source.indexOf(marker);
    assert.ok(start >= 0 && source.indexOf(marker, start + marker.length) < 0, "unique declaration: " + name);
    const open = source.indexOf("{", start);
    const end = source.indexOf("\n}", open);
    assert.ok(open > start && end > open, "complete declaration: " + name);
    if (flat) assert.ok(!/[{}]/.test(source.slice(open + 1, end)), "flat declaration: " + name);
    return source.slice(start, end + 2);
}

function alias(file, name) {
    const rows = fs.readFileSync(path.join(root, file), "utf8").split("\n")
        .filter(row => row.startsWith("public typealias " + name + " ") || row.startsWith("public typealias " + name + "<"));
    assert.equal(rows.length, 1, "one complete alias: " + name);
    assert.match(rows[0], / = /);
    return rows[0];
}

const policy = fs.readFileSync(path.join(__dirname, "LocalPolicyCourt.swift"), "utf8");
const gateStart = policy.indexOf("public protocol LocalCourtHolds");
const gateEnd = policy.indexOf("public typealias CourtPolicy");
assert.ok(gateStart >= 0 && gateEnd > gateStart);
const definitions = [
    declaration("Sources/Notation/Primitive.swift", "Paired"),
    declaration("Sources/Examples/Acquisition.swift", "FirstEvidenceImage"),
    declaration("Sources/Examples/BoundaryEvolution.swift", "SecondEvidenceImage"),
    declaration("Sources/Examples/ContactBoundary.swift", "ProductBoundary"),
    declaration("Sources/Examples/ContactBoundary.swift", "AlternativeBoundaryProduct"),
    alias("Sources/Examples/Distance.swift", "AddressTriple"),
    alias("Sources/Examples/Light.swift", "Lit1"),
    policy.slice(gateStart, gateEnd),
].join("\n");
const claims = fs.readFileSync(path.join(__dirname, "ContactBoundaryCourt.swift"), "utf8");
const source = definitions + "\n" + claims;
const good = judgeWhereTexts(source);
assert.equal(good.judged, 8, "all eight current-field certificates must be read");
assert.equal(good.members, 0, "this is an equality certificate, not generic admission");
assert.deepEqual(good.refusals, []);
const cases = [["current-product", source, 0]];

// Select exactly the explicitly labelled scope experiment. This is not a
// successful Swift-admission certificate: the court checks its equality but
// counts no memberships, whereas Swift rejects the generic argument.
const scopeMarker = "#if LOCAL_PHASE_CONTACT_BOUNDARY_COURT_ADMISSION\n";
assert.equal(claims.split(scopeMarker).length, 2);
const admissionScope = definitions + "\n" + claims.replace(scopeMarker, "").replace("#endif", "");
const scopeResult = judgeWhereTexts(admissionScope);
assert.equal(scopeResult.judged, 9);
assert.equal(scopeResult.members, 0);
assert.deepEqual(scopeResult.refusals, []);
cases.push(["inline-bound-outside-certificate", admissionScope, 0]);

for (const [name, left, right] of [
    ["BoundaryCourtFalseAB", "CourtBoundaryWhole.Left", "CourtBoundaryWhole.Right.Left"],
    ["BoundaryCourtFalseAC", "CourtBoundaryWhole.Left", "CourtBoundaryWhole.Right.Right"],
    ["BoundaryCourtWrongProbe", "CourtBoundary.ABSecond.Left", "CourtBoundaryWhole.Right.Right"],
]) {
    const text = source + "\npublic typealias " + name + " = LocalCourtSame<" + left + ", " + right + ">\n";
    const result = judgeWhereTexts(text);
    assert.equal(result.judged, 9, "the added obligation must be read: " + name);
    assert.equal(result.refusals.length, 1, name);
    assert.ok(result.refusals[0].includes(name));
    cases.push([name, text, 1]);
}

cases.push(["missing-axis", source + "\npublic typealias BoundaryCourtMissing = LocalCourtSame<CourtBoundaryWhole.Left.Lost, CourtBoundaryWhole.Left.Lost>\n", 2]);
cases.push(["conditional-scope", source + "\n" +
    declaration("Sources/Examples/ContactBoundary.swift", "OpenConditionalChain", false) +
    "\npublic typealias BoundaryCourtConditional = LocalCourtSame<OpenConditionalChain<Paired<Never, Never>, Paired<Never, Never>, Paired<Never, Never>, Paired<Never, Never>>.Right, Paired<Never, Never>>\n", 2]);

const dir = fs.mkdtempSync(path.join(os.tmpdir(), "vi-boundary-court-"));
try {
    for (const [name, text, status] of cases) {
        const file = path.join(dir, name + ".swift");
        fs.writeFileSync(file, text);
        const port = spawnSync(process.execPath,
            [path.join(path.dirname(path.resolve(judgePath)), "judge-cli.js"), "judge", "where", file],
            { encoding: "utf8", timeout: 20000 });
        assert.equal(port.status, status, port.stdout + port.stderr);
        if (name === "missing-axis") assert.match(port.stderr, /no definition of 'Lost'/);
        if (name === "conditional-scope") assert.match(port.stderr, /cannot read conditional declaration 'OpenConditionalChain'/);
        if (nativePath) {
            const native = spawnSync(path.resolve(nativePath), ["judge", "where", file],
                { encoding: "utf8", timeout: 20000 });
            assert.equal(native.status, status, native.stdout + native.stderr);
            assert.equal(native.stdout, port.stdout, name);
            assert.equal(native.stderr, port.stderr, name);
        }
    }
} finally {
    fs.rmSync(dir, { recursive: true, force: true });
}
console.log("contact boundary court: 8 current-source equalities; 3 substitutions refused; missing axis and conditional scope not certified; inline generic admission explicitly outside this equality certificate; no Swift invoked" +
    (nativePath ? "; native/port agree" : ""));
