import VerificationIsIdentification
import Examples

// All statements below are type equalities. There is no runtime evaluator.
// Reading a payload requires its question and answer, without inventing a source.
enum FactSuppliesAnswer<F: HasVerdict>: Null {
    typealias Left = ReadRecordedAnswer<F>.Answer
    typealias Right = F.Answer
}

enum FactSuppliesQuestion<F: HasVerdict>: Null {
    typealias Left = ReadRecordedAnswer<F>.Predicate
    typealias Right = F.Predicate
}

enum AcquiredAnswerFollows<R: PredicateReading>: Null
where R.Left: Structure {
    typealias Left = AcquireAnswer<R>.Right.Answer
    typealias Right = R.Answer
}

enum AcquiredWholeRecoversSource<R: PredicateReading>: Null
where R.Left: Structure {
    typealias Left = AcquireAnswer<R>.Record.Right.Left
    typealias Right = R.Left
}

enum RefinementAnswerFollows<
    F: ReadingFactors,
    G: ReadingFactors
>: Null
where G.Left == F.Observation {
    typealias Left = RefineAnswer<F, G>.Conclusion.Right.Answer
    typealias Right = F.Left.Answer
}

// The memory image forgets the source. Two different sources with the same
// first result produce exactly the same fact type, not two tagged source IDs.
enum EqualFirstFacts<
    A: Pair,
    B: Pair
>: Null
where A.Left == B.Left {
    typealias Left = FactOf<FirstTableReading<A>>
    typealias Right = FactOf<FirstTableReading<B>>
}

enum ExtendedTraceRetainsPrefix<T: ExtendedObservationTrace>: Null {
    typealias Left = T.Right.Left
    typealias Right = T.Previous.Right
}

enum PrefixDecoderUsesActualRecord<P: Permanent, R: PredicateReading>: Null
where P.Left == R.Left {
    typealias Left = PrefixMemoryAnswer<R, P.Right>.Application.Left
    typealias Right = P.Right
}

enum PrefixApplicationPreservesAnswer<P: Permanent, R: PredicateReading>: Null
where P.Left == R.Left {
    typealias Left = PrefixMemoryAnswer<R, P.Right>.Application.Answer
    typealias Right = R.Answer
}

#if ACQUISITION_PREFIX_USES_LATEST_SLOT
typealias RejectedLatestAsPrefix = PrefixMemoryAnswer<
    IdentityReading<Lit1, Never, Never>, Paired<Never, Lit1>
>
#endif

enum ScopedAnswerIsExistingReading<
    T: ObservationTrace,
    F: ReadingFactors
>: Null
where F.Left.Left == T.Left, F.Observation.Answer == T.Right {
    typealias Left = AnswerInTrace<T, F>
    typealias Right = F.Right
}

enum ScopedAnswerUsesActualMemory<
    T: ObservationTrace,
    F: ReadingFactors
>: Null
where F.Left.Left == T.Left, F.Observation.Answer == T.Right {
    typealias Left = AnswerInTrace<T, F>.Left
    typealias Right = T.Right
}

enum ScopedAnswerPreservesQuestion<
    T: ObservationTrace,
    F: ReadingFactors
>: Null
where F.Left.Left == T.Left, F.Observation.Answer == T.Right {
    typealias Left = AnswerInTrace<T, F>.Predicate
    typealias Right = F.Left.Predicate
}

enum ScopedAnswerPreservesAnswer<
    T: ObservationTrace,
    F: ReadingFactors
>: Null
where F.Left.Left == T.Left, F.Observation.Answer == T.Right {
    typealias Left = AnswerInTrace<T, F>.Answer
    typealias Right = F.Left.Answer
}

enum ConstantFamilyAcquiresSecond<T: Null>: Null
where T.Left: Structure {
    typealias First = FirstTableReading<T>
    typealias Acquired = AcquireAnswer<First>
    typealias Learned = AnswerOnRefinement<ConstantSecondFactors<T>, Acquired>
    typealias Left = Learned.Right.Answer
    typealias Right = T.Right
}

