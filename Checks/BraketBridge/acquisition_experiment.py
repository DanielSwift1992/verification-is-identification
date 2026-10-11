#!/usr/bin/env python3
"""QA and terminal-contact execution of compiler-exported acquisitions.

The private fixture prepares a retained computational-basis memory once. The
same physical wire controls source CZ and is read at the terminal contact.
The working decoder receives only its exported execution, the existing public
record, and actual SDK outcome bits. It never receives a source row or seed.

shots=0 density checks are numerical QA, NOT acquired contact replies. A fixed
subsequent shots>0 batch performs the actual terminal measurements and feeds
their outcomes to the decoder. This realizes one classical output question;
it does not implement mid-circuit feedback or return an unknown quantum state.
Python 3.9+, local official Braket runner only. No planning or proof search.
"""

import argparse
from collections import defaultdict
from datetime import datetime, timezone
from fractions import Fraction
import hashlib
import math
from pathlib import Path
import sys
from time import perf_counter

import experiment as qa
import oracle
from runtime import decode_runtime, public_terminal_shape


TOLERANCE = 1.0e-9
MAX_JOBS = 2048
SAMPLE_SHOTS = 256
SAMPLE_ALPHA = 0.01
# All active fixture branches use this fixed sample menu, selected before SDK
# execution. Density QA uses all six eigenstates. There are no retry loops.
SAMPLE_PREPARATIONS = ("zero", "plus", "plus_i")
DATA_WIRE = 1
EXPECTED_LOSSES = {
    "LiveYBefore": Fraction(0), "LiveYAfter": Fraction(0),
    "LiveXBefore": Fraction(1, 2), "LiveXAfter": Fraction(0),
    "LiveZBefore": Fraction(1, 2), "LiveZAfter": Fraction(0),
    "LiveStateBefore": Fraction(1, 2), "LiveStateAfter": Fraction(0),
    "NoPortX": Fraction(1, 2), "WithdrawnX": Fraction(1, 2),
}
EXPECTED_CHOICES = {
    "AcquireY": ("skip", 0), "AcquireX": ("acquire", 1),
    "AcquireZ": ("acquire", 1), "AcquireState": ("acquire", 1),
    "NoPortX": ("unavailable", 0), "WithdrawnX": ("unavailable", 0),
}
require = qa.require




def literal_operations(operations):
    """Independent QA interpretation; resident lifetime is checked separately."""
    plain = []
    for operation in operations:
        gate = operation.get("gate")
        if gate == "retained_z":
            require(set(operation) == {"gate", "control", "cell"}, "invalid retained producer")
            plain.append({"gate": "z", "control": operation["control"]})
        elif gate == "withdraw_residents":
            require(set(operation) == {"gate"}, "invalid resident withdrawal")
        else:
            # oracle.literal_unitaries rejects unknown or surplus fields.
            plain.append(operation)
    return plain


def resident_layout(operations, control_count):
    """Map explicit source-owned cells to wires, preserving payload wire 1."""
    cells, live = {}, []
    for operation in operations:
        gate = operation.get("gate")
        if gate == "retained_z":
            require(set(operation) == {"gate", "control", "cell"}, "invalid retained operation fields")
            cell, control = operation["cell"], operation["control"]
            require(type(cell) is int and cell >= 0 and cell not in cells,
                    "each resident must be allocated once by its producer")
            require(type(control) is int and 0 <= control < control_count,
                    "resident control is outside source coordinates")
            slot = len(cells)
            cells[cell] = {"wire": 0 if slot == 0 else slot + 1, "control": control}
            live.insert(0, cell)
        elif gate == "withdraw_residents":
            require(set(operation) == {"gate"}, "invalid resident withdrawal fields")
            # Withdrawal removes the usable port. It is not silently treated
            # as a physical reset, whose quantum channel would be different.
            live = []
        else:
            require(gate in ("h", "s", "z"), "resident preservation is not established for this gate")
    require(len(cells) <= 3, "bounded QA supports at most three retained cells")
    return cells, live


