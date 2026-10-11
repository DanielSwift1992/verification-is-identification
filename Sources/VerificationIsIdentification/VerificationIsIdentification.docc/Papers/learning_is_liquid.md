# Learning Is Liquid (Phase)

Learning changes what a system can distinguish and use. A retained record, a newly excluded possibility and a cheaper computation are three different changes. A successful computation can make none of them: it can reproduce an answer already certified. This paper separates these changes and gives a condition under which repeated observations settle a question.

The liquid/crystal language in §§0–6 describes unresolved and certified regions of a declared task domain. Retention makes a certified region monotone only while its questions, model, keys and interpretation remain fixed. Progress additionally requires observations that separate the remaining alternatives. Neither continued activity nor a finite domain supplies those observations by itself. Sections 6a–6e ask a different question: what constitutes the state of a medium whose own admissible forms and rearrangements can change? They derive contact boundaries, necessary coordination scales and conditions under which an internal relation determines a decomposition. The conditions enter before assigning physical phase names.

## §0. Setting

Fix a finite nonempty candidate set K, an actual candidate x ∈ K, a question q: K → A, and a finite vocabulary of static total queries f_i. A sound cache G records keyed answers f_i(x). Its compatible set is B_G = {y ∈ K: f_i(y) = G(i) for every cached key i}. Soundness keeps x in B_G. The question is settled when q is constant on B_G, even if several candidates remain.

A retaining update preserves old keyed answers and may add new ones. These premises describe an inference interface. They do not assert that the whole is a finite query table, that every interaction is nondisturbing, or that physical memory grows without bound. If an interaction changes the target, its state transition and the question about the original state must be included, as in Verdict VC30–VC34.

Within The Cut's commitment to one whole, source, observer, memory and query mechanism all belong to that whole. Alternatives in K describe what the observer has not distinguished. They are not additional realities outside it. A mathematical description of the whole is also not an observation automatically available to a participant.

## §1. What Can Saturate

**LQ1 (An infinite table differs from a finite generative description).** Explicitly listing infinitely many distinct answers never finishes in finite time and storage. A finite program or certified generator set can nevertheless describe an infinite family, and a finite cache can serve a useful subset. These are different completion criteria (Basis B6–B8).

Infinite reach alone does not prove that a learner lacks a complete generative description or must search anew for every answer. The phase analogy needs a declared criterion: table coverage, rule coverage, derivability, or usable access within a cost bound. No claim that the liquid phase is generic follows from cardinality alone.

**LQ2 (Resolution has a domain).** For a fixed family Q of questions, define R_G = {q ∈ Q: q is constant on B_G}. Sound retaining updates give B_G′ ⊆ B_G and hence R_G ⊆ R_G′. A scalar such as |R_G|/|Q|, when Q is finite and nonempty, discards which questions are resolved. A domain-indexed description retains that information.

*Proof.* A function constant on a set is constant on each nonempty subset. Soundness guarantees nonemptiness here. No metric or arrival distribution is needed. To predict which region resolves first, supply the query policy and its costs. Covering numbers alone do not determine arrival times. The coupon-collector law in IiI §6 additionally assumes independent uniform arrivals and successful retention.

## §2. Records, Certificates and Progress

**LQ3 (The new-record bound is relative to prior knowledge).** Let cert_G(x, q) be the smallest number of distinct uncached query keys whose actual answers, added to G, settle q. Set it to ∞ if the available keys cannot do so. If an episode settles q after m query calls and retains d distinct new keyed answers, then:

```
cert_G(x, q) ≤ d ≤ m.
```

*Proof.* The d new answers form a sufficient extension of G, so their size is at least the minimum. Each call supplies at most one keyed answer in this model. Repeated keys contribute no additional record. The lower bound is zero when G already settles q. For an empty cache it becomes the usual instance-certificate bound, provided all relevant prior constraints are included in K.

