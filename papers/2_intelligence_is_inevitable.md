# Intelligence Is Inevitable (Agent)

V=I establishes: if |S| = 1, verification is identification. This document derives what V=I leaves implicit: the loop requires an agent, the agent accumulates certified knowledge irreversibly, and this accumulation makes identification faster. The efficiency gain is intelligence. The accumulation satisfies four axioms (monotonicity, irreversibility, decidability, crystallization) that give it the structure of a phase transition with computable dynamics. The crystallized result is determined by the domain, not the agent.

## §0. From System to Agent

V=I §2–§4 define a system: a function from encodings to {PASS, REJECT}.

A function that is never called computes nothing. The system identifies nothing without input. To operate, the system requires a caller: something that provides encodings.

V=I §1 supplies this: the loop.

```
caller ──> encoding ──> system ──> PASS: identified
  ↑                        │
  └── REJECT(where, why) ──┘
```

The loop has two halves. The inner half (system) is proven: total, deterministic, safe (V=I §5). The outer half — the caller — is the agent.

**The agent IS the outer half of the loop.** Without the agent, there is no loop — only a function with no argument. Without the system, there is no loop — only a source of encodings with no check. Neither half operates alone.

The loop's structure determines the agent's components:

| Component | What it does | What it enables |
|-----------|-------------|----------------|
| Source | Produces encodings from grammar E | Operation. Without it: system has no input, loop does not start. |
| Persistence | Continues until PASS or exhaustion | Convergence. Without it: agent may stop before exhausting E. |
| Receptor | Reads REJECT(where, why) | Directed search. Without it: blind enumeration. |
| Modifier | Changes encoding based on feedback | Directed search. Without it: same as without receptor. |

Source is necessary for the loop to run. Source + Persistence is sufficient for convergence (blind enumeration over finite grammar). All four are necessary for directed search, where the agent uses feedback rather than enumeration.

## §1. One Game, Then Many

§0 established that the loop requires an agent. This section derives what follows when the agent operates the loop: one game always converges (I1 + finite E), certified results are permanent (I3 + Theorem 2), and permanence carries across games (I3 + V=I §5.18). The first two follow from V=I. The third requires one additional premise: the agent encounters more than one game.

**One game.** The agent submits encodings. The system checks. REJECT → modify → resubmit. Grammar is finite (I1). Resubmission of the same encoding is structurally futile: I3 + idempotency (V=I §5.19) guarantee the same result with zero new information. The set of untried encodings shrinks monotonically. Convergence: PASS or grammar exhausted.

One game always terminates. At most N² COMPAREs (V=I Theorem 3). Strategy does not matter here — any ordering reaches the same endpoint, only speed varies.

**Crystallization.** Each PASS converts an agent-path into a system-path. Before PASS, the encoding is the agent's guess: engineering, fallible, no guarantee. After PASS, the verified result inherits the system's guarantee (Theorem 2). Once certified, the result is permanent (I3). For any future task with the same structure, the agent reuses the certified result instead of re-deriving (§2).

This is V=I §5.17 (agent-system duality) applied across time: the system at level N is the agent's tool T2 at level N+1. Each PASS at level N produces a certified object that level N+1 can use as a premise.

**Many games.** The agent persists beyond one game (component 2: persistence). It encounters τ₁, then τ₂, then τ₃. Each game is finite. The sequence is not.

Here intelligence becomes visible: does solving τ₁ make solving τ₂ faster?

I3 answers: yes. The cache is append-only. Knowledge gained from τ₁ cannot be lost before τ₂. The agent carries its full history into every future game, and each PASS in that history is certified (Theorem 2).

## §2. What Accumulates

**I3 for the agent.** V=I derives I3 for the system: COMPARE is a pure function of fixed inputs, results cannot change, retraction is impossible (V=I §2.4). The agent operates in the same space. Its knowledge state (COMPARE results, REJECT diagnostics, PASS solutions) consists of facts about finite structures in Σ. These facts are determined by the structures themselves (V=I §5.20). Once revealed, they cannot un-reveal. I3 for the agent is the same I3, applied to the same structures, by the same argument. The agent's strategy state (position in grammar, encoding order, selection heuristics) does not inherit I3 — it is mutable and resets between runs. Only knowledge accumulates irreversibly.