def validate_inputs(sources, continuations, requests_document):
    require(sources.get("schema") == "vi.braket.sources.v1", "wrong sources schema")
    require(continuations.get("schema") == "vi.braket.continuations.v1", "wrong continuations schema")
    require(set(requests_document) == {"schema", "requests"}
            and requests_document["schema"] == "vi.acquisition.requests.v1", "wrong acquisition requests schema")
    count = sources.get("control_count")
    require(type(count) is int and 1 <= count <= 4, "unsupported bounded control count")
    models, plans = {}, {}
    for plan in continuations.get("plans", []):
        require(isinstance(plan, dict) and set(plan) == qa.PLAN_FIELDS, "invalid continuation fields")
        require(type(plan["name"]) is str and plan["name"] not in plans, "duplicate continuation")
        require(type(plan["loss_numerator"]) is int and type(plan["loss_denominator"]) is int
                and 0 <= plan["loss_numerator"] <= plan["loss_denominator"]
                and plan["loss_denominator"] > 0, "invalid claimed finite loss")
        require(type(plan["exact"]) is bool and plan["exact"] == (plan["loss_numerator"] == 0),
                "inconsistent exact claim")
        plans[plan["name"]] = plan
    for model in sources.get("models", []):
        require(set(model) == {"name", "question", "operations", "acquisitions", "rows"},
                "invalid source fields")
        name = model["name"]
        require(name not in models and name in plans, "duplicate or unplanned source")
        models[name] = model
        plan = plans[name]
        require(model["question"] in ("X", "Y", "Z", "State")
                and model["question"] == plan["question"], "changed output question")
        require(plan["record_count"] == len(model["acquisitions"]), "changed record width")
        resident_layout(model["operations"], count)
        operations = literal_operations(model["operations"])
        for indices in model["acquisitions"]:
            require(isinstance(indices, list) and all(type(i) is int and 0 <= i < count for i in indices),
                    "invalid initial acquisition expression")
        seen, active, total, incorrect_weight = set(), set(), 0, 0
        for row in model["rows"]:
            require(set(row) == {"index", "weight", "record", "frame", "target"}, "invalid fixture row")
            index, weight = row["index"], row["weight"]
            require(type(index) is int and 0 <= index < 1 << count and index not in seen,
                    "invalid or duplicate fixture index")
            require(type(weight) is int and weight >= 0, "invalid declared joint-law weight")
            seen.add(index)
            actual, ideal = oracle.literal_unitaries(operations, index, count)
            frame = oracle.independent_frame_label(actual, ideal)
            target = frame if model["question"] == "State" else qa.sign_from_literal_pauli(frame, model["question"])
            record = qa.acquired_record(model["acquisitions"], index, count)
            require(row["frame"] == frame and row["target"] == target and row["record"] == record,
                    name + ": source export disagrees with independent fixture semantics")
            if weight:
                active.add(record)
                bound = qa.bind_continuation(plan["execution"], record)
                decision = plan["decisions"][record]
                if model["question"] == "State":
                    require(decision in oracle.PAULIS, "invalid state correction")
                    emitted = oracle.I
                    for gate in bound["gates"]:
                        emitted = oracle.multiply(oracle.PAULIS[gate.upper()], emitted)
                    require(oracle.max_entry_error(emitted, oracle.PAULIS[decision]) <= TOLERANCE,
                            "exported state correction differs from the formal decision")
                else:
                    require(decision in ("0", "1") and bound["relabel"] == int(decision),
                            "exported relabel differs from the formal decision")
                    require(bound["analyzer"] == {"X": ["h"], "Y": ["s", "s", "s", "h"], "Z": []}[model["question"]],
                            "exported analyzer changed the meaning of the question")
                incorrect_weight += weight * (decision != target)
            total += weight
        require(seen == set(range(1 << count)), "incomplete source fixture")
        require(total == plan["loss_denominator"] and incorrect_weight == plan["loss_numerator"],
                name + ": literal action/decision loss differs from the exported claim")
        require(active == set(plan["decisions"]) == set(plan["execution"]["by_record"]),
                "continuation has missing or invented possible records")
        if name in EXPECTED_LOSSES:
            require(Fraction(incorrect_weight, total) == EXPECTED_LOSSES[name],
                    name + ": independent literal fixture expectation failed")
    require(set(models) == set(plans), "source/continuation domain mismatch")
    requests, names = requests_document["requests"], set()
    require(isinstance(requests, list) and requests, "missing acquisition requests")
    statuses = []
    for request in requests:
        required = {"name", "before", "selected", "action", "contacts", "backend", "reason"}
        require(required <= set(request) <= required | {"contact_id", "cell"}, "invalid acquisition request fields")
        require(request["name"] not in names, "duplicate acquisition request")
        names.add(request["name"])
        require(request["before"] in models and request["selected"] in models, "request references absent model")
        before, after = models[request["before"]], models[request["selected"]]
        plan = plans[request["selected"]]
        require(before["question"] == after["question"] and before["operations"] == after["operations"],
                "acquisition silently replaced the source or requested question")
        require([(r["index"], r["weight"]) for r in before["rows"]]
                == [(r["index"], r["weight"]) for r in after["rows"]], "acquisition changed the admitted joint law")
        cells, live = resident_layout(before["operations"], count)
        action = request["action"]
        require(type(request["contacts"]) is int, "invalid acquisition cost")
        if action == "acquire":
            require(request["contacts"] == 1 and request.get("cell") in live
                    and type(request.get("contact_id")) is str and request["contact_id"],
                    "acquisition uses an absent, withdrawn, or unbound source port")
            control = cells[request["cell"]]["control"]
            require(after["acquisitions"] == [[control]] + before["acquisitions"],
                    "selected decoder does not consume contact reply followed by the existing record")
            require(plan["exact"], "selected contact does not give an exact continuation")
        elif action == "skip":
            require(request["contacts"] == 0 and request["selected"] == request["before"]
                    and plan["exact"] and "cell" not in request and "contact_id" not in request,
                    "skip must use only a sufficient existing record")
        else:
            require(action == "unavailable" and request["contacts"] == 0
                    and request["selected"] == request["before"] and not plan["exact"]
                    and "cell" not in request and "contact_id" not in request,
                    "invalid unavailable-contact result")
        if request["name"] in EXPECTED_CHOICES:
            require((action, request["contacts"]) == EXPECTED_CHOICES[request["name"]],
                    request["name"] + ": independent minimum-contact expectation failed")
        if action == "unavailable":
            require(request["backend"] == "bounded_only", "unavailable request was presented as exact execution")
            status = "not executed: no admitted exact contact"
        elif before["question"] == "State":
            require(request["backend"] == "unsupported_live_quantum_feedback",
                    "unsupported live State restoration must be explicit")
            status = "not executed: terminal backend cannot return a corrected unknown quantum state"
        else:
            require(request["backend"] == "terminal_measurement", "unsupported acquisition backend")
            status = "terminal classical-output execution selected"
        statuses.append({"name": request["name"], "question": before["question"], "action": action,
                         "contacts": request["contacts"], "status": status})
    require(set(EXPECTED_LOSSES) <= set(models) and set(EXPECTED_CHOICES) <= names,
            "required independent base cases are absent")
    return count, models, plans, requests, statuses




