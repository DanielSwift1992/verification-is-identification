# Verdict Is Invariant (Correspondence)

Seam Is Game judges a pair of declarations at the addresses the two sides speak about. Agreement Is Comparison prices the interval between judgements, and its model begins by assumption: "The shared reach of the pair has N addresses" (AiC Definition 2). Neither paper states who fixed the correspondence between one side's addresses and the other's, or when that fixing became a fact. Here the author states the law of the correspondence itself: what space a declaration creates for it, what its ambiguity is at the moment a second record is born, what a court can decide while the correspondence remains ambiguous, and what no history of states can settle about it.

The claim is one construction, two laws, and one impossibility. The construction: a reach written on both sides makes alignment a finite decidable game, and at an exact birth the admissible alignments form a torsor under the automorphism group of the carried content, so any ambiguity at birth is pure symmetry, and where more than one candidate survives in that symmetry orbit, choosing one equivariantly needs the additional relation identified by VI1a. The court's law: judgment runs on the admissible class. A verdict does not require knowing which correspondence holds; it requires the verdict to be invariant across every correspondence the records permit, and where it is not invariant the state is open, naming a missing distinguishing premise. The act's law: an act records the distinctions it performs, and only those. The impossibility: provenance is not a function of state history in the counterfamily of §5. A state record replays compatibility there, while origin needs a distinguishing event relation. Identification is sufficient for judgment. It is necessary only when the requested answer distinguishes the remaining correspondences. Otherwise invariance can suffice. One prohibition does the work throughout: a distinction the records have not made is never filled in; the court first asks whether the asked answer depends on it at all.

## §0. Derivation