typealias QuietConstant = ConstantTable<ExperimentQuiet>
typealias QuietThenSignal = Paired<ExperimentQuiet, ExperimentSignal>
// Two retained answers can coexist and be compared without a uniform verdict.
// The question is identical; the facts originate in different sources.
typealias DisagreeingFacts = Paired<
    FactOf<FirstTableReading<QuietConstant>>,
    FactOf<FirstTableReading<ConstantTable<ExperimentSignal>>>
>
typealias StoredQuiet = ReadRecordedAnswer<DisagreeingFacts.Left>
typealias StoredSignal = ReadRecordedAnswer<DisagreeingFacts.Right>

enum StoredAnswersAreComparable<
    P: HasVerdict,
    Q: HasVerdict
>: ComparedReadings
where P.Sigma == Q.Sigma, P.Encoding == Q.Encoding,
      P.Predicate == Q.Predicate {
    typealias Left = ReadRecordedAnswer<P>
    typealias Right = ReadRecordedAnswer<Q>
}

typealias ComparableDisagreement = StoredAnswersAreComparable<DisagreeingFacts.Left, DisagreeingFacts.Right>
typealias AgreedStoredAnswers = JoinedVerdict<StoredQuiet, ReadRecordedAnswer<FactOf<FirstTableReading<QuietThenSignal>>>>

enum StoredAnswersKeepTheirDifference: Null {
    typealias Left = Paired<StoredQuiet.Answer, StoredSignal.Answer>
    typealias Right = Paired<ExperimentQuiet, ExperimentSignal>
}

typealias SameFirstFact = EqualFirstFacts<QuietConstant, QuietThenSignal>
typealias GenericConstantLearning<T: Null> = ConstantSecondFactors<T>

typealias QuietStart = StartObservations<QuietConstant>
typealias QuietFirst = AppendObservation<QuietStart, FirstTableReading<QuietConstant>>
typealias QuietSecondCertificate = ConstantSecondFromTrace<QuietFirst>
typealias QuietSecondReply = AnswerInTrace<QuietFirst, QuietSecondCertificate>

enum ConstantAnswerAfterOneObservation: Null {
    typealias Left = QuietSecondReply.Answer
    typealias Right = ExperimentQuiet
}

enum OneFactSuppliesTheReading: Null {
    typealias Left = QuietSecondReply.Left
    typealias Right = Paired<Never, FactOf<FirstTableReading<QuietConstant>>>
}

typealias OpenStart = StartObservations<QuietThenSignal>
typealias OpenFirst = AppendObservation<OpenStart, FirstTableReading<QuietThenSignal>>
typealias OpenSecond = AppendObservation<OpenFirst, SecondTableReading<QuietThenSignal>>
typealias OpenSecondCertificate = LastAnswerFromTrace<OpenSecond>
typealias OpenSecondReply = AnswerInTrace<OpenSecond, OpenSecondCertificate>
typealias OldFirstCertificate = LastAnswerFromTrace<OpenFirst>
typealias RetainedFirstCertificate = RetainTraceAnswer<OpenSecond, OldFirstCertificate>
typealias RetainedFirstReply = AnswerInTrace<OpenSecond, RetainedFirstCertificate>

// The publication's first field is its active trace, the second its archive.
// Both branches are accessible, but a published current answer takes its
// source and memory from this root's first field.
typealias PublicationRoot = Paired<OpenFirst, QuietFirst>
typealias PublicationFirst = AnswerInTrace<
    PublicationRoot.Left, LastAnswerFromTrace<PublicationRoot.Left>>
typealias ArchivedFirst = AnswerInTrace<
    PublicationRoot.Right, LastAnswerFromTrace<PublicationRoot.Right>>

enum PublicationAndArchiveCanAgree: Null {
    typealias Left = PublicationFirst.Answer
    typealias Right = ArchivedFirst.Answer
}

// PublicationFirst is the existing decoder, not a new certified wrapper.
enum PublicationUsesRootMemory: Null {
    typealias Left = PublicationFirst.Left
    typealias Right = PublicationRoot.Left.Right
}

