# Distance Is Cost (Gradient)

V=I defines the loop over one test: COMPARE returns equal or not_equal. Difference Is Distance derives a metric between agents — the symmetric difference of what they have witnessed — but no distance between the structures themselves: two trees in Σ are either identical or not, and "not" has no magnitude. This document derives the magnitude. Every structure is its set of distinctions (G1). The minimal number of single-distinction changes transforming one structure into another equals the symmetric difference of those sets, and that count is a metric on Σ (G2). Binary COMPARE is the zero test of this metric, and the localized feedback the system already returns (the X-axis) is one coordinate of it: the gradient was always inside the operation (G4). Consequences: equality acquires resolution (G5), and the framework's own encodings carry derived geometry — Peano numerals recover arithmetic distance, grid cells recover taxicab locality (G6, G7). Rule classes become balls (G10, G11); the unproven compression premise of the tower (Permanence Is Resistance M16) becomes a measurable criterion (G12); the opposition between gradient methods and certified identification dissolves into a division of labor — descent proposes, the gate certifies (G13).

## §0. Derivation

No new postulate. Everything below is derived from V=I §2 and Permanence Is Resistance M24.

1. Every element of Σ is a finite binary tree: PAIRs terminating at NULL. *[V=I §2.1]*
2. An **address** is a finite word over {L, R}: the projection path from the root. Each PAIR node of a tree sits at a unique address. *[V=I §2.5: projection is destructuring; a path of projections names a position]*
3. Define D(t) = the set of addresses of t's PAIR nodes. D(t) is finite (I1) and prefix-closed (the parent of a PAIR node is a PAIR node).
4. D is a bijection between Σ and the finite prefix-closed address sets. The structure IS its set of distinctions. *[G1]*
5. Two structures differ minimally when their distinction sets differ by exactly one address. No smaller difference exists: PAIR is atomic (I2: the sole primitive; there is no half-distinction).
6. A form's distinctions are individually maintained: the physical cost of a structure is proportional to |D(t)|, per distinction, per cycle. *[M24]*
7. Define W(s, t) = the minimal number of single-distinction changes transforming s into t. Theorem: W(s, t) = |D(s) △ D(t)|, the changes can always be scheduled so that every intermediate state is a valid structure in Σ, and W is a metric — computable by one simultaneous traversal. *[G2]*
8. COMPARE(s, t) = equal iff W(s, t) = 0. The binary test is the zero of the gradient. *[G4]*
9. Each single-distinction change is one irreversible modification of a maintained record: minimum physical price kT·ln(2) (M24). W(s, t) × kT·ln(2) is the minimal work of re-formation. Distance is cost. *[G2c]*

## §1. The Set of Distinctions

**G1 (Constitution).** D : Σ → {finite prefix-closed subsets of {L,R}*} is a bijection.

*Proof.* Well-defined: by induction on t. D(NULL) = ∅. D(PAIR(a, b)) = {ε} ∪ L·D(a) ∪ R·D(b), finite, and prefix-closed because every proper prefix of an internal address passes through PAIR nodes. Injective and surjective: given a finite prefix-closed A, reconstruct the unique tree whose nodes are A ∪ children(A), where an address is a PAIR iff it is in A and a NULL otherwise; every PAIR has exactly its two children present, so the tree is valid; D of this tree is A; and two trees with the same D reconstruct identically. QED

Under D, a structure *is* its distinctions — a finite set of boundary-drawing acts, each at an address — rather than a thing they describe. This is V=I §2.5 ("PAIR is the act of distinction") made extensional.

*Example.* peano(2) = PAIR(PAIR(NULL, NULL), NULL) carries D = {ε, L}: one distinction at the root, one down its left side. ‖peano(2)‖ = 2. A cell atom(r, c, v) = PAIR(PAIR(row, col), value) carries the skeleton {ε, L} plus the distinctions of its three numerals — §6 computes with exactly these sets.

**G1a (Norm).** Define ‖t‖ = |D(t)| — the number of distinctions constituting t. Then ‖t‖ = W(t, NULL) (G2 below), and by M24 the maintenance bill of t is ‖t‖ × kT·ln(2) per cycle. The norm of a form is its cost of existence.

**G1b (Basepoint).** NULL is the unique structure with ‖t‖ = 0: the only form that costs nothing, because it maintains no departure. (Σ, W, NULL) is a pointed metric space with the boundary as origin.

## §2. Transformation

