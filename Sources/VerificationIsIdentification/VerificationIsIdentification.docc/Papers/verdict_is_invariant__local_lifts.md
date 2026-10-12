# Verdict Is Invariant (Correspondence) — Local lifts

This part contains the original derivations for local lifts.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6zzd-Available-interventions-constrain-the-hidden-carrier>.

## Detail: §6zzd. Available interventions constrain the hidden carrier

VC92's phase was a supplied internal coordinate. Its six-position continuation also minimizes the exact six-edge contact support stated there. A different question asks how much of that carrier is forced when only the task and the available transformations are fixed, without prescribing that full support.

Use three distinct stage roles x,y,z and the two stage permutations

    a: x↔y, z↦z,     b: y↔z, x↦x.

Let K be a finite complete carrier, E:K→{x,y,z} an onto common stage reading, and U a permutation of K. Require each actual U-step to have one of the stage effects allowed by a or b. Some admitted initial position over x must reach z along its U-orbit. The controller, if used to select U, belongs to K; there is no changing instruction or clock outside this complete configuration.

### VC95

**VC95 (one reversible law needs four positions; two total reversible lifts can force six).** Under this contract the minimum |K| is four. If, in addition, there must be two total permutations A,B of K with

    E∘A=a∘E,     E∘B=b∘E,

and U(k) must be either A(k) or B(k) at every k, the minimum is six. The latter bound holds even if selection may see all of K. The phase-only selection of VC92 attains it, so greater hidden selection access is unnecessary for the upper bound.

*Proof of the first minimum.* Surjectivity requires at least three positions. With exactly three, E identifies the complete carrier. To leave x on a path to z, U must take x to y; taking x to itself would trap that orbit. From y, it must then take z, since a return to x would close a two-cycle. Bijectivity would consequently require z→x, which neither allowed stage action supplies. Thus three cannot suffice. Four suffice with the single cycle

    x → y_out → z → y_back → x,

where both middle positions read as y. Its four projected edges are allowed, and its first two steps reach z. ∎

*Proof of the stronger minimum.* A maps the entire fiber over x bijectively onto the fiber over y. For surjectivity of this restriction, a position over y has an A-predecessor, and the factor equation with the injective stage map a forces that predecessor to lie over x. The same argument for B equates the y and z fibers. Therefore all three fibers have the same nonzero size r, so |K|=3r. This is M40's exact-factor cell-volume argument applied to both available operations; no probability law is needed. At r=1 the preceding three-position obstruction still applies. Thus r≥2 and |K|≥6.

For attainment, use K={x,y,z}×{0,1}. Let A apply a and flip the resident bit, and B apply b and flip that bit. Both are involutions and both satisfy the common-reading equations everywhere. Select A at bit 0 and B at bit 1. The resulting U is the six-cycle of VC92. Starting at x0, its first two steps are x0→y1→z0. ∎

The four-position law does not provide the stronger operation family. A total A lifting a would have to send both y_out and y_back to the only position over x, contradicting injectivity. It can classify its performed edges by their stage effects, but that classification does not make either effect a freely available reversible intervention at every position. Treating the four-position example as an optimization of the original two-instrument game would remove this requirement without saying so.

The distinction is between one invertible selected process and an internally available family of invertible processes. Each of the latter operations must preserve its common reading on configurations where the current policy does not choose it as well. Those additional relations force extra internal positions. The residual need not literally be a clock bit: the lower bound concerns distinct realizations in the three fibers, and the bit is one attaining representation. Nor does the argument impose a finite carrier on all reality. Finiteness, the common reading and the complete operation domains are the specified realization contract being tested.

`LocalStageCycle` presents the four-position graph and its actual successor and predecessor fields. `LocalStageSuccessor` and `LocalStagePredecessor` are compositions of existing projections. The checks cover both inverse equations at all four nodes, the entire cycle and every allowed projected contact. The two y positions have equal stage readings and positively different binary residual readings. Their different next stages prevent the stage reading alone from carrying an autonomous U-update.

`LocalStageFindsOriginal` carries an unchanged payload beside this cycle and derives its independently read original value at the z window after two advances. Its answer, acquired image and decoder coincide with those of the six-position experiment. Its commands are advances of the one supplied U; it is not claimed to execute arbitrary calls of the original a/b instruments. The existing `LocalPhase` witnesses already establish the stronger six-position construction, including both globally available involutions and their selected inverse. Counts here concern the control carrier for a fixed payload. Carrying several payloads beside it does not by itself prove minimality of every possible larger implementation of the original-answer task.

Thus agreement on a successful result and its first two observed contacts does not certify equality of the available intervention families. Conversely, established availability can force internal structure that this one successful record does not identify. This applies the same source-and-question discipline to a structural lower bound, rather than inferring hidden positions from a convenient drawing of the process.

### VC95a

**VC95a (a tree of reversible interventions).** Let T be a finite tree with m≥3 vertices and maximum degree Δ. For each edge e let t_e exchange its two endpoints and fix all other vertices. Require an onto common reading E from a finite complete K and a permutation U of K with one orbit visiting every vertex through E. Every selected stage step must be some t_e step.

