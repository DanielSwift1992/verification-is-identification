# A finite word budget is not an idempotent closure

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
| {a} | empty, a, aa |
| {a,aa} | empty, a, aa, aaa, aaaa |

The two-factor sieve reduces {a,aa} to {a}, but expanding aaaa takes
four primitive factors. Replacing a library with a generator basis can
preserve all eventual expressivity while reducing reach at a fixed budget.

## A bounded sieve can have infinitely many redundant atoms

Scanning infinitely many distinct library members with fixed finite e
cannot leave a finite final residue: Cl_e(A) would then be finite, yet
would have to contain that whole library. For positive integers under
addition in increasing order, the residue at bound d is exactly
A_d={1+kd:k≥0}. Inductively every old atom is 1 modulo d. A sum of
2..d such atoms cannot be 1 modulo d, and a one-factor old atom cannot
be a new integer. Every other integer is an earlier atom plus at most
d−1 copies of 1. Thus every 1 modulo d is retained and the others are
derived. Nevertheless {1} generates all nonnegative integers without
a word budget. These atoms reflect the bound, not algebraic irreducibility.

The multiplicative bound-two sieve also retains composite 8: its three
factors 2 cannot fit and 4 was already omitted as derived. This is not
literally the prime sieve. Reachability and cost saving differ as well:
2=1+1 is derived at bound two although its additive cost equals 2.

## A macro changes representation, not a resource convention for free

Expanding a word of macros has exact primitive length equal to the sum of
their definition lengths over all occurrences. Here two macro calls can
expand to four primitive calls. A length-first lexical search for aaaa
tests five candidates over {a} and seven over {a,aa}, including the
empty word. Shorter solutions do not guarantee fewer search attempts.

A closed 80-state machine contains value modulo five, the
chosen two-macro program and its internal phase. The native primitive adds
one; X expands to one increment and Y to two. All transitions and inverses
were checked. YY needs two macro factors but four primitive ticks under this
declared implementation. Program and source distinctions survive. A machine
with a native two-step operation or another cost model needs a new account.
This is not an empirical neural-training speedup or a universal energy bound.

Checks: 13 finite monoids, 1536
flattening identities, 288 finite sieve models,
80 additive residue prefixes, 735
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
