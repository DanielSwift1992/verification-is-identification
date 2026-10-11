#!/usr/bin/env python3
"""Numerical QA of compiler-exported continuations on the local Braket runner.

This file does not derive a continuation or infer a joint source law. The
compiler supplies both. A private fixture prepares each declared classical
branch, while bind_continuation receives only the compiled plan and its actual
acquired record. Literal matrices in oracle.py provide an independent expected
meaning. Branch expansion is test execution of a finite mixture, not an
enumeration offered as proof of IiS45/46. There are no cloud execution paths.
"""

import argparse
from datetime import datetime, timezone
from fractions import Fraction
import hashlib
import json
import math
from pathlib import Path
import subprocess
import sys
from time import perf_counter

import oracle


TOLERANCE = 1.0e-9
MAX_JOBS = 2048
SAMPLE_SHOTS = 512
SAMPLE_ALPHA = 0.01
# Chosen before execution; exactly one batch, never retried until it passes.
SAMPLE_REQUESTS = (
    ("X", "zero"), ("X", "plus"),
    ("Y", "plus_i"), ("Y", "minus_i"),
    ("Z", "zero"), ("Z", "one"),
    ("Y", "zero"), ("X", "plus_i"),
)
PLAN_FIELDS = {
    "name", "question", "record_count", "decisions", "exact",
    "loss_numerator", "loss_denominator", "execution",
}
from runtime import EXECUTION_FIELDS, CheckFailure, require, write_json, load_json, unique_object, bind_continuation
EXPECTED_LOSSES = {
    "ParityY": Fraction(0), "ParityX": Fraction(1, 2),
    "ParityZ": Fraction(1, 2), "ParityState": Fraction(1, 2),
    "FullState": Fraction(0), "SharedEcho": Fraction(0),
    "FreshEcho": Fraction(1, 2), "GenuineMemory": Fraction(0),
    "UnboundMemory": Fraction(1, 2), "AfterH": Fraction(0),
    "JointKey": Fraction(0), "DroppedKey": Fraction(1, 2),
    "BSCShared": Fraction(0), "BSCIndependent": Fraction(3, 8),
    "BSCExclusive": Fraction(1, 2),
}
PREPARATIONS = {
    "zero": (), "one": ("x",), "plus": ("h",),
    "minus": ("x", "h"), "plus_i": ("h", "s"),
    "minus_i": ("h", "s", "s", "s"),
}




def acquired_record(acquisitions, valuation, control_count):
    # This belongs to fixture preparation, not to bind_continuation.
    bits = []
    for indices in acquisitions:
        value = 0
        for index in indices:
            value ^= oracle.control_bit(valuation, control_count, index)
        bits.append(str(value))
    return "".join(bits)


def sign_from_literal_pauli(label, question):
    p, q = oracle.PAULIS[label], oracle.PAULIS[question]
    transported = oracle.multiply(oracle.multiply(oracle.dagger(p), q), p)
    if oracle.max_entry_error(transported, q) < TOLERANCE:
        return "0"
    negative = tuple(tuple(-x for x in row) for row in q)
    require(oracle.max_entry_error(transported, negative) < TOLERANCE,
            "literal action is outside the Pauli-question family")
    return "1"


