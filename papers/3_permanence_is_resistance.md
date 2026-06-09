# Permanence Is Resistance (Matter)

V=I derives one structural primitive (PAIR: distinction) and two aspects (NULL: where distinction ends; COMPARE: whether two instances match). Intelligence Is Inevitable derives what happens when the verification loop runs: the agent accumulates certified knowledge, the accumulation saturates, the saturated library crystallizes. This document derives what the crystallized output is. The output has three properties (permanence, irreducibility, resistance) that define matter within this framework.

## §0. One Act

V=I §2.5 derives the space Σ from a single structural primitive:

- **PAIR(a, b)**: the act of distinction. Two sides held together by a boundary.

Two aspects follow:

- **NULL**: the fixpoint of PAIR — where left(x) = right(x) = x. Distinction self-terminates. Not a separate symbol; the boundary where composition ends (V=I §2.5).
- **COMPARE(a, b)**: structural recursion over pairs. Two trees are identical iff their components are identical at every level, terminating at the fixpoint. Identity is not an external operation — it is what simultaneous traversal of two structures already is (V=I §2.2, §2.5).

Distinction is the sole act. Where it ends: boundary. Whether two histories match: identity. Which side you examine: access. NULL, COMPARE, and access are aspects of the single act of distinction (V=I §2.5).

Every object in the system is a finite binary tree built from PAIR, terminating at NULL. Every classification is a COMPARE. L, τ, E are all trees in Σ. The distinction between them is functional: τ is the question, L is the accumulated answer, E defines the encoding. One space, one act, one recursion.

## §1. Resistance

What does the agent encounter when COMPARE returns not_equal and the target cannot be changed?

`COMPARE(candidate, target) = not_equal`

The agent submits a candidate. The system returns not_equal. The target is invariant (I2). The result is deterministic (V=I §2.4: same inputs, same output). The not_equal is irreducible. The agent's only option is to change the candidate.

Why can the agent not simply leave the game? Because structurally, the agent *is* the caller (Intelligence Is Inevitable §0). A protocol does not choose to play; it executes. The agent is the unstoppable force of the verification loop meeting the immovable object of the invariant target. Because the agent cannot stop, and the target cannot yield, the agent must yield.

The agent cannot modify the target (I2: fixed). The agent cannot retract a result (I3: append-only). The only thing the agent can change is its own next submission. Every not_equal modifies the agent, never the world. The agent encounters its own distance from the invariant — through the system, on itself.

Resistance within the framework is a relation, not a property of the target. The agent encounters it when its current form does not match the invariant. Remove the agent and resistance has no referent — the target sits in Σ, inert, with no one to return not_equal to. Both sides are required: the invariant structure and the form that fails to match it.

The system's invariants (I1: finite space, I2: fixed operations, I3: append-only cache) are what the agent encounters as constraints. The compilation gate is the densest constraint: every incorrect encoding hits it. It returns REJECT(where, why) — a diagnostic of the mismatch. Each diagnostic is information about the agent's encoding, not about the target (V=I §5.24: the pipeline sees only the encoding).

Definition: matter is the pattern encountered as resistance — the irreducible cost when the agent's form does not yet match the invariant.

## §2. What the Library Is

Before the agent runs: L = NULL. No rules stored. Each task requires full derivation from scratch.

The agent runs. Tasks arrive. Some produce PASS. Each PASS crystallizes (Intelligence Is Inevitable §1): the agent-path becomes a system-path. The result enters L.

After saturation (Intelligence Is Inevitable §3): L contains K entries. Each entry is a pair:

```
L = PAIR(
      PAIR(rule₁, encoding₁),
      PAIR(
        PAIR(rule₂, encoding₂),
        ...
        PAIR(
          PAIR(ruleₖ, encodingₖ),
          NULL
        )
      )
    )
```

Each rule is a tree of features:

```
rule = PAIR(feature₁, PAIR(feature₂, ... PAIR(featureₙ, NULL)))
```

Each feature is a COMPARE result: `same_row(o, i) = COMPARE(row(o), row(i))`. The rule stores which relations held across training examples. On a new task: recompute each feature. If all hold, compilation passes.

