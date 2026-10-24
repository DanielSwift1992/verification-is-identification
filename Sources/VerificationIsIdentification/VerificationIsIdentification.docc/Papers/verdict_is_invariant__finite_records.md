# Verdict Is Invariant (Correspondence) — Finite records

This part contains the original derivations for finite records.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6a-A-finite-certificate-in-the-type-lattice>.

## Detail: §6a. A finite certificate in the type lattice

The relation court has a small executable boundary: a presented finite class with one fixed question and one answer on every member. The type-level fragment below checks that boundary. It neither constructs the correspondence class of §2 nor proves the completeness of a supplied class. Sections 6b and 6c add explicit coverage witnesses under two different premises.

Write a reading as `(Σ, E, q, x, a)`: the space, encoding, question, candidate, and its recorded answer. A domain-specific type constructor supplies the application `a = q_E(x)`. Merely naming q does not establish that equation. In the worked instance, `VisibleReading<B>` binds its answer to `EyeImage<B>`. There is no independent answer argument a caller can substitute.

### VC1

**VC1 (Same question).** Two readings are comparable here only when Σ, E and q coincide. Their candidates and answers may differ. `ComparedReadings` checks the three equalities. Same answer types under different questions do not suffice.

> Argues: ``ComparedReadings`` needs ``/Notation/Pair``. The two reading addresses are
> the sides whose contexts the equalities compare.

> Argues: ``PredicateReading`` needs ``HasVerdict``. An application carries
> the question and answer axes that its output equation relates.

> Argues: ``PredicateReading`` needs ``/Notation/Pair``. The candidate and the recorded
> output occupy the two sides of the application.

### VC2

**VC2 (Binary certificate).** Given comparable readings of x and y with answers a and b, a certificate for answer v requires `a = v = b`. Its support is `{x, y}`, with repeated sources counted once. `VerdictIsInvariant` checks the answer equalities and binds the certificate's context to its readings. `JoinedVerdict` constructs it under exactly those premises. No equation x = y is required. An empty class has no reading and no constructor in this grammar.

### VC3

**VC3 (Singleton).** Repeating one reading gives a certificate on support `{x}`. The generic `SingletonVerdict<R>` body obtains the answer equality by substituting R for both branches. This proves the singleton case for a supplied application. It does not infer functional consistency of unrelated application declarations. Identification can still be necessary for a particular question: when q distinguishes every member of K, one exact answer also identifies its member. The claim is that identification is not a prerequisite for every question.

> Argues: ``VerdictIsInvariant`` needs ``HasVerdict``. The certificate names
> the common question and answer that both recorded applications must share.

### VC4

**VC4 (Finite composition).** A certified group may be read with its certified answer and joined to another reading or group of the same question. The support of the join is the union of its children's supports. This uses the partial lift of q to nonempty finite groups: q̂(S) = a exactly when every member has answer a. The group is a certificate node, not another source added to Σ. Induction on a finite constructor expression proves that every leaf has the root answer: the base case is VC3 or a supplied reading, and the step uses VC2 and the two child certificates. Grouping adds no omitted candidate. This is composition of certificates for *one predicate*, not truth-functional composition of the open verdicts for different predicates discussed in §3.

### VC5

**VC5 (Selection).** Retaining either child of a certified pair preserves its question and answer. `VerdictRetainsLeft` and `VerdictRetainsRight` equate the retained reading to that actual child. The answer equation then follows through the child, without another answer premise. A different candidate with the same answer is not a selection witness. Repeating selection and finite composition certifies a presented nonempty subtree selection. Arbitrary set inclusion is not implemented by this fragment.

> Argues: ``VerdictRetainsLeft`` needs ``/Notation/Pair``. The original certificate and
> its retained child are the two sides of the selection relation.

> Argues: ``VerdictRetainsRight`` needs ``/Notation/Pair``. The second selection carries
> the original certificate and the member at its other address.

### VC6

**VC6 (Reordering).** Swapping the two branches preserves the certificate. `ReversedVerdict<C>` takes C alone, exchanges its readings, and satisfies `VerdictIsInvariant`. `VerdictReorders` records the relation between the original and the constructed certificate. Their answer equality follows through the exchanged branches rather than being assumed separately.

> Argues: ``VerdictReorders`` needs ``/Notation/Pair``. Reordering relates an original
> certificate to its reversal, with the branch addresses exchanged.

The instance is the metameric pair from Seeing Is Encoding: `RedBeam` and `RedBeamWithIR` have one visible answer and different infrared answers. The visible certificate compiles while joining their infrared readings is refused. Within this two-beam class the infrared answer identifies the source, while the visible answer leaves it ambiguous. A third beam with more infrared joins the visible certificate. A dark visible branch does not. No physical measurement is performed: these are the existing finite spectral declarations read by a fixed type-level projection.

The repeatable check is `bash Checks/verdict.sh`, also `./check.sh --only verdict`. It type-checks generic answer-preservation witnesses and the finite examples, then separately requires refusal of changed answers, questions, encodings, spaces, selected members, branch order, an empty certificate and a disagreeing third branch. A rejected join means this constant-answer certificate is absent. Compiler failure by itself is not a general procedure for distinguishing the paper's `holds`, `parted` and `open` states.

**Remaining obligations.** A supplied reading must mean the stated application. The presented class must contain the intended admissible candidates, and the certificate must belong to the finite constructor grammar. Open Swift protocols can be given recursive conformances, so their names alone do not establish well-foundedness. This fragment checks the stated relations and generic constructions. It makes no new claim that every lattice protocol is saturated.

`Checks/FiniteBoundary.swift` keeps this boundary reproducible. A nonterminal cycle conforms to the current `StructuresFinite`. Experimental one-level and two-level floor protocols instead state the descent endpoints, and the compiler refuses cycles at either side of the one-level boundary. Those bounded claims are research fixtures, not a proof for arbitrary depth or a replacement for Σ.

## Detail: §6b. Coverage needs an independent declaration

### VC7