def validate_inputs(sources, continuations):
    require(sources.get("schema") == "vi.braket.sources.v1", "wrong source schema")
    require(continuations.get("schema") == "vi.braket.continuations.v1", "wrong continuation schema")
    count = sources.get("control_count")
    require(type(count) is int and count == 4, "this bridge expects four fixture coordinates")
    models, plans = sources.get("models"), continuations.get("plans")
    require(isinstance(models, list) and isinstance(plans, list), "missing compiler model/plan list")
    by_name = {}
    for plan in plans:
        require(isinstance(plan, dict) and set(plan) == PLAN_FIELDS, "invalid continuation fields")
        require(type(plan["name"]) is str and plan["name"] not in by_name, "duplicate/invalid plan name")
        require(type(plan["loss_numerator"]) is int and type(plan["loss_denominator"]) is int
                and 0 <= plan["loss_numerator"] <= plan["loss_denominator"]
                and plan["loss_denominator"] > 0, "invalid claimed finite loss")
        require(type(plan["exact"]) is bool and plan["exact"] == (plan["loss_numerator"] == 0),
                "exact flag disagrees with claimed loss")
        require(isinstance(plan["decisions"], dict), "missing public decision table")
        by_name[plan["name"]] = plan
    seen = set()
    for model in models:
        require(set(model) == {"name", "question", "operations", "acquisitions", "rows"},
                "invalid source model fields")
        name = model["name"]
        require(name not in seen and name in by_name, "source/continuation names do not correspond")
        seen.add(name)
        plan = by_name[name]
        require(plan["question"] == model["question"], name + ": changed final question")
        require(plan["record_count"] == len(model["acquisitions"]), name + ": changed record width")
        require(len(plan["execution"]["input_records"]) == plan["record_count"]
                and plan["execution"]["measure_payload"] == (model["question"] != "State"),
                name + ": executable output/record scope differs from the formal plan")
        for indices in model["acquisitions"]:
            require(isinstance(indices, list) and all(type(i) is int and 0 <= i < count for i in indices),
                    name + ": invalid acquisition coordinates")
        rows = model["rows"]
        require(len(rows) == (1 << count), name + ": incomplete fixture valuation table")
        seen_rows, active_records, total = set(), set(), 0
        for row in rows:
            require(set(row) == {"index", "weight", "record", "frame", "target"}, "invalid fixture row")
            index, weight = row["index"], row["weight"]
            require(type(index) is int and 0 <= index < (1 << count) and index not in seen_rows,
                    name + ": invalid/duplicate fixture index")
            seen_rows.add(index)
            require(type(weight) is int and weight >= 0, name + ": invalid source weight")
            actual, ideal = oracle.literal_unitaries(model["operations"], index, count)
            label = oracle.independent_frame_label(actual, ideal)
            require(label == row["frame"], name + ": typed frame differs from literal matrices")
            expected_target = label if model["question"] == "State" else sign_from_literal_pauli(label, model["question"])
            require(expected_target == row["target"], name + ": typed question differs from literal matrices")
            record = acquired_record(model["acquisitions"], index, count)
            require(record == row["record"], name + ": acquisition differs from the exported source relation")
            if weight:
                active_records.add(record)
                bind_continuation(plan["execution"], record)
            total += weight
        require(total > 0 and total == plan["loss_denominator"], name + ": source weights changed")
        require(set(plan["decisions"]) == active_records, name + ": decision domain differs from available records")
        require(set(plan["execution"]["by_record"]) == active_records,
                name + ": executable domain differs from available records")
        if name in EXPECTED_LOSSES:
            require(Fraction(plan["loss_numerator"], total) == EXPECTED_LOSSES[name],
                    name + ": independently specified fixture expectation disagrees")
    require(seen == set(by_name), "extra continuation without an actual source model")
    require(set(EXPECTED_LOSSES) <= seen, "required base cases are missing")
    # Test the runtime boundary without handing a private fixture to the binder.
    probe = by_name["AfterH"]
    for invalid in ({"record": "1", "latent": 1}, "10", "x"):
        try:
            bind_continuation(probe["execution"], invalid)
        except CheckFailure:
            pass
        else:
            raise CheckFailure("runtime binding admitted unavailable extra input")
    return count, models, by_name


def source_lines(operations, valuation, control_count, wire):
    lines = []
    for op in operations:
        gate = op["gate"]
        if gate == "z":
            # Opaque contact boundaries stay visible in the fixture artifact.
            lines.append("// fixture: recorded Z contact, control {}".format(op["control"]))
            if oracle.control_bit(valuation, control_count, op["control"]):
                lines.append("z q[{}];".format(wire))
        elif gate in ("h", "s"):
            lines.append("{} q[{}];".format(gate, wire))
        else:
            raise CheckFailure("unsupported source operation during export")
    return lines


