# Order Is Object (Strategy)

V=I proves the agent's sole degree of freedom is the order of comparisons. Interference Is Intelligence proves this order carries zero new bits at its own level — phase, not amplitude. Intelligence Is Inevitable records the consequence as a caveat: knowledge inherits I3, but the agent's strategy state does not — it is mutable and resets between runs.

This document removes the caveat by changing its level. A strategy over a finite domain is a finite decision tree, a finite decision tree is a structure in Σ, and structures in Σ can be targets of V=I games. So strategies can be verified, identified, certified, and crystallized: they enter the library as permanent objects, carrying the metric, the balls, and the navigation of the later papers with them. The ordering that is phase at level N is amplitude at level N+1.

The completed library entry becomes a triple — rule, encoding, strategy: WHAT the answer is, THROUGH WHICH lens, and HOW to reach it fastest. The path itself, not merely its endpoint, becomes a certified object, the top rung of the objectification ladder, and "skill" acquires a formal definition: a ball in strategy space.

## §0. Derivation

No new postulate. Everything below is derived from V=I §2 and §5.25, the Saturation Theorem (IiI §3), the W metric (DiC G2), and the navigation stack (NiG N1–N19).

1. For a fixed encoding, the agent's sole free parameter is the order of COMPAREs. *[V=I §5.25]*
2. The order carries zero identification bits at its own level. *[InI S2]*
3. An order-choosing rule over a finite domain is a function from observation histories to next-COMPARE choices. Histories are bounded (≤ N² COMPAREs, V=I Theorem 3); observations are finite (I1). The function is a finite decision tree.
4. Finite decision trees encode into Σ: branches are PAIRs, labels are Peano numerals, leaves terminate at NULL. *[V=I §2.1, §4.1]*
5. Therefore strategies have a norm ‖σ‖ and pairwise distances W(σ, σ′). *[DiC G1a, G2]*
6. cost(σ, τ) — the number of COMPAREs the pipeline performs under σ before |S| ≤ 1 — is computable: the pipeline is total, each step decidable, the count finite. *[V=I §5.5; I1, I2]*
7. A bounded-cost predicate over computable costs is a gate. A gate over a finite candidate space is a V=I game. *[V=I §3.7]*
8. Multiple strategies may pass; uniqueness is recovered by the selection-criterion move: argmin over (cost, then norm, then lexicographic order) — a total order on a finite set. *[V=I §3.7]*
9. The certified σ\* enters the library and inherits I3: permanent, irreducible, resistant. *[I3; PiR §2]*
10. The strategy library is a finite set of structures in Σ with a computable W-matrix: the ball cover (G11), the compression criterion (G12), and the navigation theorems (N1–N19) apply by substitution.

The series asked three questions of COMPARE: whether (Z), where (X), and in what order (Y). The first two were objectified from the start — facts in G, addresses in diagnostics. This document objectifies the third.

## §1. Encoding

**O1 (Strategy).** A strategy for encoding E over domain D is a function σ : observation histories → next COMPARE choice. Two regimes:

- *Non-adaptive*: σ ignores observed values — a fixed sequence of features. A list in Σ.
- *Adaptive*: σ branches on observed values — a decision tree. Internal nodes are (feature index, observed value) pairs; children are the continuations.

Non-adaptive strategies are the degenerate (unbranched) case of adaptive ones. Both are finite objects: depth ≤ N² (V=I Theorem 3: all pairs classified), branching bounded by the finite observation alphabet (I1).

**O2 (Strategies live in Σ).** Every strategy of O1 encodes as a finite binary tree: feature indices as Peano numerals (V=I §4.1), branch structure as PAIR nesting, termination at NULL. Therefore:

- ‖σ‖ is defined (DiC G1a): the strategy's maintenance cost. Simpler strategies are literally cheaper to exist.
- W(σ₁, σ₂) is defined (DiC G2): the re-formation work between strategies, computable by one traversal (G2a).

Strategy geometry is not constructed; it is inherited the moment strategies are admitted into Σ.

**O3 (Finiteness).** For fixed encoding, feature set, and depth bound d ≤ N², the strategy space Π_d is finite.

*Proof.* Finitely many features, finitely many observable values (I1), bounded depth: the number of distinct decision trees is a finite (if large) combinatorial count. QED

*Remark (the count is hostile).* |Π_d| grows doubly exponentially in d. O3 guarantees legality, not affordability. §7 restores affordability by the same move the framework always makes: the agent supplies a restricted grammar.

## §2. Verification

**O4 (Cost is computable).** cost(σ, τ) = the number of COMPAREs executed when the inner pipeline's order is dictated by σ on task τ, until |S| ≤ 1 or σ is exhausted. Computable: the pipeline is total (V=I §5.5), σ is a finite tree, each step is decidable (I2), the run is deterministic given (σ, τ).

