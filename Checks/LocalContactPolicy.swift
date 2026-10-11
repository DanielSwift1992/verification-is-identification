import VerificationIsIdentification
import Examples

typealias LocalContactTable = Paired<SecondProjection, FirstProjection>

// Both prepared channel states agree for arbitrary hidden port contents.
// The full port remains resident, outside the declared policy view.
enum LocalPreparationDoesNotChoose<P: Pair, T: Pair>: Null
where P.Right: Pair, T.Right: Pair {
    typealias X = ContactProbePreparation<P>
    typealias Y = ContactProbePreparation<T>
    typealias Left = Paired<X.Left.Right, X.Right>
    typealias Right = Paired<Y.Left.Right, Y.Right>
}

// Same request, same resident table and same two ready instruments give
// identical complete local control inputs despite different sender records.
enum LocalEqualRequestsKeepSameView<A: Structure, B: Structure, J: Pair>: Null {
    typealias X = LocalContactRequest<ContactPort1, ContactSeam01, A, B, J, Never>
    typealias Y = LocalContactRequest<ContactPort4, ContactSeam40, A, B, J, Never>
    typealias Left = Paired<X.Memory, Paired<X.Right.Right.Right.Left,
        Paired<X.Prepared.Left.Right, X.Prepared.Right>>>
    typealias Right = Paired<Y.Memory, Paired<Y.Right.Right.Right.Left,
        Paired<Y.Prepared.Left.Right, Y.Prepared.Right>>>
}

enum LocalDeliveryKeepsWhole<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair, M: Structure>: Null
where P.Right: Pair {
    typealias R = LocalContactRequest<P, E, A, B, J, M>
    typealias W = R.Right
    typealias Left = Paired<Paired<W.Left, W.Right.Right.Left>,
        Paired<W.Right.Left, W.Right.Right.Right>>
    typealias Right = R.Send.Right
}

enum LocalCycleAnswers<A: Structure, B: Structure, J: Pair>: Null
where J.Left == SecondProjection, J.Right == FirstProjection {
    typealias C = LocalContactCycle<A, B, J>
    typealias Left = Paired<C.Seam01.Answer, Paired<C.Seam12.Answer,
        Paired<C.Seam23.Answer, Paired<C.Seam34.Answer, C.Seam40.Answer>>>>
    typealias Right = Paired<Paired<A, B>, Paired<Paired<A, B>,
        Paired<Paired<A, B>, Paired<Paired<A, B>, Paired<A, B>>>>>
}
typealias LocalBinaryCycle = LocalCycleAnswers<Never, Lit1, LocalContactTable>
typealias LocalStructuredCycle = LocalCycleAnswers<Paired<Never, Lit2>, Paired<Lit1, Never>, LocalContactTable>

enum OtherLocalTableName: Pair {
    typealias Left = SecondProjection
    typealias Right = FirstProjection
}
typealias LocalRenamedProgramStillWorks = LocalCycleAnswers<Never, Lit1, OtherLocalTableName>

// The composite proof derives the original payload pair at every admitted
// seam from the actual fixed-channel reply, for arbitrary payload values.
enum LocalBitCycleAnswers<A: Structure, B: Structure, J: Pair>: Null
where J.Left == SecondProjection, J.Right == FirstProjection {
    typealias C = ContactBitCycle<A, B, J>
    typealias Left = Paired<C.Seam01.Proof.Answer, Paired<C.Seam12.Proof.Answer,
        Paired<C.Seam23.Proof.Answer, Paired<C.Seam34.Proof.Answer,
            Paired<C.OtherSeam34.Proof.Answer, C.Seam40.Proof.Answer>>>>>
    typealias AB = Paired<A, B>
    typealias Right = Paired<AB, Paired<AB, Paired<AB, Paired<AB, Paired<AB, AB>>>>>
}
typealias LocalBitBinaryCycle = LocalBitCycleAnswers<Never, Lit1, LocalContactTable>
typealias LocalBitStructuredCycle = LocalBitCycleAnswers<Paired<Never, Lit2>,
    Paired<Lit1, Never>, OtherLocalTableName>

