# Permanence Is Resistance (Matter) — Cost

This part contains the original derivations for cost.

Family and original section headings: <doc:permanence_is_resistance>.

Section setting: <doc:permanence_is_resistance#4-Levels>.

## Detail: Cost

### M24

**M24 (Physical cost requires an implementation).** I3 retains comparison records. It supplies neither a probability distribution nor an energy scale. A new record can be a reversible correlation between parts of one closed system. Recording, changing a tree node, and resetting an unknown bit are different operations. [Bennett's reversible computation construction](https://www.cs.princeton.edu/courses/archive/fall06/cos576/papers/bennett73.html) supplies an explicit counterexample to a mandatory dissipation charge for every logical step. Its clean output has its own contract. The construction computes, copies the result into a prepared blank register and uncomputes. Reversibility alone does not need that blank: the permutation (x,y)↦(x,y⊕f(x)) is invertible for every y. In that construction the blank is needed to deliver f(x) itself in a declared output register beside the retained input x, and the price of preparing it depends on the declared architecture. Verdict VC59 counts one such slot account and states that its count is not a universal price of a bit.

Under initially uncorrelated memory and thermal reservoir at positive temperature and joint unitary evolution, Landauer bounds reservoir heat by the memory's entropy decrease: `Q ≥ k_B T ΔS`, with entropy in nats. Resetting an unbiased classical bit gives `ΔS = ln 2`. Finite reservoirs add restrictions. Both memory and reservoir are internal parts of the whole. This is a lower bound, not an upper budget or a price for passive storage. See [Reeb and Wolf, Theorem 3](https://arxiv.org/html/1306.4352).

A maintenance model may assign a measured or assumed cost `c` per stored node per correction cycle. Then its bill is `c × Σ_entry F_entry`, or `c × |L| × F` for equal entry sizes. Neither uniform pricing nor `c = k_B T ln 2` follows from I1–I3. Retained correlations and the implementation of error correction must be included when applying a physical bound.

### M25

**M25 (Conditional cost management).** Under the bisecting-predicate premise of M15, a decision tree can reduce comparison depth from linear to logarithmic in the number of classes. An energy improvement additionally requires a resource model for storage, access, construction and correction. Shorter lookup does not by itself reduce the retained library or its maintenance cost. Finite storage at each moment is compatible with unbounded capacity over time, but a fixed finite device cannot store an unbounded independent record.

**When does preservation require a distinguishing response?** Having a cost does not itself require a cost report. Let T⊆X×M relate possible source conditions to complete response inputs. Let V⊆X×A specify which responses preserve the stipulated requirement in each condition. Restrict M to inputs related to at least one source. A response relation R⊆M×A is universally adequate precisely when

    T(x,m) and R(m,a) imply V(x,a).

The largest such relation is

    R_max(m) = ⋂_{x:T(x,m)} {a∈A : V(x,a)}.

*Proof.* Any admitted response at m must be allowed for every source related to m, so it belongs to that intersection. Conversely every member of the intersection meets every one of those requirements. Thus a nonempty response set can be supplied at each admitted input exactly when every displayed intersection is nonempty. R_max itself supplies those sets, with no choice of representatives. It does not select or implement an individual response. This is a condition for every admitted contact to preserve the requirement, not a statement about a probability-one guarantee. Indefinitely repeatable preservation must also cover the successor contacts.

The factorization through m is substantive. All source/response combinations allowed by T and R are being covered. If a mechanism correlates its response with x through another internal relation, that relation belongs to its complete input or to a more detailed joint contact. Equal reported symbols alone do not remove such a dependence. Neither this test nor its failure requires a separate sensor register, an external controller or a felt cost.

If one response a₀ is allowed in every source condition, the constant response suffices for this requirement despite ignorance of the actual condition. If two conditions require different unique responses, one common complete input cannot support both. More generally a whole family can conflict while each pair shares an answer: response sets {p,q}, {q,r} and {p,r} meet pairwise but have empty total intersection. A successful realization of this contract must avoid combining that conflicting family at one response input, change an admitted response or abandon the requirement. Mere survival in an unspecified range does not establish that such a conflict exists.

This is the same structure as LQ15. Each response a has its source region B_a={x:V(x,a)}. The nonempty source families admitting a common response are exactly those contained in some B_a. Forgetting the response address leaves a downward-closed family of compatible source sets. Its two-place projection need not retain the joint refusal. No new algebra is needed. When V(x,a) means a=q(x), the criterion reduces to the exact recovery condition of Verdict §6c. Preservation can require less than recovering the source or even one designated source value.

When a reading assigns one code to each source, there need not be one coarsest adequate reading. Let conditions x,y,z admit responses {a}, {a,b}, {b}, respectively. One adequate reading merges x with y and separates z. Another merges y with z and separates x. A reading coarser than both must merge all three and would require one response in {a}∩{a,b}∩{b}, which is empty. Both two-answer readings are minimal, yet neither replaces the other. Exact recovery of a stipulated q has its canonical answer fibers. Preserving a relation of acceptable responses instead permits different adequate ways of distinguishing the conditions. The ambiguity belongs to that task, not to an incomplete search for its unique quotient.

**When is there one coarsest adequate reading?** Write V_x={a:V(x,a)} and assume each V_x is nonempty. Connect two source conditions when they share an allowed response. The connected components use finite paths of these contacts, even when X is infinite. A coarsest adequate partition of X exists exactly when every such component C admits a common response:

    ⋂_{x∈C} V_x ≠ ∅.

When it exists, that component partition is the answer. Indeed, any adequate block lies within one component. Conversely, each pair sharing an allowed response can be merged by an adequate partition that leaves every other source as a singleton. A partition coarser than every adequate partition must therefore merge every component. Such a merger is adequate precisely under the displayed condition. This proves necessity and sufficiency without choosing a response for each component: the intersection supplies the adequate response relation. Implementing a selection is another requirement. LQ15's finite overlap criterion describes the same obstruction through jointly admitted source families. On an infinite component, admitting every finite subfamily alone need not admit the whole.

The component criterion is weaker than equality of full contact profiles. The rows {a} and {a,b} can share one adequate code by retaining response a, although only the second permits b. LQ13's exact contact boundary must distinguish those rows. The same relation can thus have different sufficient descriptions for choosing one permitted response and for preserving every contact answer.

### M25a

**M25a (A future restriction can force an order of response profiles).** Fix a nonempty family S of possible source conditions at one complete input. Let I_S=⋂_{x∈S}V_x. A later internal contact restricts the response to K⊆A, without reading the hidden x. Ask whether the following implication is valid for every K:

    [for every x∈S, V_x∩K ≠ ∅]  implies  I_S∩K ≠ ∅.

The left side says each possible actual source has some permitted response. The right side says one response works without another distinction of the source. This implication is valid for all K exactly when one source x₀∈S has V_(x₀)=I_S.

*Proof.* Such a least row supplies the result immediately: the left premise applied to x₀ gives a member of I_S∩K. If there is no such row, every V_x contains an element outside I_S. Take K=A\I_S. Each source then has a permitted response, while no response is common. The proof works for arbitrary sets and needs no distribution or finite enumeration. QED

For example, let V_x={a,b} and V_y={b,c}. Before the contact, b serves both. The restriction K={a,c} leaves response a for x and c for y, but no response for their unchanged common input. It does not make the actual state choose whichever alternative helps. Further source information, a different response contact, or a changed requirement is needed. This is the quantifier distinction between ∀x∃a and ∃a∀x expressed by one finite obstruction.

An autonomous coupling may respond with a at x and c at y without a separate sensor or state estimate. Such a coupling retains a source-dependent relation that the common-input factorization omitted. M25a does not prohibit it or require consciousness. It prohibits claiming both that the complete response input is unchanged and that an unrepresented dependence supplies its choice.

Now require the same implication after every nonempty source refinement T⊆S and every response restriction K. Applying the theorem to each T shows that this stronger property is satisfied exactly when every nonempty subfamily of the distinct rows {V_x:x∈S} has a least member under inclusion. Equivalently, those distinct rows are well-ordered by inclusion. For a finite row family, they must form a chain: any two rows are nested. No numerical rank or temporal traversal was assumed. This order is forced by the stipulated uniform-response requirement under those contacts. It is not a derivation that all physical interactions or all VI relations are linearly ordered.

Incomparable rows have a small positive obstruction: responses a∈V_x\V_y and b∈V_y\V_x. The two-source restriction {x,y} and two-response restriction {a,b} suffice to exhibit the failure. Excluding every such crossed pattern is exactly the familiar Ferrers condition

    V(x,a) and V(y,b) imply V(x,b) or V(y,a).

Its equivalence to nested profiles is immediate: a violation supplies one member of each row outside the other, and conversely. The relation-algebra formulation is established in [Backhouse and Voermans, §7, Lemma 120](https://arxiv.org/html/2401.17130v1#S7). LQ13's three-corner condition instead says overlapping profiles coincide. A chain and an equality interface are different possible structures extracted from contacts.

**Mutual self-contact makes the restriction sharper.** Suppose source and response roles use the same carrier, V is symmetric, and every x admits contact with itself. Take S to be that complete carrier. If x and y cannot contact one another, the same two-source, two-response example is forced by their self-contacts: each can use itself, neither can use the other. Thus a symmetric reflexive contact satisfies the universal restriction-and-refinement promise only when every pair is admitted. One actual refused pair defeats that promise. This concerns the specified adequacy relation. The mere fact that two physical forms interact need not mean they can jointly realize the requested response, and physical source/response roles need not be symmetric. No observer or numerical geometry is required for this obstruction.

Both quantifiers matter. With rows {a}, {a,b}, {a,c}, the whole family has a least row, but removing the first leaves two incomparable rows. In an infinite chain V_n={m∈ℕ:m≥n}, every finite subfamily has a least row. The complete family has none, and K=ℕ exposes the failure. Restricting the available contact grammar can weaken these conditions. Adding true source information never removes an already common response for a fixed K. What can fail after refinement is the stronger promise that individual feasibility always supplies a common response.

`CommonCandidateResponse<C,P,Q>` binds two actual selection sources to the two catalogues in C and requires their selected responses to agree. In the finite leaf/fork and recursive-join grammar, it supplies a common-response witness. The three-response construction in `Checks/Interactions.swift` admits b for both original sources and admits a and c separately after the same new contact. It refuses both actual menu entries as substitutes for b, and also refuses inventing a b leaf whose catalogue is not that menu. `ResponseLiftsThroughInclusion` proves generically that a response supported by a least catalogue and the contact remains supported when the former catalogue is included in a larger one. The universal set criteria above are mathematical proofs. These type constructions establish the addressed finite witnesses and inclusion rule.

**What remains canonical when one adequate partition does not exist?** For S⊆X put F(S)=⋂_{x∈S}V_x, with F(∅)=A, and for K⊆A put G(K)={x:K⊆V_x}. Their defining relation is

    K⊆F(S)  iff  S⊆G(K).

Hence C(S)=G(F(S)) contains S, preserves F(S), and satisfies C(C(S))=C(S). It is the greatest source family with that same common-response set: F(T)=F(S) implies T⊆C(S). The pair (C(S),F(S)) is therefore fixed by the given contact relation, even when its source regions overlap. This is the established Galois closure of [formal concept analysis, commonality operators and Galois connection](https://lat.inf.tu-dresden.de/~francesco/KR2023-tutorial-session1.pdf), applied here to permitted responses. It needs no choice of a partition or an optimizer. Source existence must be retained separately: the empty family has every response only vacuously.

This compression has an exact composition scope. Adding alternative source conditions obeys F(S∪T)=F(S)∩F(T), so the two common-response sets determine the new one. A response restriction similarly gives F(S)∩K. Restricting the possible sources by new evidence need not descend to this image. Let V_x={a,b}, V_y={a}, V_z={a,c}. The families S₁={x,y} and S₂={y,z} both have image {a} and closure {x,y,z}. The same later evidence E={x,z} leaves two nonempty families, {x} and {z}, whose response sets differ. Neither the old common-response image nor its Galois closure can determine that update. The joint relation with the new evidence was omitted.

Thus a canonical description for current guaranteed responses need not support continued discovery. To promise later refinement, retain enough source/contact correspondence for those refinements, as VC15 requires. In the extreme grammar containing every singleton source test, preservation of feasibility after all such tests already determines the full source support. Seam §3 gives the boundary-restricted version. These are questions about the information retained at a given interface. They do not imply that omitted distinctions disappeared from the whole.

For a fixed finite response alphabet A of size r, an empty intersection has a witness using at most r source conditions: for each response a, choose one related source x_a that refuses it. Those finitely many sources already exclude every response. The bound is sharp: with A={1,…,r} and allowed sets A\{i}, all r conditions together conflict and every proper subfamily admits a response. This bounds a refusal certificate without requiring a finite whole or finite source family. New source conditions cannot repair that refusal. New responses can: completeness of the response alphabet remains a premise.

With an infinite response alphabet that finite witness need not exist. Take A=ℕ and one common input for source conditions n∈ℕ, with response a allowed exactly when a≥n. Every finite family admits a common response, while the whole family admits none. The finite action bound, not closure of reality, was doing the work. This is the same finite-domain issue examined in VC23. It is not a general proof that finite evidence settles every impossibility.

This is a qualitative regulation criterion, not a new general theory of control. [Ashby's *An Introduction to Cybernetics*, §10/7 and Chapter 11](https://ashby.info/Ashby-Introduction-to-Cybernetics.pdf) already distinguishes passive protection from informed counteraction and derives regulation bounds under explicit response-table assumptions. Here V must come from the particular preservation question and its established contacts. Calling V survival or cost supplies no such contacts. The Cut §13's cost-report model therefore cannot derive its signals, or feeling, from maintenance expenditure alone.

**A finite refusal also bounds probabilistic success.** Fix an input m and one response law μ used for every source condition related to m. All response sets mentioned here are measurable, and μ is a countably additive probability on A. Write B_x=A\V_x for the responses refused in condition x. If r source conditions have no common allowed response, their refusal sets cover A. Therefore

    ∑_(i=1)^r μ(B_(x_i)) ≥ μ(A) = 1,
    max_(1≤i≤r) μ(B_(x_i)) ≥ 1/r.

This follows by integrating the fact that every answer is refused by at least one of the r conditions. The bound is sharp for A={1,…,r}, B_i={i} and uniform μ. If every answer is refused by at least k of those conditions, the same argument gives k/r. More generally, nonnegative weights w_i satisfying ∑_i w_i 1_(B_(x_i))(a)≥1 for every a yield ∑_i w_i μ(B_(x_i))≥1. The obstruction is in the joint coverage, without an entropy or dynamics premise.

The common law is part of the contract. A source-dependent response kernel or a seed correlated with the source may change the attainable errors. That dependence must be included in the joint description. The sources, seed and preparation all remain internal. No objective randomness or exterior sampler follows from this mathematical account of uncertainty.

**Probability one for each condition need not give one common safe set.** Compare

    for every x, μ(V_x)=1

with the existence of a measurable Z of probability one such that Z⊆V_x for every x. The second implies the first. The first implies the second for a finite or countable condition family: its countable intersection has probability one. This uses the same countable-null-union fact as PP5c. Even that common set can exclude admitted answers of measure zero, so it is weaker than requiring every admitted response to be safe.

For an uncountable family, probability one in each condition need not supply a common Z. Let X=A=[0,1], V_x=[0,1]\{x}, and let μ be uniform on the interval. Every fixed condition has μ(V_x)=1, but ⋂_x V_x is empty. Each answer fails in the condition bearing its own value. Choosing that condition after seeing the answer introduces a dependence absent from a fixed condition and common response law. The two success questions have different quantifiers. This is a measure-theoretic counterdescription, without a physical device that produces exact real-valued answers.

The same diagonal-refusal example distinguishes three limits. For X=A and B_x={x}, let e(μ)=sup_x μ({x}):

| Response domain and admitted conditions | Infimum of worst-condition error and attainment |
|---|---|
| r distinct values | 1/r, attained by the uniform law |
| ℕ | Infimum 0, attained by no probability law |
| [0,1] with its usual measurable sets | 0, attained by the uniform law |

For ℕ, a law uniform on the first N answers has e=1/N. Yet e=0 would assign zero mass to every singleton and hence, by countable additivity, to all of ℕ. For the interval, each singleton already has measure zero under the uniform law. Thus arbitrarily small worst-condition error, an attained probability-one guarantee for each condition, and a universally allowed answer are distinct requirements. Cardinality here belongs to the declared response example, not to a conclusion about the whole of reality.

**What extra bridge lets probability zero exclude a contact?** Suppose every admitted bad answer has a witness w whose entire compatible-answer class C_w is bad. If every such admitted witness class has μ(C_w)>0, a nonempty bad set has positive measure: choose any of its answers and then its witness. Consequently μ(B_x)=0 implies B_x is empty. A finite or countable answer domain with positive mass at every admitted answer supplies one instance, regardless of how many source conditions are considered.

A different instance permits infinite answers. Suppose each refusal is certified by finitely many addressed readings and remains a refusal under every admitted extension of those readings. If every nonempty class specified by such a finite joint record has positive preparation probability, the same proof applies. Under the IID fair-bit law on infinite binary sequences, every length-n prefix has probability 2⁻ⁿ. A refusal forced by some prefix therefore cannot have probability zero. Equality to one specified infinite sequence is different: its singleton has probability at most 2⁻ⁿ for every n and hence zero, while no finite prefix by itself certifies that equality.

The positivity requirement concerns the joint witness class. Positive probabilities for its fields separately do not establish it. Nor does a finite written formula necessarily specify a positive-probability class: a short rule can describe a single infinite sequence. M71 supplies finite refusal chains for its identity contract, but it assigns no probabilities to their source classes. This bridge needs both an actual stable refusal witness and a preparation giving its class positive mass. Sampling without an established coverage or structural argument does not certify these premises. These arguments use ordinary countable additivity and finite covering. Their purpose is to delimit the probability reading of the already specified contacts.

### M26

**M26 (Novel-comparison bound).** For a fixed finite comparison domain `D ⊂ Σ` with persistent caching, at most `|D|²` ordered pairs can receive their first result. This bounds uncached comparisons, including uncached refusals. Repeated queries can continue without bound, and a cached refusal remains a refusal. The bound concerns new comparison work, not the disappearance of structural distance.

If an implementation supplies an upper cost `ε` for each such comparison and a total overhead budget `H`, then its discovery expenditure is at most `|D|² ε + H`. Landauer supplies neither upper bound.

### M27

**M27 (Cost transformation).** Crystallization replaces some repeated derivation with lookup and retained records. Whether this lowers total expenditure depends on task count, lookup cost, record size and maintenance duration. A break-even calculation must charge construction and storage as well as the saved comparisons. Structural reuse alone does not prove an unconditional decrease in joules per task.

### M28

**Theorem M28 (Conditional finite discovery budget).** Suppose the tower has finitely many levels, each level has a certified finite operation bound `N_n`, each charged operation has a finite upper cost `ε_n`, and total overhead has a finite upper bound `H`. Then discovery expenditure is bounded by `Σ_n N_n ε_n + H`.

*Proof.* Sum the supplied upper bounds over the finitely many operations and levels. QED

M16 provides tower termination only under its compression premise. Formal comparison counts must be translated into implementation operations to provide `N_n`. A minimum heat per reset cannot provide `ε_n`. This theorem bounds a completed discovery computation under those budgets, not the cost of preserving its record for infinite time. The current `FiniteDiscovery` protocol does not encode the physical upper budgets and does not certify them.

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:learning_is_liquid__coordination_blocks#LQ15>, <doc:permanence_is_resistance#M15>, <doc:permanence_is_resistance#M16>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__recovery_memory#VC23>, <doc:verdict_is_invariant__reusable_images#VC59>.

Mentions of this page’s labels: <doc:interference_is_substitution__program_mediator> (M25a), <doc:learning_is_liquid__medium_contacts> (M25a), <doc:permanence_is_resistance> (M26), <doc:permanence_is_resistance> (M27), <doc:permanence_is_resistance__forced_answers> (M25a), <doc:verdict_is_invariant__finite_records> (M25), <doc:verdict_is_invariant__recovery_memory> (M25a), <doc:verdict_is_invariant__relative_questions> (M25).
