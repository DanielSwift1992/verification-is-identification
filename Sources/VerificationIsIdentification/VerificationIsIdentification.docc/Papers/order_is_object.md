# Order Is Object (Strategy)

Fixed complete verification permits different comparison orders with the same survivor set. This restricted freedom does not exhaust an agent's possible actions (Reading R3). The schedule can itself be the object of another question. This paper studies a declared finite family of comparison strategies and distinguishes a retained strategy description from the state of a process using it.

With finite observations and an explicit depth bound, a strategy is a finite decision tree and can be encoded in Σ. It can therefore be a target of a V=I game. Retaining the selected description does not freeze the state of an agent using it. A finite task domain alone does not bound an arbitrary strategy's depth, since the strategy could repeat observations indefinitely.

The completed library entry becomes a triple (rule, encoding, strategy): WHAT the answer is, THROUGH WHICH lens, and HOW to reach it fastest. The path itself, not its endpoint alone, becomes a certified object, the top rung of the objectification ladder, and metric balls provide one possible representation of strategy families.

## §0. Derivation

The study fixes the observation alphabet, depth bound, candidate strategies and verification rule. It uses V=I §2 and §5.25 within that scope, the W metric (DiC G2), and the separately stated navigation premises (NiG N1–N19).

1. Fix the candidates, reading functions and verification rule. Vary the permitted comparison strategy within the stated bounds. *[V=I §5.25, Reading R3]*
2. A deterministic next-comparison choice Y=P(H) adds no information about the target beyond the known history H: `I(x;Y|H)=0`. If the same static queries and answers are eventually retained, their final compatible set is independent of order. *[InI S1–S2, with acting observations in InI S2a]*
3. With a finite observation alphabet and depth bounded by d, the history-to-next-comparison rule is a finite decision tree. A complete table of N² pair comparisons supplies one finite schedule. It does not bound all policies unless the policy grammar enforces that bound.
4. Finite decision trees encode into Σ: branches are PAIRs, labels are Peano numerals, leaves terminate at NULL. *[V=I §2.1, §4.1]*
5. Therefore strategies have a norm ‖σ‖ and pairwise distances W(σ, σ′). *[DiC G1a, G2]*
6. cost(σ, τ) (the number of COMPAREs the pipeline performs under σ before |S| ≤ 1) is computable: the pipeline is total, each step decidable, the count finite. *[V=I §5.5; I1, I2]*
7. A bounded-cost predicate over computable costs is a gate. A gate over a finite candidate space is a V=I game. *[V=I §3.7]*
8. Multiple strategies may pass, and uniqueness is recovered by the selection-criterion move: argmin over (cost, then norm, then lexicographic order), a total order on a finite set. *[V=I §3.7]*
9. The certified σ\* enters the library and inherits I3: permanent, irreducible, resistant. *[I3; PiR §2]*
10. The strategy library is a finite set of structures in Σ with a computable W-matrix: the representative criterion (G12) applies to a declared approximation contract. Anchored recovery and navigation additionally require their respective premises.

The series asked three questions of COMPARE: whether (Z), where (X), and in what order (Y). The first two were objectified from the start: facts in G, addresses in diagnostics. Here the author objectifies the third.

## §1. Encoding

**O1 (Strategy).** A strategy for encoding E over domain D is a function σ : observation histories → next COMPARE choice. Two regimes:

- *Non-adaptive*: σ ignores observed values, a fixed sequence of features. A list in Σ.
- *Adaptive*: σ branches on observed values, a decision tree. Internal nodes are (feature index, observed value) pairs, and children are the continuations.

Non-adaptive strategies are the degenerate unbranched case of adaptive ones. This paper restricts both to depth at most d≤N² with a finite observation alphabet. Their finiteness follows from that restriction, not from finiteness of the task domain alone.

**O2 (Strategies have encodings in Σ).** Every strategy of O1 encodes as a finite binary tree: feature indices as Peano numerals (V=I §4.1), branch structure as PAIR nesting, termination at NULL. Therefore:

- ‖σ‖ is defined (DiC G1a): the number of distinctions in the strategy's encoding. Under M24's uniform maintenance model it prices the strategy per cycle.
- W(σ₁, σ₂) is defined (DiC G2): the number of single-address edits between two strategy encodings, computable by one traversal (G2a).

Strategy geometry is not constructed: it is inherited the moment strategies are admitted into Σ.

**O3 (Finiteness).** For fixed encoding, feature set, and depth bound d ≤ N², the strategy space Π_d is finite.

*Proof.* Finitely many features, finitely many observable values (I1), bounded depth: the number of distinct decision trees is a finite (if large) combinatorial count. QED

*Remark (the count is hostile).* |Π_d| grows doubly exponentially in d. O3 guarantees legality, not affordability. §7 restores affordability by the same move the framework always makes: the agent supplies a restricted grammar.

## §2. Verification

**O4 (Cost is computable).** cost(σ, τ) = the number of COMPAREs executed when the inner pipeline's order is dictated by σ on task τ, until |S| ≤ 1 or σ is exhausted. Computable: the pipeline is total (V=I §5.5), σ is a finite tree, each step is decidable (I2), the run is deterministic given (σ, τ).

**O5 (The strategy gate).** For a rule class k with task set {τ₁, ..., τ_m} ⊆ k and budget c:

```
GATE_σ(σ, k, c) :  for every τᵢ —  result(σ, τᵢ) = PASS  ∧  cost(σ, τᵢ) ≤ c
```

Decidable: a finite conjunction of computable checks (O4). REJECT carries the address: which task, at which step the budget broke, which feature the strategy chose there, the same diagnostic discipline as V=I §1, one level up.

**O6 (Soundness under restricted strategy access).** Fix the source, reading functions and a sound rule for issuing PASS. Let a strategy select permitted readings and decide when to stop, without changing returned evidence, discarding unrefuted candidates or issuing PASS outside that rule. Every emitted PASS is then sound because it satisfies the fixed rule. A poor strategy can exhaust its budget or fail to establish an answer. The safety argument uses this restricted access and the sound acceptance rule. Order-independence of a final survivor set alone would not justify an arbitrary early PASS. O5 adds an efficiency and completion condition on its listed tasks, without proving performance on every unlisted task in their class.

**O7 (The minimal budget is computable).** GATE_σ is monotone in c (a strategy passing at c passes at c′ ≥ c). The minimal budget c\*_k = min{c : ∃σ ∈ Π_d, GATE_σ(σ, k, c)} is computable by binary search over c ∈ [1, N²], each probe a finite check (O5).

## §3. Identification

**O8 (Uniqueness by minimality).** Let S_σ = {σ ∈ Π_d : GATE_σ(σ, k, c\*_k)}. In general |S_σ| > 1. Apply the selection-criterion move (V=I §3.7): refine by argmin over the lexicographic triple

```
( max cost over k,   ‖σ‖,   structural order on Σ )
```

A total order on a finite set has a unique minimum: σ\*_k. R4 is true for the refined relation by construction, and Theorem 2 is in force for it. The certified strategy is the cheapest of the fastest: minimal worst-case cost, then minimal norm, then canonical.

**O9 (Strategies inherit I3, as objects).** σ\*_k enters the strategy library L_σ. Entries are never removed (I3, PiR M21). The IiI §2 caveat is now resolved at its correct level: strategy *state* at level N is mutable scaffolding, and strategy *objects* at level N+1 are permanent, irreducible (the unique minimum of O8), and resistant (the next agent encounters σ\*_k as a fixed target). The caveat was true and is untouched: it was a statement about the wrong level.

**O10 (Phase becomes amplitude).** At level N a deterministic comparison choice adds no information beyond the known history (InI S1). With the same retained static queries and answers, reordering leaves the final compatible set unchanged (InI S2). An order chosen from an informative history can nevertheless reveal target information to someone who does not know that history. At level N+1 the strategy itself can be the identified content: the strategy game's target is σ\*, and gate checks constrain which strategy survives. The Y-axis of level N can become the Z-axis of level N+1. What steering was to the journey, the journey is to the map. This phase comparison is an analogy. When observations act on their source, the ordering can also change the final record at level N (InI S2a).