**Uniform operator.** Every feature in V=I is a structural predicate computed via COMPARE. `same_row(o, i) = COMPARE(row(o), row(i))`. `rank(i, I) = count_less(val(i), vals(I))`, itself a series of COMPAREs. There is no hierarchy of feature types. Positional features, value features, pattern features are all COMPARE applied at different scope. The operator is uniform; scope of reuse differs.

**Levels.** Not all records are equally useful across games. V=I operates on finite binary trees with hierarchical structure: parts (PAIR) have parts, down to leaves (NULL). COMPAREs at different levels of this hierarchy have different scope:

| Level | What is compared | Scope | Across games |
|-------|-----------------|-------|-------------|
| 0 | Values: COMPARE(val(a), val(b)) | Per-task | No transfer. Different tasks, different values. |
| 1 | Positions: COMPARE(row(a), row(b)) | Per-encoding | Transfers. Same encoding → same positions. |
| 2 | Rules: COMPARE(rule(τ₁), rule(τ₂)) | Per-rule-class | Transfers. Same rule → same solution method. |

Level 0 knowledge is disposable. Each task has its own input and output atoms with its own values. COMPARE(val(a), val(b)) in τ₁ says nothing about the values in τ₂ — they are different atoms.

Level 1 knowledge persists across all tasks under the same encoding. The encoding defines positions (rows, columns, spatial relationships). These do not change between tasks. Any structural fact about positions, once established, holds for every future task under that encoding.

Level 2 knowledge persists across tasks with the same rule structure. A solution that works for one task of a given type works for all tasks of that type.

The agent's useful growth is concentrated at levels 1 and 2. Level 0 is rebuilt from scratch for each task. Levels 1–2 accumulate irreversibly.

**Signature.** When the agent solves a game, V=I §4.5 extracts a rule: a conjunction of consistent, informative features. This rule is a structure in Σ, a finite binary tree encoding which features held across all equations. Two games have the same signature when their extracted rules are structurally identical: COMPARE(rule(τ₁), rule(τ₂)) = equal.

**Definition.** A rule class is the set of all tasks in D whose extracted rules are structurally identical. K = |rule classes in D|.

The agent's library L is a set of pairs {(rule₁, encoding₁), ..., (ruleₖ, encodingₖ)}, each a certified solution (§1: crystallization). L is a finite set of structures in Σ. It inherits I1 (finite) and I3 (append-only: entries are added, never removed).

**Pre-solve matching.** Given a new task τ, the agent does not need to solve it from scratch. Features (V=I §4.4) are structural predicates computable from COMPARE and projection; they can be extracted from the new task's equations cheaply. The agent compares these features against stored rules in L. If COMPARE finds a match, apply the stored rule and submit to compilation (V=I §4.7). Compilation is the guarantee: if it passes, Theorem 2 applies regardless of how the rule was found. If compilation fails, the match was wrong; try the next entry or fall back to full extraction.

The compilation gate makes pre-solve matching safe: a wrong match costs one compilation check and produces REJECT, not a wrong answer.

**Why transfer works.** A rule is a recipe: `same_row ∧ col_mirror` stores "for each output position, find the input atom at the same row and mirror column." When applied to a new task, every feature is recomputed on the new task's data. same_row checks the new rows, rank counts the new values. The recipe remembers which structural relations to check, and recomputes them from scratch.

This is why a rule certified on τ₁ can pass compilation on τ₂: the recipe describes the transformation. If τ₂ has the same transformation, the same structural relations hold, and compilation passes. If τ₂ has a different transformation, or if the task is ambiguous (|S| > 1, R4 fails), compilation rejects.

## §3. Intelligence

**Definitions.**

