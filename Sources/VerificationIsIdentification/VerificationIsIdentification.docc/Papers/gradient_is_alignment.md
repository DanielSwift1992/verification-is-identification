# Gradient Is Alignment (Search)

Local loss-descent needs an admissible lower-loss move whenever its policy has not reached a solution (GA1, GA7). Complete ball search has a different contract: a certified target is in a finite candidate region, and the searcher enumerates every admissible candidate with an adequate gate (G10). The metric and a correlation statistic alone do not supply either contract.

On a finite candidate graph, local descent reaches a solution when every non-solution has an admissible move of strictly lower loss and the policy takes such a move (GA7). The coefficient α measures linear correlation between loss and distance to a solution over the sampled region (GA3). GA6 separates this statistic from the descent guarantee: positive correlation can coexist with a spurious minimum, and zero correlation can retain a decodable signal. Its no-free-lunch boundary uses uniform-over-games generation.

Primes are the canonical α-zero domain, and the reason is sharper than ruggedness: their natural predicate is binary, carrying no gradient at all, and the only graded surrogate, distance to the nearest prime, is as expensive as the problem. A graded-loss domain differs exactly here: its loss (pixel-distance of an output from a target, say) is graded and cheap. Such a domain *has* a candidate gradient. Whether that gradient is *aligned* is the open measurement.

Clustering, a decreasing local policy and a certified finite search region have separate premises. For descent, the relevant question is whether the chosen policy can make progress at each reached non-solution. For complete ball search, the relevant questions are coverage, admissibility and the target gate.

## §0. Derivation

The author uses a declared finite candidate set, its W-neighbor graph and an actual loss from DiC G13. A descent policy and complete enumeration of a G10 region are separate algorithms.

1. Fix a finite admissible rule set F, a fixed task and actual finite outputs for every tested application. G13 defines an integer loss ℓ:F→ℕ from their W-discrepancies. Evaluating those applications is part of its cost.
2. On the declared examples, ℓ(R)=0 exactly when all output equalities pass. Identifying the intended rule additionally needs the candidate-membership and coverage premises of V=I U2.
3. Fix a W-neighbor relation and a policy that chooses a strictly lower-loss admissible neighbor whenever one exists. The policy halts at a vertex with no such neighbor.
4. Integer decrease proves termination in at most ℓ(s) moves. Success requires that the endpoint has zero loss. Existence of a different decreasing path does not determine the policy's choice (GA1).
5. A G10 bound places the target in a finite ball around a certified anchor. Complete admissible enumeration with an adequate gate recovers it without a decreasing-path premise (GA2).
6. Correlation between loss and distance is a separate statistic on a declared sampling region (GA3). A guarantee for an actual descent policy or candidate order requires its own premises (GA1, G10a).

The author distinguishes the cost of checking an output, choosing a local move, producing an order and enumerating a certified region. A supplied metric does not identify those operations with one another.

## §1. Alignment

**GA1 (A descent guarantee concerns the chosen policy).** Fix finite F, a W-neighbor relation, a total integer loss ℓ:F→ℕ and a policy that chooses a strictly lower-loss admissible neighbor whenever one exists and halts otherwise. From a specified start s the policy reaches a solution exactly when its actual trajectory has a zero-loss endpoint. Equivalently, it reaches no positive-loss local minimum. If every positive-loss vertex of F has an admissible lower-loss neighbor, every start succeeds under any such policy.

*Proof.* Each move lowers a nonnegative integer, so at most ℓ(s) moves are possible. At the endpoint there is no lower-loss neighbor. If every positive-loss vertex has such a neighbor, the endpoint has zero loss. Conversely, a reached positive-loss local minimum is a failed endpoint for this policy. The uniform condition is also necessary for success from every start, since a positive-loss local minimum is itself an allowed start. A policy-specific basin can name the successful starts, but then its membership must concern this policy, including its tie rule. ∎

**A decreasing path can coexist with a failed greedy choice.** Let N be the empty finite tree, P be ordered pairing, B₀=N, B₁=P(N,N), and T(xyz)=P(Bₓ,P(Bᵧ,B_z)). The internal-address set is {ε,R} together with L when x=1, RL when y=1 and RR when z=1. By G2, W between these trees is the Hamming distance of their three bits. Use F={s=T(000), a=T(100), t=T(110), m=T(001)} and neighbor radius 1. Its graph is m—s—a—t. Supply one input I=N and the entire interpretation table below.

| Rule | E(rule,I) | ℓ(rule)=W(E(rule,I),T(000)) |
|---|---|---:|
| s=T(000) | T(111) | 3 |
| a=T(100) | T(110) | 2 |
| t=T(110) | T(000) | 0 |
| m=T(001) | T(100) | 1 |