// Renaming the resident program cannot become a hidden decoder input.
enum LocalBitDecoderIgnoresProgramName<A: Structure, B: Structure>: Null {
    typealias X = ContactBitCycle<A, B, LocalContactTable>.Seam01
    typealias Y = ContactBitCycle<A, B, OtherLocalTableName>.Seam01
    typealias Left = Paired<X.Proof.Observation.Answer, X.Proof.Right>
    typealias Right = Paired<Y.Proof.Observation.Answer, Y.Proof.Right>
}

// On the restricted seam01 domain the one row is never used. Both legal
// actions at that row preserve the complete returned facts and the answer.
enum LocalUnreachedRowDoesNotConstrain<A: Structure, B: Structure>: Null {
    typealias X = Paired<SecondProjection, FirstProjection>
    typealias Y = Paired<SecondProjection, SecondProjection>
    typealias First = LocalSecondForward<ContactPort0, ContactPort1, A, B, X>
    typealias Second = LocalSecondForward<ContactPort0, ContactPort1, A, B, Y>
    typealias Left = Paired<First.Observation.Answer, First.Answer>
    typealias Right = Paired<Second.Observation.Answer, Second.Answer>
}

enum LocalRenamingKeepsBothChoices<J: Pair>: Null
where J.Left: Structure, J.Right: Structure {
    typealias Left = Paired<RenamedZeroLocalChoice<J>.Answer, RenamedOneLocalChoice<J>.Answer>
    typealias Right = Paired<J.Left, J.Right>
}

// The input at the selected resident probe is obtained through the actual
// transmission; its shape is not an independently supplied claimed memory.
enum LocalRequestMeetsProbe<A: Structure, B: Structure>: Null {
    typealias R = LocalContactRequest<ContactPort4, ContactSeam40, A, B, LocalContactTable, Lit1>
    typealias Left = R.ExecutorInput.Answer
    typealias Right = LocalOneFirstProbe<ContactPort4, LocalContactTable>.Left
}

#if LOCAL_POLICY_HIDDEN_BRANCH
// The same zero-row already selects Second. A globally convenient First
// at another hidden record cannot replace it without changing the input.
typealias RejectedLocalHiddenBranch = LocalZeroFirstProbe<ContactPort4, LocalContactTable>
#endif

// The two remaining local choices at the flexible seam both answer the
// same independent endpoint question. Adequacy does not force one action.
enum LocalFlexibleSeam<A: Structure, B: Structure>: Null {
    typealias C = LocalContactCycle<A, B, LocalContactTable>
    typealias Left = C.OtherSeam34.Answer
    typealias Right = C.Seam34.Answer
}

enum LocalReplyTransferKeepsWhole<P: Pair, E: Pair, A: Structure, B: Structure,
    J: Pair>: Null
where P.Right: Pair, J.Left == SecondProjection {
    typealias R = LocalSecondContactRun<P, E, A, B, J>
    typealias W = R.Right
    typealias Left = Paired<Paired<Paired<W.Right.Left, W.Left.Right>, W.Right.Right.Left>,
        Paired<W.Left.Left, W.Right.Right.Right>>
    typealias Right = R.Probe.Right
}

// Cover BOTH possible constant local actions by collisions in actual
// returned receiver inputs. A changed decoder cannot separate either pair.
enum LocalConstantFirstCollision: Null {
    typealias Left = ContactLocalOneEvidence<ContactPort0, ContactSeam01, Never, Lit1, LocalContactTable>.Answer
    typealias Right = ContactLocalOneEvidence<ContactPort1, ContactSeam01, Never, Lit1, LocalContactTable>.Answer
}
typealias LocalFirstSource0 = ContactBeforeLocalRequest<ContactPort0, ContactSeam01, Never, Lit1, LocalContactTable, Lit1>
typealias LocalFirstSource1 = ContactBeforeLocalRequest<ContactPort1, ContactSeam01, Never, Lit1, LocalContactTable, Lit1>
typealias LocalFirstTarget0 = DecodeRefinedEvidence<LocalFirstSource0, ContactLeftValue<LocalFirstSource0.Answer>>
typealias LocalFirstTarget1 = DecodeRefinedEvidence<LocalFirstSource1, ContactRightValue<LocalFirstSource1.Answer>>
typealias LocalConstantFirstTargetsDiffer = ZeroSuccessorBoundary<LocalFirstTarget0, LocalFirstTarget1, Never>

