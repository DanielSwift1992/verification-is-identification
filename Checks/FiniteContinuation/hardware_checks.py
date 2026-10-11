#!/usr/bin/env python3
"""Offline audit of the actual probe and continuation circuit producer."""
from qiskit.quantum_info import Statevector
from model import WORLDS, problem
from hardware import logical


def checks():
    p=problem(('t',),'terminal','X')
    spec={'cases':[{'episode':str(i),'fixture':list(w)} for i,w in enumerate(WORLDS)]}
    probes=continuations=0
    for i,w in enumerate(WORLDS):
        for q in p['probes']:
            d={'episode':str(i),'kind':'acquisition','probe':q['id']}
            c=logical(spec,d)
            probabilities=Statevector.from_instruction(c.remove_final_measurements(inplace=False)).probabilities()
            assert probabilities[q['replies'][i]]>1-1e-12
            probes+=1
        for key in p['valid'][i]:
            action=p['actions'][key]
            for target in (0,1):
                d={'episode':str(i),'kind':'validation','target_bit':target,'execution':action}
                c=logical(spec,d)
                probabilities=Statevector.from_instruction(c.remove_final_measurements(inplace=False)).probabilities()
                assert probabilities[target^(action['sign']==-1)]>1-1e-12
                continuations+=1
    return {'ideal_probe_circuits':probes,'ideal_continuation_circuits':continuations,
            'hardware_submissions':0}


if __name__=='__main__':print(checks())