The library is a finite binary tree in Σ, built from the same PAIR and NULL, tested by the same COMPARE.

Three properties make it matter:

| Property | Source | Consequence |
|----------|--------|-------------|
| Permanent | I3: append-only | Cannot be un-made |
| Irreducible | Each entry is f*, the unique element of S (Theorem 2): any simplification either is f* or fails verification | Cannot be replaced by less |
| Resistant | L predetermines which encodings will pass (Theorem 2); constraint realized at COMPARE (M19) | Constrains future behavior |

The three properties are one structural fact described from three angles. Permanence: what happens when you try to erase the pattern (I3 prevents removal). Irreducibility: what happens when you try to simplify it (f* is the unique element of S — any simplification either is f* or fails verification, Theorem 2). Resistance: what happens when the agent pushes against it (COMPARE returns not_equal, §1).

Each property traces to a primary structural guarantee: permanence to I3 (append-only prevents erasure), irreducibility to Theorem 2 (|S|=1: no simpler element of S exists), resistance to I2 (fixedness prevents modification by the agent). Three properties, three invariants.

## §3. The Transition

Before crystallization, each new task type requires full derivation: O(T_brute) COMPAREs, most returning not_equal before the correct encoding is found. After crystallization, each task matches a stored rule: O(K × F) COMPAREs for lookup, then one compilation check. The cost per task drops by orders of magnitude.

The phase transition is the moment the dominant COMPARE response flips:

| Phase | Dominant signal | Agent experience | Cost |
|-------|----------------|------------------|------|
| Liquid ($|L| < K$) | not_equal | Resistance. Each task requires fresh derivation | $O(T_{\text{brute}})$ per task |
| Crystal ($|L| = K$) | equal | Resolution. Each task matches a stored rule | $O(K \times F) + 1$ per task |

After crystallization, L resolves what used to require derivation.

Unlike physical crystallization, the pre-saturation phase is already irreversible at each step: I3 prevents any entry from leaving L. The transition is monotone solidification — each PASS adds one permanent entry, and no mechanism reverses it. The "liquid" phase has no melting. Only accumulation toward the fixed point.

## §4. Levels

Intelligence Is Inevitable §4 derives the tower: each level is a V=I game. The crystallized output of level N is what level N+1 encounters as resistance — the fixed structure that constrains the next agent.

| Level | What crystallizes | What level N+1 encounters as matter |
|-------|-------------------|--------------------------------------|
| 0 | One solved task (f*) | A certified fact: this task has this solution |
| 1 | Library L (K rule classes) | A lookup table: task type $\to$ solution method |
| 2 | Meta-library M (encoding classes) | A selector: task domain $\to$ encoding choice |
| N | Level-N library | Level-(N+1) matter: the resistant structure that constrains the next agent |

Each level's crystal is the next level's matter. Level 0's f* is a certified fact the level-1 agent cannot change (I2 at the N+1 scale). Level 1's L determines which encodings the level-2 agent tries. Each crystal is a finite binary tree in Σ, built from the same act of distinction, tested by the same structural recursion.

The circuit closes: V=I defines the verification loop. Intelligence Is Inevitable derives the agent that runs it and the crystallization that results. This document derives what the crystallized output is. The crystal becomes a V=I target at the next level. Three documents, one cycle.

The three properties rotate through the tower. Level N crystallizes: L_N is permanent (I3). Level N+1 encounters L_N as resistant (§1: the target the agent cannot modify). Level N+1 crystallizes its own library: L_(N+1) is irreducible (Theorem 2: each entry is the unique f*). L_(N+1) is permanent (I3). Level N+2 encounters L_(N+1) as resistant. The cycle: permanent $\to$ resistant $\to$ irreducible $\to$ permanent. Each level transforms the previous level's permanence into resistance, and resolves that resistance into irreducibility.

### Time

