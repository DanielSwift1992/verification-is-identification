import VerificationIsIdentification
import Examples

enum RSAnswersFollow<R: RootedRecordReadings>: Null {
    typealias Left = R.Left.Right.Answer
    typealias Right = R.Right.Right.Answer
}

enum RSSourcesFollow<R: RootedRecordReadings>: Null {
    typealias Left = R.Left.Left.Left
    typealias Right = R.Right.Left.Left
}

enum RSSpace {}
enum RSEncoding {}
enum RSPayloadQuestion {}
enum RSObservationQuestion {}
enum RSTransferQuestion {}
enum RSCurrentRevision {}
enum RSArchiveRevision {}
enum RSDocumentFormat {}
enum RSAuditFormat {}
enum RSPayload {}
enum RSWrongAnswer {}

enum RSPair<A, B>: Pair {
    typealias Left = A
    typealias Right = B
}

enum RSReading<Source, Image, Question>: PredicateReading {
    typealias Left = Source
    typealias Right = Image
    typealias Sigma = RSSpace
    typealias Encoding = RSEncoding
    typealias Predicate = Question
    typealias Answer = Image
}

enum RSPayloadAt<S: Pair>: PredicateReading {
    typealias Left = S
    typealias Right = S.Left
    typealias Sigma = RSSpace
    typealias Encoding = RSEncoding
    typealias Predicate = RSPayloadQuestion
    typealias Answer = Right
}

enum RSObservation<S: Pair, Format>: PredicateReading {
    typealias Left = S
    typealias Right = RSPair<S.Left, Format>
    typealias Sigma = RSSpace
    typealias Encoding = RSEncoding
    typealias Predicate = RSObservationQuestion
    typealias Answer = Right
}

// Each representation has its own source address. Both supplied formulas
// retain the independently requested payload reading.
enum RSRoute<S: Pair, Format>: ReadingFactors {
    typealias Left = RSPayloadAt<S>
    typealias Observation = RSObservation<S, Format>
    typealias Right = RSPayloadAt<Observation.Answer>
    typealias Sigma = RSSpace
    typealias Encoding = RSEncoding
    typealias Predicate = RSPayloadQuestion
    typealias Answer = Left.Answer
}

// This provided transfer has the actual active and archive addresses as ends.
// Its scope includes the required payload correspondence. It does not infer
// that correspondence from two equal-labelled records.
enum RSArchiveRoute<Whole: Pair>: ReadingFactors
where Whole.Left: Pair, Whole.Right: Pair,
      Whole.Left.Left == Whole.Right.Left {
    typealias Left = RSPayloadAt<Whole.Left>
    typealias Observation = RSReading<Whole.Left, Whole.Right, RSTransferQuestion>
    typealias Right = RSPayloadAt<Whole.Right>
    typealias Sigma = RSSpace
    typealias Encoding = RSEncoding
    typealias Predicate = RSPayloadQuestion
    typealias Answer = Left.Answer
}

typealias RSCurrent = RSPair<RSPayload, RSCurrentRevision>
typealias RSArchive = RSPair<RSPayload, RSArchiveRevision>
typealias RSRoot = RSPair<RSCurrent, RSArchive>
typealias RSRequested = RSPayloadAt<RSRoot.Left>
typealias RSCurrentRoutes = RecordRoutes<
    RSRoot, RSRequested,
    RSRoute<RSCurrent, RSDocumentFormat>,
    RSRoute<RSCurrent, RSAuditFormat>
>
typealias RSCurrentResults = RecordReadingResults<RSCurrentRoutes>
typealias RSCurrentEquality = RSAnswersFollow<RSCurrentRoutes>
typealias RSCurrentSourceEquality = RSSourcesFollow<RSCurrentRoutes>

// Archive reuse is allowed when the actual current-source transfer is supplied.
typealias RSReusedArchive = RecordRoutes<
    RSRoot, RSRequested,
    RSArchiveRoute<RSRoot>,
    RSRoute<RSCurrent, RSAuditFormat>
>
typealias RSReusedResults = RecordReadingResults<RSReusedArchive>

#if RS_BAD_ARCHIVE
// The scalar answer stays the same, but the independent request moved to archive.
enum RSRejectedArchive: RootedRecordReadings {
    typealias Root = RSRoot
    typealias Reference = RSPayloadAt<RSArchive>
    typealias Left = RSRoute<RSArchive, RSDocumentFormat>
    typealias Right = RSRoute<RSArchive, RSAuditFormat>
}
#endif

#if RS_BAD_REFERENCE
// One route answers the active source and the other the archived source.
enum RSRejectedReference: RootedRecordReadings {
    typealias Root = RSRoot
    typealias Reference = RSRequested
    typealias Left = RSRoute<RSCurrent, RSDocumentFormat>
    typealias Right = RSRoute<RSArchive, RSAuditFormat>
}
#endif

#if RS_BAD_ANSWER
// The representation and question labels match; the supplied decoder is wrong.
enum RSRejectedAnswer: ReadingFactors {
    typealias Left = RSRequested
    typealias Observation = RSObservation<RSCurrent, RSDocumentFormat>
    typealias Right = RSReading<Observation.Answer, RSWrongAnswer, RSPayloadQuestion>
    typealias Sigma = RSSpace
    typealias Encoding = RSEncoding
    typealias Predicate = RSPayloadQuestion
    typealias Answer = Left.Answer
}
#endif

#if RS_BAD_SOURCE_INFERENCE
// Equal payload readings do not identify the current and archive records.
enum RSRejectedSourceInference: Null {
    typealias Left = RSCurrent
    typealias Right = RSArchive
}
#endif