If only this one U is required, the smallest carrier has 2(m−1) positions. If every t_e must also have a total involutive lift A_e on K, and each U(k) must equal one of those A_e(k), the smallest carrier has mΔ positions. Selection is permitted to use a supplied local view adequate for the selected edge address; the result does not impose phase-only access or a fixed message alphabet independently of this view.

*Lower bounds.* Removing a tree edge separates two nonempty vertex sets. An orbit visiting both must cross that edge in both directions before returning. Thus every edge contributes at least two different orbit positions, giving 2(m−1). More specifically the fiber over a vertex v contains at least deg(v) positions, one for each required outgoing neighbor contact.

Under the stronger contract, each A_e bijects its endpoint fibers, as in VC95. Connectedness makes all m fibers have the same size r. Their sizes must in particular support the largest degree, so r≥Δ and |K|≥mΔ. ∎

*Attaining the first bound.* A tree has a cyclic contour walk traversing each edge once in each direction. It can be built by adding a leaf and inserting the trip to that leaf and back at a visit to its parent. Use the 2(m−1) walk positions as K, shift them cyclically by U and read their vertices by E. This is the balanced-contact construction of M39 with one connected tour.

*Attaining mΔ with all lifts present.* Choose the contour so that at every vertex of degree at least two an arrival leaves along a different edge. Such a contour is obtained by a cyclic ordering of neighbors: inserting a new leaf between an arrival and departure preserves this property and removes the former immediate return when a leaf becomes an internal vertex.

At a vertex v the contour has deg(v) positions. Insert Δ−deg(v) stationary stage steps there, making exactly Δ positions per vertex. Label these inserted steps by different edges not incident to v. There are enough such edges, since their number m−1−deg(v) is at least Δ−deg(v). These labels really do fix v. At a leaf, at least one inserted step separates its arrival and return along the same tree edge. At other vertices consecutive contour labels were already different. Inserted labels differ from each other and from the incident labels on either side. The resulting cyclic word therefore has no two adjacent equal edge labels.

Let K be its mΔ positions and U the cyclic shift. To construct A_e, pair the endpoints of every U-step labelled e and exchange each such pair. These pairs are disjoint precisely because equal labels are never adjacent, including across the end of the cyclic word. Between the two endpoint fibers of e, the two contour traversals specify two disjoint pairs. Both fibers have Δ positions, so pair their remaining Δ−2 positions bijectively. Within any other fiber, the optional inserted e-step already specifies at most one pair; fix every remaining position there. These exchanges define a total involution A_e with E∘A_e=t_e∘E. At each position its labelled A_e gives exactly U's successor. The selected edge label is a reading of the resident position; granting that local reading makes the selection executable without an external position counter. ∎

For a path, Δ=2: the bounds are 2m−2 and 2m. VC95 is the m=3 instance. For a star with r≥2 leaves they are 2r and r(r+1). Thus this difference is not limited to one spare pair of positions. The star center forces at least r distinct departures, and the reversible lifts force that same multiplicity at every leaf as well. Removing the full-domain requirement for unused interventions removes this propagation of multiplicity.

These are bounds for a specified exploration and operation family. They do not optimize acquisition of the selected-edge reading, assign a probability or entropy, or assert that all named interventions exist in a physical source. The common reading and the actual lift relations supply the conclusion.

**The star admits selection by phase alone.** Number its r≥2 leaves cyclically and take K={center,leaf₀,…,leaf_(r−1)}×ℤ_r. Define A_i to exchange center with leaf_i in the first coordinate and exchange phases i and i+1 in the second, fixing all other entries in each coordinate. Each A_i is an involution with the required total stage reading. At phase i, select A_i. The phase then advances by one, and the inverse policy at phase j selects A_(j−1).

After r steps from phase zero, the stage has undergone t₀ followed by t₁, through t_(r−1). This sends center to leaf₀, each leaf_i to leaf_(i+1), and the last leaf to center. It is a single cycle of length r+1. Thus the full selected law is one cycle of length r(r+1), attaining VC95a. Every intermediate phase also occurs over every stage, since its stage transformation is a permutation of that complete list. Neither selection direction reads the stage or an additional payload carried unchanged beside it.

Moreover at least r distinct complete local selection inputs are necessary for this exploration when each command calls one of the named A_i. Each leaf must be entered through its incident action, so all r actions must be selected; one deterministic row cannot select two different actions. The r phase values attain this bound. This applies VC89's available-choice discipline to the resident controller, without treating the phase as evidence about an unknown payload. Under another selected action a phase can instead go backwards or remain fixed. Its forward order here follows from the action-selection law, not from an independently advancing external clock.

The three-leaf instance is `LocalStar`. Its four stage rows and three phase rows construct all twelve configurations as pairs, rather than declaring a separate unexplained successor for each whole position. The three primitive steps are applications of the corresponding catalogue projections to both coordinates, leaving an arbitrary payload unchanged. Their explicit endpoint interfaces are equated to those existing paired applications in generic `Endpoints` witnesses. `LocalStarControls` binds the actual phase-only input and operation expression for every forward and inverse row.

