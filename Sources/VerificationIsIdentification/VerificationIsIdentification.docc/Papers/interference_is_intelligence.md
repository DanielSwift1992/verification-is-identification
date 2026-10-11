# Interference Is Intelligence (Mechanism)

The value of a question depends on what can be asked after its answer. A query that removes the most candidates now can leave a harder problem than a less balanced query. A short certificate for each possible target also need not yield one strategy that finds every target at its certificate cost. This paper separates local information, instance certificates and adaptive policy cost.

The mechanism studied here is finite decision-tree search. It is an established mathematical model, made explicit in VI so that claims about ordering can be checked. Retention and acquisition have the separate premises of Liquid LQ3 and LQ11. The term interference names relationships between query partitions. It does not establish quantum interference or automatic growth of intelligence.

## §0. Outcomes, Feedback and Choice

Fix a finite nonempty candidate set K, an unknown actual x ∈ K, a target question q, and static total queries f_i: K → {0,1}. Each query costs one call, leaves the source unchanged, and remains available after every history. The full query table is known for policy synthesis. An executing policy reads its internal state and query outcomes, not the unknown index x. A sound history determines a compatible set B containing x. A policy may stop when q is constant on B.

For the closed-whole interpretation, source, controller, memory and clock remain internal. The nine-state source example is also executed inside finite closed permutation windows containing the source and its controller history: 45 whole configurations for a worst-optimal policy and 54 for the forced-greedy-root policy. Preparation and a later history-recovery step are explicit. These are bounded abstract realizations, not an indefinitely growing memory or a physical cost model.

For expected costs, also fix a full-support prior π on K. Conditional probabilities below refer to π restricted to B. Worst-case costs use no prior. Computation, lookup and memory-management costs are excluded from query counts. Stateful interventions require the richer dynamics and original-question transport of Verdict VC30–VC34.

**Z-projection.** A binary comparison verdict Z ∈ {equal, not_equal} has entropy at most one bit. A deterministic or highly biased verdict may carry less. A binary alphabet is not a guarantee of one bit gained on every call.

**X-projection.** Structured feedback can include a mismatch address, expected value and observed value. Its information bound depends on the full outcome alphabet and conditional distribution. The number of addresses alone does not bound information in their attached values. If the verdict is determined by the feedback, their entropies must not be added as independent contributions.

**Y-projection.** Query choice is a policy Y = P(H) based on available history H. An adaptive policy is a tree of choices, not one fixed permutation. Structural COMPARE feedback can be represented by a multi-outcome partition, but binary depth bounds apply only to the binary-query model used below.

A bandwidth β may count exposed feature values if the interface specifies which values are returned. Fresh keys, value count and information in bits are different quantities. Neither n/β queries to identification nor a speedup ratio follows from this count alone.

## §1. What the Policy Knows

**S1 (Conditional information in a deterministic choice).** When Y = P(H), I(x; Y | H) = 0: knowing H already determines Y. This does not imply that Y is unconditionally independent of x, since H may contain information about x. Nor are the verdict and mismatch feedback independent because software computes them in different roles.

*Proof.* A deterministic function of H has zero conditional entropy given H, so H(Y | H) = H(Y | x,H) = 0. Their difference is the conditional mutual information. A policy can affect what the next observation reveals without its choice itself adding information beyond H.

**S2 (The phase comparison is an analogy).** Reordering static observations can change the cost and intermediate compatible sets. If the same queries and answers are eventually retained, their final intersection is order-independent. Early stopping can instead produce different transcript partitions with the same final target answer (System IQ4–IQ6). None of these statements supplies complex amplitudes, a quantum state or an isomorphism to quantum phase.

**S2a (Acting observations can make order informative).** S2 concerns queries that leave the source unchanged. When an observation acts on the source, the next observation reads the changed source, and the final record can depend on the order. The phase-gate chain of [OG78](../../../../Research/2026-10-10-gate-order-and-address-commutator.md) is an exact continuous example. Under its class conditions, an unknown source state Z passes two gates that differ only in their address operators A₁ and A₂. Gate k reads the quadratic form G_k(Z)=½⟨Z,A_kZ⟩ of its address operator A_k and rotates Z by an angle proportional to a prepared action parameter π₀. Its duration τ(G_k) enters one shared clock record. With π₀=0 the gates do not rotate Z, the record is a function of G₁(Z) and G₂(Z), and the two orders give the same record. With π₀≠0 the two records differ by 2π₀τ′(G₁)τ′(G₂)K(Z)+O(π₀²), where K(Z)=½⟨Z,i[A₁,A₂]Z⟩. For every sufficiently small π₀≠0, some admissible source receives different records from the two orders exactly when A₁ and A₂ do not commute. On a given source with K(Z)≠0 the two records differ for every π₀≠0 below a threshold that depends on that source. Even for noncommuting addresses, at a fixed π₀≠0 the condition K(Z)≠0 alone need not make the records different. One acting program also separates two sources with equal G₁ and G₂. The record then depends on the source beyond the forms that the gates read without acting, and only through the action on the source. This is one specified model class. It supplies neither quantum amplitudes nor an order effect for the static decision trees studied here.

