#!/usr/bin/env python3
"""Run scoped Swift acceptance/refusal checks for the Braket bridge.

This is build orchestration. It neither interprets arbitrary Swift nor decides
VI claims. Mutations address exact, controlled fixture declarations; the Swift
compiler checks the resulting source and its actual generated certificates.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import signal
import subprocess
import sys
import time


TIMEOUT_SECONDS = 30
INFRASTRUCTURE_PATTERNS = (
    r"no such module",
    r"no such file or directory",
    r"error opening input file",
    r"unable to (?:load|execute)",
    r"failed to build module",
    r"compile command failed due to signal",
    r"Stack dump:",
    r"PLEASE submit a bug report",
    r"fatal error:",
    r"cannot find .* in scope",
    r"cannot find type .* in scope",
)


class InfrastructureFailure(RuntimeError):
    pass


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def replace_once(text: str, old: str, new: str, description: str) -> str:
    count = text.count(old)
    if count != 1:
        raise InfrastructureFailure(
            f"{description}: expected one controlled fixture anchor, found {count}"
        )
    return text.replace(old, new, 1)


def compile_check(
    name: str,
    sources: list[Path],
    library: Path,
    compiler: str,
    work: Path,
    patterns: tuple[str, ...] = (),
    command_override: list[str] | None = None,
    expected_returncode: int = 1,
    kind: str | None = None,
) -> dict:
    command = command_override or [compiler, "-typecheck", "-I", str(library)]
    if command_override is None:
        command.extend(str(path) for path in sources)
    started = time.monotonic()
    output = ""
    returncode = None
    timed_out = False
    infrastructure = None
    try:
        process = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            start_new_session=True,
        )
        try:
            output, _ = process.communicate(timeout=TIMEOUT_SECONDS)
        except subprocess.TimeoutExpired:
            timed_out = True
            # Kill the compiler driver and its frontend children. A timeout is
            # infrastructure failure even if a partial refusal was printed.
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            output, _ = process.communicate()
            infrastructure = f"compiler exceeded {TIMEOUT_SECONDS} seconds"
        returncode = process.returncode
    except OSError as error:
        infrastructure = f"cannot launch compiler: {error}"
        output = str(error)

    elapsed = time.monotonic() - started
    if infrastructure is None and returncode is not None and returncode < 0:
        infrastructure = f"compiler terminated by signal {-returncode}"
    if infrastructure is None:
        for pattern in INFRASTRUCTURE_PATTERNS:
            if re.search(pattern, output, re.IGNORECASE):
                infrastructure = f"infrastructure diagnostic matched: {pattern}"
                break

    missing = [pattern for pattern in patterns if not re.search(pattern, output)]
    if infrastructure is not None:
        accepted = False
        status = "infrastructure_failure"
    elif patterns:
        accepted = returncode == expected_returncode and not missing
        expected_status = "expected_runtime_rejection" if kind == "runtime_guard" else "expected_refusal"
        status = expected_status if accepted else "unexpected_result"
    else:
        accepted = returncode == 0
        status = "accepted" if accepted else "unexpected_result"

    log_path = work / f"{name}.log"
    log_path.write_text(
        "$ " + shlex.join(command) + "\n"
        + f"returncode={returncode} elapsed_seconds={elapsed:.6f} "
        + f"timeout_seconds={TIMEOUT_SECONDS} timed_out={timed_out}\n\n"
        + output,
        encoding="utf-8",
    )
    return {
        "name": name,
        "kind": kind or ("negative" if patterns else "positive"),
        "status": status,
        "accepted": accepted,
        "returncode": returncode,
        "elapsed_seconds": round(elapsed, 6),
        "timeout_seconds": TIMEOUT_SECONDS,
        "timed_out": timed_out,
        "infrastructure_error": infrastructure,
        "expected_diagnostic_patterns": list(patterns),
        "missing_diagnostic_patterns": missing,
        "command": command,
        "sources": [str(path) for path in sources],
        "log": str(log_path),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifacts", required=True, type=Path)
    parser.add_argument("--library", required=True, type=Path)
    args = parser.parse_args()
    artifacts = args.artifacts.resolve()
    library = args.library.resolve()
    artifacts.mkdir(parents=True, exist_ok=True)
    run_id = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S") + f"-{time.time_ns()}"
    work = artifacts / "static-checks" / run_id
    work.mkdir(parents=True)
    report_path = artifacts / "static-checks.json"
    repo = Path(__file__).resolve().parents[2]
    bridge = repo / "Checks" / "BraketBridge"
    core = repo / "Sources" / "Examples" / "QuantumContinuation.swift"
    adapter = bridge / "Adapter.swift"
    cases = bridge / "Cases.swift"
    planner = bridge / "Planner.swift"
    extra = bridge / "Extra.swift"
    certificate = artifacts / "Certificates.swift"
    original = [core, adapter, cases, planner, extra, certificate]
    report = {
        "schema": "vi.braket.static-checks.v1",
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "status": "running",
        "library": str(library),
        "work_directory": str(work),
        "checks": [],
        "source_sha256": {},
        "scope": "Swift checks of this finite source/export/certificate fragment",
    }
    exit_code = 2
    try:
        compiler = shutil.which("swiftc")
        if compiler is None:
            raise InfrastructureFailure("swiftc is unavailable")
        report["compiler"] = compiler
        for path in original:
            if not path.is_file():
                raise InfrastructureFailure(f"required source is unavailable: {path}")
        module = library / "VerificationIsIdentification.swiftmodule"
        if not module.exists():
            raise InfrastructureFailure(f"core module is unavailable: {module}")
        hashes = {str(path): digest(path) for path in original}
        report["source_sha256"] = hashes
        if module.is_file():
            report["library_module_sha256"] = digest(module)

        def unchanged() -> None:
            for path in original:
                if not path.is_file() or digest(path) != hashes[str(path)]:
                    raise InfrastructureFailure(f"source changed during checks: {path}")

        def run(
            name: str,
            sources: list[Path],
            patterns: tuple[str, ...] = (),
            command_override: list[str] | None = None,
            expected_returncode: int = 1,
            kind: str | None = None,
        ) -> dict:
            unchanged()
            result = compile_check(
                name, sources, library, compiler, work, patterns,
                command_override, expected_returncode, kind,
            )
            report["checks"].append(result)
            unchanged()
            print(f"{name}: {result['status']}", flush=True)
            if result["status"] == "infrastructure_failure":
                raise InfrastructureFailure(f"{name}: {result['infrastructure_error']}")
            return result

        def write(name: str, text: str) -> Path:
            path = work / name
            path.write_text(text, encoding="utf-8")
            return path

        def replaced_sources(old: Path, new: Path) -> list[Path]:
            return [new if path == old else path for path in original]

        # Establish the actual current certificate before exercising mutations.
        baseline = run("baseline", original)
        if not baseline["accepted"]:
            raise InfrastructureFailure("positive certificate baseline did not compile")

        certificate_text = certificate.read_text(encoding="utf-8")
        cases_text = cases.read_text(encoding="utf-8")

        wrong_decision = write(
            "WrongDecisionCertificates.swift",
            replace_once(
                certificate_text,
                "typealias D_ParityY_1 = Decision<Paired<QBit1,Never>,QBit1>",
                "typealias D_ParityY_1 = Decision<Paired<QBit1,Never>,QBit0>",
                "wrong parity decoder",
            ),
        )
        run(
            "wrong_decision",
            replaced_sources(certificate, wrong_decision),
            (
                r"error: type 'C_ParityY_row4' does not conform to protocol 'Null'",
                r"'Null' requires the types.*QBit1.*QBit0",
            ),
        )

        source_fixture = """import VerificationIsIdentification