**O5 (The strategy gate).** For a rule class k with task set {τ₁, ..., τ_m} ⊆ k and budget c:

```
GATE_σ(σ, k, c) :  for every τᵢ —  result(σ, τᵢ) = PASS  ∧  cost(σ, τᵢ) ≤ c
```

Decidable: a finite conjunction of computable checks (O4). REJECT carries the address: which task, at which step the budget broke, which feature the strategy chose there — the same diagnostic discipline as V=I §1, one level up.

**O6 (Layered soundness).** A strategy only reorders COMPAREs; correctness is order-invariant (V=I §5.25, Theorem 2). Therefore no strategy — certified, uncertified, or adversarial — can produce a wrong PASS. The strategy gate certifies efficiency claims ON TOP OF unconditional safety. Two gates, two guarantees: the inner gate answers "is it right"; the strategy gate answers "is it fast." A failed strategy costs budget, never correctness.

**O7 (The minimal budget is computable).** GATE_σ is monotone in c (a strategy passing at c passes at c′ ≥ c). The minimal budget c\*_k = min{c : ∃σ ∈ Π_d, GATE_σ(σ, k, c)} is computable by binary search over c ∈ [1, N²], each probe a finite check (O5).

## §3. Identification

**O8 (Uniqueness by minimality).** Let S_σ = {σ ∈ Π_d : GATE_σ(σ, k, c\*_k)}. In general |S_σ| > 1. Apply the selection-criterion move (V=I §3.7): refine by argmin over the lexicographic triple

```
( max cost over k,   ‖σ‖,   structural order on Σ )
```

A total order on a finite set has a unique minimum: σ\*_k. R4 holds for the refined relation by construction; Theorem 2 applies to it. The certified strategy is the cheapest of the fastest — minimal worst-case cost, then minimal existence cost, then canonical.

**O9 (Strategies inherit I3 — as objects).** σ\*_k enters the strategy library L_σ. Entries are never removed (I3; PiR M21). The IiI §2 caveat is now resolved at its correct level: strategy *state* at level N is mutable scaffolding; strategy *objects* at level N+1 are permanent, irreducible (the unique minimum of O8), and resistant (the next agent encounters σ\*_k as a fixed target). The caveat was true and is untouched; it was a statement about the wrong level.

**O10 (Phase becomes amplitude).** At level N the ordering contributes zero identification bits (InI S2): Y-axis, pure phase. At level N+1 the ordering is the entire identified content: the strategy game's target is σ\*, and every gate check yields bits about which strategy survives. The Y-axis of level N is the Z-axis of level N+1. What steering was to the journey, the journey is to the map.

**O11 (The witness of cert).** InI S5b defines cert(τ) — the smallest feature set identifying τ — as the optimal trajectory length, existentially. σ\*_k is its constructive carrier: a stored, certified, permanent object whose execution realizes the class budget c\*_k. Honestly bounded: c\*_k = min over σ of max over τ ∈ k of cost(σ, τ) ≥ max over τ ∈ k of cert(τ). The gap between the class budget and the per-target cert is the price of one strategy serving a whole class — measurable per class, zero when the class is strategy-homogeneous.

## §4. Crystallization

**O12 (The complete entry).** After rule saturation (IiI §3) and strategy saturation (O14), a library entry is a triple:

```
( f*,  E,  σ* )  —  WHAT the answer is,  THROUGH WHICH lens,  HOW to reach it fastest
```

Theorem 2 certifies the first; the agent supplies and R4 validates the second; this document certifies the third. The object now contains its own path. The question that opened the series' applications — can a path be turned into an object — closes here: not only the path's endpoint (Verification Is Identification), not only the path's deposits (Intelligence Is Inevitable and Permanence Is Resistance), not only the path's infrastructure (Navigation Is Geometry), but the path itself, as an executable, certified, permanent structure.

**O13 (Strategy saturation).** Strategy classes over a finite domain are finite: at most one σ\* per rule class (O8), K rule classes (IiI §3). The Saturation Theorem applies verbatim with (tasks → strategy games, rules → strategies): after finitely many certified strategy games, L_σ covers every class; expected games to coverage = coupon collector over K_σ ≤ K (IiI §6). Post-saturation protocol: a new task first routes to L_σ — execute the stored σ\* for its class, pay c\*_k, done. The meta-level answers before the base level searches.

## §5. Strategy Geometry

**O14 (Strategy modulus).** Define ω_σ as the modulus of the map k ↦ σ\*_k: W(σ\*_k, σ\*_{k′}) ≤ ω_σ(W(k, k′)) — nearby rule classes have nearby optimal strategies. Measurable over L_σ: finitely many W-computations (DiC G2a), exactly as the rule modulus (G10). Not guaranteed by I1–I3 — same status, same honesty.