## §2. Immediate Elimination and Future Cost

For a possible answer b to query i, write B_iᵇ = {y ∈ B: f_i(y) = b}. The realized counting gain is log₂|B| − log₂|B_iᵇ|. Before seeing the answer, a uniform-prior information-gain heuristic maximizes the binary answer entropy. This selects the most balanced available split. These are different optimization rules: one is evaluated on an actual branch, the other averages over possible branches.

Two queries can be redundant on a branch when the second is constant on the compatible set left by the first. Pairwise overlap alone does not determine the cost of a complete policy. Under uniform sampling from B, |A ∩ C| = |A||C|/|B| expresses independence of two particular events. A smaller intersection expresses negative association of those events, not global search optimality.

**S3 (Optimal continuation, replacing the local-optimality claim).** Let W(B) be minimum worst-case remaining query count and V_π(B) minimum expected remaining query count for an exact policy. Both are zero when q is constant on B. Otherwise, minimizing over queries with two nonempty branches:

```
W(B) = min_i [1 + max_b W(B_iᵇ)]
V_π(B) = min_i [1 + Σ_b π(B_iᵇ | B) V_π(B_iᵇ)].
```

If no query has feasible continuations on all branches, the value is ∞. Queries constant on B can be removed from any finite successful policy in this static model. Every retained query strictly reduces each branch's candidate set, so these recurrences terminate over proper subsets.

*Proof.* Every nonterminal policy selects a first query and then a policy in each answer branch. Its continuation cost is at least that branch's optimum, giving the lower bound. Conversely, choose a minimizing root and minimizing policies on its branches to attain the expression. Induction on |B| establishes both equalities. The two objectives may select different trees.

Maximizing the immediate counting gain or answer entropy does not minimize either recurrence in general. The earlier S3 proof established only the immediate comparison and therefore did not prove its conclusion about total calls.

**S3a (A uniquely best local split can be globally worse).** Let K = {0,…,8}, q(x) = x and π uniform. Five queries have the following tables:

| State | A | B | C | D | E |
|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 0 | 1 | 0 |
| 2 | 1 | 0 | 1 | 0 | 1 |
| 3 | 1 | 0 | 0 | 0 | 1 |
| 4 | 1 | 0 | 1 | 1 | 0 |
| 5 | 0 | 1 | 0 | 0 | 0 |
| 6 | 0 | 0 | 1 | 0 | 0 |
| 7 | 0 | 0 | 0 | 1 | 0 |
| 8 | 0 | 0 | 0 | 0 | 1 |

A splits 4/5, uniquely maximizing answer entropy. B splits 2/7, and C, D, E each split 3/6. Even with optimal continuations, starting with A gives worst cost 5 and mean 31/9. The C-first tree below attains the minimum worst cost 4 and mean 10/3.

After A = 0, the remaining five candidates can only be tested one at a time by B, C, D, E. Four further queries may be necessary. The split preserved five candidates with a difficult remaining query structure. A cardinality or entropy score omitted that structure.

The costs follow directly from the table. Under A = 0, singleton tests on five candidates have remaining depths (1,2,3,4,4), so their total depths sum to 19. Under A = 1, C then E distinguish the four candidates in two further queries, contributing 12. Thus the best A-first mean is 31/9 and its worst depth is five.

A tree beginning with C attains total depth 30 and worst depth four. On C = 1, use E to separate state 2, then D to separate 4 and 6. On C = 0, use D. Its positive branch {1,7} is separated by B. Its negative branch {0,3,5,8} is split by E, then B on {0,5} or A on {3,8}. The leaf depths are one at depth two, four at depth three and four at depth four.

For completeness, a binary tree with three leaves has total depth at least 5, with six at least 16, with two at least 2, and with seven at least 20. These bounds follow by repeatedly splitting a shortest leaf, or by the binary prefix inequality. Any C-, D- or E-first tree therefore has total depth at least 9 + 5 + 16 = 30. A B-first tree has at least 9 + 2 + 20 = 31. Together with the A-first bound, the displayed C-first tree attains the global mean minimum. Nine distinct leaves also require worst depth at least four. The entropy choice has no tie.