#if ACQUISITION_PUBLICATION_USES_ARCHIVE
typealias RejectedArchiveAsCurrent = AnswerInTrace<
    PublicationRoot.Left, LastAnswerFromTrace<PublicationRoot.Right>>
#endif

enum SecondAcquisitionSettlesOpenAnswer: Null {
    typealias Left = OpenSecondReply.Answer
    typealias Right = ExperimentSignal
}

enum SecondAcquisitionPreservesFirst: Null {
    typealias Left = RetainedFirstReply.Answer
    typealias Right = ExperimentQuiet
}

// A new fact's context is irrelevant to reading the actual retained prefix.
// The old source question is retained as a complete reading, not relabelled.
enum RetainedTraceUsesOriginalReading<T: ExtendedObservationTrace, F: ReadingFactors>: Null
where F.Left.Left == T.Left, F.Observation.Answer == T.Previous.Right {
    typealias Left = RetainTraceAnswer<T, F>.Left
    typealias Right = F.Left
}

typealias MixedContextTrace = AppendObservation<
    OpenFirst,
    FirstEvidenceImage<QuietThenSignal, Lit1, Lit1, FirstTableQuestion>
>
typealias MixedRetained = RetainTraceAnswer<MixedContextTrace, OldFirstCertificate>
typealias MixedLatest = LastAnswerFromTrace<MixedContextTrace>

enum MixedTraceKeepsBothContexts: Null {
    typealias Left = Paired<
        Paired<MixedRetained.Right.Sigma, MixedRetained.Right.Encoding>,
        Paired<MixedLatest.Right.Sigma, MixedLatest.Right.Encoding>
    >
    typealias Right = Paired<Paired<Never, Never>, Paired<Lit1, Lit1>>
}

enum MixedTraceAnswersFromOneMemory: Null {
    typealias Old = AnswerInTrace<MixedContextTrace, MixedRetained>
    typealias New = AnswerInTrace<MixedContextTrace, MixedLatest>
    typealias Left = Paired<Paired<Old.Left, New.Left>, Paired<Old.Answer, New.Answer>>
    typealias Right = Paired<
        Paired<MixedContextTrace.Right, MixedContextTrace.Right>,
        Paired<ExperimentQuiet, ExperimentQuiet>
    >
}

#if ACQUISITION_MIXED_CONTEXT_IS_COMPARABLE
enum RejectedMixedComparison: ComparedReadings {
    typealias Left = MixedRetained.Right
    typealias Right = MixedLatest.Right
}
#endif

#if ACQUISITION_RETENTION_OTHER_SOURCE
typealias RejectedRetentionSource = RetainTraceAnswer<MixedContextTrace, QuietSecondCertificate>
#endif

#if ACQUISITION_RETENTION_OTHER_MEMORY
typealias RejectedRetentionMemory = RetainTraceAnswer<MixedContextTrace, OpenSecondCertificate>
#endif

enum TwoRecordsRemainOnReuse: Null {
    typealias Left = RetainedFirstReply.Left
    typealias Right = Paired<Paired<Never, FactOf<FirstTableReading<QuietThenSignal>>>, FactOf<SecondTableReading<QuietThenSignal>>>
}

// A generic second reading refines the first without changing its answer.
enum JointEvidencePreservesFirst<T: Pair>: Null
where T.Left: Structure, T.Right: Structure {
    typealias First = FirstTableReading<T>
    typealias Second = SecondTableReading<T>
    typealias More = JointEvidenceRetainsFirst<First, Second>
    typealias Left = More.Right.Answer
    typealias Right = T.Left
}

#if ACQUISITION_WRONG_FACT_ANSWER
enum RejectedFactAnswer: RetainedReadingRecord {
    typealias Reading = FirstTableReading<QuietThenSignal>
    typealias Left = QuietThenSignal
    typealias Right = Paired<QuietThenSignal, AnswerFact<Never, Never, FirstTableQuestion, ExperimentSignal>>
}
#endif

