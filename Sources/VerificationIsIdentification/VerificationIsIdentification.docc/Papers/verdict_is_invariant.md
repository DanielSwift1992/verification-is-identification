# Verdict Is Invariant (Correspondence)

Seam Is Game judges a pair of declarations at the addresses the two
sides speak about. Agreement Is Comparison prices the interval between
judgements, and its model begins by assumption: "The shared reach of
the pair has N addresses" (AiC Definition 2). Neither paper states who
fixed the correspondence between one side's addresses and the other's,
or when that fixing became a fact. Here the author states the law of
the correspondence itself: what space a declaration creates for it,
what its ambiguity is at the moment a second record is born, what a
court can decide while the correspondence stays ambiguous, and what no
history of states can settle about it.

The claim is one construction, two laws, and one impossibility. The
construction: a reach written on both sides makes alignment a finite
decidable game, and at an exact birth the admissible alignments form a
torsor under the automorphism group of the carried content, so any
ambiguity at birth is pure symmetry, and where more than one candidate
survives, none is canonical. The court's law: judgment runs on the admissible class. A verdict does not
require knowing which correspondence holds; it requires the verdict to
be invariant across every correspondence the records permit, and where
it is not invariant the state is open, naming a missing distinguishing
premise. The act's law: an act records the distinctions it performs,
and only those. The impossibility: provenance is not a function of
state history. A store of states replays compatibility; only a record
of the event replays origin. Identification is sufficient for judgment
and never necessary; invariance is sufficient. One prohibition does
the work throughout: a distinction the records have not made is never
filled in; the court first asks whether the asked answer depends on it
at all.

## §0. Derivation

No new postulate. From Existence Is Finite: Part III ("A space is not
a process": the medium holds records, never acts), Theorem 3 (decidable
COMPARE on Σ). From V=I: §5.4 (the semantics-preserving premise is
external), §5.13 and §5.15 (the recursion licences Seam Is Game used,
reused one level down), §5.20 (revelation, not creation), §5.21
(COMPARE is the sole source of equality classifications). From Seam Is
Game: SG1 (the three-state vocabulary from the partition of ℕ), SG2
(pinning is a precondition), consequences (a) (the needed distinction
has a name) and (c) (a supplied premise with a term). From Agreement
Is Comparison: Definition 2 (the shared reach, assumed given: the
assumption this paper grounds), AC4 and AC5 (one side's archive says
nothing of the other), AC6 (a generator transports agreement and
creates none). From Merge Is Commutation: Definition 1 (the reach is
written). From Distance Is Cost: G2 (W is a metric). From Record Is
System: SW1 (every act is a write or a reading: an act writes its
result, never itself), SW3 (a reading cannot drift), SW4 (a test
estimates by sample, with no word off-sample), §8 (the collapse is per
position). Declared imports, standard and named where used: torsors of
finite group actions; the tree matching complexity results of §6 (Aho,
Hopcroft, and Ullman, 1974; Zhang and Shasha, 1989; Zhang, Statman,
and Shasha, 1992). The numerics below carry one standing
throughout: exhaustive enumeration over declared finite scenes,
classes carried whole, never sampled, with a negative control (a
corrupted survivor set fails its check).

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
merely tell the court what to judge; it creates the finite space in
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
carried values break a structural symmetry. *Numerics:* two addresses
of equal value give |Aut(X₀)| = 2 = |I₀|; two addresses of distinct
values of one type give |Aut(X₀)| = 1 = |I₀| against |Aut_G| = 2, and
the torsor identity fails under the bare grammar and holds under the
birth structure.

*Proof.* For m₀, m₁ ∈ I₀, the composite m₀⁻¹ ∘ m₁ is defined because
both are bijections onto the same written R_B, and it preserves G and
ν_A, so it lies in Aut(X₀); the action is transitive. Freeness is the
injectivity of m₀. ∎

*Remark (both sides act).* Aut(Y₀) acts on the other side, and the two
groups have equal order: the structure is a bitorsor. Nothing below
depends on which side is used.

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
*Numerics:* the failure (2 against 1), the restoration, the product
law (6 = 3 × 2), and the per-fibre torsor were each checked whole.

Three readings of VI1, each doing work:

- **Ambiguity at birth is pure symmetry.** The class is not arbitrary:
  it is exactly the value-preserving symmetry of what was carried. The
  minimal exhibit is two addresses carrying equal values: a group of
  order two, identity against swap, indistinguishable by every record.
- **Where |I₀| > 1, the torsor has no basepoint.** A singleton I₀
  names its mapping by uniqueness; above one, "the true mapping" does
  not appear in this paper's vocabulary. Where the act factored through a
  specific m (a rename, a deterministic generator, an element-wise
  copy), that m is a fact of the act, and it becomes a fact of the
  system exactly if written (EiF Part III; SW1: an act writes its
  result, never itself). Where the act did not factor through a
  representative, there is no fact to have lost: forcing a choice
  would introduce a distinction that never existed.
