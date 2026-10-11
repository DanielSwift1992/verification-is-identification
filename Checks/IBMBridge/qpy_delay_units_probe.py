#!/usr/bin/env python3
"""Small standalone QPY time-unit reproduction; no project source or account.

Run with the installed Qiskit version. Numeric-unit behaviour is reported,
not assumed broken on future versions. Typed duration must round-trip.
"""
import io
import json
import qiskit
from qiskit import QuantumCircuit, qpy
from qiskit.circuit import Duration
from qiskit.circuit.classical import expr


def describe(op):
    if op.unit == 'expr':
        value = op.duration.value
        return {'representation': 'typed', 'duration': value.value(), 'unit': value.unit()}
    return {'representation': 'numeric', 'duration': op.duration, 'unit': op.unit}


def run():
    trials = []
    for duration, unit in [(32, 'dt'), (32, 'ns'), (2000, 'ns'), (.032, 'us'), (3.2e-8, 's')]:
        q = QuantumCircuit(1)
        q.delay(duration, 0, unit=unit)
        row = {'input': describe(q.data[0].operation)}
        data = io.BytesIO()
        qpy.dump(q, data)
        try:
            data.seek(0)
            restored, = qpy.load(data)
            row.update(output=describe(restored.data[0].operation), equal=q == restored)
        except Exception as error:
            row.update(error=type(error).__name__+': '+str(error), equal=False)
        trials.append(row)
    q = QuantumCircuit(1)
    q.delay(expr.lift(Duration.ns(2000)), 0)
    data = io.BytesIO()
    qpy.dump(q, data)
    data.seek(0)
    restored, = qpy.load(data)
    assert q == restored and describe(restored.data[0].operation)['unit'] == 'ns'
    return {'qiskit_version': qiskit.__version__, 'numeric_trials': trials,
            'typed_trial': describe(restored.data[0].operation), 'typed_equal': True,
            'scope': 'One-instruction serialization only; no claim about physical dt or provider timing.'}


if __name__ == '__main__':
    print(json.dumps(run(), indent=2))
