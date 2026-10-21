#!/usr/bin/env python3
"""Run bounded Swift checks for exact coherent Data/Joint continuations.

This is build orchestration over real source files and fixed fixtures. Swift
checks the equations and admitted interfaces; Python does not interpret the
operators, search for a proof, or simulate a quantum system.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import shutil
import sys
import time

sys.dont_write_bytecode = True
from static_checks import InfrastructureFailure, compile_check, digest


FOREIGN_RESIDENT = """
// A well-formed program description with a foreign current resident. The
// controlled primitive, rather than this open carrier interface, closes owner equality.
enum ForeignOwnedProgram: CoherentProgram {
    typealias Public = CoherentSource0.Public
    typealias Owner = CoherentSource0.Owner
    typealias Resident = CoherentOwnedResident<CoherentSource1.Owner>
    typealias Left = CoherentSource0
    typealias Block0 = CoherentSource0.Block0
    typealias Block1 = CoherentSource0.Block1
    typealias Ideal = CoherentSource0.Ideal
    typealias Right = Paired<Paired<Block0,Block1>,Paired<Ideal,Resident>>
}
"""

POSITIVE = """
enum Source00: Null { typealias Left = CoherentSource0.Block0; typealias Right = CoherentI<CoherentPhase0> }
enum Source01: Null { typealias Left = CoherentSource0.Block1; typealias Right = CoherentXZ<CoherentPhase2> }
enum Source10: Null { typealias Left = CoherentSource1.Block0; typealias Right = CoherentX<CoherentPhase0> }
enum Source11: Null { typealias Left = CoherentSource1.Block1; typealias Right = CoherentZ<CoherentPhase0> }
enum One00: Null { typealias Left = CohOne0.Block0; typealias Right = CoherentI<CoherentPhase0> }
enum One01: Null { typealias Left = CohOne0.Block1; typealias Right = CoherentI<CoherentPhase1> }
enum One10: Null { typealias Left = CohOne1.Block0; typealias Right = CoherentI<CoherentPhase0> }
enum One11: Null { typealias Left = CohOne1.Block1; typealias Right = CoherentI<CoherentPhase1> }
typealias Data0 = CoherentDataWitness<CohOne0>
typealias Data1 = CoherentDataWitness<CohOne1>
typealias Joint0 = CoherentJointWitness<CohTwo0>
typealias Joint1 = CoherentJointWitness<CohTwo1>
typealias CommonJoint = CoherentJointWitness<CohCommon1>
enum CommonPhase0: Null { typealias Left = CohCommon1.Block0.Phase; typealias Right = CoherentPhase2 }
enum CommonPhase1: Null { typealias Left = CohCommon1.Block1.Phase; typealias Right = CoherentPhase2 }
enum ActualCertificateSource: Null { typealias Left = CommonJoint.Program; typealias Right = CohCommon1 }
enum OwnerRetained: Null { typealias Left = CohTwo0.Resident; typealias Right = CoherentOwnedResident<CoherentSourceStart<QBit0>> }
// Memory phases have a core meaning, although this external interface does not grant them.
typealias MemoryCorrected = CoherentMemoryS<CoherentMemoryS<CoherentMemoryS<CohOne0>>>
typealias MemoryJoint = CoherentJointWitness<MemoryCorrected>
func admittedExternalControl() throws { _ = try coherentModel(CohOne0.self,name:"AdmittedControl") }
"""

PHASE_REFUSAL = (r"'CoherentJointWitness' requires the types", r"CoherentPhase0", r"CoherentPhase1", r"be equivalent")
FIXTURES = [
    ("positive", FOREIGN_RESIDENT + POSITIVE, (), "positive"),
    ("joint_one_r0", "typealias Rejected = CoherentJointWitness<CohOne0>\n", PHASE_REFUSAL, "negative"),
    ("joint_one_r1", "typealias Rejected = CoherentJointWitness<CohOne1>\n", PHASE_REFUSAL, "negative"),
    ("wrong_ideal", "typealias Rejected = CoherentDataWitness<CoherentH<CohTwo0>>\n",
     (r"'CoherentDataWitness' requires the types", r"CoherentIdealEmpty.Word", r"CoherentIdealHSymbol", r"be equivalent"), "negative"),
    ("wrong_public", "typealias Rejected = CoherentPublicX1<CoherentSource0>\n",
     (r"'CoherentPublicX1' requires the types", r"QBit0", r"QBit1", r"be equivalent"), "negative"),
    ("withdrawn_control", "typealias Rejected = CoherentCZ<CoherentWithdraw<CoherentSource0>>\n",
     (r"'CoherentCZ' requires the types", r"Never", r"CoherentOwnedResident", r"be equivalent"), "negative"),
    ("foreign_owned_control", FOREIGN_RESIDENT + "typealias Rejected = CoherentCZ<ForeignOwnedProgram>\n",
     (r"'CoherentCZ' requires the types", r"CoherentOwnedResident", r"QBit0", r"QBit1", r"be equivalent"), "negative"),
    ("ungranted_memory_phase", "func rejectedExternalControl() throws { _ = try coherentModel(CoherentMemoryS<CohOne0>.self,name:\"UngrantedControl\") }\n",
     (r"global function 'coherentModel", r"CoherentMemoryS", r"conform to 'EmitCoherentProgram'"), "negative"),
    ("conservative_missing_witness", """
