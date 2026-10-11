# Verdict Is Invariant (Correspondence)

Seam Is Game judges a pair of declarations at the addresses the two
sides speak about. Agreement Is Comparison prices the interval between
judgements, and its model begins by assumption: "The shared reach of
the pair has N addresses" (AiC Definition 2). Neither paper states who
fixed the correspondence between one side's addresses and the other's,
or when that fixing became a fact. Here the author states the law of
the correspondence itself: what space a declaration creates for it,
what its ambiguity is at the moment a second record is born, what a
court can decide while the correspondence remains ambiguous, and what no
history of states can settle about it.

The claim is one construction, two laws, and one impossibility. The
construction: a reach written on both sides makes alignment a finite
decidable game, and at an exact birth the admissible alignments form a
torsor under the automorphism group of the carried content, so any
ambiguity at birth is pure symmetry, and where more than one candidate
survives in that symmetry orbit, choosing one equivariantly needs the
additional relation identified by VI1a. The court's law: judgment runs on the admissible class. A verdict does not
require knowing which correspondence holds; it requires the verdict to
be invariant across every correspondence the records permit, and where
it is not invariant the state is open, naming a missing distinguishing
premise. The act's law: an act records the distinctions it performs,
and only those. The impossibility: provenance is not a function of
state history in the counterfamily of §5. A state record replays
compatibility there, while origin needs a distinguishing event relation.
Identification is sufficient for judgment. It is necessary only when
the requested answer distinguishes the remaining correspondences.
Otherwise invariance can suffice. One prohibition does
the work throughout: a distinction the records have not made is never
filled in; the court first asks whether the asked answer depends on it
at all.

## §0. Derivation

No new postulate. From Existence Is Finite: Part III ("A space is not
a process": the medium holds records, never acts), Theorem 3 (decidable
COMPARE on Σ). From V=I: §5.4 (the semantics-preserving premise is
external), §5.13 and §5.15 (the recursion licences Seam Is Game used,
reused one level down), §5.20 (revelation, not creation), §5.21
(the admission rule for comparison events). From Seam Is
Game: SG1 (the finite cardinality classification), SG2
(a revision-independent answer is constant over the admitted pairs),
consequences (a) (acquisition and answer resolution differ) and (c)
(a waiver does not prove semantic agreement). From Agreement
Is Comparison: Definition 2 (the shared reach, assumed given: the
assumption this paper grounds), AC4 (the edit model's independence),
AC5 (local evidence suffices on constant answer fibers), AC6 (actual
construction can establish output relations). From Merge Is Commutation: Definition 1 (the declared
support must carry the actual reading). From Distance Is Cost: G2 (W is a metric). From Record Is
System: SW1 (every act is a write or a reading: an act writes its
result, never itself), SW3 (a reading cannot drift), SW4 (a test
estimates by sample, with no word off-sample), §8 (the collapse is per
position). Declared imports, standard and named where used: torsors of
finite group actions; the tree matching complexity results of §6 (Aho,
Hopcroft, and Ullman, 1974; Zhang and Shasha, 1989; Zhang, Statman,
and Shasha, 1992).

## §1. Definitions

**Definition 1 (relation declaration).** A relation declaration for a
pair (A, B) is a record carrying: the subject (that A and B are two
records of one fact: the external premise of V=I §5.4, entered as Seam
Is Game allows); the judged predicate, written J below; and the reach,
written on both sides: a set R_A of A's addresses and a set R_B of B's,
with |R_A| = |R_B|. A declaration that writes only R_A poses a
different game (§2, the fibered remark), and recovering the second
side from the records by likeness is an inference, not a reading: no
premise of the court enters that way.

**Definition 2 (grammar, owned by the court).** G is the alignment
grammar: the structure a correspondence must preserve to be admissible
(shapes, types, the forms the court reads). G belongs to the court:
the declaration names the grammar, and the pin fixes it for replay
(§5). G and J are distinct by construction: one predicate for both
makes every survivor pass trivially, and every Iso and Aut below is
taken with respect to G, never to J. The symmetry of birth is a
symmetry of the space of admissible alignments, not of the predicate
later judged.

**Definition 3 (alignment space).** F(A, B, R_A, R_B) is the set of
bijections m : R_A → R_B. Totality on both written sides is
load-bearing: partial correspondences form a downward-closed family,
the empty correspondence is consistent with everything, and a
singleton survivor could not even be stated. The declaration does not
only tell the court what to judge; it creates the finite space in
which the question is decidable at all.

**Definition 4 (birth structure, birth game, class, drift).** The
birth structure of side A is X₀ = (A|R_A, G, ν_A): the carried
addresses, the grammar, and ν_A, the values at the pinned birth
revision; Y₀ = (B|R_B, G, ν_B) likewise. At the birth revision,
I₀ = Iso(X₀, Y₀), the correspondences preserving grammar and birth
values both: this is strict birth consistency. At a later revision t,
K_t ⊆ F is the class admissible under the recorded premises of the
current court. The values of revision t enter the drift
d_t(m) = W(A_t, B_t | m) (DiC G2), conditional on m, and never the
admissibility: admitting by current values would smuggle least-drift
selection into the class (§2). The count |K_t| measures the remaining
ambiguity; log₂|K_t| is a convenience of notation and carries no
information-theoretic claim.

**Definition 5 (witness).** A witness w is a finite record under which
the required question becomes determinate on a narrowed class
∅ ≠ K_w ⊆ K: either K_w = {m*}, or, weaker and sufficient, J is
invariant on K_w. The nonemptiness clause is load-bearing: a record
that narrows the class to nothing is not a witness, since the
alignment court reads the empty class as parted (§3) and no invariance
is read off it. A witness is measured by sufficiency, never by size:
it supplies enough recorded distinction to make the requested judgment
invariant.

## §2. Birth: ambiguity is symmetry

**VI1 (torsor).** Let the birth be an exact carry: Y₀ is an isomorphic
copy of X₀. If I₀ = Iso(X₀, Y₀) is nonempty, it is a torsor under
Aut(X₀): the automorphism group of the birth structure acts freely and
transitively, so |I₀| = |Aut(X₀)|, and every candidate is m ∘ g for g
in the group, with no candidate distinguished. The group is the birth
structure's, never the bare grammar's: Aut_G alone overcounts wherever
carried values break a structural symmetry. *Example:* on two addresses of equal value, identity and swap both preserve the carried structure, so its automorphism group has order two. With distinct values, swap no longer preserves the structure and only identity remains. The unvalued grammar still admits swap, which explains why its group cannot replace Aut(X₀).

*Proof.* For m₀, m₁ ∈ I₀, the composite m₀⁻¹ ∘ m₁ is defined because
both are bijections onto the same written R_B, and it preserves G and
ν_A, so it lies in Aut(X₀); the action is transitive. Freeness is the
injectivity of m₀. ∎

The legacy `AmbiguityIsSymmetry`/`CarriedSymmetry` interface supplied no group action or torsor equations and is retired. VI1 and VI1a retain their mathematical proofs and stated premises. No symmetry-orbit assertion follows from a bare encoding coordinate.

*Remark (both sides act).* Aut(Y₀) acts on the other side, and the two
groups have equal order: the structure is a bitorsor. Nothing below
depends on which side is used.

**A symmetry orbit does not identify the parts it exchanges.** Take two distinct roles X={a,b}, with their exchange as a symmetry. Every unary invariant reading into an unchanged answer vocabulary is constant: invariance requires q(a)=q(b). Yet the joint relation d(x,y), answering whether the roles differ, is invariant under simultaneous exchange: d(hx,hy)=d(x,y). The diagonal pairs and the off-diagonal pairs give different answers. There are two orbits in X×X under this joint action, although X has one. Replacing each role separately by its orbit gives only one pair of images and cannot retain d. This is a positive failure of factorization: (a,a) and (a,b) acquire equal images and unequal answers.

No absolute name for either role is needed by d. Retaining one role as a context also supplies the relative unary reading qᵣ(x)=d(r,x). A change of description transforms r together with x. Quotienting by all exchanges while silently holding r fixed changes that contract. Matter M59 gives the general common-frame comparison, and VC15 permits identification only after preserving the specified joint questions and continuations. Thus The Cut §3's relational commitment cannot be replaced by identity of parts with equal isolated invariant readings. The absence of an intrinsic label does not remove a distinction carried by their relation.

**The difference question cannot be replaced by independent unary eligibility.** On the same two given roles a and b, difference admits (a,b) and (b,a) and refuses (a,a). Suppose its admitted pairs were P×Q, where each place is tested independently. The first admitted pair puts a in P, and the second puts a in Q. The product then admits (a,a), contrary to the given distinction. This finite obstruction is enough. It concerns a comparison applied to these roles in either order, including the identification case. It assumes no physical operation that independently prepares every listed pair.

A single already identified ordered occurrence (a,b) can still be retained in two fields. Separate codes for the two roles can also suffice when a joint comparison relates those codes. What fails is replacing the difference question by the conjunction of two independent one-place eligibility tests. The joint dependence of a question does not prove that its carrier has no parts, require entanglement, or identify a region of experience. It exposes exactly which relation an attempted decomposition omitted.

The exact replacement criterion can start from contacts themselves. Fix a carrier X and a specified family of finite-arity relations on it. Define x≡y when substituting x for y at any one place, with all other places retained, preserves both admission and refusal for every declared contact. Equality of these complete contextual profiles is an equivalence relation. It permits each contact to descend to X/≡: replacing its arguments one at a time preserves its answer. Conversely, if E:X→I represents every contact exactly on its image, E(x)=E(y) forces this contextual equivalence. Thus ≡ is the largest identification compatible with those contacts. This extends LQ13's profile criterion to the stated finite arities and uses no dynamics or predetermined unary measurement functions.

The relation's interpretation matters here. In a complete availability model, nonmembership represents refusal. In an evidence model, an absent admission record establishes only absence of that record. Positive admission and refusal records can instead be carried as separate relations with their source and context, without assuming that they are complements. The same profile criterion applies to each declared relation. It cannot decide an unrecorded contact or turn stored disagreement into one settled answer, as VC43 already distinguishes. Completeness of evidence and completeness of physical availability are different premises.

For d above, retaining a at the second place separates a from b because d(a,a) and d(b,a) differ. The symmetry moves both places together, while this replacement test retains the other place. Confusing those two moves would erase the relational distinction. The tuples address roles of the same structure, without assuming independent physical preparations. Exactness includes refused contacts. Preserving successful contacts alone could map this irreflexive relation to a one-form relation with a loop. The completeness of the declared family remains an obligation whenever its quotient is used beyond those contacts.

*Remark (the one-sided game is fibered).* With only R_A written, the
admissible embeddings of R_A into B's addresses fiber over the
admissible images, an image being a subset R_B′ of B's addresses with
Iso(X₀, (B|R_B′, G, ν_B)) nonempty, the birth values included: each
fibre is an Aut(X₀)-torsor, and the count is the exact product
(number of admissible images) × |Aut(X₀)|.
Location ambiguity and correspondence ambiguity then confound in one
class. The minimal case: one carried address of value v against two
addresses of value v yields two embeddings over a trivial group, and
the torsor identity fails; writing R_B restores it. The second side of
the reach is therefore part of the declaration, never of a scan.

**Relative correspondences survive the removal of absolute labels.** Keep VI1's two isomorphic structures A and B. Suppose several specified correspondences f₀,…,fₙ:A→B are jointly retained. These are data about correspondences or transports. They are not all being asserted to identify the same occurrences. Changing the descriptions of A and B by automorphisms α and β sends each fᵢ to βfᵢα⁻¹. Form the relative maps hᵢ=f₀⁻¹fᵢ on A, for i≥1. The joint change sends them to αhᵢα⁻¹.

The simultaneous conjugacy class of (h₁,…,hₙ) determines exactly the joint correspondence family up to these changes of description. Necessity is the displayed transformation. For sufficiency, suppose hᵢ′=αhᵢα⁻¹ for every i. Put β=f₀′αf₀⁻¹, an automorphism of B. Then βf₀α⁻¹=f₀′ and βfᵢα⁻¹=f₀′hᵢ′=fᵢ′. Thus one pair of changes carries the entire family. The reference f₀ is one retained internal correspondence, not an added frame outside the whole. This class is a complete invariant for the stated comparison. Its existence does not supply an instrument that acquires the correspondences.

For two correspondences, equality is equivalent to h₁ being the identity. Identity and exchange on two roles therefore remain distinguishable without identifying an absolute orientation of either endpoint. Matter M59–M60 supplies the corresponding contact and probe constructions in the direct/exchanged family. If both correspondences are instead claimed to identify the same occurrences faithfully, Seam SG3 requires this identity return. A nonidentity relative transport is not forbidden by its representation as a return.

Even the relative maps cannot in general be reduced separately and then recombined. Take a three-role structure with constant values and all role permutations as automorphisms. Let s exchange roles 1 and 2 and t exchange roles 2 and 3. The relative families (s,s) and (s,t) give the same separate conjugacy classes, since s and t are conjugate. They are not simultaneously conjugate: every common conjugation preserves equality of the two entries. The relation between the correspondences retains a distinction absent from their separate invariant descriptions. This is VI1's alignment issue applied to the joint family, without a claim that the physical whole has these finite carriers.

Three consequences of VI1:

- **Ambiguity at birth is pure symmetry.** The class is not arbitrary:
  it is exactly the value-preserving symmetry of what was carried. The
  minimal exhibit is two addresses carrying equal values: a group of
  order two, identity against swap, indistinguishable by that endpoint record.
- **Where |I₀| > 1, the birth data select no basepoint.** A singleton I₀
  identifies its mapping by uniqueness. A larger I₀ does not determine
  whether the actual act used a particular correspondence. Where it did,
  that relation belongs to the act even if the birth record omits it.
  A further source-related fact or structural consequence can make the
  required answer available to this court without logging every part of
  the mapping. Where no representative was used, selecting one would add
  a requirement. These cases cannot be decided from symmetry alone.
- **An exact birth gives zero distance while preserving every symmetry
  the carried record fails to distinguish.** d = 0, and the class is
  exactly as wide as the birth structure's symmetry. Endpoint agreement
  alone does not establish a further correspondence. A question about
  which role an act used needs the source relation that distinguishes it.

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

**Afterwards, the observer's set and the court's class part ways.**
Write E_t = {m ∈ F : d_t(m) = 0}, the exact-match set of revision t.
Edits move E_t freely: one that breaks a symmetry can cut it to a
singleton, one on a carried address can empty it. None of this touches
K_t, which Definition 4 builds from recorded premises alone: E_t is an
observation, E_t = ∅ is not alignment parted, and a court that judged
on E_t would be reading current values as evidence of the birth. Post
factum the pair (m, d) is jointly underdetermined: every mismatch
under a candidate m is ambiguous between a divergence of the pair and
a misalignment of the candidate. Minimizing d over candidates selects
a representative under the undeclared premise that the least drift
identifies the performed correspondence: an observer, never a court,
unless the minimum-distance law is itself declared.

## §3. The two courts

**VI2 (alignment court, then relation court).** The alignment floor is
partitioned by SG1; the relation floor carries its own finite
partition; the empty class is cut before any quantifier:

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

There is no fourth state at either floor. The alignment floor is
SG1's partition of the survivor count. The relation floor is its own:
for s = |{m ∈ K : J(m)}| and K ≠ ∅, the set {0, …, |K|} is
{0} ⊔ {1, …, |K|−1} ⊔ {|K|}, and the three cells are parted, open,
holds. SG supplies the vocabulary and the licence to lift; the
completeness of the lift is this one-line partition, never SG1's own.
For a three-member class with exactly one positive candidate, 0 < s < |K|, so the verdict is open. **[solid: ``VerdictIsInvariant``]**

> Argues: ``VerdictIsInvariant`` needs ``ComparedReadings``. Invariance compares
answers to the same question in the same space and encoding. The corollary is the paper's
title: **identification is
sufficient for judgment, and invariance can require less.** A court that cannot name the correspondence may still
judge exactly, whenever the verdict is constant on everything the
records permit; and where it is not constant, open is the only justified
state, its remedy named (SG consequence (a), one level down): any
finite witness that makes J invariant on the narrowed class is
sufficient, and full identification is one such witness, never the
required one (Definition 5). There is no canonical missing receipt: a
weaker premise that settles the asked question settles it.

**Corollary (settled verdicts are stable under premises).** Let a
premise narrow the class at one position: ∅ ≠ K′ ⊆ K. Write
L(K) = min of J over K and U(K) = max: holds is (1, 1), parted is
(0, 0), open is (0, 1). Narrowing raises L and lowers U, so the
verdict interval only shrinks: a supplied premise may resolve an open
verdict, either way, and can reverse no settled one. The nonemptiness
clause carries the corollary: an inconsistent premise empties the
class, both bounds turn vacuous, and Definition 5 refuses it before
the court reads it. The scope is one position: an edit is a new game
(RiS §8), and nothing here constrains K across revisions.

**Remark (open is not a truth value).** Verdicts do not compose;
candidates do. For J open on K, the predicate J-or-not-J is true at
every candidate, and the court returns holds; a calculus that combined
the statuses would return open, and be wrong. A compound question is
evaluated per candidate and then quantified, never assembled from the
verdicts of its parts.

Together, VI2, the corollary, and the remark fix a calculus of judgment
under unidentified correspondence: premises act by narrowing the
class, predicates evaluate inside candidates, the verdict is read only
after quantification; refinement is monotone, and composition is
internal, never verdict-level.

**VI2 uses none of §2's geometry.** The two courts quantify over an
arbitrary finite class: fibered, orbit-structured, or neither.

**Lemma (invariance via generator symmetry).** At a two-sided birth K
is a torsor under Aut(X₀). If every generator g of Aut(X₀) is a
symmetry of J (for every admissible m, J(m∘g) = J(m)), then J is
constant on K.
For address-local predicates (a conjunction of per-address checks) the
hypothesis is a per-generator comparison over the touched addresses,
without enumerating the class, and tree automorphism groups admit
polynomial generating sets. A single-point check is not sufficient:
J(m₀∘g) = J(m₀) on every generator can hold while the orbit still
splits. For a counterexample, take S₃ generated by its transpositions and let J be true on the identity and the transpositions, false on the 3-cycles. Every generator preserves the value at the identity, but two generators can reach a 3-cycle. This refutes the single-point test. Post-drift, distance-minimizing candidates need not form a torsor, so that separate tractability question remains open.

**Polarity is policy, not court.** The relation court is symmetric.
What open answers outward (fatal or not, a candidate or a refusal) is
a jurisdiction's choice, stated separately, never derived from the
mathematics above.

## §4. The two laws, two owners

**The act's law: record the distinctions you perform.** If the act
factors through a specific correspondence, that correspondence is a
fact of the act, and an intensional record suffices exactly where the
recorded invocation and its pinned premises identify one replayed
correspondence. Repeatability of sampled executions is an estimate of
that identification and never the premise itself (SW4: a test samples
the reach, with no word off-sample); a hidden degree of freedom, a
clock, an environment, a source of randomness, is refuted by one later
run and inferred away by none. For example, define a generator with hidden counter n to return the same mapping at n = 0 and n = 1, then a different mapping at n = 2. Agreement of its first two outputs does not establish independence from n. A replay determined by the pinned record has no such undeclared coordinate. If the act does not factor through a representative, there is no representative to recover.

**The court's law: judge on the class.** A later question is answerable
when the available records and established laws give the same answer
on every admissible history. Its answer need not have been stored in
a field bearing that question's name. If compatible histories disagree,
the answer remains open. An explicit assumption can restrict that class,
but a waiver is not evidence that the assumption describes the past.
A certificate evaluated at birth covers later predicates only through
an established sufficiency or transport relation.

**Missing and nonexistent are two different opens.** VI1's second
reading splits the open state by its remedy. Where the act factored
through a representative and recorded it, the distinction is read.
Where an act selected one and the available evidence does not separate
the possible choices, the historical question remains open. A new
assumption alone is not a recovery. Where the actual construction did
not select a representative, a convention selected now is a new event.
The absence of a dedicated record does not decide between these cases.
The act's law and its remaining evidence must establish which applies.
A present convention cannot by itself certify a past selection.

## §5. History: compatibility replays, provenance does not

**Lemma (compatibility frontier).** Given the declaration, call a
revision pair compatible when both carriers exist and the strict game
there is nonempty. Compatibility is decidable per revision (EiF
Theorem 3) and the reachable history is finite (I3), so the earliest
compatible revision, the frontier, is decidable by scan, even when the
declaration was written later. The frontier bounds every on-history
birth from below. Taking the frontier for the birth asserts an
undeclared premise, "the first compatibility is the carry": the
temporal analog of least-drift selection, an observer, never a court.

**Lemma (state history does not identify provenance in general).**
Let π be the map that takes a history of events to the history of
states it leaves, forgetting the acts. π is not injective in general:
two histories with different carry events can leave every recorded
state equal. On any class H of histories containing such a pair, no
left inverse on the image exists: no r : π(H) → H with r ∘ π = id_H,
since r(π(h)) cannot equal h on both members of an identified pair;
such an r exists exactly when the restriction of π to H is injective. A recovery map exists exactly
for classes on which π is injective, and injectivity is restored on
two roads: narrow the class of histories, or let the state record
carry enough distinction to separate every pair of event histories
that π identifies. The requirement is Definition 5's, one level up:
enough recorded distinction for the asked separation, never the whole
event. The kinship is noted and not compressed.
A concrete obstruction needs only two distinct permitted events e₁ and e₂ with the same input and output state. Histories differing solely in this event have the same state projection but different provenance. Recording the event distinction, or excluding one event by premise, removes this particular obstruction.

**Compatibility and provenance can require different distinctions.**
The counterfamily has equal recorded states and different event identities.
Its state projection cannot identify origin. On another family, the same
projection may be injective and sufficient. The question is what the
actual records and admitted history law determine, rather than whether
a dedicated field was named event. A compatibility scan alone supplies
no missing event distinction in the counterfamily.

**VI3 (replay decomposition, conditional).** Given durable carrier
states and a pinned court (histories not rewritten, pinned bytes
reachable, the grammar and the comparison law versioned under the
pin), the following replay from the substrate: the carrier states, the
strict game at any recorded revision, the compatibility frontier. The
following additionally need a distinguishing relation when the available
records admit different answers:

1. an independently chosen relation declaration (subject, J, the two-sided
   reach and grammar reference), if the carrier records do not determine it;
2. the other side's revision, if compatible histories with the same
   available archive permit different revisions (AC5, SG2);
3. the event identity: that, and at which revision, the carry happened
   (the birth pin), when the lemma's indistinguishable histories remain
   admissible despite a compatible revision appearing on both histories;
4. the act's representative choice, where |I₀|>1, a later judgment
   needs it, and the other records do not already determine that choice.

An absent dedicated record is not by itself an impossibility proof.
AC5 supplies the exact criterion: all cases compatible with the
available evidence must agree on the requested answer. A retained
construction can make that criterion true without a second comparison.

Records 3 and 4 are facts of one event and may share one event
witness; the compression is not forced here. Across the four, one law:
**a precondition enters as a record, or as a reading that carries it
verbatim; where obtaining it requires an inference, the inference is a
new premise, and a premise enters as a record.**

## §6. The declared grammar prices the court

Existence Is Finite gives decidability, never tractability, and the
price divides by floor. The birth court decides Iso(X₀, Y₀) under G:
for rooted trees this is polynomial with order semantic and without
it, since exact isomorphism of unordered rooted trees is linear (Aho,
Hopcroft, and Ullman, 1974); for richer grammars the cost is the
grammar's own, and general graph isomorphism carries no known
polynomial bound and no known hardness. The post-drift observer
minimizes d_t(m), and there the order boundary is real: ordered tree
edit distance is polynomial (Zhang and Shasha, 1989), unordered tree
edit distance is NP-complete (Zhang, Statman, and Shasha, 1992).
Declaring order non-semantic therefore leaves the birth court cheap
and prices the archaeology. Σ itself is ordered (PAIR carries a left
and a right), so an encoding that keeps order semantic keeps both
floors polynomial. Decidability delivers no practical court:
tractability is a property of the declared grammar and of the question
asked of it.

## §6a. A finite certificate in the type lattice

The relation court has a small executable boundary: a presented finite class
with one fixed question and one answer on every member. The type-level fragment
below checks that boundary. It neither constructs the correspondence class of
§2 nor proves the completeness of a supplied class. Sections 6b and 6c add
explicit coverage witnesses under two different premises.

Write a reading as `(Σ, E, q, x, a)`: the space, encoding, question, candidate,
and its recorded answer. A domain-specific type constructor supplies the
application `a = q_E(x)`. Merely naming q does not establish that equation.
In the worked instance, `VisibleReading<B>` binds its answer to `EyeImage<B>`.
There is no independent answer argument a caller can substitute.

**VC1 (Same question).** Two readings are comparable here only when Σ, E and q
coincide. Their candidates and answers may differ. `ComparedReadings` checks
the three equalities. Same answer types under different questions do not suffice.

> Argues: ``ComparedReadings`` needs ``Pair``. The two reading addresses are
> the sides whose contexts the equalities compare.

> Argues: ``PredicateReading`` needs ``HasVerdict``. An application carries
> the question and answer axes that its output equation relates.

> Argues: ``PredicateReading`` needs ``Pair``. The candidate and the recorded
> output occupy the two sides of the application.

**VC2 (Binary certificate).** Given comparable readings of x and y with answers
a and b, a certificate for answer v requires `a = v = b`. Its support is
`{x, y}`, with repeated sources counted once. `VerdictIsInvariant` checks the
answer equalities and binds the certificate's context to its readings.
`JoinedVerdict` constructs it under exactly those premises. No equation x = y
is required. An empty class has no reading and no constructor in this grammar.

**VC3 (Singleton).** Repeating one reading gives a certificate on support `{x}`.
The generic `SingletonVerdict<R>` body obtains the answer equality by substituting
R for both branches. This proves the singleton case for a supplied application.
It does not infer functional consistency of unrelated application declarations.
Identification can still be necessary for a particular question: when q
distinguishes every member of K, one exact answer also identifies its member.
The claim is that identification is not a prerequisite for every question.

> Argues: ``VerdictIsInvariant`` needs ``HasVerdict``. The certificate names
> the common question and answer that both recorded applications must share.

**VC4 (Finite composition).** A certified group may be read with its certified
answer and joined to another reading or group of the same question. The support
of the join is the union of its children's supports. This uses the partial lift
of q to nonempty finite groups: q̂(S) = a exactly when every member has answer a.
The group is a certificate node, not another source added to Σ. Induction on a finite
constructor expression proves that every leaf has the root answer: the base
case is VC3 or a supplied reading, and the step uses VC2 and the two child
certificates. Grouping adds no omitted candidate. This is composition of
certificates for *one predicate*, not truth-functional composition of the open
verdicts for different predicates discussed in §3.

**VC5 (Selection).** Retaining either child of a certified pair preserves its
question and answer. `VerdictRetainsLeft` and `VerdictRetainsRight` equate the
retained reading to that actual child. The answer equation then follows through
the child, without another answer premise. A different candidate with the same
answer is not a selection witness. Repeating selection and finite composition
certifies a presented nonempty subtree selection. Arbitrary set inclusion is
not implemented by this fragment.

> Argues: ``VerdictRetainsLeft`` needs ``Pair``. The original certificate and
> its retained child are the two sides of the selection relation.

> Argues: ``VerdictRetainsRight`` needs ``Pair``. The second selection carries
> the original certificate and the member at its other address.

**VC6 (Reordering).** Swapping the two branches preserves the certificate.
`ReversedVerdict<C>` takes C alone, exchanges its readings, and satisfies
`VerdictIsInvariant`. `VerdictReorders` records the relation between the original
and the constructed certificate. Their answer equality follows through the
exchanged branches rather than being assumed separately.

> Argues: ``VerdictReorders`` needs ``Pair``. Reordering relates an original
> certificate to its reversal, with the branch addresses exchanged.

The instance is the metameric pair from Seeing Is Encoding: `RedBeam` and
`RedBeamWithIR` have one visible answer and different infrared answers. The
visible certificate compiles while joining their infrared readings is refused.
Within this two-beam class the infrared answer identifies the source, while
the visible answer leaves it ambiguous.
A third beam with more infrared joins the visible certificate. A dark visible
branch does not. No physical measurement is performed: these are the existing
finite spectral declarations read by a fixed type-level projection.

The repeatable check is `bash Checks/verdict.sh`, also `./check.sh --only verdict`.
It type-checks generic answer-preservation witnesses and the finite examples,
then separately requires refusal of changed answers, questions, encodings,
spaces, selected members, branch order, an empty certificate and a disagreeing
third branch. A rejected join means this constant-answer certificate is absent.
Compiler failure by itself is not a general procedure for distinguishing the
paper's `holds`, `parted` and `open` states.

**Remaining obligations.** A supplied reading must mean the stated application.
The presented class must contain the intended admissible candidates, and the
certificate must belong to the finite constructor grammar. Open Swift protocols
can be given recursive conformances, so their names alone do not establish
well-foundedness. This fragment checks the stated relations and generic
constructions. It makes no new claim that every lattice protocol is saturated.

`Checks/FiniteBoundary.swift` keeps this boundary reproducible. A nonterminal
cycle conforms to the current `StructuresFinite`. Experimental one-level and
two-level floor protocols instead state the descent endpoints, and the compiler
refuses cycles at either side of the one-level boundary. Those bounded claims
are research fixtures, not a proof for arbitrary depth or a replacement for Σ.

## §6b. Coverage needs an independent declaration

**VC7 (Support follows construction).** A leaf records `Leaf(x)`. A join records
`Fork(support(left), support(right))`. A group carries its certificate's support
without adding a source. `CandidateLeafReading`, `VerdictCoversBranches` and
`CandidateGroupReading` check these equations. The finite constructors
`CoveredLeaf`, `CoveredJoin` and `CoveredGroup` supply their witnesses.
Induction on this syntax gives two conclusions together: every recorded leaf
has the root answer, and the recorded tree contains exactly the constructed
leaf occurrences. The second conclusion does not follow from answer agreement.

> Argues: ``HasCandidates`` needs ``HasSigma``. Candidate support is declared
> within a space, which the reading and the certificate must share.

> Argues: ``CandidateReading`` needs ``HasCandidates``. The reading exposes the
> support that a leaf pins or a group inherits.

> Argues: ``CandidateReading`` needs ``PredicateReading``. Coverage accompanies
> an application with a source, question and answer, not a bare candidate label.

> Argues: ``CandidateLeafReading`` needs ``CandidateReading``. A leaf binds the
> support's source address to the application's source address.

> Argues: ``VerdictCoversBranches`` needs ``VerdictIsInvariant``. Coverage must
> accompany a common answer on both branches to certify an exact verdict.

> Argues: ``VerdictCoversBranches`` needs ``HasCandidates``. The root support
> records both child supports at its two addresses.

> Argues: ``CandidateGroupReading`` needs ``CandidateReading``. The grouped
> application exposes the support and answer inherited from its certificate.

**VC8 (Coverage of a declared tree).** Supply a tree D independently of the
certificate C. `CoverageMatchesDeclaration` requires `C.Candidates == D`.
Together with VC7, this certifies every occurrence declared in D. It rejects
an omitted leaf, a replacement by a foreign leaf, and a repeated leaf in place
of another source, even when all their answers coincide.

> Argues: ``CoverageMatchesDeclaration`` needs ``Pair``. The computed
> certificate and the independent declaration occupy the comparison's two sides.

The witness `ThreeBeamsCovered` checks the three-beam declaration against the
constructed certificate. `Checks/Coverage.swift` separately attempts a missing
third beam, a repeated second beam, a false leaf source, an inflated group
support and a union that repeats its left support. Each attempt is refused.

D is an ordered tree of occurrences. The test is intentionally stronger than
extensional set equality: a permutation or regrouping requires a corresponding
declaration or another checked relation. D may itself contain duplicates. The
check does not infer a set cardinality, and it does not prohibit duplicates
that the declaration actually requests. Defining D as `C.Candidates` would
make the comparison automatic and would establish no independent coverage.

M68 reuses this occurrence interpretation for an exhaustion certificate.
The existing selection paths now derive a remainder and a stable address
through `CandidateRemoval`. Removing one occurrence preserves the other
positions, including positions with equal payloads. A complete allocation
can therefore assign distinct port identities from declaration positions
without assuming distinct payload values. This removes pending coverage
obligations, not retained knowledge: the same edge reading can still serve
both endpoint proofs. The final inventory comparison must remain tied to
the independent declaration.

The interpretation applies to finite expressions of the supplied leaf, join
and group constructors. `CandidateReading` is an open interface: a manual
conformance can invent support metadata, and a recursive conformance need not
be such an expression. The protocol name alone does not certify this grammar.
Likewise, matching D does not prove that D accounts for an external domain.
This is a coverage obligation, distinct from C1 in Solvability Criterion, which
asks whether the rule sought is reachable in the declared encoding closure.

## §6c. A question can factor through a lossy encoding

The finite tree is one route to completeness. A generic structural proof is
another: one derivation can cover a family with no fixed bound on its members'
finite sizes. Its premise describes the family instead of enumerating it.

Let K be a candidate domain, E: K → I an encoding, and q: K → A a total
question. The following condition says exactly that E retains the distinctions
needed by q:

    E(x) = E(y) implies q(x) = q(y), for every x, y in K.

Equivalently, `ker(E) ⊆ ker(q)`, where each kernel is the relation of equal
outputs. It is also equivalent to the existence of a function d on E(K) with
`q = d ∘ E`. To construct d, assign each observed image the unique q-answer
shared by its fiber. The condition makes that assignment well-defined. In the
other direction, equal images passed through one function give equal answers.
This is a statement about functions on sets, independent of a finite bound.

**VC9 (Supplied factorization).** `ReadingFactors` records the square for a
source x: an observation E(x), a direct answer q(x), and a decoder answer
d(E(x)). Its equations bind the observation's input to x, its output to the
decoder's input, and both answer paths to one answer. The two applications
share the semantic question and ambient model. Their input representations
differ: one takes the source, the other its image.

> Argues: ``ReadingFactors`` needs ``VerdictIsInvariant``. The direct and
> decoded applications must give the same answer in the same question context.

A concrete square is one witness, not a proof for every source. A generic
constructor checked under the domain's premises certifies its applications
throughout that declared family. One decoder for the whole family additionally
requires that its answer depend only on the observed input and retained context.
`AlphaFactors<B: BeamShape>` supplies this through `ImageAlphaReading<EyeImage<B>>`:
its decoder takes the image alone, and reads its left coordinate. That coordinate
equals B's alpha coordinate by expansion. No equality of those answers is
requested from the caller. VC21's source-selected counterexample shows why
generic pointwise success without this decoder condition is insufficient.
`Observation` need not ask q: its question reads the image used to answer q.
The application constructors, rather than a shared question label alone,
establish the intended operations and their input domains.

`AnswerWithItsEvidence` retains both the answer and the actual observation
through that same square. This does not extend the set of source questions
recoverable from the observation. M71's `FirstAnswerAndEvidenceOmitSecond`
constructs equal answer-and-evidence pairs from arbitrary second fields,
while `FirstAnswerRecordRetainsSecond` recovers those fields from an actual
source-retaining record. A new question can require refining the image
without invalidating the original question's factorization.

**VC10 (Shared decoder).** If two factorizations share their actual decoder
reading, their direct answers agree. `SharedDecoder` equates that intermediate
reading. `AnswersThroughSharedDecoder` then constructs `VerdictIsInvariant`
without an additional answer-equality premise. `SharedVisibleImage` supplies
the shared reading from equal images through the single constructor
`ImageAlphaReading`. Two arbitrary records with the same input and predicate
labels are not enough: the lattice has no unrestricted functionality axiom
for independently declared records.

> Argues: ``SharedDecoder`` needs ``Pair``. The two factorizations have an
> intermediate reading whose equality relates their direct answers.

**VC11 (A family without enumeration).** `RedFamilyVerdict<L, R>` derives equal
visible readings for any two `RedVisibleBeam` conformers. Only the alpha and
beta coordinates are fixed. `RedWithHidden<H>` leaves the infrared coordinate
free, so the proof applies to every finite successor depth and imposes no
common depth bound. It does not require all `IntegerValued` conformances to
be finite. The visible projection does not inspect that coordinate at all.
The finite artifact here is the generic derivation, not a list of every source.

The three coverage claims have different premises. VC8 covers an independently
declared finite tree. VC11 covers every conformer satisfying a stated generic
constraint. Neither establishes that the declaration captures every physical
possibility. The optical declarations are a mathematical model, and agreement
inside that model does not supply measurement evidence for its adequacy.

This boundary has an established counterpart in database theory: a view can
determine a query's answer without supplying a rewrite in a chosen language.
Nash, Segoufin and Vianu distinguish semantic determinacy from such rewritings
in [Views and Queries: Determinacy and Rewriting](https://dbucsd.github.io/paperpdfs/2010_3.pdf)
(2010). Thus the kernel criterion alone does not provide a computable or
language-definable decoder in an arbitrary setting. The supplied Swift
constructor is an explicit witness for this particular fragment. No new
priority is claimed for the factorization theorem.

For the identity question `q(x) = x`, the kernel criterion requires E to be
injective. Identification is therefore the limiting case that retains every
source distinction. A less discriminating question can require less. Seeing
Is Encoding and Colour Is a Quotient supply the loss, while Verdict Is Invariant
states when that loss is harmless for the question actually asked.

**A complete reading also determines its relation to the source.** Suppose E:K→I has a supplied decoder d:E(K)→K with d(E(x))=x. Restrict the recorded source-image pair to its actual graph G={(x,E(x)):x∈K}. Reading its image by p(x,E(x))=E(x) has the inverse j(i)=(d(i),i). Indeed p(j(i))=i, and j(p(x,E(x)))=(x,E(x)). Consequently any specified total question H on G factors as H=(H∘j)∘p. The same image suffices to answer a question about this source-image relation. No second acquisition or extra source is required by that factorization. This uses the actual graph and the given recovery law, rather than accepting every pair with the same record shape.

The smallest nonconstant instance has G={(0,0),(1,1)}. Either coordinate determines the pair, including the fact that the two readings agree. On the enlarged domain {0,1}² the same coordinate fails: (0,0) and (1,0) have the same second reading and different first readings. Agreement and source recovery must therefore come from the admitted relation. Repeating an unsupported assertion does not create them, as VC23's ZeroInputClaimTail demonstrates. Self-inclusion of the question alone does not force an infinite sequence of new readings. An implemented decoder and its acquisition remain distinct obligations, and this argument classifies recovery rather than feeling or universal self-verification.

AnswerWithItsEvidence<F> supplies a more general static construction: any established factorization q=d∘E also determines (q(x),E(x)) through the same E. It joins F's actual decoder to an identity reading of the evidence by the existing JointEvidenceFromMemory and QuestionOnObservation. Checks/ClosedInformation.swift derives both the unchanged observation and the paired answer for every admitted F. The identity-question instance recovers the source-image graph. The existing repeated-evidence recovery cycle separately supplies the diagonal return. No additional source-reading premise, final-answer equality or consciousness marker enters these constructions.

The source scope is unchanged. If performing a further reading changes the represented whole, a question about that new occurrence must include its transition or acquired evidence. VC12 does not infer such a question from an old factorization alone. Similarly, H must be a specified total question on G: a demand for a Boolean answer equal to its own negation has no such reading. Source recovery supplies neither a universal truth predicate nor an automatic certificate of every future state. These limits concern the proposed questions, without requiring an exterior observer.

**Exact source recovery does not make the record a duplicate performer.** Let K={a,b} and I={m_a,m_b} be disjoint addressed carriers, with E(a)=m_a, E(b)=m_b and d their inverse. Then dE=id_K. Every specified source question q can be read as q∘d from the image. That equation concerns the source after decoding. It does not assert that the record has the source's properties when assessed in its own role, or that m_a is the occurrence a.

The distinction has a finite dynamic test. Let the source step U exchange a and b while the image step V is identity. Recovery of the recorded source remains exact, but E(U(a))=m_b differs from V(E(a))=m_a. The same code can answer the specified question U about its recorded source through U∘d, although the record's own evolution does not perform that step. Tracking the changing source through that same encoding would additionally require EU=VE. This example does not satisfy that stronger contract. It separates recovery, prediction of a specified step and a dynamically matching realization, without an appeal to a physical copying law. A question about whether source and record are jointly experienced requires its actual occurrence relation. The decoding equation supplies no such identification.

`PassiveCompleteRecord<A,B>` in the existing whole checks constructs this separation from RetainedWhole, projection, swap and identity readings. Its generic equality derives complete source recovery and the swapped answer from the record alone. The zero/one source gives different first fields in the unchanged record and the record required after the source swap. A positive zero/successor boundary exposes that difference, and the attempted transport equality is rejected. These are static relations of actual constructor fields, without a runtime model or a new public proof marker.

**Even exact tracking does not identify which relation drives the working answer.**
The passive-record example fails EU=VE. A stronger ambiguity remains
when the record tracks every normal update correctly, including all
the available retained history. Let x=(a,b) be a working pair, m another
pair, and h an internal remainder. Let s exchange the two pair roles,
so s²=id. Consider two proposed contacts on this same addressed
state interface:

    D(x,m,h) = (s(x),s(x),(m,h)),
    F(x,m,h) = (s(m),s(m),(x,h)).

Both contacts are injective on this represented family. From an output
(y,y,(r,h)), D's inverse recovers (s(y),r,h), and F's inverse recovers
(r,s(y),h). The unused input for the *working-answer* calculation is
retained in the actual remainder. It is not deleted from the whole
or causally irrelevant to every output reading.

The two laws can also be sectors of one internally controlled
contact: retain a mode k∈{D,F} and apply (k,x,m,h)↦(k,k(x,m,h)),
where k selects its displayed formula. Equality of complete outputs
first fixes k and then the corresponding inverse fixes all remaining
inputs, so this one contact is injective. The observation in the
following experiment exposes the three state fields, not the mode.
Its inverse can use the retained mode; the experimenter does not get
that access for free. No external law selector is required.

On the faithfully tracking family m=x, the two contacts give exactly
the same interface result (s(x),s(x),(x,h)). That result again belongs
to the tracking family. Induction therefore gives the same sequence
of working pairs, current records and remainders for every finite
normal continuation from the same preparation. Reading any of those
fields during such a continuation cannot distinguish the two laws.
This is an equality on the stated interface, not identity of hidden
implementations or of every physical form in reality. There is no
claim that an unavailable inspection of the implementation also agrees.

The same induction permits arbitrary shared interventions that map
the tracking family into itself and have the same addressed action
in both candidates. No such intervention reveals the off-family
dependency. If that tracking family is the entire admitted state
domain and all available contacts remain in it, D and F are literally
the same restricted operation. Their different formulas on excluded
pairs do not supply an additional operational distinction there.
The broader two-law inquiry is justified only when its enlarged
domain or a distinguishing contact is part of the admitted scope.
Failure to have acquired such a contact is not a proof that none
exists anywhere in the whole.

Nevertheless the working answer of D depends on x, and that of F on m.
An actual internal perturbation can distinguish the roles. Supply
J(x,m,h)=(x,s(m),h). It is its own inverse and changes only the second
pair. Also retain the initial working pair x in a reference field of
the preparation, by taking the old remainder as (x,h₀). This reference
is inside the same represented carrier and is not an absolute naming
scheme. Starting with m=x, the next working outputs after J are

    D: s(x),     F: x.

The original reference remains at the same retained path in both
outputs. Comparing the result with that actual reference distinguishes
return from crossing whenever a≠b. The same test fails when a=b;
then J has changed no relevant distinction. The reference preparation,
perturbing contact and comparison access are the supplied resources.
The code does not acquire them by naming an observer.

Thus no number of normal tracking observations identifies the acting
dependency within this two-law family, whereas one use of the unknown
contact after this perturbation does. This is not a one-probe theorem
for all unknown mechanisms. Adding other candidate laws or refusing J
changes the inquiry. A deterministic procedure based only on the equal
normal transcripts has the same input in both cases and cannot produce
different correct law identifications; the perturbation supplies the
missing distinction through the existing continuation criterion.

The result is relational also in its choice of roles. Exchanging x
and m conjugates D to F and exchanges perturbing the record with
perturbing the working pair. A written label “self-model” does not
break that symmetry. In the proposed test the actual changed role,
retained reference and subsequent working reading are held together.
A common renaming of those roles preserves return versus crossing.
It is their relation, rather than an intrinsically privileged register,
that makes the question determinate.

Nor can preservation alone define a useful binary property “uses the
record.” For any injective full contact U, two different inputs have
different full outputs. Hence every input contrast in its admitted
scope remains a contrast somewhere in the full result. D preserves
m in its remainder even though its next working pair does not depend
on m. F makes that working pair depend on m and preserves x elsewhere.
To ask which distinction controls an action, specify the input changes
and output reading. Whole-source recoverability is compatible with
both dependencies. Conversely, removing an explicit duplicate field
from a description does not by itself remove its recovered reading
or a physically situated participant.

`SelfRecordUse` constructs these contacts from the existing pair swap,
actual projections and retained fields. `FaithfulSelfRecordStep` derives
same-result equality without assuming it as a conclusion. The same
returned tracking relation supplies the induction above.
`RestoreWorkingDriven` and `RestoreRecordDriven` read only their actual
output, not an original-source parameter supplied again by the checker.
`SelfRecordProbe` composes the real perturbation with both candidate
contacts and reads the retained preparation reference. Seven positive
declarations check tracking, another iteration, both full input
recoveries, perturbation reversal, the distinguishing reference
relations and the degenerate non-distinguishing preparation. Refusals
reject carrying normal agreement through the perturbation and applying
the unperturbed advance to its changed source. They are source and
answer relations, not labels for causal power or consciousness.

This makes one part of The Cut's question independently testable:
does a purported self-record only agree with the working process,
or does the declared working continuation depend on it under the
specified internal changes? Agreement, tracking and operative use
are different obligations. Neither D nor F has been assigned an
absence or presence of experience. An identification between an
experienced occurrence and one such organization would need the
correspondence that the operational comparison does not supply.

**Transport needs the orbit of the question, not automatically a whole frame.**
The probe above is meaningful only when its contact is actually available.
M25, VC30–VC31 and LQ14–LQ15 already distinguish that obligation from
mere compatibility of a proposed operation. An independent intervention
suggests a more specific question: what must an internal movement record
retain for the *next* target to remain readable?

[Sommer and Wurtz (2002)](https://www.yorku.ca/jdc/documents/SommerWurtz2002_Science_April11_2013.pdf)
recorded an ascending pathway and reversibly inactivated its thalamic relay
while macaques made two saccades to previously flashed targets in darkness.
Second endpoints shifted in the predicted direction in 18 of 22 cases;
first movements and single-saccade controls showed much smaller effects.
These are measured statistical comparisons, not exact preservation equations.
The methods explicitly leave possible effects on adjacent neurons open.
The authors study correlates of commands, not necessarily exact copies,
and leave the pathway's contribution to stable perception for further work.
The experiment therefore supplies a real intervention and selective behavioral
evidence; it does not establish the ideal record-only probe, a complete
movement decoder, or a condition for experience used in this paper.

Here is an exact, separate relational problem. Let a group G act on a
set X, and let g map positions in one internal frame to positions in
another retained frame. For a specified target t in the latter, the
required position in the former is

    q_t(g) = g⁻¹t.

The represented source family is all g∈G; the action and the target are
supplied relations. A command record is sufficient precisely when q_t
is constant on each of its source fibers. Knowing the command that
preceded a movement does not by itself supply the actual g: possible
differences between the command and its effect must preserve this
particular answer or be resolved by other evidence.

Write H={h∈G:ht=t}. Directly,

    q_t(g)=q_t(v)  iff  v g⁻¹∈H  iff  v∈H g.

Thus the current answer identifies the set H g, not necessarily g.
No smaller uncertainty about the complete action is required for this
one target. Conversely, if H is trivial, this one target already
identifies g. A task-relative formulation does not guarantee that the
task is cheaper than complete identification.

Now supply a known contact k. Two actual composition contracts differ:

    g ↦ g k:   q_t(g k)=k⁻¹q_t(g);
    g ↦ k g:   q_t(k g)=g⁻¹(k⁻¹t).

The first always updates the current answer from itself and k. The second
may require the former position of a different target. Its answer factors
through q_t on all G if and only if every h∈H fixes k⁻¹t, equivalently

    H ⊆ k⁻¹ H k.

Indeed two sources in one current fiber have the form g and h g.
Their answers after left multiplication agree exactly when
h⁻¹k⁻¹t=k⁻¹t. Varying h over H proves both necessity and sufficiency.
If both k and k⁻¹ must descend to the current answer, the condition is
equality k⁻¹Hk=H. Equality must not replace inclusion for an arbitrary
single forward contact on an infinite group.

A four-position witness uses G=S₄ acting on {a,b,c,d}. Take g=id,
v=(b c), and k=(a b). Both current answers to t=a are a. After left
multiplication by k they are b and c. After right multiplication by k
both are b. Every operation is a permutation of the same finite carrier;
no information has been lost globally. The old answer omits a
relation needed by one permitted continuation.

**The least reusable refinement is determined by available contacts.**
Let K≤G be the subgroup generated by the actually admitted reversible
left contacts, including their inverses. Keep the target orbit O=K t
and the addressed profile

    R_O(g) = (g⁻¹z) indexed by z∈O.

It recovers q_t and has an explicit update for every k∈K:

    R_O(k g)[z] = R_O(g)[k⁻¹z].

Since k⁻¹z belongs to O, the update receives only the retained profile and
the known contact. The complete g does not enter its decoder.

This profile is the coarsest sufficient refinement in the information
order. Suppose E permits q_t after every finite admitted contact word.
Then for every k∈K it determines q_t(k g)=g⁻¹(k⁻¹t). These questions
range over every z∈O. Hence E(g)=E(v) implies R_O(g)=R_O(v).
Conversely the displayed update and the coordinate t answer every
such continuation. This proves minimality without enumerating states
or assigning the desired conclusion as a protocol constraint. An
arbitrary infinite profile is a semantic object; the statement does
not promise a finite representation or an effective universal decoder.
For a finite addressed orbit it is a finite tuple with these updates.

For K generated only by (a b), the required profile is the pair
(g⁻¹a,g⁻¹b). It exchanges its two actual fields on each contact, and
is still unable to distinguish id from (c d). Thus it is reusable for
the admitted target orbit while the complete movement remains unknown.
If the accessible orbit is all X, the profile determines the whole
permutation action. For a faithful action that determines g itself;
otherwise differences in the action's kernel remain indistinguishable.
The amount of information forced by reuse therefore depends on the
contact family, not only on the current question.

These are relative frames inside the represented system. Under a joint
renaming g′=a g b⁻¹ and t′=a t, the answer becomes q′=b q. Left contact
k becomes a k a⁻¹; right contact k becomes b k b⁻¹. The distinction
between the two interfaces survives that common change of coordinates.
Writing k g=g(g⁻¹k g) does not make the left interface free to use the
right-interface decoder: its new command g⁻¹k g may contain the very
unknown action that the record did not determine. The four-position
witness rules out that shortcut using the current answer alone.

The difference between a harmless frame choice and missing contact
information can itself be stated without an external reference. On
G×X, the diagonal change (g,t)↦(a g,a t) leaves g⁻¹t unchanged.
Conversely if g⁻¹t=v⁻¹s, the choice a=v g⁻¹ satisfies (v,s)=(a g,a t).
Thus this relative target is a complete invariant of that diagonal
frame freedom. But when a subsequent left contact k is part of the
question, it too must change to a k a⁻¹. Keeping k unchanged while
changing only (g,t) need not preserve the joint situation. On the full
triple the relative command is u=g⁻¹k g, and the next target is
u⁻¹q_t(g). This identifies exactly where the omitted relation enters.
It does not require acquiring all of u when the target-orbit profile
already suffices for the declared family. Nor does it turn the
whole's lack of an external position into an inability to distinguish
internal movements.

The intervention above does not demonstrate this particular group
model or its noncommutative obstruction. In an abelian group the two
products coincide. What it motivates independently is keeping the
movement, its record, the remembered target and the next contact as
separate linked relations. To transfer these exact conclusions to an
experiment, those action and reading relations need their own evidence.
A signal correlated with a command does not establish them by name.

`TargetFrameTransport` is the finite constructor witness. A record
(A,(B,R)) holds two addressed target preimages and other fields. The
source contact gives (B,(A,R)); the observation retains (A,B); its
decoder exchanges the actual retained fields. `TargetFrameTransport<S>`
derives equality of the entire observed source result and the updated
memory without requiring that equality from the caller. Another
composition reads the next target from the updated memory alone.
The other fields remain unknown to that decoder. The source constructor
also retains them and has an explicit reverse.

Five positive declarations check the commuting pair, subsequent target,
source reversal, independence from omitted fields, and equal current
answers in the separating example. Two refusals reject the asserted
next-answer equality and a decoder fed a pair from a different source.
These checks establish the finite field relations. The general orbit
minimality is the proof above, an instance of the existing continuation
criterion, rather than a new unverified marker for physical remapping.

A finite proof basis and a finite atom basis are different objects. VC11 does
not generate every hidden source from a finite family of domain operations.
It proves a question independent of that coordinate. VC9 is less degenerate:
its answer varies with the visible alpha level, yet one generic derivation
covers them all. A saturation experiment must declare its questions in advance,
otherwise a constant question could make any domain appear complete.
Reusing a derivation also does not make application free: constructing an
instance and checking its constraints still have a cost. This section does
not infer zero marginal execution cost from finite proof size.

## §6d. Today's invariant need not survive an operation

**VC12 (Boundary under change).** The condition `ker(E) ⊆ ker(q)` answers q
on the current source. To answer after an operation T: K → K, the required
condition is `ker(E) ⊆ ker(q ∘ T)`. The first condition does not imply the
second. An operation may expose exactly the coordinate E discarded.

`ExposeHidden<B>` is a symbolic coordinate transformation: its alpha output
is B's infrared coordinate. It is not a physical conversion law. `RedBeam`
and `RedBeamWithIR` have equal current visible images, while their transformed
visible images differ. The attempted invariant certificate for those outputs
is refused in `Checks/Coverage.swift`. Equality of current observations does
not justify reuse of a verdict across an arbitrary operation.

One sufficient condition for safe propagation is a supplied operation on
images, T̄, such that `E ∘ T = T̄ ∘ E`. If also `q = d ∘ E`, then
`q ∘ T = d ∘ T̄ ∘ E`, so the original image suffices for the later answer.
For a family of such operations, composition proves the same result for
every finite sequence. Closure of an operation vocabulary under composition
alone is insufficient: the commuting equations are the additional obligation.
The positive witness is `SwapFactors<B>`: swapping a beam's visible coordinates
and then observing gives the same image as swapping the already observed pair.
It uses `ReadingFactors` for the future question without adding a new protocol.
`SharedSwappedImage` and `AnswersThroughSharedDecoder` derive agreement after
this operation from agreement of the current images. Both transformations here
are symbolic coordinate models. The general finite-composition argument is
mathematical here. Section 6e supplies the generic finite-path certificate.

This suggests a sharper research target for saturation. Fix a question family
Q and an operation vocabulary O. Form all future questions `q ∘ w`, where
q belongs to Q and w is any finite operation sequence, including the empty
sequence. Declare two sources equivalent exactly when every such question
agrees. That relation is preserved by each operation in O: prefixing one more
operation still gives a permitted finite sequence. Adding questions or
operations can split its equivalence classes, so the vocabulary and its
revision are part of the claim.

A finite basis of proofs can certify sufficient observations for some
such closures without identifying every source. VC44 supplies one generic
coordinate instance. Existence of such a basis in every case remains unproved
and does not follow from finite syntax.
It connects the paper's invariant verdict to Basis Is Residue through
an explicit obligation: preserve what the permitted future questions can read.
A declaration that erases a distinction today must account for operations
that could reveal it tomorrow.

For finite deterministic machines and an acceptance question, equivalence
under every future input sequence is the familiar state equivalence used in
DFA minimization, described in the [Cornell CS 4120 notes](https://www.cs.cornell.edu/courses/cs4120/2026sp/notes/leximpl/#dfa-minimization).
The comparison locates this proposal within an existing construction. It does
not assert a new automata-minimization theorem or infer finiteness of K.

Even a finite question and operation vocabulary can require infinitely many
behavioral classes. Let K be the natural numbers, let the one operation be
predecessor with zero fixed, and let the one question ask whether the state
is zero. For m < n, applying predecessor m times gives different answers:
m reaches zero and n does not. Every two distinct states are distinguishable
by some finite sequence. Thus neither a finite signature nor a finite current
answer set guarantees a finite quotient under all future observations. A finite
proof description, a finite set of observable classes, and a finite generation
basis must be measured separately.

## §6e. A finite proof for every constructed action path

**VC13 (One commuting step).** An `ObservedTransition` declares an operation
between two applications of the same observation in one space and encoding.
Write those applications as `x → E(x)` and `y → E(y)`. A
`CommutingTransition` additionally supplies two applications of its operation:
`x → y` on sources and `E(x) → E(y)` on images. Four endpoint equations bind
these applications to the observation records. The operation labels and
ambient contexts must agree too. Thus the observed result can be calculated
along either side of the square.

> Argues: ``ObservedTransition`` needs ``Pair``. Its sides are the before and
> after observation records whose contexts must agree.

> Argues: ``ObservedTransition`` needs ``HasEncoding``. Both observations and
> the operation applications are situated in the declared space and encoding.

> Argues: ``CommutingTransition`` needs ``ObservedTransition``. The source and
> image steps must connect the actual endpoints of that observed transition.

The equations certify supplied applications. They do not turn every record
bearing an operation name into a correctly implemented function. In the worked
constructors, the source and image functions are explicit type expressions.
`SwapTransition<B>` exchanges alpha and beta along both paths.
`ForgetTransition<B>` erases the hidden coordinate on the source path and
uses the identity on the image path. These are symbolic transformations of
the coordinate model, with no new optical or physical erasure law asserted.

**VC14 (Composition without another output premise).** Let F and G be commuting
steps with `F.Right == G.Left`: the same intermediate observation record,
including its actual source. `JoinedTransition<F, G>` composes their source
applications and their image applications using `SequentialReading`. The
compiler derives the intermediate input/output equalities on both paths from
the shared observation. It also derives the final square from the two inner
squares. The constructor does not request that final equality from its caller.

The composed operation is the ordered expression
`OperationSequence<F.Operation, G.Operation>`. This theorem does not say that
F and G commute with each other. It says each source execution agrees with its
image execution. An `IdentityTransition<R>` supplies the empty path for any
observation R. Induction on finite constructor expressions now gives a
certificate for every well-typed finite path made of certified steps.
`AppendSwap<P, B>` names `JoinedTransition<P, SwapTransition<B>>` under its
matching-endpoint premise. It is that composition, with no separate wrapper
type and no enumeration of P's length or structure. Parenthesizations and inserted identity
steps remain distinct type expressions. These proofs establish endpoint laws,
not a normalization that equates every nominal spelling of a path.

Agreement of intermediate images alone is insufficient for this particular
constructor. A step that ends at x and one that begins at a distinct y do not
form an actual source execution, even if E(x) = E(y). `STEP_MIDDLE` probes that
boundary. A path in a quotient could use representatives differently, but that
requires its own well-defined quotient construction, as in VC15. This constructor
must not silently substitute a representative and invent a source history.

The worked path swaps, erases the hidden coordinate, then swaps again.
`RoundTripImageFollows<B>` derives the original visible image for every B.
`STEP_INVERSE` separately refuses equality of the original and final infrared
coordinates for a beam with infrared. An observed round trip is not an inverse
on the source. Erasing the current representation also does not refute the
book's commitment to a permanent historical record: these are different objects.

The repeatable compiler audit adds isolated mutations of both source endpoints,
both image endpoints, the operation, the context, the observation question,
the intermediate source, and the proposed inverse. A proposed image-only
implementation of hidden exposure fails too. The metameric counterexample in
§6d supplies the mathematical reason no deterministic decoder of that image
can implement exposure on the whole class, beyond this one failed proposal.
As before, induction concerns the finite constructor grammar. Open protocol
conformance alone does not prove a path finite or its declared applications true.

## §6f. Objects determined by possible actions

Here the stronger interpretation is made precise enough to be refused. Fix a
carrier K, a family Q of total observations, and a family O of total operations
K → K. The carrier is a premise. Nothing below derives its physical existence.
For finite words w over O, including the empty word, define

    x ≈ y exactly when q(w(x)) = q(w(y)) for every q in Q and every w.

**VC15 (The coarsest compatible object relation).** This is the greatest
equivalence relation that preserves every observation in Q and is preserved
by every operation in O.

*Proof.* Each future observation supplies a kernel equivalence, so their
intersection is an equivalence. The empty word ensures current observations
agree. If x ≈ y, then T(x) ≈ T(y) for every T in O: putting T before any finite
continuation still gives an allowed word. Conversely, let R preserve Q and
be preserved by O. Induction on words gives `x R y ⇒ w(x) R w(y)`, and
preservation of Q then gives every required answer equality. Hence R ⊆ ≈.

The quotient K/≈ therefore carries well-defined operations `[x] → [T(x)]`
and observations `[x] → q(x)`. Call its classes the operational objects for
this declaration. A representation E that answers every permitted future
question must satisfy `ker(E) ⊆ ≈`. It consequently maps onto the operational
objects by `E(x) → [x]`. This is a precise sense in which the quotient is the
least information sufficient for those questions. The quotient may be infinite,
and its definition alone supplies no finite or computable presentation.

**Corollary (two complete reduced descriptions have one source-bound correspondence).** Keep the source K, questions Q and operations O of VC15 fixed. Let E:K→I and F:K→J be two descriptions, restricted to their actual images. Require each to answer every q after every finite allowed word. Require also that any two distinct image values differ on at least one such answer: the description carries no further distinction invisible to this entire family. These are sufficiency and separation requirements, not a demand that the two notations already agree.

Then there is exactly one bijection h:I→J satisfying h(E(x))=F(x) for every source x. Indeed, sufficiency gives E(x)=E(y) ⇒ x≈y. Separation gives the converse: if x≈y, no permitted answer can separate their images, so the images agree. The same argument holds for F. Thus both kernels are exactly ≈. Define h(E(x))=F(x). Equal E-images have equal F-images, so this is well-defined; reversing the roles gives its inverse. Every image comes from a source, so the displayed equation leaves no second correspondence available.

The correspondence also preserves each question and conjugates the induced operations: h(T_I(i))=T_J(h(i)). Take i=E(x); both sides equal F(T(x)). Consequently, two complete reduced descriptions of this declared behavior cannot disagree about a continuation while still meeting the requirements. They describe one object up to the unique correspondence tied to their common source. The proof uses no minimum cardinality: equal-sized infinite images can still differ by redundant distinctions. Nor does it identify two nominal expressions or their physical carriers.

Three attempted stronger conclusions fail. Without separation, F can retain an additional source distinction that E omits, even though both answer every permitted question. Without the source bindings, the surviving object can have automorphisms, leaving several abstract correspondences as in VI1. With only current answers preserved, a continuation can expose an omitted distinction as in VC12 and VC16. For partial operations, refusals must also be retained; VC46–VC47 provide the domain obligation. One cannot apply the total-operation argument to successful partial outputs alone.

This is a consequence of VC15, not a further selection law for reality. Applied to The Cut's Step 3, it explains precisely how two proposed descriptions can collapse to one relational account. The family of actual internal distinctions and continuations must be justified before claiming completeness for the whole. Q names the distinctions being registered; it does not supply an observer outside K's containing reality. Agreement within a restricted family does not erase distinctions carried elsewhere in that whole.

This construction belongs to established behavioral semantics. Rutten's
[Universal Coalgebra: A Theory of Systems](https://ir.cwi.nl/pub/48/) (2000)
develops systems, behavior-preserving maps and bisimulation as a counterpart to
algebraic construction. Here the argument is restricted to deterministic total
operations and observations. No equivalence with a chosen notion of bisimulation
for nondeterministic, probabilistic or concurrent systems is inferred. The VI construction supplies the certificate path for these stated operations.

**VC16 (An added capability can split an object).** If Q or O is enlarged while
K is fixed, the new equivalence is contained in the old one. Every old test
remains a permitted test. Thus the new quotient maps onto the old quotient,
while a map in the reverse direction need not be determined.

In the binary-coordinate beam model, K has eight triples `(alpha, beta, hidden)`.
Let Q read the visible pair, and let O contain swap and hidden erasure. Equal
visible pairs remain equal after either operation, and differing visible pairs
are separated by the empty word. The operational objects are exactly the four
visible pairs. Add hidden exposure to O. A current observation reads alpha and
beta, while an observation after exposure reads hidden. Every distinct triple
is now separated, so the quotient has eight classes. The source carrier did
not change. The permitted distinctions did.

The radical reading is that a system's object vocabulary depends on its possible
actions, including future experiments. This is an interpretation of the quotient
construction, not a proof that physical entities are created by granting a
permission. The Cut's quantifier over anything any process could register is
stronger than a particular system's currently declared capabilities. A bounded
VI declaration must name that boundary instead of silently claiming the global
quantifier. Existing certificates continue to certify their original vocabulary.
They do not acquire the new action without another witness.

**VC17 (Unrestricted action forces identification).** Let K be finite and let
Q contain a nonconstant observation q. If O contains every total map K → K,
then ≈ is equality. Thus any representation sufficient for all such future
observations must be injective.

*Proof.* Choose u and v with q(u) ≠ q(v). For any distinct x and y, one of the
allowed operations sends x to u and y to v, with arbitrary outputs elsewhere.
The observation after that operation distinguishes x and y. This works for
every pair. Conversely, an injective representation determines the source and
therefore every future answer, at the level of functions on this finite set.

The nonconstant-observation premise matters. If every q is constant on K,
all sources remain equivalent even under every operation. Also, all maps is
a substantial capability assumption, not a consequence of finite syntax.
The theorem recovers identification as the price of an unrestricted future
vocabulary. Useful compression is possible when the permitted distinctions
have a boundary. It does not establish that the physical universe permits
all maps, or that constructing and executing their representations is cheap.
For a closed whole, controls are internal states. This quantification over
a family of operations is not an external agent choosing the laws of Ω.
A non-injective operation here can describe a subsystem. Its realization
under global preservation requires an internal residual (PiR M29–M35).

**VC18 (More information need not preserve execution closure).** Two properties
must be distinguished. A representation can determine every answer to the
chosen future questions. It can also support its own next representation via
an image operation satisfying `E ∘ T = T̄ ∘ E`. The latter asks more: all the
coordinates of E must be updatable from E. Adding information preserves the
first property, but can destroy the second.

For a direct coordinate counterexample, take `T(a, b, h) = (a, h, h)`.
The representation E1(a, b, h) = a executes by the identity: alpha never changes.
The richer E2(a, b, h) = (a, b) does not execute by itself. Two equal current
visible pairs with different h have different next visible pairs. The complete
triple E3 executes again. `AlphaSurvivesExposure<B>` proves preservation of the
small observation generically, while `STEP_RICHER_IMAGE` refuses agreement of
the larger output for the metameric pair. Its old alpha answer is still exact.

The following four-state counterexample separates record refinement from dynamic closure:

| source | smaller record | richer record | next source |
|---|---|---|---|
| 00 | 0 | 0 | 00 |
| 01 | 0 | 1 | 01 |
| 10 | 1 | 2 | 00 |
| 11 | 1 | 2 | 01 |

The smaller record always transitions to 0. The richer record 2 would need to
transition both to 0 and to 1. It still contains the smaller record, so every
old future answer remains available. An extra coordinate can create a new
obligation without supplying what is needed to discharge it. This is a concrete
reason to evaluate saturation by closed questions and operations, rather than
by the count of recorded features or claims alone.

**VC19 (Operational identity can exceed symmetry).** In the eight-beam model
with visible observation, swap and hidden erasure, the two hidden values within
one visible pair are operationally equivalent. They need not be related by an
automorphism of the labeled source system. Erasure fixes the source whose
hidden coordinate is zero and does not fix the one whose hidden coordinate is
one. An automorphism commuting with erasure must preserve that fixed-point
property, so it cannot exchange these two sources. In fact, preserving the
visible labels and erasure forces every source to be fixed, and the only
such automorphism is identity.

Thus a quotient by behavior can identify more sources than the symmetry orbits
of the underlying transition system. VI1 remains scoped to admissible exact
birth isomorphisms, which form its torsor. Those isomorphisms are a different
candidate class from the sources here. Extending the word symmetry to every
operational ambiguity would lose the distinction demonstrated by this model.

**Type representation.** The generic step-square constructors and their finite compositions express the commuting relations. Constructing the coarsest quotient for an arbitrary operation family requires an additional constructor. The maximality argument above is mathematical and independent of a finite enumeration.

## §6g. Reversibility, memory and a common whole

The starting point is PiR M29–M35: Ω includes every physical participant, and
local loss must be distinguished from whole-state loss. The question now is
which reduced descriptions can function as states of their own.

**VC20 (An exact finite autonomous image is reversible).** Let T be a
bijection on K and E map K onto a finite image Y. Suppose one map U on Y
satisfies `E(T(x)) = U(E(x))` for every x in K. Then U is a bijection.

*Proof.* For any y in Y choose x with E(x)=y. Since T is onto, some z has
T(z)=x. Thus `y = E(T(z)) = U(E(z))`, so U is onto Y. A surjection of a
finite set to itself is a bijection. In fact surjectivity of T suffices.
Transporting any distribution on Y by U only permutes its probabilities, so
its Shannon entropy is unchanged.

This connects the transition square in VC13 to the entropy distinction in
M32. Seeing fewer coordinates does not itself create irreversible autonomous
dynamics. For a finite image, an exact deterministic many-to-one local law
requires failure of at least one premise above: the complete dynamics may
not be onto, the local law may use hidden state, or the claimed equation may
apply only approximately or on a restricted domain. Explicit time dependence
also changes the fixed-E, fixed-U question. This is a condition on exact
finite descriptions, not a denial of thermodynamic irreversibility.

**VC20a (A target predecessor passes every conserved reading).** Let T be a
bijection on a declared domain K, let x be an admitted start, and let G⊆K be
the target set. Suppose the actual predecessor y=T⁻¹x belongs to G. For
every reading C:K→V satisfying C(Tz)=C(z) on K,

    C(y) = C(Ty) = C(x).

The same equality is true for any collection of such readings jointly. Thus their
conserved values alone cannot exclude G: their common level through x
already contains an actual target. This statement applies to every globally
conserved reading, including one not yet found. It does not infer a forward
hit from a backward one. Existence of T⁻¹ does not make that inverse an
admitted or executable act.

The domain is part of the claim. A condition B with only the forward
implication `B(z) ⇒ B(Tz)` need not be a conserved reading on K. Such a
condition can still separate a forward orbit from its target. Likewise, an
invariant defined only on a restricted component has different premises:
using it requires a proof that the actual forward orbit remains in that component and a
check of how that component meets G. None of these restrictions can
silently replace the full-domain premise above.

**VC20b (A finite exact image of a predecessor target gives a bounded forward
hit).** Retain K,T,x,G,y from VC20a. Suppose E maps K onto a finite Y, one
map U satisfies ET=UE, and G is saturated by E:

    E(z)=E(g), g∈G  ⇒  z∈G.

Equivalently, target membership is a function of the image alone. By VC20,
U is a permutation. If r is the period of E(y), then 1≤r≤|Y| and

    E(T^(r−1)x) = U^(r−1)E(x) = U^rE(y) = E(y).

Saturation gives T^(r−1)x∈G. If x∉G, then r≥2, so a positive forward hit
occurs no later than |Y|−1. Consequently, one finite exact image with one
fixed target test cannot cover a family of starts whose target predecessors
exist but whose first forward hits have no common finite bound. It also
cannot cover a start with a target predecessor and no forward hit.

Here each target must retain the actual question's context. If the target
depends on the original input, use pairs (x₀,z), carry x₀ unchanged, and
test the target for that same x₀. Reaching a target associated with a
different start is not a hit. K must be a domain on which T is bijective.
The union of forward continuations alone need not have this property.
These are conditions on a proposed exact finite image, not a requirement
that every finite universal proof have such an image. The proof also does
not supply a physical encoder or reader, or preserve an unstated part of
the residue.

The research history gives a concrete application. In the SA69 family,
[SA79.1](../../../../Research/2026-10-01-scope-orientation-compact-windows.md)
exhibits an actual target predecessor with the original field requirement
and literal memory. The full Source phase changes as the actual inverse
requires. [TI53e](../../../../Research/2026-10-02-positive-density-and-transport-identification.md)
gives the same predecessor relation in the phase quotient. Thus global
first integrals cannot by themselves separate that target, while
[FPR86](../../../../Research/2026-10-11-finite-prefix-radius-on-sa69.md)
provides arbitrarily long finite failure prefixes. The quotient retains the
conserved I_a, with κ(I_a)=a, so a forward orbit cannot reach a target
belonging to a different family label a. VC20b therefore excludes
one exact finite target-preserving image on the complete two-sided orbits
of that family. This conclusion concerns the family in which the Source
amplitude varies. It does not settle the selected problem with a fixed
Source and the original O_E. The phase quotient is a logical description.
The actual Source remains in the residue.

**Replacing functions by support relations does not remove the joining
obligation.** Let T be bijective and let E:K→V be onto. Its exact observed
support is

    R_T = {(E(x),E(Tx)) : x∈K}.

The inverse contact has support R_(T⁻¹)=R_Tᵀ, the converse relation. The
actual two-step returns have the diagonal support Δ_V. Relationally joining
the separately observed supports gives both exact return supports,

    R_Tᵀ ∘ R_T = Δ_V,       R_T ∘ R_Tᵀ = Δ_V,

if and only if R_T is the graph of a bijection of V. No finiteness is needed
when both equations are required.

*Proof.* Every input and every output occurs in R_T, by surjectivity of E
and T. If two different outputs share an input, their pair belongs to
R_T∘R_Tᵀ off the diagonal. If two different inputs share an output, their
pair belongs to R_Tᵀ∘R_T off the diagonal. The two return equations therefore
force exactly one partner at each side. Conversely a bijection and its
converse compose to the diagonal. ∎

On a finite common V either return equation alone suffices. For example,
R_Tᵀ∘R_T=Δ_V makes the nonempty output sets of distinct inputs disjoint.
There are |V| such sets inside |V| outputs, so each has one member and they
cover V. The single common reading and complete support matter to this count.
With different input and intermediate alphabets, the intermediate reading
can refine the input and one exact return need not give a bijection between
their alphabets.

Thus an exact composition of observed relations for a reversible contact
family already forces the deterministic permutation images used by VC20
and the later calibration results. A multivalued coarse support is a valid
one-contact description, but its unrestricted relational reuse fails at
least one of the inverse returns. This conclusion concerns that composition
contract; it does not require every useful coarse description to satisfy it.

The existing swap gives a complete finite witness. On K=D×D with |D|≥2,
take T(a,b)=(b,a) and E(a,b)=a. Then R_T=D×D, whereas R_(T²)=Δ_D.
Joining R_T with itself still gives D×D. The spurious path a→b→c uses
middle source (b,a) after the first contact but (b,c) before the second.
Both edges are truthful. Their visible middle answer agrees while their
actual middle sources differ when a≠c. `DoubleSwapReturn` composes the
actual second application from the first's answer and derives the return
for arbitrary A,B. `SequentialReading` cannot replace that source seam by
agreement of its first projection. Matter's two-letter shift gives the same
failure for multiplying separately correct one-step probability tables:
the carried correlation, rather than stationarity, decides the second step.

The direct gate check uses the existing `ExchangeRoutingWithReserve` with
one additional retained field. Its actual source body supplies both truthful
exchanges, their common operation, their equal visible middle reading and
the properly bound return. Replacing the full middle source or declaring
the unrelated second endpoint a return is refused. The adapter reads that
current definition, rather than reproducing its exchange rule in JavaScript.
Its flat declaration lies within the direct reader's admitted fragment;
the separately conditional `SwapBoundaryReading` declaration requires a
reader that supports its conditions. Those conditions are not stripped to
make a check pass.

Repair does not always mean observing more values. Keeping the actual
intermediate source in the application relation lets the inverse act on it
without a decoder that privately knows its hidden component. The acquired
record can remain coarse while the experiment preserves this binding.
Replacing the binding by equality of coarse record values asks for a
different, stronger quotient, which the two truthful edges above do not
supply.

The finite-image condition matters. A two-sided binary sequence can shift
bijectively, while its observed right half shifts non-injectively by dropping
its first bit. That image has infinitely many elements. Conversely, making
K infinite while keeping Y finite does not escape this proof.

**Which bijections permit any irreversible autonomous image?** Fix a bijection T:K→K. Every exact deterministic factor of T, through every reading onto its image, is reversible if and only if every T-orbit is finite. No common bound on orbit lengths is required.

*Proof.* If each source x has a period n_x>0, then any factor U satisfies U^(n_x)(E(x))=E(x). Every image value is periodic. A map all of whose values are periodic is a permutation: each value belongs to a finite cycle, and any periodic predecessor belongs to that same cycle, with its unique predecessor. Thus U is bijective.

Conversely, suppose the orbit of an internal reference x₀ is infinite. Its forms T^n(x₀), n∈ℤ, are distinct. On that orbit put E(T^n(x₀))=min(n,0). If there are other orbits, give all their forms one additional answer ⋆. Define U(j)=min(j+1,0) for j≤0 and U(⋆)=⋆. Then ET=UE on the complete source, but U(−1)=U(0)=0. This is M34's clipped-orbit construction applied to one orbit of the given T. It proves necessity. QED

The quantifier is over mathematical readings, without asserting access to all of them. A source with infinitely many finite cycles of unbounded lengths still forbids every such irreversible factor. A source with an infinite orbit permits one, although many of its other readings remain reversible. VC20 separately forbids any noninjective factor with a finite image. Thus a noninjective exact factor of a bijection needs both an infinite image and at least one infinite source orbit. Literal return concerns the complete source in this claim. A local pattern returning while its addressed occurrence record grows does not supply that return, by M55.

**An inverse word gives another route without cardinality bounds.** Suppose a reading E carries each total operation in O exactly, and a finite word v in O realizes the inverse of a finite word w on the full specified source domain. Compose the corresponding image operations to obtain V and W. Then VW∘E=E and WV∘E=E. Since E is onto its image, VW=WV=id there. The image inverse is therefore constructed by the same word. This is the group-action case of VC15 and Space S25. A vocabulary of involutions supplies an inverse to every word by reversing its order. Neither a finite carrier nor a uniform period is needed. For partial contacts, VC46–VC47 additionally require preservation of admission domains.

Keeping only a composite as one available operation can change that conclusion. On K=ℤ let A(n)=−n and B(n)=2−n. Both are internal-centre involutions. Their composite T=B∘A advances n by two. The reading E(n)=min(n,0) carries T exactly through U(j)=min(j+2,0), an onto noninjective map on the nonpositive integers. But it does not carry A: E(0)=E(1), while E(A(0))≠E(A(1)). It also fails for B, using 2 and 3. There is no conflict with the inverse-word result, whose premise requires both generator actions to descend. Exact knowledge of the combined effect need not support its internal steps.

Space S32 has the same vocabulary boundary in its scaling example. Each reflection is its own inverse. With each centre fixed in the word, finite compositions of a↦2c−a have slope +1 or −1. Adding doubling as a forward generator allows only slopes ±2^k with k≥0, so no finite word in that vocabulary supplies halving. Choosing a centre using an omitted source distinction would add another reading whose factorization must be checked. The quotient by integer differences carries all the stated forward words and still omits the inverse scale question. Its growing refinement is required by the newly admitted questions, rather than contradicting the exactness of the old contact family.

**VC21 (Observation windows can complete a state).** Let K be finite,
`N = |K|`, T a total deterministic map, and E a current observation with k
images. The window `W_l(x) = (E(x), E(Tx), ..., E(T^(l−1)x))` induces a
partition. At some `l ≤ N−k+1` this partition equals the all-future
behavioral partition of VC15 for the one operation T and observation E.

*Proof.* Start with the k classes of E. Each longer window refines the
partition. Equality at one refinement step makes the partition stable under
T, since equality of the longer windows equates the shifted shorter windows.
Induction then gives equality of all subsequent observations. Until that
point, each refinement adds at least one class. There can be at most N−k
strict refinements. The resulting quotient is autonomous by VC15.

When T is bijective, forward and backward all-time partitions agree: a finite
permutation has finite order, so each inverse power is also a nonnegative
forward power and conversely. Applying the same window argument to T inverse
therefore gives a sufficient finite past window too. This assertion is about
a fixed known law and observations, not about learning the law from samples.

For an internal swap `T(a,b)=(b,a)` and E(a,b)=a, one frame is insufficient:
(0,0) and (0,1) have the same present and different next observations. Two
frames give (a,b). `SwapWindow<S>` constructs these two frames for any Pair S.
The compiler derives recovery of both coordinates and both components of
`W_2(T(S)) = swap(W_2(S))`. A one-frame prediction is separately refused.
Nominal Swift wrapper equality is not inferred from component equality.

Memory can thus supply distinctions omitted from the current observation.
Here a window is a mathematical function of a state. A device recording it
must have its storage and interactions inside Ω, with their effects included
in T. The argument does not attach a free tape to an unchanged physical world.
The known neighboring idea is the construction of minimal predictive states
from histories, developed by [Shalizi and Crutchfield](https://arxiv.org/abs/cond-mat/9907176).
Their stochastic theory is broader than this finite deterministic argument.

**Past depth, retained distinctions and reversible completion.** Let T:X→X be a bijection and let a fixed reading E:X→Y be onto, with ET=UE. Put E_k=E∘T^(−k), for k≥0. The single reading E_k determines every E_j with 0≤j≤k, because E_j=U^(k−j)E_k. It is therefore the least sufficient reading for that family: the family includes E_k itself. Its answer alphabet is still Y, since T^(−k) is onto. Alphabet cardinality alone can conceal the strict refinement of source distinctions.

Within one current fiber E⁻¹(y), the required number of classes is exactly |U⁻ᵏ(y)|. Indeed U^k(E_k(x))=E(x). Conversely, for any z with U^k(z)=y, choose v with E(v)=z and put x=T^k(v). Then E(x)=y and E_k(x)=z. Any residual accompanying the old answer must distinguish these classes, by M35. For Space S32 this number is 2^k. `CurrentAnswerFromPredecessor<P,R>` supplies the finite recovery step in types: R reaches P's actual earlier source, its observation is read there, and P's image step recovers the current answer. The compiler checks the composed answer and both source seams. A total inverse family and the counting statement are the mathematical premises and proof above.

The fixed U premise matters independently of those seams. Let T swap (0,b) to (b,0), and let E read the first field. For each b, the constant decoder d_b(0)=b gives a correct pointwise square. But the identical earlier image 0 requires different current answers for b=0 and b=1. No one decoder of that image can supply both. `PointwiseFirstSwap` and `CapturedPredecessorRecovery` construct these individually accepted squares with an image application parameterized by the hidden B. The checks establish equal decoder inputs and distinct required outputs, then refuse their claimed answer agreement. The parameter is extra information outside that image. VC9 requires one function across the entire fiber, and VC10 supplies the shared-decoder relation. Neither a common operation tag nor pointwise successful composition supplies that missing premise.

For all finite depths together, define H(x)=(E_0(x),E_1(x),…). Use only its realized image Z=H(X). On that image the forward action is

    V(y₀,y₁,…) = (U(y₀),y₀,y₁,…).

Its inverse drops the first entry. The coherence equations U(y_(j+1))=y_j verify the two inverse equations, and HT=VH verifies that both actions preserve Z. H is the least reversible refinement of E through this source. To prove minimality, let R:X→W be another refinement, E=dR, and suppose RT=AR with A bijective on W=R(X). Then E_k=dA^(−k)R for every k. Thus R determines every component of H, so equal R readings have equal H readings. This is VC15's common-kernel construction with both directions admitted. It specifies exactly which omitted distinctions must be restored, without selecting a storage representation or making these readings physically available.

The realized-image clause cannot be replaced by all formally coherent histories. Let X consist of binary sequences indexed by ℤ with finite support, T(x)_i=x_(i+1), and E retain the coordinates i≥0. Consider instead the excluded sequence with ones at every negative address and zeros elsewhere. Its past readings y_j, each with exactly j initial ones, are finite-support members of Y and satisfy U(y_(j+1))=y_j. Each finite history prefix is realized by an admitted source. The entire history is not: it requires infinitely many ones in the source. Enlarging Z to include it would change the specified source's admission. VC23 and LQ15 identify the same finite-compatibility boundary. The established natural extension and its minimality in the compact topological setting appear in [Hochman, Proposition 5.10](https://math.huji.ac.il/~mhochman/courses/TD2022/notes-v3.pdf), also linked from M34. The source-relative construction above requires neither topology nor admission of unrealized histories.

**Unbounded depth can require only a binary residual.** Take X=ℤ×{0,1} and T(n,b)=(n+1,b). E always retains n and retains b exactly when n<0. Write E(n,b)=(n,b) there and (n,⋆) otherwise. The induced U increments n, drops b at the crossing from −1 to 0, and then continues to increment the visible n. It is exact and onto but not injective. Keeping b beside E suffices for every backward question, since together they recover (n,b). Every current fiber has at most two sources.

Nevertheless no common finite depth k suffices: choose n≥k. The sources (n,0) and (n,1) agree on all readings through depth k, while their readings at depth n+1 disagree. An adaptive depth n+1 suffices at each n≥0. For those sources |U⁻ᵏ(E(n,b))| is one when k≤n and two when k>n. A finite run with no new distinction at one image is not the global partition equality used in the finite-window proof. There is no repeated doubling as in S32. Required depth, residual alphabet and actual access are distinct requirements. The integer n indexes this specified shift and does not posit an external clock. No probability distribution or entropy rate is used.

There is also a limit on reading this as an arrow of time. On a finite
permutation cycle no real-valued clock can strictly increase at every step:
summing its changes around the cycle gives zero. More generally, a scalar
that never decreases on any step must be constant on each cycle, since its
nonnegative increments sum to zero. Prepared records may mark
a direction along a finite segment. A permanent strictly growing clock for
all time needs different capacity or dynamics, as M33 already requires.

**VC22 (A ready memory is part of the premise).** For finite nonempty X and
memory alphabet M with at least two values, no bijection on the complete
product X×M can implement `(x,m) → (x,q(x))` for every initial m.

*Proof.* Two distinct initial memories at the same x would have the same
whole output. This violates injectivity. Restricting the input to `(x,m0)`
changes the result: the prescribed map `(x,m0) → (x,q(x))` is injective and,
on a finite product, extends to a permutation by matching the unused inputs
and outputs. The extension's behavior on other memory states is not another
unconditional overwrite.

Thus discovery as correlation in M34 has an operational premise: a record
that reliably answers q must have suitable preparation or retain the displaced
memory elsewhere internally. For binary copying there are two permutations
extending the blank-input specification and none implementing the overwrite
on all four inputs. One extension is CNOT. Its action on an arbitrary old
memory is XOR with the target, which does not necessarily leave a direct copy.
These are classical logical maps and supply no numerical heat budget.

**VC23 (Compatible local records need not admit a common state).** Three
binary variables have the pair constraints `A XOR B=0`, `B XOR C=0`, and
`A XOR C=1`. Each pair admits two assignments. Giving each its uniform local
distribution makes every one-variable overlap uniform and consistent. Yet
there is no common triple, since the first two equations force A XOR C=0.
More generally, three such parities admit a common triple exactly when their
XOR is zero.

Local nonemptiness and matching overlap marginals therefore do not certify
a nonempty global candidate class. This example requires no quantum physics.
It illustrates the local-to-global obstruction treated more generally by
[Abramsky and Brandenburger](https://arxiv.org/abs/1102.0264). An arbitrary
parity table is not thereby a realizable quantum experiment. A contextual
physical model also need not assign context-independent values to all the
variables at once. One physical whole and one simultaneous classical value
assignment are different claims.

For VI this extends the nonempty-coverage requirement of VC5: certifying each
local list is insufficient unless their joint constraints have a witness.
`GluedEqualities<F,G>` supplies the elementary positive case. It derives the
outer equality when the two premises share the actual intermediate type.
The compiler refuses a join of independently true equalities with mismatched
intermediates. This checks equality composition, not a general Swift solver
for the parity example or arbitrary global constraints.

**When an impossible joint assignment must have a finite witness.** Consider finitely or countably many addressed variables x_i, each in a specified nonempty finite carrier A_i, and finitely or countably many requirements C_j. Each requirement is an admitted relation on a finite set of these addresses. A complete assignment is admitted exactly when it satisfies every C_j. There is no additional restriction on complete assignments left outside those requirements. Then the full family has a joint assignment if and only if every finite subfamily has one. Equivalently, every impossible joint assignment problem in this presentation has a finite inconsistent subfamily.

*Proof.* Only the reverse direction needs proof. Enumerate the addresses and requirements, and let I_n contain the first n addresses and every address used by the first n requirements. I_n is finite and increases with n. At level n, keep the assignments on I_n satisfying those first n requirements. Each level is finite and nonempty by the premise. Restriction carries every level n+1 assignment to a level n assignment. Thus these levels form a tree with finite branching and arbitrarily large depth.

From a node with descendants at arbitrarily large depths, at least one of its finitely many children has the same property. Otherwise finitely many finite depth bounds would bound all its descendants. Starting at the empty assignment, choose such a child successively. Their compatible union assigns every address. Each C_j is satisfied from level j onward, so the union satisfies them all. QED

The enumeration organizes the proof. It neither orders physical events nor supplies an external selector to an interaction. The choice of a child with unbounded remaining depth is an existence argument, not a claim that this property is decidable from a finite prefix. This is the familiar compactness mechanism. A standard graph specialization and its relation-selection form appear in [de Bruijn and Erdős, Theorems 1–2](https://users.renyi.hu/~p_erdos/1951-01.pdf). The proof here uses the stated countable presentation. It does not identify that presentation with all of reality or assign context-independent values to readings whose joint availability has not been established.

This adds a different guarantee to M71. M71 preserves a supplied finite obstruction under enlargement that preserves its premises. The result here guarantees existence of a finite inconsistent subfamily for this local finite-carrier presentation. It does not promise that its inconsistency has the particular equality-substitution form of M71. Since a finite subfamily has only finitely many relevant assignments, an explicit table or an appropriate generic argument can establish that none is admitted. These are separate proof obligations.

**A forced local answer has finite support in the requirements.** Suppose the full family has at least one assignment and fixes q=a, where q is a specified total reading of finitely many addresses. Add the finite-address requirement q≠a, meaning its explicit alternative-answer relation. The enlarged family is inconsistent, so a finite subfamily is already inconsistent. It must include q≠a, because every subfamily of the original requirements has their common assignment. Removing that one extra requirement leaves finitely many original requirements that already force q=a. This derives finite support for an answer even when the whole candidate family is infinite. It does not make these supporting relations already known or accessible to a learner.

**The finite witness need not be small.** For any n≥1, use binary variables x₀,…,x_n and the n+2 requirements

    x₀=0,   x₀=x₁,   …,   x_(n−1)=x_n,   x_n=1.

They are jointly inconsistent. Deleting the first pin admits the all-one assignment, and deleting the last admits the all-zero assignment. Deleting the equality between x_(k−1) and x_k admits zeros before that cut and ones from it onward. Thus every requirement is essential, and every proper subfamily is satisfiable. The alphabet has two values and each requirement uses at most two addresses, yet the smallest inconsistent subfamily has arbitrarily large size. Pairwise or bounded-size consistency tests cannot certify global compatibility across this family.

The transitivity proof for this family can be stated once. `GluedEqualities` already supplies its composition step, and its finite nested expressions cover any specified finite chain. A short reference to that generic rule does not reduce the number of actual contact premises on which a particular endpoint claim depends. Its existing positive checks and unmatched-seam refusal exercise this distinction. Neither a new protocol nor a runtime search is needed to repeat the same composition.

**Both admission assumptions carry content.** If a single carrier is ℕ, the requirements x>n for every n have no joint assignment, while each finite subfamily is satisfied by a larger natural number. Finite arity alone is insufficient. If all carriers are binary but complete assignments are additionally restricted to finite support, the requirements x_i=1 at every address have the same failure. Each finite subfamily has an admitted finite-support witness, but the complete all-one assignment is excluded. This second case is LQ15's existing example: the global admission restriction is not supplied by finite-address requirements. Treating it as if it were local would discard a premise.

These counterexamples concern support by finitely many ground requirements. Their impossibility has a short mathematical proof using the universal requirement and the stated carrier or admission rule. Absence of a finite ground obstruction therefore does not establish absence of a finite symbolic proof. Bare Swift's generic proofs belong to that distinction. An open conformance still does not prove finite generation of every represented value.

**An unbounded existence reading cannot have this local witness presentation.** Let the visible source be a binary sequence x and let its claimed answer b be one exactly when some x_i is one. No finite or countable network of finite-address requirements on finite-valued visible and hidden variables can represent this relation exactly by admitting a visible pair (x,b) when it has a complete satisfying hidden assignment. The local relations may have any finite arity and the hidden carriers any finite sizes.

*Proof.* Suppose requirements C supply such an exact representation. Add b=1 and x_i=0 for every i. The complete family must be inconsistent, because the all-zero sequence has no one. Yet each finite subfamily mentions only finitely many of the zero pins. Put one at an unpinned coordinate and zero elsewhere. This visible source really has a one, so exactness supplies a complete hidden assignment satisfying all of C with b=1. It satisfies the finitely selected zero pins too. Every finite subfamily is therefore satisfiable, contradicting the finite-witness theorem. QED

The proof uses only b=1 cases, so the obstruction already concerns a sound and complete positive certificate in this grammar. It persists under adding any finite or countable family of finite-valued hidden addresses and further local requirements, provided every correct positive input still has a witness. One can change the representation by admitting a natural-valued witness index, by requiring a finite generated witness path that ends at an actual one, or by bounding the relevant source addresses.

M34 uses this same boundary in a question about permanent readiness. With one marker required to exist on an integer-addressed source, each marker position has a finite positive witness, but the source family has no finite-cover property. Adding the all-zero limiting description removes that existence premise. In the enlarged compact family, the new zero source either never reaches the former readiness set, or needs a readiness certificate that no finite coordinate reading supplies. Thus compactness of a local finite-carrier presentation cannot be borrowed while discarding a global fact carried by the source. No second proof system is needed for this point: the present existence obstruction already identifies the changed premise.

One hidden index k∈ℕ gives an exact repair, including the negative answer. It names a source position inside the same representation. For every i require b=0 to imply x_i=0, and require b=1 together with k=i to imply x_i=1. These are local relations on b,k,x_i. The all-zero source admits b=0 with any k and excludes b=1. A source with a one excludes b=0 and admits b=1 by choosing one such position as k. Existence of this witness does not supply a selection protocol for finding it. Its carrier ℕ is infinite. A finite binary encoding of k needs the additional requirement that the encoding ends. That requirement cannot be replaced by unrestricted complete assignments of infinitely many binary fields.

The tempting local rule is b_i = x_i OR b_(i+1). On the all-zero source it permits both b_i=0 everywhere and b_i=1 everywhere. In the latter assignment each assertion receives its support from the next assertion, with no positive source occurrence. The rule expresses local consistency, while the intended existential reading also requires that a positive claim reach a witness. The theorem excludes repairing this exact unbounded reading solely by more constraints of the same finite-carrier local kind.

`ZeroInputClaimTail<Claim>` exposes that failure in bare Swift. Its input field is Never, its claim is supplied separately, and its next tail is the same recursive form. For the binary claims Never and Lit1, the local zero-input OR equation reduces to agreement with that next claim and is satisfied. The input at every finite unfolding remains Never. `Checks/ClosedInformation.swift` verifies both statements. Recording the Lit1 claim is admitted as an occurrence of that claim reading. Requiring the actual zero input reading to supply a Lit1 witness is refused. Thus the corpus can represent a mutually supported assertion without certifying its intended referent. The universal representation prohibition is the proof above, rather than the outcome of this single static counterexample.

**Joint support distinguishes a consequence from a consistent circular claim.** Fix a set C of addressed assertions, established proof premises B⊆C, and rules P⇒x with finite premise sets P⊆C. Each P is required jointly. Define

    F(S) = B ∪ {x: some rule P⇒x has P⊆S}.

Empty-premise rules count as declared premises. The operator is monotone. Put L₀=∅, Lₙ₊₁=F(Lₙ), and L=⋃ₙLₙ. Then L is exactly the assertions with finite derivation trees from the declared premises. Induction establishes the correspondence at each stage. F(L)⊆L because the finitely many premises of one rule all occur by some common finite stage. The reverse inclusion follows from the increasing stages. Every S with F(S)⊆S contains each Lₙ and hence L. This is the standard positive-rule construction, not a new logic: see [van Emden and Kowalski, §§6–8](https://www.doc.ic.ac.uk/~rak/papers/kowalski-van_emden.pdf).

The equality S=F(S) is stronger than closure under implications: it also requires every included assertion to have a declared support. Even that equality need not give S=L. Let N be the union of all U with U⊆F(U). Then N=F(N): the union is contained in its image, and monotonicity makes F(N) another such U, so F(N)⊆N. Every fixed point lies between L and N.

There is a precise test for unresolved circular support. N differs from L exactly when some nonempty U⊆C∖L has, for each x∈U, a rule P⇒x with P⊆L∪U and P∩U≠∅. For necessity take U=N∖L. Its members are not in B, so their support comes from rules. No supporting P can lie entirely in L, since L is fixed. For sufficiency, L∪U⊆F(L∪U), so N contains U. Thus the local support equations have one solution exactly when no such remainder exists. This criterion preserves joint premises and needs no finite whole, traversal clock or representative selected from every support family. L presupposes the stated proof-premise and rule contract. Its membership alone does not establish their fidelity to a physical source.

Take B={b} and one further assertion x. The rule {b,x}⇒x gives both fixed points {b} and {b,x}. A path to the established b has not grounded x: its other required premise is x. Replace that one joint rule by the alternatives {b}⇒x and {x}⇒x. Now the only fixed point is {b,x}, and x has a finite derivation. The ordinary dependency arrows are the same, x→b and x→x. Forgetting whether premises are joint or alternative therefore loses the answer. This is an explicit failure of representing the support relation by its separate edges.

**Givenness constrains the supported structure without removing its dependencies.** The preceding B terminates a proof because its assertions have already been established for that proof. It does not designate physically unrelated first witnesses. To inspect the internal support of an already given occurrence, keep the proposed support relation F fixed and impose the actual given as a further condition on S=F(S). Replacing F by G∪F for a set G of given assertions can weaken that condition: it allows a member of G without the support its original equation required.

For example, let x be included exactly when y is included, and let y support itself. The fixed sets are ∅ and {x,y}. If x is given, {x,y} is the only admitted set and y is necessary within this support contract. Turning x into an unconditional premise instead also admits {x}, which violates the original dependency of x on y. The deduction of y needs no finite construction of x from absence. It uses the actual x and the necessary direction of the specified support relation. Conversely, an implication y⇒x alone would not justify inferring y from x: completeness of that support description carries the reverse direction.

An omitted alternative tests exactly this completeness. Add a possible internal support z for x, with z supporting itself. The enlarged account x exactly when y or z now admits {x,z}. It preserves the earlier sufficient rule y⇒x but removes the earlier necessary rule x⇒y. Hence this is no counterexample preserving the full original contract. It shows what was assumed if x⇒y came only from listing y as the sole support. A necessity established independently would still require y in the extended account. There being no outside supplies no exhaustive catalogue of internal supports.

The necessary remainder can also be joint without selecting an individual support. Let a be included exactly when x or y is included, and let x and y each support themselves. Given a, the admitted sets are {a,x}, {a,y} and {a,x,y}. Every one contains a support for a, while neither named support is forced. Their intersection {a} is not an admitted set. Storing only the individually forced assertions would lose the necessary alternative x or y. A further established incompatibility of x with y removes the third set but still chooses neither of the first two. The actual admission family, including any established refusals and shared source roles, must remain in the question.

These are probes of a specified support account, not proposed physical replacements for the encountered contrast. The given keeps all of its established joint content. The Cut's CLOSURE_S5 neither identifies physical support with finite proof generation nor supplies a complete list of supports for every occurrence. A cycle can propagate a necessary consequence of an actual given when the relation warrants it. Its local agreement cannot supply an omitted source, and an assumed exhaustive support list cannot be passed off as a consequence of there being nothing outside reality. EF10 gives the complementary case in which recursive closure does certify an exclusion.

For research, this gives three different obligations: exhibit the obstruction, establish when finite obstructions are complete for the presentation, and establish how the available proof grammar can express them. If requirements can be enumerated and their finite carriers and complete relation tables are effectively supplied, enumerating finite subfamilies and checking their finite assignments eventually finds an obstruction when one exists. The theorem gives no uniform bound on that search and no stopping certificate from the absence of a discovered obstruction. A generic derivation can instead exclude an entire supplied family at once. The meaning of the carrier and the actual source contacts remain part of either certificate.

**VC23a (a binary Boolean constraint medium cannot express ternary parity).** Fix the grammar: every variable, including every hidden variable, takes values in {0,1}. Atomic constraints may be any unary or binary relations, including equality and fixed values. A represented relation is obtained by conjoining finitely many such constraints and existentially hiding any number of their variables. The relation a XOR b XOR c=0 is not representable in this grammar.

*Proof.* Coordinatewise majority preserves every binary Boolean relation. For three admitted pairs, at least two rows agree with the majority at each coordinate. Those two sets of rows intersect, so one input pair is the majority pair. Unary relations are preserved too. Majority of three full satisfying assignments therefore satisfies every conjunct. For three projected assignments, choose their hidden witnesses and take majority of the full assignments. Its projection supplies a witness for the majority output. Every represented relation is consequently majority-closed. But 110, 101 and 011 have even parity, while their coordinatewise majority 111 has odd parity. Contradiction. QED

The preservation argument also applies to an infinite network when admission means existence of a full satisfying assignment. Majority of three such assignments preserves every local constraint at once. Finiteness is needed for the declared finite-expression syntax, not for this obstruction. Local consistency of fragments without a full assignment is a different admission rule.

This is the preservation method of [Barto, Krokhin and Willard, *Polymorphisms, and How to Use Them*](https://drops.dagstuhl.de/opus/volltexte/2017/6959/pdf/DFU-Vol7-15301-1.pdf), specialized here with an explicit proof. A counter-operation preserving the entire generating language but breaking the target proves non-expressibility, including the permitted hidden-variable constructions. Failure of a particular attempted encoding is weaker evidence. Majority here combines possible descriptions to characterize an encoding grammar. It supplies no physical evolution law for the whole.

The same argument gives an exact approximation boundary. Any represented relation containing all four even triples must also contain every odd triple, since

```
maj(000,011,101) = 001    maj(000,011,110) = 010
maj(000,101,110) = 100    maj(011,101,110) = 111.
```

Its sound overapproximation is therefore the entire eight-state domain. Conversely a represented relation contained in parity can contain at most two of its four triples: any three distinct even triples have an odd majority. Two suffice, for example c=0 together with a=b. Allowing a disjunction of two such contexts represents parity exactly: (c=0 and a=b) or (c=1 and a≠b). Disjunction changes the declared grammar. This gives another precise repair, distinct from adding more hidden Boolean variables. More examples alone cannot make the original grammar remove the forbidden half while retaining every correct case.

The carrier restriction is essential. Allow one internal four-valued variable h=(u,v), together with binary relations that require a=u, b=v and c=u XOR v. Existentially hiding h gives exactly even parity. In this star representation four latent states are necessary: at fixed h, the allowed visible triples form a Cartesian rectangle A_h×B_h×C_h. A nonempty rectangle inside parity must be a singleton, since changing one bit alone reverses parity. Four admitted triples therefore require at least four nonempty latent states. The construction attains the bound. This lower bound concerns one latent centre with three pairwise contacts, not every topology using larger carriers. Its capacity distinguishes the four possible visible triples. It is not the information needed just to name even rather than odd parity. The larger carrier needs the stated contact relations: its existence alone does not select the parity law.

VI's `Pair` is a constructor of structured carriers, not a promise that every variable is one Boolean bit or that every joint relation is a binary Boolean predicate. The four `Paired` bit types can supply h, and the existing parity clauses produce its third reading. A two-input Boolean gate also has a third value, its output: representing that gate as a constraint uses a ternary relation. Thus VC23a excludes a tempting restriction of the medium, rather than parity from bare Swift or from Boolean circuits. The extra object can be a represented relation among existing parts. Its required logical capacity does not identify an additional physical particle.

M32's even/odd preparations give the operational reason this boundary matters: all old pair marginals agree, yet one reversible continuation exposes the omitted relation. `Checks/ClosedInformation.swift` verifies those finite tables and constructs all four latent-centre outputs through the existing parity clauses. Existing projections implement majority on the three repeated-value schemas. They read the actual columns of the admitted 110, 101 and 011 rows and produce a positive parity violation. The universal exclusion of all Boolean hidden-variable networks is the preservation argument above, not a finite enumeration by the compiler.

**VC23b (existence and internal acquisition impose different witness capacities).** Fix n≥2 addressed binary coordinates and the relation R_n={x∈{0,1}ⁿ : some x_i=0}. The coordinates describe forms in this model. They do not presuppose a sensor, an observer or a signal travelling between them. A star representation uses a finite central carrier H and binary contacts B_i⊆H×{0,1}, with

```
x ∈ R_n  iff  there exists h ∈ H with (h,x_i) ∈ B_i for every i.
```

At fixed h the compatible inputs form a rectangle C_h=∏ᵢ A_i(h), where A_i(h)={b : (h,b)∈B_i}. Discard empty rectangles. Exactness requires every remaining rectangle to exclude 1ⁿ. Its set D(h)={i : A_i(h)={0}} is therefore nonempty. D(h) identifies the coordinates this witness actually requires to be vacant.

**Existential capacity is exactly n.** For each i, the input with its only zero at i needs a witness with D(h)={i}. No witness can cover two such inputs: their coordinatewise rectangle contains 1ⁿ. Hence at least n central states are needed. The n rectangles x_i=0 attain the bound. The argument is a finite rectangle-cover lower bound, using the same method as VC23a's star argument. It assumes one centre with binary contacts, not every possible expression topology.

Now require the entire contact structure to respect every permutation g∈S_n of the positions: C_{gh}=gC_h. A deterministic acquisition is a map f:R_n→H with x∈C_{f(x)} and f(gx)=gf(x). No privileged position or additional distinguishing parameter is supplied.

**Deterministic equivariant capacity is exactly 2ⁿ−1, and acquisition must distinguish every input.** For an input x, let Z={i:x_i=0}. Since x∈C_{f(x)}, the nonempty set D(f(x)) is contained in Z. Every permutation of Z fixes x, so equivariance fixes f(x). Covariance of the contacts then fixes D(f(x)). The permutation group acts transitively on Z, so its only nonempty invariant subset is Z itself. Thus D(f(x))=Z. Different inputs have different zero sets and must acquire different central states. There are 2ⁿ−1 such inputs. Conversely, take H=R_n, f(x)=x and equality contacts h_i=x_i. Every rectangle is a singleton, the acquisition is equivariant, and the bound is attained. QED

This refutes the proposed identification of a smallest existing witness with a smallest witness the medium can produce while preserving its symmetries. A witness saying which one vacant position suffices can be smaller than the form needed to avoid making that choice. VI1a explains the obstruction at the symmetric inputs. VC23b additionally proves that it propagates through every vacancy pattern and forces injectivity of this particular acquisition. The result gives no general prohibition on compression: an invariant yes/no answer to the vacancy question is a different output contract, and a relation with more than two arguments can express that question directly. Nor does the converse above supply a path to inaccessible coordinates.

The attaining construction identifies the witness with the input itself. It needs no separate observer or extra copy at the level of these relations. It does not establish membership of an arbitrary proposed input in R_n: that must follow from its construction or the contacts. Identity supplies the witness form for an admitted input, not a free test of its admission. The 2ⁿ−1 bound concerns distinguishable witness forms, not that many registers or newly allocated storage. Additional copying, accessible readings and physical costs need their own relations. The source's address labels also supply no privileged order under the stated S_n action. A rule that selects the first written address would add precisely the structure this version omits.

**Changing the medium changes the bound.** For n=3, suppose a cyclic orientation is supplied but no starting position. Preserve only its three rotations, acting on the contacts as well as the input. Four central states now suffice: three one-position witnesses and a fourth requiring all three positions to be zero. With one zero, select it. With two zeros, select the zero immediately preceding the unique one in the supplied cyclic order. With three zeros, use the fourth witness. Rotation preserves this acquisition. Four states are also necessary: the three one-zero inputs require three distinct singleton D(h), while 000 is fixed by every rotation and needs a rotation-invariant nonempty D(h), necessarily all three positions. That fourth witness cannot coincide with any singleton witness. The two-zero selection fails reflection covariance, so this construction does not contradict the 7-state bound under S₃.

With a supplied total order on the positions, selecting the first zero uses only the n existential witnesses. Transporting that order together with the input makes the joint rule equivariant. The order or cyclic orientation is an additional internal relation, not an exterior convenience. For three positions there are two cyclic orientations and six total orders. The conditional witness counts 7, 4 and 3 do not prove that the entire source-plus-reference construction has become smaller.

An equivariant stochastic acquisition also has an n-state output law: assign probability 1/|Z| to each i∈Z and zero to other positions. Each possible witness is sound and the distribution transports under every permutation. The n one-zero inputs prove minimality of the output alphabet. This is a kernel construction, not a deterministic implementation from a symmetric complete input. Realizing a selected outcome introduces the same internal seed or event question as VI1a. Probabilities and all binary carriers here are explicit model premises.

The static fragment uses `FirstVacancy`, `SecondVacancy` and `ThirdVacancy`. Each constructor checks its actual source coordinate and supplies the corresponding one-hot position mask. Generic source and mask transport use the existing `SwapFirstTwoTriple` and `RotateThree` constructions. A positive zero/successor contrast separates valid witnesses at the same symmetric source. The full pattern can instead be retained by the existing identity reading. These checks establish the three-position clauses and their transport, not a compiler proof over all star representations or symmetry groups. The capacity proofs are the arguments above. Picking a clause by its Swift address does not establish an orientation-free acquisition.

The comparison with equivariant learning concerns the cost of choosing a representative from symmetric input. [Dym, Lawrence and Siegel](https://arxiv.org/abs/2402.16077) study related obstructions and weighted frames, with additional continuity requirements. VC23b's finite rectangle and stabilizer proofs require no topology and claim no priority over that literature. The useful research consequence here is to test the witness-producing medium, as well as the relation for which a witness exists.

**VC23c (A finite contact language determines its least forced admission).** Fix a finite nonempty carrier D and a finite family Γ of finite-arity relations on D. Every visible and hidden variable ranges over this same carrier. Expressions may use Γ, equality, finite conjunction and existential hiding. Let P⊆Dⁿ be a nonempty set of required admitted tuples, and let N⊆Dⁿ be the tuples required to be refused. These are addressed contact requirements, without a completeness claim about all contacts of reality.

Write the m=|P| rows of P as p¹,…,pᵐ. An m-input operation f:Dᵐ→D preserves Γ when applying f coordinatewise to any m tuples of any generating relation produces another tuple of that relation. Such operations are called polymorphisms. Define

    L_Γ(P) = { f(p¹,…,pᵐ) : f preserves every relation in Γ }.

Then L_Γ(P) is the least relation expressible in this grammar that contains P. In particular, an expression meeting both the positive and negative requirements exists exactly when

    L_Γ(P) ∩ N = ∅.

If the intersection is nonempty, one operation f and its resulting forbidden tuple certify impossibility for the whole grammar, including every finite choice of hidden variables. The certificate must establish preservation of the entire Γ, not only of the rows seen in P. The arity m suffices for this complete test. It need not be the smallest obstructing arity. Tuples outside L_Γ(P) are not thereby refused by reality. The least expression is one compatible representation, not a proof that the actual relation contains nothing else.

*Proof of forced admission.* Projections preserve Γ, so P⊆L_Γ(P). Every preserving operation also preserves equality and conjunction. It preserves existential hiding by applying the operation to full satisfying assignments, including their witnesses. Therefore every expressible relation containing P contains every displayed f-image.

*Proof of an attaining expression.* Introduce one variable y_u for each column u∈Dᵐ. For each k-ary R∈Γ, impose R(y_(u₁),…,y_(u_k)) whenever (u₁(j),…,u_k(j))∈R at every row j. For the i-th visible coordinate let c_i=(p¹_i,…,pᵐ_i), and require x_i=y_(c_i). Existentially hide all y variables. Assigning them is exactly specifying an operation f(u)=y_u that preserves Γ. Thus the visible assignments are exactly L_Γ(P). Each required row is realized by its projection operation. The construction is finite and uses |D|ᵐ internal variables, though many can coincide with visible variables or be eliminated. It proves expressibility, not an efficient search procedure. QED

This is the finite preservation/definability method of universal algebra. [Barto, Krokhin and Willard, Theorem 32 and Example 34](https://drops.dagstuhl.de/opus/volltexte/2017/6959/pdf/DFU-Vol7-15301-1.pdf) give the general correspondence and canonical construction. Here it answers an inverse question about positive and negative contact requirements. VC23a is its majority obstruction. A failure in a particular attempted graph does not yet certify a failure of this language. The nonempty P premise also avoids assigning meaning to a vacuous positive specification. Whether the empty relation is expressible depends on the admitted primitives.

The preserving operation f acts on assignments in the representation. It is not assumed to be an available physical process combining the corresponding preparations. Its consequence is that every expression in the specified grammar admits the resulting tuple. If a justified source contact refuses that tuple, the conflict excludes that grammar as a complete representation of these contacts. It neither requires reality to admit the tuple nor locates anything outside the whole. Establishing P and N as facts about one relation remains essential.

**How evidence and the language change this conclusion.** If P⊆P′, then L_Γ(P)⊆L_Γ(P′), because the latter is an expressible relation containing P. More admitted examples cannot remove an already forced forbidden tuple. Adding relations to Γ can remove it: there are fewer operations preserving the enlarged language, and its least forced admission is contained in the earlier one. Merely adding another name for a relation already expressible from Γ changes neither class. Such a derived lemma cannot repair this kind of obstruction. A larger hidden carrier, a genuine additional primitive or another composition grammar can do so, and each changes a stated premise.

There is an exact test for a proposed extension Δ. For each b∈N, take the m-input Γ-preserving operations sending the rows P to b. The extension removes every such forced refusal exactly when each of these operations fails to preserve at least one relation in Δ. This identifies what a new contact must break. Breaking one exhibited operation is necessary for removing its consequence, but may leave another operation forcing the same forbidden tuple. A physical justification for the new relation remains a separate contact obligation.

**VC23d (Parity and binary contacts jointly express every finite Boolean relation).** Keep all variables Boolean and the composition grammar of VC23a. Once the ternary relation E(a,b,c) defined by a XOR b XOR c=0 is available beside the binary relations and fixed values, every finite-arity Boolean relation is expressible. No larger hidden carrier or disjunction primitive is required.

*Construction.* First, E and a fixed one express complementation: E(a,b,1) means b=1−a. Chaining E expresses a specified parity of any finite nonempty list. Let I(h,x) be the binary implication relation, which refuses only (1,0). Then

    x₁ OR … OR x_k
      iff ∃h₁,…,h_k : (h₁ XOR … XOR h_k=1)
                           and I(h_i,x_i) for every i.

An odd support has at least one selected position, whose input must be one. Conversely, if x_j=1, selecting only h_j supplies an admitted support. For k=3 the construction uses two E contacts, the three actual implications, and a fixed final parity. Negated literals use the constructed complements. Any Boolean relation can be written as the conjunction of clauses excluding its forbidden tuples, which proves the claim.

There is also a direct construction from its admitted tuples. For each r∈R introduce h_r, require their total parity to be odd, and impose the binary contact h_r=1 ⇒ x_i=r_i at every coordinate i. At least one row is selected, so x must equal that row. Each admitted x has the witness selecting just itself. Distinct admitted rows cannot both be selected, since they disagree at some coordinate. Hence the actual supporting row is unique when R is a set of distinct tuples. The empty relation uses contradictory fixed values, and the full relation uses an empty conjunction. QED

Only E, implication and the two fixed-value relations are needed for this construction. Complementation turns implication into any two-literal clause, so they generate the binary contacts used above. This extension has minimal new arity relative to VC23a: that original language already contains every unary and binary Boolean relation, and still fails on E. The minimality concerns this carrier and syntax, not the physical arity of every interaction or the arity of Swift's structural `Pair`.

The change is joint. Binary constraints alone retain the majority obstruction. Parity equations and fixed values alone are preserved by coordinatewise XOR of three solutions, while implication is not: 00,01,11 are admitted and their XOR 10 is refused. Each language therefore lacks something supplied by the other. Together they can encode arbitrary three-literal clauses by the displayed fixed-size construction. This connects to [Schaefer's constraint-language classification](https://www.khoury.northeastern.edu/home/lieber/courses/csg260/f06/materials/papers/max-sat/p216-schaefer.pdf). It supplies expressive completeness, not free decisions of arbitrary satisfiability problems. The witnesses are relations among simultaneous assignments, without prescribing a solver's traversal order.

**The threshold is not specific to parity.** Relative to the language containing all binary Boolean contacts, every additional relation R of finite positive arity has one of two effects. If R is majority-closed, it is already expressible and adds no expressive power. If it is not majority-closed, adjoining R permits every finite Boolean relation. There is no intermediate expressive class between this full binary base and the enlarged language. Nullary true and false are already expressible by an empty conjunction and contradictory fixed values.

For the first case, a majority-closed relation is exactly the set of tuples allowed by all its unary and binary projections. One inclusion is immediate. For the other, use induction on arity n. At n≤2 the projections contain the whole relation. For n≥3, each deletion projection is majority-closed and the induction hypothesis supplies a row matching the proposed tuple except possibly at that deleted coordinate. Choose three distinct deleted coordinates. The majority of those three rows is the proposed tuple, since every coordinate is correct in at least two rows. Thus the unary/binary projection constraints give an exact expression. An empty relation has an empty unary projection.

For the second case, let r¹,r²,r³∈R have a refused majority m. A constant column of these rows can be pinned. In every other column there is exactly one minority row, indexed j∈{1,2,3}. Replace that column by m_i XOR u_j, using equality or complementation according to m_i. This substitution defines a ternary contact T(u₁,u₂,u₃) from R and binary contacts. It admits the three unit vectors, corresponding to r¹,r²,r³, and refuses 000, corresponding to m. Its other four answers can remain unknown. Then

    x₁ OR x₂ OR x₃
      iff ∃u₁,u₂,u₃ : T(u₁,u₂,u₃) and I(u_i,x_i) for i=1,2,3.

For a nonzero x, a unit vector at any true position supplies a witness. For x=000, the implications force u=000, which T refuses. This proves the equivalence independently of the four unknown answers. Three-literal clauses, negation and hidden variables express clauses of arbitrary length, hence every finite Boolean relation. QED

The three admitted contacts and one refused majority therefore suffice to certify the expressive transition without identifying R's entire table. They must concern one fixed R with the stated arguments and available binary substitutions. Different preparations or mechanisms cannot silently supply the four entries of that one relation. This gives a short structural certificate for a change in the logical medium. It does not infer that the contact can be physically acquired or traversed in every satisfying direction.

**Carrier capacity and contact topology are part of the threshold.** Keep finite networks of unary and binary constraints, with Boolean visible coordinates. One hidden three-state coordinate, even with arbitrarily many Boolean hidden coordinates, cannot express ternary even parity. Two three-state hidden coordinates suffice. Thus VC23a's four-state minimum belongs to one centre, while the Boolean impossibility belongs to every hidden network over that carrier.

To prove the stronger lower bound, eliminate a Boolean hidden coordinate y. For fixed values of its neighbours, each incident constraint permits a subset S_i⊆{0,1} of y's values. Include its unary restriction U. The intersection U∩⋂ᵢS_i is nonempty exactly when every U∩S_i and U∩S_i∩S_j is nonempty, with U itself nonempty. Indeed, an empty intersection in a two-element set has a witness of at most two sets, one excluding each value. These tests become unary and binary constraints on the remaining neighbours, even when their carriers are larger. Repeating this elimination leaves a binary network on the three visible bits and the single three-state coordinate. Any visible-only constraint admitting all four parity rows is universal, since every unary and binary projection of those rows is full. Each value of the remaining hidden coordinate therefore permits a rectangle of visible tuples. A nonempty rectangle contained in even parity has only one tuple. Three values cannot cover four tuples. QED

For the attaining construction, let hidden h and k each have three states. Their binary contacts to the visible coordinates allow these rectangles, with * allowing either bit:

| Hidden state | Rectangle allowed by h | Rectangle allowed by k |
|---|---|---|
| 0 | (0,*,*) | (1,*,*) |
| 1 | (1,0,1) | (0,0,0) |
| 2 | (1,1,0) | (0,1,1) |

There is no h–k contact. Existence of both witnesses intersects their two unions of rectangles. At a=0 the k contacts force b=c. At a=1 the h contacts force b≠c. Exactly the four even-parity tuples remain. Two is consequently the minimum number of three-state hidden coordinates when additional hidden coordinates may only be Boolean.

Allowing arbitrarily many three-state hidden coordinates also restores every finite Boolean relation using binary contacts alone. A hidden selector h∈{1,2,3} with the three contacts h=i ⇒ x_i=1 expresses a three-literal positive clause. Boolean complementation and more such selectors supply the general clause construction. Encoding h by two bits does not refute the Boolean obstruction: a binary contact between h and x becomes a relation on those two bits and x, and need not have a binary Boolean expression. Changing the carrier changes the medium's expressive resources. None of these conditional capacity bounds establishes a new physical component or unrestricted acquisition of its state.

`Checks/ClosedInformation.swift` gives a finite type construction of the support gadget. A selected literal has an actual Lit1 source, while an unselected literal can carry any source value. The retained parity follows from the existing parity clauses, and its final reading binds the complete actual input list. Generic bodies cover a true literal at any of three positions and prove that appending an unselected literal preserves an earlier odd support and both retained lists. The arbitrary-contact construction reads 000 and the three unit entries from one actual table. Its other four entries remain generic. Two different completed tables therefore have the same proved clause capability while retaining a positive distinction at 111. The checks reject an invented true input, empty or even support, a restarted parity, a missing unit contact and an admitted 000. These are implications of the finite constructor grammar. The general preservation theorem and the expressive classification are proved above, without treating an arbitrary Pair conformance as a verified relation expression.

**Expressive completeness removes one source of forced prediction.** For the enlarged language and every nonempty P, VC23d makes P itself expressible, hence L_Γ(P)=P. Given only admitted examples, the language now forces no additional tuple. Every disjoint set of refusals can be accommodated by some expression. This does not invalidate any earlier source-supported law. It means that the expressive language alone no longer chooses that law. A universal VI representation must obtain its physical exclusions from retained contact facts and justified laws, rather than from inability to write alternative tables. Expressibility, existence of a satisfying assignment and agreement with the given source are three separate questions.

**VC23e (Exact admission, refusal and uncertainty under a language contract).** Retain VC23c's assumptions and suppose L_Γ(P)∩N is empty. The candidates are all Γ-expressible relations that contain P and avoid N. For any proposed contact b, there are exactly three cases:

| Condition | What every compatible representation establishes |
|---|---|
| b∈L_Γ(P) | b is admitted |
| L_Γ(P∪{b})∩N≠∅ | b is refused |
| Neither condition | One compatible representation admits b and another refuses it |

*Proof.* The first row follows from leastness. In the second, admitting b would force a forbidden tuple, while every candidate must avoid N. In the third, L_Γ(P) itself is a compatible representation refusing b, and L_Γ(P∪{b}) is a compatible representation admitting it. Thus the uncertainty has two witnesses and does not mean that no answer has yet been guessed. The first two cases cannot overlap under the consistency premise. If that premise fails, the whole specification is inconsistent and none of these verdicts may be extracted vacuously. QED

A forced refusal therefore has a certificate involving the admitted rows, the proposed row and a preserving operation producing one of the actual forbidden rows. The operation needs at most |P|+1 arguments, regardless of how many hidden variables an attempted representation introduces. VC23a's majority combines 110,101,011 into 111. Under the binary Boolean language, admitting 110 and 101 and refusing 111 therefore forces refusal of 011. This is a conditional consequence of the language contract and those givens. It is not an independent physical experiment on 011.

**Individually possible contacts need not share one possible law.** With only P={110} and N={111}, both 101 and 011 remain individually unresolved. The relation {110,101} is represented by a=1 and b≠c. The relation {110,011} is represented by b=1 and a≠c. Each satisfies the givens. No relation in the original grammar can admit both additions, since their majority with 110 is the forbidden 111. Thus the union of all individually possible admissions need not itself be a possible law. A family of alternatives must retain their joint compatibility. This connects the inverse language question to Matter M25a's distinction between individual and common feasibility.

**Two kinds of extension have opposite effects.** Additional sound contact evidence narrows the candidate family. Within a still-consistent specification, old forced admissions and refusals remain forced. Adding new primitives to the expression language instead enlarges the candidate family. It can revoke either kind of derived verdict, while preserving every explicit member of P and N. For example, making parity available permits {110,101,011} and removes the preceding derived refusal of 011. Merely applying a required parity constraint to a particular source would be a different operation: that narrows the source's admitted forms. Making a relation available in a language and requiring it at an actual contact must retain different roles.

For a language expressing every Boolean relation, the three-way criterion reduces to the explicit evidence: contacts in P are forced admitted, contacts in N are forced refused, and every other contact remains unresolved. A retained physical law can still force many additional answers. Its source and scope then carry those consequences. A framework that can represent arbitrary relations cannot obtain a particular world's extra exclusions from that representational capacity alone.

**VC24 (The residual needed for prediction).** For finite K and observation E,
let ≈ be the all-future relation obtained from E and a declared operation
family, including the empty continuation. For each current image e let g(e) count the distinct
≈ classes in its fiber. A residual alphabet allowing `(E,R)` to answer every
permitted future observation needs at least `max_e g(e)` values, and that
bound is attainable as an abstract encoding.

*Proof.* Two different behavioral classes in the same current fiber must
receive different residual labels, or a future answer would be ambiguous.
Conversely, number the behavioral classes separately inside each fiber.
Together E and that number identify the behavioral class and therefore every
future answer. The classes and numbering are assumed computed or supplied.
This cardinality proof gives no efficient discovery algorithm.

M35 priced exact recovery of every whole state by `max_e |E⁻¹(e)|` residual
values. VC24 can require fewer. Under identity dynamics, an unseen coordinate
may never affect any allowed answer. Under swap it can become necessary.
This reduces an agent's required predictive record. It does not authorize
erasing the remaining whole-state distinctions from Ω.

**Research interpretation.** A possible form of VI saturation is now precise:
a representation closes its declared future questions. Memory supplies a
missing predictive distinction, and compression removes distinctions that
those questions cannot use. Expanding the capabilities changes this boundary
by VC16. The controller and the question selection are themselves internal
variables when interpreting the construction physically. Claims about one
fixed observation map must be checked again when that map becomes dynamic.

This suggests investigating objects as families of distinctions whose reduced
updates are self-contained. The choice of observations and dynamics remains
explicit. The results do not derive that choice uniquely from Ω. A model that
claims an exact irreversible finite autonomous object inside an onto whole
fails VC20. One that claims unrestricted copying without memory preparation
fails VC22. One that accepts the odd-parity global record fails VC23. These
are concrete ways to refute an attractive interpretation.

## §6h. A distinguishing question is not yet a discovery procedure

VC24 measures how much a sufficient predictive record would need to retain.
It does not establish that an agent can acquire that record by one sequence
of interventions. The following finite game makes this extra obligation explicit.
A known table gives a finite carrier K, current observation E and total operations.
The initial state is unknown. After reading E, the experimenter chooses an
operation and reads E again. There is one evolving specimen, with no reset or
fresh copy. The goal is to identify its original state, not just its final one.
A physical realization must include the controller and its recording resources
within Ω. The table alone does not certify that realization.

**VC25 (A missing distinction has a bounded question witness).** Write N=|K|
and k=|E(K)|. If two states have different future behavior, some operation
word of length at most N−k distinguishes them.

*Proof.* Refine the partition of E by the observations after every word of
length at most r. A new round compares E and the previous classes of every
one-step successor. Equality of consecutive partitions implies stability
under all operations, hence equality of every future answer by induction.
Each strict round adds a class. Starting with k classes permits at most N−k
strict rounds. Every pair separated at the limit was therefore separated by
a word of at most that length. The empty word counts as the current reading.

The ordered-pair graph has finitely many vertices. A shortest path from (x,y) to a pair with unequal observations has no repeated vertex, since removing a repeated segment shortens it. Its operation labels therefore give a shortest separating word. This pair-specific witness need not provide one procedure that succeeds from every possible initial state.

**VC26 (Pairwise distinguishability need not give one successful experiment).**
Let E(A)=E(B)=E(C)=quiet and E(signal)=signal. Give the reduced system this table:

| Initial state | ask_A | ask_B |
|---|---|---|
| A | signal | A |
| B | A | signal |
| C | A | A |
| signal | A | A |

Every pair is distinguishable. The current reading separates signal from
the others. ask_A separates A from B and C, and ask_B separates B from C.
Thus the behavioral quotient has four classes.

Nevertheless there is no guaranteed identification strategy for the initial
quiet class {A,B,C}. If its first operation is ask_A, initial B and C both
become A with the same observed history. If it is ask_B, initial A and C
both become A with the same history. No later deterministic operation can
separate origins whose current states and available records coincide. Neither
possible first action permits success for every initial state. Stopping before
an action also fails on that class.

The quantifier difference is exact: `for every pair, some word` does not imply
`one observation-dependent strategy for every initial state`. This belongs to
the established problem of [adaptive distinguishing sequences](https://arxiv.org/abs/1902.01139).
The VI contribution here is the explicit boundary on what a future-sufficiency
certificate licenses, with a concrete refused discovery claim. Current-state
convergence can still be achieved by merging candidates, but that does not
identify the original state.

This does not refute the original fixed-target COMPARE game, where structural
comparison need not disturb its target. VC26 concerns the dynamic extension
with interventions on one evolving specimen. Reset, repeatable preparation or
a fresh specimen changes the experiment and needs its own witness.

**VC26a (A symplectic comparison record is mutual).** In the abstract game a
reversible comparison can leave its target unchanged: the permutation
(x,y)↦(x,y⊕f(x)) is invertible for every initial y and does not change x. A
finite-dimensional nondegenerate symplectic implementation restricts this. Let
the whole be a symplectic product of two parts: the recorder M together with
every memory, clock or controller it uses, and the target C. Let the comparison be a
symplectic map Φ(m,c)=(F(m,c),ψ(m,c)) on an open product. At each point,
D_cF=0 if and only if D_mψ=0: local differential dependence is mutual. On
connected open factors, this also gives equivalence of global independence
for the entire map
([UT80](../../../../Research/2026-10-10-use-leaves-a-trace.md)).
A physical record of the target that leaves the target independent of the
recorder therefore requires a failed hypothesis, for example a recorder
prepared on a closed layer, a disconnected class of targets, a degenerate
description, another comparison contract or non-symplectic dynamics. The
statement concerns two complementary parts of the whole. It does not assert
reciprocity between smaller subsystems.

**VC27 (Finite reversible operations preserve the possibility of discovery).**
If every available operation is a permutation of finite K, there is one preset
word whose complete observation trace distinguishes all behavioral classes.
If the behavioral quotient has m classes, a word of length at most
`(m−k)(N−k)` suffices.

*Proof.* Each operation induces a permutation on the behavioral quotient:
the quotient is stable, and VC20 makes its finite induced map bijective.
Start with current observations. If two different original behavioral classes
still have identical traces, their current classes remain different after
any word already executed. VC25 supplies a word of at most N−k operations
that separates those current states. Append it to the experiment. The new
trace separates at least one previously unresolved pair and cannot remove
any distinction already recorded. There are initially k trace classes and
at most m to reach, so at most m−k such extensions suffice. The construction
uses the known model to choose a fixed concatenated word, without knowing
the actual starting state.

This preserves whole behavioral distinctions, which is the part of physical
reversibility needed here. Finite permutations are a sufficient condition,
not a necessary condition for a particular successful experiment. Keeping the
whole state injective while allowing its inaccessible history to grow is a
different condition and does not establish this result, as VC29 shows.

Replace ask_A in VC26 by exchange of A and signal, and ask_B by exchange of
B and signal, leaving the other states fixed. Then the word ask_A, ask_B
works. The traces for initially quiet A, B and C are respectively
(quiet,signal,quiet), (quiet,quiet,signal), and (quiet,quiet,quiet).
The initially visible signal is already identified. Swift computes the two
post-action answers from the declared table through `TwoQuestionTrace<S>`.

**VC28 (A finite discovery policy has a checkable success or obstruction certificate).**
After a common observed history, a belief is the set of possible current
states, with their distinct initial identities tracked. If an operation merges
two candidates in that belief, a guaranteed original-state identification
strategy cannot use it: those candidates have the same next observation and
can never be separated within this model. If the operation is injective on
the belief, partition its successors by the next observation.

A singleton belief succeeds. A larger belief succeeds if some injective
operation has successful successor beliefs on every possible observation.
The least fixed point of this rule is exactly the beliefs admitting a finite
successful policy: induction on policy height proves both directions.
There are finitely many nonempty beliefs, so this fixed-point iteration terminates.
Each belief shares a common current observation. An empty candidate set is
not a successful identification.

A positive certificate gives each successful belief a rank and an action,
with all successor ranks strictly smaller, ending in singletons. A negative
certificate gives a family of nonsingleton losing beliefs such that every
action either merges candidates or has an outcome still in that family.
An attempted finite successful tree starting in this family must have a
branch remaining in it at every level, contradicting a successful leaf.
These local obligations can be checked without trusting the synthesis loop.
This is a finite deterministic guarantee. No noisy, probabilistic or reset
experiment is silently included.

**VC29 (A closed history can retain what its current scene cannot reveal).**
For any deterministic T on K, take whole states to be nonempty finite histories
h over K and define `F(h) = h followed by T(last(h))`. F is injective: removing
the last entry recovers the entire previous h. Its current-scene observation
satisfies `last(F(h)) = T(last(h))`, even if T is many-to-one. F is not onto:
a one-entry history has no predecessor. Thus no information loss in the
whole does not by itself establish a bijective dynamics on its full carrier.
The image is finite when K is finite, but VC20's onto premise fails for F.

There need be no external program or clock. Let the whole be `(p,h)`, where
p is a retained nonempty finite program of operation names. Its next action
is `p[(length(h)−1) mod length(p)]`. Append the specified successor to h and
retain p. The new whole determines the old whole by removing the last history
entry. Both instruction storage and the step index are internal. This fixed
autonomous rule describes any of the finite programs as different initial
configurations, rather than importing a controller from outside Ω.

The trap model can therefore have an information-preserving history extension.
After ask_A, B and C have different whole records but the same current scene.
With read access only to that scene and the original operation vocabulary,
its discovery obstruction remains. Granting history access changes the model
and can remove the obstruction. Retention, accessibility and controllability
must each have their own witness.

`RecordedFirstQuestion<S>: Permanent` stores the prior source and its computed
next state. The generic Swift checks recover both the old source and the new
current state. A separate refusal rejects identification of the B and C whole
records after their current scenes have merged. This models finite records
of unbounded possible length. It does not supply fixed memory capacity,
physical unitarity or a derived thermodynamic arrow. The append law already
selects an orientation and rules out predecessors at its boundary.

Both examples need three residual labels for predictive sufficiency inside their quiet class, yet their discoverability differs. Record size, pairwise distinction and a guaranteed single-specimen procedure are separate properties.

These results suggest a stronger development rule for VI: a proposed knowledge
claim should state what would distinguish its remaining candidates, whether
the required experiment preserves those distinctions until they are read,
and what internal record makes that preservation checkable. Discoverability
is an additional property of a question and an intervention protocol.

## §6i. Discovery of a verdict about an original state

VC28 requires original-state identification. VI2 and VC2 allow an exact answer
without identifying its source. The distinction persists when observations
require interventions. Fix a target map q on the original states of the known
finite model. The experiment must return q(x_original), which need not equal
q(x_current) after an intervention.

**VC30 (Question-preserving beliefs).** Represent uncertainty after an observed
history by a set of pairs `(current state, required original answer)`. Initially
these are `(x,q(x))`, grouped by the current observation. An operation T maps
`(x,a)` to `(T(x),a)`, then its observed result selects a branch. The answer
label is transported, not recomputed. Duplicate pairs can be identified.

A belief with one answer label is sufficient, even if it contains several
possible states or origins. A belief containing `(x,a)` and `(x,b)` for a≠b
is an obstruction: future observations and operations on x are identical,
while the required answers differ. Merging origins is therefore permitted
precisely when no different required answers are collapsed into the same
current state on that branch. This condition prevents immediate information
loss for q. It alone does not guarantee that a later successful experiment exists.

*Proof.* The initial pairs state the target question. Each intervention changes
only the current coordinate, so induction on a trace preserves the original
answer attached to every surviving origin. A single answer is consequently
correct for every remaining candidate. Two differently labeled instances of
the same current state have identical future responses under every chosen
operation, including choices made from those responses. No such experiment
can guarantee the two different required answers. This is relative to the
declared observations and operations, with no added history access or reset.

**VC31 (Guaranteed verdict discovery).** On these finite labeled beliefs, mark
single-answer beliefs successful. A nonterminal belief succeeds when some
operation has successful children for every possible next observation. The
least fixed point is exactly the beliefs admitting a finite guaranteed policy
for q. Beliefs with a conflicting pair at one current state are unsuccessful.

*Proof.* Induct on finite policy height in one direction and on the iteration
at which a belief is marked successful in the other. There are finitely many
subsets of `K × q(K)`, so the iteration terminates. Rank-decreasing success
certificates and closed losing families validate the result as in VC28, now
using single-answer leaves instead of singleton-state leaves.

If q assigns a distinct answer to every original state, this specializes to
original-state identification. If q is constant, no intervention is needed.
Both conclusions follow directly from the terminal condition. Only beliefs
reachable from the declared initial observation matter for its policy.

**An unfolded certificate needs no independent rank.** For a nonempty initial
belief B, supply a finite tree with the following two constructors. A leaf
returns a and requires every pair in its belief to have required answer a.
An internal node specifies one admitted operation T and has exactly one child
for every possible next observation o. That child's belief must equal

```
B_o = {(T(s), a) : (s, a) ∈ B and E(T(s)) = o}.
```

Only nonempty B_o occur in this exact form. Together the children cover every successor of B, and the displayed equality forbids dropping a difficult candidate, moving it to another observation, or recomputing its required original answer. The root beliefs are computed from the independent target q on the declared initial domain. The answer labels annotate possibilities for the verifier. They are not available inputs to the experimenter.

Exact belief reconstruction is sufficient, but soundness needs only coverage. A child may carry a finite overapproximation C_o with B_o ⊆ C_o, provided its certificate succeeds for every member of C_o and every possible actual observation has a child. Extra candidates can prevent a certificate from succeeding, but cannot make it return a wrong answer for an included actual candidate. The same applies to a root containing all declared initial pairs. This can avoid filtering a canonical successor set during certificate construction. The inclusion must preserve each actual pair's required answer. Replacing its answer label is not an overapproximation.

Each node is reached through its observation history. One action at that node
therefore serves every candidate still compatible with the same history.
It cannot depend on which hidden candidate is actual. The action must name
an admitted operation of the model. In a resident realization its occurrence
and source also need the relation supplied by `SelectedResidentTraceExtension`.
A shared output question alone does not select that occurrence.

Soundness follows by induction on the supplied finite tree. An actual candidate
belongs to the child selected by its next observation, with its original answer
unchanged. At a leaf the common answer is therefore correct. Every branch ends
because it enters a proper subtree. Conversely, a finite guaranteed policy
unfolds into such a tree by attaching the beliefs computed along its histories.
Assigning height to each subtree recovers the earlier rank certificate. A finite
rank-decreasing graph can in turn be unfolded into a finite tree, possibly
duplicating shared subproofs. Thus a separate numerical rank is unnecessary
for the unfolded representation. Finiteness here is a property of the supplied
constructor expression, not a consequence of arbitrary recursive `Pair` conformance.

This states the mathematical certificate independently of a search implementation. The Swift corpus checks transition traces and original-answer transport in `Discovery.swift`, actual reading selection in `ResidentExperiment.swift`, and source coverage with common answers through `CheckedCoverage`. A successful policy can return different answers in different children, whereas `CoveredJoin` certifies one common answer over its joined support. Those are different coverage obligations.

**Static successor coverage for one binary node.** `CoverDiscoverySuccessor` now binds a selected parent row `(s, a)` to its actual successor row `(T(s), a)` in the child support keyed by `E(T(s))`. The action is a path into the state's declared two-action table. Its path remains the same at every seam of the supplied `SequentialReading` composition, so different hidden parents cannot choose different actions, even when those actions happen to yield equal successor states. The quiet and signal child supports also remain fixed. Their distinct keys give one support per observable branch.

Each step removes one parent occurrence from the remaining proof obligations, using `CandidateRemoval`, while selecting membership in a child support without consuming that child occurrence. Thus several parents may reach the same child row. `CoveredDiscoverySuccessors` matches the independently declared parent support and requires an `EmptyCandidateSupport` remainder. For finite compositions of these steps and the existing finite selection constructors, induction on the composition proves that every declared parent has a covered actual successor with its original answer unchanged. This traversal discharges verification obligations. It is not an experiment performed separately on all possible origins, or a deletion of those origins from the physical whole. Endpoint equations on an arbitrary open `PredicateReading` do not establish this constructor interpretation.

**The empty remainder must preserve the distinction between a leaf and its payload.** The former `EmptyCandidateSupport` required only that both child types conform again. Since `CandidateLeaf<Never>` has two Never fields, adding a conformance for leaves with empty payloads was accepted. This supplied a concrete false completion: start with two addressed `CandidateLeaf<Never>` vertices, use the actual `AllocateIceVertex` constructor to allocate only the first, and pass the result to `AllocatedIcePorts`. The remaining second leaf was accepted as empty. This finite support and actual allocation step exposed a missing constraint in the emptiness condition.

`CandidateNode` now binds an associated `Leaf` in the original constructor conformance. A `CandidateLeaf<X>` supplies itself. A `CandidateFork` and Never supply Never at their root. `EmptyCandidateSupport` requires `Leaf == Never` as well as empty children. Thus a genuine leaf cannot become empty even when X is Never. A later local alias cannot replace the original associated-type witness used through the `CandidateNode` constraint. A default property on the empty protocol alone was insufficient: a constrained extension could shadow that alias. The tests separately exercise both alias shadowing and attempted conformance-witness replacement.

The resulting exclusion does not need finite depth. Along any finite child path from an empty support, each reached node still conforms to `EmptyCandidateSupport`. Its bound Leaf is therefore Never. Reaching a genuine `CandidateLeaf<X>` would require that nominal leaf type to equal Never, contradicting the constructor distinction. This is an induction on the inspected path, not on the depth of the entire graph. `LeaflessSupportCycle` consequently remains admissible: its two children return to itself and it contains no leaf on any finite path. It proves no terminal, finite unfolding or completed traversal.

For a finite declared support and a finite sequence of the actual removal constructors, this exclusion prevents completion with any leaf remaining. Both empty-payload occurrences must be removed, while their addresses and allocated ports remain distinct. `Checks/IceCoverage.swift` verifies the complete two-step allocation and refuses the false empty conformance, two alias overrides and a cycle containing a real leaf. These restrictions also protect Discovery's empty remainder. They do not turn arbitrary `CandidateRemoval` or `PredicateReading` endpoint claims into executions of the stipulated constructor rules. That source-binding obligation remains, including the direct checks in `FirstDiscoveryDecision` below.

`DiscoveryCoveredNode` instantiates the trap's first action for the question whether the origin was A. Parents B and C both use the same quiet child row `(A, no)`. The quiet support also includes an unused `(B, no)` row, demonstrating sound overapproximation. Its two terminal tags agree through `CheckedCoverage`. The signal support's terminal tag is yes. Separate compiler refusals reject an uncovered parent, a changed original answer, a wrong successor, a wrong observation branch, and a hidden-origin-dependent action. The common-answer proof is needed within each terminal support, not across the two branches.

`DiscoveryTerminalSupport` derives a terminal answer directly from the rows: a leaf supplies its original-answer field, and a fork conforms when both derived answers coincide. Induction on the finite support therefore gives the common answer without accepting an unrelated terminal reading as evidence. `AnsweredDiscoveryNode` uses these very supports in its successor-coverage equations and produces the selected action address together with the quiet/signal answer table. Its two answers need not coincide. Swapping the terminal supports breaks the coverage seam, and adding a conflicting target prevents the terminal conformance.

The two clauses `ReadQuietDiscoveryAnswer` and `ReadSignalDiscoveryAnswer` receive only an observation and this prepared table. `DiscoveryObservedAnswersMeetOriginalQuestion` composes the certified action's actual table transition, the next-state observation, and the matching decoder for each declared origin. All three outputs equal their original target fields. A signal decoder after an actual quiet observation fails the composition equation. The verifier uses target annotations to certify a table that works for every candidate. The resulting decoder does not receive an annotation identifying the actual origin.

**Adversarial admission and a direct finite check.** The open interfaces permit a positive forgery: `ForgedDiscoveryCompletion` declares the input with all parents and the output with an empty remainder, while assigning no to the signal branch. `AnsweredDiscoveryNode` accepts these endpoints. Its actual signal decoder then returns no where the independently declared original A row requires yes. The positive zero/successor witness establishes that difference. This does not make Swift derive an equality between distinct answers. It shows that endpoint admission cannot certify the claimed traversal of the constructor grammar. A new freely conformable proof marker would leave the same gap.

`FirstDiscoveryDecision` instead checks the existing three-row consumer directly. The first actual successor observation must be signal and the other two quiet. Their original target fields therefore determine the two table entries, and the latter two targets must agree. The proposed node must name these exact parent rows, the first-action address and this derived table. These are equations on the source and proposed output, with no supplied coverage or terminal witness used as authority. They are necessary and sufficient for that table in this explicit observation pattern. A bare correct table passes without any coverage story. The forged table fails, as do conflicting quiet targets and a substituted source pattern.

The execution check also binds the selected successor directly to the state's first table field. A freely declared `CandidateRemoval` can otherwise carry the right source and action address while naming a different successor. That forged selection now fails at the actual transition seam. Only the three current rows and their first successors enter this direct proof. Their state descriptions may have cyclic continuations: finiteness of the whole or of the unfolded transition graph is unnecessary. The original finite coverage constructions remain useful expressions whose soundness has the stated inductive interpretation. They are no longer the sole basis for admission of this concrete consumer.

This closes a one-action decision on that three-row source pattern with two nonempty observation branches. It does not seal public protocols or supply a checker for every finite policy tree. The table and its decoder clauses are prepared symbolic components, not an account of their physical manufacture. An arbitrary finite tree still needs nonterminal child composition and observation-history control, including unreachable branches if empty supports are represented. Initial target correctness and the interpretation of the declared transition table remain premises. The reduced observation path does not assert reversibility of the whole. VC29 and the resident acquisition relations address retention separately.

`SameActualReadingLeavesDifferentRequiredAnswers` checks identical actual readings after the first trap intervention while a zero/successor witness separates the required original answers. A refusal attempts to compose that available reading with a projection of the verifier's candidate answer tag. Its decoder expects the annotated candidate, not the actual observation, so the input equation fails. This checks a concrete obstruction to answer leakage. It is not a general policy-tree certificate.

In the trap of VC26, take q(A)=yes and q(B)=q(C)=q(signal)=no. Following a quiet
initial reading, ask_A gives signal only for original A. Original B and C
both become current A with observation quiet and original answer no. Their
merger is harmless for this question. Returning q(current A)=yes instead
would answer the wrong question. The initial signal is handled immediately
by its distinct initial observation.

By contrast, asking whether the original state was C cannot be guaranteed in
that same experiment model: ask_A merges B with C and ask_B merges A with C,
collapsing different required answers whichever first intervention is chosen.
Thus discoverability belongs to the pair of a question and a protocol. It is
not a yes-or-no property of the source table alone.

`AdvanceQuestionTag<C>` transports an answer tag with the evolving source. Preservation of the tag follows by projection. Its initial correctness remains a premise. A candidate tag is not an answer already accessible to the experimenter. Substituting a current-state answer for a different retained original-answer tag violates this relation.

A terminal belief may contain distinct source histories whose original-question labels all equal no. It then determines that verdict without determining the original source. Combining equal belief pairs reduces the question-specific record while their distinct origins remain in the whole. A realization retaining those origins is supplied by VC29.

## §6j. The experimenter is part of the experiment

A certificate writer may know a table and its target question without knowing
the actual original state. That distinction must survive implementation.
An original-answer annotation is a proof object, not a sensor reading.

**VC32 (A successful verdict policy compiles to observation-only control).**
Given the finite model of VC31 and a verified successful certificate, construct
a finite controller with a prepared boot state and one memory state for each
belief reached under the selected policy. Its boot transition reads E(x).
Each active memory state names one action. After that action, the next E(x)
selects the next memory state. Each terminal memory state names one answer.
Neither q(original) nor the actual original state is a controller input.

*Proof.* Initially E(x) chooses exactly its certified root belief. Inductively,
the stored memory names the belief obtained from the same observed history.
The action is fixed by that memory. Grouping its successors by observation
gives one branch for each possible reading, so the branch update requires
only that reading. Certificate ranks decrease until a terminal memory is
reached. Its answer agrees with every original candidate, hence with the
actual one. The belief labels and ranks justify the construction but need not
be present in the executable table. One boot step plus the maximum root rank
bounds the number of joint steps until an answer. This is a sufficient memory
construction, not a minimum-size controller theorem.

The resulting scene/controller pair has a single autonomous transition F:
boot acquires a reading, an active controller chooses and records a branch,
and a terminal controller keeps its answer. The fixed controller table is
part of this machine's transition law. It can equivalently be carried as an
unchanged program coordinate. No external sequence of choices is supplied
during execution. Preparing that table and boot state remains a premise.
This closes the control loop, but it does not establish that F is injective.

**VC33 (Reversible branches do not imply reversible feedback).** Let s(E(x))
choose an operation, and let every T_a be a permutation of K. Put
D_a={x:s(E(x))=a}. The feedback map F(x)=T_s(E(x))(x) is injective exactly
when the sets T_a(D_a) for distinct selected actions are pairwise disjoint.

*Proof.* Inside one branch, injectivity follows from T_a. Across branches it
holds exactly when the output images do not intersect. For K={0,1}, let the
reading reveal x, choose identity at 0 and bit-flip at 1. Both branches are
permutations, but both selected outputs are 0. The selected branch label
restores injectivity of the prepared-slice encoding
`x → (s(E(x)),T_s(E(x))(x))`: equal labels select the same invertible map.
For a controller with existing memory, its overwritten distinctions must
also be accounted for. Merely retaining the latest action is not a general
proof that the entire joint transition is invertible.

This is the familiar requirement that inverse branches have distinguishable
ranges. Bennett states the corresponding condition for reversible machines
and constructs computations that retain intermediate information before
recovering prepared workspace. No priority over that result is claimed.
[Bennett, 1973](https://www.cs.princeton.edu/courses/archive/fall06/cos576/papers/bennett73.html).

**VC34 (A prepared finite experiment has a finite reversible completion).**
Let z=(x,m) be the joint configuration of VC32. Fix H at least the bound on
completion, padding finished controller states with identity steps. For each
original x, form the prefixes h_t=(z_0,...,z_t), 0≤t≤H, of the deterministic
run beginning at z_0=(x,boot). Define the whole carrier to contain these
prefixes, and define U(h_t)=h_(t+1) for t<H and U(h_H)=h_0.
Then U is a permutation of |K|(H+1) whole states. During the first H steps,
the last-configuration projection follows the autonomous experiment exactly.

*Proof.* Prefixes from distinct originals differ at their first configuration.
Prefixes on one run differ in length. Each run therefore forms a disjoint
cycle of H+1 states. Its unique predecessor is obtained by shortening a
noninitial prefix or by taking the last prefix at the initial phase. History
length supplies an internal phase. Mergers of current scenes or controller
memories cannot merge these whole states.

The closing step is an abstract recovery transition of the whole after the
promised window. It need not belong to the agent's allowed scene operations,
and the agent is not granted access to hidden history. The construction
assumes prepared memory and sufficient finite capacity. It gives no locality,
energy or efficient implementation bound. It does not preserve an unbounded
number of distinct historical occurrences or an ever-growing archive.

There is a matching limit. If R is a forward-invariant set of a finite
permutation, U(R)⊆R implies U(R)=R, hence U⁻¹(R)=R. No state outside R can
enter it. Thus an initially unready finite reversible whole cannot acquire
a readiness property that is then maintained forever. A finite readout window
is compatible with reversibility. Newly acquired absorbing readiness requires
changing at least one of those assumptions. Terminal self-loops in the reduced
controller do not prove permanent storage in the whole.

`RecordedControllerStep` requires both actual input coordinates. Its retained whole then recovers the prior configuration and both updated projections. Observation-only access requires the controller's separate factorization through its observation and memory. Preservation of the whole alone does not supply that factorization.

## §6k. A certificate's scope under composition

**VC35 (Reuse must preserve the certified input scope).** Let D⊆X be the
certified input set and f,g:X→Y total components. Their agreement on D
survives a common deterministic suffix k:Y→Z, since equal outputs give
equal k-outputs. A prelude h:X→X is different. If Y has at least two values,
agreement on D implies agreement of f∘h and g∘h on D for every such pair
f,g exactly when h(D)⊆D.

*Proof.* If h maps D into D, substitute its output into the given equality.
If some x∈D has h(x) outside D, choose f and g equal on D and different
only at h(x). Then the composed outputs differ at x. This proves the
universal criterion. A restricted hypothesis family can support additional
inferences, as System CS3 illustrates. QED

For admissible preludes H, let R be the least H-closed input set containing
D. Equivalently, R is the union of w(D) over all finite H-words, including
identity. Agreement f|R=g|R is exactly safe replacement after every such
prelude from D when the component output itself is observed. Sufficiency
is substitution. For necessity, every r∈R is some w(x), so a difference
at r appears in that context. This is the input-scope form of VC15, not a
new claim that sample equality is an unrestricted program congruence.

The suffix here reads only the component output. Effects, timing or direct
inspection of implementation identity require their own state and observation
axes. For multiple substituted occurrences, R must also cover the operations
feeding each occurrence. Proving agreement on R need not mean measuring
every point independently: a sound structural argument can supply it.
Adding an allowed context can enlarge R. The old certificate remains true
on its old scope but does not automatically prove the enlarged statement.
A valid global R4 identification is not contradicted by this boundary.

*Closed counterexample.* On X={0,1,2}, f is identity, g swaps 1 and 2,
and h swaps 0 and 1. At D={0}, f(0)=g(0)=0. After h, their outputs are
1 and 2. With H={g}, R={0}. Adding h gives R=X. All these operations are
permutations. In the complete 36-state construction, Ω also contains the
resident f/g choice, the bare/prelude mode and phase 0…2. Phase 0 optionally
applies h, phase 1 applies the chosen component, and phase 2 wraps. The
inverse reverses the phase's chosen permutation.

With value prepared at zero and a uniform f/g choice, whole entropy remains
one bit. The bare ready output carries zero information about that choice,
while the prelude mode's output carries one bit. The changed experiment
reveals an internal distinction, without anything entering Ω. Readiness is
a finite window, and these tables give no physical energy or hardware bound.

`PostPairAgreement` derives a verdict after the specified output-pair context. Agreement about the first table reading does not imply agreement about the second reading or the whole table. Arbitrary effects and higher-order contexts require their own compatibility relations.

Program congruence is established semantics. See
[Software Foundations, Behavioral Equivalence Is a Congruence](https://www.cs.cornell.edu/courses/cs4160/2019sp/terse/plf/Equiv.html).
The specific finite scope argument is given above. No priority for contextual
equivalence is claimed.

## §6l. One question across different representation codes

The earlier certificates compare readings in a common declared encoding.
Transmission can change the representation code itself. A wire pair (h,x)
and a native pair (x,h) can preserve one payload question without being
the same record, and projecting the payload x need not retain h.

**VC36 (Compatible factorizations compose across codes).** Let A, B and C
be representation carriers with total questions q_A, q_B and q_C into one
answer set. Let t:A→B and s:B→C be total maps. Suppose

    q_B(t(a)) = q_A(a) for every a∈D_A,
    q_C(s(b)) = q_B(b) for every b∈D_B,
    t(D_A) ⊆ D_B.

Then q_C(s(t(a)))=q_A(a) for every a∈D_A.

*Proof.* For such a, t(a) belongs to the second certificate's domain.
Substitute b=t(a) in its equation and then use the first equation. Iteration
proves the result for every finite compatible path. Identity is the empty
path. Neither injectivity of t nor recovery of all of a is required. QED

The shared middle question must have the same interpretation in both
equations. Agreement of its name or of one observed answer is insufficient.
Also, individual correctness of the equations does not imply domain coverage.
For A=B=C={0,1}, let all questions be identity, t be identity, and s be
constant zero. The first certificate is valid on D_A={1}, the second on
D_B={0}, yet their proposed composition on D_A gives the wrong answer.
This is VC35's scope boundary applied to a representation path.

No new lattice protocol is needed for the construction. `AddressedRepresentation`
retains both a code and its data as distinct input addresses. `AddressedReading<R>`
embeds a supplied R in one tagged representation grammar: its input is
`AddressedRepresentation<R.Encoding,R.Left>`, its answer and semantic question
are R's, and its encoding is `TransportEnvelope`. The original encoding is
therefore retained in the input, not discarded by the common envelope.
Within the specified native, wire and scalar constructors, this is a disjoint
tagged domain with a defined decoder for each code. An arbitrary supplied
`PredicateReading` still needs its own semantic justification.

`JoinedFactorization<F,G>` conforms to `ReadingFactors` from the two existing
factorizations with the sole added premise `F.Right == G.Left`. It joins the
observations using `SequentialReading`. Equality of the outer answers follows
through the shared actual reading. Source, destination, model, encoding and
question addresses follow through the same seam. No final answer equality
is requested from its caller. `IdentityFactorization` supplies the empty path.
These generic bodies certify every finite path constructed this way.

Exact identity of the intermediate reading is a sufficient witness and is
stronger than semantic equivalence of two independently described readings.
The construction does not claim that nominal identity is the only possible
proof of a valid handoff. Supplying a justified equivalence would require
another witness. ReadingFactors' equations alone do not enumerate all sources
or prove the physical accuracy of a declared decoder.

The concrete generic path is

    (NativeLayout, (x,h)) → (WireLayout, (h,x)) → (ScalarLayout, x).

NativePayload reads the left coordinate, WirePayload the right, and
ScalarPayload its whole input. `LayoutFactorization` and `PayloadFactorization`
prove the same payload answer by expanding these projections for every
permitted pair. `Checks/Transport.swift` joins them, checks the outer endpoints
and retains the source code. Independent refusals change an input or output
code, output data, question, model, decoder, or intermediate source, and reject
promotion of payload agreement to source identity or hidden-field recovery.
Two different sources with the same payload give the same final image by a
generic witness, so full identification is unnecessary for this transfer.

**VC37 (A closed realization and the limit of end-to-end agreement).** A
finite whole can realize that path on a prepared slice while retaining all
source distinctions. Its complete state is (x,h,u,v,z,c), with five bits and
an internal phase c∈{0,1,2}. The native source is (x,h), the wire buffers are
(u,v), and the receiver buffer is z. At phase zero XOR (h,x) into (u,v).
At phase one XOR v into z. Phase two changes no bit. Each step advances c
modulo three. This is a permutation of all 96 complete states: decrement
the phase and repeat its XOR to invert the step.

Prepare u=v=z=0 at phase zero. The next wire is (h,x), and the next receiver
value is x. Source and wire remain inside the whole. All four prepared
source alternatives have different ready whole states, while the receiver's
two values cannot recover h. Thus a local lossy representation map can be
implemented within globally reversible dynamics under explicit preparation.
The model has no external clock, random tape or discarded residual. Readiness
is a phase window, without an endless supply of freshly blank buffers.

For arbitrary initial buffers, the next wire is (u⊕h,v⊕x) and the final
receiver is z⊕v⊕x. Under the fixed wire question that reads its second bit,
the intermediate payload is correct exactly when v=0. The final payload is
correct exactly when z=v. For v=z=1 the intermediate answer is wrong and
the final answer is right. Of 32 phase-zero states, eight exhibit this
cancellation. This establishes a strict distinction between end-to-end
correctness and the proposed factorization into locally preserving steps.
A direct certificate on this alternative preparation can be valid, while
certifying each intermediate reading under the original interpretation fails.
Changing the wire decoder to complement its bit would change that contract.

Matter M72 gives the complementary implication. An established endpoint recovery through a specified composition supplies an adequate middle decoder by composing the remaining process with the final decoder. `RecoveryBeforeSuffix` constructs this relation at the actual seam. That derived decoder can differ from the wire reading just tested. Endpoint recovery therefore forces sufficiency of a complete intermediate interface, while leaving the proposed local interpretation open to failure.

This supplies a limited bridge to The Cut. All participating records and
their transitions can remain internal to one whole while occupying different
relational roles. A transfer certificate preserves a stated question through
those roles. The existence of an interaction does not establish that it
preserves that question. The finite construction is not a physical law, a
proof of every proposed history commitment, or a hardware cost claim.

The general composition proof is substitution. The representation codes and projection semantics are supplied by the constructors.

## §6m. Saturation with a reason for every new distinction

VC15 defines the coarsest behavior-preserving quotient. A final partition alone does not explain why its distinctions are required. The certificate in this section supplies both directions: each added distinction is a future reading, and the resulting representation supports every declared operation.

**VC38 (Certified least autonomous refinement).** Fix a nonempty finite K,
a total reading E and a finite vocabulary O of total maps K→K. Start with
the single feature E, represented by the empty operation word. Maintain a
finite list of features E∘w_i, with words executed from left to right, and
let F be their joint reading. If F(x)=F(y) but F(Tx)≠F(Ty) for some T∈O,
choose a current feature E∘w_i that distinguishes those successors. Add the
feature obtained by executing T and then w_i before reading E. Stop when
every T preserves equality of F-images.

This procedure terminates after at most |K|−|E(K)| additions. Its final
kernel is exactly the behavioral equivalence of VC15, and its image carries
well-defined operations. It is therefore the coarsest autonomous refinement
of E, up to a change of class names.

*Proof.* The new feature distinguishes the selected pair, so each addition
strictly increases the number of classes. Every feature is a permitted
future reading of E, so behaviorally equivalent states are never split.
At termination, equal F-images have equal successor F-images under every
operation. They also have equal E-readings, since E remains a feature.
Induction on finite words therefore shows that equal F-images give equal
answers to every future E-question. The two inclusions identify the final
kernel. There are at most |K| classes, proving the bound. Each new word
prefixes one earlier word, so its length is at most the number of additions.
QED

Minimality is relative to the original reading and vocabulary. If an existing
record must be retained, include it in E. The result minimizes distinctions
among autonomous refinements of that E. It does not minimize feature count,
sensor cost, execution time or physical memory. Different valid witness
choices can produce different feature lists with the same final partition.

A refinement witness contains a pair, an operation and a previously admitted suffix word. The pair agrees under the old features and differs under the prefixed future reading. The final equivalence is exactly the common kernel of the admitted features. Thus every retained distinction has an observation witness. Together with the observation equation and one commuting equation per operation, this yields preservation for every finite word by induction. Extra distinctions and missing closure fail different premises. The transition system and its interpretation remain explicit inputs.

This is established finite-state semantics. The
[Cornell account of DFA minimization](https://www.cs.cornell.edu/courses/cs4120/2026sp/notes/leximpl/#dfa-minimization)
explains how distinguishing suffixes propagate backward through transitions.
Here the initial reading may have more than two answers, and the certificate
retains a reason for each refinement. No new minimization theorem is claimed.

Interference Is Substitution IiS19 supplies a finite-dimensional linear case
with an infinite state carrier. Backward closure of quantum effects stabilizes
by a dimension bound. Each added direction has two valid states that agree
on the old space and differ on a permitted future reading. Instrument branches
retain history probabilities, so averaging away their outputs does not certify
the larger family of outcome-dependent continuations.

**VC39 (Separate saturation need not cover mixed continuations).** Completing
one reading separately under O_1 and O_2, then combining the two completed
images, need not give an autonomous image under O_1∪O_2. The combined
vocabulary also permits mixed words absent from either separate completion.

*Counterexample.* Let K consist of four bits (a,b,c,r), let E=a, let O_1
contain the swap of a,b, and let O_2 contain the swap of b,c. The first
completion reads (a,b), and the second reads a. Their combined kernel still
reads only (a,b). Executing swap_bc and then swap_ab makes the next alpha
reading equal c. Thus (0,0,0,r) and (0,0,1,r) require separation despite
agreeing under both separately completed descriptions. The combined
completion reads (a,b,c): each coordinate is a future alpha reading, and
both swaps update that triple from itself. The retained fourth coordinate r
never affects an allowed future reading. There are eight classes of sixteen
states, so the completion still does not identify the entire source.
The restriction concerns the declared alpha question and its continuations.
Adding a question that reads r changes the completion to sixteen classes.
No claim that r is inaccessible to every possible internal interaction follows.

This does not contradict preservation under a union of operation sets when
the same partition is already stable under each set. That common partition
would be stable under their union. Here the two separately stable partitions
are different, and the more detailed one fails closure under the other swap.

For a whole with a resident schedule, add an internal phase in {0,1,2}.
Phase zero swaps b,c, phase one swaps a,b, and phase two changes no bit.
Each step advances phase. This fixed permutation has 48 complete states,
with r retained, and needs no outside action selector. Starting at phase
zero, sources 0000 and 0010 give observation traces (phase,a) of
`(0,0),(1,0),(2,0)` and `(0,0),(1,0),(2,1)`. The first two readings agree.
The mixed continuation exposes c on the third. Saturation under this one
whole transition yields 24 classes, retaining phase and a,b,c and ignoring r.
The construction is a finite logical model, without a new physical clock law.

The Swift witness uses the existing BeamShape coordinates as symbolic a,b,c.
`FullSpectrumReading` reads all three. `SpectrumFirstTransition` and
`SpectrumSecondTransition` give commuting squares for the two swaps by
computing source and image updates separately. `AppendSpectrumFirst` and
`AppendSpectrumSecond` are scoped aliases of the existing `JoinedTransition`.
They extend any matching certified path, supplying every finite interleaving
without additional path wrappers. `SpectrumAlphaFactors` retains the original alpha
question. Three generic equality witnesses show that each image coordinate
is alpha after the empty word, swap_ab, or swap_bc followed by swap_ab.
These are the two directions of the coordinate instance of VC38. This is
not a physical conversion model for spectral lines or a proof that nominal
BeamShape type identity equals coordinate equality.

The tool also reconstructs the entropy example of PiR M38–M40 automatically.
It starts with four cells on eight whole states and adds one future reading:
states 1 and 2 in the same clock phase give different readings after a tick.
The result is exactly the six-cell autonomous refinement previously proved
by hand. Splitting all eight states would be unnecessary, and a certificate
claiming that extra refinement without distinguishing features is refused.
PiR M41 separates this change of resolution from entropy change under time
evolution at a fixed resolution.

**Sufficiency is not acquisition.** These features are functions of a state
in the supplied model. Computing them from its full transition table does
not give an internal observer those values on an unknown actual state.
In `discovery_trap.json` the completed partition has four singleton classes,
yet no allowed single-run policy identifies the initial state (VC26, VC28–VC31).
Different distinguishing experiments cannot automatically be performed on
the same unchanged specimen. A measurement strategy, retained memory, reset
or reversible completion requires the separate constructions of §§6h–6j.
The whole-system principle locates those resources internally, without
supplying them by the act of naming a feature.

## §6n. Acquisition and reuse are type relations

A generic constructor supplies the related axes, and its body satisfies the conclusion under the stated premises. Recording, refinement and retained access are these relations themselves.

**VC40 (A recorded question factors through its fact).** Given a declared reading R of source S, construct a fact containing only R's space, encoding, question and answer. The complete record pairs S with that fact. Its source projection recovers S, and its fact projection can answer the original question.

`RetainedReadingRecord` binds the stored fact to the actual reading and source. `RecordReading<R>` supplies this relation. The fact is `AnswerFact<Sigma,Encoding,Question,Answer>`, a sealed payload conforming to `HasVerdict`. Its generic arguments and associated types contain no original-source coordinate. It is not itself a `PredicateReading`: the question is not a substitute source. In particular, two two-input sources with equal first answers produce the same first-fact type even if their second fields differ. `EqualFirstFacts` checks that equality for arbitrary such source pairs.

`RecordedAnswerReading` reads the fact's answer and preserves its question and encoding. `ReadRecordedAnswer<F>` requires only F's `HasVerdict` axes; its actual source is the payload F. Reading that payload establishes what it contains. The link to an original source belongs to `RetainedReadingRecord` and `AcquiresAnswer`. `AcquireAnswer<R>` conforms to `AcquiresAnswer`, hence `ReadingFactors`, by constructing the record, its fact observation and the fact decoder. Its caller supplies R and the structural source bound, not equality of the direct and recorded answers. The compiler derives that equality by projection. This represents an internal acquisition relation with a retained whole, using pure types under Law §0′.

> Argues: ``RetainedReadingRecord`` needs ``Permanent``. The whole's source projection recovers the input beside the new fact.
> Argues: ``RecordedAnswerReading`` needs ``PredicateReading``. The fact is the actual decoder input, and its question and answer determine the reading's context and output.
> Argues: ``AcquiresAnswer`` needs ``ReadingFactors``. The record observation connects the direct source reading to the fact decoder.

**VC41 (Evidence refinement preserves a decoded answer).** Suppose F factors a question q through an observation E. Suppose G factors E itself through a richer observation H: G.Left is exactly F.Observation. Then q factors through H. Its decoder first recovers E's image through G.Right and then applies F.Right.

`EvidenceRefinesQuestion` binds that complete seam. `AnswerOnRefinement<F,G>` constructs the composed decoder and conforms to `ReadingFactors` under the seam premise alone. `RefineAnswer<F,G>` supplies this constructor as the conclusion of `RefinementPreservesAnswer`. The result's direct question is F.Left, its observation is G.Observation, and its decoded answer equals F.Answer. No equality of final answers is requested from the caller. `JointEvidenceRetainsFirst` supplies a generic example: an additional reading of the same source extends the evidence while its first projection recovers the old reading.

> Argues: ``EvidenceRefinesQuestion`` needs ``Pair``. Its sides are the earlier factorization and the recovery of that factorization's observation.
> Argues: ``RefinementPreservesAnswer`` needs ``EvidenceRefinesQuestion``. The recovery seam supplies the intermediate image required by the composed decoder.

This is a constructive scope rule. It supplies the decoder that justifies reuse under refined evidence. It does not assert that matching raw bytes prove compatibility or that every valid scope relation must have this particular representation. A different source, question or encoding cannot silently replace the stated seam.

Matter M55 uses the same composition to test a closed recovery chain. If its final observation is exactly its initial reading, the remaining legs construct the reverse of any chosen leg. Therefore an established strict gain cannot occur on that cycle. `RecoveryCycleDerivesReverse` checks the actual closing seam, and its positive repeated-evidence construction shows that different layouts can still have equal recoverable content. No new refinement principle is needed.

**VC42 (A certified question is already readable from its evidence).** An `ObservationTrace` relates a source to its memory. `StartObservations<S>` uses the empty memory Never. `AppendObservation<T,R>` retains T's memory and adds R's source-free fact, with R tied to the same source. The resulting memory contains the extension itself.

Let F: ReadingFactors and T: ObservationTrace, with F.Left.Left == T.Left and F.Observation.Answer == T.Right. F already contains its decoder F.Right. The factorization gives F.Right.Left == T.Right, F.Right.Predicate == F.Left.Predicate and F.Right.Answer == F.Left.Answer. These equalities follow by substitution from the two matching endpoints and the factorization equations.

`AnswerInTrace<T,F>` names exactly F.Right under these premises. It is a constrained typealias. The complete reading type, not only its answer, is identical to the decoder already in the certificate. A second application object, output trace or verdict flag would duplicate information for this question. The memory is the existing decoder input, and no larger memory is required by the derivation.

Source compatibility still matters even when two memories coincide. The same first fact can belong to a constant pair or an unrestricted pair. A certificate about one source does not become a certificate about the other through payload equality. The scope conditions belong at the naming relation, while the named reading remains F.Right.

Among admissible pairs (T,F), pairs with the same decoder F.Right have the same scoped reading type. This projection identifies the reading while the contexts and their witnesses can remain distinct in the whole. It uses equality of the actual decoder type. Identifying every semantically equivalent decoder would require a further relation.

> Argues: ``ObservationTrace`` needs ``Pair``. The trace relates the source to its recorded evidence.
> Argues: ``EmptyObservationTrace`` needs ``ObservationTrace``. Its memory is the empty floor for a specified source.
> Argues: ``ExtendedObservationTrace`` needs ``ObservationTrace``. Its memory contains the previous memory and the newly recorded fact.

This is a relation of sufficiency. A claim about the duration or energy of a physical use requires a specified cost model.

**A family witness.** For T: Null, T.Left == T.Right. `ConstantSecondFactors<T>` derives the second answer through the first reading. `ConstantSecondFromTrace` reads it from the stored fact. Any further use of that certificate names the same one-fact memory.

For a general two-input Pair, that conclusion does not follow. The generic negative witness `RejectedUnmeasuredSecond<T>` attempts the same factorization with only T: Pair and fails to compile. The concrete source `(Quiet, Signal)` shares its first fact with `(Quiet, Quiet)`, so the first fact cannot distinguish their second answers. Adding the actual second observation settles its second answer. `RetainTraceAnswer` also carries the old first-answer certificate through the retained memory prefix. Both later answers reuse a trace containing exactly two observations.

**Retained answers need no uniform context across all facts.** Suppose q(x)=d(E(x)) in the original question's context. Extend that same source's memory to H(x)=(E(x),f_r(x)), where the additional fact f_r has its own space, encoding and question. Then q(x)=d(π₁(H(x))). This follows from π₁(H(x))=E(x) and the original factorization. No value or context of f_r enters the decoder. The old memory, source and decoding relation are retained, so this is no translation of r into q's context.

`TraceEvidenceIn<T,S,E>` exposes the constructed memory in the context of a supplied decoding path. It leaves every fact's original verdict coordinates intact. `TraceEvidence<T>` names the case using the latest reading's context. `RetainTraceAnswer<T,F>` uses F's original context and `PrefixMemoryAnswer` to reach its actual old input. It requires the same source and the actual retained prefix, with no equality between F's context and the new reading's. The general witness `RetainedTraceUsesOriginalReading` derives the complete original reading under these two premises. `MixedTraceAnswersFromOneMemory` and `MixedTraceKeepsBothContexts` construct two source readings with the same question and answer but different spaces and encodings. Both answers are readable from one trace, and their original contexts remain different. The attempted `ComparedReadings` conformance is refused, as are a substituted source and the wrong old memory.

This corrects an unnecessary restriction in the earlier constructor: choosing the latest fact's context for every use of memory made retention demand that all appended readings share it. Coexistence requires neither a global reinterpretation of the facts nor agreement between their questions. It also supplies no general common acquisition of incompatible physical measurements: `AppendObservation` still requires declared readings of the same source, whose physical availability must be established separately.

The source, memory and operations are related within one type-level whole. There is no runtime learner supplied with a hidden source index. The input reading is still an explicit premise: the concrete table constructors derive its answer by field projection. Certifying a physical sensor requires establishing its reading relation.

**VC43 (Stored disagreement does not supply an invariant answer).** Let P and Q be two `HasVerdict` payloads that are also `Structure`, with identical space, encoding and question. Their pair is a well-formed record. `ReadRecordedAnswer<P>` and `ReadRecordedAnswer<Q>` recover their respective answers and meet `ComparedReadings`. None of these relations requires P.Answer == Q.Answer. Joining these readings under `VerdictIsInvariant` does require that equality.

*Derivation.* The pair preserves both payload addresses. Each decoder projects the four verdict coordinates from its own input. The three assumed context equalities establish comparability. Invariance adds equality of both projected answers to one answer. Taking P.Answer = Quiet and Q.Answer = Signal gives a record and comparable readings, but no such invariant join for these distinct answer types. If the answer types coincide, `JoinedVerdict` supplies the join under precisely the remaining context equalities.

The Cut §18 distinguishes the existence of conflicting records from settlement in one answer. Here this distinction is expressed without a new truth-value type or a contradiction evaluator. The facts can originate in different sources; their coexistence does not assert that one source has both answers to one reading. Even when records purport to concern one source, reading their contents and certifying their accuracy remain different relations. This construction does not establish a paraconsistent logic or a simultaneous valuation of every possible observation. It specifies which relation is present and which stronger relation is absent.

The constructors are in `Sources/Examples/Acquisition.swift`. The generic consequence witnesses and nearby incompatible constructions in `Checks/Acquisition.swift` distinguish preserved evidence from a wrong answer, retargeted question, substituted source, missing fact or discarded prefix. They also distinguish a readable payload from a source reading, and comparable stored answers from an invariant verdict.

Sections 6a–6m retain their own mathematical and encoding premises. A historical finite enumeration does not become a general type proof because this section has been added. Untranslated probabilistic and optimization results remain separately identified research results.

## §6o. A finite relation basis for unbounded continuations

**VC44 (Complete image equality is exactly the two-swap behavioral relation).**
Use the symbolic BeamShape interpretation of §6m. The question reads alpha.
The allowed operations are SwapVisible, which exchanges alpha and beta, and
SwapBetaHidden, which exchanges beta and the third coordinate. For any two
sources A and B, equality of `FullSpectrumImage<A>` and `FullSpectrumImage<B>`
is equivalent to agreement of the alpha question after every finite word
over these operations, including the empty word. Nominal source equality
is not a premise.

*Derivation.* Write the image as (a,(b,c)). The two image operations give
(b,(a,c)) and (a,(c,b)). Equal input images therefore give equal output images
under either operation. Induction on finite words preserves this one relation
under every mixed continuation, and projecting alpha gives the required
answer. Conversely, agreement after the empty word identifies a. Agreement
after SwapVisible identifies b. Agreement after SwapBetaHidden followed by
SwapVisible identifies c. The three coordinate equalities identify the image.
These two directions establish the VC15 relation for this vocabulary.

`SpectrumFirstAgreement<A,B>` and `SpectrumSecondAgreement<A,B>` name
`JoinedVerdict` certificates on the respective successor readings. Their
only additional premise is equality of the complete input images. The
compiler derives their output agreement from the projection definitions.
They introduce no new certificate wrapper or protocol. The generic bodies
establish the two generator steps, and the argument above supplies induction
over the finite constructor grammar. No bound or enumeration of source types
or word lengths is used.

For every B, `SwapVisible<SwapVisible<B>>` has B's complete image. Both
continuation certificates apply to this pair, although the two source type
expressions differ. A refusal of their nominal equality does not supply a
distinguishing alpha experiment. It checks a stronger, different relation.
In particular, the nested Swift spelling is not by itself evidence of a
physical historical trace.

There are two distinct composition questions. `JoinedTransition` connects
the actual source-reading endpoints of one encoded path. Equality of images
does not satisfy its exact intermediate-reading premise, even for sources
equivalent under VC44. The image operations, however, compose directly on
the common image: their outputs do not depend on which source representative
supplied it. Thus a path of observable images requires no chosen source
representative. It does not reconstruct a particular source history.

`ImagePathMayChangeRepresentative<A,B>` checks this directly. Its premise
equates B's image with the image after swapping A. `SequentialReading` then
composes the first image swap with the second image swap using B's image.
Its result equals the image of the corresponding two-step continuation of A.
The generic witness requires no identity between B and the intermediate
source. The concrete triple-swap representative is accepted here and refused
as a substitute endpoint of `JoinedTransition`.

The smaller visible image fails a different test. RedBeam and RedBeamWithIR
agree in alpha and beta, but SwapBetaHidden followed by SwapVisible exposes
their distinct third coordinates (VC39). This is an actual distinguishing
continuation in the declared vocabulary, whereas the double-swap pair has
none. Extending the questions beyond alpha and its two-swap continuations
requires checking the resulting relation again.

This is a concrete bridge to The Cut: what a local reading can identify is
determined by the relations it must preserve inside the whole. Saturation
here is closure of those relations under the allowed continuations. It does
not require naming every source or adding a record for every future word.
Acquiring an unknown source's image remains the separate obligation of VC40.

**VC45 (A future question factors through the present image).** Let P be a
`CommutingTransition`, possibly a composed path. Let F factor a question
through its final observation: F.Observation == P.Right. The future question
first follows P.SourceStep and then reads F.Left. Its answer factors through
P.Left, the present observation. The decoder first follows P.ImageStep and
then reads F.Right.

*Derivation.* The source step ends at P.Right.Left, which is F.Left.Left.
The image step ends at P.Right.Answer, which is F.Right.Left. The final
answers agree by F. Both composed readings therefore have the question
`OperationSequence<P.Operation,F.Predicate>`, matching contexts and matching
answers. Their initial inputs are P.Left.Left and P.Left.Answer, so P.Left
connects them as required by ReadingFactors. These are projections of the
premises, with no new final-answer equality assumed.

`QuestionAlongTransition<P,F>` supplies this factorization using the existing
`SequentialReading` constructor on each side. The operation is retained in
the question: a future alpha answer is not silently relabeled as present
alpha. If G factors P.Left through an acquired fact, VC41 then gives
`AnswerOnRefinement<QuestionAlongTransition<P,F>,G>`. Its decoder accepts
that fact and answers the same future question.

The generic instance in `Checks/Continuation.swift` acquires
`FullSpectrumReading<B>` for a structural BeamShape source B. The path
exchanges beta with the third coordinate, then alpha with beta. A final
`SpectrumAlphaFactors` supplies F. The composed decoder's input is exactly
`FactOf<FullSpectrumReading<B>>`, and its answer is B.PaschenLevel. A fact
containing only the initial alpha answer cannot replace that input. The
metameric pair of VC39 supplies the distinguishing counterexample.

This derives an answer relation, without advancing the physical source,
appending a second observation, or asserting that its path actually occurred.
For a specified possible path it answers a conditional future question.
Predicting the actual next event additionally requires the appropriate
connection between that path and the whole's resident dynamics or controller.
The original acquisition relation remains an explicit premise.
The physical work of establishing or reading the derivation also belongs
inside the whole. The type relation does not give that work a zero cost or
identify it with the modeled source transition.

## §6p. Availability is part of the relation

The total operations of VC15 and VC44 have no unavailable inputs. A partial
interaction needs another condition. Its successful output equations alone
do not specify where it may occur. In the following claims K is a declared
carrier, E:K→I is a total reading with I=E(K), and T:D→K is a partial
deterministic operation. These are premises of this fragment, not a claim
that all interactions of reality share one classical state assignment.

**VC46 (Exact descent preserves the operation's domain).** There is a partial
image operation V with domain E(D) that satisfies both

    x∈D exactly when E(x)∈dom(V),
    E(T(x)) = V(E(x)) for x∈D,

if and only if

    D = E⁻¹(E(D)),
    x,y∈D and E(x)=E(y) imply E(T(x))=E(T(y)).

The first condition says that each image fiber is entirely available or
entirely unavailable. The second says that available representatives give
one successor image.

*Proof.* An exact image domain gives D=E⁻¹(E(D)). A single-valued V requires
equal images in D to have equal successor images. Conversely, define V on
E(D) by V(E(x))=E(T(x)). The second condition makes this independent of the
representative. The first supplies exact domain reflection. The image map
is unique on E(D). QED

The existing CommutingTransition equations express an output square for
presented applications. They do not by themselves quantify over disabled
sources or impose domain reflection. For a symbolic triple (a,b,c), let T
exchange a and b only when a=c. Let E read (a,b). Every successful step has
the image update (a,b)→(b,a). Yet (1,0,1) is available and (1,0,0) is not,
despite their equal images. No partial operation on this E-image can have
the exact source domain. Matching the output on all successful inputs does
not repair the missing distinction.

The complete image (a,(b,c)) carries the domain through its own relation
a=c. `MatchedSwapSource` requires equality of the resident source fields.
`MatchedSwapImage` requires equality of the corresponding image fields.
`MatchedSwapTransition` constructs the output square from the source
condition. `AvailableStepTransfers<A,B>` derives availability and successor
agreement at B from availability at A and equality of complete images.
Interchanging A and B supplies the reverse implication. The condition is an
equality, with no independent Boolean permission coordinate.

At the successor, the condition is b=c. The source (1,0,1) therefore permits
one step and then blocks another. `TwiceMatchedSwap` requires both a=c and
b=c, and composes the existing transitions. A successful earlier step is
not a witness of availability at its changed successor. `AlphaAfterMatchedSwap`
uses VC45 to name the guarded future question. Its operation label differs
from the total swap, even when a total extension gives the same answer value.

**VC47 (Partial behavior preserves both availability and answers).** Fix a
family Q of total observations on K and a vocabulary O of partial
deterministic operations. For each finite word w, let D_w be the sources
where every successive operation is defined. The empty word has domain K.
Define x≈y when, for every w,

    x∈D_w exactly when y∈D_w,
    if x,y∈D_w, then q(w(x))=q(w(y)) for every q∈Q.

This is the greatest equivalence relation that preserves Q, preserves
availability of each operation, and relates successors whenever the
operation is available.

*Proof.* Equality of word domains and of the defined observations is
reflexive and symmetric. It is transitive because a common middle source
transfers membership in every D_w, after which answer equality is transitive.
The empty word preserves Q. Prefixing an available T to any continuation
preserves both its domain membership and its answer, so x≈y implies
T(x)≈T(y) whenever T is available. Conversely, a relation with these three
properties preserves domains and related successors along each word by
induction. Observation preservation then gives every required equality.
It is therefore contained in ≈. QED

The quotient carries partial operations [x]→[T(x)] with representative-
independent domains and results. This extends VC15 within the declared
partial deterministic fragment. No answer is assigned to an unavailable
word. An implemented attempt that returns an error would be an additional
specified interaction with its own record, rather than a conclusion of
this partial relation.

**Ignoring unavailable words can destroy transitivity.** In the guarded-swap
model, take x=(1,1,1), y=(1,0,0), z=(1,0,1), and q=alpha. The only word
available at y is the empty word, and all three initial answers are 1. A
comparison confined to words available at both endpoints therefore pairs
x with y and y with z. But the single swap is available at x and z and
gives answers 1 and 0. Those endpoints disagree. This weaker comparison is
not an equivalence relation and cannot define a quotient by identification.
Unavailable is not a wildcard answer that agrees with everything.

The generic witnesses and nearby refusals are in `Checks/Interactions.swift`.
They check the source and image conditions, transport through equal complete
images, the changed successor condition, and reuse of an acquired full-image
fact through VC41. The concrete counterexample above supplies the reason
for the failed transitivity claim. These checks concern the stated
constructor interpretation. An unrelated conformance or a compiler failure
does not establish global physical unavailability.

The complete triple is sufficient for this construction. It is not claimed
minimal for the guarded vocabulary: at an unavailable source with no other
operations, only the initial alpha question can be asked, so additional
coordinates may be irrelevant. Which distinctions can be omitted depends
on both future answers and the actions that remain possible.

## §6q. The smallest image for a partial interaction

The guarded swap has a smaller sufficient image than the complete triple.
Fix the carrier K={0,1}³, the present question q(a,b,c)=a, and the sole
action T(a,b,c)=(b,a,c), available exactly when a=c. The binary carrier is
an explicit local restriction. No binary valuation of every relation in
the whole is assumed.

**Claim VC48 (a structural obstruction to the guard).** In the declared
numeral grammar, zero and a successor have distinct outer constructors.
An ordered pair of these constructors, with its endpoints equal to the
source's a and c, therefore witnesses that the equality guard cannot hold
there. Reversing the pair gives the other orientation.

**Proof.** Zero is `Never`; a successor is `Examples.Succ<N>`. These are
distinct nominal type constructors for every admissible N. Equality of
their internal fields would not identify the constructors: in particular,
the two fields of `Succ<Never>` are both `Never`, while the successor itself
is still distinct from `Never`. Substituting the source coordinates into
the ordered pair gives the claimed obstruction at that source. ∎

`ZeroSuccessorDistinction<N>` carries this pair. The two blocked-class
readings bind its endpoints to their actual source fields by `where`;
the reverse orientation uses the existing `InternalSwap`. This is a
positive constructor witness in a specified grammar. An absent conformance
alone supplies no such witness, and these constructors do not decide
inequality between arbitrary `IntegerValued` conformers. For the binary
carrier, N is `Never`, so the two orientations cover every unequal guard.

**Claim VC49 (six classes are necessary and sufficient).** The behavioral
equivalence of VC47 on this carrier has exactly six classes. Write D(a)
for an unavailable image retaining the present answer, and R(a,b) for an
available image retaining both the present and the next answer. Define
E(a,b,c)=D(a) when a≠c and E(a,b,c)=R(a,b) when a=c.

| Source | Image | Image after T |
|---|---|---|
| 000 | R(0,0) | R(0,0) |
| 001 | D(0) | unavailable |
| 010 | R(0,1) | D(1) |
| 011 | D(0) | unavailable |
| 100 | D(1) | unavailable |
| 101 | R(1,0) | D(0) |
| 110 | D(1) | unavailable |
| 111 | R(1,1) | R(1,1) |

**Proof of sufficiency.** Every source has exactly one of the displayed
images. The present answer is the first coordinate in either form. The
guard holds exactly at the R images. At R(a,a), swapping leaves the image
unchanged and the action remains available. At R(a,b) with a≠b, the
successor has first coordinate b and third coordinate a; its guard fails,
so its image is D(b). These equations give an exact partial image action
and preserve the present question. Induction on the length of a finite
word now preserves both availability and every defined answer: the first
action has the same domain on source and image, and the same conditions
hold at its successor. Thus E preserves all continuations in VC47. ∎

**Proof of necessity.** Images with different first coordinates are
distinguished by the present answer. For the same first coordinate, D(a)
and either R(a,b) are distinguished by availability of T. The remaining
pair R(a,0), R(a,1) is distinguished by the answer after T, which is 0
at the first and 1 at the second. These cases exhaust pairs of distinct
images. Consequently every representation preserving these questions and
domains must distinguish all six classes. Together with sufficiency this
proves exact minimality, without counting the output of a program. ∎

The type forms are `BlockedAlpha<A>` and `ReadyAlpha<A,B>`. Their difference
carries availability; a blocked image cannot be replaced with an ordinary
alpha fact, since that fact alone can also be acquired at an enabled
source. Both forms reuse `ReadRecordedAnswer` for the current question.
Three image-step constructors express the equal, zero-to-successor, and
successor-to-zero cases. Generic `CommutingTransition` witnesses derive
their output squares from source-coordinate premises. The source carrier
and completeness argument are the ones just declared; an open Swift
protocol does not seal all possible conformers to the binary carrier.

This gives a relative minimum, not destruction of the remaining physical
distinctions. The two sources represented by D(0) remain different sources;
their omitted coordinate cannot affect the declared question or any
available continuation. A question about that coordinate, another action,
or an interaction that inspects the stored past would change the family
and could split this class. The cut specifies which distinctions the
interaction requires. It does not identify its image with the whole.

## §6r. A class recovered from acquired evidence

The six-class image of VC49 can be obtained from the complete image without inspecting the source again. This is a relation between readings. An algorithm selecting a class at runtime is not required to state it.

**Claim VC50 (evidence can supply a derived class and its questions).** Let O:K→I be an observation, d:I→C a class decoder, and E=d∘O. Suppose A:K→M describes an acquired record with a decoder u:M→I such that u∘A=O. Then E=(d∘u)∘A. If an independently specified question q:K→V factors as q=r∘E, it also factors as q=(r∘d∘u)∘A.

**Proof.** Substitute u∘A for O in E=d∘O, then substitute the resulting expression for E in q=r∘E. The composed decoders take M as their input. Neither substitution requires another application of O. The equation q=r∘E remains a premise about the independently specified question. Defining E by composition would not prove it. ∎

In the binary fragment, O(a,b,c)=(a,(b,c)). The three class-decoder clauses are

- d(a,(b,a))=R(a,b).
- d(0,(b,1))=D(0).
- d(1,(b,0))=D(1).

They cover the carrier with disjoint domains. Their equalities or positive constructor obstructions are read at image coordinates. `ReadySpectrumClass`, `ZeroBlockedSpectrumClass`, and `SuccessorBlockedSpectrumClass` express these clauses. The source classifications now name `DecodeRefinedEvidence` compositions through `FullSpectrumReading`. They contain no second classification definition.

`QuestionOnObservation<O,Q>` supplies the factorization of the source question defined by that composition. `ReadyAlphaFactors` and the two blocked alpha factorizations separately derive agreement with `SpectrumAlphaSource`, whose definition is still the source's first coordinate. `AnswerFromAcquiredObservation` is an alias of VC41's `AnswerOnRefinement` with `AcquireAnswer`. Its decoder consumes an `AnswerFact` for the complete image. The fact has no source type parameter. The acquisition certificate still binds that fact to the reading that produced it.

These two statements must coexist: equal complete images can have exactly the same fact-decoder type, while a certificate for acquiring an image at one nominal source is not a certificate for having acquired it at another. Shared content does not move the acquisition event. VC50 derives sufficiency from a supplied acquisition relation. It does not infer that an internal participant has physically performed the acquisition.

## §6s. Composing changes of representation

**Claim VC51 (exact partial descent composes).** Let T:D→K descend exactly through E:K→I onto V:E(D)→I in the sense of VC46, with I=E(K). Let V descend exactly through H:I→J onto W:H(E(D))→J, with J=H(I). Then T descends exactly through H∘E onto W.

**Proof.** Domain reflection for H says H(E(x)) belongs to dom W exactly when E(x) belongs to dom V. Domain reflection for E says E(x) belongs to dom V exactly when x belongs to D. Thus H∘E reflects D. At x∈D, W(H(E(x)))=H(V(E(x)))=H(E(T(x))). This is the output equation required by VC46. ∎

The two conditions have different roles. Domain reflection concerns all members of each observation fiber. A commuting square concerns the supplied successful applications. `ReobservedTransition<P,Q>` derives the composed square when P's image action is Q's actual source action. It does not turn successful-square evidence into a universal assertion about unavailable actions.

For the guarded binary fragment, those domain assertions have already been established: the full image carries a=c, and the class is R exactly at that equality, with the two D clauses carrying the complementary constructor obstructions. The three spectrum-to-class squares derive the class update from the full-image update. Each source-to-class square is now an alias of `ReobservedTransition` applied to the existing source-to-spectrum square and the corresponding spectrum-to-class square. No source update is reimplemented at the class layer.

The seam is the entire middle action reading, including its input, output, context, and operation. The unguarded swap and the guarded swap have the same coordinate formula at an enabled source, but they are different actions. Matching their output values cannot replace the required seam.

## §6t. One evidence relation for a family of continuations

**Claim VC52 (initial evidence answers every certified continuation).** Suppose E is an exact image for a declared family of partial actions and each target question q factors through E. Suppose acquired evidence M recovers the initial E-image. For every finite action word available at a source, the corresponding final question has a decoder from that same initial evidence. No new observation is required by the derivation. Availability is preserved at every prefix, not only at the final result.

**Proof.** For the empty word, compose the target question's decoder with the evidence decoder as in VC50. For a nonempty word, exact descent preserves the first action's domain and gives its image successor. Apply the induction hypothesis to the remaining word at that successor. Composing the image steps followed by the final question decoder gives the answer from the initial image. Composing once more with the evidence decoder gives it from M. Domain reflection at each step makes the argument apply exactly to available words. ∎

The bare-Swift construction is `FutureOnEvidence<P,F,G>`, an alias of `AnswerOnRefinement<QuestionAlongTransition<P,F>,G>`. F observes the actual end of P. G recovers its initial observation. The final equality is derived inside the existing generic constructors. The action expression remains part of the future question. A wrong endpoint, another initial acquisition, or replacing that question with its present-time counterpart changes the relation.

For VC49's fragment the complete continuation family has three forms:

| Initial class | Available words | Answers |
|---|---|---|
| D(a) | the empty word | a |
| R(a,a) | every finite repetition of T | a at every length |
| R(a,b), a≠b | the empty word and T | a, then b |

There is no omitted longer case at R(a,b) with a≠b: its first successor is D(b). At R(a,a), `AppendRepeatClass` names the existing `JoinedTransition` with the repeat branch at its actual endpoint. The successor still satisfies the repeat branch's premises. This supplies a generic step of closure, so a separate certificate for each length is unnecessary. The empty question can use its present factorization directly. Wrapping it with `IdentityTransition` does not make the resulting nominal operation expression identical to the unwrapped question.

This is a claim about finite paths constructed from the supplied clauses. It is not a finiteness theorem for every possible recursive protocol conformance, nor a bound on compilation time. The fragment has an unbounded family of finite questions even though its exact image has six classes.

**Claim VC53 (representation composition commutes with path composition at the boundary).** Suppose P₀,P₁ are two compatible source-to-image squares and Q₀,Q₁ are compatible image-to-class squares, with Qᵢ's source action equal to Pᵢ's image action. First composing each row and then changing representation has the same initial observation, final observation, source action, and class action as first changing representation in each column and then composing the resulting squares.

**Proof.** Write the source actions as T₀,T₁, the intermediate actions as V₀,V₁, and the class actions as W₀,W₁. Let Eᵢ be the source-to-image observations and Hᵢ the image-to-class observations at the three endpoints. In both constructions the initial observation is H₀∘E₀, the final observation is H₂∘E₂, the source action is T₁∘T₀, and the class action is W₁∘W₀. The matching middle readings justify each composition. If the square families reflect domains exactly, VC51 and the prefix argument of VC52 preserve the same available paths in both constructions. ∎

The generic Swift witness compares these four boundary types for `ReobservedTransition<JoinedTransition<P₀,P₁>,JoinedTransition<Q₀,Q₁>>` and `JoinedTransition<ReobservedTransition<P₀,Q₀>,ReobservedTransition<P₁,Q₁>>`. All four coincide by reduction. The enclosing proof types are different nominal constructions. Equality of their boundary does not identify those constructions or assert equal physical cost. The result permits either decomposition without separately proving every combined path.

## §6u. A new interaction can require a finer object

**Claim VC54 (enlarging the interaction family refines identification).** On a fixed source carrier, if the allowed action family and target-question family are enlarged, the behavioral equivalence of VC47 can only become finer. For the binary fragment of VC49, adding the total swap S(a,b,c)=(b,a,c) to the guarded action T refines the six classes into exactly eight.

**Proof of refinement.** Every old question, word, and domain comparison is among the new requirements. Agreement under the enlarged family therefore implies agreement under the old one. Equivalently, each new behavioral class lies within an old class, and sending a new class to its containing old class is well-defined. ∎

**Proof of eight classes.** The present alpha question determines a. The alpha answer after the always-available S determines b. Availability of the guarded T determines whether c=a. Since the carrier is binary, this determines c as well. Thus any equivalent pair has the same complete triple, and no two of the eight triples can be identified. Conversely the complete image preserves alpha, the total swap, and the exact domain and update of the guarded swap. It therefore suffices for every mixed continuation by VC52. ∎

For a concrete separating pair, (0,0,1) and (0,1,1) both had the image D(0). After S their alpha answers are respectively 0 and 1. A decoder from D(0) alone would have to supply both different answers at one input, so no function on the old class can answer this new question over both sources. This is a direct obstruction to factorization, not an inference from a missing Swift conformance. The positive distinction is again the zero/successor pair of VC48.

The previously acquired complete image can answer the new question through the existing `SpectrumFirstTransition`, `SpectrumAlphaFactors`, and `AnswerFromAcquiredObservation`. Its fact need not be enlarged or the source observed again for this derivation. If only the six-class image remains accessible to the participant, it does not determine the new answer. That participant needs additional distinguishing evidence or a narrower justified source domain. The omitted distinction still belongs to the different sources inside the whole. The claim concerns what is recoverable from this participant's retained representation.

The minimum is therefore relative to the declared interactions. A representation can be sufficient for its old family and insufficient for a larger one without having been an erroneous representation of the old family. This is a concrete route from saturation to a new unresolved distinction, with both boundaries stated as relations.

## §6v. An internal participant acquires the missing distinction

VC54 leaves a precise acquisition problem. A participant retaining D(0) cannot distinguish 001 from 011, although the added swap makes their difference relevant. The two sources already differ inside the whole. The participant needs an allowed coupling to that difference.

Fix a channel reading q(x) of the actual source x. Its context, encoding and question form an instrument address p. This address is the same across source values and contains neither x nor q(x). Let m be the participant's old source-bound memory. Write a prepared whole as W₀=(x,p,quiet,(m,blank)). The declared acquisition relation gives W₁=(x,p,signal,(m,f_q(x))), where f_q(x) is a fact recording the channel's context, question and actual answer. The source, address, old memory, phase and new slot all belong to the represented whole.

**Claim VC55 (prepared acquisition is source-bound and recoverable).** For a fixed declared channel law, the relation W₀↦W₁ records q(x), preserves m and x, and has a left inverse on its constructed range. The new fact's decoder can answer q from the output memory alone. This does not make the relation a reset of arbitrary occupied memory.

**Proof.** The inserted fact's answer is q(x) by construction. Projecting the output recovers x, p and m. Replacing the signal phase and the new fact slot with the prepared quiet phase and blank slot reconstructs exactly W₀. This recovery uses output coordinates and the specified preparation, without a separately retained copy of the entire input. Applying that recovery to equal outputs gives equal prepared inputs. Reading the fact returns q(x) at its actual memory address. An arbitrary previous slot value could not be recovered by replacing it with blank, so the argument is restricted to the prepared domain. ∎

`PreparedTraceExtension<T,R>` realizes the relation using `AppendObservation<T,R>`. The requirement `T.Left == R.Left` ties the new reading to the source of the old trace. Its whole contains `ChannelOf<R>`, which carries only context, encoding and question. The channel law is supplied by the reading family, not by the address label alone. `PreparedPredecessor` recovers the prepared input from the output fields. The inverse relation itself is an alias of `InternalSwap<PreparedTraceExtension<T,R>>`, with the relation's endpoints exchanged.

`AnswerInReadyWhole` names the existing factorization decoder where its source, context, phase and memory match the declared whole. Its input is the memory, not the complete source. A signal marker alone does not authenticate an arbitrary record or establish a factorization. Quiet marks an unused new slot. It does not prevent reading old facts already present in the prefix. In particular, a blank slot and a recorded zero answer are different structures, even though `Never` also represents the zero numeral.

For the new channel, `SpectrumBetaSource` reads the resident b coordinate. This is an explicitly supplied source projection. It is not a physical implementation theorem for an arbitrary measurement. Its output can subsequently answer the predicted alpha question after the total swap, because that future answer is b. Acquiring b does not itself swap the source. The two operations have different actual source endpoints.

## §6w. Acquire only the distinction the retained image lacks

**Claim VC56 (the least sufficient refinement retains exactly the new question distinctions).** For an old reading E:K→C and a new question q:K→V, define F(x)=(E(x),q(x)). F determines both readings. If another reading G determines both E and q, then F factors through G. Thus the partition induced by F is the coarsest refinement of E that determines q.

**Proof.** Projections of F give E and q. If E=e∘G and q=d∘G, the decoder z↦(e(z),d(z)) gives F from G. Equivalently, two sources have the same F-image exactly when they have the same E-image and the same q-answer. Any sufficient G must distinguish every pair for which one of those equalities fails. ∎

On the binary carrier of VC49, take q(a,b,c)=b. At R(a,b), E already gives a and b, while the guard gives c=a. No new reading is needed to recover the complete triple. At D(0), c=1 and b is missing. At D(1), c=0 and b is missing. One beta reading therefore completes each blocked class. It separates both members of its two-element fiber. Any exact refinement needs at least two outcomes within each such fiber, while no additional outcome distinction is needed in a singleton ready fiber. This is a lower bound on distinguishable outcomes, not the physical byte count of a tagged record.

The adaptive rule depends only on the old accessible class: keep the ready memory, or use the prepared beta channel for a blocked memory. It does not inspect the hidden b to select its action. The two blocked branches acquire the same question with the same instrument address. For the declared vocabulary containing only this extra source-reading channel, zero added reads suffice at ready classes and one is necessary and sufficient at blocked classes. A different allowed instrument family would require its own cost comparison.

`ReadyClassRecoversSpectrum` derives the full image from the old ready class. `ReadySpectrumFromOldTrace` transports that answer to its previously acquired fact. `ZeroBlockedPreparedSpectrum` and `OneBlockedPreparedSpectrum` recover the complete image from the old class fact and the new beta fact at their retained addresses. The binary hidden-coordinate premise is explicit: D(0) by itself would not determine which arbitrary positive successor had been hidden in c. The generic constructors do not silently extend that inference beyond the stated source family.

The resulting memory supplies `FullSpectrumReading` by a checked factorization. VC52 therefore gives every certified mixed continuation from it. `RetainTraceAnswer` also preserves the old class answer through the new memory prefix. The previously established knowledge need not be replaced by the new answer.

**Claim VC57 (a local update alone cannot separate an unresolved pair).** Suppose the participant's initial accessible state is M(x). Let its next accessible state be f(M(x)), where f is a fixed deterministic local rule with its program included in that state or held fixed across the compared sources. If M(x)=M(y), the updated accessible states are equal. No decoder from those updated states can give different answers to a question that distinguishes x and y.

**Proof.** Substitute the equal inputs into f, then into the proposed decoder. Both outputs are equal. This conflicts with distinct required answers. The same argument iterates through any finite sequence of local rules whose choices depend only on the accessible state. A rule that also receives a source-dependent channel answer has a different input and is outside this premise. ∎

For 001 and 011, the entire prepared instrument state is equal: channel address, phase, old class memory and blank slot. After the beta coupling, the records contain 0 and 1. The ordered zero/successor distinction supplies the positive separating witness. The instrument gains access through its coupling to the resident source, not through extra information in its initial address or a hidden oracle parameter.

This does not say that local reasoning cannot find an answer already determined by memory. It says that exact separation of this unresolved pair needs a new dependence on something that distinguishes it, or a justified narrowing of the source domain. M43 gives the same construction an autonomous finite dynamics and an explicit entropy account. M44 separates its prepared acquisition order from retained history and physical time.

## §6x. Select from memory, prepare from resident resources

**Claim VC58 (the selected acquisition can depend only on acquired memory).** In the binary model of VC56, let the available new channel be the declared beta reading. Define the decision on old class values by s(R(a,b))=reuse and s(D(a))=beta. Compose s with the decoder of the old class fact. This selects an adequate action for every source without using its hidden beta as a decision input. The selected beta reading must still share the actual source of that fact.

**Proof.** At R(a,b), the existing decoder gives (a,b,a), so reuse answers the complete-image question. At D(a), the two possible sources have the same old memory and hence the same decision. Their distinct beta answers separate them and recover the complete image on the binary carrier. Thus the decision is constant within each old-memory fiber, while the subsequent acquisition can distinguish that fiber's members. The source equality ties the selected reading to this acquisition, even when another source would give the same numerical answer. ∎

`ChooseReadyReuse` and `ChooseBlockedBeta` take class values as their only inputs. `DecodeRefinedEvidence` reads the class from its memory address before applying the decision. `SelectedTraceExtension` is an alias of the existing prepared relation, restricted by equalities between the policy's input and the actual trace memory, and between its answer and the actual channel address. It introduces neither another acquisition implementation nor an assumed answer equality. The specific beta family supplies the channel law. A policy label alone cannot construct an arbitrary instrument. The binary family and the available channel remain explicit premises.

M65 exhibits two preparations with the same context, question and source but different answers. Their `ChannelOf` addresses agree, so channel selection alone admits either supplied reading. `SelectedResidentTraceExtension` instead binds the policy's memory-derived answer to a finite path in a resident catalogue of actual readings. The selected leaf supplies the reading and its source equation. The existing prepared relation retains both catalogue and policy beside its input and output. The original beta instance remains valid with its declared reading family. General selection among preparations needs this occurrence relation or another proof that the selected question uniquely determines the admitted reading.

Selection does not prepare a slot. Write W_d=(x,p,quiet,(m,d)) for a workspace with arbitrary old content d. Let a be an archive and (blank,r) a resident reserve head and tail. Both a and the reserve belong to the same represented whole. Consider the preparation relation

`(W_d, a, (blank,r)) → (W_blank, (a,d), r)`.

This exchanges the occupied content for a resident blank and retains the displaced content. It does not create a blank or silently discard d. If the workspace is already blank, this preparatory exchange is unnecessary. If d is otherwise recoverable from retained data, another preparation scheme may avoid storing it separately.

**Claim VC59 (a reusable instrument can leave an accessible resident result).** After VC55's actual acquisition, write W_f=(x,p,signal,(m,f_q(x))). With one resident blank still available, define

`(W_f, a, (blank,r)) → (W_blank, (a,f_q(x)), r)`.

Both the preceding preparation and this parking relation have left inverses on their constructed ranges. Parking restores the prepared instrument and retains a memory view (m,f_q(x)) at two resident addresses. Every factorization through the acquired trace therefore remains usable from those addresses. No additional reading of x is needed to decode that view.

**Proof.** For preparation, the output gives x,p,m,a,d,r directly. Put d back into the workspace and restore the specified blank reserve head. For parking, the output supplies x,p,m,a,f_q(x),r. Move its latest archive fact back beside m, restore the specified signal phase and blank reserve head, and recover the entire input. These are inverses on the stated ranges, so equal outputs imply equal inputs. The parked view has exactly the same two fields as the acquired trace memory. Substitution into its existing decoder preserves the question and answer. The source-bound factorization supplies correctness of the record, not its shape alone. ∎

`PrepareTraceFromResidentSlot`, `StepBeside` and `ParkAcquiredTrace` connect the preparation, selected reading and storage boundaries. `ResidentTraceMemory` names the retained prefix and latest archive fact. It adds no record. `AnswerFromResidentArchive` names the existing decoder at that view, checking the actual source and context. The ready instrument marker is unnecessary for an answer already at another accessible address. Equal-valued facts do not transfer an acquisition to another nominal source.

This example declares a finite reserve grammar: S₀=Never and Sₙ₊₁=Paired<Never,Sₙ>. Starting with occupied workspace and S₂, preparation consumes one reserve head and parking consumes the other. Their old contents and the new fact remain in the archive, and S₀ remains. Each further use of this particular parking rule needs another reserve head. An empty Never is not the constructor Paired<Never,Never>, even though Never conforms to Pair. Arbitrary Pair or Structure conformances do not prove finite capacity.

Each added archive link corresponds to a removed reserve link. Growing the archive in this finite fragment therefore does not enlarge the declared stock of slots. A generic slot may contain an arbitrary Structure, so a physical byte capacity also requires an encoding and an allowed value alphabet.

This is a slot account for the declared layout, not a universal cost of acquiring a bit. A repeated answer can use its retained factorization with an empty reserve. A different sufficient encoding could compress records, and a known old workspace value need not require a separate archival copy. Slot occupancy, distinguishable outcomes and entropy have different premises.

Restoring workspace while retaining output is familiar from reversible computation. Bennett's construction preserves the output on a separate tape while restoring work storage. The present finite relation moves the fact to a resident slot and exhibits its access and source constraints in VI. It makes no priority claim over that underlying principle. [Bennett, 1973](https://www.cs.princeton.edu/courses/archive/fall06/cos576/papers/bennett73.html).

There is also an exact limit. For two sources with the same old accessible memory and different required answers, the *entire* final accessible state cannot both return to that old state and still determine the new answer. Equal decoder inputs would require equal answers. Parking permits the workspace to return because the archive distinguishes the pair. Source preservation somewhere in the whole is insufficient if that archive is unavailable to the participant. Finite current-state restoration also remains distinct from the full occurrence history required by M44.

## §6y. Admissibility forced by a common-answer contract

EF8 leaves the admitted construction language explicit. A particular interface contract can determine part of that language. Fix a question q:K→V, including its context and answer interpretation. For two sources x,y, require one local record m and one actual decoder application d(m) that correctly answers q for both sources. The whole can retain x and y separately. The requirement concerns their common answer, not their identity.

**Claim VC60 (one common reading exists exactly on the question's agreement relation).** At the level of this record contract, a common representation with a shared decoder exists for (x,y) if and only if q(x)=q(y). Thus its admissible source pairs are exactly D_q={(x,y):q(x)=q(y)}.

**Proof.** If the same decoder application supplies both answers, q(x)=d(m)=q(y). Conversely, when q(x)=q(y)=a, choose the canonical fact f=(context,q,a) and its answer projection. It supplies a from the same input fact in both source-specific factorizations. Retain ((h,(x,y)),f) to keep both actual sources and the context h beside that local fact. The construction imposes no identity between x and y. ∎

The guard is derived from the two recovery requirements meeting at one reading. It is not an additional choice to forbid unequal answers. Conversely, the contract does not forbid keeping unequal answers at different addresses with different decoder applications. A pair of source-bound facts can do that. A record's physical extent or a label saying one memory does not make those two addresses one decoder input.

The necessity is the existing `AnswersThroughSharedDecoder`. `SharedFactFromVerdict` supplies the converse using the existing `AcquireAnswer` and `ReadRecordedAnswer` constructors. Equal source answers make their canonical facts and actual decoder applications equal. That equality is derived in the generic body. `CommonFactConstruction` retains both sources with the common fact, and `CommonFactFromSharedDecoder` first derives the needed verdict from the supplied shared decoding relation. These constructions state source and record relationships. Execution uses the preparation and access relations of VC55 and VC59 when the record must be acquired and stored.

For a mechanism with additional input conditions, such as a resident prepared slot, its domain must also satisfy those conditions. Every correct common-answer mechanism has domain contained in D_q. The canonical record family attains all of D_q as a representation contract. If a mechanism is defined by that family restricted to a resource domain P, its domain is D_q∩P. This locates each restriction at its actual input instead of treating answer compatibility as the whole execution mechanism.

Different questions or encodings cannot be made comparable by coincident raw values. All context coordinates belong to the shared reading. Likewise an equal-valued source cannot replace either actual input of the retained construction. The canonical fact can preserve the answer of an older shared image without being identical to that image or its construction history.

The answer is also invariant across realizations with different memories and decoders when they share one actual source reading. Each common reading must agree with that anchor, so their other source answers agree by transitivity. `CommonAnswerAcrossRealizations` derives this verdict as an alias of `JoinedVerdict`, without an equality premise on the resulting answers. The old visible-image decoder and the canonical fact decoder give two concrete realizations. Equality of decoder implementations or storage representations is unnecessary for this conclusion.

There is a useful order on these contracts. If q=d∘r on the source domain, then D_r⊆D_q: equality of r-answers gives equality after d. The reverse inclusion need not follow. For the existing beam family, equal complete images imply an equal alpha answer. Two sources with equal alpha and different third coordinates can share an alpha fact but cannot share one complete-image answer. With q equal to source identity, D_q is the diagonal. With a coarser question, distinct sources can be compatible. Admissibility therefore depends on what the common interface promises to recover.

**Positive obstruction.** For q(x)=0 and q(y)=Succ(n) in the declared numeral grammar, `ZeroSuccessorBoundary` binds both ends of the existing constructor distinction to the actual readings, including their context and question. `SuccessorZeroBoundary` reverses the orientation. Neither case infers inequality from a failed conformance. The incompatible answers are the positive evidence. `ZeroSuccessorBoundaryRecord` and its reverse retain the two actual sources and the ordered obstruction. Their event is a record of the failed common-answer request, not a common answer to q.

For readings outside a covered family, the absence of a supplied agreement or obstruction leaves the construction unresolved. It is not a failure certificate. The binary family below is completely covered by its two equal and two unequal answer pairs.

## §6z. A minimal image preserves the derived domain

**Claim VC61 (three interface classes suffice for the binary common-answer request).** Restrict q's values to 0 and 1 and consider the four ordered answer pairs. The interface must report whether a common answer exists and, when it does, supply that answer. It has no other requests. Its minimum exact image has three classes: J₀ for (0,0), J₁ for (1,1), and B for both (0,1) and (1,0).

**Proof.** J₀ and J₁ cannot merge because their required answers differ. Neither can merge with B because the common-answer request is defined on the former and undefined on the latter. These requirements force at least three classes. Three suffice: decode the common fact at J₀ or J₁, and report the positive failure at B. No request in this interface distinguishes the two orientations inside B. ∎

The corresponding typed successful images are the two canonical `AnswerFact` types. `ZeroSuccessorBoundaryImage` and `SuccessorZeroBoundaryImage` give the same context-tagged failure image, `AddressedRepresentation<ChannelOf<L>,Never>`. A recorded zero answer remains distinct from that image. The full failure records retain orientation and actual sources even when this local image omits them. This is a quotient of the specified interface, not a merger of its complete records.

Keeping only the first answer fails even to preserve the derived domain: (0,0) and (0,1) have the same first answer, but only the former admits a common fact. This is the domain-reflection condition of VC46 applied to a partial answer request. A correct answer on successful cases does not repair an image that conflates success with failure.

If the interface additionally asks which side of a failed request had zero, B must split. The four ordered pairs then require four classes. The earlier three-class image was sufficient for its declared requests. The new question requires its retained detailed obstruction or another distinguishing reading. The source record already contains that information. This illustrates how a construction's recovery contract determines both its admissibility and the distinctions a sufficient local representation must preserve.

## §6za. Acquire once under a resident agreement

VC60 characterizes when one common fact is possible. Its acquisition also needs an actual reading and prepared memory. Write a resident source as w=(x,y), with two addressed applications q_L(w)=q(x) and q_R(w)=q(y) of the same component question. The applications have the same question interpretation but different source addresses. An agreement C establishes q_L=q_R on the domain under consideration. This agreement can follow from a structural source family. Its existence does not establish that the participant has discovered it.

**Claim VC62 (an acquired answer serves an agreed resident application without another acquisition).** Suppose both applications are on the same actual source w, C establishes their agreement, and F factors q_L through an available observation E with decoder d. Then the same observation and the same decoder factor q_R. A prepared acquisition of q_L therefore supplies one fact sufficient for both applications. Parking that fact by VC59 preserves this sufficiency wherever its resident memory address is accessible.

**Proof.** On the stated domain, q_R(w)=q_L(w)=d(E(w)). Neither E nor d changes. In the prepared special case, E(w) is the trace memory (m,f_q_L(w)). Its last-fact decoder returns q_L(w), hence q_R(w). The acquisition keeps w and m. Parking moves that one fact to an existing reserve slot while returning the instrument to its prepared state. The resident view combining the old prefix with the archived fact equals the acquired trace memory. Thus exactly the same decoder still applies. Its input contains memory, not a separately supplied copy of either source. ∎

`AnswerThroughAgreement<C,F>` constructs the general factorization. It requires the actual first application `C.Left == F.Left` and the actual source equality `C.Right.Left == F.Left.Left`. Agreement between readings of different sources does not authorize substituting F's observation of one source for an observation of the other. `PreparedCommonTrace` is the existing `PreparedTraceExtension` at the first application, constrained by the resident agreement. `CommonAnswerFromTrace` transfers `LastAnswerFromTrace` to the second application. The two resulting decoders are identical as types, including their memory input.

The explicit component laws are `BoundaryFirstAlpha` and `BoundarySecondAlpha`. On w=(CommonLeft(a),CommonRight(a)), the sources differ in hidden fields while their alpha coordinates coincide. The structural relation supplies C for every numeral a. The source pair, channel address, working memory, old archive and finite blank reserve all belong to the represented whole. The channel's label names its context and question. The first-address reading constructor supplies its coupling law. The label alone does not grant access to every reading with the same question name.

With occupied work content D, the connected construction uses the existing preparation to move D into one resident reserve slot, acquires the first alpha, then parks its fact in a second resident slot. Both seams match exactly. The final archive is ((A,D),f_q_L(w)), and the reserve tail is unchanged. There is one new answer fact, not a second measurement record for q_R. Two slots describe this particular arrangement with occupied work and subsequent parking, as in VC59. Already prepared work does not need the first exchange, and reading the completed archive needs no new slot.

Three restrictions can now be exhibited independently. An agreed source with occupied work and no reserve cannot enter this preparation relation. A prepared incompatible pair admits a first-side measurement but cannot obtain a common-answer certificate, regardless of additional blank capacity. A completed agreed acquisition still requires access to its archived fact: after instrument reset, retaining only the work view can leave two different required answers indistinguishable. All of these are restrictions inside the represented whole.

For the last case, compare the completed runs at a=0 and a=1. Their work views, excluding the sources and archive, coincide. Their archived answers have the positive zero/successor distinction. No decoder of that restricted view alone can answer both. The complete source and archive remain different. This is a loss of accessible sufficiency without loss of the distinction from the whole.

## §6zb. A sufficient answer need not reveal its own domain

**Claim VC63 (first-side evidence cannot certify common-answer admissibility on the unrestricted binary pair family).** Let e(a,b)=a on the four binary answer pairs, and let D={(a,b):a=b}. Evidence e determines the common answer on D. It does not determine membership in D on the full family. Adding the same source-independent memory or applying a deterministic transformation of that accessible evidence cannot repair the missing distinction.

**Proof.** On D, the common answer equals a, so the identity decoder suffices. But e(0,0)=e(0,1)=0, while the former pair belongs to D and the latter has the positive 0/1 obstruction. Any decoder of e must return the same result at this shared input, so it cannot correctly decide admissibility on both pairs. Appending the same memory z gives (0,z) in both cases, and every deterministic transformation of that shared input still agrees. ∎

The same distinction is exhibited by actual prepared acquisitions. The first-alpha traces of the agreed pair (0,0) and the incompatible pair (0,1) have identical memory types. Their retained source pairs differ in the second alpha. `CommonExtraMemoryCannotDiscoverAgreement` preserves trace equality beside any common resident memory tail. The incompatibility is certified by `ZeroSuccessorBoundary` bound to the two source readings. It is not inferred from a compiler refusal.

Consequently C in VC62 must retain its status as an established source relation. Within the declared correlated constructor family it follows structurally. For an unknown member of the unrestricted pair family, the first fact does not establish that relation. A distinguishing observation or another justified restriction is needed. The compiler checks the supplied construction. Membership of the actual source in D does not give the observer evidence of that membership.

This is the acquisition-side counterpart of VC61. Its three-class image preserves the successful answer and admissibility. The two-valued first-answer image is sufficient only after restricting to D. Conditional adequacy and knowledge of the condition are different obligations. Extra storage can preserve a distinction once acquired. Source-independent storage does not supply an absent distinction about which domain contains the source.

## §6zc. Acquire the relation that licenses a common answer

VC63 leaves the first-side fact insufficient to establish compatibility on the full binary pair family. The missing distinction is already at the other address of the resident source. Read that address and retain the earlier reading. The two facts then occupy different addresses in one actual memory. This operation requires no agreement premise.

**Claim VC64 (comparing acquired evidence reflects agreement and obstruction to the source).** Suppose q_L=d_L∘E and q_R=d_R∘E on the same actual source domain and with a common question interpretation. Agreement of d_L and d_R at the acquired memory E(w) entails agreement of q_L and q_R at w. A positive distinction between these decoded answers likewise distinguishes the source answers. On the binary component grammar, the two acquired readings determine exactly the three common-answer classes of VC61.

**Proof.** At m=E(w), q_L(w)=d_L(m) and q_R(w)=d_R(m). Substituting these equalities into the memory comparison gives the corresponding source comparison. For binary answers the four ordered memory cases are (0,0), (1,1), (0,1) and (1,0). The first two give canonical common facts with answers 0 and 1. The last two have the positive zero/successor distinction, in opposite orientations, and give the same failure image. Their minimum interface is therefore J₀, J₁, B by VC61. The complete memory still distinguishes all four ordered answer pairs. ∎

`AgreementFromMemory<F,G,C>` is an alias of `JoinedVerdict<F.Left,G.Left>`. Its premises require one actual observation `F.Observation == G.Observation` and the memory comparison `C.Left == F.Right`, `C.Right == G.Right`. Source-answer equality is the conclusion, not a separate premise. The shared observation also ties both source applications to the same actual whole. `ZeroSuccessorFromMemory` transfers the corresponding positive numeral distinction with its head constraints on the memory decoders. Reversing the two factors and the resulting obstruction covers the other orientation.

Let T₁ append the first component reading and T₂ append the second to the same source trace. Both are instances of the existing `AppendObservation`. `RetainTraceAnswer<T₂,LastAnswerFromTrace<T₁>>` gives d_L, while `LastAnswerFromTrace<T₂>` gives d_R. Their observation is exactly `TraceEvidence<T₂>`. Their decoder inputs contain the acquired facts, with neither source as a separate argument. They compare two recorded addresses rather than asking the source a third question.

The memory constructors `AgreedMemoryBoundary`, `ZeroSuccessorMemoryBoundary` and `SuccessorZeroMemoryBoundary` produce the three existing images. Their question is `CommonBoundaryQuestion`, distinct from the original alpha question. A failure image therefore does not masquerade as an alpha answer. `QuestionOnObservation` connects each memory classification to its actual source trace. The four binary cases are all supplied. The clauses do not define a general comparison of arbitrary Swift types, and outside this covered grammar missing conformance still means no supplied construction.

Different sources with identical acquired memory can use the identical classifier. Their acquisition relations remain different. An equal-valued foreign observation cannot replace either factor in `AgreementFromMemory`. A fabricated fact shape would also need its source-bound observation relation before this inference could apply.

In the agreed cases, the resulting source verdict now supplies C to VC62. The last acquired decoder can serve both addressed applications through `AnswerThroughAgreement`, with no new reading and no appended third fact. For an incompatible case, both individual answers remain readable, but their distinction obstructs precisely the common-answer contract. The rule's applicability has now been obtained from actual evidence rather than inferred from possession of a first-side fact.

## §6zd. A resident second slot and an exact reading bound

The two-read schedule starts with one prepared slot and one further resident blank. After the first acquisition, `AdvancePreparedTrace` moves the completed memory into the next prepared prefix and uses that blank as its new slot. Its input is `(W₁,blank)` and its output is `(w,p,quiet,(m₁,blank))`, where W₁=(w,p,signal,m₁). The two readings have the same context, encoding and component-question channel address. Their constructors specify the different component couplings. This fixed schedule does not consult the unmeasured second answer to choose its next reading.

The advance has a left inverse on this prepared range. From the output, recover w,p,m₁ and the blank. Reconstruct W₁ using its known signal phase and pair it with the recovered blank. Thus the first memory and both source components remain recoverable. An unread first state, an absent second slot and an occupied second slot do not meet this relation's input. The next `PreparedTraceExtension` then produces the memory ((m,f_L),f_R). Both seams are checked in the general constructor family.

This is a relation for a declared finite acquisition schedule. Its two slots are initially internal, and it does not introduce a supply from outside the whole. The intermediate current layouts are recoverable but do not claim to be a full occurrence-history representation. The independent historical requirement of M44 can retain these events. The local three-class view is also a derived representation, not a physical deletion of either retained fact.

**Claim VC65 (both component readings are necessary on the unrestricted binary domain).** Suppose the source is unchanged during acquisition, all four ordered binary pairs remain possible under the old evidence, and the only new source-reading operations return the first or second component. Every deterministic policy that correctly reports J₀, J₁ or B must read both components on every source. Consequently, after one component fact, exactly one further reading is necessary and sufficient. If accessible old evidence already determines the other component on this actual source, no further reading is needed to compare them.

**Proof.** After a first-component result 0, sources (0,0) and (0,1) remain indistinguishable but require J₀ and B. After result 1, sources (1,0) and (1,1) require B and J₁. Repeating that component on an unchanged source adds no distinction. The argument is symmetric if the second component is read first. Hence a correct policy must acquire the other component before terminating. Reading it once gives both answers and suffices by VC64. If another accessible factorization already supplies that answer, apply the same memory comparison to the two existing decoders instead. ∎

The last case is exhibited with an old second-side fact in the trace prefix and a first-side fact at its last address. `RetainTraceAnswer` exposes the old answer, and `AgreementFromMemory` derives agreement directly from their memory comparison. No new extension is part of that derivation. Applicability therefore has a cost relative to the evidence already accessible and the allowed channels. Two reads are necessary in the stated unrestricted domain, not a universal price of establishing a relation.

## §6ze. Transport an acquired boundary through a source change

An acquired agreement concerns addressed applications on its actual source. Changing that source requires a relation to the new applications. The existing commuting squares provide that relation while keeping the operation in the future question. For the resident pair w=(x,y), write A(w)=(alpha(x),alpha(y)) and let c classify that ordered pair into J₀, J₁ or B as in VC61.

**Claim VC66 (side exchange preserves the common-answer interface).** Let S exchange the two actual source components. Then A(Sw)=s(Aw), where s(a,b)=(b,a), and c(s(a,b))=c(a,b) on the binary carrier. Consequently the three-class image preserves the common-answer value and its domain through every finite repetition of S.

**Proof.** Component projection gives A(Sw)=(alpha(y),alpha(x)). The equal pairs (0,0) and (1,1) are fixed by s. The pairs (0,1) and (1,0) exchange places but both classify as B. Thus every class is fixed, and agreement a=b is preserved and reflected. Induction gives the same class after every finite repetition. ∎

`SwapBoundaryReading` applies the same exchange to source components and to their ordered alpha image. `SwapBoundaryTransition` derives the square by projection. `AgreedBoundarySwap`, `ZeroSuccessorBoundarySwap` and `SuccessorZeroBoundarySwap` then derive the class squares. Their common image action is `KeepBoundaryUnderSwap`. `ReobservedTransition` composes them into actual source-to-class squares, with no separately assumed equality of endpoint classes. Two consecutive swaps must use the actual intermediate source. Returning its component layout does not identify the event history with the initial record.

The ordered alpha image is also available from the two acquired facts of VC64. `JointEvidenceFromMemory<F,G>` combines their existing decoders while retaining their one actual observation. It constructs a factorization of `JointEvidence<F.Left,G.Left>` through the old memory. `AnswerOnRefinement` can then recover c from that memory. The coarse swap square already predicts the endpoint class from the old three-class image alone. Composing with its acquired factorization reads that prediction from the old memory without acquiring another source fact.

This is transport of a question along the specified operation. `QuestionAlongTransition` and `FutureOnEvidence` retain the operation in the question type. They do not rename a trace of w as a fresh trace of Sw. The static state relation can apply the source step beside unchanged memory using `StepBeside`, and a separate `RetainedWhole` can retain that actual predecessor and successor as an event record.

## §6zf. A resident exchange makes an omitted distinction relevant

For a different intervention, exchange the first component's alpha and beta. `ExchangedBoundaryFirst` uses the existing `SwapVisible` for that component and keeps the other component. The old alpha moves to the resident beta address. Suppose the first beta is initially zero. On the observed pair, this intervention has image R(a,b)=(0,b). The source action preserves the displaced value, although this local image omits it.

**Claim VC67 (one prepared exchange refines the required initial image from three classes to four).** On the four binary alpha pairs with a resident zero in the first beta, a representation that determines both the present common-answer class and its class after this exchange must distinguish all four ordered alpha pairs. The acquired ordered pair (a,b) is sufficient. The old three-class image is insufficient.

**Proof.** The current classes already distinguish (0,0), (1,1), and the group {(0,1),(1,0)}. The exchange sends (0,1) to (0,1), with class B, and (1,0) to (0,0), with class J₀. Hence the previously grouped pair must split. Four classes are necessary. They suffice because the ordered pair determines both c(a,b) and c(0,b). ∎

The other two transitions are J₀→J₀ from (0,0) and J₁→B from (1,1). The failure B therefore has no single image action for this intervention. This is a positive failure of factorization: one old input class would have to give two distinct output classes. The full acquired memory already distinguishes those inputs, so no new measurement is needed when it remains accessible.

`BoundaryFirstZeroTransition` derives the ordered-image square from the actual condition `P.Left.BetaLevel == Never`. `BoundaryFirstZeroImage` gives (0,b), and the three existing pair-class constructors supply the endpoint question. `FutureOnEvidence` composes the square, that endpoint question and `JointEvidenceFromMemory`. Its decoder takes the original acquired memory, while its direct path applies the specified source action before classifying the successor. The four concrete binary cases are supplied.

The zero condition belongs to the actual initial source family. The two alpha facts do not themselves establish it. `ExchangeBoundaryFirst` also applies when beta is occupied, but then the zero-image square is wrong. After exchanging alpha=1 with beta=0, beta contains 1. A second exchange is still possible and returns alpha to 1. What ceases to apply is the previous prediction of a zero result, not the exchange operation. This distinguishes an action's existence from the premises of a particular description of its effect.

The old trace also remains an old trace. In the (1,1) case its first fact still reads 1 while the successor's first alpha is 0. The actual source step can preserve that memory unchanged. The future classification obtained through the square is B. Appending a new-source reading to the old fixed-source trace, substituting equal-valued evidence from another source, or dropping the operation from the future question are different constructions and fail their respective address or question requirements.

Four classes here suffice for the declared initial task: the present class and the class after one prepared exchange. This does not make the updated alpha pair an exact state for repeated exchanges. Initial pairs (0,0) and (1,0) both produce the updated alpha image (0,0), but their first beta values are now 0 and 1. A second exchange reveals that retained difference. The residue therefore determines a later result even when the current common-answer interface omits it. To make a current image closed under those future interactions, that residue or another representation determining its effects must be included.

## §6zg. Close the working image under both internal exchanges

Write a current working configuration as x=(a,c,b,d), with two resident blocks (a,c) and (b,d). These are the blocks' alpha and beta fields. Their third fields remain attached to the actual blocks but do not enter this interface. The full working carrier is X={0,1}⁴. Its sixteen configurations do not count whole histories, program states or nominal Swift wrappers. The earlier prepared family is P={(a,0,b,1): a,b∈{0,1}}. Preparation applies at that beginning, not after every action.

The total actions are E(a,c,b,d)=(c,a,b,d) and S(a,c,b,d)=(b,d,a,c). The observed common class is c₀(x)=c(a,b), where c(0,0)=J₀, c(1,1)=J₁ and c(0,1)=c(1,0)=B. J carries the shared answer. B carries an obstruction to that common-answer request. This declared binary interface does not assign a Boolean valuation to every question in the whole.

**Claim VC68 (the four working coordinates close under every finite word in E and S).** The coordinate observation W has commuting squares for both actions on every current source p in the declared structural beam family. Composing them gives W(wp)=w̄(Wp) for every finite action word w. Both actions retain the displaced coordinate and are involutions on working configurations.

**Proof.** Projection after E gives ((c,a),(b,d)), exchange inside the first row of W(x). Projection after S gives ((b,d),(a,c)), exchange of its rows. These formulas apply to the successors themselves, with no zero premise. Their squares compose at the actual intermediate source. Identity is the empty word, and appending either generator supplies the induction step. Applying either permutation twice restores all four coordinates. ∎

`BoundaryCoordinatesExchange` and `BoundaryCoordinatesSwap` derive the generic squares. `SwapVisible` now has the concrete structural conformance needed to place its result inside the next source pair. Its old omission prevented a valid mixed composition in the encoding. It was not a prohibition on the exchange. A double exchange restores the coordinate reading even when a nested source wrapper has a different nominal identity.

An action word can be resident. `ResidentBoundaryCommand` binds the next tape head to the applied reading's operation, moves that head to a retained past and keeps the remaining tape inside the output. The next command consumes that output. `RecordedBoundaryCommand` uses `RetainedWhole` when an occurrence record is required. This supplies an internal word and order, with an explicit growing-history construction rather than an external selector or an assertion of unlimited finite storage.

## §6zh. The exact behavioral object has fifteen values

Define the comparison table Φ by

```
             b         d
    a      c(a,b)    c(a,d)
    c      c(c,b)    c(c,d)
```

E exchanges its rows. S transposes it because each elementary comparison is symmetric. The current common class is its upper-left entry.

**Claim VC69 (Φ is the coarsest exact image for all common-answer continuations on X).** Two configurations have equal Φ images exactly when every finite E/S continuation gives the same common class. Φ has fifteen values: it merges only (0,0,1,1) with (1,1,0,0). All fourteen remaining configurations have separate images.

**Proof of sufficiency.** Row exchange and transposition determine both generator updates from Φ alone. Each update is again a table of the same form. The upper-left entry determines the common-answer value and its availability. Induction on finite words proves sufficiency for all continuations.

**Proof of necessity.** Read the common class after ε, E, SES and ESES, writing actions in execution order. These four words return the upper-left, lower-left, upper-right and lower-right entries. Any unequal entry therefore supplies a distinguishing continuation. Every exact representation must determine Φ.

**Proof of the count.** If some entry is Jᵥ, its two incident coordinates both equal v. Comparisons against these fixed coordinates determine the other coordinate in each block: Jᵥ gives v and B gives 1−v. Any table containing J therefore determines all four bits. If every entry is B, both coordinates of either block must equal each other and oppose the other block. Exactly (0,0,1,1) and (1,1,0,0) remain. Their all-B table is fixed by both updates. There are fourteen singleton classes and one double class. ∎

`BoundaryTable` binds four comparison applications to the actual cross-coordinate inputs. `BoundaryTableExchange` derives row exchange by rearranging those applications. `BoundaryTableSwap` derives transposition while reversing their inputs. The elementary reversals agree with the existing binary clauses by `BoundaryReverse00` through `BoundaryReverse11`. Recursive reversal introduces no new answer. `ReobservedTransition` joins the table squares to VC68's actual source squares, and `JoinedTransition` closes their generated paths.

The admitted comparison grammar starts with `Boundary00`, `Boundary01`, `Boundary10` and `Boundary11`, whose answers follow from agreement or positive constructor obstruction. `Boundary0000` through `Boundary1111` declare all sixteen working inputs using those leaves. The compiler checks their addressed comparisons and derived table shapes, the generic update squares and the four separating projections. Coverage, the count and induction over that declared grammar are the mathematical argument above. An arbitrary `PredicateReading` bearing the same question name does not acquire binary-comparison semantics from its label. Swift conformance does not seal this grammar against unrelated declarations.

Fifteen counts distinct values of the minimal image. The table is a convenient structural representation of them. This does not assert that four independent ternary cells are necessary, that fifteen fixed binary codes use fewer than four bits, or that compilation has constant cost. The two merged states remain different under a component reading within the same whole. Indistinguishability for this interface does not make them globally identical.

## §6zi. Reachability and an expanded question family

**Claim VC70 (the prepared closure has fourteen configurations and thirteen common-behavior classes).** The E/S closure of P contains every element of X except (0,0,0,0) and (1,1,1,1). Restricting Φ to that closure gives thirteen classes. Adding direct first-alpha readings to the continuation interface gives sixteen classes on X and fourteen on the prepared closure.

**Proof.** E and S permute coordinates. Every seed contains a zero and a one, excluding both constant configurations. The seed (0,0,0,1) reaches the four placements of a single one. The seed (1,0,1,1) reaches the four placements of a single zero. The seed (0,0,1,1) reaches the two opposite homogeneous blocks. The seed (1,0,0,1) reaches the four configurations with one zero and one one in each block: E flips the first block, and SES flips the second. These disjoint families contain 4+4+2+4=14 configurations, exhausting the nonconstant carrier. They contain VC69's merged pair and twelve singleton classes. A direct first-alpha reading distinguishes that pair. Every other pair was already separated by a common continuation. ∎

The reachable object belongs to the closed current carrier, not just to the four initial seeds. Two alpha facts suffice at the prepared beginning because beta values are fixed there. After an exchange, the same two-coordinate layout need not suffice. An old law about the beginning can still support prediction along the actual path without becoming a law about current beta values.

## §6zj. Acquire the minimal object from resident evidence

**Claim VC71 (sufficient retained evidence determines every common continuation, with an exact component-reading boundary).** A trace of four addressed component readings at one actual source determines W and therefore Φ. Given a certified finite continuation, it determines that continuation's common class without another acquisition. On X, with no prior restrictions and only individual-coordinate channels, four distinct coordinate readings are necessary on every input to determine Φ exactly. If the original preparation P is established, the old two alpha facts suffice.

**Proof of reuse.** Retain each acquired fact in the next same-source trace. Four decoders of that one memory determine a,c,b,d, so their paired result is W. Compose with the table decoder to obtain Φ. Compose that acquired factorization with a transition square and the endpoint common-class projection. Both paths return the same future class. The memory decoder takes only the acquired memory, and its question retains the operation word.

**Proof of the reading bound.** Flip an unread coordinate while keeping all read coordinates fixed. These configurations differ in exactly one coordinate. They cannot be VC69's merged pair, whose members differ in all four. Their Φ images differ. The same observation transcript and adaptive choices cannot distinguish them, so no branch with an unread coordinate may stop. Four readings suffice by construction. On P, beta values are fixed as 0 and 1, and the alpha pair determines W directly. ∎

`AcquiredBoundaryCoordinates` retains four source-bound trace facts and combines their decoders through `JointEvidenceFromMemory`. Each extension exposes its prepared-slot relation. This is a four-reading certificate with preparation obligations, not an automatic apparatus for changing channel settings. `PreparedBoundaryCoordinatesFromAlpha` supplies the narrower initial-family factorization. `AnswerOnRefinement` recovers Φ from either adequate evidence, and `FutureOnEvidence` carries it through the mixed source/table path. Equal coordinate facts from sources with different third fields give the same coordinate decoder. Substituting another actual source into the evidence factorization still fails.

For a positive insufficiency witness, compare (0,0,0,0) and (0,1,0,0). Their alpha memories coincide and their current common class is J₀. E changes their classes to J₀ and B. The missing first-beta distinction is at a named internal address. An accessible old beta fact can supply it by decoding. If it exists only in the source or an inaccessible archive, the required access or acquisition must be supplied. Closure supplies no shortcut from one accessible record to two different answers.

## §6zk. A new internal connection exposes the last omitted distinction

Keep the common question and add K(a,c,b,d)=(d,c,b,a), exchange of first alpha with second beta. This connection crosses the old block boundary. It is another total coordinate permutation inside the same source.

**Claim VC72 (changing the interaction boundary can force a finer object without changing the question).** For all E/S/K continuations, the exact common-behavior image has sixteen values on X and fourteen on the prepared reachable carrier. If Φ is known, only its all-B class needs a further distinction to obtain this finer image. On that class, one first-alpha reading is necessary and sufficient. An accessible original four-coordinate trace supplies it without another acquisition.

**Proof.** K sends (0,0,1,1) to (1,0,1,0), whose current common class is J₁. It sends (1,1,0,0) to (0,1,0,1), whose class is J₀. The only pair merged by Φ must therefore split. All other pairs were already separated under E/S, and the four coordinates suffice under the new permutation. K preserves the nonconstant carrier, giving fourteen values there. The old singleton classes already determine all coordinates. On the all-B pair, identical old images cannot select the two K answers, while first alpha is respectively 0 and 1. That one acquired distinction completes the image. The full trace already contains it. ∎

`CrossBoundaryReading`, `CrossBoundaryImage` and `BoundaryCoordinatesCross` derive the new source/coordinate square while retaining all declared beam fields. It composes with the earlier squares and is an involution on coordinates. Reconstructing these fields does not identify arbitrary nominal source wrappers. `RecordedBoundaryCommand` retains the actual predecessor when recording the whole occurrence. The two new common answers have a positive zero/successor witness. Treating their old shared table as sufficient, or giving K an E tape address, fails. The fifteen-value object remains exact for its original operation family. The newly relevant distinction was inside the whole throughout.

## §6zl. Acquiring a law through one common observation channel

The mechanism family is now part of the declared scope. Let E exchange the first two working coordinates and K exchange the first and fourth, in coordinate order (a,c,b,d). A probe observes only the first output coordinate, under one question independent of the chosen operation. Its preparation fixes c=0 and d=1, while a, b and the retained hidden fields remain free. The actual application, its input, output and prepared recording apparatus belong to the whole.

**Claim VC73 (one prepared response determines the E/K law, conditionally on the family).** In the exact family {E,K}, the first output coordinate is 0 for E and 1 for K. The two clauses 0↦E and 1↦K therefore factor the operation-code question through the common output observation for every admitted prepared source. Acquiring that observation supplies the decoder's input. The decoder does not take the actual application or its operation tag as a hidden parameter.

**Derivation.** E(a,0,b,1)=(0,a,b,1), while K(a,0,b,1)=(1,0,b,a). Their observed coordinates are the two distinct constructor cases. `ExchangeLawFromProbe` and `CrossLawFromProbe` derive the two factorizations from preparation alone. Their declarations do not require equality of the final law answers as an extra premise. `AcquiredExchangeLaw` and `AcquiredCrossLaw` compose those factorizations with recording. `ExchangeLawFromTrace` and `CrossLawFromTrace` obtain the same answers from the actual prepared trace. The recorded fact contains the common output question and coordinate answer, with neither an E/K question label nor an application parameter. Source agreement is supplied by the acquisition relation, not by equality of fact payloads.

**Necessary scope.** On the unprepared all-zero input E and K have the same observed fact. Further, let S exchange the two rows. On prepared input (0,0,0,1), E and S both return first coordinate 0, while on (0,0,1,0) their first coordinates are respectively 0 and 1. Thus the same record does not determine the law in the larger family {E,K,S}. These are positive coinciding and separating witnesses. Compiler failure alone is not their mathematical content. A zero payload can fit the E decoder even when it came from an unprepared K application. The corresponding source-bound factorization then fails.

The result concerns law behavior in a supplied constructor family. It does not infer membership in that family from a successful probe, seal Swift's open conformance space, identify an actual mechanism from its law code, or certify that another application uses the same physical mechanism. Reuse on a new input requires a relation tying the two applications and evidence for the relevant new input. `MechanismLaw<R>`'s generic operation tag has this law interpretation only on the admitted constructors. `Checks/MechanismProbe.swift` checks seven nearby invalid extensions independently.

## §6zm. A two-probe basis for four-address routing

Fix four input and four output addresses, with both output images observed in their declared address order. An admitted law selects one fixed input address for each output address. A permutation uses each input exactly once. This is a restricted family of these routing laws. The same routing acts on both probes. No gate depending on the probe values, hidden phase or probe number belongs to this family unless separately reduced to such a fixed routing.

Prepare the two binary input vectors p=(0,0,1,1) and q=(0,1,0,1). The input addresses have respective signatures 00, 01, 10 and 11. If an output selects input address j, its two observed bits are precisely j's signature.

**Claim VC74 (two complete binary probe images determine routing, and one cannot).** On the declared family, the pair of output vectors determines the selected input at every output, hence the entire routing behavior. Two probes suffice for all twenty-four permutations, and also for all 4⁴ coordinate-selection maps. One binary probe cannot identify all permutations. The bound counts complete four-coordinate images, not individual bit reads or memory writes.

**Derivation.** Zip the two observed vectors at each fixed output address. Each resulting signature is one of the four distinct prepared input signatures, so it identifies exactly one input address. For any binary probe on four inputs, two input addresses have the same bit. Exchanging those addresses is a nonidentity permutation fixing that probe. Identity and that exchange therefore have the same complete output, so one probe cannot distinguish all permutations. For the proposed p, exchanging the first two inputs is a concrete witness, and q separates them at the first output. This proves the lower bound for any choice of a single binary probe, not only p.

`RoutingCoordinates` represents a routing by its four signatures. `FirstRoutingProbe` and `SecondRoutingProbe` project the two bit planes. `RoutingFromProbes` derives reconstruction by `RoutingFromProbeImages`, whose only input is the pair of images. The generic transpose equality is valid for arbitrary structural coordinate contents; restricting each signature to 00, 01, 10 or 11 gives the finite routing interpretation. It does not require enumeration of the twenty-four permutations. `AcquiredRouting` supplies the same decoder from the recorded observation. This records the joint image and does not itself implement two physical interventions or account for their preparation. The existing `JointEvidence` binds the two readings to the same routing source.

The extension from permutations to coordinate-selection maps uses no new reconstruction rule: repeated signatures identify repeated selections. A local selection map need not be reversible. A proposed closed realization must retain any distinctions it claims to preserve in its remaining internal structure. That retention does not follow from the signature decoder. Arbitrary Boolean functions of several inputs are a larger family and are not identified by these probes.

**Same whole does not entail stationary routing.** A resident two-position schedule may supply identity for the first probe and the first-two-address exchange for the second. Both observations then belong to one whole. Their joint recorded fact is exactly the fact produced by the fixed exchange, and reconstructs a valid permutation. Nevertheless that permutation was not the initial routing. `RoutingResidentSchedule` and `RoutingOneWholeCanHideLawChange` exhibit this inside a single paired source. Thus checking that the reconstructed signature tuple is a permutation cannot certify that the law remained fixed. The same-routing premise is a relation to establish about the internal mechanism, not a consequence of global closure or consistent-looking records.

The recovered object is behavior on the declared routing family. Two exchanges and the empty action have the same routing coordinates while retaining different operation words. Equal probe facts also occur for distinct nominal sources. `Checks/RoutingProbe.swift` supplies the generic reconstruction and positive counterexamples. Eight isolated refusals check the missing-image, source, address-order, stationarity and identity boundaries. These certificates do not identify physical histories or recover a new, unobserved data input.

## §6zn. Reusing acquired routing with an explicitly read new input

A routing signature determines which input address supplies an output. It does not contain the value at that address in a new input. Let I be a fixed routing object from VC74 and X=(x₀,x₁,x₂,x₃) a supplied new data image. X's coordinates may be arbitrary structural values. Only the calibration signatures are binary.

**Claim VC75 (acquired routing and a read new input determine the routed output).** In the four-clause coordinate-selection grammar, the application to (I,X) factors through (recorded probe images of I, X). The decoder's input explicitly contains X. For every admitted routing and all supplied X, reconstruction of the signatures followed by their coordinate selections agrees with direct application of that same I to X. The equality is derived without requiring the final output as a premise.

**Derivation.** `Route00`, `Route01`, `Route10` and `Route11` read respectively x₀,x₁,x₂,x₃ from a pair consisting of their address signature and X. `RoutingApplication` assembles the four independently selected outputs. Its admissible clauses form the product of the four address choices, including repeated choices. The generic body does not restrict the data values to calibration bits. `RoutingApplicationFromProbes` applies VC74's reconstruction and then those same four clauses. Its direct reading uses the actual I, while its decoder uses the canonical signatures reconstructed from the observed bit planes.

`EvidenceBesideInput<F,X>` derives product transport for any supplied factorization F: the source becomes (F's source,X), its observation pairs F's observation with a reading of X, and its decoder accepts both observed arguments. `RoutingMemoryBesideInput` specializes this to acquisition of the probe images. Composing it with `RoutingApplicationFromProbes` through `AnswerOnRefinement` gives the claimed decoder on (probe fact,X). The probe fact has no X parameter. Changing X therefore requires access to the new data, while the law fact can be reused. Distinct nominal routing sources with the same coordinates give the same decoder, although substituting one source's acquisition for the other's still requires a source relation.

**What the transport certificate checks.** The four supplied clause types occur on both sides of `RoutingApplicationFromProbes`. Within the declared Route00/01/10/11 grammar, each address fixes its clause and its selected value. The broader generic signature also accepts other `PredicateReading` constructors. `ReuseForged00` uses the 00 address and the same question but returns 1 on an all-zero input. It composes with acquisition and yields a different output from the valid route, despite the same declared source, question and decoder input. `Checks/RoutingReuse.swift` positively checks all these relations. Thus factorization preserves the supplied reading; it does not certify that an arbitrary reading implements coordinate selection. The four-clause premise is necessary mathematical content, not a consequence of successful type transport. The reconstruction theorem for the recorded signatures remains independent of this choice of application clauses.

`RoutingCalibration.swift` checks the application-to-probe bridge within that grammar. Each `SelectionCalibration00/01/10/11` applies its actual selection constructor to the prepared p and q and derives the declared address signature. `CalibratedRoutingBasis` assembles any four such witnesses, including repetitions, and derives agreement of the reconstructed routing with their calibrated addresses. No reconstructed whole answer is requested as a premise. This gives the two bit-plane readings their application meaning inside the declared family.

Calibration still does not establish that family. A constant-zero reading with address 00 agrees with Route00 on both prepared probes, yet differs on a new input whose first value is 1. The checks exhibit this positive boundary and reject both a wrong calibration and its invalid extension to all inputs. Thus the three obligations are visible separately: correct calibration on the probes, membership in the law family on future arguments, and transport of the acquired evidence. Adding a marker that names family membership would not derive any of them.

**Boundary and continuation.** Under identity routing, changing X from (0,0,0,0) to (1,0,0,0) changes the output. Hence the law fact alone cannot supply that output on unknown X. Conversely a constant input makes identity and exchange agree, so equality of one new output does not identify their laws. The source I used for calibration also occurs in the direct application. Replacing it by another actual routing, even one with the same fact payload, is not licensed by this factorization. VC74's changing resident schedule remains a counterexample to inferring that relation from record consistency.

The acquired output can itself supply another question. The checked K application sends X=(0,0,1,1) to (1,0,1,0), which supplies the exact input of the existing `Boundary1010` common-answer table. Composing through `QuestionOnObservation` derives that table from the same law record and read X. The old `Boundary0011` table has the wrong input and is refused. This joins acquired law evidence to the earlier common-behavior construction without inserting a precomputed table answer.

`Checks/RoutingReuse.swift` checks generic exchange and repeated-selection results for arbitrary data, the decoder's explicit input, independence of the law fact from new data, and nine invalid extensions. The result supplies a static factorization and its availability premises. It neither forces a physical acquisition nor proves that an unspecified instrument can read all of X without resources. The declared model keeps the routing source, new input and records internal. A new physical application must realize this same-routing relation, rather than repeat its operation label alone.

## §6zo. Two resident instruments acquire the probe pair

The joint observation of VC74 can be realized in a finite prepared relation with one source and two resident instruments. Each instrument carries its channel, quiet phase and blank trace slot. The source occurs once. The instrument whose address is currently beside that source is the focused one.

**Claim VC76 (two prepared resident records suffice for acquired routing and reuse).** Starting from this prepared whole, recording the first probe, exchanging the instrument addresses and recording the second produces two source-bound facts. Those facts decode the joint probe images and hence the routing. With the explicitly read input from VC75, the same two facts also decode its routed output. The initial preparation can be recovered from the final whole on the constructed range.

**Derivation.** `TwoResidentReadings<A,B>` requires A and B to read the same actual source. Its first step is `PreparedTraceExtension` beside the untouched second instrument. `ExchangeResidentInstruments` exchanges their addresses while retaining the source and both complete instrument states. Its second step records B beside the retained first record. `FollowedPair` checks both exact intermediate objects. `ResidentProbeFacts` selects the two final records in original question order, and `TwoResidentAnswers` derives their joint decoded answer. `AnswerOnRefinement` supplies routing reconstruction. `EvidenceBesideInput` then supplies the new-input reuse. The final decoder receives two facts, with no source parameter. `AnswerInResidentProbePair` checks the retained source, signalled instrument states, channels and record addresses before naming that decoder at the whole.

The two phase coordinates pass through (quiet,quiet), (signal,quiet), (quiet,signal), (signal,signal). This orders the declared forward steps without an external clock value. The focus step adds no observation. Reusing an occupied first slot, skipping the focus step or reading the second record before acquisition violates a different seam. The inverse of the focus exchange and the prepared predecessor constructions recover both initial instrument states from the final whole. Thus the forward ordering does not prohibit reversal, and returning both instruments to their initial states also removes their acquired evidence. Continued accessible learning requires retention somewhere inside the whole.

The finite realization supplies prepared recording instruments and their internal rearrangement. Its probe readings still assume the coordinate-routing family and calibrated channels of VC74. It does not derive a sensor or its calibration from global closure. `Checks/ResidentProbePair.swift` checks record preservation, source retention, prepared recovery and acquired reuse, together with seven invalid transitions or decoder placements.

## §6zp. A changing mechanism can carry the same acquired law

VC75's shared routing does not require every internal state of a mechanism to remain fixed. Write the whole as ((I,H),J): a module containing routing I and internal state H, beside resident reserve J. The internal exchange ((I,H),J)↦((I,J),H) changes the module and retains its previous state in the reserve.

**Claim VC77 (acquired law evidence transports across a certified mechanism change).** The routing observation commutes with this internal state exchange through an identity update of its image. Old source-bound probe evidence therefore answers the law question after the exchange, and after every correctly composed finite repetition. When a new data image is explicitly supplied beside the whole, that same evidence also supplies the routed output after the change. No equality H=J is required.

**Derivation.** `FactorOnSource` pulls an existing factorization back through a specified reading of the larger source, preserving its decoder. `ResidentRoutingFactors` applies it to the routing inside the module. `RoutingModuleExchange` derives a commuting square: the actual source step exchanges H and J while both endpoint observations read I. The compiler verifies the generic square without a final-answer equality premise. `FutureOnEvidence` transports an acquired instance of the initial observation through that square. `JoinedTransition` composes repetitions at their exact endpoints. `TransitionBesideInput` carries the square beside a supplied X, and the endpoint `RoutingApplication` selects its values by the transported law.

The source and module can therefore change while the acquired law remains usable. The derivation names the actual transition and retains its operation word in the future question. It does not replace a post-change source reading by a pre-change reading with a coincident answer. The final decoder omits H and J, while the transport certificate remains tied to their actual source chain. The positive instance H=0,J=1 changes a module field, so this is more than a nominal wrapper change.

**A different internal move reopens the law question.** `ExchangeRoutingWithReserve` sends ((I,H),J) to ((J,H),I). It retains both structures but replaces the module's routing. Take the same I and two reserves, identity and K. The old probe facts about I coincide in those worlds, yet the new first routing-signature bits are positively distinct. Thus those facts do not determine the future law under this larger action family. Knowledge of the reserve, whether from an accessible old record or another acquisition, can supply the missing distinction. Equality of operation labels or whole closure cannot replace that evidence.

`Checks/RoutingTransport.swift` checks old-evidence reuse, changing module fields, retained reserve state, two-step composition, new-input application and the routing-replacement counterexample. Eight isolated invalid extensions check wrong actual sources, endpoints, path seams, omitted input, erased operation words and an unjustified invariant. The criterion for reuse is a certified image update on the admitted internal transition, which can allow an actual mechanism state to change.

## §6zq. The acquired law determines which new input coordinates matter

VC75 supplies a complete new data image. That is sufficient but can exceed what a particular routing needs. Fix a known coordinate-selection law r on four output addresses. Let S be the set of input addresses selected by those outputs. For the reading bound below, each available input channel reports one coordinate. The unknown input ranges over the full product of its coordinate domains, each with at least two values, and no prior input evidence restricts that product.

**Claim VC78 (the exact coordinate-reading demand is the selected-address set).** To determine the complete routed output on this domain, reading every address in S is sufficient and necessary. Thus a permutation requires four coordinate readings, while the route selecting the first address at all four outputs requires one. The count concerns this input-channel family. It does not count VC74's complete probe images as individual coordinate reads, nor assign four calls to an instrument that already exposes all of X at once.

**Derivation.** Each output copies the value at one selected input address. Reading the distinct selected addresses therefore supplies all outputs, reusing a read value wherever its address repeats. If a selected address remains unread, change only that coordinate to another permitted value. Every acquired coordinate answer is unchanged while an output selecting the changed address differs. The same argument applies to a proposed adaptive reading sequence: those identical earlier answers select the same sequence, so it cannot stop correctly with a selected address unread. This proves necessity throughout the declared product domain. Existing evidence relating the input coordinates can reduce the requirement and is outside this premise.

`RepeatedFirstFromObservation` implements the one-coordinate case as a generic source-bound factorization. Its direct question is the existing `RoutingApplication` on the complete source pair (routing,X). Its observation pairs the acquired law fact with `FirstDataCoordinate<X>`. `RepeatFromFirstRecord` receives exactly that pair, and produces the four repeated values. No X or unused data coordinate occurs in this decoder's type arguments. The proof remains valid for arbitrary values in the unread coordinates. It even permits an opaque unused branch of X, because the selected address does not require that branch's pair structure. This larger structural domain does not erase the actual source or infer the contents of that branch.

The identity route supplies a positive boundary. Two new inputs with the same first value and different second values have the same restricted observation, including the same correct identity-law fact. Their identity outputs differ. Hence the repeated-first reduction cannot be reused for identity. A changed law can alter which input address must be read even when the number of required readings remains one.

Under a separate preparation of four independent fair input bits and a fixed repeated-first law, the output has one bit of entropy while the complete input has four. The other three bits remain in the retained source and are irrelevant to this output. Reading the first value resolves the output without resolving the whole. Neither this probability assignment nor these numerical entropies are needed for the coordinate-demand proof.

`Checks/RoutingDemand.swift` checks generic output reconstruction, absence of the three unused values from the decoder, acceptance of opaque unused structure, and positive necessity counterexamples. Seven refusals check wrong laws, missing data, wrong argument layout and attempts to recover or read omitted information. The general selected-set count follows from the finite-coordinate argument above. The static implementation exhibits the strict one-coordinate reduction and the failed extension to identity, without a runtime support-set calculator.

## §6zr. The observed law includes the internal output frame

VC74 fixes the input signatures and the order of the recorded output addresses. A module's output ports can be connected to those record addresses through an additional internal component. Call this connection its output frame. The module and frame belong to one whole, and both cases below use the same record format and probe questions.

**Claim VC79 (probe facts identify the composite routing without necessarily identifying its components).** Compare a routing I followed by a frame that exchanges the first two outputs, with routing E(I) followed by a direct frame. The two complete probe images coincide for every admitted I. In particular, identity with the crossed frame and E with the direct frame have distinct module routings but the same records. They also produce the same framed response on every supplied data input. Probe facts alone therefore cannot identify the bare module routing across this enlarged family.

**Derivation.** `ProbeThroughCrossedFrame` applies the first-two-coordinate exchange to each bit-plane output. `ProbeThroughDirectFrame` reports the bit planes unchanged. `RoutingFrameAgreement` derives their equality when the same exchange instead acts on I's output-address ordering. Its generic body does not assume equality of the observed images or of the actual sources. In the identity/E case, both data-response paths produce (x₁,x₀,x₂,x₃) for arbitrary data values. The module routings themselves differ at a positively distinguished signature bit.

Applying `RoutingFromProbeImages` to the common acquired fact correctly recovers the composite routing at the instrument's recorded addresses. If the crossed frame is independently established, its known inverse exchange recovers the module's routing coordinates. `FrameKnownCorrection` derives that correction generically. Applying the correction under the wrong frame fails. The calibration premise concerns an internal connection and does not require a reader outside the whole.

This locates the address premise in VC74: its recovered object is a relation between the specified input and observed output addresses. Calling it the law of one component requires a bridge from those observations to that component's ports. Stable-looking records, even records predicting all data applications through a fixed composite, do not determine its decomposition. An internal reading or intervention that distinguishes the frame can provide additional evidence. `Checks/RoutingFrame.swift` supplies the generic frame agreement, arbitrary-data witness, known-frame correction and four invalid extensions.

## §6zs. Existing knowledge, a new question and one necessary acquisition

The demonstration fixes its questions before constructing their memory decoders. Write a symbolic source as (a,b,h). The present question reads a. S exchanges a and b. G exchanges b and h. The mixed question executes G, then S, then reads the first coordinate. Its answer is h. These are the existing coordinate operations of Saturation, without a claim about physical conversion of spectral lines. Their laws are supplied by the constructors.

**VC80 (a new question can require either a different reading of old memory or one additional acquisition).** Suppose the acquired memory contains addressed facts for a and b from the same unchanged source. It answers the present question with a and the question after S with b. Restricting its interface to the first fact loses the latter capability on the unrestricted binary source family. The complete two-fact memory still cannot answer the mixed question on that family. One prepared reading of h is sufficient, and at least one new source-dependent reading is necessary if all other available evidence and apparatus settings agree across the unresolved h alternatives.

**Derivation.** The direct S application returns (b,a,h), so its first coordinate is the recorded b. This is a new consequence of the same memory, with no appended observation. Sources 000 and 010 have the same first fact and different S answers. Sources 000 and 001 have identical complete a/b memories and different mixed answers. Their third prepared instrument, channel address and fixed command tape also coincide. Every single-valued decoder or fixed processing of those identical accessible inputs gives the same result. It cannot supply both mixed answers. The declared h channel supplies one reading that separates them. Its recorded value answers the mixed question. The source remains inside the complete represented whole while this access changes. ∎

The generic bodies of `KnowledgeCurrent` and `KnowledgeSwapFromTwo` derive the first two answer paths. `KnowledgeMixedQuestion` names the independent mixed source application. `KnowledgeMixedFromThree` factors that application through the acquired three-fact memory using the existing `FutureOnEvidence`. `KnowledgeRetainsOld` recovers the old fact pair from the new memory, so an earlier decoder remains usable through `AnswerOnRefinement`. A constructed fact shape on its own supplies no source-bound acquisition.

`KnowledgeAcquisition` uses three resident instruments. Its initial whole contains the source once and all three prepared slots. The existing two-instrument schedule runs beside the quiet third instrument. `FocusThirdInstrument` exchanges addresses while retaining the two earlier instruments, then the third instrument acquires h. All pair compositions meet at their exact intermediate objects. The finite preparation is a premise of this model. The need for h does not conjure a channel, a blank or an unbounded reserve.

`KnowledgeResidentRun` places the two-command word inside that initial whole. After acquisition, a readdressing moves the source beside its tape while the three instruments remain in a bank. The existing resident-command construction executes both exchanges and retains consumed heads in its internal past. Checks identify the actual final source with the endpoint of the independent question and show that the final fact view is exactly the prediction decoder's input. There is no external operation selector in this fixed run. The generic family compares possible declared runs rather than supplying an agent that autonomously discovers their laws.

**VC81 (the required distinctions close under the admitted continuation family).** On the eight binary coordinate states, the least representation sufficient for every future first-coordinate question has two classes with no operations, four classes with S alone, and eight classes with S and G together. With G alone it still has two classes. Once the three coordinate facts have been acquired, they support every specified finite mixed word over S and G without another source acquisition, under the supplied transition and access laws.

**Derivation.** With no operations, exactly a matters. S has period two on coordinate contents, so (a,b) is sufficient for every S word. A zero-length word separates differing a values and S separates differing b values. G alone preserves a. With both generators, the zero-length word, S, and G followed by S expose a, b and h respectively. Any two different binary triples therefore have a separating permitted question. Conversely the complete triple updates by coordinate permutation under both generators. The two existing commuting squares compose by `JoinedTransition`, and induction covers every finite word. `KnowledgeFromThree` reconstructs that same triple from the actual resident facts, so composition with its factorization supplies every such future answer. ∎

The finite class counts refer to coordinate representations. Arbitrary nominal Swift wrappers and occurrence histories are not identified with those classes. The reconstruction and generator witnesses work for the supplied integer-valued coordinates beyond the binary instance. Minimum distinctions do not imply minimum byte count, energy or running time. The all-word result concerns the declared grammar, rather than a compiler search over arbitrary future interactions.

This gives a concrete propagation test. Admitting G alongside S changes a/b from a sufficient image to an insufficient one. Adding the resident h reading restores sufficiency. Reversing the two-command word instead changes the particular answer back to b, and old memory already suffices for that question. The operation word, evidence requirement and answer change together. Named refusals check omitted operation identity, reversed order, foreign evidence, fabricated records and broken resident seams. Positive separators establish the mathematical insufficiency that a failed conformance alone would not establish.

## §6zt. Known data changes how much of a law must be acquired

VC78 lets a known routing reduce the required data interface. The converse is also concrete: relations in supplied data can reduce the required law interface. Here the unknown law is one of the four single-output clauses Route00/01/10/11. Its prepared binary arguments are the existing p=(0,0,1,1) and q=(0,1,0,1). The new data is supplied separately. It is not guessed from the probe record.

**VC82 (data equalities coarsen sufficient law evidence).** For data x=(a,a,b,b), one recorded p response determines the selected value across all four admitted laws. Response 0 gives a and response 1 gives b. If a and b are positively different, the supplied data alone cannot determine the answer on the unrestricted four-law family. For constant data (a,a,a,a), no law probe is required for the answer. For unrestricted four-coordinate data, both p and q are sufficient, while either alone can be insufficient. These probe counts concern the declared binary p/q interface and assume the relevant new data is available.

**Derivation.** The four p responses are 0,0,1,1. The four applications to x give a,a,b,b. Thus laws 00 and 01 share one decoder on the first fact and x, and 10 and 11 share the other. The column is absent from those decoder inputs. Laws 00 and 10 require different answers when a and b differ, so a common evidence-free answer fails. With constant data, every route reduces to a, giving the law-independent decoder. To test unrestricted data after p, take x=q. Laws 00 and 01 give the same p fact and different new answers. To test q alone, take x=p and laws 00 and 10. On the single input (0,1,1,0), either permitted probe alone leaves a positively different output pair unresolved: 00/01 after p and 00/10 after q. Even choosing between p and q from these known data cannot settle the answer in one reading. The pair of probes recovers each complete signature by the existing calibrations, so it is sufficient for all supplied data in this clause family. ∎

`FirstSelectionProbe` includes p in its actual input. Its four admitted calibration witnesses agree with the actual Route applications to p. `ScopedPreparedProbeProducesActualFact` relates the recorded fact to the output of a prepared internal instrument beside x. `RowSelection00/01/10/11` derive the direct application and memory answer equalities for arbitrary structural a and b. Their two `SharedDecoder` witnesses verify that the same observed input uses the same decoder across the unresolved column alternatives. `ConstantSelectionEvidence` derives the four equal outputs, and `ConstantSelectionAnswer` accepts only the constant data. These are finite clause-family proofs, without a general search or dispatch mechanism for arbitrary Swift conformers.

**VC83 (answer preservation can survive a change of the law itself).** On the repeated-row data family, the internal replacement 00→01 preserves the selected value for all a and b. The old first-probe record remains sufficient for the question after that change. The laws are distinct and disagree on other inputs. Replacement 00→10 can change the selected value while the old first-probe record remains identical. Therefore reuse needs a relation preserving the relevant answer, rather than identity of the entire mechanism.

**Derivation.** Both 00 and 01 select a on (a,a,b,b). They are separated by their q responses, so equality of their answers on this family does not identify their laws. For 00→10 the endpoint selects b, which differs from a on the positive binary instance. `ExchangeSelectionReserve` exchanges the current law with a resident replacement, retaining the old law, p and x. `SelectionAfterReserveChange` names the actual exchange followed by the endpoint application. `RowLawChangePreservesAnswer` derives its equality to the old memory decoder under the specified within-row replacement. The decoder contains the change question but no new acquisition. The old observation omits the replacement law, and a positive pair shows why it cannot justify an arbitrary replacement. ∎

`ScopedLawResidentRun` joins one prepared probe to the actual law change. The replacement law is present initially. The instrument's record and channel survive, and the old law moves into the reserve. The checks project this run onto the independent endpoint question and identify its surviving memory with the reused decoder input. An equal response after the change is not presented as a fresh probe or as proof that the law stayed identical.

The continuation scope matters in both directions. Enlarging the new-data family can make the unmeasured column consequential even with an unchanged mechanism. Restricting the data can make a genuine mechanism change harmless for the requested answer. A saturated law representation is therefore relative to the data and question family it must support. Complete law identification remains a sufficient stronger object, but is not required for every consequence.

## §6zu. A unique answer need not have a unique smallest input interface

VC60–VC62 already transfer an answer between compatible realizations, and VC83 permits a change of the actual law while preserving a scoped answer. No new transfer principle is needed for M66's alternative supports. The separate question is which available input interfaces suffice, and whether their minimum is unique.

**VC84 (adequate input subsets form an upward-closed family, with an exact minimal basis).** Fix a nonempty admitted source domain D, a question q on D and finitely many addressed readings e_i indexed by I. All readings have fixed interpretations. Write e_S for the joint reading at the addresses in S⊆I, and call S adequate when q factors through e_S. The empty reading has one image. An adequate subset supplies an interface sufficient for every source in D. A certificate on one actual source has a narrower scope.

By VC9, adequacy is equivalent to the following condition:

    q(x) ≠ q(y)  implies  e_i(x) ≠ e_i(y) for some i in S,
    for every x,y in D.

Define Δ(x,y)={i∈I:e_i(x)≠e_i(y)}. The adequate subsets are exactly the subsets meeting every Δ(x,y) for unequal-answer pairs. This is the uniform counterpart of Interference S5b's certificate on a fixed source. The domain D need not be finite, but the condition covers every admitted pair. It is not an enumeration procedure or a claim that a sample covers D.

Adequacy is upward closed: extra readings refine the old joint image, and a decoder can ignore their answers. If the full I is inadequate, every subset is inadequate. Otherwise each adequate S contains an inclusion-minimal adequate subset, obtained by removing dispensable members until no removal is possible. Finiteness of I ends this descent. Let 𝔅 be the family of all such minimal subsets. Its members are pairwise incomparable by inclusion, and

    S is adequate  iff  some B in 𝔅 is contained in S.

This basis is unique as a family of subsets. It need not contain just one member. A least adequate interface exists exactly when the intersection of all adequate subsets is adequate. Equivalently, the nonempty adequate family is closed under intersections. For the forward direction the least member belongs to every adequate subset. For the converse the adequate intersection is itself the least member. Since I is finite, pairwise intersection closure suffices. QED

**Full coordinate products give a stronger result.** Suppose D is the full product of nonempty coordinate domains and each e_i reads exactly coordinate i. If S and T are adequate, so is S∩T. To prove this, take x,y agreeing on S∩T. Construct z with x's coordinates on S and y's on T, choosing the other coordinates from x. The overlap agrees, so z exists in this product. Adequacy gives q(x)=q(z) through S and q(z)=q(y) through T. Thus q factors through the overlap. The constructed tuple z must belong to the admitted domain.

In this full product, the least adequate subset is exactly the set of essential coordinates: i is essential when two admitted sources differing only at i have different q-answers. Every adequate subset must include each such i. Conversely, two sources agreeing on all essential coordinates can be connected by changing the other coordinates one at a time. All those intermediate sources are admitted, and every step preserves q by nonessentiality. This proves sufficiency. VC78's selected-address result is its routing instance. No physical independence or probability distribution follows from the product premise.

**Correlated sources can have alternative minima.** Reuse VC62's CommonPair<A>. Its two addressed alpha readings both give A, while the component forms have different other fields. Restrict A to Never and Lit1 for the obstruction. Either singleton reading suffices to answer the first-alpha question on this family. Their intersection is the empty interface, which gives one image for the two positively different required answers. The two singleton supports are minimal, with no least adequate subset. There is no admitted change of just one alpha coordinate, so the essential-coordinate test from the full-product theorem cannot be carried over to this domain.

The static witnesses reuse existing operations. AcquireAnswer records the second application, and AnswerThroughAgreement with ReversedVerdict transfers its decoder to the first question. No new observation, history equality or answer equality is added to that transfer. Checks derive the unchanged observation and decoder, and the same canonical answer fact through either route. The empty observation has equal images for the zero and successor cases, whose required answers have the existing positive constructor distinction. Its zero decoder works on the zero case and is rejected on the successor case. This rejects the simultaneous deletion of both alternative supports, not the use of either one.

It is therefore invalid to remove every input that is individually dispensable relative to the original interface. Sequential removal remains sound if adequacy is established after each removal, and ends at an inclusion-minimal interface. That does not prove minimum cardinality, minimum cost or a policy that discovers the best interface. S5b already distinguishes certificates from implementable query policies.

The answer partition itself remains fixed by q: sources are equivalent exactly when their q-answers agree. VC60's canonical fact represents that required answer. Different addressed carriers can realize it, and a carrier may retain extra distinctions. Unique content, a least abstract answer partition and a unique minimal set of physical or software inputs are different claims. Whole closure does not authorize adding the crossed sources needed by the product proof.

## §6zv. How much contact information makes an old record reusable?

VC83 shows that a changed law can preserve a scoped answer. VC79 shows why a changed observation frame can instead change what a record identifies. The next question is constructive: when several contact regimes remain possible, what additional reading is sufficient, and how small can its interface be?

**VC85 (exact reuse through a mode-dependent calibration).** Let X be a nonempty domain of admitted whole realizations, E:X→Z the retained record, i:X→I a finite contact-regime reading, and q:X→A an independently specified question. In a changing system, x can include the initial source, resident replacement and actual change; q then reads the endpoint. Neither E nor i is presumed to identify x. The proposed new calibration c:I→C may depend on the regime, but not additionally on E or the answer. Its actual acquisition is a separate requirement.

Join two regimes j,k by a conflict when there are x,y∈X with

    i(x)=j, i(y)=k, E(x)=E(y), q(x)≠q(y).

Allow a loop j=k. There is a single decoder d with

    q(x)=d(E(x),c(i(x)))  for every x∈X

exactly when c gives different symbols to the ends of every conflict.

**Proof.** A conflict with equal symbols gives identical complete decoder inputs and unequal required answers, so no decoder exists. Conversely, if two realizations give the same record and calibration, unequal answers would create a conflict whose ends have the same symbol. Their answers therefore agree. Assign that common answer to each realized decoder input. This defines d on its actual image. ∎

A loop means that even full regime identity cannot repair the record: another distinction within that regime is needed. With no loops, the minimum number of calibration symbols is the chromatic number of this conflict graph, namely the smallest number of labels separating every edge. This is a bound on a one-message, regime-only interface, not on entropy, average cost, a physical alphabet, or the existence of an instrument. The graph is derived from possible clashes of the independently specified answer; it is not a further prohibition imposed on the system.

A witnessed subgraph already supplies a lower bound for every extension that preserves those witnesses and the same calibration-access contract. More possible realizations can add conflicts or loops; they cannot repair a collision between the preserved decoder inputs. A sufficient colouring of the witnessed subgraph, however, need not suffice for the enlarged family. Thus the impossibility side can survive unknown internal detail without a complete classification of realizations. The sufficiency side still needs its declared coverage. This is M71's preserved-obstruction principle applied to the size of an acquisition interface.

If the available calibration instrument reads only b:I→B, any implementable c=f∘b must also identify regimes with the same b-value. Collapse those vertices, keeping all conflict edges. A resulting loop proves impossibility for every processing of that instrument's output. Otherwise the chromatic number of this quotient graph gives the minimum size of such a processed calibration. This applies PP19 to the actual access restriction: renaming an unchanged record cannot create the missing contact distinction.

This is an application of the established characteristic-graph method for function computation with side information, not a new graph-colouring theorem. [Doshi, Shah, Médard and Effros, *Functional Compression through Graph Coloring*, Definition 2](https://www.mit.edu/~medard/2010papers/funccomp.pdf) gives the corresponding conflict relation. The proof here uses possible admitted pairs alone; it introduces no probability distribution, asymptotic code or allowed error rate.

**VC86 (a binary answer can require three calibration symbols, while admission requires five).** Fix five ports p₀,…,p₄ and the five ordered seams e_j=(p_j,p_{j+1}), with indices modulo five. A record is z=(e_j,a,b), retaining the seam and its two payloads. The active port is one of that seam's endpoints. The question asks for the payload at the active port: a at p_j and b at p_{j+1}. The payload domain contains two distinct contents. The calibration may read the active port, independently of which seam and payload are presented. All these objects and contacts can be parts of one whole.

The records can precede the change. Prepare each seam with its first endpoint active, record the seam and payloads, and then exchange the active port with a resident choice of either endpoint. Retain the displaced port and the record. This supplies both admitted endpoint alternatives at every seam without an external source or erasure of the old port. The calibration concerns the resulting active port; an earlier port fact need not answer that question.

Two neighboring ports conflict: the same seam and distinct payloads require different answers. Two nonneighbors share no admitted seam record, so they do not conflict. The graph is exactly the five-cycle. Two symbols would have to alternate around it, making the final and first ports equal despite their closing conflict. Three suffice:

    port:    p₀ p₁ p₂ p₃ p₄
    symbol:   A  B  A  B  C

For each recorded seam its endpoint symbols differ; the received symbol selects one endpoint's payload. The calibration symbol alone does not identify the port. On admitted contacts, the seam together with that symbol does identify it; this example does not show nonidentification by the complete decoder input. Every proper subset of the five seam constraints admits two symbols, but their complete cycle does not. A collection of locally sufficient repairs need not supply one repair for the complete interface.

If admission is no longer a supplied premise, enlarge the source scope to every port/record pair. Require either `Refused` when that port is not incident to the seam, or `Present(value)` with the selected payload. Every pair of different ports has different incident-seam sets. Some record is therefore admitted at one and refused at the other. All five regimes now conflict, and five symbols are necessary and sufficient. With the three-symbol calibration, p₀ and p₂ share A: a record on e₁ is refused at p₀ and admitted at p₂. Their complete accessible inputs coincide. The earlier three-symbol result remains correct on admitted occurrences. The five-symbol requirement concerns both the stronger question and removal of the admission premise.

If the port question or seam reaches the calibration instrument before it reports, the regime-only restriction changes. For example, reporting the endpoint side after inspecting the seam uses two symbols on admitted contacts. That instrument reads an additional relation. It is not a two-symbol solution to the original interface contract. Likewise, restricting all payloads to a=b removes the value conflicts, but does not remove the admission conflicts.

**Cross-check on the existing routing problem.** VC82 fixes four coordinate-selection laws before this criterion. On repeated-row data (a,a,b,b), with the supplied data as E, its conflict graph is the complete bipartite graph between {00,01} and {10,11}. Two calibration symbols are necessary and sufficient: the p probe reads precisely the required row. Constant data removes every edge. Unrestricted data makes every pair of different selectors conflict, requiring four symbols for a regime-only calibration. This recovers the earlier sufficiency bounds through the new criterion without choosing a new routing example to fit it.

For VC83's initially prepared law 00, replacing it by either 00 or 01 creates no answer conflict on repeated-row data; the old record needs no repair. Allow all four resident replacement laws and one newly acquired row bit suffices. The old p=0 record cannot separate replacements 00 and 10 on unequal rows, so some new distinguishing relation is necessary. `RowLawChangeReacquiresAnswer` pulls the existing RowSelection10 factor through the actual reserve exchange. It derives the independent endpoint question from the newly acquired probe input. `ContactRepairsRouting` checks its initial source, endpoint answer and exact new memory. The replacement law remains partly unidentified.

**Static construction.** `ContactLeftValue` and `ContactRightValue` read actual source payloads under endpoint-identity constraints, independently of calibration. `ContactCalibration` projects a chosen code stored in the resident port. `ContactFacts` binds its acquired record and the retained seam/payload record to the same source. `CalibratedContactCycle<A,B>` derives reconstruction for both endpoints of all five seams and arbitrary structural payloads. Its decoder grammar consists of three projection-built rows and the existing Route00/01/10 clauses. The aggregate packages ten source-bound obligations, not ten observations claimed to have happened in one experiment. Disjoint seam/code inputs make these particular clauses one partial decoder; arbitrary PredicateReading conformances do not acquire that meaning.

`ContactReserveChange` exchanges the active port with a resident replacement and retains the displaced port. Its second application recovers the supplied pair construction. `ContactChangeRetainsRecord` derives that the record's content survives this change. Its source history does not become a fresh acquisition. A prepared internal calibration instrument produces the exact new fact required beside the old record. The five-cycle construction reads the current calibration; the old code is not silently treated as current. `OddContactCalibration` derives collapse of the two marker positions from five reversal equations. A positive distinction between those markers forbids their simultaneous realization. No runtime solver or status registry supplies this implication.

`Checks/ContactCalibration.swift` tests the arbitrary-payload construction, the actual retained record, and a pair with equal accessible inputs but opposite answers under a two-symbol calibration. It also presents the admission collision positively: the three-symbol decoder still has an answer on the common record, while an endpoint source application for the inadmissible port cannot be constructed. This separates a decoder's ability to produce a value from its authority to certify contact admission.

The resulting research boundary is operationally useful. A record can survive intact while the information needed to interpret it changes. The necessary repair is determined jointly by the retained record, the question, the possible contacts and the calibration instrument's access. This derives a minimum for a specified interface. It does not establish that these five contacts exhaust a physical situation or that a real calibration law has been acquired.

## §6zw. Acquiring an answer through the available probes

VC85 minimizes a calibration's message alphabet. It does not minimize the number of source interactions needed to obtain a usable message. Fix that access now. For VC86's five ports, write the chosen resident codes as 00,01,00,01,10. The available primitive probes read their first or second coordinate. The probing side starts with no port-dependent evidence; received requests and previous probe replies control its choices. A prepared probe records its result and retains the port; the old seam/payload record remains available to the receiver. The protocols below are deterministic and exact, and only the declared request and reply symbols cross the interface. There is no additional port-identity probe. This is an explicit finite instrument contract, not a consequence of the five port names.

**VC87 (a record-dependent request changes the acquisition bound).** On the admitted edge records with unequal payloads, a protocol with no record-dependent information reaching the probing side needs two primitive probes in the worst case. One request chosen from two commands using the old record, followed by one binary probe reply, suffices. Both the two-command request alphabet and the binary reply alphabet are minimal for this one-probe protocol.

**Proof.** A fixed first-coordinate probe confuses p₀ and p₁ at e₀; a fixed second-coordinate probe confuses p₄ and p₀ at e₄. In either case the old record agrees while the required payloads differ. Before any source observation and without record-dependent feedback, a controller cannot choose its first probe from the unknown port. More generally, a single binary message depending on the port alone cannot colour the five-cycle of VC85. Two probes suffice by acquiring both coordinates. Because the probe transitions retain the port, these are readings of the same code, not values silently collected from two different contacts.

For the interactive protocol, request the second coordinate at e₀,e₁,e₂,e₃, and the first at e₄. Each requested coordinate separates that seam's endpoints. At e₀ and e₂, reply 0 selects the first payload and reply 1 the second. At e₁,e₃,e₄, the interpretation is reversed. The request depends only on the old record; the reply depends only on the requested coordinate of the active port. A single request command would reduce to an inadequate fixed probe. A constant reply could not separate either endpoint pair with unequal payloads. ∎

This exchanges one request symbol and one reply symbol, each from a two-element alphabet. It reduces primitive source readings from two to one by making a distinction from the old record available at the probing boundary. It does not contradict the three-symbol one-way result, nor prove a reduction in total transmitted bits or physical cost. If the old record is known to have equal payloads and admission is promised, the receiver can answer immediately without this interaction.

The two fixed probes can acquire the old three-valued calibration, but that is only one sufficient procedure. `AcquireContactCode` reconstructs a supplied pair code through `TwoResidentReadings`; the source occurs once and survives both instruments. `ContactInquiryCycle` instead derives the five one-probe clauses directly from the independent endpoint questions. `ContactRequest` takes the old record as its whole input. `ContactSenderInput` constructs the actual `(command, port)` request at the sender, with no seam or payload field there. The reply fact keeps its requested coordinate question; it is not labelled a complete calibration. A prepared resident reply and the parked old record supply the exact decoder input. These constructors use the two specified projections, not an arbitrary allegedly correct reader.

**VC88 (the same conflict graph can require a different acquisition procedure).** Retain the five edge records and the same two primitive probes. Add a distinct tagged record z⋆ admitting p₀,p₁,p₄ together. Its independently assigned source values are a at p₀ and b at both p₁ and p₄. This is an additional record scope, not a claim that the earlier pair record already contained three possible endpoints.

For a≠b this record adds conflicts 0–1 and 0–4, both already in the five-cycle. It adds no conflict 1–4 because their required values agree. Different record tags prevent accidental equality with an old edge record. Consequently the full conflict graph and its minimum three-symbol one-way calibration remain unchanged.

Yet no choice between the two available probes resolves z⋆ in one source interaction. The first coordinate gives the same 0 at p₀,p₁, whose targets differ. The second gives the same 0 at p₀,p₄, whose targets differ. Feedback based on z⋆ cannot choose a probe avoiding both obstructions. Two probes suffice: their pair is 00,01 or10, and the first case requires a while the other two require b. The old nondisturbing probe law makes this sequential acquisition valid. Thus the optimal worst-case primitive-probe count with feedback increases from one to two, although the conflict graph does not change. ∎

`ContactStar` expresses the extra record as a tagged row `(a,b,b,b)` acted on by the actual Route00/01/10 clauses of ports 0,1,4. Its direct source applications are specified before their memory decoders. Three generic factors reconstruct those applications from the two resident probes, and `OuterAgreement` derives agreement of ports 1 and 4. The two one-probe collisions have equal complete accessible inputs and positively different source answers in `Checks/ContactInquiry.swift`.

The graph retains which pairs require separation somewhere. It forgets which conflicts have to be resolved together at one old record by one chosen probe. For the present nondisturbing model, one-probe sufficiency requires: for each old record e, there exists an available probe r_e such that every unequal-answer pair compatible with that same e is separated by r_e. This order of quantifiers is stronger than permitting a different probe for each pair. VC30–VC31 remain the procedure criterion when interventions change the source; no new policy solver is needed here.

**A changed source need not destroy the original question.** At seam01, admit either initial endpoint, with the opposite endpoint resident as a reserve. A known exchange occurs before the probe reply. The question still concerns the original active port. `ContactInquiryAfterExchange` covers p₀→p₁, and `ContactInquiryFromSecondEndpoint` covers p₁→p₀. One opposite decoder, bit0→b and bit1→a, returns the original answer for arbitrary payloads across both cases. The unknown initial endpoint is not given to the participant by displaying one constructor. The current-answer decoder fails on the positive unequal-payload instance. The displaced port and old record remain inside the exchange. Equal reply inputs are also exhibited for the first exchange and an unchanged p₁ source, while their required original answers differ. Thus the known intervention law matters. Omitting it cannot be repaired by calling the reply an observation of the original state.

**What the graph preserves, and what a procedure must preserve.** Let P describe an acquisition task, G(P) its labeled conflict graph, and C(P) its minimum guaranteed worst-case primitive-probe count. Keep the probes and interactive communication rules fixed as in VC87–VC88. For the edge-only task P₁ and its extension P₂,

    G(P₁) = G(P₂),     C(P₁) = 1,     C(P₂) = 2.

No reading d of G alone can therefore satisfy C=d∘G on a family containing both tasks. The same graph does determine the minimum alphabet of an unrestricted regime-only calibration, through VC85. This is the existing sufficient-reading criterion applied to a representation of tasks: the representation answers one question and loses a distinction required by another. It does not establish an inadequacy of pairwise relations in general. The loss occurs when their record contexts are aggregated away.

VC30–VC31 already supply the procedure criterion. In these examples, the supplied finite policies have minimum probe depths one and two; the known exchange transports the original-answer labels without recomputing them. To use that criterion across a distributed interface, preserve who may choose each action from which evidence. If h denotes a complete protocol history and V_j(h) the view available at side j when it acts, its deterministic action choice π_j must factor through that view:

    π_j = f_j ∘ V_j.

Equal local views must lead to the same action, even when the verifier distinguishes the underlying histories. This condition does not by itself establish a successful or available action; the declared action laws and every resulting branch must still satisfy VC31. A policy using the union of both sides' records can otherwise be successful as a centralized tree while being unavailable through the specified interface. In VC87 the receiver knows the seam before the request; the probing side does not. The transmitted command changes the latter's available view. Pooling those two views beforehand would silently erase the no-feedback boundary.

Thus the existing results form one chain: VC85–VC86 characterize a sufficient message, VC87–VC88 distinguish its representation from its acquisition, and VC30–VC31 certify available continuations with the original question retained. Neither a new graph vocabulary nor a separate status system supplies the missing relations.

This block supplies procedures and lower bounds under declared access, with explicit effects on their sources. It does not optimize over unspecified instruments, assign energy or timing costs, or infer that a chosen calibration field exists in a physical specimen. A new primitive that directly reads the z⋆ answer could change the interaction count; its availability would be a new relation to establish.

## §6zx. A message for choosing an available action

Matter M25 already identifies the allowed responses at one complete input as the intersection of the responses admitted by its possible sources. It also supplies the three pairwise-compatible rows with empty joint intersection and the example without a unique coarsest adequate partition. The next question concerns a minimum message, with the choice of response still free.

Fix a nonempty finite record family R and a finite declared action family U. At one fixed communication slot, a sender knowing r∈R sends s(r). The executor has no additional input that changes its choice and uses one agreed interpretation p of the message. For each r let W_r⊆U contain exactly the actions available on every source compatible with r whose resulting observation, together with r, suffices for the independently specified original answer. Availability and sufficiency are obligations on the actual action laws; writing W_r does not prove either. In particular an action may be available without being sufficient.

**VC89 (minimum signaling for a free adequate choice).** A message map s:R→M permits an adequate executor precisely when

    ⋂_{r:s(r)=m} W_r ≠ ∅     for every m∈s(R).

If every W_r is nonempty, the minimum number of used message symbols is

    min {|B| : B⊆U and B∩W_r ≠ ∅ for every r∈R}.

If some W_r is empty, no message alphabet supplies the missing action within this one-action contract.

**Proof.** The one action p(m) chosen at a message must belong to every W_r in its fibre. Conversely a member of each nonempty intersection defines such an interpretation; there are finitely many fibres. A protocol using k messages chooses at most k distinct actions, and those actions meet every W_r. In the other direction, take a minimum finite covering family B and, for each record, send the index of a member of B∩W_r. This uses at most |B| messages. The preceding lower bound gives equality. ∎

The minimum concerns the joint choice of encoding and policy, not compression of a previously fixed policy. One used symbol carries no positive distinction and can be omitted at the agreed slot. Alphabet size does not assign a cost to acquiring the record, manufacturing the interpreter or performing the action. The assumption that the executor has no further variable local input is essential. With such an input, a message can select a local rule rather than one constant action; the relevant covering objects then change.

For the fixed unequal-payload contacts in VC87, W is {Second} at seams 01,12,23, {First,Second} at seam34, and {First} at seam40. Both entries at seam34 follow from its codes 01 and 10. The singleton rows force two chosen actions; the two actual coordinate probes cover every row. The minimum request alphabet is therefore two even when the policy is not fixed beforehand. At z⋆ of VC88 the one-probe W is empty: extra request symbols cannot remove its need for a longer procedure with these instruments.

**Every optimal request policy in this finite instance.** Fix one distinct payload pair (a,b) for the five records, the message alphabet {0,1}, and the two coordinate probes as the executor's whole action alphabet. A successful one-probe policy must use both actions because of the singleton W rows. Its two-entry interpreter must therefore be a bijection onto {First,Second}. Seams 01,12,23 must send the label interpreted as Second; seam40 must send the label interpreted as First. Seam34 may send either. Conversely each such assignment works by the actual coordinate readings. Hence there are exactly four encoder/interpreter pairs: the two label permutations times the two choices at seam34. This exhausts the local choices under the stated alphabet and fixed record family, without a search script. It does not count policies over arbitrarily varying payload records or additional executor memory.

`LocalContactCycle` constructs one shared resident interpreter for all five seams, including both source endpoints and arbitrary structural payloads. `OtherSeam34` supplies the other allowed action on the flexible seam. `RenamedZeroLocalChoice` and `RenamedOneLocalChoice` derive preservation of the actual chosen action when both the request and the two table positions are exchanged. These are generic local lookup factorizations; the complete source-bound runs are constructed for the canonical labeling. The finite classification and this label symmetry account for all four policies, rather than silently imposing a unique choice at seam34.

The implementation begins with both probe instruments prepared at the executor. A different prepared instrument per hidden record could itself reveal which action to choose. `LocalContactRequest` instead acquires the request from the sender's actual record and delivers that acquired instrument while retaining the source, resident interpreter and both probe slots. `LocalSecondContactRun` and `LocalFirstContactRun` then focus the selected resident probe and return its filled instrument to the sender. All intermediate whole objects compose exactly. `ReturnedContactFacts` reads only the old record and the actually returned instrument at that endpoint. It cannot read an unfilled preparation as a reply. The generic endpoint factors derive the original payload through the existing decoders; no final-answer equality is asked from their caller.

`Checks/LocalContactPolicy.swift` exhibits the lower bound at the complete receiver input. A constant First choice collides on seam01; a constant Second choice collides on seam40. In each case the actual returned facts agree while independently read original answers are positively distinct. Those two witnesses cover the entire declared executor action family for a one-symbol request, irrespective of how its answer decoder is chosen. The acquired fact at the executor is also insufficient to authorize an early answer at the sender: before the return, that sender's old record still agrees at the unequal-target endpoints. Delivery, common local views, retained whole components, the flexible seam and coordinated relabeling are checked separately.

On the flexible seam, a wrong substitution of the performed action can still permit a correct final answer with a different decoder. Thus final-answer correctness alone would miss a departure from the supplied policy. `ActualLocalChoice` compares the actual table lookup with the coordinate question in the fact produced by the performed resident probe. Changing that primitive while keeping the table breaks this equality. The primitive is one of the two concrete projection constructions; a matching question label on an arbitrary reading would not establish the same guarantee.

M25's rows {u,v}, {v,w}, {u,w} are a control against replacing the joint intersection by a pairwise graph. One message fails; two actions, for example u and v, meet all rows and give a two-message construction. This reuses M25's established example. It is not a new obstruction theorem or a claim of a unique optimal partition.

## §6zy. Finite distributed policies with shared local choices

The recursion of VC31 concerns one observer's uncertainty. Choosing separate successful continuations at globally distinct nodes need not respect the equal local inputs of a distributed executor. Fix instead a horizon H, a declared finite nonempty initial domain D, finite nonempty command alphabets, and a scheduled order of participants that is locally known. Any phase used in a local view must be supplied by that schedule or an actual memory transition. The verifier's global node address is not an input. Sending, stopping and returning an answer are commands subject to the same access restriction. A send command includes its transmitted symbol and a return command its returned value; alternatively their production must be an actual local reading checked against that same view. A constant instruction named Send or Return cannot conceal source-dependent content. Fixed transmission slots and explicit symbols prevent uncounted signaling by timing or silence in this fragment.

Assume the declared transition relation is finitely branching through H. It gives action availability, all possible outcomes, and actual updates of the participants' local records. Its finite unfolding is sufficient here; no finiteness claim about the physical whole follows. Keep the original target q(x₀) as a verifier annotation. It is not inserted into any participant's view. For each unfolded history h at a decision by participant i, let V_i(h) be that participant's actually available input, and let L_i be the finite range of these views. A proposed policy is one total table π_i:L_i→U_i for each participant, with one entry for each identical local input wherever it occurs. A past observation belongs to V_i(h) only if a retained local record or another declared access supplies it. The verifier's ability to reconstruct h does not grant the participant perfect recall. Full local history is one permitted view when its retention is part of the contract; it is not the default meaning of L_i.

**VC90 (a bounded joint policy criterion).** A deterministic distributed procedure meeting the declared legality, original-answer and horizon requirements exists exactly when one joint family of those local tables passes every execution from D, including every permitted outcome. The criterion has the following finite construction, which preserves dependencies between branches.

Unfold all commands and outcomes through H before selecting a policy. Include a bad absorbing outcome for an unavailable command or a nonterminal dead end. A required reply that never arrives within the promised horizon cannot produce a successful leaf. Pad completed executions by verifier identity steps; this padding grants no new observation or action to a participant. A successful leaf must represent an actual locally chosen completion with output q(x₀); an unfinished leaf at H is bad.

Use one table variable P_(i,ℓ)∈U_i for every local input ℓ of participant i. For a complete unfolded path γ, let its guard be

    g_γ(P) = ∧ [P_(i,ℓ) = u]

over the actual participant decisions along that path. The local input ℓ=V_i(h) is computed from the declared access at that prefix h, not chosen freely for the guard. Erased local observations are not silently restored from the path. For every unsuccessful leaf impose ¬g_γ(P). Equivalently, each full path satisfies g_γ(P) ⇒ successful(γ). The resulting finite constraints are satisfiable exactly when the required local procedure exists.

**Proof.** Given satisfying tables, execute their selected command from each actual local input. The unfolding contains every successor, including failure, so no actual path disappears. The guard of every actual complete path holds. Its constraint excludes failure, unfinished execution and a wrong original answer; therefore every execution is legal and completes correctly by H. Repeated local inputs consult the same table entry even at distinct global nodes.

Conversely, a locally executable deterministic procedure within this contract assigns one command to each reached local view. Extend its tables arbitrarily to unreached views using the nonempty command alphabets. A path whose guard holds agrees with those tables at every decision and is consequently an actual execution, including its declared possible outcomes. All such paths succeed, so every unsuccessful path has a false guard. These extended tables satisfy the finite constraints. ∎

The guards prevent unreachable branches from creating false impossibility. They do not delete troublesome outcomes of a reached action: those outcomes remain separate guarded paths with the same selected action. The bad outcome prevents choosing an undefined action to satisfy an empty universal check. An inconsistent path demanding different commands at the same local input has a false guard, as it cannot belong to one deterministic local policy. The annotation q(x₀) checks the leaf; it never supplies the executor's answer or branch choice.

**A complete two-record instance of the joint constraint.** Restrict VC89 to one fixed unequal payload pair and the records r_S at seam01 and r_F at seam40. Let e_S,e_F∈{0,1} be the sender's two table entries and J₀,J₁∈{First,Second} the executor's. Success is exactly

    J_(e_S) = Second,     J_(e_F) = First.

If e_S=e_F the same entry would equal both distinct actions, so no interpreter works. If (e_S,e_F)=(0,1), the only interpreter is (Second,First); if (e_S,e_F)=(1,0), it is (First,Second). Thus exactly two of the sixteen encoder/interpreter pairs work. The reply and answer phases are supplied by the actual probe and corresponding local decoder for each record. This is a complete finite classification under these alphabets, not sixteen runs of a search program. Each encoding and each interpreter appearing in a successful pair is individually viable, but mixing the first encoding with the second interpreter fails. Separate existential checks of the two components therefore lose their required joint relation.

Reachability has a different effect. If only r_S is admitted and its encoder sends 0, only J₀ must be Second. Both legal values of J₁ are permitted because that row is never consulted. `LocalSecondForward` accordingly requires only the zero row of the actual resident J; `LocalContactCycle` requires the other row when seam40 is also admitted. Requiring the unused row to solve r_S would reject a working local procedure. Conversely, permitting J₀ to change between globally different occurrences with the same received 0 would accept a procedure that the local input cannot execute.

**Retained history and the original question.** `LocalExchangeFromFirst` and `LocalExchangeFromSecond` now compose the known internal port exchange with the complete request, acquisition and return. They answer the original endpoint question at both initial endpoints; the displaced port remains inside the reserve and is not a decoder input. The changed-source return and an unchanged source can nevertheless give identical complete receiver facts with unequal original answers. If the intervention relation is not fixed or locally retained, these facts cannot select the two different decoders. A verifier recording which history occurred cannot use that record as a participant input. The distinction remains in the whole; the failure concerns this declared access and does not prohibit another actual contact with the reserve.

This is a finite existence criterion and an exhaustive mathematical search space, not an efficient synthesis claim. An impossibility conclusion is relative to H, the alphabets, schedule and declared access. It does not exclude longer protocols. A compact constructive proof may discharge these finite obligations without enumerating every table; it must still cover every allowed choice relevant to its lower bound. The concrete Swift consumer must establish its actual lookup and transition laws, rather than accept an arbitrary conformance naming those endpoints.

The dependency restriction has an established counterpart in Henkin synthesis: each synthesized output is a function only of its declared inputs. [Golia, Roy and Meel, *Synthesis with Explicit Dependencies*, §II](https://www.cs.toronto.edu/~meel/Papers/date23.pdf) states that function-synthesis problem. Here the declared protocol also supplies the local views, reachability, action effects and original-answer obligation. No equivalence to a particular solver or its performance is inferred from the correspondence.

## §6zz. What a returned bit must preserve

Returning a full probe fact and returning its binary value are different interface contracts. The former also carries the coordinate question. To remove that field, keep the actual question's local interpretation. In the fixed policies of VC89, the receiver knows its old record and the request rule. These determine which coordinate was requested. The missing question address can therefore be reconstructed locally. If the request rule is allowed to vary without preserving that distinction at the receiver, the same argument no longer applies.

`ContactReplyCarrier` supplies a separately prepared return channel with a fixed address. It reads the payload of the filled probe instrument into that carrier, retains the original instrument at the executor, and moves only the new carrier to the old record. Both preparations and every intermediate whole are explicit. The carrier's channel, phase and prior memory are constant across the five-port family; its two filled states vary only with the returned bit. `Recover` reconstructs the original fact under a fixed coordinate law. `PairedFactorization` combines the endpoint recoveries. `AnswerOnSourceRecovery` then composes their decoder with the original endpoint decoder: its premises bind the actual initial source and recovered old observation, without asking for equality of final answers. Each `Proof` in `ContactBitCycle` supplies that construction, including both allowed actions on seam34. Forming a fact with an arbitrary question label alone would not establish its applicability.

**A boundary on pooling these policies.** On seam34, First at p₃ returns 0 and requires a; Second at p₄ also returns 0 and requires b. The old record is the same. Each respective fixed request policy works, but the complete reduced receiver inputs coincide across these two policies when their difference is omitted. For a≠b, no common decoder of that reduced input can return both original answers. This compares two fixed protocol laws. A realization that changes which law is used must carry that controlling distinction inside its whole; excluding it from the receiver's input leaves this collision unchanged. Retaining the actual request or an adequate policy distinction can repair the input. Requiring the receiver to recover every possible metadata field would be stronger than necessary: if the desired answer is invariant under a missing field, that field can remain unresolved. The criterion is still sufficiency for the declared question.

Now fix one distinct payload pair for all five edge records, their endpoint-admission premise, and exactly the two unchanged coordinate probes of VC87. A deterministic protocol has one request slot and one later reply slot. The receiver forms its request only from its old record. The executor starts with no variable port-dependent evidence, can choose probes from the request and its acquired results, and replies using only those available inputs. The receiver's final answer uses its record, its known request rule and the reply. Timing, silence, probe count and instrument addresses supply no extra signal. A one-symbol message may be omitted at its agreed slot. Acquiring or copying already acquired memory is separate from probing the original unknown port.

Let m and n be upper bounds on the numbers of request and reply symbols, and k an upper bound on primitive port probes in the worst case. The alphabets have at least one symbol; k may be zero.

**VC91 (the complete resource boundary for this contact family).** A correct protocol under these bounds exists exactly when

    (m ≥ 2 and n ≥ 2 and k ≥ 1)
    or
    (m ≥ 1 and n ≥ 3 and k ≥ 2).

The two minimal triples (request symbols, reply symbols, port probes) are therefore (2,2,1) and (1,3,2).

**Proof.** With no port probe, every input available to the executor and its reply is unchanged between the two endpoints of a fixed record. The required answers differ, so k≥1 is necessary. A constant reply likewise leaves that receiver unable to distinguish its two endpoints, regardless of the request alphabet or number of hidden probes; hence n≥2.

If m=1, the reply is a function of the port's acquired code alone. It is consequently a regime-only calibration in the scope of VC85–VC86. The odd five-cycle requires at least three reply symbols. With at most one probe, the first chosen coordinate is also independent of the old record. First collides at seam01 and Second at seam40, so k≥2. Reading both coordinates supplies the three codes 00,01,10 and the old decoder recovers the requested payload. This attains (1,3,2).

If m≥2, the necessary inequalities n≥2 and k≥1 already give the other region. VC89's two-symbol request selects Second on seams01,12,23,34 and First on seam40. Returning its bit in the fixed channel and interpreting it using the retained record gives the original answer. This attains (2,2,1). Larger budgets can use either construction without using their extra symbols or probes. The two cases exhaust m≥1. ∎

Under a separate fixed-length binary encoding of each slot, both minimal protocols can use two transmitted bits in total: zero request bits plus two reply bits, or one request bit plus one reply bit. The reduction established here is one fewer interaction with the original unknown port. It also requires preparing and communicating a request and handling the acquired reply memory. Alphabet size, total local operations, duration and physical energy are distinct costs; this finite result assigns only the first and the specified probe count.

This boundary combines the existing graph obstruction, action-cover criterion and actual return construction. It covers every allowed policy for the declared two-slot contract; it does not claim an optimal protocol for other instruments, additional feedback rounds or altered source dynamics.

## §6zza. More time cannot replace an unavailable distinction

VC90's failure at a fixed horizon does not by itself rule out longer protocols.
A different certificate can exclude every horizon: show that each choice
available at one repeated local input traps the actor in that same input.

**VC92 (a local trap that no horizon removes).** Suppose every admitted initial
source gives the same complete actor input ℓ, but their required original
answers are not all equal. The actor is deterministic; action selection,
termination and any reported value depend only on its current available input.
For every permitted nonterminal action u, suppose there is a set T_u containing
all initial sources, forward invariant under repeated u, throughout which the
actor's complete input remains ℓ. There is no correct terminating procedure
under that access, at any horizon.

*Proof.* A report at ℓ has one value and cannot answer all initial sources. If
the actor instead chooses u at ℓ, invariance keeps every subsequent source in
T_u. It therefore receives ℓ again and makes the same choice. It never obtains
a different input on which to base a different action or a correct report.
These alternatives exhaust the actor's first decision. A verifier's step
index is not additional actor memory. ∎

This criterion does not require a finite whole. Its following finite instance
also shows exactly how one available internal distinction repairs the trap.

**A closed reversible instance.** Let the whole be

    K = {x,y,z} × {0,1} × {0,1},       state (s,c,β).

The original question is β. Initially s=x and c=0; β is unknown. Operation a
exchanges x and y, fixes z, and flips c. Operation b exchanges y and z, fixes
x, and also flips c. Both leave β unchanged. Each is an involution on all
twelve states. The readout exposes β at z; at x and y it returns one quiet
symbol. The stage and the internal phase are initially excluded from the
actor's input. No action word, elapsed-step counter, timing signal or retained
history is available in addition to that readout and the fixed program.

For a, the set {x,y}×{0,1}×{0,1} is invariant and quiet. For b, the set
{x}×{0,1}×{0,1} is invariant and quiet. Both contain the two initial states.
VC92 therefore rules out every deterministic procedure with this memoryless
interface, even though the global word ab reaches z from either initial state.
Having a successful word does not supply an internal way to select its next
letter.

Now make the already resident c available. Choose a at c=0 and b at c=1 until
the readout supplies β. The path is

    (x,0,β) → (y,1,β) → (z,0,β).

Two actions suffice. Neither of the two possible first actions reaches z, so
one action cannot suffice under the same source and readout contract. The
added control image has two values. Its one-value coarsening is precisely the
interface excluded above. Thus one binary internal control distinction is
sufficient, and no constant control image is sufficient, for this declared
deterministic action and observation family.

All two-row phase policies can also be classified. The rows (a,a) and (b,b)
are the two constant traps. Rows (a,b) give the displayed two-step path. Rows
(b,a) give x0→x1→y0→z1 and succeed after three steps. These four choices exhaust
the two actions at the two quiet phase inputs. A report at either reached
quiet input still has the same value for both β and cannot replace a required
action. Thus the shortest phase policy and the slower valid policy are both
distinguished from the two impossible constant policies.

The two successful policies can share a final answer decoder. They reach
different ready phases, z0 and z1, but both read ready(β), which answers the
same original β without identifying the program or its path. The phase
distinction needed to control acquisition need not be part of the acquired
answer's eventual interface. `LocalPhaseOppositeFindsOriginal` constructs the
slower path with its actual local choices; `LocalPhaseProgramsShareDecoder`
checks equality of the original question, returned image and decoder across
both programs. This is a positive counterpart to VC91's policy-dependent bit
collision: retain a program distinction precisely where the question needs it.

This feedback law has a total reversible continuation on the same whole.
For each β it is the six-cycle

    x0 → y1 → z0 → z1 → y0 → x1 → x0.

The images of the two selected branches have different phase coordinates, as
required by VC33. An output with c=1 came from a and is undone by a; an output
with c=0 came from b and is undone by b. No extra hidden execution history is
needed for this inverse. The successful readout at z is a window, not an
absorbing whole state. Stopping the question there does not stop the whole.

For fixed β, the stage reading of this continuation has exactly the six
contacts x→x, x→y, y→x, y→z, z→y and z→z. Matter's finite-carrier criterion
following M39 therefore requires at least six whole positions. Each stage
has two different successors, so its fiber needs at least two positions under
one deterministic whole law. The displayed six-cycle attains both bounds.
Thus the binary residual reaches the minimum for this exact contact support;
its availability to the actor remains a separate relation. The contact graph
alone does not prescribe a clock, a probability distribution or an actuator.

`LocalPhaseFirst` and `LocalPhaseSecond` read the actual edge fields of the
existing `ReversibleExperiment` restricted to A, Signal and B (x, y and z).
Both exchange the two resident phase fields and retain the payload.
`LocalPhaseAtZero/One.ActualChoice` ties the controller's actual phase input
to the performed primitive. `LocalPhaseFindsOriginal` derives the original
payload from the readout after their composed path. This experiment declares
its own readout; it does not reuse the old experiment's observation field as
an unmentioned stage signal.

Both interfaces induce the same partition of the admitted initial sources:
neither distinguishes β=0 from β=1, and the added phase is initially the known
constant 0. Nevertheless their discoverability differs. The added coordinate
does not answer the original question; it makes different next interactions
locally selectable after the source changes. Initial evidence sufficiency
alone therefore cannot characterize active discovery. The future reading
relations and the controller's retained access matter, as VC19 and VC81
require in their respective continuation contracts.

The limitation is access, not loss from the whole: β and c remain present
throughout. Granting a clock, a program counter, action history, a different
instrument or a variable instruction stream changes that access. A randomized
controller also changes the policy class and needs its own success criterion.
No claim here turns one control bit into a universal bound on physical memory,
time or energy. The result separates longer iteration at unchanged local
input from acquiring a distinction that can change the next interaction.

## §6zzb. When a bounded check covers every continuation

The finite horizon in VC90 can be removed under a stronger configuration
contract. Fix a finite nonempty set C of complete configurations for the
declared game. It includes the participants' changing memory and any changing
schedule state they actually use. Each local input is a fixed reading V_i(c).
One joint table family selects commands from those inputs. The effect of a
selected command and its complete set of permitted outcomes depend only on c,
not on an omitted execution history. All permitted outcome sequences count;
an additional fairness restriction is not assumed.
Each primitive must complete its declared step or report. A possibly
nonreturning primitive cannot be hidden inside one completed graph edge;
this criterion counts command steps and does not assign physical durations.

At an initial configuration the required answer is attached by the verifier.
This original-answer tag accompanies the reachability proof, never the actor's
input. A report is correct only if it agrees with every original tag that can
reach that report through the selected policy. An unavailable command or a
nonterminal state with no successor is a failure.

**VC93 (a complete finite control configuration supplies a horizon).** In this
game, a joint local policy guarantees correct termination on every execution
exactly when (i) every reached report is correct, no reached command is illegal
and no reached nonterminal state is a dead end, and (ii) its reachable
nonterminal transition graph has no directed cycle. Such a policy uses at most
|C| commands including the final report. Consequently VC90 at H=|C| is complete
for existence of a policy that guarantees termination without a stated horizon
in this same finite configuration contract.

*Proof.* If a reachable nonterminal cycle exists, follow a path to it and
repeat its edges. Every command remains the one selected at that configuration
and every outcome is permitted. This gives an infinite execution without a
report, contradicting the guarantee. This argument uses the completeness of c
for the successor relation: a repeated label alone would not suffice.

Conversely, a path through a finite acyclic nonterminal graph cannot continue
forever. With illegal commands and dead ends excluded, it reaches a report,
which (i) makes correct for its actual original source. Before that report, no
configuration can repeat. The configurations at successive command positions,
including the report position, are therefore distinct, so there are at most
|C| commands. The bound holds for every selected table family. Applying VC90
at that bound proves the last assertion. ∎

The graph has the usual finite descending certificate: assign a report rank
zero and a nonterminal state one plus the largest successor rank. A finite
unfolded tree carries the same descent by proper-subtree inclusion, as §6h
already proves. No numerical rank needs to be available to the actor. For
distributed control, two nodes with the same V_i(c) must still use the same
row of participant i's table; a graph rank does not remove that obligation.
This is an application of finite reachability and descent, not a new synthesis
algorithm.
The VC90 unfolding must keep the same inputs V_i(c); giving each depth its own
local row would add a clock or memory absent from C. A finite source file or
a finite alphabet of readout names does not establish this configuration bound.

A fairness condition changes the guarantee as well. At a waiting node with a
self-loop and an exit, requiring the exit eventually excludes the infinite
self-loop while allowing every finite number of repetitions. All fair runs
then finish, but their lengths have no common finite bound. VC93 counts every
permitted outcome sequence and therefore rejects that reachable loop unless
an actual bounded-wait relation removes it.

In VC92 the full whole has a cycle, but the protocol ends at its first ready
readout. Removing outgoing protocol edges there leaves the nonterminal chain
y0→x1→x0→y1→z0, with z0 a report position. The other ready phase z1 also reports
immediately. A cycle of the whole is therefore compatible with termination
of this question. For either blind constant policy, a quiet two-cycle remains
reachable from x0 and supplies the genuine obstruction. The same twelve
configurations support both tests; it is their permitted local policies that
differ.

For a sufficient success certificate, knowing every configuration is stronger
than necessary. A reading into a finite acyclic progress graph suffices if
every actual nonterminal step follows its edges, all admitted executions are
covered, and each reached terminal has a source-bound decoder for the original
question. There must also be no reached illegal command or nonterminal dead
end. The graph bounds the number of steps even if the whole has infinitely
many configurations. It can omit payload details and need not be available to
the actor. Local selection and terminal correctness still need their own
relations. Completeness is required for the converse exclusion, since a cycle
introduced by an overapproximation may have no common-source realization.

**Why a finite readout alphabet supplies no such bound.** For every n≥2 and
β∈{0,1}, take a cycle with states (n,j,β), 0≤j≤n. Its one available operation
increments j modulo n+1. At j=n the local readout is ready(β); elsewhere it is
quiet. The prepared initial sources have j=0, with n and β unknown. The
question is the original β. Both n and β remain within the whole, and the
operation is a bijection. One constant local rule works for every source:
advance while quiet, then report the displayed β. It finishes after n advances
and one report, but has no uniform finite horizon over these preparations.

The three readout values and their contact support do not count complete
configurations. In particular, a quiet→quiet edge does not permit repeating
that same edge forever at a fixed initial source: its hidden phase changes.
Replacing the source by this finite contact graph adds an execution that the
original configuration does not realize. An acyclic overapproximation can
certify success; a cycle in an overapproximation need not prove failure of the
actual game.

**Even all finite observation words can miss the difference.** Call the
cycle family above A. Form B by also admitting two configurations b₀,b₁, with
U(b_β)=b_β, readout quiet and original question β. These are alternative
configurations in the same declared whole, not additional exterior objects.
Both systems are reversible and every individual orbit is finite.

For every finite horizon H, their sets of possible readout prefixes of length
H+1 from the prepared domain are equal. The only prefixes added by b₀,b₁ are
quiet repeated H+1 times. Such a prefix already occurs in A by choosing n>H.
The reverse inclusion follows because every preparation of A is admitted in
B. This remains true if prefixes are grouped by their verifier-only original
β tag. In particular, their exact one-step supports also agree.

The omitted relation is whether one common initial source realizes all the
prefixes along a branch. In A,

    for every H there is an initial source quiet through H,

but there is no initial source quiet for every H. Exchanging these quantifiers
would silently add a new admitted source. The pooled word set, even with its
prefix-extension links, does not certify that common-source relation.

Yet A has the terminating local rule just constructed, whereas B has no rule
guaranteeing a correct report: on b₀ and b₁ every available observation and
every advance agree forever, but their required answers differ. More memory
of that identical history cannot distinguish them. The property “this
declared source family admits a procedure that always eventually answers”
therefore does not factor through its set of all finite observation words.
This is the finite-compatibility boundary of VC21/VC23 applied to discovery.
M34 already exhibits the corresponding boundary for a preserved existence
fact: adding its limiting all-zero source changes the given admission rule.
The present cycle example applies that distinction to local completion rather
than introducing a new compactness principle.
It does not say that a theorem about eventual completion is impossible.
The equality concerns possible words, not their probabilities or frequencies;
the guarantee concerns every admitted source, not an almost-sure event.
The obstruction is already one of representation sufficiency: unlimited
computation on that same word set cannot choose between A and B.

For A, completion follows from a separate source relation: each admitted
configuration belongs to a finite cycle that contains its own ready(β)
position. An actual finite word with that marked position and a specified
rotation constructs such a relation without assuming a successful run. A
finite source-bound path or the complete configuration contract of VC93
supplies other positive certificates. Their adequacy cannot be replaced by
counting observed labels or by treating every locally coherent continuation
as a realization of one common source. Finiteness of a control description
need not assert finiteness of all reality; using it for a larger whole requires
an adequate reading for the actions and continuation questions in that game.

## §6zzc. Transporting a procedure through local contacts

VC52 carries an already specified word. To carry a procedure whose next
command depends on what an internal participant sees, the state relation
must also meet that participant's actual input. A relation available only to
the verifier cannot choose the participant's next action.

Let X be a new game and Y a game with a verified joint policy π. Their complete
configurations include the control memory and schedule used in the respective
games. Supply a relation Z⊆X×Y with these properties:

1. Every admitted new initial configuration has an admitted old partner in Z.
   The paired originals satisfy q_X(x₀)=d(q_Y(y₀)), with one supplied local
   output reading d. The original questions are independently specified.
2. Related configurations give corresponding participants their turns. For
   each participant i, a supplied local reading e_i satisfies
   V_i^Y(y)=e_i(V_i^X(x)) on Z. It reads the actual available input; x, y and Z
   themselves are not extra actor inputs.
3. A supplied local command translation a_i(o,u) maps the selected old command
   u and actual new local input o to one new command. Whenever u is admitted
   at a related old configuration, that new command is admitted at x. Every
   permitted new successor x′ has a permitted old successor y′ under u with
   (x′,y′)∈Z. A report v translates to a report d(v).

Commands include transmitted contents and stopping decisions. Each translated
command completes one declared step, so the translation does not insert an
unbounded internal wait. It may have fewer possible outcomes than the old
command; every new one still needs the stated old partner. Conditions may be
restricted to the cases reached by the particular policy being transferred.

**VC94 (local contacts carry a verified bounded procedure).** Under these
relations, define the new local policy by

    π_i^X(o) = a_i(o, π_i(e_i(o))).

If π guarantees a correct report within H commands in Y, this new joint policy
guarantees the original answer in X within the same number of commands after
its related initial preparation. The source relation need not identify a
unique old configuration.

*Proof.* Choose an old initial partner for the actual new preparation. At a
related pair, condition 2 makes the old policy's input exactly e_i(o). Its
command and the translated command therefore depend only on o, including in
two globally different occurrences with the same local input. Condition 3
supplies legality and an old partner after every actual new outcome. Induct
through at most H command positions, retaining one compatible old execution.
That execution reports v by H. Its translated report is d(v), which equals
the required original q_X by condition 1 and the old policy's correctness.
No verifier-only state or original-answer tag enters either local table. ∎

This is a sufficient transport contract. A global state correspondence or an
equal final answer alone does not supply condition 2. A failed proposed
translation does not exclude every other new policy. The reverse transfer
requires its own local and transition relations. These are the adaptive
control obligations added to the existing composition and domain discipline,
not a new rule that every pair of games must be equivalent.

**A complete coordinate change in the phase game.** Exchange the two resident
phase coordinates and the two program rows together. The old c=0 input becomes
the new c=1 input, and conversely. `RenamedPhaseZeroChoice` and
`RenamedPhaseOneChoice` derive the old chosen action from the actual changed
local input. Their decoders receive the changed phase and table; neither the
stage nor the payload is among those inputs.

`RenameLocalPhaseFirst` and `RenameLocalPhaseSecond` supply the two actual
commuting squares. Their generic bodies derive equality of the changed
successors from the primitive projections and phase exchange, without a
caller-supplied equality of output worlds. The three-stage admission and
readout-at-z condition are preserved because the exchange leaves the stage
unchanged. The payload question is also unchanged.

Consequently the original two-step procedure has the changed-coordinate path

    x1 → y0 → z1,

using the same action word ab under the table (b,a). `RenamedPhaseFindsOriginal`
constructs the two actual local choices and derives the independently named
original answer. Its final decoder is identical to the old one. The bound
counts the commands after the mapped preparation; treating a physical
preparation change as a free command is not part of the conclusion.

Changing phase coordinates alone while retaining (a,b) instead selects ba:
x1→x0→y1. The two-step readout contract fails. The selected primitive can also
change while keeping its old operation label: the commuting output equation
then fails. These are separate errors from a wrong final decoder. Conversely,
additional available information need not invalidate a policy: a supplied
local reading e_i may discard it while preserving the old procedure's actual
inputs and step relations.

**VC94a (expansion preserves termination only through its actual internal
progress).** Replace each translated command in VC94 by an internal block.
Supply its locally executable control, legal primitive steps, and an actual
locally recognized return to the next command boundary. Every possible return
must have the old successor required by VC94. In addition, every admitted
internal execution must return: there is no reached illegal step, nonterminal
dead end or infinite internal execution. Then an old procedure terminating
within H commands still terminates with the original answer. If every such
block, including a translated report, takes at most B primitive commands,
the new bound is BH. Preparation, communication and memory updates counted
as physical commands are included in these blocks.

*Proof.* The completed boundaries form the old execution constructed in VC94.
Each old command is reached after finitely many new steps because the preceding
block returns on every admitted execution. At most H blocks are needed. A
finite sum of finite block lengths is finite; with the uniform bound B it is
at most BH. The final original-answer equation is unchanged. ∎

This combines VC94 with the progress obligation already used in §6h and VC93.
A nonnegative integer rank decreasing at every nonterminal internal step,
together with legality, absence of dead ends and correct return markers,
supplies a sufficient progress construction. The verifier may read that rank;
the actor still selects steps from its actual available input. Unbounded ranks
over the preparation family can prove eventual return without a uniform B,
as the cycle family in VC93 shows. Calling the whole expansion a single
primitive does not establish its completion.

Even exact successful endpoint relations and their admission domains are
insufficient for the universal guarantee. A quiet internal position can have
both a legal self-loop and a legal return with the correct answer. For each
input its set of successful returned values is exactly the required singleton,
and each input has a returning path. The repeated self-loop remains an admitted
nonreturning execution. Domain reflection for successful paths and equality
of all returned answers do not remove it. A fairness assumption would change
the execution contract. The obstruction concerns completion, not the validity
of the answers on the executions that do return.

**An equal endpoint can need a different memory of order.** In VC92, the two
words ab and aaab have the same complete *working* endpoint, since a² is the
identity there. Starting at x0 they run respectively

    ab:    x0 → y1 → z0,
    aaab:  x0 → y1 → x0 → y1 → z0.

Their final acquired payload and decoder coincide. But the second and fourth
commands of aaab both start at the identical working state y1. They require
different actions, a and b. No deterministic rule of that working state alone,
and hence no rule of its phase-only reading alone, executes this prescribed
word. This excludes the proposed execution under that access contract, not
the task of acquiring the payload: ab already solves that task.

An additional internal order record permits the longer word. The existing
`ResidentBoundaryCommand` reads the actual head of a resident tape, applies
the correspondingly named supplied primitive, moves the head to the retained
past and exposes the next tail. It now also carries its existing constructed
endpoints as a `PredicateReading`, allowing ordinary `SequentialReading`
composition. No second transition formula was introduced.
`ResidentPaddedPhaseFindsOriginal` uses four such commands. Their actual seams
agree, the pending word becomes empty, and all four consumed heads remain in
the past. The original payload is read from the initial working field and
factored through the actual final window. The controller's two repeated y1
positions now have different available tape heads. Removing their distinction
again recreates the incompatible-action obligation.

Thus reducing aaab to ab preserves the chosen working answer while eliminating
two actions and the extra order distinction needed for the longer word.
It does not identify their complete controller states or their execution
histories. The reduction is licensed by the established involution and the
chosen endpoint question; a question about that history would not survive it.
The shorter construction uses the already supplied phase access of VC92 and
a different prepared control law. No physical change of a resident tape is
claimed free, and an interface exposing only its next head does not silently
gain phase access from this comparison.
This is one concrete use of static relations to remove an unnecessary
procedure, rather than first building an executor for it.

## §6zzd. Available interventions constrain the hidden carrier

VC92's phase was a supplied internal coordinate. Its six-position continuation
also minimizes the exact six-edge contact support stated there. A different
question asks how much of that carrier is forced when only the task and the
available transformations are fixed, without prescribing that full support.

Use three distinct stage roles x,y,z and the two stage permutations

    a: x↔y, z↦z,     b: y↔z, x↦x.

Let K be a finite complete carrier, E:K→{x,y,z} an onto common stage reading,
and U a permutation of K. Require each actual U-step to have one of the
stage effects allowed by a or b. Some admitted initial position over x must
reach z along its U-orbit. The controller, if used to select U, belongs to K;
there is no changing instruction or clock outside this complete configuration.

**VC95 (one reversible law needs four positions; two total reversible lifts
can force six).** Under this contract the minimum |K| is four. If, in addition,
there must be two total permutations A,B of K with

    E∘A=a∘E,     E∘B=b∘E,

and U(k) must be either A(k) or B(k) at every k, the minimum is six. The latter
bound holds even if selection may see all of K. The phase-only selection of
VC92 attains it, so greater hidden selection access is unnecessary for the
upper bound.

*Proof of the first minimum.* Surjectivity requires at least three positions.
With exactly three, E identifies the complete carrier. To leave x on a path
to z, U must take x to y; taking x to itself would trap that orbit. From y,
it must then take z, since a return to x would close a two-cycle. Bijectivity
would consequently require z→x, which neither allowed stage action supplies.
Thus three cannot suffice. Four suffice with the single cycle

    x → y_out → z → y_back → x,

where both middle positions read as y. Its four projected edges are allowed,
and its first two steps reach z. ∎

*Proof of the stronger minimum.* A maps the entire fiber over x bijectively
onto the fiber over y. For surjectivity of this restriction, a position over
y has an A-predecessor, and the factor equation with the injective stage map
a forces that predecessor to lie over x. The same argument for B equates
the y and z fibers. Therefore all three fibers have the same nonzero size r,
so |K|=3r. This is M40's exact-factor cell-volume argument applied to both
available operations; no probability law is needed. At r=1 the preceding
three-position obstruction still applies. Thus r≥2 and |K|≥6.

For attainment, use K={x,y,z}×{0,1}. Let A apply a and flip the resident bit,
and B apply b and flip that bit. Both are involutions and both satisfy the
common-reading equations everywhere. Select A at bit 0 and B at bit 1.
The resulting U is the six-cycle of VC92. Starting at x0, its first two
steps are x0→y1→z0. ∎

The four-position law does not provide the stronger operation family. A
total A lifting a would have to send both y_out and y_back to the only
position over x, contradicting injectivity. It can classify its performed
edges by their stage effects, but that classification does not make either
effect a freely available reversible intervention at every position. Treating
the four-position example as an optimization of the original two-instrument
game would remove this requirement without saying so.

The distinction is between one invertible selected process and an internally
available family of invertible processes. Each of the latter operations must
preserve its common reading on configurations where the current policy does
not choose it as well. Those additional relations force extra internal
positions. The residual need not literally be a clock bit: the lower bound
concerns distinct realizations in the three fibers, and the bit is one
attaining representation. Nor does the argument impose a finite carrier on
all reality. Finiteness, the common reading and the complete operation domains
are the specified realization contract being tested.

`LocalStageCycle` presents the four-position graph and its actual successor
and predecessor fields. `LocalStageSuccessor` and `LocalStagePredecessor` are
compositions of existing projections. The checks cover both inverse equations
at all four nodes, the entire cycle and every allowed projected contact.
The two y positions have equal stage readings and positively different binary
residual readings. Their different next stages prevent the stage reading
alone from carrying an autonomous U-update.

`LocalStageFindsOriginal` carries an unchanged payload beside this cycle and
derives its independently read original value at the z window after two
advances. Its answer, acquired image and decoder coincide with those of the
six-position experiment. Its commands are advances of the one supplied U;
it is not claimed to execute arbitrary calls of the original a/b instruments.
The existing `LocalPhase` witnesses already establish the stronger six-position
construction, including both globally available involutions and their selected
inverse. Counts here concern the control carrier for a fixed payload. Carrying
several payloads beside it does not by itself prove minimality of every possible
larger implementation of the original-answer task.

Thus agreement on a successful result and its first two observed contacts
does not certify equality of the available intervention families. Conversely,
established availability can force internal structure that this one successful
record does not identify. This applies the same source-and-question discipline
to a structural lower bound, rather than inferring hidden positions
from a convenient drawing of the process.

**VC95a (a tree of reversible interventions).** Let T be a finite tree with
m≥3 vertices and maximum degree Δ. For each edge e let t_e exchange its two
endpoints and fix all other vertices. Require an onto common reading E from
a finite complete K and a permutation U of K with one orbit visiting every
vertex through E. Every selected stage step must be some t_e step.

If only this one U is required, the smallest carrier has 2(m−1) positions.
If every t_e must also have a total involutive lift A_e on K, and each U(k)
must equal one of those A_e(k), the smallest carrier has mΔ positions.
Selection is permitted to use a supplied local view adequate for the selected
edge address; the result does not impose phase-only access or a fixed message
alphabet independently of this view.

*Lower bounds.* Removing a tree edge separates two nonempty vertex sets. An
orbit visiting both must cross that edge in both directions before returning.
Thus every edge contributes at least two different orbit positions, giving
2(m−1). More specifically the fiber over a vertex v contains at least deg(v)
positions, one for each required outgoing neighbor contact.

Under the stronger contract, each A_e bijects its endpoint fibers, as in VC95.
Connectedness makes all m fibers have the same size r. Their sizes must in
particular support the largest degree, so r≥Δ and |K|≥mΔ. ∎

*Attaining the first bound.* A tree has a cyclic contour walk traversing each
edge once in each direction. It can be built by adding a leaf and inserting
the trip to that leaf and back at a visit to its parent. Use the 2(m−1) walk
positions as K, shift them cyclically by U and read their vertices by E.
This is the balanced-contact construction of M39 with one connected tour.

*Attaining mΔ with all lifts present.* Choose the contour so that at every
vertex of degree at least two an arrival leaves along a different edge.
Such a contour is obtained by a cyclic ordering of neighbors: inserting a new
leaf between an arrival and departure preserves this property and removes
the former immediate return when a leaf becomes an internal vertex.

At a vertex v the contour has deg(v) positions. Insert Δ−deg(v) stationary
stage steps there, making exactly Δ positions per vertex. Label these inserted
steps by different edges not incident to v. There are enough such edges,
since their number m−1−deg(v) is at least Δ−deg(v). These labels really do
fix v. At a leaf, at least one inserted step separates its arrival and return
along the same tree edge. At other vertices consecutive contour labels were
already different. Inserted labels differ from each other and from the
incident labels on either side. The resulting cyclic word therefore has no
two adjacent equal edge labels.

Let K be its mΔ positions and U the cyclic shift. To construct A_e, pair the
endpoints of every U-step labelled e and exchange each such pair. These pairs
are disjoint precisely because equal labels are never adjacent, including
across the end of the cyclic word. Between the two endpoint fibers of e,
the two contour traversals specify two disjoint pairs. Both fibers have Δ
positions, so pair their remaining Δ−2 positions bijectively. Within any other
fiber, the optional inserted e-step already specifies at most one pair;
fix every remaining position there. These exchanges define a total involution
A_e with E∘A_e=t_e∘E. At each position its labelled A_e gives exactly U's
successor. The selected edge label is a reading of the resident position;
granting that local reading makes the selection executable without an
external position counter. ∎

For a path, Δ=2: the bounds are 2m−2 and 2m. VC95 is the m=3 instance.
For a star with r≥2 leaves they are 2r and r(r+1). Thus this difference is
not limited to one spare pair of positions. The star center forces at least
r distinct departures, and the reversible lifts force that same multiplicity
at every leaf as well. Removing the full-domain requirement for unused
interventions removes this propagation of multiplicity.

These are bounds for a specified exploration and operation family. They do
not optimize acquisition of the selected-edge reading, assign a probability
or entropy, or assert that all named interventions exist in a physical source.
The common reading and the actual lift relations supply the conclusion.

**The star admits selection by phase alone.** Number its r≥2 leaves cyclically
and take K={center,leaf₀,…,leaf_(r−1)}×ℤ_r. Define A_i to exchange center with
leaf_i in the first coordinate and exchange phases i and i+1 in the second,
fixing all other entries in each coordinate. Each A_i is an involution with
the required total stage reading. At phase i, select A_i. The phase then
advances by one, and the inverse policy at phase j selects A_(j−1).

After r steps from phase zero, the stage has undergone t₀ followed by t₁,
through t_(r−1). This sends center to leaf₀, each leaf_i to leaf_(i+1), and
the last leaf to center. It is a single cycle of length r+1. Thus the full
selected law is one cycle of length r(r+1), attaining VC95a. Every intermediate
phase also occurs over every stage, since its stage transformation is a
permutation of that complete list. Neither selection direction reads the
stage or an additional payload carried unchanged beside it.

Moreover at least r distinct complete local selection inputs are necessary
for this exploration when each command calls one of the named A_i. Each leaf
must be entered through its incident action, so all r actions must be selected;
one deterministic row cannot select two different actions. The r phase values
attain this bound. This applies VC89's available-choice discipline to the
resident controller, without treating the phase as evidence about an unknown
payload. Under another selected action a phase can instead go backwards or
remain fixed. Its forward order here follows from the action-selection law,
not from an independently advancing external clock.

The three-leaf instance is `LocalStar`. Its four stage rows and three phase
rows construct all twelve configurations as pairs, rather than declaring a
separate unexplained successor for each whole position. The three primitive
steps are applications of the corresponding catalogue projections to both
coordinates, leaving an arbitrary payload unchanged. Their explicit endpoint
interfaces are equated to those existing paired applications in generic
`Endpoints` witnesses. `LocalStarControls` binds the actual phase-only input
and operation expression for every forward and inverse row.

`LocalStarRound` derives the actual three-step endpoints and selected-operation
seams. Composing four rounds returns to the original whole and covers all
twelve stage/phase positions; composing three reaches the third leaf's window.
`LocalStarFindsOriginal` factors the independently read initial payload through
that actual window. Its final decoder is the same decoder used in the earlier
phase experiment. The checks cover each of the three involutions on every
stage and every phase, and both directions of the complete selected cycle.
The two generators not incident to a leaf fix it, so their permutations also
preserve its complement. This supplies the finite exclusion supporting the
need to select every generator during exploration.

The three-phase indices do not count visits indefinitely. Applying the second
primitive at phase zero leaves that phase zero; replacing the inverse policy
by the forward one fails the actual return equation. These refused relations
separate the selected control order from an autonomous clock assumption.

### §6zze. Transported distinctions do not require a finite whole

VC95a uses finiteness to derive repeated departures from a returning exploration.
Once distinct departures are positively established, their transport has a
weaker foundation. Neither the carrier's total size nor a complete inventory
of its configurations is then needed.

**VC96 (a finite witness of required multiplicity).** Let x₁,…,x_r be admitted
source configurations distinguished by one independently specified question q:
the answers q(x_i) are pairwise different. For each j=1,…,m, suppose an actual
reading or transition T_j is defined at every displayed x_i and has a decoder
D_j with

    D_j(T_j(x_i)) = q(x_i).

Suppose one common reading E distinguishes the target regions:

    E(T_j(x_i)) = b_j,

where the b_j are pairwise different. The target carrier must contain at least
mr distinct configurations. This conclusion uses only the displayed cases and
relations; the carrier may be infinite and otherwise unknown.

*Proof.* If T_j(x_i)=T_k(x_l), applying E gives b_j=b_k, hence j=k. Applying
that same D_j then gives q(x_i)=q(x_l), hence i=l. Thus every displayed pair
of indices names a different configuration. Any extension preserving these
relations preserves this distinction: identifying two of the displayed images
would contradict one of the established readings. This is M71's finite
obstruction applied to the question at two successive boundaries. ∎

The decoder condition preserves the separating question, not necessarily the
whole source. For example, a reading (i,h)↦(b_j,i) retains q(i,h)=i while omitting
h. It supplies the bound for distinct displayed i even though it does not
reconstruct h. This example is an information-reducing representation; it does
not establish that a complete physical transition can erase its omitted field.

An actual reversible word supplies the decoder constructively: return along
its inverse and then apply q. Only the inverse applications on the displayed
images are needed for this witness. Their domains and seams must hold; an
operation named reversible without those relations supplies neither. The word is part of the
specified decoder. This is the converse direction of the same question-through-
path composition used in VC52, not a claim that the path can be inferred from
its endpoint.

In the three-leaf star take the three center configurations with phases 0,1,2
and any one fixed payload. The source question reads the resident phase label
through its actual pair address. Use the empty path and each of the three
primitive involutions as the four T_j. The common stage reading distinguishes
center and the three leaves. Applying the same primitive again and then reading
the phase recovers the three original labels at each leaf. Hence these admitted
contacts require twelve distinct configurations without assuming that those
twelve exhaust the carrier.

`AnswerThroughReturn` derives a `ReadingFactors` certificate from an independently
chosen question and two applications with a supplied return seam. The caller
does not supply equality of question answers. `LocalStarPhaseImage` consists
of the existing pair projections. Each `LocalStarReturn` takes only the arrived
whole and derives its stage, phase and payload inputs there. `StarTransportedSeeds`
checks all nine leaf factorizations and all twelve common-stage readings. The
seed labels are the finite constructor forms 0,1,2; their positive boundaries
use `ZeroSuccessorBoundary`, with a predecessor projection separating 1 from 2.

This is a lower bound on admitted distinguishable configurations, not a count
of simultaneously existing particles. The complete finite star constructed in
VC95a attains it for this control carrier. The finite witness also remains valid
inside any larger realization that retains the same source distinctions and
contact relations. It does not independently establish those relations for
an unknown physical source or derive the three seed distinctions from the word
“difference” alone.

**Why knowing a return is not knowing which return to use.** In that same star,
the word 0,1,0 takes center/phase 0 through leaf A/phase 1 and leaf A/phase 2
to center/phase 2. The empty word from center/phase 2 has exactly that same
final working configuration. The original phase answers are 0 and 2. If the
admissible sources include both source/path pairs and the observation retains
only their final working carrier, no shared decoder can recover the original
phase. Each path separately has an inverse. Their omitted choice does not
factor through this observation.

`StarUnknownReturnPath` binds the two actual working endpoints.
`StarResidentUnknownPath` supplies the choice inside the modeled system: the
three commands reside in a tape and `ResidentBoundaryCommand` retains each
consumed head in its past field. The empty-path source has an empty tape and
past. Their final working projections agree, while their complete resident
records still differ. The original phase questions read the actual initial
working fields and supply the positive answer obstruction. No disappearance
of the path from the complete system is asserted.

Reusing the current phase as the original phase also fails after just one
primitive. These are different mistakes: the first excludes the recovery
context from the observation, while the second applies the wrong reading
even when the path is fixed.

There is no hidden path choice in VC96's twelve-case witness. Each leaf has one
specified transport from the center, and its stage identifies which displayed
decoder applies; the center uses the empty path. Adding the extra return loop
while erasing its identity enlarges the source/path family and loses that
property. Distinct, certified recovery constructions therefore do not establish
their own applicability after their distinguishing context has been removed.

**Applying S25: exactly which original questions survive an omitted path.**
Take all three center phases and any admitted payload V as preparations in
this star, allow every finite primitive word, and expose only the final working
configuration. An original-source question q can be recovered for every such
source/word pair exactly when, on the center preparations, q depends only on V.

For necessity, the center-based word 0,1,0 exchanges phases 0 and 2 and fixes
1. The word 1,2,1 exchanges 0 and 1 and fixes 2. Both retain V. Comparing
each performed loop with an empty-word preparation at its endpoint forces
the corresponding original q answers to agree. These two exchanges connect
all three phases, so q must be constant over them for each V. For sufficiency,
every primitive retains V by construction; induction on a finite word retains
it, and the final payload projection followed by the chosen function of V
recovers q. `StarReturnLoopsConnectSeeds` checks both complete phase exchanges
at their actual center return, for arbitrary V.

This is S25's existing question-scoped loop criterion applied to the available
instruments, not a new general theorem about loops. The stage movement graph
is a tree, but the full contact family contains more than its moving edges:
at leaf A, primitive 1 fixes the stage while changing phase. That stationary
contact is the middle of the first loop. Discarding contacts that leave a
coarse stage unchanged would remove the very relation that obstructs recovery.

Consequently the same carrier has two different exact descriptions for two
different demands. Its phase distinctions are required for the supplied
interventions and selected exploration. They are absent from the original
questions recoverable without the path. The payload can survive the latter
restriction even when every nonconstant original-phase question fails it.
Calling the phase irrelevant without specifying which demand is being preserved
would merge these two results.

### §6zzf. A minimal stage-only distinguishing continuation

The positions required by VC95a need not have a separately accessible phase
sensor. Whether their distinction is observable depends on which actual
continuations the question permits.

**VC97 (the selected star's stage horizon is exactly r−1).** In the r-leaf
phase-controlled star of VC95a, r≥2, fix the selected law U. The current stage
and its next r−1 stages identify every one of the r(r+1) control positions.
No smaller common number of U-advances suffices. An unchanged additional
payload is outside this identification question.

*Proof.* Around the one U-cycle the stage word is

    center, leaf₀ repeated r times,
    center, leaf₁ repeated r times, …,
    center, leaf_(r−1) repeated r times.

At a center position the next leaf distinguishes its r possible phases.
At a leaf the distance to the next center is one of 1,…,r, different at its
r positions. Observing r−1 advances distinguishes every distance below r by
the first center occurrence; no center in that prefix identifies distance r.
Together with the current leaf this identifies the position. With H≤r−2,
the first two positions of any r-long leaf block both give H+1 copies of
that leaf. Their later center arrivals differ, so these distinct positions
have not become equivalent continuations. ∎

For r=3 the complete two-advance table is:

| Initial stage | Phase 0 | Phase 1 | Phase 2 |
|---|---|---|---|
| center | center,A,A | center,B,B | center,C,C |
| A | A,center,B | A,A,A | A,A,center |
| B | B,B,center | B,center,C | B,B,B |
| C | C,C,C | C,C,center | C,center,A |

All twelve words differ. At A, phases 1 and 2 agree on the current and next
stage; their third readings are A and center. `StarShortTraceCollision`
checks this equal prefix and its positive zero/successor continuation boundary.
This is the finite identification and continuation criterion of U2c and VC44,
with a derived exact horizon for this source.

`SelectedLocalApplication` takes a source-bound application root, an actual
local-input reading, a row of the fixed address program and a finite catalogue
selection. The row selects the path address; the primitive is the selected
leaf itself. There is no separate primitive argument to substitute by matching
an operation label. `LocalStarApplicationRoot` derives all three applications
at the current working source and binds their ordered catalogue and library
expression. The input available to the selector contains only phase and the
fixed address program. The root is an application view supplied by the declared
library, not a new observation of the unknown source granted to the selector.

The resulting selected-law expression retains the library expression and
address program, and is the same at all three phase clauses. Thus the finite
table does not compare answers to three differently named policy questions.
`TwoStepStageTrace` composes actual source transitions with the stage projection;
`StarObservationGrid` checks all twelve words and their one common question.
Supplying the inverse table while still applying the old primitive is refused
at the selection seam.

The complete catalogue path also belongs to each operation expression.
Retaining only its terminal left projection would identify the first and
second column descriptions. The stage, residual and phase questions retain
their different source paths, even when their answers happen to agree.
A recording command includes the question it records. The checks refuse
substitution of these different questions.

Actual occurrence selection is stronger than repairing those expressions.
`AliasedApplicationRoot` deliberately gives two concrete readings equal labels
and equal answers. A left-path choice still selects the first reading itself.
A counterfeit path with that same address, label, working source and result
fails because its starting catalogue has replaced the first occurrence.
This reuses M65's existing finite `SelectCandidate` rule for actual reading
occurrences. It is not a new status or a proof of arbitrary root adequacy.
Both the current root and its finite selection construction remain bound
premises of the application.

**The actual acquisition carries its own order.** `AcquiredTwoStepStages`
constructs a five-command resident program: record the current stage, apply
the selected law, record, apply it again, and record. Each record retains
its current working source beside the acquired fact. The two advances act
only on that working field, retaining the previous records. Every consumed
instruction remains in the command history. The final observation projects
only the three ordered facts; its decoder reads their answers, without access
to the phase, current working source, original configuration or command history.

The independent source question is `TwoStepStageTrace` at the actual initial
working address. Its factorization through the acquired facts is derived by
the generic construction, not requested as an output equality. Each fact is
acquired at its own intermediate source. Treating all three as repeated
measurements of one unchanged source would require different relations.
The count r−1 measures source advances, not total physical time: the r=3
construction also performs three recordings and carries an internal program.
Its larger observer-and-record carrier is not included for free in VC95a's
minimum for the unobserved control carrier. Availability of the supplied
noninterfering stage-record construction is an explicit interface condition.

`StarAcquiredObservationGrid` instantiates that factorization at all twelve
preparations and checks that their resident instruction tapes agree. The decoder
type also remains unchanged when only the payload changes. Reversing the first
and last facts fails the original question for center,A,A but preserves it for
A,A,A. The latter single success does not justify erasing order from the whole
preparation family.

**The same phase remains invisible under another complete vocabulary.** Suppose
instead that the observer may call any of the primitive A_i, but its entire
input consists of stage readings, its own fixed program and records computed
from them. Two initial configurations with the same stage give the same stage
after every identically chosen primitive, because E∘A_i=t_i∘E. Induction
preserves equal observer records and therefore the same next chosen primitive
under every deterministic adaptive policy of that observer. No such policy
can identify the hidden phase, regardless of its horizon.

Allowing the resident selected law U supplies a different contact. Its selection
reads the phase inside the source and can communicate that distinction through
the next stage. For example, the three central phases have different U-images
but each fixed primitive has the same stage effect on them. U is built from
the same A_i together with that additional internal selection input; access
to the A_i alone did not grant the observing actor that input. This is the
locality boundary of VC90 and the acquisition boundary of PP19 in one finite
example, rather than information produced by repeating an insensitive probe.

The result connects the structural lower bound to an explicit distinguishing
continuation. It also limits its interpretation: the stage image is exact for
the whole freely chosen primitive vocabulary and insufficient for the resident
selected-law vocabulary. Saturating only the former cannot certify the latter
by assuming that the system's internal selection sees no more than the observer.

### §6zzg. A calibrated contact can fail substitution under internal selection

Return to the three-stage, two-phase carrier of VC92. Its old whole primitives
A and B perform the stage transpositions a=(x y) and b=(y z), respectively,
and both flip the resident phase. Both retain the payload V.

**VC98 (identical stage contacts, different internal continuations).** Consider
two whole contacts. C₁ is the old word A,B,A. C₀ performs its stage action
c=(x z) while preserving the phase. Each is an involution, and they have the
same stage and payload images at every source. Nevertheless they cannot be
substituted in every context of the supplied system.

*Witness.* From x/phase 0, C₁ reaches z/phase 1 while C₀ reaches z/phase 0.
Apply the same old resident law U, which selects A at phase 0 and B at phase 1.
The first case reaches y/phase 0; the second reaches z/phase 1. Even the original
quiet/signal interface distinguishes them, since y is Signal and z is Quiet.
Their payload answers remain equal. No new phase sensor is supplied to the
observing actor. ∎

This is stronger than a missed one-input calibration. For any fixed word over
the corresponding A, B and C contacts, the two libraries give identical stage
answers: every contact factors through the same stage operation. Induction
extends this to an actor choosing contacts using only its stage history and
fixed internal resources. The separating U has an additional internal input,
the phase. Thus completeness for the former continuation vocabulary did not
establish completeness for the latter.

Nor can C₀ be recovered as some longer word over the old A,B on this complete
carrier. Every old letter changes the phase and is one transposition of the
three stages. Even-length words induce an even stage permutation and preserve
phase; odd-length words induce an odd stage permutation and flip it. The target
c is odd but C₀ preserves phase, violating this relation. Equivalently the six
permutations split into the three cyclic orderings and their three reversals;
either old generator exchanges these two classes and flips the phase at the
same time. This is a finite relation between the complete stage action and
phase action, not an assumed physical parity conservation law.

`LocalStageClosing` derives the stage word. `LocalPhaseMacroClosing` composes
the actual old whole operations, retaining their phase effect.
`LocalPhaseUnflippedClosing` applies only the derived stage reading beside
the unchanged phase/payload field. `LocalClosingImagesAgree` derives their
common source and stage/payload projection for arbitrary admitted fields.
The finite checks cover both involutions at all six canonical positions.
`LocalClosingFeedbackWitness` then binds both next actions to their actual
phase readings and one fixed program. The complete-output substitution and
the later quiet/signal substitution are separately refused.

There is a related capacity distinction, without a contradiction in
monotonicity. If a third directly available stage exchange c may also be
selected as one step, the stage cycle x→y→z→x has a three-position realization
with all three transpositions present. The three `LocalStarPhase` catalogue
rows already present these involutions and their selected cycle. Under VC95's
old requirement U(k)∈{A(k),B(k)}, six positions were necessary. The new game
both adds a contact requirement and enlarges the allowed selections to include
C. It has not obtained a smaller minimum by adding constraints while
leaving the old choice set unchanged.

Deriving the endpoint expression c=a b a can be done statically. That derivation
does not need to perform the modeled operations. Claiming that an unknown
source offers c as a single available intervention is another question.
Executing the old word internally retains its old complete effect and needs
the local control of VC94a. In particular, naming that word C₀ cannot remove
its phase change. A source with C₀ available has an additional whole contact,
even when stage-only calibration cannot distinguish it from C₁.

### §6zzh. A relation of visible actions can fail on the carried phase

VC98 compared two differently supplied whole contacts. A stronger obstruction
already occurs among words of the same primitive library. Keep VC95a's r-leaf
star: t_i exchanges center with leaf i; the accompanying phase contact τ_i
exchanges i and i+1 modulo r. The working primitive is their product and retains
V. Words below list performed contacts from left to right.

**VC99 (the first failure of complete-stage determination is r=4).** For r=2
or r=3, two primitive words with the same complete stage permutation also have
the same phase permutation. For every r≥4, there is a word with the identity
stage permutation and a nonidentity phase permutation. Thus the complete stage
action of a word no longer determines its phase action in this family.

*Proof for r≥4.* Write X=(0,2,0) and Y=(1,3,1). On stages, X exchanges only
leaves 0 and 2, and Y exchanges only leaves 1 and 3. They are disjoint
exchanges, so W=(X,Y,X,Y) fixes every stage. This includes the center and,
when r>4, every other leaf.

On phases, τ₀ and τ₂ are disjoint, hence X acts as τ₂. Likewise τ₁ and τ₃
are disjoint and Y acts as τ₃. But τ₂ and τ₃ meet at phase 3. Put k=4 modulo
r. Their sequence τ₂,τ₃,τ₂,τ₃ sends 2→3, 3→k and k→2, fixing all other
phases. It is not the identity. No additional primitive or hidden phase
measurement has been supplied. ∎

*Proof of the smaller cases.* At r=2 both phase contacts are the same exchange.
The phase action therefore records whether the word length is even or odd.
Each stage contact is a transposition of three stages. It exchanges the three
cyclic orderings of those stages with their three reversals. Consequently the
identity stage action requires even word length and identity phase action.

At r=3 identify phases with these three partitions of the four stages:

    phase 0: {{center,1},{0,2}}
    phase 1: {{center,2},{0,1}}
    phase 2: {{center,0},{1,2}}.

Acting on both pairs of each partition, t₀ exchanges phases 0/1, t₁ exchanges
1/2, and t₂ exchanges 2/0. These are exactly the three supplied τ_i. Induction
on a word identifies its phase action with its action on these partitions.
The identity stage permutation fixes every partition, so it fixes every phase.
In both smaller cases, compare two equal stage actions by following the first
word with the reverse of the second: each primitive is an involution, and this
comparison word has identity stage action. Its phase identity gives equality
of the two original phase actions. ∎

For r=4 the one fixed twelve-contact word is

    0,2,0,1,3,1,0,2,0,1,3,1.

It fixes all five stages, while its phase map is 0→2→3→0 with phase 1 fixed.
This does not mean phases first exist at four leaves. They were already needed
at lower valence. What first fails here is determination of the complete phase
action by the complete stage action of a word.

**Six contacts are necessary and sufficient for some hidden phase change.**
For r≥4, Z=(0,2,0,2,0,2) is shorter than W. The stage action of 0,2 is a
three-cycle, so its third power is the identity. Its phase contacts are disjoint
exchanges. Their product has order two, so its third power is that same
nonidentity product: Z swaps phases 0/1 and 2/3.

No shorter word can return every stage while changing the phase. Cancel any
adjacent equal letters; this preserves both actions because every primitive is
an involution. A stage-identity word has even length. A reduced two-letter word
is not the identity. For a four-letter word (i,j,k,l) with adjacent letters
different, identity would equate the two-letter stage actions (i,j) and (l,k).
Each is an oriented three-cycle through center and its two named leaves; its
ordered leaf pair is uniquely determined. Thus i=l and j=k, contrary to the
absence of adjacent cancellation. Length zero changes no phase. This excludes
every length below six without a search over candidate words.

The same calculation supplies a time question without an external clock.
At r=4 repeat the two-contact block B=(0,2), starting at center/phase 0:

| Completed blocks | Stage | Phase |
|---|---|---|
| 0 | center | 0 |
| 1 | leaf 0 | 1 |
| 2 | leaf 2 | 0 |
| 3 | center | 1 |
| 4 | leaf 0 | 0 |
| 5 | leaf 2 | 1 |
| 6 | center | 0 |

The stage question has period three blocks, the phase question period two,
and their joint question period six. The block order is supplied by a resident
two-contact program when executed; it is not a freely advancing outside time
coordinate. Returning a working projection does not return an additional
growing history record. This is a scoped recurrence relation, not a claim that
the complete universe has period six or a derivation of physical duration.

**The omitted distinction has a supplied distinguishing continuation.** At the
center with phase 0, W returns to the center with phase 2. The empty word leaves the source
at center/phase 0. Every subsequent word chosen by an actor with only stage
access gives the same stage readings from those two endpoints, by VC97's
primitive-interface argument. But one application of the resident law U,
which selects contact i at phase i, gives leaf 2 after W and leaf 0 after the
empty word. Thus replacing W by the identity on the strength of its complete
stage calibration is invalid for that continuation vocabulary.

The calibration being compared is the endpoint action on all stages. It does
not include the words' different intermediate stage histories or their command
records. Those are different questions, and knowing a performed word can itself
support additional inference. Executing W inside a closed arrangement requires
its twelve-command controller; its consumed instructions may be retained as in
VC94a. The working phase change is not an erasure of that controller's history.
In fact W repeated three times restores the entire stage/phase working carrier
and V, without restoring a growing record to its earlier length.

The static construction uses arbitrary symbolic labels at the five stage
addresses and four phase addresses. `FourLeafStage0`–`3` and `FourLeafPhase0`–`3`
are their actual exchanges. `FourLeafShortStageWord` and `FourLeafStageWord`
derive complete stage identity for Z and W. The two phase-word constructors
derive (B,A,D,C) and (D,B,A,C) from (A,B,C,D). Every intermediate source is
joined to the previous actual output through `FollowedPair`; no final equality
is requested from a caller. Separate generic checks establish all eight
primitive involutions and threefold return under W.

The tuple lists the token at each final address. In W's output (D,B,A,C),
original token A reaches address 2, token C reaches 3 and token D reaches 0.
This is the stated point cycle 0→2→3→0, rather than its inverse. The code checks
that distinction explicitly. Arbitrary labels establish the complete finite
permutation without listing twenty products of stage and phase, or reading
all positions as physical data. This finite symbolic presentation replaces a
much more expensive recursive table unfolding. The general r≥4 construction,
its exact ambiguity and the exclusion at r=2,3 are the arguments here,
independent of a word-search program or an enumeration report.

`LocalFourLeafCourt.swift` presents a finite direct-court certificate from those
current definitions: four initial sources, 32 intermediate equalities, four
endpoints, two directed label readings, 36 actual constructor selections,
eight independently specified contact calibrations and the four actual Path
structures. Selection is checked even when another constructor could return
the same tuple. The 90 obligations are
read by the existing native and gate relation courts without compiling the
modeled Swift program; an independent Swift check forces the same conditional
equalities. The certificate supplies its own explicit ordered step list and
binds the declared Path to that constructor tree. It does not claim that the
relation court elaborates every conditional generic declaration, or that
equality of endpoints certifies a different path. The generic `FollowedPair`
constructions remain checked by Swift; the direct certificate separately
presents every seam they require and preserves their order.

The obstruction is at the level of relations between operations. Each primitive
still has an exact stage image. The visible relation XY=YX is valid on every
stage, yet its two lifted phase actions do not commute. A faithful stage quotient
for the primitive-only game can therefore forget a distinction essential to a
larger game with resident selection. The missing condition is preservation of
the relations needed by that larger game, not greater precision in measuring
the same endpoint stage map.

**VC99a (the exact remaining phase-action ambiguity).** For r≥4, among all
finite primitive words with a given complete stage permutation σ, the phase
permutations are exactly those with the same parity as σ. For r=2,3 there was
only one. In particular, endpoint calibration of the entire stage permutation
leaves r!/2 possible phase permutations in the larger-valence family.

*Proof.* Every letter is one transposition on stages and one on phases, so their
parities agree for every word. In particular a stage-identity word can have
only an even phase action.

Conversely, W supplies one three-cycle on phases with identity stage action.
The phase contacts τ₀,…,τ_(r−2) are the adjacent exchanges and generate every
phase permutation: successive adjacent exchanges move each named phase to its
prescribed position. Conjugating W by a word with an arbitrary such phase
permutation still has identity stage action and gives the correspondingly
renamed three-cycle. Thus every phase three-cycle is available with identity
stage action. Every even phase permutation is a product of three-cycles. To
see this directly, pair the transpositions in an even-length expression:
an identical pair cancels, a pair sharing one point is a three-cycle, and a
disjoint pair can be split into two sharing pairs by inserting the same
bridging exchange twice. Hence every even phase action occurs over stage
identity, and no odd action does.

Choose any word giving σ; the stage star exchanges generate every stage
permutation, since (i,j,i) exchanges any two leaves. Let this word's phase
action be τ. Appending a stage-identity word can multiply τ by any even phase
permutation. This reaches exactly its parity class, which is σ's parity class.
The two parity classes have equal size because multiplying by a fixed exchange
pairs them. ∎

This sharpens the question rather than declaring every hidden distinction
unknown. The parity of the phase operation is determined. Its complete action
usually is not. For a fixed initial phase, the compatible final phases exhaust
all r positions: even permutations act transitively when r≥3. Therefore asking
where that particular phase goes cannot be answered from the calibrated stage
permutation alone. A retained word or a suitable additional contact can supply
the missing relation; neither is contained in a more precise measurement of
the same σ.

### §6zzi. The missing action can be acquired with one fewer point probe

VC99a determines a precise remaining family, so its acquisition cost can be
asked without guessing a hidden mechanism.

**VC100 (point-query cost with known parity).** Let one fixed unknown
permutation τ act on r≥2 known distinct phases. Its parity is supplied. A
query may choose any phase i and return the exact value τ(i). Determining the
complete permutation requires and suffices with r−2 queries in the worst case,
even for deterministic adaptive policies. Without the parity premise the
corresponding minimum is r−1.

*Sufficiency.* Query any r−2 different inputs. Their images are distinct.
Exactly two domain points and two possible images remain. The two bijective
completions differ by one exchange and have opposite parity. The known parity
selects exactly one. Without parity, query one further input and the final
image is the only unused one. At r=2 the known parity already specifies τ.

*Necessity.* If a policy stops with at least three unqueried inputs, follow its
actual responses under τ. Precompose τ with a three-cycle of those unqueried
inputs. The alternative has the same parity and preserves every returned
answer. Induction on the policy's available history gives the same chosen
queries and stopping decision, yet the complete permutations differ. Thus
fewer than r−2 cannot suffice. Without a parity restriction, exchanging two
unqueried inputs supplies the analogous obstruction below r−1. Repeating an
already queried input does not remove either obstruction. ∎

For r=4, the two distinct returned images have 4·3 possible ordered pairs.
Each is the prefix of exactly one permutation of the supplied parity. This
is the whole twelve-member ambiguity of VC99a, rather than twelve possibilities
chosen to fit a decoder. For a question about just one τ(i), one corresponding
query suffices and, on that full family, is necessary. Identifying a finite
word that realizes τ is a different question: words differing by a returning
relation have the same complete action.

**Connection to the supplied star interface.** Restrict first to words whose
complete stage action is the identity. Prepare a known center/phase i, apply
the unknown fixed word, then apply the resident law U. The next leaf is τ(i),
because U selects its contact from the resulting resident phase. This exposes
the needed point value through a stage observation; no separate phase sensor
is given to the observer. Repeating this construction for r−2 prepared inputs
implements the point-query contract if the same law acts on every preparation.
The count concerns word queries. It does not bound the word's length, provide
free preparations, reset a changed source, or grant stability across trials.
Those are explicit parts of an acquisition arrangement inside the system.

**Two true readings need not belong to one unchanged law.** At four phases,
start with the identity table (0,1,2,3). Read its value at input 0, obtaining 0.
Change the internal law to the even table (3,1,0,2), then read its value at
input 1, obtaining 1. Both readings are true. Under a single fixed even law,
the pair (0,1) would uniquely determine the identity. The current law is not
the identity. Both laws are compatible with stage identity by VC99a, so that
whole-stage calibration does not detect the change.

`PhaseLawTwoProbeTrace` retains the first actual fact, performs the supplied
law change beside it, and acquires the second fact from the actual new source.
Its three boundaries compose. `RetainedPhaseLawInquiry` also keeps the supplied
change construction in each history's description; the available fact reading
does not inspect it. The stable and changing histories therefore need not have
the same complete initial source or the same retained context.

`PhaseLawMixedHistory` derives equal available facts for those histories, with
the same fact and current-law questions, while deriving different current
law tables. The change uses `FourLeafPhaseWord` on the table's four symbolic
entries. Its intermediate word is already given; accounting for resident
execution of that macro is the separate control requirement of VC94a. The
static trace states where the two readings occur and what is retained beside the
working table, not a claim of three elementary physical time steps.

The finite witness preserves the original recorded answers and all four table
entries. It refuses to treat the two probe sources as one, or their matching
record prefix as an unchanged complete current law. The second table entry
remains equal, and its recorded answer remains usable. Thus VC100's common-law
premise is a relation the acquisition must preserve. A uniquely completable
record does not establish that relation by itself.

### §6zzj. Twelve actual words supply the complete four-phase ambiguity

VC100's twelve possibilities need not be supplied as twelve unrelated tables.
Keep the already constructed four-leaf words Z and W of VC99, written in
performed order. Their phase actions are Z=(0 1)(2 3) and W=(0 2 3), and
both return every stage.

**VC100a (a complete finite word presentation).** The three words Wᵃ and the
nine words WᵃZWᵇ, with a,b∈{0,1,2}, realize each even four-phase permutation
exactly once. Their two point images at inputs 0 and 1 exhaust all twelve
ordered pairs of distinct phase positions.

*Proof.* H={I,W,W²} has three elements and fixes phase 1. Its conjugate ZHZ
fixes phase 0. A nonidentity element of either set is a three-cycle, with just
that one fixed phase. Consequently H∩ZHZ={I}. If WᵃZWᵇ=WᶜZWᵈ, multiplying
by the appropriate inverses puts an element of H equal to an element of ZHZ;
both must be I, hence a=c and b=d modulo three. None of those nine words lies
in H: otherwise Z would lie in H, whereas Z has order two. The twelve actions
are distinct and even. There are exactly twelve even permutations of four
positions, as in VC99a, so this is the complete class. VC100 then makes the
two point images distinct for different actions. The explicit actions are:

| Word | Image of 0 | Image of 1 | Image of 2 | Image of 3 |
|---|---|---|---|---|
| I | 0 | 1 | 2 | 3 |
| W | 2 | 1 | 3 | 0 |
| WW | 3 | 1 | 0 | 2 |
| Z | 1 | 0 | 3 | 2 |
| ZW | 1 | 2 | 0 | 3 |
| ZWW | 1 | 3 | 2 | 0 |
| WZ | 3 | 0 | 2 | 1 |
| WZW | 0 | 2 | 3 | 1 |
| WZWW | 2 | 3 | 0 | 1 |
| WWZ | 2 | 0 | 1 | 3 |
| WWZW | 3 | 2 | 1 | 0 |
| WWZWW | 0 | 3 | 1 | 2 |

Each row follows by composing the two supplied actions; it is not the output
of a permutation search. Each ordered distinct pair occurs once in the first
two image columns. ∎

`PhaseWordCatalogue` presents the actual compositions on arbitrary symbolic
labels and derives all twelve output tuples without asking for their values
as generic premises. `FourLeafJointZ` and `FourLeafJointW` compose each stage
contact beside its corresponding phase contact, retaining K at every boundary.
The joint catalogue uses those coupled words. This is stronger than pairing
two independently chosen final permutations after their answers match.

The table describes actions before it describes an observer's acquired facts.
An internal phase marker at the returned center is not itself a stage reading.
The resident continuation below exposes its position through a leaf, and its
two actual preparations retain one common law. A final stage fact does not
also carry the unknown word's expression as an implicit answer: the word
and its instructions remain outside the available fact.

Decoding the two images may choose the canonical word in this table, but it
identifies the phase action, not which word the unknown source performed.
Additional returning words can change a command history without changing that
action. Correspondingly, rejecting a different Path in the direct court and
accepting it as equivalent for this action question are compatible: their
questions preserve different relations. The action quotient does not identify
execution history, word length or physical duration.

**VC100b (two acquired facts identify the resident law in this catalogue).**
Supply two probes prepared at the center with respective phase markers 0 and
1, the fixed resident U of VC95a, and one address L selecting an actual word
from VC100a's complete catalogue. The source retains L across both invocations.
After each invocation, apply U and record only the resulting stage address.
The two acquired facts determine L. One such phase-image query cannot identify
all twelve possible addresses.

*Construction.* Each word returns the center and sends the prepared phase i
to p(i). The actual resident U then selects contact p(i), placing the stage at
that leaf. Its new internal phase is not the recorded answer. Thus the two
stage facts contain p(0) and p(1), with one common stage-reading question.
VC100a proves that their ordered pair identifies exactly one admitted action.
The fixed decoder table, whose entries are actual catalogue addresses, is

| First / second reply | 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| 0 | — | I | WZW | WWZWW |
| 1 | Z | — | ZW | ZWW |
| 2 | WWZ | W | — | WZWW |
| 3 | WZ | WW | WWZW | — |

One query has only four possible stage replies for twelve admitted laws, so
it cannot distinguish them all. Two suffice by the twelve distinct cells.
A diagonal pair is incompatible with the fixed-permutation contract; it is
not an additional identified law. ∎

`FourLeafTwoProbe` composes the actual first probe, `FourLeafReserveFocus`,
and the second probe at their full intermediate sources. The reserve is already
inside the initial source. Focus parks the old probe together with its fact,
retains L and both selector programs, and has an explicit inverse. No reset
or second independently supplied law is inserted between the observations.
`FourLeafAcquiredLaw` retains the fixed decoder table beside each complete path.
Its twelve `ReadingFactors` derive equality between the independently specified
current-law projection and the decoder reading through the two final facts.
The current L is also derived equal to the initial L. `FourLeafReplyDecoder`
reads a row and a cell using the existing address readings; its actual input
contains only those facts and the fixed table, with no source phase or chosen L.

The code also retains a useful weaker equality: I and W give the same second
fact from phase 1. Substituting W for a resident I is nevertheless refused at
the actual focus boundary. Agreement of that answer cannot repair the changed
source relation. Wrong row selection and treating a diagonal as a catalogue
law are refused separately. The fact's question type is identical across all
twelve laws and both probes, so it does not encode the answer as a word name.

`FourLeafInstallLaw` continues at the consumer with that actual decoder input
and a newly prepared probe. It records the decoder's answer beside its input,
installs the recorded address, and retains the acquired facts and decoder
table. `FourLeafRecoveredWords` binds the next actual catalogue selection to
that installed address. For arbitrary four symbolic labels, its twelve
`ReproducesAction` branches derive the phase action previously identified.
The consumer checks include input 2, which neither acquisition query read.
Choosing another word despite the learned address is refused at selection,
including a preparation on which the two words happen to have the same image.

This is reproduction of the acquired action through the supplied library.
It does not silently identify that action with a later uncontrolled source
whose law may have changed. Nor must every new question acquire the whole law:
on a four-slot source whose values are all equal, every catalogue action has
the same image. That weaker value question needs no such identification.

The finite joint witness fixes the unused outer laboratory remainder to Never;
the word, contact, recording and focus constructors retain their generic
interfaces. Generalizing the entire nested witness over that unused remainder
caused repeated Swift associated-type substitutions without a verdict and is
not needed for the complete twelve-law result. A compiler resource delay was
not counted as a mathematical refusal.

The resource count here is two **phase-image queries**, not two primitive
contacts. The admitted macro-words have different lengths; their explicit
contact compositions and internal selection are supplied by the word-query
contract. This construction does not yet derive a primitive instruction-tape
interpreter or infer that an arbitrary physical source supplies this contract.
It establishes acquisition and reuse for the displayed relations, while
VC100a identifies the complete action class those relations present.

**VC100c (the acquisition cost belongs to the requested effect).** Let r≥2,
let the unknown law range over all permutations τ of r positions with one
known parity, and let each permitted query read τ(i) at a chosen input i.
Supply a value tuple x and its equality pattern to the query chooser. Write
m for the largest number of positions carrying one equal value. The question
is the resulting value tuple y, where y_{τ(i)}=x_i, rather than the route of
each separately identified occurrence. Its exact optimal worst-case number
of point queries is

    min(r−2, r−m).

If parity is not supplied and all permutations are admitted, the number is
r−m. These counts allow adaptive choices and count distinct queried inputs.

*Upper bounds.* Query every input outside a largest equal-value class.
There are r−m such inputs. Their answers locate those values, and every
remaining output position must carry the common value of the unqueried
class. Alternatively, with known parity, r−2 queries recover the complete
law by VC100. Both constructions use the actual replies, not the unknown
law as an additional decoder input.

*Lower bound.* Consider any reached transcript using t<min(r−2,r−m)
distinct queries. At least three inputs remain unqueried, and their values
cannot all agree, since r−t>m. Choose three unqueried inputs containing two
different values, and cycle these three inputs before applying a law τ
consistent with the transcript. This changes the resulting value tuple,
preserves parity, and preserves every acquired reply. The same transcript
therefore cannot determine the requested effect. Adaptive choices do not
help: they are identical along this shared transcript. Without known parity,
a transposition of two differently valued unqueried inputs supplies the
corresponding lower bound t≥r−m. ∎

More locally, after a consistent transcript under known parity, completion of this value
question is unique exactly when at most two inputs remain or all remaining
input values agree. Thus parity saves one query in the optimal experiment
from no prior point replies exactly when all supplied values are distinct.
If a value repeats, the optimal value-question strategy already leaves that
repetition unread. This statement does not claim that parity never helps
after an independently imposed, less useful choice of earlier queries.

There is a related distinction between the number of possible answers and
their acquisition cost. If an input value repeats, exchanging two equal
inputs reverses a law's parity without changing its entire value output.
Every multiset layout is consequently attainable with either prescribed
parity. If the value multiplicities are m₁,…,m_k, there are exactly
r!/(m₁!⋯m_k!) such outputs. This count does not determine the query cost.
For seven positions, the equality patterns (4,1,1,1) and (3,2,2) each give
7!/24=210 possible value outputs, but require respectively three and four
point queries by the proved criterion. The law family and point-query
instrument are the same. The relation between each question and that
instrument, not only the cardinality of its answer space, fixes the cost.
The first strategy reads its three singly occurring values. The second
must read the four positions outside its triple; these readings also
distinguish the destinations of equal-valued inputs that the final value
question does not distinguish.

If the law is additionally sampled uniformly from its prescribed parity
class, the two examples also have identical answer entropies. For each fixed
value output, the laws producing it differ exactly by permutations within
the input equality classes. There are m₁!⋯m_k! such permutations. Exchanging
two equal inputs pairs their even and odd members, so exactly half have
the prescribed parity. The two examples therefore each have 12 laws per
output: 4!/2=12 and 3!2!2!/2=12. Their 2520 even laws induce 210 equally
likely outputs, giving H(Q₁)=H(Q₂)=log₂210.

Nevertheless their optimal zero-error expected point-query counts are
three and four, just as their optimal worst-case counts are. The lower
bound above rules out early completion on every consistent transcript,
not just one difficult branch; the attaining strategies use exactly their
respective bound on every branch. Thus the distinction is beyond the comparison between
an average uncertainty measure and a worst-case cost. Even identical answer
distributions do not determine acquisition cost through the declared
instrument. Uniform sampling is an additional premise of this entropy
comparison, not a consequence of the source relations; the deterministic
query bound did not require it.

For VC100b's twelve even laws and a supplied tuple (A,B,B,B), one query at
input 0 suffices. Replies 0,1,2,3 give respectively (A,B,B,B), (B,A,B,B),
(B,B,A,B), (B,B,B,A). The compatible address classes are respectively
{I,WZW,WWZWW}, {Z,ZW,ZWW}, {W,WZWW,WWZ}, and {WW,WZ,WWZW}.
`PhaseWordCatalogue.Outputs` already derives their action on arbitrary
symbolic labels; this substitution identifies the value effects while
retaining three possible laws in each class. The existing two-probe resident
pipeline acquires the full law. `Checks/FourLeafValueQuestion.swift` composes
`ReadRecordedAnswer` on each actual first-probe fact with the existing
addressed reading of the supplied four-output value table. For arbitrary
A,B, all twelve decoded tuples equal the independently derived word actions.
The same full first fact is admitted for I and WZW, while identifying their
actions on four distinct labels is refused. Selecting a row inconsistent
with that actual fact is refused separately. These checks establish the
one-fact value decoder at this interface.

The resident continuation is supplied by `FourLeafOneFactRoot` and the
twelve paths in `FourLeafOneFactWords`. The actual first probe is followed
by an invertible reassociation: its original source, prepared reserve and
full reply table are parked behind the new consumer's program. Only its
acquired fact and a fixed four-entry table enter `FourLeafEffectDecoder`.
The table selects respectively I,Z,W,WW at the four observed addresses.
The existing installation and root-bound selection apply that representative
to one marked value and three equal blanks. All twelve resulting phase
values agree with the original laws' value effects.

`FourLeafParkEffect` then reassociates the completed source to recover the
original source and first fact. The used payload, representative and its
decoding record remain in a separate resident remainder. Both reassociations
derive their explicit inverses. `FourLeafRefinedInquiry` continues from that
actual endpoint with the existing reserve focus and only the second probe.
Its twelve lifted factors decode the original law from the two actual facts;
they retain the first fact and the already completed value effect.
`Checks/FourLeafQuestionRefinement.swift` composes these readings with
`RecordReading` at the same endpoint. It records the recovered law while
retaining the complete source, using the same law question across all cases.

In particular WZW first installs I for the weak question and later recovers
WZW for the law question. Their agreeing first facts and weak outputs do not
identify these two roles. Replacing the parked source by I is refused at the
actual reserve-focus boundary. Likewise, executing WZW when the resident
selector chose I is refused even though their weak value outputs agree.
That refusal concerns the selected operation contract, not a claim that
WZW has the wrong value effect.

The full resident witness fixes the marked tuple and unused remainder;
the reassociations, consumer root and phase-word equations retain their
generic interfaces. The declared strengthening is from this value question
to the law question. Its additional cost is one phase-image query; recording
and reading existing facts do not count as new queries of the unknown law.

An unknown future tuple does not supply its equality pattern to the present
chooser. A uniform guarantee for every future tuple must include the
all-distinct case and still needs r−2 queries with parity, for the same fixed
law. Likewise, equal
values may belong to distinct occurrences: a question retaining each
occurrence's destination is the law question and does not receive this
reduction. The saving comes from the declared question and available source
relations, not from discarding a distinction that the question still uses.

**VC100d (additional acquisition after a question changes).** Retain VC100c's
fixed law, point-query instrument and known parity. Suppose a consistent
transcript has already read an input set J. Let U be the unread inputs,
u=|U|, and let m_U be the largest equality class of the newly requested
payload restricted to U. For u=0 put m_U=0. The exact number of additional
point queries needed to determine the new value output is

    min(max(0,u−2), u−m_U).

This is a conditional count at the actual transcript, not permission to
reuse replies after the law changes.

*Proof.* The images of J and their carried values are already known. All
remaining completions are bijections from U to the unused output positions;
two such completions of the prescribed parity differ by an even permutation
of U. Read U outside a largest new equality class, or read all but two
remaining inputs and complete using parity. These use respectively u−m_U
and max(0,u−2) additional queries. Below both bounds, at least three inputs
remain unread with at least two different new values. A three-cycle on
those inputs preserves the complete old and new transcript and parity but
changes the new value output. This applies at every adaptive branch. ∎

The first experiment can be optimal for its question without being an
optimal prefix for a later, stronger question. Write P for the first input
equality partition and Q for a refinement: every Q-class lies within one
P-class. Reading the Q-value output determines the P-value output by the
fixed merging of its labels. Thus this is an actual strengthening of the
question, not an unrelated task.

Let M≥3 be the largest P-class size. Every transcript completing P in its
optimal r−M queries leaves exactly one entire largest P-class C unread.
Indeed, M inputs remain; VC100c requires all of them to have the same
P-value. Put c_C=max{|D|: D is a Q-class contained in C}, and put
m_Q=max{|D|: D is a Q-class}. Applying the conditional bound above, optimal
completion of Q after that transcript takes r−max(2,c_C) queries in total.
Acquiring Q directly needs r−max(2,m_Q). The exact excess for this prefix is

    max(2,m_Q) − max(2,c_C).

Consequently an optimal first experiment has a continuation with no excess
exactly when its unread C contains a largest Q-class, or all Q-classes have
size at most two. If several largest P-classes exist, choosing among them
can matter even though their first-question costs agree. For M≤2 both the
first and refined questions already require r−2 queries.

For a forced example, use seven positions and the two payloads

    P: (A,A,A,A, B,B,B),
    Q: (a,b,c,d, B,B,B),

where a,b,c,d,B are distinct and the fixed merging sends a,b,c,d to A.
The only three-query completion of P reads the three B inputs: any other
three-query transcript leaves four inputs with different P-values.
After these actual replies, Q has four unread, pairwise distinct inputs.
It requires two additional queries. Every optimal first-question
experiment therefore needs five queries in total to answer Q. Acquiring
Q directly reads a,b,c,d and needs only four. No reply became false,
and no previous fact was erased; the additional cost comes from which
relations the first question made it optimal to acquire.

The excess is not bounded by one. With r=2M−1 and M≥4, take P-classes of
sizes M and M−1; refine the first into singletons and leave the second
intact. Every optimal first experiment costs M−1, its completion of Q
costs another M−2, while Q alone costs M. The excess is M−3.
This does not say that retaining knowledge harms a fixed question:
VC100d's additional cost never increases when another truthful reply
from the same law is supplied. It distinguishes that monotonicity from
optimality of the earlier choice of questions.

Even a reply which strictly narrows the possible value outputs can leave
the necessary number of further queries unchanged. For the seven-position
pattern (4,1,1,1), reading one input from the repeated class fixes one of
its output positions. The possible value outputs fall from 210 to
6!/3!=120: the other three repeated values still permit either parity.
But six inputs remain, with largest equal-value class three, so three
further queries are still necessary. Reading a singleton instead leaves
largest class four and requires only two further queries. Both replies
provide true new distinctions; their contribution to this acquisition
objective differs. No probability prior is needed for this comparison.

**VC100e (successive refinement has a sharp relative bound).** Keep the same
fixed permutation, known parity and point-query instrument. Supply a finite
sequence of value questions whose input equality partitions refine one
another. At each stage retain every previous reply and use an optimal
additional experiment for the current question as in VC100d. Question
selection supplies no additional information about the unknown law.

Let C be the resulting total number of distinct point queries, and let C*
be the optimum for the final question supplied from the beginning. Then

    C ≤ 2 C*.

If C*=0, C=0. For C*>0 the ratio is strictly below two, but no smaller
uniform factor works for all finite instances. The bound holds along every
transcript; it does not assume a distribution of laws or future questions.

*Proof.* Write U for the current unread set. If its largest class under the
next question has size m≥3, an optimal additional experiment leaves exactly
one entire largest such class unread. If m≤2, it leaves two inputs and the
whole law is determined by parity. Thus C≤r−2.

Choose a largest final equality class D, of size d. If d≤2, C*=r−2 and
the procedure is already optimal. Suppose d≥3. If no input in D is ever
queried, the final unread set is exactly D, so C=C*=r−d.
Otherwise consider the first stage which queries any input of D. Just
before that stage all of D is unread and lies in one class of the current
question, because the questions refine toward the final one. The optimal
experiment keeps a different class whose unread size is at least d.
Those two disjoint sets imply 2d≤r. Hence

    C ≤ r−2 ≤ 2(r−d)−2 = 2C*−2.

Finally VC100d's family r=2M−1 has C=2M−3 and C*=M. Their ratio approaches
two as M increases, with a unique largest first class, so tie-breaking
cannot remove this limit. ∎

For fixed r≥3 the sharp deterministic guarantee is more precise:

    R_r = max(1, (r−2)/ceil(r/2)).

Local optimal acquisition attains C≤R_r C*. In the proof above, every
nonoptimal case has d≤floor(r/2), hence C*≥ceil(r/2), while C≤r−2.
For r=3,4,5 this means every such sequence is already globally optimal.
The first possible excess occurs at six positions.

No deterministic policy which must answer each question before seeing the
next can improve this worst-case guarantee, even by deliberately taking
extra early measurements. For r≥6 first supply two equality classes of
sizes ceil(r/2) and floor(r/2). On completing that question, any correct
transcript has either at most two unread inputs or all unread inputs in
one class. In the first case stop: the policy has spent at least r−2
queries against an optimum floor(r/2). In the second case refine that
unread class into singletons and keep the other class intact. Finishing
then requires at least r−2 queries in total, while the final optimum is
at most ceil(r/2). This gives the required lower bound. The next question
depends only on the already visible query history; it supplies no additional
information about the unknown law. For r≤5 the lower bound one follows
from any question requiring a query. ∎

If all future questions are supplied before acquisition, their joint question
can be acquired optimally from the start; the bound concerns unavailable
future requests. For unknown parity the same argument, with the last two
unread inputs replaced by the last one, gives
max(1,(r−1)/ceil(r/2)); its first excess occurs at four positions.

The same guarantee covers an arbitrary sequence of these value questions
when the benchmark retains **all** requested answers. For payloads
x¹,…,xᵏ, form the joint value at input i as

    z_i = (x¹_i,…,xᵏ_i).

Transporting z by the common law is equivalent to supplying every requested
value output at their shared output coordinates. The equality classes of z
are the intersections of the individual equality classes. If their largest
size is m_joint, the exact optimal joint acquisition cost is

    C_joint = r−max(2,m_joint).

Apply VC100e to the cumulative joint questions. They refine at each step,
regardless of whether the individual next question refines the last one.
Since the retained transcript already determines the earlier answers,
obtaining the next answer is equivalent to completing the new joint answer;
their optimal additional query costs agree. Thus locally optimal sequential
acquisition satisfies C≤R_r C_joint, with the same sharp finite-size bound
and uniform factor two.

Individual costs do not determine this joint cost. On seven inputs let both
questions have pattern (4,1,1,1), so each individually needs three queries
and admits 210 value outputs. If their repeated classes intersect in k
inputs, every other joint class is a singleton, so m_joint=max(1,k).

| Common inputs in the two repeated classes | Joint query cost |
|---:|---:|
| 4 | 3 |
| 3 | 4 |
| 1 or 2 | 5 |

The questions refer to the same actual input positions and the same law;
that correspondence supplies the intersection. Their separate answer counts
and separate optimal costs cannot supply it.

`ZipFourQuestions` expresses the alignment as an invertible reassociation
of two supplied four-slot tuples into four paired values.
`JointPhaseQuestions` derives, for arbitrary component values, that the
actual W and Z generators commute with this pairing: acting on the pairs
equals pairing their actions on both components. Composition preserves the
equations, so the same relation applies to their generated phase actions.
The consumer refuses to replace one component's W action by Z. Separate
admissibility of both component operations does not establish a common action.

For a benchmark containing only the final answer, refinement remains
essential: otherwise the benchmark omits previously requested answers.
Both bounds require the declared point instrument and retained facts from
the common law. Local minimal acquisition can have an unbounded additive
excess while retaining the stated relative bound.

Retaining the measured facts is stronger than retaining only the current
answer. On four inputs, an optimal two-point acquisition for (A,A,B,B)
already determines the whole even law. But its value output alone leaves
two even laws per answer. At output (A,A,B,B) these are I and Z=(01)(23).
They disagree on the refined payload (a,b,B,B). The already acquired two
point facts answer that refinement without another unknown-law query;
the compressed value answer does not. If only that answer is accessible
and additional access is restricted to point queries, exactly one more
query distinguishes I from Z. Access to a retained original point fact
can instead restore the needed distinction without measuring the law again.

The static consumer `CurrentValueOmitsAcquiredDistinction` derives the
equal earlier value outputs, while `RetainedFactsAnswerRefinement` uses
the existing acquired-law consumer to derive the differing refined outputs.
This concerns the available reading of memory. It does not assert that
forming the value answer destroys the underlying source or archive.

**VC100f (a common relation can be transported while the law changes).**
The fixed-law condition in these query results has a relational extension.
At the t-th contact, suppose the actual law is related to a reference law by

    τ_t = β_t ∘ τ₀ ∘ α_t,

where the input and output permutations α_t,β_t, their inverses and this
relation are available through the supplied construction. A current point
reply τ_t(i)=z is then exactly the reference reply

    τ₀(α_t(i)) = β_t⁻¹(z).

The physical input and output names need not remain fixed. Count distinct
normalized inputs α_t(i), rather than raw input names i alone. To carry
over the exact acquisition bounds, the transports and their inverses must
be usable without further unknown-law contacts, and their available
contents must be determined by the supplied context and the already
counted query history. They may adapt to that history but may not introduce
an additional distinction between laws agreeing on it.

*Proof.* Apply β_t⁻¹ to the defining relation at i. Conversely, to ask
reference input a, ask current input α_t⁻¹(a) and decode the reply by
β_t⁻¹. Each direction uses one point contact and the supplied transports.
Thus, under the stated information and access conditions, the corresponding
inquiry trees simulate each other with the same number of such contacts.
Their coordinate changes supply no additional unknown-law evidence. ∎

For a final current payload x_t, the reference payload is
x₀(a)=x_t(α_t⁻¹(a)); the reference output is then relabelled by β_t.
The conditional acquisition bound of VC100d applies to this pulled-back
payload on the normalized unread inputs. VC100e applies if successive
questions refine in these reference coordinates. Refinement of raw labels
alone does not establish that relation when their input coordinates move.
For arbitrary successive questions, bundle their pulled-back values and
use VC100e's joint-question benchmark instead.

The construction which supplies the transports is substantive. An arbitrary
replacement law does not become known on the basis that some α_t,β_t could
relate it to τ₀. The earlier mixed-history counterexample omits that transport
from its accessible evidence and remains a counterexample.

Nor is an informative coordinate map free acquisition. For a direct
counterexample choose α=τ₀⁻¹ and β=id, so the current law is id. If the
complete α table is supplied, it already identifies τ₀ before any further
point query. The normalization equation is still true, but VC100d's
lower bound based only on the old point transcript no longer applies.
If α is instead only another unknown oracle, using its inverse to prepare
a coordinate can itself require a counted contact. More generally, exact
VC100d counts require that the accessible normalized evidence leaves all
parity-compatible completions of the recorded point images. A transport
that further restricts them changes that acquisition problem.

`KnownPhaseLawTransport<A,B,C,D>` supplies a concrete generic instance
using the existing phase word's actual W change

    (A,B,C,D) → (D,B,A,C).

Its independently specified current question reads input 2, whose answer
is A. Its observation contains only the old point-0 fact and the input
transport obtained by applying the same W action to four coordinate labels.
That map sends current input 2 to old input 0. The decoder reads the old
fact under precisely this address relation; the factor derives agreement
with the actual current source for arbitrary A,B,C,D. The old recorded
question remains point 0. The new reading supplies its current applicability.
The displayed path records that one original reply, performs W beside its
retained fact, and carries the supplied transport beside the resulting
source. It performs no second measurement of the law. The direct current
point-2 reading specifies the target question; the decoder obtains its
answer from the retained point-0 fact and its transport.
Here the coordinate map is the same fixed W action on four supplied labels
for every A,B,C,D; it carries no extra information about the unknown table.

This example also shows why counting raw addresses fails. Reading input 0
before W and input 2 after W reads the same reference input twice. Initial
even laws (0,1,2,3) and (0,2,3,1) give identical complete records for those
two questions, while their current laws after W differ. Reading input 1
after W instead supplies reference input 1 and completes the two-image
calibration. Even repeating raw input 0 after W supplies a different
reference input, namely 3. The coordinate relation determines whether
the contact adds an independent image of the unknown law.

**VC100g (two actions determine an intrinsic four-point frame).** There is
also a way to acquire the correspondence required for combining questions.
Let K have four distinct points. Supply two directed bijections W,Z on K,
where W has one three-cycle and one fixed point, and Z exchanges two
disjoint pairs. These are the action shapes of the existing phase generators.
Define the roles

    b = the unique fixed point of W,
    a = Z(b),    c = W(a),    d = W(c).

They are four distinct points, and their complete actions are forced:

    W: a→c→d→a, b→b;
    Z: a↔b, c↔d.

Indeed Z has no fixed point, so a differs from b and belongs to W's
three-cycle. W therefore supplies its other two members c,d. Since Z
exchanges a,b, its remaining exchange must pair c,d. No input point was
chosen as a distinguished origin in this definition. Under any renaming
of K, the same expressions produce the renamed roles.

For two such systems with corresponding W and Z actions, matching these
four roles gives an isomorphism of both actions, and it is the only one.
Any intertwining bijection must preserve W's unique fixed point and then
its images under Z,W,W. W alone leaves three possible cyclic alignments
of its other points. The second action removes exactly that ambiguity.
Which actions correspond remains part of the compared signature;
knowing that two systems generate an abstractly isomorphic group does not
identify their individual contacts or physical occurrences.

The entire frame has exact worst-case acquisition cost **three point
queries**, each asking W(i) or Z(i), when the four point identities and
the stated action class are available. Start at any accessible point i.

* Read j=W(i). If j=i, then b=i. Read a=Z(i), then c=W(a); the remaining
  point is d.
* If j≠i, read k=W(j). The directed three-cycle is i→j→k→i; its remaining
  point is b. Read a=Z(b), then obtain c,d from that already known cycle.

Both branches use two W replies and one Z reply. The starting point
affects their order, not the final frame. There are eight possible W
three-cycles and three possible Z pairings, hence 24 distinct frames on
four named ports. Each single W point reply leaves exactly two possible
W actions; reading Z does not distinguish them. Conversely, any W history
still permits all three Z pairings until Z is read. Thus every successful
transcript requires at least two W queries and one Z query. The algorithm
attains both lower bounds on every branch. This counts the stated point
queries, with their preparations and macro execution supplied by that
instrument; the action-type premises come from the supplied construction
or an independently justified calibration.

This is a mathematical frame construction from the established W,Z
actions. The earlier resident two-probe pipeline does not implement this
new adaptive three-query procedure; its query count and algorithm are
established here by the displayed argument.

**VC100h (a unique frame need not give compatible joint actions).** The
frame part of VC100g needs less than its full action premise. If W has
one three-cycle and the unique fixed point b, any second bijection Q
satisfying Q(b)≠b defines four distinct roles

    a=Q(b),    c=W(a),    d=W(c),    b=Fix(W).

Every bijection intertwining two such pairs must match these roles.
Consequently there is at most one candidate correspondence. This does
not yet show that it intertwines Q on the other three points. VC100g's
two-exchange premise forced those remaining rows; the weaker premise
does not.

The distinction survives even when both individual action shapes are
fixed. On the same four roles take the directed cycles

    W=(a c d),    Q₁=(b a c),    Q₂=(b a d).

Each action has order three and one fixed point. Both pairs (W,Q₁) and
(W,Q₂) produce the very same intrinsic roles above: W fixes b, both Q
actions take b to a, and W then takes a to c to d. Yet their joint actions
are incompatible. Writing W∘Q for performing Q and then W gives

    W∘Q₁=(a d)(b c),    W∘Q₂=(b c d).

The first has order two, the second order three. If a common bijection
intertwined both corresponding actions, it would intertwine every
composite word and preserve its order. These two periods contradict
that requirement. No relabelling of the four points repairs it.

There is also a direct distinguishing preparation. Start at b, selected
as W's unique fixed point. One joint step reaches c in both systems.
After the second joint step, the first system is back at b and the
second is at d. Thus identical individual periods, the same acquired
frame and even the same first joint answer do not determine continued
joint behavior. A joint contact supplies the missing relation.

The remaining acquisition problem has an exact positive answer. Suppose
only this frame and the two individual three-cycle shapes have been
acquired, with no further Q replies. Given Q(b)=a, the third member of
Q's cycle is either c or d; these give exactly Q₁ and Q₂ above. One Q
query at the intrinsically identified point a returns c or d and completes
the joint action. No zero-query completion works because both laws retain
the entire available frame. Equivalently, the unresolved relation is
whether Q(a)=W(a) or Q(a)=W²(a). It survives all point renamings and
belongs to the relative placement of the actions, not either action's
individual period. This is a conditional one-query count after the frame
is available.

The complete acquisition problem in this action class also has an exact
answer: **three point queries for the frame, four for the full joint
action**, in the worst case. The class consists of all pairs of directed
three-cycles W,Q on four known points with different fixed points; this
is exactly Q(b)≠b. VC100g's algorithm still acquires the frame with two
W replies and Q(b). Querying Q(a) then identifies the remaining action.
There are 24 possible frames (each with two Q completions), while a
two-query tree has at most 4² leaves, so no two-query strategy always
identifies the frame.

For the full-action lower bound, the two contacts play symmetric roles
in this class. Suppose the first query is W(i), and consider its possible
reply i. W then has two possible orientations on the other three points.
Independently, Q has six possible three-cycles whose fixed point differs
from i. If the next query asks W, at least six Q actions remain for the
last query, which has at most four replies. If it asks Q, some possible
reply leaves at least two Q actions; both W orientations also remain.
The last query to either action cannot determine the other. Thus some
transcript needs at least four queries. A first Q query has the symmetric
argument. The four-query construction attains this bound. These counts
use point access to the two supplied actions; their adaptive acquisition
proof is mathematical, not a new resident query interpreter.

The two three-cycles trace triangles sharing one edge. For (W,Q₁) that
edge is a→c in both actions. For (W,Q₂) it is d→a in W and a→d in Q₂.
The unresolved binary relation is therefore agreement or opposition of
their directions on the shared edge. Interchanging the names of the two
contacts or reversing both directions preserves this distinction; reversing
only one contact exchanges the two cases. The displayed obstruction
therefore preserves the directed contacts as stipulated. Allowing an
independent replacement of a contact by its inverse changes that comparison
contract, and cannot be treated as renaming the points.

Nevertheless these same systems admit an explicit contact-to-word
translation. In performed order their actual words satisfy

    Q₁ = W Q₂,    Q₂ = W W Q₁,
    Z = W Q₁ = W W Q₂.

Both pairs therefore generate exactly the same twelve phase actions as
the original W,Z family. What fails is correspondence of each single
contact to the equally named single contact. If the interface permits
translation to words, keep W and substitute the displayed word for Q.
Composition then preserves every translated phase action at its word
boundaries.

With only the two forward contacts of each target interface counted as
primitives, translating Q₁ needs exactly two contacts, and translating
Q₂ in the reverse direction needs exactly three. For the first bound,
neither target primitive equals Q₁, and W Q₂ attains two. In the reverse
direction neither primitive equals Q₂. Among two-letter words, W W fixes
b, Q₁ Q₁ takes b to c, and W Q₁ and Q₁ W are involutions, whereas Q₂
has order three. Thus none is Q₂; W W Q₁ attains three. If inverse
contacts are supplied as additional primitives, that cost question changes.
These counts concern the two declared contact interfaces, not the earlier
star-contact implementation of each macro.

The translation does not identify the intervening execution histories or
erase its additional contacts. A question about which single contact
occurred keeps that distinction. The positive bridge and the earlier
refusal thus answer different, explicitly related interface questions.

`PhaseAlignmentObstruction<A,B,C,D>` realizes the example using the
existing actual words Q₁=WWZ and Q₂=WZ. It composes their cubes and the
joint words WWZW and WZW through their exact intermediate sources.
The individual cubes, the first joint square and the second joint cube
return arbitrary supplied values to their initial arrangement. The
marked-point consumer derives the common intrinsic preparation, the
common first joint answer and the unequal second answers. Requiring
those final answers to be equal is rejected. These are relations of the
actual words, without an added assumption equating their results.
The generic consumer `PhaseContactWordTranslation` also composes the
four displayed translations through the current sources and derives their
endpoint equalities for arbitrary A,B,C,D.

This sharpens the positive identification claim. Relations can force
the only possible correspondence; additional relations still decide
whether that correspondence is an admissible one. In this example the
remaining obligation is precisely a joint action, not another origin,
unit or independently assigned coordinate label.

The negative result does not require a complete four-point universe.
Its local certificate is a preparation b and a corresponding word P with
P²(b)=b in the first displayed action, whereas P′²(b′)=d′≠b′ in the
second. A proposed map h preserving the preparation and those action
steps would require

    b′ = h(b) = h(P²(b)) = P′²(h(b)) = d′.

Thus even a non-injective intertwining map with h(b)=b′ is impossible.
Adding unobserved states outside the displayed action does not repair
this equation while those relations are retained. If b is only a
projected reading, preservation of the projected action steps must be
established as part of this contract; an observed return alone does not
assert a complete hidden-state return. Both systems can exist as
different subsystems. The excluded claim is their proposed identification
under the stated preparation and corresponding contacts. This is M71's
local incompatibility applied to acquired joint actions.

**VC100i (VC89 applied to a library of programs).** Identifying the
unknown action is not always necessary to act correctly. Apply VC89's
existing adequate-choice criterion to a finite nonempty context family C
and a finite program library P. Let L_c⊆P contain the programs whose
actual application in c satisfies an independently specified target on
every admitted working input. For available evidence E:C→M, a selector
d satisfying d(E(c))∈L_c exists exactly when

    for every m∈E(C),  ⋂ { L_c : E(c)=m } ≠ ∅.

VC89 supplies the proof. The requirement can concern the phase result,
histories, contact counts or records; changing it changes L_c. Membership
must follow from actual application paths. The criterion itself does not
acquire the sets L_c or their proof.

If each context permits exactly one program, this reduces to the usual
factorization of that program through E. With several permitted programs,
requiring some previously preferred choice to factor can be too strong:
a different common program may work throughout the same fiber. With no
readout, E is constant, so one program must belong to every L_c. A longer
word can supply such an intersection even when the shorter library does
not. The library, target question and cost therefore belong to the
acquisition problem; the unknown source alone does not determine it.

**VC100j (acting without identifying the remaining orientation).** Keep
the acquired intrinsic frame of VC100h and W=(a c d), with one unknown
but fixed Q∈{Q₁,Q₂}, Q₁=(b a c), Q₂=(b a d). Available primitives are
forward W and Q. Words here are written in performed order. Then

    U = Q Q W Q W           acts as Q₁ for either fixed Q;
    V = Q Q W W Q W W       acts as Q₂ for either fixed Q.

These are full phase-action equalities on arbitrary inputs, not agreement
only on the preparation b. They require no intermediate readout, branch
selection or identification of Q. They do require three actual Q calls
using the same law. “No readout” does not mean no interaction, no change
to the working phase or no information elsewhere in the whole source.

For existence, use the already established performed-order identities
Q₁=W²Z, Q₂=WZ, W³=Q₁³=Q₂³=Z²=I. For Q=Q₁, (Q₁W)²=I, so U=Q₁.
For Q=Q₂, Q₂²W=Z and ZQ₂W=ZWZW=W²Z=Q₁. Interchanging W and W² and
interchanging Q₁ and Q₂ gives V. This proof uses the actual joint
relations; the separate periods alone would not establish these words.

The lengths five and seven are minimal among fixed forward words with
no intermediate readouts. To see this without enumerating words, consider
the three partitions ab|cd, ac|bd, ad|bc. W cycles these partitions; Z
fixes each. A word with n occurrences of W and m occurrences of Q acts
on these partitions as W^(n+2m) under Q₁ and W^(n+m) under Q₂. For a
common Q₁ result, m≡0 and n≡2 modulo three. A word with m=0 fixes b and
cannot be Q₁. Thus m≥3, n≥2: at least five calls, attained by U.

For a common Q₂ result the congruences are m≡0, n≡1 modulo three.
Again m=0 is impossible. Below length seven the only remaining possibility
has three Q calls and one W. Its word is Q^k W Q^(3−k), 0≤k≤3, whose
fixed point is Q^(3−k)(b). For k=0 or 3 that point is b; for k=2 it is a.
For k=1 it is c under Q₁ but d under Q₂. None is the common target Q₂,
which fixes c. Hence at least seven calls are needed, attained by V.

This resolves two different acquisition questions:

| Required guarantee after the frame is known | Additional readout | Forward action calls |
| --- | --- | --- |
| Identify which Q is present | One point query Q(a) | Query interaction accounted separately |
| Implement Q₁ by a word chosen after that identification | Uses the acquired answer | One if Q₁, two if Q₂ |
| Implement Q₂ by a word chosen after that identification | Uses the acquired answer | Three if Q₁, one if Q₂ |
| Implement Q₁ by the same word for either fixed Q | None | Exactly five |
| Implement Q₂ by the same word for either fixed Q | None | Exactly seven |

The point-query rows retain VC100h's query/preparation contract. They are
not claims that obtaining or retaining the query answer costs no contacts.
Nor are these words an identification of the two interfaces: their
primitive actions and intermediate histories remain different.

`UnobservedPhaseBridge<A,B,C,D>` composes all four paths through their
actual intermediate arrangements. Its generic `Null` witnesses derive
the two common endpoint actions without asking the caller to supply
their equality. The minimality proof above is mathematical; the Swift
construction proves the attaining words, not a search over all words.
The costs count W,Q calls in the stated interface. Expanding the supplied
Q clauses into the existing W,Z representation certifies their phase
effects; it is not the cost convention used in the five/seven bounds.

**VC100k (changing context, and acquisition of an applicable correction).**
The same acquired frame need not make VC100j applicable over time. Replace
only the third Q in U by Q₂, with its first two occurrences Q₁. The
performed word Q₁ Q₁ W Q₂ W acts as W, not Q₁. Starting from b it returns
b, whereas the stable-law U reaches a.

This change can be entirely internal to one fixed reversible system.
Take a three-state clock t∈{0,1,2}; W acts on phase and leaves t alone.
One total Q contact acts on phase by Q₁ at t=0,1 and by Q₂ at t=2, then
advances t cyclically. This is a bijection on the twelve point-and-clock
states: the final clock determines the preceding clock and hence which
inverse phase permutation to apply. Starting at t=0, U uses Q₁,Q₁,Q₂
and ends at t=0 with phase action W. Thus the clock returns and the same
instantaneous intrinsic phase frame remains available, while the desired
phase bridge fails. No external source of change has been introduced.

The distinction is more general than this clock. Suppose each Q occurrence
may independently use either Q₁ or Q₂, with the same W and intrinsic
frame. No fixed forward word without intermediate observations realizes
one fixed full phase action if it contains Q. Choose its last Q, fix all
earlier choices, and compare two executions differing only there. Their
common prefix is bijective. Some working input therefore reaches a point
where Q₁ and Q₂ disagree. The remaining suffix consists only of powers of
W and cannot erase that difference. A word containing no Q fixes b, so
cannot realize either target Q₁ or Q₂.

Any specified finite switching schedule in this argument can itself be
implemented by a sufficiently long finite internal clock; the negative
result does not require outside interventions. Its scope is all such
schedules and a fixed word required to work on every phase input. It is
not a prohibition on feedback, a controller exploiting a particular known
clock law, or success on a special preparation. For instance Q(b)=a in
both clauses, so that one prepared answer alone conceals their difference.

For the displayed three-state clock there is a positive repair. Acquire
only the current bit e(t) indicating t=2. Select Q if e=0, and WQ if e=1.
The latter is Q₁ by VC100h. Added W does not tick the clock. The resulting
whole contact N therefore satisfies, with E the phase projection,

    N(x,t) = (Q₁(x), t+1 mod 3),       E∘N = Q₁∘E.

This gives an autonomous phase action even though E∘Q does not factor
through E for the uncorrected contact. The evidence has not made the raw
laws identical: it selects an applicable program that makes the requested
phase action common. In the two-word library {Q,WQ}, the permitted sets
are {Q} at clocks 0 and 1 and {WQ} at clock 2. Thus e is necessary and
sufficient for this selector, by VC100i. This is not a lower bound for
every controller allowed to exploit the known clock dynamics.
It also depends on asking for the full phase action: on the preparation b,
raw Q alone reaches a at all three clocks. The positive consumer
`PreparedPhaseWithoutClockReadout` derives that weaker answer directly.

There is a stronger impossibility when the target retains N's actual
clock advance. Even with this clock law known, no fixed forward word of
any length realizes N at every phase and unknown initial clock without
current-clock evidence.
Use VC100j's three pair partitions. W acts as one cyclic step on them;
the Q clauses act as u₀=2, u₁=2, u₂=1 such steps. If a word has n W
calls and m Q calls, its clock advances by m modulo three, regardless of
where the W calls occur. To realize N, m=3k+1. On the pair partitions the
phase action at initial clock t is therefore

    W^(n+5k+u_t).

The first 3k Q calls contribute k complete clock rounds, each with
exponent 2+2+1=5; the remaining Q contributes u_t. W is clock-neutral,
and all partition actions commute as powers of the same three-cycle.
The displayed exponents differ between initial clocks 0/1 and 2, whereas
N has the same phase action Q₁ everywhere. This is impossible.
Allowing inverse contacts cannot remove this particular obstruction:
on the finite carrier each inverse is a positive power of its contact,
so any such word could be expanded into a forward word. The earlier
five/seven cost bounds still use forward calls as their unit.

Thus a longer fixed word cannot replace the acquired distinction while
also preserving this context transition. Among controllers that acquire
one finite message about the initial clock, then execute its selected
fixed word on arbitrary working inputs, at least two used message symbols
are necessary; the displayed bit and the two words attain that minimum.
This lower bound is stronger than the two-word-library observation, but
it retains the clock-advance requirement. It does not exclude a common
phase action with a different clock endpoint, a payload-dependent choice
or a controller given additional current-context evidence. Two symbols
measure a required distinction, not a physical acquisition cost.

If the initial clock is already known to be zero and its transition
relation is retained, the third-clause correction in the earlier U path
can instead be scheduled from that knowledge. `PhaseCyclingBridge.Corrected`
does exactly this. No new clock measurement is needed in that prepared
case. The lower bound concerns a current clock still ranging over all
three possibilities under the executor's available evidence.

The acquired bit is sufficient for this action, but not an autonomous
clock state: e(0)=e(1), while e(1)≠e(2) after one contact. To repeat the
policy one must read the current bit again or possess enough retained
clock information and a valid transition relation. Retaining an old
true record alone does not supply the next selector input.

`PhaseCyclingContacts` supplies the three actual reversible clauses and
their inverse applications. `PhaseCyclingBridge` derives the failed U
endpoint, the returning clock and the repaired endpoint for arbitrary
phase values. `PhaseClockCorrectionBit` reads the actual clock slot.
`AcquiredPhaseClockPolicy` records that reading beside its source and
uses `SelectedLocalApplication` to select the actual Q or WQ application
from its current root. Its decoder input contains only the recorded bit
and a fixed program marker. Each of the three concrete source clauses
derives the same phase result, the actual next clock and the retained
record. The decoder is not handed an additional private orientation or
an independently chosen primitive. The concrete clock law, the reading
construction and the finite selection grammar are the stated premises;
arbitrary user-written reading conformances are not certified by this
example. Checks reject the wrong branch and reuse of the old zero-bit
record at the source whose current bit is one.

Together these results locate the obligation more precisely than “first
identify the law”. Establish which programs are valid throughout the
current evidence fiber, and whether the actual intervening contacts
preserve the relations used in that validity proof. Sometimes one common
word removes the need for identification. Sometimes internal change
destroys that word's applicability. A small acquired context can restore
the requested action without reconstructing the entire source.

**VC100l (acquire through a disturbing contact, then restore applicability).**
The direct clock-slot reading in VC100k is a declared instrument; its
availability does not follow from W,Q. The same selection can instead be
fed by a retained phase-probe reply. Declare one additional internal probe
prepared at a, with the working values parked beside it. Q acts on the
active phase register and the same shared clock; structural refocusing
exposes the working register after the experiment. The probe preparation,
phase readout and this refocusing are the explicit access contract.

Apply Q to the probe once and read only whether its resulting phase is d.
The reply is zero at initial clocks 0/1 and one at initial clock 2. The
contact has already advanced the clock, so this fact is not yet its
current correction bit. Apply two further Q contacts to the reached probe,
without another readout. The actual paths are

| Initial clock | Probe after first Q | After second Q | After third Q | Returned clock | Retained bit |
| --- | --- | --- | --- | --- | --- |
| 0 | c | b | a | 0 | 0 |
| 1 | c | c | b | 1 | 0 |
| 2 | d | d | d | 2 | 1 |

Now the same original fact is the required bit at the restored clock.
Refocus the parked working values together with this actual clock and
fact. The existing selector applies Q for reply zero and WQ for reply one.
The working phase becomes Q₁(x) and the clock advances from its original
t to t+1. The final probe phases a,b,d and the original recorded reply
remain in the whole output. In particular the experiment returns the
clock, not the full source. Initial clocks 0 and 1 remain unidentified by
the supplied reply; the unexamined probe residue distinguishes them.

This path uses three probe Q calls, one retained phase-bit readout, then
one working Q call and at most one working W call. This is an attaining
construction under the stated preparation and refocusing contract. A
minimum contact count over controllers with such auxiliary probes is not proved.
VC100k's word impossibility concerns W,Q acting on its one phase register;
it must not be transferred to the expanded auxiliary-register interface.

`PhaseProbeClockReturn` records after the first actual contact and retains
that fact through the next two. `PhaseProbeClockExperiment` derives the
three clock returns, replies and unequal probe residues. The generic
`ProbeAcquiredPhaseClockPolicy<A,B,C,D>` parks arbitrary working data,
performs this experiment, refocuses the actual returned clock and original
fact, and uses the same `PhaseClockPolicyRoot` decoder. That root now
accepts the acquired fact independently of its acquisition path: no
replacement “current” fact or copied certificate is manufactured. Its
decoder still receives only the fact's answer and the fixed program.
The resulting phase-and-clock targets and retained facts/probes are
derived from the whole composed path.

The refusal at the premature seam is informative. Starting from clock 1,
the first reply is the truthful zero bit, but the clock is now 2. The
zero-bit selector legally chooses its direct Q branch and this actual
branch performs Q₂, not the required Q₁. Its claimed phase target is
rejected. Thus a valid local lookup is not itself proof of the lookup's
applicability. The two further contacts restore the specific relation
that makes this very same retained fact sufficient, while preserving the
changed probe rather than pretending it returned.

The expanded interface also permits a completely unobserved construction.
Write Q_w for Q on the working register and Q_p for Q on the auxiliary
register, both advancing the same clock, and define the performed block

    F = Q_w Q_p Q_p.

The block returns the clock to its initial t. On the working register it
acts as Q_t; its last two contacts alter only the auxiliary phase and the
clock. Thus every F in a composed path presents the same Q_t to the
working register, although the auxiliary residue changes. W_w also keeps
the clock fixed. VC100j therefore applies to the effective interface F,W_w:

    F F W_w Q_w W_w

has working action Q₁ and advances the clock by one through its last Q_w.
The first two F blocks return the clock; the third working Q therefore
still uses the same Q_t. There is no further Q whose law would require
another restoration. Its expanded length is nine primitive contacts. No register is read and
no branch is selected. The auxiliary initial phase may be arbitrary:
its role is to permit the two clock-advancing contacts away from the
working register. Its final phase is retained, not required to return.

Consequently zero readouts are attainable in this enlarged interface;
one readout trades for the shorter four/five-contact path above. Nine
is an upper bound, not a proved minimum contact count. This nine-contact
result follows mathematically by composition of the clock return with
VC100j. VC100m below additionally supplies its full static two-register
trace and closes the continuation question. The single-register obstruction and this
positive auxiliary-register construction differ in exactly the declared
ability to advance the shared clock without acting on the working phase.

**VC100m (a common carrier for a repeatable interface).**
Keep exactly VC100l's fixed clock law and access to the two phase registers.
The admitted complete states are

    C = X⁴ × {0,1,2} × Y⁴,       s=(x,t,y),       E(s)=x.

Here X and Y are any nonempty payload sets. Every working and auxiliary
arrangement is admitted, including repetitions of values. There is no
blank reserve, prepared auxiliary mark, accumulated record, or extra
phase-dependent access condition. Refocusing preserves both registers and
the same shared clock. The contact law and this access contract are fixed
premises; arbitrary changes to them are not changes of state within C.
As in VC100l, nine counts Q/W calls. The admitted structural refocusing
steps are explicit in the trace and are not assigned a free physical cost.

Write q for Q₁ acting on either register's four slots, w for W, and
ε(t)=1 at t=2 and zero otherwise. The actual nine-contact program M from
VC100l and working W have the full actions

    M(x,t,y) = (q(x), t+1 mod 3, q^ε(t)(y)),
    W_work(x,t,y) = (w(x), t, y).

The auxiliary formula follows from the actual F blocks, not from treating
their unobserved outputs as disposable. If y=(E,F,G,H), the two auxiliary
contacts within one F produce respectively

    t=0: (G,H,E,F),     t=1: (H,G,F,E),     t=2: (G,E,F,H).

Each F returns the clock. The first two auxiliary permutations square to
identity; the third is q² and its square is q. M contains two such F
blocks, followed by no further auxiliary contact. Its working action is
q by VC100j and its final working Q advances the clock once. This proves
the displayed full formula.

In particular both M and W_work map all of C back into C, and

    E∘M = q∘E,       E∘W_work = w∘E.

These two obligations have different roles. The equations establish the
promised phase action; closure establishes that the complete actual output
is an admitted input for the next call. A statement about one register's
allowed values alone would not supply that closure.

For every finite word in M,W_work, repeated composition therefore gives
the corresponding word in q,w under E. Proof: the empty word preserves
C and E; either appended generator preserves C and its commuting equation
extends the preceding one. No enumeration of longer words and no fresh
preparation is needed. Since w,q generate the twelve phase actions of
VC100h (the performed word wq is Z), all twelve are realizable through
this reusable interface without reading the current clock. This concerns
phase actions at call boundaries, not identity of full action histories.

The full formula makes that distinction particularly explicit:

For a finite interface word u containing m calls to M, let u_phase be the
same performed word with M replaced by q and W_work by w. Its complete action is

    u(x,t,y) = (u_phase(x), (t+m) mod 3, q^floor((t+m)/3)(y)).

Each M advances the clock and applies one auxiliary q precisely when that
advance wraps from two to zero; W_work changes neither. Induction on the
word therefore proves the formula. In particular,

    M³(x,t,y) = (x,t,q(y)),       M⁹(x,t,y) = (x,t,y).

Every three successive calls visit each clock once, so their auxiliary
exponents sum to one, while q³ is identity on working data. Repeating
that triple three times proves the second equation. For auxiliary data
with a nontrivial q orbit, three calls return the working phase and clock
but not the auxiliary register. On a payload domain with such a tuple,
the full action has order nine: clock return requires a multiple of three
calls and auxiliary return requires three such triples. One call to M
contains nine primitive Q/W contacts; the full nine-call return thus uses
81 contacts. Full return here means return of the displayed carrier C,
not a carrier enlarged by an independently retained contact journal.

`UnobservedClockInterface.swift` constructs the three actual F paths and
three nine-contact M paths from `PhaseCyclingContacts`, with generic
working and auxiliary payloads. `WholeSources` and `WholeOutputs` derive
all input/output arrangements. Structural refocusing carries every field.
`ReusablePhaseInterface.swift` supplies generic `CommutingTransition`
constructors for M and W_work, and applies the existing `JoinedTransition`
at the actual full intermediate sources. It admits MM, MW and WM at all
three clocks and derives M³'s complete output. W_work closes under further
W_work directly by its generic unchanged-context formula. The common
carrier and the finite-word induction above extend these constructions;
M⁹ is a consequence of the full M³ formula, not a separately enumerated
81-contact Swift fixture.

The operation-address adapter `PhasePathReading` alone proves no intended
meaning. The concrete squares tie its actual path endpoints to the
independently defined phase actions. Neither their constructors nor the
generic join request the final phase equality from the caller. The
verified fragment consists of these constructors and their joins, not
every possible conformance to `PredicateReading` or `CommutingTransition`.

Finally, absence of readouts during execution does not assert permanent
unobservability of the residue. Two initial states with the same working
phase have identical boundary working histories under the same interface
word; this follows from its commuting equations. A policy using only
those histories also makes the same next choices. Auxiliary readings,
clock readings, intermediate observations or timing questions are richer
interfaces and need their own comparison. For example a known auxiliary
mark at a is unchanged by M at initial clocks 0/1 but moves to c at
initial clock 2. An admitted subsequent auxiliary reading could distinguish
that case. The established claim is an interface requiring no clock
identification, with equivalence relative to its declared observations.

**VC100n (exact residue and the price of stronger return contracts).**
Keep VC100m's carrier and fixed program M. Assume |X|≥2 and |Y|≥2 when
distinguishing transformations on the entire carrier. Write

    R(t,y) = (t+1 mod 3, q^ε(t)(y)).

Then M=(q,R), W_work=(w,id), R³=(id_clock,q), and R has order nine.
For any two forward interface words u,v, the full-action formula gives

    u=v on all of C  iff  u_phase=v_phase and m(u)=m(v) mod 9.

Here m counts M calls. Sufficiency is immediate. For necessity, two payload
values already distinguish different slot permutations: place one value
in a single slot and the other value everywhere else. Equal full actions
therefore imply equal working permutations. Their environment factors
then agree; R has order nine since clock return requires three steps and
a non-fixed auxiliary tuple requires three such triples. This comparison
concerns transformations on the entire carrier, not agreement on one
tuple, a primitive trace, or its cost.

The two coordinates can be independently realized. In performed order,

    K = (W_work M)^2 = (id,R²),
    K⁵ = (id,R),
    N = K M⁷ = (q,id).

The first equation uses (wq)²=Z²=id; the others use R⁹=id and q³=id.
Together with W_work=(w,id), these forward words generate all of
A₄×C₉: w and q generate the twelve working permutations, while K⁵
generates the full environment factor. Thus there are exactly 108 full
transformations and nine above each working transformation. This counts
actions, not states; X and Y need not be finite. The kernel of the working
projection is exactly {id}×C₉, rather than an unspecified hidden remainder.

There is an exact cost result in this same, restricted interface. Programs
are fixed forward words over {M,W_work}; every M invokes its established
nine-Q/W implementation and every W_work costs one Q/W call. No inverse
primitive, read-dependent selection, or rewriting of M's implementation
is added. On the full carrier, the minimum costs for these contracts are:

| Required final result | Exact cost | Attaining word |
| --- | --- | --- |
| Working q, with continued interface applicability | 9 | M |
| Working q and original clock; auxiliary unconstrained | 29 | B=K M |
| Working q, original clock and original auxiliary register | 83 | N=K M⁷ |

For the lower bounds, let a word have m calls to M and n to W_work.
A working q requires m>0: w fixes slot b and q does not, so a word in
w alone cannot give q. On the three partitions of four slots into pairs,
w induces a three-cycle and q its square. Thus any word giving q satisfies

    n+2m = 2 mod 3.

Clock return requires m=0 mod 3; complete environment return requires
m=0 mod 9. In either case n=2 mod 3, so n≥2. The respective positive
minima of m are three and nine, giving 9·3+2=29 and 9·9+2=83. Without
clock return, m≥1 alone gives cost≥9. The displayed words attain all
three bounds. In particular 83 is a proved weighted-word minimum here,
not a minimum among all programs in the original primitive contact
language. Structural refocusing cost remains outside this Q/W count.

The full outputs also expose exactly where the stronger price disappears:

    B(x,t,y) = (q(x),t,q(y)),
    N(x,t,y) = (q(x),t,y).

On the invariant subdomain q(y)=y, B already restores the environment,
so the full-return minimum there is 29 (with |X|≥2). Repeated payloads
are not excluded to make the lower bound work: the 83 bound quantifies
over all admitted y, including some that q changes. A demonstration on
one fixed auxiliary tuple cannot certify return on that larger domain.

`PhaseInterfaceResidue.swift` constructs the actual K and B paths at all
three clocks, then builds N=B M³ M³ from VC100m's actual cubes. Its
generic `Endpoints: Null` witnesses identify short complete boundaries
with the composed paths; no caller supplies the desired final equality.
`Checks/PhaseInterfaceResidue.swift` checks these paths and permits B's
full return on fixed auxiliary tuples. It rejects treating K as a whole
identity, treating B as preserving arbitrary auxiliary data, and inferring
full action equality from equal M counts alone. The classification and
the all-word lower bounds above are mathematical proofs; these concrete
Swift witnesses establish the attaining constructions and their stated
boundaries, not an enumeration of every candidate word.

**VC100o (ten primitive contacts suffice and are necessary for full return).**
Keep the known clock law and carrier C of VC100m. Let A=Q_work be the
actual primitive that advances the clock, applying q at clocks zero/one
and r=Q₂ at clock two. Write w=W, with w³=q³=id, (wq)²=id and r=w²q,
all in performed order. The fixed word

    T = W_work A² W_work A⁴ W_work²
      = W Q Q W Q Q Q Q W W

acts as T(x,t,y)=(q(x),t,y) on all of C. Every call is on the working
register: six Q calls return the clock and no call acts on y. No readout
or special preparation is used.

To verify the phase action, set P=A² W_work A⁴. Its three clock clauses are

| Initial clock | Actual phase word in P | Phase result |
| --- | --- | --- |
| 0 | q² w r q² r | w q² |
| 1 | q r w q² r q | w q² |
| 2 | r q w q r q² | w q² |

Substitute r=w²q and use qwq=w², wqw=q². The first row reduces to
q²w²q=wq²; the second to q w² (q w q²) w² q²=wq²; the third to
w²(q²wq)w²=w²qw=wq². Thus T's phase action is
w(wq²)w²=w²q²w²=q, proving the full output, including clock and context.

The exact minimum is ten in the following alphabet: Q_work, Q_aux,
W_work, W_aux, each costing one. Each Q uses the same shared clock law;
each W applies w to its addressed register without advancing the clock.
Programs are fixed forward words, with no reading, conditional choice,
clock reset or additional data-transforming operation. Structural
refocusing only provides access to the named register; it is not an
extra uncounted permutation of logical register contents. For the lower
bound assume |X|≥2, |Y|≥2 and demand the displayed output for all of C.

Let m be the total number of Q calls and n the total number of W calls,
on both registers. Clock return requires m=3k. On the three pair partitions
the exponents of w,q,r are respectively 1,2,1 modulo three. Each global
round of three Q calls contributes 2+2+1=5≡2 to the sum of the two
register exponents, regardless of the addressed registers. A final q on
working data and identity on auxiliary data therefore require

    n+2k = 2 mod 3.

Among words of length at most nine with m>0, only (m,n)=(3,0),(3,3),
(3,6),(6,1) survive. With m=0 the working action is a power of w and
cannot be q, since w fixes slot b and q does not.

For m=3 or 6, let a_j count working Q calls in global Q positions j mod 3,
indexed from zero, and let s=a₀+a₁+a₂. If n_work counts working W calls,
the working partition exponent at initial clock t is

    n_work+2s-a_(2-t mod 3).

Equality for all three initial clocks requires a₀=a₁=a₂ modulo three.
Each a_j≤2, so these are integer equalities and s is zero, three or six.
Zero cannot give q. If s=3, each residue appears once among the working
calls, so r occupies each of their three possible positions as the initial
clock varies. Equality between adjacent placements, after cancelling
the common prefix and suffix, would require

    q w^e r = r w^e q

for the number e of intervening working W calls. Auxiliary calls act
on a different register and contribute no factor to this working equation.
Substitution and cancellation reduce it to q w²=w² q, which is false:
the two actual slot permutations move b differently. This excludes
three working Q calls for any number or placement of intervening W calls.

Only six working Q calls and one W remain. All Q calls then act on working
data; the W must also be working, since one W_aux with no auxiliary Q
would change some admitted y. The candidate is A^j W_work A^(6-j).
Choose initial clock t=2-j modulo three, putting the W at clock two.
At clock two A³ has phase w² and A⁶ has phase w. Writing the prefix phase
as h, the full candidate phase is h w² h⁻¹. For j modulo three, h is
respectively id, q, q² followed by a power of w², which cancels in this
conjugation. The three possible results are

    w²,       q w² q²,       q² w² q = w q².

Their fixed slots are b,c,a respectively, whereas q fixes d. None gives
the required full action. All words shorter than ten are excluded, and
T attains ten. The same lower bound holds for the smaller alphabet without
W_aux. It is a proof about the stated words, not a physical time or energy
bound or a bound for controllers with additional observations.

The result closes VC100n's primitive-program question while preserving
its weighted macro minima. N and T agree as complete transformations,
but cost 83 and 10 in their respective implementations. It also preserves
VC100k's single-register obstruction: that target advances the clock by
one, whereas T returns it. Those are different complete questions.

P itself is a useful closed operation: P(x,t,y)=((wq²)(x),t,y), costing
seven calls. Since q=w(wq²)w², P and W_work generate all twelve working
actions while returning the entire context after every call. Every word
over this pair acts as (g(x),t,y); equal working actions imply equal full
boundary transformations. This does not identify their contact histories
or costs, and seven is not claimed here as a general basis optimum.
The pure phase factor already existed as N,W_work in VC100n; these
primitive paths give it a substantially less expensive implementation.

`PrimitivePhaseReturn.swift` constructs P and T from the actual reached
`PhaseCyclingContacts`, with generic working fields and an arbitrary
carried structure. Parametric `Endpoints: Null` witnesses derive the
short boundaries from the full paths. The consumer ties T to the
independently defined q, compares its complete endpoints with N, and
constructs T³ as a whole return. Refusals separate P from q, full context
return from identity on the working register, and q w² from w² q.
The all-word lower bound is the mathematical argument above; no runtime
search or exhaustive Swift word enumeration is used as its foundation.

**VC100p (a complete basis preserving all twelve optimal costs).**
Use exactly VC100o's four primitive contacts, fixed forward programs,
unknown initial clock and complete return contract on C, with |X|,|Y|≥2.
Write v=wq² for the phase action of the seven-contact P. Let c_primitive(g)
be the least primitive cost of (x,t,y)↦(g(x),t,y), and let c_basis(g)
be the least cost over P,W_work with weights seven and one. Then

    c_primitive(g)=c_basis(g) for every g in A₄.

The complete profile is below. Tuples describe output payloads from
(A,B,C,D), rather than forward destinations of individual slots.

| Word | Working output | Both minimum costs |
| --- | --- | --- |
| I | (A,B,C,D) | 0 |
| W | (D,B,A,C) | 1 |
| WW | (C,B,D,A) | 2 |
| P | (A,D,B,C) | 7 |
| PW | (C,D,A,B) | 8 |
| PWW | (B,D,C,A) | 9 |
| WP | (D,C,B,A) | 8 |
| WPW | (A,C,D,B) | 9 |
| WPWW | (B,C,A,D) | 10 |
| WWP | (C,A,B,D) | 9 |
| WWPW | (D,A,C,B) | 10 |
| WWPWW | (B,A,D,C) | 11 |

The three powers of w and the nine distinct w^i v w^j, 0≤i,j≤2,
give all twelve actions. A basis word with at least two P calls costs
at least fourteen, exceeding every displayed upper bound. A word with
one P reduces its surrounding W powers modulo three, and the nine
resulting actions are distinct. Thus its minimum is exactly 7+i+j.
Words with no P give only the three powers of w. This proves c_basis.

Here is a primitive lower bound for the entire profile. Only competitors
of cost at most ten need exclusion. Clock return allows m=0,3,6,9 Q calls.
For m=3 or 6, VC100o's working-position argument still applies to any
fixed working action, not only q: zero working Q calls give a power of w;
three are incompatible with clock independence. Hence an action outside
H={id,w,w²} with m=6 must use all six Q calls on working data. For a
shortest such program, auxiliary W calls can be removed: with no auxiliary
Q they must sum to a multiple of three to return arbitrary auxiliary data,
and commute with all working calls. It remains to classify short one-register
words with six Q calls.

A small exact coordinate representation makes that classification
transparent. Label the four slots b=0,a=1,c=z,d=z² in characteristic two,
with z²+z+1=0. These are labels for the existing four-slot permutations:

    w(s)=z s,       q(s)=z² s+1,       r(s)=z s+1.

No extra physical or contact law is being assumed. Write a six-Q word as

    W^g₀ A W^g₁ A W^g₂ A W^g₃ A W^g₄ A W^g₅ A W^g₆,
    n=g₀+...+g₆,       c_j=z^(g_(j+1)+...+g₆),   j=0,...,5.

Its multiplier is z^(n+1). The vector of additive terms across initial
clocks zero, one, two is exactly

    (z²c₀+c₃)(1,1,z)
      +(z²c₁+c₄)(z,z²,z²)
      +(z²c₂+c₅)(1,1,1).

Each Q contributes one, multiplied by all subsequent Q/W multipliers;
grouping the six contributions in pairs three positions apart gives this
formula. Differences of the first two components, then of the last two,
show that clock independence is equivalent to

    g₁+g₂+g₃ = 1 mod 3,
    g₂+g₃+g₄ = 1 mod 3.

When these hold, the common additive term is

    z^g₆ (z^(2+g₃+g₄+g₅)+1).

For n≤2 the two sums must equal one as integers. Put h=g₁=g₄;
then g₂+g₃=1−h and n=1+h+g₀+g₅+g₆. Substitution yields the full small-cost
classification, without a program search:

| Working W calls n | Clock-independent actions of six working Q calls |
| --- | --- |
| 0 | none |
| 1 | w², v |
| 2 | id, wv, vw |

One more possible shortcut needs exclusion. With nine Q and no W, a
complete-return word has total partition exponent zero. Let a_j count
working Q calls in the three global Q residue classes. Clock independence
and zero working exponent require each a_j=0 or 3. If one residue class
is used, all three working contacts have the same law and cube to identity.
If two classes are used, choose the initial clock making the omitted class
the r class; all six working calls are q, again giving identity. If all
three classes are used, choose initial clock two: A³ has phase w² and
A⁹ has identity phase. With no working class the phase is also identity.
Thus any fixed working action from such a complete-return word must be id.

To finish, the primitive total partition exponent for m=3k Q and n W
calls is n+2k modulo three. For a complete return it equals the exponent
of g, since the auxiliary permutation is identity. Outside H, the three
exponent classes in the displayed profile are:

- exponent two: v at cost seven, and two other actions at cost ten;
- exponent zero: wv,vw at cost eight, and w²vw² at cost eleven;
- exponent one: all three actions at cost nine.

For m=6 the congruence and the small-cost classification exclude every
cheaper candidate: n=1 gives only v outside H, n=2 gives only wv,vw,
and n=0 gives none. The next possible n in each class is three larger.
For m=9, n=0 was just excluded outside H; n=1 or 2 has the wrong
exponent to beat any remaining bound (or already costs at least that
bound). Cases m=0,3 were excluded outside H above. The minima for I,W,WW
are immediate. This proves the full equality of the two cost profiles.

The seven-contact threshold proposed after VC100o follows as well: any
individually context-returning, clock-independent command costing at most
six has action in H. Arbitrarily many such commands still generate only H.
P and W reach A₄ with maximum command cost seven, so seven is the least
possible maximum command cost for this kind of complete interface.

Cost preservation means that an optimal realization is available within
the basis for every specified final action. It does not mean that every
basis word is optimal: P² and WPW have identical full endpoints, but cost
fourteen and nine. Nor may they be exchanged in a question requiring the
same intermediate observations. The theorem fixes complete boundary actions,
the stated primitive alphabet and its cost, rather than all possible tasks.

`PhaseBasisProfile.swift` builds the twelve actual paths at each clock
using the existing seven-contact P and actual W steps. The suffix helper
requires only the actual intermediate source; it assumes no phase meaning
for an arbitrary supplied prefix. The concrete instances supply that source
from P's proved clauses. The consumer compares all complete outputs with
the independently existing `PhaseWordCatalogue`, checks their common full
sources and derives P²=WPW as an endpoint equality. Refusals reject merging
distinct equal-cost actions and reusing P at the pre-W source. The general
lower bounds remain the symbolic proofs above, not runtime enumeration
or cost labels asserted as extra type premises.

**VC100q (four local replacements give a unique optimal boundary word).**
Retain VC100o–p's fixed complete carrier, known contact laws and costs:
W costs one and P costs seven. Words are performed from left to right.
The following replacements preserve the complete endpoint at every source,
including the original clock and the arbitrary retained context:

| Replacement | Old cost | New cost |
| --- | --- | --- |
| WWW → I | 3 | 0 |
| PP → WPW | 14 | 9 |
| PWP → WW | 15 | 2 |
| PWWP → WWPWW | 16 | 11 |

Here I is the empty word. These are equalities of applications on the
complete carrier, not just of their working projections. For example,
P has payload action (A,B,C,D)↦(A,D,B,C). Thus PP and WPW both yield
(A,C,D,B), PWP and WW both yield (C,B,D,A), and PWWP and WWPWW both
yield (B,A,D,C). Every constituent returns the clock and context. WWW
returns the payload as well. No unobserved residue is discarded.

*Termination and uniqueness.* Every replacement strictly lowers the
nonnegative integer cost. Hence every sequence of replacements terminates.
An irreducible word has no W run of length three. If it had two P letters,
take consecutive P letters: the intervening W run has length zero, one
or two, giving one of the other three reducible patterns. Consequently
the irreducibles are exactly

    I, W, WW, and W^i P W^j for 0≤i,j≤2.

VC100p supplies twelve distinct complete actions for these twelve words,
when the payload domain has at least two values. Every replacement preserves
the action, so any two terminating reductions of the same word must reach
the same irreducible word. This establishes uniqueness independently of
which available replacement is chosen first; no priority policy or
enumeration of overlapping replacements is required. Equivalently the
formal four-label actions separate the normal words, even when a particular
payload tuple happens to contain repeated values.

VC100p also proves that each normal word has minimum cost among all fixed
forward primitive words with the same complete action. Thus reducing a
basis word reaches a primitive-optimal realization of its action. The
largest resulting execution cost is eleven. This does **not** bound the
cost of reading or reducing an arbitrarily long input word: each step
decreases cost by at least three, giving only the separate elementary
bound of floor(initial cost/3) replacements. It is not a complexity bound
for finding a reducible occurrence or for the compiler.

*Replacement in context.* Let F and G be the two actual applications being
substituted, with F.Left=G.Left and F.Right=G.Right. If an actual prefix
ends at F.Left and a suffix starts at F.Right, the same two seams also
admit G. The two complete composites then have the same input and output.
This argument requires neither the entire intervening contact history nor
a new equality premise about the composite outputs. It does require that
the endpoints include every relation on which the continuation depends.
A logger or instrument responding to intermediate contacts changes that
question: PP and WPW already differ after their first macro contact.

`PhaseBasisReduction.swift` constructs all four longer paths at each clock
from the actual prior P and W applications, and derives their full input/output
equalities with the shorter paths. `EndpointSubstitution` constructs both
surrounding composites from the replacement's own endpoint equality and
the old seams; the new seams are consequences. The consumer checks all
clock clauses, a nonidentity prefix and suffix, and rejects erasing the
remaining WW action or inferring equal intermediate readings. The termination,
uniqueness and cost arguments are the proofs above; the types do not
pretend to execute a normalization algorithm or certify a cost by naming it.

This closes the normalization problem for the supplied interface. Its
next application problem is different: when W and P are unknown contacts,
which acquired relations justify these same replacements? Passing a local
return observation alone must not be substituted for their full applicability.


### §6zzk. Six return equations and the cost of complete calibration

VC99 fixes a particular phase construction. The next question ranges over all
realizations of the same four reversible stage contacts. Write the five stages
as ★,0,1,2,3. Let E:K→V be onto, and let A_i be total involutions satisfying
E∘A_i=t_i∘E, where t_i exchanges ★ and i. A returning word below acts identically
on **every** stage, not just on one preparation. Products are in performed order.

**VC101 (a finite criterion for complete endpoint calibration).** The complete
final stage permutation determines the full action of every contact word on K
if and only if these six words act identically on K:

    (A₀A₁)³, (A₁A₂)³, (A₁A₃)³,
    (A₁A₂A₁A₀)², (A₂A₃A₂A₀)², (A₂A₃A₂A₁)².

These are six equations on full actions, not necessarily six point
measurements. They comprise three words of length six and three of length
eight. Their stage actions are identity: a pair of different spokes has
product order three, and t_i t_j t_i exchanges leaves i,j while fixing ★,
so it commutes with a third spoke t_k.

*Proof.* The actual group G generated by the A_i has an onto homomorphism
p:G→S₅ supplied by E. The stage action is well-defined because E is onto.
Complete calibration is precisely ker p={1}, which makes the six identities
necessary. For sufficiency, put

    s₁=A₀, s₂=A₁, s₃=A₁A₂A₁, s₄=A₂A₃A₂.

Their stage edges form the path 0–★–1–2–3. Each s is an involution. The three
neighbor products are A₀A₁, A₂A₁, and A₂(A₁A₃)A₂; the last equality uses
the A₁/A₂ braid already supplied by the second pair return. Their cubes are
identity. The three length-eight returns state exactly the commutation of
s₁/s₃, s₁/s₄, and s₂/s₄. These generators recover A₂=s₂s₃s₂ and
A₃=A₂s₄A₂, so they generate G.

For completeness, the adjacent-swap relations bound this group by 5!, without
a classification of its possible realizations. In rank n−1 let H be generated
by s₁,…,s_(n−2), and put d_n=1 and d_j=s_(n−1)…s_j for j<n. The union of
the n sets H d_j is closed under right multiplication by each s_i. Indeed,
d_j s_i is s_i d_j if i<j−1, d_(j−1) if i=j−1, d_(j+1) if i=j, and
s_(i−1)d_j if i>j. The last identity uses one braid and distant commutations.
For d_n the assertion is immediate. All displayed left factors belong to H.
Induction therefore gives at most n! elements. Here |G|≤120, while the onto
stage map already has 120 images. Hence p is an isomorphism. ∎

**VC101a (none of these six equations follows from the other five).** This
independence concerns total involutive lifts with an onto stage reading. It
does not additionally impose the twenty-state selected orbit of VC102.

Use a product carrier V×P, read its first field, and put
A_i(v,p)=(t_i(v),τ_i(p)). Each τ_i below is an involution. Write P01, P12,
P13 for the three cubic returns and T120, T230, T231 for the three squared
returns in their displayed order. The following assignments violate exactly
the indicated equation:

| Omitted equation | Phase set and exchanges | (τ₀,τ₁,τ₂,τ₃) |
|---|---|---|
| P01 | two phases, exchange x | (x,1,1,1) |
| P12 | two phases, exchange x | (1,1,x,1) |
| P13 | two phases, exchange x | (1,1,1,x) |
| T120 | four phases; x=(01), y=(02), z=(03) | (x,x,y,z) |
| T230 | three phases; x=(01), y=(02), z=(12) | (z,x,y,z) |
| T231 | the same three phases | (z,x,y,x) |

*Verification.* In each two-phase row, the selected cubic return is x and
the other two are identity. Every squared word is identity because all phase
actions belong to {1,x}. In the fourth row put X=τ₁τ₂τ₁=(12) and
Y=τ₂τ₃τ₂=(23). The required pair products have order one or three. Y
commutes with τ₀=τ₁=(01), whereas X does not commute with τ₀. Thus only
T120 fails. In the fifth row X=z and Y=x: X commutes with τ₀=z, Y with
τ₁=x, but Y does not commute with τ₀. In the last row X=Y=z, so only
the demanded commutation with τ₁=x fails. All three required pair products
again have order one or three. The failed squared words move phase 0 to 2,
1, and 2 respectively, providing an actual separator. All their stage
actions remain identity. ∎

This makes the chosen basis irredundant. It does not minimize the number of
arbitrary possible measurements, and these small product witnesses do not
establish independence after adding a capacity or selected-orbit condition.

**VC101b (the involution premise cannot be replaced by reversibility).**
On V×Z₄ let R advance the four phases and set
A_i=(t_i,R^(e_i)) with (e₀,e₁,e₂,e₃)=(-1,1,-1,-1).
Every contact is a permutation. The three cubic-return phase exponents are
zero; the three unsquared triple-word exponents are 0,-4,-2. Squaring them
gives zero modulo four. Thus all six equations of VC101 hold. Yet A_i²
advances phase by two and is not identity, despite its identity stage action.

The same twenty-state model even admits a selected twenty-cycle with the
canonical stage word. From center phase zero perform

    0,2,2,2,0; 1,0,0,0,1; 2,0,0,0,2; 3,0,0,0,3.

The center phases are 0,3,2,1 and then 0 again. The four leaf blocks have
phases (3,2,1,0), (0,3,2,1), (1,0,3,2), (0,3,2,1), respectively.
These twenty sources exhaust the five-by-four carrier. Thus the U trace
does not repair the missing involution relation either. Here consecutive
equal contact labels can change phase, instead of cancelling as required
by the later simple-path arguments.

`FourSlotTurn` derives the two opposite turns from actual adjacent exchanges.
`QuarterClockSixReturns` composes precisely the six phase words above, with
their intermediate sources, and derives all six identities for arbitrary
four labels. `QuarterClockDoubleContact` couples the actual stage exchange
to the turn and derives its squared action. The check retains the stage
return while refusing the proposed full involution on four distinct labels.

Consequently, for arbitrary total contact maps the finite criterion consists
of the four equations A_i²=1 together with VC101's six returns. The first
four equations already derive invertibility. In contrast, if complete
endpoint calibration is itself given as equality of full word actions
whenever their stage permutations agree, then A_i²=1 follows by comparison
with the empty word. It need not be an additional assumption under that
stronger premise. These are two different ways of presenting the same
calibration question, with different obligations still to be established.

**VC102 (complete calibration costs at least thirty control states).** In
addition, let a function U select an available contact at every state:
U(k)=A_i(k) for some i. If a U-trajectory visits at least eighteen different states
and the six identities of VC101 hold, then |K|≥30. Thirty states attain this
bound with the same twenty-step stage word as the canonical four-phase star.

*Lower bound.* Under VC101, G≅S₅. Its orbit O containing the selected trajectory
has at least eighteen states. If |K|<30, a stabilizer H of a state over ★ would
have 4<|H|<7, since |O|=120/|H|. It is a subgroup of the S₄ fixing ★. Its
order divides 24, so |H|=6 and |O|=20.

On the four leaves, an H-orbit has size dividing six. If H fixed no leaf, the
only possible orbit decomposition would be 2+2. That would embed H faithfully
in S₂×S₂, of order four, which is impossible. Thus H fixes a further leaf w.
It equals the order-six stabilizer of the pair (★,w). The resulting action
on O is consequently the action on ordered pairs (v,w), v≠w, with
A_i(v,w)=(t_i(v),t_i(w)) and E(v,w)=v.

Write C_j=(★,j), D_i=(i,★), and P_ij=(i,j) for distinct leaves i,j. Each P_ij
has just two non-fixed contact neighbors, C_j and D_i. No two P states are
adjacent. A simple contact path contains at most eight C/D states and at most
nine P states between or beside them: at most seventeen states. A deterministic
trajectory cannot encounter a repeated state and later discover a new one,
so eighteen visited states would supply a forbidden simple path. This proves
|K|≥30. In particular, below thirty states at least one of the six specified
return words changes a full state. Reversibility of U was not required. ∎

The stronger exploration condition matters. With twenty ordered-pair states,
choose a cyclic successor n on the four leaves and the twelve-cycle
C_w→P_(n(w),w)→D_(n(w))→C_(n(w)). Its steps are A_(n(w)), A_w, A_(n(w)).
Fix every other state using a contact whose index differs from both of its
leaf coordinates. This is a total selected permutation visiting all five
stages and satisfying VC95a at its minimum size. It has no hidden returning
action. Thus minimum size plus exploration of all **stages** does not already
give VC102's obstruction.

*Attaining thirty with complete calibration.* Let
H={1,(01)(23),(02)(13),(03)(12)} inside the S₄ fixing ★. Take the thirty
right cosets H g in S₅, with E(H g)=★g and A_i given by right multiplication
by t_i. A stage-identity word is the identity permutation and fixes every coset.

Choose the section t_v=(★ v), t_★=1, and write a state as H h t_v with h
fixing ★. The six possible H h form S₄/H≅S₃, through the action on the three
pairings of four leaves. Denote its three transpositions by
a=[(01)]=[(23)], b=[(02)]=[(13)], c=[(03)]=[(12)], and put p=ab, q=ba.
At ★ or leaf i, A_i exchanges the stage and leaves the phase unchanged.
At another leaf j, it fixes the stage and right-multiplies the phase by [(i j)].
This follows from the chosen section, rather than a separate phase rule.

Starting at (★,e), use the contacts

    0,2,3,2,0; 1,0,2,0,1; 2,0,1,0,2; 3,1,2,1,3.

Their twenty source states, followed by return to the initial state, are:

| Stage | Phases in order |
|---|---|
| ★ | e |
| 0 | e,b,p,a |
| ★ | a |
| 1 | a,e,c,p |
| ★ | p |
| 2 | p,a,q,c |
| ★ | c |
| 3 | c,q,b,e |

All twenty are distinct. Complete U on the other ten states by the exchanges
(★,b)↔(1,b) and (★,q)↔(1,q) through A₁; (0,c)↔(0,q) through A₂;
(2,e)↔(2,b) through A₀; and (3,a)↔(3,p) through A₁. These five disjoint
two-cycles and the twenty-cycle cover K. Every U-step remains an actual contact.

`ThreeSlotContacts` derives a,b,c as exchanges of an arbitrary three-slot
source. Their six preparations are e=ABC, a=BAC, b=CBA, c=ACB, p=CAB, q=BCA.
`FaithfulFourLeafRows` presents all five source rows of each contact using the
existing stage exchanges and those phase readings. `FaithfulFourLeafCycle`
composes the twenty actual rows; `FaithfulFourLeafRemainder` constructs the five
other cycles. `FaithfulFourLeafWhole.SourceCoverage` equates their thirty
sources with the complete five-by-six declared domain. The group and capacity
arguments above are mathematical proofs; the static witness checks this
construction and its actual intermediate sources, not every possible group.

### §6zzl. The finite evidence and the size of a relevant distinction

**VC103 (twenty profiles from twenty-three readings).** Suppose one autonomous
selected U supplies this prefix of stage readings:

    ★,0,0,0,0,★,1,1,1,1,★,2,2,2,2,★,3,3,3,3,★,0,0.

Its twenty consecutive four-reading windows are distinct, by the argument of
VC97. Equal source states would have equal future windows. Thus the first
twenty source states are distinct, using finite readings rather than assuming
an infinite observed period. With fewer than thirty control states and the
four full lift relations, VC102 forces a nonidentity among the six return words.
At capacity twenty, the first twenty states exhaust the carrier. State twenty
reads ★ and its successor reads 0. Among the four earlier ★ states only state
zero has that successor reading; hence state twenty is state zero. Thus U is
a twenty-cycle on this carrier, without having assumed that U was invertible.
The same four-reading windows then expose any changed state within at most
three further U-advances. This is a bounded witness, not a free supply of trials,
preparations, instruments or a primitive instruction interpreter.

The capacity condition can concern the distinctions relevant to these contacts
without declaring the entire world finite. For an arbitrary K, identify two
states exactly when every finite continuation from {A₀,A₁,A₂,A₃,U} yields the
same E answer. This relation is a congruence for the admitted continuations.
Let Q be its quotient. U descends to a function and the A_i to involutions;
the five-stage reading remains onto. No surjectivity of U is required.

The twenty different windows force twenty different classes of Q. Applying
VC101–102 to Q gives the following alternative: there are at least thirty
distinct continuation profiles, **or** one of the six short returning words
changes a profile and can be distinguished by an admitted later reading.
With exactly twenty profiles, at most three further U-advances suffice. The
cardinality of K outside those relevant distinctions need not be bounded.

The two constructions make the resource premise concrete. The canonical
twenty-state star and the faithful thirty-state construction give the same
displayed stage sequence forever from their indicated starts. Yet the latter
has no hidden returning action. That single sequence cannot establish the
missing upper capacity bound or distinguish the two complete contact laws.

There is also a difference between allowed continuations. Fixed words using
only the A_i cannot separate two states with the same E: their common stage
permutation gives the same answer after both. The source-dependent selection
U can separate them. The additional distinction is therefore exposed by an
actual selection relation, not by declaring an invisible phase observable.

**VC103a (five readings already force a capacity or return obstruction).**
Under the same total involutive lift and selected autonomous U relations,
the shorter observed prefix

    0,0,0,0,★

already forces this alternative: at least thirty continuation profiles, or
one of VC101's six returning words changes a profile.

*Proof.* The four states reading 0 are distinct. A repetition among them,
followed by the same autonomous U, would make the final ★ occur earlier in
the displayed block, contradicting its readings. They lie in one contact
orbit. Its fibers over the five stages have equal size, so that orbit has
at least twenty states. If fewer than thirty profiles exist and all six
returns are identity, VC101 and the stabilizer argument of VC102 identify
the orbit with the twenty ordered pairs. Within leaf i its four states are
D_i and the three P_ij. Their non-fixed internal contacts form a three-armed
star centered at D_i. No simple path in this star contains four vertices.
The observed residence followed by exit supplies exactly that forbidden path. ∎

The exit is essential: four equal readings without an exit need not come
from four states. This shorter prefix does not establish the twenty-cycle
or the four-reading decoder used above. If the continuation quotient has
n finite profiles, every distinct pair is separated by some admitted word
of length at most n−5. Indeed, equality of readings for words of length at
most t defines a partition starting with five stage classes. Until the
partition is discrete, each refinement must split a class; a refinement that
does not split would already be stable under every generator and contradict
the definition of the continuation quotient. There are at most n−5 strict
refinements. Here, below thirty, equal-sized stage fibers and the four-state
residence imply n=20 or25, so at most twenty further contacts suffice for
an existing separator. Its existence does not itself supply a comparison
preparation or the acquired table needed to select it.

In particular, all thirty states of the faithful construction have different
continuation profiles. Its five-reading residence occurs and all six returns
are identity. A quotient with fewer than thirty profiles would contradict
VC103a, while the original carrier has only thirty states. Thus the extra ten
states outside the displayed cycle are relevant to the full contact scope,
even though U alone leaves some of their histories indistinguishable.

### §6zzm. Acquiring a window and restoring the target

The canonical twenty-profile example now presents the selected U at all five
stages, rather than only at the center. `FourLeafControl` reads the current
phase and carried address program; it does not supply the stage to that
selector. The chosen application still uses the actual full source root.
Four consecutive selected contacts rotate five arbitrary stage labels, and
five such rounds return them. `FourLeafControlOrbit.SourceCoverage` identifies
the twenty actual sources with the independently declared five-by-four
preparation family. Its twenty rows use the same selector.

`AcquiredFourFirstFields<A,B,C>` records four actual first-field readings
separated by the three supplied transitions. Its seven resident commands retain
the current target, all four facts, and the consumed instruction history.
The decoder receives the four records and fixed projection expressions.
The independently constructed direct question reads the same four stages
from the source and its actual successive images. Their equality follows
through the intermediate application seams.

Two neighboring leaf-zero preparations have the same first three facts and
the same seven-command tape, but their fourth facts differ: leaf zero versus
center. Thus the fourth reading contributes an actual distinguishing answer;
a private phase parameter in the decoder or a different program does not
supply the distinction. The three-reading compression and a substituted
third-transition source are refused in `Checks/FourReadingAcquisition.swift`.

Restoration must likewise specify what returns. `FourLeafEcho` performs one
U step, records its stage, and performs the nineteen remaining U steps. It then
performs Z=(A₀A₂)³, repeats the same observation-and-return instruction, and
performs Z again. These are fifty-two primitive contacts and two stage
acquisitions. The target returns to its initial preparation; the retained
records read different leaves, zero and one, and the command history remains.

From this actual final root, the first old record still answers the question
about the next U stage. The second old record does not. Both records remain
truthful about their acquisitions. `Checks/FourLeafEcho.swift` derives the
first reuse and refuses the second, an observation applied to the wrong
source, and the proposed equality of the whole final and initial experiment.
The target's return therefore supports a particular renewed use of old
evidence while preserving the distinctions acquired by the enclosing experiment.

### §6zzn. A residence obstruction without an upper capacity bound

**VC104 (twenty-five equal readings followed by exit).** Retain the onto
five-stage reading, the four total involutive lifts, and the autonomous
selection relation U(k)=A_i(k). If a U-trajectory supplies twenty-five
consecutive readings of one leaf followed by a different stage, then one
of VC101's six returning words changes a continuation profile in the contact
orbit of that preparation. No upper bound on K or its continuation quotient
is required.

*Proof.* Pass to the continuation quotient Q defined in §6zzl. The twenty-five
leaf profiles are distinct: any repetition before the exit would cause the
same exit earlier, because U is a function. All belong to one contact orbit O.
If the six words fixed every profile of O, VC101 would make its contact action
S₅. Fix one profile q over this leaf. Each other profile in the same leaf
fiber has the form gq with g fixing the leaf, since E is equivariant.
That stage stabilizer has only 4!=24 elements, so the fiber contains at most
twenty-four profiles. This contradicts the observed twenty-five. Consequently
one of the six words changes a profile of O; by the definition of Q a finite
admitted continuation distinguishes the change. ∎

Unreachable copies of a carrier, including infinitely many copies, cannot
increase a single orbit of this completely calibrated action. The result uses
twenty-six readings as a sufficient witness. VC105 below makes this threshold
exact within the family of uninterrupted leaf-residence tests. VC104a gives
a bounded, potentially longer returning word with a later stage separator;
it does not identify which of the six short equations fails at which source.

The premise has a finite reversible realization. Let K=V×{0,…,24},
E(v,p)=v, and A_i=(t_i,τ_i), where τ₀=τ₃=1 and

    τ₁=(0 1)(2 3)…(22 23), fixing 24,
    τ₂=(1 2)(3 4)…(23 24), fixing 0.

Use a selected fifty-two-cycle through leaf zero at phases 0,…,24, then
center at phase 24, then leaf three at phases 24,…,0, then center at phase
zero and back to the start. On the ascending leaf use A₁ at even phases and
A₂ at odd phases; on the descending leaf use A₂ at positive even phases and
A₁ at odd phases. The two exits and entries use A₀ and A₃.

Complete U by the twenty-three exchanges
(★,p)↔(1,τ₁(p)) through A₁ for 1≤p≤23. Fix leaf-one phases 1 and 24,
and all twenty-five leaf-two states, using A₀. These disjoint cycles cover
all 125 states. Thus U is a permutation made entirely of actual contacts.
The return (A₀A₁)³ acts identically on stages and as τ₁ on phase. At leaf-zero
phase zero it moves to phase one. After twenty-four further U steps the first
preparation still reads leaf zero, while the changed preparation reads center.
The specified return therefore has an actual later observable effect.

The residence already requires twenty-five states in one stage fiber.
Contact bijections give equally large fibers at the other four stages,
so every such lift realization has at least 125 states. This construction
attains that lower bound. The same argument applies to continuation profiles:
the twenty-five leaf-zero phases have different exit delays, and invertible
contacts carry their distinctions to every stage. All 125 states therefore
remain distinct in the admitted continuation quotient.

`AlternatingPhaseLine` presents the finite matching edges and their fixed
endpoints. `AlternatingLineTravel` composes the actual ascent, descent, exits
and entries. The remainder exchanges and fixed points supply the other rows;
`AlternatingLineWhole.SourceCoverage` equates their actual sources with the
independently declared five-by-twenty-five preparation family.
`AlternatingLineDelayedWitness` derives the six-contact return and the two
different readings after twenty-four more selected contacts. These static
constructions establish the displayed realization; the orbit argument above
establishes the restriction on all realizations of the stated relations.

Two assumptions still carry indispensable content. If U is a relation allowing
any available next contact, the bare five-stage carrier permits arbitrarily
many repeated leaf-zero readings through A₁ followed by an exit through A₀.
All six equations then hold. A single autonomous source function is needed.

Even with a function, equality only after E is insufficient. On V×Z₂₅ take
A_i=(t_i,1) and define U(v,p)=(t₁(v),p+1) for p<24 and
U(v,24)=(t₀(v),0). This U is reversible: the output phase identifies the
preceding phase and the inverse stage exchange. It supplies the same long
residence and exit, while every A_i satisfies complete calibration.
Its displayed stage step agrees with an available contact, but its complete
step also changes the internal counter. Thus U(k)≠A_i(k).
This fully internal countermodel shows why the actual selection relation must
include the question-relevant update, rather than only its displayed endpoint.
`Checks/AlternatingLine.swift` exhibits the corresponding static boundary:
the same source and same stage answer admit different full contact answers.


**VC104a (a bounded return inside the observed passage).** Under VC104's
relations and readings there are indices 0≤i<j≤24 and a contact word B
such that:

* B acts identically on every stage and has even length 6≤j−i≤24;
* B takes the actually visited preparation U^i(q₀) to U^j(q₀);
* after k=25−j further U steps, these two preparations read different stages;
* i≤18 and k≤19.

*Proof.* For each of the first twenty-four U steps choose its actual contact
label. All lie in {1,2,3}, since contact zero would exit leaf zero. Their
twenty-five prefix stage permutations fix that leaf and thus belong to its
twenty-four-element stabilizer. Two prefixes p_i,p_j coincide. Cancellation
of the stage permutations makes the intervening word B stage identity.
Its actual action takes q_i to q_j. After k=25−j U steps, q_j reaches the
observed center, whereas q_i remains inside the observed leaf block.

No two consecutive labels in this passage coincide: full involutivity would
repeat a state before the observed exit. A nonempty reduced identity in
star transpositions has even length at least six, as in VC99's lower-bound
argument. Therefore j−i≥6, i≤18, and k≤19. ∎

The initial collision argument uses only total deterministic lifts and actual
selection; full involutivity strengthens the length bounds and connects the
result to VC101's six equations. The proof does not assign the chosen labels
to the visible stage records. If an actual contact-address trace is acquired,
the equal prefixes and B can be read from that trace. Stage records alone
give a finite existence bound, not those addresses or a free reset for trials.
The two compared paths from q₀ have lengths 25 and 25−(j−i). Reaching the
comparison preparation again after acquisition is a further application
question; retaining the actual addresses supplies an inverse route when the
contacts are involutions.

### §6zzo. Exact residence costs under complete calibration

**VC105 (the full residence and capacity boundary).** Assume complete
endpoint calibration as in VC101 and an autonomous U selecting actual
contacts. For an observation consisting of m consecutive readings of a
fixed leaf followed by exit, the minimum number of states is:

| Residence m | Minimum carrier size |
|---|---:|
| 1 | 5 |
| 2 | 10 |
| 3 | 15 |
| 4–6 | 30 |
| 7–8 | 40 |
| 9–12 | 60 |
| 13–24 | 120 |
| 25 or more | no completely calibrated realization |

Every finite entry is attained with U a permutation. The same minima hold
for the continuation quotient, so they count relevant distinctions rather
than inaccessible extra labels. No finite bound on an enclosing world is
part of the question.

Here total deterministic contact maps and their lift equations suffice as
initial contact assumptions: full calibration derives their involutions by
VC101b. A displayed preparation and total lifts of the transitive stage
contacts also make E onto. Neither fact needs a second independent premise
for this residence question.

*Lower bound.* The trajectory remains in one orbit O of the completely
calibrated S₅ action. Its m leaf states are distinct and form a simple path
using the three contacts that fix that leaf. For a stabilizer H≤S₄,
|O|=120/|H| and its leaf fiber has 24/|H| states. The possible subgroup
orders divide 24, giving fiber sizes 1,2,3,4,6,8,12,24.
At fiber size four, H has order six and fixes a further symbol by VC102's
argument. The internal fiber graph is the four-vertex star, whose longest
simple path has three vertices. Thus this cardinality cannot support m=4.
All remaining lower bounds in the table follow already from fiber size. ∎

*Paths attaining the bounds.* Use the coset action H\\S₅ with H fixing the
observed leaf zero. In its leaf-zero fiber H\\S₄, the available internal
contacts a,b,c exchange the remaining marked center with leaves 1,2,3.
The following choices of H supply paths through all their fiber states:

| H in S₄ | Fiber | Actual path structure |
|---|---:|---|
| S₄ | 1 | one preparation, then exit |
| A₄ | 2 | sign changes under any internal contact |
| stabilizer of a pairing, order 8 | 3 | the three pairings; the contacts induce their three exchanges |
| the four-element group of double exchanges | 6 | regular S₃; alternate two different exchanges for five steps |
| even permutations fixing a symbol, order 3 | 8 | the marked-symbol/parity path below |
| stabilizer of an ordered distinct pair, order 2 | 12 | the ordered-pair cycle below |
| {1} | 24 | the displayed regular S₄ path below |

For the eight-state fiber use a marked symbol together with parity. A contact
exchanges its marked center/leaf and flips parity. Write O± and L_i± for
these internal marks, all still at the same observed physical leaf. The path

    L₁+,L₁−,O+,L₂−,L₂+,O−,L₃+,L₃−

uses contact labels 2,1,2,1,2,3,1 and visits all eight states.
For the twelve-state fiber use ordered distinct pairs of four symbols.
With C_i=(★,i), D_i=(i,★), P_ij=(i,j), the cycle

    C₁,P₂₁,D₂,P₂₃,C₃,P₁₃,D₁,P₁₂,C₂,P₃₂,D₃,P₃₁,C₁

uses labels 2,1,3 repeated four times. A twelve-state path is obtained by
omitting its final closing step.

For the regular twenty-four-state fiber, the contact word

    a b a b a, c, a b a b a, c, b a b a b, c, b a b a b

visits every permutation once. To check it, temporarily label the four
movable symbols ★,1,2,3 by digits 0,1,2,3; this digit zero is not the fixed
physical leaf. List inverse images, so right multiplication exchanges the
first slot with the slot named by a,b,c. Its consecutive states are:

    0123 1023 2013 0213 1203 2103
    3102 1302 0312 3012 1032 0132
    2130 3120 1320 2310 3210 1230
    0231 3201 2301 0321 3021 2031

Each row has one fixed last symbol and all six orders of the other three.
The four last symbols differ, and c joins successive rows. This verifies
both the actual contacts and the twenty-four distinct sources without an
enumeration program. A suffix supplies any shorter required residence.

*Reversible completion of any such path.* Let x₀,…,x_(m−1) be the chosen
simple path in leaf zero, and put b₀=A₀. Exit at its last state through b₀.
Return through the center states x_j b₀ in reverse order. For an original
edge y=x a, the three contacts a,b₀,a take y b₀ to x b₀, since
a b₀ a=b₀ a b₀ under complete calibration. Their intermediate states are
y b₀ a and x b₀ a, both at the leaf named by a and exchanged by b₀.

These intermediate states do not collide. For any fixed a, its edges in a
simple path have disjoint endpoints; consecutive equal labels would repeat
a vertex. The bijection b₀a preserves their disjointness. Different a have
different stage readings, and none of these stages is zero or center.
The forward path, exit, reverse passages, and final b₀ form a simple cycle
of 4m−2 states. Its used set is invariant under b₀: the original and center
states are paired, as are the two intermediates for each edge. Set U=b₀ on
the complement. This is a total selected permutation on the same carrier,
completing all upper bounds. At m=24 it is a ninety-four-cycle and thirteen
two-cycles on the regular 120-state carrier. ∎

Passing any minimal realization to its continuation quotient preserves the
observed residence, full contact calibration and selected U relation. The
lower bound applies there too, while a quotient cannot be larger than its
carrier. Hence all states of these minimal constructions have distinct
continuation profiles. In particular, twenty-four equal leaf readings and
exit are compatible with full calibration; twenty-five and exit are not.
This makes twenty-six readings optimal within this specific observation
family, while leaving other experiments and additional relations available.

The table identifies a constraint that a state count alone misses. A fiber
of four states admits fewer distinct consecutive visits than a raw count
would suggest, because its permitted contacts form a star. Full calibration
restricts both how many distinctions can remain and how those distinctions
can be traversed by an internal controller.

### §6zzp. An acquired choice can supply the inverse route

**VC106 (recovering through the actually selected contact).** Let A_i be
bijective contacts and let a(x) select the actual step U(x)=A_(a(x))(x).
Then the retained reading

    x ↦ (U(x),a(x))

is injective. Its source is recovered by (y,i)↦A_i⁻¹(y), using the same
contact family. If the contacts are involutions, applying the recorded
contact once more performs this recovery. The chooser need not identify y
in order to select that operation; the operation acts on the actual y.

*Proof.* Two equal retained outputs have the same i and A_i(x)=A_i(x′).
Invertibility gives x=x′. Applying A_i⁻¹ to an actual retained output gives
its original source. This reasoning does not require U itself to be injective.
Repeating U would use a(y), which need not equal the recorded a(x). ∎

With four contacts, four address values always suffice for this recovery
question. They are necessary in some realizations: on the five bare stages,
choose the corresponding contact at each leaf, sending all four leaves to
center, and choose contact zero at center. The four equal resulting centers
must retain four different residual values to recover their different leaf
sources. This is M35's fiber bound with an explicit inverse supplied by the
contact family. It does not require keeping a complete copy of the source.
For a weaker source question, VC85's conflict relation can permit a coarser
address record; the size of the whole source alone does not decide that cost.

The static construction now acquires the address before using it.

* `SelectedLocalApplication.RecordedPrimitive` applies the existing
  `RetainingRecordedReading` to its actual `Selection=SequentialReading<I,D>`,
  then performs `Primitive=S.Right` beside the acquired fact. The retained
  source is the source used by both selection and the primitive.
* `FourLeafSelectionRecords` presents four record normal forms with one
  common question and the four address answers. They contain no original
  stage or context parameter. `FourLeafRecordedReturn.AcquiredRecords`
  derives equality with the four actual producers for arbitrary stage
  labels and retained context K.
* `KeepSelectionInContext` moves the acquired fact into the current working
  source. `RecordedLocalChoiceInput` reads just that fact and the retained
  address program; `ReadLocalChoice` obtains the address from the fact.
  Selection from the new current root then supplies the actual contact.
  All four generic paths return the original target beside their own fact.

The recorded choice is retained by recovery, so this is a target return,
not erasure of the complete acquisition. These relations use the already
admitted recording construction; they do not infer an instrument from the
name of the fact or a source value supplied privately to the decoder.

`Checks/FourLeafRecordedReturn.swift` also changes the active catalogue
through an explicit internal exchange. Both candidate catalogues are already
present; the exchange retains the old catalogue and the acquired address.
The next application root is read from the actual current slot after that
exchange. Its contact zero now preserves phase while exchanging the same
stages. This changed contact is itself involutive, and the record still
selects precisely address zero. Nevertheless it does not undo the earlier
contact, which changed phase. The source-return equality is refused while
the current selection, retained record and old catalogue remain valid.

The result therefore distinguishes three different uses of knowledge:
recovering a source through an acquired contact address, repeating the
current autonomous policy, and using that address after replacing its
contact family. Only the first has the supplied inverse relation. This
provides the missing form of evidence for following an inverse address
trace in VC104a, without pretending that stage observations already contain
that trace or constructing a general instruction interpreter here.

**Two predecessors per output need not permit a binary address-only record.**
M35 minimizes an unrestricted residual encoding of the source. A recorder
that sees only the chosen address has a different interface. The distinction
can occur with one fully calibrated family of contacts, without law drift.

Let G be any finite simple graph with a nonempty edge set on r contact
labels. Give each edge an ordered presentation e=(i,j), retained as internal
context. Set K=V×Edges(G), V={★,1,…,r}, and A_l(v,e)=(t_l(v),e),
where t_l exchanges ★ and l. These contacts are involutions and their
full actions are determined by their complete stage permutations.
In the copy belonging to e=(i,j), define one selected U by:

| Source stage | Chosen contact | Result stage |
|---|---|---|
| i | i | ★ |
| j | j | ★ |
| ★ | i | i |
| k different from i,j | i | k |

The edge remains fixed throughout. The center output has exactly the two
predecessors i,j; output i has only the center predecessor; each other
nonendpoint leaf has only itself; j is not an output. Thus every full-output
fiber has at most two members.

Nevertheless, a retained symbol c(a(x)) that may depend only on the chosen
address must distinguish i from j for every edge. Different copies already
have different full outputs, so these are exactly the conflicts. By VC85,
the minimum alphabet is χ(G). For the complete graph on four labels it is
four, even though no output has more than two predecessors. This realizes
VC85's access constraint through actual reversible contact actions; it is
not another graph-colouring theorem or a numerical search.

If the recorder can also read the actual edge context, two symbols suffice:
record which endpoint supplied the selected address. The decoder shares
the retained edge and selects that endpoint's inverse contact. The same
choice restores the center and the fixed-leaf cases as well. One symbol
cannot separate the two center predecessors. The changed minimum follows
from the additional input relation, not from a different entropy convention.

`StarContactPredecessors` supplies the actual four contact rows into one
center and their four inverse rows, retaining arbitrary context.
`MergedStarAddressInput` derives the complete-input collision for one
witnessed edge when its two records are merged. Its check exhibits the
different required source readings and refuses their identification. These
are contact and collision witnesses; the total edge-dependent U and the
general conflict classification are given by the explicit construction above.

### §6zzq. What a finite passing experiment cannot establish

**VC107 (no unrestricted finite positive calibration test).** Suppose the
unknown source is accessed through its five-stage reading E, the four
involutive contacts A_i, and an autonomous selected U. The interface may also
report which contact U actually selected. No capacity bound or complete
contact definition is supplied. For every finite operation budget N there
are two finite realizations agreeing on every such experiment of length at
most N from their corresponding prepared sources, although only one is
completely calibrated. Every A_i and U can be an involution in both.

*Construction.* The reference is the five bare stages, A_i=t_i and U=t₀.
For the alternative put D=3(N+1), M=2D+1 and K=V×Z_M. Read E(v,p)=v,
prepare (v,0) for each stage v, and use

    A₀(v,p)=(t₀(v),p),       A₁(v,p)=(t₁(v),p),
    A₂(v,p)=(t₂(v),−p),      A₃(v,p)=(t₃(v),1−p),

with phase arithmetic modulo M. Each is a total involution with the required
exact stage action. Set U=A₁ at phase D and U=A₀ everywhere else. Both
choices preserve phase, so U is also a total involution. This is one fixed
internal selection rule, not a later change of law or an external clock.

After at most N operations from phase zero, the phase has an integer
representative z with |z|≤N. Inductively each operation keeps z, negates it,
or replaces it by 1−z. Since D>N and M−D>N, no such phase is D. Every
encountered U therefore selects A₀, exactly as in the reference. The stage
action of every specified A_i is also the same. Thus all acquired stage
readings and selected addresses agree. Adaptation based on those acquired
values chooses the same next contact in both realizations. Restoring one of
the supplied preparations (v,0) does not create a difference within this
budget either.

Yet R=(A₁A₃)³ returns every stage and sends phase zero to one. The performed
product A₂A₃ increments phase by one. Let H=(A₂A₃)^D. Its stage action is
identity because D is divisible by three. From (★,0), H reaches (★,D),
where U reads leaf one. From R(★,0), the same H reaches (★,D+1), where
U reads leaf zero. One of the six short return words thus changes a
continuation profile. The alternative, with only 5M states, is not
completely calibrated. ∎

In particular, an observation-only procedure cannot finitely accept the
reference as completely calibrated and remain sound over this unrestricted
class. Take N to be its stopping budget on the reference. The constructed
alternative yields the same acquired transcript and therefore the same
acceptance, while violating the asserted property. This obstruction uses
finite carriers throughout; no inaccessible infinite universe is needed.

The access restriction is substantive. An instrument reading another internal
relation, a certified bound on the relevant carrier, or a faithfully supplied
definition of the complete contacts changes the evidence. A static proof
from such a definition is not a finite experiment using only E and the
reported addresses. Conversely, naming an uninspected definition
does not add that stronger reading. VC107 identifies a missing relation in
the proposed positive certificate, while VC104 still supplies a finite
negative witness when its observed residence occurs.

**VC107a (the exact first distinguishing experiment in this family).** In
VC107's alternative let D≥3 be divisible by three and M=2D+1. With its
five supplied preparations (v,0), stage readings and selected-address reports
attached to performed U steps, the minimum distinguishing operation count
is exactly 2D.

*Proof.* The two phase reflections form the path

    0, 1, −1, 2, −2, …, D, −D       modulo 2D+1.

These are all M different phases. Negation joins k with −k and fixes zero;
the other reflection joins −k with k+1 and fixes −D. Thus phase D lies at
distance 2D−1 from the prepared phase zero. The remaining operations preserve
phase. Until U is performed at phase D, all U choices and all stage effects
agree with the reference. No experiment of at most 2D−1 operations can
include such a U, even with adaptive choices or repeated supplied preparations.

For sufficiency perform S=(A₃A₂)^(D−1)A₃ from prepared leaf two. It has
length 2D−1 and reaches phase D. Since D is divisible by three, its stage
action is (t₃t₂)²t₃=t₂. It therefore reaches center. The following U reads
leaf zero in the reference and leaf one in the alternative. This distinguishes
them at operation 2D, using stage readings alone. ∎

The phase path uses the same two alternating matchings as the finite
`AlternatingPhaseLine` witness. The internal switching condition, not an outside clock,
places the difference at this distance. For D=3·2^k the binary parameter D
has k+2 bits while the experiment requires 6·2^k contacts. The proof remains
one parametric argument; it does not execute those contacts or enumerate their
carrier. This separates a supplied structural proof from observation through
the stated instrument. It is not a measured complexity claim about the
compiler. Access to the actual defining relations is the additional evidence
that makes that proof applicable.

### §6zzr. A supplied bound makes positive calibration finite

**VC108 (complete finite test on a bounded continuation scope).** Retain
VC101's onto five-stage reading and total stage lifts A₀,…,A₃, without yet
assuming that their source actions are involutions. Let an autonomous U
select one actual A_i at each source. Prepare q₀ over center. Let Q be the quotient
of its contact orbit by equality of all future E answers under {A_i,U}.
Suppose an independently established bound |Q|≤n is supplied, with n≥5.
Then complete endpoint calibration on Q is equivalent to the following
finite family of equalities:

    E(s(h(q₀))) = E(s(R(h(q₀))))

for every contact word h of length at most n−4, every continuation s in
{A_i,U} of length at most n−5, and each R in this ten-word family: the four
squares A_iA_i and VC101's six return words. If the A_i are already known
to induce involutions on Q, the four square tests can be omitted.
Each modified trial uses at most 2n−1 primitive operations from q₀.
This is a sufficient test horizon, not a claim of minimum trial length or
minimum number of queries. The claim concerns this reachable continuation
scope; it does not certify unrelated orbits or equality of hidden sources.

*Proof.* Equality of all future readings is a congruence for each admitted
operation. The A_i therefore descend as total maps to Q. A U step is one
of their edges, so adding U does not enlarge the contact orbit. The first
contact layer from q₀ contains its four leaf neighbors, all with different
E answers from one another and from q₀. Thus five profiles are reached at
depth one. Each further nonempty breadth layer contains at least one new
profile; an empty layer closes the orbit. Every profile is consequently
reached by a contact word of length at most |Q|−4≤n−4.

Partition Q first by E, obtaining five nonempty classes. At each refinement
compare both the current class and successor classes under every admitted
operation. After k refinements, equality means agreement on all E readings
after words of length at most k. If a step adds no class, the partition is
already a congruence and no later refinement can split it. Each strict step
adds at least one class. Because distinct members of Q have a distinguishing
continuation by definition, at most |Q|−5≤n−5 strict steps make the partition
discrete. Any two different profiles therefore separate within that horizon.

Assume the displayed tests pass. For any q∈Q choose a permitted h reaching
it. Agreement for every tested s forces R(q)=q by bounded separation. Thus
all ten words act identically on every profile. The four squares make the
induced A_i involutions; VC101's remaining six give complete endpoint
calibration. Conversely that calibration makes every displayed
equality hold. The longest return word has eight contacts, so the modified
trial length is at most (n−4)+8+(n−5)=2n−1. ∎

The unmodified comparison uses at most 2n−9 operations. These bounds count
target operations, not the cost of reading, recording, selecting experiments
or returning the target for another trial. Enumerating all words within the
two bounds is finite but can require exponentially many trials. An already
acquired presentation of preparations and separating continuations may
replace that enumeration; its coverage then becomes the supplied relation.

**Returning without erasing the experiment.** Repeated preparation need not
mean an unexplained reset. Suppose the experiment can acquire the actual
chosen address of every U step, and the same A_i involutions remain
applicable throughout. Commanded A_i addresses are already specified.
After reading a trial's answer, apply its recorded contacts in reverse
order. VC106 gives a return of the actual target to its preparation, while
the record and controller retain what happened. Applying U backwards is
unnecessary, and applying U again would in general choose another contact.

This construction uses a finite prepared recording and control arrangement;
it does not infer such an instrument from a list of observations. The
return argument also uses the involution relation it was given. It cannot
silently be used to test that same relation from scratch. Testing all ten
equations of VC101b would require an independently justified return or
preparation arrangement. Replacing the contact catalogue between a step
and its proposed inverse fails exactly as the internal exchange in VC106.

For these repeated E questions, an actual whole-source return is stronger
than necessary. If the induced A_i on Q are known involutions, reversing
the acquired address word restores the same profile. The instruments must
preserve that profile or provide their own justified restoration; a passing
prefix alone does not establish this. Questions about the complete returned
history can still differ.

For example, enlarge any model of the original involutions to K×I*, where
I* is the set of finite words of contact indices, and set

    A_i′(x,h)=(A_i(x),h appended i),
    U′(x,h)=(U(x),h appended a(x)),       U(x)=A_(a(x))(x).

Read only the original E(x). Projection to K intertwines every admitted
target continuation, and every old distinguishing word still distinguishes.
The new continuation quotient is therefore exactly the old Q. The enlarged
contacts are injective and retain their sources, but no nonempty word returns
the full history. Replaying reversed addresses restores x while appending
the return occurrences too. This is a retaining realization on a supplied
history carrier, not an inference of freely available physical storage.
Adding a contact that uses this history may split the quotient; the stated
bound concerns the original target questions and operation vocabulary.

**The bound need not count the hidden carrier.** VC12 already supplies a
structural way to establish the required bound. Suppose a reading F of
the actual source has at most n images, E=e∘F, and every admitted operation
T has a supplied image operation T̄ satisfying F∘T=T̄∘F on the entire
reachable scope. Induction shows that equal F images have every future E
answer equal. Hence F refines Q and |Q|≤|F(K)|≤n, even for an infinite K.
F need not itself be the coarsest such reading. These are the existing
commuting relations, not a new label declaring a representation complete.

Checking all ten returning words as identities on F is sufficient for their
identity on Q; the four squares can again be omitted if the induced
involutions are already known. A failed identity on F, however, need not
fail on Q: F may retain additional distinctions. For example, use the
first two-phase assignment of VC101a and take U=A₀ always. The phase makes
one cubic return nonidentity on the ten-element stage/phase image. Yet E
alone is already closed under every A_i and this fixed U. There are just
five continuation profiles and calibration on those profiles holds. An E
separator is required before turning that richer-image failure into a
failure of the stated future question.

The bounded experiments above test Q directly. Their evidence differs from
that of a faithful definition with generic commuting proofs: the latter can
provide the bound structurally, while finite E samples alone do not establish
those universal equations. VC107 excludes obtaining the missing bound
by extending a passing prefix. Together the results distinguish finite
falsification, finite testing under a justified bound, and static proof from
a supplied presentation.

There is a tempting circular shortcut. Complete calibration makes this
contact orbit an S₅ orbit, so a calibrated Q has at most 120 members.
It does not follow that an unknown candidate may be tested with n=120.
That bound excludes some of the very alternatives under investigation and
must hold for the actual candidate independently of the conclusion. VC107's
uncalibrated alternatives can pass an arbitrarily long finite prefix.
The six short algebraic equations form a finite presentation of the law;
they are not six finite observations certifying their own universal scope.
A short returning word can have an arbitrarily delayed observable effect.

`FourLeafProfileScope.swift` supplies the last route for the existing
twenty-profile model. `LocalStagePhaseImage` is built from the actual stage
and phase projections. `FourLeafPrimitiveProfiles` derives equality of all
four subsequent images across arbitrary contexts K,L and arbitrary symbolic
phase labels. `FourLeafControlProfiles` derives the same equality for the
four admitted one-hot selection clauses, including their selected
addresses. Both clauses carry the same resident program. With one-hot stage
and phase preparations, the image has at most 5×4 members; the earlier
source coverage and distinguishing readings give all twenty. The arbitrary
retained context is not counted as twenty states or assumed finite.

The context need not remain fixed. `LocalContextExchange` exchanges two
fields behind the retained program and derives the same image. Its use
can be interleaved with the admitted contacts. In contrast, the separate
reserve contact in `Checks/FourLeafProfileScope.swift` exchanges the active
phase with a reserved one. It is itself an involution, retains both fields
and the program, and has a reading constructed from their actual addresses.
Two sources with the same old image then reach different active phases.
Their next U applications use the actual exchanged roots and expose
different stages. The proposed equality is refused. This is a change of
the admitted contact scope, not a failure of the original generic proof or
evidence that the unchanged context was absent from the whole.

### §6zzs. The residence argument depends on the observed action, not the star

**VC109 (a finite observed action forces an aliased pair of paths).** Let
E:K→V be an onto reading with finite V. Each admitted contact A_i is a total
map with a specified total observed action t_i:V→V satisfying E∘A_i=t_i∘E.
Let U be one fixed total map that selects an actual A_i at each source.
Fix v∈V. Let M_v consist of the distinct maps generated by the t_i that
individually fix v, including the empty word, and put d=|M_v|.

If a U trajectory has d+1 consecutive readings v followed by a different
reading, two contact words of length at most d have the same complete
observed map but different continuation effects from the same preparation.
Thus the complete observed contact action does not determine the action
needed for all future E questions. Neither source reversibility nor a finite
source carrier is needed for this conclusion.

*Proof.* Name the equal-reading sources q₀,…,q_d and the exit q_(d+1).
Let w_j be the actual contact prefix taking q₀ to q_j, with w₀ empty,
and let p_j be its complete observed map. Every contact in these prefixes
fixes v because both its actual endpoint readings are v. The d+1 maps
p₀,…,p_d lie in M_v. Hence p_i=p_j for some i<j.

Their full source effects need not be compared through inaccessible state
equality. Put k=d+1−j. Then U^k(q_j)=q_(d+1), whose reading differs from v,
whereas U^k(q_i)=q_(i+k) still reads v, since i+k<d+1. The same admitted
continuation separates w_i(q₀) and w_j(q₀). This is a witnessed failure of
factorization through the complete observed contact map. ∎

Both distinguishing continuations occur as segments of the original
trajectory. No additional return to a past source is required to infer this
existence statement. Identifying the particular aliased contact words also
requires their actual selected addresses; the sequence of stage answers
alone need not supply them. The common, autonomous U relation ties the two
continuations. A changing controller omitted from the declared source does
not supply that relation.

**Visible inverses turn the pair into one returning word.** If all t_i are
permutations, M_v is the group H_v generated by those contacts fixing v.
Write w_j as w_i followed by its actual intervening word B. Cancelling
p_i=p_j in the observed permutation group shows that B acts identically
on all V. From q_i it reaches q_j, and U^k distinguishes its effect.
Here |B|≤d, preparation length i≤d−1 and separator length k≤d. This step
still does not require A_i to be invertible: only the observed maps were
cancelled. Involutive source contacts additionally forbid certain shorter
returns, as used in VC104a's six-contact lower bound.

For m=|V| there are m^(m−1) total maps fixing v, so d is at most that number.
For permutations d≤(m−1)!. The particular admitted maps can give a smaller
bound. In the four-leaf star, the three individually fixing contacts generate
the full permutation group of the other four stages. Thus d=24 and this
argument recovers VC104a before its sharper short-word analysis. The number
twenty-four comes from this declared action, not a universal physical scale.

If complete calibration does hold on the relevant source or continuation
quotient, it gives another description of the same limit. With permutation
images it defines an action of their generated group G: a positive word for
each inverse exists because every observed permutation has finite order.
Calibration with the empty word then supplies inverse actions on the scope
where it is asserted. A contact orbit has at most |G| members, and the
profiles over v in that orbit have at most |G_v| members. An uninterrupted
residence uses only H_v≤G_v, explaining why its more specific bound may be
smaller. Unreachable copies and distinctions outside the admitted future
questions do not enlarge this orbit.

The two-path conclusion is more general than a return criterion. With
noninvertible observed maps, equal prefixes cannot in general be cancelled.
For example, contacts whose observed maps are the two constants on {0,1}
have no nonempty word with observed identity. An explicit retaining source
is K={0,1}×({0,1}×{0,1})*, where the second field h is a finite internal
history. Set E(v,h)=v and

    A_b(v,h) = (b, h appended with (v,b)),       b∈{0,1}.

Every A_b is injective: its appended pair retains v and its preceding
history is still present. Select U=A₀ when |h|<2 and U=A₁ otherwise.
From (0,empty) the readings are 0,0,0,1. The prefixes A₀ and A₀A₀ have
the same complete observed map, the constant zero. Their next U readings
are respectively zero and one. Every nonempty contact word has a constant
observed map, so no such word is observed identity. The different paths
remain consequential without a returning observed word or any loss from
the complete source. The contacts have inverses on their images; they are
not asserted to be onto this entire history carrier. Its internal record
length controls the choice, without an outside clock.

Finally, U has not been assumed to possess a fixed map on V. It selects an
actual contact using the source. If E∘U=u∘E for a fixed u were also supplied,
two equal readings followed later by exit would already be impossible:
u(v)=v would keep every subsequent reading v. The residence therefore probes
distinctions available to the internal chooser and omitted by E. VC109 asks
the stronger question of when even the full observed *contact action* is
insufficient for those future choices.

## §7. Statement

1. A reach written on both sides creates the finite space in which
   alignment is decidable; a one-sided reach poses a fibered game in
   which location and correspondence confound, and the second side is
   part of the declaration, never of a scan (§1, §2).
2. At an exact birth the admissible alignments are a torsor under the
   automorphism group of the birth structure, grammar and carried
   values both: any ambiguity is pure symmetry, and where more than
   one candidate survives in that orbit, an equivariant choice needs
   the internal reference condition of VI1a.
3. Judgment runs on the admissible class: holds and parted require
   invariance over the class, open names a missing distinguishing
   premise, and any finite witness that makes the judged predicate
   invariant is sufficient; identification is sufficient without being
   a prerequisite for every question (VI2).
4. The relation court is independent of the birth geometry: it decides
   on arbitrary finite classes (VI2).
5. Invariance at a two-sided birth may be established through
   generator symmetries of the judged predicate; a single-point
   generator check does not suffice (Lemma).
6. The act records the distinctions it performs; the court judges on
   the class; neither predicts future predicates (§4).
7. State history need not identify provenance. It does so exactly when
   its projection separates the event distinctions being asked about.
   VI3 lists additional relations needed where this fails (§5).
8. Post-drift, correspondence and distance are jointly
   underdetermined; minimum-distance selection is observation unless
   declared as law (§2).
9. A supplied premise narrows the class and only shrinks the verdict
   interval: open may resolve, settled verdicts remain fixed; and verdicts do
   not compose, candidates do (Corollary, Remark).
10. A past choice can be recovered when available evidence determines
    it. If the admitted histories still disagree, further evidence or
    an explicit restriction is needed. A newly selected convention
    does not thereby establish that it was selected in the past (§4).

A verdict is exact when every admissible correspondence gives the
same answer. A choice of representative is an additional task whose
requirements depend on symmetry and the available internal reference.
Historical recovery has the same discipline: retain or derive the
distinction the question needs, and exhibit differing compatible
histories before declaring it unrecoverable.

## Scope

Claimed: VI1 for an exact carry on a two-sided written reach, with the
fibered remark for the one-sided game and VI1a for equivariant readings,
internal references and finite probability kernels under their stated actions.
Also the two-court structure, the
alignment floor complete by SG1's partition and the relation floor by
its own; the stability corollary and the
non-compositionality remark; the generator-symmetry and
compatibility-frontier lemmas; the non-identifiability of provenance
from state history, in the scoped form of §5; VI3 under its stated
conditions; the joint underdetermination reading of §2. Not claimed: any
dynamics of |K_t| over time, in either direction; tractability of the
post-drift court; a quotient presentation for the correspondence class
of §2, which is a set without a declared equivalence on its members.

Sections 6a–6n add VC1–VC42 with their own premises. The implemented fragment
checks finite certificate construction, exact coverage of a declared support
tree, a supplied question factorization, and a generic family witness. One
operation example refutes unrestricted propagation, while a second supplies
a commuting factorization. Section 6e implements generic finite-path composition. The coarsest
operational quotient and its boundaries in §6f are mathematical arguments
under their declared state, operation and observation relations. Section 6g connects
these to finite reversible images, sufficient windows, prepared memory and
global compatibility, with generic window and equality-composition witnesses.
Section 6h adds bounded separators, discovery policies and obstruction
certificates, with table traces and retained-history witnesses. Section 6i
specializes discovery to a fixed original-state question using labeled beliefs,
with explicit refusal of retargeting that question after an intervention.
Section 6j compiles an observation-only internal controller, separates branch
reversibility from feedback reversibility, and constructs a finite whole for
a prepared bounded experiment with an explicit limit on permanent readiness.
Section 6k restricts component reuse to its certified input scope. Section 6l
composes supplied factorizations across tagged representation codes and gives
a closed realization with explicit preparation and intermediate-reading premises.
Section 6m certifies the least autonomous refinement by future-reading
witnesses, including mixed continuations and a separate acquisition boundary.
Section 6n derives recording, evidence refinement and certified reuse through
generic type relations, including the existing decoder's exact input and answer.
No claim is made that
Swift seals the constructor grammar, that a supplied model covers reality,
or that every question family has a finite proof basis.

Sections 6o–6zf connect a finite relation basis for continued use, availability, partial interactions and source-bound acquisition. Their sufficient images, retained evidence and prepared exchanges are stated on their own declared carriers and action families. A sufficient old answer does not by itself certify a new contact or expose the domain on which that answer remains usable.

Sections 6zg–6zk close two internal exchange generators, identify the exact fifteen-value common-behavior image on the full binary working carrier and its thirteen-value restriction to the prepared reachable carrier, and derive its reuse from acquired evidence. A third internal exchange splits the remaining pair while preserving the common question. The binary comparison clauses, total action family and source-bound acquisition premises specify each result's scope. The count concerns behavioral values, not whole histories or runtime inhabitants of Swift types.

Sections 6zl–6zr acquire an E/K law from a prepared response and reconstruct four-address routing from two binary probe images. A product factorization reuses the acquired routing with an explicitly read new input and supplies an existing common-answer table. The law family, probe preparation and stable routing delimit each conclusion. An internal changing schedule produces the same record as a fixed permutation, so neither whole-source identity nor record consistency supplies stationarity.

Sections 6zs–6zzs develop question-relative acquisition, available probes and distributed choices, transport through local contacts, carried-phase obstructions and residence costs. Their finite calibrations and lower bounds retain the original question, admitted actions, initial preparation and actual residue. A finite passing experiment supplies its stated certificate. A supplied bound can make a stronger calibration finite, but success on a tested prefix does not establish that bound. Each result keeps the scope of its local statement and proof.

Kin outside the corpus, imported as nothing. The relation court's
universal quantification has ancestors in certain answers over
incomplete databases and over uncertain schema mappings (Imielinski
and Lipski, 1984; Dong, Halevy, and Yu, 2009), where a query is
answered under every world or mapping the records permit. The three
verdicts are the supervaluationist's (van Fraassen, 1966; Fine, 1975):
truth on every admissible precisification, falsity on every one,
indeterminacy between; the relation court supervaluates over
correspondences, and the remark that open is not a truth value is that
tradition's own boundary against three-valued logic. The bitorsor
of isomorphisms under the two automorphism groups is classical.
Provenance attestation formats (W3C PROV; in-toto and SLSA) record
event witnesses for build artifacts in practice, and
rename-reconstruction tools document their own threshold sensitivity
and confusion classes, living the joint underdetermination of §2.
The works surveyed here do not state the composition claimed here:
the class of correspondences derived from a written reach and the
symmetry of a birth; the two-floor court with parted and open as
first-class verdicts and the witness measured by sufficiency; and the
non-identifiability of provenance from state history as a theorem
rather than a practice. No priority is claimed
over any of them, and the derivation above uses none of their steps.

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

## Topics

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
