# Learning Is Liquid (Phase)

Learning changes what a system can distinguish and use. A retained record, a newly excluded possibility and a cheaper computation are three different changes. A successful computation can make none of them: it can reproduce an answer already certified. This paper separates these changes and gives a condition under which repeated observations settle a question.

The liquid/crystal language in §§0–6 describes unresolved and certified regions of a declared task domain. Retention makes a certified region monotone only while its questions, model, keys and interpretation remain fixed. Progress additionally requires observations that separate the remaining alternatives. Neither continued activity nor a finite domain supplies those observations by itself. Sections 6a–6e ask a different question: what constitutes the state of a medium whose own admissible forms and rearrangements can change? They derive contact boundaries, necessary coordination scales and conditions under which an internal relation determines a decomposition. The conditions enter before assigning physical phase names.

## §0. Setting

Fix a finite nonempty candidate set K, an actual candidate x ∈ K, a question q: K → A, and a finite vocabulary of static total queries f_i. A sound cache G records keyed answers f_i(x). Its compatible set is B_G = {y ∈ K: f_i(y) = G(i) for every cached key i}. Soundness keeps x in B_G. The question is settled when q is constant on B_G, even if several candidates remain.

A retaining update preserves old keyed answers and may add new ones. These premises describe an inference interface. They do not assert that the whole is a finite query table, that every interaction is nondisturbing, or that physical memory grows without bound. If an interaction changes the target, its state transition and the question about the original state must be included, as in Verdict VC30–VC34.

Within The Cut's commitment to one whole, source, observer, memory and query mechanism all belong to that whole. Alternatives in K describe what the observer has not distinguished. They are not additional realities outside it. A mathematical description of the whole is also not an observation automatically available to a participant.

## §1. What Can Saturate

### LQ1

**LQ1 (An infinite table differs from a finite generative description).** Explicitly listing infinitely many distinct answers never finishes in finite time and storage. A finite program or certified generator set can nevertheless describe an infinite family, and a finite cache can serve a useful subset. These are different completion criteria (Basis B6–B8).

Infinite reach alone does not prove that a learner lacks a complete generative description or must search anew for every answer. The phase analogy needs a declared criterion: table coverage, rule coverage, derivability, or usable access within a cost bound. No claim that the liquid phase is generic follows from cardinality alone.

### LQ2

**LQ2 (Resolution has a domain).** For a fixed family Q of questions, define R_G = {q ∈ Q: q is constant on B_G}. Sound retaining updates give B_G′ ⊆ B_G and hence R_G ⊆ R_G′. A scalar such as |R_G|/|Q|, when Q is finite and nonempty, discards which questions are resolved. A domain-indexed description retains that information.

*Proof.* A function constant on a set is constant on each nonempty subset. Soundness guarantees nonemptiness here. No metric or arrival distribution is needed. To predict which region resolves first, supply the query policy and its costs. Covering numbers alone do not determine arrival times. The coupon-collector law in IiI §6 additionally assumes independent uniform arrivals and successful retention.

## §2. Records, Certificates and Progress

### LQ3

**LQ3 (The new-record bound is relative to prior knowledge).** Let cert_G(x, q) be the smallest number of distinct uncached query keys whose actual answers, added to G, settle q. Set it to ∞ if the available keys cannot do so. If an episode settles q after m query calls and retains d distinct new keyed answers, then:

```
cert_G(x, q) ≤ d ≤ m.
```

*Proof.* The d new answers form a sufficient extension of G, so their size is at least the minimum. Each call supplies at most one keyed answer in this model. Repeated keys contribute no additional record. The lower bound is zero when G already settles q. For an empty cache it becomes the usual instance-certificate bound, provided all relevant prior constraints are included in K.

