# Verdict Is Invariant (Correspondence) — Routing laws

This part contains the original derivations for routing laws.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6ze-Transport-an-acquired-boundary-through-a-source-change>.

## Detail: §6ze. Transport an acquired boundary through a source change

An acquired agreement concerns addressed applications on its actual source. Changing that source requires a relation to the new applications. The existing commuting squares provide that relation while keeping the operation in the future question. For the resident pair w=(x,y), write A(w)=(alpha(x),alpha(y)) and let c classify that ordered pair into J₀, J₁ or B as in VC61.

### VC66

**Claim VC66 (side exchange preserves the common-answer interface).** Let S exchange the two actual source components. Then A(Sw)=s(Aw), where s(a,b)=(b,a), and c(s(a,b))=c(a,b) on the binary carrier. Consequently the three-class image preserves the common-answer value and its domain through every finite repetition of S.

**Proof.** Component projection gives A(Sw)=(alpha(y),alpha(x)). The equal pairs (0,0) and (1,1) are fixed by s. The pairs (0,1) and (1,0) exchange places but both classify as B. Thus every class is fixed, and agreement a=b is preserved and reflected. Induction gives the same class after every finite repetition. ∎

`SwapBoundaryReading` applies the same exchange to source components and to their ordered alpha image. `SwapBoundaryTransition` derives the square by projection. `AgreedBoundarySwap`, `ZeroSuccessorBoundarySwap` and `SuccessorZeroBoundarySwap` then derive the class squares. Their common image action is `KeepBoundaryUnderSwap`. `ReobservedTransition` composes them into actual source-to-class squares, with no separately assumed equality of endpoint classes. Two consecutive swaps must use the actual intermediate source. Returning its component layout does not identify the event history with the initial record.

The ordered alpha image is also available from the two acquired facts of VC64. `JointEvidenceFromMemory<F,G>` combines their existing decoders while retaining their one actual observation. It constructs a factorization of `JointEvidence<F.Left,G.Left>` through the old memory. `AnswerOnRefinement` can then recover c from that memory. The coarse swap square already predicts the endpoint class from the old three-class image alone. Composing with its acquired factorization reads that prediction from the old memory without acquiring another source fact.

This is transport of a question along the specified operation. `QuestionAlongTransition` and `FutureOnEvidence` retain the operation in the question type. They do not rename a trace of w as a fresh trace of Sw. The static state relation can apply the source step beside unchanged memory using `StepBeside`, and a separate `RetainedWhole` can retain that actual predecessor and successor as an event record.

## Detail: §6zf. A resident exchange makes an omitted distinction relevant

For a different intervention, exchange the first component's alpha and beta. `ExchangedBoundaryFirst` uses the existing `SwapVisible` for that component and keeps the other component. The old alpha moves to the resident beta address. Suppose the first beta is initially zero. On the observed pair, this intervention has image R(a,b)=(0,b). The source action preserves the displaced value, although this local image omits it.

### VC67

**Claim VC67 (one prepared exchange refines the required initial image from three classes to four).** On the four binary alpha pairs with a resident zero in the first beta, a representation that determines both the present common-answer class and its class after this exchange must distinguish all four ordered alpha pairs. The acquired ordered pair (a,b) is sufficient. The old three-class image is insufficient.

**Proof.** The current classes already distinguish (0,0), (1,1), and the group {(0,1),(1,0)}. The exchange sends (0,1) to (0,1), with class B, and (1,0) to (0,0), with class J₀. Hence the previously grouped pair must split. Four classes are necessary. They suffice because the ordered pair determines both c(a,b) and c(0,b). ∎

The other two transitions are J₀→J₀ from (0,0) and J₁→B from (1,1). The failure B therefore has no single image action for this intervention. This is a positive failure of factorization: one old input class would have to give two distinct output classes. The full acquired memory already distinguishes those inputs, so no new measurement is needed when it remains accessible.

`BoundaryFirstZeroTransition` derives the ordered-image square from the actual condition `P.Left.BetaLevel == Never`. `BoundaryFirstZeroImage` gives (0,b), and the three existing pair-class constructors supply the endpoint question. `FutureOnEvidence` composes the square, that endpoint question and `JointEvidenceFromMemory`. Its decoder takes the original acquired memory, while its direct path applies the specified source action before classifying the successor. The four concrete binary cases are supplied.

The zero condition belongs to the actual initial source family. The two alpha facts do not themselves establish it. `ExchangeBoundaryFirst` also applies when beta is occupied, but then the zero-image square is wrong. After exchanging alpha=1 with beta=0, beta contains 1. A second exchange is still possible and returns alpha to 1. What ceases to apply is the previous prediction of a zero result, not the exchange operation. This distinguishes an action's existence from the premises of a particular description of its effect.

