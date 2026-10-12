# Basis Is Residue (Basis)

A library can contain both necessary generators and useful composite macros. Removing every derivable entry can preserve eventual expressive power while reducing what a learner reaches within a fixed composition budget. The ordered sieve below computes a bounded residue. That residue is not in general a minimal algebraic basis, a collection of cost-saving primitives, or a certificate of finite total learning cost.

The distinction matters inside one closed Ω. A macro definition, its stored name, the expanded operations and the controller that executes them must be accounted for within the whole. Changing the level of description can change a search budget without adding information about an unknown law.

## §0. Declared model

Choose an ambient monoid M, an effective representation, a finite ordered library L, and a positive integer word budget e. Membership tests require an exact equality procedure on the represented products. Finite full truth tables or a sound equivalence proof can supply it. Finitely many candidate programs alone do not make arbitrary semantic equality decidable. A task PASS supplies equivalence only under that task's separation premises.

Every finite run below terminates when product evaluation and equality terminate. An infinite library additionally needs an effective presentation. Each finite expression can coexist with an infinite generated domain.

## §1. The composition sieve

**B1 (Composition needs a common interpretation).** Total endofunctions on one domain form a monoid under composition, with identity. A particular certified library is a subset, not necessarily closed under composition or containing identity. Compiling a composite faithfully and certifying its meaning require the stated representation and evaluation premises. The protocol `RulesCompose` intersects existing axes but supplies no concrete composition operator, identity or general equivalence procedure. A local certificate can be reused only on inputs covered by its proof. Precomposition may leave that domain even when every component is reversible. Verdict VC35 computes the reachable input scope required by a declared context family. A training agreement does not supply that scope by itself.

**B2 (Bounded products).** Define Cl_d(A) as products of at most d elements of A, with repetition and the empty product as identity. Here d counts factors, as in the original definition. It is not binary-tree height. For finite A, at most Σ_(j=0)^d |A|^j words are enumerated, although distinct words can denote the same element. Cl_0(A)={identity}. The notation Cl_d names bounded reach, not an idempotent closure operator.

**B3 (Ordered bounded sieve).** Process L in a declared total order, for example norm followed by a fixed tie-break. Maintain A initially empty:

```
for R in L:
    if R is in Cl_e(A): mark R DERIVED and retain a factorization witness
    else:              add R to A and mark it RESIDUE
return A
```

The test uses earlier residue entries. Equal-norm earlier entries are not strictly smaller in norm. If strict norm is intended, it requires a separate filter. The labels state bounded reachability relative to this run. They are not automatically proofs of cost irreducibility or primality.

## §2. Reachability and cost

**B4 (Residue is a failure of bounded representation).** Before R is processed, it is residue exactly when no word of length at most e over the current A equals R. Given positive finite atom costs, the corresponding minimum summed word cost is infinity when no such word exists.

This is different from asking whether a representation is strictly cheaper than R's own cost. Under addition and cost(n)=n, 2=1+1 is derived at e=2, yet its cost equals 2. Thus equality of compositional and intrinsic cost does not characterize B3's residue.

**B5 (Two cost conventions must be stated).** A declared intrinsic cost and the minimum cost of a bounded representation can be compared after fixing the candidate set, word budget and per-atom costs. A cost-aware sieve would use that comparison as an additional test. B3 does not. The existing `AtomBasis` protocol pins `CompositionalNorm == Distance` and inherits a finite-basis axis. That type equality alone computes neither the sieve residue nor a minimum generator set.

## §3. What the residue preserves

**B6 (Unbounded generation and bounded expansion).** For B3 with e≥1, its final residue satisfies A⊆L⊆Cl_e(A). Consequently, for every d≥0,

    Cl_d(A) ⊆ Cl_d(L) ⊆ Cl_(de)(A),
    Cl_infinity(A) = Cl_infinity(L).

*Proof.* A is selected from L. Every omitted member had an at-most-e-factor witness over a subset of the final A, and every selected member has its one-factor representation. Replacing each occurrence of an L-member by its witness multiplies the uniform factor bound by e. Conversely A⊆L preserves every A-word. Taking the union over all finite budgets gives equality of the unbounded generated monoids. QED