`LocalStarRound` derives the actual three-step endpoints and selected-operation seams. Composing four rounds returns to the original whole and covers all twelve stage/phase positions; composing three reaches the third leaf's window. `LocalStarFindsOriginal` factors the independently read initial payload through that actual window. Its final decoder is the same decoder used in the earlier phase experiment. The checks cover each of the three involutions on every stage and every phase, and both directions of the complete selected cycle. The two generators not incident to a leaf fix it, so their permutations also preserve its complement. This supplies the finite exclusion supporting the need to select every generator during exploration.

The three-phase indices do not count visits indefinitely. Applying the second primitive at phase zero leaves that phase zero; replacing the inverse policy by the forward one fails the actual return equation. These refused relations separate the selected control order from an autonomous clock assumption.

## Detail: §6zze. Transported distinctions do not require a finite whole

VC95a uses finiteness to derive repeated departures from a returning exploration. Once distinct departures are positively established, their transport has a weaker foundation. Neither the carrier's total size nor a complete inventory of its configurations is then needed.

### VC96

**VC96 (a finite witness of required multiplicity).** Let x₁,…,x_r be admitted source configurations distinguished by one independently specified question q: the answers q(x_i) are pairwise different. For each j=1,…,m, suppose an actual reading or transition T_j is defined at every displayed x_i and has a decoder D_j with

    D_j(T_j(x_i)) = q(x_i).

Suppose one common reading E distinguishes the target regions:

    E(T_j(x_i)) = b_j,

where the b_j are pairwise different. The target carrier must contain at least mr distinct configurations. This conclusion uses only the displayed cases and relations; the carrier may be infinite and otherwise unknown.

*Proof.* If T_j(x_i)=T_k(x_l), applying E gives b_j=b_k, hence j=k. Applying that same D_j then gives q(x_i)=q(x_l), hence i=l. Thus every displayed pair of indices names a different configuration. Any extension preserving these relations preserves this distinction: identifying two of the displayed images would contradict one of the established readings. This is M71's finite obstruction applied to the question at two successive boundaries. ∎

The decoder condition preserves the separating question, not necessarily the whole source. For example, a reading (i,h)↦(b_j,i) retains q(i,h)=i while omitting h. It supplies the bound for distinct displayed i even though it does not reconstruct h. This example is an information-reducing representation; it does not establish that a complete physical transition can erase its omitted field.

An actual reversible word supplies the decoder constructively: return along its inverse and then apply q. Only the inverse applications on the displayed images are needed for this witness. Their domains and seams must hold; an operation named reversible without those relations supplies neither. The word is part of the specified decoder. This is the converse direction of the same question-through- path composition used in VC52, not a claim that the path can be inferred from its endpoint.

In the three-leaf star take the three center configurations with phases 0,1,2 and any one fixed payload. The source question reads the resident phase label through its actual pair address. Use the empty path and each of the three primitive involutions as the four T_j. The common stage reading distinguishes center and the three leaves. Applying the same primitive again and then reading the phase recovers the three original labels at each leaf. Hence these admitted contacts require twelve distinct configurations without assuming that those twelve exhaust the carrier.

`AnswerThroughReturn` derives a `ReadingFactors` certificate from an independently chosen question and two applications with a supplied return seam. The caller does not supply equality of question answers. `LocalStarPhaseImage` consists of the existing pair projections. Each `LocalStarReturn` takes only the arrived whole and derives its stage, phase and payload inputs there. `StarTransportedSeeds` checks all nine leaf factorizations and all twelve common-stage readings. The seed labels are the finite constructor forms 0,1,2; their positive boundaries use `ZeroSuccessorBoundary`, with a predecessor projection separating 1 from 2.

This is a lower bound on admitted distinguishable configurations, not a count of simultaneously existing particles. The complete finite star constructed in VC95a attains it for this control carrier. The finite witness also remains valid inside any larger realization that retains the same source distinctions and contact relations. It does not independently establish those relations for an unknown physical source or derive the three seed distinctions from the word “difference” alone.

**Why knowing a return is not knowing which return to use.** In that same star, the word 0,1,0 takes center/phase 0 through leaf A/phase 1 and leaf A/phase 2 to center/phase 2. The empty word from center/phase 2 has exactly that same final working configuration. The original phase answers are 0 and 2. If the admissible sources include both source/path pairs and the observation retains only their final working carrier, no shared decoder can recover the original phase. Each path separately has an inverse. Their omitted choice does not factor through this observation.

`StarUnknownReturnPath` binds the two actual working endpoints. `StarResidentUnknownPath` supplies the choice inside the modeled system: the three commands reside in a tape and `ResidentBoundaryCommand` retains each consumed head in its past field. The empty-path source has an empty tape and past. Their final working projections agree, while their complete resident records still differ. The original phase questions read the actual initial working fields and supply the positive answer obstruction. No disappearance of the path from the complete system is asserted.

Reusing the current phase as the original phase also fails after just one primitive. These are different mistakes: the first excludes the recovery context from the observation, while the second applies the wrong reading even when the path is fixed.