def analyzer(question):
    if question == "X":
        return ["h q[0];"], oracle.H
    if question == "Y":
        # Chronological S-dagger then H: (H S-dagger)^dagger Z (H S-dagger)=Y.
        return ["s q[0];", "s q[0];", "s q[0];", "h q[0];"], oracle.multiply(oracle.H, oracle.dagger(oracle.S))
    require(question == "Z", "unsupported analyzer")
    return [], oracle.I


def qasm_job(model, row, control_count, bound, state=None):
    question = model["question"]
    if question == "State":
        lines = ["OPENQASM 3.0;", "qubit[2] q;", "h q[0];", "cnot q[0], q[1];"]
        lines += source_lines(model["operations"], row["index"], control_count, 1)
        # The fixture relocates logical payload 0 to physical data wire 1.
        lines += ["{} q[1];".format(gate) for gate in bound["gates"]]
        lines.append("#pragma braket result density_matrix q[0], q[1]")
    else:
        lines = ["OPENQASM 3.0;", "qubit[1] q;"]
        lines += ["{} q[0];".format(gate) for gate in PREPARATIONS[state]]
        lines += source_lines(model["operations"], row["index"], control_count, 0)
        lines += ["{} q[0];".format(gate) for gate in bound["gates"]]
        lines += ["{} q[0];".format(gate) for gate in bound["analyzer"]]
        lines.append("#pragma braket result density_matrix q[0]")
    return "\n".join(lines) + "\n"


def decode_complex(value):
    if isinstance(value, dict):
        require(set(value) == {"real", "imag"}, "unexpected SDK complex encoding")
        result = complex(value["real"], value["imag"])
    else:
        result = complex(value)
    require(math.isfinite(result.real) and math.isfinite(result.imag), "non-finite SDK matrix entry")
    return result


def sdk_density(result, dimension):
    require(result["shots"] == 0 and len(result["values"]) == 1, "missing single density result")
    raw = result["values"][0]
    require(len(raw) == dimension and all(len(row) == dimension for row in raw), "wrong SDK tensor dimensions")
    matrix = tuple(tuple(decode_complex(x) for x in row) for row in raw)
    require(abs(sum(matrix[i][i] for i in range(dimension)) - 1) <= TOLERANCE, "SDK density trace failed")
    require(max(abs(matrix[i][j] - matrix[j][i].conjugate()) for i in range(dimension)
                for j in range(dimension)) <= TOLERANCE, "SDK density Hermiticity failed")
    require(all(-TOLERANCE <= matrix[i][i].real <= 1 + TOLERANCE for i in range(dimension)),
            "SDK diagonal is not a probability")
    return matrix


def weighted_sum(entries):
    dimension = len(entries[0][1])
    return tuple(tuple(sum(weight * matrix[i][j] for weight, matrix in entries)
                       for j in range(dimension)) for i in range(dimension))


def overlap(left, right):
    value = sum(left[i][j] * right[j][i] for i in range(len(left)) for j in range(len(left)))
    require(abs(value.imag) <= TOLERANCE, "non-real Choi overlap")
    return value.real