More exactly, Cl_d(Cl_e(A))=Cl_(de)(A) in any monoid. Flatten at most d blocks of at most e factors for one inclusion. Split any word of length at most de into at most d blocks of at most e factors for the other. If d or e is zero, both sides contain only identity. Associativity justifies flattening, and identity supplies the empty word. A tree-height convention would be a different cost model and cannot replace B2 silently.

*Counterexample to the earlier equality.* In the free monoid on a, let L={a,aa} and e=2. B3 retains A={a}. But Cl_2(A)={empty,a,aa}, whereas Cl_2(L) also contains aaa and aaaa. The missing products appear in Cl_4(A). Thus the earlier claim Cl_e(A)=Cl_e(L) was false. The same counterexample occurs among reversible increments modulo five: a is +1, aa is +2.

**B7 (A generator count is not a total execution budget).** Certifying a specified finite generator set and a sound composition rule can justify many derived expressions. This does not mean that evaluating, constructing, searching for or storing all those expressions costs nothing. Replacing a macro word by definitions gives exact primitive length Σ_j length(def_j), counting every occurrence. A uniform per-definition bound e gives de.

In an increment-only instruction basis, expansion of two two-increment macros contains four primitive increments. This cost follows from the declared primitive word. A different native basis gives a different resource account.

Shorter descriptions do not automatically reduce search attempts. To find aaaa, length-first lexical enumeration tests five words over {a}, including the empty word, and seven over {a,aa}. Yet at a two-factor bound only the larger library reaches the target. Bounded reach, branching, execution and stored definition size are separate costs.

**B8 (A fixed finite word bound cannot yield finite residue on infinite L).** Suppose B3 processes infinitely many distinct elements with fixed finite e≥1. Its accumulated residue must be infinite. If the final A were finite, Cl_e(A) would be finite but would have to contain every processed element by B6, a contradiction. This remains true when the unbounded domain has a one-element generating set. Therefore finite bounded-sieve residue is not a criterion for finite algebraic generation of an infinite domain.

For positive integers under addition, increasing order and word bound d≥1, the residue is exactly A_d={1+kd:k≥0}. Inductively earlier atoms are 1 modulo d. A sum of 2,…,d of them cannot be 1 modulo d, and one earlier atom cannot equal a new integer. Every other n is an earlier atom plus at most d−1 copies of 1. Thus the residue is infinite, while {1} generates every nonnegative integer with no word bound. The explicit formula also shows that a trajectory-defined residue need not be hard to predict.

**B8a (The prime analogy needs a different test).** Under multiplication, a prime cannot be made from smaller positive nonunit factors. But B3 with bound two also retains composite 8: 4 was omitted as 2×2, and expressing 8 using the retained primes requires three factors. This bounded test is not literally Eratosthenes. The usual multiplicative monoid of positive integers has no finite generating set, since each prime requires a generator containing that prime factor. That algebraic fact is separate from B3.

**B8b (Algebraic generation and bounded residue are different classifications).** For a specified generating set G with M=Cl_infinity(G), one can classify finite G with finite M, finite G with infinite M, or infinite G. An infinite set of distinct generators forces infinite M. To classify whether a monoid is finitely generated, ask whether some finite G exists, not whether one chosen G is infinite. The HORN label can describe finite algebraic generation with infinite reach, but a fixed-budget sieve does not recover such a finite G from an infinite library. Addition with G={1} demonstrates this difference.

**B8c (Finite description is not completion of infinite work).** A finite set of definitions and a proved composition rule can describe infinitely many consequences. It does not enumerate them in finite time, give a uniform bounded-length representation, or make their evaluation cost zero. Even when all needed generators have appeared in a run, recognizing that no more are needed requires a separate completeness certificate. The earlier finite-cost equivalence and zero marginal execution reading are withdrawn.

