#!/usr/bin/env python3
"""A finite learner whose actual attempts repair data and consume return reserve.

The finite law rows are read from the current Swift construction. The working
controller gets replies, not the true row. A separate exact operator semantics
certifies each admitted episode. This is a local model, not an IBM adapter.
"""
from dataclasses import dataclass
from fractions import Fraction as F
from functools import lru_cache
import hashlib
import json
from pathlib import Path
import subprocess

from resident_record_recovery import (
    matrix, identity, multiply, choi, transpose,
)

ROOT = Path(__file__).resolve().parents[2]
I = identity(2)
X = matrix([[0, 1], [1, 0]])
Z = matrix([[1, 0], [0, -1]])
P0 = matrix([[1, 0], [0, 0]])
P1 = matrix([[0, 0], [0, 1]])
ROTATION = matrix([[F(3, 5), -F(4, 5)], [F(4, 5), F(3, 5)]])


def require(condition, message):
    if not condition:
        raise ValueError(message)


def fingerprint(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True).encode()).hexdigest()


def read_source():
    result = subprocess.run(['node', str(Path(__file__).with_name('returning_attempt_court.js')), 'read'],
                            capture_output=True, text=True, check=True, timeout=30)
    source = json.loads(result.stdout)
    require(source['schema'] == 'vi.returning-attempt-source.v1', 'Wrong source schema')
    for name, expected in source['source_sha256'].items():
        require(hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == expected,
                'Current source differs from its reading: ' + name)
    return source


EPISODES = {
    'B': {'field': 'ProbeB', 'dephase': False, 'restores_contact': True},
    'Parity': {'field': 'ProbeParity', 'dephase': False, 'restores_contact': True},
    'Residue': {'field': 'Residue', 'dephase': False, 'restores_contact': True},
    'DirectDestructive': {'field': 'Control', 'dephase': True, 'restores_contact': True},
    'BWithoutReturn': {'field': 'ProbeB', 'dephase': False, 'restores_contact': False},
}


def repaired_terms(name, reply):
    """Actual probe Z^b, possible dephasing, then the actual reply's Z^b."""
    e = EPISODES[name]
    z = Z if reply else I
    noise = (P0, P1) if e['dephase'] else (I,)
    return [(F(1), multiply(z, multiply(z, k))) for k in noise]


def admission(name):
    e = EPISODES[name]
    data = all(choi(repaired_terms(name, b)) == choi([(F(1), I)]) for b in (0, 1))
    # Contact restoration is the declared concrete mode transition below;
    # the data part is established from operators, never a "preserves" flag.
    return {'data_preserved': data, 'contact_restored': e['restores_contact'],
            'admitted': data and e['restores_contact']}


def successors(source, support, probe):
    field = EPISODES[probe]['field']
    return {b: tuple(i for i in support if source['rows'][i][field] == b)
            for b in (0, 1) if any(source['rows'][i][field] == b for i in support)}


def shared_control(source, support):
    values = {source['rows'][i]['Control'] for i in support}
    return next(iter(values)) if len(values) == 1 else None


def synthesize(source, support=None, reserve=2, catalogue=('B', 'Parity', 'Residue')):
    """Acquire a ONE-service-call ability; not a universal solvability test.

    Echo below may already solve a goal without acquiring such an ability.
    A missing acquisition tree must never be called global impossibility.
    """
    support = tuple(range(len(source['rows']))) if support is None else tuple(support)
    require(support and support == tuple(sorted(set(support))), 'Nonempty ordered support required')
    require(type(reserve) is int and reserve >= 0, 'Invalid return reserve')
    require(all(p in EPISODES for p in catalogue), 'Unknown episode')
    allowed = tuple(p for p in catalogue if admission(p)['admitted'])

    @lru_cache(None)
    def solve(compatible, remaining):
        answer = shared_control(source, compatible)
        if answer is not None:
            return {'kind': 'act', 'support': list(compatible), 'remaining': remaining,
                    'control': answer, 'rank': 0}
        if not remaining:
            return None
        candidates = []
        for probe in allowed:
            children = {str(b): solve(group, remaining - 1)
                        for b, group in successors(source, compatible, probe).items()}
            if all(c is not None for c in children.values()):
                rank = 1 + max(c['rank'] for c in children.values())
                candidates.append((rank, probe, children))
        if not candidates:
            return None
        rank, probe, children = min(candidates, key=lambda x: (x[0], x[1]))
        return {'kind': 'probe', 'support': list(compatible), 'remaining': remaining,
                'probe': probe, 'branches': children, 'rank': rank}

    tree = solve(support, reserve)
    certificate = {'source': fingerprint(source), 'catalogue': list(catalogue),
                   'support': list(support), 'reserve': reserve, 'tree': tree}
    if tree is not None:
        verify(source, certificate)
    return certificate


