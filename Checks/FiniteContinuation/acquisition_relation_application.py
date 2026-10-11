#!/usr/bin/env python3
"""Apply a logical acquisition to a producing JOINT process, or leave it open.

No physical membership is inferred from metadata, model proofs or a family
of possible mechanisms. This entry point has no QPU transport. Closed local
execution means execution by the same declared finite instrument interpreter.
"""
from dataclasses import dataclass
from fractions import Fraction
import io
import numpy as np
from qiskit import qpy
import acquisition_xor_resolve as rule
from acquisition_future_synthesis_checks import read_gate_instrument

core = rule.core
require = core.require


def channel(rows, size):
    """Producing dyadic CP map on the WHOLE announced source carrier.

Rows are (positive rational weight, actual operator). They are not inferred
from isolated output scores or per-wire calibration summaries.
"""
    require(rows, 'An empty family is not a channel')
    out = []
    for weight, k in rows:
        w = Fraction(weight)
        require(w > 0 and w.denominator <= 2**20 and w.denominator & (w.denominator-1) == 0,
                'This exact fragment uses positive dyadic weights')
        k = np.array(k, dtype=complex, copy=True)
        require(k.shape == (size, size) and set(k.flat) <= {0, 1, -1, 1j, -1j},
                'This exact fragment requires Gaussian integer operator entries')
        k.flags.writeable = False; out.append((w, k))
    require(core.equal(sum(float(w)*k.conj().T@k for w, k in out), np.eye(size)),
            'Joint context does not preserve trace')
    return tuple(out)


def joint_paths(paths, size):
    """Produce a whole episode from a JOINT law on unitary contact paths.

No multiplication of marginal transition tables is inferred. Correlation
between occurrences is supplied by the producing path construction itself.
"""
    rows = []
    for weight, word in paths:
        whole = np.eye(size, dtype=complex)
        for u in word:
            require(np.shape(u) == (size, size) and core.equal(u.conj().T@u, np.eye(size)),
                    'This path constructor requires unitary contacts')
            whole = u@whole
        rows.append((weight, whole))
    return channel(rows, size)


@dataclass(frozen=True)
class Recipe:
    interface: str
    qpy_bytes: bytes
    decoder: tuple


def prepare(source, spec, query, certificate):
    q = rule.compile_result(source, spec, query, certificate)
    # A different requested future need not change the producing process.
    # Keep source/record semantics, not a request-id equality as a substitute
    # for applying the actual operator relation to the new question.
    q.name = 'vi-xor-acquisition'
    q.metadata = {'interface': spec['id'], 'actual_decoder': certificate['plan']['derived']['decoder']}
    buf = io.BytesIO(); qpy.dump(q, buf)
    return Recipe(spec['id'], buf.getvalue(), tuple(certificate['plan']['derived']['decoder'].items()))


class ProducedJointModel:
    """One owned local carrier, with actual interpreter operations as its meaning.

This is explicitly a model, never an identification of an external device.
No execution choice is made using the private simulator density matrix.
"""
    def __init__(self, recipe, context_after, rho, *, reference_dimension=1, metadata=None):
        self.recipe = recipe; self.metadata = dict(metadata or {})
        q, = qpy.load(io.BytesIO(recipe.qpy_bytes))
        maps = read_gate_instrument(q)
        self.size = len(next(iter(maps.values())))
        self.context = channel(context_after, self.size)
        self.maps = {raw: tuple((w, c@k) for w, c in self.context) for raw, k in maps.items()}
        self.reference = reference_dimension
        require(type(self.reference) is int and self.reference >= 1, 'Wrong reference dimension')
        self._rho = np.array(rho, complex, copy=True)
        n = self.size*self.reference
        require(self._rho.shape == (n, n) and np.allclose(self._rho, self._rho.conj().T) and
                abs(np.trace(self._rho)-1) < 1e-12 and np.linalg.eigvalsh(self._rho).min() > -1e-12,
                'Invalid simulator input')
        self.consumed = False


@dataclass(frozen=True)
class ExternalEpisode:
    """An addressed physical episode is not a producing operator relation."""
    recipe: Recipe
    occurrence: str
    metadata: dict


def target_effects(spec, query):
    core.validate_request(spec, query)
    ps = core.projectors(query['values']); vocabulary = core.paulis(spec['size'].bit_length()-1)
    return {(a, label): p@vocabulary[label]@p for a, p in enumerate(ps)
            for label in query['closure']['basis']}


def model_effects(model, spec, query):
    require(type(model) is ProducedJointModel, 'Not a producing local model')
    require(model.recipe.interface == spec['id'] and model.size == spec['size'], 'Different source interface')
    decoder = dict(model.recipe.decoder); vocabulary = core.paulis(spec['size'].bit_length()-1)
    result = {}
    for a, label in target_effects(spec, query):
        result[a, label] = sum((float(w)*k.conj().T@vocabulary[label]@k
                               for raw, rows in model.maps.items()
                               if decoder.get(''.join(map(str, raw))) == a for w, k in rows),
                              np.zeros((model.size, model.size), complex))
    return result


