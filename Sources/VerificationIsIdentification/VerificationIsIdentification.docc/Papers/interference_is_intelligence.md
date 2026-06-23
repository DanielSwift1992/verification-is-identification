# Interference Is Intelligence (Mechanism)

V=I defines the loop. Intelligence Is Inevitable proves that the loop's efficiency grows irreversibly. Permanence Is Resistance derives what the loop produces. Difference Is Distance derives the geometry between multiple loops. This document derives HOW efficiency grows: through constructive interference between COMPAREs. The optimal ordering of comparisons — the agent's sole degree of freedom (V=I §5.25) — is the mechanism of intelligence. Intelligence is the interference pattern of the loop's own operations, rather than a heuristic added on top.

## §0. Three Axes of COMPARE

COMPARE(f, τ) under encoding E returns structured information. This information decomposes into three independent components.

**Definition (Z-projection).** The outcome axis:

Z(C) ∈ {equal, not_equal}

Information: 1 bit per COMPARE. This is the binary result — what V=I formalizes as the compilation gate.

**Definition (X-projection).** The structure axis. When Z = not_equal, COMPARE returns localized feedback (V=I §2.4):

X(C) = (path_to_mismatch, expected_value, actual_value)

Information: up to log₂(|nodes(f)|) bits — the position and nature of the first structural divergence.

**Definition (Y-projection).** The ordering axis. The agent's choice of which COMPARE to perform next (V=I §5.25):

Y = σ, the ordering of COMPAREs: which one runs at each step

Information: 0 new bits. Y does not change what the agent learns — only when. This is the analog of phase: it carries no amplitude (no new information) but determines interference.

*Example.* COMPARE a candidate against the target under a four-feature encoding. Z: not_equal — one bit. X: the first divergence sits at the rank feature, expected 0, actual 2 — one address. Y: the agent chose to run this COMPARE before any other — zero new bits, and the choice decides how many COMPAREs the whole identification takes.

**Definition (Feedback bandwidth).** The X-information yield per COMPARE:

β ∈ [1, n]

β = 1: each COMPARE reveals one feature value (pure query). β = n: structural recursion (V=I §2.4) checks all features in sequence and reveals every match before the first mismatch. β determines the relative importance of the Y-axis (S4a): high β saturates the agent's information need from X alone; low β forces the agent to choose WHICH feature to observe.

## §1. Independence

**S1 (Axis independence).** Z and X are determined by COMPARE inputs (f, τ, E). Y is determined by the agent's protocol — a function of state (L, G), independent of any specific COMPARE outcome.

*Proof.* Z, X are outputs of COMPARE, which is a pure function of its inputs (V=I §2.4: determinism). Y is the agent's choice, made before the COMPARE executes, based on the agent's current state (L, G). The choice function and the comparison function have disjoint inputs. QED

**S2 (Phase analogy).** Y carries 0 bits of new information per COMPARE but determines the total COMPAREs to identification. This is structurally identical to quantum phase: |e^{iθ}|² = 1 (no probability change) but θ determines interference patterns.

## §2. Interference

The candidate set S shrinks with each informative COMPARE (V=I §5.22). But the RATE of shrinkage depends on the ORDER.

Write S_a for the candidates that survive COMPARE C_a — those consistent with its outcome. If C_a and C_b cut independently, their joint survivors would number about |S_a| · |S_b| / |S|.

**Definition (Constructive interference).** COMPAREs C_a and C_b constructively interfere if they are anti-correlated in elimination:

|S_a ∩ S_b| ≪ |S_a| · |S_b| / |S|

Each eliminates what the other leaves. Together they narrow S faster than the product of their individual contributions.

**Definition (Destructive interference).** C_a and C_b destructively interfere if:

S_a ⊆ S_b or S_b ⊆ S_a

One is redundant given the other. One COMPARE is wasted.