// Four repetitions of the actual S,S,H suffix give (HZ)^4 = -I.
// Its common phase is harmless, but H^2/S^4 reduction alone does not prove it.
typealias Unreduced1 = CoherentH<CoherentS<CoherentS<CohTwo0>>>
typealias Unreduced2 = CoherentH<CoherentS<CoherentS<Unreduced1>>>
typealias Unreduced3 = CoherentH<CoherentS<CoherentS<Unreduced2>>>
typealias Unreduced4 = CoherentH<CoherentS<CoherentS<Unreduced3>>>
typealias Missing = CoherentDataWitness<Unreduced4>
""", (r"'CoherentDataWitness' requires the types", r"CoherentIdealHSymbol", r"be equivalent"), "conservative_missing_witness"),
]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifacts", required=True, type=Path)
    parser.add_argument("--library", required=True, type=Path)
    args = parser.parse_args()
    artifacts, library = args.artifacts.resolve(), args.library.resolve()
    artifacts.mkdir(parents=True, exist_ok=True)
    work = artifacts / "coherent-static-checks" / str(time.time_ns())
    work.mkdir(parents=True)
    repo = Path(__file__).resolve().parents[2]
    bridge = repo / "Checks/BraketBridge"
    common = [repo / "Sources/Examples/QuantumContinuation.swift", repo / "Sources/Examples/QuantumCoherentControl.swift"]
    common += [bridge / name for name in ("Cases.swift", "Adapter.swift", "CoherentAdapter.swift", "CoherentCases.swift")]
    certificates = artifacts / "CoherentCertificates.swift"
    consumer = artifacts / "CheckedCoherentExport.swift"
    tracked = common + [certificates, consumer, Path(__file__).resolve(), bridge / "static_checks.py",
                        library / "VerificationIsIdentification.swiftmodule", library / "libVerificationIsIdentification.dylib",
                                library / "Notation.swiftmodule", library / "libNotation.dylib"]
    report = {
        "schema": "vi.coherent.static-checks.v1", "started_utc": datetime.now(timezone.utc).isoformat(),
        "status": "running", "library": str(library), "work_directory": str(work), "checks": [],
        "source_sha256": {},
        "scope": "exact finite Swift block/phase, source, ownership, and admitted-export checks; no physical or numerical validation",
        "conservative_limit": "A missing H^2/S^4 normal-form witness is not a proof of operator inequality or impossibility.",
    }
    exit_code = 1
    try:
        compiler = shutil.which("swiftc")
        if compiler is None:
            raise InfrastructureFailure("swiftc is unavailable")
        report["source_sha256"] = {str(path): digest(path) for path in tracked}

        def check(name: str, sources: list[Path], patterns: tuple[str, ...] = (), kind: str = "positive") -> None:
            result = compile_check(name, sources, library, compiler, work, patterns, kind=kind)
            # Compiler resource limits are not a failed mathematical equality.
            output = Path(result["log"]).read_text(encoding="utf-8")
            if "rule count limit exceeded" in output or "cannot build rewrite system" in output:
                result.update(accepted=False, status="infrastructure_failure", infrastructure_error="Swift generic rewrite limit")
            report["checks"].append(result)
            if not result["accepted"]:
                if result["status"] == "infrastructure_failure":
                    raise InfrastructureFailure(result["infrastructure_error"])
                raise RuntimeError("Unexpected result: " + name)

        # First validate the actual generated witnesses and checked consumer.
        check("generated_certificates", common + [certificates, consumer])
        for name, body, patterns, kind in FIXTURES:
            fixture = work / (name + ".swift")
            fixture.write_text("import VerificationIsIdentification\n" + body, encoding="utf-8")
            check(name, common + [fixture], patterns, kind)

        if any(digest(path) != report["source_sha256"][str(path)] for path in tracked):
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
    report["fixture_sha256"] = {str(path): digest(path) for path in sorted(work.glob("*.swift"))}
    destination = artifacts / "coherent-static-checks.json"
    destination.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"{report['status']}: {len(report['checks'])} coherent checks; {destination}")
    return exit_code


if __name__ == "__main__":
    sys.exit(main())