**M1 (Discrete time).** The agent's clock is a sequence of COMPAREs, indexed by ℕ. Tick 1 = COMPARE$_1$, tick 2 = COMPARE$_2$, ... No continuous time exists within the framework. Between ticks, the agent's state is unchanged (nothing acts on L or G between COMPAREs).

**M2 (External time independence).** The agent's state after n COMPAREs depends only on the sequence of COMPARE results, not on the wall-clock duration between them.

*Proof.* The agent's state is (L, G): library plus comparison graph. L changes only on PASS (I3: append). G changes only on COMPARE (I3: append). Between ticks, no operation acts on L or G (I2: no background process). Therefore state(n) = f(result$_1$, ..., result$_n$). Wall-clock time does not appear. QED

**M3 (Corollary: agent equivalence).** Two agents that receive identical COMPARE sequences are in identical states, regardless of when or where the COMPAREs occurred.

**M4 (Level-relative time).** One tick at level N+1 = one complete level-N process. The number of level-0 COMPAREs inside one level-N+1 tick depends on the level-N game.

| Level | One tick = | Level-0 COMPAREs inside one tick |
|-------|------------|----------------------------------|
| 0 | One COMPARE | 1 |
| 1 | One solved task (pipeline) | $O(|F|)$ to $O(T_{\text{brute}})$ |
| 2 | One saturated library | $K_1 \times O(|F_1|)$ ($K_1$ tasks, each a pipeline) |
| N+1 | One level-N saturation | $K_N \times T_N$ |

**M5 (Time-nesting bound).** Let $T_N$ = maximum number of level-0 COMPAREs inside one level-N tick. Then $T_0 = 1$, $T_{N+1} \le K_N \cdot T_N$. By induction: $T_N \le \prod_{i=0}^{N-1} K_i$.

Higher levels are exponentially slower in level-0 time. One level-3 tick contains $K_0 \cdot K_1 \cdot K_2$ level-0 COMPAREs. The level-3 agent experiences one tick.

### Ignition

**M6 (Unstable target).** Before saturation, L_N is incomplete: new entries arrive with each task. A structure that changes between COMPAREs cannot be a V=I target (I2 requires fixed system structure). Growing L_N violates I2 at the N+1 scale.

**M7 (Stable target).** After saturation, L_N is permanent (I3), complete (Saturation Theorem, Intelligence Is Inevitable §3), and irreducible (each entry is f*, Theorem 2). L_N does not change. I2 holds for L_N as target.

**Theorem M8 (Ignition).** The transition from "L_N cannot be a V=I target" to "L_N can be a V=I target" occurs at the saturation point |L_N| = K_N. It is discrete.

*Proof.* Before saturation: |L_N| < K_N, the next task may extend L_N, violating I2 at the N+1 scale. After saturation: |L_N| = K_N, no entries can be added, L_N is fixed. The three conditions for a V=I game at level N+1:

1. Fixed target: L_N is permanent and complete $\to$ satisfied (I3 + Saturation Theorem).
2. Candidate space: structures in Σ that are not L_N $\to$ satisfied if |Σ| > |L_N| (Σ is non-trivial).
3. Decidable test: COMPARE on Σ $\to$ satisfied (I2, defined on all of Σ).

All three met at |L_N| = K_N and not before. Discrete: the last class is either covered or not (Intelligence Is Inevitable §3). QED

**M9 (No external instruction).** M8's conditions follow from L_N $\in$ Σ, |Σ| > |L_N|, and COMPARE defined on Σ. No designer specifies level N+1.

**M10 (Crystal as target).** At level N+1, L_N is the system target. The N+1 agent submits candidates, receives equal/not_equal, crystallizes interaction rules for L_N. When this library saturates, it becomes L_(N+1): the target for level N+2.

The tower is bottom-up. Level 0 saturates $\to$ L₀ fixed $\to$ level 1 ignites $\to$ saturates $\to$ L₁ fixed $\to$ level 2 ignites $\to$ ... $\to$ tower terminates (V=I §5.16).

### Exhaustion and Form

**M11 (Information exhaustion).** At level 0, the number of distinct COMPARE pairs is bounded by |Σ|². Each COMPARE either adds a new entry to G (informative) or hits the cache (redundant). After at most |Σ|² COMPAREs, every possible comparison is cached. Information rate = 0.