**VC7 (Support follows construction).** A leaf records `Leaf(x)`. A join records `Fork(support(left), support(right))`. A group carries its certificate's support without adding a source. `CandidateLeafReading`, `VerdictCoversBranches` and `CandidateGroupReading` check these equations. The finite constructors `CoveredLeaf`, `CoveredJoin` and `CoveredGroup` supply their witnesses. Induction on this syntax gives two conclusions together: every recorded leaf has the root answer, and the recorded tree contains exactly the constructed leaf occurrences. The second conclusion does not follow from answer agreement.

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

### VC8

**VC8 (Coverage of a declared tree).** Supply a tree D independently of the certificate C. `CoverageMatchesDeclaration` requires `C.Candidates == D`. Together with VC7, this certifies every occurrence declared in D. It rejects an omitted leaf, a replacement by a foreign leaf, and a repeated leaf in place of another source, even when all their answers coincide.

> Argues: ``CoverageMatchesDeclaration`` needs ``/Notation/Pair``. The computed
> certificate and the independent declaration occupy the comparison's two sides.

The witness `ThreeBeamsCovered` checks the three-beam declaration against the constructed certificate. `Checks/Coverage.swift` separately attempts a missing third beam, a repeated second beam, a false leaf source, an inflated group support and a union that repeats its left support. Each attempt is refused.

D is an ordered tree of occurrences. The test is intentionally stronger than extensional set equality: a permutation or regrouping requires a corresponding declaration or another checked relation. D may itself contain duplicates. The check does not infer a set cardinality, and it does not prohibit duplicates that the declaration actually requests. Defining D as `C.Candidates` would make the comparison automatic and would establish no independent coverage.

M68 reuses this occurrence interpretation for an exhaustion certificate. The existing selection paths now derive a remainder and a stable address through `CandidateRemoval`. Removing one occurrence preserves the other positions, including positions with equal payloads. A complete allocation can therefore assign distinct port identities from declaration positions without assuming distinct payload values. This removes pending coverage obligations, not retained knowledge: the same edge reading can still serve both endpoint proofs. The final inventory comparison must remain tied to the independent declaration.

The interpretation applies to finite expressions of the supplied leaf, join and group constructors. `CandidateReading` is an open interface: a manual conformance can invent support metadata, and a recursive conformance need not be such an expression. The protocol name alone does not certify this grammar. Likewise, matching D does not prove that D accounts for an external domain. This is a coverage obligation, distinct from C1 in Solvability Criterion, which asks whether the rule sought is reachable in the declared encoding closure.

## Detail: §6c. A question can factor through a lossy encoding

The finite tree is one route to completeness. A generic structural proof is another: one derivation can cover a family with no fixed bound on its members' finite sizes. Its premise describes the family instead of enumerating it.

Let K be a candidate domain, E: K → I an encoding, and q: K → A a total question. The following condition says exactly that E retains the distinctions needed by q:

    E(x) = E(y) implies q(x) = q(y), for every x, y in K.

Equivalently, `ker(E) ⊆ ker(q)`, where each kernel is the relation of equal outputs. It is also equivalent to the existence of a function d on E(K) with `q = d ∘ E`. To construct d, assign each observed image the unique q-answer shared by its fiber. The condition makes that assignment well-defined. In the other direction, equal images passed through one function give equal answers. This is a statement about functions on sets, independent of a finite bound.

### VC9

**VC9 (Supplied factorization).** `ReadingFactors` records the square for a source x: an observation E(x), a direct answer q(x), and a decoder answer d(E(x)). Its equations bind the observation's input to x, its output to the decoder's input, and both answer paths to one answer. The two applications share the semantic question and ambient model. Their input representations differ: one takes the source, the other its image.

> Argues: ``ReadingFactors`` needs ``VerdictIsInvariant``. The direct and
> decoded applications must give the same answer in the same question context.

A concrete square is one witness, not a proof for every source. A generic constructor checked under the domain's premises certifies its applications throughout that declared family. One decoder for the whole family additionally requires that its answer depend only on the observed input and retained context. `AlphaFactors<B: BeamShape>` supplies this through `ImageAlphaReading<EyeImage<B>>`: its decoder takes the image alone, and reads its left coordinate. That coordinate equals B's alpha coordinate by expansion. No equality of those answers is requested from the caller. VC21's source-selected counterexample shows why generic pointwise success without this decoder condition is insufficient. `Observation` need not ask q: its question reads the image used to answer q. The application constructors, rather than a shared question label alone, establish the intended operations and their input domains.

`AnswerWithItsEvidence` retains both the answer and the actual observation through that same square. This does not extend the set of source questions recoverable from the observation. M71's `FirstAnswerAndEvidenceOmitSecond` constructs equal answer-and-evidence pairs from arbitrary second fields, while `FirstAnswerRecordRetainsSecond` recovers those fields from an actual source-retaining record. A new question can require refining the image without invalidating the original question's factorization.

### VC10

**VC10 (Shared decoder).** If two factorizations share their actual decoder reading, their direct answers agree. `SharedDecoder` equates that intermediate reading. `AnswersThroughSharedDecoder` then constructs `VerdictIsInvariant` without an additional answer-equality premise. `SharedVisibleImage` supplies the shared reading from equal images through the single constructor `ImageAlphaReading`. Two arbitrary records with the same input and predicate labels are not enough: the lattice has no unrestricted functionality axiom for independently declared records.

> Argues: ``SharedDecoder`` needs ``/Notation/Pair``. The two factorizations have an
> intermediate reading whose equality relates their direct answers.

### VC11

**VC11 (A family without enumeration).** `RedFamilyVerdict<L, R>` derives equal visible readings for any two `RedVisibleBeam` conformers. Only the alpha and beta coordinates are fixed. `RedWithHidden<H>` leaves the infrared coordinate free, so the proof applies to every finite successor depth and imposes no common depth bound. It does not require all `IntegerValued` conformances to be finite. The visible projection does not inspect that coordinate at all. The finite artifact here is the generic derivation, not a list of every source.