**O11 (The witness of cert).** InI S5b defines cert(τ) (the smallest feature set identifying τ) as the optimal trajectory length, existentially. σ\*_k is its constructive carrier: a stored, certified, permanent object whose execution realizes the class budget c\*_k. The exact bound: c\*_k = min over σ of max over τ ∈ k of cost(σ, τ) ≥ max over τ ∈ k of cert(τ). The gap between the class budget and the per-target cert is the price of one strategy serving a whole class, measurable per class, zero when the class is strategy-homogeneous.

## §4. Crystallization

**O12 (The complete entry).** After rule saturation (IiI §3) and strategy saturation (O13), a library entry is a triple:

```
( f*,  E,  σ* )  —  WHAT the answer is,  THROUGH WHICH lens,  HOW to reach it fastest
```

Theorem 2 certifies the first, the agent supplies and R4 validates the second, and the strategy gate of this document certifies the third. The object now contains its own path. The question that opened the series' applications (can a path be turned into an object) closes here: not only the path's endpoint (Verification Is Identification), not only the path's deposits (Intelligence Is Inevitable and Permanence Is Resistance), not only the path's infrastructure (Navigation Is Geometry), but the path itself, as an executable, certified, permanent structure.

**O13 (Strategy saturation).** Strategy classes over a finite domain are finite: at most one σ\* per rule class (O8), K rule classes (IiI §3). The conditional Saturation Theorem transfers with (tasks → strategy games, rules → strategies): under its common interpretation, sound retaining insertions and a stream on which every class is eventually solved (IiI §3), finitely many certified strategy games make L_σ cover every class. For an initially empty library with K_σ ≥ 1, if the K_σ strategy classes being counted arrive independently and uniformly and each encountered class is solved and retained on that encounter, the expected number of arriving games until coverage is K_σ H_{K_σ} (IiI §6). Post-saturation protocol: a new task first routes to L_σ. Execute the stored σ\* for its class, pay c\*_k, done. The meta-level answers before the base level searches.

## §5. Strategy Geometry

**O14 (Strategy modulus).** Define ω_σ as the modulus of the map k ↦ σ\*_k: W(σ\*_k, σ\*_{k′}) ≤ ω_σ(W(k, k′)): nearby rule classes have nearby optimal strategies. Measurable over L_σ: finitely many W-computations (DiC G2a), exactly as the rule modulus (G10). Not guaranteed by I1–I3: same status, same standing.

**O15 (A metric representation of skills).** A ball in strategy space can represent a family of nearby strategy codes. With an adequate strategy modulus and applicable search procedure, an anchor bounds where to seek a strategy for a new class. This is one possible representation of a skill. G12's approximation criterion does not make it the definition of every reusable strategy. The same generic procedure can operate exactly on many new inputs, including when the stored code family has constant pairwise distances.

**O16 (Strategy navigation).** L_σ under W forms an anchor graph Γ(L_σ, ρ). NiG N1–N19 apply by substitution, each under its own premises (O18): connectivity and navigability thresholds, monotonicity, ballistic descent, holes with addresses, and repair retained under N16's insertion policy. Population preserves supplied witnesses, not every global routing score (N19). A new task class routes greedily through strategy space to its nearest certified skill, executes, and on gate failure emits an addressed hole, naming the missing skill. The router's failures are the skill curriculum (N17, one level up).

**O17 (The objectification ladder).** Path-to-object conversion is a ladder of six rungs, each conditional on more geometric structure, each condition decidable or measurable:

| Rung | Object | Condition | Source |
|---|---|---|---|
| 1 | Trace recorded | none, unconditional | I3 |
| 2 | Endpoint certified (f\*) | finite deterministic task | Thm 2, Thm 4 |
| 3 | Object transfers | rule classes repeat (K finite) | IiI §3 |
| 4 | Object generalizes (ball) | modulus ω exists | G10–G11 |
| 5 | Objects route (graph) | radius, permitted moves, targets and policy specified; a hop bound retains N12's access, level and selection premises | NiG N12, N18 |
| 6 | The path itself certified (σ\*) | strategy grammar affordable (§7) | this document |