def make_fixture(model, row, count, execution, state, contact_cell=None, fresh_bit=None):
    """Prepare a private branch. Never pass the returned private data to decoder."""
    cells, live = resident_layout(model["operations"], count)
    if contact_cell is not None:
        require(contact_cell in live, "contact unavailable after source boundary")
    wires = {entry["wire"]: oracle.control_bit(row["index"], count, entry["control"])
             for entry in cells.values()}
    nqubits = max([DATA_WIRE] + list(wires)) + 1
    contact_wire = None if contact_cell is None else cells[contact_cell]["wire"]
    if fresh_bit is not None:
        require(contact_wire is not None and fresh_bit in (0, 1), "invalid explicit wrong-carrier fixture")
        # This extra wire is NOT used by source CZ. Its substitution is an
        # intentional negative fixture, not a change to the admitted model.
        contact_wire = nqubits
        wires[nqubits] = fresh_bit
        nqubits += 1
    lines = ["OPENQASM 3.0;", "qubit[{}] q;".format(nqubits)]
    for wire, bit in sorted(wires.items()):
        if bit:
            lines.append("x q[{}];".format(wire))
    lines += ["{} q[{}];".format(gate, DATA_WIRE) for gate in qa.PREPARATIONS[state]]
    for operation in model["operations"]:
        gate = operation["gate"]
        if gate == "retained_z":
            wire = cells[operation["cell"]]["wire"]
            lines.append("// retained source cell {} is the CZ control".format(operation["cell"]))
            lines.append("cz q[{}], q[{}];".format(wire, DATA_WIRE))
        elif gate == "z":
            if oracle.control_bit(row["index"], count, operation["control"]):
                lines.append("z q[{}];".format(DATA_WIRE))
        elif gate in ("h", "s"):
            lines.append("{} q[{}];".format(gate, DATA_WIRE))
        elif gate == "withdraw_residents":
            lines.append("// resident port withdrawn: no subsequent acquisition is authorized")
        else:
            raise qa.CheckFailure("unsupported fixture source action")
    lines += ["{} q[{}];".format(gate, DATA_WIRE) for gate in public_terminal_shape(execution)]
    actual, ideal = oracle.literal_unitaries(literal_operations(model["operations"]), row["index"], count)
    independent_analyzer = qa.analyzer(model["question"])[1]
    data = oracle.output_density(oracle.multiply(independent_analyzer, actual), oracle.STATES[state])
    # Product-state oracle is sufficient for this declared classical fixture:
    # every genuine retained cell is a basis state, including after CZ.
    dim = 1 << nqubits
    expected = [[0j for _ in range(dim)] for _ in range(dim)]
    fixed = sum(bit << (nqubits - 1 - wire) for wire, bit in wires.items())
    for left in (0, 1):
        for right in (0, 1):
            i = fixed | (left << (nqubits - 1 - DATA_WIRE))
            j = fixed | (right << (nqubits - 1 - DATA_WIRE))
            expected[i][j] = data[left][right]
    density_lines = lines + ["#pragma braket result density_matrix " + ", ".join("q[{}]".format(i) for i in range(nqubits))]
    measured_wires = [DATA_WIRE] if contact_wire is None else [contact_wire, DATA_WIRE]
    sample_lines = lines[:2] + ["bit[{}] out;".format(len(measured_wires))] + lines[2:]
    sample_lines += ["out[{}] = measure q[{}];".format(i, wire) for i, wire in enumerate(measured_wires)]
    return {"density_qasm": "\n".join(density_lines) + "\n",
            "sample_qasm": "\n".join(sample_lines) + "\n",
            "nqubits": nqubits, "contact_wire": contact_wire, "measured_wires": measured_wires,
            "expected": expected, "ideal": ideal,
            "genuine_contact_wire": None if contact_cell is None else cells[contact_cell]["wire"],
            "genuine_reply": None if contact_cell is None else wires[cells[contact_cell]["wire"]]}