The path s→a→t decreases loss as 3→2→0. The policy that chooses the smallest neighbor loss instead chooses s→m, since 1<2. At m its only neighbor is s, of loss 3, so it halts with positive loss. The local minimum m is on no s-to-t path in this graph. Existence of a decreasing path, or absence of a separating minimum, therefore does not guarantee this policy's success. This is a supplied finite interpretation of codes and application, not an implementation in every program grammar. It does not refute N3's routing by W(rule,t), which would choose a from s.

N5's integer-decrease argument proves termination of the corresponding descent. GA7 and N12 state the additional progress obligations for an actual policy. Neither a different successful path nor a correlation coefficient supplies those obligations.

**GA2 (Complete ball search and local descent have different contracts).** Under G10's supplied bound and certified anchor, the target belongs to the stated finite ball. A searcher who completely enumerates its admissible candidates and applies a gate adequate for the intended target finds it. This conclusion does not require a lower-loss path from the anchor. A local descent confined to that ball needs its own policy and progress premises.

The same interpretation gives a concrete G10 instance. Put τ₀=PAIR(I,T(100)) and τ₁=PAIR(I,T(000)). Their unique accepted rules in F are m and t respectively. By G2a, W(τ₀,τ₁)=1, while W(m,t)=3. On the whole declared domain D={τ₀,τ₁}, the bound ω(0)=0 and ω(r)=3 for r>0 satisfies every pair inequality. The certified old anchor (τ₀,m) therefore puts the new target t in B(m,3). The entire admissible intersection F∩B(m,3) is F, so exhaustive enumeration with E(g,I)=T(000) finds t.

Starting at m, strict loss-descent for τ₁ cannot take a first step, since its only neighbor has loss 3>1. Thus complete ball search succeeds in a case with no decreasing path from the anchor. If the searcher enumerates all structural trees in B(m,3), the gate first checks g∈F and only then applies E, whose interpretation is declared on F. The finite table and bound are supplied, and no economy of acquisition, enumeration or loss evaluation is inferred from this example.

**GA3 (The alignment coefficient).** Over a search region, define

```
α = correlation( W(R, R*) ,  loss_τ(R) )   for R sampled in the region,  R* a solution
```

α ∈ [−1, 1] grades the landscape:

- **α → 1:** loss rises smoothly with distance from the solution. Descent is optimal, ball search at small r works, and the geometry points at the answer.
- **α → 0:** loss is uncorrelated with distance. Correlation is a linear, region-averaged read, so α = 0 rules out the correlational signal, never every signal: a loss that permutes distance decodes exactly at zero correlation. The landscape is rugged for descent and for every more-similar-is-nearer order, and whether any signal at all remains is a further question α does not answer.
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

**GA6 (Descent, proposal order and finite-region recovery have separate premises).** GA1 and GA7 require progress by the actual loss-descent policy. The coefficient α in GA3 is a statistic and does not supply that guarantee. The earlier form of this claim, an iff on α > 0, said more than its proof carried, in both directions, and two finite landscapes retire it. One has α = 0.477 and a spurious minimum holding greedy descent from a majority of starts while enumeration succeeds within |F| tests: positive correlation without the basin condition decides nothing about descent. The other has a loss that is a multiplicative permutation of distance: α ≈ 0 with full information at zero correlation, and the order that decodes the loss tests the solution first.

For an actual order of n≥1 candidates, one accepted target per task and one unit per candidate check, G10a gives a separate criterion on the declared task distribution: E[R]<(n+1)/2 improves expected check count relative to a uniformly random permutation. The tie rule is fixed, and search stops at the first accepted candidate. Producing the order and evaluating its loss still have costs. The uniform-over-games boundary of IiI §4 has its own distribution premise. G10 instead needs a target bound, a certified anchor, complete admissible enumeration and an adequate gate. None of these operational contracts can be replaced by existence of a decreasing path or by the value of α alone.

**GA7 (Descent, approximation and reuse have separate premises).** G12 characterizes representative approximation. It does not prove that clustering is necessary for efficient descent. On a finite candidate graph, a supplied loss with a strictly decreasing admissible move from every non-solution, together with a policy that takes such a move, permits descent to a solution. Finiteness excludes an infinite strictly descending path. The work of locating each move and evaluating loss still needs a cost model. GA6 already separates this condition from a correlation coefficient.

Conversely a small metric cover gives neither a descending move nor evidence that its endpoint satisfies the task. G12's shared-reader construction also permits exact reuse without a metric search. Therefore neither “clustered AND aligned” nor a flat-matrix test is a necessary-and-sufficient criterion for all efficient search. These properties can support particular algorithms once their operational premises and costs are supplied.