**O15 (Skills are balls).** If ω_σ exists and the strategy W-matrix clusters (G12 applied to L_σ), then a *skill* is formally a ball B(σ_anchor, r) in strategy space: one strategy family covering many rule classes, with per-class adjustment bounded by r. Skills exist exactly to the extent that strategy space is metrically compressible. A domain whose strategy matrix is flat has no skills — every class demands its own bespoke order, and the meta-level is pure memoization (the fourth face of the one boundary, O18).

**O16 (Strategy navigation).** L_σ under W forms an anchor graph Γ(L_σ, ρ). All of NiG N1–N19 apply by substitution: connectivity threshold, navigability threshold, monotonicity, ballistic descent, holes with addresses, permanent repair, inevitability under population. A new task class routes greedily through strategy space to its nearest certified skill, executes, and on gate failure emits an addressed hole — naming the missing skill. The router's failures are the skill curriculum (N17, one level up).

**O17 (The objectification ladder).** Path-to-object conversion is a ladder of six rungs, each conditional on more geometric structure, each condition decidable or measurable:

| Rung | Object | Condition | Source |
|---|---|---|---|
| 1 | Trace recorded | none — unconditional | I3 |
| 2 | Endpoint certified (f\*) | finite deterministic task | Thm 2, Thm 4 |
| 3 | Object transfers | rule classes repeat (K finite) | IiI §3 |
| 4 | Object generalizes (ball) | modulus ω exists | G10–G11 |
| 5 | Objects route (graph) | library clusters | NiG N11, N18 |
| 6 | The path itself certified (σ\*) | strategy grammar affordable (§7) | this document |

Rungs 3–6 stand on the same boundary: compressibility of the domain's geometry, at the rule level and at the strategy level. The ladder is the series' answer to "is path→object universal": the mechanism always runs; the height reached is a measurable property of the domain.

**O18 (One boundary, fourth face).** NiG N18 identified learning, generalization, and navigation as one boundary. Strategy compressibility is its fourth face: a flat strategy matrix means nothing transfers between classes at the HOW level even when everything transfers at the WHAT level. The converse composes: a domain that clusters at both levels yields skills that route — the agent navigates strategy space to select HOW, then navigates rule space to select WHAT, each in logarithmic hops (N12, twice).

## §6. The Tower of Orders

**O19 (Level invariance).** Strategy games at level N+1 are themselves run in some order; that order is the Y-axis of level N+1, carries zero bits there (InI S2 applies — its proof references only COMPARE's properties), and is objectifiable at level N+2 by the construction of this document, verbatim (O1–O9 reference only finiteness, decidability, and Σ-encodability — all level-invariant, mirror of InI S8a). The tower of orders climbs by the same criterion as the tower of rules: it terminates at the first level whose strategy matrix is metrically uniform (G12 applied to L_σ at that level). Phase becomes amplitude at every level, until there is no phase left to lift.

## §7. Affordability

**O20 (Restricted strategy grammars).** |Π_d| is doubly exponential (O3 remark); exhaustive strategy search is legal and unaffordable. The framework's standard move applies: the agent supplies a strategy grammar Π_R ⊂ Π_d, and all guarantees hold relative to Π_R (exactly as encodings: V=I §1 — the agent's grammar bounds the reachable, never the correct). Three grammars with known properties:

1. *Greedy family*: always test the max-entropy feature over the current S_k. One parameter (the entropy estimator). Achieves η → 1 when balanced features exist (InI S5). Certification cost: linear in features per probe.
2. *Anchor-edit family*: strategies within W-radius r of an existing σ\* ∈ L_σ — ball search in strategy space (G10 applied via O14). Cost: |B(σ\*, r)| probes (finite, G8).
3. *Trajectory replay*: the sequence of COMPAREs that solved a class instance, read from G (the trace is already there, I3), pruned of redundant steps (InI S3a detects them). Cost: one pass over the recorded episode. This is rung 1 lifted to rung 6 directly: the cheapest strategy candidate is the remembered path itself.

**O21 (Amortization).** Certifying σ\*_k costs C_cert(Π_R) once; it saves (T_random − c\*_k) COMPAREs on every future instance of class k. Crossover after C_cert / (T_random − c\*_k) instances — finite, computable in advance, the strategy-level twin of NiG N13. Post-crossover, the meta-level is pure profit; the profit compounds with task frequency p_k, so the optimal certification order is by descending p_k × (T_random − c\*_k) — the curriculum is computable too.

## §8. Boundaries

**Affordability is grammar-relative.** O20's guarantees are relative to Π_R; the optimal strategy in Π_d \ Π_R is invisible — same status as encodings outside E (IiI §4: the permanent boundary is the grammar).