def build_jobs(models, plans, control_count):
    jobs, contexts = [], []
    for model in models:
        plan = plans[model["name"]]
        total = sum(row["weight"] for row in model["rows"])
        for row in model["rows"]:
            if row["weight"] == 0:
                continue
            record = acquired_record(model["acquisitions"], row["index"], control_count)
            bound = bind_continuation(plan["execution"], record)
            formal_decision = plan["decisions"][record]
            actual, ideal = oracle.literal_unitaries(model["operations"], row["index"], control_count)
            states = [None] if model["question"] == "State" else list(PREPARATIONS)
            for state in states:
                identifier = "density-{:04d}".format(len(jobs))
                if state is None:
                    require(formal_decision in oracle.PAULIS, "invalid formal Pauli decision")
                    output = oracle.multiply(oracle.PAULIS[formal_decision], actual)
                    # Check applicability of the declared Pauli-mixture error formula.
                    residual = oracle.independent_frame_label(output, ideal)
                    expected = oracle.choi_density(output)
                else:
                    require(formal_decision in ("0", "1") and bound["relabel"] == int(formal_decision),
                            "executable outcome relabel differs from the checked decision")
                    output = oracle.multiply(analyzer(model["question"])[1], actual)
                    residual = None
                    expected = oracle.output_density(output, oracle.STATES[state])
                qasm = qasm_job(model, row, control_count, bound, state)
                jobs.append({"id": identifier, "qasm": qasm, "shots": 0})
                contexts.append({"id": identifier, "model": model["name"], "question": model["question"],
                                 "row": row["index"], "record": record, "bound": bound,
                                 "state": state, "formal_decision": formal_decision, "weight": row["weight"] / total,
                                 "expected": expected, "ideal": ideal, "actual": actual,
                                 "residual": residual, "qasm": qasm})
    return jobs, contexts


def add_negative_jobs(jobs, models, plans, control_count):
    by_name = {m["name"]: m for m in models}
    negative = {"wrong_after_h": [], "misbound_memory": []}
    model, plan = by_name["AfterH"], plans["AfterH"]
    for row in model["rows"]:
        if row["weight"] and plan["decisions"][row["record"]] == "X":
            actual, ideal = oracle.literal_unitaries(model["operations"], row["index"], control_count)
            identifier = "negative-wrong-after-h"
            bound = dict(bind_continuation(plan["execution"], row["record"]), gates=["z"])
            jobs.append({"id": identifier, "qasm": qasm_job(model, row, control_count, bound), "shots": 0})
            negative["wrong_after_h"].append({"id": identifier,
                "expected_mutation": oracle.choi_density(oracle.multiply(oracle.Z, actual)),
                "required": oracle.choi_density(ideal)})
            break
    require(negative["wrong_after_h"], "AfterH lacks its nondegenerate mutation witness")

    model, plan = by_name["GenuineMemory"], plans["GenuineMemory"]
    require(model["acquisitions"] == [[0]], "misbinding fixture expects the declared genuine source bit")
    total = sum(row["weight"] for row in model["rows"])
    marginals = {"declared": {"0": 0, "1": 0}, "injected": {"0": 0, "1": 0}}
    relation_failures = 0
    for row in model["rows"]:
        if not row["weight"]:
            continue
        true_record = acquired_record(model["acquisitions"], row["index"], control_count)
        # Deliberate fixture violation, kept out of the positive model/law.
        injected_record = str(oracle.control_bit(row["index"], control_count, 1))
        relation_failures += int(true_record != injected_record)
        marginals["declared"][true_record] += row["weight"]
        marginals["injected"][injected_record] += row["weight"]
        bound = bind_continuation(plan["execution"], injected_record)
        formal_decision = plan["decisions"][injected_record]
        actual, ideal = oracle.literal_unitaries(model["operations"], row["index"], control_count)
        identifier = "negative-misbound-{:02d}".format(len(negative["misbound_memory"]))
        jobs.append({"id": identifier, "qasm": qasm_job(model, row, control_count, bound), "shots": 0})
        negative["misbound_memory"].append({"id": identifier, "weight": row["weight"] / total,
            "expected_mutation": oracle.choi_density(oracle.multiply(oracle.PAULIS[formal_decision], actual)),
            "required": oracle.choi_density(ideal)})
    require(relation_failures > 0 and marginals["declared"] == marginals["injected"],
            "misbinding mutation must violate association while retaining the record marginal")
    negative["source_relation_failures"] = relation_failures
    negative["record_marginals_equal"] = True
    return negative