def apply_relation(boundary, source, spec, query, certificate):
    """Recompute the relation on this boundary; never consume a saved verdict."""
    # Reapply the proposed rule to the CURRENT root, but compare the actual
    # model semantically. A different circuit can implement the same request.
    prepare(source, spec, query, certificate)
    require(boundary.recipe.interface == spec['id'], 'Boundary addresses another declared interface')
    target = target_effects(spec, query)
    if type(boundary) is ExternalEpisode:
        require(isinstance(boundary.occurrence, str) and boundary.occurrence, 'Physical occurrence is missing')
        return {'kind': 'open_physical_application', 'occurrence': boundary.occurrence,
                'missing_relation': {'left': 'Actual joint instrument of this episode, including the acquired record',
                    'domain_binding': 'Identification of the actual input, retained outputs and record ports with this declared carrier is part of the missing relation.',
                    'right': {str(a)+':'+label: core.code(m) for (a, label), m in target.items()},
                    'equation': 'J_a^*(O) = P_a O P_a on the declared input domain',
                    'future': query['closure'], 'request': query['id']},
                'metadata_is_physical_evidence': False,
                'physical_guarantee': None}
    require(type(boundary) is ProducedJointModel, 'Unsupported boundary mechanism')
    require(not boundary.consumed, 'This live local carrier has already been consumed')
    actual = model_effects(boundary, spec, query)
    for (a, label), wanted in target.items():
        delta = actual[a, label]-wanted
        if not core.equal(delta, np.zeros_like(delta)):
            # A realizable input witness for the joint answer/future statistic.
            values, vectors = np.linalg.eigh(delta); i = int(np.argmax(abs(values)))
            v = vectors[:, i]; rho = np.outer(v, v.conj())
            return {'kind': 'distinguished_in_produced_model', 'answer': a, 'direction': label,
                    'continuation': query['closure']['basis'][label],
                    'operator_difference': core.code(delta), 'witness_state': core.code(rho),
                    'ideal_joint_statistic': float(np.trace(rho@wanted).real),
                    'actual_joint_statistic': float(np.trace(rho@actual[a, label]).real),
                    'scope': 'Constructed local joint process; not a diagnosis of hardware.'}
    return {'kind': 'applies_to_produced_model', 'scope': 'This local interpreter and all input states, including reference.',
            'question_effects_checked': len(target), 'physical_guarantee': None}


def conditional_family(models, source, spec, query, certificate):
    """Joint-process uncertainty; model membership stays a free premise."""
    require(models, 'Empty candidate coverage cannot establish a conclusion')
    results = [apply_relation(m, source, spec, query, certificate) for m in models]
    require(all(type(m) is ProducedJointModel for m in models), 'Family elements must be producing models')
    if any(r['kind'] != 'applies_to_produced_model' for r in results):
        return {'kind': 'family_does_not_entail_request', 'applications': results,
                'physical_guarantee': None}
    return {'kind': 'conditional_on_joint_coverage', 'applications': results,
            'open_premise': 'The actual complete episode instrument belongs to the convex hull of these joint instruments.',
            'physical_guarantee': None}


def use(boundary, source, spec, query, certificate, rng):
    """One guarded local application; all shots/outcomes, no trusted-input oracle."""
    application = apply_relation(boundary, source, spec, query, certificate)
    require(application['kind'] == 'applies_to_produced_model',
            'No applicable producing boundary; open premises cannot authorize promised execution')
    outputs = {}
    for raw, rows in boundary.maps.items():
        outputs[raw] = sum((float(w)*np.kron(k, np.eye(boundary.reference))@boundary._rho@
                           np.kron(k, np.eye(boundary.reference)).conj().T for w, k in rows),
                          np.zeros_like(boundary._rho))
    probabilities = np.array([np.trace(rho).real for rho in outputs.values()])
    require(np.min(probabilities) > -1e-12 and abs(sum(probabilities)-1) < 1e-12, 'Invalid model output')
    raw = list(outputs)[int(rng.choice(len(outputs), p=np.maximum(probabilities, 0)/sum(np.maximum(probabilities, 0))))]
    probability = float(np.trace(outputs[raw]).real)
    answer = dict(boundary.recipe.decoder)[''.join(map(str, raw))]
    boundary.consumed = True
    return {'scope': 'produced_local_model', 'actual_record': raw, 'answer': answer,
            'remaining_density': outputs[raw]/probability, 'reference_dimension': boundary.reference,
            'application': application}