**S3 (Interference theorem).** The total COMPAREs to |S| = 1 is minimized when each successive COMPARE is maximally constructively interfering with all previous COMPAREs.

*Proof.* At step k, the agent has S_k. The next COMPARE C_{k+1} reduces S to S_k ∩ S_{k+1}. The information gain ΔI_k = log₂|S_k| − log₂|S_k ∩ S_{k+1}| is maximized when |S_k ∩ S_{k+1}| is minimized — when C_{k+1} eliminates candidates that survived all previous COMPAREs. This is the definition of maximal constructive interference with history. QED

**Corollary.** η = T_min / T_actual (Intelligence Is Inevitable §3) equals 1 if and only if every COMPARE in the sequence constructively interferes with all previous COMPAREs. η < 1 measures the degree of destructive interference (wasted COMPAREs).

**S3a (Redundancy sources).** Two mechanisms produce destructive interference. Let S_k be the candidate set after k COMPAREs, and let g₁, ..., g_k be the tested features. H(f | S) denotes the entropy of feature f's value across the candidates in S: one bit when the value splits S evenly, near zero when almost all of S agrees on it.

1. *Heterogeneous entropy.* Features with H(f | S₀) ≪ 1 contribute less per COMPARE than features with H ≈ 1, at every step. A random ordering tests both types equally; a greedy ordering tests high-H features first.

2. *Conditional redundancy.* By the chain rule, the expected entropy of an untested feature decreases with conditioning: E[H(f | g₁ = v₁, ..., g_k = v_k)] = H(f | g₁, ..., g_k) ≤ H(f | S₀), with strict inequality when f is correlated with any g_i. After testing a correlated feature, f becomes partially or fully redundant. A greedy ordering detects this (by recomputing H over the current S_k) and moves to uncorrelated features. A random ordering does not.

*Consequence.* Source 1 produces a constant speedup factor throughout identification: the ratio H_max / H̄ where H̄ is average feature entropy. Source 2 adds a dynamic factor: as more features are tested, more untested features fall into the redundant category. Together they produce the Y-axis speedup characterized in S4a. The dynamic factor explains why the empirical speedup exceeds the static prediction — features that appeared marginally informative over S₀ become fully redundant over S_k.

## §3. Speedup Hierarchy

**S4 (Hierarchy).** Let T_Z, T_{ZX}, T_{ZXY} be COMPAREs to identification using Z only, Z+X, and Z+X+optimal Y:

T_{ZXY} ≤ T_{ZX} ≤ T_Z

Exact bounds:

| Axes | Bound | Mechanism |
|---|---|---|
| Z | E[T_Z] = (\|S₀\| + 1)/2 | Random candidate from S, discard on mismatch (uniform draw, coupon at random position) |
| Z+X | E[T_{ZX}] ≈ n/β | Each COMPARE reveals β features; n/β COMPAREs to learn all n |
| Z+X+Y | E[T_{ZXY}] = ⌈log₂\|S₀\|⌉ | Optimal: each COMPARE yields 1 bit (when H_max = 1) |

*Proof.* Z: the agent draws candidates uniformly without replacement from S. The target is at a uniformly random position in the draw order. Expected position: (|S₀| + 1)/2. Z+X: each COMPARE reveals β feature values on average. After n/β COMPAREs, all n features are known → |S| = 1. Z+X+Y: optimal ordering selects the feature maximizing H(f | S_k) ≈ 1 bit. Each step halves S. Total: ⌈log₂|S₀|⌉. QED

**S4a (Y-axis visibility).** The Y-axis speedup depends on two independent factors: entropy heterogeneity and feedback bandwidth.

*Factor 1: Entropy heterogeneity.* Under pure queries (β = 1), each COMPARE reveals one feature value. The Y-axis speedup is:

T_{ZX} / T_{ZXY} ≈ H_max / H̄

