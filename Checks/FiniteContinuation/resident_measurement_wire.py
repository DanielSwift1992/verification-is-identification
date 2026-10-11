#!/usr/bin/env python3
"""Apply an independently requested logical J(alpha) word by measurements.

The live result is a quantum carrier, its acquired two-bit Pauli frame and a
known physical address. The initial frame is physically initialized once;
append never resets it. Measured retired carriers are recycled, not archived.
"""
import argparse
from copy import deepcopy
from fractions import Fraction
from functools import lru_cache
import json
import math
from pathlib import Path
import subprocess

from qiskit import QuantumCircuit, ClassicalRegister, qpy

import resident_goal_compiler as goal
import resident_flat_controller as flat
import whole_word_admission as admission
from environment import digest,write


@lru_cache(maxsize=2)
def current(key):
    return json.loads(goal.run(['node',goal.HERE/'resident_measurement_wire_court.js','read']))


def validate(source):
    key=tuple((p,digest(goal.ROOT/p)) for p in sorted(source['source_sha256']))
    if dict(key)!=source['source_sha256']:raise ValueError('Measurement-wire source changed')
    key+=tuple((str(p),digest(p)) for p in [goal.HERE/'resident_measurement_wire_court.js',goal.HERE/'contact_court.js',goal.HERE/'court_bridge.js'])
    if current(key)!=source:raise ValueError('Not the current measurement-wire reading')


def model(source):
    validate(source);rows=source['rows'];address={(r['before']['phase'],r['before']['x'],r['before']['z']):i for i,r in enumerate(rows)}
    return {'name':'Density-output Pauli frame after acquired measurements',
        'states':[''.join(map(str,key)) for key in address],
        'observation':[[r['before']['x'],r['before']['z']] for r in rows],
        'operations':{'reply'+str(b):[address[(r['next'][b]['phase'],r['next'][b]['x'],r['next'][b]['z'])] for r in rows] for b in (0,1)},
        'initial':[address[tuple(source['initial'][k] for k in ['phase','x','z'])]],
        'source_sha256':admission.fingerprint(source),
        'scope':'Measured classical histories, arbitrary logical density operator and reference; not coherent superpositions of histories.'}


def plan(source):
    m=model(source);cert=goal.saturate.synthesize(m);goal.saturate.verify(m,cert)
    return {'model':m,'certificate':cert}


def lowering(source,selection):
    if selection['model']!=model(source):raise ValueError('The plan no longer answers the current source question')
    goal.saturate.verify(selection['model'],selection['certificate'])
    table={(r['before']['x'],r['before']['z']):r for r in source['rows'] if r['before']['phase']==0}
    values={k:[] for k in ('next_x','next_z','negate')}
    for word in range(8):
        x,z,b=word&1,(word>>1)&1,(word>>2)&1;r=table[x,z]
        values['next_x'].append(r['next'][b]['x']);values['next_z'].append(r['next'][b]['z']);values['negate'].append(r['negate'])
    for row in source['rows']:
        basic=table[row['before']['x'],row['before']['z']]
        if row['negate']!=basic['negate'] or any(row['next'][b][k]!=basic['next'][b][k] for b in (0,1) for k in ('x','z')):
            raise ValueError('Dropped phase affects the future density question')
    forms={k:flat.affine(v,3) for k,v in values.items()}
    # This local in-place order is valid for the derived relation, not an
    # arbitrary update map. Never overwrite x before its old value is used.
    if forms['next_z']!={'constant':0,'terms':[0],'rows_verified':8} or forms['negate']!={'constant':0,'terms':[0],'rows_verified':8}:
        raise ValueError('The supported in-place schedule no longer applies')
    if source['corrections']!=['QX','QZ']:raise ValueError('Correction order changed')
    return forms


def angle(pair):
    if not isinstance(pair,(list,tuple)) or len(pair)!=2 or any(type(x) is not int for x in pair) or pair[1]<=0:
        raise ValueError('An angle is an explicit rational multiple [numerator, positive denominator] of pi')
    f=Fraction(*pair)
    if abs(f)>4 or f.denominator>64:raise ValueError('Angle outside this bounded local adapter')
    return [f.numerator,f.denominator]