enum LocalConstantSecondCollision: Null {
    typealias Left = ContactLocalZeroEvidence<ContactPort4, ContactSeam40, Never, Lit1, LocalContactTable>.Answer
    typealias Right = ContactLocalZeroEvidence<ContactPort0, ContactSeam40, Never, Lit1, LocalContactTable>.Answer
}
typealias LocalSecondSource4 = ContactBeforeLocalRequest<ContactPort4, ContactSeam40, Never, Lit1, LocalContactTable, Never>
typealias LocalSecondSource0 = ContactBeforeLocalRequest<ContactPort0, ContactSeam40, Never, Lit1, LocalContactTable, Never>
typealias LocalSecondTarget4 = DecodeRefinedEvidence<LocalSecondSource4, ContactLeftValue<LocalSecondSource4.Answer>>
typealias LocalSecondTarget0 = DecodeRefinedEvidence<LocalSecondSource0, ContactRightValue<LocalSecondSource0.Answer>>
typealias LocalConstantSecondTargetsDiffer = ZeroSuccessorBoundary<LocalSecondTarget4, LocalSecondTarget0, Never>

// Before the actual return, the sender has not distinguished the two
// original endpoints, even though the other side has acquired a probe fact.
enum LocalNoEarlyAnswer: Null {
    typealias X = LocalSecondContactRun<ContactPort0, ContactSeam01, Never, Lit1, LocalContactTable>
    typealias Y = LocalSecondContactRun<ContactPort1, ContactSeam01, Never, Lit1, LocalContactTable>
    typealias Left = X.Probe.Right.Right.Left
    typealias Right = Y.Probe.Right.Right.Left
}
typealias LocalEarlyTargetsDiffer = ZeroSuccessorBoundary<
    LocalContactCycle<Never, Lit1, LocalContactTable>.Seam01.DirectP,
    LocalContactCycle<Never, Lit1, LocalContactTable>.Seam01.DirectT, Never>

#if LOCAL_POLICY_READY_IS_REPLY
typealias LocalReadySlot = PreparedTraceExtension<StartObservations<ContactPort0>, ContactFirstBit<ContactPort0>>.Left.Right
typealias RejectedLocalReadyReply = ReturnedContactFacts<Paired<
    FactOf<ContactRecord<ContactWorld<ContactPort0, ContactSeam01, Never, Lit1>>>, LocalReadySlot>>
#endif

#if LOCAL_POLICY_CONSTANT_FIRST_ANSWER
typealias RejectedLocalFirstCollisionAnswer = JoinedVerdict<LocalFirstTarget0, LocalFirstTarget1>
#endif

#if LOCAL_POLICY_CONSTANT_SECOND_ANSWER
typealias RejectedLocalSecondCollisionAnswer = JoinedVerdict<LocalSecondTarget4, LocalSecondTarget0>
#endif

#if LOCAL_POLICY_RENAMES_MESSAGE_ONLY
enum RejectedLocalMessageOnlyRename: ReadingFactors {
    typealias Left = LocalPolicyAtZero<LocalContactTable>
    typealias Observation = RenameZeroLocalRequest<LocalContactTable>
    typealias Right = LocalPolicyAtOne<LocalContactTable>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = AcquisitionChoice
    typealias Answer = Left.Answer
}
#endif

#if LOCAL_POLICY_UNSELECTED_PRIMITIVE
// At the flexible seam either instrument can support a correct answer.
// That does not let one replace the action chosen by this actual table.
enum RejectedLocalUnselectedPrimitive: Null {
    typealias R = LocalSecondContactRun<ContactPort3, ContactSeam34, Never, Lit1, LocalContactTable>
    typealias Wrong = StepBeside<FirstResidentContactProbe<ContactPort3>, R.Focus.Right.Right>
    typealias Left = R.Choice.Answer
    typealias Right = LocalProbeReply<Wrong>.Predicate.Right
}
#endif