def sampling_precommit(contexts):
    jobs, checks = [], []
    for index, (question, state) in enumerate(SAMPLE_REQUESTS):
        candidates = [c for c in contexts if c["question"] == question and c["state"] == state]
        require(candidates, "required sampling question/preparation is unavailable")
        context = candidates[0]
        lines = [line for line in context["qasm"].splitlines() if not line.startswith("#pragma")]
        lines.insert(2, "bit[1] out;")
        lines.append("out[0] = measure q[0];")
        identifier = "sample-{:02d}".format(index)
        jobs.append({"id": identifier, "qasm": "\n".join(lines) + "\n", "shots": SAMPLE_SHOTS})
        checks.append({"id": identifier, "density_job": context["id"], "model": context["model"],
                       "question": question, "state": state,
                       "raw_probability_zero": context["expected"][0][0].real})
    return jobs, {"schema": "vi.braket.sampling-precommit.v1", "job_count": len(jobs),
                  "shots_per_job": SAMPLE_SHOTS, "family_alpha": SAMPLE_ALPHA,
                  "absolute_tolerance": math.sqrt(math.log(2 * len(jobs) / SAMPLE_ALPHA) / (2 * SAMPLE_SHOTS)),
                  "retry_policy": "one fixed batch; no retry until pass", "checks": checks}


def execute_runner(python, artifacts, jobs, stem, log):
    input_path = artifacts / (stem + "-jobs.json")
    output_path = artifacts / (stem + "-results.json")
    write_json(input_path, {"schema": "vi.braket.jobs.v1", "jobs": jobs})
    command = [python, str(Path(__file__).with_name("runner.py")), "--jobs", str(input_path), "--output", str(output_path)]
    started = perf_counter()
    completed = subprocess.run(command, text=True, capture_output=True, timeout=600)
    log.append({"phase": stem, "command": command, "wall_seconds": perf_counter() - started,
                "returncode": completed.returncode, "stdout": completed.stdout, "stderr": completed.stderr})
    require(completed.returncode == 0, "external local runner failed during {}: {}".format(stem, completed.stderr.strip()))
    result = load_json(output_path)
    require(result.get("schema") == "vi.braket.results.v1" and result.get("status") == "completed"
            and result.get("backend") == "braket_dm", "runner did not provide a completed local density result")
    returned = result.get("jobs", [])
    require(len(returned) == len(jobs) and len({r["id"] for r in returned}) == len(jobs)
            and {r["id"] for r in returned} == {j["id"] for j in jobs}, "runner result identity mismatch")
    return result, {r["id"]: r for r in returned}