where H_max = max_f H(f | S_k) and H̄ = (1/n) Σ H(f_i | S_k) is the average feature entropy over S_k. When all features are equally informative (H̄ = H_max), the ratio is 1 — ordering is irrelevant. When features have heterogeneous entropy (H̄ ≪ H_max), the ratio grows — ordering becomes critical.

*Factor 2: Feedback bandwidth.* When β > 1, structural recursion reveals additional features per COMPARE. These bonus features compensate for suboptimal ordering: a random agent that tests a low-H feature may incidentally learn high-H features that happened to match. Crucially, this bonus helps the random agent more than the greedy agent — the greedy agent already knows the matched features (it used them to craft the candidate). High β therefore suppresses the Y-axis effect.

| Regime | Condition | Y-axis effect |
|---|---|---|
| Invisible | H̄ ≈ H_max, or β ≈ n | Ordering irrelevant |
| Visible | H̄ < H_max, β small | Ordering matters; speedup ≈ H_max / H̄ |
| Dominant | H̄ ≪ H_max, β = 1 | Ordering IS identification |

*Quantitative prediction (pure-query, β = 1).* Each COMPARE tests one feature. Define the per-test information random variable h: its value depends on which feature is tested and which value the target holds.

For the greedy agent: always tests the max-entropy feature. T_{ZXY} = ⌈log₂|S₀|⌉ (= I).