enum LocalExchangePreservesOriginalAnswers<A: Structure, B: Structure, J: Pair>: Null
where J.Left == SecondProjection {
    typealias Left = Paired<LocalExchangeFromFirst<A, B, J>.Answer, LocalExchangeFromSecond<A, B, J>.Answer>
    typealias Right = Paired<A, B>
}

enum LocalPreparedExchangeReturns<P: Pair, T: Structure, E: Pair, A: Structure,
    B: Structure, J: Pair, M: Structure>: Null
where P.Right: Pair {
    typealias W = LocalContactRequest<P, E, A, B, J, M>.Left
    typealias First = ExchangePreparedContactPort<W, T>
    typealias Second = ExchangePreparedContactPort<First.Right.Left, First.Right.Right>
    typealias Left = Second.Right
    typealias Right = First.Left
}

enum LocalExchangeRetainsBothPorts<A: Structure, B: Structure, J: Pair>: Null
where J.Left == SecondProjection {
    typealias W = LocalExchangeFromFirst<A, B, J>.Whole.Right
    typealias Left = Paired<W.Left.Right.Left, Paired<W.Right, W.Left.Right.Right.Right.Left>>
    typealias Right = Paired<ContactPort1, Paired<ContactPort0, J>>
}

// This input alone does not identify whether the old endpoint was exchanged.
// The missing law relation cannot be recovered from identical reply facts.
enum LocalUnknownExchangeHasSameReply: Null {
    typealias Left = LocalExchangeFromFirst<Never, Lit1, LocalContactTable>.Observation.Answer
    typealias Right = ContactLocalZeroEvidence<ContactPort1, ContactSeam01, Never, Lit1, LocalContactTable>.Answer
}
typealias LocalUnknownExchangeTargetsDiffer = ZeroSuccessorBoundary<
    LocalExchangeFromFirst<Never, Lit1, LocalContactTable>.Left,
    LocalContactCycle<Never, Lit1, LocalContactTable>.Seam01.DirectT, Never>

// The COMPLETE carrier state agrees across distinct probe coordinates
// and ports when the returned bit agrees. Its channel adds no hidden bit.
enum LocalBitCarrierDoesNotNameProbe: Null {
    typealias X = ContactFirstBitReturn<ContactPort4, ContactSeam40, Never, Lit1, LocalContactTable>
    typealias Y = ContactSecondBitReturn<ContactPort1, ContactSeam01, Never, Lit1, LocalContactTable>
    typealias Left = Paired<X.Transmission.Left.Right, X.Right.Left.Right>
    typealias Right = Paired<Y.Transmission.Left.Right, Y.Right.Left.Right>
}

enum LocalBitReturnRetainsProbe<P: Pair, E: Pair, A: Structure,
    B: Structure, J: Pair>: Null
where P.Right: Pair, J.Left == SecondProjection {
    typealias C = ContactSecondBitReturn<P, E, A, B, J>
    typealias W = C.Right
    typealias Left = Paired<Paired<W.Right.Right.Left, W.Left.Right>,
        Paired<W.Right.Left, Paired<W.Right.Right.Right.Left,
            Paired<W.Left.Left, W.Right.Right.Right.Right>>>>
    typealias Right = C.Acquire.Right
}

enum LocalBitReplyRestoresKnownQuestion<P: Pair, E: Pair, A: Structure,
    B: Structure, J: Pair>: Null
where P.Right: Pair, J.Left == SecondProjection, J.Right == FirstProjection {
    typealias X = ContactFirstBitReturn<P, E, A, B, J>
    typealias Y = ContactSecondBitReturn<P, E, A, B, J>
    typealias First = X.Recover<OperationSequence<ContactCalibrationQuestion, FirstProjection>, P.Right.Left>
    typealias Second = Y.Recover<OperationSequence<ContactCalibrationQuestion, SecondProjection>, P.Right.Right>
    typealias Left = Paired<First.Answer, Second.Answer>
    typealias Right = Paired<X.ProbeFacts.Answer, Y.ProbeFacts.Answer>
}

