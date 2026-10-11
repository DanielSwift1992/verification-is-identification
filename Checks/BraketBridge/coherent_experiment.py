#!/usr/bin/env python3
"""QA of checked coherent-control exports through the official local SDK.

The binder receives public r, a goal, exported packets, and source-owned handles;
it never receives an active memory bit. All evolution is performed by runner.py.
Literal Choi/product targets test the translation, not a general theorem. The
current door excludes local memory phase gates and measurement acquisition.
"""

import argparse
from copy import deepcopy
from dataclasses import dataclass
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from time import perf_counter

import experiment as qa
import oracle


require = qa.require
TOLERANCE = 1e-9
MODEL_FIELDS = {"name", "public", "operations", "ideal", "blocks"}
PLAN_FIELDS = {"public", "goal", "candidate", "source", "source_operations",
               "correction_operations", "ideal", "blocks", "interactions", "measurements", "memory"}
H_BELL = ((.25, .25, .25, -.25), (.25, .25, .25, -.25),
          (.25, .25, .25, -.25), (-.25, -.25, -.25, .25))
PLUS = ((.5, .5), (.5, .5))
PLUS_I = ((.5, -.5j), (.5j, .5))
MINUS_I = ((.5, .5j), (-.5j, .5))
ZERO = ((1, 0), (0, 0))


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def validate_blocks(blocks):
    require(type(blocks) is list and len(blocks) == 2, "two exact memory blocks required")
    for block in blocks:
        require(type(block) is dict and set(block) == {"phase", "word"}, "invalid block fields")
        require(type(block["phase"]) is int and 0 <= block["phase"] <= 3
                and block["word"] in ("I", "X", "Z", "XZ"), "invalid exact block")


def validate_operations(operations, public, live=True):
    require(type(operations) is list and len(operations) <= 128, "invalid bounded operation list")
    for operation in operations:
        require(type(operation) is dict, "operation must be an object")
        gate = operation.get("gate")
        if gate in ("h", "s"):
            require(set(operation) == {"gate"}, "surplus payload operation fields")
        elif gate in ("public_x", "public_z"):
            require(set(operation) == {"gate", "value"} and type(operation["value"]) is int
                    and operation["value"] == public, "operation changes the public control")
        elif gate in ("cx", "cz"):
            require(set(operation) == {"gate", "memory"} and operation["memory"] == "source-M",
                    "operation names a different memory")
            require(live, "operation uses withdrawn memory")
        elif gate == "withdraw_memory":
            require(set(operation) == {"gate"}, "invalid withdrawal fields")
            live = False
        else:
            # In particular memory_s is outside this executable door. Granting
            # it would change the two-interaction Joint resource question.
            raise qa.CheckFailure("unsupported coherent operation: {!r}".format(gate))
    return live


