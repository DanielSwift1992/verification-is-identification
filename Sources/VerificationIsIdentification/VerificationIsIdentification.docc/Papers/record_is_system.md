# Record Is System (Software)

Permanence Is Resistance §5 projects the framework onto physical systems, and The Architecture of Learning Machines projects it onto learners. This document is the same move applied to the software artifact itself: the thing a team builds, describes, proves, and audits. The **record** is the source text: what is written down. The **system** is what is true once the build runs. The claim, within the framework's scope (the determinate part of a system, written as pure types, Law §0′), is that the two are one object: the record *is* the system, its proof is the build's verdict on it, and its documentation, reports, and audit are readings of it, re-derived at every build. Practice keeps four artifacts and pays to hold them in step. The projection derives that, over the pure part, there is exactly one artifact and nothing to hold in step.

The evidence base is concrete: the repository around this paper. Its showcase is a whole organization (people, roles, documents, access policy, review cycles) written as pure types, and every page of the resulting site, every access verdict, every audit figure is read off those types at build time. After a policy edit, the next build re-derives two hundred pages, with no step where a description could lag the system it describes.

## §0. The Projection Basis

No new postulate. The author reads the coordinates off the theory:

| Element | Source | Role in the artifact |
|---|---|---|
| **medium** (pure types, nothing runs) | Law §0′ | the record is a position in Σ, a standing finite structure |
| **gate** (the compiler) | V=I §2.5, PP15 | the given COMPARE: decidable, borrowed, certified by no game here |
| **move** (expand / compress) | Law §1 | the write, the only way the record changes |
| **reading** (projection + COMPARE) | V=I §5.20–5.21 | docs, reports, audit: facts revealed, never created |
| **order** (the build schedule) | V=I §5.25 | free, and it changes no verdict |

A software practice is located by which of its artifacts are the record and which are second encodings kept beside it. The theorems are then in force conditionally, the same way PiR §5 reads I1–I3 on ice and the Architecture paper reads the six coordinates on a learner.

The pure artifact and the physical activity that reads it have different
boundaries within one whole. A build can leave the source record unchanged
while changing the compiler's memory and its surroundings. Purity of the
represented relation does not place that activity outside reality or assign
it zero physical cost.

The same distinction applies to editing a description. An actual edit is an event within the whole. Invariance of the described answer concerns its referent and encoding. It does not erase the editing event. Likewise, retaining an edit in a complete history does not make the previous source available in the current checkout. That access needs a retained readable representation, the distinction stated in Matter M50.

## §1. Two Verbs Exhaust the Practice

**SW0 (What the type check establishes).** The pure record consists of types and relations between their addresses. A caseless enum can satisfy a relation despite having no runtime values. In this medium, such absence is not falsity. `Null` equates its Left and Right; it does not erase the witness type or identify every equal-sided structure with Never.

A protocol states a required relation. A conformance supplies a construction meeting it. A generic constructor derives a consequence when its parameters require only the premises (Law §T). Merely placing the desired conclusion in a `where` clause describes its scope; it does not establish that every source belongs there. A compiler refusal rules out the attempted construction under its constraints. It is not an object-level negation, and a timeout or unrelated build error is no refusal witness at all.

This starting point needs no global Boolean valuation of all questions. Two records can coexist without agreeing (Verdict VC43); an answer can be readable within one scope without identifying its source (VC40–VC42). These are addressed structural relations. Classical reasoning can establish consequences of a specified fragment, but its additional premises must not be silently attributed to the whole of The Cut. The present construction does not claim a complete alternative logical calculus.

**SW1 (Every act is a write or a reading).** On a pure-Σ artifact, every act available to practice either changes the record or leaves it unchanged. If it changes the record, it is a move, and there are two, expand or compress (Law §1: there is no third). If it leaves the record unchanged, its result is determined by the standing structure before the act (V=I §5.20: revelation, not creation): it is a reading. Running is not a third verb: §0′ leaves nothing to run.