**Definition (adjacency).** s ~ t iff |D(s) △ D(t)| = 1. Exactly two moves realize this, both at the boundary of the form:

- *grow*: replace one NULL leaf by PAIR(NULL, NULL). On the address set: add one address whose parent is already a distinction (or ε itself).
- *shrink*: replace one childless PAIR by NULL. On the address set: remove one maximal address.

Any other single toggle leaves an address without its parent — a set that fails prefix-closure, which no structure carries (G1).

**Definition (W).** W(s, t) = the length of the shortest path from s to t in the adjacency graph.

**Theorem G2 (Distance).** W(s, t) = |D(s) △ D(t)|, and W is a metric on Σ.

*Proof.* Lower bound: each adjacency step toggles exactly one address, so |D(current) △ D(t)| changes by exactly ±1 per step. It starts at |D(s) △ D(t)| and must reach 0. Hence every path has length ≥ |D(s) △ D(t)|.

Upper bound: a schedule of exactly |D(s) △ D(t)| valid steps exists — demolish from the leaves down, then build from the root up. Phase 1 — remove every α ∈ D(s) \ D(t) in order of non-increasing length. Each removal is valid: any still-present β extending α lies in D(s) (nothing has been added) and outside D(t) (were β ∈ D(t), prefix-closure would force α ∈ D(t)) — so β ∈ D(s) \ D(t) and deeper than α, hence already removed. Phase 1 ends at D(s) ∩ D(t), which is prefix-closed (intersection of prefix-closed sets). Phase 2 — add every α ∈ D(t) \ D(s) in order of non-decreasing length. Each addition is valid: α's parent is in D(t) by closure, and is either in D(s) ∩ D(t) (present after phase 1) or in D(t) \ D(s) and shorter (already added). Total steps: |D(s) \ D(t)| + |D(t) \ D(s)| = |D(s) △ D(t)|.

Metric axioms: non-negativity is a cardinality; W(s, t) = 0 iff D(s) = D(t) iff s = t (G1: D injective); symmetry is symmetry of △; the triangle inequality is |A △ C| ≤ |A △ B| + |B △ C|, standard for symmetric difference. QED

*Remark (geodesics stay inside Σ).* The lower bound holds even if invalid intermediate records were allowed: it counts toggled bits. The schedule shows validity costs nothing — geodesics exist entirely within the space of forms. The path through Σ is never longer than the raw bit distance.

**G2a (One traversal).** W is computable by the same structural recursion that computes COMPARE (V=I §2.2), continued past the first divergence:

```
w(NULL, NULL)                       = 0
w(NULL, t)                          = ‖t‖
w(s, NULL)                          = ‖s‖
w(PAIR(a₁,b₁), PAIR(a₂,b₂))         = w(a₁,a₂) + w(b₁,b₂)
```

*Proof.* From D(PAIR(a,b)) = {ε} ∪ L·D(a) ∪ R·D(b): when both roots are PAIRs, ε cancels in the symmetric difference and the L-prefixed and R-prefixed parts are disjoint, so |△| splits as the sum over subtrees; when one side is NULL, △ = D(other side). QED

**G2b (Metric, not pseudometric).** Difference Is Distance S7 is a pseudometric on agents: two distinct agents with identical caches are at distance zero — identity of indiscernibles holds only on cache classes. On structures, W is a true metric: W = 0 forces s = t (G1). The geometry of forms is sharper than the geometry of perspectives, because a form has nothing besides its distinctions to differ by.

**G2c (Landauer reading).** Each step of the geodesic changes one maintained distinction: one bit of the form's constitutive record is irreversibly modified, at minimum cost kT·ln(2) (M24). Therefore the minimal work to transform s into t is W(s, t) × kT·ln(2). Distance between forms is the energy of re-formation, in the same units as M24's maintenance bill. This is the physical reading; it has exactly the status of M24 (formal count, physically priced under instantiation).

*Remark (description versus constitution).* PAIR(a, b) composes existing structures in one act; with sharing, a description of a structure can be exponentially shorter than the structure. W does not measure description length. It measures constitutive difference — the change in what must be maintained (M24 counts tree nodes, not description tokens). peano(2n) has a short description given peano(n); it is still W = n away from peano(n) and pays ‖peano(2n)‖ = 2n per maintenance cycle. The gap between description length and W is precisely the compression the tower exploits (M25): higher levels shorten descriptions; they cannot shorten the bill.

