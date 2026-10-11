#!/usr/bin/env python3
"""Read lowered boundary programs as formal instrument words.

The service matrix is never evaluated. Both replies are retained, including
branches that may have probability zero for a particular device. Equality of
these words implies equality for every substitution of the same instrument
maps, on arbitrary retained states and external references.
"""
from copy import deepcopy
import json

from qiskit.circuit import ClassicalRegister
from qiskit.circuit.classical import expr

import resident_boundary_composition as c


def read_words(circuit, ports, expected_service):
    B, M, E, D, REF = ports
    indices = lambda bits: [circuit.find_bit(bit).index for bit in bits]
    first = {'bits': [0]*circuit.num_clbits, 'probe': 0, 'events': [], 'word': []}

    def get(var, row):
        if isinstance(var, ClassicalRegister):
            return sum(row['bits'][circuit.find_bit(bit).index]<<i for i, bit in enumerate(var))
        return row['bits'][circuit.find_bit(var).index]

    def value(node, row):
        if isinstance(node, expr.Value):
            return node.value
        if isinstance(node, expr.Var):
            return get(node.var, row)
        if isinstance(node, expr.Binary):
            x, y = value(node.left, row), value(node.right, row)
            if node.op.name == 'EQUAL': return x == y
            if node.op.name == 'BIT_XOR': return x ^ y
            if node.op.name == 'LOGIC_AND': return bool(x) and bool(y)
        raise ValueError('Expression outside symbolic boundary fragment')

    def write(var, number, row):
        if isinstance(var, ClassicalRegister):
            c.s.require(0 <= int(number) < 2**len(var), 'Classical overflow')
            for i, bit in enumerate(var):
                row['bits'][circuit.find_bit(bit).index] = (int(number)>>i)&1
        else:
            c.s.require(number in (0, 1), 'Nonbinary bit assignment')
            row['bits'][circuit.find_bit(var).index] = int(number)

    def visit(body, rows, wires, cbits):
        for item in body.data:
            op = item.operation
            qs = [wires[body.find_bit(b).index] for b in item.qubits]
            cs = [cbits[body.find_bit(b).index] for b in item.clbits]
            if op.name == 'if_else':
                after = []
                for row in rows:
                    cond = op.condition
                    yes = get(cond[0], row) == cond[1] if isinstance(cond, tuple) else value(cond, row)
                    selected = 0 if yes else 1
                    after.extend(visit(op.blocks[selected], [row], qs, cs)
                                 if selected < len(op.blocks) else [row])
                rows = after
            elif op.name == 'store':
                for row in rows: write(op.lvalue.var, value(op.rvalue, row), row)
            elif op.name == 'unitary':
                c.s.require(qs == [B, M, E] and op == expected_service,
                            'Another service or another joint port was used')
                for row in rows:
                    c.s.require(row['probe'] == 0, 'Service input probe was not prepared zero')
                    row['probe'] = 'unread service'
            elif op.name == 'measure':
                c.s.require(qs == [B], 'Retained quantum data measured')
                after = []
                for row in rows:
                    pending = row['probe'] == 'unread service'
                    for bit in (0, 1) if pending else [row['probe']]:
                        new = deepcopy(row)
                        new['bits'][cs[0]], new['probe'] = bit, bit
                        if pending:
                            new['word'].append(('service', bit))
                            new['events'].append(('contact', bit))
                        elif op.label and op.label.endswith(':answer'):
                            new['events'].append(('answer', bit))
                        else:
                            c.s.require(bit == 0, 'Inactive contact produced information')
                        after.append(new)
                rows = after
            elif op.name == 'reset':
                c.s.require(qs == [B], 'Retained quantum data reset')
                for row in rows:
                    c.s.require(row['probe'] != 'unread service', 'An unobserved service result was discarded')
                    row['probe'] = 0
            elif op.name == 'x' and qs == [B]:
                for row in rows:
                    c.s.require(row['probe'] in (0, 1), 'Coherent unread probe changed')
                    row['probe'] ^= 1
            elif op.name == 'id':
                c.s.require(qs == [B], 'Unexpected identity anchor')
            elif op.name in ('h', 's', 'z') and qs == [D]:
                for row in rows: row['word'].append((op.name, 'D'))
            elif op.name == 'z' and qs == [E]:
                for row in rows: row['word'].append(('z', 'E'))
            elif op.name == 'cz' and qs == [D, E]:
                for row in rows: row['word'].append(('cz', 'D', 'E'))
            elif op.name == 'barrier':
                pass
            else:
                raise ValueError('Instruction outside symbolic boundary fragment: '+op.name)
        return rows

    rows = visit(circuit, [first], list(range(circuit.num_qubits)), list(range(circuit.num_clbits)))
    c.s.require(all(row['probe'] == 0 for row in rows), 'Disposable probe not returned')
    return rows


