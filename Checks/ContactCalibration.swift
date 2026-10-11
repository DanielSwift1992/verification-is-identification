import VerificationIsIdentification
import Examples

// All ten independent source questions factor through the actual fact inputs.
// The five generic bodies in Examples establish this for arbitrary A and B.
enum ContactAllSeams<A: Structure, B: Structure>: Null {
    typealias C = CalibratedContactCycle<A, B>
    typealias Left = Paired<C.Seam01.Answer, Paired<C.Seam12.Answer,
        Paired<C.Seam23.Answer, Paired<C.Seam34.Answer, C.Seam40.Answer>>>>
    typealias Right = Paired<Paired<A, B>, Paired<Paired<A, B>,
        Paired<Paired<A, B>, Paired<Paired<A, B>, Paired<A, B>>>>>
}
typealias ContactBinaryPayloads = ContactAllSeams<Never, Lit1>
typealias ContactStructuredPayloads = ContactAllSeams<Paired<Never, Lit1>, Paired<Lit2, Never>>

// A genuinely changed active port preserves the old record, but can change q.
typealias ContactCases = CalibratedContactCycle<Never, Lit1>
typealias ContactBefore = ContactCases.W01L
typealias ContactChange = ContactReserveChange<ContactBefore, ContactPort1>
typealias ContactAfter = ContactChange.Right.Left
typealias ContactOldRecordSurvives = ContactChangeRetainsRecord<ContactBefore, ContactPort1>
enum ContactReserveReturns<P: Pair, Q: Pair, R: Structure>: Null {
    typealias Change = ContactReserveChange<Paired<P, R>, Q>
    typealias Return = ContactReserveChange<Change.Right.Left, Change.Right.Right>
    typealias Left = Return.Right
    typealias Right = Change.Left
}
enum ContactChangeHasActualEndpoint: Null {
    typealias Left = ContactAfter
    typealias Right = ContactCases.W01R
}
typealias ContactChangedAnswer = ZeroSuccessorBoundary<ContactLeftValue<ContactBefore>, ContactRightValue<ContactAfter>, Never>

// The decoder input uses the OLD record and the CURRENT calibration. The
// equality is derived from the concrete replacement, not a caller's promise.
enum ContactReuseHasExactInput: Null {
    typealias Left = Paired<FactOf<ContactRecord<ContactBefore>>, FactOf<ContactCalibration<ContactAfter>>>
    typealias Right = ContactCases.Decode01R.Left
}
enum ContactReuseHasNewAnswer: Null {
    typealias Left = ContactCases.Decode01R.Answer
    typealias Right = ContactRightValue<ContactAfter>.Answer
}

// A prepared internal instrument produces precisely the current calibration
// fact needed beside the old record. Preparation remains an explicit premise.
typealias ContactPreparedCalibration = PreparedTraceExtension<StartObservations<ContactAfter>, ContactCalibration<ContactAfter>>
typealias ContactCalibrationBesideOldRecord = StepBeside<ContactPreparedCalibration, FactOf<ContactRecord<ContactBefore>>>
enum ContactPreparedRepairInput: Null {
    typealias W = ContactCalibrationBesideOldRecord.Right
    typealias CurrentFact = W.Left.Right.Right.Right.Right
    typealias Left = Paired<W.Right, CurrentFact>
    typealias Right = ContactCases.Decode01R.Left
}

// A second, previously specified task: repair VC83's 00 -> 10 replacement.
// Pull the existing row factor through the actual replacement. The new p
// observation determines the new row without identifying the whole route.
enum ContactRepairsRouting<A: Structure, B: Structure>: Null {
    typealias X = RowRepeatedData<A, B>
    typealias Repair = RowLawChangeReacquiresAnswer<A, B>
    typealias Independent = SelectionAfterReserveChange<SelectionCalibration00, SelectionCalibration10, X, Route10<X>>
    typealias Left = Paired<Repair.Left.Left, Paired<Repair.Answer, Repair.Observation.Answer>>
    typealias Right = Paired<Independent.Left, Paired<Independent.Answer,
        Paired<FactOf<FirstSelectionProbe<SelectionCalibration10>>, X>>>
}

// The algebraic odd-circuit result permits a collapsed marker, and proves
// that collapse from edge relations. Such a marker is not two distinct codes.
typealias ContactCollapsed = Paired<Never, Never>
typealias ContactCollapsedCircuit = OddContactCalibration<ContactCollapsed, ContactCollapsed, ContactCollapsed, ContactCollapsed, ContactCollapsed>

