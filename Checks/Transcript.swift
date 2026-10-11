import VerificationIsIdentification
import Examples

// No transcript equality is assumed: it follows from the two certified answers.
enum DirectTracesAgree<C: VerdictIsInvariant>: Null
where C.Left.Left: Structure, C.Right.Left: Structure, C.Answer: Structure {
    typealias Left = DirectAnswerRecord<C.Left>.Right.Right
    typealias Right = DirectAnswerRecord<C.Right>.Right.Right
}

enum DirectTraceReturnsAnswer<R: PredicateReading>: Null
where R.Left: Structure, R.Answer: Structure {
    typealias Left = DirectAnswerRecord<R>.Right.Right.Left
    typealias Right = R.Answer
}

enum DirectRecordRetainsSource<R: PredicateReading>: Null
where R.Left: Structure, R.Answer: Structure {
    typealias Left = DirectAnswerRecord<R>.Right.Left
    typealias Right = R.Left
}

// BeamShape's nominal labels need not be Structure. Use its actual encoded
// pair, whose residual carries the different infrared coordinate.
enum StructuralVisibleReading<B: BeamShape>: PredicateReading {
    typealias Left = BeamWithResidual<B>
    typealias Right = EyeImage<B>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = VisibleQuestion
    typealias Answer = EyeImage<B>
}
typealias StructuralVisibleVerdict = JoinedVerdict<StructuralVisibleReading<RedBeam>, StructuralVisibleReading<RedBeamWithIR>>
typealias VisibleTracesAgree = DirectTracesAgree<StructuralVisibleVerdict>
typealias VisibleAnswerReturns = DirectTraceReturnsAnswer<StructuralVisibleReading<RedBeam>>
typealias VisibleSourceRetained = DirectRecordRetainsSource<StructuralVisibleReading<RedBeamWithIR>>

#if TRANSCRIPT_OVERREADS_HIDDEN_FIELD
enum RejectedOverreadingTrace: Null {
    typealias Left = Paired<EyeImage<RedBeam>, RedBeam.PaschenLevel>
    typealias Right = Paired<EyeImage<RedBeamWithIR>, RedBeamWithIR.PaschenLevel>
}
#endif

#if EQUAL_TRACE_MERGES_WHOLE_RECORD
enum RejectedTraceWholeMerger: Null {
    typealias Left = DirectAnswerRecord<StructuralVisibleReading<RedBeam>>.Right
    typealias Right = DirectAnswerRecord<StructuralVisibleReading<RedBeamWithIR>>.Right
}
#endif