- **An exact birth gives zero distance while preserving every symmetry
  the carried record fails to distinguish.** d = 0, and the class is
  exactly as wide as the birth structure's symmetry: agreement creates
  no identity beyond the distinctions already recorded. Which of the equal things
  the act took, only the act contained, and only where the act
  individuated them at all.

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
unless the minimum-distance law is itself declared. *Numerics:*
current values collapse E_t to a singleton while the recorded class
keeps two members; the court on the recorded class stays open, and a
court on E_t would return holds.

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
*Numerics:* on a class of three, a predicate true at exactly one
candidate lands open, never identified. The corollary is the paper's
title: **identification is
sufficient for judgment and never necessary; invariance is
sufficient.** A court that cannot name the correspondence may still
judge exactly, whenever the verdict is constant on everything the
records permit; and where it is not constant, open is the only honest
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
(RiS §8), and nothing here constrains K across revisions. *Numerics:*
every nonempty narrowing of a holds class held and of a parted class
parted, and one open class resolved both ways under two premises.

**Remark (open is not a truth value).** Verdicts do not compose;
candidates do. For J open on K, the predicate J-or-not-J is true at
every candidate, and the court returns holds; a calculus that combined
the statuses would return open, and be wrong. A compound question is
evaluated per candidate and then quantified, never assembled from the
verdicts of its parts. *Numerics:* the divergence is checked whole:
per-candidate evaluation returns holds where the three-valued
combination of statuses returns open.

Together, VI2, the corollary, and the remark fix a calculus of judgment
under unidentified correspondence: premises act by narrowing the
class, predicates evaluate inside candidates, the verdict is read only
after quantification; refinement is monotone, and composition is
internal, never verdict-level.

**VI2 uses none of §2's geometry.** The two courts quantify over an
arbitrary finite class: fibered, orbit-structured, or neither.
*Numerics:* the courts return the same three verdicts on a full
fibered class and on arbitrary subsets with no orbit structure.

**Lemma (invariance via generator symmetry).** At a two-sided birth K
is a torsor under Aut(X₀). If every generator g of Aut(X₀) is a
symmetry of J (for every admissible m, J(m∘g) = J(m)), then J is
constant on K.
For address-local predicates (a conjunction of per-address checks) the
hypothesis is a per-generator comparison over the touched addresses,
without enumerating the class, and tree automorphism groups admit
polynomial generating sets. A single-point check is not sufficient:
J(m₀∘g) = J(m₀) on every generator can hold while the orbit still
splits. *Numerics:* the counterexample is S₃ with a predicate true at
the identity and the transpositions, false at the 3-cycles: the
single-point check passes and the class is not constant; both
symmetric predicates of either polarity confirmed the positive half.
Post-drift, the class of distance-minimizing candidates has no such
structure in general; tractability there is open and not claimed.

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
run and inferred away by none. *Numerics:* two runs of a generator
with a hidden counter compare equal, whole, and a third differs: the
sampled premise was false; a replay that reads only the pinned record
identifies one correspondence by construction. If the act does not
factor through a representative, there is nothing to record and
nothing to invent.

**The court's law: judge on the class.** Predicates declared after the
birth find either a recorded distinction (and are answerable) or a
genuinely absent one (and stand open, the premise suppliable by hand
with a term: SG consequence (c)). Neither law requires predicting
future predicates: the act answers for the act's facts, the court for
the question's invariance. A conditional obligation evaluated at birth
ranges only over the predicates then declared and cannot discharge
predicates introduced later; the split laws can.

**Missing and nonexistent are two different opens.** VI1's second
reading splits the open state by its remedy. Where the act factored
through a representative and recorded it, the distinction is read.
Where the act factored through one and did not record it, the act's
distinction left no system record, and the historical question stands
open; a hand-supplied premise (SG consequence (c)) carries a term, not
a recovery. Where the act never individuated, the distinction never
existed, and no record of the birth can be found or supplied: a
singleton narrowing taken now is a new premise with its own moment,
legislation, never testimony. The stability corollary holds either
way: **a premise may settle the future; it cannot manufacture a
distinction in the past.** *Numerics:* a birth record invariant under
a renaming that exchanges the two candidates separates nothing between
them: the historical question stays open, and a singleton narrowing
demonstrably reads current values (the observer E_t of §2), never the
birth.

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
*Numerics:* the witness pair is finite and was checked whole: in one
history the second record exists independently, coincidentally
compatible under the swap, and the carry happens at the next revision
under the direct mapping; in the other the carry happens first, under
the swap, and an independent edit lands on the same bytes; the two
state histories are equal revision by revision, and the strict classes
at the two revisions are disjoint singletons, so the frontier court
returns a singleton correspondence that no act in the first history
performed.