// Alternating two codes succeeds on the open path, but collides at seam40.
// The two complete accessible inputs coincide while the direct values differ.
typealias ContactBinaryPort4 = Paired<ContactPort4.Left, RoutingAddress00>
typealias ContactCollisionLeft = ContactWorld<ContactBinaryPort4, ContactSeam40, Never, Lit1>
typealias ContactCollisionRight = ContactCases.W40R
enum ContactCollisionInputsAgree: Null {
    typealias Left = ContactFacts<ContactCollisionLeft>.Answer
    typealias Right = ContactFacts<ContactCollisionRight>.Answer
}
typealias ContactCollisionAnswersDiffer = ZeroSuccessorBoundary<ContactLeftValue<ContactCollisionLeft>, ContactRightValue<ContactCollisionRight>, Never>

// The three-code construction deliberately does not identify every port.
// In the enlarged domain, a nonincident p0 has the same facts as incident p2.
typealias ContactNotIncident = ContactWorld<ContactPort0, ContactSeam12, Never, Lit1>
enum ContactAdmissionInputsAgree: Null {
    typealias Left = ContactFacts<ContactNotIncident>.Answer
    typealias Right = ContactFacts<ContactCases.W12R>.Answer
}
typealias ContactNotAtFirstEndpoint = ZeroSuccessorBoundaryPairClass<Paired<ContactPort0.Left, ContactSeam12.Left>, Never>
typealias ContactNotAtSecondEndpoint = ZeroSuccessorBoundaryPairClass<Paired<ContactPort0.Left, ContactSeam12.Right>, Lit1>
// Positive attack: the decoder can produce a value despite missing admission.
typealias ContactValueWithoutAdmission = DecodeRefinedEvidence<ContactFacts<ContactNotIncident>, ContactCases.Decode12R>
enum ContactUnadmittedDecoderProducesValue: Null {
    typealias Left = ContactValueWithoutAdmission.Answer
    typealias Right = Lit1
}

// Equal payloads remove the value conflict. This factor omits calibration
// altogether and answers the independently specified RIGHT endpoint question.
enum ContactConstantNeedsNoCalibration<A: Structure>: ReadingFactors {
    typealias W = CalibratedContactCycle<A, A>.W40R
    typealias Left = ContactRightValue<W>
    typealias Observation = AcquireAnswer<ContactRecord<W>>.Observation
    typealias Read = ReadRecordedAnswer<Observation.Answer>
    typealias Payload = SecondEvidenceImage<Read.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    typealias Right = DecodeRefinedEvidence<DecodeRefinedEvidence<Read, Payload>,
        FirstEvidenceImage<Payload.Answer, BeamSpace, SaturationEncoding, RoutedValueQuestion>>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutedValueQuestion
    typealias Answer = Left.Answer
}

#if CONTACT_STALE_CALIBRATION
enum RejectedStaleContactCalibration: Null {
    typealias Left = Paired<FactOf<ContactRecord<ContactBefore>>, FactOf<ContactCalibration<ContactBefore>>>
    typealias Right = ContactCases.Decode01R.Left
}
#endif

#if CONTACT_TWO_SYMBOLS_CLOSE
typealias ContactForward = Paired<Never, Lit1>
typealias ContactBackward = Paired<Lit1, Never>
typealias RejectedTwoContactSymbols = OddContactCalibration<ContactForward, ContactBackward, ContactForward, ContactBackward, ContactForward>
#endif

#if CONTACT_COLLISION_REUSES_ANSWER
enum RejectedContactCollision: ReadingFactors {
    typealias Left = ContactLeftValue<ContactCollisionLeft>
    typealias Observation = ContactFacts<ContactCollisionLeft>
    typealias Right = ContactCases.Decode40R
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = RoutedValueQuestion
    typealias Answer = Left.Answer
}
#endif

#if CONTACT_FALSE_ADMISSION
typealias RejectedContactAdmission = ContactLeftValue<ContactNotIncident>
#endif

#if CONTACT_CHANGES_SEAM
typealias RejectedContactSeam = DecodeRefinedEvidence<ContactFacts<ContactCases.W12R>, ContactCases.Decode01L>
#endif
