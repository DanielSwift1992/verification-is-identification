# Navigation Is Geometry (Map)

Distance Is Cost gave the library a metric: every pair of entries has a distance W, computable by one traversal. A metric space is not yet a map. This document derives the map.

The library under W is a finite metric space, and connecting entries within radius ρ makes it a graph. The graph is connected exactly above a computable threshold, and greedy descent toward a target terminates in at most W(start, target) hops, because the metric is integer-valued and every hop strictly decreases it. Where greedy descent fails, it fails at an address — a named node, a named target, a named radius, a hole that says where an anchor is missing. Holes are repaired by insertion, repairs are permanent, and inserting an anchor never creates a hole where none was: the router's failures are the acquisition curriculum.

Above that unconditional core sit the conditional theorems, in the same standing as the modulus and the compression criterion. A library whose geometry is hierarchically separated is navigable at small radius in logarithmic hops, the cost of building the map amortizes over queries with a computable crossover, and a populating library navigates inevitably, for the same reason intelligence is inevitable — append-only accumulation over a finite clustered space. Learning, generalization, and navigation turn out to be three readings of one measurable property of the W-matrix.

The map is not added to the library. It was implied by the metric, and this document only draws it.

## §0. Derivation

No new postulate. Everything below is derived from the metric (DiC G2), the library (IiI §3; PiR §2), and the invariants I1–I3.

1. The saturated library L is a finite set of structures in Σ. *[IiI §3; PiR §2]*
2. W is a metric on Σ, integer-valued, computable by one traversal. *[DiC G2, G2a]*
3. A finite set with a computable metric has a computable distance matrix: |L|² traversals. *[1 + 2]*
4. Fixing a radius ρ turns the matrix into a graph: entries are nodes, pairs with W ≤ ρ are edges. *[N1]*
5. Routing toward any W-computable target is greedy descent on this graph; descent strictly decreases an integer quantity bounded below — it terminates. *[N5]*
6. Termination is arrival or a local minimum; a local minimum carries its own address. *[N6]*
7. Every routing question over the finite graph is decidable offline. *[N7; I1]*
8. Append-only insertion (I3) makes the graph's failures monotonically removable and its repairs permanent. *[N15–N16]*

The earlier papers built the entries. This document is about getting between them without scanning all of them.

## §1. The Anchor Graph

**N1 (Anchor graph).** For a library L and radius ρ, define Γ(L, ρ): nodes are the entries (anchors), edges are pairs (a, b) with W(a, b) ≤ ρ. Finite (I1), computed from the W-matrix (DiC G2a), recomputed incrementally on insertion: one row of traversals per new entry.

**N2 (Connectivity threshold).** Γ(L, ρ) is connected iff ρ ≥ ρ\*, where ρ\* is the largest edge weight of a minimum spanning tree of the W-matrix.

*Proof.* If ρ ≥ ρ\*: every MST edge has weight ≤ ρ\* ≤ ρ, so the MST is a spanning connected subgraph of Γ. If ρ < ρ\*: let e be an MST edge of weight ρ\*. By the cut property, e is a minimum-weight edge across the cut it spans; every other edge across that cut weighs ≥ ρ\* > ρ, so no edge of Γ(L, ρ) crosses it. Disconnected. QED

**N3 (Greedy descent).** Given a W-computable target τ (any structure in Σ — a query signature, a task encoding, another entry), the greedy walk from anchor s: move to the neighbor n minimizing W(n, τ), provided W(n, τ) < W(current, τ); halt otherwise. Each step costs deg(current) traversals (one W per neighbor, G2a).

**N4 (Stretch).** For a walk that arrives, stretch = (hops taken) / (graph distance from start to arrival). Stretch ≥ 1; its distribution over (start, target) pairs is a property of the geometry, measured, not bounded in general.

## §2. Descent

**N5 (Ballistic termination).** A greedy walk from s toward τ terminates in at most W(s, τ) hops.

*Proof.* W is integer-valued (DiC: a count of distinctions) and bounded below by 0. Each step strictly decreases W(·, τ) by at least 1. At most W(s, τ) steps fit. QED