The three coverage claims have different premises. VC8 covers an independently declared finite tree. VC11 covers every conformer satisfying a stated generic constraint. Neither establishes that the declaration captures every physical possibility. The optical declarations are a mathematical model, and agreement inside that model does not supply measurement evidence for its adequacy.

This boundary has an established counterpart in database theory: a view can determine a query's answer without supplying a rewrite in a chosen language. Nash, Segoufin and Vianu distinguish semantic determinacy from such rewritings in [Views and Queries: Determinacy and Rewriting](https://dbucsd.github.io/paperpdfs/2010_3.pdf) (2010). Thus the kernel criterion alone does not provide a computable or language-definable decoder in an arbitrary setting. The supplied Swift constructor is an explicit witness for this particular fragment. No new priority is claimed for the factorization theorem.

For the identity question `q(x) = x`, the kernel criterion requires E to be injective. Identification is therefore the limiting case that retains every source distinction. A less discriminating question can require less. Seeing Is Encoding and Colour Is a Quotient supply the loss, while Verdict Is Invariant states when that loss is harmless for the question actually asked.

**A complete reading also determines its relation to the source.** Suppose E:K→I has a supplied decoder d:E(K)→K with d(E(x))=x. Restrict the recorded source-image pair to its actual graph G={(x,E(x)):x∈K}. Reading its image by p(x,E(x))=E(x) has the inverse j(i)=(d(i),i). Indeed p(j(i))=i, and j(p(x,E(x)))=(x,E(x)). Consequently any specified total question H on G factors as H=(H∘j)∘p. The same image suffices to answer a question about this source-image relation. No second acquisition or extra source is required by that factorization. This uses the actual graph and the given recovery law, rather than accepting every pair with the same record shape.

The smallest nonconstant instance has G={(0,0),(1,1)}. Either coordinate determines the pair, including the fact that the two readings agree. On the enlarged domain {0,1}² the same coordinate fails: (0,0) and (1,0) have the same second reading and different first readings. Agreement and source recovery must therefore come from the admitted relation. Repeating an unsupported assertion does not create them, as VC23's ZeroInputClaimTail demonstrates. Self-inclusion of the question alone does not force an infinite sequence of new readings. An implemented decoder and its acquisition remain distinct obligations, and this argument classifies recovery rather than feeling or universal self-verification.

AnswerWithItsEvidence<F> supplies a more general static construction: any established factorization q=d∘E also determines (q(x),E(x)) through the same E. It joins F's actual decoder to an identity reading of the evidence by the existing JointEvidenceFromMemory and QuestionOnObservation. Checks/ClosedInformation.swift derives both the unchanged observation and the paired answer for every admitted F. The identity-question instance recovers the source-image graph. The existing repeated-evidence recovery cycle separately supplies the diagonal return. No additional source-reading premise, final-answer equality or consciousness marker enters these constructions.

The source scope is unchanged. If performing a further reading changes the represented whole, a question about that new occurrence must include its transition or acquired evidence. VC12 does not infer such a question from an old factorization alone. Similarly, H must be a specified total question on G: a demand for a Boolean answer equal to its own negation has no such reading. Source recovery supplies neither a universal truth predicate nor an automatic certificate of every future state. These limits concern the proposed questions, without requiring an exterior observer.

**Exact source recovery does not make the record a duplicate performer.** Let K={a,b} and I={m_a,m_b} be disjoint addressed carriers, with E(a)=m_a, E(b)=m_b and d their inverse. Then dE=id_K. Every specified source question q can be read as q∘d from the image. That equation concerns the source after decoding. It does not assert that the record has the source's properties when assessed in its own role, or that m_a is the occurrence a.

The distinction has a finite dynamic test. Let the source step U exchange a and b while the image step V is identity. Recovery of the recorded source remains exact, but E(U(a))=m_b differs from V(E(a))=m_a. The same code can answer the specified question U about its recorded source through U∘d, although the record's own evolution does not perform that step. Tracking the changing source through that same encoding would additionally require EU=VE. This example does not satisfy that stronger contract. It separates recovery, prediction of a specified step and a dynamically matching realization, without an appeal to a physical copying law. A question about whether source and record are jointly experienced requires its actual occurrence relation. The decoding equation supplies no such identification.

`PassiveCompleteRecord<A,B>` in the existing whole checks constructs this separation from RetainedWhole, projection, swap and identity readings. Its generic equality derives complete source recovery and the swapped answer from the record alone. The zero/one source gives different first fields in the unchanged record and the record required after the source swap. A positive zero/successor boundary exposes that difference, and the attempted transport equality is rejected. These are static relations of actual constructor fields, without a runtime model or a new public proof marker.

**Even exact tracking does not identify which relation drives the working answer.** The passive-record example fails EU=VE. A stronger ambiguity remains when the record tracks every normal update correctly, including all the available retained history. Let x=(a,b) be a working pair, m another pair, and h an internal remainder. Let s exchange the two pair roles, so s²=id. Consider two proposed contacts on this same addressed state interface:

    D(x,m,h) = (s(x),s(x),(m,h)),
    F(x,m,h) = (s(m),s(m),(x,h)).

Both contacts are injective on this represented family. From an output (y,y,(r,h)), D's inverse recovers (s(y),r,h), and F's inverse recovers (r,s(y),h). The unused input for the *working-answer* calculation is retained in the actual remainder. It is not deleted from the whole or causally irrelevant to every output reading.

The two laws can also be sectors of one internally controlled contact: retain a mode k∈{D,F} and apply (k,x,m,h)↦(k,k(x,m,h)), where k selects its displayed formula. Equality of complete outputs first fixes k and then the corresponding inverse fixes all remaining inputs, so this one contact is injective. The observation in the following experiment exposes the three state fields, not the mode. Its inverse can use the retained mode; the experimenter does not get that access for free. No external law selector is required.

