# Distance Is Cost (Gradient)

V=I defines the loop over one test: COMPARE returns equal or not_equal. Difference Is Distance derives a metric between agents (the symmetric difference of what they have witnessed) but no distance between the structures themselves: two trees in Σ are either identical or not, and "not" has no magnitude. Here the author derives the magnitude.

Every structure is its set of distinctions. The minimal number of single-distinction changes transforming one structure into another equals the symmetric difference of those sets, and that count is a metric on Σ. Binary COMPARE is the zero test of this metric, and the localized feedback the system already returns (the X-axis) is one coordinate of it: the gradient was always inside the operation.

The consequences follow. Equality acquires resolution, and the framework's own encodings carry derived geometry: Peano numerals recover arithmetic distance, grid cells recover taxicab locality. A fixed metric supports bounded search and approximation by representatives. These require explicit coverage, application and cost premises. Exact output certification and strict progress can also be expressed through addressed differences without a scalar loss.

## §0. Derivation

The structural metric below follows from the finite tree grammar and the declared single-node edit model. Its conversion to physical cost requires the implementation premises of Permanence Is Resistance M24.

1. Every element of Σ is a finite binary tree: PAIRs terminating at NULL. *[V=I §2.1]*
2. An **address** is a finite word over {L, R}: the projection path from the root. Each PAIR node of a tree is at a unique address. *[V=I §2.5: projection is destructuring; a path of projections names a position]*
3. Define D(t) = the set of addresses of t's PAIR nodes. D(t) is finite (I1) and prefix-closed (the parent of a PAIR node is a PAIR node).
4. D is a bijection between Σ and the finite prefix-closed address sets. The structure IS its set of distinctions. *[G1]*
5. Two structures differ minimally when their distinction sets differ by exactly one address. No smaller difference exists: PAIR is atomic (I2: the sole primitive, and there is no half-distinction).
6. A uniform maintenance model may assign cost `c` per tree node per cycle. This is a physical premise, independent of the metric proof. *[M24]*
7. Define W(s, t) = the minimal number of single-distinction changes transforming s into t. Theorem: W(s, t) = |D(s) △ D(t)|, the changes can always be scheduled so that every intermediate state is a valid structure in Σ, and W is a metric, computable by one simultaneous traversal. *[G2]*
8. COMPARE(s, t) = equal iff W(s, t) = 0. The binary test is the zero of the gradient. *[G4]*
9. W is the minimum number of the declared edits. A physical implementation must separately specify what those edits erase and their actual resource costs. *[G2c]*

## §1. The Set of Distinctions

**G1 (Constitution).** D : Σ → {finite prefix-closed subsets of {L,R}*} is a bijection.

*Proof.* Well-defined: by induction on t. D(NULL) = ∅. D(PAIR(a, b)) = {ε} ∪ L·D(a) ∪ R·D(b), finite, and prefix-closed because every proper prefix of an internal address passes through PAIR nodes. Injective and surjective: given a finite prefix-closed A, reconstruct the unique tree whose nodes are A ∪ children(A), where an address is a PAIR iff it is in A and a NULL otherwise. Every PAIR has exactly its two children present, so the tree is valid, D of this tree is A, and two trees with the same D reconstruct identically. QED

Under D, a structure *is* its distinctions (a finite set of boundary-drawing acts, each at an address) rather than a thing they describe. This is V=I §2.5 ("PAIR is the sole structural primitive: the act of distinction") made extensional.

*Example.* peano(2) = PAIR(PAIR(NULL, NULL), NULL) has D = {ε, L}: one distinction at the root, one down its left side. ‖peano(2)‖ = 2. A cell atom(r, c, v) = PAIR(PAIR(row, col), value) has the skeleton {ε, L} plus the distinctions of its three numerals, and §6 computes with exactly these sets.

**G1a (Norm).** Define ‖t‖ = |D(t)|: the number of distinctions constituting t. Then ‖t‖ = W(t, NULL) (G2 below). Under M24's uniform maintenance model, its bill is `c × ‖t‖` per cycle. The structural norm is defined without that physical model.

**G1b (Basepoint).** NULL is the unique structure with ‖t‖ = 0. It has zero charged nodes under the uniform model, which says nothing about hardware overhead. (Σ, W, NULL) is a pointed metric space with the boundary as origin.

## §2. Transformation

**Definition (adjacency).** s ~ t iff |D(s) △ D(t)| = 1. Exactly two moves realize this, both at the boundary of the form:

- *grow*: replace one NULL leaf by PAIR(NULL, NULL). On the address set: add one address whose parent is already a distinction (or ε itself).
- *shrink*: replace one childless PAIR by NULL. On the address set: remove one maximal address.

Any other single toggle leaves an address without its parent: a set that fails prefix-closure, which no structure has (G1).

**Definition (W).** W(s, t) = the length of the shortest path from s to t in the adjacency graph.

**Theorem G2 (Distance).** W(s, t) = |D(s) △ D(t)|, and W is a metric on Σ.

*Proof.* Lower bound: each adjacency step toggles exactly one address, so |D(current) △ D(t)| changes by exactly ±1 per step. It starts at |D(s) △ D(t)| and must reach 0. Hence every path has length ≥ |D(s) △ D(t)|.

Upper bound: a schedule of exactly |D(s) △ D(t)| valid steps exists: demolish from the leaves down, then build from the root up. Phase 1: remove every α ∈ D(s) \ D(t) in order of non-increasing length. Each removal is valid: any still-present β extending α is in D(s) (nothing has been added) and outside D(t) (were β ∈ D(t), prefix-closure would force α ∈ D(t)), so β ∈ D(s) \ D(t) and deeper than α, hence already removed. Phase 1 ends at D(s) ∩ D(t), which is prefix-closed (intersection of prefix-closed sets). Phase 2: add every α ∈ D(t) \ D(s) in order of non-decreasing length. Each addition is valid: α's parent is in D(t) by closure, and is either in D(s) ∩ D(t) (present after phase 1) or in D(t) \ D(s) and shorter (already added). Total steps: |D(s) \ D(t)| + |D(t) \ D(s)| = |D(s) △ D(t)|.

Metric axioms: non-negativity is a cardinality. W(s, t) = 0 iff D(s) = D(t) iff s = t (G1: D injective). Symmetry is symmetry of △. For the triangle inequality, each address in A △ C belongs to at least one of A △ B and B △ C: membership could not differ between A and C if it agreed across both intermediate comparisons. Hence A △ C ⊆ (A △ B) ∪ (B △ C), and taking finite cardinalities gives |A △ C| ≤ |A △ B| + |B △ C|. QED

The Swift name `MetricProperty` currently checks only the shared endpoint of two addressed legs. It contains no distance values or order relation, and does not require equal leg lengths. A symmetric cost assignment with d(a,b)=1, d(b,c)=1 and d(a,c)=3 has the same endpoint diagram and violates the triangle inequality. Thus `DistanceOnStructures` does not yet connect an arbitrary distance axis to this theorem's W. G2d–G2e construct the difference partition and bound for an explicit finite tree grammar. The existing scalar axis needs a connection to that construction, rather than certification by the protocol's name.