def specification(source, events, queries, prefix):
    r, history, word, entry, stage, answers = 0, [], [], None, 0, []
    for kind, bit in events:
        if kind == 'contact':
            gate = source['goal']['raw']['interpreter']['controls'][r ^ bit]['gate']
            word.extend([('service', bit), ({'JointHLabel':'h', 'JointSLabel':'s'}[gate], 'D'),
                         ('z', 'E'), ('cz', 'D', 'E')])
            r = 1 ^ r ^ bit
            history.append(bit)
            if len(history) == prefix: entry = 4*r+2*history[0]+history[-1]
        else:
            c.s.require(entry is not None and stage < len(queries), 'Answer has no requested occurrence')
            query = queries[stage]
            current = 4*r+2*history[0]+history[-1]
            at = entry if query['occurrence'] == 'entry' else current
            c.s.require(query['questions'][len(answers)][at] == bit, 'Wrong symbolic answer')
            answers.append(bit)
            if len(answers) == len(query['questions']):
                code = sum(b<<i for i,b in enumerate(answers))
                if query['recipient'][code]: word.append(('z', 'D'))
                answers, entry, stage = [], current, stage+1
    c.s.require(stage == len(queries) and not answers, 'Requested continuation missing')
    return word, 4*r+2*history[0]+history[-1]


def audit(assembly, cut, queries, prefix=3):
    circuit = assembly.program(cut)
    rows = read_words(circuit, cut._ports, assembly._service)
    unique = set()
    for row in rows:
        expected, current = specification(assembly.source, row['events'], queries, prefix)
        c.s.require(row['word'] == expected, 'Lowered word changed the instrument or retained action')
        code = sum(row['bits'][circuit.find_bit(bit).index]<<i for i,bit in enumerate(cut._memory))
        c.s.require(current in cut.contract['supports'][code], 'Remaining actual memory lost its source')
        for register in circuit.cregs:
            if register.name in circuit.metadata['cleared_scratch']:
                c.s.require(all(row['bits'][circuit.find_bit(bit).index] == 0 for bit in register),
                            'Reused scratch contains an unreturned value')
        key = tuple(row['events'])
        c.s.require(key not in unique, 'One abstract history has duplicate continuations')
        unique.add(key)
    return {'formal_branches': len(rows), 'literal_instrument_words_equal': True,
            'service_matrix_evaluated': False,
            'zero_probability_replies_kept': True,
            'scratch_zero_on_every_formal_branch': True,
            'scope': 'Supported lowered instruction fragment, all formal reply histories; '
                     'equal CP-map words for arbitrary common service substitutions, not hardware accuracy.'}


if __name__ == '__main__':
    import resident_reusable_ability as reuse
    from resident_boundary_composition_checks import question
    from resident_raw_reply_checks import fixture
    source = c.s.reading()
    query = question(source, [170])
    learned = reuse.discover(source, reuse.represented_boundary(source), query)
    cases = []
    for ports in [(0,1,2,3,4), (2,4,0,1,3)]:
        assembly = c.Assembly(source, fixture(1.3,-.8)[0])
        cut = assembly.prepare_first(ports=ports)
        for _ in range(3): cut = reuse.apply(assembly, cut, learned)
        cases.append(audit(assembly, cut, [query]*3))
    output = {'schema':'vi.boundary-symbolic-audit.v1', 'cases':cases}
    path = c.s.ROOT/'Research/Artifacts/resident-reusable-ability-20260915/symbolic.json'
    path.write_text(json.dumps(output, indent=2)+'\n')
    print(json.dumps(output, indent=2))
