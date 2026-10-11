#!/usr/bin/env python3
"""Certificate scope under precomposition and deterministic postcomposition."""
from fractions import Fraction
from itertools import permutations, product
import json
from pathlib import Path
import sys

from closed_information import entropy, equal, mutual, pushed


def compose(after, before):
    return tuple(after[x] for x in before)


def agrees(f, g, domain):
    return all(f[x] == g[x] for x in domain)


def closure(domain, operations):
    reached = set(domain)
    while True:
        expanded = reached | {h[x] for h in operations for x in reached}
        if expanded == reached:
            return reached
        reached = expanded


def context_words(operations, n):
    identity = tuple(range(n))
    words = {identity: ()}
    frontier = [identity]
    while frontier:
        before = frontier.pop()
        for i, h in enumerate(operations):
            after = compose(h, before)
            if after not in words:
                words[after] = words[before] + (i,)
                frontier.append(after)
    return words


def scope_audit():
    n = 3
    functions = tuple(product(range(n), repeat=n))
    domains = tuple(tuple(i for i in range(n) if mask & (1 << i)) for mask in range(1 << n))
    cases = failures = 0
    for domain in domains:
        for h in functions:
            safe_for_all_pairs = True
            for f, g in product(functions, repeat=2):
                cases += 1
                if agrees(f, g, domain):
                    # Applying a common total suffix to equal outputs is safe.
                    assert agrees(compose(h, f), compose(h, g), domain)
                    safe = agrees(compose(f, h), compose(g, h), domain)
                    if not safe:
                        safe_for_all_pairs = False
                        failures += 1
            assert safe_for_all_pairs == all(h[x] in domain for x in domain)
    return {'pair_context_cases': cases, 'unsafe_precompositions': failures,
            'universal_domain_checks': len(domains)*len(functions)}


def reach_audit():
    n = 3
    functions = tuple(product(range(n), repeat=n))
    perms = tuple(permutations(range(n)))
    models = pairs = 0
    for mask in range(1 << len(perms)):
        operations = tuple(p for i, p in enumerate(perms) if mask & (1 << i))
        words = context_words(operations, n)
        for domain_mask in range(1 << n):
            domain = tuple(i for i in range(n) if domain_mask & (1 << i))
            reached = closure(domain, operations)
            assert reached == {h[x] for h in words for x in domain}
            assert set(domain) <= reached
            assert all(h[x] in reached for h in operations for x in reached)
            # Check minimality independently against every closed superset.
            for sup_mask in range(1 << n):
                sup = {i for i in range(n) if sup_mask & (1 << i)}
                if set(domain) <= sup and all(h[x] in sup for h in operations for x in sup):
                    assert reached <= sup
            for f, g in product(functions, repeat=2):
                contextual = all(agrees(compose(f, h), compose(g, h), domain) for h in words)
                assert contextual == agrees(f, g, reached)
                pairs += 1
            models += 1
    return {'reachable_scope_models': models, 'contextual_pair_checks': pairs}


def closed_example():
    f, g, h = (0, 1, 2), (0, 2, 1), (1, 0, 2)
    assert agrees(f, g, (0,)) and compose(f, h)[0] == 1 and compose(g, h)[0] == 2
    assert closure((0,), (g,)) == {0}
    assert closure((0,), (g, h)) == {0, 1, 2}
    words = context_words((g, h), 3)
    separating = next((word, x) for prelude, word in words.items() for x in (0,)
                      if f[prelude[x]] != g[prelude[x]])
    # A complete whole: local value, resident implementation choice, context
    # mode, and phase. All three component operations are permutations.
    worlds = tuple(product(range(3), range(2), range(2), range(3)))
    implementations = (f, g)
    def step(w):
        x, implementation, mode, phase = w
        if phase == 0 and mode:
            x = h[x]
        elif phase == 1:
            x = implementations[implementation][x]
        return x, implementation, mode, (phase+1) % 3
    def inverse(w):
        x, implementation, mode, phase = w
        previous = (phase-1) % 3
        if previous == 0 and mode:
            x = h.index(x)
        elif previous == 1:
            x = implementations[implementation].index(x)
        return x, implementation, mode, previous
    assert len(worlds) == 36 and len({step(w) for w in worlds}) == 36
    assert all(inverse(step(w)) == w and step(inverse(w)) == w for w in worlds)
    answers = []
    for mode in range(2):
        prepared = {(0, implementation, mode, 0): Fraction(1, 2) for implementation in range(2)}
        ready = pushed(pushed(prepared, step), step)
        assert all(w[3] == 2 for w in ready)
        equal(entropy(prepared), 1)
        equal(entropy(ready), 1)
        equal(mutual(ready, lambda w: w[1], lambda w: w[0]), mode)
        answers.append([step(step((0, i, mode, 0)))[0] for i in range(2)])
    assert answers == [[0, 0], [1, 2]]
    return {'whole_states': 36, 'answers_without_context': answers[0],
            'answers_after_context': answers[1],
            'separating_word': list(separating[0]), 'separating_input': separating[1]}


