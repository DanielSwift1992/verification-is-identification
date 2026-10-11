#!/usr/bin/env python3
"""Exact rational examples of future-scoped classical record recovery.

Real rational weighted Kraus operators; complex input states are still covered
by the full Choi comparison. No SDK, cloud call, sampling, or tolerance gate.
This checks the declared instruments, not acquisition of a hardware model.
"""
from fractions import Fraction as F
import json
from pathlib import Path
import time


def matrix(rows): return tuple(tuple(F(x) for x in row) for row in rows)
def transpose(a): return tuple(zip(*a))
def scale(a, w): return tuple(tuple(w*x for x in row) for row in a)
def add(a, b): return tuple(tuple(x+y for x,y in zip(ar,br)) for ar,br in zip(a,b))
def subtract(a, b): return add(a, scale(b, -1))
def zero(rows, cols): return matrix([[0]*cols for _ in range(rows)])
def identity(n): return matrix([[int(i==j) for j in range(n)] for i in range(n)])
def multiply(a, b):
    assert len(a[0]) == len(b)
    return tuple(tuple(sum(x*y for x,y in zip(row,col)) for col in transpose(b)) for row in a)
def trace(a): return sum(a[i][i] for i in range(len(a)))
def total(items):
    items = list(items)
    assert items
    result = zero(len(items[0]), len(items[0][0]))
    for item in items: result = add(result, item)
    return result
def outer(a, b): return tuple(tuple(x*y for y in b) for x in a)
def flatten(a): return tuple(x for row in a for x in row)
def is_zero(a): return all(x == 0 for x in flatten(a))


def positive(a):
    """Exact real PSD check by positive pivots and Schur complements."""
    if not a: return True
    if a != transpose(a) or any(a[i][i] < 0 for i in range(len(a))): return False
    pivot = next((i for i in range(len(a)) if a[i][i] > 0), None)
    if pivot is None: return is_zero(a)
    rest = [i for i in range(len(a)) if i != pivot]
    return positive(tuple(tuple(a[i][j]-a[i][pivot]*a[pivot][j]/a[pivot][pivot]
                                for j in rest) for i in rest))


def choi(terms):
    # Column vectorization: output index is fastest; unnormalized Choi.
    return total(scale(outer(flatten(transpose(a)), flatten(transpose(a))), w) for w,a in terms)


def adjoint(terms, effect):
    return total(scale(multiply(multiply(transpose(a), effect), a), w) for w,a in terms)


def validate(branches):
    terms = [term for row in branches for term in row]
    assert terms and all(type(w) is F and w >= 0 for w,a in terms)
    output, input_ = len(terms[0][1]), len(terms[0][1][0])
    assert all(len(a)==output and all(len(row)==input_ for row in a) for w,a in terms)
    assert all(type(x) is F for w,a in terms for x in flatten(a))
    assert total(adjoint(row, identity(output)) for row in branches) == identity(input_)
    return input_, output


def separating_state(delta):
    """Exhibit a rational rank-one density matrix detecting nonzero real Δ."""
    assert delta == transpose(delta) and not is_zero(delta)
    n = len(delta)
    for i in range(n):
        if delta[i][i]:
            v = [F(int(k==i)) for k in range(n)]
            return outer(v,v)
    for i in range(n):
        for j in range(i):
            if delta[i][j]:
                v = [F(int(k in (i,j))) for k in range(n)]
                return scale(outer(v,v), F(1,2))
    raise AssertionError('No witness for nonzero Hermitian matrix')


