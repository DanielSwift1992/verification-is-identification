#!/usr/bin/env python3
"""Scoped build QA for the typed acquisition source and its external registry.

Python writes fixed Swift fixtures and runs qualified compiler/runtime checks.
It does not interpret VI types, derive a decoder, or simulate an operation.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import shutil
import sys
import time

sys.dont_write_bytecode = True
from static_checks import InfrastructureFailure, compile_check, digest


COMMON = """import VerificationIsIdentification
enum Occurrence: Close {}
enum ForeignOccurrence: Close {}
typealias Law = QuantumWeights16<Never,Never,Never,Never,Never,Never,Never,Never,Never,Never,Never,Never,Never,Never,Never,Never>
typealias Source = QuantumSource<Occurrence,Law>
typealias ForeignSource = QuantumSource<ForeignOccurrence,Law>
typealias Before = QuantumH<QuantumZ0<QuantumStart<Source>>>
typealias Program = RetainedQuantumZ1<Before>
typealias Memory = QuantumRecordsCons<RecordToggle1<RecordToggle0<RecordZero<Source>>>,QuantumNoRecords<Source>>
typealias Added = ContactAugmented<Program,Memory,ReadState<Program.Frame>>
"""

# This all-zero law is only an endpoint fixture, never an exported source law.
POSITIVE = """
enum ProducerBound: Null { typealias Left = Program.Production.Reading.Left; typealias Right = Program.Primitive }
enum CurrentResident: Null { typealias Left = Program.Residents.Left; typealias Right = Program.Production.Right.Right }
enum CurrentContact: Null { typealias Left = Added.Acquisition.Left.Left; typealias Right = Program }
enum AcquiredFact: Null { typealias Left = Added.Reply.Left; typealias Right = Added.Acquisition.Record.Right.Right }
enum AcquiredSource: Null { typealias Left = Added.Reply.Source; typealias Right = Source }
enum NewList: Null { typealias Left = Added.Continuation.Records; typealias Right = QuantumRecordsCons<Added.Reply,Memory> }
enum PreservedH: Null { typealias Left = QuantumH<Program>.Residents; typealias Right = Program.Residents }
enum PreservedS: Null { typealias Left = QuantumS<Program>.Residents; typealias Right = Program.Residents }
enum Destroyed: Null { typealias Left = DestroyResidents<Program>.Residents; typealias Right = Never }
enum ReplyRow0: Null { typealias Left = Added.Reply.Table.Row0; typealias Right = QBit0 }
enum ReplyRow1: Null { typealias Left = Added.Reply.Table.Row1; typealias Right = QBit0 }
enum ReplyRow2: Null { typealias Left = Added.Reply.Table.Row2; typealias Right = QBit0 }
enum ReplyRow3: Null { typealias Left = Added.Reply.Table.Row3; typealias Right = QBit0 }
enum ReplyRow4: Null { typealias Left = Added.Reply.Table.Row4; typealias Right = QBit1 }
enum ReplyRow5: Null { typealias Left = Added.Reply.Table.Row5; typealias Right = QBit1 }
enum ReplyRow6: Null { typealias Left = Added.Reply.Table.Row6; typealias Right = QBit1 }
enum ReplyRow7: Null { typealias Left = Added.Reply.Table.Row7; typealias Right = QBit1 }
enum ReplyRow8: Null { typealias Left = Added.Reply.Table.Row8; typealias Right = QBit0 }
enum ReplyRow9: Null { typealias Left = Added.Reply.Table.Row9; typealias Right = QBit0 }
enum ReplyRow10: Null { typealias Left = Added.Reply.Table.Row10; typealias Right = QBit0 }
enum ReplyRow11: Null { typealias Left = Added.Reply.Table.Row11; typealias Right = QBit0 }
enum ReplyRow12: Null { typealias Left = Added.Reply.Table.Row12; typealias Right = QBit1 }
enum ReplyRow13: Null { typealias Left = Added.Reply.Table.Row13; typealias Right = QBit1 }
enum ReplyRow14: Null { typealias Left = Added.Reply.Table.Row14; typealias Right = QBit1 }
enum ReplyRow15: Null { typealias Left = Added.Reply.Table.Row15; typealias Right = QBit1 }
"""

NO_RESIDENT = (r"Never", r"does not conform to protocol 'HasVerdict'")
COMPILE_FIXTURES = [
    ("positive", POSITIVE, ()),
    ("absent", "typealias Missing = ReadFirstResident<Before>\n", NO_RESIDENT),
    ("discarded", "typealias Missing = ReadFirstResident<DestroyResidents<Program>>\n", NO_RESIDENT),
    ("foreign_source", "typealias Foreign = ContactAugmented<Program,QuantumNoRecords<ForeignSource>,ReadState<Program.Frame>>\n",
     (r"'ContactAugmented' requires the types", r"ForeignOccurrence", r"be equivalent")),
    ("false_reply", "enum Wrong: Null { typealias Left = Added.Reply.Table.Row4; typealias Right = QBit0 }\n",
     (r"'Null' requires the types", r"QBit1", r"QBit0", r"be equivalent")),
    ("foreign_occurrence", "typealias Other = RetainedQuantumZ1<QuantumH<QuantumZ0<QuantumStart<ForeignSource>>>>\nenum Wrong: Null { typealias Left = Added.Acquisition.Left.Left; typealias Right = Other }\n",
     (r"'Null' requires the types", r"RetainedQuantumZ1", r"ForeignOccurrence", r"be equivalent")),
    ("plain_z_has_no_port", "typealias Missing = ReadFirstResident<QuantumZ1<Before>>\n", NO_RESIDENT),
]

REGISTRY_FIXTURE = """import Foundation
import VerificationIsIdentification