**The class–target gap.** σ\*_k optimizes the class worst case; a per-target shortcut (InI S5b(c)) may beat it on individual tasks. The gap is measurable (O11); closing it per-target reintroduces per-target storage — the memoization trade, now visible as a number.

**ω_σ is not guaranteed.** O14–O16 are conditional on measurable properties, in the standing of G10–G12 and N11. The degenerate cases are exact: flat strategy matrix = no skills = per-class memoization.

**Stochastic environments are out of scope.** cost(σ, τ) presumes deterministic execution (I2). Moving or noisy targets break the strategy gate as they break the rule gate — the subject of the next document (law identification restores I2 at the level of dynamics).


## §9. Statement

1. A strategy is a finite decision tree; finite decision trees live in Σ; therefore strategies have norms, distances, and can be targets (O1–O3).
2. Strategy cost is computable, the strategy gate is decidable, and no strategy can corrupt correctness — efficiency certification layers on top of unconditional safety (O4–O6).
3. The minimal budget and the unique cheapest-fastest strategy are computable; σ\* is the constructive witness of certificate complexity (O7–O8, O11).
4. Certified strategies inherit I3: the mutable-strategy caveat of Intelligence Is Inevitable was a statement about the wrong level (O9).
5. Phase becomes amplitude: the Y-axis of level N is the Z-axis of level N+1, at every level, until no phase remains (O10, O19).
6. The library entry completes into (f\*, E, σ\*): the object contains its own path. The objectification ladder reaches its top rung, and its height is a measurable property of the domain (O12, O17).
7. Strategy space carries the full geometric stack: modulus, balls, navigation. Skills are balls; skills exist exactly where strategy space compresses — the fourth face of the one boundary (O14–O16, O18).
8. Affordability is restored by restricted grammars, the cheapest of which is the remembered path itself; certification amortizes by a computable crossover, in a computable order (O20–O21).

> **The order was never information at its own level — that was the point. One level up, it is the only information there is. The path, certified, is an object; objects, accumulated, are skills; skills, clustered, are navigable. Phase becomes amplitude, level after level, and I3 holds at every one.**

## §10. Dependency

### External

| Source | Used |
|---|---|
| V=I | §1 (agent supplies grammar), §2.1 (Σ), §3.7 (selection criterion), §4.1 (Peano), §5.5 (totality), §5.25 (order sole variable; order-invariant correctness), Theorems 2–4 |
| IiI | §2 (strategy-state caveat — resolved by O9), §3 (Saturation Theorem; K), §4 (grammar boundary), §6 (coupon collector) |
| PiR | §2 (three properties of crystal), M21 (no deletion) |
| DiC | G1a (norm), G2/G2a (W, one traversal), G8 (finite balls), G10 (modulus, ball search), G11–G12 (cover, compression) |
| InI | S2 (Y carries zero bits), S3a (redundancy detection), S5 (greedy achieves η → 1), S5b (cert), S8a (level invariance) |
| NiG | N1–N19 (applied to L_σ by substitution), N13 (amortization), N17 (failure curriculum), N18 (one boundary) |

### Internal

| Statement | Depends on |
|---|---|
| O1–O3 | V=I §2.1, §4.1, Theorem 3; I1 |
| O4–O6 | O1; V=I §5.5, §5.25, Theorem 2; I2 |
| O7 | O5 (monotone gate); I1 |
| O8 | O7; V=I §3.7 |
| O9 | O8; I3; PiR M21 |
| O10 | O8; InI S2 |
| O11 | O8; InI S5b |
| O12 | O8, O9; IiI §3 |
| O13 | O9; IiI §3, §6 |
| O14 | O2; DiC G10 |
| O15 | O14; DiC G12 |
| O16 | O14, O15; NiG N1–N19 |
| O17 | O12; I3; Thm 2/4; IiI §3; G10–G11; NiG N18 |
| O18 | O15; NiG N18 |
| O19 | O1–O9; InI S2, S8a; DiC G12 |
| O20 | O3 remark; V=I §1; InI S5; DiC G8, G10; I3 |
| O21 | O20; NiG N13; IiI §6 |

Interference Is Intelligence proved the ordering is where intelligence lives. This document proves the ordering is where intelligence is STORED. The Y-axis was the last unowned degree of freedom in the framework; it is now an entry in the library, with a proof attached, like everything else.

## Topics

### Theorems this paper proves

- ``StrategyLivesInSigma``
- ``StrategyGate``
- ``StrategyIsUnique``
- ``StrategyCrystallizes``
- ``PhaseBecomesAmplitude``
- ``CompleteEntry``
- ``SkillsAreBalls``
- ``StrategyNavigation``
- ``FourthFace``
