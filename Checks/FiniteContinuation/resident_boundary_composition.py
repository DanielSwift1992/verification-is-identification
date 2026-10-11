#!/usr/bin/env python3
"""Compose certified continuations at a source-bound circuit boundary.

A CircuitBoundary is a cut in a program under construction, NOT a serialized
quantum state or a live cloud session. The finite contract is the existing
Swift monitor; recipes contain existing independently checkable certificates.
This adapter has no hardware client and never reads a service matrix.
"""
from copy import deepcopy
from dataclasses import dataclass
from functools import lru_cache
import hashlib
import io
import json

from qiskit import ClassicalRegister, QuantumCircuit, qpy
from qiskit.circuit.classical import expr
from qiskit.circuit.library import UnitaryGate

import resident_goal_synthesis as s
import resident_joint_goals as joint
import resident_goal_compiler as goal
import resident_flat_controller as flat
import whole_word_admission as a


def digest_circuit(q):
    stream = io.BytesIO()
    qpy.dump(q, stream)
    return hashlib.sha256(stream.getvalue()).hexdigest()


@lru_cache(maxsize=2)
def _presentation_at(key):
    return json.loads(s.run(['node', s.HERE/'resident_boundary_representation_court.js', 'read']))


def presentations(source):
    key = tuple(sorted(source['source_sha256'].items())) + tuple(
        (str(p), s.digest(p)) for p in [
            s.ROOT/'Sources/Examples/ResidentBoundaryRepresentation.swift',
            s.HERE/'resident_boundary_representation_court.js'])
    value = _presentation_at(key)
    s.require(value['base_source_sha256'] == source['source_sha256'], 'Presentation has another source')
    for name, digest in value['source_sha256'].items():
        s.require(s.digest(s.ROOT/name) == digest, 'Presentation source changed')
    return deepcopy(value)


def schema(source, supports):
    s.require(type(supports) is list and 2 <= len(supports) <= 512 and
              len(supports) & (len(supports)-1) == 0, 'A bounded binary memory encoding is required')
    relative = source['goal']['observation']['continue']
    for block in supports:
        s.require(type(block) is list and block == sorted(set(block)) and
                  all(type(i) is int and 0 <= i < 8 for i in block), 'Invalid memory fiber')
        if block:
            s.require(len({relative[i][0] for i in block}) == 1, 'Memory cannot select the actual contact')
    s.require(any(supports), 'Empty boundary domain')
    return {'schema': 'vi.circuit-boundary.v1', 'source': a.fingerprint(source),
            'supports': deepcopy(supports), 'memory_width': (len(supports)-1).bit_length(),
            'quantum_roles': ['probe', 'hidden_memory', 'service', 'data', 'reference'],
            'probe_at_cut': 'zero',
            'input_scope': 'CQ monitor memory; arbitrary retained DEM and reference, including correlations.',
            'instance_kind': 'circuit construction boundary, not a persisted physical state'}


def validate_schema(source, value):
    s.require(value == schema(source, value['supports']), 'Boundary source or preservation contract changed')


def recipe(source, boundary_schema, query):
    """Independent of producer name, physical ports, or service parameters."""
    s.validate_source(source)
    validate_schema(source, boundary_schema)
    joint.validate_request(source, query)
    certs = [joint.synthesize(source, block, query) if block else None
             for block in boundary_schema['supports']]
    result = {'schema': 'vi.boundary-recipe.v1', 'input': deepcopy(boundary_schema),
              'query': deepcopy(query), 'certificates': certs}
    result['applicable'] = all(c is None or c['worst_case_contacts'] is not None for c in certs)
    verify_recipe(source, result)
    return result


def verify_recipe(source, value):
    """Check certificates, not a second search for the same solution."""
    s.require(set(value) == {'schema', 'input', 'query', 'certificates', 'applicable'} and
              value['schema'] == 'vi.boundary-recipe.v1', 'Unknown recipe contract')
    validate_schema(source, value['input'])
    joint.validate_request(source, value['query'])
    certs = value['certificates']
    s.require(len(certs) == len(value['input']['supports']), 'Input memory domain changed')
    for block, certificate in zip(value['input']['supports'], certs):
        if not block:
            s.require(certificate is None, 'Unreachable input gained an assumed answer')
        else:
            s.require(certificate is not None and certificate['input_support'] == block and
                      certificate['query'] == value['query'], 'Recipe substituted its input question/fiber')
            joint.verify(source, certificate)
    applicable = all(c is None or c['worst_case_contacts'] is not None for c in certs)
    s.require(type(value['applicable']) is bool and value['applicable'] == applicable, 'Unproved admission')
    return applicable