No new postulate. From Existence Is Finite: Part III ("A space is not a process": the medium holds records, never acts), Theorem 3 (decidable COMPARE on Σ). From V=I: §5.4 (the semantics-preserving premise is external), §5.13 and §5.15 (the recursion licences Seam Is Game used, reused one level down), §5.20 (revelation, not creation), §5.21 (the admission rule for comparison events). From Seam Is Game: SG1 (the finite cardinality classification), SG2 (a revision-independent answer is constant over the admitted pairs), consequences (a) (acquisition and answer resolution differ) and (c) (a waiver does not prove semantic agreement). From Agreement Is Comparison: Definition 2 (the shared reach, assumed given: the assumption this paper grounds), AC4 (the edit model's independence), AC5 (local evidence suffices on constant answer fibers), AC6 (actual construction can establish output relations). From Merge Is Commutation: Definition 1 (the declared support must carry the actual reading). From Distance Is Cost: G2 (W is a metric). From Record Is System: SW1 (every act is a write or a reading: an act writes its result, never itself), SW3 (a reading cannot drift), SW4 (a test estimates by sample, with no word off-sample), §8 (the collapse is per position). Declared imports, standard and named where used: torsors of finite group actions; the tree matching complexity results of §6 (Aho, Hopcroft, and Ullman, 1974; Zhang and Shasha, 1989; Zhang, Statman, and Shasha, 1992).

## §1. Definitions

**Definition 1 (relation declaration).** A relation declaration for a pair (A, B) is a record carrying: the subject (that A and B are two records of one fact: the external premise of V=I §5.4, entered as Seam Is Game allows); the judged predicate, written J below; and the reach, written on both sides: a set R_A of A's addresses and a set R_B of B's, with |R_A| = |R_B|. A declaration that writes only R_A poses a different game (§2, the fibered remark), and recovering the second side from the records by likeness is an inference, not a reading: no premise of the court enters that way.

**Definition 2 (grammar, owned by the court).** G is the alignment grammar: the structure a correspondence must preserve to be admissible (shapes, types, the forms the court reads). G belongs to the court: the declaration names the grammar, and the pin fixes it for replay (§5). G and J are distinct by construction: one predicate for both makes every survivor pass trivially, and every Iso and Aut below is taken with respect to G, never to J. The symmetry of birth is a symmetry of the space of admissible alignments, not of the predicate later judged.

**Definition 3 (alignment space).** F(A, B, R_A, R_B) is the set of bijections m : R_A → R_B. Totality on both written sides is load-bearing: partial correspondences form a downward-closed family, the empty correspondence is consistent with everything, and a singleton survivor could not even be stated. The declaration does not only tell the court what to judge; it creates the finite space in which the question is decidable at all.

**Definition 4 (birth structure, birth game, class, drift).** The birth structure of side A is X₀ = (A|R_A, G, ν_A): the carried addresses, the grammar, and ν_A, the values at the pinned birth revision; Y₀ = (B|R_B, G, ν_B) likewise. At the birth revision, I₀ = Iso(X₀, Y₀), the correspondences preserving grammar and birth values both: this is strict birth consistency. At a later revision t, K_t ⊆ F is the class admissible under the recorded premises of the current court. The values of revision t enter the drift d_t(m) = W(A_t, B_t | m) (DiC G2), conditional on m, and never the admissibility: admitting by current values would smuggle least-drift selection into the class (§2). The count |K_t| measures the remaining ambiguity; log₂|K_t| is a convenience of notation and carries no information-theoretic claim.

**Definition 5 (witness).** A witness w is a finite record under which the required question becomes determinate on a narrowed class ∅ ≠ K_w ⊆ K: either K_w = {m*}, or, weaker and sufficient, J is invariant on K_w. The nonemptiness clause is load-bearing: a record that narrows the class to nothing is not a witness, since the alignment court reads the empty class as parted (§3) and no invariance is read off it. A witness is measured by sufficiency, never by size: it supplies enough recorded distinction to make the requested judgment invariant.

## §2. Birth: ambiguity is symmetry

### VI1

**VI1 (torsor).** Let the birth be an exact carry: Y₀ is an isomorphic copy of X₀. If I₀ = Iso(X₀, Y₀) is nonempty, it is a torsor under Aut(X₀): the automorphism group of the birth structure acts freely and transitively, so |I₀| = |Aut(X₀)|, and every candidate is m ∘ g for g in the group, with no candidate distinguished. The group is the birth structure's, never the bare grammar's: Aut_G alone overcounts wherever carried values break a structural symmetry. *Example:* on two addresses of equal value, identity and swap both preserve the carried structure, so its automorphism group has order two. With distinct values, swap no longer preserves the structure and only identity remains. The unvalued grammar still admits swap, which explains why its group cannot replace Aut(X₀).

*Proof.* For m₀, m₁ ∈ I₀, the composite m₀⁻¹ ∘ m₁ is defined because both are bijections onto the same written R_B, and it preserves G and ν_A, so it lies in Aut(X₀); the action is transitive. Freeness is the injectivity of m₀. ∎

The legacy `AmbiguityIsSymmetry`/`CarriedSymmetry` interface supplied no group action or torsor equations and is retired. VI1 and VI1a retain their mathematical proofs and stated premises. No symmetry-orbit assertion follows from a bare encoding coordinate.

*Remark (both sides act).* Aut(Y₀) acts on the other side, and the two groups have equal order: the structure is a bitorsor. Nothing below depends on which side is used.

**A symmetry orbit does not identify the parts it exchanges.** Take two distinct roles X={a,b}, with their exchange as a symmetry. Every unary invariant reading into an unchanged answer vocabulary is constant: invariance requires q(a)=q(b). Yet the joint relation d(x,y), answering whether the roles differ, is invariant under simultaneous exchange: d(hx,hy)=d(x,y). The diagonal pairs and the off-diagonal pairs give different answers. There are two orbits in X×X under this joint action, although X has one. Replacing each role separately by its orbit gives only one pair of images and cannot retain d. This is a positive failure of factorization: (a,a) and (a,b) acquire equal images and unequal answers.

No absolute name for either role is needed by d. Retaining one role as a context also supplies the relative unary reading qᵣ(x)=d(r,x). A change of description transforms r together with x. Quotienting by all exchanges while silently holding r fixed changes that contract. Matter M59 gives the general common-frame comparison, and VC15 permits identification only after preserving the specified joint questions and continuations. Thus The Cut §3's relational commitment cannot be replaced by identity of parts with equal isolated invariant readings. The absence of an intrinsic label does not remove a distinction carried by their relation.

**The difference question cannot be replaced by independent unary eligibility.** On the same two given roles a and b, difference admits (a,b) and (b,a) and refuses (a,a). Suppose its admitted pairs were P×Q, where each place is tested independently. The first admitted pair puts a in P, and the second puts a in Q. The product then admits (a,a), contrary to the given distinction. This finite obstruction is enough. It concerns a comparison applied to these roles in either order, including the identification case. It assumes no physical operation that independently prepares every listed pair.

A single already identified ordered occurrence (a,b) can still be retained in two fields. Separate codes for the two roles can also suffice when a joint comparison relates those codes. What fails is replacing the difference question by the conjunction of two independent one-place eligibility tests. The joint dependence of a question does not prove that its carrier has no parts, require entanglement, or identify a region of experience. It exposes exactly which relation an attempted decomposition omitted.

The exact replacement criterion can start from contacts themselves. Fix a carrier X and a specified family of finite-arity relations on it. Define x≡y when substituting x for y at any one place, with all other places retained, preserves both admission and refusal for every declared contact. Equality of these complete contextual profiles is an equivalence relation. It permits each contact to descend to X/≡: replacing its arguments one at a time preserves its answer. Conversely, if E:X→I represents every contact exactly on its image, E(x)=E(y) forces this contextual equivalence. Thus ≡ is the largest identification compatible with those contacts. This extends LQ13's profile criterion to the stated finite arities and uses no dynamics or predetermined unary measurement functions.

The relation's interpretation matters here. In a complete availability model, nonmembership represents refusal. In an evidence model, an absent admission record establishes only absence of that record. Positive admission and refusal records can instead be carried as separate relations with their source and context, without assuming that they are complements. The same profile criterion applies to each declared relation. It cannot decide an unrecorded contact or turn stored disagreement into one settled answer, as VC43 already distinguishes. Completeness of evidence and completeness of physical availability are different premises.

For d above, retaining a at the second place separates a from b because d(a,a) and d(b,a) differ. The symmetry moves both places together, while this replacement test retains the other place. Confusing those two moves would erase the relational distinction. The tuples address roles of the same structure, without assuming independent physical preparations. Exactness includes refused contacts. Preserving successful contacts alone could map this irreflexive relation to a one-form relation with a loop. The completeness of the declared family remains an obligation whenever its quotient is used beyond those contacts.

*Remark (the one-sided game is fibered).* With only R_A written, the admissible embeddings of R_A into B's addresses fiber over the admissible images, an image being a subset R_B′ of B's addresses with Iso(X₀, (B|R_B′, G, ν_B)) nonempty, the birth values included: each fibre is an Aut(X₀)-torsor, and the count is the exact product (number of admissible images) × |Aut(X₀)|. Location ambiguity and correspondence ambiguity then confound in one class. The minimal case: one carried address of value v against two addresses of value v yields two embeddings over a trivial group, and the torsor identity fails; writing R_B restores it. The second side of the reach is therefore part of the declaration, never of a scan.

**Relative correspondences survive the removal of absolute labels.** Keep VI1's two isomorphic structures A and B. Suppose several specified correspondences f₀,…,fₙ:A→B are jointly retained. These are data about correspondences or transports. They are not all being asserted to identify the same occurrences. Changing the descriptions of A and B by automorphisms α and β sends each fᵢ to βfᵢα⁻¹. Form the relative maps hᵢ=f₀⁻¹fᵢ on A, for i≥1. The joint change sends them to αhᵢα⁻¹.

The simultaneous conjugacy class of (h₁,…,hₙ) determines exactly the joint correspondence family up to these changes of description. Necessity is the displayed transformation. For sufficiency, suppose hᵢ′=αhᵢα⁻¹ for every i. Put β=f₀′αf₀⁻¹, an automorphism of B. Then βf₀α⁻¹=f₀′ and βfᵢα⁻¹=f₀′hᵢ′=fᵢ′. Thus one pair of changes carries the entire family. The reference f₀ is one retained internal correspondence, not an added frame outside the whole. This class is a complete invariant for the stated comparison. Its existence does not supply an instrument that acquires the correspondences.

For two correspondences, equality is equivalent to h₁ being the identity. Identity and exchange on two roles therefore remain distinguishable without identifying an absolute orientation of either endpoint. Matter M59–M60 supplies the corresponding contact and probe constructions in the direct/exchanged family. If both correspondences are instead claimed to identify the same occurrences faithfully, Seam SG3 requires this identity return. A nonidentity relative transport is not forbidden by its representation as a return.

Even the relative maps cannot in general be reduced separately and then recombined. Take a three-role structure with constant values and all role permutations as automorphisms. Let s exchange roles 1 and 2 and t exchange roles 2 and 3. The relative families (s,s) and (s,t) give the same separate conjugacy classes, since s and t are conjugate. They are not simultaneously conjugate: every common conjugation preserves equality of the two entries. The relation between the correspondences retains a distinction absent from their separate invariant descriptions. This is VI1's alignment issue applied to the joint family, without a claim that the physical whole has these finite carriers.

Three consequences of VI1:

- **Ambiguity at birth is pure symmetry.** The class is not arbitrary: it is exactly the value-preserving symmetry of what was carried. The minimal exhibit is two addresses carrying equal values: a group of order two, identity against swap, indistinguishable by that endpoint record.
- **Where |I₀| > 1, the birth data select no basepoint.** A singleton I₀ identifies its mapping by uniqueness. A larger I₀ does not determine whether the actual act used a particular correspondence. Where it did, that relation belongs to the act even if the birth record omits it. A further source-related fact or structural consequence can make the required answer available to this court without logging every part of the mapping. Where no representative was used, selecting one would add a requirement. These cases cannot be decided from symmetry alone.
- **An exact birth gives zero distance while preserving every symmetry the carried record fails to distinguish.** d = 0, and the class is exactly as wide as the birth structure's symmetry. Endpoint agreement alone does not establish a further correspondence. A question about which role an act used needs the source relation that distinguishes it.

### VI1a

**VI1a (a determined selection requires enough internal distinction).** Let a group H act on the complete available input space X and answer space Y. The input includes any record, instrument, parameter or schedule used by the proposed reading. Require the deterministic reading F to respect these changes of description: F(hx)=hF(x). For an actual input x, let H_x={h : hx=x}. Then F(x) must belong to Fix_Y(H_x), the answers fixed by every symmetry that preserves x.

Here the input contract is fixed independently of the desired result. Adding that result to X makes it readable by projection, but does not establish its determination from the original source. Matter §6 gives the exact relation criterion. A completed occurrence can be specific even when the proposed source reading fails that criterion. Calling the occurrence complete does not supply a deterministic selection law.

*Proof and converse on one orbit.* For h in H_x, hF(x)=F(hx)=F(x). Conversely, if y is fixed by H_x, define F(hx)=hy on the orbit of x. If hx=kx, then k⁻¹h belongs to H_x and hy=ky, so the definition is independent of the chosen description. It is equivariant by composition. Thus the equivariant readings on this orbit correspond exactly to Fix_Y(H_x). An empty fixed set forbids selection, a singleton forces one answer, and several fixed answers leave a further choice. The converse is a set-theoretic construction. Accessible implementation in a specified expression grammar is a separate obligation, as VC23a demonstrates. ∎

This strengthens VI1's absence of a basepoint with an exact test for an added reference. Supply an internal resource r in an H-space R. The stabilizer of the joint input (x,r) is H_x ∩ H_r. A prescribed answer y is possible on its joint orbit precisely when this intersection fixes y. Adding a slot or a record unchanged by H_x leaves the obstruction intact. The distinguishing resource can be a relation across several parts without occupying a dedicated register.

There is also a capacity bound. Suppose H is finite and fixes x. If F(x,r)=y, then H_r ⊆ H_y, hence |H·r|=[H:H_r] ≥ [H:H_y]=|H·y|. The resource must admit at least as many distinguishable alternatives on its orbit as the selected answer does. The bound is attained at this level by R=H·y and F(x,r)=r. This construction supplies a reference and a reading. Acquiring that reference requires a further construction. For VI1's nontrivial torsor of exact alignments, the action is free, so selecting one full alignment needs a resource orbit of at least |Aut(X₀)| states. An invariant verdict can need only one. These are capacities, not Shannon entropies without a distribution, and not counts of separate realities.

LQ13 distinguishes this selection criterion from recovery of an omitted source fact. A two-dimensional symplectic pairing over F₂ has a unique refinement invariant under all its symmetries. Yet two group contacts with that same pairing have different actual square laws. Selecting the invariant refinement does not recover both sources. In dimension at least four, three commuting symplectic maps already exclude an invariant refinement, although every two requirements are satisfiable. Some symmetries of the projected pairing also fail to lift to automorphisms of the complete group contact: precisely those that change its square law. The symmetry of an incomplete input must not be attributed to the whole source without that further check.

The two-side instance gives an explicit exclusion. If exchanging two candidate positions preserves the full available input, an equivariant binary leader answer must satisfy (a,b)=(b,a), so a=b. Requiring exactly one leader permits only 10 and 01, so no deterministic answer satisfies both requirements. Matter M58 and `SwapReturnForcesAgreement` already derive the required diagonal relation in bare Swift. The existing zero/successor witnesses exclude both orientations. No new marker named symmetric would establish equivariance of an arbitrary reading. A recorded orientation changes the input symmetry and makes a relative choice possible. V=I U2b supplies the related positive construction: a pin and opposite equations force a schedule, while the exchanged unpinned schedule remains admissible.

An adaptive deterministic protocol does not escape by taking more steps. If each step on its complete current configuration is equivariant and the initial configuration is H-fixed, induction makes every later configuration H-fixed. An equivariant final reading then has the same obstruction. A chosen address, asymmetric trained parameter, interaction schedule or random seed must be included when it is used. An asymmetric internal resource may remove the obstruction. The absence of an exterior does not make the actual whole symmetric.

**A unique distribution need not select a unique event.** For a finite answer space, an equivariant probability kernel K satisfies K(hx,hy)=K(x,y). At an H-fixed input its output probabilities are constant on each H-orbit. If the permitted answers form one finite transitive orbit, normalization forces the uniform distribution. For the two leader answers this is exactly P(10)=P(01)=1/2. Every sampled answer is asymmetric although the law is symmetric. Deterministic selection, set-valued admissibility and a probability law therefore pose different questions. Random selection can create a new alignment record. It does not recover a specific earlier alignment absent from its evidence.

The admission-only version is exact too. For an equivariant relation R⊆X×Y, its fiber R_x at x is invariant under H_x: y∈R_x implies hy∈R_x, and h⁻¹ gives the reverse inclusion. The fiber can contain a whole orbit with no fixed point. Thus a fixed-point obstruction to a determined answer cannot be applied to every member of an admitted set. Difference §5l uses this distinction when auditing physical selection rules.

The mathematics is classical. Deterministic symmetry obstructions are used in [Angluin's local and global network analysis](https://doi.org/10.1145/800141.804655) and explained in [Aspnes's leader-election notes](https://www.cs.yale.edu/homes/aspnes/pinewiki/LeaderElection.html). The contrast here is between the existence of an arbitrary representative and a selection determined equivariantly by the supplied relations. For a two-element set an arbitrary choice exists without any infinitary choice axiom, while a choice respecting its exchange does not. This is no inconsistency in classical mathematics. VI makes the latter obligation relevant when a result is presented as recovered knowledge.

Physical use requires the actual equation Fh=hF. In particular, time reversal can relate a forward evolution to its inverse rather than commute with that same evolution. Invariance of a law's wording alone is insufficient. [Roberts's analysis of Curie's principle](https://philsci-archive.pitt.edu/9862/) identifies this boundary. VI1a derives no preferred time direction, intrinsic randomness or physical symmetry group from closure alone.

**Afterwards, the observer's set and the court's class part ways.** Write E_t = {m ∈ F : d_t(m) = 0}, the exact-match set of revision t. Edits move E_t freely: one that breaks a symmetry can cut it to a singleton, one on a carried address can empty it. None of this touches K_t, which Definition 4 builds from recorded premises alone: E_t is an observation, E_t = ∅ is not alignment parted, and a court that judged on E_t would be reading current values as evidence of the birth. Post factum the pair (m, d) is jointly underdetermined: every mismatch under a candidate m is ambiguous between a divergence of the pair and a misalignment of the candidate. Minimizing d over candidates selects a representative under the undeclared premise that the least drift identifies the performed correspondence: an observer, never a court, unless the minimum-distance law is itself declared.

## §3. The two courts

### VI2

**VI2 (alignment court, then relation court).** The alignment floor is partitioned by SG1; the relation floor carries its own finite partition; the empty class is cut before any quantifier:

```
alignment court over K:
    |K| = 0  →  alignment parted (no admissible correspondence)
    |K| = 1  →  identified
    |K| > 1  →  an admissible class, no representative chosen

relation court over K ≠ ∅, judging J:
    ∀m∈K:  J(m)   →  holds
    ∀m∈K: ¬J(m)   →  parted
    otherwise      →  open, naming a missing distinguishing premise
```

There is no fourth state at either floor. The alignment floor is SG1's partition of the survivor count. The relation floor is its own: for s = |{m ∈ K : J(m)}| and K ≠ ∅, the set {0, …, |K|} is {0} ⊔ {1, …, |K|−1} ⊔ {|K|}, and the three cells are parted, open, holds. SG supplies the vocabulary and the licence to lift; the completeness of the lift is this one-line partition, never SG1's own. For a three-member class with exactly one positive candidate, 0 < s < |K|, so the verdict is open. **[solid: ``VerdictIsInvariant``]**

> Argues: ``VerdictIsInvariant`` needs ``ComparedReadings``. Invariance compares
answers to the same question in the same space and encoding. The corollary is the paper's title: **identification is sufficient for judgment, and invariance can require less.** A court that cannot name the correspondence may still judge exactly, whenever the verdict is constant on everything the records permit; and where it is not constant, open is the only justified state, its remedy named (SG consequence (a), one level down): any finite witness that makes J invariant on the narrowed class is sufficient, and full identification is one such witness, never the required one (Definition 5). There is no canonical missing receipt: a weaker premise that settles the asked question settles it.

**Corollary (settled verdicts are stable under premises).** Let a premise narrow the class at one position: ∅ ≠ K′ ⊆ K. Write L(K) = min of J over K and U(K) = max: holds is (1, 1), parted is (0, 0), open is (0, 1). Narrowing raises L and lowers U, so the verdict interval only shrinks: a supplied premise may resolve an open verdict, either way, and can reverse no settled one. The nonemptiness clause carries the corollary: an inconsistent premise empties the class, both bounds turn vacuous, and Definition 5 refuses it before the court reads it. The scope is one position: an edit is a new game (RiS §8), and nothing here constrains K across revisions.

**Remark (open is not a truth value).** Verdicts do not compose; candidates do. For J open on K, the predicate J-or-not-J is true at every candidate, and the court returns holds; a calculus that combined the statuses would return open, and be wrong. A compound question is evaluated per candidate and then quantified, never assembled from the verdicts of its parts.

Together, VI2, the corollary, and the remark fix a calculus of judgment under unidentified correspondence: premises act by narrowing the class, predicates evaluate inside candidates, the verdict is read only after quantification; refinement is monotone, and composition is internal, never verdict-level.

**VI2 uses none of §2's geometry.** The two courts quantify over an arbitrary finite class: fibered, orbit-structured, or neither.

**Lemma (invariance via generator symmetry).** At a two-sided birth K is a torsor under Aut(X₀). If every generator g of Aut(X₀) is a symmetry of J (for every admissible m, J(m∘g) = J(m)), then J is constant on K. For address-local predicates (a conjunction of per-address checks) the hypothesis is a per-generator comparison over the touched addresses, without enumerating the class, and tree automorphism groups admit polynomial generating sets. A single-point check is not sufficient: J(m₀∘g) = J(m₀) on every generator can hold while the orbit still splits. For a counterexample, take S₃ generated by its transpositions and let J be true on the identity and the transpositions, false on the 3-cycles. Every generator preserves the value at the identity, but two generators can reach a 3-cycle. This refutes the single-point test. Post-drift, distance-minimizing candidates need not form a torsor, so that separate tractability question remains open.

**Polarity is policy, not court.** The relation court is symmetric. What open answers outward (fatal or not, a candidate or a refusal) is a jurisdiction's choice, stated separately, never derived from the mathematics above.

## §4. The two laws, two owners

**The act's law: record the distinctions you perform.** If the act factors through a specific correspondence, that correspondence is a fact of the act, and an intensional record suffices exactly where the recorded invocation and its pinned premises identify one replayed correspondence. Repeatability of sampled executions is an estimate of that identification and never the premise itself (SW4: a test samples the reach, with no word off-sample); a hidden degree of freedom, a clock, an environment, a source of randomness, is refuted by one later run and inferred away by none. For example, define a generator with hidden counter n to return the same mapping at n = 0 and n = 1, then a different mapping at n = 2. Agreement of its first two outputs does not establish independence from n. A replay determined by the pinned record has no such undeclared coordinate. If the act does not factor through a representative, there is no representative to recover.

**The court's law: judge on the class.** A later question is answerable when the available records and established laws give the same answer on every admissible history. Its answer need not have been stored in a field bearing that question's name. If compatible histories disagree, the answer remains open. An explicit assumption can restrict that class, but a waiver is not evidence that the assumption describes the past. A certificate evaluated at birth covers later predicates only through an established sufficiency or transport relation.

**Missing and nonexistent are two different opens.** VI1's second reading splits the open state by its remedy. Where the act factored through a representative and recorded it, the distinction is read. Where an act selected one and the available evidence does not separate the possible choices, the historical question remains open. A new assumption alone is not a recovery. Where the actual construction did not select a representative, a convention selected now is a new event. The absence of a dedicated record does not decide between these cases. The act's law and its remaining evidence must establish which applies. A present convention cannot by itself certify a past selection.

## §5. History: compatibility replays, provenance does not

**Lemma (compatibility frontier).** Given the declaration, call a revision pair compatible when both carriers exist and the strict game there is nonempty. Compatibility is decidable per revision (EiF Theorem 3) and the reachable history is finite (I3), so the earliest compatible revision, the frontier, is decidable by scan, even when the declaration was written later. The frontier bounds every on-history birth from below. Taking the frontier for the birth asserts an undeclared premise, "the first compatibility is the carry": the temporal analog of least-drift selection, an observer, never a court.

**Lemma (state history does not identify provenance in general).** Let π be the map that takes a history of events to the history of states it leaves, forgetting the acts. π is not injective in general: two histories with different carry events can leave every recorded state equal. On any class H of histories containing such a pair, no left inverse on the image exists: no r : π(H) → H with r ∘ π = id_H, since r(π(h)) cannot equal h on both members of an identified pair; such an r exists exactly when the restriction of π to H is injective. A recovery map exists exactly for classes on which π is injective, and injectivity is restored on two roads: narrow the class of histories, or let the state record carry enough distinction to separate every pair of event histories that π identifies. The requirement is Definition 5's, one level up: enough recorded distinction for the asked separation, never the whole event. The kinship is noted and not compressed. A concrete obstruction needs only two distinct permitted events e₁ and e₂ with the same input and output state. Histories differing solely in this event have the same state projection but different provenance. Recording the event distinction, or excluding one event by premise, removes this particular obstruction.

**Compatibility and provenance can require different distinctions.** The counterfamily has equal recorded states and different event identities. Its state projection cannot identify origin. On another family, the same projection may be injective and sufficient. The question is what the actual records and admitted history law determine, rather than whether a dedicated field was named event. A compatibility scan alone supplies no missing event distinction in the counterfamily.

### VI3

**VI3 (replay decomposition, conditional).** Given durable carrier states and a pinned court (histories not rewritten, pinned bytes reachable, the grammar and the comparison law versioned under the pin), the following replay from the substrate: the carrier states, the strict game at any recorded revision, the compatibility frontier. The following additionally need a distinguishing relation when the available records admit different answers:

1. an independently chosen relation declaration (subject, J, the two-sided reach and grammar reference), if the carrier records do not determine it;
2. the other side's revision, if compatible histories with the same available archive permit different revisions (AC5, SG2);
3. the event identity: that, and at which revision, the carry happened (the birth pin), when the lemma's indistinguishable histories remain admissible despite a compatible revision appearing on both histories;
4. the act's representative choice, where |I₀|>1, a later judgment needs it, and the other records do not already determine that choice.

An absent dedicated record is not by itself an impossibility proof. AC5 supplies the exact criterion: all cases compatible with the available evidence must agree on the requested answer. A retained construction can make that criterion true without a second comparison.

Records 3 and 4 are facts of one event and may share one event witness; the compression is not forced here. Across the four, one law: **a precondition enters as a record, or as a reading that carries it verbatim; where obtaining it requires an inference, the inference is a new premise, and a premise enters as a record.**

## §6. The declared grammar prices the court

Existence Is Finite gives decidability, never tractability, and the price divides by floor. The birth court decides Iso(X₀, Y₀) under G: for rooted trees this is polynomial with order semantic and without it, since exact isomorphism of unordered rooted trees is linear (Aho, Hopcroft, and Ullman, 1974); for richer grammars the cost is the grammar's own, and general graph isomorphism carries no known polynomial bound and no known hardness. The post-drift observer minimizes d_t(m), and there the order boundary is real: ordered tree edit distance is polynomial (Zhang and Shasha, 1989), unordered tree edit distance is NP-complete (Zhang, Statman, and Shasha, 1992). Declaring order non-semantic therefore leaves the birth court cheap and prices the archaeology. Σ itself is ordered (PAIR carries a left and a right), so an encoding that keeps order semantic keeps both floors polynomial. Decidability delivers no practical court: tractability is a property of the declared grammar and of the question asked of it.

## §6a. A finite certificate in the type lattice

Derivations: <doc:verdict_is_invariant__finite_records#Detail-6a-A-finite-certificate-in-the-type-lattice>.

## §6b. Coverage needs an independent declaration

Derivations: <doc:verdict_is_invariant__finite_records#Detail-6b-Coverage-needs-an-independent-declaration>.

## §6c. A question can factor through a lossy encoding

Derivations: <doc:verdict_is_invariant__finite_records#Detail-6c-A-question-can-factor-through-a-lossy-encoding>.

## §6d. Today's invariant need not survive an operation

Derivations: <doc:verdict_is_invariant__finite_records#Detail-6d-Todays-invariant-need-not-survive-an-operation>.

## §6e. A finite proof for every constructed action path

Derivations: <doc:verdict_is_invariant__finite_records#Detail-6e-A-finite-proof-for-every-constructed-action-path>.

## §6f. Objects determined by possible actions

Derivations: <doc:verdict_is_invariant__finite_records#Detail-6f-Objects-determined-by-possible-actions>.

## §6g. Reversibility, memory and a common whole

Derivations: <doc:verdict_is_invariant__recovery_memory#Detail-6g-Reversibility-memory-and-a-common-whole>.

## §6h. A distinguishing question is not yet a discovery procedure

Derivations: <doc:verdict_is_invariant__discovery_acquisition#Detail-6h-A-distinguishing-question-is-not-yet-a-discovery-procedure>.

## §6i. Discovery of a verdict about an original state

Derivations: <doc:verdict_is_invariant__discovery_acquisition#Detail-6i-Discovery-of-a-verdict-about-an-original-state>.

## §6j. The experimenter is part of the experiment

Derivations: <doc:verdict_is_invariant__discovery_acquisition#Detail-6j-The-experimenter-is-part-of-the-experiment>.

## §6k. A certificate's scope under composition

Derivations: <doc:verdict_is_invariant__discovery_acquisition#Detail-6k-A-certificates-scope-under-composition>.

## §6l. One question across different representation codes

Derivations: <doc:verdict_is_invariant__discovery_acquisition#Detail-6l-One-question-across-different-representation-codes>.

## §6m. Saturation with a reason for every new distinction

Derivations: <doc:verdict_is_invariant__discovery_acquisition#Detail-6m-Saturation-with-a-reason-for-every-new-distinction>.

## §6n. Acquisition and reuse are type relations

Derivations: <doc:verdict_is_invariant__discovery_acquisition#Detail-6n-Acquisition-and-reuse-are-type-relations>.

## §6o. A finite relation basis for unbounded continuations

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6o-A-finite-relation-basis-for-unbounded-continuations>.

## §6p. Availability is part of the relation

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6p-Availability-is-part-of-the-relation>.

## §6q. The smallest image for a partial interaction

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6q-The-smallest-image-for-a-partial-interaction>.

## §6r. A class recovered from acquired evidence

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6r-A-class-recovered-from-acquired-evidence>.

## §6s. Composing changes of representation

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6s-Composing-changes-of-representation>.

## §6t. One evidence relation for a family of continuations

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6t-One-evidence-relation-for-a-family-of-continuations>.

## §6u. A new interaction can require a finer object

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6u-A-new-interaction-can-require-a-finer-object>.

## §6v. An internal participant acquires the missing distinction

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6v-An-internal-participant-acquires-the-missing-distinction>.

## §6w. Acquire only the distinction the retained image lacks

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6w-Acquire-only-the-distinction-the-retained-image-lacks>.

## §6x. Select from memory, prepare from resident resources

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6x-Select-from-memory-prepare-from-resident-resources>.

## §6y. Admissibility forced by a common-answer contract

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6y-Admissibility-forced-by-a-common-answer-contract>.

## §6z. A minimal image preserves the derived domain

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6z-A-minimal-image-preserves-the-derived-domain>.

## §6za. Acquire once under a resident agreement

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6za-Acquire-once-under-a-resident-agreement>.

## §6zb. A sufficient answer need not reveal its own domain

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6zb-A-sufficient-answer-need-not-reveal-its-own-domain>.

## §6zc. Acquire the relation that licenses a common answer

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6zc-Acquire-the-relation-that-licenses-a-common-answer>.

## §6zd. A resident second slot and an exact reading bound

Derivations: <doc:verdict_is_invariant__reusable_images#Detail-6zd-A-resident-second-slot-and-an-exact-reading-bound>.

## §6ze. Transport an acquired boundary through a source change

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6ze-Transport-an-acquired-boundary-through-a-source-change>.

## §6zf. A resident exchange makes an omitted distinction relevant

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zf-A-resident-exchange-makes-an-omitted-distinction-relevant>.

## §6zg. Close the working image under both internal exchanges

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zg-Close-the-working-image-under-both-internal-exchanges>.

## §6zh. The exact behavioral object has fifteen values

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zh-The-exact-behavioral-object-has-fifteen-values>.

## §6zi. Reachability and an expanded question family

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zi-Reachability-and-an-expanded-question-family>.

## §6zj. Acquire the minimal object from resident evidence

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zj-Acquire-the-minimal-object-from-resident-evidence>.

## §6zk. A new internal connection exposes the last omitted distinction

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zk-A-new-internal-connection-exposes-the-last-omitted-distinction>.

## §6zl. Acquiring a law through one common observation channel

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zl-Acquiring-a-law-through-one-common-observation-channel>.

## §6zm. A two-probe basis for four-address routing

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zm-A-two-probe-basis-for-four-address-routing>.

## §6zn. Reusing acquired routing with an explicitly read new input

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zn-Reusing-acquired-routing-with-an-explicitly-read-new-input>.

## §6zo. Two resident instruments acquire the probe pair

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zo-Two-resident-instruments-acquire-the-probe-pair>.

## §6zp. A changing mechanism can carry the same acquired law

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zp-A-changing-mechanism-can-carry-the-same-acquired-law>.

## §6zq. The acquired law determines which new input coordinates matter

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zq-The-acquired-law-determines-which-new-input-coordinates-matter>.

## §6zr. The observed law includes the internal output frame

Derivations: <doc:verdict_is_invariant__routing_laws#Detail-6zr-The-observed-law-includes-the-internal-output-frame>.

## §6zs. Existing knowledge, a new question and one necessary acquisition

Derivations: <doc:verdict_is_invariant__relative_questions#Detail-6zs-Existing-knowledge-a-new-question-and-one-necessary-acquisition>.

## §6zt. Known data changes how much of a law must be acquired

Derivations: <doc:verdict_is_invariant__relative_questions#Detail-6zt-Known-data-changes-how-much-of-a-law-must-be-acquired>.

## §6zu. A unique answer need not have a unique smallest input interface

Derivations: <doc:verdict_is_invariant__relative_questions#Detail-6zu-A-unique-answer-need-not-have-a-unique-smallest-input-interface>.

## §6zv. How much contact information makes an old record reusable?

Derivations: <doc:verdict_is_invariant__relative_questions#Detail-6zv-How-much-contact-information-makes-an-old-record-reusable>.

## §6zw. Acquiring an answer through the available probes

Derivations: <doc:verdict_is_invariant__relative_questions#Detail-6zw-Acquiring-an-answer-through-the-available-probes>.

## §6zx. A message for choosing an available action

Derivations: <doc:verdict_is_invariant__relative_questions#Detail-6zx-A-message-for-choosing-an-available-action>.

## §6zy. Finite distributed policies with shared local choices

Derivations: <doc:verdict_is_invariant__finite_policies#Detail-6zy-Finite-distributed-policies-with-shared-local-choices>.

## §6zz. What a returned bit must preserve

Derivations: <doc:verdict_is_invariant__finite_policies#Detail-6zz-What-a-returned-bit-must-preserve>.

## §6zza. More time cannot replace an unavailable distinction

Derivations: <doc:verdict_is_invariant__finite_policies#Detail-6zza-More-time-cannot-replace-an-unavailable-distinction>.

## §6zzb. When a bounded check covers every continuation

Derivations: <doc:verdict_is_invariant__finite_policies#Detail-6zzb-When-a-bounded-check-covers-every-continuation>.

## §6zzc. Transporting a procedure through local contacts

Derivations: <doc:verdict_is_invariant__finite_policies#Detail-6zzc-Transporting-a-procedure-through-local-contacts>.

## §6zzd. Available interventions constrain the hidden carrier

Derivations: <doc:verdict_is_invariant__local_lifts#Detail-6zzd-Available-interventions-constrain-the-hidden-carrier>, <doc:verdict_is_invariant__four_phase_catalogue>, <doc:verdict_is_invariant__action_interfaces>, <doc:verdict_is_invariant__return_costs>, <doc:verdict_is_invariant__calibration_residence>, <doc:verdict_is_invariant__bounded_calibration>.

### §6zze. Transported distinctions do not require a finite whole

Derivations: <doc:verdict_is_invariant__local_lifts#Detail-6zze-Transported-distinctions-do-not-require-a-finite-whole>.

### §6zzf. A minimal stage-only distinguishing continuation

Derivations: <doc:verdict_is_invariant__local_lifts#Detail-6zzf-A-minimal-stage-only-distinguishing-continuation>.

### §6zzg. A calibrated contact can fail substitution under internal selection

Derivations: <doc:verdict_is_invariant__local_lifts#Detail-6zzg-A-calibrated-contact-can-fail-substitution-under-internal-selection>.

### §6zzh. A relation of visible actions can fail on the carried phase

Derivations: <doc:verdict_is_invariant__local_lifts#Detail-6zzh-A-relation-of-visible-actions-can-fail-on-the-carried-phase>.

### §6zzi. The missing action can be acquired with one fewer point probe

Derivations: <doc:verdict_is_invariant__local_lifts#Detail-6zzi-The-missing-action-can-be-acquired-with-one-fewer-point-probe>.

### §6zzj. Twelve actual words supply the complete four-phase ambiguity

Derivations: <doc:verdict_is_invariant__four_phase_catalogue#Detail-6zzj-Twelve-actual-words-supply-the-complete-four-phase-ambiguity>, <doc:verdict_is_invariant__action_interfaces>, <doc:verdict_is_invariant__return_costs>.


### §6zzk. Six return equations and the cost of complete calibration

Derivations: <doc:verdict_is_invariant__calibration_residence#Detail-6zzk-Six-return-equations-and-the-cost-of-complete-calibration>.

### §6zzl. The finite evidence and the size of a relevant distinction

Derivations: <doc:verdict_is_invariant__calibration_residence#Detail-6zzl-The-finite-evidence-and-the-size-of-a-relevant-distinction>.

### §6zzm. Acquiring a window and restoring the target

Derivations: <doc:verdict_is_invariant__calibration_residence#Detail-6zzm-Acquiring-a-window-and-restoring-the-target>.

### §6zzn. A residence obstruction without an upper capacity bound

Derivations: <doc:verdict_is_invariant__calibration_residence#Detail-6zzn-A-residence-obstruction-without-an-upper-capacity-bound>.

### §6zzo. Exact residence costs under complete calibration

Derivations: <doc:verdict_is_invariant__calibration_residence#Detail-6zzo-Exact-residence-costs-under-complete-calibration>.

### §6zzp. An acquired choice can supply the inverse route

Derivations: <doc:verdict_is_invariant__calibration_residence#Detail-6zzp-An-acquired-choice-can-supply-the-inverse-route>.

### §6zzq. What a finite passing experiment cannot establish

Derivations: <doc:verdict_is_invariant__bounded_calibration#Detail-6zzq-What-a-finite-passing-experiment-cannot-establish>.

### §6zzr. A supplied bound makes positive calibration finite

Derivations: <doc:verdict_is_invariant__bounded_calibration#Detail-6zzr-A-supplied-bound-makes-positive-calibration-finite>.

### §6zzs. The residence argument depends on the observed action, not the star

Derivations: <doc:verdict_is_invariant__bounded_calibration#Detail-6zzs-The-residence-argument-depends-on-the-observed-action-not-the-star>.

## §7. Statement

1. A reach written on both sides creates the finite space in which alignment is decidable; a one-sided reach poses a fibered game in which location and correspondence confound, and the second side is part of the declaration, never of a scan (§1, §2).
2. At an exact birth the admissible alignments are a torsor under the automorphism group of the birth structure, grammar and carried values both: any ambiguity is pure symmetry, and where more than one candidate survives in that orbit, an equivariant choice needs the internal reference condition of VI1a.
3. Judgment runs on the admissible class: holds and parted require invariance over the class, open names a missing distinguishing premise, and any finite witness that makes the judged predicate invariant is sufficient; identification is sufficient without being a prerequisite for every question (VI2).
4. The relation court is independent of the birth geometry: it decides on arbitrary finite classes (VI2).
5. Invariance at a two-sided birth may be established through generator symmetries of the judged predicate; a single-point generator check does not suffice (Lemma).
6. The act records the distinctions it performs; the court judges on the class; neither predicts future predicates (§4).
7. State history need not identify provenance. It does so exactly when its projection separates the event distinctions being asked about. VI3 lists additional relations needed where this fails (§5).
8. Post-drift, correspondence and distance are jointly underdetermined; minimum-distance selection is observation unless declared as law (§2).
9. A supplied premise narrows the class and only shrinks the verdict interval: open may resolve, settled verdicts remain fixed; and verdicts do not compose, candidates do (Corollary, Remark).
10. A past choice can be recovered when available evidence determines it. If the admitted histories still disagree, further evidence or an explicit restriction is needed. A newly selected convention does not thereby establish that it was selected in the past (§4).

A verdict is exact when every admissible correspondence gives the same answer. A choice of representative is an additional task whose requirements depend on symmetry and the available internal reference. Historical recovery has the same discipline: retain or derive the distinction the question needs, and exhibit differing compatible histories before declaring it unrecoverable.

## Scope

Claimed: VI1 for an exact carry on a two-sided written reach, with the fibered remark for the one-sided game and VI1a for equivariant readings, internal references and finite probability kernels under their stated actions. Also the two-court structure, the alignment floor complete by SG1's partition and the relation floor by its own; the stability corollary and the non-compositionality remark; the generator-symmetry and compatibility-frontier lemmas; the non-identifiability of provenance from state history, in the scoped form of §5; VI3 under its stated conditions; the joint underdetermination reading of §2. Not claimed: any dynamics of |K_t| over time, in either direction; tractability of the post-drift court; a quotient presentation for the correspondence class of §2, which is a set without a declared equivalence on its members.

Sections 6a–6n add VC1–VC42 with their own premises. The implemented fragment checks finite certificate construction, exact coverage of a declared support tree, a supplied question factorization, and a generic family witness. One operation example refutes unrestricted propagation, while a second supplies a commuting factorization. Section 6e implements generic finite-path composition. The coarsest operational quotient and its boundaries in §6f are mathematical arguments under their declared state, operation and observation relations. Section 6g connects these to finite reversible images, sufficient windows, prepared memory and global compatibility, with generic window and equality-composition witnesses. Section 6h adds bounded separators, discovery policies and obstruction certificates, with table traces and retained-history witnesses. Section 6i specializes discovery to a fixed original-state question using labeled beliefs, with explicit refusal of retargeting that question after an intervention. Section 6j compiles an observation-only internal controller, separates branch reversibility from feedback reversibility, and constructs a finite whole for a prepared bounded experiment with an explicit limit on permanent readiness. Section 6k restricts component reuse to its certified input scope. Section 6l composes supplied factorizations across tagged representation codes and gives a closed realization with explicit preparation and intermediate-reading premises. Section 6m certifies the least autonomous refinement by future-reading witnesses, including mixed continuations and a separate acquisition boundary. Section 6n derives recording, evidence refinement and certified reuse through generic type relations, including the existing decoder's exact input and answer. No claim is made that Swift seals the constructor grammar, that a supplied model covers reality, or that every question family has a finite proof basis.

Sections 6o–6zf connect a finite relation basis for continued use, availability, partial interactions and source-bound acquisition. Their sufficient images, retained evidence and prepared exchanges are stated on their own declared carriers and action families. A sufficient old answer does not by itself certify a new contact or expose the domain on which that answer remains usable.

Sections 6zg–6zk close two internal exchange generators, identify the exact fifteen-value common-behavior image on the full binary working carrier and its thirteen-value restriction to the prepared reachable carrier, and derive its reuse from acquired evidence. A third internal exchange splits the remaining pair while preserving the common question. The binary comparison clauses, total action family and source-bound acquisition premises specify each result's scope. The count concerns behavioral values, not whole histories or runtime inhabitants of Swift types.

Sections 6zl–6zr acquire an E/K law from a prepared response and reconstruct four-address routing from two binary probe images. A product factorization reuses the acquired routing with an explicitly read new input and supplies an existing common-answer table. The law family, probe preparation and stable routing delimit each conclusion. An internal changing schedule produces the same record as a fixed permutation, so neither whole-source identity nor record consistency supplies stationarity.

Sections 6zs–6zzs develop question-relative acquisition, available probes and distributed choices, transport through local contacts, carried-phase obstructions and residence costs. Their finite calibrations and lower bounds retain the original question, admitted actions, initial preparation and actual residue. A finite passing experiment supplies its stated certificate. A supplied bound can make a stronger calibration finite, but success on a tested prefix does not establish that bound. Each result keeps the scope of its local statement and proof.

Kin outside the corpus, imported as nothing. The relation court's universal quantification has ancestors in certain answers over incomplete databases and over uncertain schema mappings (Imielinski and Lipski, 1984; Dong, Halevy, and Yu, 2009), where a query is answered under every world or mapping the records permit. The three verdicts are the supervaluationist's (van Fraassen, 1966; Fine, 1975): truth on every admissible precisification, falsity on every one, indeterminacy between; the relation court supervaluates over correspondences, and the remark that open is not a truth value is that tradition's own boundary against three-valued logic. The bitorsor of isomorphisms under the two automorphism groups is classical. Provenance attestation formats (W3C PROV; in-toto and SLSA) record event witnesses for build artifacts in practice, and rename-reconstruction tools document their own threshold sensitivity and confusion classes, living the joint underdetermination of §2. The works surveyed here do not state the composition claimed here: the class of correspondences derived from a written reach and the symmetry of a birth; the two-floor court with parted and open as first-class verdicts and the witness measured by sufficiency; and the non-identifiability of provenance from state history as a theorem rather than a practice. No priority is claimed over any of them, and the derivation above uses none of their steps.

## §8. Dependency

| Source | Used |
|---|---|
| Existence Is Finite | Part III (a space is not a process), Theorem 3 |
| V=I | §5.4, §5.13, §5.15, §5.20, §5.21 |
| Seam Is Game | SG1, SG2, consequences (a) and (c) |
| Agreement Is Comparison | Definition 2, AC4, AC5, AC6 |
| Merge Is Commutation | Definition 1 (the reach is written) |
| Distance Is Cost | G2 |
| Record Is System | SW1, SW3, SW4, §8 |
| Seeing Is Encoding | visible projection and its hidden coordinate, used in VC9–VC12 |
| Colour Is a Quotient | equality of encoded images and the question-relative loss in §6c |
| Basis Is Residue | finite basis versus unbounded reach, compared with finite proof size in §§6c–6d |
| Solvability Criterion | C1 distinguished from declared support coverage in §6b |
| Nash, Segoufin and Vianu (2010) | semantic determinacy distinguished from rewriting in a chosen language, §6c |
| Rutten (2000) | behavioral semantics and its distinction from algebraic construction, §6f |
| Declared here | torsors of finite group actions; linear isomorphism of rooted unordered trees (Aho, Hopcroft, and Ullman, 1974); ordered tree edit distance in polynomial time (Zhang and Shasha, 1989); unordered tree edit distance NP-complete (Zhang, Statman, and Shasha, 1992); the forgetful-map argument of §5 |

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:permanence_is_resistance__retention#M58>, <doc:permanence_is_resistance__retention#M59>, <doc:permanence_is_resistance__retention#M60>, <doc:verdict_is_invariant__finite_records#VC1>, <doc:verdict_is_invariant__finite_records#VC12>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__recovery_memory#VC23a>, <doc:verdict_is_invariant__discovery_acquisition#VC42>, <doc:verdict_is_invariant__discovery_acquisition#VC43>, <doc:verdict_is_invariant__finite_records#VC9>.

Mentions of this page’s labels: <doc:interference_is_substitution__models_calibration> (VI1), <doc:learning_is_liquid> (VI1), <doc:learning_is_liquid> (VI1a), <doc:learning_is_liquid__atoms_continuations> (VI1), <doc:learning_is_liquid__medium_contacts> (VI1), <doc:learning_is_liquid__medium_contacts> (VI1a), <doc:learning_is_liquid__reconstructed_sides> (VI1), <doc:learning_is_liquid__reconstructed_sides> (VI1a), <doc:permanence_is_resistance__forced_answers> (VI1a), <doc:permanence_is_resistance__forced_answers> (VI2), <doc:permanence_is_resistance__records_entropy> (VI1), <doc:verdict_is_invariant__discovery_acquisition> (VI2), <doc:verdict_is_invariant__finite_records> (VI1), <doc:verdict_is_invariant__recovery_memory> (VI1a).

## Topics

### Parts

- <doc:verdict_is_invariant__finite_records>
- <doc:verdict_is_invariant__recovery_memory>
- <doc:verdict_is_invariant__discovery_acquisition>
- <doc:verdict_is_invariant__reusable_images>
- <doc:verdict_is_invariant__routing_laws>
- <doc:verdict_is_invariant__relative_questions>
- <doc:verdict_is_invariant__finite_policies>
- <doc:verdict_is_invariant__local_lifts>
- <doc:verdict_is_invariant__four_phase_catalogue>
- <doc:verdict_is_invariant__action_interfaces>
- <doc:verdict_is_invariant__return_costs>
- <doc:verdict_is_invariant__calibration_residence>
- <doc:verdict_is_invariant__bounded_calibration>

### Related type declarations

- ``PredicateReading``
- ``VerdictIsInvariant``
- ``CandidateReading``
- ``CandidateLeafReading``
- ``VerdictCoversBranches``
- ``CandidateGroupReading``
- ``ReadingFactors``
- ``RecordedAnswerReading``
- ``AcquiresAnswer``