def qa_probability_zero(matrix, nqubits, contact_wire, execution, existing_record):
    """Integrate a density diagonal for QA; this is not a runtime acquisition."""
    probability = 0.0
    for index in range(1 << nqubits):
        raw = (index >> (nqubits - 1 - DATA_WIRE)) & 1
        reply = None if contact_wire is None else (index >> (nqubits - 1 - contact_wire)) & 1
        if decode_runtime(execution, existing_record, raw, reply) == 0:
            probability += matrix[index][index].real
    return probability


def build_jobs(count, models, plans, requests):
    density_jobs, contexts, sample_jobs, samples, negative = [], [], [], [], []
    for request in requests:
        model = models[request["before"]]
        if request["action"] == "unavailable" or model["question"] == "State":
            continue
        plan = plans[request["selected"]]
        execution = plan["execution"]
        public_terminal_shape(execution)
        total = sum(row["weight"] for row in model["rows"])
        cell = request["cell"] if request["action"] == "acquire" else None
        for row in model["rows"]:
            if row["weight"] == 0:
                continue
            existing = qa.acquired_record(model["acquisitions"], row["index"], count)
            for state in qa.PREPARATIONS:
                fixture = make_fixture(model, row, count, execution, state, cell)
                identifier = "acquisition-density-{:04d}".format(len(density_jobs))
                density_jobs.append({"id": identifier, "qasm": fixture["density_qasm"], "shots": 0})
                ideal_probability = oracle.effect_probability(oracle.derive_effect(fixture["ideal"], model["question"]), oracle.STATES[state])
                context = dict(fixture, id=identifier, request=request["name"], question=model["question"],
                               state=state, weight=row["weight"] / total, existing_record=existing,
                               execution=execution, ideal_probability=ideal_probability,
                               row=row["index"], contact_count=request["contacts"])
                contexts.append(context)
                if state in SAMPLE_PREPARATIONS:
                    sample_id = "acquisition-sample-{:04d}".format(len(sample_jobs))
                    sample_jobs.append({"id": sample_id, "qasm": fixture["sample_qasm"], "shots": SAMPLE_SHOTS})
                    samples.append(dict(context, id=sample_id, density_id=identifier))
    # Deliberate wrong-carrier negatives are separate from positive source laws.
    # Doubling each branch by a fresh unbiased bit gives genuine independence.
    for question in ("X", "Z"):
        candidates = [r for r in requests if r["action"] == "acquire" and models[r["before"]]["question"] == question]
        require(candidates, "missing acquisition for wrong-carrier witness: " + question)
        request = candidates[0]
        model, plan = models[request["before"]], plans[request["selected"]]
        total = sum(row["weight"] for row in model["rows"])
        genuine_joint, replaced_joint = defaultdict(Fraction), defaultdict(Fraction)
        for row in model["rows"]:
            if not row["weight"]:
                continue
            existing = qa.acquired_record(model["acquisitions"], row["index"], count)
            for fresh in (0, 1):
                weight = Fraction(row["weight"], 2 * total)
                for state in qa.PREPARATIONS:
                    fixture = make_fixture(model, row, count, plan["execution"], state, request["cell"], fresh)
                    identifier = "wrong-carrier-density-{:04d}".format(len(negative))
                    density_jobs.append({"id": identifier, "qasm": fixture["density_qasm"], "shots": 0})
                    negative.append(dict(fixture, id=identifier, request=request["name"], question=question,
                        state=state, weight=float(weight), existing_record=existing, execution=plan["execution"],
                        ideal_probability=oracle.effect_probability(oracle.derive_effect(fixture["ideal"], question), oracle.STATES[state])))
                genuine_joint[(existing, fixture["genuine_reply"])] += weight
                replaced_joint[(existing, fresh)] += weight
        require(genuine_joint == replaced_joint, "wrong-carrier witness did not preserve full public (r,t) statistics")
    require(density_jobs and sample_jobs and len(density_jobs) + len(sample_jobs) <= MAX_JOBS,
            "empty or excessive precommitted SDK job batch")
    return density_jobs, contexts, sample_jobs, samples, negative


