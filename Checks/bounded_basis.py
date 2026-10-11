#!/usr/bin/env python3
"""Word-budget closure, sieve residue and retained macro execution."""
from itertools import product
import json
from pathlib import Path
import sys


def reach(atoms, budget, combine, identity):
    result = {identity}
    frontier = {identity}
    for _ in range(budget):
        frontier = {combine(x, a) for x in frontier for a in atoms}
        result |= frontier
    return result


def sieve(library, budget, combine, identity):
    atoms = []
    for value in library:
        if value not in reach(atoms, budget, combine, identity):
            atoms.append(value)
    return atoms


def monoids(n):
    # Enumerate all tables with distinguished identity 0, and independently
    # retain exactly the associative ones.
    for cells in product(range(n), repeat=(n-1)**2):
        table = tuple(tuple(j if i == 0 else i if j == 0 else cells[(i-1)*(n-1)+j-1]
                            for j in range(n)) for i in range(n))
        if all(table[table[a][b]][c] == table[a][table[b][c]]
               for a, b, c in product(range(n), repeat=3)):
            yield table


def algebra_audit():
    counts = {'monoids': 0, 'flattening_identities': 0, 'sieve_models': 0}
    for n in (2, 3):
        for table in monoids(n):
            counts['monoids'] += 1
            combine = lambda x, y: table[x][y]
            for mask in range(1 << n):
                library = tuple(i for i in range(n) if mask & (1 << i))
                for d, e in product(range(4), repeat=2):
                    nested = reach(reach(library, e, combine, 0), d, combine, 0)
                    assert nested == reach(library, d*e, combine, 0)
                    counts['flattening_identities'] += 1
                for e in range(1, 4):
                    atoms = sieve(library, e, combine, 0)
                    assert set(atoms) <= set(library) <= reach(atoms, e, combine, 0)
                    # In an n-state multiplication graph, every reachable
                    # state has a simple path from identity of length <=n-1.
                    assert reach(atoms, n, combine, 0) == reach(atoms, n+1, combine, 0)
                    assert reach(library, n, combine, 0) == reach(library, n+1, combine, 0)
                    assert reach(atoms, n, combine, 0) == reach(library, n, combine, 0)
                    for d in range(4):
                        assert reach(library, d, combine, 0) <= reach(atoms, d*e, combine, 0)
                    counts['sieve_models'] += 1
    return counts


def residue_audit():
    # For addition, the finite-prefix sieve matches the exact infinite
    # formula A_d={1+kd:k>=0}. The article proves it by residues mod d.
    count = 0
    for d in range(1, 5):
        for limit in range(1, 21):
            actual = sieve(range(1, limit+1), d, lambda x, y: x+y, 0)
            assert actual == list(range(1, limit+1, d))
            count += 1
    multiplicative = sieve(range(2, 17), 2, lambda x, y: x*y, 1)
    assert 8 in multiplicative and 4 not in multiplicative and 6 not in multiplicative
    # Reachability is not strict cost improvement: 2=1+1 has equal cost
    # under the additive norm, yet the reachability sieve marks it derived.
    assert sieve((1, 2), 2, lambda x, y: x+y, 0) == [1]
    assert 1+1 == 2
    return count, multiplicative


def macro_audit():
    a = ('a',)
    library = ('a', 'aa')
    concat = lambda x, y: x+y
    assert reach(a, 2, concat, '') == {'', 'a', 'aa'}
    assert reach(library, 2, concat, '') == {'', 'a', 'aa', 'aaa', 'aaaa'}
    assert sieve(library, 2, concat, '') == ['a']
    # Arbitrary two-symbol definitions of length 0..2, arbitrary programs
    # of length 0..3. Check literal expansion with an independent evaluator.
    definitions = ('', 'a', 'b', 'aa', 'ab', 'ba', 'bb')
    count = 0
    for first, second in product(definitions, repeat=2):
        dictionary = (first, second)
        for length in range(4):
            for program in product(range(2), repeat=length):
                expanded = ''.join(dictionary[i] for i in program)
                assert len(expanded) == sum(len(dictionary[i]) for i in program)
                assert len(expanded) <= 2*len(program)
                # Noncommuting permutations detect reversal of substitution.
                for initial in range(3):
                    def run(word, state):
                        for op in word:
                            state = (state+1) % 3 if op == 'a' else (1, 0, 2)[state]
                        return state
                    macro_state = initial
                    for i in program:
                        macro_state = run(dictionary[i], macro_state)
                    assert run(expanded, initial) == macro_state
                count += 1
    # Enumeration cost can rise although expression length falls.
    def rank(atoms, target):
        attempted = 0
        for n in range(5):
            for word in product(atoms, repeat=n):
                attempted += 1
                if ''.join(word) == target:
                    return attempted
        raise AssertionError('target not reached')
    assert rank(('a',), 'aaaa') == 5
    assert rank(('a', 'aa'), 'aaaa') == 7
    return count