The old trace also remains an old trace. In the (1,1) case its first fact still reads 1 while the successor's first alpha is 0. The actual source step can preserve that memory unchanged. The future classification obtained through the square is B. Appending a new-source reading to the old fixed-source trace, substituting equal-valued evidence from another source, or dropping the operation from the future question are different constructions and fail their respective address or question requirements.

Four classes here suffice for the declared initial task: the present class and the class after one prepared exchange. This does not make the updated alpha pair an exact state for repeated exchanges. Initial pairs (0,0) and (1,0) both produce the updated alpha image (0,0), but their first beta values are now 0 and 1. A second exchange reveals that retained difference. The residue therefore determines a later result even when the current common-answer interface omits it. To make a current image closed under those future interactions, that residue or another representation determining its effects must be included.

## Detail: §6zg. Close the working image under both internal exchanges

Write a current working configuration as x=(a,c,b,d), with two resident blocks (a,c) and (b,d). These are the blocks' alpha and beta fields. Their third fields remain attached to the actual blocks but do not enter this interface. The full working carrier is X={0,1}⁴. Its sixteen configurations do not count whole histories, program states or nominal Swift wrappers. The earlier prepared family is P={(a,0,b,1): a,b∈{0,1}}. Preparation applies at that beginning, not after every action.

The total actions are E(a,c,b,d)=(c,a,b,d) and S(a,c,b,d)=(b,d,a,c). The observed common class is c₀(x)=c(a,b), where c(0,0)=J₀, c(1,1)=J₁ and c(0,1)=c(1,0)=B. J carries the shared answer. B carries an obstruction to that common-answer request. This declared binary interface does not assign a Boolean valuation to every question in the whole.

### VC68

**Claim VC68 (the four working coordinates close under every finite word in E and S).** The coordinate observation W has commuting squares for both actions on every current source p in the declared structural beam family. Composing them gives W(wp)=w̄(Wp) for every finite action word w. Both actions retain the displaced coordinate and are involutions on working configurations.

**Proof.** Projection after E gives ((c,a),(b,d)), exchange inside the first row of W(x). Projection after S gives ((b,d),(a,c)), exchange of its rows. These formulas apply to the successors themselves, with no zero premise. Their squares compose at the actual intermediate source. Identity is the empty word, and appending either generator supplies the induction step. Applying either permutation twice restores all four coordinates. ∎

`BoundaryCoordinatesExchange` and `BoundaryCoordinatesSwap` derive the generic squares. `SwapVisible` now has the concrete structural conformance needed to place its result inside the next source pair. Its old omission prevented a valid mixed composition in the encoding. It was not a prohibition on the exchange. A double exchange restores the coordinate reading even when a nested source wrapper has a different nominal identity.

An action word can be resident. `ResidentBoundaryCommand` binds the next tape head to the applied reading's operation, moves that head to a retained past and keeps the remaining tape inside the output. The next command consumes that output. `RecordedBoundaryCommand` uses `RetainedWhole` when an occurrence record is required. This supplies an internal word and order, with an explicit growing-history construction rather than an external selector or an assertion of unlimited finite storage.

## Detail: §6zh. The exact behavioral object has fifteen values

Define the comparison table Φ by

```
             b         d
    a      c(a,b)    c(a,d)
    c      c(c,b)    c(c,d)
```

E exchanges its rows. S transposes it because each elementary comparison is symmetric. The current common class is its upper-left entry.

### VC69

**Claim VC69 (Φ is the coarsest exact image for all common-answer continuations on X).** Two configurations have equal Φ images exactly when every finite E/S continuation gives the same common class. Φ has fifteen values: it merges only (0,0,1,1) with (1,1,0,0). All fourteen remaining configurations have separate images.

**Proof of sufficiency.** Row exchange and transposition determine both generator updates from Φ alone. Each update is again a table of the same form. The upper-left entry determines the common-answer value and its availability. Induction on finite words proves sufficiency for all continuations.

**Proof of necessity.** Read the common class after ε, E, SES and ESES, writing actions in execution order. These four words return the upper-left, lower-left, upper-right and lower-right entries. Any unequal entry therefore supplies a distinguishing continuation. Every exact representation must determine Φ.

**Proof of the count.** If some entry is Jᵥ, its two incident coordinates both equal v. Comparisons against these fixed coordinates determine the other coordinate in each block: Jᵥ gives v and B gives 1−v. Any table containing J therefore determines all four bits. If every entry is B, both coordinates of either block must equal each other and oppose the other block. Exactly (0,0,1,1) and (1,1,0,0) remain. Their all-B table is fixed by both updates. There are fourteen singleton classes and one double class. ∎