## §3. What Speed Bounds Require

**S4 (Capability inclusion bounds optima).** If one policy class can simulate another with the same observations and costs, its optimal cost cannot be higher. This is the valid basis for a richer-feedback or larger-vocabulary hierarchy. It compares optima. A particular implementation can perform worse despite having more available information.

For N candidates and binary queries, a complete identification tree has worst depth at least ceil(log₂N). Under uniform targets its mean depth is at least log₂N, not generally ceil(log₂N). Attaining these lower bounds requires suitable available partitions. For three equally likely candidates with all identity tests, an optimal tree has depths (1,2,2), mean 5/3 and worst depth 2.

If every reachable nonterminal candidate set has an available split with each branch of size at most ceil(|B|/2), repeatedly choosing such a split reaches identity in at most ceil(log₂N) queries. This is a recursive availability condition. High entropy at the initial state does not establish it at later states. Query alphabets and goals also matter: a particular binary question may settle without identifying all N candidates.

Testing candidates in a uniformly random order until an explicit positive match has expected position (N+1)/2. If one instead stops once the last untested candidate is logically forced, the expectation is smaller by 1/N. The stopping rule must therefore accompany the formula.

**S4a (Exact random-order accounting).** Suppose the entire finite query vocabulary of size m separates the target answer for actual x. Draw a uniformly random permutation without replacement, query in that order, and stop when q is constant on the compatible set. Then:

```
E[T_x] = Σ_{k=0}^{m−1} Pr(a uniform k-subset has not settled q(x)).
```

*Proof.* For integer T_x between zero and m, E[T_x] = Σ_{k=0}^{m−1} Pr(T_x > k). Static answers and retaining intersection make the first k queries' effect depend on their set, whose distribution is uniform. Each unresolved event is an exact finite subset count. If the full vocabulary cannot settle the answer, exhaustion and successful stopping must be distinguished.

This identity uses a specified random-order distribution. Replacing it with a renewal approximation needs assumptions about the increments, dependence and stopping rule. Query information normally changes with the history, so the earlier entropy-moment formula and its claimed universal overestimate are withdrawn. The reported speedup factor H_max/H̄ is not a general theorem.