Termination is one of two states: arrival at an anchor with W = 0 to τ — identification of τ's entry (G2b: W = 0 forces identity) — or arrival at the closest reachable anchor, including the global minimum over L when the geometry cooperates (N11).

**N6 (Holes carry addresses).** A greedy walk is *stuck* at s for target τ when no neighbor of s is strictly closer to τ. The triple (s, τ, ρ) is the hole's address, and it is constructive: it names the region — structures within ρ of s and closer to τ than s — in which L has no anchor. The failure does not say "lost"; it says where the map is blank, with coordinates.

**N7 (Decidability).** For fixed L and ρ, greedy success or failure for every (start, target) pair over any finite target set is decidable: finitely many walks, each terminating (N5), each step computable (G2a). The whole routing table — and every hole in it — is computable offline, before any query arrives.

## §3. Thresholds

**N8 (Monotonicity in radius).** Stuckness is monotone: if s is stuck for τ at radius ρ′, it is stuck at every ρ ≤ ρ′. Equivalently, growing ρ only removes holes, never creates them.

*Proof.* Neighbors at radius ρ are a subset of neighbors at ρ′ ≥ ρ. The stuck condition — no neighbor strictly closer — survives subsetting: removing options cannot unstick. Conversely, adding options (larger ρ) can only provide a closer neighbor. QED

In substituted readings the same statement is monotonicity in capability: richer edge sets — more actions, more moves, more reachable variants per step — strictly shrink the set of traps and never grow it.

**N9 (Navigability threshold).** ρ_nav(L) = the least ρ at which greedy descent succeeds for every (start, target) pair over L. It exists: at ρ = diam(L) the graph is complete and the target's own entry is every node's neighbor — every walk arrives in one hop. It is computable: success at fixed ρ is decidable (N7) and monotone in ρ (N8), so binary search over ρ ∈ [ρ\*, diam] finds the threshold in log₂(diam) probes.

**N10 (Query cost).** A routed query costs Σ deg(node) traversals along the walk — at most hops × max-degree. A linear scan costs |L| traversals. Routing wins exactly when hops × deg < |L|; the win factor is a measured property of the graph, and the regime where it is large — few hops, modest degree — is the regime the conditional theorems below characterize.

## §4. Navigable Geometries

The statements so far are unconditional. The useful regime — small ρ_nav, few hops — is not guaranteed by I1–I3. It is a property of the domain's geometry, with the same standing as the modulus (G10) and the compression criterion (G12): measurable, not derivable.

**N11 (Nested separated covers).** Premise: L admits a nested sequence of covers C₀ ⊃ C₁ ⊃ ... ⊃ C_m at scales r₀ > r₁ > ... > r_m, where C₀ is one ball of radius diam, each cluster at scale i is contained in a cluster at scale i−1, distinct clusters at scale i are separated by ≥ λ·rᵢ with λ > 2, and every cluster contains at least one anchor. This is the dendrogram condition: the library's hierarchical clustering has well-separated levels. Decidable for a given L by inspection of the W-matrix; its empirical signature is a Gromov four-point constant δ small relative to the diameter (tree-likeness).

**N12 (Logarithmic hops).** Under N11, greedy descent at radius ρ ≥ 2·r₀/λ... — the condition in full: at each scale i, separation λ > 2 makes the target's cluster strictly closer than any sibling cluster, so a greedy step from an anchor in the wrong scale-i cluster moves into the target's scale-i cluster within one inter-cluster hop, and the walk descends one scale level per bounded number of hops. Total hops = O(m) = O(log(diam)) for geometrically decreasing scales — logarithmic in the diameter, sub-linear in |L|.

*Proof sketch.* From anchor a in a sibling cluster at scale i, every anchor b in the target's cluster satisfies W(b, τ) ≤ rᵢ and W(a, τ) ≥ λ·rᵢ − rᵢ > rᵢ (separation, λ > 2): b is strictly closer, and any neighbor in the target's cluster is a strict improvement; nested containment repeats the argument at scale i+1. The bounded-hops-per-scale constant depends on cluster occupancy — part of the premise, measured. QED