| Symbol | Meaning |
|--------|---------|
| τ | A single task (V=I game) |
| D | A finite set of tasks the agent encounters. D is fixed for a given analysis |
| P | A protocol: the agent's strategy for selecting and ordering encodings |
| T_min(τ) | Minimum COMPAREs to reach \|S\| ≤ 1 on task τ. Property of the task |
| T_actual(P, τ) | Total COMPAREs protocol P uses to reach \|S\| ≤ 1 on task τ |
| T_brute | Upper bound on T_actual for any task under brute-force enumeration. T_brute ≤ N² (Theorem 3) |
| F | Number of features per rule in the current encoding |
| K | Number of rule classes in D (§2: signature) |

**Definition.** Intelligence of protocol P on task τ:

```
η(P, τ) = T_min(τ) / T_actual(P, τ)
```

η ∈ (0, 1]. Shannon: any decision tree identifying all targets from |S₀| candidates has depth ≥ ⌈log₂|S₀|⌉; per-target T_min can be shorter when a single feature distinguishes the target from many candidates. Bounded above: T_min ≤ N² (Theorem 3). Computable (I1: finite space, finite decision trees). Substrate-independent. η is the natural measure here: the Saturation Theorem proves T_actual decreases, and η = T_min / T_actual directly reflects that decrease.

T_min is computable but expensive: finding the optimal decision tree over COMPAREs is NP-hard in the general case. An agent that has saturated D (theorem below) can compute T_min for any task in D, because it has the complete map. Before saturation, only bounds are available.

(η is used to avoid confusion with I1, I2, I3.)

**On a single game:** η is a fixed number. No dynamics. Any protocol achieves some η and the game ends.

**Lookup.** T_actual depends on what is already in library L:

- For a task matching a stored rule: compare features of τ against each entry in L. Cost: O(|L| × F) COMPAREs. If match found → apply stored rule → compilation check: 1 pipeline execution. If PASS → done. Total: O(|L| × F) + 1.
- No match or compilation fails → full extraction. Cost: O(|L| × F) + T_brute.

Lookup cost is O(|L| × F), linear in library size and feature count. Both are finite (I1). For fixed D, |L| ≤ K, so lookup is bounded by O(K × F), a constant for fixed D.

**Theorem (Saturation).** For any finite domain D under encoding E, let D_id ⊆ D be the tasks for which |S| = 1 (identifiable under E). After at most K tasks (one per rule class in D_id), the agent's library contains a certified rule for every class in D_id. For all subsequent identifiable tasks in D: T_actual ≤ O(K × F) + 1.

*Proof.* D_id is finite → K is finite. Each solved task whose rule is new adds one rule class to L (I3: append-only; §1: crystallization, each PASS is certified). After K tasks with distinct rules, every class in D_id is covered. For any future identifiable task τ from D, feature extraction + COMPARE against L finds a match (all classes covered). Apply stored rule. The rule is a structural predicate recomputed on τ's data (§2: why transfer works); since τ shares the same transformation as the original task in this class, compilation passes. T_actual = O(K × F) + 1. Tasks with |S| > 1 or |S| = 0 produce diagnostic output (§4: completeness boundary). QED

*Corollary (efficiency gain).* Before saturation, T_actual = O(T_brute) per task. After saturation, T_actual = O(K × F) + 1 per task. The improvement factor is T_brute / (K × F + 1). Saturation is beneficial when solving from scratch costs much more than lookup: T_brute >> K × F.

*Corollary (saturation cost).* Time to saturation ≤ K × T_brute (K tasks at brute-force cost each). After that: effectively constant cost per task.

*Corollary (η after saturation).* After saturation, η(P, τ) = T_min(τ) / (O(K × F) + 1) for all τ in D_id. Since T_min ≤ T_actual by definition, and both are bounded, η is well-defined and near-maximal when K × F is small relative to T_min.

Before saturation: η may not increase monotonically per task (wrong matches in L add cost). After saturation: η is at its maximum for D_id under E. Saturation is inevitable: I3 guarantees the library covers one more class with each new-class task, and D_id has finitely many classes.

*Remark (diversity).* Saturation requires K distinct rule classes. K copies of the same rule class add no entries to L. The rate of saturation depends on task diversity: an agent encountering the same task type repeatedly does not progress toward coverage.

