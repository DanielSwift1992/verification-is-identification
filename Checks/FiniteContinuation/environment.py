#!/usr/bin/env python3
"""Compile a continuing finite environment; run without a planner or an LLM.

The controller sees public tasks, declared change relations and actual probe
receipts. Hidden modules and the live payload belong exclusively to the port.
No cloud access. Exact ideal epochs only; no implicit physical drift detector.
"""
import argparse
from collections import deque
from copy import deepcopy
import hashlib
import json
import math
from pathlib import Path
import uuid

from build_from_source import HERE, ROOT, run
from planner import synthesize


def write(path, value):
    path.write_text(json.dumps(value, indent=2)+'\n')


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rows(mask):
    return [i for i in range(16) if mask & (1 << i)]


def to_mask(indices):
    result = 0
    for i in indices:
        result |= 1 << i
    return result


def graph(reading):
    splits = {p['id']: [to_mask(i for i,b in enumerate(p['replies']) if b == bit)
                        for bit in (0,1)] for p in reading['probes']}
    images = {name: [to_mask(e['after'] for e in reading['edges']
                            if e['before'] == i and e['delta'] in changes)
                      for i in range(16)] for name,changes in reading['profiles'].items()}
    seen = {65535}
    pending = deque(seen)
    transitions = {}
    while pending:
        state = pending.popleft()
        transitions[str(state)] = {}
        for name, edges in images.items():
            target = 0
            for i in rows(state):
                target |= edges[i]
            transitions[str(state)][name] = target
        candidates = list(transitions[str(state)].values())
        candidates += [state & b for bits in splits.values() for b in bits]
        for target in candidates:
            if target and target not in seen:
                seen.add(target)
                pending.append(target)
    return sorted(seen, key=lambda m:(m.bit_count(),m)), splits, transitions


def construct(reading):
    states, splits, transitions = graph(reading)
    classes = {}
    requests = {}
    for task in reading['tasks']:
        signature = tuple(task['answers'])
        classes.setdefault(signature, 'c'+str(len(classes)))
        requests[task['id']] = {'class':classes[signature],
                               **({'middle':task['middle']} if 'middle' in task else {'family':task['family']})}
    policies = {}
    for answers,name in classes.items():
        problem = {'valid': [[a] for a in answers],
                   'actions': {a:{'physical_gates':0} for a in set(answers)},
                   'probes':reading['probes']}
        policy = {}
        # Reuse the frozen, generic minimax constructor. Retain only its next
        # contact and successor family, not thousands of copied subtrees.
        for state in states:
            tree = synthesize(problem, rows(state))['tree']
            if tree['kind'] == 'act':
                node = {'kind':'act','action':tree['action'],'depth':0}
            else:
                assert tree['kind'] == 'probe'
                node = {'kind':'probe','probe':tree['probe'],
                        'next':[state & b for b in splits[tree['probe']]],'depth':tree['cost'][0]}
            policy[str(state)] = node
        policies[name] = policy
    return {'schema':'vi.continuing-environment.v1','source_sha256':reading['source_sha256'],
            'contacts':[{k:v for k,v in p.items() if k != 'replies'} for p in reading['probes']],
            'changes':reading['profiles'],'requests':requests,'states':states,
            'transitions':transitions,'policies':policies}


def build(output):
    if output.exists():
        raise ValueError('Use a new output directory')
    output.mkdir(parents=True)
    reading = json.loads(run(['node',HERE/'environment_court.js','read']))
    write(output/'source-reading.json',reading)
    controller = construct(reading)
    write(output/'controller.json',controller)
    result = json.loads(run(['node',HERE/'environment_court.js','check',output]))
    for proof in result['proofs']:
        log = run([ROOT/'.build/arm64-apple-macosx/debug/Tools','judge','where',output/proof['name']])
        assert 'THE WHERE holds' in log and f"{proof['equalities']} equalities" in log
        proof['native'] = log.strip()
    assert json.loads(run(['node',HERE/'environment_court.js','read'])) == reading
    result['source_sha256'] = reading['source_sha256']
    result['controller_sha256'] = digest(output/'controller.json')
    result['implementation_sha256'] = {str(p.relative_to(ROOT)):digest(p) for p in
        [Path(__file__),HERE/'environment_court.js',HERE/'planner.py',HERE/'renewal_court.js',
         HERE/'contact_court.js',HERE/'court_bridge.js']}
    result['limits'] = ('Source applications and exhaustive finite controller check; '
                        'continuous phase recovery has its separate algebraic proof. '
                        'No hardware or noise validation, no global multi-request cost optimum.')
    write(output/'build.json',result)
    return result


