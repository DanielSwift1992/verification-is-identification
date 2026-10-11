# Intelligence Is Inevitable (Agent)

V=I identifies a candidate when its verified survivor set has one element. This paper studies how repeated games can accumulate reusable knowledge. The result is conditional: sound retaining updates, a covered finite rule domain, adequate model assumptions and usable dispatch can support reuse. Faster or optimal identification does not follow from retention alone. Intelligence here names measured efficiency (§3), not a broader faculty. System CS1–CS3 separates coverage, selection and generalization, and §6 gives cover-time laws under an explicit independent-arrival model. A complete rule projection is domain-determined. Feature records and the method of reaching it can differ.

## §0. From System to Agent

V=I §2–§4 define a system: a function from encodings to {PASS, REJECT}.

A function that is never called computes nothing. The system identifies nothing without input. To operate, the system requires a caller: something that provides encodings.

V=I §1 supplies this: the loop.

```
caller ──> encoding ──> system ──> PASS: identified
  ↑                        │
  └── REJECT(where, why) ──┘
```

The loop has two halves. The inner half (system) is proven: total, deterministic, safe (V=I §5). The outer half (the caller) is the agent. *Agent* names the role, extensionally: whatever supplies encodings to the system is the agent of its loop, regardless of substrate. The components below are not assumptions about its nature: they are requirements derived from what the loop needs in order to run, converge, and direct its search.

**The agent IS the outer half of the loop.** Without the agent, there is no loop: only a function with no argument. Without the system, there is no loop: only a source of encodings with no check. Neither half operates alone.

The loop's structure determines the agent's components:

| Component | What it does | What it enables |
|-----------|-------------|----------------|
| Source | Produces encodings from grammar E | Operation. Without it: system has no input, loop does not start. |
| Persistence | Continues until PASS or exhaustion | Continued activity. Exhaustion additionally requires a coverage policy. |
| Receptor | Reads REJECT(where, why) | Directed search. Without it: blind enumeration. |
| Modifier | Changes encoding based on feedback | Directed search. Without it: same as without receptor. |

Source and persistence allow the loop to run. Exhaustive enumeration of a declared finite encoding set gives PASS or exhaustion after finitely many submissions. Persistence alone permits endless repeats, and a finite grammar can generate infinitely many encodings. Receptor and modifier support feedback-directed search, whose progress still needs an argument.

## §1. One Game, Then Many

§0 identifies the caller's role. One finite pipeline invocation terminates under its bounds. An outer search over encodings terminates when the search has a finite budget or an exhaustive policy over a finite set. These are distinct claims.

**One game.** The agent submits an encoding and the system checks it. A pure repeat of the same request produces the same answer. That does not force the agent to avoid repeats. If each rejection removes the submitted encoding from a finite untried set, PASS or exhaustion occurs after at most that set's size in submissions. The inner N² comparison bound of V=I Theorem 3 applies per invocation under its assumptions, not to an arbitrary sequence of resubmissions.

**Crystallization.** Each PASS converts an agent-path into a system-path. Before PASS, the encoding is the agent's guess: engineering, fallible, no guarantee. After PASS, the verified result inherits the system's guarantee (Theorem 2). Once certified, the result is permanent (I3). For any future task with the same structure, the agent reuses the certified result instead of re-deriving (§2).

This is V=I §5.17 (agent-system duality) applied across time: the system at level N is the agent's tool T2 at level N+1. Each PASS at level N produces a certified object that level N+1 can use as a premise.

**Many games.** The agent may encounter τ₁, then τ₂, then τ₃. Repeated encounters are an additional operating condition. An infinite stream of completed games does not follow from the termination of each finite invocation.

Here intelligence becomes visible: does solving τ₁ make solving τ₂ faster?

Retained results can make shared work reusable when keys, scope and interpretation agree. The optimal cost with an optional sound cache cannot exceed the same optimum without it: the richer policy can ignore that cache. An implemented policy need not attain this bound, since lookup, feature extraction and dispatch have costs. §2 specifies what can transfer, and §3 separates coverage from faster use.