def effect_from_probabilities(probabilities):
    mid = (probabilities["zero"] + probabilities["one"]) / 2
    off_diagonal = complex(probabilities["plus"] - mid, mid - probabilities["plus_i"])
    return ((complex(probabilities["zero"]), off_diagonal),
            (off_diagonal.conjugate(), complex(probabilities["one"])))


def check_densities(contexts, results, negative=False):
    groups, branches = defaultdict(list), []
    for context in contexts:
        matrix = qa.sdk_density(results[context["id"]], 1 << context["nqubits"])
        discrepancy = oracle.max_entry_error(matrix, context["expected"])
        require(discrepancy <= TOLERANCE, "source-owned CZ/analyzer differs from independent matrix QA: " + context["id"])
        probability = qa_probability_zero(matrix, context["nqubits"], context["contact_wire"],
                                          context["execution"], context["existing_record"])
        independently_predicted = qa_probability_zero(context["expected"], context["nqubits"], context["contact_wire"],
                                                      context["execution"], context["existing_record"])
        require(abs(probability - independently_predicted) <= TOLERANCE, "joint outcome integration differs")
        if not negative:
            require(abs(probability - context["ideal_probability"]) <= TOLERANCE,
                    "exact terminal output failed in a positive source branch")
        groups[context["request"]].append((context, probability))
        branches.append({"id": context["id"], "request": context["request"], "input": context["state"],
                         "matrix_max_entry_error": discrepancy, "qa_reported_probability_zero": probability,
                         "meaning": "density QA only; no contact acquired by this check"})
    summaries = []
    for name, entries in groups.items():
        probabilities, ideals = defaultdict(float), {}
        for context, probability in entries:
            probabilities[context["state"]] += context["weight"] * probability
            ideals[context["state"]] = context["ideal_probability"]
        require(set(probabilities) == set(qa.PREPARATIONS), "incomplete six-state output check")
        effect = effect_from_probabilities(probabilities)
        ideal_effect = oracle.derive_effect(entries[0][0]["ideal"], entries[0][0]["question"])
        discrepancy = oracle.max_entry_error(effect, ideal_effect)
        worst = max(abs(probabilities[s] - ideals[s]) for s in probabilities)
        if negative:
            require(abs(worst - 0.5) <= TOLERANCE and discrepancy > TOLERANCE,
                    "wrong-carrier mutation did not expose the independently expected one-half output error")
        else:
            require(discrepancy <= TOLERANCE and worst <= TOLERANCE, "terminal output effect is not the ideal question")
        summaries.append({"name": name, "question": entries[0][0]["question"],
                          "probabilities_zero": dict(probabilities), "ideal_probabilities_zero": ideals,
                          "effect_max_entry_error": discrepancy, "six_input_worst_probability_error": worst,
                          "outcome": "expected wrong-carrier rejection" if negative else "exact classical-output effect checked",
                          "quantum_state_restoration_claimed": False})
    return summaries, branches