def load(directory):
    certificate = json.loads((directory/'build.json').read_text())
    if digest(directory/'controller.json') != certificate['controller_sha256']:
        raise ValueError('Controller changed after checking')
    for name,expected in {**certificate['source_sha256'], **certificate['implementation_sha256']}.items():
        if digest(ROOT/name) != expected:
            raise ValueError('Current source or interpreter changed: '+name)
    return json.loads((directory/'controller.json').read_text()), certificate['controller_sha256']


def request_id(bundle, request):
    if not isinstance(request,dict):
        raise ValueError('A structured recipient request is required')
    if request.get('kind') == 'phase':
        if (set(request) != {'kind','theta','t'} or type(request['t']) is not int or request['t'] not in (0,1)
            or type(request['theta']) not in (int,float) or not math.isfinite(request['theta'])
            or not math.isfinite(2*request['theta'])):
            raise ValueError('Finite phase angle and a bit-flip bit required')
        return 'phase'
    if request.get('kind') == 'clifford' and set(request) == {'kind','middle'}:
        if not isinstance(request['middle'],list) or any(g not in ('h','s') for g in request['middle']):
            raise ValueError('Undeclared target word')
        key = 'clifford:'+','.join(request['middle'])
        if key in bundle['requests']:
            return key
    raise ValueError('Recipient requirement is outside the compiled interface')


def instructions(bundle, request, action):
    # This consumes an ACQUIRED answer, never a realized module pair.
    request_id(bundle,request)
    if request['kind'] == 'phase':
        if not action.startswith('key:') or len(action) != 7 or any(b not in '01' for b in action[4:]):
            raise ValueError('Phase-family use requires the three-bit key')
        q,p,u = map(int,action[4:])
        target = [['rz',request['theta']]] + ([['x']] if request['t'] else [])
        correction = ([['x']] if p else []) + ([['z']] if q else [])
        if u:
            correction += [['rz',(-1)**request['t']*2*request['theta']]]
    else:
        if action not in ('pauli:I','pauli:X','pauli:Y','pauli:Z'):
            raise ValueError('Clifford use requires its actual residual frame')
        target = [[g] for g in request['middle']]
        correction = [] if action == 'pauli:I' else [[action[-1].lower()]]
    return {'target':target,'correction':correction}


