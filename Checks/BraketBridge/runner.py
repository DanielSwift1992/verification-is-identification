#!/usr/bin/env python3
"""Run exported OpenQASM jobs on the official local Braket density simulator.

Python 3.9+. This adapter contains no VI rules, planning, expected results, or
simulation implementation. The only backend is LocalSimulator("braket_dm").

Input:  {"schema": "vi.braket.jobs.v1", "jobs": [{"id", "qasm", "shots"}, ...]}
Output: vi.braket.results.v1; arrays become nested lists and complex entries
become {"real": number, "imag": number}. Sampled jobs have an empty values list.

Density-matrix tensor factors follow their explicit QASM result target order;
the first listed target is the most significant factor. Measurement bitstrings
follow the returned measured_qubits order. No bitstring or tensor reversal is
performed here. Sampling uses the simulator's randomness without a supplied seed.

Validation errors exit 2. SDK, execution, or output errors exit 1. Results are
written atomically only after every job succeeds; an existing output is unchanged
on failure, so callers must check the exit status before using it.
"""

import argparse
from datetime import datetime, timezone
from importlib import metadata
import json
import math
import os
from pathlib import Path
import socket
import sys
import tempfile
from time import perf_counter


INPUT_SCHEMA = "vi.braket.jobs.v1"
OUTPUT_SCHEMA = "vi.braket.results.v1"
MAX_JOBS = 2048
MAX_SHOTS = 4096


class ValidationError(ValueError):
    pass


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValidationError("duplicate JSON object key: {!r}".format(key))
        result[key] = value
    return result


def reject_constant(value):
    raise ValidationError("non-finite JSON constant: {}".format(value))


def load_jobs(path):
    try:
        with path.open("r", encoding="utf-8") as handle:
            document = json.load(
                handle, object_pairs_hook=unique_object, parse_constant=reject_constant
            )
    except (OSError, UnicodeError, json.JSONDecodeError) as error:
        raise ValidationError("cannot read jobs JSON: {}".format(error)) from error
    if not isinstance(document, dict) or set(document) != {"schema", "jobs"}:
        raise ValidationError("top-level fields must be exactly schema and jobs")
    if document["schema"] != INPUT_SCHEMA:
        raise ValidationError("unsupported jobs schema")
    jobs = document["jobs"]
    if not isinstance(jobs, list) or not 1 <= len(jobs) <= MAX_JOBS:
        raise ValidationError("jobs must contain between 1 and {} entries".format(MAX_JOBS))
    seen = set()
    for index, job in enumerate(jobs):
        prefix = "job {}".format(index)
        if not isinstance(job, dict) or set(job) != {"id", "qasm", "shots"}:
            raise ValidationError(prefix + " fields must be exactly id, qasm, shots")
        if not isinstance(job["id"], str) or not job["id"].strip():
            raise ValidationError(prefix + " id must be a nonempty string")
        if job["id"] in seen:
            raise ValidationError("duplicate job id: {!r}".format(job["id"]))
        seen.add(job["id"])
        if not isinstance(job["qasm"], str) or not job["qasm"].strip():
            raise ValidationError(prefix + " qasm must be a nonempty string")
        if type(job["shots"]) is not int or not 0 <= job["shots"] <= MAX_SHOTS:
            raise ValidationError(prefix + " shots must be an integer in [0, {}]".format(MAX_SHOTS))
    return jobs


def json_value(value):
    """Serialize SDK values without changing their indices or numeric meaning."""
    if hasattr(value, "tolist"):
        return json_value(value.tolist())
    if isinstance(value, complex):
        return {"real": json_value(value.real), "imag": json_value(value.imag)}
    if isinstance(value, (list, tuple)):
        return [json_value(item) for item in value]
    if isinstance(value, dict):
        return {str(key): json_value(item) for key, item in value.items()}
    if isinstance(value, float) and not math.isfinite(value):
        raise ValueError("simulator returned a non-finite number")
    if value is None or isinstance(value, (str, bool, int, float)):
        return value
    raise TypeError("unsupported SDK result value type: {}".format(type(value).__name__))


def no_network(*args, **kwargs):
    raise RuntimeError("network access is outside this local-only runner")


def write_atomic(path, document):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary_path = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w", encoding="utf-8", prefix=path.name + ".", suffix=".tmp",
            dir=str(path.parent), delete=False
        ) as handle:
            temporary_path = Path(handle.name)
            json.dump(document, handle, indent=2, allow_nan=False)
            handle.write("\n")
        os.replace(str(temporary_path), str(path))
    finally:
        if temporary_path is not None and temporary_path.exists():
            temporary_path.unlink()


def run(jobs):
    # No AWS sessions, credential discovery, or cloud devices are constructed.
    socket.create_connection = no_network
    socket.socket.connect = no_network
    socket.socket.connect_ex = no_network
    from braket.devices import LocalSimulator
    from braket.ir.openqasm import Program

    device = LocalSimulator("braket_dm")
    versions = {
        name: metadata.version(name)
        for name in ("amazon-braket-sdk", "amazon-braket-default-simulator", "amazon-braket-schemas")
    }
    completed = []
    for job in jobs:
        started = perf_counter()
        try:
            result = device.run(Program(source=job["qasm"]), shots=job["shots"]).result()
            measured = result.measured_qubits
            completed.append({
                "id": job["id"],
                "shots": job["shots"],
                "values": json_value(result.values) if job["shots"] == 0 else [],
                "measurement_counts": json_value(dict(result.measurement_counts or {})),
                "measured_qubits": json_value(measured) if measured is not None else [],
                "duration_seconds": perf_counter() - started,
            })
        except Exception as error:
            raise RuntimeError("job {!r} failed: {}".format(job["id"], error)) from error
    return versions, completed


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--jobs", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args(argv)
    started = perf_counter()
    started_utc = datetime.now(timezone.utc).isoformat()
    try:
        if args.jobs.resolve() == args.output.resolve():
            raise ValidationError("jobs and output must be different files")
        jobs = load_jobs(args.jobs)
    except ValidationError as error:
        print("runner validation error: {}".format(error), file=sys.stderr)
        return 2
    try:
        versions, results = run(jobs)
        document = {
            "schema": OUTPUT_SCHEMA,
            "status": "completed",
            "backend": "braket_dm",
            "python_version": sys.version.split()[0],
            "package_versions": versions,
            "started_utc": started_utc,
            "completed_utc": datetime.now(timezone.utc).isoformat(),
            "elapsed_seconds": perf_counter() - started,
            "job_count": len(results),
            "total_shots": sum(job["shots"] for job in jobs),
            "jobs": results,
        }
        write_atomic(args.output, document)
    except Exception as error:
        print("runner execution error: {}".format(error), file=sys.stderr)
        return 1
    print("wrote {} local job results to {}".format(len(results), args.output))
    return 0


if __name__ == "__main__":
    sys.exit(main())
