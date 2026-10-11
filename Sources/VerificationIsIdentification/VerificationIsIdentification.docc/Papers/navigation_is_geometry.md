# Navigation Is Geometry (Map)

Distance Is Cost gave the library a metric: every pair of entries has a distance W, computable by one traversal. A metric space is not yet a map. Here the author derives the map.

A declared finite library under W and a chosen radius define a graph. A walk taking strict W-decreases has a finite bound, while arrival additionally requires accessible improving transitions. A missing transition can be stated as a question about a start, target and radius. Insertion preserves existing edges but can introduce new routing obligations.

The conditional results distinguish a supplied routing certificate, the cost of using it and the acquisition of the required anchors. N12 requires actual access for its hop bound. N18 separates approximation, anchored recovery and navigation. N19 shows why a global routing threshold can increase when the domain expands.

## §0. Derivation

The graph arguments assume a declared finite library, the specified W metric and the chosen radius. Routing policies, access and acquisition premises are stated separately.

1. The saturated library L is a finite set of structures in Σ. *[IiI §3; PiR §2]*
2. W is a metric on Σ, integer-valued, computable by one traversal. *[DiC G2, G2a]*
3. A finite set with a computable metric has a computable distance matrix: |L|² traversals. *[1 + 2]*
4. Fixing a radius ρ turns the matrix into a graph: entries are nodes, pairs with W ≤ ρ are edges. *[N1]*
5. Routing toward any W-computable target is greedy descent on this graph, and descent strictly decreases an integer quantity bounded below: it terminates. *[N5]*
6. Termination is arrival or a local minimum, and a local minimum carries its own address. *[N6]*
7. Every routing question over the finite graph is decidable offline. *[N7; I1]*
8. Retaining insertion preserves supplied improving edges at fixed start/target coordinates. New vertices can add new obligations. *[N15–N19]*

The earlier papers built the entries. This document is about getting between them without scanning all of them.

## §1. The Anchor Graph

**N1 (Anchor graph).** For a library L and radius ρ, define Γ(L, ρ): nodes are the entries (anchors), edges are pairs (a, b) with W(a, b) ≤ ρ. Finite (I1), computed from the W-matrix (DiC G2a), recomputed incrementally on insertion: one row of traversals per new entry.

**N2 (Connectivity threshold).** Γ(L, ρ) is connected iff ρ ≥ ρ\*, where ρ\* is the largest edge weight of a minimum spanning tree of the W-matrix.

*Proof.* If ρ ≥ ρ\*: every MST edge has weight ≤ ρ\* ≤ ρ, so the MST is a spanning connected subgraph of Γ. If ρ < ρ\*: let e be an MST edge of weight ρ\*. By the cut property, e is a minimum-weight edge across the cut it spans, and every other edge across that cut weighs ≥ ρ\* > ρ, so no edge of Γ(L, ρ) crosses it. Disconnected. QED

**N3 (Greedy descent).** Given a W-computable target τ (any structure in Σ: a query signature, a task encoding, another entry), the greedy walk from anchor s: move to the neighbor n minimizing W(n, τ), provided W(n, τ) < W(current, τ), and halt otherwise. Each step costs deg(current) traversals (one W per neighbor, G2a).

**N4 (Stretch).** For a walk that arrives, stretch = (hops taken) / (graph distance from start to arrival). Stretch ≥ 1, and its distribution over (start, target) pairs is a property of the geometry, measured, not bounded in general.

## §2. Descent

**N5 (Ballistic termination).** A greedy walk from s toward τ terminates in at most W(s, τ) hops.

*Proof.* W is integer-valued (DiC: a count of distinctions) and bounded below by 0. Each step strictly decreases W(·, τ) by at least 1. At most W(s, τ) steps fit. QED

