# Verdict Is Invariant (Correspondence) — Reusable images

This part contains the original derivations for reusable images.

Family and original section headings: <doc:verdict_is_invariant>.

Section setting: <doc:verdict_is_invariant#6o-A-finite-relation-basis-for-unbounded-continuations>.

## Detail: §6o. A finite relation basis for unbounded continuations

### VC44

**VC44 (Complete image equality is exactly the two-swap behavioral relation).** Use the symbolic BeamShape interpretation of §6m. The question reads alpha. The allowed operations are SwapVisible, which exchanges alpha and beta, and SwapBetaHidden, which exchanges beta and the third coordinate. For any two sources A and B, equality of `FullSpectrumImage<A>` and `FullSpectrumImage<B>` is equivalent to agreement of the alpha question after every finite word over these operations, including the empty word. Nominal source equality is not a premise.

*Derivation.* Write the image as (a,(b,c)). The two image operations give (b,(a,c)) and (a,(c,b)). Equal input images therefore give equal output images under either operation. Induction on finite words preserves this one relation under every mixed continuation, and projecting alpha gives the required answer. Conversely, agreement after the empty word identifies a. Agreement after SwapVisible identifies b. Agreement after SwapBetaHidden followed by SwapVisible identifies c. The three coordinate equalities identify the image. These two directions establish the VC15 relation for this vocabulary.

`SpectrumFirstAgreement<A,B>` and `SpectrumSecondAgreement<A,B>` name `JoinedVerdict` certificates on the respective successor readings. Their only additional premise is equality of the complete input images. The compiler derives their output agreement from the projection definitions. They introduce no new certificate wrapper or protocol. The generic bodies establish the two generator steps, and the argument above supplies induction over the finite constructor grammar. No bound or enumeration of source types or word lengths is used.

For every B, `SwapVisible<SwapVisible<B>>` has B's complete image. Both continuation certificates apply to this pair, although the two source type expressions differ. A refusal of their nominal equality does not supply a distinguishing alpha experiment. It checks a stronger, different relation. In particular, the nested Swift spelling is not by itself evidence of a physical historical trace.

There are two distinct composition questions. `JoinedTransition` connects the actual source-reading endpoints of one encoded path. Equality of images does not satisfy its exact intermediate-reading premise, even for sources equivalent under VC44. The image operations, however, compose directly on the common image: their outputs do not depend on which source representative supplied it. Thus a path of observable images requires no chosen source representative. It does not reconstruct a particular source history.

`ImagePathMayChangeRepresentative<A,B>` checks this directly. Its premise equates B's image with the image after swapping A. `SequentialReading` then composes the first image swap with the second image swap using B's image. Its result equals the image of the corresponding two-step continuation of A. The generic witness requires no identity between B and the intermediate source. The concrete triple-swap representative is accepted here and refused as a substitute endpoint of `JoinedTransition`.

The smaller visible image fails a different test. RedBeam and RedBeamWithIR agree in alpha and beta, but SwapBetaHidden followed by SwapVisible exposes their distinct third coordinates (VC39). This is an actual distinguishing continuation in the declared vocabulary, whereas the double-swap pair has none. Extending the questions beyond alpha and its two-swap continuations requires checking the resulting relation again.

This is a concrete bridge to The Cut: what a local reading can identify is determined by the relations it must preserve inside the whole. Saturation here is closure of those relations under the allowed continuations. It does not require naming every source or adding a record for every future word. Acquiring an unknown source's image remains the separate obligation of VC40.

### VC45

**VC45 (A future question factors through the present image).** Let P be a `CommutingTransition`, possibly a composed path. Let F factor a question through its final observation: F.Observation == P.Right. The future question first follows P.SourceStep and then reads F.Left. Its answer factors through P.Left, the present observation. The decoder first follows P.ImageStep and then reads F.Right.

*Derivation.* The source step ends at P.Right.Left, which is F.Left.Left. The image step ends at P.Right.Answer, which is F.Right.Left. The final answers agree by F. Both composed readings therefore have the question `OperationSequence<P.Operation,F.Predicate>`, matching contexts and matching answers. Their initial inputs are P.Left.Left and P.Left.Answer, so P.Left connects them as required by ReadingFactors. These are projections of the premises, with no new final-answer equality assumed.

`QuestionAlongTransition<P,F>` supplies this factorization using the existing `SequentialReading` constructor on each side. The operation is retained in the question: a future alpha answer is not silently relabeled as present alpha. If G factors P.Left through an acquired fact, VC41 then gives `AnswerOnRefinement<QuestionAlongTransition<P,F>,G>`. Its decoder accepts that fact and answers the same future question.

The generic instance in `Checks/Continuation.swift` acquires `FullSpectrumReading<B>` for a structural BeamShape source B. The path exchanges beta with the third coordinate, then alpha with beta. A final `SpectrumAlphaFactors` supplies F. The composed decoder's input is exactly `FactOf<FullSpectrumReading<B>>`, and its answer is B.PaschenLevel. A fact containing only the initial alpha answer cannot replace that input. The metameric pair of VC39 supplies the distinguishing counterexample.

This derives an answer relation, without advancing the physical source, appending a second observation, or asserting that its path actually occurred. For a specified possible path it answers a conditional future question. Predicting the actual next event additionally requires the appropriate connection between that path and the whole's resident dynamics or controller. The original acquisition relation remains an explicit premise. The physical work of establishing or reading the derivation also belongs inside the whole. The type relation does not give that work a zero cost or identify it with the modeled source transition.

## Detail: §6p. Availability is part of the relation

The total operations of VC15 and VC44 have no unavailable inputs. A partial interaction needs another condition. Its successful output equations alone do not specify where it may occur. In the following claims K is a declared carrier, E:K→I is a total reading with I=E(K), and T:D→K is a partial deterministic operation. These are premises of this fragment, not a claim that all interactions of reality share one classical state assignment.