typealias StaticSourceOther = QuantumSource<OtherOccurrence,Uniform2>
typealias StaticSourceBinding = QuantumContinuation<
    ZHZ<Source2>,One<R0<SOURCE>>,ReadY<ZHZ<Source2>.Frame>
>
"""
        source_control = write(
            "SourceMatchControl.swift", source_fixture.replace("SOURCE", "Source2")
        )
        if not run("source_match_control", original + [source_control])["accepted"]:
            raise InfrastructureFailure("source-mismatch fixture's positive control failed")
        source_mismatch = write(
            "SourceMismatch.swift", source_fixture.replace("SOURCE", "StaticSourceOther")
        )
        run(
            "source_mismatch",
            original + [source_mismatch],
            (
                r"'QuantumContinuation' requires the types.*Source.*be equivalent",
                r"OtherOccurrence",
                r"requirement specified as 'P\.Source' == 'R\.Source'",
            ),
        )

        frame_fixture = """import VerificationIsIdentification
typealias StaticQuestionBinding = QuantumContinuation<
    ZHZ<Source2>,ParityMemory,ReadX<FRAME>
>
"""
        frame_control = write(
            "QuestionFrameControl.swift",
            frame_fixture.replace("FRAME", "ZHZ<Source2>.Frame"),
        )
        if not run("question_frame_control", original + [frame_control])["accepted"]:
            raise InfrastructureFailure("question-frame fixture's positive control failed")
        wrong_frame = write(
            "WrongQuestionFrame.swift",
            frame_fixture.replace("FRAME", "QuantumStart<Source2>.Frame"),
        )
        run(
            "wrong_question_frame",
            original + [wrong_frame],
            (
                r"'QuantumContinuation' requires the types.*be equivalent",
                r"requirement specified as 'P\.Frame' == 'Q\.Left'",
            ),
        )

        unknown_fixture = """import VerificationIsIdentification