Each rung needs its own representation, application and acquisition witnesses. Encoding a path as an object permits another question about it, but does not establish that the next level is learnable or cheaper.

**O18 (Strategy transfer has its own application contract).** Reusing an answer does not automatically provide a strategy for finding it, and reusing a strategy requires binding that strategy to the new task's actual observations and operations. A metric bound can help find a suitable strategy, while an exact generic application can make that search unnecessary. N18 and G12 therefore do not yield a fourth equivalent clustering criterion. Any logarithmic navigation bound must retain the separate hypotheses of the particular navigation theorem at each level.

## §6. The Tower of Orders

**O19 (Transfer across levels).** Strategy games at level N+1 are themselves run in some order. InI S1 applies to a deterministic choice conditional on its known history. S2 applies when the same static queries and answers are retained. Neither makes that order unconditionally uninformative. The construction O1–O9 can be applied at level N+2 only after supplying its bounded strategy grammar, finite candidates, decidable verification and Σ-encoding, together with the static query semantics, sound history, query availability, costs and policy information required by InI S8a. Encoding alone does not supply these premises. M16 gives a sufficient termination argument when finite class counts strictly decrease at every step. G12 does not identify the endpoint with a flat strategy matrix, and encoding a strategy does not force a useful higher-level question or its solution.

## §7. Affordability

**O20 (Restricted strategy grammars).** |Π_d| is doubly exponential (O3 remark), and exhaustive strategy search is legal and unaffordable. The framework's standard move is in force: the agent supplies a strategy grammar Π_R ⊂ Π_d, and all guarantees are relative to Π_R (exactly as encodings, V=I §1: the agent's grammar bounds the reachable, never the correct). Three grammars with known properties:

1. *Greedy family*: always test the max-entropy feature over the current S_k. One parameter (the entropy estimator). This is a candidate heuristic. InI S3–S5 do not establish its exact optimality or convergence to η → 1. Its performance requires a separate guarantee or certification under O5. Certification cost: linear in features per probe.
2. *Anchor-edit family*: strategies within W-radius r of an existing σ\* ∈ L_σ, ball search in strategy space (G10 applied via O14). Cost: |B(σ\*, r)| probes (finite, G8).
3. *Trajectory replay*: the sequence of COMPAREs that solved a class instance, read from G (the trace is already there, I3), pruned of redundant steps (InI S3a detects them). Cost: one pass over the recorded episode. This is rung 1 lifted to rung 6 directly: the cheapest strategy candidate is the remembered path itself.

**O21 (Amortization).** Certifying σ\*_k costs C_cert(Π_R) once, and it saves (T_random − c\*_k) COMPAREs on every future instance of class k. Crossover after C_cert / (T_random − c\*_k) instances: finite, computable in advance, the strategy-level twin of NiG N13. Post-crossover, every further instance of class k saves (T_random − c\*_k) comparisons, and the savings grow with task frequency p_k, so the optimal certification order is by descending p_k × (T_random − c\*_k): the curriculum is computable too.

## §8. Boundaries

**Affordability is grammar-relative.** O20's guarantees are relative to Π_R, and the optimal strategy in Π_d \ Π_R is invisible: same status as encodings outside E (IiI §4: the permanent boundary is the grammar).

**The class–target gap.** σ\*_k optimizes the class worst case, and a per-target shortcut (InI S5b(c)) may beat it on individual tasks. The gap is measurable (O11), and closing it per-target reintroduces per-target storage: the memoization trade, now visible as a number.

**ω_σ is not guaranteed on unobserved tasks.** A complete finite target table permits checking a proposed bound on that table. Exact strategy reuse can also follow from a generic application. Flat pairwise distances do not exclude such reuse, as G12 shows.

**The stated cost gate uses deterministic execution.** A stochastic extension must specify whether it certifies worst-case cost, expected cost or a tail bound, and must supply the corresponding transition and observation law. Identifying that law does not turn its individual outcomes into deterministic predictions. Law §6 separates exact law consequences from acquisition through finite samples. Agreement AC7 tests when an average preserves the requested answer, and Play §4 retains the opponent's available information in a mixed-strategy guarantee.