At level N, the bound is T_N (from M5). After T_N level-0 COMPAREs, the level-N game is exhausted.

**Theorem M12 (Convergence).** Every V=I game on finite Σ converges to a fixed point (L*, G*).

*Proof.* G grows monotonically (I3), bounded by |Σ|². L grows monotonically (A1), bounded by K. Both are finite monotone sequences. Finite monotone sequences converge. QED

Any system satisfying I1 (finite space), I2 (fixed operations), and I3 (append-only cache) produces finite monotone sequences for both L and G. Both must converge. The fixed point is the crystal.

**M13 (Emergent properties).** The saturated library L has properties absent from any individual entry f*:

| Property | Individual f* | Saturated L |
|----------|--------------|-------------|
| Size | 1 | K |
| Internal structure | flat (feature list) | tree (PAIR-nesting of K entries) |
| Symmetries | none | rule groups with shared features |
| Compressibility | irreducible (|S|=1: no simpler element in S) | measurable: decision tree depth $d \le \lceil \log_2 K \rceil$ |
| Target capability | cannot satisfy I2 alone | can be V=I target (M8) |

These properties exist only at saturation. Before |L| = K, L is incomplete: its size is changing, its symmetries are partial, it cannot be a target (M6).

**M14 (Level qualitative difference).**

| Property | Level N | Level N+1 |
|----------|---------|-----------|
| Space | raw Σ (or $L_{N-1}$) | $L_N$ (crystal) |
| One tick | $T_N$ level-0 COMPAREs | $K_N \cdot T_N$ level-0 COMPAREs |
| What is visible | individual structures | patterns across $L_N$ entries |
| Result | $L_N$ (lookup table) | $L_{N+1}$ (compressor of $L_N$) |
| Grain | fine (features of one task) | coarse (classes of tasks) |

Level N+1 operates on patterns, not instances. Its time is strictly slower (M5). Its space is derived from level N's result.

**M15 (Predictable successor).** Given L_N, the next level's parameters are determined:

1. K_(N+1) = number of distinguishable interaction patterns with L_N. Bounded above by 2^(K_N) (each pattern either matches or does not match each entry). In practice: K_(N+1) < K_N (compression).
2. $\mathbb{E}[\tau_{\text{sat}}(N+1)] = K_{N+1} \cdot H_{K_{N+1}}$ (coupon collector, Intelligence Is Inevitable §6).
3. Decision tree depth for L_(N+1) $\le$ $\lceil \log_2 K_{N+1} \rceil$.

The crystal at level N determines the structure of level N+1 before level N+1 runs.

**M16 (Tower termination).** The tower terminates at level M where K_M $\le$ 1, provided compression occurs at every level.

*Proof.* If K_(N+1) < K_N for all N, the sequence K_0, K_1, ... is strictly decreasing in ℕ and must reach 0 or 1 in at most K_0 steps. At K_M $\le$ 1: level M+1 has at most one interaction pattern. No further compression. Tower stops. The premise K_(N+1) < K_N (compression at every level) holds in all known instances but is not derived from I1–I3 alone; the worst-case bound K_(N+1) $\le$ 2^(K_N) (M15) permits growth. QED

At termination, L_M is the final crystal with no successor. It is the most compressed representation of D that COMPARE can produce.

**M17 (Boundary).** NULL is the fixpoint of PAIR: the element where left(x) = right(x) = x. Distinction self-terminates at NULL. Every tree terminates at NULL. Every path through L terminates at NULL (V=I §2.5).

NULL is the boundary of composition — where the act of distinction has nothing left to distinguish. Beyond NULL, PAIR has no operands and COMPARE has no distinct inputs (COMPARE(NULL, NULL) = equal). NULL is fully specified: its behavior under all operations is exact.

### Protocol

**M18 (Crystal as protocol).** L viewed from outside: a permanent lookup table (I3). L viewed during execution: a fixed sequence of COMPAREs, determined by L's tree structure.