def check_density_results(contexts, results, models, plans):
    groups, branch_checks = {}, []
    for context in contexts:
        dimension = 4 if context["question"] == "State" else 2
        matrix = sdk_density(results[context["id"]], dimension)
        discrepancy = oracle.max_entry_error(matrix, context["expected"])
        require(discrepancy <= TOLERANCE, "external branch differs from independent matrices: " + context["id"])
        groups.setdefault(context["model"], []).append((context, matrix))
        branch_checks.append({"id": context["id"], "model": context["model"],
                              "input": context["state"] or "normalized Choi", "max_entry_error": discrepancy})
    model_checks = []
    for model in models:
        name, plan = model["name"], plans[model["name"]]
        entries = groups[name]
        claimed = plan["loss_numerator"] / plan["loss_denominator"]
        if model["question"] == "State":
            density = weighted_sum([(c["weight"], m) for c, m in entries])
            ideal_density = oracle.choi_density(entries[0][0]["ideal"])
            success = overlap(ideal_density, density)
            observed = 1 - success
            identity_weight = sum(c["weight"] for c, _ in entries if c["residual"] == "I")
            require(abs(success - identity_weight) <= TOLERANCE, name + ": Choi overlap differs from its literal Pauli mixture")
            exact_discrepancy = oracle.max_entry_error(density, ideal_density)
            detail = {"choi_overlap_success": success, "literal_identity_weight": identity_weight,
                      "exact_ideal_matrix_discrepancy": exact_discrepancy,
                      "measure": "Choi overlap check; half-diamond formula applies only by the admitted Pauli-mixture theorem"}
        else:
            probabilities, ideals = {}, {}
            for context, matrix in entries:
                state = context["state"]
                raw = matrix[0][0].real
                probability = 1 - raw if context["bound"]["relabel"] else raw
                probabilities[state] = probabilities.get(state, 0.0) + context["weight"] * probability
                ideals[state] = oracle.effect_probability(
                    oracle.derive_effect(context["ideal"], model["question"]), oracle.STATES[state])
            differences = {state: abs(probabilities[state] - ideals[state]) for state in PREPARATIONS}
            observed = max(differences.values())
            average_diagonal = (probabilities["zero"] + probabilities["one"]) / 2
            upper_right = complex(probabilities["plus"] - average_diagonal,
                                  average_diagonal - probabilities["plus_i"])
            measured_effect = ((complex(probabilities["zero"]), upper_right),
                               (upper_right.conjugate(), complex(probabilities["one"])))
            literal_effects = [(c["weight"], oracle.derive_effect(c["actual"], model["question"], int(c["formal_decision"])))
                               for c, _ in entries if c["state"] == "zero"]
            require(oracle.max_entry_error(measured_effect, weighted_sum(literal_effects)) <= TOLERANCE,
                    name + ": measured effect differs from its literal interpretation")
            ideal_effect = oracle.derive_effect(entries[0][0]["ideal"], model["question"])
            exact_discrepancy = oracle.max_entry_error(measured_effect, ideal_effect)
            detail = {"probabilities": probabilities, "ideal_probabilities": ideals,
                      "six_input_worst_probability_error": observed,
                      "exact_ideal_effect_discrepancy": exact_discrepancy,
                      "measure": "worst probability error in the declared Pauli/Clifford question family"}
        require(abs(observed - claimed) <= TOLERANCE, name + ": observed bounded error differs from the exported claim")
        if plan["exact"]:
            require(exact_discrepancy <= TOLERANCE, name + ": an exact continuation failed its independently defined target")
        if name in EXPECTED_LOSSES:
            require(abs(observed - float(EXPECTED_LOSSES[name])) <= TOLERANCE, name + ": literal case expectation failed")
        model_checks.append(dict({"name": name, "question": model["question"], "exact": plan["exact"],
                                  "claimed_error": claimed, "observed_error": observed}, **detail))
    return model_checks, branch_checks


def check_negatives(negative, results):
    wrong = negative["wrong_after_h"][0]
    matrix = sdk_density(results[wrong["id"]], 4)
    require(oracle.max_entry_error(matrix, wrong["expected_mutation"]) <= TOLERANCE,
            "wrong-correction fixture did not execute its declared mutation")
    wrong_discrepancy = oracle.max_entry_error(matrix, wrong["required"])
    require(wrong_discrepancy > TOLERANCE and abs(overlap(matrix, wrong["required"])) <= TOLERANCE,
            "wrong Z-after-H mutation was not detected by the Choi target")
    entries = []
    for entry in negative["misbound_memory"]:
        matrix = sdk_density(results[entry["id"]], 4)
        require(oracle.max_entry_error(matrix, entry["expected_mutation"]) <= TOLERANCE,
                "misbound fixture did not execute its explicitly changed acquisition")
        entries.append((entry["weight"], matrix))
    density = weighted_sum(entries)
    misbound_error = 1 - overlap(density, negative["misbound_memory"][0]["required"])
    require(abs(misbound_error - 0.5) <= TOLERANCE, "independent replacement did not expose its expected error")
    return {
        "WrongZAfterH": {"outcome": "expected semantic rejection", "choi_matrix_discrepancy": wrong_discrepancy},
        "MisboundMemory": {"outcome": "expected source-relation and ideal-channel rejection",
                           "declared_acquisition": [[0]], "injected_acquisition": [[1]],
                           "positive_model_modified": False,
                           "record_marginals_equal": negative["record_marginals_equal"],
                           "source_relation_failures": negative["source_relation_failures"],
                           "observed_choi_overlap_error": misbound_error},
    }