def markdown(r):
    return f'''# A certificate's input scope must survive reuse

Let D be tested inputs and f,g total components. Agreement f|D=g|D
survives any common deterministic postprocessing k: k(f(x))=k(g(x)) on D.
Preprocessing h is different. Agreement implies f(h(x))=g(h(x)) for all
f,g agreeing on D exactly when h(D)⊆D, provided the output alphabet has at
least two values. Sufficiency is substitution. If h sends x∈D outside D,
choose f,g equal on D and different only at that new input for necessity.
This universal criterion can be stronger than what a restricted hypothesis
family needs. It does not demand an independent measurement at every input.

## Context-complete scope

For a family H of admissible preludes, R is the least H-closed set containing
D. It is exactly the union of w(D) over finite H-words, including identity.
Agreement on R is equivalent to safe replacement after every such prelude
from D when the component output itself is observable. A common deterministic
suffix preserves that equality. For replacements at multiple occurrences,
the reachable set must also cover the operations that feed those occurrences.
This is a specified context family, not all possible programming contexts.
Effects, timing or direct access to implementation identity require their
own state and observation axes. The suffix here uses only the equal output.

The result is an application of VI VC15's operational equivalence. Enlarging
H can enlarge R and require a stronger certificate. The old certificate
still proves its original statement. This does not refute a valid global
R4 identification; it forbids silently promoting sample agreement to one.

## Fully reversible counterexample

On {{0,1,2}}, f=identity, g swaps 1 and 2, h swaps 0 and 1.
Both components answer 0 at tested input 0. After h, f answers 1 and g 2.
With H={{g}}, the reachable scope is {{0}}. Adding h expands it to all three
inputs. Every map used in this counterexample is a permutation.

The complete whole has {r['closed']['whole_states']} states: local value,
resident implementation choice, context mode and internal phase 0…2.
The first phase optionally applies h, the second applies the chosen f/g,
the third wraps the phase. Its inverse and all states are checked.
With the implementation choice uniform and local value prepared at zero,
both modes preserve one bit of whole entropy. Without h, the ready local
value carries zero bits about the implementation. With h, it carries one.
The distinction was internal all along, and a changed experiment reveals it.
The ready phase is an explicit finite window. No physical energy or hardware
implementation theorem is inferred from these tables.

Checks: {r['scope']['pair_context_cases']} function-pair/prelude cases,
{r['scope']['universal_domain_checks']} exact domain-invariance criteria,
{r['scope']['unsafe_precompositions']} sample-agreeing failures,
{r['reach']['reachable_scope_models']} context/reachable-scope models and
{r['reach']['contextual_pair_checks']} contextual-agreement pairs.
State reachability, function-composition closure and every closed superset
are checked independently on the three-state instances.

Pure Swift lifts an existing verdict through one fixed output-pair context,
deriving the new answer equality. The table witness accepts first-input
agreement and refuses to reuse it as a second-input or whole-table equality.
This is not an arbitrary higher-order context checker or compiler certification.

Prior art: [Software Foundations, behavioral equivalence and congruence](https://www.cs.cornell.edu/courses/cs4160/2019sp/terse/plf/Equiv.html).
The congruence requirement is established program semantics. The finite
criterion, VI scope linkage and explicit counterexample are written here.
No new priority for contextual equivalence is claimed.
'''


def main():
    result = {'scope': scope_audit(), 'reach': reach_audit(), 'closed': closed_example()}
    root = Path(__file__).parent / 'Reports'
    if '--write' in sys.argv:
        (root / 'context_reuse.json').write_text(json.dumps(result, indent=2) + '\n')
        (root / 'context_reuse.md').write_text(markdown(result))
    assert result == json.loads((root / 'context_reuse.json').read_text())
    assert markdown(result) == (root / 'context_reuse.md').read_text()
    print(f"context: {result['scope']}; {result['reach']}; 36 reversible whole states and certificate-scope reports agree")


if __name__ == '__main__':
    main()