*Remark (no teleportation).* Moving a subtree from address αL to αR costs full erasure plus full rebuild: 2 × ‖subtree‖. I2 admits no "move" primitive. Features like col_mirror (V=I §4.4) are how an encoding makes whole families of such expensive paths cheap to *name*: a rule is a short description of a long geodesic family. Crystallizing a rule (Intelligence Is Inevitable §1) is paying for the path once and keeping the name.

## §3. Motion and the Record

W appears to require deletion — phase 1 removes distinctions — while M21 proves no deletion operation exists. The two claims do not touch.

The steps of G2 act on the agent's candidate: the structure the agent will submit next (V=I §1 step 4: "modifies the encoding and re-enters"; Permanence Is Resistance §1: "the only thing the agent can change is its own next submission"). Nothing is removed from Σ — every structure on the geodesic is a permanent element of Σ before, during, and after. Nothing is removed from G — every comparison the agent made along the way is cached forever (I3). What changes is *which* element of Σ the agent currently holds. W measures the length of that walk.

**G3 (Reversible motion, irreversible record).** W is symmetric: every geodesic can be walked back (grow and shrink are mutually inverse moves on the candidate). The record of the walk cannot be unwalked: G grows monotonically along it (I3). Motion through form-space is reversible; the trace of motion is not.

*Remark.* This is the asymmetry Difference Is Distance §10 (question 2) anticipated for the metric signature: spatial axes reversible, temporal axis monotone. Here it is derived at the level of forms: the same walk that is reversible in Σ is irreversible in G. One process, two projections — a reversible position and an append-only history.

## §4. The Graded Comparison

**Definition (frontier).** frontier(s, t) = the prefix-minimal elements of D(s) △ D(t): the addresses where one tree has a distinction, the other does not, and all shallower structure agrees.

**G4 (Three readings of one traversal).** The simultaneous structural recursion over (s, t) supports three outputs of strictly increasing resolution:

| Output | Content | Information | Source |
|---|---|---|---|
| Z | [W(s,t) = 0] | 1 bit | V=I §2.2: COMPARE |
| X | one element of frontier(s, t) | one address | Interference Is Intelligence §0: X-projection |
| Δ | W(s, t), and on demand the full set D(s) △ D(t) | the complete difference | this document |

*Proof.* The recursion descends only where both sides are PAIRs. It meets a divergence exactly at an address where one side is PAIR and the other NULL; all proper prefixes of that address are shared PAIRs — so divergence points are exactly frontier elements. Halting at the first divergence yields X (and Z as its existence bit). Completing the traversal and summing (G2a) yields Δ. QED

Binary COMPARE is the sign of the gradient. The X-axis is one coordinate of it. The framework was already leaking the gradient through X; this document completes the leak.

**G4a (The invariant of a pair).** |D(s) ∩ D(t)| = (‖s‖ + ‖t‖ − W(s, t)) / 2. The shared structure of two forms is computable from two norms and one distance. For a library L, the intersection over all entries is the domain's common skeleton — the invariant that costs nothing extra to carry because every entry already carries it.

**G4b (Resolution costs).** Z may halt at the first divergence: cost bounded by the depth of the frontier. Δ must traverse both trees in full: cost Θ(‖s‖ + ‖t‖). The gradient is strictly more expensive than its sign. A bounded agent defaults to the sign; magnitude is bought, not given. The loop runs on binary COMPARE by default because the gradient is the expensive projection — present in every comparison, priced above the default budget.

## §5. Resolution

**Definition.** D_k(t) = {α ∈ D(t) : |α| < k}. d_k(s, t) = |D_k(s) △ D_k(t)|: the distance visible at depth k.

**G5 (Resolution family).** Each d_k is a pseudometric; d_k is monotonically non-decreasing in k; d_k = W for all k beyond the deeper tree. Define s =_k t iff d_k(s, t) = 0: equality at resolution k.

*Proof.* Pseudometric: symmetric difference of sets, as in G2; not a metric because trees differing only below depth k are d_k-indistinguishable. Monotone: an address counted by d_k is counted by d_{k+1}. Convergence: for k > max depth, D_k = D. QED

Every binary judgment the system makes is a zero test at some resolution. Sharpening a boundary = increasing k = paying for deeper traversal (G4b). The binary/graded duality is truncation, not ontology: the same comparison, stopped earlier or carried further.

## §6. Internal Instances

