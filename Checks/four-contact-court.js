// Frozen research reader: see Checks/Archive/WhereV2/README.md; not current Court evidence.
"use strict";

// Present actual source equations to the existing court. This adapter does
// not compute a permutation or unfold a word using its own implementation.
const fs = require("node:fs");
const path = require("node:path");
const os = require("node:os");
const assert = require("node:assert/strict");
const { spawnSync } = require("node:child_process");
const root = path.resolve(__dirname, "..");
const judgePath = path.join(root, "Checks/Archive/WhereV2/judge-where.js");
const nativePath = process.argv[2];
const { judgeWhereTexts } = require(path.resolve(judgePath));
const read = file => fs.readFileSync(path.join(root, file), "utf8");
const primitive = read("Sources/Notation/Primitive.swift");
const paired = primitive.match(/public enum Paired\b[^{}]*\{[^{}]*\}/g);
assert.equal(paired && paired.length, 1, "one complete current Paired definition");
const routing = read("Sources/Examples/RoutingTransport.swift");
const swap = routing.match(/public enum ExchangeRoutingWithReserve\b[^{}]*\{[^{}]*\}/g);
assert.equal(swap && swap.length, 1, "one complete current reserve exchange definition");
const moduleShape = routing.match(/^public typealias RoutingModule[^\n]+/gm);
assert.equal(moduleShape && moduleShape.length, 1, "one complete current module shape");
const binary = read("Sources/Examples/BoundaryBinary.swift");
const working = binary.match(/^public typealias BoundaryWorking[^\n]+/gm);
assert.equal(working && working.length, 1, "one complete current BoundaryWorking alias");
const policy = read("Checks/LocalPolicyCourt.swift");
const end = policy.indexOf("public typealias CourtPolicy");
assert.ok(end > 0, "current equality gate preamble");
const text = [paired[0], moduleShape[0], swap[0], working[0], policy.slice(0, end),
    read("Sources/Examples/LocalFourLeaf.swift"), read("Checks/LocalFourLeafCourt.swift"),
    read("Sources/Examples/FourContactReturnBasis.swift"), read("Checks/LocalReturnBasisCourt.swift")].join("\n");
const good = judgeWhereTexts(text);
assert.equal(good.judged, 134, "the original 128 obligations and six actual swap/source obligations must be read");
assert.deepEqual(good.refusals, []);
const cases = [["good", text, 0]];
for (const [name, left, right] of [
    ["FullIdentity", "FourCourtWPhase.S11.Right", "FourCourtPhaseInput"],
    ["OldInput", "FourCourtWPhase.S1.Left", "FourCourtPhaseInput"],
    ["InverseAsPoint", "FourCourtWPhase.S11.Right.Left.Left", "FourCourtA"],
    ["SameAnswerOtherContact", "FourLeafPhase0<FourCourtA, FourCourtA, FourCourtA, FourCourtA>",
        "FourLeafPhase1<FourCourtA, FourCourtA, FourCourtA, FourCourtA>"],
    ["SameEndpointOtherPath", "FourCourtWPhase.Path",
        "FollowedPair<FollowedPair<FourLeafPhase0<FourCourtA, FourCourtB, FourCourtC, FourCourtD>, FourLeafPhase0<FourCourtB, FourCourtA, FourCourtC, FourCourtD>>, FourCourtWPhase.Path>"],
    ["TripleWordIsTotalIdentity", "ReturnCourtPhase.S7.Right", "FourCourtPhaseInput"],
    ["TripleWordMissingLastContact", "ReturnCourtStage.S6.Right", "FourCourtStageInput"],
    ["VisibleMiddleIsActualMiddle", "SwapSeamFirst.Answer", "SwapSeamOther.Left"],
    ["TwoTrueEdgesGiveReturn", "SwapSeamOther.Answer", "SwapSeamFirst.Left"],
]) {
    const bad = text + "\npublic typealias " + name + " = LocalCourtSame<" + left + ", " + right + ">\n"
        + "public typealias Use" + name + " = LocalCourtUse<" + name + ">\n";
    const result = judgeWhereTexts(bad);
    assert.equal(result.judged, 135, name + " must actually be judged");
    assert.equal(result.refusals.length, 1, name);
    assert.ok(result.refusals[0].includes(name), result.refusals[0]);
    cases.push([name, bad, 1]);
}
if (nativePath) {
    const dir = fs.mkdtempSync(path.join(os.tmpdir(), "vi-four-contact-"));
    try {
        for (const [name, source, status] of cases) {
            const file = path.join(dir, name + ".swift");
            fs.writeFileSync(file, source);
            const native = spawnSync(path.resolve(nativePath), ["judge", "where", file], { encoding: "utf8" });
            const port = spawnSync(process.execPath,
                [path.join(path.dirname(path.resolve(judgePath)), "judge-cli.js"), "judge", "where", file],
                { encoding: "utf8" });
            if (native.error) throw native.error;
            if (port.error) throw port.error;
            assert.equal(native.status, status, native.stdout + native.stderr);
            assert.equal(port.status, status, port.stdout + port.stderr);
            assert.equal(native.stdout, port.stdout, name);
            assert.equal(native.stderr, port.stderr, name);
        }
    } finally {
        fs.rmSync(dir, { recursive: true, force: true });
    }
}
console.log("four-contact court: 134 current-source obligations hold; 9 substitutions refused; no Swift build"
    + (nativePath ? "; native/port agree" : ""));