On the faithfully tracking family m=x, the two contacts give exactly the same interface result (s(x),s(x),(x,h)). That result again belongs to the tracking family. Induction therefore gives the same sequence of working pairs, current records and remainders for every finite normal continuation from the same preparation. Reading any of those fields during such a continuation cannot distinguish the two laws. This is an equality on the stated interface, not identity of hidden implementations or of every physical form in reality. There is no claim that an unavailable inspection of the implementation also agrees.

The same induction permits arbitrary shared interventions that map the tracking family into itself and have the same addressed action in both candidates. No such intervention reveals the off-family dependency. If that tracking family is the entire admitted state domain and all available contacts remain in it, D and F are literally the same restricted operation. Their different formulas on excluded pairs do not supply an additional operational distinction there. The broader two-law inquiry is justified only when its enlarged domain or a distinguishing contact is part of the admitted scope. Failure to have acquired such a contact is not a proof that none exists anywhere in the whole.

Nevertheless the working answer of D depends on x, and that of F on m. An actual internal perturbation can distinguish the roles. Supply J(x,m,h)=(x,s(m),h). It is its own inverse and changes only the second pair. Also retain the initial working pair x in a reference field of the preparation, by taking the old remainder as (x,h₀). This reference is inside the same represented carrier and is not an absolute naming scheme. Starting with m=x, the next working outputs after J are

    D: s(x),     F: x.

The original reference remains at the same retained path in both outputs. Comparing the result with that actual reference distinguishes return from crossing whenever a≠b. The same test fails when a=b; then J has changed no relevant distinction. The reference preparation, perturbing contact and comparison access are the supplied resources. The code does not acquire them by naming an observer.

Thus no number of normal tracking observations identifies the acting dependency within this two-law family, whereas one use of the unknown contact after this perturbation does. This is not a one-probe theorem for all unknown mechanisms. Adding other candidate laws or refusing J changes the inquiry. A deterministic procedure based only on the equal normal transcripts has the same input in both cases and cannot produce different correct law identifications; the perturbation supplies the missing distinction through the existing continuation criterion.

The result is relational also in its choice of roles. Exchanging x and m conjugates D to F and exchanges perturbing the record with perturbing the working pair. A written label “self-model” does not break that symmetry. In the proposed test the actual changed role, retained reference and subsequent working reading are held together. A common renaming of those roles preserves return versus crossing. It is their relation, rather than an intrinsically privileged register, that makes the question determinate.

Nor can preservation alone define a useful binary property “uses the record.” For any injective full contact U, two different inputs have different full outputs. Hence every input contrast in its admitted scope remains a contrast somewhere in the full result. D preserves m in its remainder even though its next working pair does not depend on m. F makes that working pair depend on m and preserves x elsewhere. To ask which distinction controls an action, specify the input changes and output reading. Whole-source recoverability is compatible with both dependencies. Conversely, removing an explicit duplicate field from a description does not by itself remove its recovered reading or a physically situated participant.

`SelfRecordUse` constructs these contacts from the existing pair swap, actual projections and retained fields. `FaithfulSelfRecordStep` derives same-result equality without assuming it as a conclusion. The same returned tracking relation supplies the induction above. `RestoreWorkingDriven` and `RestoreRecordDriven` read only their actual output, not an original-source parameter supplied again by the checker. `SelfRecordProbe` composes the real perturbation with both candidate contacts and reads the retained preparation reference. Seven positive declarations check tracking, another iteration, both full input recoveries, perturbation reversal, the distinguishing reference relations and the degenerate non-distinguishing preparation. Refusals reject carrying normal agreement through the perturbation and applying the unperturbed advance to its changed source. They are source and answer relations, not labels for causal power or consciousness.

This makes one part of The Cut's question independently testable: does a purported self-record only agree with the working process, or does the declared working continuation depend on it under the specified internal changes? Agreement, tracking and operative use are different obligations. Neither D nor F has been assigned an absence or presence of experience. An identification between an experienced occurrence and one such organization would need the correspondence that the operational comparison does not supply.

**Transport needs the orbit of the question, not automatically a whole frame.** The probe above is meaningful only when its contact is actually available. M25, VC30–VC31 and LQ14–LQ15 already distinguish that obligation from mere compatibility of a proposed operation. An independent intervention suggests a more specific question: what must an internal movement record retain for the *next* target to remain readable?