**Degenerate case, exact.** A metrically uniform library — all pairwise distances comparable — admits no separated nesting: ρ_nav ≈ diam, the graph is only navigable when complete, and routing degenerates to scanning. The map of a flat geometry is a list.

## §5. Economics

**N13 (Amortization).** Building the map costs |L|² traversals once (the W-matrix). Each routed query saves (|L| − hops × deg) traversals against the scan (N10). The crossover — queries until the map has paid for itself — is |L|² / (|L| − hops × deg): finite, computable in advance from measured quantities. Past it, the map is pure profit, and the profit compounds with query rate. Incremental maintenance (one matrix row per insertion) keeps the ledger linear after the initial build.

**N14 (Attachment signature).** As the library grows by crystallization under a modulus (G10), new entries land within ω(·) of the classes that produced them: insertions attach near existing anchors. Anchors central to dense regions accumulate degree; the degree distribution of Γ(L, ρ) skews toward hubs — ball centers in the sense of G11. The histogram of deg(a) is therefore a cheap diagnostic of clustered growth: skewed degrees are the signature of attachment, flat degrees the signature of uniform scatter. A signature, not a law: read it, do not assume it.

## §6. Repair

**N15 (Holes are repairable, constructively).** Given a hole (s, τ, ρ): any new anchor a with W(s, a) ≤ ρ and W(a, τ) < W(s, τ) removes it. Such structures exist in Σ — every geodesic from s toward τ passes through valid structures at every intermediate distance (DiC G2: the schedule stays inside Σ), so the required region is never empty as a region of Σ. Whether the region contains a *certifiable entry* — a rule some task can certify — is the domain's affair: the hole names what to look for; finding a task that crystallizes there is acquisition, not deduction.

**N16 (Repairs are permanent; insertion is safe).** Inserted anchors never leave (I3; PiR M21), so a removed hole stays removed. And insertion cannot damage the rest of the map: a node that had a strictly-closer neighbor still has it after any insertion — stuckness only shrinks under anchor addition. Walks may re-route through new anchors; they cannot newly strand.

*Proof.* Stuckness at (s, τ) is "no neighbor strictly closer." Insertion adds candidate neighbors and removes none; an existing strict improvement persists. QED

**N17 (The failure curriculum).** N6 gives every routing failure an address; N15 makes the address actionable; N16 makes acting on it monotone progress. Therefore the set of current holes IS the acquisition agenda: each hole names the region where the next certified entry buys navigability, and hole-directed acquisition strictly reduces the hole count, while undirected acquisition only might. The router's failures are the curriculum — the navigation-level instance of the series' one pattern: the failure names its own cure.

## §7. The Profile

Between ρ\* (connectivity, N2) and diam (trivial completeness), the graph has a measurable profile: greedy success rate over (start, target) pairs, stretch distribution (N4), hole count and hole addresses (N6–N7), degree histogram (N14) — each as a function of ρ. The profile is the domain's navigability made visible: success rising to 1 at ρ_nav, stretch falling toward 1 as shortcuts appear, holes draining as anchors populate. Two libraries with identical K and identical covering numbers can carry different profiles; the profile is finer than the cover. All of it is offline, exact, and reproducible from the W-matrix alone — the map's quality is itself a certified measurement, not an impression.

## §8. One Boundary, and Inevitability

**N18 (One boundary, three faces).** Three conditional capacities of the framework rest on one object — the structure of the W-matrix:

| Face | Capacity | Criterion | Flat case |
|---|---|---|---|
| Learning | compression beyond memoization | G12: N(r) < K | every class its own entry |
| Generalization | transfer within balls | G10–G11: modulus, anchored balls | r = 0, exact match only |
| Navigation | sub-linear routing | N11: separated nesting; small ρ_nav | scan the library |

The three criteria are not three assumptions: they are three consumers of one measurable property — whether the domain's rule space clusters. A flat W-matrix denies all three at once; a clustered one offers all three at once. There is one boundary, and it is a number you can compute.