This is certificate complexity conditioned on an initial compatible set, not an optimal policy theorem. A certificate chosen with knowledge of x need not be discoverable at that cost by a policy that must work for every x. The standard distinction between certificates and decision trees is described by [Buhrman and de Wolf, §4.1](https://homepages.cwi.nl/~rdewolf/publ/qc/dectree.pdf).

A new record need not remove a candidate. Let K contain the four bit pairs (a, b), let q = b, and suppose G records a = 0. Querying a AND b returns 0 and adds a distinct key, but B_G remains {00, 01}. The answer to b is still open. Conversely, q = a is already settled without reading b. Neither full feature coverage nor positive new-record growth is necessary for a certified answer.

### LQ11

**LQ11 (Finite completion is equivalent to eventual separation).** Along a sound retaining query stream with fixed finite K and q, the question settles in finite time if and only if every y ∈ B_G with q(y) ≠ q(x) is eventually separated from x by a queried key.

*Proof.* If q is settled, no such y survives, so some observed answer has excluded each one. Conversely, select one finite separation time for each wrong-answer candidate. There are finitely many candidates, so the maximum of these times is finite. After that time no wrong-answer candidate survives, while x does. If there are no wrong-answer candidates initially, completion occurs at time zero.

Equivalently, each uncached key i covers D_i = {y ∈ B_G: q(y) ≠ q(x) and f_i(y) ≠ f_i(x)}. A sufficient extension covers all wrong-answer candidates. LQ3 minimizes the size of such a cover. LQ11 asks whether the actual stream ever supplies a cover. Existence and acquisition are separate obligations.

If a policy always chooses a query that strictly reduces B while q is unresolved, it settles after at most |B_G| − 1 calls. That policy premise is stronger than eventual separation and may fail when the vocabulary cannot distinguish different answers. Eventual separation gives a finite stopping time for a finite B, but no uniform waiting-time bound: arbitrarily many repeats may precede a useful query.

The argument uses survivor intersection and finite set coverage. It applies to arbitrary finite carriers and answer alphabets in the stated static-query model.

**An infinite candidate family can still give finite completion.** VC23 supplies another sufficient setting: countably many finite-valued addresses, admission completely specified by finite-address relations, and a total question q depending on finitely many addresses. Suppose every acquired fact is another such relation on the same source, the facts are sound and retained, and their entire stream together with the fixed admission requirements determines q. VC23's forced-answer corollary gives a finite subset of these requirements and facts that already determines it. The acquired members of that subset all arrive by some finite stage. The fixed admission requirements belong to the background. Thus q is already determined at that stage even if infinitely many other distinctions remain unresolved. This establishes logical resolution. Recognizing it still requires a derivation or an adequate decision procedure.

The question condition matters even with binary addresses and no extra admission restriction. Let the actual source be the all-zero sequence, and ask whether any coordinate is one. Query coordinates successively. Every wrong-answer source is eventually separated, because it has a one at some queried position. Nevertheless, every finite prefix of zero answers admits a one at an unqueried position, so the question never settles at a finite stage. Its answer concerns infinitely many addresses. A supplied source-bound universal fact that every coordinate is zero would settle it by a finite symbolic argument. That fact is stronger than any finite list of these individual observations.

Adding a field named the answer does not remove this condition. VC23 proves that the exact relation between that field and this unbounded existence question has no representation by countably many local constraints with finite-valued hidden fields. A recursive claim that some later position supplies the witness can satisfy every local continuation equation on an all-zero input. Requiring a finite witness that reaches an actual one changes the admission rule and excludes that unsupported claim. The source, the claim and its justification are distinct internal roles in this model.

LQ15's finite-character condition concerns refuting one proposed complete tuple. VC23's finite-carrier argument instead concerns existence of a common assignment for a family of requirements. Together they identify when local saturation can suffice and where a global admission or question premise must remain explicit. Finiteness of each recorded fact alone supplies neither guarantee. No bound on the physical whole or universal acquisition schedule has been inferred.

### LQ4

**LQ4 (Geometry needs an acquisition model).** A metric on structures can organize resolved regions and assign query costs. It does not determine their growth direction or speed. Even a small clustered region can remain unresolved if the policy never visits its distinguishing queries. Dendritic growth is a proposed geometric analogy requiring a specified dynamics and measured behavior, not a consequence of metric structure alone.

**Axon guidance supplies a concrete contact question.** In [Koser et al. (2016)](https://cris.fau.de/publications/241417791/), Xenopus retinal ganglion cell axons grew toward softer tissue. An in vitro stiffness gradient reproduced this orientation without a chemical gradient. Altering brain stiffness, blocking mechanotransduction or reducing Piezo1 produced abnormal growth and pathfinding. These interventions establish a role for mechanical contact in this preparation. They do not require the growing axon to represent a distant destination before interacting with its surroundings.

[Qiu et al. (2024)](https://www.frontiersin.org/journals/molecular-neuroscience/articles/10.3389/fnmol.2024.1307755/full) studied a different contact: substrate-bound netrin-1 and its receptor DCC. Receptor grip was more prevalent on the netrin-coated substrate than on the control, with greater transmitted traction. Disrupting the actin-to-DCC linkage through shootin1 knockout impaired the directed growth. The relevant description includes the ligand, receptor, internal force coupling and substrate. A chemical cue alone is an incomplete description of that contact mechanism.

**Changing the support changes the interaction.** [Moore, Biais and Sheetz (2009), Fig. 1](https://pmc.ncbi.nlm.nih.gov/articles/PMC2746731/) presented spinal commissural neuron growth cones with netrin-1-coated beads. Growth cones transported an unrestrained bead down the axon. An immobilized bead could redirect axon growth. None of 13 axons turned more than 20 degrees toward an unrestrained bead, whereas 10 of 15 did toward an immobilized bead. DCC interference also disrupted pulling on the coated beads. These observations distinguish the mechanical support of the contact while retaining the ligand category. They do not establish identical complete preparations or a deterministic response of every axon. An interface recording only the presence of netrin-1 omits a variable tested by this intervention.

**Restoring one contact function need not restore its continuation.** [Nichols, Lee and Shen (2025), Fig. 5](https://pmc.ncbi.nlm.nih.gov/articles/PMC11888602/) followed axon guidance in living C. elegans. In UNC-6-deficient animals, membrane-tethered UNC-6 at the ventral sublateral intermediate target restored local axon stabilization. Expression only at the ventral nerve cord did not. The tethered constructs did not restore the direction of initial axon emergence. Supplying tethered UNC-6 at both locations partially rescued final targeting: 68.6% of PDE axons reached the ventral nerve cord, compared with 32.1% in the UNC-6 mutant and 100% in wild type in the reported adult samples. Thus local attachment, initial direction and eventual targeting require separate comparisons. The authors propose successive adhesion and gradient-guided growth. Their results prevent extending a contact-only account to all stages of guidance on the strength of local stabilization alone.

The VI research question is therefore which joining distinctions a proposed growth interface must retain. LQ13 already separates the two endpoints from the actual joining between them. Here that joining participates in both local response and changed geometry, which changes later contacts. The experiments support studying that coupling. They do not establish that every growth event acquires knowledge, that two neurons universally attract one another, or that biological development implements a VI proof checker. A wrong path can be physically realized while failing the network's functional task. Physical admission and correctness about a specified target remain different relations.

## §3. Search and Composition

### LQ5

**LQ5 (Alignment is a policy condition).** Descent succeeds under a basin or progress condition for the actual loss, neighbor relation and tie-breaking rule. Positive aggregate correlation α does not exclude a spurious local minimum. Gradient GA6 supplies a finite counterexample with positive α and failed greedy descent. Calling successful and stalled search laminar and turbulent does not establish fluid dynamics.

### LQ6

**LQ6 (Ruggedness statistics need a sampling measure).** A quantity C(d) = corr(loss(R), loss(R′) | W(R, R′) = d) requires a distribution over pairs and nonzero conditional variances. It can summarize scale-dependent loss variation under that distribution. No general equivalence between its decay, a scalar alignment coefficient and successful search has been established here. A spectral interpretation requires additional structure, such as a specified graph operator. The proposed analogy between 1/α and a Reynolds number is not a derived invariant.

### LQ7

**LQ7 (Composition depth and counting growth).** Iterating a declared composition rule expands its reachable set when new extensional classes appear. The cumulative count N(s) and its exponential rate γ measure reach per unit norm (B8d). They do not by themselves specify a temporal flow, an energy transfer or the computational efficiency of generation.

For finite norm bands, the formal partition sum Z(λ) = Σ_s n(s) exp(−λs) converges for λ > γ and diverges for λ < γ. The actual density determines the boundary and the limiting moments (Play PP17). A limsup growth rate does not imply n(s) ~ exp(γs): the count sequences ceil(2ˢ/sᵖ) have the same γ for p = 0, 2, 3, 4 and different critical behavior. Zero γ also permits subexponential unbounded growth. Calling composition a physical cascade requires further dynamics.

## §4. Coupling and the Learning Arrow

### LQ8

**LQ8 (Feedback requires an implemented update).** Search can propose a candidate, a verifier can certify a scoped claim, a retaining store can preserve it, and a later policy can use it. This forms a feedback loop when those operations are implemented and connected. A repeated PASS may leave the store unchanged. A new record may leave the compatible set unchanged. A smaller compatible set may leave the implemented search slower because retrieval and policy computation have costs.

**Acquisition can reshape the next interface.** Let w be one joint form, with readings for the participant, its surroundings and their actual contact. No independent product of these readings is assumed. An implemented acquisition is a transition w→w′. A changed participant reading already distinguishes the whole forms, even if a chosen environmental reading is unchanged. The transition can also change the next available preparations, contact conditions or decoding operation. Thus acquiring a record and modifying the interface can occur in one physical process. Whether both occur is a question about that transition. LQ12's resident context and Verdict's resident preparation constructions supply exact finite examples of changing access within a retained whole.

Two comparisons must accompany such an update. First, does the retained evidence determine more about the original question? VC30 transports that question through the intervention. Second, what can the new participant-contact configuration distinguish or do next? Equal recorded answers need not settle the second comparison. By VC15, if two configurations have the same proposed retained image but a permitted continuation gives different answers, that image cannot supply a common exact decoder. The missing distinction may concern the contact itself. In stochastic applications the relevant comparison concerns the specified response laws, not inequality of two individual trial outcomes.

This makes a limited interpretation of learning as physical reconfiguration precise: the learner and its representation are internal forms whose changes can alter later interactions. Establishing improved knowledge additionally requires the relation to the target question. A useful next experiment would separately vary the acquired evidence and the mechanical or decoding contact, then compare the same declared continuation. This distinguishes a new fact, a new way to use an old fact and a changed source. The formal compilation of a new claim models these processes only when its fields and transitions preserve those actual relations.

Consequently no decrease in nearby loss, increase in efficiency, or Stefan equation follows from this loop alone. A Stefan model would need specified fields, geometry, transport equations and an interface balance. `StefanCoupling` names the proposed connection in the type lattice. Its protocol intersection does not supply those equations or an actual policy update.

### LQ8a

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

### LQ9

**LQ9 (Retention gives a weak monotone quantity).** For fixed finite Q, |R_G| is nondecreasing under the premises of LQ2. It can remain constant through indefinitely many operations. Thus it is a weak monotone quantity, not a strict Lyapunov function. Expanding Q or revising K changes what is being measured, so a comparison across such changes needs an explicit transport of questions and evidence.

This local learning direction is not yet a thermodynamic arrow. In an eight-state closed model with source bits a, b and memory bit m, the fixed operation (a, b, m) ↦ (a, b, m XOR a) is reversible. On the prepared slice m = 0 it makes a readable from memory. Under uniform source bits, whole-state Shannon entropy remains two bits while memory entropy rises from zero to one bit. Applying the same operation again clears that memory. The acquired distinction stayed inside the whole, and reversibility alone did not retain local access to it.

The whole, the preparation, the reading and the transition must therefore be distinguished. PiR M38–M41 separately treat exact transport, coarse entropy and changes of resolution. LQ11 supplies an informational completion condition. None of these derives irreversible physical time from the fact that there is no outside.

## §5. Implications for AI

### LQ10

**LQ10 (Certification is scoped, and compatible with statistical proposal).** A statistical generator can propose an answer or a proof. A checker can verify a formal claim under stated premises, and a store can retain the result with its scope. Certification concerns that claim: it does not establish that an empirical model includes the actual world. An unresolved question can elicit a further query, a set of compatible answers, an explicit hypothesis, or abstention.

There is no architectural prohibition on combining learned proposals with formal checking. [LeanDojo and its ReProver system](https://arxiv.org/pdf/2306.15626) provide a concrete example of language-model proof search interacting with Lean. The earlier claim that statistical AI cannot certify, retain or abstain was too broad. The useful distinction is between an unchecked output and an output with the required evidence and interpretation.

For VI, a sharper research direction is to train question selection against residual alternatives while retaining scoped certificates. Evaluate at least query cost, distinct new records, resolved questions and total implemented cost separately. Repeated certificates can demonstrate reliable reuse with zero new observations. Useful new evidence can settle one question without identifying the whole candidate. Neither behavior requires every episode to increase a global knowledge count.

A further hypothesis is that training on which alternatives a question excludes can improve acquisition more directly than rewarding record volume. LQ11 gives a completion criterion and failure cases for such a system. Immediate gain is still incomplete: InI S3a gives a uniquely most informative first query with worse optimal continuations, and S12 gives a necessary first observation with zero immediate information about the target answer. Acquisition policies therefore need a criterion that accounts for continuations. No efficiency advantage for a learned policy is proved here.

## §6. Boundaries

The proofs here concern static total queries, fixed candidate semantics, sound keyed observations and retaining updates. The verifier, storage and policy all remain internal to a chosen whole. Stateful interventions need a dynamics model and transported questions. Unknown or inadequate models need revision, not confidence inferred from a singleton survivor.

Three tasks remain separate: constructing a representation that distinguishes future behavior (Verdict VC38), acquiring a distinction along an executable interaction (VC30–VC34), and finding a policy that does so cheaply (InI and IiI). Saturating the first does not solve the other two. The finite acquisition-trap witness in `Checks/Models/discovery_trap.json` already exhibits that gap.

## §6a. The state of the logical medium

Derivations: <doc:learning_is_liquid__medium_contacts#Detail-6a-The-state-of-the-logical-medium>.

## §6b. Contact before reading

Derivations: <doc:learning_is_liquid__medium_contacts#Detail-6b-Contact-before-reading>.

## §6c. Coordination through internal changes

Derivations: <doc:learning_is_liquid__coordination_blocks#Detail-6c-Coordination-through-internal-changes>.

## §6d. Which independent blocks are forced?

Derivations: <doc:learning_is_liquid__coordination_blocks#Detail-6d-Which-independent-blocks-are-forced>.

## §6e. Can the relation supply its sides?

Derivations: <doc:learning_is_liquid__reconstructed_sides#Detail-6e-Can-the-relation-supply-its-sides>.

## §6f. Can one gradient determine the regions?

Derivations: <doc:learning_is_liquid__reconstructed_sides#Detail-6f-Can-one-gradient-determine-the-regions>.

## §6g. Must the reconstructed sides have their own dynamics?

Derivations: <doc:learning_is_liquid__reconstructed_sides#Detail-6g-Must-the-reconstructed-sides-have-their-own-dynamics>.

## §6h. When the requirement belongs to the medium

Derivations: <doc:learning_is_liquid__reconstructed_sides#Detail-6h-When-the-requirement-belongs-to-the-medium>.

## §6i. Atoms of a whole action

Derivations: <doc:learning_is_liquid__atoms_continuations#Detail-6i-Atoms-of-a-whole-action>.

## §6j. What an atom actually preserves

Derivations: <doc:learning_is_liquid__atoms_continuations#Detail-6j-What-an-atom-actually-preserves>.

## §6k. One atomic relation through different manifestations

Derivations: <doc:learning_is_liquid__atoms_continuations#Detail-6k-One-atomic-relation-through-different-manifestations>.

## §6l. Comparing atoms: rest, completion, return and carried difference

Derivations: <doc:learning_is_liquid__atoms_continuations#Detail-6l-Comparing-atoms-rest-completion-return-and-carried-difference>.

## §6m. Quantitative distinguishability keeps its contact

Derivations: <doc:learning_is_liquid__atoms_continuations#Detail-6m-Quantitative-distinguishability-keeps-its-contact>.

## §7. Statement

Retained evidence restricts a compatible set. For a finite sound query model, eventual separation is exactly what turns this process into finite completion. The logical medium supplies a further question: which relations make forms compatible and constrain their rearrangement? LQ13 derives a least complete contact interface and identifies when a shared equality would lose a forbidden combination. LQ14 derives a necessary coordination scale that includes internal detours. LQ15 recovers the finest independent blocks under its completeness conditions; LQ16 reconstructs the two roles of a partial recombination law while retaining its refusals. These results turn a proposed decomposition into an obligation on actual relations. The existence or unique selection of those relations still requires grounds within the whole.

LQ16a makes joint admission essential to coherent exchanges. LQ16b distinguishes extending an ideal carrier from respecting an already supplied joint family. It characterizes the maximal region of unrestricted exchanges and the smaller paths that can serve a particular request. A resident route then constructs one internally controlled action on a joint carrier, without identifying its unknown role contents. LQ16c removes the prepared route index for a specified incidence-continuation request, derives the exact condition for transporting that action through a coarser reading, and separates uniqueness of the requested continuation from uniqueness of the hidden move. The given relations, request and separate obligation of physical realization remain explicit.

LQ17 tests the stronger proposal that one ordered gradient supplies exact regions at every level. It forces nested partitions and refuses crossed ones, while leaving higher-order admission and a smallest represented region as separate obligations.

LQ18 distinguishes reconstructing a cut from preserving it under another operation. It excludes every complete autonomous binary cut for one explicit reversible interaction, then constructs the least autonomous reading from a question-return relation. This supplies a way to revise the proposed representation rather than excluding the interaction to protect that representation.

Section 6h applies the existing contact boundary to a requirement supplied by an internal counterpart. It distinguishes that derived compatibility condition from choosing, executing or valuing a continuation, and uses LQ8a to keep requirement revision separate from fulfillment. Internal regulation and experienced feeling remain further research obligations.

LQ19 applies the same recombination test to whole executions and families of relations. It derives their finest common independent blocks and a finite relational basis for that partition on finite addresses. The shared-unknown example prevents confusing factorization conditional on a mode with factorization of the joint episode. The exchange example shows why endpoint return does not establish independence of the intervening action.

LQ20 identifies those blocks from minimally forbidden partial fillings and shows that exact local reduction of irrelevant distinctions preserves them. It distinguishes a block's extent from its full law and from the dynamics which may preserve it. Joint restrictions can involve arbitrarily many roles while remaining invisible in every proper projection.

LQ21 makes the uniqueness claim precise across minimal separate presentations of the same contact. Their source-bound translations preserve the atom and compose consistently; actions are also transported when their descent is established. Unique decomposition, unique reduced description and unique occurrence or mechanism are not interchangeable conclusions.

Section 6l compares seven models without imposing a universal temporal fate. LQ22 constructs a reversible phase/residue action with an atomic execution graph, a returning phase and a precisely advancing residue. Its requested r-step effect needs neither initial value to be known. Returning endpoints do not separate the intervening history; atomicity alone does not supply the successor law used in this construction.

Section 6m relates the standard trace distance to a fixed family of supported questions. A separable two-role example retains a fully distinguishable joint relation with identical single-role marginals. The distance supplies neither the successor law of a cycle nor a physical space/time calibration.

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

## Cross-page mentions

Labels mentioned here: <doc:learning_is_liquid__medium_contacts#LQ12>, <doc:learning_is_liquid__medium_contacts#LQ13>, <doc:learning_is_liquid__coordination_blocks#LQ14>, <doc:learning_is_liquid__coordination_blocks#LQ15>, <doc:learning_is_liquid__reconstructed_sides#LQ16>, <doc:learning_is_liquid__reconstructed_sides#LQ16a>, <doc:learning_is_liquid__reconstructed_sides#LQ16b>, <doc:learning_is_liquid__reconstructed_sides#LQ16c>, <doc:learning_is_liquid__reconstructed_sides#LQ17>, <doc:learning_is_liquid__reconstructed_sides#LQ18>, <doc:learning_is_liquid__atoms_continuations#LQ19>, <doc:learning_is_liquid__atoms_continuations#LQ20>, <doc:learning_is_liquid__atoms_continuations#LQ21>, <doc:learning_is_liquid__atoms_continuations#LQ22>, <doc:permanence_is_resistance__records_entropy#M35>, <doc:permanence_is_resistance__records_entropy#M38>, <doc:permanence_is_resistance__records_entropy#M41>, <doc:permanence_is_resistance__recovery_remainder#M67>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__recovery_memory#VC23>, <doc:verdict_is_invariant__recovery_memory#VC23b>, <doc:verdict_is_invariant__discovery_acquisition#VC30>, <doc:verdict_is_invariant__discovery_acquisition#VC34>, <doc:verdict_is_invariant__discovery_acquisition#VC38>, <doc:verdict_is_invariant__discovery_acquisition#VC39>, <doc:verdict_is_invariant__reusable_images#VC46>, <doc:verdict_is_invariant__reusable_images#VC47>, <doc:verdict_is_invariant#VI1>, <doc:verdict_is_invariant#VI1a>.

Mentions of this page’s labels: <doc:learning_is_liquid__reconstructed_sides> (LQ8a).

## Topics

### Parts

- <doc:learning_is_liquid__medium_contacts>
- <doc:learning_is_liquid__coordination_blocks>
- <doc:learning_is_liquid__reconstructed_sides>
- <doc:learning_is_liquid__atoms_continuations>

### Related type declarations

- ``LiquidPhase``
- ``CrystallizationFront``
- ``SearchFlow``
- ``StefanCoupling``
- ``GateIsMembrane``