def validate_packets(models_document, plans_document):
    require(type(models_document) is dict and set(models_document) == {"schema", "models"}
            and models_document["schema"] == "vi.coherent.models.v1", "invalid coherent model document")
    require(type(plans_document) is dict and set(plans_document) == {"schema", "plans"}
            and plans_document["schema"] == "vi.coherent.continuations.v1", "invalid coherent plan document")
    require(type(models_document["models"]) is list and 1 <= len(models_document["models"]) <= 32,
            "invalid model registry")
    registry = {}
    for model in models_document["models"]:
        require(type(model) is dict and set(model) == MODEL_FIELDS, "invalid model fields")
        name, public = model["name"], model["public"]
        require(type(name) is str and name and name not in registry, "duplicate or missing model name")
        require(type(public) is int and public in (0, 1), "invalid public source bit")
        require(type(model["ideal"]) is list and all(g in ("h", "s") for g in model["ideal"]),
                "unsupported ideal word")
        validate_blocks(model["blocks"])
        validate_operations(model["operations"], public)
        registry[name] = model
    require(type(plans_document["plans"]) is list and len(plans_document["plans"]) == 4,
            "exactly four public-bit/goal plans required for this QA fixture")
    plans = {}
    for plan in plans_document["plans"]:
        require(type(plan) is dict and set(plan) == PLAN_FIELDS, "invalid continuation fields")
        public, goal = plan["public"], plan["goal"]
        require(type(public) is int and public in (0, 1) and goal in ("data", "joint"),
                "invalid continuation public bit or goal")
        require((public, goal) not in plans, "duplicate public-bit/goal continuation")
        require(type(plan["source"]) is str and plan["source"] in registry
                and type(plan["candidate"]) is str and plan["candidate"] in registry,
                "continuation endpoint absent from current registry")
        source, candidate = registry[plan["source"]], registry[plan["candidate"]]
        require(source["public"] == candidate["public"] == public, "source/candidate public control mismatch")
        require(plan["source_operations"] == source["operations"], "source packet differs from current model")
        live = validate_operations(plan["source_operations"], public)
        validate_operations(plan["correction_operations"], public, live)
        require(candidate["operations"] == plan["source_operations"] + plan["correction_operations"],
                "current candidate is not the exact source plus correction")
        require(plan["ideal"] == candidate["ideal"] == source["ideal"] == ["h"], "target ideal changed")
        require(plan["blocks"] == candidate["blocks"], "continuation blocks differ from current candidate")
        validate_blocks(plan["blocks"])
        require(all(block["word"] == "I" for block in plan["blocks"]), "data target not certified by identity words")
        if goal == "joint":
            require(plan["blocks"][0]["phase"] == plan["blocks"][1]["phase"], "unequal phases do not restore joint memory")
        require(type(plan["measurements"]) is int and plan["measurements"] == 0
                and plan["memory"] == "source-M", "unsupported measurement or carrier contract")
        interactions = sum(op["gate"] in ("cx", "cz") for op in plan["correction_operations"])
        require(type(plan["interactions"]) is int and plan["interactions"] == interactions,
                "interaction count differs from actual correction operations")
        # This is an explicit source family check, not a generic interpreter.
        expected_source = [{"gate": "cz", "memory": "source-M"},
                           {"gate": "public_z", "value": public}, {"gate": "h"},
                           {"gate": "cz", "memory": "source-M"}]
        expected_blocks = ([{"phase": 0, "word": "I"}, {"phase": 2, "word": "XZ"}]
                           if public == 0 else [{"phase": 0, "word": "X"}, {"phase": 0, "word": "Z"}])
        require(source["operations"] == expected_source and source["blocks"] == expected_blocks,
                "source is outside the independently specified parity-consistent family; XZ means X*Z")
        plans[public, goal] = plan
    require(set(plans) == {(r, goal) for r in (0, 1) for goal in ("data", "joint")}, "incomplete goal domain")
    return registry, plans


@dataclass(frozen=True)
class OwnedHandle:
    owner: object
    source_digest: str
    role: str
    wire: int


def allocate_source_handles(source, memory_wire, data_wire):
    """Trusted fixture allocation; one owner links the source's actual wires."""
    owner, fingerprint = object(), digest(source)
    return (OwnedHandle(owner, fingerprint, "memory", memory_wire),
            OwnedHandle(owner, fingerprint, "data", data_wire))


def lower_operations(operations, public, memory, data):
    lines = []
    for operation in operations:
        gate = operation["gate"]
        if gate in ("h", "s"):
            lines.append("{} q[{}];".format(gate, data.wire))
        elif gate in ("public_x", "public_z"):
            if public:
                lines.append("{} q[{}];".format(gate[-1], data.wire))
        elif gate in ("cx", "cz"):
            lines.append("{} q[{}], q[{}];".format("cnot" if gate == "cx" else "cz", memory.wire, data.wire))
        elif gate == "withdraw_memory":
            # Access removal has no invented physical reset operation.
            continue
        else:
            raise qa.CheckFailure("operation was not validated")
    return lines