def runtime_sample_counts(execution, existing_record, measured_qubits, counts, contact_wire):
    """Postprocess only real SDK output; private fixture arguments are absent."""
    expected = {DATA_WIRE} if contact_wire is None else {contact_wire, DATA_WIRE}
    require(isinstance(measured_qubits, list) and len(measured_qubits) == len(expected)
            and set(measured_qubits) == expected, "SDK measured an extra/missing memory or payload wire")
    data_position = measured_qubits.index(DATA_WIRE)
    contact_position = None if contact_wire is None else measured_qubits.index(contact_wire)
    zero, total, replies = 0, 0, defaultdict(int)
    for bits, count in counts.items():
        require(type(bits) is str and len(bits) == len(measured_qubits) and all(b in "01" for b in bits)
                and type(count) is int and count >= 0, "invalid raw SDK outcomes")
        raw = int(bits[data_position])
        reply = None if contact_position is None else int(bits[contact_position])
        reported = decode_runtime(execution, existing_record, raw, reply)
        zero += count * (reported == 0)
        total += count
        if reply is not None:
            replies[str(reply)] += count
    return {"reported_zero_count": zero, "total": total, "contact_reply_counts": dict(replies)}


def sampling_precommit(samples):
    # Two Bernoulli events per job: final reported zero, and genuine contact
    # reply zero if read. The latter verifies the wire relation using fixture
    # truth only in QA, never as a decoder input.
    event_count = len(samples) + sum(c["contact_wire"] is not None for c in samples)
    tolerance = math.sqrt(math.log(2 * event_count / SAMPLE_ALPHA) / (2 * SAMPLE_SHOTS))
    return {"schema": "vi.acquisition.sampling-precommit.v1", "job_count": len(samples),
            "shots_per_job": SAMPLE_SHOTS, "family_alpha": SAMPLE_ALPHA,
            "bernoulli_event_count": event_count, "absolute_tolerance": tolerance,
            "retry_policy": "one fixed batch; failure is reported, never retried until pass",
            "preparations": list(SAMPLE_PREPARATIONS),
            "checks": [{"id": c["id"], "request": c["request"], "input": c["state"],
                        "expected_measured_wires": c["measured_wires"], "existing_public_record": c["existing_record"],
                        "expected_reported_probability_zero": c["ideal_probability"],
                        "qa_expected_contact_zero": None if c["genuine_reply"] is None else 1 - c["genuine_reply"]}
                       for c in samples]}