#if ACQUISITION_FACT_IS_SOURCE_READING
// A payload can be read, but is not itself a reading of an original source.
typealias RejectedFactAsSourceReading = AcquireAnswer<FactOf<FirstTableReading<QuietConstant>>>
#endif

#if ACQUISITION_COEXISTENCE_IS_AGREEMENT
typealias RejectedStoredAgreement = JoinedVerdict<StoredQuiet, StoredSignal>
#endif

#if ACQUISITION_WRONG_FACT_QUESTION
enum RejectedFactQuestion: RetainedReadingRecord {
    typealias Reading = FirstTableReading<QuietConstant>
    typealias Left = QuietConstant
    typealias Right = Paired<QuietConstant, FactOf<SecondTableReading<QuietConstant>>>
}
#endif

#if ACQUISITION_WRONG_FACT_SOURCE
enum RejectedFactSource: RetainedReadingRecord {
    typealias Reading = FirstTableReading<QuietConstant>
    typealias Left = QuietThenSignal
    typealias Right = Paired<QuietThenSignal, FactOf<Reading>>
}
#endif

#if ACQUISITION_UNKNOWN_SECOND_FROM_FIRST
// The generic body must fail: its only source premise is Pair, not Null.
enum RejectedUnmeasuredSecond<T: Pair>: ReadingFactors {
    typealias Left = SecondTableReading<T>
    typealias Observation = FirstTableReading<T>
    typealias Right = ConstantSecondDecoder<T.Left>
    typealias Sigma = Never
    typealias Encoding = Never
    typealias Predicate = SecondTableQuestion
    typealias Answer = T.Left
}
#endif

#if ACQUISITION_WIDENS_CONSTANT_SCOPE
typealias RejectedConstantScope = ConstantSecondFromTrace<OpenFirst>
#endif

#if ACQUISITION_REFINES_OTHER_QUESTION
typealias RejectedRefinementQuestion = RefineAnswer<ConstantSecondFactors<QuietConstant>, AcquireAnswer<SecondTableReading<QuietConstant>>>
#endif

#if ACQUISITION_REFINES_OTHER_SOURCE
typealias RejectedRefinementSource = RefineAnswer<ConstantSecondFactors<QuietConstant>, AcquireAnswer<FirstTableReading<QuietThenSignal>>>
#endif

#if ACQUISITION_TRACE_CHANGES_SOURCE
typealias RejectedTraceSource = AppendObservation<QuietFirst, FirstTableReading<QuietThenSignal>>
#endif

#if ACQUISITION_TRACE_FORGETS_PREFIX
enum RejectedTracePrefix: ExtendedObservationTrace {
    typealias Previous = OpenFirst
    typealias Reading = SecondTableReading<QuietThenSignal>
    typealias Left = QuietThenSignal
    typealias Right = Paired<Never, FactOf<Reading>>
}
#endif

#if ACQUISITION_TRACE_ADDS_NO_FACT
enum RejectedMissingFact: ExtendedObservationTrace {
    typealias Previous = QuietFirst
    typealias Reading = FirstTableReading<QuietConstant>
    typealias Left = QuietConstant
    typealias Right = Previous.Right
}
#endif

#if ACQUISITION_REUSE_ADDS_OBSERVATION
enum RejectedReuseGrowth: Null {
    typealias Left = AnswerInTrace<OpenFirst, OldFirstCertificate>.Left
    typealias Right = OpenSecond.Right
}
#endif

#if ACQUISITION_REUSE_OTHER_MEMORY
typealias RejectedOtherMemory = AnswerInTrace<OpenSecond, OldFirstCertificate>
#endif

#if ACQUISITION_REUSE_OTHER_SOURCE
typealias RejectedOtherSource = AnswerInTrace<OpenFirst, QuietSecondCertificate>
#endif

#if ACQUISITION_REUSE_CHANGES_QUESTION
enum RejectedRepeatedQuestion: Null {
    typealias Left = AnswerInTrace<QuietFirst, QuietSecondCertificate>.Predicate
    typealias Right = FirstTableQuestion
}
#endif