// The flexible seam admits two different prepared policies. Dropping which
// one was used can merge identical bits with different original answers.
// Each fixed policy remains valid; this is a boundary on pooling them.
typealias LocalBitFromFirstPolicy = ContactFirstBitReturn<ContactPort3, ContactSeam34, Never, Lit1, LocalContactTable>
typealias LocalBitFromSecondPolicy = ContactSecondBitReturn<ContactPort4, ContactSeam34, Never, Lit1, LocalContactTable>
enum LocalBitWithoutPolicyCollides: Null {
    typealias Left = LocalBitFromFirstPolicy.Receiver.Answer
    typealias Right = LocalBitFromSecondPolicy.Receiver.Answer
}
typealias LocalBitFirstOriginal = DecodeRefinedEvidence<
    FirstEvidenceImage<LocalBitFromFirstPolicy.Left, BeamSpace, SaturationEncoding, FirstProjection>,
    LocalFirstForward<ContactPort3, ContactPort4, Never, Lit1, LocalContactTable>.DirectP>
typealias LocalBitSecondOriginal = DecodeRefinedEvidence<
    FirstEvidenceImage<LocalBitFromSecondPolicy.Left, BeamSpace, SaturationEncoding, FirstProjection>,
    LocalSecondBackward<ContactPort3, ContactPort4, Never, Lit1, LocalContactTable>.DirectT>
typealias LocalBitWithoutPolicyTargetsDiffer = ZeroSuccessorBoundary<LocalBitFirstOriginal, LocalBitSecondOriginal, Never>

#if LOCAL_POLICY_GUESSES_REPLY_QUESTION
enum RejectedLocalGuessedReplyQuestion: ReadingFactors {
    typealias Left = LocalBitSecondOriginal
    typealias Observation = LocalBitFromSecondPolicy.Receiver
    typealias Guessed = ContactReplyWithQuestion<Observation.Answer,
        OperationSequence<ContactCalibrationQuestion, FirstProjection>>
    typealias Right = DecodeRefinedEvidence<Guessed,
        ContactFirstInquiryForward<ContactPort3, ContactPort4, Never, Lit1>.DecoderP>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = Left.Predicate
    typealias Answer = Left.Answer
}
#endif

#if LOCAL_POLICY_CURRENT_IS_ORIGINAL
enum RejectedLocalCurrentForOriginal: ReadingFactors {
    typealias F = LocalExchangeFromFirst<Never, Lit1, LocalContactTable>
    typealias Left = F.Left
    typealias Observation = F.Observation
    typealias Right = ContactInquiryCycle<Never, Lit1>.Seam01.DecoderT
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutedValueQuestion
    typealias Answer = Left.Answer
}
#endif

#if LOCAL_POLICY_USES_DISPLACED_PORT
typealias LocalChangedPort = LocalExchangeFromFirst<Never, Lit1, LocalContactTable>
typealias RejectedLocalDisplacedProbe = FollowedPair<LocalChangedPort.Exchange,
    StepBeside<LocalSecondContactRun<ContactPort0, ContactSeam01, Never, Lit1, LocalContactTable>, ContactPort1>>
#endif

#if LOCAL_POLICY_UNSENT_REQUEST
typealias LocalUnsent = LocalContactRequest<ContactPort4, ContactSeam40, Never, Lit1, LocalContactTable, Never>
typealias RejectedLocalUnsentRequest = DecodeRefinedEvidence<LocalUnsent.ExecutorInput,
    LocalOneFirstReply<ContactPort4, LocalContactTable>>
#endif

#if LOCAL_POLICY_CHANGES_TABLE
typealias LocalOriginalProgram = LocalContactRequest<ContactPort1, ContactSeam01, Never, Lit1, LocalContactTable, Never>
typealias RejectedLocalChangedTable = FollowedPair<LocalOriginalProgram.ExecutorInput,
    LocalZeroFirstProbe<ContactPort1, Paired<FirstProjection, SecondProjection>>>
#endif
