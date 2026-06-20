# Law Is Target (Dynamics)

The framework demands a fixed target: I2. A dynamic environment — a state that moves between comparisons — violates it directly, and the violation has stood as the series' explicit boundary since Permanence Is Resistance M6: a structure that changes cannot be a V=I target. This document removes the boundary by relocating the target. The state is not the target; the law is. In a finite deterministic environment the transition law is a finite structure in Σ (LT2); observed transitions are example pairs; identifying the law is an ordinary V=I game with every guarantee intact (LT4), and ambiguity returns as an exploration address — the diagnostic names which experiment to run next (LT5). Once the law is certified, motion becomes substrate: the state space under the law is a graph, a goal is a ball, and planning is greedy descent — the entire navigation stack applies by substitution (LT10–LT12). Trajectories are structures, so behavior acquires a norm and a metric (LT7–LT8); certified sub-plans are strategy objects in the sense of Order Is Object, so motor skills are balls in plan space (LT13). Interactive tasks decompose into identify-then-navigate (LT14). The closing move: if the law itself drifts lawfully, the meta-law is the fixed target, recursively — a world is learnable exactly when it is lawful at some finite level (LT15). I2 never asked the world to stand still. It asked the test to be of something fixed, and the law is the fixed thing about a moving world.

## §0. Derivation

No new postulate. One new premise, stated openly: the environment is finite and deterministic (relaxations and their honest failures in §6).

1. I2 requires a fixed target. A moving state is not fixed. *[V=I §2.4; PiR M6]*
2. The state moves lawfully: s′ = f(s, a) for a deterministic transition function f over finite states and actions. f itself does not move. *[premise]*
3. A function over finite domains is a finite table; a finite table is a finite structure in Σ. *[I1; V=I §2.1]*
4. Observed transitions (s, a, s′) are example pairs of a game whose target is f. *[V=I §3.1]*
5. The candidate space — transition functions consistent with the agent's encoding — is finite. *[I1; V=I §3.3]*
6. Verification is decidable: apply the candidate law to (s, a), COMPARE with the observed s′. *[V=I §2.2]*
7. R4 is decidable and its failure is addressed: |S| > 1 names the unobserved transitions that distinguish survivors. *[V=I §3.6; LT5]*
8. The certified f\* is permanent (I3) and therefore a legal fixed substrate for everything downstream. *[I3; PiR M7]*
9. Under f\*, the state space is a finite labeled graph; goals are balls; plans are descents. The navigation theorems apply by substitution. *[NiG N1–N19; DiC G7]*
10. Trajectories are finite trees in Σ: behavior has a norm and a metric. *[DiC G1a, G2]*

The framework's prior papers identified rules of static transformations. A law is a rule whose examples arrive in time. Nothing in Theorems 1–5 referenced when the examples arrive.

## §1. The Law as Structure

**LT1 (Environment).** A finite deterministic environment is a triple (St, A, f): finite state set St, finite action set A, transition function f : St × A → St. Observation is the full state (partial observability: §6). All three components are finite (I1).