Termination is one of two states: arrival at an anchor with W = 0 to τ (identification of τ's entry, G2b: W = 0 forces identity) or arrival at the closest reachable anchor, including the global minimum over L when the geometry admits it (N11).

**N6 (Holes carry addresses).** A greedy walk is *stuck* at s for target τ when no neighbor of s is strictly closer to τ. The triple (s, τ, ρ) is the hole's address, and it is constructive: it names the region (structures within ρ of s and closer to τ than s) in which L has no anchor. The failure does not say "lost": it says where the map is blank, with coordinates.

**N7 (Decidability).** For fixed L and ρ, greedy success or failure for every (start, target) pair over any finite target set is decidable: finitely many walks, each terminating (N5), each step computable (G2a). The whole routing table (and every hole in it) is computable offline, before any query arrives.

## §3. Thresholds

**N8 (Monotonicity in radius).** Stuckness is monotone: if s is stuck for τ at radius ρ′, it is stuck at every ρ ≤ ρ′. Equivalently, growing ρ only removes holes, never creates them.

*Proof.* Neighbors at radius ρ are a subset of neighbors at ρ′ ≥ ρ. The stuck condition (no neighbor strictly closer) is preserved under subsetting: removing options cannot unstick. Conversely, adding options (larger ρ) can only provide a closer neighbor. QED

In substituted readings the same statement is monotonicity in capability: richer edge sets (more actions, more moves, more reachable variants per step) strictly shrink the set of traps and never grow it.

**N9 (Navigability threshold).** ρ_nav(L) = the least ρ at which greedy descent succeeds for every (start, target) pair over L. It exists: at ρ = diam(L) the graph is complete and the target's own entry is every node's neighbor, and every walk arrives in one hop. It is computable: success at fixed ρ is decidable (N7) and monotone in ρ (N8), so binary search over ρ ∈ [ρ\*, diam] finds the threshold in log₂(diam) probes.

**N10 (Query cost).** A routed query costs Σ deg(node) traversals along the walk, at most hops × max-degree. A linear scan costs |L| traversals. Routing wins exactly when hops × deg < |L|. The win factor is a measured property of the graph, and the regime where it is large (few hops, modest degree) is the regime the conditional theorems below characterize.

## §4. Navigable Geometries

The statements so far are unconditional. The useful regime (small ρ_nav, few hops) is not guaranteed by I1–I3. It is a property of the domain's geometry, with the same standing as the modulus (G10) and the compression criterion (G12): measurable, not derivable.

**N11 (Nested separated covers).** Premise: L admits a nested sequence of covers C₀ ⊃ C₁ ⊃ ... ⊃ C_m at scales r₀ > r₁ > ... > r_m, where C₀ is one ball of radius diam, each cluster at scale i is contained in a cluster at scale i−1, distinct clusters at scale i are separated by ≥ λ·rᵢ with λ > 2, and every cluster contains at least one anchor. This is the dendrogram condition: the library's hierarchical clustering has well-separated levels. Decidable for a given L by inspection of the W-matrix, and its empirical signature is a Gromov four-point constant δ small relative to the diameter (tree-likeness).

**N12 (A routing bound needs actual access).** Fix a target t in a finite graph and a level assignment ℓ_t with values in {0,…,m}, zero exactly at t. Suppose every other node has an actual permitted neighbor of lower level, and the routing policy selects such a neighbor. Then routing reaches t in at most m hops, because each hop strictly decreases a nonnegative integer. This is a bound from the supplied access and level relations. For finite tree outputs, G2h already supplies a stronger addressed form of progress: strict inclusion of the remaining differences to the same target. Its finite-chain proof does not require a separately represented scalar level.

A nested metric cover alone does not supply the necessary graph edges, a policy that finds them or a logarithmic depth bound. Separation can compare distances between clusters, but it cannot make a missing neighbor accessible. The previous proof of logarithmic routing implicitly used precisely that missing step. A hierarchy yields O(log |L|) hops only after its depth and the accessible transitions supporting that routing bound are established. The work of selecting each transition is an additional cost.

*Exact equal-distance case.* If every distinct pair in L has distance d>0, the radius graph has no edges for ρ<d and is complete for ρ≥d. This follows directly from N1. A policy comparing all neighbors pays for a scan in the complete case. A direct task-to-target reader need not scan those neighbors, so this graph fact is not a lower bound on every solver or a prohibition on reuse.

## §5. Economics

**N13 (Amortization).** Building the map costs |L|² traversals once (the W-matrix). Each routed query saves (|L| − hops × deg) traversals against the scan (N10). The crossover (queries until the map has paid for itself) is |L|² / (|L| − hops × deg): finite, computable in advance from measured quantities. Past it, the map is pure profit, and the profit compounds with query rate. Incremental maintenance (one matrix row per insertion) keeps the ledger linear after the initial build.

**N14 (Attachment signature).** As the library grows by crystallization under a modulus (G10), new entries land within ω(·) of the classes that produced them: insertions attach near existing anchors. Anchors central to dense regions accumulate degree, and the degree distribution of Γ(L, ρ) skews toward hubs: ball centers in the sense of G11. The histogram of deg(a) is therefore a cheap diagnostic of clustered growth: skewed degrees are the signature of attachment, flat degrees the signature of uniform scatter. A signature, not a law: read it, do not assume it.

## §6. Repair

**N15 (Holes are repairable, constructively).** Given a hole (s, τ, ρ) with s≠τ and integer ρ≥1: any new anchor a with W(s, a) ≤ ρ and W(a, τ) < W(s, τ) removes it. Such structures exist in Σ: every geodesic from s toward τ passes through valid structures at every intermediate distance (DiC G2: the schedule is inside Σ throughout), so the required region is never empty as a region of Σ. For ρ=0 no distinct tree is accessible, so this repair claim does not apply. Whether the region contains a *certifiable entry* (a rule some task can certify) is the domain's affair: the hole names what to look for, and finding a task that crystallizes there is acquisition, not deduction.

**N16 (Existing improving edges are retained).** Under an insertion policy retaining old vertices and edges at a fixed radius, a strictly closer neighbor for a fixed pair (s,τ) remains available. A supplied path using old edges also remains available. New vertices can create new start/target pairs, and a changed routing policy can choose different paths. This local preservation result does not bound every walk in the expanded graph.

*Proof.* Stuckness at (s, τ) is "no neighbor strictly closer." Insertion adds candidate neighbors and removes none, and an existing strict improvement persists. QED

**N17 (A failure can specify an acquisition question).** A witnessed missing improving neighbor gives a concrete region to examine. Supplying an admissible anchor in that region removes this particular hole, as N15–N16 show. It does not prove such a rule can be acquired or that the total number of holes decreases when new start/target pairs are added. A useful curriculum must therefore retain the failure coordinates, the actual repair witness and the domain over which progress is measured.

## §7. The Profile

For a fixed finite library, target set and deterministic tie-breaking policy, the W-matrix determines a routing profile at each radius: success rate, stretch for arriving distinct start/target pairs (N4), hole count and addresses (N6–N7), and degree histogram. Increasing radius removes holes at fixed coordinates (N8), and all pairs over L succeed at ρ_nav. This does not prove monotonicity of every individual walk's success or stretch. Enlarging L changes the pairs being measured and can worsen the global threshold (N19). Exact comparison of profiles must therefore retain the domain, radius, target set and policy alongside the matrix.

## §8. Shared Metric, Distinct Obligations

**N18 (Different contracts sharing a metric).** Approximation, anchored recovery and navigation can use the same W, but require different relations. G12 gives the least number of representatives for a specified approximation error. G10–G11 require a task-to-rule bound or covered anchors and access to a containing search region. A navigation claim additionally names an edge radius, permitted moves, targets and a routing policy. Sharing the metric does not make these premises equivalent.

G12's flat family has a one-center radius-1 cover and an exact direct reader. Thus a constant off-diagonal matrix excludes neither representative economy nor exact reuse. Conversely a small cover supplies no edges at an arbitrarily small navigation radius and no dispatcher from tasks to anchors. For a fixed finite library, its pairwise matrix can determine a chosen radius graph. It does not specify what task observations or operations are available outside that graph. There is no single clustering number deciding all three capacities.

**N19 (Population preserves witnesses, not every global routing score).** Under an explicit arrival and acquisition model establishing eventual coverage of a fixed finite rule set, retained entries eventually represent that set. G11 gives one IID sufficient model. Positive marginal probabilities alone are insufficient, as IiI §6 shows. Once the required anchors and transitions for a supplied routing certificate are present and retained, those paths remain available.

The global navigability threshold over a growing vertex set need not decrease. With unary trees encoding 0 and 1, the threshold is 1. Add the tree encoding 100. At any radius below 99, that new node is isolated. At radius 99, the chain 0–1–100 supports greedy progress to every target in this three-node library, so the new threshold is 99. G6 supplies these actual tree distances. Old edges were preserved, but a new start and target introduced a harder obligation. Retention therefore preserves existing path witnesses without proving monotonicity of an aggregate score over an expanded domain.

## §9. Boundaries

**Conditional core.** N11–N12, N14, N19 are premise-bound. The premises are measurable (dendrogram separation, δ, degree law, class probabilities) and not guaranteed by I1–I3: the standing of G10 and G12, unchanged. The degenerate cases are exact and stated.

**Greedy is not optimal.** Greedy descent finds a path, not the shortest path, and stretch is measured (N4), not bounded, outside N11's premise.

**Targets must be comparable.** Routing requires W(anchor, τ) to be computable: τ must be encoded in the same encoding as the library (DiC §11, encoding-locality). A query in a foreign encoding is not near or far: it is unmeasurable, and the first step is translation (DiD S9).

**The map is level-relative.** Γ(L, ρ) maps one library at one level. Each tower level carries its own map, and the construction is level-invariant for the same reason everything else is (InI S8a): it references only finiteness, decidability, and the metric.


## §10. Statement

1. The library under W is a finite metric space, a radius makes it a graph, and the connectivity threshold is the largest MST edge: computable, exact (N1–N2).
2. Greedy descent toward any comparable target terminates in at most the initial distance: the metric is integer-valued and every hop pays at least one distinction (N5).
3. Failure is an address, not a verdict: a stuck walk names the node, the target, and the blank region (N6–N7).
4. Navigability has a threshold, monotone in radius and capability, computable by binary search (N8–N10).
5. A supplied routing level and actual descending transitions bound hops. Nested covers alone do not establish logarithmic routing (N11–N12).
6. The map amortizes over queries with a computable crossover, and clustered growth leaves a degree signature (N13–N14).
7. An admissible improving anchor repairs its addressed hole. Retaining old edges preserves that improvement, while new pairs require their own routing witnesses (N15–N17).
8. Approximation, anchored recovery and navigation share a metric but have different premises (N18).
9. Population and retention preserve supplied paths. Global navigability on an expanding domain need not improve (N19).

> **A routing claim names its starts, targets and permitted moves. Retaining its path preserves that witness. Adding an anchor can repair a named failure while making navigation over the enlarged domain harder.**

## §11. Dependency

### External

| Source | Used |
|---|---|
| V=I | §2 (Σ, I1–I3), Theorem 2 (certified entries, via crystallization) |
| IiI | §1 (crystallization), §3 (library, K, saturation), §6 (coupon collector, stream premise) |
| PiR | §2 (the crystal's three properties), M21 (no deletion) |
| DiD | S9 (translation between encodings) |
| DiC | G1a (norm), G2/G2a/G2b (metric, one traversal, identity), G8 (finite balls), G10 (modulus), G11 (anchored cover), G12 (compression criterion), §11 (encoding-locality) |
| InI | S8a (level invariance) |

### Internal

| Statement | Depends on |
|---|---|
| N1 | I1, DiC G2a |
| N2 | N1 |
| N3, N4 | N1, DiC G2a |
| N5 | N3, DiC G2 (integer metric) |
| N6 | N5 |
| N7 | N5, I1 |
| N8 | N3 |
| N9 | N7, N8 |
| N10 | N3, DiC G2a |
| N11 | N1, DiC G11–G12 |
| N12 | N11 |
| N13 | N10 |
| N14 | DiC G10–G11, IiI §1 |
| N15 | N6, DiC G2 (geodesics inside Σ) |
| N16 | N15, I3, PiR M21 |
| N17 | N6, N15, N16 |
| N18 | DiC G10–G12, N11 |
| N19 | N16, IiI §6, DiC G10, G12 |

Distance Is Cost gave every pair of forms a number. Here the author gives the numbers a use: not to rank the library but to move through it. The gradient told the agent how far. The map tells it which way.

## Topics

### Related type declarations

- ``AnchorGraph``
- ``GreedyDescentTerminates``
- ``HolesCarryAddresses``
- ``RepairsPermanent``
- ``FailureCurriculum``
- ``OneBoundaryThreeFaces``
- ``NavigationInevitable``