def check_samples(precommit, results):
    checks = []
    for item in precommit["checks"]:
        result = results[item["id"]]
        require(result["shots"] == SAMPLE_SHOTS and result["measured_qubits"] == [0],
                "sample count or measured-qubit order changed")
        counts = result["measurement_counts"]
        require(set(counts) <= {"0", "1"} and all(type(n) is int and n >= 0 for n in counts.values())
                and sum(counts.values()) == SAMPLE_SHOTS, "invalid one-qubit sampling counts")
        observed = counts.get("0", 0) / SAMPLE_SHOTS
        deviation = abs(observed - item["raw_probability_zero"])
        require(deviation <= precommit["absolute_tolerance"],
                "fixed sampling batch failed its precommitted family bound: " + item["id"])
        checks.append(dict(item, observed_frequency_zero=observed, deviation=deviation))
    return checks


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifacts", type=Path, required=True)
    parser.add_argument("--python", default=sys.executable, help="isolated Python interpreter with the Braket SDK")
    args = parser.parse_args()
    artifacts = args.artifacts.resolve()
    artifacts.mkdir(parents=True, exist_ok=True)
    report_path = artifacts / "experiment-report.json"
    started = perf_counter()
    report = {"schema": "vi.braket.experiment.v1", "status": "running",
              "started_utc": datetime.now(timezone.utc).isoformat(),
              "numerical_tolerance": TOLERANCE, "runner_log": [],
              "boundary": "local simulator QA, not a physical experiment or a computed general diamond norm"}
    write_json(report_path, report)
    try:
        oracle.self_check()
        source_path, plan_path = artifacts / "sources.json", artifacts / "continuations.json"
        report["input_sha256"] = {path.name: hashlib.sha256(path.read_bytes()).hexdigest() for path in (source_path, plan_path)}
        count, models, plans = validate_inputs(load_json(source_path), load_json(plan_path))
        jobs, contexts = build_jobs(models, plans, count)
        negatives = add_negative_jobs(jobs, models, plans, count)
        sample_jobs, precommit = sampling_precommit(contexts)
        require(len(jobs) + len(sample_jobs) <= MAX_JOBS, "precommitted job budget exceeded")
        # Written before either SDK run; sampling remains conditional on all density checks.
        write_json(artifacts / "sampling-precommit.json", precommit)
        report["fixture_and_export_seconds"] = perf_counter() - started
        report["density_job_count"] = len(jobs)
        report["sampling_job_count"] = len(sample_jobs)
        report["total_shots"] = len(sample_jobs) * SAMPLE_SHOTS
        write_json(report_path, report)
        density_run, results = execute_runner(args.python, artifacts, jobs, "density", report["runner_log"])
        report["backend"] = density_run["backend"]
        report["sdk_versions"] = density_run["package_versions"]
        report["runner_python"] = density_run["python_version"]
        report["models"], report["branches"] = check_density_results(contexts, results, models, plans)
        report["negative_checks"] = check_negatives(negatives, results)
        report["density_checks_passed"] = True
        write_json(report_path, report)
        _, samples = execute_runner(args.python, artifacts, sample_jobs, "sampling", report["runner_log"])
        report["sampling_checks"] = check_samples(precommit, samples)
        report["sampling_family_alpha"] = SAMPLE_ALPHA
        report["status"] = "passed"
    except Exception as error:
        report["status"] = "failed"
        report["failure_type"] = type(error).__name__
        report["failure"] = str(error)
        print("bridge experiment failed: {}".format(error), file=sys.stderr)
    finally:
        report["completed_utc"] = datetime.now(timezone.utc).isoformat()
        report["elapsed_seconds"] = perf_counter() - started
        write_json(report_path, report)
    if report["status"] != "passed":
        return 1
    print("bridge experiment passed: {} models, {} density jobs, {} fixed sampling jobs".format(
        len(report["models"]), report["density_job_count"], report["sampling_job_count"]))
    print("report: " + str(report_path))
    return 0


if __name__ == "__main__":
    sys.exit(main())