`BoundaryTable` binds four comparison applications to the actual cross-coordinate inputs. `BoundaryTableExchange` derives row exchange by rearranging those applications. `BoundaryTableSwap` derives transposition while reversing their inputs. The elementary reversals agree with the existing binary clauses by `BoundaryReverse00` through `BoundaryReverse11`. Recursive reversal introduces no new answer. `ReobservedTransition` joins the table squares to VC68's actual source squares, and `JoinedTransition` closes their generated paths.

The admitted comparison grammar starts with `Boundary00`, `Boundary01`, `Boundary10` and `Boundary11`, whose answers follow from agreement or positive constructor obstruction. `Boundary0000` through `Boundary1111` declare all sixteen working inputs using those leaves. The compiler checks their addressed comparisons and derived table shapes, the generic update squares and the four separating projections. Coverage, the count and induction over that declared grammar are the mathematical argument above. An arbitrary `PredicateReading` bearing the same question name does not acquire binary-comparison semantics from its label. Swift conformance does not seal this grammar against unrelated declarations.

Fifteen counts distinct values of the minimal image. The table is a convenient structural representation of them. This does not assert that four independent ternary cells are necessary, that fifteen fixed binary codes use fewer than four bits, or that compilation has constant cost. The two merged states remain different under a component reading within the same whole. Indistinguishability for this interface does not make them globally identical.

## Detail: §6zi. Reachability and an expanded question family

### VC70

**Claim VC70 (the prepared closure has fourteen configurations and thirteen common-behavior classes).** The E/S closure of P contains every element of X except (0,0,0,0) and (1,1,1,1). Restricting Φ to that closure gives thirteen classes. Adding direct first-alpha readings to the continuation interface gives sixteen classes on X and fourteen on the prepared closure.

**Proof.** E and S permute coordinates. Every seed contains a zero and a one, excluding both constant configurations. The seed (0,0,0,1) reaches the four placements of a single one. The seed (1,0,1,1) reaches the four placements of a single zero. The seed (0,0,1,1) reaches the two opposite homogeneous blocks. The seed (1,0,0,1) reaches the four configurations with one zero and one one in each block: E flips the first block, and SES flips the second. These disjoint families contain 4+4+2+4=14 configurations, exhausting the nonconstant carrier. They contain VC69's merged pair and twelve singleton classes. A direct first-alpha reading distinguishes that pair. Every other pair was already separated by a common continuation. ∎

The reachable object belongs to the closed current carrier, not just to the four initial seeds. Two alpha facts suffice at the prepared beginning because beta values are fixed there. After an exchange, the same two-coordinate layout need not suffice. An old law about the beginning can still support prediction along the actual path without becoming a law about current beta values.

## Detail: §6zj. Acquire the minimal object from resident evidence

### VC71

**Claim VC71 (sufficient retained evidence determines every common continuation, with an exact component-reading boundary).** A trace of four addressed component readings at one actual source determines W and therefore Φ. Given a certified finite continuation, it determines that continuation's common class without another acquisition. On X, with no prior restrictions and only individual-coordinate channels, four distinct coordinate readings are necessary on every input to determine Φ exactly. If the original preparation P is established, the old two alpha facts suffice.

**Proof of reuse.** Retain each acquired fact in the next same-source trace. Four decoders of that one memory determine a,c,b,d, so their paired result is W. Compose with the table decoder to obtain Φ. Compose that acquired factorization with a transition square and the endpoint common-class projection. Both paths return the same future class. The memory decoder takes only the acquired memory, and its question retains the operation word.

**Proof of the reading bound.** Flip an unread coordinate while keeping all read coordinates fixed. These configurations differ in exactly one coordinate. They cannot be VC69's merged pair, whose members differ in all four. Their Φ images differ. The same observation transcript and adaptive choices cannot distinguish them, so no branch with an unread coordinate may stop. Four readings suffice by construction. On P, beta values are fixed as 0 and 1, and the alpha pair determines W directly. ∎

`AcquiredBoundaryCoordinates` retains four source-bound trace facts and combines their decoders through `JointEvidenceFromMemory`. Each extension exposes its prepared-slot relation. This is a four-reading certificate with preparation obligations, not an automatic apparatus for changing channel settings. `PreparedBoundaryCoordinatesFromAlpha` supplies the narrower initial-family factorization. `AnswerOnRefinement` recovers Φ from either adequate evidence, and `FutureOnEvidence` carries it through the mixed source/table path. Equal coordinate facts from sources with different third fields give the same coordinate decoder. Substituting another actual source into the evidence factorization still fails.