class Environment:
    """An event loop with retained knowledge; only its port touches the source.

    Declared change events must precede the next acquisition/use. Probe receipt
    tokens bind the software calls, not unknown physical epochs. An uncertain
    in-flight operation blocks restart, preventing silent duplicate execution.
    Journal replay recomputes knowledge; a saved mask is never trusted.
    """
    def __init__(self, directory, journal):
        self.bundle,self.fingerprint = load(Path(directory))
        self.fingerprint = self.execution_identity(self.fingerprint)
        self.journal = Path(journal)
        if self.journal.exists():
            saved = json.loads(self.journal.read_text())
            if saved['controller_sha256'] != self.fingerprint:
                raise ValueError('Journal belongs to a different environment')
            self.session = str(uuid.UUID(saved['session']))
            self.events = saved['events']
        else:
            self.session = str(uuid.uuid4())
            self.events = []
        self.state,self.epoch,self.active = self.replay(self.events)
        self._save()

    def _save(self):
        # Atomic local replacement, not a remote transaction or an authenticity
        # guarantee. Caller owns this path; a preexisting journal is replayed.
        temp = self.journal.with_suffix(self.journal.suffix+'.tmp')
        write(temp,{'controller_sha256':self.fingerprint,'session':self.session,'events':self.events})
        temp.replace(self.journal)

    def _append(self, event):
        proposed = self.events+[event]
        state,epoch,active = self.replay(proposed)
        self.events = proposed
        self.state,self.epoch,self.active = state,epoch,active
        self._save()

    def node(self, state, request):
        cls = self.bundle['requests'][request_id(self.bundle,request)]['class']
        return self.bundle['policies'][cls][str(state)]

    def execution_identity(self, base_identity):
        return base_identity

    def validate_port(self, port):
        """Extensions may require an additional owned access relation."""

    def native(self, request, node):
        return instructions(self.bundle,request,node['action'])

    def replay(self, events):
        state,epoch,active,pending,resident = 65535,0,None,None,None
        for index,event in enumerate(events):
            kind = event['kind']
            if pending:
                if kind != 'receipt' or event.get('token') != pending['token']:
                    raise ValueError('Unresolved in-flight operation')
                if event.get('resident') != resident:
                    raise ValueError('Receipt from another resident source')
                if pending['operation'] == 'probe':
                    bit = event.get('bit')
                    if type(bit) is not int or bit not in (0,1):
                        raise ValueError('Nonbinary ideal receipt')
                    node = self.node(state,active)
                    if event.get('contact') != node['probe'] or event.get('epoch') != epoch:
                        raise ValueError('Receipt from another contact or source epoch')
                    state = node['next'][bit]
                else:
                    if event.get('epoch') != epoch or event.get('applied') is not True:
                        raise ValueError('Unestablished payload execution')
                    active = None
                pending = None
            elif kind == 'bind':
                if resident is not None or active is not None or index != 0 or not isinstance(event.get('resident'),str) or not event['resident']:
                    raise ValueError('An environment has one resident source handle')
                resident = event['resident']
            elif kind == 'change':
                if resident is None or active is not None or event.get('profile') not in self.bundle['changes']:
                    raise ValueError('Change outside a declared idle boundary')
                state = self.bundle['transitions'][str(state)][event['profile']]
                epoch += 1
            elif kind == 'request':
                if resident is None or active is not None:
                    raise ValueError('A task is already active')
                request_id(self.bundle,event['request'])
                active = event['request']
            elif kind == 'pending':
                if active is None or event.get('epoch') != epoch:
                    raise ValueError('No current task/epoch for the operation')
                token = self.session+':'+str(index)
                if event.get('token') != token:
                    raise ValueError('Mismatched occurrence token')
                node = self.node(state,active)
                expected = 'probe' if node['kind'] == 'probe' else 'payload'
                if event.get('operation') != expected:
                    raise ValueError('Attempted use before its evidence')
                if expected == 'probe' and event.get('contact') != node['probe']:
                    raise ValueError('Selected contact differs from the checked controller')
                if expected == 'payload' and event.get('action') != node['action']:
                    raise ValueError('Substituted continuation')
                pending = event
            else:
                raise ValueError('Unexpected event '+str(kind))
        # Retain a pending marker for _ready; do not replay its operation.
        self.pending = pending
        self.resident = resident
        return state,epoch,active

    def _ready(self):
        if self.pending:
            raise ValueError('Outcome of the last port call is unknown; reconciliation is required')
        # No token or old status can grant applicability after source edits.
        load_source = self.bundle['source_sha256']
        for name,expected in load_source.items():
            if digest(ROOT/name) != expected:
                raise ValueError('Active source changed; rebuild required')

    def change(self, profile):
        self._ready()
        self._append({'kind':'change','profile':profile})

    def perform(self, request, port, budget=4):
        self._ready()
        request = deepcopy(request)
        request_id(self.bundle,request)
        self.validate_port(port)
        if type(budget) is not int or budget < 0:
            raise ValueError('A nonnegative acquisition budget is required')
        if not isinstance(port.resident,str) or not port.resident:
            raise ValueError('The port must expose its owned resident handle')
        if self.resident is None:
            self._append({'kind':'bind','resident':port.resident})
        elif self.resident != port.resident:
            raise ValueError('This knowledge belongs to a different resident port')
        if self.active is None:
            self._append({'kind':'request','request':deepcopy(request)})
        elif self.active != request:
            raise ValueError('Resume or resolve the actual outstanding request')
        count = 0
        while True:
            node = self.node(self.state,request)
            if node['kind'] == 'probe' and count >= budget:
                return {'kind':'needs_evidence','probes':count,'remaining_sources':self.state.bit_count()}
            token = self.session+':'+str(len(self.events))
            pending = {'kind':'pending','token':token,'epoch':self.epoch,
                       'operation':'probe' if node['kind'] == 'probe' else 'payload'}
            if node['kind'] == 'probe':
                pending['contact'] = node['probe']
                descriptor = next(p for p in self.bundle['contacts'] if p['id'] == node['probe'])
                self._append(pending)
                receipt = port.probe(deepcopy(descriptor),token,self.epoch)
                self._append({'kind':'receipt',**receipt})
                count += 1
            else:
                pending['action'] = node['action']
                native = self.native(request,node)
                self._append(pending)
                receipt = port.apply(native,token,self.epoch)
                self._append({'kind':'receipt',**receipt})
                return {'kind':'applied','probes':count,'action':node['action'],
                        'remaining_sources':self.state.bit_count(),'epoch':self.epoch}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',required=True,type=Path)
    result = build(parser.parse_args().output.resolve())
    print(json.dumps({k:result[k] for k in ('graph','equalities','controller_sha256','limits')},indent=2))