There is no hidden path choice in VC96's twelve-case witness. Each leaf has one specified transport from the center, and its stage identifies which displayed decoder applies; the center uses the empty path. Adding the extra return loop while erasing its identity enlarges the source/path family and loses that property. Distinct, certified recovery constructions therefore do not establish their own applicability after their distinguishing context has been removed.

**Applying S25: exactly which original questions survive an omitted path.** Take all three center phases and any admitted payload V as preparations in this star, allow every finite primitive word, and expose only the final working configuration. An original-source question q can be recovered for every such source/word pair exactly when, on the center preparations, q depends only on V.

For necessity, the center-based word 0,1,0 exchanges phases 0 and 2 and fixes
1. The word 1,2,1 exchanges 0 and 1 and fixes 2. Both retain V. Comparing each performed loop with an empty-word preparation at its endpoint forces the corresponding original q answers to agree. These two exchanges connect all three phases, so q must be constant over them for each V. For sufficiency, every primitive retains V by construction; induction on a finite word retains it, and the final payload projection followed by the chosen function of V recovers q. `StarReturnLoopsConnectSeeds` checks both complete phase exchanges at their actual center return, for arbitrary V.

This is S25's existing question-scoped loop criterion applied to the available instruments, not a new general theorem about loops. The stage movement graph is a tree, but the full contact family contains more than its moving edges: at leaf A, primitive 1 fixes the stage while changing phase. That stationary contact is the middle of the first loop. Discarding contacts that leave a coarse stage unchanged would remove the very relation that obstructs recovery.

Consequently the same carrier has two different exact descriptions for two different demands. Its phase distinctions are required for the supplied interventions and selected exploration. They are absent from the original questions recoverable without the path. The payload can survive the latter restriction even when every nonconstant original-phase question fails it. Calling the phase irrelevant without specifying which demand is being preserved would merge these two results.

## Detail: §6zzf. A minimal stage-only distinguishing continuation

The positions required by VC95a need not have a separately accessible phase sensor. Whether their distinction is observable depends on which actual continuations the question permits.

### VC97