For a positive insufficiency witness, compare (0,0,0,0) and (0,1,0,0). Their alpha memories coincide and their current common class is J₀. E changes their classes to J₀ and B. The missing first-beta distinction is at a named internal address. An accessible old beta fact can supply it by decoding. If it exists only in the source or an inaccessible archive, the required access or acquisition must be supplied. Closure supplies no shortcut from one accessible record to two different answers.

## Detail: §6zk. A new internal connection exposes the last omitted distinction

Keep the common question and add K(a,c,b,d)=(d,c,b,a), exchange of first alpha with second beta. This connection crosses the old block boundary. It is another total coordinate permutation inside the same source.

### VC72

**Claim VC72 (changing the interaction boundary can force a finer object without changing the question).** For all E/S/K continuations, the exact common-behavior image has sixteen values on X and fourteen on the prepared reachable carrier. If Φ is known, only its all-B class needs a further distinction to obtain this finer image. On that class, one first-alpha reading is necessary and sufficient. An accessible original four-coordinate trace supplies it without another acquisition.

**Proof.** K sends (0,0,1,1) to (1,0,1,0), whose current common class is J₁. It sends (1,1,0,0) to (0,1,0,1), whose class is J₀. The only pair merged by Φ must therefore split. All other pairs were already separated under E/S, and the four coordinates suffice under the new permutation. K preserves the nonconstant carrier, giving fourteen values there. The old singleton classes already determine all coordinates. On the all-B pair, identical old images cannot select the two K answers, while first alpha is respectively 0 and 1. That one acquired distinction completes the image. The full trace already contains it. ∎

`CrossBoundaryReading`, `CrossBoundaryImage` and `BoundaryCoordinatesCross` derive the new source/coordinate square while retaining all declared beam fields. It composes with the earlier squares and is an involution on coordinates. Reconstructing these fields does not identify arbitrary nominal source wrappers. `RecordedBoundaryCommand` retains the actual predecessor when recording the whole occurrence. The two new common answers have a positive zero/successor witness. Treating their old shared table as sufficient, or giving K an E tape address, fails. The fifteen-value object remains exact for its original operation family. The newly relevant distinction was inside the whole throughout.

## Detail: §6zl. Acquiring a law through one common observation channel

The mechanism family is now part of the declared scope. Let E exchange the first two working coordinates and K exchange the first and fourth, in coordinate order (a,c,b,d). A probe observes only the first output coordinate, under one question independent of the chosen operation. Its preparation fixes c=0 and d=1, while a, b and the retained hidden fields remain free. The actual application, its input, output and prepared recording apparatus belong to the whole.

### VC73

**Claim VC73 (one prepared response determines the E/K law, conditionally on the family).** In the exact family {E,K}, the first output coordinate is 0 for E and 1 for K. The two clauses 0↦E and 1↦K therefore factor the operation-code question through the common output observation for every admitted prepared source. Acquiring that observation supplies the decoder's input. The decoder does not take the actual application or its operation tag as a hidden parameter.

**Derivation.** E(a,0,b,1)=(0,a,b,1), while K(a,0,b,1)=(1,0,b,a). Their observed coordinates are the two distinct constructor cases. `ExchangeLawFromProbe` and `CrossLawFromProbe` derive the two factorizations from preparation alone. Their declarations do not require equality of the final law answers as an extra premise. `AcquiredExchangeLaw` and `AcquiredCrossLaw` compose those factorizations with recording. `ExchangeLawFromTrace` and `CrossLawFromTrace` obtain the same answers from the actual prepared trace. The recorded fact contains the common output question and coordinate answer, with neither an E/K question label nor an application parameter. Source agreement is supplied by the acquisition relation, not by equality of fact payloads.

**Necessary scope.** On the unprepared all-zero input E and K have the same observed fact. Further, let S exchange the two rows. On prepared input (0,0,0,1), E and S both return first coordinate 0, while on (0,0,1,0) their first coordinates are respectively 0 and 1. Thus the same record does not determine the law in the larger family {E,K,S}. These are positive coinciding and separating witnesses. Compiler failure alone is not their mathematical content. A zero payload can fit the E decoder even when it came from an unprepared K application. The corresponding source-bound factorization then fails.

The result concerns law behavior in a supplied constructor family. It does not infer membership in that family from a successful probe, seal Swift's open conformance space, identify an actual mechanism from its law code, or certify that another application uses the same physical mechanism. Reuse on a new input requires a relation tying the two applications and evidence for the relevant new input. `MechanismLaw<R>`'s generic operation tag has this law interpretation only on the admitted constructors. `Checks/MechanismProbe.swift` checks seven nearby invalid extensions independently.

## Detail: §6zm. A two-probe basis for four-address routing

Fix four input and four output addresses, with both output images observed in their declared address order. An admitted law selects one fixed input address for each output address. A permutation uses each input exactly once. This is a restricted family of these routing laws. The same routing acts on both probes. No gate depending on the probe values, hidden phase or probe number belongs to this family unless separately reduced to such a fixed routing.