**GA8 (Structural reduction is a third, orthogonal lever).** Even at α = 0, a domain's *symmetries* can shrink the candidate space below brute force without supplying any gradient. Primality: α ≈ 0 (no descent), yet divisor-pairing (any factor above √n forces a partner below it) folds the search to √n, a quadratic cut, from structure, with no ordering of the search. So three distinct reductions, three distinct domain properties:

- *Representative approximation* (G12): bounds the number of representatives at a specified error. Amortized savings need additional costs and reuse.
- *Descent progress* (GA1, GA7): a supplied policy takes admissible decreasing moves. The coefficient α is a separate statistic.
- *Symmetry* (GA8): shrinks the search via quotient.

A domain can have any subset. Primes have only symmetry (√n), no clustering of their sequence, no alignment of their predicate: the exact profile of a domain that is *checkable cheaply per element* yet *unpredictable in aggregate*. The √n reduction is this third lever, and it is real and separate from the gradient: symmetry shrinks the space, the gradient orders the walk, the hierarchy reuses the result, and which you have is measured, never assumed.

## §4. Statement

1. Local descent and complete search of a certified finite region have different contracts (GA1–GA2).
2. Integer decrease gives termination. Success from a specified start depends on the chosen policy reaching zero loss. A supplied lower-loss move at every positive-loss vertex guarantees success from every start (GA1, GA7).
3. Alignment is a coefficient α: high ⇒ descent favoured, zero ⇒ no correlational signal, with a decodable one still possible, negative ⇒ deceptive (GA3).
4. Primes are hard in the deeper of two modes (no cheap graded loss exists, the predicate is binary and gradient-free), which corrects the "void"/"synchronization" framings and replaces them with a measurable property (GA4, GA4a).
5. A graded-loss domain is in the shallower, better mode: it *has* a gradient. The open question is whether that gradient is aligned, measured as α (GA5).
6. Descent progress, candidate-order rank, a distribution-relative bound and complete ball recovery have separate premises. A correlation coefficient does not replace them (GA6).
7. Descent, approximation and exact reuse require different contracts and cannot be classified by one clustering test (GA7).
8. Symmetry is a third, orthogonal lever: it shrinks the space without ordering the search (the √n reduction), so a domain's profile is a triple (cluster, align, symmetry), each measured (GA8).

> **A distance measures a declared discrepancy. Successful descent also needs progress by the chosen policy. Complete ball search needs coverage, admissible enumeration and an adequate gate. A correlation coefficient alone supplies none of those guarantees.**

## §5. Dependency

### External

| Source | Used |
|---|---|
| V=I | §2.2 (gate = loss-zero), I1 |
| IiI | §3 (η, T_min), §4 (distribution-relativity = ruggedness, GA6) |
| DiC | G2 (W, integer loss), G8/G10 (finite target region and complete recovery, GA2), G10a (actual order and rank), G13 (loss from actual outputs), §9 (descent proposes), §11 (alignment is grammar-relative) |
| NiG | N1 (W-neighbor graph), N4–N6 (descent and local minima), N12 (actual routing access), N18 (distinct metric contracts) |
| InI | S5 (gradient-following order = intelligence) |
| B | the sieve and basis (primes as the α≈0 / mode-2 reference, GA4) |
| External | fitness-landscape ruggedness / NK-landscapes (α and autocorrelation are the standard measures), trial division to √n (GA8), prime gaps' irregularity (GA4) |

### Internal

| Statement | Depends on |
|---|---|
| GA1 | finite F, actual integer loss and policy, NiG N5/N12, DiC G2/G13 |
| GA2 | DiC G2a/G8/G10, declared interpretation and admissibility gate |
| GA3 | GA1, DiC §11 |
| GA4 | GA3, B (binary predicate, no cheap loss) |
| GA4a | GA4, B10 (sieve waves) |
| GA5 | GA3, GA4, DiC G13 |
| GA6 | GA1/GA3, DiC G10/G10a, IiI §4, InI S5 |
| GA7 | GA6, DiC G12, NiG N18 |
| GA8 | GA3, structural symmetry |

A decreasing path can establish the possibility of a route, while the declared policy can still choose a failed branch. Complete search can recover a target in a certified finite region even when local descent cannot move. The author keeps the policy, coverage, gate and cost premises separate so each resulting guarantee has its stated scope.

## Topics

### Related type declarations

- ``AlignmentCoefficient``
- ``AlignmentEnablesIntelligence``
- ``SearchableIffClusteredAndAligned``