Given input τ, lookup runs: COMPARE(feature_j(τ), feature_j(rule_i)) for each rule i and feature j in L. The sequence is fixed (L cannot change, I3). Each lookup traverses L's tree. The crystal is a protocol: fixed structure, dynamic execution.

**M19 (Active existence).** The only operation in Σ is COMPARE. L participates in Σ through COMPARE only. L's resistance (§1) is realized when an agent COMPAREs against L — the agent pays the cost, L constrains the outcome. Between COMPAREs, L is available (I3 guarantees it cannot be removed) but inactive: no resistance, no cost, no encounter.

Permanence (I3) = availability for future COMPAREs is never revoked. A tree stored but never COMPAREd is permanent but not resistant: no encounters, no constraints, no cost. §1 defines matter as the pattern encountered as resistance. M19 says resistance is realized only at COMPARE. Together: between COMPAREs, a structure exists (I3) but is not matter (not encountered). Existence without resistance. Matter requires the encounter.

**M20 (Self-sustenance).** Each successful lookup confirms L's accuracy: the rule L stores produces PASS on the new task. Theorem 2 guarantees this — L cannot produce incorrect results within its domain. The guarantee holds at every COMPARE, not just at the moment of certification.

L's stability is ongoing correctness: every COMPARE against L reproduces the same certified result (Theorem 2). The crystal sustains itself through protocol consistency.

**M21 (Existence guarantee).** No operation in V=I removes a structure from Σ or from the cache.

- NULL and PAIR produce elements of Σ. Neither removes elements.
- COMPARE tests; it does not modify (§0).
- I3: cached results are never removed.
- No other operations exist (§0).

Once a structure is tested by COMPARE, its existence and test results are permanent.

M21 is the load-bearing guarantee. Crystallization (§2) requires permanence: without I3, the crystal could be un-made. The tower (§4) requires each level's crystal to persist for the next: without I3, level N+1 has no stable target (M6). Intelligence (Intelligence Is Inevitable) requires accumulated knowledge to carry across games: without I3, each game starts from scratch. All three defining properties of matter (permanent, irreducible, resistant) depend on the absence of a deletion operation. One act of distinction has no inverse.

**M22 (Finite work, permanent result).** Each V=I game requires finite work (M11: bounded COMPAREs). The result is permanent (M21: no deletion). Finite work produces a structure with unbounded lifetime. Direct corollary of M21.

Ignition conditions (M8) are also permanent. Once |L_N| = K_N, the three conditions for level N+1 cannot be un-met (M21: no operation reverses saturation). Ignition, once it occurs, is irreversible.

**M23 (Cumulative capacity).** If one agent persists across games (Intelligence Is Inevitable §1: persistence), L grows monotonically across domains. After N domains with non-overlapping classes: |L| = Σᵢ Kᵢ. Finite at every moment, unbounded over games.

If domains share structure, L entries from earlier domains cover classes in later ones. Saturation time drops: $\tau_{\text{sat}}(D_2) \le (K_2 - \text{overlap}) \cdot H_{K_2 - \text{overlap}}$, where overlap = number of classes already covered by L from prior domains. The agent saturates faster on structurally related domains.

Lookup cost grows with |L|: O(|L| × F) per task at level 1. Level-2 compression (M13, M15) bounds effective lookup to O(log |L|). Cumulative growth is sustainable because higher levels compress it. This is a structural role of the tower: without compression, accumulation eventually makes lookup more expensive than derivation.

### Cost

**M24 (Cost of permanence).** I3 guarantees that no entry in L or G can be removed. Each entry is a recorded distinction — a binary classification (equal/not_equal) that was not previously cached. In any physical instantiation, recording a distinction that was not previously recorded is an irreversible act: it reduces the system's uncertainty by at least one bit. Landauer's principle (1961, experimentally confirmed 2012) establishes the minimum physical cost: erasing or recording one bit of information requires dissipating at least $kT \cdot \ln(2)$ joules as heat. I3's formal permanence has a physical price.