def closed_execution():
    # A native primitive adds one modulo five. X expands to one primitive,
    # Y to two. The chosen two-macro program and its phase are internal.
    programs = tuple(product((1, 2), repeat=2))
    worlds = tuple((value, program, phase) for program in programs
                   for value in range(5) for phase in range(sum(program)+1))
    def step(w):
        value, program, phase = w
        return ((value+1) % 5, program, phase+1) if phase < sum(program) else (value, program, 0)
    def inverse(w):
        value, program, phase = w
        return ((value-1) % 5, program, phase-1) if phase else (value, program, sum(program))
    assert len(worlds) == 80 and len({step(w) for w in worlds}) == 80
    assert all(inverse(step(w)) == w and step(inverse(w)) == w for w in worlds)
    for program in programs:
        for initial in range(5):
            w = initial, program, 0
            for _ in range(sum(program)):
                w = step(w)
            assert w == ((initial+sum(program)) % 5, program, sum(program))
    assert reach((1,), 2, lambda a, b: (a+b) % 5, 0) == {0, 1, 2}
    assert reach((1, 2), 2, lambda a, b: (a+b) % 5, 0) == set(range(5))
    return len(worlds)


def markdown(r):
    return f'''# A finite word budget is not an idempotent closure

B2 defines depth as the number of factors, not binary-tree height. Write
Cl_d(A) for products of at most d elements, including the empty identity.
In any monoid, Cl_d(Cl_e(A))=Cl_(de)(A): flatten blocks in one direction,
and split a word of length at most de into at most d blocks of length at
most e in the other. A binary-height convention would be a different budget.

For the ordered sieve with e≥1, its finite residue A satisfies
A⊆L⊆Cl_e(A). Thus Cl_d(A)⊆Cl_d(L)⊆Cl_(de)(A), and the unbounded
generated monoids agree. The bounded sets need not agree:

| Library | Reach with at most two factors |
|---|---|
| {{a}} | empty, a, aa |
| {{a,aa}} | empty, a, aa, aaa, aaaa |

The two-factor sieve reduces {{a,aa}} to {{a}}, but expanding aaaa takes
four primitive factors. Replacing a library with a generator basis can
preserve all eventual expressivity while reducing reach at a fixed budget.

## A bounded sieve can have infinitely many redundant atoms

Scanning infinitely many distinct library members with fixed finite e
cannot leave a finite final residue: Cl_e(A) would then be finite, yet
would have to contain that whole library. For positive integers under
addition in increasing order, the residue at bound d is exactly
A_d={{1+kd:k≥0}}. Inductively every old atom is 1 modulo d. A sum of
2..d such atoms cannot be 1 modulo d, and a one-factor old atom cannot
be a new integer. Every other integer is an earlier atom plus at most
d−1 copies of 1. Thus every 1 modulo d is retained and the others are
derived. Nevertheless {{1}} generates all nonnegative integers without
a word budget. These atoms reflect the bound, not algebraic irreducibility.

The multiplicative bound-two sieve also retains composite 8: its three
factors 2 cannot fit and 4 was already omitted as derived. This is not
literally the prime sieve. Reachability and cost saving differ as well:
2=1+1 is derived at bound two although its additive cost equals 2.

## A macro changes representation, not a resource convention for free

Expanding a word of macros has exact primitive length equal to the sum of
their definition lengths over all occurrences. Here two macro calls can
expand to four primitive calls. A length-first lexical search for aaaa
tests five candidates over {{a}} and seven over {{a,aa}}, including the
empty word. Shorter solutions do not guarantee fewer search attempts.

A closed {r['whole_states']}-state machine contains value modulo five, the
chosen two-macro program and its internal phase. The native primitive adds
one; X expands to one increment and Y to two. All transitions and inverses
were checked. YY needs two macro factors but four primitive ticks under this
declared implementation. Program and source distinctions survive. A machine
with a native two-step operation or another cost model needs a new account.
This is not an empirical neural-training speedup or a universal energy bound.

Checks: {r['algebra']['monoids']} finite monoids, {r['algebra']['flattening_identities']}
flattening identities, {r['algebra']['sieve_models']} finite sieve models,
{r['residue_prefixes']} additive residue prefixes, {r['macro_expansions']}
macro expansions evaluated also with noncommuting permutations, and 80
complete machine states. Infinite claims have the proofs above.
The pure Swift witness expands two resident two-field definitions into
four ordered primitive fields and retains the definitions. It derives the
four-field terminator and refuses an alleged two-field end. It does not
implement general monoid equality, arbitrary recursive expansion or physical cost.

Learned libraries changing bounded search are already established, for
example [DreamCoder, PLDI 2021, §§1–2](https://people.csail.mit.edu/asolar/papers/EllisWNSMHCST21.pdf).
This result corrects VI's bounded/unbounded inference. It does not claim
library learning or elementary word substitution as a new invention.
'''


def main():
    prefixes, multiplicative = residue_audit()
    result = {'algebra': algebra_audit(), 'residue_prefixes': prefixes,
              'multiplicative_bound2_residue_to16': multiplicative,
              'macro_expansions': macro_audit(), 'whole_states': closed_execution()}
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'bounded_basis.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'bounded_basis.md').write_text(markdown(result))
    assert result == json.loads((root / 'bounded_basis.json').read_text())
    assert markdown(result) == (root / 'bounded_basis.md').read_text()
    print(f"basis: {result}; bounded preservation and critical counterexamples checked")


if __name__ == '__main__':
    main()
