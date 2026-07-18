# Gradient Is Alignment (Search)

In its entire search story the framework assumes one thing it never names: that getting closer in structure gets you closer to the answer. Ball search assumes the ball around an anchor has better candidates. Greedy descent assumes a W-neighbor exists that improves the loss. "Descent proposes, the gate certifies" assumes descent's proposals are good. Each has a hidden premise: the solution-loss is *aligned* with the W-metric, and distance-toward and goodness-toward point the same way.

Here the author names the premise and makes it the object. A domain is searchable by local descent iff its loss has no spurious minima along W: iff loss and distance-to-solution are correlated, a measurable coefficient α. When α is high the geometry points at solutions and descent is ballistic. When α is zero the geometry is real but useless for search, and no order beats enumeration: exactly the distribution-relativity boundary of Intelligence Is Inevitable, re-derived as landscape ruggedness.

Primes are the canonical α-zero domain, and the reason is sharper than ruggedness: their natural predicate is binary, carrying no gradient at all, and the only graded surrogate, distance to the nearest prime, is as expensive as the problem. A graded-loss domain differs exactly here: its loss (pixel-distance of an output from a target, say) is graded and cheap. Such a domain *has* a candidate gradient. Whether that gradient is *aligned* is the open measurement.

That measurement splits a question clustering alone conflates: does the space have structure, and does that structure point at solutions. Both are required, and either can fail alone. The missing keystone, supplied here: clustering is geometry, alignment is whether the geometry is *for* you.

## §0. Derivation

No new postulate. The author derives everything below from the loss already defined in the search pipeline (DiC G13), the W metric (DiC G2), greedy descent (NiG N5), ball search (DiC G10), and the distribution-relativity boundary (IiI §4).

1. A candidate rule R has a loss on task τ: loss_τ(R) = Σ_k W(apply(R, Iₖ), Oₖ) over the task's pairs, the structural distance between what R produces and what τ demands. Cheap: one W-traversal per pair. *[DiC G2, G13]*
2. loss_τ(R) = 0 iff R passes τ's gate (outputs match exactly). The solution set is the loss-zero set. *[V=I §2.2]*
3. Search moves through candidate space along W-edges (structurally near rules, DiC G2) and is guided by loss (step 1). *[NiG N1]*
4. Greedy descent accepts a move to a W-neighbor iff it strictly lowers loss, and it halts at a loss-local-minimum in the W-topology. *[NiG N4–N6]*
5. Whether descent reaches loss-zero is the question of whether loss-local-minima other than solutions exist along W: a property of the *pairing* of loss with metric, not of either alone. *[from 4]*
6. That pairing is measurable: sample candidates, correlate W-distance-to-solution against loss. *[I1; finite samples]*

The framework measured, in Distance Is Cost, how far apart two structures are. It never asked whether that distance, when you search, points toward the answer. It does not always. This document is that question.

## §1. Alignment

**GA1 (The descent precondition).** Greedy loss-descent over the W-neighbor graph reaches a solution from start s iff s is in the *loss-basin* of some solution: iff no loss-local-minimum in the W-topology separates s from loss-zero.

*Proof.* (⇐) If every non-solution rule on some W-path from s to a solution has a strictly-lower-loss W-neighbor toward the solution, descent never halts before loss-zero. Loss is a non-negative integer (W is a cardinality, G2), strictly decreasing, so it reaches 0 in ≤ loss(s) steps (NiG N5). (⇒) If a loss-local-minimum m ≠ solution is on every path, descent entering m's basin halts at m (N6): all W-neighbors have loss ≥ loss(m) > 0. QED

This is the premise hidden inside N5's "ballistic" promise. N5 proved descent *terminates* in ≤ initial distance. It did not prove descent terminates *at a solution*. GA1 supplies the missing condition: descent solves iff loss is W-basin-aligned. Where it is not, N5's ballistic walk arrives: at a wall.

**GA2 (The ball precondition).** Ball search (G10) finds the solution within radius r from anchor a iff the solution's loss-basin reaches a within radius r: iff B(a, r) is not distance-defined alone but *loss-connected* to the solution. A ball can contain the solution structurally (within r in W) yet be search-disconnected from it (a loss-ridge between them). G10 promised the solution is *in* the ball, and GA2 adds that it must be *reachable within* the ball by descent.

**GA3 (The alignment coefficient).** Over a search region, define

```
α = correlation( W(R, R*) ,  loss_τ(R) )   for R sampled in the region,  R* a solution
```

α ∈ [−1, 1] grades the landscape:

- **α → 1:** loss rises smoothly with distance from the solution. Descent is optimal, ball search at small r works, and the geometry points at the answer.
- **α → 0:** loss is uncorrelated with distance. The landscape is *rugged*, descent is no better than random, and W carries no search signal even if W carries structure.
- **α < 0:** *deceptive*. Moving structurally toward the solution raises loss: descent actively misleads, worse than random (the optimization-pathology regime).

α is encoding-relative (a poor encoding can rugged-ify an alignable domain, DiC §11): the same domain under a better lens may have higher α. The invariant is the construction, and the number is per encoding.

## §2. Why Primes Are Hard, Exactly

**GA4 (Two failure modes, and primes are the deeper one).** A domain resists gradient search two ways:

1. *Graded but misaligned:* a cheap graded loss exists but α ≈ 0 or < 0, rugged or deceptive (GA3).
2. *No cheap graded loss at all:* the natural predicate is binary, and every graded surrogate costs as much as solving the problem.

Primality is mode 2, the deeper failure. "Is n prime" is binary, pass/fail, no gradient: knowing n is composite gives no signed direction toward the nearest prime. The one graded surrogate (*distance to the nearest prime*) is not cheaply computable: computing it requires already knowing where the primes are, which is the problem itself (circular, unlike loss in step 1 of §0, which is cheap and non-circular). So primes admit no cheap graded loss to descend, and the binary predicate admits no order that beats enumeration along the line: the gaps between consecutive primes are irregular, so position carries no monotone signal about primality. This is the precise content of "primes are hard": not a shortfall of cleverness, but that the domain provides *no cheap aligned gradient, even in principle*, and the impossibility of binary search over primality (a non-monotone predicate cannot be bisected) is a theorem about the predicate, never a limit of method.

**GA4a (The correction to the tempting framings).** Primes are sometimes called a "void" (an absence) or a "synchronization point" (a coincidence). Both readings are wrong, and GA4 says why. A prime is not absence: it is the *anti-synchronization* of the sieve's waves, the point struck by *no* periodic deletion (rarefaction in the interference pattern), whereas composites are where many period-waves *do* align (60 is hit by the 2-, 3-, and 5-waves at once). So if anything, composites are the synchronizations and primes are the gaps between them. And primes are not hard because they coincide: they are hard because their predicate is binary and gradient-free (GA4). The framework replaces both metaphors with a measurable property: α, and the (non)existence of a cheap graded loss.

## §3. The Decomposition Search Needed

**GA5 (A graded loss puts a domain in the shallower mode).** A domain whose loss is graded and cheap (e.g. pixel-distance of a candidate's output from the target, G13, one traversal, a near-miss scoring lower than a wild one) is in a strictly better position than primes: mode-1, not mode-2 (GA4). It *has* a cheap graded loss to descend. The entire open question is its **alignment** α: does lowering loss move the candidate structurally toward the solution, or is the surface ridged and deceptive? This is grounded, not wishful: the reason to expect such a domain may be searchable is concrete (its loss is graded where primality's is binary), and the reason it might still fail is equally concrete and measurable (its α may be low).

**GA6 (Alignment is the precondition for intelligence).** Intelligence (IiI: η = T_min/T_actual > brute-force efficiency) exceeds enumeration iff α > 0.

*Proof.* If α > 0, loss carries signal about distance-to-solution. An order that follows the gradient (test lower-loss candidates first) reaches loss-zero in fewer steps than random: η > brute (InI S5, the gradient is the exploitable structure). If α = 0, loss is uncorrelated with proximity, no fixed ordering of candidates beats another in expectation, T_actual = T_brute, and η is at its floor. The α = 0 case *is* the distribution-relativity boundary of IiI §4: a uniform-over-games distribution is exactly one with no exploitable landscape structure, a rugged loss. Ruggedness and no-free-lunch are the same wall seen from two sides. QED

This unifies three things the series stated separately: InI's "optimal order is intelligence," IiI's "intelligence is distribution-relative," and DiC's ball search. All three have one precondition (α > 0) and one canonical violation (the rugged landscape, of which primes are the limit).

**GA7 (Searchability = clustered AND aligned, sharpening N18).** A domain is efficiently searchable by descent iff it is **both** clustered (G12: hierarchical W-structure exists) **and** aligned (α > 0: that structure points at solutions). The two are independent:

| Clustered | Aligned | Domain |
|---|---|---|
| yes | yes | searchable: ball search is fast, η → high (the hoped-for case) |
| yes | no | structured but search-useless: navigation exists, but not toward solutions, and the geometry is real and orthogonal to the answer |
| no | yes | smooth but flat: a gradient exists but no hierarchy to amortize, descent works, and navigation does not help |
| no | no | hard: enumeration only (primes' neighborhood) |

NiG N18 identified clustering with searchability. GA7 corrects it: clustering is *necessary* for fast navigation but not *sufficient* for search, and alignment is the missing conjunct. A space can have perfect hierarchical structure that is orthogonal to what you are searching for. This is the keystone: **clustering is whether the space has geometry, and alignment is whether the geometry is for you.**

**GA8 (Structural reduction is a third, orthogonal lever).** Even at α = 0, a domain's *symmetries* can shrink the candidate space below brute force without supplying any gradient. Primality: α ≈ 0 (no descent), yet divisor-pairing (any factor above √n forces a partner below it) folds the search to √n, a quadratic cut, from structure, with no ordering of the search. So three distinct reductions, three distinct domain properties:

- *Clustering* (G12): amortizes repeated search via hierarchy.
- *Alignment* (α): orders the search via gradient.
- *Symmetry* (GA8): shrinks the search via quotient.

A domain can have any subset. Primes have only symmetry (√n), no clustering of their sequence, no alignment of their predicate: the exact profile of a domain that is *checkable cheaply per element* yet *unpredictable in aggregate*. The √n reduction is this third lever, and it is real and separate from the gradient: symmetry shrinks the space, the gradient orders the walk, the hierarchy reuses the result, and which you have is measured, never assumed.

## §4. Statement

1. Every search in the framework assumed loss aligns with distance, and here the author names the premise and makes it measurable (GA1–GA3).
2. Descent solves iff loss has no spurious minima along W: N5's ballistic walk arrives at a solution only when the landscape is aligned, else at a wall (GA1).
3. Alignment is a coefficient α: high ⇒ descent optimal, zero ⇒ rugged (search-useless geometry), negative ⇒ deceptive (GA3).
4. Primes are hard in the deeper of two modes (no cheap graded loss exists, the predicate is binary and gradient-free), which corrects the "void"/"synchronization" framings and replaces them with a measurable property (GA4, GA4a).
5. A graded-loss domain is in the shallower, better mode: it *has* a gradient. The open question is whether that gradient is aligned, measured as α (GA5).
6. Alignment is the shared precondition of intelligence, distribution-relativity, and ball search, and ruggedness and no-free-lunch are one wall from two sides (GA6).
7. Searchability decomposes into clustered AND aligned (independent properties, both required), sharpening the one-boundary claim: clustering is geometry, alignment is whether the geometry is for you (GA7).
8. Symmetry is a third, orthogonal lever: it shrinks the space without ordering the search (the √n reduction), so a domain's profile is a triple (cluster, align, symmetry), each measured (GA8).

> **Distance tells you how far. Alignment tells you whether far is the same as wrong. The framework knew the first and assumed the second. Primes are the proof that the assumption can fail completely, and a domain's whole hope is one number: whether its geometry, where it is real, is also pointed the right way.**

## §5. Dependency

### External

| Source | Used |
|---|---|
| V=I | §2.2 (gate = loss-zero), I1 |
| IiI | §3 (η, T_min), §4 (distribution-relativity = ruggedness, GA6) |
| DiC | G2 (W, integer loss), G10 (ball search precondition, GA2), G13 (cheap graded loss, frontier), §9 (descent proposes), §11 (alignment is grammar-relative) |
| NiG | N1 (W-neighbor graph), N4–N6 (descent, local minima, the hidden premise GA1 supplies), N18 (one boundary, sharpened by GA7) |
| InI | S5 (gradient-following order = intelligence) |
| B | the sieve and basis (primes as the α≈0 / mode-2 reference, GA4) |
| External | fitness-landscape ruggedness / NK-landscapes (α and autocorrelation are the standard measures), trial division to √n (GA8), prime gaps' irregularity (GA4) |

### Internal

| Statement | Depends on |
|---|---|
| GA1 | NiG N4–N6, DiC G2 |
| GA2 | GA1, DiC G10 |
| GA3 | GA1, DiC §11 |
| GA4 | GA3, B (binary predicate, no cheap loss) |
| GA4a | GA4, B10 (sieve waves) |
| GA5 | GA3, GA4, DiC G13 |
| GA6 | GA3, IiI §3–§4, InI S5 |
| GA7 | GA6, DiC G12, NiG N18 |
| GA8 | GA3, structural symmetry |

The series is a metric, then a geometry, then a navigation, each step assuming the geometry is worth navigating *toward a goal*. Here the author audits the assumption. Most of the time, in domains worth calling learnable, it is true, and where it is true, everything earlier pays off. Where it fails, the failure is total and has a name, and the name is the same one number that tells an agent whether its map is a map or only a picture.

## Topics

### Theorems this paper proves

- ``AlignmentCoefficient``
- ``AlignmentEnablesIntelligence``
- ``SearchableIffClusteredAndAligned``