*Proof.* Law §0′ excludes execution from the medium, so acts partition by whether they alter Σ. Alterations are protocol writes, and Law §1 enumerates the moves. Non-alterations produce output from fixed input. By §5.20–5.21 that output is a pre-existing structural fact made explicit. QED. **[solid]**

The verbs of practice map accordingly: *implement* = write. *Build* = the referee's verdict on the position (Play Is Proof). Generate a document, report or audit = read. Author a new explanation = write. Review reads the record against the law. Checks of nearby incompatible constructions examine whether that law expresses the intended boundary (§4).

## §2. The Four Artifacts Are One Record

**SW2 (Proof, documentation, and audit are projections).** Practice maintains four artifacts: the source, the proof, the documentation, the audit trail. Over the pure part they are one structure under four readings:

- **The proof is in the checked relations.** The build checks presented conformances and generic derivations against the encoded requirements. The relation is carried by the record itself. Compilation alone does not certify an arbitrary interpretation of a declaration (SW0).
- **The generated documentation is a reading.** A fixed renderer projects the type graph into pages. Equal types give equal pages under that reading; equal pages identify types only if the reading retains the distinctions in question. Authored prose has its own claims and is not proved by being rendered. **[solid within these premises]**
- **The audit is a reading of verdicts.** Which access is in force, which invariant is intact, which count settles: each is a conformance fact, read where it is pinned. The access matrix cannot disagree with the policy, because it is the policy, read.
- **The source is the record**: the only member of the four that is written rather than read.

*Instance.* `Login<Who, Entered>: Authorized where Who.Pass == Entered` identifies the entered credential with the credential assigned to Who. Who is already a parameter. If two people share a credential, that equality cannot select one of them. Identifying a person requires a declared candidate domain and a reading that separates its candidates; the single password equality supplies only its addressed relation.

## §3. Drift Has No Second Frame

*A scoped name can suffice.* Given a factorization F through a trace T's memory, `AnswerInTrace<T,F>` names F.Right after matching the source and memory endpoints (Verdict VC42). The alias is the existing decoder type. It introduces no object that applies the certificate and no copied answer for that object to maintain. Two admissible names of the same decoder are the same type. The declared source and question relations still determine where that reading is justified.

The same trace can retain facts from different contexts. An old decoder reads its unchanged prefix in its original context, independently of the new fact's encoding (VC42). `RetainTraceAnswer` therefore needs matching source and memory, without requiring a common context for every fact in the trace. `TraceEvidence` names the contextual memory projection `TraceEvidenceIn`. Coexistence of these facts neither translates their questions nor makes their answers comparable. The relation needed for one reading is smaller than a uniform interpretation of the complete record.

The same simplification applies to path extension: `AppendSwap` and the two
`AppendSpectrum` aliases name existing compositions. Their names add no
separate path objects. VC44 also shows why reducing names is not enough by
itself: different nominal expressions can have the same complete behavior
under the specified questions and operations. The agreement certificates
express that relation without asserting source identity. VC45 then carries
a question along a transition to a decoder of its initial image, using one
generic factorization rather than a second implementation of the prediction.

VC50–VC53 extend this reduction across representations. The source classification names a composition of the complete observation with its class decoder. The source-to-class action square names `ReobservedTransition`. Its source action and class action already exist. `AnswersThroughSharedDecoder` likewise names `JoinedVerdict` at the decoder seam. These aliases remove duplicate declarations of consequences without equating different source types.

Changing representation before or after joining a path gives the same boundary readings (VC53). The proof expressions themselves remain nominally different. The boundary relation is enough to reuse the result. Demanding identity of the whole proof expression would add a requirement that the question does not need. Physical storage, reading cost, and the process that finds a useful representation remain separate from this static equality.