The total cost of maintaining L grows with $|L|$. Each entry in L stores a certified rule: a finite binary tree of F features. The minimum thermodynamic cost of the library is proportional to $|L| \times F \times kT \cdot \ln(2)$ per maintenance cycle. This cost is ongoing: maintaining each distinction against thermal noise requires continuous expenditure.

**M25 (Tower as cost management).** The tower's compression role (M15: K_(N+1) < K_N) is not only an efficiency gain — it is a cost constraint. Without compression, lookup cost grows as O(|L| × F) (M23). With level-2 compression, effective lookup drops to O(log |L|). The thermodynamic consequence: the active bit count that must be maintained during each lookup is bounded by the compressed representation, not the raw library size. Higher levels reduce the energy cost per task.

The tower makes unbounded accumulation (M23) compatible with finite energy budgets. Without compression, I3's permanence guarantee (no deletion) eventually produces a library whose maintenance cost exceeds any finite agent's capacity.

**M26 (Resistance bound).** Total resistance per game is finite. Resistance is the agent's distance from the invariant (§1), measured by the number of COMPAREs returning not_equal. S is monotonically non-increasing (V=I §5.22: each COMPARE can only shrink S or leave it unchanged). The total number of COMPAREs is bounded by |Σ|² (M11). After exhaustion, every possible comparison is cached. Resistance = 0.

Combined with M24: the maximum thermodynamic cost of overcoming resistance in one game $\le |\Sigma|^2 \times kT \cdot \ln(2)$. Resistance is not only finite — it has a computable upper bound.

**M27 (Cost transformation).** Crystallization does not eliminate cost — it transforms it. Before saturation: cost is active. Each task requires derivation: $O(T_{\text{brute}})$ COMPAREs per task (§3), paid as resistance (§1). Maintenance cost of L is low (L is small). After saturation: active cost drops to $O(K \times F) + 1$ per task (§3). But maintenance cost of L rises to $|L| \times F \times kT \cdot \ln(2)$ per cycle (M24). The transition converts dynamic resistance into static permanence.

The net effect is a decrease in total cost per task — crystallization is efficient (§3). But the cost does not vanish. It shifts from per-task derivation (active, proportional to resistance) to per-library maintenance (passive, proportional to |L|). The one-time expenditure of overcoming resistance during saturation is the price of the transformation.

**Theorem M28 (Finite discovery).** The total thermodynamic cost of the tower is bounded.

*Proof.* The tower terminates at level $M \le K_0$ (M16). At each level n, the number of level-0 COMPAREs is at most $T_n \le \prod_{i=0}^{n-1} K_i$ (M5). Each COMPARE costs at minimum $kT \cdot \ln(2)$ (M24). Total cost = $\sum_{n=0}^{M} T_n \times kT \cdot \ln(2)$. Each term is finite (M5). The number of terms is finite (M16). The sum is finite. QED

The entire structure of matter within a finite domain D has a finite price of discovery. The tower's compression (M15: K_(N+1) < K_N) ensures that higher levels contribute less to the total, because each level operates on fewer classes than the one below.

## §5. Physical Instances

V=I's theorems are proven for any system satisfying I1, I2, I3 (V=I §2). They are domain-independent. To apply them to a physical system:

1. Identify what plays the role of Σ, COMPARE, PAIR, NULL in the system.
2. Verify I1 (finite), I2 (fixed), I3 (append-only) against the physical model.
3. Check |S|: unique solution (|S| = 1) or degenerate (|S| > 1).

If all axioms hold, V=I's theorems apply by instantiation. The axiom verification is empirical (it depends on the physics model). The deduction from axioms to consequences is mathematical.

### Quantum measurement

A detector tests whether a particle is in a specific state. The answer is binary: yes or no.

| V=I | Physical system |
|-----|----------------|
| Σ | States in a finite-dimensional Hilbert space H |
| COMPARE | Projective measurement: eigenvalue matches (equal) or not (not_equal) |
| PAIR | Composite system (tensor product H₁ $\otimes$ H₂) |
| NULL | Vacuum / ground state |