*Remark (between-domain transfer).* If domains D₁ and D₂ share rule classes under the same encoding E, the agent's library from D₁ carries to D₂ for shared classes. The compilation gate verifies: if a rule from L₁ passes compilation on a D₂ task, it transfers. No new axiom needed — this is the Saturation Theorem applied to D₁ ∪ D₂.

**What the library stores.** Certified paths. Each entry passed compilation (Theorem 2) and is permanent (I3). Correctness of every entry in L is unconditional (Theorem 2: PASS → f' = f*).

**Completion.** The transition from |L| < K to |L| = K is discrete: one PASS adds the final rule class. Before completion: some tasks in D_id require full derivation. After: all resolve via lookup. This transition is:

| Property | Source |
|----------|--------|
| Discrete | One entry separates partial from total coverage |
| Deterministic | The same D and E produce the same completed library (SAT5, SAT6) |
| Inevitable | I3 guarantees each new-class task adds one entry; D_id is finite |
| Irreversible | I3 prevents entry loss; the completed library cannot regress |

Before completion, the agent's capabilities cover |L|/K of D_id's rule classes. After, capabilities are total within D_id. The shift from partial to total occurs at a single PASS. The library either covers D_id or it does not.

**Uniqueness of the saturated library.** A saturated library is a deterministic structure. Given the same domain D and encoding E, any agent — regardless of protocol, ordering, or history — arrives at a library with the same entries (V=I §5.26: SAT5, SAT6). The library's content is determined by the domain, not by the agent.

This follows from three facts: (1) each entry is the unique f\* for its rule class (Theorem 2), (2) correctness is order-invariant (V=I §5.25), (3) entries are permanent (I3). Two agents processing the same domain produce libraries that differ only in insertion order.

The conditions for this are: finite space (I1), decidable check (I2), permanent record (I3). Break any one and the property fails:

| Condition broken | Consequence |
|-----------------|-------------|
| I1 (finite) | Space is unbounded; saturation never completes |
| I2 (decidable) | Verification may not halt; entries may be wrong |
| I3 (append-only) | Results can be retracted; entries may be lost |

**Comparison with mutable-state accumulation.** A gradient-trained model operates without I3. Weights are mutable: each training step overwrites previous values. Catastrophic forgetting is the structural consequence of mutable state. Without I3, the cache is not append-only. Without append-only, saturation is not guaranteed (V=I §5.22 breaks: eliminated candidates can re-enter S). Without guaranteed saturation, the accumulation has no convergence proof.

Consequences: (1) different training seeds produce different weights — the result is not unique; (2) no entry carries a proof — the result is not certified; (3) continued training changes all entries — the result is not permanent; (4) the system always produces an output, even when the answer is unknown — honest REJECT is absent.

The architectural difference is one property: I3. An approximate model can serve as the agent's Source component (§0). Correctness depends on the compilation gate, not the source (Theorem 2).

## §4. Boundaries

Intelligence is inevitable within an encoding. It is not inevitable in general. The boundaries:

**Encoding boundary.** No transfer between encodings. Different encoding → different positions → different features → level 1–2 cache is useless. On a new encoding, the agent starts from zero.

**Meta-saturation (softening the encoding boundary).** The encoding boundary is a wall at level 1. But encoding selection satisfies the conditions of the Saturation Theorem at level 2. Space = E (finite grammar). Check = run(task, encoding).status (decidable, V=I §5.5). Cache = append-only (I3, by the same argument as §2). This is search-with-memory over a finite space, not identification of a unique f\* — multiple encodings may produce PASS for the same task. The agent needs any one. After encountering enough task types, the agent learns which encoding works for which task type — and the encoding boundary softens from wall to lookup.

The tower is finite (V=I §5.16). Saturation applies at every level by the same argument: finite space + decidable check + I3 → inevitable coverage. Each level's saturation extends the reach of the next. But the cost grows: the space at level N+1 is derived from level N's space, typically exponentially larger. Level 1 saturation is cheap. Level 2 is expensive. Higher levels may exceed any practical budget.

**NP-hard boundary.** T_min is the depth of the optimal decision tree over COMPAREs. Computing optimal decision trees is NP-hard in general. The agent can achieve η = 1 without knowing it — and cannot efficiently verify its own optimality.

**Distribution-relative.** Under a uniform distribution over all possible games with a given encoding, no fixed protocol dominates all others. Intelligence is relative to a distribution. A protocol optimized for D₁ is suboptimal for some D₂. No universally intelligent protocol exists. (This is a structural consequence of the encoding boundary: a protocol's library is tuned to the rule classes it has seen. Rule classes not in D are not covered.)

**Finiteness boundary.** V=I requires I1 (finite space). Infinite domains — continuous variables, unbounded structures — must be encoded finitely. The encoding is a lossy compression. What the encoding discards, the system cannot recover.

**Completeness boundary.** Under a fixed encoding E, tasks with |S| > 1 (ambiguous) or |S| = 0 (no solution) are outside the system's reach. But this is a property of E, not of the task. A task with |S| > 1 under E may have |S| = 1 under a richer encoding E' with more features or more examples. The permanent boundary is the grammar: tasks whose solutions require encodings not in the agent's grammar are outside reach. Tasks whose solutions are expressible in the grammar are reachable through encoding selection (meta-saturation above).

**System closure.** The system operates only on relations between elements within the encoding (V=I §5.23–§5.24). Every feature is COMPARE between elements in Σ; every rule is a conjunction of such COMPAREs. What the encoding does not represent, the system does not see.

## §5. Crystallizing System

§3 proved saturation: the library covers D_id after K tasks. §1 called the mechanism crystallization. This section extracts the axioms that make both work and proves V=I and agent learning satisfy them.

**Definition.** A crystallizing system is a tuple (S₀, {Pₙ}) satisfying A1–A4 below.

S₀ is a set of candidates. {Pₙ} is a sequence of decidable predicates on S₀, finite or infinite. Define Sₙ = {x ∈ S₀ : P₁(x) ∧ ... ∧ Pₙ(x)} — the candidates surviving all predicates up to n.

The sequence may terminate (V=I: finite F, finitely many COMPAREs) or continue indefinitely (RG: infinitely many coarse-graining steps). What matters is whether A4 is reached in finite steps.

| Axiom | Name | Statement |
|-------|------|-----------|
| A1 | Monotonicity | S₀ ⊇ S₁ ⊇ S₂ ⊇ ... Each predicate can only exclude |
| A2 | Irreversibility | Pₙ, once imposed, is never retracted |
| A3 | Decidability | x ∈ Sₙ is decidable for each n |
| A4 | Crystallization | ∃ n : \|Sₙ\| ≤ 1 — the system reaches a terminal state |

A1–A3 are structural prerequisites. A4 is the phase transition. When |Sₙ| = 1, the sole survivor is the crystal. When |Sₙ| = 0, no candidate passes — the system has eliminated everything (V=I: |S| = 0, encoding inconsistent). Both are terminal: the process has converged.

**Lemma 1 (V=I).** The inner pipeline of V=I is a crystallizing system.

*Proof.* S₀ = F, the finite space of candidates (I1). Each COMPARE result defines a predicate Pₙ: "candidate x is consistent with the n-th comparison." V=I §5.22: S is monotonically non-increasing. Each COMPARE can only eliminate candidates from S or leave S unchanged → A1. I3: the cache is append-only. A COMPARE result, once recorded, cannot be retracted → A2. I2: structural equality on finite structures is decidable → A3. Theorem 2 + R4: when |S| = 1 and PASS, f' = f*. For any finite deterministic task, an encoding producing |S| = 1 exists (Theorem 4), so the pipeline reaches |S| ≤ 1 → A4. QED

**Lemma 2 (Agent learning).** Library accumulation under the Saturation Theorem is a crystallizing system.

A1 is defined as shrinkage: S₀ ⊇ S₁ ⊇ S₂ ⊇ ... In Lemma 1 the shrinking object is obvious — S, the candidate set, loses members with each COMPARE. In §3, agent learning is described as L growing: rules are added, the library expands. But A1 requires something that shrinks. To apply the axioms, rewrite the same process from the other side: instead of counting what L has gained, count what L has not yet covered. That set — rule classes in D_id minus rule classes in L — is the one that shrinks. Every new PASS removes one class from it. It never grows back (I3). This is the object Lemma 2 uses as S₀.

*Proof.* S₀ = the set of rule classes in D_id not yet covered by L. This set is finite (I1 + finite D_id → finitely many rule classes). Each solved task whose rule is new defines a predicate Pₙ: "class k is covered." I3 for the agent (§2): entries are never removed from L, so a covered class stays covered. Uncovered classes can only decrease → A1. Covered classes cannot become uncovered → A2. Whether a new task matches an existing entry in L is decidable: compare features of τ against each stored rule, O(K × F) COMPAREs → A3. Saturation Theorem (§3): after K tasks with distinct rules, every class in D_id is covered. |uncovered| = 0 → A4 (terminal state: no candidates remain in S₀). QED

*Remark.* A4 in Lemma 1 terminates at |S| = 1 (one candidate survives). A4 in Lemma 2 terminates at |uncovered| = 0 (no class remains). Both are terminal: no further predicate changes the outcome. Lemma 1 crystallizes an answer. Lemma 2 crystallizes a library.



## §6. Phase Transition

§3 described completion as discrete, deterministic, inevitable, irreversible. This section gives the transition its mathematics.

**Theorem (Saturation time).** Suppose the agent encounters tasks drawn uniformly from K rule classes. The expected number of tasks until saturation:

```
E[τ_sat] = K · Hₖ = K · Σᵢ₌₁ᴷ (1/i) ≈ K · ln(K) + γK
```

where Hₖ is the K-th harmonic number and γ ≈ 0.5772 is the Euler-Mascheroni constant.

*Proof.* After covering k − 1 classes, the probability that the next task belongs to a new class is (K − k + 1)/K. The expected wait for one new class is K/(K − k + 1). Summing over k from 1 to K yields K · Hₖ. This is the coupon collector's problem (de Montmort, 1708). QED

**Corollary (Approach speed).** The probability that the library is incomplete after τ tasks:

```
P(|L| < K after τ) ≤ K · e^(−τ/K)
```

Exponential decay. Crystallization is inevitable, but the last classes cost the most.

**Theorem (Symmetry breaking).** The saturated library L is unique: any two agents processing the same (D, E) produce the same L (§3: SAT5, SAT6). The trajectory to L — which classes are covered in which order — depends on the specific task sequence. Multiple trajectories, one endpoint.

*Proof.* Assume the task distribution has pₖ > 0 for all k (every class can appear). Uniqueness (§3) establishes endpoint invariance: the content of L depends on (D, E), not on the agent or task order. I3 establishes irreversibility: once a class enters L, it stays. The intermediate states L₁ ⊂ L₂ ⊂ ... ⊂ L do depend on which tasks arrived first — agent A seeing class 3 before class 7 has a different L₄ than agent B who saw class 7 first. But both reach the same final L because every class in D_id eventually appears (pₖ > 0) and I3 prevents loss. The set of possible orderings is K! (all permutations of K classes). Each specific history selects one permutation. The endpoint is invariant across all K! paths. This is spontaneous symmetry breaking: the dynamics select one trajectory from a symmetric set, but the fixed point is unique. QED

**Definition.** The universality class of an agent-domain pair is the tuple (K, F, {pₖ}) where K = number of rule classes, F = features per rule, pₖ = frequency of class k in the task distribution. Two domains with isomorphic (K, F, {pₖ}) exhibit identical saturation dynamics: same E[τ_sat], same approach speed, same cost profile. The specific tasks differ; the phase transition is the same.

This is why two unrelated domains — say, visual pattern recognition and natural language syntax — can exhibit the same learning curve: if K, F, and the class frequency distribution match, the saturation dynamics are indistinguishable. The content of the library differs; the cost trajectory does not.

**Remark (Critical slowing down).** Near saturation, when |L| = K − δ, the remaining δ classes are the rarest — otherwise the agent would have encountered them already. The expected wait for the next new class is K/δ. As δ → 1, the wait approaches K. The system slows before it crystallizes. The same effect appears in physical phase transitions as critical slowing down. Here it follows from the coupon collector's tail.

## §7. Discovery

V=I §5.20: COMPARE(a, b) does not create a fact. The result — equal or not_equal — is structurally determined before the call. The trees are already what they are. COMPARE reveals.

The same applies to the pipeline as a whole and to the agent: neither creates the facts they operate on.

**Corollary (Pre-existence).** f* exists before the agent starts. S = {y ∈ F : passes verification} is determined by the task's structure and the encoding's test. The agent's COMPARE sequence does not construct f* — it eliminates every other candidate until f* is the only one left.

**Corollary (Library invariance).** The saturated library L is determined by (D, E), not by the agent (§3: uniqueness). Two agents with different protocols, different orderings, different histories arrive at the same L. The agent reveals L; it does not construct it.

These two corollaries shift the question from "what does the agent build?" to "how efficiently does the agent uncover what is already there?"

**Corollary (Encoding as lens).** The target does not depend on the encoding (V=I §5.14). The encoding determines which distinctions are visible. A richer encoding exposes more structure. A poorer encoding hides it. The structure is invariant; the lens is the variable.

**Corollary (Search as elimination).** V=I §5.22: S shrinks monotonically. The agent starts with all of F and removes what does not survive. The process is subtractive.

## §8. Statement

V=I proves: the system is correct (inner half).

This document proves: intelligence is inevitable (outer half).

The derivation:

1. The system is a function (V=I §2–§4).

2. A function needs a caller → the loop → the agent (§0).

3. The agent operates in Σ. I3 applies to its knowledge state: knowledge accumulates irreversibly (§2).

4. Each PASS certifies: the agent's path becomes a system-path (§1).

5. Certified paths form a library L (§2, §3).

6. Rules transfer: a rule is a recipe recomputed on new data (§2).

7. L grows monotonically (I3). Each new rule class covered is permanent.

8. For finite D: L covers all K identifiable classes under E → T_actual drops to O(K × F) + 1 (§3, theorem). Tasks non-identifiable under E may resolve under a different encoding (§4: meta-saturation).

9. Reducing T_actual relative to T_min is increasing η — the measure of intelligence (§3).

10. This cannot be prevented: I3 is structural, certification is structural, D_id is finite (§3, theorem).

11. The completed library is unique, deterministic, and agent-invariant (§3). Completion is discrete and irreversible.

12. The encoding boundary softens at level 2: encoding selection satisfies the Saturation Theorem conditions (§4).

13. A system without I3 loses uniqueness, certification, and permanence. The architectural difference is one property (§3).

14. The axioms governing crystallization (A1–A4) are satisfied by V=I and by agent learning (§5).

15. Crystallization has computable dynamics: E[τ_sat] = K · Hₖ, exponential approach, symmetry breaking with invariant endpoint (§6).

16. The crystallized library is revealed, never constructed by the agent. f* pre-exists. L is domain-determined. Search is elimination (§7).

Intelligence is a structural consequence of operating a verification loop with an append-only cache over a finite space. Any protocol that runs long enough on a finite grammar becomes more efficient at identification. The only variables are how fast (ordering), within what scope (encoding), and against which distribution (D).

Combined with V=I: the system cannot produce a wrong PASS (Theorem 2), and when identification fails it returns the reason: |S| > 1 (encoding insufficient) or |S| = 0 (no candidate passes). This document adds: saturation is inevitable (I3 + finite D_id), the saturated library's content is determined by the domain, not the agent, and the crystallization follows computable phase transition dynamics.

Every entry is certified (Theorem 2), unique (SAT5/SAT6), and permanent (I3) — properties that generic caching and mutable-state accumulation lack.

> **Intelligence is inevitable. Its crystallization is a phase transition with computable dynamics. The result is determined by the domain.**