**SW3 (Regeneration removes a stale copy, not the reading's proof obligation).** If each build computes a specified reading from the current source, its output cannot retain an older source through failure to update a separately maintained copy. This removes that synchronization failure. It does not prove that the reading answers the intended question. A renderer that always prints the same verdict is perfectly reproducible and can still misdescribe the source.

SW2 therefore requires both current-source binding and a justified reading. Authored explanations introduce their own questions and claims. Rendering a changed theorem beside an unchanged stronger slogan does not derive the slogan from the theorem. Difference Is Distance's comparison of encodings can measure an established discrepancy, but absence of a second maintained file alone does not establish semantic faithfulness.

**SW3a (An application needs the acting premises).** An unchanged theorem remains true under its stated conditions. Weakening the premises offered at a use site can make its former application unjustified. For example, `ConstantSecondFactors<T>` derives the second answer from the first under `T: Null`. Changing the supplied constraint to `T: Pair` removes the needed equality. The conditional theorem remains valid, while `RejectedUnmeasuredSecond` rejects that wider application (VC42).

Fix a universe U of candidate realizations and a question q:U→B. Suppose the former premises admitted a nonempty family K₀ and established q=c throughout it. A correction weakening those premises admits K₁⊇K₀. The old answer remains justified on the corrected family exactly when:

> `K₁ ⊆ q⁻¹({c})`.

For a dependent answer obtained through an established map h:B→D, the weaker obligation is:

> `q(K₁) ⊆ h⁻¹({h(c)})`.

*Proof.* The first inclusion states q(x)=c for every newly admitted x. The second states h(q(x))=h(c) for every such x. These are exactly the respective claims. The second can remain true when the first fails, because h can discard the varying distinction. This applies the answer criterion of Verdict Is Invariant to a correction. It introduces no alternative proof calculus.

*An explicit change of scope.* K₀={(0,0)} becomes K₁={(0,0),(0,1)}. The first-coordinate answer remains 0. The second-coordinate answer is no longer constant. A restatement retaining that second answer as (answer,s) also varies. A subsequent reading returning only s remains constant. Thus the old derivation can become unusable while a downstream conclusion has a new proof from weaker premises. Treating every dependent conclusion as false would lose a valid answer. Continuing to use its old proof without checking the changed scope would also be wrong.

`Checks/Context.swift` expresses this directly with existing readers. `ExpandedFirstAgreement` derives agreement for (A,B) and (A,C) from their shared first coordinate, without asking the caller for output equality. Its sources cover the declared expanded pair. `PostPairAgreement` transfers that result to an actual output context. `CorrectedSecondObstruction` supplies the distinct second answers at 00 and 01. `ExpandedTagAgreement` composes actual second-coordinate readings with the tag projection and derives the coarser descendant anew. Compiler refusals reject reuse of the old source scope, agreement of the expanded second answers and agreement of the restatement retaining those answers.

*Bind the use to the publication's root.* `AnswerInTrace<T,F>` requires `F.Left.Left == T.Left` and `F.Observation.Answer == T.Right`, then names the existing decoder `F.Right`. In `Checks/Acquisition.swift`, `PublicationRoot` contains the active trace and an archive. `PublicationFirst` takes its trace from that root's active field. The archived reading gives the same scalar answer to the same question, but using its certificate against the active trace is refused. The archive remains readable as an archive. This is an explicit source relation within the declared publication, not an intrinsic property of a type named Current or a claim that the whole has an external present.

*Reuse is composition.* When `q=d∘E` and a new observation H recovers E through `E=r∘H`, the existing `AnswerOnRefinement` and `RefineAnswer` derive `q=(d∘r)∘H` (VC41). Recovering all of E is sufficient but can be unnecessary for q. A weaker new observation can still support a direct factorization of that question. An absent construction establishes neither such a factorization nor the conclusion's falsity. An explicit collision of observations with different q-answers rules out a shared decoder on that family.

There is no separate proved-status field here. A list of parent names, a revision hash or matching question labels cannot replace these applications. The existing Book Court can check declared dependencies and metadata. It does not prove that an English summary preserves the source's quantifiers and scope. The publication-root fixture also does not connect every free prose paragraph to a typed claim. That connection requires the corresponding statement and a justified renderer or a separately checked reading.

These inclusions concern a fixed question on comparable candidates. A change of representation or of the question itself additionally needs an established correspondence, as VC45 and VC50–VC53 require. Neither nominally preserving a claim ID nor retaining its earlier certificate transports that correspondence automatically.

**SW3b (The published reading belongs to the root).** `DocumentKit.CoveredStatement<Root>` renders one fixed statement form. The root contains an independently declared support, independently requested covered readings, the actual coverage construction, and an archive. The requested and actual constructions must cover the declared support in the same space and encoding, and their answers must agree. Both constructions and both answers are read from that root. The renderer takes no separate certificate argument from which it could choose another reading.

In `DocumentKitDemo/Claim.swift`, the active support names three beams. `RequestedVisibleAnswers` specifies the required `VisibleReading` applications directly, without referring to the proposed coverage aliases. `ThreeBeamsCovered` derives the proposed common answer. The archived support names only the first two. `swift run DocumentKitDemo claim --write` produces the Examples page *A Covered Visible Answer* from this root. Its statement retains the support, space, encoding, requested readings and answer, actual derivation, operation and answer. The derivations display reading constructors rather than replacing them with a question label.

*Why the finite statement follows.* Interpret both coverage trees through the leaf/join/group constructors of Verdict §6b. A leaf contributes exactly the source of its actual reading. A join retains both supports and equates their answers. A group retains its certificate's support and answer. Induction therefore gives the requested common answer at every leaf of the request tree and the proposed common answer at every leaf of the proposed tree. Both supports are the same declared tree, and the two common answers are equal. Thus each proposed leaf gives the requested answer on its corresponding source. This is a nonempty family of represented sources. It does not establish that the declaration exhausts an external domain, that arbitrary open conformances belong to this grammar, or that represented sources have physical realizations.

*The question label is insufficient.* An alternative `PredicateReading` can retain `BeamSpace`, `EyeEncoding` and `VisibleQuestion` while declaring `Never` as its answer. Those fields alone do not bind its answer to `EyeImage`. The open protocol accepts that declaration. The earlier publication contract also accepted a coordinated replacement of all three readings: they still agreed with one another. The revised root retains an independent request, so this replacement fails the required answer equality. The saved before/after counterexample is in `Research/Artifacts/application-court-20260918/`. Deliberately changing the request changes the question; it is not reuse of the former claim.

Different constructions can preserve the required answer. From any `F: ReadingFactors`, `FactoredPublicationRetainsSource` and `FactoredPublicationRetainsAnswer` derive that `SequentialReading<F.Observation,F.Right>` retains the source and answer of `F.Left`. The composed expression has its own operation name. The factorization establishes the correspondence. In the beam example, `AlphaFactors<B>` proves the bridge between direct alpha reading and reading alpha from the visible image for every admitted B. `ImageAlphaPublication` requests the direct reading and covers the latter construction on the same three-source support. Publication does not require equality of their operation labels: it checks the required answer on that support. This result does not imply equality of effects or arbitrary continuations.

`Checks/Publication.swift` also retains a positive reordering: exchanging the two covered branches preserves their answer by the existing join equations. The declaration and requested tree change order with them. Refusals reject using the two-source archive for the active three-source support, replacing the requested visible answer by alpha, changing the encoding or space without the matching construction, replacing all proposed readings by the same-labelled alternative above, and inferring source identity from the common visible answer. These are applicability checks, without a copied proof status.

The local site build regenerates this claim even in its fast mode and stops if generation fails. It builds the executable product first: checking a target alone need not relink a previously built renderer. The artifact check also regenerates the page before comparing it with the committed copy. These paths connect the rendered statement to the built root. A manually copied page, a different publication path, an altered statement template and free prose require their own corresponding checks.

The existing Topics generator supplies a concrete limit. It maps protocol declarations to paper pages by source file. Its former heading, *Theorems this paper proves*, asserted more than that mapping established and regenerated the overstatement after manual corrections. The heading now reads *Related type declarations*. This corrects the fixed reading at its source. It neither downgrades an established theorem nor treats a protocol listing as its proof.

## §4. A Test Estimates, a Compile Identifies

**SW4 (A checked derivation covers its generic scope).** A successful generic conformance establishes the encoded relation for every admissible substitution of its parameters, subject to the toolchain premise. It need not select one nominal type: many types can satisfy the same relation. A concrete runtime test establishes an outcome for its tested input; extending that result requires a coverage argument. Exhausting a finite domain is one such argument, so the distinction concerns scope and coverage, beyond compile versus run.

Re-executing a consequence already supplied by a generic derivation adds no scope to that derivation. A nearby incompatible construction serves another purpose: it checks that the encoded relation excludes the specific substitution it should exclude. This is useful when formulating the relation. Encoding adequacy, physical acquisition, performance and toolchain behavior also remain distinct questions. None requires storing a second runtime implementation of the mathematical claim.

The source-bound trace and the prepared instrument now meet in `PreparedTraceExtension` (VC55). Its old memory, channel address, new slot and source are coordinates of the same declared whole. The supplied beta channel derives the newly recorded answer from that source. An equal-valued reading of a different nominal source cannot replace it.

The trace's next record is not a proof that an instrument has a fresh slot. The next prepared whole has different endpoints from the current filled whole. A rewind can restore preparation while retracting the latest accessible fact. M44 makes the capacity and order assumptions explicit. These facts concern the modeled process. Checking the static object does not assert that a physical instrument executed it.

## §5. Trust Crystallizes by Region

**SW5 (The typed region is crystal, and adoption is a front).** One part of a system written in the notation is decided: a wrong version does not build. The part beside it is still craft. Learning Is Liquid names this configuration (crystal behind a front, liquid ahead of it, LQ3, LQ10), and adoption is the front advancing one part at a time. The boundary is visible in the source, exactly where the types stop. Each part moved across joins the region where verification is a build. What secures the part also maps it: the record lays out the part's legal forms and collapses them to the survivor. **[interpretive**: LL's vocabulary as tools, its discipline inherited (LL §6), and the per-part guarantee itself is Theorem 2, solid**]**