def linked_nodes(value):
    nodes, starts = [], {}
    for code, cert in enumerate(value['certificates']):
        if cert is None:
            continue
        reached, todo = {0}, [0]
        while todo:
            i = todo.pop()
            if cert['nodes'][i]['answers'] is None:
                for j in cert['nodes'][i]['next']:
                    if j not in reached:
                        reached.add(j)
                        todo.append(j)
        indices = {old: len(nodes)+i for i, old in enumerate(sorted(reached))}
        starts[code] = indices[0]
        for i in sorted(reached):
            row = cert['nodes'][i]
            nodes.append({**deepcopy(row), 'next': [indices[j] for j in row['next']]
                          if row['answers'] is None else None})
    return nodes, starts


def output_schema(source, value):
    """Compute the remaining source domain from checked terminal pairs."""
    s.require(verify_recipe(source, value), 'A refused recipe has no promised exit')
    nodes, _ = linked_nodes(value)
    width = max(1, (len(nodes)-1).bit_length())
    supports = [[] for _ in range(2**width)]
    for i, row in enumerate(nodes):
        if row['answers'] is not None:
            supports[i] = sorted({state for _, state in row['pairs']})
    return schema(source, supports)


def recoding(source, given, wanted):
    """Find a total classical reading on the declared input domain.

    An output fiber may contain more possibilities: forgetting a distinction
    is allowed. A label never certifies an input state outside its fiber.
    """
    validate_schema(source, given)
    validate_schema(source, wanted)
    mapping = []
    for block in given['supports']:
        choices = [i for i, target in enumerate(wanted['supports'])
                   if set(block) <= set(target)] if block else []
        s.require(not block or choices, 'Requested memory needs an unavailable distinction')
        mapping.append(min(choices) if choices else None)
    value = {'schema': 'vi.boundary-recoding.v1', 'input': deepcopy(given),
             'output': deepcopy(wanted), 'mapping': mapping}
    verify_recoding(source, value)
    return value


def verify_recoding(source, value):
    s.require(set(value) == {'schema', 'input', 'output', 'mapping'} and
              value['schema'] == 'vi.boundary-recoding.v1', 'Unknown memory reading')
    validate_schema(source, value['input'])
    validate_schema(source, value['output'])
    s.require(len(value['mapping']) == len(value['input']['supports']), 'Input domain omitted')
    targets = value['output']['supports']
    for block, code in zip(value['input']['supports'], value['mapping']):
        if not block:
            s.require(code is None, 'Unreachable memory value acquired an invented meaning')
        else:
            s.require(type(code) is int and 0 <= code < len(targets) and
                      set(block) <= set(targets[code]), 'Memory reading invents a source distinction')
    return True


@dataclass(frozen=True, eq=False)
class CircuitBoundary:
    _owner: object
    _generation: int
    _schema: dict
    _memory: object
    _ports: tuple
    _seal: str

    @property
    def contract(self):
        return deepcopy(self._schema)