This is certificate complexity conditioned on an initial compatible set, not an optimal policy theorem. A certificate chosen with knowledge of x need not be discoverable at that cost by a policy that must work for every x. The standard distinction between certificates and decision trees is described by [Buhrman and de Wolf, §4.1](https://homepages.cwi.nl/~rdewolf/publ/qc/dectree.pdf).

A new record need not remove a candidate. Let K contain the four bit pairs (a, b), let q = b, and suppose G records a = 0. Querying a AND b returns 0 and adds a distinct key, but B_G remains {00, 01}. The answer to b is still open. Conversely, q = a is already settled without reading b. Neither full feature coverage nor positive new-record growth is necessary for a certified answer.

**LQ11 (Finite completion is equivalent to eventual separation).** Along a sound retaining query stream with fixed finite K and q, the question settles in finite time if and only if every y ∈ B_G with q(y) ≠ q(x) is eventually separated from x by a queried key.

*Proof.* If q is settled, no such y survives, so some observed answer has excluded each one. Conversely, select one finite separation time for each wrong-answer candidate. There are finitely many candidates, so the maximum of these times is finite. After that time no wrong-answer candidate survives, while x does. If there are no wrong-answer candidates initially, completion occurs at time zero.

Equivalently, each uncached key i covers D_i = {y ∈ B_G: q(y) ≠ q(x) and f_i(y) ≠ f_i(x)}. A sufficient extension covers all wrong-answer candidates. LQ3 minimizes the size of such a cover. LQ11 asks whether the actual stream ever supplies a cover. Existence and acquisition are separate obligations.

If a policy always chooses a query that strictly reduces B while q is unresolved, it settles after at most |B_G| − 1 calls. That policy premise is stronger than eventual separation and may fail when the vocabulary cannot distinguish different answers. Eventual separation gives a finite stopping time for a finite B, but no uniform waiting-time bound: arbitrarily many repeats may precede a useful query.

The argument uses survivor intersection and finite set coverage. It applies to arbitrary finite carriers and answer alphabets in the stated static-query model.

**An infinite candidate family can still give finite completion.** VC23 supplies another sufficient setting: countably many finite-valued addresses, admission completely specified by finite-address relations, and a total question q depending on finitely many addresses. Suppose every acquired fact is another such relation on the same source, the facts are sound and retained, and their entire stream together with the fixed admission requirements determines q. VC23's forced-answer corollary gives a finite subset of these requirements and facts that already determines it. The acquired members of that subset all arrive by some finite stage. The fixed admission requirements belong to the background. Thus q is already determined at that stage even if infinitely many other distinctions remain unresolved. This establishes logical resolution. Recognizing it still requires a derivation or an adequate decision procedure.

The question condition matters even with binary addresses and no extra admission restriction. Let the actual source be the all-zero sequence, and ask whether any coordinate is one. Query coordinates successively. Every wrong-answer source is eventually separated, because it has a one at some queried position. Nevertheless, every finite prefix of zero answers admits a one at an unqueried position, so the question never settles at a finite stage. Its answer concerns infinitely many addresses. A supplied source-bound universal fact that every coordinate is zero would settle it by a finite symbolic argument. That fact is stronger than any finite list of these individual observations.

Adding a field named the answer does not remove this condition. VC23 proves that the exact relation between that field and this unbounded existence question has no representation by countably many local constraints with finite-valued hidden fields. A recursive claim that some later position supplies the witness can satisfy every local continuation equation on an all-zero input. Requiring a finite witness that reaches an actual one changes the admission rule and excludes that unsupported claim. The source, the claim and its justification are distinct internal roles in this model.

LQ15's finite-character condition concerns refuting one proposed complete tuple. VC23's finite-carrier argument instead concerns existence of a common assignment for a family of requirements. Together they identify when local saturation can suffice and where a global admission or question premise must remain explicit. Finiteness of each recorded fact alone supplies neither guarantee. No bound on the physical whole or universal acquisition schedule has been inferred.

**LQ4 (Geometry needs an acquisition model).** A metric on structures can organize resolved regions and assign query costs. It does not determine their growth direction or speed. Even a small clustered region can remain unresolved if the policy never visits its distinguishing queries. Dendritic growth is a proposed geometric analogy requiring a specified dynamics and measured behavior, not a consequence of metric structure alone.

**Axon guidance supplies a concrete contact question.** In [Koser et al. (2016)](https://cris.fau.de/publications/241417791/), Xenopus retinal ganglion cell axons grew toward softer tissue. An in vitro stiffness gradient reproduced this orientation without a chemical gradient. Altering brain stiffness, blocking mechanotransduction or reducing Piezo1 produced abnormal growth and pathfinding. These interventions establish a role for mechanical contact in this preparation. They do not require the growing axon to represent a distant destination before interacting with its surroundings.

[Qiu et al. (2024)](https://www.frontiersin.org/journals/molecular-neuroscience/articles/10.3389/fnmol.2024.1307755/full) studied a different contact: substrate-bound netrin-1 and its receptor DCC. Receptor grip was more prevalent on the netrin-coated substrate than on the control, with greater transmitted traction. Disrupting the actin-to-DCC linkage through shootin1 knockout impaired the directed growth. The relevant description includes the ligand, receptor, internal force coupling and substrate. A chemical cue alone is an incomplete description of that contact mechanism.

**Changing the support changes the interaction.** [Moore, Biais and Sheetz (2009), Fig. 1](https://pmc.ncbi.nlm.nih.gov/articles/PMC2746731/) presented spinal commissural neuron growth cones with netrin-1-coated beads. Growth cones transported an unrestrained bead down the axon. An immobilized bead could redirect axon growth. None of 13 axons turned more than 20 degrees toward an unrestrained bead, whereas 10 of 15 did toward an immobilized bead. DCC interference also disrupted pulling on the coated beads. These observations distinguish the mechanical support of the contact while retaining the ligand category. They do not establish identical complete preparations or a deterministic response of every axon. An interface recording only the presence of netrin-1 omits a variable tested by this intervention.

**Restoring one contact function need not restore its continuation.** [Nichols, Lee and Shen (2025), Fig. 5](https://pmc.ncbi.nlm.nih.gov/articles/PMC11888602/) followed axon guidance in living C. elegans. In UNC-6-deficient animals, membrane-tethered UNC-6 at the ventral sublateral intermediate target restored local axon stabilization. Expression only at the ventral nerve cord did not. The tethered constructs did not restore the direction of initial axon emergence. Supplying tethered UNC-6 at both locations partially rescued final targeting: 68.6% of PDE axons reached the ventral nerve cord, compared with 32.1% in the UNC-6 mutant and 100% in wild type in the reported adult samples. Thus local attachment, initial direction and eventual targeting require separate comparisons. The authors propose successive adhesion and gradient-guided growth. Their results prevent extending a contact-only account to all stages of guidance on the strength of local stabilization alone.

The VI research question is therefore which joining distinctions a proposed growth interface must retain. LQ13 already separates the two endpoints from the actual joining between them. Here that joining participates in both local response and changed geometry, which changes later contacts. The experiments support studying that coupling. They do not establish that every growth event acquires knowledge, that two neurons universally attract one another, or that biological development implements a VI proof checker. A wrong path can be physically realized while failing the network's functional task. Physical admission and correctness about a specified target remain different relations.

## §3. Search and Composition

**LQ5 (Alignment is a policy condition).** Descent succeeds under a basin or progress condition for the actual loss, neighbor relation and tie-breaking rule. Positive aggregate correlation α does not exclude a spurious local minimum. Gradient GA6 supplies a finite counterexample with positive α and failed greedy descent. Calling successful and stalled search laminar and turbulent does not establish fluid dynamics.

**LQ6 (Ruggedness statistics need a sampling measure).** A quantity C(d) = corr(loss(R), loss(R′) | W(R, R′) = d) requires a distribution over pairs and nonzero conditional variances. It can summarize scale-dependent loss variation under that distribution. No general equivalence between its decay, a scalar alignment coefficient and successful search has been established here. A spectral interpretation requires additional structure, such as a specified graph operator. The proposed analogy between 1/α and a Reynolds number is not a derived invariant.

**LQ7 (Composition depth and counting growth).** Iterating a declared composition rule expands its reachable set when new extensional classes appear. The cumulative count N(s) and its exponential rate γ measure reach per unit norm (B8d). They do not by themselves specify a temporal flow, an energy transfer or the computational efficiency of generation.

For finite norm bands, the formal partition sum Z(λ) = Σ_s n(s) exp(−λs) converges for λ > γ and diverges for λ < γ. The actual density determines the boundary and the limiting moments (Play PP17). A limsup growth rate does not imply n(s) ~ exp(γs): the count sequences ceil(2ˢ/sᵖ) have the same γ for p = 0, 2, 3, 4 and different critical behavior. Zero γ also permits subexponential unbounded growth. Calling composition a physical cascade requires further dynamics.

## §4. Coupling and the Learning Arrow

**LQ8 (Feedback requires an implemented update).** Search can propose a candidate, a verifier can certify a scoped claim, a retaining store can preserve it, and a later policy can use it. This forms a feedback loop when those operations are implemented and connected. A repeated PASS may leave the store unchanged. A new record may leave the compatible set unchanged. A smaller compatible set may leave the implemented search slower because retrieval and policy computation have costs.

**Acquisition can reshape the next interface.** Let w be one joint form, with readings for the participant, its surroundings and their actual contact. No independent product of these readings is assumed. An implemented acquisition is a transition w→w′. A changed participant reading already distinguishes the whole forms, even if a chosen environmental reading is unchanged. The transition can also change the next available preparations, contact conditions or decoding operation. Thus acquiring a record and modifying the interface can occur in one physical process. Whether both occur is a question about that transition. LQ12's resident context and Verdict's resident preparation constructions supply exact finite examples of changing access within a retained whole.

Two comparisons must accompany such an update. First, does the retained evidence determine more about the original question? VC30 transports that question through the intervention. Second, what can the new participant-contact configuration distinguish or do next? Equal recorded answers need not settle the second comparison. By VC15, if two configurations have the same proposed retained image but a permitted continuation gives different answers, that image cannot supply a common exact decoder. The missing distinction may concern the contact itself. In stochastic applications the relevant comparison concerns the specified response laws, not inequality of two individual trial outcomes.

This makes a limited interpretation of learning as physical reconfiguration precise: the learner and its representation are internal forms whose changes can alter later interactions. Establishing improved knowledge additionally requires the relation to the target question. A useful next experiment would separately vary the acquired evidence and the mechanical or decoding contact, then compare the same declared continuation. This distinguishes a new fact, a new way to use an old fact and a changed source. The formal compilation of a new claim models these processes only when its fields and transitions preserve those actual relations.

Consequently no decrease in nearby loss, increase in efficiency, or Stefan equation follows from this loop alone. A Stefan model would need specified fields, geometry, transport equations and an interface balance. `StefanCoupling` names the proposed connection in the type lattice. Its protocol intersection does not supply those equations or an actual policy update.

**LQ8a (Current agreement does not identify acquisition).** Let the nonempty relation T⊆W₀×W₁ contain the admitted source–result pairs, including the actual interaction being studied. A pair can name two internal records or two cuts of a history. The notation supplies no clock outside the whole. Let q₀:W₀→A be the original question, q₁:W₁→A its proposed current reading, m:W₁→M the retained evidence and d:M→A its decoder. Assume current agreement on every admitted pair:

    d(m(t)) = q₁(t), for every (s,t) ∈ T.

Then that same decoded record answers the original question exactly if and only if

    q₁(t) = q₀(s), for every (s,t) ∈ T.

*Proof.* Substitute the current-agreement equation into d(m(t))=q₀(s), in each direction. If one admitted pair violates question transport, its current agreement supplies the wrong original answer. If every pair satisfies the equation, transitivity gives the required original answer on every pair. This argument uses a relation, so deterministic independent updates of the participant and surroundings are unnecessary. Different answer encodings require an established comparison between them before either equality can be asserted. QED

The result is a consequence of VC15's factorization and VC30's original-question transport. It exposes a specific inference that current agreement alone cannot support. Learning about an earlier source can also occur while its current answer changes, provided the record retains the earlier answer. In that case the first, current-agreement equation can fail. Only the selected question must be tracked. Preserving the whole environment is unnecessary. Acquisition is new relative to prior evidence only when that evidence did not already determine the original answer.

**Two reversible interactions give the obstruction.** Use four resident fields, with the first read as the current target and the third as the participant's current record. The admitted preparations are (x,x,r,r), where x and r can each take either of two distinguishable forms. The participant's prior evidence is r alone, so it does not determine x. The equal copies are supplied preparation relations. No procedure for copying an unknown physical state is inferred. Define two permutations on the complete four-field carrier:

    L(a,b,c,d) = (a,c,b,d)
    C(a,b,c,d) = (c,a,d,b).

L is its own inverse. C⁻¹(a,b,c,d)=(b,d,a,c). On the prepared slice:

| Interaction | Result fields | Current target and record | Original target recoverable at |
| --- | --- | --- | --- |
| L | (x,r,x,r) | (x,x) | field 3 |
| C | (r,x,r,x) | (r,r) | field 2 |

Both operations preserve all source fields and both produce exact current agreement. Under L, the current record determines the original x. Under C, fixing r and varying x leaves the current target–record pair unchanged while the original answer changes. Therefore no decoder of that pair can recover x for all admitted preparations of C. This refusal applies even if both final readings are granted. Access to the initial target was not granted by declaring its role. Knowing that C was used does not remove this collision. The archive at field 2 does remove it if that further contact becomes available. The distinction remains inside the whole throughout.

Even the complete four-field outputs satisfy L(x,x,r,r)=C(r,r,x,x). These are two different operations, so the equality does not contradict their separate injectivity. Realizing them as one controlled law requires its resident mode: (L,w)↦(L,L(w)) or (C,w)↦(C,C(w)). The mode is retained, and this joint transformation is bijective. Omitting the mode would omit part of the described whole. If x and r additionally have the independent uniform distribution, both interactions produce the same current joint law, half (0,0) and half (1,1). Thus even perfect current correlation and its complete probability table do not distinguish acquisition from changing the target to agree with the old record. The counterexample itself needs no probability measure.

`Checks/ClosedInformation.swift` constructs these permutations from `TransposeEntries`, `SwapBoundaryReading` and `FollowedPair`. Generic equalities establish both inverses, the current readings, recovery of both original fields and the collision for arbitrary original targets under C. `StepBeside` retains the mode. The refusal fixtures attempt to infer the original answer from current agreement, omit the prepared copy relation, or merge modes because their four output fields coincide. The matrix-shaped carrier supplies four addresses here. No quantum or scalar interpretation is used.

**The changing membrane has two adequacy questions.** A proposed interface can preserve a fact about the original source while omitting what its holder can do next, or preserve an available action while omitting the fact's origin. To retain both, its equal images must agree on the selected original questions and on the selected continuation questions, including whether each continuation is available. The coarsest adequate equivalence is the intersection of those two question-equivalence relations. Any adequate encoding refines that intersection by VC15. The equivalence-class encoding attains it. This concerns a declared family of contacts, with stochastic response laws used where required. It grants neither knowledge of all physical continuations nor a device that acquires the classification for free.

This connects the reversible example to the axon experiments without identifying their mechanisms. The example forces retention of the relation to the original source. The experiments test contact distinctions that affect particular continuations. A learning process can change both at once. The substantive claim to examine is whether its new internal organization preserves the answers being claimed and changes which further distinctions can be acquired. Compiling another VI claim is an instance only when the represented source, update and later use are actually joined by those relations.

**LQ9 (Retention gives a weak monotone quantity).** For fixed finite Q, |R_G| is nondecreasing under the premises of LQ2. It can remain constant through indefinitely many operations. Thus it is a weak monotone quantity, not a strict Lyapunov function. Expanding Q or revising K changes what is being measured, so a comparison across such changes needs an explicit transport of questions and evidence.

This local learning direction is not yet a thermodynamic arrow. In an eight-state closed model with source bits a, b and memory bit m, the fixed operation (a, b, m) ↦ (a, b, m XOR a) is reversible. On the prepared slice m = 0 it makes a readable from memory. Under uniform source bits, whole-state Shannon entropy remains two bits while memory entropy rises from zero to one bit. Applying the same operation again clears that memory. The acquired distinction stayed inside the whole, and reversibility alone did not retain local access to it.

The whole, the preparation, the reading and the transition must therefore be distinguished. PiR M38–M41 separately treat exact transport, coarse entropy and changes of resolution. LQ11 supplies an informational completion condition. None of these derives irreversible physical time from the fact that there is no outside.

## §5. Implications for AI

**LQ10 (Certification is scoped, and compatible with statistical proposal).** A statistical generator can propose an answer or a proof. A checker can verify a formal claim under stated premises, and a store can retain the result with its scope. Certification concerns that claim: it does not establish that an empirical model includes the actual world. An unresolved question can elicit a further query, a set of compatible answers, an explicit hypothesis, or abstention.

There is no architectural prohibition on combining learned proposals with formal checking. [LeanDojo and its ReProver system](https://arxiv.org/pdf/2306.15626) provide a concrete example of language-model proof search interacting with Lean. The earlier claim that statistical AI cannot certify, retain or abstain was too broad. The useful distinction is between an unchecked output and an output with the required evidence and interpretation.

For VI, a sharper research direction is to train question selection against residual alternatives while retaining scoped certificates. Evaluate at least query cost, distinct new records, resolved questions and total implemented cost separately. Repeated certificates can demonstrate reliable reuse with zero new observations. Useful new evidence can settle one question without identifying the whole candidate. Neither behavior requires every episode to increase a global knowledge count.

A further hypothesis is that training on which alternatives a question excludes can improve acquisition more directly than rewarding record volume. LQ11 gives a completion criterion and failure cases for such a system. Immediate gain is still incomplete: InI S3a gives a uniquely most informative first query with worse optimal continuations, and S12 gives a necessary first observation with zero immediate information about the target answer. Acquisition policies therefore need a criterion that accounts for continuations. No efficiency advantage for a learned policy is proved here.

## §6. Boundaries

The proofs here concern static total queries, fixed candidate semantics, sound keyed observations and retaining updates. The verifier, storage and policy all remain internal to a chosen whole. Stateful interventions need a dynamics model and transported questions. Unknown or inadequate models need revision, not confidence inferred from a singleton survivor.

Three tasks remain separate: constructing a representation that distinguishes future behavior (Verdict VC38), acquiring a distinction along an executable interaction (VC30–VC34), and finding a policy that does so cheaply (InI and IiI). Saturating the first does not solve the other two. The finite acquisition-trap witness in `Checks/Models/discovery_trap.json` already exhibits that gap.

## §6a. The state of the logical medium

**LQ12 (admission and rearrangement specify different properties of a medium).** Begin with admitted forms R and an actual relation of elementary rearrangements J⊆R×R. In the reversible fragment considered here, J is symmetric. Paths are finite compositions of its admitted links. No observer, transmitted signal or separate certification agent enters this definition. R and J specify this fragment, rather than claiming that every relation in reality is a Boolean state or a reversible step. A change in J changes what the medium can do while leaving R unchanged.

The distinction is between which forms fit the relations and which forms can be reached from one another through permitted rearrangement. All predicates true of every member of R remain the same when J changes. Those truths alone therefore cannot determine the medium's mobility. If the term logical phase is used here, it must include this structure of possible transformation, not only a fraction of questions already answered.

**The persistent properties are exactly those constant on rearrangement components.** Let π map each form to its component under finite J-paths. A property q is preserved by every admitted elementary rearrangement exactly when q=d∘π for a unique d on the components. Preservation propagates along a path by substitution, so q is constant on each component. Conversely, each link has both endpoints in one component, so every such factorization is preserved. Adding rearrangements can only merge components and reduce this family of persistent properties. It need not merge actual forms or make an individual transformation irreversible. No distribution or entropy definition enters this result.

This partition characterizes persistent properties, not every property of rearrangement. A connected path and a complete graph on the same forms both preserve only constant q, yet permit different elementary transitions. Classifying the whole medium therefore cannot stop at the number of components. The example establishes a useful invariant of a proposed logical regime, without making it a complete phase taxonomy.

Coupling supplies another coordinate when the medium has specified independently addressed parts. For a partition P of those parts, call its admission relation separable across P when R=∏_{B∈P}π_B(R). Otherwise constraints across those parts remain. The decomposition itself belongs to the specified contact structure. It cannot be silently replaced by a different one after recoding the forms.

The existing binary families give a complete small test of the distinction. For n≥2, compare these admitted forms under changes to one coordinate whose endpoints remain admitted:

| Admitted relation | Separation across the addressed parts | Rearrangement components |
|---|---|---|
| All binary tuples | Product of the individual coordinate domains | One |
| At least one zero, R_n of VC23b | No nontrivial product partition | One |
| Even parity | No nontrivial product partition | 2ⁿ⁻¹ singletons |
| The first coordinate is zero | Product of the individual coordinate domains | One |

For the middle two relations, every proper coordinate projection is the full binary cube: supply a missing zero for R_n, or choose the missing parity bit. If either relation factored across a nontrivial partition, every block projection would be full and their product would admit the excluded tuples. This proves the failure of every such product decomposition. Yet R_n is connected: remove its ones one at a time to reach 0ⁿ, always keeping a zero. Even parity has no one-coordinate edge because such a change reverses parity. Fixing the first coordinate to zero leaves a connected cube on the others. The all-cube case is connected by correcting the differing coordinates in sequence.

Thus one forbidden joint form can couple every addressed part without immobilizing the medium. Conversely, many admissible forms can be isolated from every permitted elementary rearrangement. The parity and fixed-first-zero families even have equal cardinality 2ⁿ⁻¹. With an additionally chosen uniform distribution, both have Shannon entropy n−1 bits, while one has only isolated forms and the other is connected. Neither allowed-form count nor this entropy determines the rearrangement regime. The uniform measure is a comparison premise, not a probability law extracted from logic.

**Changing the rearrangement relation changes the regime without changing its admitted truths.** On the same even-parity family, admit a flip of any two coordinates. Each operation is an involution and preserves parity. Two even tuples differ at an even number of positions. Pair those positions and flip each pair to obtain a finite path between the tuples. The medium is now connected. Its forms and their common parity constraint have not changed, but the properties preserved by every admitted rearrangement have reduced from all functions on R to constants. This is a precise structural change underlying a possible phase vocabulary. It is not yet a thermodynamic phase transition.

The context of this change can itself belong to the form. Take (c,x), where c∈{0,1} and x has even parity. A context exchange changes c and retains x. Pair flips retain c and are admitted when c=1. Each admitted operation is reversible. With c fixed at zero there are no nontrivial x rearrangements. With c fixed at one they connect all x. The whole relation, including context exchange, is connected: enter c=1, make the necessary pair flips, then set the required endpoint context. Therefore a property protected in the fixed-zero context need not be protected through the full internal relation. No outside chooser or heating apparatus is needed to state these links. Their availability alone does not specify which path actually occurs.

**The classification must survive a faithful change of description.** If b:R→R′ is a bijection and the rearrangements are transported as J′={(b(x),b(y)):(x,y)∈J}, b bijects the path components and transports all their persistent properties. For example, binary addition maps even-parity tuples bijectively to a cube with one fixed coordinate by writing the total parity into that coordinate. The earlier disconnected and connected regimes do not become identical through this recoding: their respective one-coordinate rearrangements have not been transported to the same relation. Declaring the new coordinate changes elementary would change the medium. Locality is among the relations to establish, not a picture supplied for free by an encoding.

These constructions reuse the admission and continuation distinction of VC46–VC47, the higher-order vacancy obstruction in M67, and VC23b's dependence of witness acquisition on the medium's internal orientation. They do not require a new type protocol named phase. The mathematical study of [reconfiguration of satisfying assignments](https://arxiv.org/abs/cs/0609072) supplies related tools for the Boolean specialization. Here the proposed level change is to examine the form of the checking and rearranging medium itself, including changes of its context, before specializing it to an observer or a physical substance.

The next foundational question is which rearrangement and contact relations follow from the proposed medium's own construction. A named solid or liquid does not answer it. The following construction extracts an exact constraint on replacement from an internal contact. The older settled-question account remains one local use of a logical regime. It does not exhaust what a logical state could mean.

## §6b. Contact before reading

**LQ13 (an internal contact determines the boundary of uniform replacement).** At a specified cut inside one whole, write the admitted joint forms as R⊆A×B. A and B address the two parts, not a system and an outside of reality. Restrict A and B to their projections from R, so each addressed form has at least one compatible partner. Define

    N(a) = {b ∈ B : (a,b) ∈ R}.

This is a description of the contact relation already present. It does not introduce an observer who knows N(a), a stored copy of that set, or an instrument that measures it. Ask whether replacing a by a′ preserves admission for every compatible b while retaining that same b. The answer is exactly

    a can be uniformly replaced by a′  iff  N(a) ⊆ N(a′).

*Proof.* If inclusion holds, each admitted (a,b) has b∈N(a′), so its replacement (a′,b) is admitted. If inclusion fails, a b in N(a)\N(a′) supplies an admitted source and forbidden replacement. This b is an internal obstruction, not an appeal to an external verdict. QED

Thus uniform replacement is a preorder. Mutual replacement is exactly equality of the compatibility sets. In contrast, one actual occurrence permits a→a′ with its retained b whenever b belongs to both sets. A replacement can succeed at that occurrence and fail the uniform claim. It is the quantifier over internal partners that changes, rather than the logic becoming inconsistent.

**The least complete contact description is forced.** Let β(a) be the equivalence class under N(a)=N(a′). Suppose an interface e:A→E is required to retain exactly this admission relation: there must be some relation S⊆E×B with

    (a,b) ∈ R  iff  (e(a),b) ∈ S.

Then e(a)=e(a′) forces N(a)=N(a′). Hence β=d∘e for a unique d on e(A). Conversely β itself admits such an S by the defining equality of compatibility sets. This proves minimality by factorization, without selecting a preferred encoding or counting its symbols. β retains every distinction needed at this cut. It can discard differences within a contact class. It need not identify the complete local form or preserve future contacts that have not been included in R.

Both sides can be reduced at once. Define β_A by equal row profiles N(a), and β_B by equal column profiles {a:(a,b)∈R}. Then R descends exactly to a relation between β_A(A) and β_B(B). Replacing a by another member of its row class preserves every incidence, and replacing b within its column class does the same, proving that the descended relation is well-defined. Any other separate encodings e and f that preserve both admission and refusal must refine these two classifications: equal e-values force equal rows, and equal f-values force equal columns. This is a least complete two-sided interface by factorization. One joint contract can therefore require two different boundary spaces. It need not be equality of one common value.

Completeness here concerns admission. If an actual contact also has a joining form w with endpoint projections p(w) and q(w), its admission relation is R={(p(w),q(w)):w∈W}. Different w can have the same endpoints. LQ13's quotient then preserves existence of a compatible joining, not every distinction of that joining. A question u(w) can be answered from the two boundary classes exactly when it is constant on their joint fibers, by VC15. VI1's different alignments between equal repeated contents already supply such omitted contact distinctions. The joining belongs inside the whole. It must remain in the representation when the question or a permitted future rearrangement depends on it. This prevents promoting the least admission interface into a complete description of every actual interaction.

**A boundary pair does not establish a scalar collapse.** At this specified cut there are two roles. That does not make their contents two possible answers, two bits, or two real numbers. The pair (β_A(a),β_B(b)) can address arbitrarily rich contact profiles. Its adequacy follows from the retained relation between them. It is not supplied by the pair shape. The whole has no outside partner in this construction: both roles and their joining are internal.

For a question u about actual joinings, put e(w)=(β_A(p(w)),β_B(q(w))). The precise boundary obligation is

    e(w)=e(w′)  implies  u(w)=u(w′).

This is the existing factorization criterion, now applied to the proposed pair. If it fails, two equal endpoint images require different answers. A retained joining distinction can repair the representation, for example as ⟨e(w),k(w)⟩, provided equality of this refined image really implies equality of u. Naming k supplies no recovery theorem. A binary constructor can carry that richer relation through nested pairs without asserting a third fundamental participant. Conversely, two endpoint names alone cannot reconstruct the joining by being called a complete pair.

The distinction is already present in the type notation. `Pair` exposes Left and Right, while different nominal conformers can expose the same two sides, as EF4 shows. Equality of those sides does not identify their full relation witnesses. `ResidentTransportContact` explicitly retains the application as well as its two accessors. Discarding that application is justified only for questions and continuations that factor through the remaining fields. A `Null` verdict identifies its two compared sides. It does not turn their common content into the number zero, or establish that the contact itself has disappeared.

A determinate answer and a complete result occurrence also have different identity conditions. Several different actual contacts can give the same answer without making that answer ambiguous. The returned value is one reading of their relational content. Its source binding need not be duplicated inside every numeral: `FactOf<R>` retains the question, context, encoding and answer, while `RecordReading<R>` binds that fact beside the actual supplied source through R. Moving the fact alone does not carry that entire binding. The required connection may belong to the containing record, but its existence must not be inferred from equality of the isolated answer values. This is a property of the specified recording construction, not a theorem that every physical measurement leaves its source unchanged.

Nor is numerical notation itself the obstruction. For any specified finite family of distinct forms, an injective numbering c can retain each form. Carry each actual relation R to the numbered relation {(c(a),c(b)):(a,b)∈R}, including its refusals on the declared domain. For a partial operation ⋆ whose admitted outputs belong to that family, its exact numbered operation is defined by c(a)⋆_c c(b)=c(a⋆b) wherever the source operation is admitted. Injectivity makes this well-defined. The numbered operation may remain partial or noncommutative. Replacing it by ordinary addition or multiplication requires a further preservation proof. This construction concerns that finite represented family, not a finite whole or a preferred physical scale.

Thus three different moves must be kept separate: retaining a contact in two structural roles, identifying forms with the same relevant contact answers, and selecting a numerical coordinate system. The first and third do not require a loss of distinctions. The second identifies forms, and is sound only for questions whose answers it preserves. These are properties of a description. A physical acquisition and its effects on the resident whole require their own contact construction. A measured number is the answer of a specified contact when that correspondence is established. Its scalar shape does not make it the complete boundary for every later contact.

**A shared context does not replace the joining relation.** Let J⊆C×A×B describe pair admissions in their retained context. Its separate projections say P(c,a) iff some b satisfies J(c,a,b), and Q(c,b) iff some a satisfies J(c,a,b). Recombining these facts admits J′(c,a,b) iff P(c,a) and Q(c,b). Always J⊆J′. Equality is equivalent to every nonempty fiber J_c being a rectangle: for fixed c, its two projections have product exactly J_c. This follows directly from the definition of J′. If it fails, an a and b each admitted in that same context have a refused joint pairing. The common context label has not retained the missing relation.

For example, at one context c the pair relations {00,11} and {01,10} have the same two separate projections and no common admitted pair. This is a counterdescription to recovery from those projections, not a claim that one actual occurrence contains both alternative relations. If an address instead identifies one completely specified ordered pair, its fiber is a singleton and its two projections suffice. The established correspondence to that pair does the work. Calling a context an occurrence cannot supply it.

**Binary incidence can retain a joint relation without selecting its physical organization.** For any specified finite number of roles and admission relation R⊆A₁×⋯×Aₙ, take an internal witness carrier W=R. Let E_i(w,a_i) mean that the i-th component of w equals a_i. Then

    (a₁,…,aₙ) ∈ R  iff  there is one w with every E_i(w,a_i).

An admitted tuple supplies w. Conversely all these equalities make the tuple the components of that one w, which belongs to R. Thus binary incidences to a shared witness reproduce every original admission and refusal. Hiding each witness separately would instead give the product of the projections and could invent admissions. The common witness is the retained joint restriction in this presentation. It adds no independent observer and does not establish a physical mediator or a direction of influence.

The presentation also does not recover actual occurrence identity from admission alone. Replacing W by R×K for any nonempty index set K and letting all E_i ignore K gives exactly the same R. Different witness multiplicities are invisible to this question. A supplied occurrence distinction or a question about its history must be retained separately and cannot be erased by this construction. For a single admitted ternary tuple, one ternary contact and three binary incidences to its witness give different drawings with the same original answers. Counting primitive arrows, participants or cycles in a drawing therefore cannot determine physical organization until their source correspondence and meaning are fixed. This generalizes the incidence construction in VC23a, without weakening its restriction to Boolean carriers or declaring a unique topology behind joint givenness.

**This participant, a substitute, and a complete occurrence have different identity requirements.** Suppose an actual occurrence g has an established role reading r(g)=a. If r is single-valued on the declared domain and a is positively distinguished from b, the same g under the same r cannot have b in that role. It would give a=r(g)=b. This is M71's finite obstruction applied to one participant, without requiring an inventory of every role or every possible occurrence. A richer account retaining these two premises cannot repair the proposed substitution by adding another internal participant. A reading which returns only a participant's content forces identity of that content, not of two equal-content occurrences. The reading's question determines which distinction this argument preserves.

A participation relation alone has no such uniqueness: P(g,a) and P(g,b) may both be true with a≠b. One established participation cannot be turned into an exclusive role by calling it a side. Conversely, preserving the known P(g,a) while adding P(g,z) leaves the known participation intact. It changes the proposed complete membership if that earlier account claimed to list it all. The positive statement that a participates and the universal claim that nobody else participates have different grounds. Naming g supplies neither a single-valued role nor a complete boundary.

Now permit a new occurrence h and ask only that a specified content reading u be preserved. The relation u(h)=u(g) need not give r(h)=r(g). Keeping this consequence for every admitted replacement is exactly the factorization condition r=d∘u on the occurrence domain: equality of u must imply equality of r. Necessity follows by applying d. Conversely, define d on the image by d(u(g))=r(g), which is well-defined under that implication. This reuses VC9 and VC60. It distinguishes a participant indispensable to the identified occurrence from a participant required by every realization of some retained content. The first refusal can use one addressed contradiction. The second claim needs its domain or a structural proof covering it. Neither statement proves physical impossibility of replacing a carrier while preserving a coarser question.

This also tests a proposed location for a given distinction. Endpoint descriptions p and q may omit it even jointly, as when u(g)≠u(h) but p(g)=p(h) and q(g)=q(h). An account that puts the entire difference in either endpoint's described state cannot fit these facts. A richer endpoint description may include the distinguishing connection, but then its asserted boundary has changed. If the distinction is experienced, its experienced status belongs to the given. These structural tests do not independently establish which joining is felt or assign it an exclusive owner. A subject boundary must be related to that occurrence rather than installed by calling one endpoint its interior.

For a bijection f:A→A, the transformation (a,b)↦(f(a),b) is a reversible rearrangement of R, including its inverse, exactly when β(f(a))=β(a) for every a. Necessity applies the replacement criterion in both directions. Sufficiency gives an admitted forward and inverse on every joint form. Therefore the largest family of such rearrangements consists exactly of independent permutations within the contact classes. Actual operations can be a proper subfamily. The contact specifies the full compatibility envelope, not an instruction to realize every member of it.

**Can preserving changes determine the boundary in reverse?** Combine this result with LQ12. Let G be generated by a supplied family of reversible local maps on A. Each map must preserve the contact with every partner retained, using the same local map for all partners. Every G-orbit is contained in one β-class. The orbit reading therefore determines β, but may retain distinctions that this contact does not require. The two classifications coincide exactly when G connects every pair with the same contact profile. This is a reachability obligation. Replacing the supplied G by all permutations inside the β-classes meets it by construction, while using the boundary that was supposed to be recovered. A context-dependent replacement or a map that also moves the partner has a different premise.

Even complete knowledge of simultaneous symmetries need not determine this local boundary. Take four roles a,b,c,d with the opposite pairing o=(a d)(b c). On two uses of this same role family define two contacts:

    R₁(x,y) iff y=o(x),
    R₂(x,y) iff y=x or y=o(x).

Both admit the same contact (a,d) between positively distinct forms. Their row profiles, with + admitted and − refused, are

| Local role | R₁ partners a,b,c,d | R₂ partners a,b,c,d |
|---|---|---|
| a | − − − + | + − − + |
| b | − − + − | − + + − |
| c | − + − − | − + + − |
| d | + − − − | + − − + |

Their full groups of simultaneous role permutations are identical. A permutation π preserves R₁ exactly when it preserves its opposite pairs, hence πo=oπ. It preserves R₂ exactly when it preserves its admitted pairs of distinct roles, which are those same opposite pairs. The diagonal is preserved by every permutation. Thus the full group in both cases is {π:πo=oπ}. It has eight elements: choose the image of a in four ways, which fixes the image of d, then choose the image of b in two ways, which fixes c. These are all symmetries of this specified action on the two roles together, not all physically available operations or all permutations of the joint-form set.

Yet R₁ has four different profiles, each with a different sole partner, while R₂ has only the two classes {a,d} and {b,c}. Exchanging a and d with the partner retained is uniformly reversible for R₂. For R₁, the given partner d gives an admitted source (a,d) and refused replacement (d,d). Thus the same complete simultaneous symmetry group, and the same given contact between distinct forms, permit different least boundaries of local replacement. This refutes the inference from that symmetry information to a unique such boundary. A faithful joint renaming of all roles preserves the counterexample.

If the given ordered contact is also required to remain fixed, both groups reduce to the same subgroup fixing a and d: identity and the exchange of b with c. Including that internal reference therefore does not distinguish the two boundaries either. The four role names here carry no additional intrinsic structure. Further relations on their carriers must be included before attributing these symmetries to a physical whole.

`FourRoleProfileSymmetries<D,O,C>` in the interaction checks constructs the common table with diagonal D, opposite O and remaining entry C. Actual column and row operations derive its invariance under (a c)(b d) and (b c), generators of the eight-element group. The specializations (D,O,C)=(−,+,−) and (+,+,−) supply the two contacts above. The type checks derive the shared opposite contact, equal opposite rows only in the second contact, and a positive distinction between the first contact's opposite rows. They refuse identification of the whole contacts and transfer of the second boundary to the first. The proof that these are the full simultaneous symmetry groups is the argument above, rather than an unverified symmetry marker. The admission codes describe the finite example and are not physical measurements.

**An actual contact fact can select what symmetry leaves open.** On the ordered pairs, this group has three orbits: diagonal, opposite and remaining pairs. A binary admission law invariant under the group assigns one answer to each orbit. The shared fact (a,d) fixes the opposite answer only. A test of (d,d) distinguishes R₁ from R₂, but does not by itself identify an arbitrary invariant law: its remaining-pair orbit may still be unanswered. The given fact and its actual transport law have distinct jobs.

More generally, let known internal reversible transformations G preserve an unknown admission relation R on a specified candidate domain W. For established admitted forms P and refused forms N, put L=G·P and F=G·N. A G-invariant R satisfying those facts exists exactly when L∩F is empty. When it exists, the possible relations are precisely the unions of G-orbits between L and W∖F. Necessity transports each fact. For sufficiency any such union preserves the facts and is invariant. Therefore these facts and symmetries determine the whole relation exactly when L∪F=W. They determine a particular form's admission once its orbit meets P or N. This uses known symmetries, not the additional claim that G is the full symmetry group of R. No probability law or sampling guarantee is implied.

This is a way to propagate established facts using LQ12 and VI1a, with a coverage condition for a positive completion. It does not manufacture the initial facts or transformations. A positive difference between two responses under the same retained contact can already refuse a proposed identification of their sources, by VC9. Failure to obtain a response does not automatically supply a refused form. The empirical task can therefore begin with an established response contrast, without treating every missing observation as physical impossibility.

`ResidentContactExchange<X>` supplies a source-bound construction for the equality-contact specialization. Its input contains ((local,partner),reserve). The local and reserved forms expose their boundary at Right, while the partner exposes the same boundary at Left. Both equalities are checked at those actual addresses. The output is ((reserve,partner),local). The constructor admits arbitrary interiors, preserves the partner and retains the old local form as the new reserve. Applying it twice recovers the canonical input pair. The replacement is already resident in the source, rather than supplied by an unaccounted agent.

`RetainedPartnerForcesBoundary<P>` proves the corresponding necessity for any supplied endpoint pair P: if both endpoints satisfy their contact equalities and the partner is retained, their local boundaries agree. That conclusion is derived inside the generic type body. The checks instantiate a changed interior with the same boundary and refuse a mismatched reserve boundary, a broken source contact, erasure of the old local form and a changed partner presented as retained. These are general equalities of addressed fields. The full set-theoretic classification above is proved in the article, not by treating an open conformance as a quantifier over all possible contacts.

**One constraint can leave internal motion while fixing a boundary quantity.** For even binary parity across nonempty blocks A and B, a tuple a is compatible with exactly those b of the same parity. There are precisely two contact classes, the even and odd local forms. The parity of A is therefore the least complete boundary description. Every uniform reversible rearrangement of A with B retained must preserve that parity. When A contains at least two coordinates, swapping or flipping two local bits supplies nontrivial examples. For a single coordinate each class has one member, so no nontrivial replacement remains. A boundary quantity and a minimum size of coordinated change have emerged from the joint admission relation. Neither a probability law nor a previously named conserved physical quantity was used.

The vacancy relation of VC23b gives a different structure. Across nonempty blocks, a local tuple with a zero is compatible with every B tuple. A local all-one tuple is compatible with every B tuple except all ones. Thus turning an all-one local tuple into one with a zero is uniformly admissible. The reverse is admissible only in contexts where B already supplies a zero. It cannot be promoted to a uniform inverse while retaining B. The whole can still admit reversible coordinated rearrangements, and each particular coordinate toggle has its reverse at its own admitted endpoints. An order of uniform replacement is therefore not a physical time arrow.

**Opening possibilities can invalidate an old universal law.** On binary A and B, start with R₀={00,10}. Exchanging A's values while retaining B is reversible on R₀. Add the admitted form 01 to obtain R₁={00,10,01}. The exchange is no longer a total operation on R₁, because it takes 01 to the forbidden 11. Add 11 as well to obtain R₂, and the exchange becomes valid again. Every old application remains admitted throughout. What fails in the middle is its extension to every new context. More admitted forms do not monotonically give more uniform local laws. This supplies a concrete question about a changing logical medium: which previously valid universal replacements survive its new contacts?

**The contact can be refined without treating its parts as independent.** If two independently combinable partner fields have nonempty compatibility sets N₁(a) and N₂(a), their joint set is N₁(a)×N₂(a). Equality of these products is equivalent to equality of both factors, by projecting the nonempty products. The resulting contact classes are the common refinement of the two old classifications. If the partner fields are themselves constrained together, the joint set instead intersects their admitted relation. The independent-product conclusion then needs a new proof. Relations among partners are part of the same whole and cannot be dropped to obtain a stronger conclusion.

**Logical operations have construction requirements.** The family of realized sets {N(a):a∈A} need not contain their intersections, unions or complements. For example, three forms with respective partner sets {0,1}, {1,2} and {0,2} have no form whose partner set is {1}, the intersection of the first two. The set intersection is mathematically defined. Its realization as another form of this same A is absent. A truth-functional connective on descriptions and an available construction of the described forms are different objects.

For a construction whose complete admission consists of two contacts to the same partner b, the resulting form (a₁,a₂) has compatibility N₁(a₁)∩N₂(a₂). Exactness means there is no further joint constraint on a₁,a₂,b. Shared partner identity alone does not establish that completeness. LQ15 below gives a positive three-role obstruction. If the contacts instead keep separate independent partners, the result has the product N₁(a₁)×N₂(a₂). Calling both constructions conjunction would omit the relation that distinguishes them. An empty shared-partner intersection means that this combined contact has no realization. A record proposing it can still exist, as The Cut §18 distinguishes.

For a projection e that hides differences among local forms, the projected admission relation has

    N_e(u) = ⋃ {N(a) : e(a)=u}.

This union describes existence of some compatible realization. It need not guarantee compatibility of the actual hidden realization. Let R={00,11} and let e merge the two local forms. The projected form admits both partners, although each actual local form admits only one. Its apparent freedom comes from omitting the correlation. This also explains why LQ13 requires the two-way equality R(a,b) iff S(e(a),b) for every actual a and b. Merely projecting R supplies only an existential image and can falsely enlarge the replacement possibilities of a particular form. The finer boundary β prevents exactly this merger.

Guaranteeing one partner across the hidden forms instead uses their profile intersection. Matter M25a derives when that common-response requirement survives further restrictions of partners and source possibilities. It also identifies a canonical Galois closure that preserves current common responses, although no unique adequate partition need exist. This closure composes exactly with adding source alternatives and restricting partners. New evidence restricting the hidden sources can distinguish families with the same closure. Each compression must retain the direction of contact for which it is sufficient.

The contact profile is also different from a common value present on either side separately. A common value consists of maps p:A→Q and q:B→Q with p(a)=q(b) for every admitted pair. Equality propagates along the bipartite contact graph, so such values are exactly functions of its connected components. This applies the same propagation argument as LQ12 and Seeing SiE9 to a contact. At any nontrivial cut of even parity, there are two components, labeled by the parity on either side. In the vacancy relation every a shares some partner containing a zero, and every b has a compatible a containing a zero. The graph is connected, so only constant values are common to the two sides in this sense, even though the compatibility profiles differ. A joint constraint need not consist of identical copies of one nonconstant value in each participant.

**An equality seam represents a contact exactly only under a rectangle condition.** There exist separate codes p:A→Q and q:B→Q with

    (a,b) ∈ R  iff  p(a)=q(b)

exactly when any three admitted corners (a,b), (a,b′), (a′,b) force the fourth (a′,b′). Necessity is substitution of the three equalities. Conversely, the corner condition makes overlapping compatibility sets identical: a shared b and any b′∈N(a) force b′∈N(a′), and the reverse argument gives equality. The nonempty sets N(a) therefore partition B. Give a its set as a code and b the unique set containing it. These codes establish precisely R. Equivalently, every connected component of the contact graph must be a complete bipartite graph.

For an arbitrary R, replacing its contact by equality of shared codes while retaining every admitted pair necessarily adds every missing pair inside each contact component. Equality propagates along its paths. Coding by the components attains exactly that completion, proving that it is the smallest such enlargement. On R={00,01,10}, the three corners force 11. Thus no two separate deterministic codes can express this vacancy contact solely by their equality. That is a restriction of the proposed interface, not a restriction of all binary relations or of Swift.

`ThreeContactsForceFourth<X>` proves the rectangle implication from three actual equalities of four addressed codes. Its fourth equality is a conclusion. The vacancy relation itself already has an exact static construction: fix the third coordinate of VC23b's triples at Lit1 and admit `FirstVacancy` or `SecondVacancy`. The 00 form has two possible supports, 01 has the first, 10 has the second, and 11 has neither. The constructor used retains which actual coordinate supplied the vacancy. Collapsing this relation to one shared equality would create the forbidden fourth form. The equality-contact exchange above is therefore an exact useful fragment, not a universal representation of every contact in the medium.

**Order independence probes the same contact law.** Keep R⊆A×B. A partial local map f on A induces an action F(a,b)=(f(a),b) exactly when f(a) is defined and this output belongs to R. A partial map g on B similarly induces G(a,b)=(a,g(b)). Their local rules use only their respective coordinates. The shared relation still controls availability. The following conditions on R are equivalent:

1. Three admitted corners always imply the fourth.
2. For every such f and g, whenever F and G are both available at a source, both successive orders are available and give the same result.
3. For every such f and g, the two composites G∘F and F∘G are equal as partial maps, including their domains.

For 1⇒2, joint initial availability supplies (a,b), (f(a),b) and (a,g(b)). The fourth corner is the common final form. For 2⇒1, use the singleton-domain maps a↦a′ and b↦b′ at any three supplied corners. For 1⇒3, an available order supplies the source, its intermediate corner and the final corner. The rectangle condition supplies the other intermediate corner, and each local rule remains defined on its unchanged coordinate. The converse order is therefore available with the same output. For 3⇒1, suppose (a,b), (a′,b) and (a,b′) are admitted but (a′,b′) is refused. At (a′,b), use a′↦a and b↦b′. The first-then-second order reaches (a,b′), while the reverse first attempts the refused corner. Its domains differ, contradicting 3. No finite carrier is required.

Consequently this universal independence property selects exactly the contacts representable by equality of a shared boundary value. It does not require R to be a full product. In a relation with several complete bipartite components, every admitted one-sided move preserves the common component value, because its unchanged partner retains that value. Both sides may still admit a coordinated change to another component under a separately supplied operation. The theorem assumes the full family of induced local maps, including the singleton-domain tests. A restricted vocabulary can commute on a nonrectangular R. Actual physical availability of that entire family is not implied by the contact description.

**For one pair of actions, equal composites can hide a refusal.** On R={00,01,10}, let each local map fill its zero coordinate with one and be undefined at one. Both lifted actions are available at 00, yet neither complete order is available: both would end at 11. Their composites are the same empty partial map. Conversely, on R={00,10,11} the same filling maps are never initially available together, so condition 2 for this pair is vacuous. Filling the first and then the second coordinate is nevertheless available at 00, while the reverse is not. Thus the preceding equivalence uses the quantifier over all local maps. It cannot be applied to one observed pair of commuting formulas or an untested intermediate form.

For a specified pair of partial actions on any K, a direct certificate of independent availability and result is

    domain(G∘F) = domain(F∘G) = domain(F) ∩ domain(G),
    G(F(x)) = F(G(x)) on that common domain.

The first equality says exactly that F neither enables nor disables G while F is available, and G neither enables nor disables F while G is available. It follows by expanding domain(G∘F)={x∈domain(F):F(x)∈domain(G)} and its reverse. The second is the output requirement. Equal final values without the domain equations omit both dependencies and refusals. G14b's `IndependentReadingOrders` derives the output part on its product application grammar. `IndependentContactOrders` also derives the final equality contact from the original and two individual contacts, so those two constructed orders remain in that contact relation. It reuses `ThreeContactsForceFourth` without a fourth-contact premise. This certificate concerns the supplied applications in the equality-contact fragment, not exhaustive knowledge of an arbitrary action domain.

**Complete boundaries at every cut need not carry one common nonconstant answer.** Let R be even parity on n≥3 binary roles. For every nonempty proper subset S of roles, its exact equality seam is

    parity(x restricted to S) = parity(x restricted to the complement of S).

Both boundary values occur. Each value has a different nonempty partner set, so two boundary classes are necessary and sufficient at each cut. Yet a common answer readable separately from every individual role must be constant. Every pair projection of R is full: choose an omitted bit to complete parity. If q(x)=dᵢ(xᵢ)=dⱼ(xⱼ) on R for distinct i,j, this gives dᵢ(u)=dⱼ(v) for every u,v, making both readings constant. Thus an exact shared value across every cut does not supply a nonconstant value separately present in every participant. The grouped complement retains a relation that each of its individual roles can omit.

There are two precise ways to combine boundary information. For any nonempty family of readings bⱼ:R→Bⱼ, a description retaining every bⱼ must separate x and y whenever some bⱼ does. The tuple b(x)=(bⱼ(x))ⱼ is the least such description: b=d∘v for every other complete description v, because equal v-values imply equal tuples. Its equal-value relation is the intersection of the equal-value relations of the bⱼ.

In contrast, an answer recoverable from each bⱼ separately must identify x and y whenever any bⱼ identifies them. It must therefore be constant along every finite chain of such identifications. Conversely, constancy on these chain components defines a unique decoder on each bⱼ(R). The component quotient is the greatest content separately recoverable from all the readings. These statements apply to infinite families and carriers too. They follow directly from factorization and finite equality propagation, without probabilities or a choice of representatives.

In the ternary parity relation {000,011,101,110}, the singleton-cut codes are a,b,c. Their tuple identifies all four admitted forms, while their jointly recoverable common content has one class. Every two distinct admitted triples share a coordinate. A single cut needs two codes, and VC23a's exact latent centre needs four possible states. Those capacities answer different questions. A predicate constant on the admitted relation can still forbid other proposed combinations: absence of a varying common answer does not remove the joint admission law. Nor does the tuple identify different actual joinings with identical endpoint values. A question about those occurrences still needs LQ13's earlier joining condition.

This ties LQ13 to M72 without treating a different cut as a different reality. To retain all established boundary distinctions, combine their actual answers. To ask what every boundary can recover separately, use the propagation condition. Replacing the first operation by the second can erase the whole distinction under investigation. The existing parity clauses and `LatentPairConstructsAllEvenTriples` retain the four joint triples in bare Swift. The general classification across arbitrary families is the argument above, not a new compiler claim.

**Four roles can force composition before inverses.** Let R⊆A×B×C×D, with nonempty carriers. Require exactly one output d=F(a,b,c) for every assignment to A,B,C. Choose one admitted reference (a₀,b₀,c₀,d₀), and require the three sections a↦F(a,b₀,c₀), b↦F(a₀,b,c₀), c↦F(a₀,b₀,c) to be bijections onto D. These are three specified reference sections, without a requirement that every other one-variable section be surjective. Impose the rectangle condition at AB|CD and BC|AD. Separate bijections of the four carriers then identify R with

    d = (a ⋅ b) ⋅ c = a ⋅ (b ⋅ c)

in a cancellative monoid: composition is associative, has a unit, and permits cancellation on both sides. Inverses are a further question. Requiring AC|BD to be rectangular is equivalent to commutativity. Conversely, every cancellative monoid gives the first two rectangles and the reference sections at its unit, and a commutative one gives all three. The carriers can be infinite. No binary operation, unit or associativity law is supplied separately from these contact conditions.

*Construction and proof.* Use the three specified bijections to express the inputs in Q=D, and write e=d₀. The resulting T:Q³→Q satisfies

    T(x,e,e)=x,   T(e,y,e)=y,   T(e,e,z)=z.

These are consequences of the chosen coordinates. Define x*y=T(x,e,y). It is total and has two-sided unit e. Set p=T(x,y,e). At AB|CD, the rows (x,y) and (p,e) share the partner (e,p). Rectangularity makes their entire profiles equal, hence T(x,y,z)=T(p,e,z)=p*z. At BC|AD, put q=T(e,y,z). The rows (y,z) and (e,q) share the partner (e,q), giving T(x,y,z)=T(x,e,q)=x*q.

Set z=e in the second identity to obtain p=x*y. Set x=e in the first to obtain q=y*z. Thus

    T(x,y,z)=(x*y)*z=x*(y*z).

Associativity is derived. Cancellation also follows from the rectangles. If x*z=y*z, the AB rows (x,e) and (y,e) share a CD partner. Their profiles coincide, and their values at c=e then give x=y. If z*x=z*y, the BC rows (e,x) and (e,y) share an AD partner. Comparing their profiles at a=e again gives x=y. No inverse or surjectivity of multiplication was used.

At AC|BD, the rows (x,z) and (x*z,e) share partner (e,x*z). A third application of the rectangle condition gives T(x,y,z)=(x*z)*y. Taking x=e yields y*z=z*y. Conversely, for any cancellative monoid, sharing a CD partner gives (a*b)*c=(a′*b′)*c, so cancellation identifies the AB products and hence their full profiles. The BC case uses left cancellation. In the commutative case the same argument applies to AC products, establishing the third rectangle. QED

**One reference-completion condition supplies all inverses.** The monoid above is a group exactly when every x admits y,z with T(x,y,z)=e. For sufficiency let r=y*z. Then x*r=e, and associativity gives x*(r*x)=(x*r)*x=x=x*e. Cancellation gives r*x=e. Every x therefore has a two-sided inverse. Necessity follows by taking y=x⁻¹ and z=e. This is an existence condition at one output reference. It does not separately assume unique solutions at every role and every other output.

Requiring every assignment to any three original roles to have exactly one completion implies the reference sections and this reference-completion condition, so it gives the stronger group conclusion. Conversely a group relation has that full completion property. Its first two seams can be written a⋅b=d⋅c⁻¹ and b⋅c=a⁻¹⋅d, and in a commutative group the third is a⋅c=d⋅b⁻¹. These inverse formulas are available only after the additional condition has been established.

The nonnegative integers with F(a,b,c)=a+b+c satisfy the weaker conditions, including all three rectangles and the reference sections at zero. The input 1 cannot be completed to output zero, so this is no group. Thus exact overlapping cuts can force associative, cancellative composition without forcing inverse availability. In a finite cancellative monoid, each multiplication is an injection of a finite set into itself and hence a bijection, so the inverse condition follows. The unbounded carrier is essential to this particular separation. These equations concern contact roles, not the physical availability of a reverse-time action.

`PositiveSumCannotReachZero<N>` in `Checks/Interactions.swift` positively separates the zero reference from the answer of the actual `AddSuccessor<AddZero<N>>` construction. Its structural refusal applies to every `N: IntegerValued`. Reading N as a nonnegative integer additionally uses the finite numeral grammar of IiS15. No arbitrary arithmetic conformance is accepted as the base. This certifies the refused zero return for those constructed sums, without claiming a compiler proof of the general monoid reconstruction.

The reference belongs to R. It establishes no preferred zero outside the relation. In the group case, changing the reference to one whose output is o changes the normalized binary operation to x⋄y=x⋅o⁻¹⋅y. The map x↦o⁻¹⋅x is a group isomorphism to the old operation. Thus the group obtained from the same R does not depend, up to isomorphism, on that reference. A monoid without inverses need not permit the same bijective reference sections at every admitted tuple. The hypotheses still allow different group relations: the cyclic group of order four and the group of two independent binary coordinates both satisfy all three seams. Their element orders differ. The complete contact distinguishes them, while the general seam requirements alone do not select one of them.

The group case is a contact formulation of established generalized associativity, not a new algebraic theorem. [Zaslavsky, *Associativity in Multary Quasigroups*, §1.1 and Lemma 4.2](https://arxiv.org/pdf/math/0411268) treats factorization as associativity and reconstructs groups from compatible factorizations. The proof here separates the facts forcing composition and cancellation from the extra availability that supplies inverses. Associativity concerns this reconstructed contact operation, not every operation in the medium.

**The missing cut has a finite obstruction without inverses.** In a cancellative monoid take g,h with g*h≠h*g. At AC|BD use rows (e,g), (g,e) and columns (e,g), (h,h*g). The first three corners are admitted, while the fourth requires g*h=h*g. Hence two exact seams cannot justify the third. Finite words under concatenation supply such a monoid: the empty word is the unit, common prefixes and suffixes cancel, and distinct single-letter words need not commute. No nonempty word has an inverse under that same concatenation. Thus noncommutation and missing inverses can occur together within the weaker contact conditions.

The existing group witness uses g*h*g⁻¹≠h. Its AC rows (e,e), (g,g⁻¹) and BD columns (e,e), (h,h) again give three admitted corners and one refused corner. Permutations realize it internally: exchanging positions 1 and 2 conjugates the exchange of 2 and 3 into the exchange of 1 and 3. `AdjacentSwapConjugation` constructs that word from the existing projections and applications for arbitrary three fields. The checked source with three different fields distinguishes its result from the original exchange. This is an actual finite word calculation, not a group law installed in a protocol. The compiler checks this permutation construction and refusal. Reconstruction over arbitrary carriers is the preceding mathematical proof.

One exact cut need not even force associativity. For a complete example let Q consist of e and the nine pairs in {0,1,2}². Give e the unit role. For pairs u,v, define u⊙u=e and u⊙v=−u−v modulo three when u≠v. Each left translation is an involution, so this is a loop. With a=(0,0), b=(1,0), c=(0,1), one obtains (a⊙b)⊙c=(1,2) but a⊙(b⊙c)=(1,1). The relation d=(a⊙b)⊙c has unique completion at every role and the exact seam a⊙b=c⊙d, yet its normalized operation is nonassociative. It therefore fails the second rectangle condition used above. For three roles, the relation c=a⊙b already has exact seams at every cut without associativity. The fourth role and its overlapping cuts add a real requirement.

Total completion and uniqueness matter separately. A diagonal relation with at least two values has exact seams at every cut and at most one completion, but most triples have none. A full product with at least two values in each role has exact seams and completion for every triple, but not unique completion. Neither yields the stated group representation by separate bijections. The physical inquiry is therefore specific: whether the same actual four roles admit these completions and forbid each missing fourth corner. Internal closure alone does not supply those facts. Once established, their algebra cannot be varied while preserving that contact under the same role correspondence.

**Even adjoining one inverse can violate a retained contrast.** Missing inverses do not by themselves forbid embedding a monoid in a group: nonnegative addition embeds in integer addition. Cancellation, however, does not guarantee such an embedding. The following is Malcev's example, presented in [Edwardes and Heath, Theorem 2.2 and §3](https://link.springer.com/article/10.1007/s00233-025-10509-2). Take the monoid of finite words on eight letters, with exactly the equations

    ax = by,    au = bv,    cx = dy.

These equations preserve two disjoint letter classes {a,b,c,d} and {x,y,u,v}. Any replaceable pair has its first letter in the first class and second in the other, so replaceable positions cannot overlap. Corresponding pairs belong to the classes {ax,by}, {au,bv}, {cx,dy}, with other pairs unchanged. Equality of words is exactly equality of these independent blocks and the remaining single letters. Thus cu and dv are distinct. Each block class contains at most one pair with any fixed first letter, and at most one with any fixed second letter. Cancelling an identical prefix or suffix therefore cannot conceal a different boundary letter. All other blocks cancel directly. Repeating letter cancellation proves cancellation of arbitrary words on both sides.

The forbidden extension is more local than a full group embedding. Suppose an enlarged monoid preserves the three displayed equalities and the distinction cu≠dv. Suppose it adds r with yr=e and allows cancellation of the prefix a on the new products. Then

    b = axr,    d = cxr,
    au = bv = axrv,
    u = xrv,
    cu = cxrv = dv.

The last line contradicts the retained distinction. Hence no such extension exists. In particular y cannot gain a right inverse inside any left-cancellative extension preserving these facts, and no group-valued homomorphism can preserve the contrast between cu and dv. Only that contrast is needed for refusal, without requiring the proposed representation to distinguish every other source pair. Arbitrarily many additional forms cannot repair this finite derivation under the same composition and cancellation contract. This is an application of M71, not a claim that adjoining inverses always fails.

**Cancellation on new products is a substantive condition.** To test it, use all functions M→M with composition in order of application, f⋆g=g∘f. Represent s by the right translation R_s(w)=ws. Then R_s⋆R_t=R_st and R_s(e)=s, so this representation preserves every original product and distinction. Define J(zy)=z, and J(w)=e when w is outside the image My={zy:z∈M}. Right cancellation in the original monoid makes J well-defined. It gives R_y⋆J=id, a right inverse of the represented y in this enlarged function monoid.

All three original equations and cu≠dv are retained, but cancellation of a fails on new products. The retained equations give R_a⋆R_u=R_b⋆R_v=R_a⋆R_x⋆J⋆R_v. The factors after R_a are different: at e, the first returns u, while the second returns v because x is outside My and J(x)=e. Thus original cancellation on original words is preserved, while its asserted extension to the new factors is false. Also J⋆R_y sends e to y, so J is not a two-sided inverse. This is an explicit one-sided recovery extension, without a group embedding. A universal law on one carrier cannot be enlarged silently when new operands are introduced.

**The same law still has faithful injective actions and partial inverses.** On the monoid itself let L_s(t)=st. Cancellation makes every L_s injective, composition gives L_s∘L_t=L_st, and L_s(e)=s distinguishes the actions. Every L_s is a bijection onto its own image sM and has an inverse defined there. The generators have positive word length, and the defining equations preserve length, so e is outside each generator image. For y, the composite L_y∘L_y⁻¹ is the identity on yM, not on the whole action domain M. Replacing that restricted identity by a total one would remove the domain condition needed to preserve the contrast above.

Thus total injective actions with shared composition laws need not admit a simultaneous representation by permutations that preserves the same products and contrast. This differs from the reversible realization of a prepared local episode in Matter M70. That construction carries the preparation, phase and retained source. It does not assert one family of total inverse actions preserving every equation of an arbitrary monoid. Nor does a formal inverse remove an occurred record from M55's history. The example supplies a conditional finite obstruction in the relation medium, without establishing that physical changes have this monoid law. The word cancellation and extension arguments here are mathematical proofs, not new Swift conformance markers.

**The complete crossed boundary retains an action.** Keep the noncommutative group contact d=a⋅b⋅c and the cut AC|BD. The profile of (a,c) is the graph of the partner response b↦a⋅b⋅c. Put p=a⋅c. This response is

    b ↦ (a⋅b⋅a⁻¹)⋅p.

Let Z(G) be the centre, the elements commuting with every element of G. Two rows have the same profile exactly when

    aZ(G)=a′Z(G)   and   a⋅c=a′⋅c′.

*Proof.* Agreement at b=e fixes p. Agreement at every b then means that conjugation by a and by a′ coincide, equivalently a′⁻¹⋅a commutes with every b. These two conditions also give identical responses at every b. QED

Thus β_AC(a,c)=(aZ(G),p) is the least complete boundary, by LQ13's factorization argument. The column profile maps a to c=b⁻¹⋅a⁻¹⋅d. The same reasoning gives β_BD(b,d)=(bZ(G),t), where t=b⁻¹⋅d. Both boundaries retain a product value and the element's class modulo the centre, which determines its conjugation action. This is different from a conjugacy class of elements. The two boundaries need not be the same value across an admitted contact.

Their exact remaining relation is

    t = κ(aZ(G),bZ(G))⋅p,
    κ(aZ(G),bZ(G)) = b⁻¹⋅a⋅b⋅a⁻¹.

Changing a or b by a central factor leaves κ unchanged, so this relation is well-defined on the boundary classes. Substituting p=a⋅c and t=b⁻¹⋅d proves equivalence with the original contact. This retains both admission and refusal. In the commutative case the classes modulo the centre disappear and κ=e, reducing the relation to t=p. In the general case the missing distinction concerns how one part acts on the other. Adding that relation to the boundary preserves the contact without forcing a new commutative law. The law is still expressible as the equality t=κ⋅p, with κ computed from both boundary roles. The failed restriction was equality of separately computed codes alone, not equality or bare Swift as an expression medium.

M72 computes the other quotient: the greatest content separately readable on both sides is the image of p and t in G/[G,G]. The commutator subgroup [G,G] and the centre Z(G) answer different questions here. For a finite G of order m, with centre of order z and commutator subgroup of order k, each complete side boundary has m²/z classes, while the separately common content has m/k classes. Replacing the contact by equality of that common content expands the m³ admitted quadruples to m³k. Those new admissions are errors of the coarser representation, not new possibilities proved for the original relation.

For the six permutations of three positions, Z(G)={e} and [G,G] is the three-element subgroup of even permutations. Hence a complete side boundary has 36 classes, while the common content has two. The exact relation admits 216 quadruples and its smallest shared-equality enlargement admits 648. M72 proves these group facts and the count. `AdjacentSwapConjugation` supplies one of the omitted refusals: the conjugated exchange and the original exchange have the same parity, yet differ on the same addressed source. Agreement in the common quotient cannot authorize that fourth corner.

Complete contact here means all admissions and refusals of the stated four-role relation. Interpreting its group elements as changes of a configuration does not automatically include a record of each performed occurrence. M55 proves the exact limit: if every group action and its inverse are admitted as next steps, any nondecreasing record read from that configuration is constant on group orbits. Two swaps can return the selected fields while their two-entry record remains different. That record is another internal distinction to retain when the question concerns occurrences. No exterior history register is supplied by this distinction.

**A central crossing residual gives an alternating pairing.** Simultaneously replacing a,b by s⋅a⋅s⁻¹,s⋅b⋅s⁻¹ replaces κ(a,b) by s⋅κ(a,b)⋅s⁻¹. This covariance applies in every group. Requiring the residual value itself to remain unchanged for every s,a,b is stronger: it says exactly that all commutators lie in Z(G). Freedom to change an internal description does not establish this literal invariance. Under the additional condition K=[G,G]⊆Z(G), the following structure is forced.

The quotient V=G/Z(G) is abelian, as is K. In additive notation on these two groups, define

    ω(aZ(G),bZ(G)) = κ(a,b).

It is well-defined by the earlier boundary calculation. Centrality gives a⋅b=κ(a,b)⋅b⋅a. Moving b past a′ and then a in (a⋅a′)⋅b multiplies the two central residuals, so ω(v+v′,w)=ω(v,w)+ω(v′,w). Moving a past b and then b′ proves additivity in the second place. Also ω(v,v)=0 and ω(w,v)=−ω(v,w). If ω(v,w)=0 for every w, any representative of v commutes with every group element and therefore lies in Z(G), so v=0. This is nondegeneracy as a separating pairing, not an assumption about a metric or a dual-space isomorphism.

If K has prime order p, then ω(pv,w)=pω(v,w)=0, hence pv=0 by nondegeneracy. Consequently V is a vector space over F_p, with scalar multiplication supplied by repeated addition. K is a one-dimensional F_p-space. Choosing a nonzero element of K expresses ω as an F_p-valued nondegenerate alternating form. Thus the vector structure follows from the stated central residual of prime order. If V is finite-dimensional, its dimension is even: choose v≠0 and w with ω(v,w)≠0, scale that value to one, split off their nondegenerate plane and continue in its orthogonal complement. This gives a symplectic geometry. It fixes neither lengths nor a probability rule, and no finiteness of the entire G was required.

These are established group-theoretic constructions. [Cameron, *Notes on Classical Groups*, §8.1](https://webspace.maths.qmul.ac.uk/p.j.cameron/class_gps/ch8.pdf) derives the commutator form and the additional power map in extraspecial groups. Here centrality and prime-order residual are stated where they enter, after the group itself was reconstructed from contact conditions. Neither follows from belonging to one reality alone.

**The pairing can omit how an action returns to itself.** Suppose further that Z(G)=K has order two. Write its values as 0,1. Every a² belongs to Z(G), since V has exponent two. Replacing a by a central multiple leaves a² unchanged, so

    q(aZ(G)) = a²

is well-defined. Reordering the middle factors in (a⋅b)² gives

    q(v+w) = q(v)+q(w)+ω(v,w).

Thus q is a quadratic refinement of the pairing. The centre condition matters: for a larger centre, changing a by z changes its square by z², so this particular map need not be well-defined into Z(G). Alternation ω(v,v)=0 says that exchanging two equal actions makes no difference. It does not say that their double application is the identity. Those are different return questions.

For an explicit pair of complete contacts, take triples (x,y,z)∈F₂³. For ε=0 or 1 define

    (x,y,z) ⋅ε (u,v,w)
      = (x+u, y+v, z+w+yu+ε(xu+yv)).

The added last-coordinate term cε((x,y),(u,v)) is bilinear. Hence cε(r,s)+cε(r+s,t)=cε(s,t)+cε(r,s+t), which proves associativity. The zero triple is the identity, and (x,y,z+cε((x,y),(x,y))) is the inverse of (x,y,z). Both groups have centre and commutator subgroup {(0,0,0),(0,0,1)}, since their common commutator form

    ω((x,y),(u,v)) = xv+yu

has zero radical. Their square maps differ:

    q₀(x,y)=xy,             q₁(x,y)=xy+x+y.

The first has two nonzero vectors with square zero, while the second has none. A change of quotient coordinates cannot remove that difference. For ε=0 the two coordinate generators are involutions and their product has order four, giving the dihedral group D₈ of order eight. For ε=1 both generators and their product square to the central nonidentity, giving Q₈. They have the same alternating pairing and different group contacts. This is a counterexample preserving the pair geometry, rather than two names for the same source law.

`SameCommutatorDifferentSquares` realizes this distinction through permutations of eight arbitrary resident fields, assembled into four constructor pairs. Reversing a pair defines a polarity exchange Z on the four pairs together. The computed actions satisfy P²=Q²=Z²=id and I²=J²=Z, while the two orders of P,Q and of I,J each differ by Z. The existing `TwistedPairShift`, projections and sequential applications construct the words. A source with eight different fields positively distinguishes Z from the identity, and the negative fixture refuses equality of the two squares. No group-identity premise, probability or runtime table is added. Constructor pairs are required for these full returns: exchanging and rebuilding an arbitrary nominal `Pair` does not recover its nominal shell. The compiler checks the displayed word identities and refusal, while the general reconstruction of ω and q is the preceding mathematical proof.

**The square law depends on which central changes are forgotten.** More generally, if C=Z(G) and G/C has exponent two, a square determines the class of a² in C/C², where C²={z²:z∈C}. This is well-defined because (az)²=a²z². Its polarization is the preceding equation with the central residual also mapped into C/C². If C=U(1), every central phase has a square root and this quotient is trivial. The square class then supplies no distinction, even when the commutator itself remains nontrivial in C. The earlier q with values in the two-element centre must not be transferred unchanged to this larger ambiguity.

There is a concrete quantum contact with the same boundary. In IiS10's complex two-mode model, the Pauli operations X,Z obey X²=Z²=I and XZ=−ZX. They generate D₈. The rephased operations iX,iZ have squares −I, their product also has square −I, and they generate Q₈. The four standalone channels and their compositions coincide between these two implementations, because common phases cancel there. The literal operation groups and their coherent comparison with a bypass remain different. Enlarging the ignored phase freedom therefore loses the square distinction without making D₈ and Q₈ isomorphic.

`CommonQuarterRephasingChangesSquares` constructs the relevant finite change using the existing eight-field operations. Read each inner pair as a signed term, and group the four resulting terms as two complex modes. The common quarter phase sends (u,v,w,x) to (v,−u,x,−w). It commutes with mode exchange and with the relative sign. Applying it beside each primitive changes both computed squares to the central exchange. The generic constructor verifies these equations, and a positive source contrast supports refusal of the old square after rephasing. Interpreting the paired terms as complex amplitudes is stated here, not inferred from their names.

IiS10 identifies the precise calibration issue: two orders of the same primitives have balanced occurrence counts, while a double application compared with a bypass does not. Full phase freedom and sign-only freedom impose different balance conditions. A physical realization of the square data below must retain the phase relation that makes those answers available. Neither one observed period ratio nor the number of branches supplies that reference. This restriction preserves the stated finite group reconstruction and prevents its use as an uncalibrated inference about spin or time reversal.

**The missing square law has an exact extent.** Fix a finite-dimensional symplectic space (V,ω) over F₂, with dim V=d. Any two refinements q,q′ of ω differ by a linear functional ℓ: subtracting their polarization equations gives ℓ(v+w)=ℓ(v)+ℓ(w). Conversely q+ℓ is a refinement for every linear ℓ. This is an affine family. Expressing a member as a linear displacement requires a reference member, rather than supplying a preferred zero law.

For a basis b₁,…,b_d, repeated polarization gives

    q(Σᵢ xᵢbᵢ) = Σᵢ xᵢq(bᵢ) + Σᵢ<ⱼ xᵢxⱼω(bᵢ,bⱼ).

Every assignment of the d basis values defines a refinement by this formula. Suppose actual square answers have been read at a family T⊆V and W=span T has dimension r. Exactly 2^(d−r) refinements agree with those answers. A target q(v) is determined across this whole family exactly when v∈W. For v∈W the formula reconstructs it from a finite linear combination of the read vectors and their known pairings. For v∉W, extend a basis of W by v and choose ℓ vanishing on W with ℓ(v)=1. Then q and q+ℓ retain every reading and give opposite target answers. Thus a finite span certificate can settle one target without settling the whole law. Full recovery requires spanning readings. Adaptive choice of query vectors cannot reduce the number below d in this access model: on any branch of smaller rank a nonzero annihilating ℓ leaves every answer, and hence the branch, unchanged. Other source information changes that model.

**Three commuting changes of description can exclude an invariant completion.** For v≠0 define the linear map τ_v(x)=x+ω(x,v)v. It is an involution and preserves ω: expansion of ω(τ_v(x),τ_v(y)) cancels the two cross terms, and the last term vanishes by alternation. These are symplectic transvections, as in [Cameron, §4.3](https://webspace.maths.qmul.ac.uk/p.j.cameron/class_gps/ch4.pdf). Direct polarization, with ω(x,v) either zero or one, gives

    q(τ_v(x)) + q(x) = ω(x,v)(q(v)+1).

Nondegeneracy supplies an x with ω(x,v)=1. Therefore q is invariant under τ_v exactly when q(v)=1. In dimension at least four, choose independent a,b with ω(a,b)=0, for example one vector from each of two orthogonal symplectic planes. The three maps τ_a,τ_b,τ_(a+b) commute and preserve the same pairing. Their joint invariance would require q(a)=q(b)=q(a+b)=1. But polarization requires q(a+b)=q(a)+q(b)=0. This is a finite obstruction using three transformations, without enumerating the full symmetry group. Every two of these invariance requirements are satisfiable: any two of a,b,a+b are independent and their square values can be extended to a basis. Separate successful symmetry checks therefore miss the joint refusal.

The dimension boundary is exact. In dimension two, q_*(0)=0 and q_*(v)=1 for all v≠0 is a refinement and is invariant under every symplectic map. Distinct nonzero vectors in that plane pair to one, which verifies polarization. Invariance under each τ_v also proves uniqueness. In dimension at least four, even supplying one distinguished nonzero vector r does not make an invariant refinement possible under all symplectic maps fixing r. Choose b∈r⊥ outside span{r} and repeat the three-map obstruction with a=r. All three maps fix the added reference. A reference must remove the relevant obstruction jointly, as VI1a requires.

**Square data completes the finite group contact.** The two missing laws above are realizable as group descriptions, not only as functions satisfying an isolated equation. For any refinement q, write ωᵢⱼ=ω(bᵢ,bⱼ), qᵢ=q(bᵢ), and set

    c(x,y) = Σᵢ qᵢxᵢyᵢ + Σᵢ>ⱼ ωᵢⱼxᵢyⱼ,
    (t,x) ⋅ (s,y) = (t+s+c(x,y), x+y)    on F₂×V.

Bilinearity of c proves associativity by the same identity used for D₈/Q₈. The identity is (0,0), the inverse of (t,x) is (t+c(x,x),x), the square is (q(x),0), and the commutator is (ω(x,y),0). For d>0, nondegeneracy gives centre and commutator subgroup F₂×{0}. Conversely, in any finite group with the stipulated centre, choose lifts uᵢ of a quotient basis and call the central nonidentity z. Every element has a unique form z^t u₁^x₁…u_d^x_d. Moving later generators past earlier ones and using uᵢ²=z^qᵢ gives exactly c. Thus ω and q reconstruct the group up to an isomorphism preserving its quotient and centre. Basis and lift choices change its expression. This spells out the reconstruction requested in [Cameron, §8.1, Exercise 8.3](https://webspace.maths.qmul.ac.uk/p.j.cameron/class_gps/ch8.pdf), without asserting that the givenness of contrast forces its group premises.

A symplectic quotient map lifts to an automorphism of this group exactly when it preserves q. Necessity follows by applying the automorphism to squares. For sufficiency, choose lifts of the transformed basis. They satisfy the same square and commutator relations, so the normal forms define a homomorphism, which is bijective on the quotient and centre. Some symmetries of ω therefore fail to preserve the restored contact. This is information omitted by a description, not a violation of relativity by the described whole.

`SameCommutatorDifferentSquares` also composes P,Q,P,Q and I,J,I,J and derives the answer Z in both cases. Together with its individual squares, these words verify the three nonzero square answers in both two-dimensional examples. The compiler constructs these finite actions. The general span, symmetry and reconstruction arguments above remain mathematical proofs in the article, not a claim of a generic Swift classification of groups.

**A canonical completion is still not recovery of what is given.** Forgetting q defines a projection π:(ω,q)↦ω. A rule s choosing an admissible refinement satisfies π∘s=id. Recovering every original contact would instead require s∘π=id, which the distinct refinements exclude. Even the unique invariant q_* in dimension two does not recover the square law of D₈. Its uniqueness is conditional on requiring an invariant completion, an extra requirement absent from that source. In higher dimension no completion preserving all symmetries of the bare pairing exists, although the family of refinements transports covariantly. For VI, the given contact already has its own square facts. An incomplete reading neither manufactures alternatives in reality nor licenses choosing one and calling it a discovery. The span test states exactly when the retained facts determine a particular missing answer. No external reference, physical randomness or time evolution is inferred from this obstruction.

**Local square laws glue exactly when their joint dependencies close.** In the same finite-dimensional (V,ω), let U₁,…,U_m be internal subspaces and let qᵢ refine ω restricted to Uᵢ. The restrictions may be degenerate. Write W=ΣᵢUᵢ and r=dim W. A single refinement on V restricts to all these qᵢ exactly when every finite list v₁,…,v_k, with v_j∈Uᵢⱼ and Σⱼv_j=0, satisfies

    Σⱼ qᵢⱼ(v_j) + Σⱼ<ₗ ω(v_j,v_l) = 0.                 (†)

The common embeddings in V and the cross pairings in this equation are retained premises. Local functions without those correspondences do not specify this problem.

Necessity follows by expanding q(Σv_j)=q(0). For sufficiency, assign to w=Σv_j the left side of (†) for that list, without requiring its sum to be zero. Two lists for the same w concatenate to a zero-sum list. The extra cross term is ω(w,w)=0, so (†) makes their assigned answers equal. This defines q_W independently of the decomposition. Concatenating lists for w and w′ gives polarization with cross term ω(w,w′), and a one-term list recovers each qᵢ. Extend a basis of W to V and assign square values to its new members. The preceding basis formula extends q_W. Thus the condition is sufficient, with exactly 2^(d−r) extensions. A target in W has one answer obtained from any decomposition through the local domains. A target outside W retains the linear ambiguity already proved above.

Checking pairwise overlaps tests only a part of (†). On a symplectic plane take independent a,b with ω(a,b)=1 and the three lines spanned by a, b and a+b. Give each line's nonzero vector square zero. All restrictions agree at their pairwise intersections {0}. But q(a+b)=q(a)+q(b)+1 forces the third answer to one. Every two of the line laws do extend: their nonzero vectors are independent and can receive arbitrary square values. Explicit extensions for the pairs are xy, xy+y and xy+x in coordinates a,b. This is a refusal of joint extension even though all pairwise extensions exist. In an isotropic plane, the corresponding three nonzero answers one also fail, now because the cross term is zero. The sum relation matters as well as the overlap pattern.

The existing static actions exhibit the symplectic-plane refusal. Their individual returns give P²=Q²=id, while their actual combined return gives (PQ)²=Z≠id on the addressed source. `ProductSquarePositiveRefusal` retains the zero/successor difference, and `INTERACTION_LOCAL_SQUARES_ERASE_CROSSING` rejects the proposed third identity. The individual and joint answers are computed through `SameCommutatorDifferentSquares`. This checks a concrete failed gluing of return claims, not the general quantification over all subspaces in (†).

**Every failure here has a short dependency witness.** Choose a failing zero-sum list of minimal length. It has no proper nonempty zero-sum sublist. Otherwise that sublist either already fails, or removing it leaves a shorter failure: the cross term between it and its complement is zero. Hence the vectors in the list form a minimal linear dependence, so its length is at most r+1. The bound is sharp for r≥2. Take r independent vectors and their sum as r+1 distinct lines. Start with the restrictions of a reference refinement and reverse the nonzero answer on only the last line. The sole minimal dependence fails (†), while any proper subset of the line laws extends. Thus checking joint extendibility of every subfamily of at most r laws can still miss a failure.

The size r belongs to this represented span, not to reality. Once a failing list, its zero-sum relation, cross pairings and distinct answers zero and one are established, adjoining further domains or ambient dimensions cannot repair that same list. Changing a local answer, its address or a cross relation changes a premise. This is the persistence of a witnessed refusal from M71. Conversely, if all retained laws came from one already established q, they necessarily pass (†). A failure concerns the proposed account of their shared source, rather than a contradiction occurring in the whole.

**When are pairwise comparisons enough for every local family?** The condition can be put on the domain arrangement itself. Let E=⊕ᵢUᵢ retain each domain as a separate summand, and let σ:E→W send a tuple to the sum of its actual vectors. Let N⊆E be generated by ιᵢ(v)+ιⱼ(v) for every v∈Uᵢ∩Uⱼ, where ιᵢ records the summand address. These are precisely the identifications supplied by shared vectors. Always N⊆ker σ. Agreement on all pairwise overlaps guarantees a global refinement for every local family exactly when

    N = ker σ.

To prove it, fix one reference refinement q₀ on V and subtract its restrictions. Each local law becomes a linear functional ℓᵢ=qᵢ+q₀|Uᵢ, together defining ℓ:E→F₂. Pairwise agreement says ℓ(N)=0. Global extension says ℓ(ker σ)=0, since that is exactly what lets ℓ descend to W. If N is smaller than ker σ, a linear functional on E/N can be chosen nonzero on a missing relation. Its restrictions, added back to q₀, give pairwise agreeing local refinements that fail globally. Thus the criterion is both necessary and sufficient. The reference cancels from the criterion. The quotient ker σ/N records dependencies not generated by overlaps. Its dimension is the number of additional independent linear conditions on a pairwise agreeing family, not a count of physical states or an entropy.

For example, two subspaces always meet this condition: a kernel element (u,v) has u=v in their intersection. Three distinct lines in a plane fail it: all pairwise intersections vanish but the sum map has a one-dimensional kernel. A useful sufficient condition for a longer ordered family is Uⱼ∩(Σᵢ<ⱼUᵢ)=Σᵢ<ⱼ(Uⱼ∩Uᵢ) at every step. After gluing earlier domains, pairwise agreement then fixes the new law on the whole shared span, allowing the two-subspace gluing step. These are exact checks on the carried relations, with no claim that an arbitrary diagram has them.

After subtraction of q₀ this is ordinary linear consistency: dependencies among inputs must also cancel among answers. The role of such dependencies in a matrix presentation is reviewed in [Strang's lecture on the four fundamental subspaces](https://ocw.mit.edu/courses/18-06sc-linear-algebra-fall-2011/62a9db9eeab190694d40afe4734068ca_MIT18_06SCF11_Ses1.10sum.pdf). That source discusses real matrices. The proof here uses the algebraic dual over F₂ and imports no positive inner product. The result's use for VI is to identify which joint relation a collection of individually valid descriptions has failed to retain. It introduces no extra observer or dynamics, and does not turn a collection of reports into jointly established facts.

**A finite contact family can certify the full profile under an exact condition.** Suppose the available readings return f(b)=a⋅b⋅c at the specified partners in a nonempty set T⊆G. Choose b₀∈T and let C_G(S) denote all group elements commuting with every member of S. Agreement on these readings forces agreement of the complete profiles, uniformly over all a,c, exactly when

    C_G({b⋅b₀⁻¹ : b∈T}) = Z(G).

*Proof.* For any b, f(b)⋅f(b₀)⁻¹=a⋅(b⋅b₀⁻¹)⋅a⁻¹. If two profiles agree on T, they agree at b₀, and a′⁻¹⋅a centralizes every relative partner b⋅b₀⁻¹. The displayed condition makes that element central, so the full profiles agree. Conversely, let u centralize all these relative partners while u∉Z(G). The profiles f(b)=b and f′(b)=u⋅b⋅b₀⁻¹⋅u⁻¹⋅b₀ agree on T, yet differ somewhere in G. They are actual profiles of (a,c)=(e,e) and (u,b₀⁻¹⋅u⁻¹⋅b₀). QED

For a noncommutative G, two partners never suffice. Their relative family is {e,t}. If t is central its centralizer is G, larger than Z(G). Otherwise the centralizer contains the noncentral t itself. Three partners do suffice for S₃: take e,(12),(23), whose common centralizer is trivial by M72's argument. The two-partner ambiguity has the existing source-bound witness: rows (e,e) and (g,g), with g=(12), agree at b=e and b=g, since g²=e and g³=g. They differ at b=(23), by `AdjacentSwapConjugation`. `AdjacentContactSwapReturns` derives the equalities for the first two contacts from actual applications. The mathematical centralizer criterion supplies completeness of the three-contact family, not a compiler enumeration of all profiles.

Generating G with the relative partners is sufficient but unnecessary. In S₃×S₃, the diagonal copies of (12) and (23) generate only a diagonal subgroup, yet their common centralizer is trivial in the full product. Thus e and these two partners still determine its complete profiles. The criterion requires separation of the conjugation actions, not generation of every form.

A finite separating family need not exist. Let G be the group of sequences of S₃ elements with finite support, multiplied coordinatewise. Its centre is trivial. Any finite partner family has support in finitely many coordinates, so a nonidentity permutation in another coordinate commutes with the entire family while remaining noncentral. The criterion fails. Every unequal pair of full profiles still has an individual distinguishing partner. Even a deterministic adaptive policy that must finish after finitely many such readings on every profile cannot identify all profiles: follow its finite branch on f(b)=b, then choose that unused coordinate. Conjugation there gives identical answers to every query on the branch but a different full profile. This concerns exact determination through the specified partner readings. A further direct source reading would change the contract.

LQ13 extracts a boundary from compatibility rather than installing a signal and asking what it reveals. Its minimality argument is a direct relation factorization, related to the existing question-scoped factorizations of VC15 and VC35. The changed object is significant: the retained distinction now determines whether two parts can fit together at all, before specifying any reading. Shared contacts, independent contacts and omitted internal distinctions give different composition laws. This is a precise sense in which the logical operations available to a medium depend on its construction.

Matter M72 applies this boundary to an established prefix/continuation relation. A later exact recovery forces the earlier answer to be common to both sides of each admitted joining. Every complete admission boundary must retain that answer. Distinct contact profiles alone give less: overlapping profiles can distinguish availability while supporting no different exactly shared answers. Thus relational influence, faithful recovery and the current appearance of a record remain separate questions even within one whole.

## §6c. Coordination through internal changes

**LQ14 (admission gives a necessary coordination scale, including all internal detours).** Fix a finite set I of addressed parts and admitted forms R⊆∏ᵢ Aᵢ. The parts and their addresses must belong to the proposed construction. For x,y∈R, let Δ(x,y)={i:xᵢ≠yᵢ}. Among all finite paths from x to y through R, define

    κ_R(x,y) = min_path max_step |Δ(x_previous,x_next)|,
    κ_R(x,x) = 0.

For distinct endpoints the direct path gives a candidate changing at most |I| addresses in one step. Every candidate width is a positive integer, so a minimum exists. A step here is a relation between forms, with composition giving a path. Its width counts changed addresses without specifying a physical instant. This definition uses every compatible intermediate form. It does not assume that every such step is actually available. Consequently κ_R is a lower bound on the largest step width in any actual path that remains in R with these addresses. An actual operation family can require a larger change or admit no such path at all.

**The coordination scales form a hierarchy.** Symmetry of Δ allows each path to reverse, so κ_R is symmetric. It vanishes exactly on identical endpoints. Concatenating minimizing paths proves

    κ_R(x,z) ≤ max(κ_R(x,y), κ_R(y,z)).

Thus κ_R is an integer-valued ultrametric. For each k, κ_R(x,y)≤k is exactly reachability through admitted pairs differing at at most k addresses. These equivalence classes merge as k increases. They describe the largest compatibility envelope for that change width. By LQ12, properties preserved by every pair in this envelope are exactly functions of these classes. This uses the radius-graph construction already present in Navigation N1–N2. Here the vertices are admitted forms of a contact structure, and the radius limits address changes per step rather than a library search distance.

There are two complementary certificates. An admitted path of width at most k proves κ_R(x,y)≤k. A partition of R placing x and y on opposite sides, with every crossing pair differing at more than k addresses, proves κ_R(x,y)>k. Conversely, if no width-k path exists, the forms reachable from x supply such a partition. This is a partition of admitted forms, distinct from the earlier cut between their addressed parts. The lower certificate applies to every actual operation family respecting R and the width bound. The upper certificate additionally needs actual constructions for its steps before it certifies a realized process.

The earlier examples now have exact scales. In the full cube and the vacancy relation, every distinct pair has κ=1 because the one-coordinate paths already constructed connect them. In even parity, every distinct pair has κ=2: one change is forbidden, and pair flips connect every two admitted forms. For the repetition relation {0ⁿ,1ⁿ}, κ(0ⁿ,1ⁿ)=n, since no other admitted form exists. Coupling all n coordinates can therefore require changing either one, two or n addresses per step in these different relations. The number of parts coupled does not determine the required coordination scale.

**When the elementary refusal determines the binary law.** Let R⊆{0,1}ⁿ, n≥2. Suppose its projection onto one chosen n−1 roles is the full cube, and no two admitted forms differ at exactly one role. Then R is exactly one parity class. The parity law is a conclusion from these two admission requirements.

*Proof.* Write a form as (x,t), with t at the omitted role. Full projection gives at least one t for every x. The elementary refusal gives at most one, so t=f(x). If x and y differ at one role, f(x) and f(y) must differ too, or their full forms would violate the refusal. On a binary carrier this forces the output to exchange its two values at every such change. Starting at 0ⁿ⁻¹ and changing the nonzero coordinates of x gives f(x)=f(0ⁿ⁻¹)⊕parity(x). Thus R is exactly the class with total parity f(0ⁿ⁻¹). QED

One exhibited admitted form fixes which class it is. No independent parity equation, probability, metric or temporal law was assumed. All other proper projections are full as a consequence. The established refusal also rules out any process between distinct admitted forms consisting only of changes to one role while retaining these roles and this complete R. Pair flips connect the class, giving κ=2, though their physical availability still requires actual operations.

Full projection can be weakened when the question concerns a smaller supplied domain D⊆{0,1}ⁿ⁻¹. Require at least one completion for every x∈D and the same elementary refusal. The unique completion f again changes at every one-role edge inside D. Hence f(x)⊕parity(x) is constant on each connected component of that domain graph. Conversely, one freely chosen binary value per component defines every relation satisfying these requirements. One exhibited completed form in each component determines all its other completions. The full-cube theorem is the connected special case.

For a particular target input, even knowledge of all D is unnecessary. A finite chain of inputs from an exhibited completed form to the target suffices, provided each input is known to admit a completion and consecutive inputs differ at one role. The refusal forces the answer along that chain. A richer domain retaining these admissions, refusals and role identities cannot change this answer. An oppositely completed target would contradict the finite chain. Thus a positive route can transmit a necessary answer without an exhaustive catalogue of possibilities. Claiming that no such route exists still requires the appropriate coverage. The chain orders the argument and supplies no physical sequence of those forms.

Each premise has content. Without full projection, a singleton relation obeys the refusal but omits most of a parity class. Without the refusal, the full cube has the projection. Binary alternatives are essential: on three-valued roles, c=a+b and c=a−b modulo three both have full (a,b) projection, no admitted one-role change and the given form 000, but differ at the same addressed input (0,1). This is an exact conditional identification of a relation, not a derivation of binary carriers or complete projection from happening. To apply it to a given phenomenon, those carrier, coverage and refusal facts must be established for the same roles. A few observed unchanged cases do not establish the universal refusal.

**An irreducible direct replacement need not require an irreducible process.** One proposed atom would be a pair x,y with no admitted intermediate assembled coordinatewise from their endpoint entries. That criterion fails in the presence of detours. Consider the single internal relation

    R = {(a,b,c) ∈ {0,1}³ : c=1 or a=b}.

With c fixed at zero it admits only 000 and 110. Every proper partial replacement between them violates a=b. But the whole relation admits

    000 → 001 → 101 → 111 → 110.

Each step changes one coordinate. The c=1 forms permit independent a and b, and the final change restores c=0 only after their agreement is restored. Every displayed edge has its reverse within R. The fixed-zero fragment needs width two, while the same endpoint pair has width one in the full internal relation. The distinction between these conclusions is the retained or changing context, not an external exception to the law. The same relation is satisfied throughout the detour.

This example changes which constraint the addressed fragment must satisfy through a resident coordinate. LQ12's earlier example instead changed its permitted moves while keeping the same parity admission condition. Both are possible descriptions of a regime change, and neither should be silently substituted for the other. A physical phase interpretation would have to establish which kind of change its actual construction permits.

**Two meanings of greater freedom move differently.** On fixed addresses, if R⊆R′, every old path is still available in the enlarged compatibility envelope. Hence κ_R′(x,y)≤κ_R(x,y) for old endpoints. Yet LQ13's R₀⊂R₁⊂R₂ example shows that a uniform local law can become invalid and then valid again. Opening more forms can ease a particular rearrangement while making a universal law harder to satisfy. These are two precise properties of a changing logical medium, not one scalar liquidity.

**The whole need not have finitely many parts.** For arbitrary I, use finite paths whose individual changes have finite support. Two admitted endpoints can be joined in this envelope exactly when they differ at finitely many addresses. Necessity follows because the union of finitely many finite supports is finite. Sufficiency is the direct finite-support change between those endpoints. Within each such class the same integer minimum and strong triangle argument apply. Endpoints differing at infinitely many addresses have no finite path of this kind. A proposed limiting process would require its own convergence and continuation relation. This result does not impose finite support on reality. It states exactly what that construction premise implies, without assuming a finite whole.

The quantity κ depends on the addressed decomposition. A permutation of addresses and independent bijections on their carriers preserve difference supports, so they preserve κ. An arbitrary encoding that mixes coordinates need not do so. It is not a physical energy, a duration or an entropy. Its direct use is sharper: to refute a claimed bounded-width rearrangement, prove that no path of that width fits the actual contact relation, including all its internal context changes. To establish actual attainability, bind a minimizing path to the medium's available constructions.

## §6d. Which independent blocks are forced?

**LQ15 (finite recombination determines a unique finest independent partition on fixed addresses).** Let I be a finite set of addresses and let R be a nonempty admitted family in ∏ᵢ Aᵢ. These are a set presentation of one fragment and its addressed distinctions, not an assumption that the whole has finitely many parts or that every logical environment is a product. For S⊆I, define the proposed splice

    c_S(x,y)ᵢ = xᵢ if i∈S, and yᵢ otherwise.

Call S a free cut when c_S(x,y)∈R for every x,y∈R. The test includes every admitted pair of descriptions. It does not assert that two such forms coexist or that their splice is an available physical operation.

**Free cuts determine each other by exact identities.** The empty and full cuts are free. Complementation exchanges the inputs: c_(I\S)(x,y)=c_S(y,x). If S and T are free, so is their intersection, because

    c_(S∩T)(x,y) = c_S(c_T(x,y),y).

Union follows by complementation. Thus the family C_R of free cuts is a Boolean subalgebra of the address subsets. This is an algebra of independently recombinable address masks. It does not assign Boolean truth values to every question in the medium.

For each address i, intersect all free cuts containing i. Since I is finite, this gives a smallest free block B_i. If j∈B_i, no free cut contains i without j. No free cut can contain j without i either, since its complement would separate them the other way. Thus i and j have the same membership in every free cut, and B_i=B_j. The distinct B_i are disjoint and cover I. Every free cut is a union of these blocks. Repeatedly splicing the finitely many blocks proves

    R = ∏_{B in P_R} π_B(R),

where P_R is the partition into the distinct B_i. Indeed, choose an admitted form realizing each proposed block value and splice the blocks into one admitted form. Conversely, every admitted form has those block values by projection. If R factors over any other partition P, each of its blocks is a free cut and hence a union of B_i. Therefore P_R is the unique finest product partition on these addresses. Any finer proposed separation inside one B_i fails the universal splice condition. An admitted pair x,y whose mixed form is forbidden is a positive obstruction to that proposed separation. An actual universal constructor proving splice closure can establish a free cut without enumerating the family.

The result excludes a choice between incompatible finest independent partitions once the addressed relation is fixed. It does not derive the addresses themselves. It also does not say that a coupled relation has no parts: the vacancy relation has meaningful addressed positions while its free-cut partition has only one block. An internal contact can be exactly what prevents independent recombination.

**The infinite extension fails without an additional premise.** On countably many binary addresses, let R consist of the sequences with finitely many ones. Every splice of two admitted sequences is admitted, for every S: its ones are contained in the finite union of the two source supports. Every finite partition gives a product factorization, because combining finitely many finite supports leaves finite support. Yet the product of the single-coordinate projections is the entire binary sequence space and contains the excluded all-one sequence.

There is no finest product partition in this example. Any partition into infinitely many nonempty blocks fails: choose one address per block, producing infinitely many ones while every block value occurs in an admitted finite-support sequence. Every partition into finitely many blocks can be refined by splitting an infinite block. Thus closure under all two-source splices does not imply unrestricted assembly of infinitely many separately possible choices. Neither absence of an outside nor successful finite assemblies supplies the missing premise.

**Finite-character admission supplies an infinite extension.** Suppose I may be infinite, but a proposed tuple belongs to R whenever each of its finite address restrictions occurs in an admitted form. This is an explicit completeness property of admission. Under it, C_R is closed under arbitrary intersections. For S=⋂_α S_α and any finite set F of addresses, finitely many S_α suffice to exclude every i∈F\S while retaining F∩S. Their finite-intersection splice belongs to R and agrees with c_S(x,y) on F. Finite-character admission therefore admits c_S(x,y).

The blocks B_i now exist as arbitrary intersections of free cuts. Their product again equals R: any finite restriction of a proposed assembly meets only finitely many blocks, which can be spliced from admitted representatives. The completeness premise admits the whole assembly. This proves the same unique finest partition without imposing a finite whole. In the finite-support counterexample every finite restriction of the all-one sequence is admitted, so this premise positively fails. The proof identifies the missing condition rather than inferring the impossibility of an infinite assembly from a finite check that did not perform it.

In this set presentation, finite-character admission is equivalently the condition that every excluded tuple has a finite forbidden restriction. It therefore states exactly when finite address evidence is complete for refuting a proposed assembly. The all-one sequence in the finite-support example has no such finite refutation. Completeness of finite refutations neither bounds their required size nor gives a terminating procedure for accepting every admitted infinite tuple. To establish a particular free cut, supply its universal splice construction; to refute one, supply an actual forbidden splice. The unique mathematical partition alone is not an acquisition procedure.

This completeness condition is sufficient for the finest-partition theorem, not necessary for every relation to have some finest partition. For example, add only the all-one sequence to the finite-support family. Any nonempty proper cut would have to admit both its indicator and its complement by splicing the all-one and all-zero sources. At least one of those indicators has infinite proper support and is excluded. Thus the only free cuts are empty and full, and the single whole block is the finest partition. The relation still excludes an alternating sequence while admitting all its finite restrictions. Having a forced inseparable block and having complete finite refutations are different properties.

An address permutation and independent changes of each carrier's notation transport P_R. An arbitrary encoding that mixes addresses can change what counts as a splice. For example, even parity on three bits is one inseparable block on its three original addresses, yet the bijection (a,b,a⊕b)↦(a,b) presents its four admitted forms as a product of two binary roles. Its inverse restores the constrained third coordinate. The encoding preserves the admitted forms but does not transport the original address roles as two independent coordinates. LQ12–LQ14 already require transport of the actual rearrangement relation for the same reason. The decomposition is forced by a relational presentation, not by its number of forms alone.

**A partition of jointly admitted roles requires a different law.** A free-cut block concerns independent recombination of values. To ask which roles belong together, fix instead a finite nonempty role set I and a downward-closed family K⊆𝒫(I) containing every singleton. A member of K is an admitted joint set for a specified relation. Downward closure means that selecting fewer roles from such a set preserves this admission. Neither a subject nor a partition is supplied. This premise concerns one finite presentation and does not bound the whole.

There is a partition P of I such that

    S∈K  iff  S⊆B for some B∈P

exactly when K satisfies the following overlap law:

    S,T∈K and S∩T≠∅  imply  S∪T∈K.

To prove necessity, intersecting admitted sets belong to the same partition block, which also admits their union. For sufficiency, every member of K lies in a maximal member because I is finite. Two maximal members cannot overlap: the law would admit their union, forcing both to equal it. The maximal members cover I because all singletons are admitted. They are consequently a partition, and downward closure supplies exactly all their subsets. Every partition with the displayed property has precisely these maximal members, so it is unique. This is a criterion for representation by disjoint regions, independent of the free-cut criterion above. Calling a relation connected does not supply its overlap law.

**One retained role can have a unique region even when there is no global partition.** Fix a∈I and form U(a)=⋃{S∈K:a∈S}. A unique maximal admitted set containing a exists exactly when U(a)∈K. If the maximal set is unique, every set containing a extends to it and their union equals it. In the reverse direction an admitted U(a) contains every such set and is their unique maximum. Downward closure also gives

    U(a)={a}∪{b∈I:{a,b}∈K}.

Thus pair contacts determine the candidate U(a), but the admission of that entire candidate is a further question. The family with maximal members {a,b} and {b,c} has unique regions through a and c and two maximal regions through b. It is closed under selecting fewer roles but fails the overlap law. The role retained in this question belongs to the same presentation. Its selection and its interpretation as a given occurrence have not been supplied by the theorem.

There is an exact positive obstruction to uniqueness through a: two admitted sets S,T containing a whose union is refused. A unique maximal region would have to contain both and hence admit their union by downward closure, a contradiction. Conversely, if uniqueness fails, choose two distinct maximal sets containing a. Their union is refused by maximality. Equivalently, failure of admission for U(a) has such an obstruction: build its finite union from admitted sets containing a, and take the first step whose union is refused. All earlier unions were admitted. Thus the finite criterion supplies both a sufficient complete region and a pair witnessing that no unique one exists. It does not require choosing one of the competing maximal regions.

**All pair contacts can survive while the proposed common region fails.** Let I={a,b,c} and K contain every proper subset of I. Every pair is admitted, but the triple is refused. The full family 𝒫(I) has exactly the same singleton and pair answers and does admit the triple. Therefore those answers cannot determine this joint-admission question on the two-source family. VI's factorization criterion gives the obstruction directly. For any n≥3, all proper subsets of an n-role set likewise agree between 𝒫(I) and 𝒫(I)\{I}, while the full-set answer differs. In the latter family I\{a} and I\{b} overlap for a≠b and their union is forbidden, explicitly violating the overlap law. No fixed bound on the size of inspected subsets settles every such question.

**Joint assembly has an exact symmetric composition.** On any such K, define μ(S,T)=S∪T exactly when S∪T∈K. It is idempotent and commutative. Both μ(μ(S,T),U) and μ(S,μ(T,U)) are defined exactly when S∪T∪U∈K, by downward closure, and then give that same union. Thus rebracketing preserves availability as well as the result, even when K has a refused triple with every pair admitted. Associativity and commutativity do not force a partition of jointly admitted roles. This operation is different from LQ16's retention of one specified input role: with S={a}, T={b}, Z={a} and {a,b} admitted, μ(μ(S,T),Z)={a,b}, while μ(S,Z)={a}. The first absorption law fails at an admitted contact.

**Contact-profile intersection has a precise completeness premise.** For S∈K, let N_K(S)={U∈K:S∪U∈K}. Whenever S∪T∈K, downward closure gives N_K(S∪T)⊆N_K(S)∩N_K(T). In the proper-subset family on {a,b,c}, the singleton {c} belongs to N_K({a}) and N_K({b}) but not to N_K({a,b}). The combined form has an additional refusal which the separate contacts omit.

For finite I the inclusion is equality at every admitted S∪T exactly when K is determined by its pair admissions: every set whose pairs are admitted is itself admitted. To prove sufficiency, if S∪T, S∪U and T∪U are admitted, every pair in S∪T∪U is admitted, so the whole union is admitted. This gives the reverse inclusion of profiles. For necessity, suppose pair admission is incomplete and choose an inclusion-minimal refused set F all of whose pairs are admitted. Every proper subset of F is admitted and |F|≥3. Partition F into three nonempty sets S,T,U. Their pair unions are proper subsets and hence admitted, while the triple union F is refused. Thus U belongs to both separate profiles but not the profile of S∪T, a contradiction. The proof names exactly the additional relation hidden by an unsupported intersection rule.

Conjunction of predicates on one fixed complete domain still has intersection as its truth set. The failed equality here concerns the compatibility profile of a constructed joint form. Treating that profile as the conjunction of the two separate profiles omits the possible extra constraint among all three participating sets. The medium supplies the construction relation needed to justify that identification.

A partition requires still more. The family with maximal sets {a,b} and {b,c} is determined by its pair admissions and obeys this profile-intersection equality, yet overlapping admitted sets can have a refused union. A classification that represents joint admission solely by equality of one region label must obey the stronger overlap law. Admission of {a,b} and {b,c} would force all three labels to agree and incorrectly admit their joint set. GluedEqualities already supplies the underlying equality composition in bare Swift. Richer constraints can retain the refusal, but change the representation from one partition to a more general joint relation. This is not an obstruction to VI's Pair constructor, as VC23a explains for parity.

Finiteness is material if the claim concerns complete admitted regions. On an infinite I, the family of all finite subsets satisfies downward closure and the overlap law and contains all singletons, but has no maximal member. It cannot be all subsets of partition blocks: admission of every pair would force a single block I, which is not admitted. A declared closure under the relevant infinite unions would be an additional premise. This parallels the earlier finite-character boundary without asserting that every episode or every support is finite.

**Forgetting the occurrence changes the boundary question.** Suppose an indexed description supplies role sets B_w for internal occurrences w. Here B_w records the complete membership assigned to that occurrence. Its completeness is part of this description, not derived from a label. Forgetting w leaves the admission family

    K={S⊆I : S⊆B_w for some w}.

This projection is downward closed. For a role a that occurs in it, its possible companions are

    U(a)=⋃{B_w : a∈B_w}.

The projected K has a greatest a-region exactly when some B_w contains U(a). Since that B_w contains a, it must then equal U(a). This asks whether one occurrence includes every companion supplied across those occurrences. It does not ask whether each individual B_w has a complete membership. Take distinct roles a,b,c and two occurrences g,h, with B_g={a,b} and B_h={a,c}. Both indexed sets are complete, yet K has no greatest a-region: it admits {a,b} and {a,c} and refuses {b,c}. Even a shared role a does not identify g with h.

The distinction applies on any nonempty I. Every downward-closed K containing the singletons has a presentation of the displayed form: take one index w_S for each nonempty S∈K and set B_{w_S}=S. If a nonempty T is contained in one of these sets, downward closure gives T∈K. Conversely w_T supplies it. The empty set is present on both sides because I is nonempty. Thus a K failing the overlap law can still be the projection of individually specified complete sets. Duplicating an index with the same membership changes none of K either. K alone therefore does not determine the identity or multiplicity of its indexed occurrences. These are counterdescriptions to reconstruction from this projection. They do not establish which arrangements can be experienced.

If each role is instead required to belong to exactly one indexed occurrence, the nonempty B_w are disjoint and their projection satisfies the partition law. Unique occurrence membership is the extra requirement doing that work. An overlap refusal cannot be used to refute the unity of the original given G after G's occurrence correspondence has been erased. Conversely, naming all roles incident to g as a set does not establish that our record covers that set, or that mere membership captures the experienced joint relation. Those remain source obligations. VC84's sufficient input interfaces answer a further question and need not be these regions.

**Partial evidence can settle a boundary question without supplying K.** Now allow I to be any nonempty set, and retain a∈I. A greatest region through a means an admitted B containing every admitted set through a. For finite I this is equivalent to a unique maximal region. On an infinite carrier those two questions must be distinguished.

Let P₊ contain certified admitted sets and P₋ contain certified refused sets for the same joint relation and the same addressed roles. Define

    L = {S⊆I: |S|≤1 or S⊆P for some P∈P₊},
    U = {S⊆I: no N∈P₋ satisfies N⊆S}.

Assume L⊆U, so the supplied answers are consistent with downward closure and admitted singletons. The compatible descriptions are exactly the downward-closed K with L⊆K⊆U. An unobserved set has not thereby been refused. These K are alternative descriptions of the relation being investigated, not additional realities outside the whole.

Put A=⋃{S∈L:a∈S} and C={z∈I:{a,z}∈U}. A contains the mandatory companions, and C the possible companions, with A⊆C. The exact family of boundaries that can be the greatest a-region in a compatible description is

    ℬ = {B∈U: A⊆B}.

Necessity follows because a greatest region must contain every certified set through a and must itself be admissible. Conversely, for any displayed B, construct K_B=L∪𝒫(B). It is downward closed, remains inside U, and contains all supplied positive answers. Every one of its members containing a lies inside B, since those from L lie inside A. Hence B is its greatest a-region. This proves the exact family without completing every unknown admission answer.

It follows that no compatible description has such a region exactly when A∉U, equivalently when some certified refused N is contained in A. Otherwise K_A supplies a compatible description with greatest region A. The construction establishes what the data permit. It does not certify K_A as the actual relation.

There is also an exact criterion for when every compatible description has a greatest a-region:

    C∈L  or  |C|≤2.

If C∈L, it is admitted in every K and contains every possible companion, so it is always the greatest region. If |C|≤2, the only possible sets through a are {a} and possibly one pair, and a greatest member always exists. For necessity, first consider K=L. It has a greatest a-region only if A∈L. If C=A, this gives C∈L. Otherwise choose b∈C\A. When A contains x≠a, the compatible description L∪𝒫({a,b}) has both A and {a,b}, but no admitted set containing their union: such a set belongs neither to L nor to 𝒫({a,b}). When A={a} and |C|≥3, choose distinct b,c∈C\{a} and use L∪𝒫({a,b})∪𝒫({a,c}). It likewise has no greatest a-region. These constructions apply to infinite I as well.

Thus the partial data force absence exactly when A∉U, force existence exactly under the displayed condition, and otherwise admit explicit descriptions giving opposite answers. To force the same particular boundary in every description requires C∈L, and that boundary is C. Indeed any such boundary must equal A in L and contain each possible companion b in L∪𝒫({a,b}), so A=C∈L. Knowing that a boundary exists can therefore require less than identifying it. With I={a,b} and only singleton answers supplied, a greatest a-region always exists but can be {a} or {a,b}. This is VC15's distinction between an invariant answer and selection applied to the boundary question.

**A finite refusal can survive every enlargement of the described carrier.** The absence criterion has a direct certificate: retain one refused set N and, for each n∈N, an admitted contact {a,n}. Any greatest a-region would contain every n, hence N, contradicting downward closure. If N is finite, this certificate uses finitely many actual answers. It remains a refutation in every larger, possibly infinite, carrier preserving those contacts, that refusal and the same relation. New internal roles cannot repair the contradiction. No complete enumeration of K, maximal regions or hidden roles is required.

For example, {a,b} and {a,c} can be admitted while {b,c} is refused. A purported greatest region through a must then include a,b,c and would admit the refused pair. More generally, one higher-order refusal can be covered by many separately admitted contacts through a. The certificate need not include two already certified large sets whose union is explicitly refused. This is an application of downward closure, not a claim that every infinite failure has a finite certificate: all finite subsets of an infinite carrier admit every finite test and still have no greatest region.

**Positive closure needs a different obligation.** Suppose a description on I does have a greatest a-region B. Add a previously unrepresented internal role z and define K′=K∪𝒫({a,z}). Every old admission and refusal on I is unchanged, but B is no longer greatest. If B contains b≠a, B and {a,z} have no admitted common extension. If B={a}, the new greatest region is {a,z}. Thus even complete knowledge of the old relation does not establish its coverage of all relevant internal roles. A positive certificate for B consists of its admission together with the universal boundary relation {a,z}∈K ⇒ z∈B. A structural derivation of that relation can suffice without enumerating z. Closure of the physical whole supplies no missing coverage claim for a particular description of it.

Finally, the infinite maximality distinction has an explicit counterexample. On I={a,b}∪{c₀,c₁,…}, take K=𝒫({a,b}) together with every finite subset of {a,c₀,c₁,…}. Its only maximal member is {a,b}, since every member of the other family can gain another cᵢ. Yet {a,c₀} is admitted and has no extension into that maximal member. There is no greatest a-region. The finite refusal above excludes a region containing all compatible companions, while uniqueness of an unextendable member alone can survive. Using the latter as a complete boundary would leave an entire admitted direction unaccounted for.

These certificates concern actual answers to one stated joint-admission question. A failed measurement, an absent declaration or a change of context is not automatically a refused set for that relation. Its roles may be situated inside the whole while their correspondence to an experienced episode remains to be established. The improvement is an exact account of which partial data already settle the structural question and which coverage premise a positive boundary still needs.

## §6e. Can the relation supply its sides?

**LQ16 (self-contact and contextual substitution force a determinate two-role contact).** Start with a nonempty family W of forms and a ternary relation Γ⊆W×W×W. Write Γ(x,y) for all outputs u related to the ordered inputs x,y. Neither a pair of coordinate spaces nor uniqueness of an output is supplied. Require:

1. Γ(x,x)={x} for every x.
2. If u∈Γ(x,y), then Γ(u,z)=Γ(x,z) for every z.
3. Under the same premise, Γ(z,u)=Γ(z,y) for every z.

These are substantive laws of this proposed relation. They are not consequences of calling it a cut. The second law says that forming u retains x's first role in every continuation of this kind; the third retains y's second role. Equality includes the empty output family, so the laws preserve refusal as well as successful outputs, as required by VC46–VC47. No temporal order is inferred from writing an input and an output role.

Let a(x) be x's class under equality of complete rows Γ(x,−), and b(x) its class under equality of complete columns Γ(−,x). Set A=a(W), B=b(W), and R={(a(x),b(x)):x∈W}.

These rows include the actual result forms. The admission profiles of LQ13 omit that result information. In a full product contact, every first-side form admits every partner, so its admission boundary is constant. Recombination still retains which first-side form appears in the result. Recovering that role and recovering the minimum admission interface answer different questions.

**No form distinction is lost by the two roles together.** If a(x)=a(y), then Γ(y,x)=Γ(x,x)={x}. If also b(x)=b(y), the same Γ(y,x) equals Γ(y,y)={y}. Hence x=y. The map x↦(a(x),b(x)) is a bijection between W and R.

**Every admitted result is unique.** An actual u∈Γ(x,y) gives the finite chain

    Γ(x,y) = Γ(u,y) = Γ(u,u) = {u}.

The first equality is law 2 at z=y; the second is law 3 at z=u; the last is exact self-contact. Thus Γ is the graph of a partial operation m. A certificate for one contact needs these source-bound equalities of complete output families, not an enumeration of alternative outputs. Checking only that u is one successful output would not supply them. Determinacy at arbitrary inputs has been derived from exact self-contact and contextual substitution, rather than imposed as a property of every relation in the medium.

**The domain is exactly the reconstructed contact.** When u=m(x,y) exists, laws 2–3 give a(u)=a(x) and b(u)=b(y). Conversely, suppose a(z)=a(x) and b(z)=b(y) for some z∈W. Substituting the equal row and column into m(z,z)=z proves that m(x,y) is defined and equals z. Consequently

    m(x,y) exists  iff  (a(x),b(y))∈R,
    m(x,y) is the unique form with those two roles.

Every nonempty ordered relation R⊆A×B with A and B restricted to its projections supplies such an operation: combine the first field of x with the second field of y exactly when the result lies in R. Its partial rows distinguish precisely the first fields, and its partial columns distinguish precisely the second fields. For row separation, two different first fields cannot produce the same output at any shared admitted column, while each row has at least one output; the column argument is symmetric. Thus any exact two-role presentation of the given operation differs only by independent bijections of A and B. The sides and their contact have been reconstructed from m, rather than installed before it.

**The premises exclude explicit alternatives.** If exact self-contact is weakened to x∈Γ(x,x), the relation Γ=W³ on a two-form W satisfies both substitution laws but has two outputs everywhere. If equality is required only where both compared applications happen to be defined, take the four pair forms 00,01,10,11, allow every diagonal m(x,x)=x, and additionally allow m(00,11)=01. Forbid all other applications. Every permitted result has canonical mixed fields, so both absorption equations hold wherever both sides are defined. But m(01,00) is forbidden while m(00,00) is allowed. The result 01 has not retained 00's full first-role availability. This relation fails law 2 and cannot be certified by checking successful outputs alone.

This reconstructs the roles of one operation. Its two input places remain a premise: the argument has not derived binary arity or VI's primitive Pair from an unstructured whole. Nor does it prove that every form has two spatial parts, that those parts are independent, or that one such operation is uniquely selected by internal closure. The converse admits every nonempty binary contact, so these laws classify recombination without selecting which contact is realized. A diagonal-only operation m(x,x)=x satisfies all three laws and reconstructs a fully coupled diagonal relation. A first projection m(x,y)=x also satisfies them and gives one singleton side. Nontrivial independent roles need further actual relations. A contact is not made physically real by finding a convenient mathematical factorization.

**Which form returns in exact self-contact?** Suppose a proposed new occurrence takes h to h′ and an actual retained reading distinguishes them: r(h′)≠r(h). Then h′≠h, so that same full output cannot satisfy Γ(h,h)={h}. This finite obstruction needs neither a numerical clock nor a bound on the whole. A local form reading π can nevertheless satisfy π(h′)=π(h). Exact recombination of the local form and a new retained occurrence can therefore coexist on these different addressed readings. M55 states proper extension through the actual retention correspondence, with a witnessed occurrence outside the old image. That witness survives faithful continuation. Even an infinite history with the same abstract order type can extend properly: equality of endpoint patterns can omit which old occurrence was retained where. The recursive-record counterexample separately prevents deriving novelty from the append shape alone. LQ16 reconstructs the roles of the specified recombination. Using it for the birth of an occurrence requires stating whether W carries the local form or the complete contact that distinguishes the occurrence, including its retention relation.

**The same requirement works at every positive finite arity.** Let Γ now relate n input forms to an output, with finite n≥1. Require Γ(x,…,x)={x}. Whenever u∈Γ(x₁,…,xₙ), require that u and xᵢ be interchangeable in input place i in every further Γ-context, including refusals. Replacing the n inputs one at a time by u reduces that entire output family to Γ(u,…,u)={u}, proving determinacy. Define aᵢ(x) by equality of complete place-i contexts. If aᵢ(x)=aᵢ(y) for every i, the same finite replacement takes Γ(x,…,x) to Γ(y,…,y), so x=y. Every admitted output therefore has the uniquely determined role tuple (a₁(x₁),…,aₙ(xₙ)). Conversely, any realized role tuple supplies an admitted output by the same finite substitutions into its diagonal. This reconstructs exactly an n-role contact.

The proof does not select n=2. Binary constructor notation can represent a finite list of roles, but its grouping must preserve the joint contact. Erasing that contact in favor of separate pair projections would repeat VC23a's failed translation.

**An infinite-input counterexample shows where the proof stops.** Take W={0,1} and countably many input places. Let Γ(s) contain 0 exactly when the sequence s has infinitely many zeros, and contain 1 exactly when it has infinitely many ones. Every input has at least one output. Constant inputs have their exact singleton diagonal outputs, while an alternating input has both. Changing one input place preserves the output family, so every place-i substitution law above holds, for either proposed output. Yet Γ is not single-valued, and no one input place distinguishes 0 from 1. The finite replacement argument cannot replace all infinitely many places. A collective distinction has survived every such finite substitution.

This is a represented infinitary relation, not an assertion that an actual physical process can acquire infinitely many inputs. It refutes promotion of the finite-arity theorem to every relation of a potentially infinite whole. A limit-admission premise can restore the proof: for each output u, require that Γ admit u at a proposed input whenever every finite restriction of that input occurs in some input admitting that same u. The output is fixed throughout; allowing a different output at each finite restriction would be another premise. Finite substitutions from one diagonal supply those restrictions at the other diagonal, and the premise carries u to the limit, proving joint separation. The same argument carries a realized role tuple to its proposed mixed input and recovers the contact. This premise is also necessary for such an exact role presentation: inputs producing u form the product of its place-i role classes, and membership in that product is fixed by the individual places. The displayed counterexample fails the premise: every finite restriction of the all-one input extends to an eventually-zero input admitting 0, but the all-one input refuses 0. Thus the needed infinitary completeness condition is stated and attacked, rather than inferred from closure of the whole.

**Total binary recombination is the independent special case.** If m is total, the contact is all of A×B. The two absorption laws give

    m(m(x,y),m(z,t)) = m(x,t).

Conversely, this identity together with m(x,x)=x gives both absorption laws by setting the appropriate inner pair equal. Thus these two identities characterize this total product construction. Idempotence alone is insufficient: ordinary minimum on a two-element ordered carrier is idempotent, but with x=1,y=0,z=1 its first absorption would identify 0 with 1.

**Equal results in both orders force equal sources.** Suppose m(x,y) and m(y,x) are admitted and equal to u. Their reconstructed first roles give a(x)=a(u)=a(y), and their second roles give b(y)=b(u)=b(x). Joint separation therefore yields x=y, and self-contact then gives u=x. A commutative m satisfying LQ16 can consequently have only diagonal applications. A total commutative instance has just one form. This is an incompatibility between exact role retention and symmetric single-result assembly of different forms. LQ15's union construction avoids it by obeying different absorption laws.

There is a stronger boundary for readings of that single result. Let q:W→Q have a fixed answer vocabulary and require q(m(x,y))=q(m(y,x)) wherever both results exist. Two forms sharing their first role produce each other as the two mixed results, so q must agree on them. The same is true for forms sharing their second role. Agreement propagates along the bipartite contact graph of R. Thus q is constant on its connected components. Conversely, both mixed results belong to the same component, through their shared roles with the original forms, so any function of that component satisfies the requirement. The component is exactly the most detailed such order-insensitive reading. On a full product it is constant. This recovers LQ13's common-content object from the interchange requirement, without assuming q separately readable from each role in advance. A reading which also retains the complementary result has a different input contract.

**Exactly when can one mixed result recover both sources?** For any admitted m(x,y)=u, the diagonal m(u,u)=u supplies a second source description with that output. If x≠y, the ordered pairs (x,y) and (u,u) cannot be equal. Thus every admitted off-diagonal application obstructs recovery of its complete ordered input from its result alone. Conversely, when only diagonal applications are admitted, u↦(u,u) recovers both sources. Under these laws, single-output recovery of the entire input is possible exactly in the diagonal-only domain. No extra historical record is needed in that domain: the construction relation itself fixes the two sources.

This obstruction uses only idempotence and the admission of the output's diagonal, so it applies to LQ15's joint union as well. The union can determine which contents are present while omitting which input sets supplied them or which overlap was used. The complete application or a retained source correspondence can preserve those distinctions. They have not been shown to disappear from the whole. Seam SG3 states the additional correspondence needed when a union concerns occurrences rather than repeated content.

For finite W, the exact fiber at u in the reconstructed presentation is

    m⁻¹(u) = a⁻¹(a(u)) × b⁻¹(b(u)).

Every such source pair selects u's admitted roles, so the equality includes the domain condition. A source-preserving residual therefore needs at least the maximum of these fiber sizes as its fixed alphabet size (M35). In contact notation the size at u=(a,b) is |N(a)| times the number of first-side forms compatible with b. This bound is conditional on recovering the complete ordered input. A question that ignores some of its distinctions can require less.

**Keeping complementary results constructs a recovery where they fit.** Where both cross-results exist, define E(x,y)=(m(x,y),m(y,x)). Applying E again gives (x,y), by absorption and the diagonal law. Its domain is closed under this inverse. Therefore equal complete E-outputs force equal ordered sources, without an additional record of those sources. This is a conditional recovery theorem from the constructed exchange. It does not infer global injectivity from internal closure alone, nor require this particular residual when a smaller question or a narrower source domain suffices.

This recovery also permits forgetting the order of both source and result together. Let τ(x,y)=(y,x). The admitted domain is τ-stable and Eτ=τE. Hence E induces an involution on the τ-orbits: [x,y]↦[m(x,y),m(y,x)]. It recovers the unordered pair from the unordered pair of complementary results without choosing an orientation. These are unordered two-entry pairs, including repeated entries, rather than a claim that two occurrences of equal content are one event. Applying this quotient to the output while still demanding the ordered source would fail on every distinct exchanged pair. The law transports the distinction of order or intentionally omits it on both sides. It does not erase arbitrary source distinctions in the name of symmetry.

The domain restriction matters. In the vacancy contact R={00,01,10}, the sources x=01 and y=10 admit m(x,y)=00 while the complementary result m(y,x)=11 is forbidden. Both source forms and one local result exist, but this two-form exchange leaves R×R. A richer internal carrier may retain what the chosen result omits. Its compatibility must be established; naming that omitted content an environment does not supply an admitted carrier. Conversely, the full product relation admits both cross-results and the involution. This excludes the inference from a legal local output to an automatically legal closed exchange.

The vacancy obstruction excludes more than the displayed exchange. The four ordered sources (00,00), (00,10), (01,00), (01,10) all give the same primary result 00. A residual restricted to R has only three possible forms. No encoding with that fixed primary result and one R-valued residual can recover all four sources, regardless of how it assigns the residual. A path of several internal steps cannot remove this final-image obstruction. A prepared domain excluding one source, a larger residual or a changed primary contract alters the question. Counting all nine pairs in R×R would miss the obstruction within the fixed-primary fiber.

There is an explicit larger construction. Retain the raw complementary fields (a(y),b(x)) in A×B without asserting that they form an admitted contact in R. The map (x,y)↦(m(x,y),(a(y),b(x))) then recovers x=(a(x),b(x)) and y=(a(y),b(y)) from its displayed fields on the admitted source domain. In the example its residual is the code 11. That code can be a valid record even though 11 is an excluded vacancy contact. The actual output domain consists precisely of the pairs whose recovered sources are both in R. A disjoint internal preparation/output phase can join this map and its inverse into one reversible relation. This constructs a possible larger carrier; it does not establish that a particular physical system has it. The existing static exchange already retains the raw pair, while the vacancy consumers correctly refuse to treat it as an admitted vacancy.

**Enough residual states need not supply the required relational roles.** M35's fiber bound is sufficient for an unrestricted finite encoding. Requiring it to respect internal relabelings adds VI1a's symmetry condition. Take the five contacts

    (a₀,b₀), (a₀,b₁), (a₀,b₂), (a₁,b₀), (a₂,b₀),

and four isolated contacts (cⱼ,dⱼ), with all cⱼ,dⱼ new. There are nine admitted forms. The largest primary fiber, at u=(a₀,b₀), has 3×3=9 members, so a nine-form residual meets the unrestricted capacity bound. Independently exchanging a₁ with a₂ and b₁ with b₂ preserves the whole contact relation and fixes u and the four isolated contacts. The four sources ((a₀,bⱼ),(aᵢ,b₀)), i,j∈{1,2}, form one orbit of size four under these exchanges. The proposed residual carrier R has only orbits of sizes one and two. An equivariant injective residual would have to send that four-element source orbit to a four-element residual orbit, which does not exist. Thus no such encoding into R is possible without an additional relation that changes the symmetry requirement.

The raw complementary pairs (aᵢ,bⱼ) do have the required four-element orbit. Their transformation behavior, as well as their number, is part of what makes them suitable residuals. This is an application of VI1a to the actual contact fiber. It prevents replacing an internally related memory by an equal-sized list of unrelated labels and treating that replacement as cost-free. The counterexample does not deny the unrestricted encoder; it identifies the extra relation that encoder would need to respect or supply.

Matter M70 tests the larger consequence of leaving that supply free. Every finite local deterministic law has a reversible completion over a suitably prepared internal carrier for any finite requested horizon. The record can inherit the source's symmetry. Closure and recovery therefore do not select the local law while this preparation remains unrestricted. For a specified finite carrier, sustained reset has a sharp horizon bound; a faithful record of each occurrence strengthens it. Entropy can remain unchanged throughout. The relevant restriction belongs to which residual forms and continued uses the actual whole admits.

IiS20–IiS21 supply a different obstruction after the preparation geometry is fixed. Some local transformation requests have no common residual at any dimension, although every proper preparation subfamily has a realization. Equal overlap magnitudes force residual phases to agree around cycles. A failed cycle cannot be repaired by enlarging a blank environment. The example keeps every matched mixture entropy unchanged as well. An already prepared two-dimensional internal record can instead change the relevant Gram relation and permit the transition. This separates free capacity from an available source-related preparation. In the exact equal-magnitude regime, a spanning forest and its remaining cycle equations certify the whole fixed overlap graph. The quantum geometry supplies these contact equations; they are not asserted for every LQ16 contact on the basis of their shared word relation alone.

For a shared-equality contact, however, the two source contacts and one crossed contact force the other. This is exactly LQ13's three-corner criterion, now applied to a resident exchange. `EqualityContactCut<X>` uses these three equalities at the actual source fields. The generic complementary-contact proof derives the fourth equality, and a second application is admitted from the first output without a new contact premise. A positive relation about the two originals separately is insufficient when their boundary values differ. Thus the same obstruction that limits a compressed interface also determines when one legal cross-result guarantees this reversible completion.

**Availability-preserving rebracketing forces exactly that shared-equality class.** Require, for every x,y,z, that m(m(x,y),z) and m(x,m(y,z)) be defined together and agree when defined. Agreement of their values already follows from LQ16 wherever both bracketings exist. The extra condition is their availability. Write x=(a,b), y=(c,d), z=(e,f). The left bracketing requires R(a,d) and R(a,f); the right requires R(c,f) and R(a,f). Since y is admitted, preserving definedness says: given the contacts (a,f) and (c,d), the two crossed contacts (a,d) and (c,f) must occur together. This is precisely LQ13's three-corner condition. Conversely, that condition equates the displayed domains and supplies the required rebracketing law. Palindromic triples x,y,x already suffice to force the condition, by taking x=(a,f) and y=(c,d).

The vacancy contact fails this test positively. With x=00, y=10 and z=01, the left bracketing gives m(00,01)=01 after the admitted intermediate 00. The right bracketing needs the forbidden intermediate m(10,01)=11. Rebracketing changes availability even though the formal mixed fields of both final expressions agree. Thus one precise additional composition requirement excludes every nonrectangular contact from this representation. It does not exclude those contacts from the whole: they remain representable with their actual domains. A different composition relation or retained joining witness must carry any stronger associativity claim.

The Swift constructors use canonical pair fields for this fragment. `PairRecombination<X>.Right` obtains the first inner field from X.Left and the second from X.Right. The full generic application still names X through its parameter and Left field. The recovery obstruction concerns its Right image, not that complete application or the retained source text. ReversedCutAgreement<X> derives equality of the two original field pairs from equal complementary results. A diagonal family supplies the positive construction, while the 01/10 source refuses that equality of results. `ResidentCutExchange<X>.Right` retains both complementary combinations. Its inverse is a new application whose only source parameter is that Right image. Generic equalities in Checks/Interactions.swift derive the absorption identities, the double exchange, transport of the source swap to the output swap, and recovery of all four source fields from equal complete outputs. They do not assume the desired result as a separate marker. A custom nominal Pair can carry distinctions beyond its two projected fields; double exchange reconstructs the canonical nested pairs, not an arbitrary nominal wrapper. That boundary is tested separately.

**Reconstructing the roles does not choose the relation.** A carrier with no supplied relations beyond equality has no distinguished nontrivial ordered product cut that respects every permutation of its forms. To see this, an equivalence relation preserved by every permutation is either equality or universal: one related distinct pair transports to any other. In an equivariant total recombination, its row and column equivalences would have this property. Joint separation and the full-product requirement leave only one equality equivalence beside one universal equivalence, hence one singleton side. VI1a already supplies the general stabilizer criterion behind this obstruction. The new requirement is concrete: an internal relation must remove the permutations that change the desired roles. Mere existence of some factorization does not do so.

Finally, W must include every distinction whose recovery is claimed. If two distinct joining forms have the same proposed endpoints, an endpoint-only reconstruction cannot both recover them by its diagonal law. The multiple alignments of VI1 already supply this case. Their internal correspondence has to survive in a role, in a further coordinate, or in a richer joining relation. The least admission interface of LQ13 does not promise that recovery. This is an attack on the proposed two-role description itself, not a demand for an observer outside the whole.

**LQ16a (coherent complementary exchanges force a shared boundary).** Keep LQ16's reconstructed contact R⊆A×B and its complementary exchange E on W=R. On triples of admitted forms, let E₁ exchange positions 1 and 2, and E₂ exchange positions 2 and 3. Each exchange is partial: both complementary results must belong to R. Then the following are equivalent:

1. E₁E₂E₁ and E₂E₁E₂ have the same domain and the same output on that domain.
2. R(a,b), R(a,d) and R(c,b) imply R(c,d).
3. R is a disjoint union of full rectangles A_k×B_k, where the nonempty A_k partition A and the nonempty B_k partition B.

Words are written in performed order. Condition 1 concerns equality of partial applications, including refusal, rather than agreement only where both words succeed. The roles A and B come from LQ16; they are not additional spatial coordinates or numerical measurements. The ambient triple family W³ is the declared domain of this theorem, not a deduction that three independently available physical forms are jointly available.

Indeed, agreement where both words succeed holds for every R: both words swap the first and third second-role values and retain the middle one. The new requirement is their common domain. It is an additional composition requirement, not a consequence of LQ16 alone. In R={00,01,10}, the first word is admitted on (00,01,10), but the second starts by exchanging 01 with 10 and requires the absent 11. Thus the same already-admitted source can distinguish the requirements without inspecting an arbitrary unknown interior.

*Proof of 1⇒2.* Given the three contacts, put x=(a,b), y=(a,d), z=(c,b). The first word has the admitted trajectory

    ((a,b),(a,d),(c,b))
      → ((a,d),(a,b),(c,b))
      → ((a,d),(a,b),(c,b))
      → ((a,b),(a,d),(c,b)).

The middle exchange retains two equal second roles. The other word must therefore be admitted. Its first exchange is between (a,d) and (c,b), so its complementary result (c,d) must belong to R. The missing corner follows from preservation of the domain. QED

*Proof of 2⇔3.* Two row profiles with a shared neighbor have the same neighbors: use condition 2 for each inclusion. Thus nonempty row profiles are equal or disjoint. Group the rows by their common profile B_k and call the corresponding row class A_k. These give exactly the displayed disjoint rectangles. Conversely each three-corner configuration belongs to one rectangle, which contains its fourth corner. QED

*Proof of 3⇒1.* A form (a,b) has the unique component k containing both roles. E(x,y) is admitted exactly when the two components agree, and retains that component at both positions. Either three-exchange word is consequently admitted exactly when all three components agree. Within that domain each elementary exchange swaps only the second roles. Both words send ((a,b),(c,d),(e,f)) to ((a,f),(c,d),(e,b)). QED

This derives the same shared-equality class as the preceding rebracketing criterion, now from a composition of exchanges that retains both complementary results. It does not introduce a second classification of compatible media. The common component k is determined by the incidence relation up to source-bound relabeling. It is not an extra bit acquired by a participant, and it can have just one value.

**A finite joint witness supports a nontrivial change and its continuation.** Suppose condition 2 holds and the actual source relations supply (a,b), (c,b) and (c,d). The fourth contact (a,d) follows. Hence E sends the jointly supplied pair ((a,b),(c,d)) to ((a,d),(c,b)). Both output forms are admitted, their components still agree, and the same exchange is admitted again and recovers the input. If b≠d is also established, both addressed forms change: their second roles differ, while their first roles are retained. No values of a,b,c,d need to be identified to derive these conclusions. For this specified role-transfer request the output is unique by LQ16's joint separation. This is not uniqueness of every possible action or of its physical implementation.

The pair carrier for that conclusion is the declared W². If a realization instead admits only K⊂W², the input and its exchanged output must both belong to K; preservation of K by E is one sufficient general condition. Individual membership of all four forms in R does not establish this joint membership.

One explicit mathematical construction needs no full W² as its resident carrier. For an admitted input p and its constructed exchange E(p), put K_p={p,E(p)} and restrict E to K_p. Since E²(p)=p, this is a total reversible operation on K_p. Any E-closed subfamily containing p must contain E(p), so K_p is the least such subfamily. If the second roles differ, its two members are distinct. The generating equation gives closure directly; no separately asserted preservation flag is used. This is minimal closure under this action, not minimum acquired information. Constructing K_p as a mathematical carrier does not establish its availability inside an independently given physical device, whose own K must still be respected.

That two-configuration construction uses partial involutivity alone. For several overlapping exchanges there is a corresponding construction after the common component has been established. Given a nonempty finite tuple p=((a₁,b₁),…,(a_n,b_n)) in one component, define

    K_p = {((a₁,b_{π(1)}),…,(a_n,b_{π(n)})): π is a permutation of 1,…,n}.

Every displayed pair belongs to R by rectangularity. Each neighboring exchange is total on K_p, and the braid and disjoint-exchange laws hold there. Any permutation is obtained by neighboring exchanges: move the required first entry to the first place, then repeat in the remaining positions. Thus K_p is exactly the least family containing p and closed under those exchanges. It has at most n! joint configurations even when A and B are infinite; equal second-role contents can make the bound smaller, with one configuration when all are equal. Finiteness concerns this generated orbit of a specified finite tuple, not the entire medium, its occurrence history, or the acquired information. One finite support for the common component consists of the n source contacts and the n−1 cross-contacts R(a_i,b_(i+1)): each links two neighboring source components, so all agree. No component label need be separately read. As before, constructing this carrier specifies a mathematical medium; an independently given joint carrier must admit the resulting paths for this construction to be realized there.

The source contacts and contrast are finite support for this application of the general law. They do not replace that law with a finite collection of observations. Within the full n-form carrier of one component, any finite word of neighboring complementary exchanges remains admitted and is inverted by its reversed word. Each exchange preserves every first role at its position, and the second roles are permuted without being erased. The result therefore carries the same admission basis needed by the next such exchange. Outside a common component, E² is identity only on E's domain; replacing it by an everywhere-admitted empty word would discard a refusal.

**Joint availability must remain in the theorem.** If the actual resident triples form J⊂W³, restricting each elementary exchange to inputs and outputs in J changes its domain. The unrestricted equivalence cannot be imported unchanged. Necessity uses the displayed three-corner triples and their intermediate forms. Sufficiency needs the relevant exchange paths to remain in J; closure under each admitted elementary exchange is one sufficient condition. A carrier containing only diagonal triples has no such coverage of the three-corner tests. A proof of the law on that carrier alone need not force condition 2 on all of R.

Both gaps have finite witnesses. For the nonrectangular R={00,01,10}, take J={(w,w,w):w∈R}. Every exchange on J is identity, so J is closed and satisfies the braid equation without forcing 11. Conversely, take the full rectangle R={a}×{1,2,3} and denote triples by their second roles. On J={123,213,231,321}, the first word has the path 123→213→231→321, while the other requires the excluded first intermediate 132. Rectangularity alone does not remove a joint restriction. For necessity at one three-corner instance, joint admission of the two triples (x,y,z) and (y,x,z) used above suffices; the proof does not require every triple in W³ to be physically present.

The construction distinguishes an admitted contact from an algorithm deciding contact membership, and a specified word from an autonomous mechanism that initiates it. Neither a total detector nor a physical scheduler follows from R. Returning the displayed content also does not return a complete occurrence with an additional retained history; M55 and the earlier self-contact discussion apply. The gain here is an exact condition under which composition retains the basis for further use, without a finite source catalogue or identification of unknown role contents.

The braid equation itself is established mathematics. [Ferri and Shibukawa, Introduction and §4.1](https://arxiv.org/html/2503.10327v2) study Yang–Baxter maps on composable quiver paths, including their involutivity. LQ16a proves the narrower criterion above directly for this particular complementary-exchange construction and its partial domains. No general Yang–Baxter classification, physical braiding, or scientific novelty claim is inferred from it.

**LQ16b (an already given joint carrier requires inward closure).** Fix one nonempty rectangle A_k×B_k obtained in LQ16a and a positive finite arity n. Let X=(A_k×B_k)ⁿ. The full neighboring exchanges E_i act on X by permuting second roles. Write G for this action of S_n; it need not be faithful. Let J⊆X be the supplied jointly admitted family. Membership in J is part of this mathematical source, not an admission oracle obtained from the definition of X. Define

    Cl(J)   = ⋃_{g∈G} gJ,
    Core(J) = ⋂_{g∈G} gJ.

Cl(J) is the least G-invariant family containing J. Core(J) is the greatest G-invariant family contained in J. For p∈X,

    p∈Core(J) ⇔ Gp⊆J
              ⇔ every finite neighboring-exchange word from p has its result in J.

The empty word is included. The last condition concerns all mixed words, including every prefix, not repetition of one chosen exchange or the existence of some infinite admitted schedule.

*Proof.* Multiplication by any group element permutes the families in the union and intersection, proving invariance. Any invariant family containing J contains every gJ; any invariant family contained in J is contained in every gJ. Also p∈gJ exactly when g⁻¹p∈J. Inverses range over G, giving the orbit criterion. Neighboring exchanges generate all permutations, and every word prefix is such a permutation. This proves both directions of the last equivalence. ∎

For J={123,213,132}, with distinct second-role values and fixed first roles, either exchange can be repeated indefinitely on its own from 123. The mixed word E₁E₂ reaches the absent 231. Individual repeatability does not supply joint repeatability. At n=1 there are no generators and Core(J)=J, which is why initial membership cannot be omitted.

The construction of K_p in LQ16a closes a proposed carrier outward. Core(J) instead respects an already supplied carrier. Neither construction physically prepares its members. In particular, adding an excluded form to Cl(J) cannot count as proving that form admitted by the original J.

**The permitted whole can remain unknown within an exact invariant.** Two configurations of X lie in the same orbit exactly when their ordered first-role vectors agree and their second-role multisets agree. Necessity follows from what exchanges retain. For sufficiency, match the finitely many occurrences of each second-role value and obtain a permutation. Thus J is G-invariant exactly when its admission is constant on those joint classes. Every G-invariant question factors uniquely through this orbit classification on its image. This is LQ13's general orbit propagation specialized to the constructed exchanges; it does not assert a new general classification of symmetry.

This permits genuine constraints on the whole. For example, requiring all second roles to be distinct is invariant, without requiring independence of those roles. Requiring the first two second roles to agree is generally not invariant when n≥3 and at least two second-role values occur: (b,b,d) exchanges to (b,d,b). The invariant class is derived from the operations. It is not an additional sensor output and need not be acquired to apply a uniformly established law. Each orbit has n!/∏_b m_b! members, where m_b are the positive multiplicities in the finite tuple. Its finiteness does not bound hidden histories of a physical realization.

There is also a precise obstruction to gaining unrestricted freedom by these same exchanges. If p∉Core(J), no exchange word can move p into Core(J), since every such move preserves the full orbit and Core(J) is a union of complete orbits. This rules out that particular stabilization request. It does not rule out preserving a smaller requested capability, changing the available operations or changing a jointly participating resource.

**An admitted path needs less than unrestricted freedom.** For each i put

    D_i = J∩E_iJ,    e_i = E_i|D_i : D_i→D_i.

Then e_i²=id on D_i. For p∈J, let Reach_J(p) contain exactly the endpoints of finite paths of these restricted exchanges from p. This is the least S⊆J containing p for which q∈S and E_iq∈J imply E_iq∈S. It is a connected component of the admitted exchange graph and has at most n! members. This closure only requires taking edges which exist. It is weaker than the requirement that every generator be available everywhere in the component.

In J={123,213,231,321}, Core(J) is empty: its only full orbit contains the omitted 132 and 312. Nevertheless the entire path 123→213→231→321 is admitted, and its reversed path returns. The alternative braid word fails at its first step. A particular request can therefore be met while the full coherent action on J is unavailable. Requiring Core(J) for that request would add an unnecessary obligation.

**The selected route can be made one internally controlled mathematical action.** Let w=i₁…i_L have positive finite length L, and let nonempty P⊆J be a supplied family on which all prefixes of w have their results in J. Form the forward-and-return label sequence α=(i₁,…,i_L,i_L,…,i₁) of length M=2L. Let u_j be its first j exchanges, with u₀=u_M=id. Construct the joint carrier

    Z = {(u_j(p),j) : p∈P, 0≤j<M},
    F(q,j) = (E_{α_(j+1)}q, j+1 mod M).

This is a construction of Z, not a claim that an independently given device admits J×{0,…,M−1}. Every displayed q lies in J: the latter half of the route retraces admitted edges. The rule F uses only q and the resident route position j. It neither recovers p nor calls a membership test for P. If the same pair has two presentations, its image is the same because the applied E and the next position are the same. Each route position has an inverse edge labelled by the preceding exchange, including the wrap to position zero. Thus F is a total permutation of Z and F^M=id. From (p,0), position L contains w(p). The whole joint orbit has M members because the position labels differ, although P itself may be infinite and the contents unknown.

The positions name the residual route, not an external clock or elapsed durations. Their introduction is a supplied internal control resource, not a deduction that the original pair already carries it. If termination is requested instead, retain the forward positions 0,…,L and admit F only below L; the final position has no next F-edge. That finite path does not by itself implement a physical halt. The cyclic construction gives a closed mathematical mechanism for choosing the next exchange, but does not initiate it physically, acquire a readout at the target position or store a new memory of the cycle. Full return and retained new history remain different requests, as M55 requires. This construction also does not make the uncontrolled exchanges total on the original J or assert minimal control information.

There is nevertheless a precise information statement. From every (p,0) with p∈P, the trace consisting only of the resident position and availability of the next F is identical: cyclic positions with every transition defined, or forward positions with only the final transition undefined in the terminating variant. The map from p to this trace is constant. Thus this particular control reading acquires no further distinction among the admitted original contents, although the requested transformation is carried out. This does not cover other readouts, physical timing or unmodeled channels, and does not minimize the size of the resident controller. An undefined final transition also does not by itself supply a physical refusal record.

These statements separate three questions: which formal composites agree, which paths an actual joint admission relation permits, and which changes a realization can execute. The first two do not manufacture the third. VC46–47 give the separate conditions for transporting domains and future answers through an actual reading. A finite formal orbit need not imply a finite whole: a changing internal history can be omitted when all requested continuations preserve the reading and their availability. Conversely, a residual that later disables an exchange cannot be omitted on the ground that the displayed roles have returned. The obligation is on the joint continuation, not on the current picture alone.

**LQ16c (a retained incidence can determine continuation without a route index).** LQ16b supplies an internal controller but still starts with a chosen word. A different question starts with the complete admitted neighboring relation itself. Let T be a symmetric irreflexive relation on W, and put D={(u,v):uTv}. This is a joint incidence carrier, not the free product W². Request a continuation (u,v)↦(v,w) along T which avoids w=u whenever another neighbor of v exists, and returns to u when there is no other neighbor. This is an explicit requested behavior; it does not follow from the mere existence of T.

For d=(u,v), its allowed output vertices are

    A(u,v) = N(v)\{u},  if this set is nonempty;
             {u},      otherwise.

There is exactly one output for every d∈D if and only if every nonisolated vertex has at most two neighbors. Indeed, one neighbor forces return, two force the unique other neighbor, and three or more leave at least two alternatives. Isolated vertices supply no incident inputs. Thus under this condition the request derives one total F:D→D without selecting a path, a global origin or a route length. W can be infinite.

The complete incidence is retained as (v,w), which is an input of the same kind. In this sense the output carries its next ground of application. The input's two roles remain part of the source. This theorem does not create a physical record of a previous state or claim that a given device already exposes D.

**Reversibility follows from two pairings of the same carrier.** Let α(u,v)=(v,u). Within D_v={(u,v):uTv}, let β exchange the two members when there are two and retain the member when there is one. Both are involutions. With ordinary function composition, F=α∘β and F⁻¹=β∘α, hence αFα=F⁻¹. Equivalently, F⁻¹(u,v)=(z,u), where z is the other neighbor of u if one exists, and is v otherwise. These pairings are reconstructed from T and its incidence roles. Their composition is a mathematical law, not yet a physical schedule for two separate actuations.

The same pairing construction can start from two supplied partitions of a common incidence carrier: one into pairs, the other into singletons and pairs. Each block has a unique exchange, or identity for a singleton. Their ordered composition is again a permutation. The order and the two partitions are given relations. This form can retain parallel contacts and distinct ports at the same endpoint; they must not be collapsed into the simple graph T if their different continuations matter. The conclusions below about reading a vertex use the simple-graph premise.

On a finite connected path with m≥1 edges, F is one cycle of length 2m. On a simple m-cycle it has two cycles of length m, one in each direction. On an infinite ray it has one two-sided infinite orbit, and on a double ray it has two. Following the only other neighbor until an endpoint, then returning, proves the path assertions; without an endpoint each orientation persists. No finite period is inferred for the infinite cases. The period or its absence belongs to the given incidence, not an independently programmed counter. This provides no duration or autonomous physical initiation.

For the complete admitted graph 123—213—231—321 in LQ16b, the resulting orbit is

    (213,123) → (123,213) → (213,231) → (231,321)
              → (321,231) → (231,213) → (213,123).

Its current-vertex reading is the previous six-position trajectory. The extra route index has been replaced by the actual incoming incidence. The six distinguishable configurations have not disappeared. Moreover, selecting this particular graph to encode a desired route would still program the geometry. The theorem applies to an already supplied complete relation; it does not derive which relation a task or a physical medium must have.

**Which distinction is necessary depends on the reading.** Put q(u,v)=v. At a degree-two vertex, its two incoming incidences have the same q and different qF. Thus q alone is not autonomous. More exactly, suppose h:D→S, V:S→S and Q:S→W satisfy hF=Vh and Qh=q. Equal h-values force equality of both q and qF. But (q(d),qF(d)) is the ordered pair F(d), and F is injective, so d is determined. Consequently every such exact autonomous description is injective on D. This is a concrete instance of VC15's minimal future distinction, not a minimum amount of physically acquired information. The carrier must retain the distinction; an external controller need not first identify it. A weaker requested reading can omit it, as the next criterion shows.

**An exact criterion for a coarser incidence reading.** Let G and H be simple undirected graphs with degrees at most two, and let h:V_G→V_H preserve adjacency. It induces h̄(u,v)=(h(u),h(v)) on incidences. Then

    h̄F_G = F_Hh̄ on D_G
        ⇔ h(N_G(v)) = N_H(h(v)) for every nonisolated v of G.

*Proof.* If h(v) has one neighbor, all images of neighbors of v equal that neighbor, so both continuations agree. If h(v) has two neighbors, agreement requires v to have two neighbors with different images: a single neighbor, or two with the same image, gives a projected return where F_H requires the other neighbor. Conversely, those two different images give exactly the required continuation. These are all cases. Isolated vertices must be excluded because D_G has no input testing them. ∎

This condition requires coverage of each target neighborhood, but not injectivity. For example, parity maps the integer line onto a single edge and folds its two neighbors together; the incidence continuation is still exact. The current target vertex determines the future in this two-vertex image, so the source direction can remain unknown. Mapping the integer line modulo m≥3 onto an m-cycle is locally bijective. It gives a finite, periodically returning incidence image of two infinite source orbits. Reuse of that exact image therefore needs no full-source return or identification of how far the source has progressed. Adjacency and local coverage are laws of the supplied joint map, not conclusions drawn from repeated matching samples. This criterion preserves this entire incidence operation; a still weaker query may require less.

**Uniqueness of the requested continuation can require less than a unique internal move.** More generally, let C(d) be a nonempty family of allowed successors of each d∈D, and let π:D→Q with Q=π(D) be the independently specified reading. A total V:Q→Q describes every allowed successor exactly when

    {π(e) : π(d)=q, e∈C(d)}

is a singleton for each q. Necessity follows from π(e)=V(π(d)); sufficiency defines V by that unique value. Induction transfers every finite allowed sequence through V, regardless of which successor occurred. Alternatives here describe allowed unknown realizations; no probability law is supplied. This is the relational version of the existing exact-descent criterion, not a new general principle of VI. Nonemptiness is material: a source which later has no next contact cannot be included under a total V without changing the contract. Partial interfaces must retain their availability distinctions as in VC46–47. If C only overapproximates the actual possibilities, the criterion is sufficient, but its failure does not prove that the actual narrower dynamics lacks the requested continuation. Necessity concerns the declared C. Likewise, the constant reading always satisfies the criterion; finding some convenient deterministic reading cannot establish a separately posed task.

For an explicit distinction of scopes, take a complete bipartite graph A⊔B with at least three vertices in each part. On incidences (u,v), allow every (v,w) with w adjacent to v and w≠u. The internal successor is never unique. But the reading that asks only which part contains v has the unique update A↔B for every successor, and this remains true at each continuation. No participant identity has to be identified for that question. This does not solve a task asking which vertex is reached, and the part reading must not be substituted afterwards for a stronger original request. Thus degree at most two is necessary for the earlier full-successor request, not a fundamental restriction on a medium supporting definite relational use.

**There are two remaining sources of choice.** At the center of an unlabelled star with at least three leaves, an automorphism can fix the input incidence and exchange two other exits. No choice of a nonreturning exit can respect all these automorphisms. VI1a supplies the general obstruction. An additional internal relation may break that symmetry, but the bare incidence does not provide it. On a general graph of higher degree, global distinctions may instead select an exit; the star argument does not exclude them. Separately, even at degree two, immediate return defines another total reversible action α. F is unique under the stated progression request, not under preservation of the carrier alone.

Finally, uniqueness of an output is not an algorithm for finding a hidden neighbor. Applying the rule constructively requires the actual singleton or pair incidence, including its coverage, or another established way to realize the corresponding exchange. Two observed responses do not prove that no third incidence exists. Nor does a missing response supply a terminal. This is where a source-bound construction is needed. The gain over the prepared word is an intrinsic continuation law once that incidence is supplied, with an exact test for its transport through a coarser reading. Physical realization of those relations is still a distinct obligation.

Oriented-edge carriers are established mathematics: [Ortner and Woess, abstract](https://arxiv.org/abs/math/0403414) use them for non-backtracking walks, in a probabilistic setting without the endpoint rule used here. [Bottinelli, Ciobanu and Kolpakov, §2.1](https://arxiv.org/html/1712.01418v7#S2.SS1) describe incidence geometry through permutations of darts. Neither source establishes the physical premises of this VI fragment; the determinacy, reversal and transport criteria above have been proved directly.

## §6f. Can one gradient determine the regions?

**LQ17 (one ordered scale of exact regions forces nested partitions).** Fix a nonempty role set I and a totally ordered family of levels Λ. At each level t let K_t describe the finite joint sets admitted there, including every singleton. Suppose stronger levels only remove admissions. Ask whether each K_t consists exactly of the finite subsets of the blocks of a partition P_t of I. This is a proposed representation of one specified relation. No intensity scale, experienced boundary or physical subject is supplied by the words level and region.

For each t the representation exists exactly when K_t is downward closed and obeys LQ15's overlap law. This criterion also works on infinite I when the question concerns only finite joint sets. Define a∼_t b when {a,b}∈K_t. The overlap law makes this an equivalence relation. Repeated overlapping union admits every finite subset of an equivalence class, and every admitted set lies in one class. These classes give the unique partition. This does not establish admission of an entire infinite class as one complete occurrence, the separate limitation identified in LQ15.

Since stronger levels remove admissions, ∼_t becomes finer with increasing t. Thus the partitions are nested. Conversely, any nested family of partitions supplies the stated K_t. A finite refusal at one level cannot be repaired by adding further levels while preserving its admission answers.

An exact pair-strength representation has an additional useful form. Let s:I×I→Λ be symmetric, with s(a,a) the greatest level, and stipulate a∼_t b exactly when s(a,b)≥t. Every threshold relation is an equivalence precisely when

    s(a,c) ≥ min(s(a,b), s(b,c))

for all a,b,c. Necessity applies transitivity at t=min(s(a,b),s(b,c)). Sufficiency applies the inequality to two pairs admitted at any one t. Only the order and its pairwise minimum are used. For real distance scales with the order reversed, the hierarchy correspondence is conventionally expressed through ultrametrics, as in [Carlsson and Mémoli, §3.3](https://www.jmlr.org/papers/volume11/carlsson10a/carlsson10a.pdf). Here it audits a proposed relational reading, without identifying experience with a clustering output.

**Crossed partitions refuse one such scale.** On four retained roles, let one reading group {a,b} and {c,d}, while another groups {a,c} and {b,d}. Neither partition refines the other. The pair a,b is together only in the first, and a,c only in the second. No ordering of those two levels can make both predicates thresholds of one monotone scale. This obstruction requires only the two pair distinctions. Calling one reading higher-resolution does not remove it.

A common refinement does exist: retain both class readings as one pair. On these four roles it separates all four. Either original partition follows by projection, and both can be coarsened to the single whole. There are two admissible refinement directions, with no single chain containing both crossed partitions. `CrossedRegionReadings` in the interaction checks constructs the two projections and their joint recovery from one four-role source. Positive zero/successor comparisons and two expected refusals test the failure of each proposed direction of coarsening. No outcome weight or empirical region assignment is encoded by those types.

The input to this comparison is one addressed role, and its reduced answer is that role's class label. A complete table together with the input's address is a richer input. Reconstruction of the whole displayed table must not be confused with decoding the omitted class from one local label. The type construction recovers the paired fields at every address. Its refusal witnesses select two roles with equal old labels and different required new labels.

Pairwise strength still cannot establish full joint admission without the overlap requirement. LQ15's admitted three pairs and refused triple defeat a region label even though the pair relation at that level is transitive. Replacing the original contact by connectivity would fill in that refused triple. A useful representation must retain it. Similarly, a proposed set of subject boundaries concerns one addressed occurrence and its actual membership, rather than all possible companions after forgetting occurrence indices.

**Without a strongest admitted level, a hierarchy need not contain a smallest represented region.** Return to the general ordered family, without the greatest-level premise of the pair-strength presentation. Let I be all infinite binary sequences and let level n partition them by their first n entries. Every finite level gives exact nested regions, each of which splits into two at the next level. Along the nested chain containing one fixed sequence there is therefore no smallest region. The intersection of that chain is the singleton containing the sequence, but that intersection is not one of the represented finite-level regions. Adding it changes the available family. A finite-depth version instead has terminal blocks. Consequently hierarchy and refinement alone establish neither an indivisible experienced atom nor its absence. A minimality claim must identify its region family and show where further relevant refinement ends.

## §6g. Must the reconstructed sides have their own dynamics?

**LQ18 (a fixed recombination cut and an autonomous reading are separate obligations).** Let m be an LQ16 contact on W, with its reconstructed, jointly separating roles a:W→A and b:W→B. Let U:W→W be total. The following requirements are equivalent:

1. There exist total f:A→A and g:B→B such that aU=fa and bU=gb.
2. Every admitted m(x,y) has an admitted m(Ux,Uy), and U(m(x,y))=m(Ux,Uy).

For 2⇒1, suppose a(x)=a(y). Then m(x,y)=y. Preservation gives m(Ux,Uy)=Uy, hence a(Ux)=a(Uy). Thus aU factors through a. If b(x)=b(y), use m(x,y)=x to obtain b(Ux)=b(Uy). Both maps are well-defined on the realized role sets. Conversely, write z=m(x,y). Requirement 1 gives a(Uz)=f(a(x))=a(Ux) and b(Uz)=g(b(y))=b(Uy). The actual form Uz realizes the mixed image roles, so LQ16 supplies their admitted contact and its unique result Uz. No finiteness or reversibility is used.

Requirement 2 preserves admitted results in the forward direction. Preserving refusals is an additional condition in this generality. On R={00,01,10}, the constant U(x)=00 has autonomous constant role maps and preserves every admitted result. But m(10,01) is refused while m(U10,U01) is admitted. If W is finite and U bijective, the distinction disappears: applying U to all three places maps the finite graph of m injectively into itself, hence onto itself, so refusals are preserved too. This finite reversible case must not be silently extended to every partial or infinite realization.

This equivalence audits a proposed explanation. Requiring U to preserve all recombinations does not derive role autonomy from less content: it is another presentation of exactly that requirement. Even preserving just the same-role absorptions used in the proof is equivalent. LQ16 reconstructs roles of m; it does not require a different operation U to preserve them. For a full product, requirement 1 is precisely U(a,b)=(f(a),g(b)): each next role ignores the other old role. For a proper contact, the admission relation can additionally restrict which such maps coexist, as in M64ak. Neither case establishes this fixed-cut requirement for every actual interaction.

**Moving the cut can make its preservation automatic.** If U is bijective, define a′=aU⁻¹, b′=bU⁻¹ and m′(u,v)=U(m(U⁻¹u,U⁻¹v)), with the transported domain. Then a′U=a, b′U=b and U(m(x,y))=m′(Ux,Uy). Every bijection admits this construction. It constrains no unknown U unless some reading or contact is specified independently of that transport. Obtaining the inverse-based reading may require the very information being sought. This is the same resource issue identified for a source-dependent frame in VC100f. A changed reading can be useful and exact; its correctness is not evidence that the stationary reading is preserved.

**A reversible four-form action defeats every complete autonomous binary cut.** Take W={P,Q,R,F}, with U(P)=Q, U(Q)=R, U(R)=P, U(F)=F. Let E be any binary reading and suppose EU=tE for one total map on its realized answers. Since U is onto, t is onto E(W). If both answers occur, t is a permutation of two answers, so t²=id. Also U³=id gives t³=id. Together these force t=id: applying t to t²=id and comparing with t³=id gives t=id. A one-answer image is fixed as well. Every autonomous binary reading is therefore constant on {P,Q,R}.

Consequently no family of individually autonomous binary readings, however large, separates the three moving forms. In particular, no choice of two binary coordinates gives a jointly complete fixed cut for this action. This obstruction is independent of coordinate names. Even allowing the two roles to exchange does not repair a complete two-bit cut: a bijective square map of that kind preserves the unique point opposite each point. The fixed F would force its opposite to be fixed too, whereas U has only one fixed form. The argument excludes the proposed autonomous decomposition, not the reversible action from the whole.

For a concrete complete coordinate reading, set E(P)=E(Q)=0 and E(R)=E(F)=1, and use (E,EU). Its values at P,Q,R,F are respectively 00,01,10,11. The induced action is

    00 → 01 → 10 → 00,    11 → 11.

The first coordinate agrees at P,Q but its next values differ. The second agrees at P,R but its next values differ. The full paired reading is exact and autonomous. Its two binary coordinates are not individually autonomous. An exact state description and an autonomous decomposition into its displayed parts are different achievements.

**A returning question constructs its least autonomous refinement.** Let K be any nonempty carrier, U:K→K total, and E:K→Y a total reading. Suppose, for a fixed positive integer r, that the addressed reading law EUʳ=E holds on K. The whole source need not return and K need not be finite. Define

    F(x) = (E(x), E(Ux), …, E(Uʳ⁻¹x)).

Then F(Ux) is the cyclic left rotation of F(x). The last coordinate follows from the one supplied return law; the other coordinates follow directly from the actual paths. Thus F has an autonomous reversible image even if U itself is not onto. Rotation maps F(K) into itself and its rth power is the identity, which supplies its inverse on that image.

Moreover, F is the coarsest autonomous refinement of E for all finite repetitions of U. Its equality preserves every future E-answer: reduce an exponent modulo r using the return law at each actual source. Conversely, if E=dH and HU=vH, equality H(x)=H(y) gives d(vʲ(H(x)))=d(vʲ(H(y))) for j=0,…,r−1, hence F(x)=F(y). Every autonomous refinement of E must retain these distinctions. This is a constructive periodic instance of VC15/VC38, not a new general minimization theorem. The source equation concerns one reading; the derived object serves the larger family of future questions. It neither assumes that E alone is autonomous nor obtains autonomy by adding that conclusion to E's requirements. The return law is sufficient for this construction, not necessary for autonomous knowledge in general: U(n)=n+1 and E(n)=n on the integers give a reversible autonomous reading with no positive finite return period.

In the four-form example the three-reading values are 001,010,100,111. They rotate, and the first two entries already separate all four forms. No fixed binary part retains a changing answer autonomously; the family of three binary readings instead transports its members cyclically. Allowing this relation between readings recovers an exact description of the interaction that the fixed-part demand excluded.

**The size obligation is exact, and depends on the question.** More generally, take one n-cycle and one fixed form, and any reading E. Let d divide n be the least period of the cyclic word of its n answers. Equality of all future answers gives exactly d classes on the cycle: equal shifted words have precisely the shifts in the period subgroup. If d>1, each such word is nonconstant and differs from the constant word of the fixed form. The least autonomous image therefore has d+1 states. If d=1, it has one state when the fixed form has that same answer, and two otherwise. In particular, on a prime p-cycle plus one fixed form, any reading nonconstant on the cycle forces p+1 image states. A reading that only distinguishes cycle membership needs just two fixed image states. Minimality concerns future E-answers, not recovery of every distinction of an arbitrary hidden extension.

**What is actually acquired.** For the displayed four-form source, two consecutive E-queries separate every state. One cannot do so, even after any fixed number of unobserved U-contacts: it still has at most two answers. The exact worst-case number of binary queries is therefore two in this declared interface. Record E, apply U, record E again, then apply U twice more. The working source returns and the two facts remain. This uses three U-contacts to return the working source, not to return the expanded record. It supplies the minimal autonomous state information without imposing autonomy on either individual answer. At Q the recorded next answer is 1 while the restored current answer is 0; the two acquired facts retain their different addressed questions.

The general return law EUʳ=E is not inferred from finitely many matching samples. A five-cycle with successive answers 00001 gives a small positive boundary: at its first form, E(U³x)=E(x) and the three-reading frame updates from 000 to 000 exactly as certified. At the next form, its current frame is still 000 but its successor frame is 001. The first correct square does not establish an autonomous law for that frame on the whole five-cycle. `DelayedFrameDrift` checks both the admitted first application and the refused continuation.

Here the sufficient source is instead a supplied four-node graph whose three-step return is derived at all four nodes. For an unknown mechanism, the global reading law needs its own construction or justified scope; VC107–108 still apply. The generic Swift constructor `ThreeReadingReturnFrame` requests only the actual three-step reading equality and derives the cyclic image update at that addressed source. `ThreeCycleWithFixed` supplies the complete finite example. `RecordThreeCycle` builds the two acquisitions and the returning source path, while its decoder reads only the two retained facts. The general equivalence and minimality arguments above are mathematical proofs; accepting these types does not certify all interpretations of all Swift conformances.

This changes the research question. Instead of requiring each preferred part to remain autonomous, establish which current or continued reading the given interaction actually supports. M64ak remains a conditional rigidity theorem when its two autonomous channels are supplied. The four-form counterexample prevents treating that premise as a consequence of internal closure. The returning-question construction gives a positive alternative: enlarge the reading exactly where future answers force a distinction, while keeping the original interaction.

## §6h. When the requirement belongs to the medium

LQ13 supplies a limited way to derive a requirement from a presented internal
relation. For its joint admission R⊆A×B, retain the actual counterpart b and
write A_b={a:(a,b)∈R}. The admitted fillings of role A are then fixed by R and
b. A target set has not been chosen independently of the rest of the
construction. This is a requirement of compatibility with that counterpart,
not yet a motive to preserve it. The decomposition and R remain supplied
grounds; calling the whole internal does not derive them.

Since B is a projection of R, each such A_b is already nonempty, and an
actual pair in R already satisfies its condition. Extracting this condition
does not exhibit an unmet task. Moreover any family of nonempty target sets
T_b can be encoded as R={(a,b):a∈T_b}. Taking sections of that relation would
recover the inserted targets. The section construction therefore locates the
condition's dependence on a counterpart, but does not establish that its
normative significance originated within the source.

The dual part of LQ13 also gives the least information needed to retain this
requirement. If a reading e of B supports R(a,b) iff D(a,e(b)), equal e-images
must have identical sets A_b. Conversely the class β(b) under equality of A_b
supports exactly that test. Thus every such e refines β. This is a consequence
of the existing two-sided boundary theorem, not a new classification. It can
leave the content of b unidentified while preserving its complete requirement
at this cut when distinct counterparts share a profile. The map β may also
be injective; the theorem does not promise compression. It supplies neither
a procedure for acquiring β nor an action
which fills the role. An available implementation must come from the actual
construction. One compatible filling is not necessarily the only one, and a
unique filling is not necessarily accessible.

The comparison N(a)⊆N(a′) likewise says exactly that every counterpart
compatible with a remains compatible with a′. It does not itself say that more counterparts are better
or that the process will select a′. Those would add a preference or an action
law. Where the complete input has a symmetry exchanging two candidate
requirements, VI1a excludes a single equivariant selection between them. A
joint answer may remain determinate. Actual internal history or another
distinguishing relation may remove that obstruction.

**Internal location does not establish internal formation.** Adding a field
called goal, satisfaction or feeling does not show how the process produces
or uses it. A research proposal is to connect the conditions enabling a
process with the actual transformations which maintain or revise those
conditions. Its regulation must be exhibited, rather than inferred from a
drawn dependency cycle. Even a successful such construction would establish
the stated functional organization, not a universal account of purpose.

**A changed requirement must retain its relation to the question being asked.**
LQ8a already gives two reversible changes of a joint source which both create
perfect current agreement. In one, the record answers the original question;
in the other, the current target has changed to match the old record while the
original answer remains elsewhere in the whole. Therefore whole recoverability
and current agreement do not establish fulfillment of an earlier requirement.
A new requirement can itself be legitimate, but the rule or source authorizing
that revision needs its own grounds. Putting a revision rule inside the form
does not derive its authority.

For an equality requirement, a common injective change of interpretation h
gives q=x iff h(q)=h(x). This preserves refusal as well as agreement. The fact
does not extend to every reversible transformation of a pair or to every
predicate. Nor does it restrict a real repair to preserve refusal: a repair
may satisfy the same previously unsatisfied requirement. Preserving a question
under re-description, meeting it by action, and changing the question are
different relations to the source.

Related proposals must be read with their scope. [Di Paolo (2005)](https://ezequieldipaolo.net/wp-content/uploads/2011/10/autopoiesis_teleology_2005.pdf)
argues that self-production alone does not explain adaptive regulation relative
to viability, and does not identify adaptation with one optimal state.
[Montévil and Mossio (2015)](https://montevil.org/publications/articles/2015-mm-organisation-closure-constraints/)
study mutually maintained constraints at specified scales. These are accounts
of biological organization with substantive premises. They do not derive a
purpose for every transformation or validate VI's source relations.

The earlier operational use of perception concerns access to a distinction for
an action. Experienced feeling remains a further subject of explanation.
Equating either a record or a regulatory loop with feeling would introduce an
unproved bridge; omitting a feeling variable would not establish its absence
in the described source either. No criterion for that bridge is supplied here.
The concrete next obligation is to construct how a presented medium both
produces a compatibility requirement and uses changes in its support to alter
its available continuation, including the source of any requirement revision.

## §6i. Atoms of a whole action

LQ15's blocks are relative to the supplied recombinations. A single admitted
configuration does not establish them: the singleton containing that
configuration factors over every partition of its addresses. Nor do the
separate families of inputs and outputs specify which output continues which
input. To retain that obligation, apply the same construction to the admitted
executions, preserving their source–result correspondence. This is an extension
of the joint relation being tested, not the introduction of a clock outside it.

**LQ19 (a family of addressed relations forces one finest common independent
partition).** Let I be a finite nonempty address set. For each e in a possibly
infinite family E, let R_e be a nonempty relation in ∏ᵢ Aᵢᵉ. The addresses have
an established correspondence across these presentations; each presentation
has LQ15's coordinate splices. A cut S is common-free when it is free for
every R_e. Then there is a unique finest partition P_E over which every R_e
factors. Its blocks are the equivalence classes generated by putting addresses
together whenever they lie in one block of some P_(R_e).

*Proof.* The common-free masks form the intersection of the Boolean
subalgebras C_(R_e), hence a Boolean subalgebra of the finite set 𝒫(I).
Its atoms partition I. A mask belongs to this intersection precisely when
it is a union of blocks of every P_(R_e), equivalently a union of the stated
generated equivalence classes. The resulting blocks are free in each R_e,
so the finite assembly proof of LQ15 factors each relation over them. Any
partition doing so has common-free blocks and therefore groups these atoms.
For an empty E the common partition is the singleton partition. ∎

The family is a family of obligations, not a supply of independent choices of
e. An unknown shared choice must remain inside the appropriate joint relation,
as the example below shows. Nor is this an acquisition algorithm: arbitrary
relations can have infinite carriers and no given decision procedure.

**There is a finite relational basis for this partition.** At most
|I|−|P_E| members of E already force P_E. Start with the singleton partition.
If the partition generated by the members selected so far is finer than P_E,
some remaining member must join at least two of its blocks; otherwise it would
already be an upper bound for all P_(R_e). Select such a member. Each selection
strictly reduces the number of blocks. At equality with P_E stop. This proves
the bound, including zero for the singleton target partition. The empty
address set has the separate trivial bound zero.

The bound counts whole relations with their laws, not observations, bits,
execution steps or the size of proofs. A selected relation may require an
unbounded description. The existence proof does not decide that no unexamined
relation will require a further joining. It proves finite determination of
this partition, not finite determination of the whole game.

**The least independent enclosure of specified roles is derived.** For
J⊆I, take the union of the blocks of P_E which meet J. This is the smallest
common-free cut containing J: every other such cut is a union of blocks and
must include each block meeting J. Applying this enclosure twice changes
nothing. It measures which roles must remain jointly covered if the remainder
is to be independently recombinable. It is not the amount of content a user
must acquire, and says nothing yet about distances between those roles.

**For an action graph, independent blocks are exactly blockwise product actions.**
Let R⊆∏ᵢ Aᵢ be nonempty and F:R→R total and deterministic. Present its
graph T={(x,F(x)):x∈R} with one paired role (xᵢ,yᵢ) at each address i.
For a partition P, T factors over P if and only if

    R = ∏_{B∈P} π_B(R),    F(x)_B = F_B(x_B) for every B∈P

for total F_B:π_B(R)→π_B(R). Pairing input and output at the same address
is part of this presentation, not a conclusion that those physical boundaries
are stationary.

*Proof.* A product graph projects to a product input relation. Each projected
block relation is total on π_B(R). If it assigned two results to one block
input, combine those two pairs with fixed pairs at the other blocks. Product
factorization would give two global outputs for one input, contradicting F.
Thus each block relation is a function F_B. Conversely, a product source and
the stated block functions give exactly the product of their graphs. ∎

This connects LQ15 to LQ18's autonomy criterion. For a partial or multivalued
T the free-cut test still applies to whole execution pairs, but this
total-function corollary cannot be inserted unchanged. Include an independently
required source relation R as another obligation if T does not cover all of R.
Shared controllers, hidden memory and applicability restrictions must remain
in the described joint relation when they affect its allowed continuations.

**An exchange gives independent snapshots and an inseparable action.** Let
R={0,1}×{0,1} and F(a,b)=(b,a). Both the input family and output family
are complete products. The executions 00→00 and 11→11 are admitted.
Taking the first role's input and output from the first execution and the
second role's from the second proposes 01→01, which the exchange refuses.
The execution graph therefore has one two-role block. F² is the identity,
whose endpoint graph has two independent blocks. Returning the endpoint can
remove this obstruction from the endpoint relation while the intermediate
exchange still carries it. A full two-step history retains the forbidden
splice at its first exchange. Endpoint return and independence throughout
the episode are different claims.

**A shared unknown cannot be replaced by separate local choices.** On the
same product source, let F₀ leave both bits alone and F₁ flip both. Each
fixed graph T₀ and T₁ separately factors into the two roles. Their union T
does not: it contains 00→00 and 00→11 but refuses the mixed 00→01.
The common partition of the obligations {T₀,T₁} is thus finer than the
partition of the single relation T. The former asks for factorization
conditional on the same fixed choice; the latter retains the constraint
that both roles share one choice. This dependence does not establish a
direct interaction or force between the roles; a common mode suffices.

If the same unknown choice persists for two calls, F_h² is the identity for
both choices. If the choice may change between calls, F₁F₀ does not return
the input. Thus repeatability of the procedure name alone loses the return
law. In general, the relation

    there is one h with y=F_h(x) and z=F_h(y)

must not be replaced by two independently chosen witnesses h₁,h₂. U11 retains
this joint dependence and, when its source-map cycle criterion holds, derives
a repeat count returning the required answer without identifying the unknown
action or payload. No unit of elapsed duration is
needed for this algebraic return statement. Actual access to the repeated
whole step and its completion remains a separate construction obligation.

**Adding obligations can join atoms; learning a narrower relation need not.**
If E⊆E′, every common-free cut for E′ was already common-free for E, so
P_E′ can only join blocks of P_E. This is a comparison of descriptions
which retain the old obligations, not a law of physical fusion. Replacing
one relation by a subset has no such monotonicity: on two binary roles, the
full product has two blocks, its diagonal {00,11} has one, and the singleton
{00} again has two. Conditioning on a case and adding a relation as an
additional obligation are different operations.

**What may remain unknown.** None of these partition results demands reading
the contents of every role in a block. Unknown contents can be carried and
transformed through their actual relation. Minimum retained information for
an independently fixed question and its continuations is instead VC15's
behavioral quotient, with VC46–47 retaining partial-action availability.
LQ18's returning-reading construction supplies a periodic case. These two
minima answer different questions: independent enclosure concerns what must
remain jointly covered; sufficient information concerns what distinctions a
particular use must retain. Neither minimum supplies an implementation solely
by being uniquely determined.

The result preserves the positive scope of the proposed atom: every faithful
realization of these same roles, recombinations, admissions and refusals must
respect their forbidden separations. Transport of the actual splices, rather than a bijection alone
of configurations, preserves the atomic partition as in LQ15. The theorem
does not derive all roles, contacts, finite address coverage, a universal
clock or a physical particle structure from existence alone. Its present
contribution is one shared construction for the inseparability of admitted
forms and admitted actions, including the otherwise hidden common choice.

## §6j. What an atom actually preserves

The word atom below means an LQ15 block for the established roles and their
recombinations. A single role can be a block because no internal cut
of that role is in this presentation. A block with several roles makes a
stronger relational statement: each proposed independent separation of its
roles has an actual forbidden recombination. This does not assert a smallest
physical object under every possible refinement.

**An internal cut can retain an atom without making its parts independent.**
For a fixed coordinate cut S | I\S, retain the joint image

    J_S = {(π_S(x), π_(I\S)(x)) : x∈R}.

The paired projection is a bijection from R onto J_S: the two restrictions
together retain each coordinate of x. Moreover J_S is the full product of
its projections exactly when S is a free cut. For the forward implication,
each proposed splice has a pair of restrictions in that product and hence
comes from an admitted x. Conversely, a free splice realizes every such pair.
Under LQ15's partition premises, a cut splitting one atomic block therefore
has a joint image strictly smaller than that product.

Thus internal articulation and independent recombination are different
properties. The parts can jointly describe the atom exactly while their
compatibility relation remains indispensable. Distinguishing two different
blocks also does not require independently decomposing each block internally.
This is a claim about the supplied representations; it does not provide
physical access to their projections or an operation that cuts their carrier.

**LQ20 (minimal forbidden fillings determine the independent blocks).** Let
I be finite and nonempty, R⊆∏ᵢ Aᵢ nonempty, and Aᵢ=πᵢ(R). For J⊆I,
a partial filling p∈∏ᵢ∈J Aᵢ is forbidden when no member of R restricts to
p. A forbidden filling is minimally forbidden when every restriction to a proper subset of J
has an extension in R. Minimality concerns this particular filling, not just
its address set. Make each such support J a hyperedge on I. Then the connected
components of this hypergraph, including isolated roles as singleton
components, are exactly P_R.

*Proof.* Suppose R factors over a partition P. If a partial filling p is
forbidden, at least one restriction p|_(J∩B), B∈P, is forbidden: otherwise
choose an extension at each block and assemble them using the product
factorization. A minimally forbidden p must therefore have all its support
inside one block. This applies to every factorization, including P_R.

Conversely, let P be any partition containing each minimally forbidden
support inside one block. Consider x with x_B∈π_B(R) for all B∈P. If
x∉R, its full filling is forbidden. Finiteness of I supplies a minimally
forbidden restriction p=x|_J. Its support lies inside one B, contradicting
the fact that x_B extends to a member of R. Thus x∈R and R factors over P.
The components of the hypergraph are precisely the finest partition which
contains each hyperedge inside one block, proving the claim. ∎

R≠∅ excludes an empty forbidden support. Restricting each carrier to πᵢ(R)
excludes singleton forbidden supports. No carrier Aᵢ has to be finite. The
theorem needs established nonextendability, not a pattern absent from a finite
sample. It describes the exact joint relation; a proposed overapproximation
can have a different partition.

**One atom can contain several irreducible restrictions.** In the relation
{000,111}, the minimally forbidden fillings are mismatches on pairs. Their
overlap joins all three roles into one atom. In the even-parity relation on
three binary roles, every filling of any pair extends, while an odd complete
triple does not. Here all minimally forbidden fillings use all three roles.
Both relations have one atom, but their compatibility laws differ. The atom
partition therefore preserves the extent of independent decomposition,
not the entire law of the relation. Even the hyperedge supports omit which
fillings are forbidden; those fillings must be retained to specify R.

For every finite n≥3, even parity on n roles has all proper projections
equal to those of the full product. Its minimally forbidden fillings are
exactly the complete odd-parity fillings, so its partition has one block,
whereas the full product has n singleton blocks. Thus even all proper
projections need not determine the atomic partition. This identifies an
arbitrarily high-order joint restriction, without making n=3 a universal
minimum or assigning a quantum interpretation to the example.

**A many-role atom has variation, but not a forced reaction to every change.**
If πᵢ(R) is a singleton, splicing that coordinate between any two admitted
forms changes nothing. The singleton mask is free, so i cannot belong to a
larger atom. Every role in a many-role atom consequently has at least two
admitted values. This is variation across the admitted family, not a claim
that any value changes during a particular occurrence.

In R={00,01,10}, the two roles form one atom because 11 is excluded while
both coordinate projections are full. A first-role value 0 allows two
partners, so atomicity does not give unique determination. The admitted
forms 00 and 10 also share the same second role. A change between them,
if available, would require no change there. Compatibility of these endpoints
does not itself supply the action between them. Indivisibility forbids some
independent recombinations, not every single-role change.

A fixed role being a separate block likewise grants no right to delete its
physical support. Product factorization retains that role. Withdrawal of a
support, or a change in action availability, is another relation which must
be represented if it belongs to the question. A graph of successful cases
alone must not erase refusals of an attempted continuation (VC46–47).

**Exact local reduction preserves the atomic partition.** Suppose each
qᵢ:Aᵢ→Bᵢ is onto, q=∏ᵢqᵢ, S=q(R), and the complete admission law is

    R = q⁻¹(S).

Then C_R=C_S and hence P_R=P_S on the same addresses, even when the qᵢ
are not injective.

*Proof.* Coordinatewise q commutes with every splice. If a cut is free for
R, lift two members of S to members of R and project their admitted splice;
the cut is free for S. If a cut is free for S, the image of a splice of
members of R lies in S. The displayed inverse-image condition makes that
splice a member of R. This proves the converse. ∎

Merely setting S=q(R) is insufficient: mapping every coordinate to a constant
would turn any relation into a singleton and erase every many-role atom. The
inverse-image condition retains both admissions and refusals on the entire
declared product. Locality is material too: LQ15's bijective parity encoding
mixes roles and does not retain their independent splices.

**The least separate contact descriptions supply this exact reduction.**
For each i, identify a,a′∈Aᵢ exactly when, for every filling z of the other
roles, (a,z)∈R iff (a′,z)∈R. Write βᵢ for the profile-class map.
Coordinate replacement inside one such class preserves admission in every
context. Finitely many coordinate replacements therefore prove

    R = β⁻¹(β(R)),     β=∏ᵢβᵢ.

Indeed, if β(x)=β(r) with r∈R, replace the coordinates of r by those of
x one at a time; every intermediate form remains admitted. The reverse
inclusion is immediate. The preceding result therefore preserves P_R after
this reduction. LQ13 already proves the two-role instance.

If separate encodings eᵢ preserve the complete joint membership test, then
eᵢ(a)=eᵢ(a′) forces identical admission in every retained context of the
other roles. Thus βᵢ=dᵢ∘eᵢ for a unique dᵢ on eᵢ(Aᵢ). The profiles are
the least separate descriptions for this exact contact. No claim is made
that eᵢ factors through βᵢ, that β is the smallest arbitrary joint code, or
that a participant has an available procedure for acquiring these profiles.
Future contacts and distinctions between actual joinings require their own
inclusion, as in LQ13 and VC15. When R is the whole execution relation of
LQ19, the reduction concerns that supplied episode and its source binding.

For example, let A={0,1}×U and B={0,1}×V, where U,V are nonempty
carriers. Admit ((s,u),(t,v)) exactly when s=t.
On the supplied two-role cut A/B this is one atom. Reducing each side to its
s-value preserves every admission and refusal and leaves that same atom.
The u,v contents need not be read. If further internal cuts exposing u and v
are admitted, their decomposition becomes another question; the theorem
does not suppress those additional possible distinctions.

**Preservation of the atom does not select its dynamics.** On
R={(m,m):m∈ℤ}, both the identity and (m,m)↦(m+1,m+1) are reversible
and preserve the same one-block relation. The former returns after one
application, whereas no positive repetition of the latter returns an input.
Thus atomicity and its preservation do not determine a return rhythm, an
elapsed duration or one unique action. U11's return criterion and LQ18's
returning-reading construction address that additional relation. Geometric
distance, physical force and stability against specified disturbances also
require their actual relations. The positive invariant established here is
inseparability under the supplied recombinations, retained even after exact
local removal of irrelevant distinctions.

**One whole sets a scope before it supplies a numerical measure.** A given
whole can serve as the addressed unit of coverage without an inventory of
its internal constituents. Its articulation into parts must retain J_S;
calling it one neither makes those parts independently usable nor assigns
them numerical fractions. If a nonnegative additive measure μ is separately
established and normalized by μ(W)=1, a complete disjoint division gives
μ(A)+μ(B)=1. Values 1/2 require the further equality μ(A)=μ(B), for example
from an established exchange preserving that measure. Normalizing an unknown
positive finite absolute scale removes its numerical size, not these laws.

LiR8 supplies an internal instance with an actual comparison relation:
its derived additive reading has ρ(A)=1 for the supplied reference action.
If an available B satisfies Bⁿ=A for n≥1 on that same orbit, then
nρ(B)=ρ(A)=1, hence ρ(B)=1/n. The reference action alone does not supply
such a root B. A full return with no retained change cannot serve as the
strictly advancing reference required by LiR8.

The actual residue of one game may subsequently serve as one role in another
contact, with the distinctions and source relations needed by that contact
retained. Referring to each game's own whole as one does not identify the
two carriers or prove that a measured quantity is conserved across their
handoff. Their continued relation must be supplied by the same actual
construction. HF4–HF5 already separate that continuation from terminality;
the existence of a unit does not turn it into a universal saturation ceiling.

## §6k. One atomic relation through different manifestations

LQ15 gives a unique finest independent partition for one established contact
and its cuts. It does not say that every such block has the same law. LQ20
also separates a block's extent from the forbidden fillings which determine
its particular contact. To compare manifestations of an atomic relation,
retain that full contact and the source correspondence, not just their common
number of blocks or matching isolated readings.

**LQ21 (minimal separate presentations have one source-bound transport).**
Let I be finite and nonempty, R⊆∏ᵢAᵢ nonempty, and Aᵢ=πᵢ(R). Let
eᵢ:Aᵢ→Bᵢ and fᵢ:Aᵢ→Cᵢ be onto. Put e=∏ᵢeᵢ, f=∏ᵢfᵢ,
S=e(R), T=f(R), and require exact admission and refusal:

    R = e⁻¹(S) = f⁻¹(T).

Require also that every distinct pair of values in any Bᵢ has a context in
the other B-roles which gives different admission answers in S, and likewise
for Cᵢ and T. This is absence of redundant local distinctions for the complete
contact. Then for every i there is exactly one bijection hᵢ:Bᵢ→Cᵢ with

    hᵢ(eᵢ(a)) = fᵢ(a) for every a∈Aᵢ.

Their product h transports S exactly to T, preserving refusals, free cuts,
minimal forbidden fillings and the atomic partition on the retained roles.

*Proof.* Let βᵢ be LQ20's full profile-class map. Exactness gives
ker(eᵢ)⊆ker(βᵢ). If two equal-profile values a,a′ had distinct eᵢ-images,
the separation condition would supply a context of B-values distinguishing
their admission. Lift that context through the onto maps at the other
finitely many roles. Exactness would then give a context in A distinguishing
a,a′, contradicting their equal profiles. Thus ker(eᵢ)=ker(βᵢ). The same
argument gives ker(fᵢ)=ker(βᵢ).

Define hᵢ(eᵢ(a))=fᵢ(a). Equal kernels make this well-defined and injective;
surjectivity of fᵢ makes it onto, and surjectivity of eᵢ makes it unique.
The product map commutes with each coordinate splice. Since h(e(x))=f(x),
it sends S onto T; its inverse therefore also retains nonmembership.
Coordinatewise bijections carry partial fillings and their extensions
bijectively, hence carry minimal refusals and all free cuts. LQ15/LQ20
then give the atomic correspondence. ∎

This is the separate-contact instance of the source-bound uniqueness already
present in LQ13 and VC15's reduced-description corollary. It does not prove
one universal atom type. With the role correspondence fixed, the common
source fixes the translation without absolute names for its values. If the
roles themselves are renamed, their established address correspondence must
also be retained; equal block counts do not acquire it.

**Several manifestations compose without changing their retained meaning.**
For three such presentations e,f,g of this same R, the unique translations
satisfy h_fg h_ef = h_eg, because both composites send eᵢ(a) to gᵢ(a).
Returning to the same presentation with the same source binding therefore
gives the identity. This is a law of re-description, not a claim that a loop
of actual changes returns the source. The whole source relation and its
correspondences remain part of the statement, not an external controller.

**Actions require the corresponding continuation law.** If one actual total
operation U:R→R descends to U_S:S→S and U_T:T→T with

    eU = U_Se,    fU = U_Tf,

then hU_S=U_Th on S. Both sides applied to e(x) equal f(Ux), and e is
onto S. Thus the translation also carries this action exactly. Existence of
these descended operations is not a consequence of contact-minimality alone.
For partial operations their availability must descend as well (VC46–47).
VC15 instead starts with the entire declared continuation family and derives
its least sufficient quotient. A present-contact reduction must not silently
claim that larger scope.

**Three different kinds of uniqueness remain distinct.** The finest
partition is unique for its supplied cuts. The minimal contact description
is unique up to the source-bound translations just proved. A unique actual
realization, occurrence or next action is not established by either result.
If redundant distinctions remain, whole presentations need not be bijective;
their common least profile description still exists. If the source bindings
are omitted, structural symmetries can leave several correspondences, as
VI1 proves. Treating all such correspondences as simultaneous identifications
would change the relation.

For a positive illustration, the binary relations x=y and u≠v have the
same contact form under the specified encoding (u,v)=(x,1−y). It carries
every admission and refusal. Without that encoding and its source binding,
those two written predicates do not identify an actual contact. Any other
retained reading of the second role must also be transported; holding a
non-invariant reading fixed would change the question. In contrast, {00,11} and
{00,01,10} both have two roles and one atomic block but have different
contact laws. Their numbers of admitted pairs differ, so no coordinatewise
bijections identify them. Both have two profile classes per role;
counting those classes also misses their difference.

The logical invariant therefore concerns a particular irreducible contact
with its declared continuations. Additional carrier distinctions can remain
unknown or be omitted from this description when the exact reduction allows
it. Several occurrences can instantiate that same contact form; their
numerical identity still needs an actual occurrence correspondence (Seam
§4b). No additional entity behind the realizations is inferred. Nor does
calling their common form one supply a handoff or saturation law: those
must be carried by the continuing construction as in HF4–HF5.

## §6l. Comparing atoms: rest, completion, return and carried difference

LQ20–LQ21 distinguish one atomic boundary from its particular law and its
manifestations. The next comparison keeps that distinction operational:
specify the admitted relation, say whether the cut concerns forms or whole
executions, and only then ask what returns. These are constructed mathematical
models. Their laws are premises of the comparison, not laws acquired from an
unknown physical carrier. An exponent of an operation counts compositions;
it supplies neither an external clock nor an elapsed physical duration.

**One contact can support several different kinds of continuation.** Let
ΔD={(d,d):d∈D}, where D has at least two elements. The displayed values are
two addressed manifestations of the same admitted choice. Neither singleton
cut is free: splicing (d,d) with (e,e), for d≠e, gives the refused (d,e).
Thus ΔD is one two-role atom. Each operation
(d,d)↦(u(d),u(d)) preserves admission to this contact. An arbitrary u need
not preserve the atomicity of its image: a constant u leaves a singleton
product. The examples below specify their actual operation and domain.

| Model | Given relation and continuation | What the comparison establishes |
|---|---|---|
| Maintained agreement | ΔD, identity operation | A nontrivial joint restriction need not change its admitted filling. Repeating an identity does not construct a clock. |
| Completing path | Δ{0,1,2}, partial operation (0,0)→(1,1)→(2,2), no outgoing step there | The relation is atomic and the path finite, but there is no positive return. A terminal does not supply a successor law. |
| Returning cycle | Δ{0,…,r−1}, r≥2, simultaneous increment modulo r | Every filling returns after exactly r positive steps. The initial phase can remain unknown. |
| Continuing path | Δℤ, simultaneous increment by one | The joint restriction is preserved by a reversible action, but no filling returns after any positive number of steps. |
| Return carrying a residue | Phase/residue pair and the whole operation constructed below | One role returns while its return advances the other. Their values are independently admissible; their whole executions are inseparable. |
| Shared restriction with remaining choice | R={00,01,10}, with no continuation yet supplied | One atom does not make either role uniquely determine the other. Internal freedom remains. |
| Joint closure beyond pairs | Even parity on n binary roles, n≥3, with no continuation yet supplied | Every proper projection is a full product although the entire relation is one atom. Pairwise evidence does not reconstruct the restriction. |

For the shared restriction, splice 10 and 01 to obtain the refused 11.
Yet fixing either role at 0 leaves two possibilities for the other. For the
last row, any proper filling extends by choosing one omitted bit to obtain
even parity. Across any nontrivial cut, choose a permitted filling with two
ones, one on each side, and the all-zero filling. A splice with just one of
those ones is refused. This verifies one atom across every proposed split;
it does not derive a preferred three-role primitive or a temporal law.

The table compares these relations; it is not a replacement for them or a
table inferred from matching observations. In particular, a transition's
before/after roles are bound by its given graph. Their correspondence is
not inferred from the shapes of their labels.

**A repeating projection of a nonreturning whole.** In the continuing-path
model, let E(m,m)=(m mod r,m mod r), for fixed r≥2. Then EUʳ=E,
while Uᵏ(m,m)≠(m,m) for every positive k. The reading has a least positive
global period r. LQ18 applies to this supplied reading-return law. Its
period is not a return of the source, and the preservation of Δℤ itself
is not a period either: that restriction is respected at every step while
its admitted filling keeps changing.

**LQ22 (an internal return can carry an exact next act).** Fix r≥2 and put
K={0,…,r−1}×ℤ, with addressed phase p and residue q. Define one operation

    U(p,q) = (p+1,q)    when p<r−1,
    U(p,q) = (0,q+1)    when p=r−1.

This is one total reversible law on the joint carrier. The second clause is
its internal continuation at the end of the phase range; no separate reader
observes completion and then authorizes it. The present carrier K is a full
product. Atomicity here concerns the graph of U on the two grouped roles
(p,p′) and (q,q′), as required by LQ19.

The graph is one atom. The executions (0,0)→(1,0) and
(r−1,0)→(0,1) are admitted, but the first phase execution combined with
the second residue execution would be (0,0)→(1,1), which is refused.
This is a witnessed failure of the only nontrivial cut.

For all p,q, the complete r-step action satisfies

    Uʳ(p,q) = (p,q+1).

*Proof and source binding.* Euclidean division gives a bijection

    H(n) = (n mod r, ⌊n/r⌋),    H⁻¹(p,q) = rq+p.

Transporting the specified successor n↦n+1 through H gives exactly the
two clauses of U. This also supplies its inverse. Incrementing n by r
proves the displayed r-step law. In this comparison, n is another exact
description of the same joint configuration, not an external elapsed time
or a third reader. The given successor law has not been derived from mere
atomicity. Once that law and this source correspondence are retained, its
transport U is unique, as in LQ21's action clause.

If the available action is only repetition of U and the requirement is to
return p while advancing q by exactly one, precisely r applications do so.
The inverse description increases by k after k applications, and by r at
the required target. Thus k=r is necessary as well as sufficient. Neither
initial p nor initial q needs to be learned. The result concerns this given
action and request, not a universal minimum information content or physical
cost. Shifting every q by the same integer commutes with U; an absolute
origin for that internal residue is unnecessary. ∎

This identity of repetitions does not by itself build an autonomous command
which stops after r applications. Executing exactly that finite composition
needs its actual executor or internal stopping construction; U itself keeps
going. With unknown initial p, the first carry can occur at any of the first
r steps. Consecutive carry events are exactly r steps apart under this law.
These are different claims from a commanded return to the initial phase.

The r-step endpoint graph factors: its phase part is p′=p and its residue
part is q′=q+1. The full r-step history remains one atom when each role
retains its own whole trajectory. Starting at p=0 puts the residue increment
at the last step; starting at p=r−1 puts it at the first. Splicing the former
phase history with the latter residue history violates U at the first step.
Endpoint return therefore coexists with inseparable execution, exactly the
distinction already exposed by LQ19's exchange example.

This gives a concrete partial answer to the atom—ceiling—continuation
question. If the first clause alone is designated the old game's moves,
p=r−1 has no old move; the very same supplied whole law has its carry move
there. Completion and the next act are joined in the execution relation.
The proof does not infer this law from terminality: deleting the carry
clause leaves a different, stopping model. A unique admitted next act also
does not prove that an arbitrary physical device will execute it. Here the
mathematical run is specifically iteration of the supplied total U.

**What can count a return.** For a complete autonomous state description x,
if Uʳx=x, then every current internal reading M of that description satisfies
M(Uʳx)=M(x). Consequently a retained count which changes across that return
cannot be part of an otherwise exactly returning complete description. If
such a count is present, the description that returned omitted it. This does
not identify two actual occurrences or deny the ordered path between them;
it concerns what their current retained state distinguishes. LQ22 realizes
the positive alternative: the phase returns, the joint state does not, and
the distinction between iterations is carried inside the construction.

The comparison separates preservation of a rule, return of one question,
return of a complete state, and a record of the traversed path. Calling all
four a cycle would erase precisely the relation which makes a local rhythm
usable by another part. Order or change alone does not imply periodicity.
HF2 supplies eventual periodicity for an infinite deterministic run on a
finite complete state space; its premises do not follow from a finite list
of observed answers or from the existence of an atom.

The common pattern is a restriction on independent recombination under
declared cuts. Completion, recurrence, retained history and a next act are
different ways that restriction can participate in a continuing whole.
LQ22 is useful because one can guarantee a composed effect while leaving
the actual filling unknown. The remaining research question is which given
contact supplies its continuation law, not how to rename every atom a clock.

**A supplied cyclic reading leaves a whole return action.** This connection
with LiR §6 is made precise in [AR4](../../../../Research/2026-09-25-atoms-distinguishability-and-return.md).
Let K be nonempty, U:K→K bijective, and p:K→ℤ/r satisfy pU=p+1,
for r≥2. Put X₀=p⁻¹(0), M=Uʳ|X₀. The bijection H(j,y)=Uʲy gives

    H⁻¹UH(j,y) = (j+1,y) for j<r−1,
    H⁻¹UH(r−1,y) = (0,My).

Every bijective M on a nonempty carrier admits this construction. Thus the
same phase cycle permits a full return, a longer cycle or a nonreturning
residue. The counter increment in LQ22 is one particular M. On this new
phase/residue cut, the whole-step graph is atomic exactly when M≠id: splice
a non-carry phase step with a changed residue y→My. A complete-state return
after k positive steps instead requires k=rm and Mᵐy=y.

H is a phase-dependent readdressing of the whole. It is not generally a
separate recoding of old physical parts, so LQ21 does not automatically
transport their cuts or access through H. Its inverse formula supplies no
available physical inverse operation. An original question Q on X₀ has
the required return action V precisely when QM=VQ. A transported question
on another phase must remain bound to that requirement. A second forward
contact is not the reverse edge of the first, including in a two-phase
cycle; identifying them would impose M=id without grounds.

## §6m. Quantitative distinguishability keeps its contact

The trace distance used in the earlier CA estimates has the convention
D(ρ,σ)=½‖ρ−σ‖₁. This section connects that quantitative reading with the
atom comparison; it does not derive the quantum state model from LQ15.
On one supplied finite-dimensional quantum carrier,

    D(ρ,σ) = max_{0≤M≤I} |Tr M(ρ−σ)|.

Indeed, the positive and negative parts of the traceless Hermitian
ρ−σ each have trace D. Every effect M bounds the displayed difference
between −D and D, and the projector on the positive part attains D.
The operational discrimination result and the common-channel contraction
law are standard; see [Watrous, chapter 3, Theorem 3.4 and Corollary 3.40](https://cs.uwaterloo.ca/~watrous/TQI/TQI.3.pdf).
In particular, D≤ε bounds each event-probability difference by ε,
including after the same quantum channel is applied to both states.
The channel need not be individually known for this bound, provided that
its common action and membership in that class are established. Normalized
postselection is not such a channel. A bound on event probabilities does
not by itself identify the occurrence or establish its physical source law.

For a fixed nonempty family of actually supported effects ℰ, define

    d_ℰ(ρ,σ) = sup_{M∈ℰ} |Tr M(ρ−σ)| ≤ D(ρ,σ).

This is a pseudometric; its zero means agreement on those outcomes. The
same ℰ must be used across comparisons. A family chosen differently for
each state pair need not satisfy the triangle inequality. To retain
continued questions, include their effective source effects Φ*(M), with
the actual common continuation Φ. This is VC15's scope discipline in a
supplied probabilistic model, not a free replacement of an internal contact
by an observer's choice. Actual availability remains to be established.

**Joint distinction can be absent from every single part.** On two binary
roles put

    ρ = (|00⟩⟨00| + |11⟩⟨11|)/2,
    σ = (|01⟩⟨01| + |10⟩⟨10|)/2.

Their supports are orthogonal, so D(ρ,σ)=1. Both reduced states on each
single role are I/2, hence both local distances are zero. The joint effect
M=|00⟩⟨00|+|11⟩⟨11| has probabilities one and zero. A contact supporting
that effect distinguishes the preparations; separate marginal questions
do not. These are separable mixtures, so quantum entanglement is not needed
for the example. Their support relations are respectively {00,11} and
{01,10}, each atomic under LQ15's independent-splice definition. Atom here
does not mean extremal density operator or absence of a convex decomposition.
Flipping the second role relates the two supports, as in LQ21; transporting
both the states and their effects is different from changing only the state
while retaining the original question.

**Support atomicity is not the whole quantitative relation.** For the two
diagonal states above, put ρ_ε=(1−ε)ρ+εI₄/4 and
σ_ε=(1−ε)σ+εI₄/4, with 0<ε<1. All four classical outcomes now have
positive probability. Their support relations are full products even though
their joint distance is 1−ε and D(ρ_ε,ρ)=ε/2. Both marginal pairs still
coincide. Thus a discontinuous change of LQ15's support partition need not
be a discontinuous loss of correlations. This is IiS19's already established
zero-profile/weight distinction applied to the atom comparison. Full support
also really removes error-free finite discrimination in IiS19's instrument
class; a large remaining correlation does not restore that exact guarantee.

For a fixed finite tensor-role partition P, quantitative independence means
ρ=⊗_{B∈P}ρ_B. Exact product partitions have a unique finest refinement:
reducing a Q-product to each P-block proves factorization over every
nonempty intersection B∩C. However, declaring approximate independence by
δ_P(ρ)=D(ρ,⊗ρ_B)≤ε does not preserve that conclusion. The three-role state
(1−λ)I₈/8+λ(|000⟩⟨000|+|111⟩⟨111|)/2 has δ=λ/2 for each
two-block partition and δ=3λ/4 for three singleton blocks. At tolerance
λ/2, incompatible finest acceptable partitions therefore coexist.
[AR1–AR3](../../../../Research/2026-09-25-atoms-distinguishability-and-return.md)
prove these statements and the bound
|δ_P(ρ)−δ_P(σ)|≤(|P|+1)D(ρ,σ). This selected marginal-product distance
is not a minimization over all product states. The actual tensor roles,
preparation law and required continuation remain part of the claim.

**The full action has its own factorization and error.** For a supplied
finite-dimensional channel Φ:⊗Aᵢ→⊗Bᵢ, keep each input reference Rᵢ
grouped with its output Bᵢ. The normalized Choi state J_Φ factors across
these grouped roles exactly when Φ is a product of the corresponding
channels. Thus AR1's unique finest exact partition extends to this whole
boundary-to-boundary action, as proved in
[AR5](../../../../Research/2026-09-25-atoms-distinguishability-and-return.md).
If d is the input dimension, the uniform error on unknown inputs with a
retained reference obeys

    D(J_Φ,J_Ψ) ≤ ½‖Φ−Ψ‖_⋄ ≤ d D(J_Φ,J_Ψ).

A small Choi error therefore need not be the same small worst-case error.
The mathematical reference does not grant physical preparation or complete
knowledge of J from one trial. The endpoint channel also does not determine
intermediate records or interventions. This extension preserves LQ19's
whole-action requirement; it does not infer independence of a physical
implementation from the product form of its final effect.

**A distance between states does not supply a rhythm or spatial length.**
Encode distinct positions of a finite cycle as orthogonal pure states. Every
pair of distinct positions has D=1, irrespective of the number of steps
between them. The supplied successor relation determines those steps; D
alone cannot reconstruct it. LQ22's phase/residue relation, LiR8's internal
calibration and Space S26's light-incidence boundary therefore address
different obligations. In particular, S26 already preserves light paths
within a conformal family while changing clock integrals. Using light for
comparison does not by itself establish a smallest length or one complete
reading of every system distinction.

The useful joint requirement is to retain which distinctions a contact
supports, how its action carries them, and how its repetitions are compared.
The general relational framework does not thereby supersede the quantitative
quantum laws used in this example. It locates where their source, joint scope
and continuation must remain attached to any claim made with the number D.

## §7. Statement

Retained evidence restricts a compatible set. For a finite sound query model, eventual separation is exactly what turns this process into finite completion. The logical medium supplies a further question: which relations make forms compatible and constrain their rearrangement? LQ13 derives a least complete contact interface and identifies when a shared equality would lose a forbidden combination. LQ14 derives a necessary coordination scale that includes internal detours. LQ15 recovers the finest independent blocks under its completeness conditions; LQ16 reconstructs the two roles of a partial recombination law while retaining its refusals. These results turn a proposed decomposition into an obligation on actual relations. The existence or unique selection of those relations still requires grounds within the whole.

LQ16a makes joint admission essential to coherent exchanges. LQ16b distinguishes extending an ideal carrier from respecting an already supplied joint family. It characterizes the maximal region of unrestricted exchanges and the smaller paths that can serve a particular request. A resident route then constructs one internally controlled action on a joint carrier, without identifying its unknown role contents. LQ16c removes the prepared route index for a specified incidence-continuation request, derives the exact condition for transporting that action through a coarser reading, and separates uniqueness of the requested continuation from uniqueness of the hidden move. The given relations, request and separate obligation of physical realization remain explicit.

LQ17 tests the stronger proposal that one ordered gradient supplies exact regions at every level. It forces nested partitions and refuses crossed ones, while leaving higher-order admission and a smallest represented region as separate obligations.

LQ18 distinguishes reconstructing a cut from preserving it under another operation. It excludes every complete autonomous binary cut for one explicit reversible interaction, then constructs the least autonomous reading from a question-return relation. This supplies a way to revise the proposed representation rather than excluding the interaction to protect that representation.

Section 6h applies the existing contact boundary to a requirement supplied by an internal counterpart. It distinguishes that derived compatibility condition from choosing, executing or valuing a continuation, and uses LQ8a to keep requirement revision separate from fulfillment. Internal regulation and experienced feeling remain further research obligations.

LQ19 applies the same recombination test to whole executions and families of
relations. It derives their finest common independent blocks and a finite
relational basis for that partition on finite addresses. The shared-unknown
example prevents confusing factorization conditional on a mode with
factorization of the joint episode. The exchange example shows why endpoint
return does not establish independence of the intervening action.

LQ20 identifies those blocks from minimally forbidden partial fillings and
shows that exact local reduction of irrelevant distinctions preserves them.
It distinguishes a block's extent from its full law and from the dynamics
which may preserve it. Joint restrictions can involve arbitrarily many
roles while remaining invisible in every proper projection.

LQ21 makes the uniqueness claim precise across minimal separate presentations
of the same contact. Their source-bound translations preserve the atom and
compose consistently; actions are also transported when their descent is
established. Unique decomposition, unique reduced description and unique
occurrence or mechanism are not interchangeable conclusions.

Section 6l compares seven models without imposing a universal temporal fate.
LQ22 constructs a reversible phase/residue action with an atomic execution
graph, a returning phase and a precisely advancing residue. Its requested
r-step effect needs neither initial value to be known. Returning endpoints
do not separate the intervening history; atomicity alone does not supply
the successor law used in this construction.

Section 6m relates the standard trace distance to a fixed family of supported
questions. A separable two-role example retains a fully distinguishable
joint relation with identical single-role marginals. The distance supplies
neither the successor law of a cycle nor a physical space/time calibration.

## §8. Dependency

### External

| Source | Used |
|---|---|
| V=I | GC1–GC4 (truth and accessible retention), CS1–CS3 (coverage, dispatch and model scope) |
| IiI | §3 (conditional reuse), §5 (progress premise), §6 (arrival laws) |
| PiR | M35 (residual capacity), M38–M41 (transport, entropy and resolution) |
| DiC | §4 (frontier vocabulary), G11–G13 (geometry and search) |
| InI | S6a–S6c (corrected record accounting and acquisition condition) |
| GA | GA1 and GA6 (descent conditions and correlation counterexamples) |
| B / PP | B6–B8 (finite description and reach), PP17 (weighted counts) |
| Verdict | VI1a (symmetry), VC30–VC34 (acquisition), VC38–VC39 (representation closure), VC46–VC47 (domain preservation) |
| External | Buhrman and de Wolf §4.1 (certificate complexity), LeanDojo (learned proof proposals with checking) |

### Internal

| Statement | Depends on |
|---|---|
| LQ1 | B6–B8, declared completion criterion |
| LQ2 | §0, fixed Q and sound retaining update |
| LQ12 | admitted forms and reversible rearrangements, addressed product structure, VC46–VC47, VC23b and M67 |
| LQ13 | actual internal contact relation, uniform replacement with the partner retained, exact relation factorization |
| LQ14 | addressed admission relation, finite paths, maximum support of an elementary change, LQ12–LQ13 |
| LQ15 | admitted forms on fixed addresses, splice identities; finite addresses or explicit finite-character admission for the finest partition |
| LQ16 | ternary contact, exact self-contact and contextual substitution including refusals; row/column equality, LQ13, M35, VI1a and VC46–VC47 |
| LQ17 | ordered levels of finite joint admission, LQ15's overlap law, source-bound class readings and explicit refinement scope |
| LQ18 | LQ16's reconstructed contact; actual source operation and reading; VC15/VC38; a specified reading-return law for the periodic construction |
| LQ19 | LQ15's finite free-cut algebra; established common address roles and splices; whole execution relations; LQ18 and U11 for the action and return connections |
| LQ20 | LQ15 and finite address coverage; minimal nonextendable fillings; coordinatewise exact membership quotients; LQ13 for least separate contact profiles |
| LQ21 | LQ13/LQ20 exact contact profiles; source-bound coordinate maps and reduced presentations; LQ15 for atom transport; VC15/VC46–47 and VI1 for continuation and symmetry scope |
| LQ22 | LQ19 whole-execution cuts; specified successor and Euclidean-division source correspondence; LQ18 and HF2/HF4 for reading return, recurrence and continuation scope |
| LQ3 | §0, distinct keyed answers and instance certificates |
| LQ4 | LQ2, acquisition policy and cost boundary |
| LQ5 | GA1, GA6, specified descent policy |
| LQ6 | specified pair measure and nonzero variances |
| LQ7 | B8d, PP17 |
| LQ8 | LQ3, explicit verifier, store and policy update |
| LQ9 | LQ2, fixed scope, closed reversible counterexample |
| LQ10 | scoped verification and explicit acquisition policy |
| LQ11 | §0, finite B_G and eventual separation |

## Topics

### Related type declarations

- ``LiquidPhase``
- ``CrystallizationFront``
- ``SearchFlow``
- ``StefanCoupling``
- ``GateIsMembrane``