class Wire:
    def __init__(self,q,source,selection):
        if q.num_qubits!=4:raise ValueError('Two alternating carriers plus E and Ref are required')
        self.source=deepcopy(source);self.selection=deepcopy(selection);self.forms=lowering(source,selection)
        self.q=q;self.owner=source['initial_owner'];self.program=[];self.corrected_at=[]
        self.x=ClassicalRegister(1,'frame_x');self.z=ClassicalRegister(1,'frame_z');self.reply=ClassicalRegister(1,'reply')
        q.add_register(self.x,self.z,self.reply)
        q.store(self.x[0],bool(source['initial']['x']));q.store(self.z[0],bool(source['initial']['z']));q.store(self.reply[0],False)

    def append(self,angles):
        forms=lowering(self.source,self.selection);values=[angle(a) for a in angles]
        if not values or len(self.program)+len(values)>64:raise ValueError('One through 64 actual measurement steps required')
        q=self.q;variables=[self.x[0],self.z[0],self.reply[0]]
        for a in values:
            incoming=self.owner;outgoing=self.source['next_owner'][incoming];alpha=math.pi*a[0]/a[1]
            q.reset(outgoing);q.h(outgoing);q.cz(incoming,outgoing)
            with q.if_test(flat.expression(forms['negate'],variables)) as otherwise:q.rz(-alpha,incoming)
            with otherwise:q.rz(alpha,incoming)
            q.h(incoming);q.measure(incoming,self.reply[0]);q.reset(incoming)
            q.store(self.reply[0],flat.expression(forms['next_x'],variables))
            q.store(self.z[0],self.x[0]);q.store(self.x[0],self.reply[0]);q.store(self.reply[0],False)
            self.owner=outgoing;self.program.append(a)
        flat.check_flat_fragment(q)
        return self.boundary()

    def rectify(self):
        lowering(self.source,self.selection);q=self.q
        with q.if_test((self.x[0],1)):q.x(self.owner)
        with q.if_test((self.z[0],1)):q.z(self.owner)
        q.store(self.x[0],False);q.store(self.z[0],False);self.corrected_at.append(len(self.program))
        return self.boundary()

    def boundary(self):
        return {'source':admission.fingerprint(self.source),'selection':admission.fingerprint(self.selection),
            'logical_word':deepcopy(self.program),'logical_step':'J(alpha)=H Rz(alpha)',
            'physical_owner':self.owner,'retired_carrier':self.source['next_owner'][self.owner],
            'frame_bits':{'x':self.q.find_bit(self.x[0]).index,'z':self.q.find_bit(self.z[0]).index},
            'rectified_at':list(self.corrected_at),'scope':'Live same-circuit state; this descriptor alone cannot recreate it.'}


def build(output):
    output.mkdir(parents=True,exist_ok=True)
    r=json.loads(goal.run(['node',goal.HERE/'resident_measurement_wire_court.js','build',output]))
    native=goal.ROOT/'.build/arm64-apple-macosx/debug/Tools';text=goal.run([native,'judge','where',output/'ResidentMeasurementWire.swift'])
    assert f"{r['equalities']} equalities" in text and 'THE WHERE holds' in text
    for entry in r['negatives']:
        p=subprocess.run([str(native),'judge','where',str(output/entry['file'])],capture_output=True,text=True,timeout=30)
        assert p.returncode==1 and 'requires the types' in p.stdout+p.stderr
    source=json.loads((output/'wire-reading.json').read_text());selection=plan(source);write(output/'plan.json',selection)
    r['native']=text.strip();r['frame_classes']=len(selection['certificate']['quotient']['observation']);write(output/'build.json',r)
    return {k:r[k] for k in ['equalities','frame_classes','negatives']}


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True)
    print(json.dumps(build(p.parse_args().output.resolve())))