def verify(source, certificate):
    """Independent upper-bound proof check. Does not call search/solve."""
    require(certificate['source'] == fingerprint(source), 'Different source')
    allowed = certificate['catalogue']
    require(all(p in EPISODES for p in allowed), 'Unknown proof episode')

    def visit(node, support, remaining):
        require(node is not None and node['support'] == list(support) and
                node['remaining'] == remaining, 'Wrong branch input/readiness')
        require(support and all(0 <= i < len(source['rows']) for i in support), 'Bad support')
        if node['kind'] == 'act':
            require(node['rank'] == 0 and all(source['rows'][i]['Control'] == node['control']
                                            for i in support), 'Not one applicable action')
            return 0
        require(node['kind'] == 'probe' and remaining > 0, 'No return resource')
        p = node['probe']
        require(p in allowed and admission(p)['admitted'], 'Episode cannot return the required boundary')
        actual = successors(source, support, p)
        require(set(node['branches']) == {str(b) for b in actual}, 'Missing or invented outcome')
        ranks = [visit(node['branches'][str(b)], group, remaining - 1) for b, group in actual.items()]
        require(node['rank'] == 1 + max(ranks), 'No strict episode rank descent')
        return node['rank']

    return visit(certificate['tree'], tuple(certificate['support']), certificate['reserve'])


@dataclass(frozen=True)
class Reply:
    owner: object
    source: str
    serial: int
    probe: str
    value: int


class LocalPort:
    """Declared physical toy family; _row is audit/device state, never a policy input.

    operator records the exact action on an arbitrary incoming data/reference.
    It is not used by the controller to choose probes or working corrections.
    Python encapsulation here is a functional separation, not a security claim.
    """
    def __init__(self, source, actual_row, reserve=2):
        self._row = dict(source['rows'][actual_row])
        self.source = fingerprint(source)
        self.owner = object()
        self.reserve = reserve
        self.mode = 'ready'
        self.serial = 0
        self.operator = I
        self.events = []
        self._pending = None

    def probe(self, name):
        require(name in ('B', 'Parity', 'Residue'), 'This port exposes only the certified probe bodies')
        require(self.mode == 'ready' and self.reserve > 0, 'Probe lacks a restorable boundary')
        b = self._row[EPISODES[name]['field']]
        self.operator = multiply(Z if b else I, self.operator)
        self.mode = 'spent'
        self.serial += 1
        self._pending = Reply(self.owner, self.source, self.serial, name, b)
        self.events.append(('probe', name, b))
        return self._pending

    def repair(self, reply, *, faulty_skip_correction=False):
        require(self.mode == 'spent' and self.reserve > 0 and reply == self._pending,
                'Repair must consume the actual outstanding attempt')
        if not faulty_skip_correction:
            self.operator = multiply(Z if reply.value else I, self.operator)
        self.reserve -= 1
        self.mode = 'ready'
        self._pending = None
        self.events.append(('repair', reply.serial, self.reserve))

    def work(self, control, gate):
        require(self.mode == 'ready', 'A matching visible reply is not readiness')
        require(control in (0, 1) and multiply(transpose(gate), gate) == I, 'Invalid working command')
        # The same unknown device contributes its phase; the acquired control
        # cancels it. Neither the work caller nor its ability reads _row.
        actual = multiply(Z if control else I, multiply(Z if self._row['Control'] else I, gate))
        self.operator = multiply(actual, self.operator)
        self.events.append(('work', control))

    def new_payload(self):
        """A distinct later caller supplies arbitrary fresh data, not a retry reset."""
        require(self.mode == 'ready', 'Previous attempt is still incomplete')
        self.operator = I
        self.events.append(('new_payload',))


class Knowledge:
    def __init__(self, source, owner, support=None):
        self.source = fingerprint(source)
        self.owner = owner
        self.support = tuple(range(len(source['rows']))) if support is None else tuple(support)
        self.last_serial = 0

    def acquire(self, source, reply):
        require(self.source == fingerprint(source) == reply.source and reply.owner is self.owner,
                'Fact is from a different source occurrence')
        require(reply.serial > self.last_serial, 'This old reply is not a new occurrence')
        self.support = successors(source, self.support, reply.probe).get(reply.value, ())
        require(self.support, 'Reply is inconsistent with the admitted family')
        self.last_serial = reply.serial


@dataclass(frozen=True)
class Ability:
    source: str
    owner: object
    control: int

    def apply(self, port, gate):
        require(port.source == self.source and port.owner is self.owner,
                'Acquired ability belongs to another port')
        port.work(self.control, gate)


def learn(source, port, certificate, knowledge=None):
    verify(source, certificate)
    knowledge = Knowledge(source, port.owner) if knowledge is None else knowledge
    require(port.source == knowledge.source == certificate['source'] and
            port.owner is knowledge.owner and port.mode == 'ready' and
            list(knowledge.support) == certificate['support'] and
            port.reserve == certificate['reserve'], 'Actual input boundary does not match the proof')
    node = certificate['tree']
    while node['kind'] == 'probe':
        reply = port.probe(node['probe'])
        port.repair(reply)
        knowledge.acquire(source, reply)
        node = node['branches'][str(reply.value)]
        require(list(knowledge.support) == node['support'] and port.reserve == node['remaining'],
                'Actual history did not reach the proposed branch')
    require(shared_control(source, knowledge.support) == node['control'], 'Unjustified acquired command')
    return Ability(port.source, port.owner, node['control']), knowledge