def bind_runtime(public, goal, models_document, plans_document, memory, data):
    """Working boundary: public input and actual owned handles, never active t."""
    require(type(public) is int and public in (0, 1) and goal in ("data", "joint"), "invalid runtime record or goal")
    registry, plans = validate_packets(models_document, plans_document)
    plan = plans[public, goal]
    source = registry[plan["source"]]
    require(type(memory) is OwnedHandle and type(data) is OwnedHandle
            and memory.owner is data.owner and memory.role == "memory" and data.role == "data",
            "memory/data handles are not owned by one source")
    require(memory.source_digest == data.source_digest == digest(source), "handles belong to a different source")
    require(type(memory.wire) is int and type(data.wire) is int
            and 0 <= memory.wire <= 4 and 0 <= data.wire <= 4 and memory.wire != data.wire,
            "invalid owned wire layout")
    return {"source": lower_operations(plan["source_operations"], public, memory, data),
            "correction": lower_operations(plan["correction_operations"], public, memory, data),
            "plan": deepcopy(plan), "source_digest": digest(source)}


def literal_product(left, right):
    """Tensor product of fixed expected densities, never program evolution."""
    n = len(right)
    return tuple(tuple(left[i // n][j // n] * right[i % n][j % n]
                       for j in range(len(left) * n)) for i in range(len(left) * n))


def memory_choi(phase):
    return ((.5, 0, 0, phase.conjugate() / 2), (0, 0, 0, 0),
            (0, 0, 0, 0), (phase / 2, 0, 0, .5))


def wrong_carrier_target(public):
    # Literal real sign vectors for the two orthogonal mixture components.
    if public == 0:
        a, b = (1, 1, 1, -1, 1, -1, -1, -1), (-1, 1, 1, 1, 1, 1, 1, -1)
    else:
        a, b = (1, -1, 1, 1, 1, 1, -1, 1), (1, 1, -1, 1, -1, 1, -1, -1)
    return tuple(tuple((a[i] * a[j] + b[i] * b[j]) / 16 for j in range(8)) for i in range(8))


def build_jobs(models_document, plans_document):
    registry, plans = validate_packets(models_document, plans_document)
    jobs, contexts = [], []
    for public in (0, 1):
        for goal in ("data", "joint"):
            plan = plans[public, goal]
            require(plan["interactions"] == (1 if goal == "data" else 2), "fixture's expected selected interaction count changed")
            for group in ("joint_choi", "future_memory", "wrong_carrier"):
                memory_wire, data_wire = (1, 3) if group == "joint_choi" else (2, 1)
                memory, data = allocate_source_handles(registry[plan["source"]], memory_wire, data_wire)
                bound = bind_runtime(public, goal, models_document, plans_document, memory, data)
                if group == "joint_choi":
                    # Full channel Choi: references R_M and R_D remain untouched.
                    lines = ["OPENQASM 3.0;", "qubit[4] q;", "h q[0];", "cnot q[0], q[1];",
                             "h q[2];", "cnot q[2], q[3];"]
                    lines += bound["source"] + bound["correction"]
                    lines += ["#pragma braket result density_matrix q[0], q[1], q[2], q[3]"]
                    expected = literal_product(memory_choi(1j if goal == "data" else 1+0j), H_BELL)
                    order = ["R_M", "M", "R_D", "D"]
                else:
                    lines = ["OPENQASM 3.0;", "qubit[{}] q;".format(4 if group == "wrong_carrier" else 3),
                             "h q[0];", "cnot q[0], q[1];", "h q[2];"]
                    lines += bound["source"]
                    if group == "future_memory":
                        lines += bound["correction"] + ["h q[2];"]
                        expected = literal_product(H_BELL, MINUS_I if goal == "data" else ZERO)
                    else:
                        lines += ["h q[3];", "#pragma braket noise phase_flip(0.5) q[3]"]
                        # Deliberate physical negative, outside the accepted binder:
                        # redirect only its already lowered correction controls.
                        expected_controls = plan["interactions"]
                        redirected = [line.replace("q[2], q[1]", "q[3], q[1]") for line in bound["correction"]]
                        require(sum(a != b for a, b in zip(redirected, bound["correction"])) == expected_controls,
                                "negative carrier mutation did not address every correction interaction")
                        lines += redirected
                        expected = wrong_carrier_target(public)
                    lines += ["#pragma braket result density_matrix q[0], q[1], q[2]"]
                    order = ["R_D", "D", "M"]
                identifier = "{}_r{}_{}".format(group, public, goal)
                jobs.append({"id": identifier, "qasm": "\n".join(lines) + "\n", "shots": 0})
                contexts.append({"id": identifier, "group": group, "public": public, "goal": goal,
                                 "order": order, "expected": expected, "binding": bound["source_digest"],
                                 "candidate": plan["candidate"], "interactions": plan["interactions"]})
    return jobs, contexts


def runtime_refusals(models_document, plans_document):
    registry, plans = validate_packets(models_document, plans_document)
    plan = plans[0, "data"]
    memory, data = allocate_source_handles(registry[plan["source"]], 2, 1)
    checks = []

    def refuse(name, models, packets, m=memory, d=data, public=0):
        try:
            bind_runtime(public, "data", models, packets, m, d)
        except qa.CheckFailure as error:
            checks.append({"name": name, "status": "rejected", "diagnostic": str(error)})
        else:
            raise qa.CheckFailure("runtime accepted adversary: " + name)

    packets = deepcopy(plans_document)
    packets["plans"][0]["active_t"] = 1
    refuse("private_value_in_packet", models_document, packets)
    packets = deepcopy(plans_document)
    packets["plans"][0]["source_operations"][0]["memory"] = "other-M"
    refuse("foreign_carrier_in_source_packet", models_document, packets)
    models = deepcopy(models_document)
    next(m for m in models["models"] if m["name"] == plan["candidate"])["operations"].append({"gate": "h"})
    refuse("stale_current_candidate", models, plans_document)
    other_memory, _ = allocate_source_handles(registry[plan["source"]], 3, 1)
    refuse("independently_allocated_carrier", models_document, plans_document, m=other_memory)
    refuse("non_bit_public_input", models_document, plans_document, public=True)
    for gate, operation in (("ungranted_memory_phase", {"gate": "memory_s", "memory": "source-M"}),
                            ("unknown_operation", {"gate": "mystery"}),
                            ("withdrawn_carrier", {"gate": "withdraw_memory"})):
        models, packets = deepcopy(models_document), deepcopy(plans_document)
        changed = next(p for p in packets["plans"] if p["public"] == 0 and p["goal"] == "data")
        changed["correction_operations"].insert(0, operation)
        candidate = next(m for m in models["models"] if m["name"] == changed["candidate"])
        candidate["operations"] = changed["source_operations"] + changed["correction_operations"]
        refuse(gate, models, packets)
    return checks


def check_results(contexts, results):
    checks = []
    for context in contexts:
        expected = context["expected"]
        matrix = qa.sdk_density(results[context["id"]], len(expected))
        error = oracle.max_entry_error(matrix, expected)
        require(error <= TOLERANCE, "density differs from literal target: " + context["id"])
        record = {k: v for k, v in context.items() if k != "expected"}
        record["max_entry_error"] = error
        if context["group"] == "joint_choi":
            alternate = literal_product(memory_choi(1+0j if context["goal"] == "data" else 1j), H_BELL)
            record["different_memory_phase_target_error"] = oracle.max_entry_error(matrix, alternate)
            require(record["different_memory_phase_target_error"] > .1, "joint Choi did not distinguish memory phase")
        elif context["group"] == "future_memory":
            probability = sum(matrix[i][i].real for i in range(0, 8, 2))
            expected_probability = .5 if context["goal"] == "data" else 1.0
            require(abs(probability - expected_probability) <= TOLERANCE, "future memory Z-read effect differs")
            record.update(future_z_probability_zero=probability, expected_probability_zero=expected_probability,
                          measurement_status="density-derived effect QA, no sampled acquisition")
        else:
            claimed = literal_product(H_BELL, PLUS_I if context["goal"] == "data" else PLUS)
            record["claimed_positive_target_error"] = oracle.max_entry_error(matrix, claimed)
            require(record["claimed_positive_target_error"] > .1, "wrong carrier did not disagree with positive target")
            rd = tuple(tuple(matrix[2*i][2*j] + matrix[2*i+1][2*j+1] for j in range(4)) for i in range(4))
            overlap = qa.overlap(H_BELL, rd)
            require(abs(overlap - .5) <= TOLERANCE, "wrong-carrier H-Bell overlap differs from literal half")
            record["payload_reference_ideal_overlap"] = overlap
        checks.append(record)
    return checks


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifacts", type=Path, required=True)
    parser.add_argument("--python", default=sys.executable, metavar="SDKPY")
    args = parser.parse_args()
    artifacts = args.artifacts.resolve()
    artifacts.mkdir(parents=True, exist_ok=True)
    report_path = artifacts / "coherent-experiment-report.json"
    started = perf_counter()
    report = {"schema": "vi.coherent.experiment.v1", "status": "running",
              "started_utc": datetime.now(timezone.utc).isoformat(), "numerical_tolerance": TOLERANCE,
              "scope": "source-bound SDK translation QA; no acquisition, proof search, or custom simulation",
              "coverage": "four full two-input Choi states; four future-memory effects; four physical carrier negatives",
              "runner_log": [], "total_shots": 0}
    qa.write_json(report_path, report)
    try:
        paths = [artifacts / "coherent-models.json", artifacts / "coherent-continuations.json"]
        report["input_sha256"] = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
        models, packets = [qa.load_json(path) for path in paths]
        registry, plans = validate_packets(models, packets)
        report["runtime_refusals"] = runtime_refusals(models, packets)
        jobs, contexts = build_jobs(models, packets)
        require(len(jobs) == 12, "fixed twelve-job budget changed")
        report["model_count"], report["plan_count"], report["density_job_count"] = len(registry), len(plans), len(jobs)
        jobs_path, results_path = artifacts / "coherent-density-jobs.json", artifacts / "coherent-density-results.json"
        qa.write_json(jobs_path, {"schema": "vi.braket.jobs.v1", "jobs": jobs})
        runner = Path(__file__).with_name("runner.py")
        command = [args.python, str(runner), "--jobs", str(jobs_path), "--output", str(results_path)]
        began = perf_counter()
        completed = subprocess.run(command, capture_output=True, text=True, timeout=60)
        report["runner_log"].append({"command": command, "returncode": completed.returncode,
                                     "stdout": completed.stdout, "stderr": completed.stderr,
                                     "elapsed_seconds": perf_counter() - began})
        require(completed.returncode == 0, "official local runner failed")
        sdk = qa.load_json(results_path)
        require(sdk.get("schema") == "vi.braket.results.v1" and sdk.get("status") == "completed"
                and sdk.get("backend") == "braket_dm", "invalid local SDK result envelope")
        require(type(sdk.get("jobs")) is list and len(sdk["jobs"]) == len(jobs)
                and {j["id"] for j in sdk["jobs"]} == {j["id"] for j in jobs}, "SDK result job identity mismatch")
        report["checks"] = check_results(contexts, {j["id"]: j for j in sdk["jobs"]})
        report["sdk_versions"], report["runner_python"] = sdk["package_versions"], sdk["python_version"]
        require(report["input_sha256"] == {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},
                "typed exports changed during SDK verification")
        report["artifact_sha256"] = {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                                      for p in (Path(__file__), runner, jobs_path, results_path)}
        report["status"] = "passed"
    except Exception as error:
        report.update(status="failed", failure_type=type(error).__name__, failure=str(error))
        print("coherent experiment failed: {}".format(error), file=sys.stderr)
    finally:
        report.update(completed_utc=datetime.now(timezone.utc).isoformat(), elapsed_seconds=perf_counter() - started)
        qa.write_json(report_path, report)
    if report["status"] != "passed":
        return 1
    print("coherent experiment passed: 12 density jobs, {} runtime refusals; {}".format(len(report["runtime_refusals"]), report_path))
    return 0


if __name__ == "__main__":
    sys.exit(main())