> Argues: ``DistanceIsCost`` needs ``DistanceOnStructures``.

*Remark (geodesics are inside Σ).* The lower bound is true even if invalid intermediate records were allowed: it counts toggled bits. The schedule shows validity costs nothing: geodesics exist entirely within the space of forms. The path through Σ is never longer than the raw bit distance.

**G2a (One traversal).** W is computable by the same structural recursion that computes COMPARE (V=I §2.2), continued past the first divergence:

```
w(NULL, NULL)                       = 0
w(NULL, t)                          = ‖t‖
w(s, NULL)                          = ‖s‖
w(PAIR(a₁,b₁), PAIR(a₂,b₂))         = w(a₁,a₂) + w(b₁,b₂)
```

*Proof.* From D(PAIR(a,b)) = {ε} ∪ L·D(a) ∪ R·D(b): when both roots are PAIRs, ε cancels in the symmetric difference and the L-prefixed and R-prefixed parts are disjoint, so |△| splits as the sum over subtrees. When one side is NULL, △ = D(other side). QED

In particular, extension by a common right context is an isometric embedding: W(PAIR(s,e),PAIR(t,e))=W(s,t). This concerns two extended sources. It does not make W(s,PAIR(s,e)) equal to one. Program Is Path PiP3 gives an actual retaining append with distance three, and uses TreePartition111 to transport the direct masks under a common append. PiP2a transports a retained question through the corresponding prefix projection.

**G2b (Metric, not pseudometric).** Difference Is Distance S7 is a pseudometric on agents: two distinct agents with identical caches are at distance zero: identity of indiscernibles is true only on cache classes. On structures, W is a true metric: W = 0 forces s = t (G1). The geometry of forms is sharper than the geometry of perspectives, because a form has nothing besides its distinctions to differ by.

**G2c (Conditional physical reading).** An edit of one tree node need not erase one unknown physical bit. If an implementation independently establishes that every charged edit resets one unbiased bit under M24's Landauer assumptions, then W edits give a lower heat bound `W(s,t) k_B T ln 2`. Equality and an upper budget do not follow. Reversible implementations need not pay that reset charge for each edit. The Bennett copy-and-uncompute construction prepares its output register blank for its stated copying-output contract. The cost of that preparation depends on the architecture (PiR M24). The metric measures edit count, with a physical conversion supplied by the implementation.

> Argues: ``DistanceIsCost`` needs ``HasCost``.

**G2d (The exact residual of a triangle).** Let A=D(s), B=D(u), C=D(t). Partition the addresses that do not agree across all three sets into:

- X: A differs from B=C.
- Y: B differs from A=C.
- Z: C differs from A=B.

Membership at a fixed address is binary, so exactly one of these cases applies whenever the three memberships are not all equal. Consequently these finite sets are pairwise disjoint, A △ B = X ∪ Y, B △ C = Y ∪ Z, and A △ C = X ∪ Z. Thus

```
W(s,u) + W(u,t) = W(s,t) + 2|Y|,
Y = (A ∩ C) \ B  ∪  B \ (A ∪ C).
```

This proves more than a bound: it identifies every unit of excess. The route through u is shortest exactly when Y is empty, equivalently A ∩ C ⊆ B ⊆ A ∪ C. Prefix closure of B is still required for it to represent a tree. For example, NULL → PAIR(NULL,NULL) → NULL has Y={ε}: two charged edits, zero endpoint distance. These statements concern shortest paths through u, not arbitrary walks with additional repetitions.

The constructive content is a rearrangement of tagged occurrences. The two legs have layout ((X,Y),(Y,Z)). Exchanging their second and fourth fields yields ((X,Z),(Y,Y)). Applying the exchange again restores the legs. Projection onto the first field supplies the direct difference. The second field retains both residual occurrences. Under disjoint finite-set interpretation, cardinality reads this reversible rearrangement as the displayed equation. Equal Y types do not identify the two occurrences or make their charge zero.

`Examples.RegroupDistanceLegs` and `DistanceLegsRestored` check the rearrangement and recovery for arbitrary field types. `CancelDistanceDetour` derives the `Monotone` projection, and `DistanceDetourHasTwoCopies` derives equality of the residual field types from the shared part of the partition legs. No numerical answer, inequality, runtime count or result-equality premise is passed to these constructions. Here the common field is Y, a set of differences. It is not the intermediate tree u in a vertex diagram.

This is the structural kernel of the bound. G2e supplies its partition from a finite constructor grammar of actual tree triples. An arbitrary `MetricProperty` conformer does not acquire that interpretation, and `DistanceOnStructures.Distance` is not thereby bound to W. The constructor domain matters. Adding another conformance label cannot replace it.

**G2e (Construct the partition with its sources).** Use Never for the syntax leaf and Paired for the binary tree constructor. There is a finite type expression computing the G2d partition for every triple of finite trees in this grammar. It uses `EmptyTreePartition` and the seven `TreePartition001` through `TreePartition111` constructors in Examples/Distance.swift.

Each expression has `Left=(s,(u,t))` and `Right=(X,(Y,Z))`. A mask is either Never, denoting the empty set, or `(h,(l,r))`, where h is Never or Lit1. Its set contains ε exactly when h is Lit1, together with the L-prefixed addresses of l and the R-prefixed addresses of r. The prefixes keep child occurrences distinct. This interpretation counts occupied address slots, not Swift's runtime `Structure.count` and not the number of nominal wrapper types.

The terminal supplies three NULL sources and three empty masks. At a nonempty joint root, the constructor's three digits specify which source roots are PAIRs. Each present root constructs its actual source from the corresponding left and right child sources. Each absent root requires both child sources to equal Never and supplies Never as its source. Those `where` constraints prevent a constructor from hiding a nonempty subtree below an absent root.

The root partition follows from its binary pattern:

| Root patterns | Occupied partition slot at ε |
| --- | --- |
| 100, 011 | X |
| 010, 101 | Y |
| 001, 110 | Z |
| 111 | none |
| 000 | terminal, all masks empty |

`PartitionBelowRoot` prefixes the actual child masks and adds these fixed root slots. The caller supplies neither an output tree nor a root classification result.

*Proof.* Induct on the height of the union of the three source address sets. If it is empty, all three sources are NULL and the terminal applies. Otherwise the source roots determine exactly one nonzero pattern. Project each present tree onto its children and pad each absent tree with two NULL children. Both child triples have smaller joint height, so the induction supplies their expressions. Their actual source types satisfy every absent-root constraint of the selected constructor. It therefore constructs the requested source triple. At ε the displayed pattern gives exactly the outlier from G2d. At deeper addresses the induction gives the outlier in the corresponding child, and prefixing preserves both its address and its unique class. Hence the resulting masks are pairwise disjoint and represent X,Y,Z. This also proves completeness and uniqueness of the construction within this finite expression grammar. QED