enum StaticUnknownProgram: QuantumProgram {
    typealias Source = Source2
    typealias Left = QuantumStart<Source2>
    typealias Frame = QuantumStart<Source2>.Frame
    typealias Right = Frame
}
typealias StaticExportRoot = QuantumContinuation<
    PROGRAM,Empty<Source2>,ReadState<PROGRAM.Frame>
>
func staticDemandProgramExport() throws {
    _ = try model(StaticExportRoot.self,name:"static-constructor-control")
}
"""
        known_program = write(
            "SupportedProgramControl.swift",
            unknown_fixture.replace("PROGRAM", "QuantumStart<Source2>"),
        )
        if not run("supported_program_control", original + [known_program])["accepted"]:
            raise InfrastructureFailure("unknown-constructor fixture's positive control failed")
        unknown_program = write(
            "UnknownProgram.swift",
            unknown_fixture.replace("PROGRAM", "StaticUnknownProgram"),
        )
        run(
            "unknown_constructor",
            original + [unknown_program],
            (r"requires that 'StaticUnknownProgram' conform to 'EmitProgram'",),
        )

        changed_law = write(
            "ChangedLawCases.swift",
            replace_once(
                cases_text,
                "typealias Source2 = QuantumSource<MainOccurrence,Uniform2>",
                "typealias Source2 = QuantumSource<MainOccurrence,Uniform4>",
                "changed joint law under the old source alias",
            ),
        )
        run(
            "stale_zero_rows",
            replaced_sources(cases, changed_law),
            (
                r"error: type 'C_ParityY_row1' does not conform to protocol 'Null'",
                r"'Null' requires the types.*QuantumUnitWeight.*Never",
            ),
        )

        wrong_record = write(
            "WrongRecordCases.swift",
            replace_once(
                cases_text,
                "typealias FullMemory = Two<R0<Source2>,R1<Source2>>",
                "typealias FullMemory = Two<R0<Source2>,R0<Source2>>",
                "old full-state decoder applied to duplicated first record",
            ),
        )
        run(
            "wrong_record_application",
            replaced_sources(cases, wrong_record),
            (
                r"error: type 'C_FullState_row4' does not conform to protocol 'Null'",
                r"'Null' requires the types.*QBit0.*QBit1",
            ),
        )

        # A bounded certificate binds record keys, not state answers. Shrinking
        # support can make its unchanged decoder exact while these key-only
        # equalities still compile. Exercise the separate runtime guard against
        # promoting that stale certificate to an exact one. Only one dedicated
        # model is evaluated; the base-case source aliases remain untouched.
        dynamic = work / "stale-exactness"
        dynamic.mkdir()
        phase1_directory = dynamic / "phase1-output"
        phase2_directory = dynamic / "phase2-output"
        phase1_directory.mkdir()
        phase2_directory.mkdir()
        phase_fixture_text = """import VerificationIsIdentification
typealias StaticPhaseLaw = Uniform2
typealias StaticPhaseSource = QuantumSource<MainOccurrence,StaticPhaseLaw>
typealias StaticParityState = QuantumContinuation<
    ZHZ<StaticPhaseSource>,One<Parity<StaticPhaseSource>>,
    ReadState<ZHZ<StaticPhaseSource>.Frame>
>
"""
        phase1_fixture = write("StaticPhaseOne.swift", phase_fixture_text)
        generator = write("StaticPhaseGenerator.swift", """import Foundation