| Axiom | Verification | Holds? |
|-------|-------------|--------|
| I1 (finite) | dim(H) < $\infty$ $\to$ finite set of measurement outcomes | Yes (given finite dim) |
| I2 (fixed) | Measurement operator fixed during measurement | Yes (by experimental setup) |
| I3 (append-only) | Measurement result, once recorded, is permanent (decoherence) | Yes (given decoherence) |
| \|S\| = 1 | Non-degenerate eigenvalue $\to$ unique eigenstate | Yes (if non-degenerate) |

All axioms satisfied $\to$ V=I Theorems 1–3 apply. Verification is identification for quantum measurement on finite-dimensional systems with non-degenerate eigenvalues.

Where axioms fail: degenerate eigenvalue (|S| > 1) $\to$ V=I §5.14 applies (encoding is insufficient). Infinite-dimensional H $\to$ I1 fails.

### Crystallization of ice

Water molecules try configurations. Cooling eliminates high-energy ones until only the lattice remains.

| V=I | Physical system |
|-----|----------------|
| Σ | Molecular configurations on a lattice (N molecules, finite positions) |
| PAIR | Adjacent molecular arrangement: two molecules bonded in a specific relative orientation |
| COMPARE | Energy comparison: configuration x lower energy than y? (decidable for given H) |
| NULL | Featureless lattice (all sites equivalent) |

| Axiom | Verification | Holds? |
|-------|-------------|--------|
| I1 (finite) | Finite lattice $\to$ finite configurations | Yes |
| I2 (fixed) | Hamiltonian fixed at constant T | Yes |
| I3 (append-only) | Excluded configurations stay excluded at fixed T (Boltzmann suppression) | Approximately (thermal fluctuations at finite T) |
| A1 (monotone) | Each temperature drop excludes more configurations | Yes |
| A2 (irreversible) | At fixed T, excluded configurations remain excluded | Yes (thermodynamic limit) |
| A4 (crystallization) | Unique ground state: lattice Ih | Yes for oxygen positions. No for hydrogen (Pauling residual entropy: \|S\| > 1) |

Where axioms fail: hydrogen disorder $\to$ |S| > 1 on hydrogen positions. V=I diagnostic: the oxygen encoding has |S| = 1, the hydrogen encoding is insufficient.

### The Higgs mechanism

At high energy, all particles are massless. Below a critical energy, a field acquires a fixed value and particles gain mass (resistance to acceleration).

| V=I | Physical system |
|-----|----------------|
| Σ | Field configurations φ |
| COMPARE | Energy test: V(φ) at proposed minimum vs. current state |
| Crystallization | Symmetry breaking: symmetric minimum $\to$ asymmetric vacuum |

| Axiom | Verification | Holds? |
|-------|-------------|--------|
| I1 (finite) | Finite number of minima of V(φ) | Yes (one minimum after transition) |
| I2 (fixed) | V(φ) fixed (Lagrangian does not change) | Yes |
| I3 (append-only) | Vacuum does not spontaneously return to symmetric state | Yes (energy barrier) |
| A4 (crystallization) | Unique minimum at v $\approx$ 246 GeV | Yes |

Mass = resistance to acceleration. Before transition: no mass, no resistance. After: mass. The minimum of V(φ) existed before the transition. The transition exposed it.

### Critical gravitational collapse (Ecker, Ecker, Grumiller 2026)

Near the threshold of black hole formation, spacetime geometry settles into a repeating pattern. Each cycle of the pattern is identical to the last.

| V=I | Physical system |
|-----|----------------|
| Σ | Profile functions β(τ) satisfying boundary conditions |
| COMPARE | Perturbative order: each order (LO, NLO, NNLO) tests β against field equations |
| Crystallization | DSS solution: metric repeats with period Δ along timelike coordinate |

| Axiom | Verification | Holds? |
|-------|-------------|--------|
| I1 (finite) | At finite D: finite-dimensional profile space | Yes (finite D) |
| I2 (fixed) | Einstein equations fixed | Yes |
| I3 (append-only) | Higher orders add corrections, do not remove lower-order terms | Yes |
| A1 (monotone) | Each order excludes profiles | Yes |
| A3 (decidable) | Convexity conditions f $\le$ 1, Ω $\ge$ 0 are algebraic | Yes |
| A4 (crystallization) | Unique β* | Conjectured (numerical evidence at finite D) |