**State history replays compatibility; only an event record replays
provenance.** The substrate holds states: I3 holds the results of
acts, never the acts (SW1). Structural identification and historical
identification part exactly here: comparison establishes what
corresponds now, the scan establishes when correspondence became
possible, and neither invents the event of origin that nobody wrote.

**VI3 (replay decomposition, conditional).** Given durable carrier
states and a pinned court (histories not rewritten, pinned bytes
reachable, the grammar and the comparison law versioned under the
pin), the following replay from the substrate: the carrier states, the
strict game at any recorded revision, the compatibility frontier. The
following do not, and each is a record or nothing:

1. the relation declaration (subject, J, the two-sided reach, the
   reference to the court's grammar), where none was written;
2. the other side's revision, where the pair crosses a boundary (one
   side's archive says nothing of the other: AC4, AC5);
3. the event identity: that, and at which revision, the carry happened
   (the birth pin), underivable even when a compatible revision stands
   on history (the lemma above);
4. the act's representative choice, where |I₀| > 1 and a later
   judgment needs one.

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

## §7. Statement

1. A reach written on both sides creates the finite space in which
   alignment is decidable; a one-sided reach poses a fibered game in
   which location and correspondence confound, and the second side is
   part of the declaration, never of a scan (§1, §2).
2. At an exact birth the admissible alignments are a torsor under the
   automorphism group of the birth structure, grammar and carried
   values both: any ambiguity is pure symmetry, and where more than
   one candidate survives, none is distinguished unless recorded (VI1).
3. Judgment runs on the admissible class: holds and parted require
   invariance over the class, open names a missing distinguishing
   premise, and any finite witness that makes the judged predicate
   invariant is sufficient; identification is sufficient and never
   necessary (VI2).
4. The relation court is independent of the birth geometry: it decides
   on arbitrary finite classes (VI2).
5. Invariance at a two-sided birth may be established through
   generator symmetries of the judged predicate; a single-point
   generator check does not suffice (Lemma).
6. The act records the distinctions it performs; the court judges on
   the class; neither predicts future predicates (§4).
7. State history replays compatibility, never provenance: the frontier
   bounds the birth and cannot name it, and the unrecoverable residue
   of a birth is the declaration, the other side's revision, the event
   identity, and the act's representative choice (§5, VI3).
8. Post-drift, correspondence and distance are jointly
   underdetermined; minimum-distance selection is observation unless
   declared as law (§2).
9. A supplied premise narrows the class and only shrinks the verdict
   interval: open may resolve, settled verdicts stand; and verdicts do
   not compose, candidates do (Corollary, Remark).
10. Open splits by remedy: a recorded distinction is read, an
    unrecorded one is historically lost, a never-made one can only be
    legislated as a new premise with its own moment; a premise settles
    the future and manufactures nothing in the past (§4).

> **Two records of one fact are aligned by a correspondence nobody may
> ever have written down. At an exact birth on a two-sided written
> reach the admissible correspondences form a torsor: whatever
> ambiguity remains is exactly the symmetry of what was carried, and
> where more than one candidate survives, none is canonical; where the
> act chose a representative, that distinction is
> either recorded or absent from the system. A court needs no
> representative: a verdict is exact whenever it is invariant across
> every correspondence the records permit, and where it is not, the
> state is open and a missing premise is named. The history of states
> can say when agreement became possible; only a record of the event
> can say where it came from. When the act factors through a
> representative, the act alone contains that distinction; only a
> record carries it into the system, and unwritten it is not a fact.**

## Scope

Claimed: VI1 for an exact carry on a two-sided written reach, with the
fibered remark for the one-sided game; the two-court structure, the
alignment floor complete by SG1's partition and the relation floor by
its own; the stability corollary and the
non-compositionality remark; the generator-symmetry and
compatibility-frontier lemmas; the non-identifiability of provenance
from state history, in the scoped form of §5; VI3 under its stated
conditions; the joint underdetermination reading of §2. The numerics carry the standing
declared in §0: exhaustive enumeration over declared finite scenes,
classes carried whole, with a negative control. Not claimed: any
dynamics of |K_t| over time, in either direction; tractability of the
post-drift court; a quotient in the strict sense (the admissible class
is a set, and becomes a quotient only under an equivalence this paper
does not define).

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
| Declared here | torsors of finite group actions; linear isomorphism of rooted unordered trees (Aho, Hopcroft, and Ullman, 1974); ordered tree edit distance in polynomial time (Zhang and Shasha, 1989); unordered tree edit distance NP-complete (Zhang, Statman, and Shasha, 1992); the forgetful-map argument of §5 |