class Assembly:
    """Own one program while modules independently build its continuations.

    Ownership guards construction-time substitution/stale use. They are not
    a security boundary against arbitrary Python mutation or a proof of the
    physical identity of an external device.
    """
    def __init__(self, source, service):
        s.validate_source(source)
        s.require(isinstance(service, UnitaryGate) and service.num_qubits == 3,
                  'The supported opaque service requires three ports')
        self.source = deepcopy(source)
        self._service = service.copy()
        self._service.label = 'unmodelled_service'
        self._q = QuantumCircuit(5)
        self._current = None
        self._generation = 0
        self._answer_index = 0
        self._free_registers = []
        self.trace = []

    def _mint(self, q, ports, memory, supports, free_registers):
        value = schema(self.source, supports)
        s.require(len(memory) == value['memory_width'], 'Actual memory width differs')
        s.require(len(set(free_registers)) == len(free_registers) and
                  memory.name not in free_registers and
                  all(any(reg.name == name for reg in q.cregs) for name in free_registers),
                  'Invalid scratch ownership')
        self._generation += 1
        self._q = q
        self._free_registers = list(free_registers)
        cut = CircuitBoundary(self, self._generation, value, memory, tuple(ports),
                              self._seal(q, value, memory, ports))
        self._current = cut
        return cut

    def _seal(self, q, contract, memory, ports):
        return a.fingerprint({'program': digest_circuit(q), 'contract': contract,
                              'memory_bits': [q.find_bit(b).index for b in memory],
                              'ports': list(ports), 'trace': self.trace,
                              'free_registers': self._free_registers})

    @staticmethod
    def _take_register(q, available, width, name):
        # Only explicitly cleared, non-exported storage can be taken again.
        for reg in q.cregs:
            if reg.name in available and len(reg) == width:
                available.remove(reg.name)
                return reg
        reg = ClassicalRegister(width, name)
        q.add_register(reg)
        return reg

    def _guard(self, cut):
        s.require(cut is self._current and cut._owner is self and
                  cut._generation == self._generation, 'Boundary is stale or belongs to another assembly')
        s.validate_source(self.source)
        validate_schema(self.source, cut._schema)
        s.require(sorted(cut._ports) == list(range(5)) and
                  cut._memory in self._q.cregs, 'Actual port or memory binding changed')
        s.require(self._seal(self._q, cut._schema, cut._memory, cut._ports) == cut._seal,
                  'Program or supporting boundary relation changed outside its construction')

    def prepare_first(self, *, presentation='direct', ports=(0, 1, 2, 3, 4), contacts=3):
        s.require(self._current is None and not self._q.data and self._generation == 0,
                  'Initial acquisition may occur only once')
        s.require(type(contacts) is int and 1 <= contacts <= 8 and sorted(ports) == list(range(5)) and
                  all(type(p) is int for p in ports), 'Invalid initial contact count/ports')
        readings = presentations(self.source)
        s.require(presentation in readings['views'], 'Unknown source-derived presentation')
        view = readings['views'][presentation]
        encoded = [x[0]+2*x[1] for x in view]
        supports = [[i for i, code in enumerate(encoded) if code == k] for k in range(4)]
        plan = goal.plan(self.source['goal'], 'first')
        ctl = goal.interpret(self.source['goal'], plan)
        classes = plan['certificate']['classes']
        output = []
        for cls in range(ctl['size']):
            choices = {encoded[i] for i, c in enumerate(classes) if c == cls}
            s.require(len(choices) == 1, 'Presentation needs an unacquired distinction')
            output.append(next(iter(choices)))
        q = self._q.copy()
        current = ClassicalRegister(ctl['width'], 'prepared_current')
        old = ClassicalRegister(ctl['width'], 'prepared_previous')
        reply = ClassicalRegister(1, 'prepared_reply')
        memory = ClassicalRegister(2, 'prepared_memory')
        q.add_register(current, old, reply, memory)
        B, M, E, D, REF = ports
        def emit(label):
            s.require(label in ('JointHLabel', 'JointSLabel'), 'Unknown source action')
            getattr(q, {'JointHLabel': 'h', 'JointSLabel': 's'}[label])(D)
        for step in range(contacts):
            q.reset(B)
            q.append(self._service, [B, M, E])
            q.measure(B, reply[0])
            if step == 0:
                for b in (0, 1):
                    with q.if_test((reply[0], b)):
                        emit(self.source['goal']['raw']['interpreter']['controls'][b]['gate'])
                        q.store(current, ctl['initial'][b])
            else:
                q.store(old, current)
                for cls in range(ctl['size']):
                    for b in (0, 1):
                        with q.if_test(flat.predicate(old, cls, reply[0], b)):
                            emit(ctl['emit'][cls][b])
                            q.store(current, ctl['next']['reply'+str(b)][cls])
            q.z(E)
            q.cz(D, E)
        for cls, code in enumerate(output):
            with q.if_test((current, cls)):
                q.id(B)
                q.store(memory, code)
        q.store(current, 0)
        q.store(old, 0)
        q.store(reply[0], False)
        q.reset(B)
        flat.check_flat_fragment(q)
        self.trace.append({'kind': 'prepare', 'contacts': contacts, 'ports': list(ports),
                           'presentation': presentation, 'presentation_sha256': readings['source_sha256'],
                           'controller': plan})
        return self._mint(q, ports, memory, supports, [current.name, old.name, reply.name])

    def extend(self, cut, compiled):
        self._guard(cut)
        s.require(compiled['input'] == cut._schema, 'Recipe does not apply to the actual input boundary')
        s.require(verify_recipe(self.source, compiled), 'No uniformly bounded continuation for this input domain')
        nodes, starts = linked_nodes(compiled)
        width = max(1, (len(nodes)-1).bit_length())
        s.require(width <= 9, 'Controller exceeds the supported boundary budget')
        q = self._q.copy()
        available = list(self._free_registers)
        tag = f'part{self._generation}'
        node = self._take_register(q, available, width, tag+'_node')
        old = self._take_register(q, available, width, tag+'_previous')
        reply = self._take_register(q, available, 1, tag+'_reply')
        n = len(compiled['query']['questions'])
        packet = self._take_register(q, available, n, tag+'_packet')
        returned = ClassicalRegister(n, tag+'_answers')
        q.add_register(returned)
        B, M, E, D, REF = cut._ports
        for code, start in starts.items():
            with q.if_test((cut._memory, code)):
                q.id(B)
                q.store(node, start)
        q.store(cut._memory, 0)
        available.append(cut._memory.name)
        bound = max(c['worst_case_contacts'] for c in compiled['certificates'] if c is not None)
        for _ in range(bound):
            q.store(old, node)
            q.reset(B)
            for i, row in enumerate(nodes):
                if row['answers'] is None:
                    with q.if_test((old, i)):
                        q.append(self._service, [B, M, E])
            q.measure(B, reply[0])
            for i, row in enumerate(nodes):
                if row['answers'] is None:
                    for b in (0, 1):
                        label = self.source['goal']['raw']['interpreter']['controls'][row['relative'] ^ b]['gate']
                        s.require(label in ('JointHLabel', 'JointSLabel'), 'Unknown source continuation action')
                        with q.if_test(flat.predicate(old, i, reply[0], b)):
                            getattr(q, {'JointHLabel': 'h', 'JointSLabel': 's'}[label])(D)
                            q.z(E)
                            q.cz(D, E)
                            q.store(node, row['next'][b])
            q.store(old, 0)
            q.store(reply[0], False)
        # These fields are scratch even when bound == 0: they were either
        # freshly zero-initialized or obtained from an explicitly cleared pool.
        available.extend([old.name, reply.name])
        q.reset(B)
        supports = [[] for _ in range(2**width)]
        for i, row in enumerate(nodes):
            if row['answers'] is not None:
                supports[i] = sorted({state for _, state in row['pairs']})
                with q.if_test((node, i)):
                    q.id(B)
                    q.store(packet, row['code'])
        for bit in range(n):
            with q.if_test((packet[bit], 1)):
                q.x(B)
            from qiskit.circuit import Measure
            q.append(Measure(label=f'goal{self._answer_index+bit}:answer'), [B], [returned[bit]])
            q.reset(B)
        q.store(packet, 0)
        available.append(packet.name)
        for code, bit in enumerate(compiled['query']['recipient']):
            if bit:
                with q.if_test((returned, code)):
                    q.z(D)
        flat.check_flat_fragment(q)
        self._answer_index += n
        self.trace.append({'kind': 'extend', 'recipe': deepcopy(compiled),
                           'answers': returned.name, 'nodes': nodes, 'bound': bound})
        return self._mint(q, cut._ports, node, supports, available)

    def program(self, cut):
        self._guard(cut)
        q = self._q.copy()
        q.metadata = {'schema': 'vi.boundary-composition-program.v1',
                      'source': a.fingerprint(self.source), 'ports': list(cut._ports),
                      'boundary': cut.contract, 'memory': cut._memory.name,
                      'trace': deepcopy(self.trace), 'physical_state_serialized': False,
                      'cleared_scratch': list(self._free_registers)}
        return q

    def recode(self, cut, transport):
        """Recode actual classical memory without touching retained quantum ports."""
        self._guard(cut)
        s.require(transport['input'] == cut._schema, 'Memory reading has another actual input')
        verify_recoding(self.source, transport)
        q = self._q.copy()
        available = list(self._free_registers)
        memory = self._take_register(q, available, transport['output']['memory_width'],
                                     f'boundary_memory{self._generation}')
        for old, new in enumerate(transport['mapping']):
            if new is not None:
                with q.if_test((cut._memory, old)):
                    # Preserve the already-audited SDK fragment: bare Store
                    # branches are not reliable in this installed Aer path.
                    q.id(cut._ports[0])
                    q.store(memory, new)
        q.store(cut._memory, 0)
        available.append(cut._memory.name)
        flat.check_flat_fragment(q)
        self.trace.append({'kind': 'recode', 'reading': deepcopy(transport),
                           'quantum_contacts': 0})
        return self._mint(q, cut._ports, memory, transport['output']['supports'], available)