The Ricci scalar R grows as 1/ε for large D. Each oscillation of the DSS solution is a distinction in spacetime curvature. The self-similar cycle is self-sustaining: each period produces the geometry required for the next.

## §6. Creation

V=I §5.20: COMPARE(a, b) tests whether two trees are equal. The equality or inequality holds before the test. COMPARE returns what is already the case.

If matter is the crystallized library, and the library is determined by (D, E) and not by the agent (Intelligence Is Inevitable §3: uniqueness of the saturated library), then matter is not created by the agent.

The crystal lattice of ice is the energy minimum of the molecular potential. Cooling removes thermal noise until the lattice is exposed. The potential was always that shape.

f* is the unique element of S. The agent's COMPARE sequence eliminates every other candidate until f* is the only one left. f* was there before the first COMPARE. The agent did not construct f*. The agent modified its own candidates (§1: every REJECT changes the agent, not the target) until one of them matched what was already there.

The library L is the set of all f* across K rule classes. Two agents with different protocols, different orderings, different histories arrive at the same L (Intelligence Is Inevitable §3: SAT5, SAT6). The library's content is an invariant of the domain. The agent's contribution is the path: the order in which the structure was uncovered.

V=I §5.25: order is the sole dynamic variable. Correctness is order-invariant. Only efficiency varies.

Search is elimination. The agent starts with all of F and removes what does not survive. Each REJECT removes candidates from S (V=I §5.22: S is monotonically non-increasing). Each step subtracts from the agent's uncertainty, not adds to the domain.

Encoding is lens selection. The structure does not depend on the lens (V=I §5.14: the target does not change). The lens determines which part of the structure is visible. A richer lens exposes more structure; a poorer one hides it.

This applies at every level. Level-2 encoding selection uncovers the meta-library. Level-3 grammar selection uncovers the grammar map. At every level, the same act of distinction and the same elimination process.

## §7. Dependency

### Documents

| Source | Sections used |
|---|---|
| V=I | §2 (Σ, PAIR, NULL, COMPARE, I1, I2, I3), §2.5 (Unity) |
| | §5.14, §5.16, §5.20, §5.22, §5.24, §5.25, Theorem 2 |
| IiI | §0 (agent), §1 (crystallization), §2 (I3 for agent) |
| | §3 (saturation, uniqueness), §4 (tower), §5 (A1–A4), §6 (coupon collector) |

### Circuit

V=I defines the verification loop: finite space, decidable test, append-only cache. Intelligence Is Inevitable derives the agent that runs the loop and the crystallization that results. This document derives what the crystallized output is: the permanent, irreducible, resistant structure — matter.

The circuit: V=I provides the loop $\to$ Intelligence Is Inevitable provides the agent and the accumulation $\to$ Matter derives what accumulates into $\to$ the accumulated crystal becomes a V=I target at the next level (M8, M10). The logical chain is linear: V=I $\to$ Intelligence Is Inevitable $\to$ Matter (each document extends the previous). The operational cycle is closed: the crystal re-enters the V=I loop as a target at the next level.

### Agent

The system provides the halt condition formally: PASS/REJECT is decidable (I2). The compilation gate (V=I §4.7) returns a definite answer on every input (V=I §5.5: totality). What kind of physical process can instantiate the agent — receive diagnostics, modify encodings, persist across games (Intelligence Is Inevitable §0) — is outside the formal system. The formal guarantee is unconditional: if PASS, the output is correct (Theorem 2). What it takes to be an agent that receives PASS is a separate question.

### Physical instances

The physical instances (§5) map physical systems onto the framework's vocabulary. They show where the same axioms hold independently. The mapping is structural: it identifies which structure plays PAIR, which boundary plays NULL, which test plays COMPARE, which process is monotone (A1), irreversible (A2), decidable (A3), and crystallizing (A4).