`PartitionedTreeDistance<P>` composes these actual masks with G2d's cancellation kernel. Thus every generated tree triple supplies the structural decomposition of its two-leg cost into its direct cost and two copies of its detour mask. No separate distance table or numerical solver establishes this result.

A consumer identifies `P.Left` with its requested source triple. Swift verifies the supplied construction expression and that identification. The existence proof does not claim that Swift searches for the expression from three arbitrary input types.

The open `TreePartitionShape` protocol describes the input/output layout. It does not seal the constructor grammar or establish the partition law for arbitrary conformers. Checks/Distance.swift includes a positive counterconstruction: a conformer can pair three NULL sources with an unsupported occupied X mask. G2e applies to finite expressions built from the specified terminal and seven constructors, not to this arbitrary conformer. Swift checks the generic constructor equations, source seams and kernel composition. The induction just given establishes their meaning and coverage. The existing scalar `DistanceOnStructures.Distance` axis still needs an explicit interface to this construction.

An empty padded mask can have the form `(Never,(Never,Never))` and need not equal Never as a type. Set emptiness, nominal type equality and equality of a Pair's sides are different relations. In particular, testing `Mask: Null` would not supply the zero test of W. Any static zero test must respect this mask grammar.

**G2f (Zero identifies the actual endpoints).** On the finite expression grammar of G2e, the following conditions are equivalent: the X and Z masks are empty, the first and last source trees are equal, and the expression admits the supplied `ZeroTreeDifference` conformance.

`EmptyAddressMask` requires an empty root slot and two children with the same property. Never supplies the empty terminal. A conditional conformance gives `(Never,(l,r))` this property whenever l and r have it. Thus the relation recognizes empty padded masks without nominally collapsing their wrappers. More generally its recursive constraints exclude an occupied slot at every finite projection path. Induction on the path length proves this: the current root is empty and each next child carries the same constraint. The proof requires no finite bound on mask depth. The checked `RecursiveEmptyMask` points both child axes back to itself and still has no occupied finite address.

`ZeroTreeDifference` connects this property of X and Z to equality of the actual source endpoints. The terminal conforms directly. The 010, 101 and 111 constructors conform conditionally on their two children having this relation. Swift checks the parent's empty masks and endpoint equality from those child constraints. No conditional conformance asks for the parent's source equality again. This derives the parent relation, whereas a consumer taking an arbitrary `P: ZeroTreeDifference` receives the already established relation.

*Proof.* For finite masks, emptiness means that the root slot and both child masks are empty. In a partition expression this excludes exactly the 001, 011, 100 and 110 root patterns: each occupies X or Z at the root. The remaining nonterminal patterns are 010, 101 and 111. Their X and Z root slots are empty, and emptiness descends to both child partitions. Induction therefore supplies the children's zero relations and the applicable conditional conformance supplies the parent's relation. For 010 both endpoint roots are NULL. For 101 and 111 the endpoints are PAIRs of the equal child endpoints, so their actual types agree. Conversely equal finite endpoint trees have matching root constructors. If NULL, the partition is terminal or 010. If PAIR, it is 101 or 111 and the corresponding children agree. Induction supplies the same zero relation. This proves all three equivalences within the stated grammar. QED

The middle tree is unconstrained by endpoint equality. In `TreePartition010<EmptyTreePartition,EmptyTreePartition>` the direct masks are empty and both endpoints are NULL, while the Y root slot is occupied. The zero relation therefore cannot erase the detour or infer equality across each leg. `PartitionedTreeDistance` retains both Y occurrences.

This connects the zero question to actual source identity without first representing a numerical cardinality. Checks/Distance.swift exercises the generic consumer, a nested equal-endpoint construction, padded and recursive empty masks, and independent refusals of occupied masks and unequal sources. An arbitrary shape with empty masks but unequal sources cannot satisfy `ZeroTreeDifference`, nor can one with equal sources but an occupied direct mask. The full partition meaning of other fields still comes from G2e's constructor grammar.

**G2g (A positive witness for nonzero distance).** The nonzero question needs an occupied direct-difference address. Failure to construct G2f's zero relation is not that witness. For a generated partition P, select X or Z from its actual direct pair. Read a finite mask address using ReadMaskRoot, ReadMaskLeft and ReadMaskRight. These are aliases of the existing FirstEvidenceImage, SecondEvidenceImage and SequentialReading constructors. Each next reading must receive the actual output of the preceding projection. The final answer is the root bit at the reached mask, computed from its Left field.

`TreeDifferenceAt<P,R>` accepts the resulting reading when R starts at P's actual (X,Z) pair and its computed answer is Lit1. It retains P's source triple beside R. The reading's composed predicate records the projection route. The caller supplies a path construction, not a free answer parameter. The witness locates a difference but does not claim to choose the first or shallowest one.

*Proof.* Induct over the finite projection path. The root reader returns the current mask's actual bit. A left or right step composes two field projections with its continuation, with equal source/output types at each seam. It therefore reads the chosen descendant of the original mask. An answer Lit1 identifies an occupied address of X or Z. By G2e, that address belongs to D(s) △ D(t), so W(s,t)>0. Conversely, nonzero W implies an occupied address of X or Z. Its finite L/R word constructs the corresponding reading and supplies the witness. QED

Thus G2f's zero construction and G2g's positive occupied-address construction cover all triples in the finite tree grammar and cannot both report their respective outcomes for one such triple. This statement uses the actual partition and projection-reading grammars. It does not cover an arbitrary PredicateReading declaration with an invented answer (Verdict VC10). Swift checks a supplied construction and its bindings. The existence proof does not claim that the compiler searches for the address or chooses a certificate by itself.

The Y mask is excluded from the direct pair. It can be occupied even when the endpoints agree, as G2f shows. Checks reject using that detour as direct evidence, reading an empty address as occupied, attaching a continuation to the wrong child and reusing a reading with incompatible direct masks. Different source triples can legitimately share the same reading when their computed direct masks agree. Compatibility of those actual inputs matters, rather than nominal uniqueness of the source triple.

**G2h (Strict progress without a distance count).** Fix finite trees s, u, t and G2e's partition of their actual address sets A, B, C. Interpret s as the current candidate, u as its proposed replacement, and t as the same target throughout. The following are equivalent:

- Y is empty.
- A ∩ C ⊆ B ⊆ A ∪ C.
- W(s,u) + W(u,t) = W(s,t).
- B △ C ⊆ A △ C.

*Proof.* Y contains exactly the addresses where s and t agree but u disagrees: root patterns 010 and 101, at any address. Its absence gives the second condition. The third follows in both directions from G2d's exact residual 2|Y|. For the fourth, G2d gives A △ C = X ⊔ Z and B △ C = Y ⊔ Z, with X, Y, Z pairwise disjoint. The inclusion is therefore equivalent to Y being empty. QED