## §2. What Accumulates

**I3 for the agent.** Empirical records, certified conditional conclusions and strategy state can have different update rules. A pure comparison fixes its truth but does not guarantee that an agent retains its accessible record (System GC1). A sound retaining update requires an explicit implementation and immutable keys (GC2–GC3). The library needs its own such update. Predictive conclusions also carry model assumptions, whose revision can change applicability without changing a single recorded observation (CS3). Under a stationary probability measure on the whole, a measurable cache that never drops any of a countable set of facts also gains none almost surely. Prepared growth and entropy preservation require different premises (PiR M36–M37).

**Uniform operator.** Every feature in V=I is a structural predicate computed via COMPARE. `same_row(o, i) = COMPARE(row(o), row(i))`. `rank(i, I) = count_less(val(i), vals(I))`, itself a series of COMPAREs. There is no hierarchy of feature types. Positional features, value features, pattern features are all COMPARE applied at different scope. The operator is uniform, and scope of reuse differs.

**Levels.** Not all records are equally useful across games. V=I operates on finite binary trees with hierarchical structure: parts (PAIR) have parts, down to leaves (NULL). COMPAREs at different levels of this hierarchy have different scope:

| Level | What is compared | Scope | Across games |
|-------|-----------------|-------|-------------|
| 0 | Values: COMPARE(val(a), val(b)) | Exact immutable value keys | Reusable when the keys recur. |
| 1 | Positions: COMPARE(row(a), row(b)) | Position and coordinate context | Reusable when those keys and their interpretation recur. |
| 2 | Rules: COMPARE(rule(τ₁), rule(τ₂)) | Declared rule semantics | Application requires the new task to satisfy the rule's premises. |

The storage level alone does not decide transfer. A repeated value comparison can be reused across tasks, while a changed coordinate context can invalidate an old position key. A retained rule can supply a candidate on new data, but matching, verification and target representability retain their separate obligations.

**Signature.** When the agent solves a game, V=I §4.5 extracts a rule: a conjunction of consistent, informative features. This rule is a structure in Σ, a finite binary tree encoding which features held across all equations. Two games have the same signature when their extracted rules are structurally identical: COMPARE(rule(τ₁), rule(τ₂)) = equal.

**Definition.** For saturation, use classes of tasks sharing the same extensional required rule in a common family and decoding (System CS1). Let K count these classes. Identical extracted syntax is one possible signature, not a proof that every equivalent rule has a unique syntactic form.

The agent's library L is a set of pairs {(rule₁, encoding₁), ..., (ruleₖ, encodingₖ)}, each a certified solution (§1: crystallization). A finite represented library consists of structures in Σ. Its retaining update is an implementation premise. The projection to common rule classes has bound K, while different rule/encoding records can outnumber those classes.

**Pre-solve matching.** Given a new task τ, the agent does not need to solve it from scratch. Features (V=I §4.4) are structural predicates computable from COMPARE and projection, and they can be extracted from the new task's equations cheaply. The agent compares these features against stored rules in L. If COMPARE finds a match, apply the stored rule and submit to compilation (V=I §4.7). Compilation is the guarantee: if it passes, Theorem 2 applies regardless of how the rule was found. If compilation fails, the match was wrong: try the next entry or fall back to full extraction.

A feature match can be a false positive: extraction samples the unambiguous equations, compilation checks every example pair. Two transformations that coincide on the sample (mirror and shift on a symmetric grid) are separated at the gate. This is why the gate is still essential after a successful match: matching is a fast guess, and compilation converts it into a certificate.

The gate rejects a match that violates its checked examples. Exact identification of the encoding-local target additionally requires R4, and prediction of an actual law requires representability (System CS3).

**Why transfer works.** A rule is a recipe: `same_row ∧ col_mirror` stores "for each output position, find the input atom at the same row and mirror column." When applied to a new task, every feature is recomputed on the new task's data. same_row checks the new rows, rank counts the new values. The recipe remembers which structural relations to check, and recomputes them from scratch.