### VC46

**VC46 (Exact descent preserves the operation's domain).** There is a partial image operation V with domain E(D) that satisfies both

    x∈D exactly when E(x)∈dom(V),
    E(T(x)) = V(E(x)) for x∈D,

if and only if

    D = E⁻¹(E(D)),
    x,y∈D and E(x)=E(y) imply E(T(x))=E(T(y)).

The first condition says that each image fiber is entirely available or entirely unavailable. The second says that available representatives give one successor image.

*Proof.* An exact image domain gives D=E⁻¹(E(D)). A single-valued V requires equal images in D to have equal successor images. Conversely, define V on E(D) by V(E(x))=E(T(x)). The second condition makes this independent of the representative. The first supplies exact domain reflection. The image map is unique on E(D). QED

The existing CommutingTransition equations express an output square for presented applications. They do not by themselves quantify over disabled sources or impose domain reflection. For a symbolic triple (a,b,c), let T exchange a and b only when a=c. Let E read (a,b). Every successful step has the image update (a,b)→(b,a). Yet (1,0,1) is available and (1,0,0) is not, despite their equal images. No partial operation on this E-image can have the exact source domain. Matching the output on all successful inputs does not repair the missing distinction.

The complete image (a,(b,c)) carries the domain through its own relation a=c. `MatchedSwapSource` requires equality of the resident source fields. `MatchedSwapImage` requires equality of the corresponding image fields. `MatchedSwapTransition` constructs the output square from the source condition. `AvailableStepTransfers<A,B>` derives availability and successor agreement at B from availability at A and equality of complete images. Interchanging A and B supplies the reverse implication. The condition is an equality, with no independent Boolean permission coordinate.

At the successor, the condition is b=c. The source (1,0,1) therefore permits one step and then blocks another. `TwiceMatchedSwap` requires both a=c and b=c, and composes the existing transitions. A successful earlier step is not a witness of availability at its changed successor. `AlphaAfterMatchedSwap` uses VC45 to name the guarded future question. Its operation label differs from the total swap, even when a total extension gives the same answer value.

### VC47

**VC47 (Partial behavior preserves both availability and answers).** Fix a family Q of total observations on K and a vocabulary O of partial deterministic operations. For each finite word w, let D_w be the sources where every successive operation is defined. The empty word has domain K. Define x≈y when, for every w,

    x∈D_w exactly when y∈D_w,
    if x,y∈D_w, then q(w(x))=q(w(y)) for every q∈Q.

This is the greatest equivalence relation that preserves Q, preserves availability of each operation, and relates successors whenever the operation is available.

*Proof.* Equality of word domains and of the defined observations is reflexive and symmetric. It is transitive because a common middle source transfers membership in every D_w, after which answer equality is transitive. The empty word preserves Q. Prefixing an available T to any continuation preserves both its domain membership and its answer, so x≈y implies T(x)≈T(y) whenever T is available. Conversely, a relation with these three properties preserves domains and related successors along each word by induction. Observation preservation then gives every required equality. It is therefore contained in ≈. QED

The quotient carries partial operations [x]→[T(x)] with representative- independent domains and results. This extends VC15 within the declared partial deterministic fragment. No answer is assigned to an unavailable word. An implemented attempt that returns an error would be an additional specified interaction with its own record, rather than a conclusion of this partial relation.

**Ignoring unavailable words can destroy transitivity.** In the guarded-swap model, take x=(1,1,1), y=(1,0,0), z=(1,0,1), and q=alpha. The only word available at y is the empty word, and all three initial answers are 1. A comparison confined to words available at both endpoints therefore pairs x with y and y with z. But the single swap is available at x and z and gives answers 1 and 0. Those endpoints disagree. This weaker comparison is not an equivalence relation and cannot define a quotient by identification. Unavailable is not a wildcard answer that agrees with everything.

The generic witnesses and nearby refusals are in `Checks/Interactions.swift`. They check the source and image conditions, transport through equal complete images, the changed successor condition, and reuse of an acquired full-image fact through VC41. The concrete counterexample above supplies the reason for the failed transitivity claim. These checks concern the stated constructor interpretation. An unrelated conformance or a compiler failure does not establish global physical unavailability.

The complete triple is sufficient for this construction. It is not claimed minimal for the guarded vocabulary: at an unavailable source with no other operations, only the initial alpha question can be asked, so additional coordinates may be irrelevant. Which distinctions can be omitted depends on both future answers and the actions that remain possible.

## Detail: §6q. The smallest image for a partial interaction

The guarded swap has a smaller sufficient image than the complete triple. Fix the carrier K={0,1}³, the present question q(a,b,c)=a, and the sole action T(a,b,c)=(b,a,c), available exactly when a=c. The binary carrier is an explicit local restriction. No binary valuation of every relation in the whole is assumed.

### VC48

**Claim VC48 (a structural obstruction to the guard).** In the declared numeral grammar, zero and a successor have distinct outer constructors. An ordered pair of these constructors, with its endpoints equal to the source's a and c, therefore witnesses that the equality guard cannot hold there. Reversing the pair gives the other orientation.

**Proof.** Zero is `Never`; a successor is `Examples.Succ<N>`. These are distinct nominal type constructors for every admissible N. Equality of their internal fields would not identify the constructors: in particular, the two fields of `Succ<Never>` are both `Never`, while the successor itself is still distinct from `Never`. Substituting the source coordinates into the ordered pair gives the claimed obstruction at that source. ∎

`ZeroSuccessorDistinction<N>` carries this pair. The two blocked-class readings bind its endpoints to their actual source fields by `where`; the reverse orientation uses the existing `InternalSwap`. This is a positive constructor witness in a specified grammar. An absent conformance alone supplies no such witness, and these constructors do not decide inequality between arbitrary `IntegerValued` conformers. For the binary carrier, N is `Never`, so the two orientations cover every unequal guard.

### VC49

**Claim VC49 (six classes are necessary and sufficient).** The behavioral equivalence of VC47 on this carrier has exactly six classes. Write D(a) for an unavailable image retaining the present answer, and R(a,b) for an available image retaining both the present and the next answer. Define E(a,b,c)=D(a) when a≠c and E(a,b,c)=R(a,b) when a=c.

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

**Proof of sufficiency.** Every source has exactly one of the displayed images. The present answer is the first coordinate in either form. The guard holds exactly at the R images. At R(a,a), swapping leaves the image unchanged and the action remains available. At R(a,b) with a≠b, the successor has first coordinate b and third coordinate a; its guard fails, so its image is D(b). These equations give an exact partial image action and preserve the present question. Induction on the length of a finite word now preserves both availability and every defined answer: the first action has the same domain on source and image, and the same conditions hold at its successor. Thus E preserves all continuations in VC47. ∎

**Proof of necessity.** Images with different first coordinates are distinguished by the present answer. For the same first coordinate, D(a) and either R(a,b) are distinguished by availability of T. The remaining pair R(a,0), R(a,1) is distinguished by the answer after T, which is 0 at the first and 1 at the second. These cases exhaust pairs of distinct images. Consequently every representation preserving these questions and domains must distinguish all six classes. Together with sufficiency this proves exact minimality, without counting the output of a program. ∎

The type forms are `BlockedAlpha<A>` and `ReadyAlpha<A,B>`. Their difference carries availability; a blocked image cannot be replaced with an ordinary alpha fact, since that fact alone can also be acquired at an enabled source. Both forms reuse `ReadRecordedAnswer` for the current question. Three image-step constructors express the equal, zero-to-successor, and successor-to-zero cases. Generic `CommutingTransition` witnesses derive their output squares from source-coordinate premises. The source carrier and completeness argument are the ones just declared; an open Swift protocol does not seal all possible conformers to the binary carrier.

This gives a relative minimum, not destruction of the remaining physical distinctions. The two sources represented by D(0) remain different sources; their omitted coordinate cannot affect the declared question or any available continuation. A question about that coordinate, another action, or an interaction that inspects the stored past would change the family and could split this class. The cut specifies which distinctions the interaction requires. It does not identify its image with the whole.

## Detail: §6r. A class recovered from acquired evidence

The six-class image of VC49 can be obtained from the complete image without inspecting the source again. This is a relation between readings. An algorithm selecting a class at runtime is not required to state it.

### VC50

**Claim VC50 (evidence can supply a derived class and its questions).** Let O:K→I be an observation, d:I→C a class decoder, and E=d∘O. Suppose A:K→M describes an acquired record with a decoder u:M→I such that u∘A=O. Then E=(d∘u)∘A. If an independently specified question q:K→V factors as q=r∘E, it also factors as q=(r∘d∘u)∘A.

**Proof.** Substitute u∘A for O in E=d∘O, then substitute the resulting expression for E in q=r∘E. The composed decoders take M as their input. Neither substitution requires another application of O. The equation q=r∘E remains a premise about the independently specified question. Defining E by composition would not prove it. ∎

In the binary fragment, O(a,b,c)=(a,(b,c)). The three class-decoder clauses are

- d(a,(b,a))=R(a,b).
- d(0,(b,1))=D(0).
- d(1,(b,0))=D(1).

They cover the carrier with disjoint domains. Their equalities or positive constructor obstructions are read at image coordinates. `ReadySpectrumClass`, `ZeroBlockedSpectrumClass`, and `SuccessorBlockedSpectrumClass` express these clauses. The source classifications now name `DecodeRefinedEvidence` compositions through `FullSpectrumReading`. They contain no second classification definition.

`QuestionOnObservation<O,Q>` supplies the factorization of the source question defined by that composition. `ReadyAlphaFactors` and the two blocked alpha factorizations separately derive agreement with `SpectrumAlphaSource`, whose definition is still the source's first coordinate. `AnswerFromAcquiredObservation` is an alias of VC41's `AnswerOnRefinement` with `AcquireAnswer`. Its decoder consumes an `AnswerFact` for the complete image. The fact has no source type parameter. The acquisition certificate still binds that fact to the reading that produced it.

These two statements must coexist: equal complete images can have exactly the same fact-decoder type, while a certificate for acquiring an image at one nominal source is not a certificate for having acquired it at another. Shared content does not move the acquisition event. VC50 derives sufficiency from a supplied acquisition relation. It does not infer that an internal participant has physically performed the acquisition.

## Detail: §6s. Composing changes of representation

### VC51

**Claim VC51 (exact partial descent composes).** Let T:D→K descend exactly through E:K→I onto V:E(D)→I in the sense of VC46, with I=E(K). Let V descend exactly through H:I→J onto W:H(E(D))→J, with J=H(I). Then T descends exactly through H∘E onto W.

**Proof.** Domain reflection for H says H(E(x)) belongs to dom W exactly when E(x) belongs to dom V. Domain reflection for E says E(x) belongs to dom V exactly when x belongs to D. Thus H∘E reflects D. At x∈D, W(H(E(x)))=H(V(E(x)))=H(E(T(x))). This is the output equation required by VC46. ∎

The two conditions have different roles. Domain reflection concerns all members of each observation fiber. A commuting square concerns the supplied successful applications. `ReobservedTransition<P,Q>` derives the composed square when P's image action is Q's actual source action. It does not turn successful-square evidence into a universal assertion about unavailable actions.

For the guarded binary fragment, those domain assertions have already been established: the full image carries a=c, and the class is R exactly at that equality, with the two D clauses carrying the complementary constructor obstructions. The three spectrum-to-class squares derive the class update from the full-image update. Each source-to-class square is now an alias of `ReobservedTransition` applied to the existing source-to-spectrum square and the corresponding spectrum-to-class square. No source update is reimplemented at the class layer.

The seam is the entire middle action reading, including its input, output, context, and operation. The unguarded swap and the guarded swap have the same coordinate formula at an enabled source, but they are different actions. Matching their output values cannot replace the required seam.

## Detail: §6t. One evidence relation for a family of continuations

### VC52

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

### VC53

**Claim VC53 (representation composition commutes with path composition at the boundary).** Suppose P₀,P₁ are two compatible source-to-image squares and Q₀,Q₁ are compatible image-to-class squares, with Qᵢ's source action equal to Pᵢ's image action. First composing each row and then changing representation has the same initial observation, final observation, source action, and class action as first changing representation in each column and then composing the resulting squares.

**Proof.** Write the source actions as T₀,T₁, the intermediate actions as V₀,V₁, and the class actions as W₀,W₁. Let Eᵢ be the source-to-image observations and Hᵢ the image-to-class observations at the three endpoints. In both constructions the initial observation is H₀∘E₀, the final observation is H₂∘E₂, the source action is T₁∘T₀, and the class action is W₁∘W₀. The matching middle readings justify each composition. If the square families reflect domains exactly, VC51 and the prefix argument of VC52 preserve the same available paths in both constructions. ∎

The generic Swift witness compares these four boundary types for `ReobservedTransition<JoinedTransition<P₀,P₁>,JoinedTransition<Q₀,Q₁>>` and `JoinedTransition<ReobservedTransition<P₀,Q₀>,ReobservedTransition<P₁,Q₁>>`. All four coincide by reduction. The enclosing proof types are different nominal constructions. Equality of their boundary does not identify those constructions or assert equal physical cost. The result permits either decomposition without separately proving every combined path.

## Detail: §6u. A new interaction can require a finer object

### VC54

**Claim VC54 (enlarging the interaction family refines identification).** On a fixed source carrier, if the allowed action family and target-question family are enlarged, the behavioral equivalence of VC47 can only become finer. For the binary fragment of VC49, adding the total swap S(a,b,c)=(b,a,c) to the guarded action T refines the six classes into exactly eight.

**Proof of refinement.** Every old question, word, and domain comparison is among the new requirements. Agreement under the enlarged family therefore implies agreement under the old one. Equivalently, each new behavioral class lies within an old class, and sending a new class to its containing old class is well-defined. ∎

**Proof of eight classes.** The present alpha question determines a. The alpha answer after the always-available S determines b. Availability of the guarded T determines whether c=a. Since the carrier is binary, this determines c as well. Thus any equivalent pair has the same complete triple, and no two of the eight triples can be identified. Conversely the complete image preserves alpha, the total swap, and the exact domain and update of the guarded swap. It therefore suffices for every mixed continuation by VC52. ∎

For a concrete separating pair, (0,0,1) and (0,1,1) both had the image D(0). After S their alpha answers are respectively 0 and 1. A decoder from D(0) alone would have to supply both different answers at one input, so no function on the old class can answer this new question over both sources. This is a direct obstruction to factorization, not an inference from a missing Swift conformance. The positive distinction is again the zero/successor pair of VC48.

The previously acquired complete image can answer the new question through the existing `SpectrumFirstTransition`, `SpectrumAlphaFactors`, and `AnswerFromAcquiredObservation`. Its fact need not be enlarged or the source observed again for this derivation. If only the six-class image remains accessible to the participant, it does not determine the new answer. That participant needs additional distinguishing evidence or a narrower justified source domain. The omitted distinction still belongs to the different sources inside the whole. The claim concerns what is recoverable from this participant's retained representation.

The minimum is therefore relative to the declared interactions. A representation can be sufficient for its old family and insufficient for a larger one without having been an erroneous representation of the old family. This is a concrete route from saturation to a new unresolved distinction, with both boundaries stated as relations.

## Detail: §6v. An internal participant acquires the missing distinction

VC54 leaves a precise acquisition problem. A participant retaining D(0) cannot distinguish 001 from 011, although the added swap makes their difference relevant. The two sources already differ inside the whole. The participant needs an allowed coupling to that difference.

Fix a channel reading q(x) of the actual source x. Its context, encoding and question form an instrument address p. This address is the same across source values and contains neither x nor q(x). Let m be the participant's old source-bound memory. Write a prepared whole as W₀=(x,p,quiet,(m,blank)). The declared acquisition relation gives W₁=(x,p,signal,(m,f_q(x))), where f_q(x) is a fact recording the channel's context, question and actual answer. The source, address, old memory, phase and new slot all belong to the represented whole.

### VC55

**Claim VC55 (prepared acquisition is source-bound and recoverable).** For a fixed declared channel law, the relation W₀↦W₁ records q(x), preserves m and x, and has a left inverse on its constructed range. The new fact's decoder can answer q from the output memory alone. This does not make the relation a reset of arbitrary occupied memory.

**Proof.** The inserted fact's answer is q(x) by construction. Projecting the output recovers x, p and m. Replacing the signal phase and the new fact slot with the prepared quiet phase and blank slot reconstructs exactly W₀. This recovery uses output coordinates and the specified preparation, without a separately retained copy of the entire input. Applying that recovery to equal outputs gives equal prepared inputs. Reading the fact returns q(x) at its actual memory address. An arbitrary previous slot value could not be recovered by replacing it with blank, so the argument is restricted to the prepared domain. ∎

`PreparedTraceExtension<T,R>` realizes the relation using `AppendObservation<T,R>`. The requirement `T.Left == R.Left` ties the new reading to the source of the old trace. Its whole contains `ChannelOf<R>`, which carries only context, encoding and question. The channel law is supplied by the reading family, not by the address label alone. `PreparedPredecessor` recovers the prepared input from the output fields. The inverse relation itself is an alias of `InternalSwap<PreparedTraceExtension<T,R>>`, with the relation's endpoints exchanged.

`AnswerInReadyWhole` names the existing factorization decoder where its source, context, phase and memory match the declared whole. Its input is the memory, not the complete source. A signal marker alone does not authenticate an arbitrary record or establish a factorization. Quiet marks an unused new slot. It does not prevent reading old facts already present in the prefix. In particular, a blank slot and a recorded zero answer are different structures, even though `Never` also represents the zero numeral.

For the new channel, `SpectrumBetaSource` reads the resident b coordinate. This is an explicitly supplied source projection. It is not a physical implementation theorem for an arbitrary measurement. Its output can subsequently answer the predicted alpha question after the total swap, because that future answer is b. Acquiring b does not itself swap the source. The two operations have different actual source endpoints.

## Detail: §6w. Acquire only the distinction the retained image lacks

### VC56

**Claim VC56 (the least sufficient refinement retains exactly the new question distinctions).** For an old reading E:K→C and a new question q:K→V, define F(x)=(E(x),q(x)). F determines both readings. If another reading G determines both E and q, then F factors through G. Thus the partition induced by F is the coarsest refinement of E that determines q.

**Proof.** Projections of F give E and q. If E=e∘G and q=d∘G, the decoder z↦(e(z),d(z)) gives F from G. Equivalently, two sources have the same F-image exactly when they have the same E-image and the same q-answer. Any sufficient G must distinguish every pair for which one of those equalities fails. ∎

On the binary carrier of VC49, take q(a,b,c)=b. At R(a,b), E already gives a and b, while the guard gives c=a. No new reading is needed to recover the complete triple. At D(0), c=1 and b is missing. At D(1), c=0 and b is missing. One beta reading therefore completes each blocked class. It separates both members of its two-element fiber. Any exact refinement needs at least two outcomes within each such fiber, while no additional outcome distinction is needed in a singleton ready fiber. This is a lower bound on distinguishable outcomes, not the physical byte count of a tagged record.

The adaptive rule depends only on the old accessible class: keep the ready memory, or use the prepared beta channel for a blocked memory. It does not inspect the hidden b to select its action. The two blocked branches acquire the same question with the same instrument address. For the declared vocabulary containing only this extra source-reading channel, zero added reads suffice at ready classes and one is necessary and sufficient at blocked classes. A different allowed instrument family would require its own cost comparison.

`ReadyClassRecoversSpectrum` derives the full image from the old ready class. `ReadySpectrumFromOldTrace` transports that answer to its previously acquired fact. `ZeroBlockedPreparedSpectrum` and `OneBlockedPreparedSpectrum` recover the complete image from the old class fact and the new beta fact at their retained addresses. The binary hidden-coordinate premise is explicit: D(0) by itself would not determine which arbitrary positive successor had been hidden in c. The generic constructors do not silently extend that inference beyond the stated source family.

The resulting memory supplies `FullSpectrumReading` by a checked factorization. VC52 therefore gives every certified mixed continuation from it. `RetainTraceAnswer` also preserves the old class answer through the new memory prefix. The previously established knowledge need not be replaced by the new answer.

### VC57

**Claim VC57 (a local update alone cannot separate an unresolved pair).** Suppose the participant's initial accessible state is M(x). Let its next accessible state be f(M(x)), where f is a fixed deterministic local rule with its program included in that state or held fixed across the compared sources. If M(x)=M(y), the updated accessible states are equal. No decoder from those updated states can give different answers to a question that distinguishes x and y.

**Proof.** Substitute the equal inputs into f, then into the proposed decoder. Both outputs are equal. This conflicts with distinct required answers. The same argument iterates through any finite sequence of local rules whose choices depend only on the accessible state. A rule that also receives a source-dependent channel answer has a different input and is outside this premise. ∎

For 001 and 011, the entire prepared instrument state is equal: channel address, phase, old class memory and blank slot. After the beta coupling, the records contain 0 and 1. The ordered zero/successor distinction supplies the positive separating witness. The instrument gains access through its coupling to the resident source, not through extra information in its initial address or a hidden oracle parameter.

This does not say that local reasoning cannot find an answer already determined by memory. It says that exact separation of this unresolved pair needs a new dependence on something that distinguishes it, or a justified narrowing of the source domain. M43 gives the same construction an autonomous finite dynamics and an explicit entropy account. M44 separates its prepared acquisition order from retained history and physical time.

## Detail: §6x. Select from memory, prepare from resident resources

### VC58

**Claim VC58 (the selected acquisition can depend only on acquired memory).** In the binary model of VC56, let the available new channel be the declared beta reading. Define the decision on old class values by s(R(a,b))=reuse and s(D(a))=beta. Compose s with the decoder of the old class fact. This selects an adequate action for every source without using its hidden beta as a decision input. The selected beta reading must still share the actual source of that fact.

**Proof.** At R(a,b), the existing decoder gives (a,b,a), so reuse answers the complete-image question. At D(a), the two possible sources have the same old memory and hence the same decision. Their distinct beta answers separate them and recover the complete image on the binary carrier. Thus the decision is constant within each old-memory fiber, while the subsequent acquisition can distinguish that fiber's members. The source equality ties the selected reading to this acquisition, even when another source would give the same numerical answer. ∎

`ChooseReadyReuse` and `ChooseBlockedBeta` take class values as their only inputs. `DecodeRefinedEvidence` reads the class from its memory address before applying the decision. `SelectedTraceExtension` is an alias of the existing prepared relation, restricted by equalities between the policy's input and the actual trace memory, and between its answer and the actual channel address. It introduces neither another acquisition implementation nor an assumed answer equality. The specific beta family supplies the channel law. A policy label alone cannot construct an arbitrary instrument. The binary family and the available channel remain explicit premises.

M65 exhibits two preparations with the same context, question and source but different answers. Their `ChannelOf` addresses agree, so channel selection alone admits either supplied reading. `SelectedResidentTraceExtension` instead binds the policy's memory-derived answer to a finite path in a resident catalogue of actual readings. The selected leaf supplies the reading and its source equation. The existing prepared relation retains both catalogue and policy beside its input and output. The original beta instance remains valid with its declared reading family. General selection among preparations needs this occurrence relation or another proof that the selected question uniquely determines the admitted reading.

Selection does not prepare a slot. Write W_d=(x,p,quiet,(m,d)) for a workspace with arbitrary old content d. Let a be an archive and (blank,r) a resident reserve head and tail. Both a and the reserve belong to the same represented whole. Consider the preparation relation

`(W_d, a, (blank,r)) → (W_blank, (a,d), r)`.

This exchanges the occupied content for a resident blank and retains the displaced content. It does not create a blank or silently discard d. If the workspace is already blank, this preparatory exchange is unnecessary. If d is otherwise recoverable from retained data, another preparation scheme may avoid storing it separately.

### VC59

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

## Detail: §6y. Admissibility forced by a common-answer contract

EF8 leaves the admitted construction language explicit. A particular interface contract can determine part of that language. Fix a question q:K→V, including its context and answer interpretation. For two sources x,y, require one local record m and one actual decoder application d(m) that correctly answers q for both sources. The whole can retain x and y separately. The requirement concerns their common answer, not their identity.

### VC60

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

## Detail: §6z. A minimal image preserves the derived domain

### VC61

**Claim VC61 (three interface classes suffice for the binary common-answer request).** Restrict q's values to 0 and 1 and consider the four ordered answer pairs. The interface must report whether a common answer exists and, when it does, supply that answer. It has no other requests. Its minimum exact image has three classes: J₀ for (0,0), J₁ for (1,1), and B for both (0,1) and (1,0).

**Proof.** J₀ and J₁ cannot merge because their required answers differ. Neither can merge with B because the common-answer request is defined on the former and undefined on the latter. These requirements force at least three classes. Three suffice: decode the common fact at J₀ or J₁, and report the positive failure at B. No request in this interface distinguishes the two orientations inside B. ∎

The corresponding typed successful images are the two canonical `AnswerFact` types. `ZeroSuccessorBoundaryImage` and `SuccessorZeroBoundaryImage` give the same context-tagged failure image, `AddressedRepresentation<ChannelOf<L>,Never>`. A recorded zero answer remains distinct from that image. The full failure records retain orientation and actual sources even when this local image omits them. This is a quotient of the specified interface, not a merger of its complete records.

Keeping only the first answer fails even to preserve the derived domain: (0,0) and (0,1) have the same first answer, but only the former admits a common fact. This is the domain-reflection condition of VC46 applied to a partial answer request. A correct answer on successful cases does not repair an image that conflates success with failure.

If the interface additionally asks which side of a failed request had zero, B must split. The four ordered pairs then require four classes. The earlier three-class image was sufficient for its declared requests. The new question requires its retained detailed obstruction or another distinguishing reading. The source record already contains that information. This illustrates how a construction's recovery contract determines both its admissibility and the distinctions a sufficient local representation must preserve.

## Detail: §6za. Acquire once under a resident agreement

VC60 characterizes when one common fact is possible. Its acquisition also needs an actual reading and prepared memory. Write a resident source as w=(x,y), with two addressed applications q_L(w)=q(x) and q_R(w)=q(y) of the same component question. The applications have the same question interpretation but different source addresses. An agreement C establishes q_L=q_R on the domain under consideration. This agreement can follow from a structural source family. Its existence does not establish that the participant has discovered it.

### VC62

**Claim VC62 (an acquired answer serves an agreed resident application without another acquisition).** Suppose both applications are on the same actual source w, C establishes their agreement, and F factors q_L through an available observation E with decoder d. Then the same observation and the same decoder factor q_R. A prepared acquisition of q_L therefore supplies one fact sufficient for both applications. Parking that fact by VC59 preserves this sufficiency wherever its resident memory address is accessible.

**Proof.** On the stated domain, q_R(w)=q_L(w)=d(E(w)). Neither E nor d changes. In the prepared special case, E(w) is the trace memory (m,f_q_L(w)). Its last-fact decoder returns q_L(w), hence q_R(w). The acquisition keeps w and m. Parking moves that one fact to an existing reserve slot while returning the instrument to its prepared state. The resident view combining the old prefix with the archived fact equals the acquired trace memory. Thus exactly the same decoder still applies. Its input contains memory, not a separately supplied copy of either source. ∎

`AnswerThroughAgreement<C,F>` constructs the general factorization. It requires the actual first application `C.Left == F.Left` and the actual source equality `C.Right.Left == F.Left.Left`. Agreement between readings of different sources does not authorize substituting F's observation of one source for an observation of the other. `PreparedCommonTrace` is the existing `PreparedTraceExtension` at the first application, constrained by the resident agreement. `CommonAnswerFromTrace` transfers `LastAnswerFromTrace` to the second application. The two resulting decoders are identical as types, including their memory input.

The explicit component laws are `BoundaryFirstAlpha` and `BoundarySecondAlpha`. On w=(CommonLeft(a),CommonRight(a)), the sources differ in hidden fields while their alpha coordinates coincide. The structural relation supplies C for every numeral a. The source pair, channel address, working memory, old archive and finite blank reserve all belong to the represented whole. The channel's label names its context and question. The first-address reading constructor supplies its coupling law. The label alone does not grant access to every reading with the same question name.

With occupied work content D, the connected construction uses the existing preparation to move D into one resident reserve slot, acquires the first alpha, then parks its fact in a second resident slot. Both seams match exactly. The final archive is ((A,D),f_q_L(w)), and the reserve tail is unchanged. There is one new answer fact, not a second measurement record for q_R. Two slots describe this particular arrangement with occupied work and subsequent parking, as in VC59. Already prepared work does not need the first exchange, and reading the completed archive needs no new slot.

Three restrictions can now be exhibited independently. An agreed source with occupied work and no reserve cannot enter this preparation relation. A prepared incompatible pair admits a first-side measurement but cannot obtain a common-answer certificate, regardless of additional blank capacity. A completed agreed acquisition still requires access to its archived fact: after instrument reset, retaining only the work view can leave two different required answers indistinguishable. All of these are restrictions inside the represented whole.

For the last case, compare the completed runs at a=0 and a=1. Their work views, excluding the sources and archive, coincide. Their archived answers have the positive zero/successor distinction. No decoder of that restricted view alone can answer both. The complete source and archive remain different. This is a loss of accessible sufficiency without loss of the distinction from the whole.

## Detail: §6zb. A sufficient answer need not reveal its own domain

### VC63

**Claim VC63 (first-side evidence cannot certify common-answer admissibility on the unrestricted binary pair family).** Let e(a,b)=a on the four binary answer pairs, and let D={(a,b):a=b}. Evidence e determines the common answer on D. It does not determine membership in D on the full family. Adding the same source-independent memory or applying a deterministic transformation of that accessible evidence cannot repair the missing distinction.

**Proof.** On D, the common answer equals a, so the identity decoder suffices. But e(0,0)=e(0,1)=0, while the former pair belongs to D and the latter has the positive 0/1 obstruction. Any decoder of e must return the same result at this shared input, so it cannot correctly decide admissibility on both pairs. Appending the same memory z gives (0,z) in both cases, and every deterministic transformation of that shared input still agrees. ∎

The same distinction is exhibited by actual prepared acquisitions. The first-alpha traces of the agreed pair (0,0) and the incompatible pair (0,1) have identical memory types. Their retained source pairs differ in the second alpha. `CommonExtraMemoryCannotDiscoverAgreement` preserves trace equality beside any common resident memory tail. The incompatibility is certified by `ZeroSuccessorBoundary` bound to the two source readings. It is not inferred from a compiler refusal.

Consequently C in VC62 must retain its status as an established source relation. Within the declared correlated constructor family it follows structurally. For an unknown member of the unrestricted pair family, the first fact does not establish that relation. A distinguishing observation or another justified restriction is needed. The compiler checks the supplied construction. Membership of the actual source in D does not give the observer evidence of that membership.

This is the acquisition-side counterpart of VC61. Its three-class image preserves the successful answer and admissibility. The two-valued first-answer image is sufficient only after restricting to D. Conditional adequacy and knowledge of the condition are different obligations. Extra storage can preserve a distinction once acquired. Source-independent storage does not supply an absent distinction about which domain contains the source.

## Detail: §6zc. Acquire the relation that licenses a common answer

VC63 leaves the first-side fact insufficient to establish compatibility on the full binary pair family. The missing distinction is already at the other address of the resident source. Read that address and retain the earlier reading. The two facts then occupy different addresses in one actual memory. This operation requires no agreement premise.

### VC64

**Claim VC64 (comparing acquired evidence reflects agreement and obstruction to the source).** Suppose q_L=d_L∘E and q_R=d_R∘E on the same actual source domain and with a common question interpretation. Agreement of d_L and d_R at the acquired memory E(w) entails agreement of q_L and q_R at w. A positive distinction between these decoded answers likewise distinguishes the source answers. On the binary component grammar, the two acquired readings determine exactly the three common-answer classes of VC61.

**Proof.** At m=E(w), q_L(w)=d_L(m) and q_R(w)=d_R(m). Substituting these equalities into the memory comparison gives the corresponding source comparison. For binary answers the four ordered memory cases are (0,0), (1,1), (0,1) and (1,0). The first two give canonical common facts with answers 0 and 1. The last two have the positive zero/successor distinction, in opposite orientations, and give the same failure image. Their minimum interface is therefore J₀, J₁, B by VC61. The complete memory still distinguishes all four ordered answer pairs. ∎

`AgreementFromMemory<F,G,C>` is an alias of `JoinedVerdict<F.Left,G.Left>`. Its premises require one actual observation `F.Observation == G.Observation` and the memory comparison `C.Left == F.Right`, `C.Right == G.Right`. Source-answer equality is the conclusion, not a separate premise. The shared observation also ties both source applications to the same actual whole. `ZeroSuccessorFromMemory` transfers the corresponding positive numeral distinction with its head constraints on the memory decoders. Reversing the two factors and the resulting obstruction covers the other orientation.

Let T₁ append the first component reading and T₂ append the second to the same source trace. Both are instances of the existing `AppendObservation`. `RetainTraceAnswer<T₂,LastAnswerFromTrace<T₁>>` gives d_L, while `LastAnswerFromTrace<T₂>` gives d_R. Their observation is exactly `TraceEvidence<T₂>`. Their decoder inputs contain the acquired facts, with neither source as a separate argument. They compare two recorded addresses rather than asking the source a third question.

The memory constructors `AgreedMemoryBoundary`, `ZeroSuccessorMemoryBoundary` and `SuccessorZeroMemoryBoundary` produce the three existing images. Their question is `CommonBoundaryQuestion`, distinct from the original alpha question. A failure image therefore does not masquerade as an alpha answer. `QuestionOnObservation` connects each memory classification to its actual source trace. The four binary cases are all supplied. The clauses do not define a general comparison of arbitrary Swift types, and outside this covered grammar missing conformance still means no supplied construction.

Different sources with identical acquired memory can use the identical classifier. Their acquisition relations remain different. An equal-valued foreign observation cannot replace either factor in `AgreementFromMemory`. A fabricated fact shape would also need its source-bound observation relation before this inference could apply.

In the agreed cases, the resulting source verdict now supplies C to VC62. The last acquired decoder can serve both addressed applications through `AnswerThroughAgreement`, with no new reading and no appended third fact. For an incompatible case, both individual answers remain readable, but their distinction obstructs precisely the common-answer contract. The rule's applicability has now been obtained from actual evidence rather than inferred from possession of a first-side fact.

## Detail: §6zd. A resident second slot and an exact reading bound

The two-read schedule starts with one prepared slot and one further resident blank. After the first acquisition, `AdvancePreparedTrace` moves the completed memory into the next prepared prefix and uses that blank as its new slot. Its input is `(W₁,blank)` and its output is `(w,p,quiet,(m₁,blank))`, where W₁=(w,p,signal,m₁). The two readings have the same context, encoding and component-question channel address. Their constructors specify the different component couplings. This fixed schedule does not consult the unmeasured second answer to choose its next reading.

The advance has a left inverse on this prepared range. From the output, recover w,p,m₁ and the blank. Reconstruct W₁ using its known signal phase and pair it with the recovered blank. Thus the first memory and both source components remain recoverable. An unread first state, an absent second slot and an occupied second slot do not meet this relation's input. The next `PreparedTraceExtension` then produces the memory ((m,f_L),f_R). Both seams are checked in the general constructor family.

This is a relation for a declared finite acquisition schedule. Its two slots are initially internal, and it does not introduce a supply from outside the whole. The intermediate current layouts are recoverable but do not claim to be a full occurrence-history representation. The independent historical requirement of M44 can retain these events. The local three-class view is also a derived representation, not a physical deletion of either retained fact.

### VC65

**Claim VC65 (both component readings are necessary on the unrestricted binary domain).** Suppose the source is unchanged during acquisition, all four ordered binary pairs remain possible under the old evidence, and the only new source-reading operations return the first or second component. Every deterministic policy that correctly reports J₀, J₁ or B must read both components on every source. Consequently, after one component fact, exactly one further reading is necessary and sufficient. If accessible old evidence already determines the other component on this actual source, no further reading is needed to compare them.

**Proof.** After a first-component result 0, sources (0,0) and (0,1) remain indistinguishable but require J₀ and B. After result 1, sources (1,0) and (1,1) require B and J₁. Repeating that component on an unchanged source adds no distinction. The argument is symmetric if the second component is read first. Hence a correct policy must acquire the other component before terminating. Reading it once gives both answers and suffices by VC64. If another accessible factorization already supplies that answer, apply the same memory comparison to the two existing decoders instead. ∎

The last case is exhibited with an old second-side fact in the trace prefix and a first-side fact at its last address. `RetainTraceAnswer` exposes the old answer, and `AgreementFromMemory` derives agreement directly from their memory comparison. No new extension is part of that derivation. Applicability therefore has a cost relative to the evidence already accessible and the allowed channels. Two reads are necessary in the stated unrestricted domain, not a universal price of establishing a relation.

## Cross-page mentions

Labels mentioned here: <doc:permanence_is_resistance__records_entropy#M43>, <doc:permanence_is_resistance__records_entropy#M44>, <doc:permanence_is_resistance__uniform_routing#M65>, <doc:verdict_is_invariant__finite_records#VC15>, <doc:verdict_is_invariant__discovery_acquisition#VC39>, <doc:verdict_is_invariant__discovery_acquisition#VC40>, <doc:verdict_is_invariant__discovery_acquisition#VC41>.

Mentions of this page’s labels: <doc:interference_is_substitution__global_obstructions> (VC46), <doc:interference_is_substitution__global_obstructions> (VC47), <doc:interference_is_substitution__models_calibration> (VC45), <doc:learning_is_liquid> (VC46), <doc:learning_is_liquid> (VC47), <doc:learning_is_liquid__atoms_continuations> (VC46), <doc:learning_is_liquid__medium_contacts> (VC46), <doc:learning_is_liquid__medium_contacts> (VC47), <doc:learning_is_liquid__medium_contacts> (VC60), <doc:learning_is_liquid__reconstructed_sides> (VC46), <doc:learning_is_liquid__reconstructed_sides> (VC47), <doc:permanence_is_resistance__cost> (VC59), <doc:permanence_is_resistance__forced_answers> (VC47), <doc:permanence_is_resistance__forced_answers> (VC60), <doc:permanence_is_resistance__forced_answers> (VC61), <doc:permanence_is_resistance__forced_answers> (VC65), <doc:permanence_is_resistance__records_entropy> (VC44), <doc:permanence_is_resistance__records_entropy> (VC45), <doc:permanence_is_resistance__records_entropy> (VC46), <doc:permanence_is_resistance__records_entropy> (VC47), <doc:permanence_is_resistance__records_entropy> (VC49), <doc:permanence_is_resistance__records_entropy> (VC55), <doc:permanence_is_resistance__records_entropy> (VC58), <doc:permanence_is_resistance__records_entropy> (VC59), <doc:permanence_is_resistance__recovery_remainder> (VC46), <doc:permanence_is_resistance__recovery_remainder> (VC47), <doc:permanence_is_resistance__recovery_remainder> (VC60), <doc:permanence_is_resistance__recovery_remainder> (VC62), <doc:permanence_is_resistance__uniform_routing> (VC58), <doc:verdict_is_invariant__finite_policies> (VC52), <doc:verdict_is_invariant__finite_records> (VC44), <doc:verdict_is_invariant__finite_records> (VC46), <doc:verdict_is_invariant__finite_records> (VC47), <doc:verdict_is_invariant__local_lifts> (VC44), <doc:verdict_is_invariant__local_lifts> (VC52), <doc:verdict_is_invariant__recovery_memory> (VC46), <doc:verdict_is_invariant__recovery_memory> (VC47), <doc:verdict_is_invariant__relative_questions> (VC60), <doc:verdict_is_invariant__relative_questions> (VC62), <doc:verdict_is_invariant__routing_laws> (VC61), <doc:verdict_is_invariant__routing_laws> (VC64).