Under these conditions, progress is strict iff X contains an address. Then B △ C = Z is a proper subset of A △ C = X ⊔ Z and W(u,t) < W(s,t). `GeodesicTreePartition` requires the actual Y mask to be empty. Its conditional conformances derive that constraint from geodesic children for root patterns 001, 011, 100, 110 and 111, with EmptyTreePartition as terminal. Induction gives exactly the Y-empty part of the finite partition grammar. Patterns 010 and 101 cannot enter it.

`StrictTreeProgress<P,R>` combines that partition with G2g's actual projection reading into X, with computed answer Lit1. Its Monotone relation projects Z from (Z,X). The named Partition, Sources and Witness retain the source triple and the removed-address evidence. No IntegerValued count, comparison of supplied numbers or extra premise of strict inequality is needed. The finite partition and projection-reading grammars provide the interpretation, as in G2e–G2g. An arbitrary open protocol conformance does not replace them.

For a sequence of such steps, require the actual output tree of each step to equal the next input and require every target tree to equal the same t. The successive difference sets are then strictly nested subsets of the finite initial set D(s₀) △ D(t). Each step removes at least one address, so there are at most W(s₀,t) steps and no cycle. This is a mathematical bound on a sequence of supplied certificates. It neither schedules the next step nor requires a process to continue. A sequence maximal among all such tree steps ends at t: otherwise u=t is itself an admissible strict step. Restricted proposal families can stop earlier.

The criterion is sufficient, not necessary, for decreasing scalar W. With target PAIR(NULL,NULL), change PAIR(PAIR(PAIR(NULL,NULL),NULL),NULL) to PAIR(NULL,PAIR(NULL,NULL)). The former has two extra left addresses and the latter one extra right address. W falls from 2 to 1 although Y contains R. Checks/Distance.swift constructs that triple and rejects it as geodesic. A positive difference, a stationary step and a loss decrease with a detour must not be conflated with this stronger address inclusion.

*Remark (description versus constitution).* PAIR(a, b) composes existing structures in one act, and sharing can shorten their description. W measures node-address differences, not description length. peano(2n) is W = n away from peano(n) and has norm 2n. A bill proportional to that norm follows only under the uniform node-maintenance model. Different encodings and physical implementations can change the bill without changing this abstract edit metric.

*Remark (no teleportation).* Moving a subtree from address αL to αR costs full erasure plus full rebuild: 2 × ‖subtree‖. I2 admits no "move" primitive. Features like col_mirror (V=I §4.4) are how an encoding makes whole families of such expensive paths cheap to *name*: a rule is a short description of a long geodesic family. Crystallizing a rule (Intelligence Is Inevitable §1) is paying for the path once and keeping the name.

## §3. Motion and the Record

The edit metric allows removal from a candidate tree. M21 imposes retention on the comparison record instead. These are different coordinates of the declared state.

The steps of G2 change the candidate to be submitted (V=I §1 step 4: "reads the diagnostic and constructs a revised encoding"). The encoded domain still contains the same possible structures. A retaining implementation can preserve every comparison made during that walk in G. This is an update premise, not an effect of the candidate metric itself.

**G3 (Reversible candidate paths with retaining records).** W is symmetric: growing and shrinking candidate nodes reverse one another in the declared edit graph. If the cache updates retain prior records, its record set grows by inclusion along that path. Traversing the candidate path backward need not undo those records. This says nothing about absence of an inverse for the complete physical whole (M21, M29).

The two projections can therefore exhibit different behavior: a candidate returns to its earlier position while an internal record still distinguishes the traversal. Additional memory and its access conditions must be included in a realization. Neither an eternal record nor a thermodynamic arrow follows from the edit metric.

## §4. The Graded Comparison

**Definition (frontier).** frontier(s, t) = the prefix-minimal elements of D(s) △ D(t): the addresses where one tree has a distinction, the other does not, and all shallower structure agrees.

**G4 (Three readings of one traversal).** The simultaneous structural recursion over (s, t) supports three outputs of strictly increasing resolution:

| Output | Content | Information | Source |
|---|---|---|---|
| Z | [W(s,t) = 0] | 1 bit | V=I §2.2: COMPARE |
| X | one element of frontier(s, t) | one address | Interference Is Intelligence §0: X-projection |
| Δ | W(s, t), and on demand the full set D(s) △ D(t) | the complete difference | this document |

*Proof.* The recursion descends only where both sides are PAIRs. It meets a divergence exactly at an address where one side is PAIR and the other NULL, and all proper prefixes of that address are shared PAIRs, so divergence points are exactly frontier elements. Halting at the first divergence yields X (and Z as its existence bit). Completing the traversal and summing (G2a) yields Δ. QED

Binary COMPARE is the sign of the gradient. The X-axis is one coordinate of it. The framework was already leaking the gradient through X, and here the author completes the leak.

**G4a (The invariant of a pair).** |D(s) ∩ D(t)| = (‖s‖ + ‖t‖ − W(s, t)) / 2. The shared structure of two forms is computable from two norms and one distance. For a library L, the intersection over all entries is the domain's common skeleton: the invariant that costs nothing extra to carry because every entry already carries it.

**G4b (Resolution costs).** Z may halt at the first divergence: cost bounded by the depth of the frontier. Δ must traverse both trees in full: cost Θ(‖s‖ + ‖t‖). The gradient is strictly more expensive than its sign. A bounded agent defaults to the sign, and magnitude is bought, never given. The loop runs on binary COMPARE by default because the gradient is the expensive projection: present in every comparison, priced above the default budget.

## §5. Resolution

**Definition.** D_k(t) = {α ∈ D(t) : |α| < k}. d_k(s, t) = |D_k(s) △ D_k(t)|: the distance visible at depth k.

**G5 (Resolution family).** Each d_k is a pseudometric, d_k is monotonically non-decreasing in k, and d_k = W for all k beyond the deeper tree. Define s =_k t iff d_k(s, t) = 0: equality at resolution k.

*Proof.* Pseudometric: symmetric difference of sets, as in G2, and not a metric because trees differing only below depth k are d_k-indistinguishable. Monotone: an address counted by d_k is counted by d_{k+1}. Convergence: for k > max depth, D_k = D. QED

Every binary judgment the system makes is a zero test at some resolution. Sharpening a boundary = increasing k = paying for deeper traversal (G4b). The binary/graded duality is truncation, not ontology: the same comparison, stopped earlier or carried further.

## §6. Internal Instances

Permanence Is Resistance §5 maps the axioms onto external physical systems, and those mappings are structural analogies whose axiom-verification is empirical. The instances below are different in kind: they are theorems of the framework's own reference encodings. Exact, internal, no analogy.

**G6 (Number).** For the Peano encoding (V=I §4.1: encode(0) = NULL, encode(n) = PAIR(encode(n−1), NULL)):

W(encode(n), encode(m)) = |n − m|