**B8d (Exponential reach rate).** With finite counts n(s) at each integer norm, let N(s)=Σ_(j≤s)n(j) and γ=limsup_s ln N(s)/s. A bounded reach has γ=0. An unbounded reach can have zero, finite positive or infinite rate. Zero rate includes polynomial and subexponential growth, not only linear growth. A finite positive rate alone does not imply N(s)~e^(γs), determine subexponential factors, or measure the physical speed of generation. For infinite reach, the cumulative rate equals the rate computed from n(s), with ln0=−∞. Play PP17 supplies the comparison proof and shows why γ leaves normalization and norm moments at the boundary unresolved.

**B8e (Two residue curves).** For a specified generator choice, count generators and reachable behavioral classes within each norm bound separately. If both counts remain bounded, the case is CLOSED. A finite atom set with unbounded reach is HORN, and an unbounded atom count is PRIMES, under the stated sieve and composition premises. On an infinite countable reach no uniform probability exists, but nonuniform full-support sampling is well defined. IID sampling visits every class almost surely over an infinite sequence, without completing all visits at any finite time (Play PP5c). Discount weights normalize for λ>γ, fail for λ<γ, and require a separate boundary test at λ=γ (PP17). An enumeration is one presentation policy, not a necessity of measurability. These rate statements do not identify a bounded sieve residue with a finite algebraic generating set (B8).

**B8f (Only unbounded generated closure is idempotent).** On a fixed ambient monoid, Cl_infinity is the least submonoid containing its input. It is monotone, extensive and idempotent, and submonoids are closed under intersection. B6 gives the composition law for the bounded family instead. Neither construction identifies its elements with every physical state of Ω.

## §4. The trajectory and the next experiment

**B9 (Residue depends on the run).** B3 depends on the presented library, its order, the word bound, equality and representation. These parameters must accompany any reported atom count. More permitted factors can make a previously unrepresentable object representable, while rerunning the sieve can also change which earlier entries remain available.

**B10 (Finite audit is possible under the declared decision premises).** For finite L and terminating exact evaluation/equality, every candidate has either a factorization witness or a complete finite refusal over the allowed words. This certifies the specified run. It establishes neither an infinite stopping rule nor that predicting this residue is intrinsically as hard as enumerating it.

**B11 (Compression is a separate resource question).** Some residue patterns have short formulas, such as A_d above. Other libraries may be difficult. A complexity claim needs an input family, encoding and cost model, not the fact that a sieve was used. No equivalence with a general prime-distribution question or with the Riemann Hypothesis is established here.

**B12 (What a useful learned library should be tested for).** Measure the reachable answers at a declared word budget, search attempts, primitive execution work and retained definition size. A nonminimal library can be useful because it supplies short names for common compositions. Whether that gain outweighs branching and storage is an experimental question. This is consistent with established library learning, for example [DreamCoder, PLDI 2021, §§1–2](https://people.csail.mit.edu/asolar/papers/EllisWNSMHCST21.pdf), where learned components change tractability within an already expressive base language. No new neural performance result is claimed by this audit.

`TwoMacroExpansion` expands two resident two-field definitions into four primitive fields in pure Swift, retaining their original definitions through `RetainedWhole`. Its four-field terminator follows by substitution. Arbitrary semantic equality and recursive macro termination require their own relations.

## §5. Statement

A bounded residue answers what failed to fit one particular presentation budget. An algebraic generating set answers what can eventually be composed. A useful macro library answers what becomes accessible at acceptable cost. The three can differ even in a one-generator monoid. These differences must survive a change of representation if the theory is to explain the engineering value of compression.

## §6. Dependency

| Claim | Required premises |
|---|---|
| B1–B3 | Ambient composition, effective representation, exact equality, finite run and word budget |
| B4–B5 | Declared candidate set and costs, distinct from membership alone |
| B6 | B3 with e≥1, associative substitution and identity |
| B7 | B6 and the explicitly charged representation or machine |
| B8–B8c | Finite bounded reach versus unbounded generation |
| B8d–B8e | Finite norm bands and Play PP5c/PP17 |
| B8f | Fixed ambient monoid and unbounded closure |
| B9–B11 | Fixed run parameters and a separate complexity model |
| B12 | Declared evaluation tasks and separate resource measurements |

## Topics

### Related type declarations

- ``RulesCompose``
- ``AtomBasis``
- ``AtomnessIsTrajectory``