**N19 (Inevitability under population).** Premises: a task stream with positive probability for every class (IiI §6), a modulus (G10), and clustered geometry (G12). Then: every ball of the cover eventually receives an anchor (coupon collector over N(r) balls, IiI §6); stuck-sets shrink monotonically with each insertion and never grow (N16); ρ_nav(L_t) is non-increasing in t and converges. The limit navigability is set by the geometry, and it is reached and kept — I3 forbids regression. Navigation becomes inevitable for the same structural reason intelligence does: append-only accumulation over a finite clustered space leaves the system nowhere to go but covered. The Saturation Theorem populated the library; this statement says the populated library is, eventually and permanently, a place you can move around in.

## §9. Boundaries

**Conditional core.** N11–N12, N14, N19 are premise-bound; the premises are measurable (dendrogram separation, δ, degree law, class probabilities) and not guaranteed by I1–I3 — the standing of G10 and G12, unchanged. The degenerate cases are exact and stated.

**Greedy is not optimal.** Greedy descent finds a path, not the shortest path; stretch is measured (N4), not bounded, outside N11's premise.

**Targets must be comparable.** Routing requires W(anchor, τ) to be computable: τ must be encoded in the same encoding as the library (DiC §11, encoding-locality). A query in a foreign encoding is not near or far; it is unmeasurable — translation first (DiD S9).

**The map is level-relative.** Γ(L, ρ) maps one library at one level. Each tower level carries its own map; the construction is level-invariant for the same reason everything else is (InI S8a): it references only finiteness, decidability, and the metric.


## §10. Statement

1. The library under W is a finite metric space; a radius makes it a graph; the connectivity threshold is the largest MST edge — computable, exact (N1–N2).
2. Greedy descent toward any comparable target terminates in at most the initial distance: the metric is integer-valued and every hop pays at least one distinction (N5).
3. Failure is an address, not a verdict: a stuck walk names the node, the target, and the blank region (N6–N7).
4. Navigability has a threshold, monotone in radius and capability, computable by binary search (N8–N10).
5. Hierarchically separated libraries are navigable at small radius in logarithmic hops; flat libraries are lists — both cases exact (N11–N12).
6. The map amortizes over queries with a computable crossover; clustered growth leaves a degree signature (N13–N14).
7. Holes are constructively repairable, repairs are permanent, insertion is safe, and the holes themselves are the curriculum (N15–N17).
8. Learning, generalization, and navigation are three faces of one measurable boundary: the clustering of the W-matrix (N18).
9. Under population, navigation is inevitable — and stays (N19).

> **The metric was the map all along. Drawing it costs a matrix; reading it costs a walk; failing on it produces an address; and every anchor added makes it permanently better. A library you can search is a cache. A library you can navigate is a territory.**

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
| N1 | I1; DiC G2a |
| N2 | N1 |
| N3, N4 | N1; DiC G2a |
| N5 | N3; DiC G2 (integer metric) |
| N6 | N5 |
| N7 | N5; I1 |
| N8 | N3 |
| N9 | N7, N8 |
| N10 | N3; DiC G2a |
| N11 | N1; DiC G11–G12 |
| N12 | N11 |
| N13 | N10 |
| N14 | DiC G10–G11; IiI §1 |
| N15 | N6; DiC G2 (geodesics inside Σ) |
| N16 | N15; I3; PiR M21 |
| N17 | N6, N15, N16 |
| N18 | DiC G10–G12; N11 |
| N19 | N16; IiI §6; DiC G10, G12 |

Distance Is Cost gave every pair of forms a number. This document gives the numbers a use: not to rank the library but to move through it. The gradient told the agent how far. The map tells it which way.

## Topics

### Theorems this paper proves

- ``AnchorGraph``
- ``GreedyDescentTerminates``
- ``HolesCarryAddresses``
- ``RepairsPermanent``
- ``FailureCurriculum``
- ``OneBoundaryThreeFaces``
- ``NavigationInevitable``