Prepare the two binary input vectors p=(0,0,1,1) and q=(0,1,0,1). The input addresses have respective signatures 00, 01, 10 and 11. If an output selects input address j, its two observed bits are precisely j's signature.

### VC74

**Claim VC74 (two complete binary probe images determine routing, and one cannot).** On the declared family, the pair of output vectors determines the selected input at every output, hence the entire routing behavior. Two probes suffice for all twenty-four permutations, and also for all 4⁴ coordinate-selection maps. One binary probe cannot identify all permutations. The bound counts complete four-coordinate images, not individual bit reads or memory writes.

**Derivation.** Zip the two observed vectors at each fixed output address. Each resulting signature is one of the four distinct prepared input signatures, so it identifies exactly one input address. For any binary probe on four inputs, two input addresses have the same bit. Exchanging those addresses is a nonidentity permutation fixing that probe. Identity and that exchange therefore have the same complete output, so one probe cannot distinguish all permutations. For the proposed p, exchanging the first two inputs is a concrete witness, and q separates them at the first output. This proves the lower bound for any choice of a single binary probe, not only p.

`RoutingCoordinates` represents a routing by its four signatures. `FirstRoutingProbe` and `SecondRoutingProbe` project the two bit planes. `RoutingFromProbes` derives reconstruction by `RoutingFromProbeImages`, whose only input is the pair of images. The generic transpose equality is valid for arbitrary structural coordinate contents; restricting each signature to 00, 01, 10 or 11 gives the finite routing interpretation. It does not require enumeration of the twenty-four permutations. `AcquiredRouting` supplies the same decoder from the recorded observation. This records the joint image and does not itself implement two physical interventions or account for their preparation. The existing `JointEvidence` binds the two readings to the same routing source.

The extension from permutations to coordinate-selection maps uses no new reconstruction rule: repeated signatures identify repeated selections. A local selection map need not be reversible. A proposed closed realization must retain any distinctions it claims to preserve in its remaining internal structure. That retention does not follow from the signature decoder. Arbitrary Boolean functions of several inputs are a larger family and are not identified by these probes.

**Same whole does not entail stationary routing.** A resident two-position schedule may supply identity for the first probe and the first-two-address exchange for the second. Both observations then belong to one whole. Their joint recorded fact is exactly the fact produced by the fixed exchange, and reconstructs a valid permutation. Nevertheless that permutation was not the initial routing. `RoutingResidentSchedule` and `RoutingOneWholeCanHideLawChange` exhibit this inside a single paired source. Thus checking that the reconstructed signature tuple is a permutation cannot certify that the law remained fixed. The same-routing premise is a relation to establish about the internal mechanism, not a consequence of global closure or consistent-looking records.

The recovered object is behavior on the declared routing family. Two exchanges and the empty action have the same routing coordinates while retaining different operation words. Equal probe facts also occur for distinct nominal sources. `Checks/RoutingProbe.swift` supplies the generic reconstruction and positive counterexamples. Eight isolated refusals check the missing-image, source, address-order, stationarity and identity boundaries. These certificates do not identify physical histories or recover a new, unobserved data input.

## Detail: §6zn. Reusing acquired routing with an explicitly read new input

A routing signature determines which input address supplies an output. It does not contain the value at that address in a new input. Let I be a fixed routing object from VC74 and X=(x₀,x₁,x₂,x₃) a supplied new data image. X's coordinates may be arbitrary structural values. Only the calibration signatures are binary.

### VC75

**Claim VC75 (acquired routing and a read new input determine the routed output).** In the four-clause coordinate-selection grammar, the application to (I,X) factors through (recorded probe images of I, X). The decoder's input explicitly contains X. For every admitted routing and all supplied X, reconstruction of the signatures followed by their coordinate selections agrees with direct application of that same I to X. The equality is derived without requiring the final output as a premise.

**Derivation.** `Route00`, `Route01`, `Route10` and `Route11` read respectively x₀,x₁,x₂,x₃ from a pair consisting of their address signature and X. `RoutingApplication` assembles the four independently selected outputs. Its admissible clauses form the product of the four address choices, including repeated choices. The generic body does not restrict the data values to calibration bits. `RoutingApplicationFromProbes` applies VC74's reconstruction and then those same four clauses. Its direct reading uses the actual I, while its decoder uses the canonical signatures reconstructed from the observed bit planes.