This is why a rule certified on τ₁ can pass compilation on τ₂: the recipe describes the transformation. If τ₂ has the same transformation, the same structural relations are true, and compilation passes. If τ₂ has a different transformation, some example pair separates the stored rule from τ₂'s solution, and compilation rejects. If no example separates them, both survive into S, and that is |S| > 1, reported by the R4 check (V=I §3.6), the one failure compilation cannot see: every member of S reproduces every example.

## §3. Intelligence

**Definitions.**

| Symbol | Meaning |
|--------|---------|
| τ | A single task (V=I game) |
| D | A finite set of tasks the agent encounters. D is fixed for a given analysis |
| P | A protocol: the agent's strategy for selecting and ordering encodings |
| T_min(τ) | Minimum COMPAREs to reach \|S\| ≤ 1 on task τ. Property of the task |
| T_actual(P, τ) | Total COMPAREs protocol P uses to reach \|S\| ≤ 1 on task τ |
| T_brute | A declared extraction bound in the same cost unit, including work not covered by the N² atom-key count |
| F | Number of features per rule in the current encoding |
| K | Number of rule classes in D (§2: signature) |

**Definition.** Intelligence of protocol P on task τ:

```
η(P, τ) = T_min(τ) / T_actual(P, τ)
```

Define η only when 0<T_min≤T_actual, with both costs measured in the same unit and with the same available information, memory and query capabilities. An already answered task with zero cost needs separate treatment, not a 0/0 ratio. Binary decision-tree entropy and depth bounds have the scope stated in System IQ1–IQ3. A bound on atom-pair comparisons cannot be moved to another cost model without a bridge.

For finite deterministic query tables, exhaustive optimization can compute a minimum, although the search can be expensive. Rule coverage alone neither supplies those complete query tables nor proves a chosen dispatcher optimal. (η is used to avoid confusion with I1, I2, I3.)

**On a single completed game:** η is an episode-level cost ratio when both costs meet its definition. A policy that does not terminate has no such finite episode ratio.

**Lookup.** Use a canonical library with one entry per represented rule class, and let C be the complete class set for a fixed identifiable domain D_id. Write K=|C| and P(L) for the represented classes. Raw (features,rule) records may outnumber K (System CS1). Let J bound the comparisons per entry in a chosen feature dispatcher, and V bound verification cost in the same unit. A successful scan has comparison bound O(KJ)+V only when the available features select the required class or an explicit complete verification search can recover it (CS2). A gate call is not automatically one comparison.

**Theorem (Conditional saturation).** Assume a common finite rule interpretation for D_id, sound retaining insertions, and a task stream on which every class is eventually solved. Starting with represented classes P₀, K−|P₀| first insertions of new classes yield P(L)=C. If the dispatcher and verifier satisfy the preceding assumptions, subsequent tasks in D_id can reuse those rules with the stated bound.

*Proof.* Each fresh class increases |P(L)| by one. No class leaves and no class outside C enters. After K−|P₀| such events, P(L)=C. Correct dispatch or complete verification then selects the required rule. Counting arbitrary successful tasks does not prove these events occur. Nor does coverage establish the dispatcher. QED

*Corollary (cost).* If B bounds extraction and insertion for a first encounter, those K−|P₀| events cost at most (K−|P₀|)B. This excludes intervening tasks and lookup overhead. Arbitrarily many repeats can delay completion. Reuse improves a task's cost when its actual lookup and verification cost is less than solving it afresh. An upper-bound expression alone supplies no improvement ratio.

*Corollary (efficiency after coverage).* Neither maximal nor near-maximal η follows from P(L)=C. With four classes already cached and both name and binary-coordinate tests available, sequential name tests have worst cost 3 and mean 9/4, while an optimal dispatcher has worst and mean cost 2. Both are exact and use the same complete library. Choosing an efficient policy remains a separate optimization problem.

*Remark (scope of inevitability).* Finite classes plus retention imply a bound on fresh insertions. Eventual coverage additionally requires each class to arrive and be solved. No conclusion about tasks outside D_id follows. In the independent positive-probability model of §6, class visitation occurs almost surely, not by a deterministic deadline.