## §6. The Laws Tower

**SW6 (The medium's next floor writes its law in the floor below).** The tower has three floors, and each writes its law in the medium beneath it. The raw source text is under the grammar (Permission Is Existence): a law whose rules are declarations, whose prohibitions are absences, and whose jurisdiction includes the file that declares the lattice's own seed. The lattice built on that text is under ``Law``. The rendering surface (the layer that turns types into pages) is under `SurfaceLaw`, in the rendering module. All three share one two-part shape: a checkable subset enforced on every build, a remainder held by review. Each law is written *in* a medium a lower law governs, and each floor appears where the one below is saturated enough to build on: Permanence Is Resistance §4's tower, instantiated in a toolchain, where the crystallized floor becomes the fixed target the next level's law crystallizes against (M8 ignition, the cycle permanent → resistant → irreducible). Each law is itself a position in its own medium (Law §6), so the rulebook is on the board it governs, at every floor. **[interpretive**: the three laws and their shape are fact, and reading them *as* the tower is the projection**]**

## §7. The Walls Are the Encoding's

**SW7 (What the medium cannot carry bounds what may be claimed).** The Solvability Criterion localizes all difficulty in the encoder (E2 §0). On the surface this arrives as *walls*: named, checked, and stopped at, never patched around. The render target has no column-width primitive, so no combinator claims one (SurfaceLaw §S15). The type system has no higher-kinded holes, so no combinator takes an unapplied template (§S11). Composition depth has a real stack bound, so a page is one screen's worth and a site is linked pages (§S16), the anchor graph of Navigation Is Geometry, forced by the medium.

The sharpest wall is a scope law: **an open axis carries no verdict.** A type whose reading is pinned by several `where` clauses reads its specific case only at a site where every pin is closed. Through any generic layer, the reading falls to the base case (§S12, §S17). This is V=I §5.24 surfacing in the medium: the reading reads exactly what its encoding carries, and a generic site's encoding does not carry the pin. The working rule (a non-generic proxy, resolved once at a literal site) is "fix the encoding, then read," stated as engineering. **[solid**: each wall checked directly in the medium, and the §5.24 identification is the projection**]**

## §8. Boundaries

**The scope is the pure part.** The claims are true over the determinate part written as pure types. The encoding (carving the world into those types) is the craft the framework names and does not do (E2 §5). Performance, IO, the running application are outside the record's claims, and where they matter, the liquid instruments are in force.

**The gate is given, and its trust is borrowed.** The compiler checks this encoded fragment. That acceptance alone does not certify the compiler's correctness, which remains a toolchain premise of this check. The compiler is outside the artifact being checked and inside the physical whole. PP21 permits relative internal inspection under its stated semantics. PP15's diagonal boundary is not a general ban on such inspection. No external source of reality is introduced by distinguishing these internal roles.

**The claim is per position and reading.** Editing the record changes the source to which its current readings are bound. Version history can retain earlier positions without making their claims applicable to the new one. Regeneration answers the declared reading on the new source. Agreement with the intended question still needs SW2's relation, and reuse after a correction needs SW3a's scope check.

## §9. Statement

1. On a pure-Σ artifact every act is a write (expand or compress) or a reading. Nothing runs, so nothing else exists to do (SW1).
2. Proof, documentation, and audit are readings of the one record: the proof is the build's verdict, the page is the type's name, the audit is the verdicts read (SW2).
3. Regeneration removes one stale-copy failure. Semantic agreement and reuse after correction need justified readings on the current scope. Some dependent answers can survive a weakened premise even when an intermediate answer no longer does. The finite published statement reads its domain and actual derivation from the same root (SW3–SW3b).
4. A generic derivation covers its admissible substitutions. A targeted refusal checks a boundary of the formulation; neither implies a unique whole object or settles every unencoded question (SW4).
5. Trust grows by region: the typed part is crystal, the boundary is visible where the types stop, and adoption is a front (SW5).
6. The laws are a tower: the surface writes its own law in the floor below, same shape, enforced the same way (SW6).
7. The medium's walls bound the claims, and an open axis carries no verdict: scope-bounded reading, engineered (SW7).

> **A shared source removes duplicate maintenance where proof, documentation and audit are justified readings of it. After a correction, reuse follows the questions whose answers remain established on the new scope.**

## §10. Dependency

| Source | Used |
|---|---|
| Law | §0′ (pure types, the medium), §1 (two moves), §6 (the law is a position in its own medium) |
| V=I | §2.5 (COMPARE given), §5.20–5.21 (structural facts and comparison-event admission), §5.24 (encoded-input scope), §5.25 (order within a declared traversal), Theorem 2 |
| PP | PP10 (one closed substrate), PP15 (the diagonal boundary), PP21 (scoped internal inspection under stated semantics) |
| DiD | §0/S1 (one encoding, no second frame), S7 (distance of caches), S9 (translation, the price of a second encoding) |
| PiR | §4 (the tower, M8 ignition, permanent → resistant → irreducible), §5 (projection onto systems, the structural precedent) |
| LL | crystal / front / liquid (LQ3, LQ10), §6 (tool discipline) |
| E2 | §0 (difficulty targets the encoder), §5 (the delegated remainder, where tests keep standing) |
| NiG | the anchor graph (linked pages over one monolith) |
| AI paper | the projection format (coordinates present/absent → guarantees derived, not assessed) |
| SurfaceLaw | §S11, §S12, §S15–§S17 (the walls, each checked directly in the medium) |

The record can contain its checked relations and support several useful projections. Their scope is the relation actually derived. A rendered page is also an artifact whose explanation can overstate its source. SW3a applies the same discipline to this paper: preservation of a useful answer must be shown through the actual reading after its premises change.