`EvidenceBesideInput<F,X>` derives product transport for any supplied factorization F: the source becomes (F's source,X), its observation pairs F's observation with a reading of X, and its decoder accepts both observed arguments. `RoutingMemoryBesideInput` specializes this to acquisition of the probe images. Composing it with `RoutingApplicationFromProbes` through `AnswerOnRefinement` gives the claimed decoder on (probe fact,X). The probe fact has no X parameter. Changing X therefore requires access to the new data, while the law fact can be reused. Distinct nominal routing sources with the same coordinates give the same decoder, although substituting one source's acquisition for the other's still requires a source relation.

**What the transport certificate checks.** The four supplied clause types occur on both sides of `RoutingApplicationFromProbes`. Within the declared Route00/01/10/11 grammar, each address fixes its clause and its selected value. The broader generic signature also accepts other `PredicateReading` constructors. `ReuseForged00` uses the 00 address and the same question but returns 1 on an all-zero input. It composes with acquisition and yields a different output from the valid route, despite the same declared source, question and decoder input. `Checks/RoutingReuse.swift` positively checks all these relations. Thus factorization preserves the supplied reading; it does not certify that an arbitrary reading implements coordinate selection. The four-clause premise is necessary mathematical content, not a consequence of successful type transport. The reconstruction theorem for the recorded signatures remains independent of this choice of application clauses.

`RoutingCalibration.swift` checks the application-to-probe bridge within that grammar. Each `SelectionCalibration00/01/10/11` applies its actual selection constructor to the prepared p and q and derives the declared address signature. `CalibratedRoutingBasis` assembles any four such witnesses, including repetitions, and derives agreement of the reconstructed routing with their calibrated addresses. No reconstructed whole answer is requested as a premise. This gives the two bit-plane readings their application meaning inside the declared family.

Calibration still does not establish that family. A constant-zero reading with address 00 agrees with Route00 on both prepared probes, yet differs on a new input whose first value is 1. The checks exhibit this positive boundary and reject both a wrong calibration and its invalid extension to all inputs. Thus the three obligations are visible separately: correct calibration on the probes, membership in the law family on future arguments, and transport of the acquired evidence. Adding a marker that names family membership would not derive any of them.

**Boundary and continuation.** Under identity routing, changing X from (0,0,0,0) to (1,0,0,0) changes the output. Hence the law fact alone cannot supply that output on unknown X. Conversely a constant input makes identity and exchange agree, so equality of one new output does not identify their laws. The source I used for calibration also occurs in the direct application. Replacing it by another actual routing, even one with the same fact payload, is not licensed by this factorization. VC74's changing resident schedule remains a counterexample to inferring that relation from record consistency.

The acquired output can itself supply another question. The checked K application sends X=(0,0,1,1) to (1,0,1,0), which supplies the exact input of the existing `Boundary1010` common-answer table. Composing through `QuestionOnObservation` derives that table from the same law record and read X. The old `Boundary0011` table has the wrong input and is refused. This joins acquired law evidence to the earlier common-behavior construction without inserting a precomputed table answer.

`Checks/RoutingReuse.swift` checks generic exchange and repeated-selection results for arbitrary data, the decoder's explicit input, independence of the law fact from new data, and nine invalid extensions. The result supplies a static factorization and its availability premises. It neither forces a physical acquisition nor proves that an unspecified instrument can read all of X without resources. The declared model keeps the routing source, new input and records internal. A new physical application must realize this same-routing relation, rather than repeat its operation label alone.

## Detail: §6zo. Two resident instruments acquire the probe pair

The joint observation of VC74 can be realized in a finite prepared relation with one source and two resident instruments. Each instrument carries its channel, quiet phase and blank trace slot. The source occurs once. The instrument whose address is currently beside that source is the focused one.

### VC76

**Claim VC76 (two prepared resident records suffice for acquired routing and reuse).** Starting from this prepared whole, recording the first probe, exchanging the instrument addresses and recording the second produces two source-bound facts. Those facts decode the joint probe images and hence the routing. With the explicitly read input from VC75, the same two facts also decode its routed output. The initial preparation can be recovered from the final whole on the constructed range.

**Derivation.** `TwoResidentReadings<A,B>` requires A and B to read the same actual source. Its first step is `PreparedTraceExtension` beside the untouched second instrument. `ExchangeResidentInstruments` exchanges their addresses while retaining the source and both complete instrument states. Its second step records B beside the retained first record. `FollowedPair` checks both exact intermediate objects. `ResidentProbeFacts` selects the two final records in original question order, and `TwoResidentAnswers` derives their joint decoded answer. `AnswerOnRefinement` supplies routing reconstruction. `EvidenceBesideInput` then supplies the new-input reuse. The final decoder receives two facts, with no source parameter. `AnswerInResidentProbePair` checks the retained source, signalled instrument states, channels and record addresses before naming that decoder at the whole.

The two phase coordinates pass through (quiet,quiet), (signal,quiet), (quiet,signal), (signal,signal). This orders the declared forward steps without an external clock value. The focus step adds no observation. Reusing an occupied first slot, skipping the focus step or reading the second record before acquisition violates a different seam. The inverse of the focus exchange and the prepared predecessor constructions recover both initial instrument states from the final whole. Thus the forward ordering does not prohibit reversal, and returning both instruments to their initial states also removes their acquired evidence. Continued accessible learning requires retention somewhere inside the whole.

The finite realization supplies prepared recording instruments and their internal rearrangement. Its probe readings still assume the coordinate-routing family and calibrated channels of VC74. It does not derive a sensor or its calibration from global closure. `Checks/ResidentProbePair.swift` checks record preservation, source retention, prepared recovery and acquired reuse, together with seven invalid transitions or decoder placements.

## Detail: §6zp. A changing mechanism can carry the same acquired law

VC75's shared routing does not require every internal state of a mechanism to remain fixed. Write the whole as ((I,H),J): a module containing routing I and internal state H, beside resident reserve J. The internal exchange ((I,H),J)↦((I,J),H) changes the module and retains its previous state in the reserve.

### VC77

**Claim VC77 (acquired law evidence transports across a certified mechanism change).** The routing observation commutes with this internal state exchange through an identity update of its image. Old source-bound probe evidence therefore answers the law question after the exchange, and after every correctly composed finite repetition. When a new data image is explicitly supplied beside the whole, that same evidence also supplies the routed output after the change. No equality H=J is required.

**Derivation.** `FactorOnSource` pulls an existing factorization back through a specified reading of the larger source, preserving its decoder. `ResidentRoutingFactors` applies it to the routing inside the module. `RoutingModuleExchange` derives a commuting square: the actual source step exchanges H and J while both endpoint observations read I. The compiler verifies the generic square without a final-answer equality premise. `FutureOnEvidence` transports an acquired instance of the initial observation through that square. `JoinedTransition` composes repetitions at their exact endpoints. `TransitionBesideInput` carries the square beside a supplied X, and the endpoint `RoutingApplication` selects its values by the transported law.

The source and module can therefore change while the acquired law remains usable. The derivation names the actual transition and retains its operation word in the future question. It does not replace a post-change source reading by a pre-change reading with a coincident answer. The final decoder omits H and J, while the transport certificate remains tied to their actual source chain. The positive instance H=0,J=1 changes a module field, so this is more than a nominal wrapper change.

**A different internal move reopens the law question.** `ExchangeRoutingWithReserve` sends ((I,H),J) to ((J,H),I). It retains both structures but replaces the module's routing. Take the same I and two reserves, identity and K. The old probe facts about I coincide in those worlds, yet the new first routing-signature bits are positively distinct. Thus those facts do not determine the future law under this larger action family. Knowledge of the reserve, whether from an accessible old record or another acquisition, can supply the missing distinction. Equality of operation labels or whole closure cannot replace that evidence.

`Checks/RoutingTransport.swift` checks old-evidence reuse, changing module fields, retained reserve state, two-step composition, new-input application and the routing-replacement counterexample. Eight isolated invalid extensions check wrong actual sources, endpoints, path seams, omitted input, erased operation words and an unjustified invariant. The criterion for reuse is a certified image update on the admitted internal transition, which can allow an actual mechanism state to change.

## Detail: §6zq. The acquired law determines which new input coordinates matter

VC75 supplies a complete new data image. That is sufficient but can exceed what a particular routing needs. Fix a known coordinate-selection law r on four output addresses. Let S be the set of input addresses selected by those outputs. For the reading bound below, each available input channel reports one coordinate. The unknown input ranges over the full product of its coordinate domains, each with at least two values, and no prior input evidence restricts that product.

### VC78

**Claim VC78 (the exact coordinate-reading demand is the selected-address set).** To determine the complete routed output on this domain, reading every address in S is sufficient and necessary. Thus a permutation requires four coordinate readings, while the route selecting the first address at all four outputs requires one. The count concerns this input-channel family. It does not count VC74's complete probe images as individual coordinate reads, nor assign four calls to an instrument that already exposes all of X at once.

**Derivation.** Each output copies the value at one selected input address. Reading the distinct selected addresses therefore supplies all outputs, reusing a read value wherever its address repeats. If a selected address remains unread, change only that coordinate to another permitted value. Every acquired coordinate answer is unchanged while an output selecting the changed address differs. The same argument applies to a proposed adaptive reading sequence: those identical earlier answers select the same sequence, so it cannot stop correctly with a selected address unread. This proves necessity throughout the declared product domain. Existing evidence relating the input coordinates can reduce the requirement and is outside this premise.

`RepeatedFirstFromObservation` implements the one-coordinate case as a generic source-bound factorization. Its direct question is the existing `RoutingApplication` on the complete source pair (routing,X). Its observation pairs the acquired law fact with `FirstDataCoordinate<X>`. `RepeatFromFirstRecord` receives exactly that pair, and produces the four repeated values. No X or unused data coordinate occurs in this decoder's type arguments. The proof remains valid for arbitrary values in the unread coordinates. It even permits an opaque unused branch of X, because the selected address does not require that branch's pair structure. This larger structural domain does not erase the actual source or infer the contents of that branch.

The identity route supplies a positive boundary. Two new inputs with the same first value and different second values have the same restricted observation, including the same correct identity-law fact. Their identity outputs differ. Hence the repeated-first reduction cannot be reused for identity. A changed law can alter which input address must be read even when the number of required readings remains one.

Under a separate preparation of four independent fair input bits and a fixed repeated-first law, the output has one bit of entropy while the complete input has four. The other three bits remain in the retained source and are irrelevant to this output. Reading the first value resolves the output without resolving the whole. Neither this probability assignment nor these numerical entropies are needed for the coordinate-demand proof.

`Checks/RoutingDemand.swift` checks generic output reconstruction, absence of the three unused values from the decoder, acceptance of opaque unused structure, and positive necessity counterexamples. Seven refusals check wrong laws, missing data, wrong argument layout and attempts to recover or read omitted information. The general selected-set count follows from the finite-coordinate argument above. The static implementation exhibits the strict one-coordinate reduction and the failed extension to identity, without a runtime support-set calculator.

## Detail: §6zr. The observed law includes the internal output frame

VC74 fixes the input signatures and the order of the recorded output addresses. A module's output ports can be connected to those record addresses through an additional internal component. Call this connection its output frame. The module and frame belong to one whole, and both cases below use the same record format and probe questions.

### VC79

**Claim VC79 (probe facts identify the composite routing without necessarily identifying its components).** Compare a routing I followed by a frame that exchanges the first two outputs, with routing E(I) followed by a direct frame. The two complete probe images coincide for every admitted I. In particular, identity with the crossed frame and E with the direct frame have distinct module routings but the same records. They also produce the same framed response on every supplied data input. Probe facts alone therefore cannot identify the bare module routing across this enlarged family.

**Derivation.** `ProbeThroughCrossedFrame` applies the first-two-coordinate exchange to each bit-plane output. `ProbeThroughDirectFrame` reports the bit planes unchanged. `RoutingFrameAgreement` derives their equality when the same exchange instead acts on I's output-address ordering. Its generic body does not assume equality of the observed images or of the actual sources. In the identity/E case, both data-response paths produce (x₁,x₀,x₂,x₃) for arbitrary data values. The module routings themselves differ at a positively distinguished signature bit.

Applying `RoutingFromProbeImages` to the common acquired fact correctly recovers the composite routing at the instrument's recorded addresses. If the crossed frame is independently established, its known inverse exchange recovers the module's routing coordinates. `FrameKnownCorrection` derives that correction generically. Applying the correction under the wrong frame fails. The calibration premise concerns an internal connection and does not require a reader outside the whole.

This locates the address premise in VC74: its recovered object is a relation between the specified input and observed output addresses. Calling it the law of one component requires a bridge from those observations to that component's ports. Stable-looking records, even records predicting all data applications through a fixed composite, do not determine its decomposition. An internal reading or intervention that distinguishes the frame can provide additional evidence. `Checks/RoutingFrame.swift` supplies the generic frame agreement, arbitrary-data witness, known-frame correction and four invalid extensions.

## Cross-page mentions

Labels mentioned here: <doc:verdict_is_invariant__reusable_images#VC61>, <doc:verdict_is_invariant__reusable_images#VC64>.

Mentions of this page’s labels: <doc:interference_is_substitution__models_calibration> (VC74), <doc:permanence_is_resistance__forced_answers> (VC66), <doc:permanence_is_resistance__forced_answers> (VC67), <doc:permanence_is_resistance__records_entropy> (VC68), <doc:permanence_is_resistance__records_entropy> (VC69), <doc:permanence_is_resistance__records_entropy> (VC70), <doc:permanence_is_resistance__records_entropy> (VC71), <doc:permanence_is_resistance__records_entropy> (VC72), <doc:permanence_is_resistance__records_entropy> (VC74), <doc:permanence_is_resistance__records_entropy> (VC75), <doc:permanence_is_resistance__records_entropy> (VC76), <doc:permanence_is_resistance__records_entropy> (VC77), <doc:verdict_is_invariant__relative_questions> (VC78), <doc:verdict_is_invariant__relative_questions> (VC79).