## §9. Statement

1. A strategy is a finite decision tree, finite decision trees are in Σ, and therefore strategies have norms, distances, and can be targets (O1–O3).
2. Strategy cost is computable, the strategy gate is decidable, and a strategy with O6's restricted access cannot corrupt a sound PASS: efficiency certification layers on top of that safety (O4–O6).
3. The minimal budget and the unique cheapest-fastest strategy are computable, and σ\* is the constructive witness of certificate complexity (O7–O8, O11).
4. Certified strategies inherit I3: the mutable-strategy caveat of Intelligence Is Inevitable was a statement about the wrong level (O9).
5. A strategy can become the target of a higher-level question when that level supplies its own observation, verification and access premises (O10, O19).
6. The library entry completes into (f\*, E, σ\*): the object contains its own path. The objectification ladder reaches its top rung, and its height is a measurable property of the domain (O12, O17).
7. Metric strategy search and exact strategy reuse require their respective application and access premises (O14–O16, O18).
8. Affordability is restored by restricted grammars, the cheapest of which is the remembered path itself, and certification amortizes by a computable crossover, in a computable order (O20–O21).

> **With its history known, a deterministic choice adds no new information. One level up, the path itself can be the answer. Certified, it is an object. Reused, it still needs its contract.**

## §10. Dependency

### External

| Source | Used |
|---|---|
| V=I | §1 (agent supplies grammar), §2.1 (Σ), §3.7 (selection criterion), §4.1 (Peano), §5.5 (totality), §5.25 (order sole variable, order-invariant correctness), Theorems 2–4 |
| IiI | §2 (strategy-state caveat, resolved by O9), §3 (Saturation Theorem, K), §4 (grammar boundary), §6 (coupon collector) |
| PiR | §2 (three properties of crystal), M21 (no deletion) |
| DiC | G1a (norm), G2/G2a (W, one traversal), G8 (finite balls), G10 (modulus, ball search), G11–G12 (cover, compression) |
| InI | S1 (choice conditional on history), S2 (same retained static evidence), S2a (acting observations), S3a (redundancy detection), S5 (efficiency under a common objective), S5b (cert), S8a (transfer with premises) |
| NiG | radius graph, N12 supplied access bound, N17 addressed acquisition, N18 distinct contracts, N19 expanding-domain boundary |

### Internal

| Statement | Depends on |
|---|---|
| O1–O3 | V=I §2.1, §4.1, Theorem 3, I1 |
| O4–O6 | O1, V=I §5.5, §5.25, Theorem 2, I2 |
| O7 | O5 (monotone gate), I1 |
| O8 | O7, V=I §3.7 |
| O9 | O8, I3, PiR M21 |
| O10 | O8, InI S1, S2, S2a |
| O11 | O8, InI S5b |
| O12 | O8, O9, IiI §3 |
| O13 | O9, IiI §3, §6 |
| O14 | O2, DiC G10 |
| O15 | O14, DiC G12 |
| O16 | O14, O15, NiG N1–N19 |
| O17 | O12, I3, Thm 2/4, IiI §3, G10–G11, NiG N12, N18 |
| O18 | O15, NiG N18 |
| O19 | O1–O9, InI S1–S2, S8a, DiC G12 |
| O20 | O3 remark, V=I §1, InI S3–S5, DiC G8, G10, I3 |
| O21 | O20, NiG N13, IiI §6 |

Interference Is Intelligence studied where the ordering of comparisons matters. Here the author shows how an ordering can be STORED as an object. The Y-axis was the last unowned degree of freedom in the framework. It is now an entry in the library, with a proof attached, like everything else.

## Topics

### Related type declarations

- ``StrategyLivesInSigma``
- ``StrategyGate``
- ``StrategyIsUnique``
- ``StrategyCrystallizes``
- ``PhaseBecomesAmplitude``
- ``CompleteEntry``
- ``SkillsAreBalls``
- ``StrategyNavigation``
- ``FourthFace``