**LT2 (The law lives in Σ).** f is a finite function; a finite function encodes as a lookup structure — a tree of PAIR((s, a), s′) entries terminating at NULL (V=I §2.1, the same move as the library's own encoding, PiR §2). Therefore:

- ‖f‖ is defined (G1a): the law's maintenance cost. Simple dynamics are literally cheaper to exist; a law expressible through few features has small norm.
- W(f₁, f₂) is defined (G2): the distance between dynamics — the work to re-form one law into the other, disagreeing transition cells each counted with the magnitude of their disagreement. Environment transfer becomes a measurable quantity before any transfer is attempted.

**LT3 (Relocation).** The state violates I2; the law satisfies it. PiR M6 stands untouched — a growing or moving structure cannot be a target — and is bypassed: the moving thing was never the right target. The framework requires the *test* to be of something fixed (I2: fixed operations, fixed target). The law is what is fixed about a moving world. Relocating the target from state to law is the entire content of this document; everything after is inheritance.

## §2. Identification

**LT4 (The transition game).** Examples: observed transitions {((sᵢ, aᵢ), s′ᵢ)}. Test input: any (s, a) pair. Candidate space F_dyn: transition functions expressible in the agent's encoding (the agent supplies features over states and actions, exactly as over grids — V=I §1). Gate: for every observed transition, apply the candidate and COMPARE with the recorded outcome. Theorems 1–5 apply unchanged: they reference finiteness, decidability, and the append-only cache — never the semantics of the structures. A PASS-ed law is certified consistent with every witnessed transition; under R4 it is THE law (Theorem 2).

**LT5 (Ambiguity is an exploration address).** |S| > 1 holds iff some (s, a) cell on which surviving candidates disagree is unobserved.

*Proof.* If all distinguishing cells were observed, the gate would have eliminated all but one candidate (disagreement on an observed cell is a failed COMPARE). Conversely, if an unobserved distinguishing cell exists, both candidates pass every observed check. QED

The diagnostic is constructive: the system returns the distinguishing cells — WHICH state to reach, WHICH action to try there. Exploration is not a policy bolted onto the agent; it is the |S| > 1 diagnostic read back as an experiment plan. This is the dynamics-level instance of the series' one pattern: the failure names its own cure (V=I §1: REJECT carries the address; NiG N17: holes are the curriculum; here: ambiguity is the experiment design).

**LT6 (Convergence).** Each observed transition can only shrink S (V=I §5.22, verbatim — a new fact eliminates or leaves). The brute bound: |St| × |A| observations witness every cell and force |S| = 1 under any injective encoding. The structured case is the interesting one: a law expressible as a conjunction of features (objects persist; motion continues until collision; color is conserved) is pinned by as many transitions as the features need — the table compresses exactly as rules compress (V=I §4.5), and few transitions identify a whole family of cells. The gap between the brute bound and the achieved count is the law's compressibility, measured in experiments saved.

## §3. Behavior as Structure

**LT7 (Trajectory).** A bounded-horizon trajectory T = (s₀, a₀, s₁, a₁, ..., s_h) is a finite sequence over finite alphabets: a finite tree in Σ. Behavior is a structure. Two consequences are immediate: ‖T‖ — the cost of a behavior's existence — and W(T₁, T₂) — the distance between behaviors, computable by one traversal (G2a).

**LT8 (Behavioral inertia).** Changing an in-progress plan from trajectory T₁ to T₂ requires at least W(T₁, T₂) ticks: one distinction per tick (PiR M1; DiD S19; DiC G14). Behavioral inertia is structural inertia at the trajectory scale — the same quantity, the same units, no new definition. An agent mid-plan resists redirection in exact proportion to how much of its committed trajectory must be re-formed.

**LT9 (Prediction is execution).** Given certified f\*, a start state, and an action sequence, the future trajectory is computed by iterated application — predicted by execution, not estimation. The certificate's honest scope: Theorem 2 certifies f\* on the evidence closure — the cells witnessed or pinned by the encoding's features under R4. Within that closure, prediction cannot be wrong (a wrong prediction would witness a cell where f\* disagrees with the world, contradicting the gate). Outside it, |S| > 1 was the standing diagnostic, and the framework said so before the prediction was attempted. The system does not extrapolate silently; it either certifies or names the missing experiment (LT5).

## §4. Planning Is Navigation

**LT10 (The state graph).** Under certified f\*, define Γ_state = (St, E) with action-labeled edges s →ᵃ f\*(s, a). Finite (I1), computed from f\* without further interaction — the agent plans offline on the crystal of its own experiments.

**LT11 (Goals are balls).** A goal is a target region B(g, r) under W on states. For grid worlds the metric is already derived: taxicab (DiC G7) — proximity to the goal is a theorem of the encoding, not a designed reward. No reward function is supplied anywhere in this document; the gradient toward the goal is the W-gradient, and it comes from the same primitives as everything else.

**LT12 (Planning is greedy descent).** A plan is a walk in Γ_state decreasing W(·, g). The navigation stack applies by substitution (L → St, library entries → states, edges → actions):

| NiG statement | Dynamics reading |
|---|---|
| N5 (ballistic termination) | a strictly-approaching plan reaches the goal in ≤ W(s₀, g) steps |
| N6 (holes with addresses) | a stuck state = no action decreases W — an obstacle or trap, located and named |
| N7 (decidability) | reachability of every goal from every state is decidable, offline |
| N8 (monotonicity) | richer action sets strictly reduce traps — adding an action never creates one |
| N9 (threshold) | the minimal action-reach at which the world is fully navigable exists and is computable |
| N15–N16 (permanent repair) | a trap repaired — by a new action, a waypoint, a macro — stays repaired (I3) |
| N17 (failure curriculum) | the traps name which capabilities to acquire next |

Local minima of W are exactly the states where greedy locomotion fails — walls, dead ends, puzzles. The framework does not promise their absence; it promises their addresses.

**LT13 (Macro-actions are strategies — the papers compose).** A certified sub-plan — a region of states, an action sequence, a guaranteed arrival region under f\* — is a strategy object in the sense of Order Is Object: a finite decision tree over observations (states) choosing moves (actions), certifiable by the strategy gate (O5) with cost = plan length, entering the library with norm and distance (O2). Therefore the whole of OiO applies: motor skills are balls in plan space (O15); skill space is navigable when it clusters (O16); the optimal certification order of motor skills is computable (O21). Identification (papers 1–6), navigation (7), strategy (8), and dynamics (9) compose on shared primitives with no new axioms: a skill learned in one region of one environment transfers to any (region, environment) pair within measured W — both distances already defined (LT2, O14).

**LT14 (Decomposition of the interactive task).** Any task in a finite deterministic environment decomposes:

```
IDENTIFY the law (LT4–LT6: V=I game, exploration by diagnostic)
   ↓ certified f*
PLAN (LT10–LT12: navigation on the state graph, offline)
   ↓ certified or addressed
EXECUTE (one action per tick; prediction = execution, LT9)
```

Each stage is certified or returns an addressed failure: unidentified law → experiment address (LT5); unreachable goal → trap address (LT12); divergent execution → a witnessed cell where f\* fails — which is new evidence, shrinking S, re-entering stage one with strictly more information (V=I §5.22). The loop cannot silently be wrong; it can only be explicitly incomplete, with the incompleteness named. Interactive benchmarks of the ARC-AGI-3 kind are in scope exactly when their environments are finite, deterministic, and fully observable — and the decomposition is the architecture for them.

## §5. The Tower of Laws

**LT15 (Lawful drift — conditional).** Suppose the law itself changes, but lawfully: f is parameterized by a slow variable whose own dynamics are deterministic and finite. Then the meta-law is the fixed target, and LT1–LT14 apply one level up — identify the meta-law from observed law-changes (each itself identified by LT4 over a window), plan over the law-space graph, descend. The recursion is the framework's standing move (PiR §4: each level's crystal is the next level's substrate; OiO O19: the construction is level-invariant). It terminates when some level is genuinely fixed — and I2 demands only that SOME level is.

*Consequence, stated plainly:* a world is learnable by this framework iff it is lawful at some finite level. Unlawful worlds — where no level of description is a fixed finite deterministic structure — are not learnable by it, and the framework reports this as |S| > 1 persisting at every level it can afford, rather than as a confident wrong answer. The premise (finite lawful depth) has the same status as compression in PiR M16: not derived from I1–I3, measurable in practice, honest as a premise.

## §6. Boundaries

**Stochasticity.** A stochastic transition breaks the gate: the same (s, a) yields different s′, and COMPARE on outcomes fails through no fault of any candidate. Encoding the law as a finite distribution table (rational probabilities) keeps the structure finite, but equality of distributions is not decidable from finite samples — the gate's PASS is unavailable in principle, not merely in practice. Statistical laws earn confidence, never certificates. The framework's honest output is |S| > 1 forever, and that honesty is the boundary. (A bounded reframing survives: "within n trials, outcome frequencies match table p exactly" is decidable — but it certifies the sample, not the law.)

**Partial observability.** Hidden state forces belief-state encoding. The belief space over finite St is finite (I1 holds — subsets or finite-precision distributions), so the construction is legal; it is exponentially large, so it is rarely affordable. Same status as O3's remark: legality without affordability, restored only by an agent-supplied restriction (a feature basis over beliefs).

**Adversaries.** A deterministic opponent is part of the environment: its policy is a component of f, identifiable by LT4 — playing against it is just dynamics. An adapting opponent changes the law with history: lawful adaptation falls to LT15 (identify the adaptation rule); unlawful adaptation is the stochastic boundary wearing a face.

**Continuity.** Continuous state must be finitely encoded; what the encoding discards, no theorem recovers (IiI §4, finiteness boundary, verbatim).

**Implementation.** A gridworld suffices to machine-verify the chain: (i) LT6 — S shrinks monotonically as transitions arrive, hitting |S| = 1 at the predicted count for a feature-compressible law; (ii) LT5 — the ambiguity diagnostic names exactly the withheld transitions; (iii) LT12 — greedy descent under the derived taxicab metric reaches goals, and every stuck state is a wall by inspection; (iv) LT13 — extracted macro-actions pass the strategy gate of OiO. Extends `python/`: a transition-table encoder, an instrumented explorer, and the unchanged `delta.py` for all distances.

## §7. Statement

1. The state is not the target; the law is. I2 is satisfied by relocation, not relaxation (LT1–LT3).
2. Law identification is an ordinary V=I game: certified under R4, with ambiguity returned as an experiment address — exploration is the diagnostic read back (LT4–LT6).
3. Behavior is a structure: trajectories carry norms and distances; behavioral inertia is structural inertia at the trajectory scale; prediction is execution of the certified law within its evidence closure, and silence outside it (LT7–LT9).
4. Planning is navigation: goals are balls under the derived metric, plans are ballistic descents, traps have addresses, repairs are permanent, and no reward function is ever supplied (LT10–LT12).
5. Motor skills are certified strategies: papers 8 and 9 compose without new axioms, and skill transfer between environments is a measured distance before it is an attempt (LT13).
6. Interactive tasks decompose into identify–plan–execute, each stage certified or explicitly incomplete with the incompleteness named (LT14).
7. If the law drifts lawfully, the meta-law is the target, recursively: a world is learnable iff it is lawful at some finite level — and the framework says so rather than guessing (LT15).

> **The world moves; what it obeys does not. Identify the law and motion becomes substrate: prediction is execution, planning is descent, skill is a ball in the space of plans. I2 never asked the world to hold still — only the truth about it.**

## §8. Dependency

### External

| Source | Used |
|---|---|
| V=I | §1 (agent supplies encoding; REJECT carries address), §2 (Σ, COMPARE, I1–I3), §3.1–3.6 (game, F, S, R4 decidable), §4.5 (rule compression), §5.22 (S non-increasing), Theorems 1–5 |
| IiI | §4 (finiteness boundary), §6 (coupon collector, for exploration budgets) |
| PiR | M1 (tick), M6 (moving structure cannot be target — bypassed, not broken), M7 (stable target), §4 (tower), M21 (no deletion) |
| DiD | S19 (one distinction per tick) |
| DiC | G1a (norm), G2/G2a (W, one traversal), G7 (taxicab on grids — derived goal gradient), G14 (travel time) |
| NiG | N5–N9, N15–N17 (imported into the state graph by substitution) |
| OiO | O2 (strategies in Σ), O5 (strategy gate), O14–O16 (skills as balls, skill navigation), O21 (certification order) |

### Internal

| Statement | Depends on |
|---|---|
| LT1–LT2 | premise; I1; V=I §2.1; DiC G1a, G2 |
| LT3 | LT2; I2; PiR M6–M7 |
| LT4 | LT2; V=I §3, Theorems 1–5 |
| LT5 | LT4; V=I §3.6 |
| LT6 | LT4; V=I §5.22, §4.5 |
| LT7 | I1; DiC G1a, G2 |
| LT8 | LT7; PiR M1; DiD S19; DiC G14 |
| LT9 | LT4; Theorem 2; LT5 |
| LT10 | LT4; I1 |
| LT11 | LT7; DiC G7 |
| LT12 | LT10, LT11; NiG N5–N9, N15–N17 |
| LT13 | LT12; OiO O2, O5, O14–O16, O21 |
| LT14 | LT5, LT9, LT12; V=I §5.22 |
| LT15 | LT1–LT14; PiR §4; OiO O19 |

Permanence Is Resistance proved a moving structure cannot be a target, and the series obeyed: every target so far stood still. This document keeps the theorem and moves the aim. The law was always the still point of the turning world — and it was always in Σ, waiting to be compared.