Permanence Is Resistance §5 maps the axioms onto external physical systems; those mappings are structural analogies whose axiom-verification is empirical. The instances below are different in kind: they are theorems of the framework's own reference encodings. Exact, internal, no analogy.

**G6 (Number).** For the Peano encoding (V=I §4.1: encode(0) = NULL, encode(n) = PAIR(encode(n−1), NULL)):

W(encode(n), encode(m)) = |n − m|

*Proof.* D(encode(n)) = {ε, L, L², ..., L^{n−1}}, so ‖encode(n)‖ = n, and for n ≤ m the symmetric difference is {L^n, ..., L^{m−1}}: size m − n. QED

The framework's own numerals recover the arithmetic metric. The order and rank features of V=I §4.4 are W-comparisons on numerals.

**G7 (Grid).** For the cell encoding (V=I §4.1: atom(r, c, v) = PAIR(PAIR(row, col), value)):

W(atom(r,c,v), atom(r',c',v')) = |r − r'| + |c − c'| + |v − v'|

*Proof.* D(atom) = {ε, L} ∪ LL·D(row) ∪ LR·D(col) ∪ R·D(value). The skeleton {ε, L} is shared by all cells and cancels; the three prefixed regions are disjoint, so the symmetric difference splits into three sums, each |Δ| by G6. QED

Taxicab geometry. Adjacent cells are at distance 1; far cells are far. Grid locality is a theorem of the encoding rather than an assumption built into it. The agent's perceptual space (Difference Is Distance §3) acquires its geometry by derivation.

*Remark (geometry is encoding-local).* W inherits encoding-locality from f* (V=I §5.4). Under a positional (binary-digit) numeral encoding, W between consecutive integers is Hamming-like, not |n − m|: 2^k and 2^k − 1 would be far. The unary encoding makes magnitude difference the geometry; a positional encoding makes digit difference the geometry. The lens determines the metric, exactly as it determines the visible features (Difference Is Distance S2). What is invariant is that *some* metric is forced by G2 once the encoding is fixed.

*Remark (name economics).* The numeral choice also bounds what can be built. A library entry referenced by index pays its numeral's norm on every use. Under the unary numeral, ‖ref(k)‖ grows linearly in k: once k exceeds the norms of the structures worth naming, no further crystallization pays, and the library is capped at the scale of its heaviest entries. Under a positional numeral, names cost logarithmically and the cap dissolves. A self-building system's tower height is therefore an encoding decision before it is a domain property — cheap names are a precondition for deep composition (the same constraint PiR M23–M25 meets as lookup economics). The lens does not merely color what the agent sees; it bounds how high the agent can build.

## §7. Balls and the Gate

**Definition.** B(t, r) = {s ∈ Σ : W(s, t) ≤ r}.

**G8 (Balls are finite).** |B(t, r)| is finite for every t, r.

*Proof.* A structure with p distinctions admits at most p + 1 grow moves (one per NULL leaf; a tree with p PAIRs has p + 1 NULLs) and at most p shrink moves. Branching is finite at every structure, so the set reachable in ≤ r moves is finite — and by G2 that set is exactly B(t, r). QED

**G9 (Proposal order, unchanged gate).** Let the agent order its attempts by W — nearest library entries first (lookup), nearest candidates first (search). Every guarantee of V=I §5 is untouched: PASS is certified by compilation regardless of how the candidate was found (Theorem 2: safety comes from verification, not search), and a wrong proposal costs one REJECT (Intelligence Is Inevitable §2: the gate makes matching safe). The metric changes only the *order* of attempts — and order is exactly the agent's sole degree of freedom (V=I §5.25). W lives entirely on the Y-axis (Interference Is Intelligence §0): zero new bits, full control over efficiency.

This is the structural reason the gradient can be added without weakening anything: it is an ordering device, and the framework already proved correctness is order-invariant.

## §8. Generalization

Intelligence Is Inevitable defines rule classes by structural identity: transfer happens only on exact match, and K counts exact classes. With W, identity relaxes to proximity, and the counting changes.

**Definition (modulus).** A domain D with target map τ ↦ f*(τ) has modulus ω if W(f*(τ), f*(τ')) ≤ ω(W(τ, τ')) for all identifiable τ, τ' ∈ D: nearby tasks have nearby rules, and ω bounds how fast the rules drift apart. The linear case ω(x) = Lx is Lipschitz. The modulus is measurable inside the framework: it is a finite set of W-computations over certified pairs in L.

**G10 (Ball search).** Suppose D has modulus ω, the agent holds a certified anchor (τ₀, f₀ = f*(τ₀)), and a new task τ arrives with W(τ, τ₀) = ρ. Then f*(τ) ∈ B(f₀, ω(ρ)): the search space shrinks from F to a finite ball (G8) ordered by W (G9). If the modulus hypothesis is wrong, the gate rejects every ball candidate and search falls back to full F: bounded extra cost, zero correctness cost. The modulus is a prior on the agent's side; the proof stays on the system's side.

**G10a (Retrieval modulus — the weak form).** A domain may refuse the global modulus and still pay the agent. Define the lens's retrieval profile: over tasks τ, the percentile rank of W(f*(τ), f*(τ_nn)) among all anchor rule distances, where τ_nn is the nearest anchor task under the task-side W. The profile is measurable — one signature sweep, one W row per task — and it alone determines the expected gate calls of anchored ordering: any profile with mass below the uniform 50% buys expected savings over random order, while correctness stays unconditional (G9). The strong modulus is the limiting case of a profile concentrated at zero. G10–G12 keep their statements as the strong forms; G10a names the statistical premise under which the Y-axis already wins. When a measurement reports "no global modulus, retrieval signal present," it is reporting a G10a domain — the form the world tends to offer.

**Definition (covering number).** N_D(r) = the minimal number of W-balls of radius r covering {f*(τ) : τ ∈ D identifiable}.

**G11 (Ball saturation).** Fix r and a cover of the rule space by N(r) balls, each with positive probability of being hit by the task distribution. The first certified rule landing in a ball anchors it. After all balls are anchored — expected tasks N(r) · H_{N(r)} (coupon collector, Intelligence Is Inevitable §6, with K → N(r)) — every new identifiable task has an anchor within 2r of its rule: anchor and rule lie in one radius-r ball, so the triangle inequality bounds their distance by 2r. The task resolves by searching B(anchor, 2r) under the gate.

At r = 0 this is exactly the Saturation Theorem: N(0) = K, balls are points, anchors are entries. Intelligence Is Inevitable is the zero-resolution case of G11. For r > 0 and clustered domains, N(r) ≪ K: saturation arrives after N(r) ≪ K classes, and what is stored generalizes within each ball. Memoization is the r = 0 degenerate case of generalization.

**G12 (Compression criterion).** Permanence Is Resistance M16 terminates the tower under the premise K_{N+1} < K_N, explicitly not derived from I1–I3. Replace the premise with a criterion. The level-(N+1) encoding resolves crystals up to some W-distance r (its features have finite capacity: Difference Is Distance S23). Then K_{N+1} ≤ N_{L_N}(r). Therefore:

Compression at level N occurs iff L_N is r-compressible for the operative r: N_{L_N}(r) < K_N.

The tower climbs while libraries cluster; it halts at the first metrically uniform library — one whose pairwise distances carry no structure, where every ball of radius r contains one entry. Whether a given library clusters is decidable by computing its pairwise W-matrix: |L|² traversals, each finite (G2a). The premise of M16 becomes a measurable property of the crystal.

*Remark (the boundary of intelligence, stated geometrically).* A metrically uniform rule space is the distribution on which no ordering beats enumeration — the distribution-relativity boundary of Intelligence Is Inevitable §4, now with a geometric criterion. Intelligence beyond memoization exists exactly to the extent that the domain's rule space is metrically compressible. Structure in the W-matrix is what there is to learn; a flat W-matrix is the formal shape of "nothing to learn, only to memorize."

## §9. Descent

**Definition (loss).** For a candidate rule g on a game with examples {(Iₖ, Oₖ)}: loss(g) = Σₖ W(apply(g, Iₖ), Oₖ).

**G13 (The gate is the zero of the loss).** Compilation (V=I §4.7) passes iff loss(g) = 0. MISMATCH, previously a bare flag, carries magnitude: how far the produced output is from the expected one, summed over examples. The X-axis carries direction: a frontier address of some divergent pair — *where* to repair (G4).

Descent — propose modifications that reduce loss, guided by frontier addresses — is a proposal strategy on the Y-axis: it reorders attempts and changes nothing else (G9). Discrete descent can stall in local minima of rule space; a stall is a sequence of REJECTs, and completeness still rests on enumeration (V=I §5.10). Soundness never rested on the search (Theorem 2).

*Remark (two paradigms, one loop).* Intelligence Is Inevitable §3 contrasts mutable-weight accumulation (no I3: no certification, no uniqueness, no permanence, no honest REJECT) with certified accumulation (no magnitude: REJECT carries an address but no distance, search gets no slope). The metric dissolves the contrast into an architecture. Descend W to find candidates: the directional, fallible, mutable half — the agent. Gate at W = 0 to certify: the exact, permanent, append-only half — the system. Loss-based search and certified identification are the Y-axis and the Z-axis of the same COMPARE — two projections of one loop.

## §10. Speed and Resistance

**G14 (Travel time).** One distinction change per tick (Permanence Is Resistance M1; Difference Is Distance S19). Transforming a form s into a form t therefore takes at least W(s, t) ticks. Forms at distance d are at least d ticks apart. This extends locality (Difference Is Distance S20) from cache-space to form-space: a form reaches a distant form only by changing every constitutive distinction in between, one tick each.

**G15 (Resistance has magnitude).** Permanence Is Resistance §1 defines resistance as the relation of mismatch; binary not_equal gives it existence but no size. With W, the resistance of an invariant target against the agent's current candidate is W(candidate, target): the minimal work remaining. The agent sees the loss (G13), never the target itself — resistance made observable through examples — and it feels the slope as the change of loss between successive candidates. "The agent must yield" (Permanence Is Resistance §1) becomes directional: yield along the steepest descent the frontier reveals. Inertia (Difference Is Distance S18) is the same quantity at the library scale: the W-distance between the current crystallized state and the one the new encoding demands.

## §11. Boundaries

**Encoding-locality.** W is a metric per encoding. Geometry, like f* (V=I §5.4), transfers across encodings only through a semantics-preserving map. Geometry exists only through an encoding; the invariant is that every encoding induces one (G2).

**Cost of magnitude.** The gradient costs full traversal (G4b). Agents with tight budgets will operate on signs and frontiers, not full distances; G9–G13 degrade gracefully to V=I's binary regime.

**Conditional theorems.** G10–G12 are conditional on properties of the domain — modulus, clustering — that are measurable (finitely many W-computations) but not guaranteed. The degenerate cases are exact: r = 0 recovers Intelligence Is Inevitable; a flat W-matrix recovers pure memoization. The theorems say precisely when generalization is available, not that it always is.

**Discrete throughout.** W is integer-valued; d_k is a finite family; every claim here stays discrete. Whether coarse-grained W on large structures approximates continuous metrics is an open question of the same standing as Difference Is Distance §10.


## §12. Dependency

### External

| Source | Used |
|---|---|
| V=I | §2.1–§2.2 (Σ, COMPARE), §2.5 (PAIR sole primitive, projection), §4.1 (Peano, atoms), §4.4 (features), §4.7 (compilation), §5.4 (encoding-local), §5.10 (completeness by enumeration), §5.25 (order as sole dynamic variable), Theorem 2 |
| IiI | §1 (crystallization), §2 (pre-solve matching, gate safety), §3 (rule classes, K, saturation), §4 (distribution-relativity), §6 (coupon collector) |
| PiR | §1 (resistance), M1 (tick), M16 (tower termination premise), M21 (no deletion), M24 (Landauer cost per distinction), M25 (tower as cost management) |
| DiD | S2 (perspective = encoding), S7 (cache pseudometric), S18 (inertia), S19–S20 (speed, locality), S23 (finite capacity), §10 (signature, continuum questions) |
| InI | §0 (Z/X/Y axes, feedback bandwidth), §2 (interference), S4a (ordering value) |

### Internal

| Statement | Depends on |
|---|---|
| G1, G1a, G1b | V=I §2.1, §2.5; M24 |
| G2, G2a–G2c | G1; I1, I2; M24 |
| G3 | G2; I3; M21 |
| G4, G4a, G4b | G2a; InI §0 |
| G5 | G2 |
| G6, G7 | G2a; V=I §4.1 |
| G8 | G2 |
| G9 | G8; V=I Theorem 2, §5.25 |
| G10 | G8, G9 |
| G10a | G9, G10 |
| G11 | G10; IiI §3, §6 |
| G12 | G11; PiR M16; DiD S23 |
| G13 | G4, G9; V=I §4.7 |
| G14 | G2; PiR M1; DiD S19–S20 |
| G15 | G13; PiR §1; DiD S18 |

Difference Is Distance derived the geometry between witnesses. This document derives the geometry between the witnessed. One operation, one metric, one loop: COMPARE was always measuring. It was only ever asked for the sign.