*Remark (finiteness of classes).* A finite structure does not imply a finite family of rule classes. A domain with an unbounded family may never complete a library indexed by every rule. A finite generative basis can represent more rules than it explicitly stores, but reliable derivation and selection from that basis need their own arguments. Finite basis coverage is not itself coverage of all generated behaviors.

*Remark (between-domain transfer).* Transfer to D₂ requires compatible decoding, applicability of the stored rule and adequate verification on the new task. Passing new examples alone certifies consistency. Exact rule identification also requires R4 and representability. System CS3 gives an explicit failure when the actual rule lies outside the assumed family.

**What completion fixes.** Two complete libraries share the projection C. Different feature descriptions or derivations can yield different raw entries. Canonical raw equality needs a shared representation convention. When K>0, |P(L)|/K measures class coverage, not model adequacy, prediction coverage or dispatcher quality. Completion under a retaining update cannot retract within that update model, but a fixed finite reversible whole cannot acquire a new permanently absorbing knowledge state without violating VC34's premises.

> Argues: ``LibrarySaturates`` needs ``CachePermanent``.

**Comparison with mutable state.** Mutable storage permits forgetting but does not force it. Conversely, append-only empirical records do not prevent conclusions from losing applicability when the hypothesis family changes (System CS3). Certification, adequate assumptions, rejection behavior and retention are separate properties. No advantage over neural learning follows from the cache law alone. An approximate model can propose encodings or rules, and a verifier can certify conclusions within its explicit scope.

## §4. Boundaries

Coverage and efficiency depend on the following boundaries in addition to the conditions of §3:

**Encoding boundary.** Cross-encoding transfer requires a semantics-preserving correspondence and compatible cache keys. Such a bridge can permit reuse. Its absence prevents a guarantee, not every possible transfer.

**Meta-saturation (encoding selection).** The same coverage argument can be applied to a finite declared set of task classes and encodings, provided each class eventually receives a working encoding and the association is retained. More than one encoding may work for a task. What is covered is the task class, not a unique encoding. The grammar's finite description does not prove that its generated encoding set is finite, and a decidable gate does not provide the missing coverage policy. Successful lookup at this level is therefore conditional in the same way as §3's rule lookup.

The tower is finite only with a separate height bound or strict rank descent (V=I §5.16, EiF EF7). Saturation at a given level also needs the class-coverage premise of §3. Finite space, a decidable check and retained records alone do not force the task stream to visit every class. Where saturation occurs it can extend the next level's reach. Higher-level candidate spaces may grow exponentially, so neither a final level nor a practical total cost follows from finiteness at each level.

**Optimization boundary.** A finite complete query table permits exhaustive decision-tree optimization, which may be expensive. The objective must specify worst-case depth, expected query count under a prior, or another cost. An instance certificate is not automatically an optimal adaptive policy. Neither coverage nor a successful run proves that the implemented policy is optimal.

**Distribution-relative.** An expected-cost claim needs a task distribution. Optimality under one prior does not itself establish optimality under another. No-free-lunch results require their own function-family, sampling and performance assumptions. The encoding boundary alone supplies no theorem that every protocol has a rival distribution on which it loses.

**Finiteness boundary.** A finite representation can exactly describe an infinite generated family. A finite observation that merges candidates instead loses access to questions that differ within a fiber. Such a question cannot be answered from that observation alone. Additional interactions can expose a formerly hidden distinction (Verdict VC38), and a model of those interactions is needed to establish recoverability.

**Completeness boundary.** An empty survivor set rejects the declared model and evidence. Multiple survivors prevent whole-rule identification but can still agree on a particular query (System CS3). Additional evidence can reduce ambiguity. Expanding the family can instead restore alternatives excluded by an inadequate model. Expressibility provides a possible candidate, not proof that a fixed extraction strategy reaches it.

**System closure.** The system operates only on relations between elements within the encoding (V=I §5.23–§5.24). Every feature is COMPARE between elements in Σ, and every rule is a conjunction of such COMPAREs. What the encoding does not represent, the system does not see.