import VerificationIsIdentification
@main struct StaticPhaseGenerator {
    static func main() throws {
        let directory = CommandLine.arguments[1]
        let current = try model(StaticParityState.self,name:"StaticParityState")
        let plan = try derive(current)
        try demand(!plan.exact && plan.decisions == ["0":"I","1":"X"],
                   "Stale-exactness fixture no longer has the stated bounded decoder")
        try writeJSON(["exact":plan.exact,"decisions":plan.decisions],
                      to:directory+"/phase1.json")
        try ("import VerificationIsIdentification\\n"+certificate(current,plan))
            .write(toFile:directory+"/Certificates.swift",atomically:true,encoding:.utf8)
        try checkedEmitter([current],[plan])
            .write(toFile:directory+"/CheckedExport.swift",atomically:true,encoding:.utf8)
    }
}
""")
        dynamic_base = [core, adapter, cases, planner, extra]

        def build_dynamic(name: str, sources: list[Path], executable: Path) -> None:
            command = [compiler, "-I", str(library), "-L", str(library),
                       "-lVerificationIsIdentification", "-lNotation"]
            command.extend(str(path) for path in sources)
            command.extend(["-Xlinker", "-rpath", "-Xlinker", str(library),
                            "-o", str(executable)])
            result = run(name, sources, command_override=command, kind="compile_and_link")
            if not result["accepted"]:
                raise InfrastructureFailure(f"{name}: dynamic fixture did not build")

        phase_generator = dynamic / "generate"
        build_dynamic("stale_phase_generator_build",
                      dynamic_base + [phase1_fixture, generator], phase_generator)
        if not run(
            "stale_phase_generator_run", dynamic_base + [phase1_fixture, generator],
            command_override=[str(phase_generator), str(dynamic)], kind="runtime_control",
        )["accepted"]:
            raise InfrastructureFailure("isolated stale-phase generator failed")

        stale_certificate = dynamic / "Certificates.swift"
        checked = dynamic / "CheckedExport.swift"
        if not stale_certificate.is_file() or not checked.is_file():
            raise InfrastructureFailure("isolated generator did not produce its Swift sources")
        # Keep the emitted body unchanged. This harness catches its thrown error
        # so the expected guard rejection has exit 73 rather than a crash signal.
        guarded_body = write(
            "StaticGuardedExport.swift",
            replace_once(checked.read_text(encoding="utf-8"),
                         "@main struct CheckedExport", "struct CheckedExport",
                         "controlled entry-point wrapper"),
        )
        guard_main = write("StaticGuardMain.swift", """import Foundation
@main struct StaticGuardMain {
    static func main() {
        do { try CheckedExport.main() }
        catch {
            FileHandle.standardError.write(Data("STATIC_GUARD_REJECTED: \\(error)\\n".utf8))
            exit(73)
        }
    }
}
""")
        guard_inputs = [stale_certificate, guarded_body, guard_main]
        phase1_checked = dynamic / "phase1-checked"
        build_dynamic("stale_phase_original_build",
                      dynamic_base + [phase1_fixture] + guard_inputs, phase1_checked)
        if not run(
            "stale_phase_original_run", dynamic_base + [phase1_fixture] + guard_inputs,
            command_override=[str(phase1_checked), str(phase1_directory / "continuations.json")],
            kind="runtime_control",
        )["accepted"]:
            raise InfrastructureFailure("unchanged isolated checked-export did not run")
        if not (phase1_directory / "continuations.json").is_file():
            raise InfrastructureFailure("unchanged checked-export produced no output")

        narrowed = (
            "QuantumWeights16<W1,Never,Never,Never,Never,Never,Never,Never,"
            "W1,Never,Never,Never,Never,Never,Never,Never>"
        )
        phase2_fixture = write(
            "StaticPhaseTwo.swift",
            replace_once(phase_fixture_text, "typealias StaticPhaseLaw = Uniform2",
                         "typealias StaticPhaseLaw = " + narrowed,
                         "isolated support shrink"),
        )
        phase2_checked = dynamic / "phase2-checked"
        build_dynamic("stale_phase_narrowed_build",
                      dynamic_base + [phase2_fixture] + guard_inputs, phase2_checked)
        guarded_result = run(
            "stale_phase_exactness_guard", dynamic_base + [phase2_fixture] + guard_inputs,
            (r"STATIC_GUARD_REJECTED:.*Exactness changed: regenerate row applications",),
            command_override=[str(phase2_checked), str(phase2_directory / "continuations.json")],
            expected_returncode=73, kind="runtime_guard",
        )
        forbidden = [phase2_directory / "continuations.json", phase2_directory / "sources.json"]
        guarded_result["outputs_absent"] = all(not path.exists() for path in forbidden)
        if not guarded_result["outputs_absent"]:
            guarded_result["accepted"] = False
            guarded_result["status"] = "unexpected_result"
            guarded_result["output_error"] = "stale checked-export wrote output before rejection"
        report["stale_phase_scope"] = (
            "The stale bounded row certificate compiles after support shrinks; "
            "the unchanged decoder cannot acquire an exact contract without new row applications."
        )
        unchanged()
        passed = all(check["accepted"] for check in report["checks"])
        report["status"] = "passed" if passed else "failed"
        exit_code = 0 if passed else 1
    except (InfrastructureFailure, OSError) as error:
        report["status"] = "infrastructure_failure"
        report["infrastructure_error"] = str(error)
        print(f"static checks: infrastructure failure: {error}", file=sys.stderr)
        exit_code = 2
    finally:
        report["finished_utc"] = datetime.now(timezone.utc).isoformat()
        report["exit_code"] = exit_code
        report["passed_checks"] = sum(check["accepted"] for check in report["checks"])
        report["total_checks"] = len(report["checks"])
        report_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        (work / "report.json").write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        print(f"static report: {report_path}", flush=True)
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