[Sommer and Wurtz (2002)](https://www.yorku.ca/jdc/documents/SommerWurtz2002_Science_April11_2013.pdf) recorded an ascending pathway and reversibly inactivated its thalamic relay while macaques made two saccades to previously flashed targets in darkness. Second endpoints shifted in the predicted direction in 18 of 22 cases; first movements and single-saccade controls showed much smaller effects. These are measured statistical comparisons, not exact preservation equations. The methods explicitly leave possible effects on adjacent neurons open. The authors study correlates of commands, not necessarily exact copies, and leave the pathway's contribution to stable perception for further work. The experiment therefore supplies a real intervention and selective behavioral evidence; it does not establish the ideal record-only probe, a complete movement decoder, or a condition for experience used in this paper.

Here is an exact, separate relational problem. Let a group G act on a set X, and let g map positions in one internal frame to positions in another retained frame. For a specified target t in the latter, the required position in the former is

    q_t(g) = g⁻¹t.

The represented source family is all g∈G; the action and the target are supplied relations. A command record is sufficient precisely when q_t is constant on each of its source fibers. Knowing the command that preceded a movement does not by itself supply the actual g: possible differences between the command and its effect must preserve this particular answer or be resolved by other evidence.

Write H={h∈G:ht=t}. Directly,

    q_t(g)=q_t(v)  iff  v g⁻¹∈H  iff  v∈H g.

Thus the current answer identifies the set H g, not necessarily g. No smaller uncertainty about the complete action is required for this one target. Conversely, if H is trivial, this one target already identifies g. A task-relative formulation does not guarantee that the task is cheaper than complete identification.

Now supply a known contact k. Two actual composition contracts differ:

    g ↦ g k:   q_t(g k)=k⁻¹q_t(g);
    g ↦ k g:   q_t(k g)=g⁻¹(k⁻¹t).

The first always updates the current answer from itself and k. The second may require the former position of a different target. Its answer factors through q_t on all G if and only if every h∈H fixes k⁻¹t, equivalently

    H ⊆ k⁻¹ H k.

Indeed two sources in one current fiber have the form g and h g. Their answers after left multiplication agree exactly when h⁻¹k⁻¹t=k⁻¹t. Varying h over H proves both necessity and sufficiency. If both k and k⁻¹ must descend to the current answer, the condition is equality k⁻¹Hk=H. Equality must not replace inclusion for an arbitrary single forward contact on an infinite group.

A four-position witness uses G=S₄ acting on {a,b,c,d}. Take g=id, v=(b c), and k=(a b). Both current answers to t=a are a. After left multiplication by k they are b and c. After right multiplication by k both are b. Every operation is a permutation of the same finite carrier; no information has been lost globally. The old answer omits a relation needed by one permitted continuation.

**The least reusable refinement is determined by available contacts.** Let K≤G be the subgroup generated by the actually admitted reversible left contacts, including their inverses. Keep the target orbit O=K t and the addressed profile

    R_O(g) = (g⁻¹z) indexed by z∈O.

It recovers q_t and has an explicit update for every k∈K:

    R_O(k g)[z] = R_O(g)[k⁻¹z].

Since k⁻¹z belongs to O, the update receives only the retained profile and the known contact. The complete g does not enter its decoder.

This profile is the coarsest sufficient refinement in the information order. Suppose E permits q_t after every finite admitted contact word. Then for every k∈K it determines q_t(k g)=g⁻¹(k⁻¹t). These questions range over every z∈O. Hence E(g)=E(v) implies R_O(g)=R_O(v). Conversely the displayed update and the coordinate t answer every such continuation. This proves minimality without enumerating states or assigning the desired conclusion as a protocol constraint. An arbitrary infinite profile is a semantic object; the statement does not promise a finite representation or an effective universal decoder. For a finite addressed orbit it is a finite tuple with these updates.

For K generated only by (a b), the required profile is the pair (g⁻¹a,g⁻¹b). It exchanges its two actual fields on each contact, and is still unable to distinguish id from (c d). Thus it is reusable for the admitted target orbit while the complete movement remains unknown. If the accessible orbit is all X, the profile determines the whole permutation action. For a faithful action that determines g itself; otherwise differences in the action's kernel remain indistinguishable. The amount of information forced by reuse therefore depends on the contact family, not only on the current question.

These are relative frames inside the represented system. Under a joint renaming g′=a g b⁻¹ and t′=a t, the answer becomes q′=b q. Left contact k becomes a k a⁻¹; right contact k becomes b k b⁻¹. The distinction between the two interfaces survives that common change of coordinates. Writing k g=g(g⁻¹k g) does not make the left interface free to use the right-interface decoder: its new command g⁻¹k g may contain the very unknown action that the record did not determine. The four-position witness rules out that shortcut using the current answer alone.

The difference between a harmless frame choice and missing contact information can itself be stated without an external reference. On G×X, the diagonal change (g,t)↦(a g,a t) leaves g⁻¹t unchanged. Conversely if g⁻¹t=v⁻¹s, the choice a=v g⁻¹ satisfies (v,s)=(a g,a t). Thus this relative target is a complete invariant of that diagonal frame freedom. But when a subsequent left contact k is part of the question, it too must change to a k a⁻¹. Keeping k unchanged while changing only (g,t) need not preserve the joint situation. On the full triple the relative command is u=g⁻¹k g, and the next target is u⁻¹q_t(g). This identifies exactly where the omitted relation enters. It does not require acquiring all of u when the target-orbit profile already suffices for the declared family. Nor does it turn the whole's lack of an external position into an inability to distinguish internal movements.

The intervention above does not demonstrate this particular group model or its noncommutative obstruction. In an abelian group the two products coincide. What it motivates independently is keeping the movement, its record, the remembered target and the next contact as separate linked relations. To transfer these exact conclusions to an experiment, those action and reading relations need their own evidence. A signal correlated with a command does not establish them by name.

`TargetFrameTransport` is the finite constructor witness. A record (A,(B,R)) holds two addressed target preimages and other fields. The source contact gives (B,(A,R)); the observation retains (A,B); its decoder exchanges the actual retained fields. `TargetFrameTransport<S>` derives equality of the entire observed source result and the updated memory without requiring that equality from the caller. Another composition reads the next target from the updated memory alone. The other fields remain unknown to that decoder. The source constructor also retains them and has an explicit reverse.

Five positive declarations check the commuting pair, subsequent target, source reversal, independence from omitted fields, and equal current answers in the separating example. Two refusals reject the asserted next-answer equality and a decoder fed a pair from a different source. These checks establish the finite field relations. The general orbit minimality is the proof above, an instance of the existing continuation criterion, rather than a new unverified marker for physical remapping.

A finite proof basis and a finite atom basis are different objects. VC11 does not generate every hidden source from a finite family of domain operations. It proves a question independent of that coordinate. VC9 is less degenerate: its answer varies with the visible alpha level, yet one generic derivation covers them all. A saturation experiment must declare its questions in advance, otherwise a constant question could make any domain appear complete. Reusing a derivation also does not make application free: constructing an instance and checking its constraints still have a cost. This section does not infer zero marginal execution cost from finite proof size.

## Detail: §6d. Today's invariant need not survive an operation

### VC12

**VC12 (Boundary under change).** The condition `ker(E) ⊆ ker(q)` answers q on the current source. To answer after an operation T: K → K, the required condition is `ker(E) ⊆ ker(q ∘ T)`. The first condition does not imply the second. An operation may expose exactly the coordinate E discarded.

`ExposeHidden<B>` is a symbolic coordinate transformation: its alpha output is B's infrared coordinate. It is not a physical conversion law. `RedBeam` and `RedBeamWithIR` have equal current visible images, while their transformed visible images differ. The attempted invariant certificate for those outputs is refused in `Checks/Coverage.swift`. Equality of current observations does not justify reuse of a verdict across an arbitrary operation.

One sufficient condition for safe propagation is a supplied operation on images, T̄, such that `E ∘ T = T̄ ∘ E`. If also `q = d ∘ E`, then `q ∘ T = d ∘ T̄ ∘ E`, so the original image suffices for the later answer. For a family of such operations, composition proves the same result for every finite sequence. Closure of an operation vocabulary under composition alone is insufficient: the commuting equations are the additional obligation. The positive witness is `SwapFactors<B>`: swapping a beam's visible coordinates and then observing gives the same image as swapping the already observed pair. It uses `ReadingFactors` for the future question without adding a new protocol. `SharedSwappedImage` and `AnswersThroughSharedDecoder` derive agreement after this operation from agreement of the current images. Both transformations here are symbolic coordinate models. The general finite-composition argument is mathematical here. Section 6e supplies the generic finite-path certificate.

This suggests a sharper research target for saturation. Fix a question family Q and an operation vocabulary O. Form all future questions `q ∘ w`, where q belongs to Q and w is any finite operation sequence, including the empty sequence. Declare two sources equivalent exactly when every such question agrees. That relation is preserved by each operation in O: prefixing one more operation still gives a permitted finite sequence. Adding questions or operations can split its equivalence classes, so the vocabulary and its revision are part of the claim.

A finite basis of proofs can certify sufficient observations for some such closures without identifying every source. VC44 supplies one generic coordinate instance. Existence of such a basis in every case remains unproved and does not follow from finite syntax. It connects the paper's invariant verdict to Basis Is Residue through an explicit obligation: preserve what the permitted future questions can read. A declaration that erases a distinction today must account for operations that could reveal it tomorrow.

For finite deterministic machines and an acceptance question, equivalence under every future input sequence is the familiar state equivalence used in DFA minimization, described in the [Cornell CS 4120 notes](https://www.cs.cornell.edu/courses/cs4120/2026sp/notes/leximpl/#dfa-minimization). The comparison locates this proposal within an existing construction. It does not assert a new automata-minimization theorem or infer finiteness of K.

Even a finite question and operation vocabulary can require infinitely many behavioral classes. Let K be the natural numbers, let the one operation be predecessor with zero fixed, and let the one question ask whether the state is zero. For m < n, applying predecessor m times gives different answers: m reaches zero and n does not. Every two distinct states are distinguishable by some finite sequence. Thus neither a finite signature nor a finite current answer set guarantees a finite quotient under all future observations. A finite proof description, a finite set of observable classes, and a finite generation basis must be measured separately.

## Detail: §6e. A finite proof for every constructed action path

### VC13

**VC13 (One commuting step).** An `ObservedTransition` declares an operation between two applications of the same observation in one space and encoding. Write those applications as `x → E(x)` and `y → E(y)`. A `CommutingTransition` additionally supplies two applications of its operation: `x → y` on sources and `E(x) → E(y)` on images. Four endpoint equations bind these applications to the observation records. The operation labels and ambient contexts must agree too. Thus the observed result can be calculated along either side of the square.

> Argues: ``ObservedTransition`` needs ``/Notation/Pair``. Its sides are the before and
> after observation records whose contexts must agree.

> Argues: ``ObservedTransition`` needs ``HasEncoding``. Both observations and
> the operation applications are situated in the declared space and encoding.

> Argues: ``CommutingTransition`` needs ``ObservedTransition``. The source and
> image steps must connect the actual endpoints of that observed transition.

The equations certify supplied applications. They do not turn every record bearing an operation name into a correctly implemented function. In the worked constructors, the source and image functions are explicit type expressions. `SwapTransition<B>` exchanges alpha and beta along both paths. `ForgetTransition<B>` erases the hidden coordinate on the source path and uses the identity on the image path. These are symbolic transformations of the coordinate model, with no new optical or physical erasure law asserted.

### VC14

**VC14 (Composition without another output premise).** Let F and G be commuting steps with `F.Right == G.Left`: the same intermediate observation record, including its actual source. `JoinedTransition<F, G>` composes their source applications and their image applications using `SequentialReading`. The compiler derives the intermediate input/output equalities on both paths from the shared observation. It also derives the final square from the two inner squares. The constructor does not request that final equality from its caller.

The composed operation is the ordered expression `OperationSequence<F.Operation, G.Operation>`. This theorem does not say that F and G commute with each other. It says each source execution agrees with its image execution. An `IdentityTransition<R>` supplies the empty path for any observation R. Induction on finite constructor expressions now gives a certificate for every well-typed finite path made of certified steps. `AppendSwap<P, B>` names `JoinedTransition<P, SwapTransition<B>>` under its matching-endpoint premise. It is that composition, with no separate wrapper type and no enumeration of P's length or structure. Parenthesizations and inserted identity steps remain distinct type expressions. These proofs establish endpoint laws, not a normalization that equates every nominal spelling of a path.

Agreement of intermediate images alone is insufficient for this particular constructor. A step that ends at x and one that begins at a distinct y do not form an actual source execution, even if E(x) = E(y). `STEP_MIDDLE` probes that boundary. A path in a quotient could use representatives differently, but that requires its own well-defined quotient construction, as in VC15. This constructor must not silently substitute a representative and invent a source history.

The worked path swaps, erases the hidden coordinate, then swaps again. `RoundTripImageFollows<B>` derives the original visible image for every B. `STEP_INVERSE` separately refuses equality of the original and final infrared coordinates for a beam with infrared. An observed round trip is not an inverse on the source. Erasing the current representation also does not refute the book's commitment to a permanent historical record: these are different objects.

The repeatable compiler audit adds isolated mutations of both source endpoints, both image endpoints, the operation, the context, the observation question, the intermediate source, and the proposed inverse. A proposed image-only implementation of hidden exposure fails too. The metameric counterexample in §6d supplies the mathematical reason no deterministic decoder of that image can implement exposure on the whole class, beyond this one failed proposal. As before, induction concerns the finite constructor grammar. Open protocol conformance alone does not prove a path finite or its declared applications true.

## Detail: §6f. Objects determined by possible actions

Here the stronger interpretation is made precise enough to be refused. Fix a carrier K, a family Q of total observations, and a family O of total operations K → K. The carrier is a premise. Nothing below derives its physical existence. For finite words w over O, including the empty word, define

    x ≈ y exactly when q(w(x)) = q(w(y)) for every q in Q and every w.

### VC15

**VC15 (The coarsest compatible object relation).** This is the greatest equivalence relation that preserves every observation in Q and is preserved by every operation in O.

*Proof.* Each future observation supplies a kernel equivalence, so their intersection is an equivalence. The empty word ensures current observations agree. If x ≈ y, then T(x) ≈ T(y) for every T in O: putting T before any finite continuation still gives an allowed word. Conversely, let R preserve Q and be preserved by O. Induction on words gives `x R y ⇒ w(x) R w(y)`, and preservation of Q then gives every required answer equality. Hence R ⊆ ≈.

The quotient K/≈ therefore carries well-defined operations `[x] → [T(x)]` and observations `[x] → q(x)`. Call its classes the operational objects for this declaration. A representation E that answers every permitted future question must satisfy `ker(E) ⊆ ≈`. It consequently maps onto the operational objects by `E(x) → [x]`. This is a precise sense in which the quotient is the least information sufficient for those questions. The quotient may be infinite, and its definition alone supplies no finite or computable presentation.

**Corollary (two complete reduced descriptions have one source-bound correspondence).** Keep the source K, questions Q and operations O of VC15 fixed. Let E:K→I and F:K→J be two descriptions, restricted to their actual images. Require each to answer every q after every finite allowed word. Require also that any two distinct image values differ on at least one such answer: the description carries no further distinction invisible to this entire family. These are sufficiency and separation requirements, not a demand that the two notations already agree.

Then there is exactly one bijection h:I→J satisfying h(E(x))=F(x) for every source x. Indeed, sufficiency gives E(x)=E(y) ⇒ x≈y. Separation gives the converse: if x≈y, no permitted answer can separate their images, so the images agree. The same argument holds for F. Thus both kernels are exactly ≈. Define h(E(x))=F(x). Equal E-images have equal F-images, so this is well-defined; reversing the roles gives its inverse. Every image comes from a source, so the displayed equation leaves no second correspondence available.

The correspondence also preserves each question and conjugates the induced operations: h(T_I(i))=T_J(h(i)). Take i=E(x); both sides equal F(T(x)). Consequently, two complete reduced descriptions of this declared behavior cannot disagree about a continuation while still meeting the requirements. They describe one object up to the unique correspondence tied to their common source. The proof uses no minimum cardinality: equal-sized infinite images can still differ by redundant distinctions. Nor does it identify two nominal expressions or their physical carriers.

Three attempted stronger conclusions fail. Without separation, F can retain an additional source distinction that E omits, even though both answer every permitted question. Without the source bindings, the surviving object can have automorphisms, leaving several abstract correspondences as in VI1. With only current answers preserved, a continuation can expose an omitted distinction as in VC12 and VC16. For partial operations, refusals must also be retained; VC46–VC47 provide the domain obligation. One cannot apply the total-operation argument to successful partial outputs alone.

This is a consequence of VC15, not a further selection law for reality. Applied to The Cut's Step 3, it explains precisely how two proposed descriptions can collapse to one relational account. The family of actual internal distinctions and continuations must be justified before claiming completeness for the whole. Q names the distinctions being registered; it does not supply an observer outside K's containing reality. Agreement within a restricted family does not erase distinctions carried elsewhere in that whole.

This construction belongs to established behavioral semantics. Rutten's [Universal Coalgebra: A Theory of Systems](https://ir.cwi.nl/pub/48/) (2000) develops systems, behavior-preserving maps and bisimulation as a counterpart to algebraic construction. Here the argument is restricted to deterministic total operations and observations. No equivalence with a chosen notion of bisimulation for nondeterministic, probabilistic or concurrent systems is inferred. The VI construction supplies the certificate path for these stated operations.

### VC16

**VC16 (An added capability can split an object).** If Q or O is enlarged while K is fixed, the new equivalence is contained in the old one. Every old test remains a permitted test. Thus the new quotient maps onto the old quotient, while a map in the reverse direction need not be determined.

In the binary-coordinate beam model, K has eight triples `(alpha, beta, hidden)`. Let Q read the visible pair, and let O contain swap and hidden erasure. Equal visible pairs remain equal after either operation, and differing visible pairs are separated by the empty word. The operational objects are exactly the four visible pairs. Add hidden exposure to O. A current observation reads alpha and beta, while an observation after exposure reads hidden. Every distinct triple is now separated, so the quotient has eight classes. The source carrier did not change. The permitted distinctions did.

The radical reading is that a system's object vocabulary depends on its possible actions, including future experiments. This is an interpretation of the quotient construction, not a proof that physical entities are created by granting a permission. The Cut's quantifier over anything any process could register is stronger than a particular system's currently declared capabilities. A bounded VI declaration must name that boundary instead of silently claiming the global quantifier. Existing certificates continue to certify their original vocabulary. They do not acquire the new action without another witness.

### VC17

**VC17 (Unrestricted action forces identification).** Let K be finite and let Q contain a nonconstant observation q. If O contains every total map K → K, then ≈ is equality. Thus any representation sufficient for all such future observations must be injective.

*Proof.* Choose u and v with q(u) ≠ q(v). For any distinct x and y, one of the allowed operations sends x to u and y to v, with arbitrary outputs elsewhere. The observation after that operation distinguishes x and y. This works for every pair. Conversely, an injective representation determines the source and therefore every future answer, at the level of functions on this finite set.

The nonconstant-observation premise matters. If every q is constant on K, all sources remain equivalent even under every operation. Also, all maps is a substantial capability assumption, not a consequence of finite syntax. The theorem recovers identification as the price of an unrestricted future vocabulary. Useful compression is possible when the permitted distinctions have a boundary. It does not establish that the physical universe permits all maps, or that constructing and executing their representations is cheap. For a closed whole, controls are internal states. This quantification over a family of operations is not an external agent choosing the laws of Ω. A non-injective operation here can describe a subsystem. Its realization under global preservation requires an internal residual (PiR M29–M35).

### VC18

**VC18 (More information need not preserve execution closure).** Two properties must be distinguished. A representation can determine every answer to the chosen future questions. It can also support its own next representation via an image operation satisfying `E ∘ T = T̄ ∘ E`. The latter asks more: all the coordinates of E must be updatable from E. Adding information preserves the first property, but can destroy the second.

For a direct coordinate counterexample, take `T(a, b, h) = (a, h, h)`. The representation E1(a, b, h) = a executes by the identity: alpha never changes. The richer E2(a, b, h) = (a, b) does not execute by itself. Two equal current visible pairs with different h have different next visible pairs. The complete triple E3 executes again. `AlphaSurvivesExposure<B>` proves preservation of the small observation generically, while `STEP_RICHER_IMAGE` refuses agreement of the larger output for the metameric pair. Its old alpha answer is still exact.

The following four-state counterexample separates record refinement from dynamic closure:

| source | smaller record | richer record | next source |
|---|---|---|---|
| 00 | 0 | 0 | 00 |
| 01 | 0 | 1 | 01 |
| 10 | 1 | 2 | 00 |
| 11 | 1 | 2 | 01 |

The smaller record always transitions to 0. The richer record 2 would need to transition both to 0 and to 1. It still contains the smaller record, so every old future answer remains available. An extra coordinate can create a new obligation without supplying what is needed to discharge it. This is a concrete reason to evaluate saturation by closed questions and operations, rather than by the count of recorded features or claims alone.

### VC19

**VC19 (Operational identity can exceed symmetry).** In the eight-beam model with visible observation, swap and hidden erasure, the two hidden values within one visible pair are operationally equivalent. They need not be related by an automorphism of the labeled source system. Erasure fixes the source whose hidden coordinate is zero and does not fix the one whose hidden coordinate is one. An automorphism commuting with erasure must preserve that fixed-point property, so it cannot exchange these two sources. In fact, preserving the visible labels and erasure forces every source to be fixed, and the only such automorphism is identity.

Thus a quotient by behavior can identify more sources than the symmetry orbits of the underlying transition system. VI1 remains scoped to admissible exact birth isomorphisms, which form its torsor. Those isomorphisms are a different candidate class from the sources here. Extending the word symmetry to every operational ambiguity would lose the distinction demonstrated by this model.

**Type representation.** The generic step-square constructors and their finite compositions express the commuting relations. Constructing the coarsest quotient for an arbitrary operation family requires an additional constructor. The maximality argument above is mathematical and independent of a finite enumeration.

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__coordination_blocks#LQ14>, <doc:learning_is_liquid__coordination_blocks#LQ15>, <doc:permanence_is_resistance__cost#M25>, <doc:permanence_is_resistance__records_entropy#M29>, <doc:permanence_is_resistance__records_entropy#M35>, <doc:permanence_is_resistance__physical_models#M68>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__recovery_memory#VC21>, <doc:verdict_is_invariant__recovery_memory#VC23>, <doc:verdict_is_invariant__discovery_acquisition#VC30>, <doc:verdict_is_invariant__discovery_acquisition#VC31>, <doc:verdict_is_invariant__reusable_images#VC44>, <doc:verdict_is_invariant__reusable_images#VC46>, <doc:verdict_is_invariant__reusable_images#VC47>, <doc:verdict_is_invariant#VI1>.

Mentions of this page’s labels: <doc:interference_is_substitution__global_obstructions> (VC15), <doc:interference_is_substitution__global_obstructions> (VC9), <doc:interference_is_substitution__models_calibration> (VC15), <doc:interference_is_substitution__positive_channels> (VC15), <doc:learning_is_liquid> (VC15), <doc:learning_is_liquid__atoms_continuations> (VC15), <doc:learning_is_liquid__coordination_blocks> (VC15), <doc:learning_is_liquid__medium_contacts> (VC15), <doc:learning_is_liquid__medium_contacts> (VC9), <doc:learning_is_liquid__reconstructed_sides> (VC15), <doc:permanence_is_resistance__cost> (VC15), <doc:permanence_is_resistance__forced_answers> (VC15), <doc:permanence_is_resistance__forced_answers> (VC9), <doc:permanence_is_resistance__frame_acquisition> (VC12), <doc:permanence_is_resistance__records_entropy> (VC15), <doc:permanence_is_resistance__records_entropy> (VC18), <doc:permanence_is_resistance__retention> (VC18), <doc:permanence_is_resistance__reusable_requests> (VC15), <doc:permanence_is_resistance__uniform_routing> (VC15), <doc:verdict_is_invariant> (VC1), <doc:verdict_is_invariant> (VC12), <doc:verdict_is_invariant> (VC15), <doc:verdict_is_invariant> (VC9), <doc:verdict_is_invariant__bounded_calibration> (VC12), <doc:verdict_is_invariant__discovery_acquisition> (VC15), <doc:verdict_is_invariant__discovery_acquisition> (VC2), <doc:verdict_is_invariant__finite_policies> (VC19), <doc:verdict_is_invariant__recovery_memory> (VC10), <doc:verdict_is_invariant__recovery_memory> (VC13), <doc:verdict_is_invariant__recovery_memory> (VC15), <doc:verdict_is_invariant__recovery_memory> (VC16), <doc:verdict_is_invariant__recovery_memory> (VC5), <doc:verdict_is_invariant__recovery_memory> (VC9), <doc:verdict_is_invariant__relative_questions> (VC9), <doc:verdict_is_invariant__reusable_images> (VC15).