## §5. Crystallizing System

A finite decreasing candidate sequence stabilizes. Its limit can still contain several candidates. This section states the additional progress premise that makes a question settle or a finite library become covered.

Let S₀ be a finite candidate set and Pₙ decidable predicates. Define Sₙ = {x ∈ S₀: P₁(x) ∧ ... ∧ Pₙ(x)}. A1 is monotonicity of this sequence, A2 retention of its predicates and A3 decidable membership. These properties permit Sₙ = S₀ for every n. They do not imply the former A4 conclusion, ∃n: |Sₙ| ≤ 1.

**Progress premise.** Fix an actual x ∈ S₀ and a question q, require every predicate to preserve x, and require that for every y with q(y) ≠ q(x), some finite Pₙ excludes y. Liquid LQ11 proves that this premise is equivalent to q becoming constant on Sₙ in finite time. For q equal to candidate identity it gives a singleton. A query can also settle while multiple candidates remain.

**Lemma 1 (V=I with acquisition).** A finite pipeline whose sound comparisons eventually separate the target from every other candidate identifies that target. Finiteness makes the collection of separation times finite, and retention preserves each exclusion. PASS still needs the conditions of V=I Theorem 2. The existence of a suitable encoding does not establish that a caller finds it or that its actual query policy gathers the distinguishing evidence.

> Argues: ``PipelineCrystallizes`` needs ``PassIsIdentification``.

**Lemma 2 (Agent learning with coverage).** Fix a finite common set C of required rule classes and a sound retaining library L. Let U₀ = C ∖ P(L₀) be its initially uncovered classes. After episode n define Uₙ = {k ∈ U₀: k has not been inserted by episode n}. The predicates keep classes that remain uncovered. Each successful insertion of a new class removes that class, while a repeated PASS may leave U unchanged. If every initially uncovered class is eventually solved and inserted, the maximum of its finitely many insertion times is finite and U becomes empty. Matching and usable dispatch require the separate premise of System CS2.

> Argues: ``LibraryCrystallizes`` needs ``LibrarySaturates``.

An empty survivor set remains empty under further intersection and indicates inconsistency of the declared model and evidence. A singleton is stable under further sound evidence preserving its actual member. Without that premise a later predicate can exclude the singleton too. Empty coverage complement and unique target are different completion criteria.

The Swift intersections expose declared relations and type coordinates. `SystemCrystallizes` pins a `Unique` solution-set coordinate. This checks a supplied type relation, not eventual progress of an arbitrary runtime trajectory. A proof of the progress premise or a bounded acquisition witness must be supplied separately.

## §6. Phase Transition

This section models coverage under an additional arrival law. Retention and finite classes alone do not determine arrival statistics. The resulting cover-time and endpoint statements concern a finite class set under that model, not a derived thermodynamic phase transition.

**Theorem (Saturation time).** Suppose K≥1, the library starts empty, task classes arrive independently with uniform probability, and each encountered class is solved and retained. The expected number of tasks until saturation:

```
E[τ_sat] = K · Hₖ = K · Σᵢ₌₁ᴷ (1/i) ≈ K · ln(K) + γK
```

where Hₖ is the K-th harmonic number and γ ≈ 0.5772 is the Euler-Mascheroni constant.

*Proof.* After covering k − 1 classes, the probability that the next task belongs to a new class is (K − k + 1)/K. The expected wait for one new class is K/(K − k + 1). Summing over k from 1 to K yields K · Hₖ. This is the coupon collector model. QED

**Corollary (Approach speed).** The probability that the library is incomplete after τ tasks:

```
P(|P(L)| < K after τ) ≤ K · e^(−τ/K)
```

The union bound gives K(1−1/K)^τ≤K exp(−τ/K). For positive independent class probabilities p_k, the corresponding bound is Σ_k(1−p_k)^τ, which tends to zero. Marginal probabilities alone do not imply coverage: choose one fair class once and repeat it forever. Every time has uniform marginals while one class never appears. The IID law is an extra stochastic model, not a consequence of a finite closed reversible whole. Such a whole can implement bounded prepared arrival windows without supplying an independent stream forever.

