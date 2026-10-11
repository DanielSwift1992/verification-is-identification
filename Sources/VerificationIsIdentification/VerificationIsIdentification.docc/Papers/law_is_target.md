# Law Is Target (Dynamics)

I2 requires the identified target and the interpretation of its evidence to remain fixed. A changing state can be studied through a fixed transition law when the chosen state includes what that law needs. On specified finite state and action carriers, such a law has a finite table. Its identification is a VI game within a declared candidate family containing the actual law.

The distinction between a whole and its local state is essential. Matter M70 constructs a fixed finite reversible whole that displays any prescribed local deterministic law for a prepared finite horizon. An internal record then changes what the same local value does next. A fixed law of the whole therefore does not, by itself, give a fixed autonomous law on the local description. Moving the target to a law does not establish the completeness of that description.

Within the established scope, disagreements between surviving tables identify distinguishing transition cells. Whether those cells can be reached and recorded is a further part of the task. Certified trajectories and strategies can then use the law under their own navigation, metric and availability premises. A fixed law at a higher level can be another target; its existence alone does not prove that an internal learner can identify it.

## §0. Derivation

No new postulate. One new premise, stated openly: the environment is finite and deterministic (relaxations and their named failures in §6).

1. I2 requires a fixed target. A moving state is not fixed. *[V=I §2.4; PiR M6]*
2. The state moves lawfully: s′ = f(s, a) for a deterministic transition function f over finite states and actions. f itself does not move. *[premise]*
3. A function over finite domains is a finite table, and a finite table is a finite structure in Σ. *[I1; V=I §2.1]*
4. Observed transitions (s, a, s′) are example pairs of a game whose target is f. *[V=I §3.1]*
5. The candidate space (transition functions consistent with the agent's encoding) is finite. *[I1; V=I §3.3]*
6. Verification is decidable: apply the candidate law to (s, a), COMPARE with the observed s′. *[V=I §2.2]*
7. R4 is decidable and its failure is addressed: |S| > 1 names the unobserved transitions that distinguish survivors. *[V=I §3.6; LT5]*
8. The certificate remains valid for its fixed law family, interpretation and evidence. Applying it to further physical changes requires those connections to continue to hold. *[I3; PiR M7; M70]*
9. Under f\*, the state space is a finite labeled graph, goals are balls, and plans are descents. The navigation theorems apply by substitution. *[NiG N1–N19; DiC G7]*
10. Trajectories are finite trees in Σ: behavior has a norm and a metric. *[DiC G1a, G2]*

The framework's prior papers identified rules of static transformations. A law is a rule whose examples arrive in time. Nothing in Theorems 1–5 references when the examples arrive.

## §1. The Law as Structure

**LT1 (Environment).** A finite deterministic environment is a triple (St, A, f): finite state set St, finite action set A, transition function f : St × A → St. Observation is the full state (partial observability: §6). All three components are finite (I1).

**LT2 (The law has an encoding in Σ).** f is a finite function, and a finite function has an encoding as a lookup structure: a tree of PAIR((s, a), s′) entries terminating at NULL (V=I §2.1, the same move as the library's own encoding, PiR §2). Therefore:

- ‖f‖ is defined (G1a): the law's maintenance cost. Simple dynamics are literally cheaper to exist, and a law expressible through few features has small norm.
- W(f₁, f₂) is defined (G2): the distance between dynamics, the work to re-form one law into the other, disagreeing transition cells each counted with the magnitude of their disagreement. Environment transfer becomes a measurable quantity before any transfer is attempted.

**LT3 (Relocation).** Under LT1's fixed complete state/action interpretation, the transition table remains fixed while a represented state changes. It can therefore be the target required by I2. For a local description E of a larger state, the corresponding requirement is descent of the whole transition through E, with its actual availability preserved where actions are partial (Verdict VC46–VC47). M70 supplies whole permutations for which a local reset holds for any prepared finite horizon and then fails. Identifying the fixed whole law and establishing an autonomous local law are different obligations.

## §2. Identification

**LT4 (The transition game).** Examples are observed transitions {((sᵢ,aᵢ),s′ᵢ)} in LT1's fixed interpretation. Compare each candidate table in the declared finite F_dyn with those entries. Acceptance establishes agreement on the witnessed cells. If exactly one candidate survives, it is the only table in that family agreeing with the records. Identifying it with the actual law additionally requires that the actual law belongs to the family and that the records refer to this same state/action interpretation. A feature choice or a named encoding does not establish these requirements. System CS3 and Verdict VC74 already state the coverage boundary.

**LT5 (Ambiguity is an exploration address).** |S| > 1 is true iff some (s, a) cell on which surviving candidates disagree is unobserved.

*Proof.* If all distinguishing cells were observed, the gate would have eliminated all but one candidate (disagreement on an observed cell is a failed COMPARE). Conversely, if an unobserved distinguishing cell exists, both candidates pass every observed check. QED

The diagnostic is constructive: the system returns the distinguishing cells: WHICH state to reach, WHICH action to try there. Exploration is not a policy bolted onto the agent: it is the |S| > 1 diagnostic read back as an experiment plan. This is the dynamics-level instance of the series' one pattern: the failure names its own cure (V=I §1: REJECT carries the address, NiG N17: holes are the curriculum, and here: ambiguity is the experiment design).

**LT6 (Convergence under attainable coverage).** Adding a sound observation can only remove candidates from a fixed F_dyn. Observing every distinct cell of the complete |St|×|A| table determines that table; repeated observations of a smaller region do not supply this coverage. Attaining the cells may require preparation, access and extra actions, and some can be unreachable in the stated experiment. Structural relations can determine unwitnessed cells from witnessed ones when the actual law is known to obey those relations. The resulting reduction in required observations follows from that family and its separating experiments, not from the word compression alone.

## §3. Behavior as Structure

**LT7 (Trajectory).** A bounded-horizon trajectory T = (s₀, a₀, s₁, a₁, ..., s_h) is a finite sequence over finite alphabets: a finite tree in Σ. Behavior is a structure. Two consequences are immediate: ‖T‖ (the cost of a behavior's existence) and W(T₁, T₂) (the distance between behaviors, computable by one traversal, G2a).

**LT8 (Editing a plan and executing it have different costs).** W(T₁,T₂) counts the single-address edits of G2 needed to change one encoded plan into another. It bounds operation ticks only for an interface allowing one such edit per tick. G14a instead permits compatible edits in parallel and counts dependent rounds. Executing a plan can also depend on the current state, action availability, committed effects and retained history. Its redirection cost must use those actual transitions. A distance between two plan descriptions alone does not determine that cost or a physical inertia.

**LT9 (Prediction is execution).** Given certified f\*, a start state, and an action sequence, the future trajectory is computed by iterated application: predicted by execution, never estimation. The certificate's exact scope: Theorem 2 certifies f\* on the evidence closure, the cells witnessed or pinned by the encoding's features under R4. Within that closure, prediction cannot be wrong (a wrong prediction would witness a cell where f\* disagrees with the world, contradicting the gate). Outside it, |S| > 1 was the standing diagnostic, and the framework said so before the prediction was attempted. The system does not extrapolate silently: it either certifies or names the missing experiment (LT5).

## §4. Planning Is Navigation

**LT10 (The state graph).** Under certified f\*, define Γ_state = (St, E) with action-labeled edges s →ᵃ f\*(s, a). Finite (I1), computed from f\* without further interaction: the agent plans offline on the crystal of its own experiments.

**LT11 (Goals are balls).** A goal is a target region B(g, r) under W on states. For grid worlds the metric is already derived: taxicab (DiC G7). Proximity to the goal is a theorem of the encoding, never a designed reward. The author supplies no reward function anywhere in this document: the gradient toward the goal is the W-gradient, and it comes from the same primitives as everything else.

**LT12 (Planning is greedy descent).** A plan is a walk in Γ_state decreasing W(·, g). The navigation stack applies by substitution (L → St, library entries → states, edges → actions):

| NiG statement | Dynamics reading |
|---|---|
| N5 (ballistic termination) | a strictly-approaching plan reaches the goal in ≤ W(s₀, g) steps |
| N6 (holes with addresses) | a stuck state = no action decreases W, an obstacle or trap, located and named |
| N7 (decidability) | reachability of every goal from every state is decidable, offline |
| N8 (monotonicity) | richer action sets strictly reduce traps: adding an action never creates one |
| N9 (threshold) | the minimal action-reach at which the world is fully navigable exists and is computable |
| N15–N16 (permanent repair) | a trap repaired (by a new action, a waypoint, a macro) is repaired for good (I3) |
| N17 (failure curriculum) | the traps name which capabilities to acquire next |

Local minima of W are exactly the states where greedy locomotion fails: walls, dead ends, puzzles. The framework does not promise their absence: it promises their addresses.

**LT13 (Macro-actions are strategies, and the papers compose).** A certified sub-plan (a region of states, an action sequence, a guaranteed arrival region under f\*) is a strategy object in the sense of Order Is Object: a finite decision tree over observations (states) choosing moves (actions), certifiable by the strategy gate (O5) with cost = plan length, entering the library with norm and distance (O2). Therefore the whole of OiO is in force: motor skills are balls in plan space (O15), skill space is navigable when it clusters (O16), and the optimal certification order of motor skills is computable (O21). Identification (papers 1–6), navigation (7), strategy (8), and dynamics (9) compose on shared primitives with no new axioms: a skill learned in one region of one environment transfers to any (region, environment) pair within measured W, both distances already defined (LT2, O14).

**LT14 (Decomposition of the interactive task).** Any task in a finite deterministic environment decomposes:

```
IDENTIFY the law (LT4–LT6: V=I game, exploration by diagnostic)
   ↓ certified f*
PLAN (LT10–LT12: navigation on the state graph, offline)
   ↓ certified or addressed
EXECUTE (one action per tick; prediction = execution, LT9)
```

Under the preceding premises, law ambiguity identifies a distinguishing cell and a proposed plan can be checked against the represented state graph. A later transition disagreeing with the identified candidate refutes its continued application. It can leave the fixed family empty, exposing a failed family, observation or stationarity premise; it need not leave another correct candidate ready for selection. A controller does not detect every such failure from the presence of a gate alone. A question constant on all currently admitted laws can already be settled before complete law identification, so this decomposition is one sufficient route where its acquisition and planning obligations are met.

## §5. The Tower of Laws

**LT15 (Lawful drift, conditional).** If a changing local rule is governed by a finite fixed law on a larger state, that larger law can serve as a target. The new state must include the relevant internal rule and control fields. Identification still requires a declared candidate family containing the actual law and attainable evidence that separates it. Merely moving the word law up a level supplies none of that evidence and no bound on the number of levels to inspect.

The former iff between learnability and a fixed finite lawful level was too strong. Existence of a finite description does not supply a bounded candidate family, access to hidden state or separating experiments. M70 makes this visible within fixed reversible wholes: an unbounded family of finite internal record carriers can reproduce an arbitrarily long prepared local reset before its return. Exact whole recovery does not certify an unlimited local reset from that finite prefix. The record-preserving variant can instead continue on an unbounded history carrier. These are different complete models behind the same local evidence. Finite scope and actual access must be established, while a question invariant across the surviving models can need less than identifying their full laws.

## §6. Boundaries

**Stochasticity changes the target of comparison.** A proposed deterministic successor can fail when the same available (s,a) permits different s′. A specified response law can still have exactly provable consequences. Finite rational probability tables can be compared exactly when supplied, while finite observations need not identify which table generated them. For example, any finite binary word has positive likelihood under every IID Bernoulli parameter strictly between zero and one. Such a word cannot logically separate those candidate laws. A declared family with distinguishable supports or an independently certified preparation can change this conclusion. Thus finite sampling does not imply a universal refusal of statistical certificates or perpetual ambiguity for every statistical question.

Agreement AC7 supplies an exact finite error bound under a stated conditional law. The bound can be proved while the actual unknown parameter remains unidentified. A predicate shared by every law compatible with the retained evidence and premises can also be certified by VC15. Without restrictions on the candidate family, absence of an outcome from a finite sample does not establish its impossibility: arbitrarily small positive probabilities remain compatible. A confidence statement quantifies error across the stipulated sampling law and is not a logical guarantee for the realized sample. The evidence, law, question and tolerated error must remain bound together.

**Partial observability needs an adequate retained reading.** For finite St, possible-state subsets form a finite family. Exact probability distributions on St generally form an infinite family, even when St has only two members. A fixed finite-precision encoding is another construction whose omitted distinctions need an error or invariance argument. The full belief distribution need not be retained when a smaller reading answers the actual question and its continuations, as VC15 establishes. Neither finiteness of the hidden state nor the word belief proves that a proposed approximation is sufficient.

**Adversaries have an information and move-order contract.** A fixed deterministic opponent can be included in the state, but its identification still needs LT4's candidate-family and experiment premises. A guarantee may instead quantify over every admitted opponent strategy without identifying one. Adaptation can be represented by history and does not make the opponent lawless or automatically stochastic. A mixed-strategy guarantee must state what the opponent can observe before choosing. Play §4 distinguishes balanced hidden choices from a predictable sequence having the same overall frequencies.

**Continuity.** Continuous state must be finitely encoded, and what the encoding discards, no theorem recovers (IiI §4, finiteness boundary, verbatim).


## §7. Statement

1. A fixed law on an adequate state/action representation can be the target while states change (LT1–LT3).
2. Law identification determines a candidate within its declared family. Connection to the actual law and attainable separating experiments remain required (LT4–LT6).
3. Encoded trajectories carry norms and edit distances. Editing, plan execution and prediction each require their actual transition and interpretation premises (LT7–LT9).
4. Planning is navigation: goals are balls under the derived metric, plans are ballistic descents, traps have addresses, repairs are permanent, and no reward function is ever supplied (LT10–LT12).
5. Motor skills are certified strategies: papers 8 and 9 compose without new axioms, and skill transfer between environments is a measured distance before it is an attempt (LT13).
6. Identify–plan–execute is a sufficient route under its acquisition, model and planning premises. An invariant question can be settled with the law still unresolved (LT14).
7. A fixed law at a larger internal level is another possible target. Its finite existence alone does not establish learnability or certify a continuing local law (LT15, M70).

## §8. Dependency

### External

| Source | Used |
|---|---|
| V=I | §1 (agent supplies encoding, REJECT carries address), §2 (Σ, COMPARE, I1–I3), §3.1–3.6 (game, F, S, R4 decidable), §4.5 (rule compression), §5.22 (S non-increasing), Theorems 1–5 |
| IiI | §4 (finiteness boundary), §6 (coupon collector, for exploration budgets) |
| PiR | M1 (tick), M6 (moving structure cannot be target, bypassed, not broken), M7 (stable target), §4 (tower), M21 (no deletion) |
| DiD | S19 update-relative rate, S20 agreement versus influence |
| DiC | G1a (norm), G2/G2a (W, one traversal), G7 (taxicab on grids, derived goal gradient), G14 (travel time) |
| NiG | N5–N9, N15–N17 (imported into the state graph by substitution) |
| OiO | O2 (strategies in Σ), O5 (strategy gate), O14–O16 (skills as balls, skill navigation), O21 (certification order) |

### Internal

| Statement | Depends on |
|---|---|
| LT1–LT2 | premise, I1, V=I §2.1, DiC G1a, G2 |
| LT3 | LT2, I2, PiR M6–M7 |
| LT4 | LT2, V=I §3, Theorems 1–5 |
| LT5 | LT4, V=I §3.6 |
| LT6 | LT4, V=I §5.22, §4.5 |
| LT7 | I1, DiC G1a, G2 |
| LT8 | LT7, PiR M1, DiD S19, DiC G14 |
| LT9 | LT4, Theorem 2, LT5 |
| LT10 | LT4, I1 |
| LT11 | LT7, DiC G7 |
| LT12 | LT10, LT11, NiG N5–N9, N15–N17 |
| LT13 | LT12, OiO O2, O5, O14–O16, O21 |
| LT14 | LT5, LT9, LT12, V=I §5.22 |
| LT15 | LT1–LT14, PiR M70, EiF EF6–EF7, Verdict VC74, OiO O19 |

The fixed target can be a law of change. The representation must still account for the internal relations that make it that law's state, including the preparation and records on which repeated use depends.

## Topics

### Related type declarations

- ``LawLivesInSigma``
- ``LawIsTarget``
- ``AmbiguityIsExperiment``
- ``BehaviorIsStructure``
- ``PlanningIsNavigation``
- ``MotorSkillsAreStrategies``
- ``InteractiveDecomposition``
- ``LawfulDrift``