def recovery(branches, coarse, effects=None):
    """Classical resampling only; it does not touch the retained quantum output.

    For full recovery compare J_r = p(r|m) sum_{d(s)=m} J_s.
    For requested output effects compare Φ_r*(E) = p(r|m) Ψ_m*(E).
    Identity is mandatory, so probabilities themselves remain in scope.
    """
    input_, output = validate(branches)
    assert len(coarse) == len(branches)
    if effects is not None:
        assert identity(output) in effects.values()
        assert all(len(e)==output and all(len(row)==output for row in e) and e==transpose(e)
                   for e in effects.values())
        assert all(positive(e) and positive(subtract(identity(output),e)) for e in effects.values())
    weights, violations = {}, []
    for m in sorted(set(coarse)):
        group = [r for r,label in enumerate(coarse) if label==m]
        joint = [term for r in group for term in branches[r]]
        denominator = trace(adjoint(joint, identity(output)))
        assert denominator >= 0
        for r in group:
            p = (trace(adjoint(branches[r], identity(output)))/denominator
                 if denominator else F(int(r==group[0])))
            weights[r] = p
            pairs = ({name:(adjoint(branches[r],e), adjoint(joint,e)) for name,e in effects.items()}
                     if effects is not None else {'Choi':(choi(branches[r]),choi(joint))})
            for name,(fine,coarsened) in pairs.items():
                delta = subtract(fine,scale(coarsened,p))
                if not is_zero(delta):
                    witness = separating_state(delta)
                    gap = trace(multiply(witness,delta))
                    assert gap != 0
                    violations.append({'branch':r,'coarse':m,'test':name,
                                       'candidate_probability':str(p),
                                       'separating_projector_or_input':witness,
                                       'probability_difference':str(gap/input_ if effects is None else gap),
                                       'experiment':'maximally entangled input and joint output projector'
                                                    if effects is None else 'input density and named output effect'})
        assert sum(weights[r] for r in group) == 1
    return {'recoverable':not violations, 'kernel':{str(r):str(p) for r,p in weights.items()},
            'violations':violations,
            'scope':'all input states and references' if effects is None else 'named output effect span'}


def rank(rows):
    rows = [list(row) for row in rows]
    pivot = 0
    for col in range(len(rows[0])) if rows else []:
        found = next((i for i in range(pivot,len(rows)) if rows[i][col]), None)
        if found is None: continue
        rows[pivot],rows[found] = rows[found],rows[pivot]
        divisor = rows[pivot][col]
        rows[pivot] = [x/divisor for x in rows[pivot]]
        for i in range(len(rows)):
            if i != pivot:
                multiplier = rows[i][col]
                rows[i] = [x-multiplier*y for x,y in zip(rows[i],rows[pivot])]
        pivot += 1
    return pivot


def future_effects(initial, operations):
    """Least invariant linear span, with actual contact words as witnesses."""
    basis, vectors = [], []
    def offer(effect, terminal, word):
        vector = flatten(effect)
        if rank(vectors+[vector]) > len(vectors):
            vectors.append(vector)
            basis.append({'effect':effect,'terminal':terminal,'word':word})
    for name,effect in initial.items(): offer(effect,name,[])
    cursor = 0
    while cursor < len(basis):
        current = basis[cursor]; cursor += 1
        for name,terms in operations.items():
            validate([terms])
            offer(adjoint(terms,current['effect']),current['terminal'],[name]+current['word'])
    # Independent closure check after the fixed point, not a depth cutoff.
    for row in basis:
        for terms in operations.values():
            assert rank(vectors+[flatten(adjoint(terms,row['effect']))]) == len(vectors)
    return basis


def square_flagged_repair(branches):
    """Universal deterministic correction with a known single-Kraus flag.

    Trace preservation forces K_r^T K_r = p_r I. For square K, this gives
    an explicit weighted-transpose unitary inverse. Multi-Kraus branches and
    rectangular output spaces are outside this constructor.
    """
    input_, output = validate(branches)
    assert input_ == output and all(len(row)==1 for row in branches)
    repairs, failures = [], []
    for r,row in enumerate(branches):
        w,a = row[0]
        effect = adjoint(row,identity(output))
        p = trace(effect)/input_
        if effect != scale(identity(input_),p):
            failures.append({'branch':r,'effect':effect,'required_probability':str(p)})
            repairs.append(None)
        elif p == 0:
            repairs.append([(F(1),identity(input_))])
        else:
            repair = [(w/p,transpose(a))]
            validate([repair])
            assert choi([(w*v,multiply(b,a)) for v,b in repair]) == scale(choi([(F(1),identity(input_))]),p)
            repairs.append(repair)
    return {'universally_repairable':not failures,'repairs':repairs,'failures':failures}