**Theorem (Endpoint of class coverage).** With sound retaining updates and eventual visitation and solution of each class, P(L)=C at completion. This follows from CS1. Different orders of first visits can yield the same class set and different feature records. There are K! permutations of first visits, but arbitrary task histories also contain repeats. These permutations need not be equally likely when class probabilities differ.

The coverage process under an IID arrival law is determined by its class probabilities and initial coverage. Equal probabilities and class counts do not establish equal computation costs: query availability, feature extraction and verification still differ.

**Remark (waiting near coverage).** Under uniform independent arrivals, δ missing classes have combined probability δ/K, so the mean wait for the next new class is K/δ. The remaining classes need not be intrinsically rare. With nonuniform probabilities, the mean is 1/Σ_missing p_k instead. These are waiting-time identities within the arrival model. No physical critical phenomenon follows from them.

## §7. Discovery

V=I §5.20: COMPARE(a, b) does not create a fact. The result (equal or not_equal) is structurally determined before the call. The trees are already what they are. COMPARE reveals.

The same applies to the pipeline as a whole and to the agent: neither creates the facts they operate on. Exists and pre-exists, here and below, are statements of determination: the value is fixed by the task and the encoding before any call computes it, V=I §5.20's purity, applied at larger scales.

**Corollary (Pre-existence).** f* exists before the agent starts. S = {y ∈ F : passes verification} is determined by the task's structure and the encoding's test. The agent's COMPARE sequence does not construct f*: it eliminates every other candidate until f* is the only one left.

> Argues: ``DiscoveryIsRevelation`` needs ``ExactlyOneSurvives``.

**Corollary (Rule projection invariance).** The complete class set C is determined by the common domain and rule interpretation. Libraries with different feature records can project to the same C. The agent can discover which rules apply while constructing a particular representation of that record. No choice of representation creates the already fixed target law.

> Argues: ``DiscoveryIsRevelation`` needs ``LibrarySaturates``.

These two corollaries shift the question from "what does the agent build?" to "how efficiently does the agent uncover what is already there?"

**Corollary (Encoding as lens).** The target does not depend on the encoding (V=I §5.14). The encoding determines which distinctions are visible. A richer encoding exposes more structure. A poorer encoding hides it. The structure is invariant, and the lens is the variable.

**Corollary (Search as elimination).** V=I §5.22: S shrinks monotonically. The agent starts with all of F and removes what does not survive. The process is subtractive.

## §8. Statement

V=I's safety theorem identifies the encoding-local candidate under PASS and R4. Faithful observations and target representability connect that statement to an actual law. This paper adds a conditional account of reuse:

1. Sound retaining updates preserve their records under fixed assumptions.
2. A finite common rule domain bounds newly represented classes.
3. Eventual visitation and successful learning of each class yield full class coverage.
4. Sufficient dispatch or complete verification makes stored rules usable on the next task.
5. Reuse improves efficiency when its measured cost is lower than re-derivation. Optimality needs a separate argument.
6. Independent arrivals supply the coupon-collector model. Other arrival laws can fail coverage despite positive marginals.
7. Complete libraries share their rule projection. They need not share feature records, derivations or costs.
8. Expanding a model family can retract predictions while every observation remains retained and true.

The theory therefore supports a precise research program for certified learning and reuse. It does not yet prove that every persistent learner becomes faster, that retention alone entails intelligence, or that a unique encoding-local solution must match an unrepresented physical law. The finite witnesses and countermodels in System CS1–CS3 make those boundaries executable.

## Topics

### Related type declarations

- ``KnowledgeAccumulates``
- ``LibrarySaturates``
- ``BasisIsFinite``
- ``EncodingSelectionSaturates``
- ``SystemCrystallizes``
- ``PipelineCrystallizes``
- ``LibraryCrystallizes``
- ``SaturationDynamics``
- ``DiscoveryIsRevelation``
- ``IntelligenceRises``