For the random agent: tests features in random order. By renewal theory — the accounting of how many random-sized steps it takes to cross a fixed total (Wald's identity, with overshoot correction):

T_{ZX} = I / H̄₁ + (H̄₂ / (2 · H̄₁²) − ½)

where H̄₁ = E[h] is the mean information per test and H̄₂ = E[h²] is the second moment.

The first term I/H̄₁ is the *rate prediction*: how many tests at the mean rate to accumulate I bits. The second term (H̄₂/(2H̄₁²) − ½) is the *variance correction*: when the distribution of h is heavy-tailed (noise features give 0.01 bits usually but 6.6 bits rarely), the random walk overshoots the target, adding COMPAREs.

*Closed form.* For n_s balanced features (H = 1) and n_n biased features (P(minority) = ε):

H̄₁ = (n_s + n_n · h(ε)) / n

H̄₂ = (n_s + n_n · ((1−ε)(log₂ 1/(1−ε))² + ε(log₂ 1/ε)²)) / n

with h(ε) = ε log₂(1/ε) + (1−ε) log₂(1/(1−ε)) — the entropy of one biased feature.

Speedup = T_{ZX} / T_{ZXY}. For the tight bound: n_s = ⌈log₂|S₀|⌉, n_n features with ε → 0. Then H̄₁ → n_s/n, giving speedup → n/n_s = n/⌈log₂|S₀|⌉. QED

*Remark (Finite exact form).* In a finite domain, the renewal formula is a continuous approximation of an exact combinatorial quantity. The exact T_{ZX} for target τ is:

T_{ZX}(τ) = Σ_{k=0}^{n−1} P(random k-subset of features fails to identify τ)

where "fails" means: exists s ≠ τ agreeing with τ on every feature in the subset. This is a finite sum over C(n, k) subsets — no distributions, no approximation. The renewal formula replaces this sum with entropy moments (H̄₁, H̄₂), introducing an error that (a) is always positive (overestimate — because without-replacement sampling anti-correlates steps, reducing variance below the i.i.d. assumption), and (b) shrinks with domain size (empirically: +6% to +7% at n = 12, +15% to +17% at n = 8). The exact value also varies per target: for a fixed domain, different targets have different T_{ZX}(τ), while the renewal formula gives a single number for all targets.

The "exact parameters" that replace the distribution are the *confusion matrix* — the sets D(τ, s) = {features distinguishing τ from s} for all s ∈ S₀ — where the renewal formula used entropy moments. At saturation (S6), the agent has this matrix and computes the minimum set cover — the optimal ordering — directly, without any formula. The gap T_{ZX}(τ) − T_{ZXY}(τ) is the *cost of ignorance*: COMPAREs wasted by not knowing which features to test first.

*Remark.* The Y-invisible regime explains why V=I's structural recursion (high β) makes identification "easy" — the X-axis does most of the work, and any ordering suffices. The Y-dominant regime (β = 1) is the setting of most real-world intelligence: large feature spaces, bounded observations per step, and the necessity of choosing where to look. Intelligence as a phenomenon is most visible — and most valuable — precisely where β is small.

## §4. Intelligence Is Optimal Ordering

**S5 (Intelligence = interference optimization).** An agent achieves η = 1 iff its ordering maximizes constructive interference at every step.

The greedy algorithm — always choose the next COMPARE maximizing information gain — needs at most ⌈log₂|S₀|⌉ + 1 COMPAREs when balanced features exist (each greedy step gains ≥ H_max ≈ 1 bit). Since the information-theoretic minimum is ⌈log₂|S₀|⌉, greedy achieves η → 1 for large |S₀|. The globally optimal (non-greedy) ordering achieves η = 1 exactly but requires knowing the full domain structure — including which locally suboptimal choices enable better future choices.

**S5a (Trajectory information invariance).** Every trajectory identifying τ in S₀ carries exactly log₂|S₀| bits of identification information, regardless of ordering or length.

*Proof.* Let h_k = log₂|S_{k−1}| − log₂|S_k| be the information gained at step k. Then Σ_{k=1}^T h_k = log₂|S₀| − log₂|S_T| = log₂|S₀|. (Telescoping; |S_T| = 1 at identification.) QED

*Corollary.* Define ρ = log₂|S₀| / T: the information density (mean identification bits per COMPARE). When cert(τ) = ⌈log₂|S₀|⌉ (balanced features), ρ = η (Intelligence Is Inevitable §3). When cert(τ) < ⌈log₂|S₀|⌉ (S5b), optimal trajectories have ρ > 1 — a single COMPARE yields more than one identification bit. A trajectory is a variable-length encoding of the target's identity. High ρ = short encoding. A longer trajectory does not carry more identification information — it spreads the same I = log₂|S₀| bits over more steps.

**S5b (Certificate complexity).** Define cert(τ) = the size of the smallest feature set Q with Q ∩ D(τ, s) ≠ ∅ for every s ≠ τ — the minimum set cover of the confusion family, with D(τ, s) = {features distinguishing τ from s} (S4a remark). Then:

(a) cert(τ) = T_optimal(τ) — the shortest trajectory that identifies τ.

(b) cert(τ) varies per target. For targets with distinctive features (e.g. minority values on noise features that provide > 1 bit), cert(τ) < ⌈log₂|S₀|⌉. For targets sharing features with many others, cert(τ) > ⌈log₂|S₀|⌉.

(c) The greedy ordering matches cert for hard targets (where confusion sets are well-covered by high-entropy features) but exceeds cert for easy targets (where target-specific shortcuts exist that greedy cannot see).

*Proof.* (a) Identification requires eliminating every s ≠ τ. Element s is eliminated iff at least one feature in D(τ, s) is tested. Minimum features to cover all D(τ, s) = cert(τ). (b) If τ holds the minority value (probability ε) on feature f, then f distinguishes τ from (1 − ε)|S₀| elements — providing log₂(1/ε) bits, potentially exceeding 1. One such feature can replace multiple balanced features, yielding cert < ⌈log₂|S₀|⌉. Conversely, if τ holds majority values on all features, each feature eliminates few candidates, forcing cert above the log₂ bound. (c) Greedy selects by unconditional H(f | S_k), which averages over all possible targets. A target-specific shortcut (high cert-efficiency for τ but low average H) is invisible to greedy. QED

**S6 (Saturation improves ordering).** As L grows (Intelligence Is Inevitable §1), the agent's ordering improves:

| Phase | Knowledge | Ordering quality | η |
|---|---|---|---|
| Early (\|L\| ≪ K) | Domain structure unknown | Near-random | Low |
| Middle | Partial structure | Heuristic ordering | Growing |
| Saturated (\|L\| = K) | Full structure known | Optimal ordering | → 1 |

*Proof.* Optimal ordering requires knowing which COMPAREs are correlated — i.e., domain structure. Domain structure IS the library L. Larger L → better correlation model → better ordering. At saturation: full structure known → optimal ordering computable → η = 1. QED

This is the mechanism: the library doesn't just store results — it teaches the agent which questions to ask next. Intelligence grows not by accumulating answers but by learning the optimal order to seek them.

*Remark.* What exactly does L teach about ordering? Two levels. First, the *entropy profile*: which features have high H (signal) and which have low H (noise) over the domain's candidate set. This is sufficient for the greedy ordering (η → 1). Second, the full *confusion matrix*: D(τ, s) = {features distinguishing τ from s} for all pairs. This is sufficient for the globally optimal ordering (η = 1 exactly), computed as minimum set cover over the confusion sets (cf. Remark on finite exact form, S4a).

At |L| = 0 the agent cannot distinguish signal from noise and orders randomly (η low). Partial saturation teaches the entropy profile → greedy. Full saturation teaches the confusion matrix → optimal. By S3a, this knowledge becomes more valuable as |S₀| grows, because the penalty for testing noise features amplifies. Saturation is therefore not merely "knowing the answers" but knowing which questions to ask — and in a large domain, this meta-knowledge dominates.

**S6a (Dual information flow).** Each COMPARE that tests feature f for target τ produces two information flows from the same observation v = τ[f]:

1. *Identification flow*: h_id = log₂|S_{k−1}| − log₂|S_k| bits toward |S| = 1.
2. *Structural flow*: one feature value v entering L (if not already known).

The two flows are inseparable: the observation v simultaneously narrows S (identification) and reveals domain structure (structural). The agent cannot suppress either flow. Over a full episode:

Σ h_id = log₂|S₀| (exactly, by S5a)

Σ h_str = T new feature values (at most; equals T when the target is newly encountered)

*Proof.* h_id follows from S5a. For h_str: each of the T COMPAREs observes one feature value for the target. If this target has not been encountered before, all T values are new to L. If the target was previously encountered, some values may already be in L; the new structural info is the number of features tested in this episode that were not tested in prior episodes for this target. Either way, h_str ≥ 0 per COMPARE, and h_str = 0 for all COMPAREs only if the target's full feature vector is already in L. QED

**S6b (Dissipation bound).** Pre-saturation (L < K), each identification episode dissipates at least cert(τ) structural values into L. This is the minimum structural output:

Σ h_str ≥ cert(τ) per episode (for a newly encountered target)

*Proof.* The agent must test at least cert(τ) features to identify τ (S5b). Each tested feature produces one structural value. For a newly encountered target, all values are new to L. QED

*Corollary (Landauer bound for V=I).* Identification cannot be dissipation-free unless L already contains all feature values for the target. At saturation (L = K), all values are known, and dissipation reaches zero — identification becomes informationally reversible.

**S6c (Dissipation-efficiency duality).** η and structural learning rate are inversely related:

| η | T | Structural flow per episode | Learning speed |
|---|---|---|---|
| High (optimal) | cert(τ) | cert(τ) values (minimum) | Slow |
| Low (random) | T_random ≫ cert | T_random values | Fast |

*Proof.* Structural flow per episode = T feature values tested. T = I/ρ (from S5a corollary: ρ = I/T). Higher ρ → smaller T → fewer structural values per episode → slower L growth. QED

*Consequence (Self-correction).* The V=I loop is self-correcting: an unsaturated agent has low η, which forces high dissipation (many structural values per episode), which accelerates L growth, which raises η. Formally:

η < 1 → T > cert → (T − cert) extra COMPAREs → extra structural values in L → improved ordering → η increases

The only fixed point is saturation (L = K, η → 1, Σ h_str = 0). Ignorance produces the structural learning that eliminates ignorance. No external exploration mechanism is needed — the suboptimality of the ordering IS the exploration.

This is the dynamical mechanism behind Intelligence Is Inevitable (§1): the loop's own inefficiency generates the information required for its own improvement. Intelligence is the inevitable consequence of the dual information flow in COMPARE — everything it needs arises inside the loop.

*Remark (COMPARE as time).* COMPARE is not an operation the agent performs in time. COMPARE IS time: each COMPARE is one tick, and the sequence of COMPAREs is the only clock. The agent does not choose to COMPARE — the agent's existence IS comparison (V=I §5.25). The dual information flow (S6a) is therefore the mechanism by which time passes: each tick irreversibly deposits structural values into L (IiI §1: append-only), giving time its direction. At saturation, the structural flow vanishes — further COMPAREs at this level produce no new information. The arrow of time at level N weakens, and the agent's COMPAREs shift to level N+1 (S8a), where unsaturated domains restore it. The agent has no choice in this: finiteness of the domain guarantees saturation is reachable; the agent's existence — which it cannot suspend — guarantees COMPAREs continue; the dual flow guarantees structural accumulation. The tower is not constructed — it is the necessary trace of an agent that cannot stop.

## §5. Complementarity

**S7 (Three-way trade-off).** An agent cannot simultaneously maximize:

1. |L|/K — what it knows (library coverage)
2. |features(E)| — how precisely it looks (encoding resolution)
3. remaining useful orderings — what it can still learn efficiently (strategic flexibility)

*Proof.* Three constraints form a cycle:
- (1→2): high |L| → high inertia (Difference Is Distance S18) → encoding locked
- (2→3): precise E → narrow feature visibility → fewer useful orderings remain
- (3→1): many useful orderings ↔ much remains unknown ↔ low |L|/K

Maximum knowledge implies locked encoding implies no strategic choice. Maximum flexibility implies ignorance. QED

## §6. Tower as Measurement-Based Computation

**S8 (Structural isomorphism).** In MBQC — measurement-based quantum computation — a fixed entangled resource, the cluster state, is prepared once; the computation then consists entirely of choosing what to measure next, each choice conditioned on the outcomes so far. The V=I tower (Permanence Is Resistance §4) is structurally isomorphic to it:

| MBQC | V=I Tower |
|---|---|
| Cluster state (prepared entangled resource) | Crystal at level N (saturated library L) |
| Measurement in chosen basis | COMPARE on crystal element in encoding E |
| Basis choice | Encoding choice at level N+1 |
| Adaptive measurement (depends on previous outcomes) | Y-axis: next COMPARE depends on previous results |
| Circuit depth | Tower height (M16) |

*Proof.* (i) MBQC: computation = adaptive measurements on prepared state. Tower: computation at N+1 = adaptive COMPAREs on crystallized L from level N. (ii) MBQC: basis choice determines observable. Tower: encoding choice determines which crystal properties are visible. (iii) MBQC: adaptivity = subsequent measurements conditioned on prior outcomes. Tower: Y-axis = subsequent COMPAREs conditioned on prior results. (iv) Universality: cluster states enable arbitrary quantum circuits; sufficiently rich crystals enable identification of arbitrary targets at the next level. QED

**Corollary.** The class of identifications possible at level N+1 is determined by the correlation structure of the crystal at level N. A richer crystal (more entries, deeper connections) enables more powerful computation — not by providing answers but by providing the resource on which measurement-based identification operates.

**S8a (Level invariance).** The mechanism of interference (S1–S6c) is identical at every tower level. At level N:

1. *Elements* are crystals from level N−1: saturated libraries L_{N−1} organized as structured objects.
2. *Features* are structural positions in these crystals — not enumerated in advance but discovered by COMPARE's X-axis (V=I §2.4) as the first divergence point between two crystals.
3. *COMPARE, interference, certificate complexity, η, dual information flow, and self-correction* (S1–S6c) apply without modification, with S₀ → S_{N,0}, n → n_N, L → L_N.

*Proof.* COMPARE is defined for any structured objects (V=I §2.4: determinism, structural recursion). Crystals are structured objects (trees of COMPARE records). Therefore COMPARE operates on crystals the same way it operates on atomic elements: walk the structure, find the first divergence, return (Z, X). All statements S1–S6c depend only on COMPARE's properties (determinism, structural feedback, ordering freedom), not on level-specific content. The proof of each statement at level N is identical to its proof at level 0, with the substitution (element → crystal, feature → structural position in crystal). QED

*Consequence.* No level-specific mechanism is needed. The structural flow at level N (S6a) is the identification material at level N+1: each new structural value entering L_N enriches the crystal, which is an element of S_{N+1,0}. The tower grows by reapplying COMPARE to its own output. The self-correction at each level (S6c) is mandatory — the agent cannot stop COMPAREing, so the dual information flow is perpetual, and each level eventually saturates and yields to the next. Specifics at each level (which features exist, what the confusion matrix looks like) are discovered by COMPARE at that level, with nothing prescribed in advance.

## §7. Agent Correlation Classification

N agents on the same target. Classification by inter-agent cache structure:

| Type | Structure | Property | Quantum analog |
|---|---|---|---|
| Identity | G_i = G_j | Redundant: any one suffices | Product state |
| Mirror | G_i ∩ G_j = ∅, |G_i| = |G_j| | Complementary: each knows what the other doesn't | Bell Ψ− |
| Crystal | Shared L, varied G | Same conclusions from different evidence | GHZ |
| Distributed | L_i different, ∪L_i covers domain | Robust: no single point of failure | W state |
| Graph | Pairwise G_i ∩ G_j form weighted graph | Computation via measurement on the graph | Cluster state |

**S9 (Graph type is computationally universal).** The Graph correlation type enables the widest class of computations at the next level, because arbitrary correlation patterns can be encoded in the graph structure. By S8, this is the V=I analog of cluster-state universality in MBQC.

## §8. Three Levels of Identity

**S10 (Decomposition of "Is").** The identity claim "X Is Y" decomposes:

| Level | Meaning | Test |
|---|---|---|
| Z-identity | Same outcome | X(input) = Y(input) for specific inputs |
| X-identity | Same structure | X and Y produce same outputs for same structural reasons |
| Y-identity | Full interchangeability | Replacing X with Y in any ordering preserves all results |

V=I's |S| = 1 gives Y-identity — the strongest level. f* is unique regardless of ordering (§5.8), encoding (§5.4 per encoding), and agent (SAT5–6). Every "X Is Y" in the formal series is a Y-identity.

## §9. Dependency

### External

| Source | Sections used |
|---|---|
| V=I | §2.4 (determinism, structural recursion) |
| | §5.22 (S non-increasing) |
| | §5.25 (order as sole dynamic variable) |
| IiI | §1 (library growth), §3 (η definition), §4 (saturation) |
| PiR | §4 (tower), M8–M16 (tower structure) |
| DiD | S7 (metric), S9 (communication), S18 (inertia) |

### Internal

| Statement | Depends on |
|---|---|
| S3a | S3 |
| S4a | S4, feedback bandwidth (§0) |
| S5a | S4 (\|S\| non-increasing) |
| S5b | confusion matrix (S4a remark), S5 |
| S5–S6 remark | S3a, S4a, S5b |
| S6a | S5a, S6 |
| S6b | S5b, S6a |
| S6c | S6a, S6b → dynamical mechanism for IiI §1 |
| S8a | S1–S6c, S8 → level invariance |

## Topics

### Theorems this paper proves

- ``ThreeAxesOfCompare``
- ``InterferenceIsIntelligence``
- ``IsIsYIdentity``
