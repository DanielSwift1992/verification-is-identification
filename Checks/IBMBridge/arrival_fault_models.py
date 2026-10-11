#!/usr/bin/env python3
"""Exact-in-model distinguishability of candidate boundary Pauli errors.

This does not assert that an IBM fault is a Pauli error. It checks whether
our diagnostic questions can distinguish even these small competing models.
No cloud calls, no simulator sampling, no historical files are rewritten.
"""
import json
import numpy as np

I=np.eye(2, dtype=complex)
X=np.array([[0,1],[1,0]], complex)
Y=np.array([[0,-1j],[1j,0]], complex)
Z=np.diag([1.,-1.]).astype(complex)
H=(X+Z)/np.sqrt(2)
S=np.diag([1,1j])
U=H@S@H
P={'I':I,'X':X,'Y':Y,'Z':Z}
BELL=np.array([1,0,0,1],complex)/np.sqrt(2)


def density(v): return np.outer(v,v.conj())
def mean(v,op): return float(np.vdot(v,op@v).real)


def run():
    # Qiskit order R,D; source motion U on D only.
    before=np.kron(I,U)@BELL
    faults={'identity':np.eye(4)}
    faults.update({side+'_'+axis:np.kron(I,p) if side=='D' else np.kron(p,I)
                   for side in ('D','R') for axis,p in P.items() if axis!='I'})
    old={name:np.kron(I,U.conj().T)@f@before for name,f in faults.items()}
    old_values={name:{b:mean(v,np.kron(P[b[0]],P[b[1]])) for b in ('XX','ZZ')}
                for name,v in old.items()}
    old_alias=float(np.max(abs(density(old['D_Y'])-density(old['R_Z']))))
    assert old_alias<1e-12
    assert np.max(abs(np.array(list(old_values['D_Z'].values()))-[-1,-1]))<1e-12
    assert np.max(abs(np.array(list(old_values['R_Z'].values()))-[-1,1]))<1e-12

    plus=np.array([1,1])/np.sqrt(2);zeros=[np.array([1,0]),np.array([0,1])]
    inputs={side+str(s):np.kron(z,plus) if side=='D' else np.kron(plus,z)
            for side in ('D','R') for s,z in enumerate(zeros)}
    profiles={}
    for name,f in faults.items():
        profile={}
        for label,v in inputs.items():
            out=f@v
            for axis in ('X','Y','Z'):
                # Our physical plan reads X/Y of the live target and Z of
                # its spectator. No unperformed question is used here.
                side=label[0] if axis in ('X','Y') else ('R' if label[0]=='D' else 'D')
                op=np.kron(I,P[axis]) if side=='D' else np.kron(P[axis],I)
                profile[label+':'+side+axis]=round(mean(out,op),12)
        profiles[name]=profile
    keys=[tuple(p.values()) for p in profiles.values()]
    assert len(set(keys))==len(keys)==7
    return {'old_C0_means_after_harness_inverse':old_values,
            'old_full_density_alias_D_Y_vs_R_Z':old_alias,
            'new_measured_product_profiles':profiles,
            'seven_candidate_profiles_all_distinct':True,
            'scope':'Single Pauli insertion at the common exposed boundary, ideal other operations. '
                    'Not identification of arbitrary hardware noise or a claim that a Pauli caused the refusal.'}


if __name__=='__main__': print(json.dumps(run(),indent=2))