enum AcquisitionQAError: Error { case failed(String) }

func expectInvalid(_ expected: String, _ action: () throws -> Void) throws {
    do { try action() }
    catch BridgeError.invalid(let actual) {
        guard actual == expected else { throw AcquisitionQAError.failed("wrong diagnostic: " + actual) }
        print("EXPECTED_REFUSAL: " + actual)
        exit(73)
    }
    throw AcquisitionQAError.failed("expected registry refusal")
}

func runAcquisitionCheck(_ name: String) throws {
    if name == "exact_state_skip" {
        typealias Clean = QuantumStart<Source2>
        typealias State = QuantumContinuation<Clean,QuantumNoRecords<Source2>,ReadState<Clean.Frame>>
        let m = try model(State.self,name:"ExactStateSkip")
        let request = AcquisitionRequest(name:"ExactStateSkip",before:m,contacts:[])
        let output = try checkedAcquisitionRequests([request],sources:[m.json])
        guard output.count == 1, output[0]["action"] as? String == "skip",
              output[0]["contacts"] as? Int == 0,
              output[0]["backend"] as? String == "unitary_quantum_continuation",
              output[0]["cell"] == nil else {
            throw AcquisitionQAError.failed("exact State skip backend or availability")
        }
        print("PASS exact_state_skip")
        return
    }
    let sources = try acquisitionModels().map { $0.json }
    let request = try contactRequest(LiveXAcquisition.self,name:"AcquireX",beforeName:"LiveXBefore",afterName:"LiveXAfter")
    switch name {
    case "registry_positive":
        let output = try checkedAcquisitionRequests([request],sources:sources)
        guard output.count == 1, output[0]["action"] as? String == "acquire" else {
            throw AcquisitionQAError.failed("positive registry control")
        }
        print("PASS registry_positive")
    case "missing_before":
        try expectInvalid("Request has no checked source") {
            _ = try checkedAcquisitionRequests([request],sources:sources.filter { $0["name"] as? String != "LiveXBefore" })
        }
    case "missing_after":
        try expectInvalid("Request has no checked source") {
            _ = try checkedAcquisitionRequests([request],sources:sources.filter { $0["name"] as? String != "LiveXAfter" })
        }
    case "duplicate":
        try expectInvalid("Duplicate checked source") {
            _ = try checkedAcquisitionRequests([request],sources:sources + [sources[0]])
        }
    case "redirected":
        let original = request.contacts[0]
        let wrong = try model(LiveZAfter.self,name:"LiveXAfter")
        let changed = AcquisitionRequest(name:request.name,before:request.before,
            contacts:[ContactOption(id:original.id,cell:original.cell,after:wrong)])
        try expectInvalid("Request differs from checked source") {
            _ = try checkedAcquisitionRequests([changed],sources:sources)
        }
    case "registered_changed_question":
        let original = request.contacts[0]
        let wrong = try model(LiveYAfter.self,name:"LiveYAfter")
        let changed = AcquisitionRequest(name:request.name,before:request.before,
            contacts:[ContactOption(id:original.id,cell:original.cell,after:wrong)])
        try expectInvalid("Contact does not refine this source question") {
            _ = try checkedAcquisitionRequests([changed],sources:sources)
        }
    case "registered_changed_source":
        let original = request.contacts[0]
        let wrong = try model(RotatedXAfter.self,name:"RotatedXAfter")
        let changed = AcquisitionRequest(name:request.name,before:request.before,
            contacts:[ContactOption(id:original.id,cell:original.cell,after:wrong)])
        try expectInvalid("Contact does not refine this source question") {
            _ = try checkedAcquisitionRequests([changed],sources:sources)
        }
    case "wrong_cell":
        let original = request.contacts[0]
        let changed = AcquisitionRequest(name:request.name,before:request.before,
            contacts:[ContactOption(id:original.id,cell:original.cell + 1,after:original.after)])
        try expectInvalid("Contact differs from current resident") {
            _ = try checkedAcquisitionRequests([changed],sources:sources)
        }
    default: throw AcquisitionQAError.failed("unknown fixture case")
    }
}