*Proof.* D(encode(n)) = {ε, L, L², ..., L^{n−1}}, so ‖encode(n)‖ = n, and for n ≤ m the symmetric difference is {L^n, ..., L^{m−1}}: size m − n. QED

The framework's own numerals recover the arithmetic metric. The order and rank features of V=I §4.4 are W-comparisons on numerals.

**G7 (Grid).** For the cell encoding (V=I §4.1: atom(r, c, v) = PAIR(PAIR(row, col), value)):

W(atom(r,c,v), atom(r',c',v')) = |r − r'| + |c − c'| + |v − v'|

*Proof.* D(atom) = {ε, L} ∪ LL·D(row) ∪ LR·D(col) ∪ R·D(value). The skeleton {ε, L} is shared by all cells and cancels, and the three prefixed regions are disjoint, so the symmetric difference splits into three sums, each |Δ| by G6. QED

Taxicab geometry. Adjacent cells are at distance 1, and far cells are far. Grid locality is a theorem of the encoding rather than an assumption built into it. The agent's perceptual space (Difference Is Distance §3) acquires its geometry by derivation.

*Remark (geometry is encoding-local).* W inherits encoding-locality from f* (V=I §5.4). Under a positional (binary-digit) numeral encoding, W between consecutive integers is Hamming-like, not |n − m|: 2^k and 2^k − 1 would be far. The unary encoding makes magnitude difference the geometry, and a positional encoding makes digit difference the geometry. The lens determines the metric, exactly as it determines the visible features (Difference Is Distance S2). What is invariant is that *some* metric is forced by G2 once the agent fixes the encoding.

*Remark (name economics).* The numeral choice also bounds what can be built. A library entry referenced by index pays its numeral's norm on every use. Under the unary numeral, ‖ref(k)‖ grows linearly in k: once k exceeds the norms of the structures worth naming, no further crystallization pays, and the library is capped at the scale of its heaviest entries. Under a positional numeral, names cost logarithmically and the cap dissolves. A self-building system's tower height is therefore an encoding decision before it is a domain property: cheap names are a precondition for deep composition (the same constraint PiR M23–M25 meets as lookup economics). The lens does more than color what the agent sees: it bounds how high the agent can build.

## §7. Balls and the Gate

**Definition.** B(t, r) = {s ∈ Σ : W(s, t) ≤ r}.

**G8 (Balls are finite).** |B(t, r)| is finite for every t, r.

*Proof.* A structure with p distinctions admits at most p + 1 grow moves (one per NULL leaf, and a tree with p PAIRs has p + 1 NULLs) and at most p shrink moves. Branching is finite at every structure, so the set reachable in ≤ r moves is finite, and by G2 that set is exactly B(t, r). QED

**G9 (Proposal order, unchanged gate).** Let the agent order its attempts by W: nearest library entries first (lookup), nearest candidates first (search). Every guarantee of V=I §5 is untouched: PASS is certified by compilation regardless of how the candidate was found (Theorem 2: safety is from verification, never from search), and a wrong proposal costs one REJECT (Intelligence Is Inevitable §2: the gate makes matching safe). The metric changes only the *order* of attempts, and order is exactly the agent's sole degree of freedom (V=I §5.25). W is entirely on the Y-axis (Interference Is Intelligence §0): zero new bits, full control over efficiency.

This is the structural reason the gradient can be added without weakening anything: it is an ordering device, and the framework already proved correctness is order-invariant.

> Argues: ``StrategyLivesInSigma`` needs ``OrderIsOnlyFreedom``.

## §8. Generalization

Intelligence Is Inevitable defines rule classes by structural identity: transfer happens only on exact match, and K counts exact classes. With W, identity relaxes to proximity, and the counting changes.

**Definition (modulus).** Fix a task domain D and a single-valued target rule map τ ↦ f*(τ). A bound ω satisfies W(f*(τ),f*(τ′)) ≤ ω(W(τ,τ′)) for every pair in D. A complete finite table of those targets permits checking this bound on that domain. Measurements on a proper sample establish only the sampled inequalities. They do not certify the bound on other tasks.

**G10 (Ball search).** Suppose the bound applies to a new task τ and a certified anchor (τ₀,f₀=f*(τ₀)). If W(τ,τ₀)=ρ, then f*(τ)∈B(f₀,ω(ρ)), directly by the bound. G8 makes this a finite candidate region. Recovery additionally requires a rule representation, complete enumeration and a gate adequate for the intended target. A small known ω can make the region useful. Mere existence of a bound is weak: for any finite task domain, the constant diameter of its finite target set bounds every pair, without providing a smaller search region.

If the bound is only a heuristic, an exhausted ball can be followed by broader search. The extra work includes the examined candidates and their gate costs. A sound gate preserves its declared guarantee under that change of order. Exhaustion within a limited budget is not proof that the intended rule lies outside the grammar.

**G10a (Rank and expected proposal cost).** Fix a finite candidate set of size n≥1, one accepted target for each task, a task distribution, and an actual ordering of all candidates with a specified tie rule. Let R(τ)∈{1,…,n} be the target's position. If each candidate check costs one unit and search stops at the first accepted candidate, the number of checks is exactly R(τ). Expected checks are therefore E[R]. A uniformly random permutation has mean (n+1)/2 for every target. This ordering improves expected check count exactly when E[R]<(n+1)/2, before charging the work of producing the ordering.

A majority of tasks below median rank is insufficient. With n=100, rank 49 on 60% of tasks and rank 100 on 40% gives mean 69.4, worse than the random mean 50.5. With variable check costs cⱼ(τ), the relevant expectation is E[Σⱼ≤R(τ)cⱼ(τ)] plus ordering cost. The rank of a selected anchor among anchor distances does not determine this candidate rank, the ball interior's enumeration order or its costs.

A retrieval profile can thus measure a useful heuristic on a declared distribution, but it is not equivalent to a modulus, a small cover or a guarantee of low future cost. G10 gives an absolute radius bound. G10a gives a cost identity for an actual proposal order. Neither implies the other's efficiency premise.

**Definition (covering number).** N_D(r) = the minimal number of W-balls of radius r covering {f*(τ) : τ ∈ D identifiable}.

**G11 (Ball coverage and bounded recovery).** Fix a nonempty rule set S and a finite cover B(cᵢ,r), i=1,…,N. Once each ball has a retained certified anchor aᵢ in it, every f∈S lies within 2r of at least one anchor. Indeed, choose a covering ball containing f. The triangle inequality gives W(f,aᵢ) ≤ W(f,cᵢ)+W(cᵢ,aᵢ) ≤ 2r. This is a deterministic consequence of the supplied cover and anchors. The cover need not be minimal, and overlapping balls may share an anchor.

The target's nearby anchor need not be known from the new task. Without a certified dispatcher or G10's modulus, search the finite union of all B(aᵢ,2r). G8 makes that union finite and the preceding argument places f in it. Exhaustive enumeration of that union with a gate adequate for the intended target gives recovery. A heuristic choice of one anchor alone does not inherit the guarantee. The metric ball is a set of finite tree structures, so the gate must also establish admissibility as a rule for the task.

Arrival time needs a separate model. Suppose certified rules arrive IID and ball i has probability pᵢ>0 of receiving each arrival. Apply Intelligence Is Inevitable §6 to each missing-ball event. After n arrivals, the probability of incomplete ball coverage is at most Σᵢ(1−pᵢ)ⁿ, which tends to zero. The expected completion time is at most Σᵢ1/pᵢ: each first-hit time has expectation 1/pᵢ and their maximum is no greater than their sum. These bounds permit overlapping balls and do not require independence between ball-hit events on the same arrival. The exact N·H_N formula requires the uniform exclusive-class model of IiI §6, not positivity alone. Two disjoint balls with probabilities ε and 1−ε already require expected time at least 1/ε. No bound depending only on N can follow as ε tends to zero. The IID law is an explicit stochastic assumption, not a source outside the relational whole or a consequence of closure.

At r=0, a cover by distinct centers is exact rule coverage and N(0)=|S| when S is finite. For r>0 a smaller cover can reduce the number of anchors required to bound the search region. It does not by itself supply the target dispatcher, reduce total search cost, or certify behavior on undeclared tasks. An arrival here already includes successful certification and retention. Raw task counts need the additional premise that each encountered required rule is obtained and retained.

> Argues: ``BallSaturation`` needs ``LibrarySaturates``.

**G12 (The exact scope of a covering number).** Fix a nonempty finite set S of finite trees, radius r≥0, and centers allowed anywhere in Σ. An approximation through m representatives consists of centers c₁,…,cₘ and an assignment e:S→{1,…,m} satisfying W(s,c_{e(s)})≤r for every s∈S. Such an assignment exists iff those m balls cover S. Consequently the least number of representatives equals N_S(r).

*Proof.* An assignment places each s in its selected center's ball, giving a cover. Conversely a finite cover permits selecting one containing ball for each s, giving an assignment with the required error. Minimizing over the same permitted centers gives equality of the two minima. A finite minimum exists since each member of S can serve as its own center. QED

Thus N_S(r)<|S| is exactly the criterion for using fewer representatives under this approximation contract. At r=0, the metric separates all distinct members, so N_S(0)=|S|. At r>0, a common representative need not preserve exact identity, program behavior or the answer to a particular question. If every original member must be recovered exactly, its residual distinction must remain in the code or another addressed record. A short generative program can share structure while still producing many distinct outputs. Its description length is not the number of representatives.

For exact preservation of a specified question q, Verdict §6c already supplies the sharper criterion: equal encoded images must imply equal q-answers, equivalently q factors through a decoder on the realized image. ReadingFactors and its concrete generic constructors express that actual application square. The criterion concerns the distinctions needed by q, without assuming that a small W-error preserves them. G12 does not replace this existing relation.

This does not replace Permanence Is Resistance M16's premise K_{N+1}<K_N for an arbitrary tower. The next level must first be bound to the representative assignment just defined, with its permitted error. Nor does that inequality alone make the assignment optimal. For any finite S, a sufficiently large radius permits one representative, so the unqualified condition “some r>0 with N_S(r)<|S|” says nothing about useful accuracy or affordable search when |S|>1.

Centers matter computationally too. The finite pairwise W-matrix of S suffices for covers whose centers are restricted to S. It need not supply the distances to all allowed ambient centers. For integer r and unrestricted centers, a finite search is still possible: any useful center lies in the finite union ⋃_{s∈S}B(s,r), by symmetry and G8. Searching that finite family can be expensive. Finiteness is not an efficiency bound.

> Argues: ``CompressionCriterion`` needs ``Tower``.

*Counterconstruction (a flat metric does not force memorization).* Choose a finite tree b with k≥2 distinct NULL-leaf addresses aᵢ. Form sᵢ by replacing only that NULL with PAIR(NULL,NULL). Then D(sᵢ)=D(b)∪{aᵢ}. For i≠j, W(sᵢ,sⱼ)=2, while W(sᵢ,b)=1. Thus the off-diagonal distance matrix is constant, yet N_S(1)=1 with ambient center b and N_S(0)=k. A matrix being flat is not even equivalent to lacking a smaller positive-radius cover.

Now present any sᵢ as input and require that same tree as output. The existing generic IdentityReading<X,S,E> produces X for every input type X, without storing an entry for each sᵢ or selecting a nearest anchor. Its Null equation derives the answer equality directly. A shared constructor or projection can likewise expose a task's target without exploiting distances among different targets. This is a counterexample to the claim that exact transfer requires a nontrivial metric grouping. It does not claim to learn the identity rule from insufficient examples: that identification needs its own rule domain and evidence, as in V=I U2.

If the target objects are rules, use constant-output rules with a fixed constructor wrapper around each sᵢ. Their codes still differ only at the prefixed aᵢ addresses, so their mutual distances remain 2. A task exposing the required code permits the same direct reading. This deliberately easy task violates the asserted necessity of metric routing. The original universal claim imposed no premise hiding the required code.

For an acquired operation rather than a supplied reader, Matter M65 and CalibratedRoutingBasis already provide a more substantive case. Prepared probes distinguish members of the stipulated uniform routing family, and the recovered input-position map applies to new contents through the interpretation relation. This is exact rule reuse after identification, without requiring a new metric ball around each input. VC74's boundary still applies: matching the probes does not establish that an unknown mechanism belongs to that family.

The available questions and operations, the task-to-target relation, and the charged work can distinguish two problems with identical rule-distance matrices. A genuine no-information search bound requires a model that hides the target symmetrically from the permitted observations. Metric flatness alone does not impose that model. G12 characterizes representative approximation, not the existence of intelligence or the height of every learning tower.

## §9. Descent

**Definition (loss).** Fix a finite indexed family of examples (Iₖ,Oₖ) and a candidate g whose application on every declared Iₖ is defined and yields a finite output tree Aₖ. Then loss(g) = Σₖ W(Aₖ,Oₖ). An undefined application has no value under this definition. It is not a zero contribution.

**G13 (Zero loss and certified progress on examples).** Under these premises, loss(g)=0 iff Aₖ=Oₖ for every declared index k. Each summand is nonnegative by G2 and is zero exactly when its two trees agree. Thus a zero sum forces every equality, and those equalities force a zero sum. The empty family has zero loss for every candidate, with no output identification. A nonempty family can still admit different rules with the same outputs. V=I U2's membership and coverage obligations determine when a rule itself is identified.

Pack the outputs into the same fixed finite PAIR skeleton on both sides. Its common skeleton cancels and its leaf regions have disjoint address prefixes, so W(pack(Aₖ),pack(Oₖ)) = Σₖ W(Aₖ,Oₖ). This follows by induction from the two-output equation W(PAIR(a,b),PAIR(c,d)) = W(a,c)+W(b,d). G2f's existing ZeroTreeDifference construction can therefore equate the entire actual output tuple with the target tuple without a scalar sum. The application constructions must bind g and each declared Iₖ to those Aₖ. Supplying an unrelated equal tuple does not establish zero loss for g.

Compilation implements this zero test only where the candidate's actual applications and all declared output equalities are checked. Compiling an arbitrary declaration or a GateIsZeroOfLoss conformance is not that equivalence. Additional admissibility conditions remain additional conditions of the gate. Matching the examples also does not by itself establish behavior on undeclared inputs.

For progress, pack the old outputs, proposed outputs and fixed targets with that same skeleton. If every component has Y empty and at least one has an occupied X address, G2h gives strict progress for the whole tuple. `TreePartition111<P,Q>` already constructs the paired source triple and prefixes each component mask by its actual side. `PairedTreeProgress<P,Q,R>` transports P's occupied-X reading through the left branch while requiring Q to be geodesic. A component can wait or improve, but cannot introduce a detour. The original single-tuple constructor also accepts a witness in any component through its actual finite path. Checks exercise both an improving pair and one improving output beside a stationary output, and reject hiding a detour in the other output.

`TreeReadingProgress<Before,After,P,R>` binds the progress certificate to two actual readings. Both receive the same input and use the same Sigma and Encoding. Their answers must equal P's current and proposed trees respectively. The predicates may differ, because this compares two candidate operations on that input. Within the concrete projection-reading grammar, their answers come from the operations themselves. For input PAIR(PAIR(NULL,NULL),NULL) and target NULL, replacing first-projection by second-projection is certified. The same replacement on PAIR(NULL,PAIR(NULL,NULL)) moves away from NULL and cannot reuse that partition certificate. Checks reject the mismatched applications, different inputs with deceptively compatible output values, and changed contexts. An arbitrary PredicateReading with an invented answer retains VC10's boundary.

Successive certificates with matching actual output tuples and fixed targets inherit G2h's finite strict-chain bound. This proves an order property of the supplied output changes. TreeReadingProgress also checks the supplied application bindings, but does not generate a new rule realizing a proposed tuple. A restricted rule family may contain no next step of this kind. Scalar-loss descent allows more steps, including some with detours, while still not forcing a search procedure to find them. An exhaustive search needs its own domain, coverage and scheduling premises.

An agent can therefore use scalar loss to order proposals, or use an addressed witness to certify a stronger form of progress without calculating that loss. Zero certification, proposal generation and retention of accepted knowledge have separate constructions. This is a concrete connection between the gradient and the existing relational kernel, without requiring the legacy Distance axis for either zero or address-monotone progress.

## §10. Speed and Resistance

**G14 (A time bound requires a specified transition).** In G2's sequential edit model, a step changes one address. A path of n such steps therefore has n≥W(s,t). If one counted tick completes exactly one such edit, the same inequality bounds counted ticks. Matter M1 defines an operation clock but does not identify every operation with a single tree edit. M4 permits macros, and PiP4 distinguishes represented sequence from unavoidable execution order. The inequality is consequently a theorem about this edit interface, not a universal conversion from W to physical duration.

**G14a (Compatible rounds and the longest dependency chain).** Define a different interface on the same finite trees. In one round, choose any set of pairwise prefix-incomparable addresses, each admitting a G2 grow or shrink on the tree at the start of that round. Apply all those edits. Unchanged branches are allowed. This model has no additional charge for dispatch or unchanged structure, and imposes no limit on the number of independent edits per round. It is a defined transition model, not an assertion about a physical machine's resources.

For A=D(s), C=D(t), write R=A\C for removals and P=C\A for additions. For a finite address set E let h(E) be the largest number of its members in a strict prefix chain, with h(∅)=0. The minimum round count is

    T_round(s,t) = max(h(R), h(P)).

*Lower bound.* Along a chain of initially absent addresses that must be added, each ancestor must first be created before its descendant can first be created. Along a chain of initially present addresses that must be removed, each descendant must first be removed before its ancestor can first be removed as a childless node. Comparable edits cannot occur in the same round. Thus any schedule, even with extra edits, needs at least h(P) and h(R) rounds.

*Upper bound.* No removal address is comparable with an addition address. If α∈R were a prefix of β∈P, C's prefix closure would force α∈C. In the other direction, A's prefix closure gives the contradiction. Within R, remove all currently maximal remaining addresses each round. Any descendant of a removed address also belongs to R, so these are valid childless removals once their predecessors are gone. Within P, add all addresses whose needed ancestors have already been supplied. Their other ancestors belong to A∩C and remain present. Each ready group is an antichain, and the two groups are mutually incomparable. Running them together completes the removals in h(R) rounds and additions in h(P) rounds. The maximum is attained. QED

For B₀=NULL and B_{d+1}=PAIR(B_d,B_d), G2 gives W(NULL,B_d)=2^d−1 while this round model gives T_round(NULL,B_d)=d. Both follow by structural induction. The distinction is between total edits and dependent rounds. A compatible frontier is simultaneous only by this round contract. Neither closure of the whole nor the syntax tree alone selects that contract or a duration for its rounds.

**G14b (The round grammar and its actual applications).** The finite Swift grammar has four forms: IdentityReading<Never,S,E>, GrowTreeRoot<S,E>, ShrinkTreeRoot<S,E>, and PairedTreeRound<L,R> with matching Sigma and Encoding. The first is the NULL identity. The next two construct a childless root from NULL and remove that actual childless root. The paired form keeps the parent and applies its two child rounds through PairedApplication.

PairedApplication lifts each child reading through its actual input projection and combines the answers with the existing JointEvidence. It computes PAIR(F.Answer,G.Answer) from PAIR(F.Left,G.Left), with no supplied final-answer equality. The round grammar's soundness follows by induction: a root edit excludes all child edits, and paired children have disjoint address prefixes. Completeness follows by decomposing a permitted round. If the root changes, it is the sole edit. If both roots are NULL, use the identity. Otherwise the common parent remains and the round splits into its two child rounds. This covers exactly the specified compatible rounds over finite trees.

TreeRoundShape checks the application layout. It does not seal this constructor grammar. SequentialReading composes rounds at the actual preceding answer and does not thereby become a one-round constructor. Checks reject editing below an absent parent, shrinking a nonleaf, changing context, or substituting a two-round application as a paired child round. Two rounds construct B₂ with its three internal nodes, and a single paired round constructs both children of an existing root. These witnesses need no numerical duration axis.

IndependentReadingOrders<F,G> derives equal paired inputs and answers for first-then-second, second-then-first and PairedApplication<F,G>. The constructor expresses independence through the disjoint input projections, not by declaring that arbitrary operations commute. The operation descriptions and intermediate records may differ. Checks use growth on one field and shrinkage on the other, and reject identifying their two retained application histories. Equality of the selected final answer does not erase order from the full record. Such retention uses RetainedWhole and M21's update premise, rather than being inferred from closure alone.

Disjoint input projections concern which fields an operation uses. They do not factor the preparation's joint probability law. LQ15's free cuts instead concern recombination of admitted forms, and AC7's cycle ratios concern joint weights. IiS12 exhibits an encoding that transports every local unitary and preserves independent preparation, yet fails on one joint controlled exchange. These meanings of independence therefore need their own transport relations.

**G14c (An influence bound uses dependency addresses).** Consider one whole modeled by a finite directed graph of internal components. At each declared round, a fixed deterministic update computes component v's new state only from the previous states at its specified input neighbors, including itself when its rule uses its prior state. Include every controller, clock or other state on which this update depends in those input relations. No changing unrecorded input is permitted.

After n rounds, v's state factors through the initial states with a directed path of length n into v. Equivalently, a conservative bound uses all initial components within n input edges. *Proof.* At round zero the required source is v itself. At the next round, the update uses only its declared neighbors. Substitute each neighbor's previous factorization and compose the paths. Induction establishes the claim. Two admitted prepared whole states agreeing on that source region therefore give the same answer at v after n rounds. QED

This is a conditional locality result from actual input dependence. It does not require an external observer or source, and does not identify cache symmetric difference with communication distance. Exact clocks, asynchronous updates or longer-range inputs change the dependency relation and must be included in the model. Verdict's question-factorization construction and QuestionAlongTransition provide the existing application form for such composed questions. The arbitrary-graph theorem here is mathematical, not a new Swift encoding of all graphs or a derivation of a universal physical speed.

**G14d (Reciprocity across a symplectic whole cut).** Let the whole be finite-dimensional with a nondegenerate symplectic form that is a product over a cut into two parts, each with every controller, clock or memory assigned to its side. Let one round be a symplectic map Φ(m,c)=(F(m,c),ψ(m,c)) on an open product. At each point, D_cF=0 if and only if D_mψ=0: local differential dependence across the cut is mutual. On connected open factors this also gives equivalence of global independence for the entire round ([UT80](../../../../Research/2026-10-10-use-leaves-a-trace.md)). A round whose global dependence crosses some cut of the whole in one direction only therefore needs a failed hypothesis in its physical realization, for example a symplectic form that is not a product over that cut, discrete or non-symplectic dynamics, a prepared closed layer, a disconnected class or a degenerate description. G14c's bound remains valid for every dependency graph. G14d restricts cuts crossed in only one direction under its hypotheses. Individual directed edges can be one-way. It concerns two complementary parts of the whole, not smaller subsystems.

Matter M66 asks when a finite family of admitted partial records determines one fixed prerequisite order. Closure under union and intersection, with separation of occurrence addresses, is its exact criterion. Alternative support or incompatibility can require more than that order. M67 identifies its serializations and the questions preserved by exchanging adjacent incomparable occurrences. These results explain what has to be retained when G14a's dependency chains are used as a model of time. A chosen linear record can carry additional distinctions, and G14b preserves them in the complete history.

**G15 (Distance and resistance answer different questions).** W(candidate,target) is the minimum count of G2 edits between specified trees. It can measure an output discrepancy once the actual outputs and target are bound as in G13. It need not measure plan-execution time, physical inertia or the cost of finding a rule that realizes the target. G14a gives a different exact time count for the same trees under a different permitted transition.

A target may be given directly, partially observed through examples, or reconstructed from retained evidence. The interface must state which questions are available. An occupied difference supplies an address, and G2h can certify strict progress without a scalar loss. Neither witness chooses a steepest step or obliges a process to take one. A resource or resistance law requires the actual permitted transitions, state dependence and charged work in addition to the comparison.

## §11. Boundaries

**Encoding-locality.** W is a metric per encoding. Geometry, like f* (V=I §5.4), transfers across encodings only through a semantics-preserving map. Geometry exists only through an encoding, and the invariant is that every encoding induces one (G2).

**Cost of magnitude.** The gradient costs full traversal (G4b). Agents with tight budgets will operate on signs and frontiers, not full distances, and G9–G13 degrade gracefully to V=I's binary regime.

**Conditional theorems.** G10 bounds a candidate region, G10a measures an actual order, G11 relates a supplied cover to anchors, and G12 characterizes approximation by representatives. Complete finite declarations permit finite checks. Sampled checks do not establish unobserved cases, and these results do not classify all possible forms of generalization.

**Discrete throughout.** W is integer-valued, d_k is a finite family, and every claim here is discrete. Whether coarse-grained W on large structures approximates continuous metrics is an open question of the same standing as Difference Is Distance §10.


## §12. Dependency

### External

| Source | Used |
|---|---|
| V=I | §2.1–§2.2 (Σ, COMPARE), §2.5 (PAIR sole primitive, projection), §4.1 (Peano, atoms), §4.4 (features), §4.7 (compilation), §5.4 (encoding-local), §5.10 (completeness by enumeration), §5.25 (order as sole dynamic variable), Theorem 2 |
| IiI | §1 (crystallization), §2 (pre-solve matching, gate safety), §3 (rule classes, K, saturation), §4 (distribution-relativity), §6 (coupon collector) |
| PiR | §1 (resistance), M1 (tick), M16 (tower termination premise), M21 (no deletion), M24 (conditional physical resource model), M25 (tower as cost management) |
| DiD | S2 (perspective = encoding), S7 (cache pseudometric), S18 (switching cost), S19–S20 (update rate and influence), S23 (slot model), §10 (open physical relations) |
| InI | §0 (Z/X/Y axes, feedback bandwidth), §2 (interference), S4a (ordering value) |

### Internal

| Statement | Depends on |
|---|---|
| G1, G1a, G1b | V=I §2.1, §2.5, M24 |
| G2, G2a–G2c | G1, I1, I2, M24 |
| G2d–G2h | G2, finite partition and projection-reading grammars |
| G3 | G2, I3, M21 |
| G4, G4a, G4b | G2a, InI §0 |
| G5 | G2 |
| G6, G7 | G2a, V=I §4.1 |
| G8 | G2 |
| G9 | G8, V=I Theorem 2, §5.25 |
| G10 | G8, G9 |
| G10a | fixed candidate order, check costs and task distribution |
| G11 | G10, IiI §3, §6 |
| G12 | G2, G8, explicit representative approximation contract |
| G13 | G2f–G2h, actual applications, fixed finite output packing, V=I U2 |
| G14–G14c | G2, explicit round grammar, actual input dependence, M1/M4, PiP4, M21 |
| G14d | G14c, finite-dimensional symplectic product, UT80 (Research, 10 October 2026) |
| G15 | G2h, G13–G14c, declared transition and resource model |

Difference Is Distance derived the geometry between witnesses. Here the author derives the geometry between the witnessed. One operation, one metric, one loop: COMPARE was always measuring. It was only ever asked for the sign.

## Topics

### Related type declarations

- ``DistanceIsCost``
- ``BallSaturation``
- ``CompressionCriterion``