def check_samples(samples, results, precommit):
    checks, acquired_replies = [], defaultdict(set)
    for context in samples:
        result = results[context["id"]]
        require(result["shots"] == SAMPLE_SHOTS, "changed precommitted shots")
        decoded = runtime_sample_counts(context["execution"], context["existing_record"],
                                        result["measured_qubits"], result["measurement_counts"], context["contact_wire"])
        require(decoded["total"] == SAMPLE_SHOTS, "incomplete SDK shot batch")
        observed = decoded["reported_zero_count"] / SAMPLE_SHOTS
        deviation = abs(observed - context["ideal_probability"])
        require(deviation <= precommit["absolute_tolerance"], "actual terminal-output sample failed its fixed family bound")
        contact_deviation = None
        if context["contact_wire"] is not None:
            contact_zero = decoded["contact_reply_counts"].get("0", 0) / SAMPLE_SHOTS
            contact_deviation = abs(contact_zero - (1 - context["genuine_reply"]))
            require(contact_deviation <= precommit["absolute_tolerance"], "measured contact is not tied to its declared producer")
            acquired_replies[context["request"]].update(k for k, v in decoded["contact_reply_counts"].items() if v)
        checks.append({"id": context["id"], "request": context["request"], "input": context["state"],
                       "measured_qubits": result["measured_qubits"], "contact_count_per_run": context["contact_count"],
                       "actual_contact_reply_counts": decoded["contact_reply_counts"],
                       "actual_reported_probability_zero": observed, "ideal_probability_zero": context["ideal_probability"],
                       "deviation": deviation, "contact_deviation": contact_deviation})
    # Require both actual replies only when both are declared in this fixture.
    for name, replies in acquired_replies.items():
        possible = {str(c["genuine_reply"]) for c in samples if c["request"] == name}
        require(replies == possible, "fixed batch did not exercise each declared contact reply")
    return checks, {name: sorted(replies) for name, replies in acquired_replies.items()}