@main struct AcquisitionRegistryChecks {
    static func main() {
        do {
            guard CommandLine.arguments.count == 2 else { throw AcquisitionQAError.failed("expected one case") }
            try runAcquisitionCheck(CommandLine.arguments[1])
        } catch {
            fputs("QA failure: \\(error)\\n",stderr)
            exit(2)
        }
    }
}
"""

RUNTIME_CASES = [
    ("registry_positive", None),
    ("missing_before", "Request has no checked source"),
    ("missing_after", "Request has no checked source"),
    ("duplicate", "Duplicate checked source"),
    ("redirected", "Request differs from checked source"),
    ("registered_changed_question", "Contact does not refine this source question"),
    ("registered_changed_source", "Contact does not refine this source question"),
    ("wrong_cell", "Contact differs from current resident"),
    ("exact_state_skip", None),
]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifacts", required=True, type=Path)
    parser.add_argument("--library", required=True, type=Path)
    args = parser.parse_args()
    artifacts, library = args.artifacts.resolve(), args.library.resolve()
    artifacts.mkdir(parents=True, exist_ok=True)
    work = artifacts / "acquisition-static-checks" / str(time.time_ns())
    work.mkdir(parents=True)
    repo = Path(__file__).resolve().parents[2]
    bridge = repo / "Checks/BraketBridge"
    quantum = [repo / "Sources/Examples/QuantumContinuation.swift", repo / "Sources/Examples/QuantumAcquisition.swift"]
    runtime_sources = quantum + [bridge / p for p in ("Cases.swift", "Adapter.swift", "Planner.swift", "AcquisitionAdapter.swift", "AcquisitionCases.swift")]
    report = {"schema": "vi.acquisition.static-checks.v1", "started_utc": datetime.now(timezone.utc).isoformat(),
              "status": "running", "scope": "fixed Swift acquisition endpoint and external registry QA; no backend execution",
              "library": str(library), "work_directory": str(work), "source_sha256": {}, "checks": []}
    tracked = runtime_sources + [Path(__file__).resolve(), bridge / "static_checks.py",
                                library / "VerificationIsIdentification.swiftmodule",
                                library / "libVerificationIsIdentification.dylib",
                                library / "Notation.swiftmodule", library / "libNotation.dylib"]
    exit_code = 1
    try:
        compiler = shutil.which("swiftc")
        if compiler is None:
            raise InfrastructureFailure("swiftc is unavailable")
        report["source_sha256"] = {str(p): digest(p) for p in tracked}

        def check(name: str, sources: list[Path], patterns: tuple[str, ...] = (), **options) -> None:
            result = compile_check(name, sources, library, compiler, work, patterns, **options)
            report["checks"].append(result)
            if not result["accepted"]:
                if result["status"] == "infrastructure_failure":
                    raise InfrastructureFailure(result["infrastructure_error"])
                raise RuntimeError("Unexpected result: " + name)

        for name, body, patterns in COMPILE_FIXTURES:
            fixture = work / (name + ".swift")
            fixture.write_text(COMMON + body, encoding="utf-8")
            check(name, quantum + [fixture], patterns)

        registry = work / "RegistryChecks.swift"
        registry.write_text(REGISTRY_FIXTURE, encoding="utf-8")
        executable = work / "registry-checks"
        command = [compiler, "-I", str(library), "-L", str(library), "-lVerificationIsIdentification", "-lNotation"]
        command += [str(p) for p in runtime_sources + [registry]]
        command += ["-Xlinker", "-rpath", "-Xlinker", str(library), "-o", str(executable)]
        check("registry_compile", runtime_sources + [registry], command_override=command)
        for name, diagnostic in RUNTIME_CASES:
            patterns = () if diagnostic is None else (re.escape("EXPECTED_REFUSAL: " + diagnostic),)
            check(name, runtime_sources + [registry], patterns,
                  command_override=[str(executable), name], expected_returncode=73,
                  kind="runtime_positive" if diagnostic is None else "runtime_guard")

        if any(digest(p) != report["source_sha256"][str(p)] for p in tracked):
            raise InfrastructureFailure("An input changed during the check")
        report["status"] = "passed"
        exit_code = 0
    except (InfrastructureFailure, OSError) as error:
        report["status"] = "infrastructure_failure"
        report["error"] = str(error)
        exit_code = 2
    except RuntimeError as error:
        report["status"] = "failed"
        report["error"] = str(error)
    report["completed_utc"] = datetime.now(timezone.utc).isoformat()
    report["passed"] = exit_code == 0
    report["fixture_sha256"] = {str(p): digest(p) for p in sorted(work.glob("*.swift"))}
    report_path = artifacts / "acquisition-static-checks.json"
    report_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"{report['status']}: {len(report['checks'])} acquisition checks; {report_path}")
    return exit_code


if __name__ == "__main__":
    sys.exit(main())