**VC97 (the selected star's stage horizon is exactly r−1).** In the r-leaf phase-controlled star of VC95a, r≥2, fix the selected law U. The current stage and its next r−1 stages identify every one of the r(r+1) control positions. No smaller common number of U-advances suffices. An unchanged additional payload is outside this identification question.

*Proof.* Around the one U-cycle the stage word is

    center, leaf₀ repeated r times,
    center, leaf₁ repeated r times, …,
    center, leaf_(r−1) repeated r times.

At a center position the next leaf distinguishes its r possible phases. At a leaf the distance to the next center is one of 1,…,r, different at its r positions. Observing r−1 advances distinguishes every distance below r by the first center occurrence; no center in that prefix identifies distance r. Together with the current leaf this identifies the position. With H≤r−2, the first two positions of any r-long leaf block both give H+1 copies of that leaf. Their later center arrivals differ, so these distinct positions have not become equivalent continuations. ∎

For r=3 the complete two-advance table is:

| Initial stage | Phase 0 | Phase 1 | Phase 2 |
|---|---|---|---|
| center | center,A,A | center,B,B | center,C,C |
| A | A,center,B | A,A,A | A,A,center |
| B | B,B,center | B,center,C | B,B,B |
| C | C,C,C | C,C,center | C,center,A |

All twelve words differ. At A, phases 1 and 2 agree on the current and next stage; their third readings are A and center. `StarShortTraceCollision` checks this equal prefix and its positive zero/successor continuation boundary. This is the finite identification and continuation criterion of U2c and VC44, with a derived exact horizon for this source.

`SelectedLocalApplication` takes a source-bound application root, an actual local-input reading, a row of the fixed address program and a finite catalogue selection. The row selects the path address; the primitive is the selected leaf itself. There is no separate primitive argument to substitute by matching an operation label. `LocalStarApplicationRoot` derives all three applications at the current working source and binds their ordered catalogue and library expression. The input available to the selector contains only phase and the fixed address program. The root is an application view supplied by the declared library, not a new observation of the unknown source granted to the selector.

The resulting selected-law expression retains the library expression and address program, and is the same at all three phase clauses. Thus the finite table does not compare answers to three differently named policy questions. `TwoStepStageTrace` composes actual source transitions with the stage projection; `StarObservationGrid` checks all twelve words and their one common question. Supplying the inverse table while still applying the old primitive is refused at the selection seam.

The complete catalogue path also belongs to each operation expression. Retaining only its terminal left projection would identify the first and second column descriptions. The stage, residual and phase questions retain their different source paths, even when their answers happen to agree. A recording command includes the question it records. The checks refuse substitution of these different questions.

Actual occurrence selection is stronger than repairing those expressions. `AliasedApplicationRoot` deliberately gives two concrete readings equal labels and equal answers. A left-path choice still selects the first reading itself. A counterfeit path with that same address, label, working source and result fails because its starting catalogue has replaced the first occurrence. This reuses M65's existing finite `SelectCandidate` rule for actual reading occurrences. It is not a new status or a proof of arbitrary root adequacy. Both the current root and its finite selection construction remain bound premises of the application.

**The actual acquisition carries its own order.** `AcquiredTwoStepStages` constructs a five-command resident program: record the current stage, apply the selected law, record, apply it again, and record. Each record retains its current working source beside the acquired fact. The two advances act only on that working field, retaining the previous records. Every consumed instruction remains in the command history. The final observation projects only the three ordered facts; its decoder reads their answers, without access to the phase, current working source, original configuration or command history.

The independent source question is `TwoStepStageTrace` at the actual initial working address. Its factorization through the acquired facts is derived by the generic construction, not requested as an output equality. Each fact is acquired at its own intermediate source. Treating all three as repeated measurements of one unchanged source would require different relations. The count r−1 measures source advances, not total physical time: the r=3 construction also performs three recordings and carries an internal program. Its larger observer-and-record carrier is not included for free in VC95a's minimum for the unobserved control carrier. Availability of the supplied noninterfering stage-record construction is an explicit interface condition.

`StarAcquiredObservationGrid` instantiates that factorization at all twelve preparations and checks that their resident instruction tapes agree. The decoder type also remains unchanged when only the payload changes. Reversing the first and last facts fails the original question for center,A,A but preserves it for A,A,A. The latter single success does not justify erasing order from the whole preparation family.

**The same phase remains invisible under another complete vocabulary.** Suppose instead that the observer may call any of the primitive A_i, but its entire input consists of stage readings, its own fixed program and records computed from them. Two initial configurations with the same stage give the same stage after every identically chosen primitive, because E∘A_i=t_i∘E. Induction preserves equal observer records and therefore the same next chosen primitive under every deterministic adaptive policy of that observer. No such policy can identify the hidden phase, regardless of its horizon.

Allowing the resident selected law U supplies a different contact. Its selection reads the phase inside the source and can communicate that distinction through the next stage. For example, the three central phases have different U-images but each fixed primitive has the same stage effect on them. U is built from the same A_i together with that additional internal selection input; access to the A_i alone did not grant the observing actor that input. This is the locality boundary of VC90 and the acquisition boundary of PP19 in one finite example, rather than information produced by repeating an insensitive probe.

The result connects the structural lower bound to an explicit distinguishing continuation. It also limits its interpretation: the stage image is exact for the whole freely chosen primitive vocabulary and insufficient for the resident selected-law vocabulary. Saturating only the former cannot certify the latter by assuming that the system's internal selection sees no more than the observer.

## Detail: §6zzg. A calibrated contact can fail substitution under internal selection

Return to the three-stage, two-phase carrier of VC92. Its old whole primitives A and B perform the stage transpositions a=(x y) and b=(y z), respectively, and both flip the resident phase. Both retain the payload V.

### VC98

**VC98 (identical stage contacts, different internal continuations).** Consider two whole contacts. C₁ is the old word A,B,A. C₀ performs its stage action c=(x z) while preserving the phase. Each is an involution, and they have the same stage and payload images at every source. Nevertheless they cannot be substituted in every context of the supplied system.

*Witness.* From x/phase 0, C₁ reaches z/phase 1 while C₀ reaches z/phase 0. Apply the same old resident law U, which selects A at phase 0 and B at phase 1. The first case reaches y/phase 0; the second reaches z/phase 1. Even the original quiet/signal interface distinguishes them, since y is Signal and z is Quiet. Their payload answers remain equal. No new phase sensor is supplied to the observing actor. ∎

This is stronger than a missed one-input calibration. For any fixed word over the corresponding A, B and C contacts, the two libraries give identical stage answers: every contact factors through the same stage operation. Induction extends this to an actor choosing contacts using only its stage history and fixed internal resources. The separating U has an additional internal input, the phase. Thus completeness for the former continuation vocabulary did not establish completeness for the latter.

Nor can C₀ be recovered as some longer word over the old A,B on this complete carrier. Every old letter changes the phase and is one transposition of the three stages. Even-length words induce an even stage permutation and preserve phase; odd-length words induce an odd stage permutation and flip it. The target c is odd but C₀ preserves phase, violating this relation. Equivalently the six permutations split into the three cyclic orderings and their three reversals; either old generator exchanges these two classes and flips the phase at the same time. This is a finite relation between the complete stage action and phase action, not an assumed physical parity conservation law.

`LocalStageClosing` derives the stage word. `LocalPhaseMacroClosing` composes the actual old whole operations, retaining their phase effect. `LocalPhaseUnflippedClosing` applies only the derived stage reading beside the unchanged phase/payload field. `LocalClosingImagesAgree` derives their common source and stage/payload projection for arbitrary admitted fields. The finite checks cover both involutions at all six canonical positions. `LocalClosingFeedbackWitness` then binds both next actions to their actual phase readings and one fixed program. The complete-output substitution and the later quiet/signal substitution are separately refused.

There is a related capacity distinction, without a contradiction in monotonicity. If a third directly available stage exchange c may also be selected as one step, the stage cycle x→y→z→x has a three-position realization with all three transpositions present. The three `LocalStarPhase` catalogue rows already present these involutions and their selected cycle. Under VC95's old requirement U(k)∈{A(k),B(k)}, six positions were necessary. The new game both adds a contact requirement and enlarges the allowed selections to include C. It has not obtained a smaller minimum by adding constraints while leaving the old choice set unchanged.

Deriving the endpoint expression c=a b a can be done statically. That derivation does not need to perform the modeled operations. Claiming that an unknown source offers c as a single available intervention is another question. Executing the old word internally retains its old complete effect and needs the local control of VC94a. In particular, naming that word C₀ cannot remove its phase change. A source with C₀ available has an additional whole contact, even when stage-only calibration cannot distinguish it from C₁.

## Detail: §6zzh. A relation of visible actions can fail on the carried phase

VC98 compared two differently supplied whole contacts. A stronger obstruction already occurs among words of the same primitive library. Keep VC95a's r-leaf star: t_i exchanges center with leaf i; the accompanying phase contact τ_i exchanges i and i+1 modulo r. The working primitive is their product and retains V. Words below list performed contacts from left to right.

### VC99

**VC99 (the first failure of complete-stage determination is r=4).** For r=2 or r=3, two primitive words with the same complete stage permutation also have the same phase permutation. For every r≥4, there is a word with the identity stage permutation and a nonidentity phase permutation. Thus the complete stage action of a word no longer determines its phase action in this family.

*Proof for r≥4.* Write X=(0,2,0) and Y=(1,3,1). On stages, X exchanges only leaves 0 and 2, and Y exchanges only leaves 1 and 3. They are disjoint exchanges, so W=(X,Y,X,Y) fixes every stage. This includes the center and, when r>4, every other leaf.

On phases, τ₀ and τ₂ are disjoint, hence X acts as τ₂. Likewise τ₁ and τ₃ are disjoint and Y acts as τ₃. But τ₂ and τ₃ meet at phase 3. Put k=4 modulo r. Their sequence τ₂,τ₃,τ₂,τ₃ sends 2→3, 3→k and k→2, fixing all other phases. It is not the identity. No additional primitive or hidden phase measurement has been supplied. ∎

*Proof of the smaller cases.* At r=2 both phase contacts are the same exchange. The phase action therefore records whether the word length is even or odd. Each stage contact is a transposition of three stages. It exchanges the three cyclic orderings of those stages with their three reversals. Consequently the identity stage action requires even word length and identity phase action.

At r=3 identify phases with these three partitions of the four stages:

    phase 0: {{center,1},{0,2}}
    phase 1: {{center,2},{0,1}}
    phase 2: {{center,0},{1,2}}.

Acting on both pairs of each partition, t₀ exchanges phases 0/1, t₁ exchanges 1/2, and t₂ exchanges 2/0. These are exactly the three supplied τ_i. Induction on a word identifies its phase action with its action on these partitions. The identity stage permutation fixes every partition, so it fixes every phase. In both smaller cases, compare two equal stage actions by following the first word with the reverse of the second: each primitive is an involution, and this comparison word has identity stage action. Its phase identity gives equality of the two original phase actions. ∎

For r=4 the one fixed twelve-contact word is

    0,2,0,1,3,1,0,2,0,1,3,1.

It fixes all five stages, while its phase map is 0→2→3→0 with phase 1 fixed. This does not mean phases first exist at four leaves. They were already needed at lower valence. What first fails here is determination of the complete phase action by the complete stage action of a word.

**Six contacts are necessary and sufficient for some hidden phase change.** For r≥4, Z=(0,2,0,2,0,2) is shorter than W. The stage action of 0,2 is a three-cycle, so its third power is the identity. Its phase contacts are disjoint exchanges. Their product has order two, so its third power is that same nonidentity product: Z swaps phases 0/1 and 2/3.

No shorter word can return every stage while changing the phase. Cancel any adjacent equal letters; this preserves both actions because every primitive is an involution. A stage-identity word has even length. A reduced two-letter word is not the identity. For a four-letter word (i,j,k,l) with adjacent letters different, identity would equate the two-letter stage actions (i,j) and (l,k). Each is an oriented three-cycle through center and its two named leaves; its ordered leaf pair is uniquely determined. Thus i=l and j=k, contrary to the absence of adjacent cancellation. Length zero changes no phase. This excludes every length below six without a search over candidate words.

The same calculation supplies a time question without an external clock. At r=4 repeat the two-contact block B=(0,2), starting at center/phase 0:

| Completed blocks | Stage | Phase |
|---|---|---|
| 0 | center | 0 |
| 1 | leaf 0 | 1 |
| 2 | leaf 2 | 0 |
| 3 | center | 1 |
| 4 | leaf 0 | 0 |
| 5 | leaf 2 | 1 |
| 6 | center | 0 |

The stage question has period three blocks, the phase question period two, and their joint question period six. The block order is supplied by a resident two-contact program when executed; it is not a freely advancing outside time coordinate. Returning a working projection does not return an additional growing history record. This is a scoped recurrence relation, not a claim that the complete universe has period six or a derivation of physical duration.

**The omitted distinction has a supplied distinguishing continuation.** At the center with phase 0, W returns to the center with phase 2. The empty word leaves the source at center/phase 0. Every subsequent word chosen by an actor with only stage access gives the same stage readings from those two endpoints, by VC97's primitive-interface argument. But one application of the resident law U, which selects contact i at phase i, gives leaf 2 after W and leaf 0 after the empty word. Thus replacing W by the identity on the strength of its complete stage calibration is invalid for that continuation vocabulary.

The calibration being compared is the endpoint action on all stages. It does not include the words' different intermediate stage histories or their command records. Those are different questions, and knowing a performed word can itself support additional inference. Executing W inside a closed arrangement requires its twelve-command controller; its consumed instructions may be retained as in VC94a. The working phase change is not an erasure of that controller's history. In fact W repeated three times restores the entire stage/phase working carrier and V, without restoring a growing record to its earlier length.

The static construction uses arbitrary symbolic labels at the five stage addresses and four phase addresses. `FourLeafStage0`–`3` and `FourLeafPhase0`–`3` are their actual exchanges. `FourLeafShortStageWord` and `FourLeafStageWord` derive complete stage identity for Z and W. The two phase-word constructors derive (B,A,D,C) and (D,B,A,C) from (A,B,C,D). Every intermediate source is joined to the previous actual output through `FollowedPair`; no final equality is requested from a caller. Separate generic checks establish all eight primitive involutions and threefold return under W.

The tuple lists the token at each final address. In W's output (D,B,A,C), original token A reaches address 2, token C reaches 3 and token D reaches 0. This is the stated point cycle 0→2→3→0, rather than its inverse. The code checks that distinction explicitly. Arbitrary labels establish the complete finite permutation without listing twenty products of stage and phase, or reading all positions as physical data. This finite symbolic presentation replaces a much more expensive recursive table unfolding. The general r≥4 construction, its exact ambiguity and the exclusion at r=2,3 are the arguments here, independent of a word-search program or an enumeration report.

`LocalFourLeafCourt.swift` presents a finite direct-court certificate from those current definitions: four initial sources, 32 intermediate equalities, four endpoints, two directed label readings, 36 actual constructor selections, eight independently specified contact calibrations and the four actual Path structures. Selection is checked even when another constructor could return the same tuple. The 90 obligations are read by the existing native and gate relation courts without compiling the modeled Swift program; an independent Swift check forces the same conditional equalities. The certificate supplies its own explicit ordered step list and binds the declared Path to that constructor tree. It does not claim that the relation court elaborates every conditional generic declaration, or that equality of endpoints certifies a different path. The generic `FollowedPair` constructions remain checked by Swift; the direct certificate separately presents every seam they require and preserves their order.

The obstruction is at the level of relations between operations. Each primitive still has an exact stage image. The visible relation XY=YX is valid on every stage, yet its two lifted phase actions do not commute. A faithful stage quotient for the primitive-only game can therefore forget a distinction essential to a larger game with resident selection. The missing condition is preservation of the relations needed by that larger game, not greater precision in measuring the same endpoint stage map.

### VC99a

**VC99a (the exact remaining phase-action ambiguity).** For r≥4, among all finite primitive words with a given complete stage permutation σ, the phase permutations are exactly those with the same parity as σ. For r=2,3 there was only one. In particular, endpoint calibration of the entire stage permutation leaves r!/2 possible phase permutations in the larger-valence family.

*Proof.* Every letter is one transposition on stages and one on phases, so their parities agree for every word. In particular a stage-identity word can have only an even phase action.

Conversely, W supplies one three-cycle on phases with identity stage action. The phase contacts τ₀,…,τ_(r−2) are the adjacent exchanges and generate every phase permutation: successive adjacent exchanges move each named phase to its prescribed position. Conjugating W by a word with an arbitrary such phase permutation still has identity stage action and gives the correspondingly renamed three-cycle. Thus every phase three-cycle is available with identity stage action. Every even phase permutation is a product of three-cycles. To see this directly, pair the transpositions in an even-length expression: an identical pair cancels, a pair sharing one point is a three-cycle, and a disjoint pair can be split into two sharing pairs by inserting the same bridging exchange twice. Hence every even phase action occurs over stage identity, and no odd action does.

Choose any word giving σ; the stage star exchanges generate every stage permutation, since (i,j,i) exchanges any two leaves. Let this word's phase action be τ. Appending a stage-identity word can multiply τ by any even phase permutation. This reaches exactly its parity class, which is σ's parity class. The two parity classes have equal size because multiplying by a fixed exchange pairs them. ∎

This sharpens the question rather than declaring every hidden distinction unknown. The parity of the phase operation is determined. Its complete action usually is not. For a fixed initial phase, the compatible final phases exhaust all r positions: even permutations act transitively when r≥3. Therefore asking where that particular phase goes cannot be answered from the calibrated stage permutation alone. A retained word or a suitable additional contact can supply the missing relation; neither is contained in a more precise measurement of the same σ.

## Detail: §6zzi. The missing action can be acquired with one fewer point probe

VC99a determines a precise remaining family, so its acquisition cost can be asked without guessing a hidden mechanism.

### VC100

**VC100 (point-query cost with known parity).** Let one fixed unknown permutation τ act on r≥2 known distinct phases. Its parity is supplied. A query may choose any phase i and return the exact value τ(i). Determining the complete permutation requires and suffices with r−2 queries in the worst case, even for deterministic adaptive policies. Without the parity premise the corresponding minimum is r−1.

*Sufficiency.* Query any r−2 different inputs. Their images are distinct. Exactly two domain points and two possible images remain. The two bijective completions differ by one exchange and have opposite parity. The known parity selects exactly one. Without parity, query one further input and the final image is the only unused one. At r=2 the known parity already specifies τ.

*Necessity.* If a policy stops with at least three unqueried inputs, follow its actual responses under τ. Precompose τ with a three-cycle of those unqueried inputs. The alternative has the same parity and preserves every returned answer. Induction on the policy's available history gives the same chosen queries and stopping decision, yet the complete permutations differ. Thus fewer than r−2 cannot suffice. Without a parity restriction, exchanging two unqueried inputs supplies the analogous obstruction below r−1. Repeating an already queried input does not remove either obstruction. ∎

For r=4, the two distinct returned images have 4·3 possible ordered pairs. Each is the prefix of exactly one permutation of the supplied parity. This is the whole twelve-member ambiguity of VC99a, rather than twelve possibilities chosen to fit a decoder. For a question about just one τ(i), one corresponding query suffices and, on that full family, is necessary. Identifying a finite word that realizes τ is a different question: words differing by a returning relation have the same complete action.

**Connection to the supplied star interface.** Restrict first to words whose complete stage action is the identity. Prepare a known center/phase i, apply the unknown fixed word, then apply the resident law U. The next leaf is τ(i), because U selects its contact from the resulting resident phase. This exposes the needed point value through a stage observation; no separate phase sensor is given to the observer. Repeating this construction for r−2 prepared inputs implements the point-query contract if the same law acts on every preparation. The count concerns word queries. It does not bound the word's length, provide free preparations, reset a changed source, or grant stability across trials. Those are explicit parts of an acquisition arrangement inside the system.

**Two true readings need not belong to one unchanged law.** At four phases, start with the identity table (0,1,2,3). Read its value at input 0, obtaining 0. Change the internal law to the even table (3,1,0,2), then read its value at input 1, obtaining 1. Both readings are true. Under a single fixed even law, the pair (0,1) would uniquely determine the identity. The current law is not the identity. Both laws are compatible with stage identity by VC99a, so that whole-stage calibration does not detect the change.

`PhaseLawTwoProbeTrace` retains the first actual fact, performs the supplied law change beside it, and acquires the second fact from the actual new source. Its three boundaries compose. `RetainedPhaseLawInquiry` also keeps the supplied change construction in each history's description; the available fact reading does not inspect it. The stable and changing histories therefore need not have the same complete initial source or the same retained context.

`PhaseLawMixedHistory` derives equal available facts for those histories, with the same fact and current-law questions, while deriving different current law tables. The change uses `FourLeafPhaseWord` on the table's four symbolic entries. Its intermediate word is already given; accounting for resident execution of that macro is the separate control requirement of VC94a. The static trace states where the two readings occur and what is retained beside the working table, not a claim of three elementary physical time steps.

The finite witness preserves the original recorded answers and all four table entries. It refuses to treat the two probe sources as one, or their matching record prefix as an unchanged complete current law. The second table entry remains equal, and its recorded answer remains usable. Thus VC100's common-law premise is a relation the acquisition must preserve. A uniquely completable record does not establish that relation by itself.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__records_entropy#M39>, <doc:permanence_is_resistance__records_entropy#M40>, <doc:permanence_is_resistance__uniform_routing#M65>, <doc:permanence_is_resistance__forced_answers#M71>, <doc:verdict_is_invariant__reusable_images#VC44>, <doc:verdict_is_invariant__reusable_images#VC52>, <doc:verdict_is_invariant__relative_questions#VC89>, <doc:verdict_is_invariant__finite_policies#VC90>, <doc:verdict_is_invariant__finite_policies#VC92>, <doc:verdict_is_invariant__finite_policies#VC94a>.

Mentions of this page’s labels: <doc:permanence_is_resistance__contact_rigidity> (VC99), <doc:permanence_is_resistance__frame_acquisition> (VC100), <doc:permanence_is_resistance__frame_acquisition> (VC99a), <doc:verdict_is_invariant__calibration_residence> (VC95a), <doc:verdict_is_invariant__calibration_residence> (VC97), <doc:verdict_is_invariant__calibration_residence> (VC99), <doc:verdict_is_invariant__four_phase_catalogue> (VC100), <doc:verdict_is_invariant__four_phase_catalogue> (VC95a), <doc:verdict_is_invariant__four_phase_catalogue> (VC99), <doc:verdict_is_invariant__four_phase_catalogue> (VC99a).
