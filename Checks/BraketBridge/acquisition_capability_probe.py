#!/usr/bin/env python3
"""Observe installed Braket measurement/feedforward semantics with four local jobs.

Python 3.9+. --python optionally runs this same probe under an existing SDK Python.
No installation, cloud access, custom simulation, or VI proof is involved. A
completed probe exits 0 even when feedback is rejected or behaves differently;
read the observations. Infrastructure/output failures exit 1. Finite sampling
agreement is evidence only and never enables State acquisition by itself.
"""

import argparse
from datetime import datetime, timezone
from importlib import metadata
from pathlib import Path
import socket
import subprocess
import sys
from time import perf_counter
import warnings

from runner import json_value, no_network, write_atomic


SCHEMA = "vi.braket.acquisition-capability.v1"
SHOTS = 256
PACKAGES = ("amazon-braket-sdk", "amazon-braket-default-simulator", "amazon-braket-schemas")
JOBS = (
    {
        "id": "measured_one_controls_x",
        "qasm": """OPENQASM 3.0;
qubit[2] q;
bit[2] b = "00";
x q[0];
b[0] = measure q[0];
if (b[0]) { x q[1]; }
b[1] = measure q[1];
""",
        "expected_probabilities": {"11": 1.0},
        "absolute_frequency_tolerance": 0.0,
        "purpose": "Actual measurement of M=1 must select X on D.",
    },
    {
        "id": "measurement_overwrites_one",
        "qasm": """OPENQASM 3.0;
qubit[2] q;
bit[2] b = "10";
i q[0];
b[0] = measure q[0];
if (b[0]) { x q[1]; }
b[1] = measure q[1];
""",
        "expected_probabilities": {"00": 1.0},
        "absolute_frequency_tolerance": 0.0,
        "purpose": "Measurement of M=0 must overwrite initialized b[0]=1.",
    },
    {
        "id": "h_measure_h_collapse",
        "qasm": """OPENQASM 3.0;
qubit[2] q;
bit[2] b = "00";
h q[0];
b[0] = measure q[0];
h q[0];
cnot q[0], q[1];
b[1] = measure q[1];
""",
        "expected_probabilities": {"00": 0.25, "01": 0.25, "10": 0.25, "11": 0.25},
        "absolute_frequency_tolerance": 0.125,
        "purpose": "First measurement and ancilla readout after H must be independent fair bits.",
    },
    {
        "id": "terminal_same_memory_cz",
        "qasm": """OPENQASM 3.0;
qubit[2] q;
bit[2] b = "00";
x q[0];
h q[1];
cz q[0], q[1];
h q[1];
b[0] = measure q[0];
b[1] = measure q[1];
""",
        "expected_probabilities": {"11": 1.0},
        "absolute_frequency_tolerance": 0.0,
        "purpose": "Terminally read the same M=1 that controls CZ on D=+.",
    },
)


def observe(device, program_type, job):
    record = dict(job, shots=SHOTS, expected_measured_qubits=[0, 1])
    started = perf_counter()
    with warnings.catch_warnings(record=True) as caught:
        warnings.simplefilter("always")
        try:
            result = device.run(program_type(source=job["qasm"]), shots=SHOTS).result()
            counts = json_value(dict(result.measurement_counts or {}))
            measured = json_value(result.measured_qubits)
            valid = (
                measured == [0, 1]
                and all(key in {"00", "01", "10", "11"} for key in counts)
                and all(type(value) is int and value >= 0 for value in counts.values())
                and sum(counts.values()) == SHOTS
            )
            frequencies = {key: value / SHOTS for key, value in counts.items()} if valid else {}
            deviations = {
                key: abs(frequencies.get(key, 0.0) - job["expected_probabilities"].get(key, 0.0))
                for key in {"00", "01", "10", "11"}
            } if valid else {}
            compatible = valid and max(deviations.values()) <= job["absolute_frequency_tolerance"]
            record.update(
                status="observed", measurement_counts=counts, measured_qubits=measured,
                observed_frequencies=frequencies, valid_sample_format=valid,
                maximum_frequency_deviation=max(deviations.values()) if valid else None,
                observation="compatible_with_expected_semantics" if compatible else "different_from_expected_semantics",
                compatible=compatible,
            )
        except Exception as error:
            record.update(status="rejected", error_type=type(error).__name__, error=str(error),
                          observation="semantics_not_demonstrated", compatible=False)
        record["warnings"] = [str(item.message) for item in caught]
    record["elapsed_seconds"] = perf_counter() - started
    return record


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--python", metavar="SDKPY", help="existing Python executable containing Braket")
    args = parser.parse_args(argv)
    if args.output.resolve() == Path(__file__).resolve():
        parser.error("output must not overwrite the probe")
    if args.python:
        try:
            return subprocess.run(
                [args.python, str(Path(__file__).resolve()), "--output", str(args.output.resolve())],
                check=False, timeout=60,
            ).returncode
        except (OSError, subprocess.TimeoutExpired) as error:
            print("capability probe launch failed: {}".format(error), file=sys.stderr)
            return 1

    started = perf_counter()
    report = {
        "schema": SCHEMA, "backend": "braket_dm", "python": sys.executable,
        "python_version": sys.version.split()[0],
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "scope": "finite installed-SDK behavior evidence; no proof or automatic capability promotion",
        "live_feedback_semantics_demonstrated": False,
        "complete_instrument_support_established": False,
        "state_acquisition_support": "not_established_by_this_probe",
        "limitations": [
            "Finite frequency agreement does not prove an instrument implementation.",
            "No zero-shot density, entangled-reference, or pause/resume capability is tested.",
            "Measurement bitstrings are interpreted in returned measured_qubits order.",
        ],
        "jobs": [],
    }
    exit_code = 0
    try:
        socket.create_connection = no_network
        socket.socket.connect = no_network
        socket.socket.connect_ex = no_network
        from braket.devices import LocalSimulator
        from braket.ir.openqasm import Program

        report["package_versions"] = {name: metadata.version(name) for name in PACKAGES}
        device = LocalSimulator("braket_dm")
        report["jobs"] = [observe(device, Program, job) for job in JOBS]
        report["live_feedback_semantics_demonstrated"] = all(job["compatible"] for job in report["jobs"])
        report["terminal_source_control_baseline_compatible"] = report["jobs"][-1]["compatible"]
        report["status"] = "completed"
    except Exception as error:
        report.update(status="infrastructure_failure", error_type=type(error).__name__, error=str(error))
        exit_code = 1
    report.update(completed_utc=datetime.now(timezone.utc).isoformat(),
                  elapsed_seconds=perf_counter() - started,
                  job_count=len(report["jobs"]), attempted_shots=len(report["jobs"]) * SHOTS)
    try:
        write_atomic(args.output, report)
    except Exception as error:
        print("capability probe output failed: {}".format(error), file=sys.stderr)
        return 1
    print("wrote acquisition capability observations to {}".format(args.output))
    return exit_code


if __name__ == "__main__":
    sys.exit(main())