These limitations do not make greedy search useless. [Dasgupta's analysis of greedy active learning](https://proceedings.neurips.cc/paper/2636-analysis-of-a-greedy-active-learning-strategy.pdf) proves approximation guarantees in its finite identification setting. Approximation under explicit assumptions is different from exact optimality or automatic convergence to η = 1.

## §4. Certificates and Implementable Strategies

**S5 (Efficiency requires a common objective).** For a finite positive cost C(P) of an exact policy and the corresponding optimum C*, define η = C*/C(P). The objective, prior where applicable, query vocabulary, initial knowledge and cost units must match. Then η = 1 means that P attains that optimum. It does not mean that every query is most informative locally or that every executed query adds a new useful record.

**S5a (Trajectory counting gain telescopes).** Along any sound static-query trajectory B₀ ⊇ … ⊇ B_T, the sum of log₂|B_{k−1}| − log₂|B_k| equals log₂|B₀| − log₂|B_T|. For full identification from a uniform initial compatible set it equals log₂|B₀|, regardless of trajectory length. This is a counting identity. For a coarser target q, the terminal set may have several members and different successful policies can disclose different additional distinctions.

A rare binary answer can leave a singleton from a large B and have realized counting gain above one bit. Binary answer entropy is still at most one bit in expectation. These quantities must not be substituted for each other. Nor does gain-per-call generally equal η: their numerators differ unless a separately established optimum matches the counting gain.

**S5b (The instance-to-policy quantifier gap).** Let cert_B(x,q) be the minimum number of query keys whose answers on x exclude every y ∈ B with q(y) ≠ q(x). These are covers of wrong-answer candidates, or equivalently hitting sets of their distinguishing-key sets (Liquid LQ3/LQ11). Every correct policy's path on x has length at least cert_B(x,q).

If the full vocabulary distinguishes the required answers on all of B, each x has some globally correct policy whose path on x attains its certificate. Query that certificate first along x's answer sequence and use the remaining vocabulary as a fallback on other branches. This proves a separate existence statement for each x. It does not give one policy attaining all instance certificates.

Three distinct objects and the queries “is it object i?” show the gap. Each object's certificate has size one. A policy must choose its first query without knowing which object is actual. Its negative branch still contains two objects, so worst cost is two and the minimum uniform mean is 5/3. The vector (1,1,1) of separate certificate minima is not the depth vector of any correct policy.

Even a rule allowed to inspect the actual branch can fail to find its shortest certificate greedily. For x = 0 and six wrong-answer candidates, query A excludes {1,2,3,4}, B excludes {1,2,5}, and C excludes {3,4,6}. A uniquely excludes the most first, but then both B and C are needed. B and C alone suffice in two calls.

The distinction between instance certificates and decision-tree complexity is standard. See [Buhrman and de Wolf, §4.1](https://homepages.cwi.nl/~rdewolf/publ/qc/dectree.pdf). Saturating the query table makes the optimization problem specified. It does not collapse its quantifiers or make its solution computationally free.

**S6 (What a library can contribute to ordering).** A retained library can supply query models, scoped certificates or previously synthesized policies. Whether it contains a complete current query table is a separate premise. With that table and the declared costs, S3 computes optimal policies by finite search. The search may be expensive, and a deployed policy may be approximate. Library growth alone does not guarantee a better table, better query choices or greater η.

**S11 (Refinement preserves optional capability).** Suppose initial observation r refines observation s on B: s = h ∘ r there. The source is static, both observations have the same acquisition cost, all later queries and costs remain available, and local decoding is uncharged in this model. Then the optimal total worst-case and expected costs after obtaining r are no greater than those after obtaining s.

*Proof.* A policy receiving r can compute s and simulate every subsequent choice of the s-policy. It can ignore the extra distinctions. Thus the richer observation permits every old policy at the same query cost. Taking the infimum gives the inequalities. This is an operational comparison between partitions, not a comparison between their entropy values. A and C in S3a are incomparable partitions, so the theorem does not rank them.

If a richer observation changes the source, consumes a future resource, restricts available actions or costs more to acquire or decode, this simulation needs a new argument. S11 does not cross those boundaries.

**S12 (A useful first observation can give no immediate target information).** Let a,b be independent uniform bits and q = a XOR b. The only queries read a or b. Each read alone leaves q equally likely to be zero or one, so I(q;a) = I(q;b) = 0. Reading both determines q, giving I(q;a,b) = 1 bit. Every exact policy needs both reads.

*Proof.* For either first reading, its two compatible states have opposite q values. Each joint reading identifies one pair and hence q. A policy that rejects every zero-immediate-target-information query would reject both possible first steps and never solve this task.

The first observation prepares an interpretation of the second. This is a relation between questions in a history. For VI and The Cut, it motivates evaluating what a distinction makes accessible next, alongside what it resolves immediately. It suggests training against continuation cost or certified residual structure. An advantage of a learned policy under that objective remains an experimental question.

**S6a (Observation, record and elimination).** Fix the static-query model of Liquid §0: a sound compatible set B, an actual x ∈ B, a question q and immutable keyed queries. A query can both restrict B and add a retained keyed answer. These effects need not both be positive, and retention requires an implemented update.

For a query outcome leaving B′, define h_id = log₂|B| − log₂|B′|. This is a nonnegative counting measure and telescopes over an episode to log₂|B_initial| − log₂|B_final|. Under a uniform prior on the compatible set it is also the branch reduction in hypothesis entropy. For a general prior, conditional entropy can increase on a particular branch (System IQ1–IQ3). Settling q does not require |B_final| = 1.

Let h_str count distinct new retained keys, in records rather than bits. Over T calls, 0 ≤ Σh_str ≤ T. Equality on the right needs every call to use an uncached distinct key and the store to retain it. A newly encountered target alone does not prevent repeated queries. Zero growth does not require its full feature vector to be cached: the episode may repeat one known query forever, or q may already be settled.

**S6b (Relative certificate bound).** Liquid LQ3 proves cert_G(x, q) ≤ d ≤ T for a settling episode that retains d distinct new answers relative to sound initial cache G. Liquid LQ11 identifies the sufficient key sets as covers of the remaining wrong-answer candidates. The bound becomes the usual empty-cache certificate bound when G is empty. This is an instance lower bound, not a proof that an unknown target can be located by an equally cheap adaptive policy.

No physical dissipation bound follows from a count of records. Record volume, logical elimination, Shannon information and dissipated energy have different definitions. Reusing a sufficient partial certificate can require zero new observations even while other features remain unknown. The former Landauer corollary and the claim that full feature coverage is necessary for zero new records are withdrawn.

**S6c (Acquisition requires progress).** More calls can mean more repeated observations or more redundant records. Neither forces improved ordering. The implication from inefficient search to self-correction therefore needs additional premises: the policy eventually selects distinguishing queries, observations are retained with a sound interpretation, and the implementation can exploit them at an acceptable cost.

For fixed finite B and q, eventual separation of every wrong-answer candidate is necessary and sufficient for finite completion (Liquid LQ11). Repeating a known answer is an unresolved fixed point of the cache update when that answer does not settle q. Saturation is not the only possible fixed point. Comparing policies also requires a common query vocabulary and cost convention (IiI §3), not the assumption that every observed value is new useful knowledge.

*Remark (COMPARE as a clock).* Counting comparisons defines an operational clock. Its tick count can increase while retained knowledge and the compatible set remain unchanged. Nothing in this count forces a thermodynamic arrow or a shift to a higher level. In The Cut's closed whole, the observer, source and clock are internal. Their interactions can change accessible correlations without increasing whole-state information, and local retention still needs its own mechanism (Liquid LQ9, PiR M38–M41).

## §5. Complementarity as a Research Question

**S7 (Resource trade-offs need a model).** Library coverage, observation resolution and policy flexibility are different coordinates. No universal three-way impossibility has been proved here. Optional stored information can be ignored under S11's simulation premises, so greater knowledge alone does not force a locked encoding or fewer useful choices. A trade-off would need an explicit shared resource budget, update dynamics or restriction on available policies.

## §6. Reuse Across Levels

**S8 (The MBQC comparison remains an analogy).** Adaptive choice of observations on a prepared resource resembles one part of measurement-based computation. A correspondence of these roles does not establish an isomorphism of state spaces, measurements or achievable computations. The previous table and universality inference supplied none of those maps. No quantum computational guarantee is claimed for a classical cache graph.

**S8a (Theorems transfer with their premises).** A higher level may use structured records from a lower level as its candidates. S1–S6c apply there only after supplying the required finite candidate set, static query semantics, sound history, query availability, costs and policy information. Structural COMPARE's ability to inspect a tree does not provide the whole query table, eventual separating queries or an efficient policy. S6c therefore does not force saturation at every level or an infinite tower.

## §7. Several Agents

**S9 (Cache organization does not establish universality).** Agents may share identical caches, complementary records, overlapping libraries or a graph of communication links. Their usable combined information depends on consistent keys, interpretation, delivery and scope of reuse. Disjoint records can be redundant or contradictory, and distributed coverage need not survive failure of one holder. A cache-overlap graph alone proves neither fault tolerance nor computational universality. Those remain properties to establish for a specified communication and computation model.

## §8. Three Levels of Identity

**S10 (Equality depends on the tested relation).** Agreement on an output, equality of represented structure and interchangeability under later operations are different claims. A unique encoding-local survivor does not establish interchangeability across all encodings or contexts. A certificate transports only when its domain and subsequent context meet the relevant conditions (Verdict VC35–VC36). Closure under future readings gives a precise operational equivalence for the chosen vocabulary (VC38), not every possible meaning of “is”.

## §9. Dependency

### External

| Source | Sections used |
|---|---|
| V=I | §2.4 (comparison), §5.22 (retaining intersection), IQ1–IQ6 (information and transcripts) |
| IiI | §3 (common cost model), §5 (acquisition), §6 (arrival assumptions) |
| Liquid | LQ3 (relative certificate), LQ9 (local access), LQ11 (eventual separation) |
| Verdict | VC30–VC34 (stateful acquisition), VC35–VC36 (context and transport), VC38 (future readings) |
| External | Buhrman and de Wolf (certificate complexity), Dasgupta (greedy approximation under stated assumptions) |

### Internal

| Statement | Depends on |
|---|---|
| S1 | deterministic choice from available history |
| S2 | static observations and the scope of their intersection |
| S2a | acting observations, the OG78 phase-gate class (Research, 10 October 2026) |
| S3 | §0, policy decomposition and proper-subset induction |
| S3a | explicit table, replay and exhaustive depth-vector enumeration |
| S4 | policy simulation and stated partition-availability conditions |
| S4a | uniform random permutation and finite tail-sum identity |
| S5 | common positive objective and exact policies |
| S5a | sound nested candidate sets and telescoping |
| S5b | Liquid LQ3/LQ11 and instance/policy quantifier distinction |
| S6 | supplied query table, S3 and implementation costs |
| S6a | S5a and explicit retaining updates |
| S6b | Liquid LQ3/LQ11 |
| S6c | Liquid LQ11 and usable policy updates |
| S7–S9 | research boundaries, no general impossibility or universality theorem |
| S10 | declared equivalence, context and transport premises |
| S11 | static-source simulation, refinement and equal costs |
| S12 | four-state XOR table and two available queries |

## Topics

### Related type declarations

- ``ThreeAxesOfCompare``
- ``InterferenceIsIntelligence``
- ``IsIsYIdentity``