def run():
    began = time.perf_counter()
    I = identity(2); Z = matrix([[1,0],[0,-1]])
    Hraw = matrix([[1,1],[1,-1]])
    Pz = matrix([[1,0],[0,0]])
    Px = scale(matrix([[1,1],[1,1]]), F(1,2))
    coin = [[(F(1,2),I)],[(F(1,2),I)]]
    phase = [[(F(1,2),I)],[(F(1,2),Z)]]
    projective = [[(F(1),Pz)],[(F(1),subtract(I,Pz))]]
    corrected = [[(w,multiply(I if r==0 else Z,a)) for w,a in row]
                 for r,row in enumerate(phase)]
    kept_copy = [[(F(1,2),matrix([[1,0],[0,1],[0,0],[0,0]]))],
                 [(F(1,2),matrix([[0,0],[0,0],[1,0],[0,1]]))]]
    stable = future_effects({'I':I,'Z0':Pz},{'Z':[(F(1),Z)]})
    expanded = future_effects({'I':I,'Z0':Pz},
                              {'Z':[(F(1),Z)],'H':[(F(1,2),Hraw)]})
    stable_effects = {str(i):row['effect'] for i,row in enumerate(stable)}
    expanded_effects = {str(i):row['effect'] for i,row in enumerate(expanded)}
    tests = {'independent_coin_full':recovery(coin,[0,0]),
             'phase_record_probabilities_only':recovery(phase,[0,0],{'I':I}),
             'phase_record_Z_continuations':recovery(phase,[0,0],stable_effects),
             'phase_record_after_adding_H':recovery(phase,[0,0],expanded_effects),
             'phase_record_full':recovery(phase,[0,0]),
             'coin_with_protected_copy_full':recovery(kept_copy,[0,0]),
             'projective_probabilities_only':recovery(projective,[0,0],{'I':I}),
             'after_actual_controlled_correction':recovery(corrected,[0,0]),
             'zero_unreachable_branch':recovery([[(F(1),I)],[(F(0),I)]],[0,1])}
    assert [v['recoverable'] for v in tests.values()] == [True,True,True,False,False,False,False,True,True]
    assert len(stable)==2 and len(expanded)==3
    assert any(row['effect']==Px and row['word']==['H'] for row in expanded)
    # Actual bit controls Z^r; independently resampled bit is wrong half the time.
    # Use |+> and X+ as an explicit adaptive operational witness.
    def apply(terms,rho):
        return total(scale(multiply(multiply(a,rho),transpose(a)),w) for w,a in terms)
    actual = total(apply([(F(1), I if r==0 else Z)], apply(phase[r],Px)) for r in (0,1))
    coarsened = total(apply(branch,Px) for branch in phase)
    other_input = subtract(I,Px)
    assert other_input != Px
    assert coarsened == total(apply(branch,other_input) for branch in phase)
    # Even the retained original flag does not separate |+> from |-> after
    # an actual projective Z measurement: the whole CQ output agrees.
    assert all(apply(branch,Px) == apply(branch,other_input) for branch in projective)
    repair_cases = {'phase':square_flagged_repair(phase),
                    'projective':square_flagged_repair(projective)}
    assert repair_cases['phase']['universally_repairable']
    assert not repair_cases['projective']['universally_repairable']
    replay = total(apply([(F(1,2), I if r==0 else Z)],coarsened) for r in (0,1))
    assert actual == Px and replay == scale(I,F(1,2))
    result = {'schema':'vi.future-scoped-record-recovery.v1','tests':tests,
              'closed_Z_effect_space':stable,'with_H_effect_space':expanded,
              'adaptive_X_success':{'actual_record':str(trace(multiply(Px,actual))),
                                    'fresh_independent_record':str(trace(multiply(Px,replay)))},
              'deterministic_reverse_reading_for_coin':False,
              'distinct_inputs_after_discard_have_identical_quantum_output':True,
              'projective_distinct_inputs_have_identical_output_even_with_original_flag':True,
              'flagged_repair':repair_cases,
              'correction_before_discard_restores_identity_channel':choi([term for row in corrected for term in row])
                                                                  == choi([(F(1),I)]),
              'arithmetic':'exact rational; no tolerance or numerical admission',
              'seconds':time.perf_counter()-began,'new_QPU_jobs':0,
              'scope':'Explicit instrument laws, classical-only stochastic reconstruction; '
                      'not occurrence identity, arbitrary quantum recovery, or hardware calibration.'}
    root = Path(__file__).resolve().parents[2]
    out = root/'Research/Artifacts/resident-record-recovery-20260916'
    out.mkdir(exist_ok=True)
    (out/'exact.json').write_text(json.dumps(result,indent=2,default=str)+'\n')
    print(json.dumps({'tests':{k:v['recoverable'] for k,v in tests.items()},
                      'effect_dimensions':[len(stable),len(expanded)],
                      'adaptive_X_success':result['adaptive_X_success'],
                      'seconds':result['seconds']},indent=2))


if __name__ == '__main__': run()