def echo(port, gate):
    """A shared two-call word, requiring no record about the unknown phase."""
    port.work(0, gate)
    port.work(0, I)


def choose_strategy(source, task_count, reserve=2, support=None):
    """Joint finite minimax search over queries, single use and echo.

    Probe and repair each cost one interface command; a work call costs one.
    This is not seconds, primitive gates, acquisition of the model or QPU cost.
    Every move reduces remaining reserve or remaining tasks, so the recursion
    is finite. The solver may interleave acquisition and completed goals.
    """
    require(type(task_count) is int and task_count > 0, 'Positive declared task count required')
    require(type(reserve) is int and 0 <= reserve <= 8, 'Bounded declared reserve required')
    support = tuple(range(len(source['rows']))) if support is None else tuple(support)
    catalogue = tuple(p for p in EPISODES if admission(p)['admitted'])

    @lru_cache(None)
    def solve(compatible, remaining, pending):
        node = {'support':list(compatible), 'remaining':remaining, 'pending':pending}
        if pending == 0:
            return {**node, 'kind':'done', 'cost':0}
        child = solve(compatible, remaining, pending - 1)
        choices = [(2 + child['cost'], 1, 'echo', {'next':child})]
        control = shared_control(source, compatible)
        if control is not None:
            choices.append((1 + child['cost'], 0, 'single', {'control':control,'next':child}))
        if remaining:
            for p in catalogue:
                children = {str(b):solve(post,remaining-1,pending)
                            for b,post in successors(source,compatible,p).items()}
                choices.append((2 + max(c['cost'] for c in children.values()),2,p,{'branches':children}))
        cost, priority, name, continuation = min(choices,key=lambda v:v[:3])
        return {**node,'kind':'probe' if priority==2 else name,'cost':cost,
                **({'probe':name} if priority==2 else {}),**continuation}

    tree = solve(support,reserve,task_count)
    answer = {'source':fingerprint(source),'tree':tree,'cost':tree['cost'],
              'kind':tree['kind'],'task_count':task_count,'reserve':reserve,'support':list(support),
              'scope':'Minimum worst-case interface commands in the finite declared episode/single/echo language, including their interleavings.'}
    verify_batch(source,answer)
    return answer


def verify_batch(source, certificate):
    """Check an executable upper bound without invoking its optimizer."""
    require(certificate['source']==fingerprint(source),'Wrong batch source')
    def check(node,support,reserve,pending):
        require(node['support']==list(support) and node['remaining']==reserve and
                node['pending']==pending,'Wrong actual batch boundary')
        if node['kind']=='done':
            require(pending==0 and node['cost']==0,'Unfinished goals called done')
            return 0
        require(pending>0,'Action after completion')
        if node['kind'] in ('single','echo'):
            if node['kind']=='single':
                require(shared_control(source,support)==node['control'],'Unknown one-call correction')
            cost=(1 if node['kind']=='single' else 2)+check(node['next'],support,reserve,pending-1)
        else:
            require(node['kind']=='probe' and reserve>0 and admission(node['probe'])['admitted'],
                    'Invalid returning episode in batch')
            outcomes=successors(source,support,node['probe'])
            require(set(node['branches'])=={str(b) for b in outcomes},'Batch omitted an actual reply')
            cost=2+max(check(node['branches'][str(b)],post,reserve-1,pending) for b,post in outcomes.items())
        require(node['cost']==cost,'Wrong full command cost')
        return cost
    cost=check(certificate['tree'],tuple(certificate['support']),certificate['reserve'],certificate['task_count'])
    require(cost==certificate['cost'],'Wrong batch root price')
    return cost


def execute_batch(source,port,certificate,gates):
    """All choices use the checked tree and actual replies, never _row.

    Output matrices are audit observations only; no choice branches on them.
    Each new_payload denotes a genuinely new input supplied between goals,
    never replacement of data during an acquisition or a working word.
    """
    verify_batch(source,certificate)
    require(port.source==certificate['source'] and port.mode=='ready' and
            port.reserve==certificate['reserve'] and len(gates)==certificate['task_count'],
            'Batch requires another current boundary')
    knowledge=Knowledge(source,port.owner)
    require(list(knowledge.support)==certificate['support'],'Batch entry is not initial available evidence')
    node=certificate['tree'];outputs=[]
    while node['kind']!='done':
        if node['kind']=='probe':
            reply=port.probe(node['probe']);port.repair(reply);knowledge.acquire(source,reply)
            node=node['branches'][str(reply.value)]
        else:
            gate=gates[len(outputs)]
            if node['kind']=='echo':echo(port,gate)
            else:Ability(port.source,port.owner,node['control']).apply(port,gate)
            outputs.append(port.operator)
            node=node['next']
            if len(outputs)<len(gates):port.new_payload()
        require(list(knowledge.support)==node['support'] and port.reserve==node['remaining'],
                'Working branch is not the acquired boundary')
    control=shared_control(source,knowledge.support)
    ability=None if control is None else Ability(port.source,port.owner,control)
    return outputs,ability,knowledge