def runtime_boundary_checks(plans, requests):
    acquired = next(r for r in requests if r["action"] == "acquire" and plans[r["selected"]]["question"] != "State")
    execution = plans[acquired["selected"]]["execution"]
    before_width = len(execution["input_records"]) - 1
    existing = "0" * before_width
    failures = 0
    for bad_call in (
        lambda: decode_runtime(execution, {"r": existing, "latent": 0}, 0, 0),
        lambda: decode_runtime(execution, existing, 0),
        lambda: decode_runtime(execution, existing + "0", 0, 0),
        lambda: decode_runtime(execution, existing, 0, 2),
    ):
        try:
            bad_call()
        except qa.CheckFailure:
            failures += 1
        else:
            raise qa.CheckFailure("runtime accepted a missing, extra, or private input")
    state = next(p for p in plans.values() if p["question"] == "State")
    try:
        public_terminal_shape(state["execution"])
    except qa.CheckFailure:
        failures += 1
    else:
        raise qa.CheckFailure("terminal interface accepted an unknown State output")
    return {"expected_rejections": failures, "decoder_private_fixture_access": False,
            "state_route": "explicitly refused", "missing_contact": "not synthesized from source history"}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifacts", type=Path, required=True)
    parser.add_argument("--python", default=sys.executable, help="Python with official Braket local SDK")
    args = parser.parse_args(argv)
    artifacts = args.artifacts.resolve()
    artifacts.mkdir(parents=True, exist_ok=True)
    report_path = artifacts / "acquisition-experiment-report.json"
    started = perf_counter()
    report = {"schema": "vi.acquisition.experiment.v1", "status": "running",
              "started_utc": datetime.now(timezone.utc).isoformat(), "runner_log": [],
              "numerical_tolerance": TOLERANCE,
              "scope": "local simulator; source-bound terminal measurement and one classical output",
              "not_claimed": ["physical hardware experiment", "live quantum feedback", "unknown quantum state restoration",
                              "learning an unknown source law", "density QA as an acquired contact"]}
    qa.write_json(report_path, report)
    try:
        paths = [artifacts / name for name in ("sources.json", "continuations.json", "requests.json")]
        report["input_sha256"] = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
        count, models, plans, requests, statuses = validate_inputs(*(qa.load_json(p) for p in paths))
        report["requests"] = statuses
        report["runtime_boundary_checks"] = runtime_boundary_checks(plans, requests)
        jobs, contexts, sample_jobs, samples, negatives = build_jobs(count, models, plans, requests)
        precommit = sampling_precommit(samples)
        qa.write_json(artifacts / "acquisition-sampling-precommit.json", precommit)
        report["density_job_count"] = len(jobs)
        report["sampling_job_count"] = len(sample_jobs)
        report["total_shots"] = len(sample_jobs) * SAMPLE_SHOTS
        report["fixture_and_export_seconds"] = perf_counter() - started
        qa.write_json(report_path, report)
        density_run, results = qa.execute_runner(args.python, artifacts, jobs, "acquisition-density", report["runner_log"])
        report["backend"] = density_run["backend"]
        report["sdk_versions"] = density_run["package_versions"]
        report["runner_python"] = density_run["python_version"]
        report["outputs"], report["density_branches"] = check_densities(contexts, results)
        report["wrong_carrier_outputs"], negative_branches = check_densities(negatives, results, negative=True)
        report["wrong_carrier"] = {"public_joint_record_statistics_equal": True,
                                   "source_CZ_uses_genuine_cell": True,
                                   "contact_uses_independent_fresh_cell": True,
                                   "positive_source_law_modified": False,
                                   "branch_count": len(negative_branches),
                                   "maximum_matrix_error": max(x["matrix_max_entry_error"] for x in negative_branches)}
        report["density_checks_passed"] = True
        qa.write_json(report_path, report)
        _, sample_results = qa.execute_runner(args.python, artifacts, sample_jobs, "acquisition-sampling", report["runner_log"])
        report["sampling_checks"], report["actual_contact_replies_exercised"] = check_samples(samples, sample_results, precommit)
        report["sampling_family_alpha"] = SAMPLE_ALPHA
        report["status"] = "passed"
    except Exception as error:
        report["status"] = "failed"
        report["failure_type"] = type(error).__name__
        report["failure"] = str(error)
        print("acquisition experiment failed: {}".format(error), file=sys.stderr)
    finally:
        report["completed_utc"] = datetime.now(timezone.utc).isoformat()
        report["elapsed_seconds"] = perf_counter() - started
        qa.write_json(report_path, report)
    if report["status"] != "passed":
        return 1
    print("acquisition experiment passed: {} density jobs, {} fixed sampling jobs".format(
        report["density_job_count"], report["sampling_job_count"]))
    print("report: " + str(report_path))
    return 0


if __name__ == "__main__":
    sys.exit(main())
