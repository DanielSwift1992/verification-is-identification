#!/usr/bin/env python3
"""A complete local application, and attempts to replace relations by metadata."""
import argparse
from fractions import Fraction
import io
import json
from pathlib import Path
import time
import numpy as np
from qiskit import qpy
import acquisition_relation_application as a


def run(out):
    started = time.perf_counter(); core = a.core
    source = core.source_reader.read_source(); spec = core.interface(source)
    values = [row['Control'] for row in source['rows']]; v = core.paulis(3); n = spec['size']
    h_b = {'numerator': core.code(v['IXI']+v['IZI']), 'norm_squared': 2}
    questions = {
        'only_A': core.request(spec, values, ['III']),
        'B_Z': core.request(spec, values, ['IZI']),
        'B_X': core.request(spec, values, ['IXI']),
        'B_Z_after_H': core.request(spec, values, ['IZI'], {'H_B': h_b}),
        'joint_XX': core.request(spec, values, ['IXX']),
        'all_future': core.request(spec, values, list(v)),
    }
    certs = {name: a.rule.construct(spec, q) for name, q in questions.items()}
    recipes = {name: a.prepare(source, spec, q, certs[name]) for name, q in questions.items()}
    assert all(recipe == recipes['only_A'] for recipe in recipes.values())
    recipe = recipes['only_A']
    identity = [(1, v['III'])]
    correlated = [(Fraction(1, 2), v['III']), (Fraction(1, 2), v['IZZ'])]
    independent = [(Fraction(1, 4), v[label]) for label in ('III', 'IZI', 'IIZ', 'IZZ')]
    rho = np.eye(n)/n
    same_metadata = {'timestamp': '2026-09-16T20:00:00Z', 'elapsed_ns': 1000,
                     'verified': True, 'source_unchanged': True, 'qpy_hash': core.source_reader.fingerprint(recipe.qpy_bytes.hex())}
    models = {name: a.ProducedJointModel(recipe, c, rho, metadata=same_metadata) for name, c in
              [('identity', identity), ('correlated', correlated), ('independent', independent)]}
    applications = {name: {qname: a.apply_relation(m, source, spec, q, certs[qname])
                          for qname, q in questions.items()} for name, m in models.items()}
    ok = 'applies_to_produced_model'; bad = 'distinguished_in_produced_model'
    assert all(result['kind'] == ok for result in applications['identity'].values())
    for name in ('correlated', 'independent'):
        assert applications[name]['only_A']['kind'] == applications[name]['B_Z']['kind'] == ok
        assert applications[name]['B_X']['kind'] == applications[name]['B_Z_after_H']['kind'] == bad
    assert applications['correlated']['joint_XX']['kind'] == ok
    assert applications['independent']['joint_XX']['kind'] == bad
    assert applications['correlated']['B_Z_after_H']['continuation']['word'] == ['H_B']

    # Both joint channels induce the SAME complete marginal channel on each
    # participant for arbitrary correlated inputs. They differ on joint XX.
    def dual(context, o): return sum(float(w)*k.conj().T@o@k for w, k in context)
    marginal_labels = ['I'+p+'I' for p in 'IXYZ'] + ['II'+p for p in 'IXYZ']
    assert all(core.equal(dual(correlated, v[label]), dual(independent, v[label])) for label in marginal_labels)
    assert core.equal(dual(correlated, v['IXX']), v['IXX'])
    assert core.equal(dual(independent, v['IXX']), np.zeros((n, n)))

    # Equal single-contact channels are insufficient for a two-contact episode.
    # Reusing the same hidden choice r makes Z_B^r Z_B^r=I; a fresh choice
    # at the second contact instead gives dephasing, with identical marginals.
    same_choice = a.joint_paths([(Fraction(1, 2), [u, u]) for u in (v['III'], v['IZI'])], n)
    fresh_choice = a.joint_paths([(Fraction(1, 4), [u, w])
                                 for u in (v['III'], v['IZI']) for w in (v['III'], v['IZI'])], n)
    reused = a.ProducedJointModel(recipe, same_choice, rho)
    fresh = a.ProducedJointModel(recipe, fresh_choice, rho)
    temporal = [a.apply_relation(m, source, spec, questions['B_X'], certs['B_X']) for m in (reused, fresh)]
    assert [result['kind'] for result in temporal] == [ok, bad]
    # A nonidentity full context can be invisible after the required A read.
    answer_phase = a.ProducedJointModel(recipe, [(1, v['ZII'])], rho)
    assert a.apply_relation(answer_phase, source, spec, questions['all_future'], certs['all_future'])['kind'] == ok

    # Different elapsed times do not defeat an actually established relation.
    older = a.ProducedJointModel(recipe, identity, rho, metadata={**same_metadata, 'elapsed_ns': 10**18})
    assert a.apply_relation(older, source, spec, questions['all_future'], certs['all_future'])['kind'] == ok
    # Different source bytes and two extra operations can implement the same
    # relation. Equality of the circuit hash is neither required nor enough.
    changed_q, = qpy.load(io.BytesIO(recipe.qpy_bytes))
    changed_q.x(3); changed_q.x(3)
    buf = io.BytesIO(); qpy.dump(changed_q, buf)
    changed_recipe = a.Recipe(spec['id'], buf.getvalue(), recipe.decoder)
    assert changed_recipe != recipe
    different_program = a.ProducedJointModel(changed_recipe, identity, rho)
    assert a.apply_relation(different_program, source, spec, questions['all_future'], certs['all_future'])['kind'] == ok
    # The old measured implementation is also a possible realization of the
    # WEAKER request. It is not forged into the direct rule's own derivation.
    old_plan = core.propose(spec, questions['only_A'], ['ProbeB', 'ProbeParity'], [True, True])
    old_q = core.compile_plan(source, spec, questions['only_A'], old_plan)
    buf = io.BytesIO(); qpy.dump(old_q, buf)
    old_recipe = a.Recipe(spec['id'], buf.getvalue(), tuple(old_plan['derived']['decoder'].items()))
    measured_model = a.ProducedJointModel(old_recipe, identity, rho)
    assert a.apply_relation(measured_model, source, spec, questions['only_A'], certs['only_A'])['kind'] == ok
    assert a.apply_relation(measured_model, source, spec, questions['B_X'], certs['B_X'])['kind'] == bad
    # Same visible program and perfect basis answers do not establish future X.
    phase = a.ProducedJointModel(recipe, [(1, v['IZI'])], rho, metadata=same_metadata)
    assert a.apply_relation(phase, source, spec, questions['only_A'], certs['only_A'])['kind'] == ok
    assert a.apply_relation(phase, source, spec, questions['B_X'], certs['B_X'])['kind'] == bad

    # Open physical coverage remains open even when every supplied model passes.
    family = a.conditional_family([models['identity'], models['correlated']], source, spec,
                                  questions['joint_XX'], certs['joint_XX'])
    assert family['kind'] == 'conditional_on_joint_coverage' and family['physical_guarantee'] is None
    external = a.ExternalEpisode(recipe, 'addressed-but-unidentified-episode',
                                  {**same_metadata, 'family': family, 'scope': 'physical', 'admitted': True})
    opened = a.apply_relation(external, source, spec, questions['joint_XX'], certs['joint_XX'])
    assert opened['kind'] == 'open_physical_application' and opened['physical_guarantee'] is None
    refused = []
    def reject(name, action):
        try: action()
        except (ValueError, AssertionError): refused.append(name); return
        raise AssertionError('Accepted '+name)
    reject('metadata and conditional family cannot authorize physical use',
           lambda: a.use(external, source, spec, questions['joint_XX'], certs['joint_XX'], np.random.default_rng(1)))
    reject('empty coverage cannot establish anything',
           lambda: a.conditional_family([], source, spec, questions['only_A'], certs['only_A']))

    # The exact positive relation controls the actual local handoff on data
    # entangled with a separate reference; the planner never receives rho.
    rng = np.random.default_rng(9161901)
    z = rng.normal(size=(16, 4))+1j*rng.normal(size=(16, 4)); state = z@z.conj().T; state /= np.trace(state)
    live = a.ProducedJointModel(recipe, correlated, state, reference_dimension=2)
    reject('stronger future does not consume carrier when inapplicable',
           lambda: a.use(live, source, spec, questions['B_X'], certs['B_X'], rng))
    assert not live.consumed
    received = a.use(live, source, spec, questions['joint_XX'], certs['joint_XX'], rng)
    answer = received['answer']; p = np.kron(core.projectors(values)[answer], np.eye(2))
    ideal = p@state@p; ideal /= np.trace(ideal)
    xx = np.kron(v['IXX'], np.eye(2))
    residual = float(abs(np.trace(xx@(received['remaining_density']-ideal))))
    assert residual < 1e-12
    reject('copied plan does not restore a consumed carrier',
           lambda: a.use(live, source, spec, questions['joint_XX'], certs['joint_XX'], rng))

    # Check the refusal's witness, not just the label of its verdict.
    rejection = applications['independent']['joint_XX']
    witness = core.matrix(rejection['witness_state'])
    assert np.linalg.eigvalsh(witness).min() > -1e-12 and abs(np.trace(witness)-1) < 1e-12
    delta = core.matrix(rejection['operator_difference'])
    assert abs(np.trace(witness@delta).real) > .99

    result = {'schema': 'vi.acquisition-relation-application-audit.v1',
              'source': source, 'interface': spec, 'questions': questions,
              'applications': applications, 'joint_family_application': family,
              'physical_application_left_open': opened, 'rejected_uses': refused,
              'same_complete_marginals_do_not_fix_joint_XX': True,
              'same_single_contact_channels_different_joint_episode': temporal,
              'phase_on_acquired_answer_is_invisible_for_all_declared_future': True,
              'different_program_same_needed_relation_admitted': True,
              'old_two_read_process_accepted_only_for_sufficient_future': True,
              'application_uses_elapsed_time_or_verified_flag': False,
              'local_handoff_actual_record': list(received['actual_record']),
              'local_handoff_answer': answer, 'local_handoff_joint_XX_residual': residual,
              'source_dimension': n, 'external_reference_dimension': 2,
              'new_QPU_jobs': 0, 'seconds': time.perf_counter()-started}
    out.mkdir(parents=True, exist_ok=True); (out/'audit.json').write_text(json.dumps(result, indent=2)+'\n')
    return {k: result[k] for k in ('same_complete_marginals_do_not_fix_joint_XX',
              'application_uses_elapsed_time_or_verified_flag', 'rejected_uses',
              'local_handoff_joint_XX_residual', 'new_QPU_jobs', 'seconds')}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(); parser.add_argument('--out', required=True, type=Path)
    print(json.dumps(run(parser.parse_args().out), indent=2))
