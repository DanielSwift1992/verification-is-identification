import VerificationIsIdentification
import Examples

// This generic implication must compile without a further answer equality.
enum ConservedAnswersFollow<Step: ConservedReadingStep>: Null {
    typealias Left = Step.Left.Answer
    typealias Right = Step.Right.Answer
}

// Supplied application records for an explicit two-state interpretation:
// K={y,x}, T(y)=x, T(x)=y, C(y)=C(x)=visible, G={y}.
// These aliases check their addresses; the table is the interpretation.
enum HF9Space {}
enum HF9Encoding {}
enum HF9Swap {}
enum HF9Observation {}
enum HF9Predecessor {}
enum HF9Start {}
enum HF9Visible {}
enum HF9OtherVisible {}
enum HF9Unrelated {}

enum HF9Record<Source, Output, Question>: PredicateReading {
    typealias Left = Source
    typealias Right = Output
    typealias Sigma = HF9Space
    typealias Encoding = HF9Encoding
    typealias Predicate = Question
    typealias Answer = Output
}

enum HF9FixedImage: PredicateReading, Null {
    typealias Left = HF9Visible
    typealias Right = HF9Visible
    typealias Sigma = HF9Space
    typealias Encoding = HF9Encoding
    typealias Predicate = HF9Swap
    typealias Answer = HF9Visible
}

enum HF9ConservedSquare: ConservedReadingStep {
    typealias Left = HF9Record<HF9Predecessor, HF9Visible, HF9Observation>
    typealias Right = HF9Record<HF9Start, HF9Visible, HF9Observation>
    typealias Sigma = HF9Space
    typealias Encoding = HF9Encoding
    typealias Operation = HF9Swap
    typealias SourceStep = HF9Record<HF9Predecessor, HF9Start, HF9Swap>
    typealias ImageStep = HF9FixedImage
}

typealias HF9PredecessorSharesReading = ConservedStepReadings<HF9ConservedSquare>
typealias HF9AnswerEquality = ConservedAnswersFollow<HF9ConservedSquare>

// Boundary control: a genuine commuting square may change the image.
// Its existence does not contradict HF9, whose reading is conserved.
enum HF9ChangingSquare: CommutingTransition {
    typealias Left = HF9Record<HF9Predecessor, HF9Visible, HF9Observation>
    typealias Right = HF9Record<HF9Start, HF9OtherVisible, HF9Observation>
    typealias Sigma = HF9Space
    typealias Encoding = HF9Encoding
    typealias Operation = HF9Swap
    typealias SourceStep = HF9Record<HF9Predecessor, HF9Start, HF9Swap>
    typealias ImageStep = HF9Record<HF9Visible, HF9OtherVisible, HF9Swap>
}

#if HF9_BAD_CONSERVATION
// The same two source states have distinct answers. Claiming conservation
// must fail at the image step's required Null conformance.
enum HF9RejectedConservation: ConservedReadingStep {
    typealias Left = HF9ChangingSquare.Left
    typealias Right = HF9ChangingSquare.Right
    typealias Sigma = HF9Space
    typealias Encoding = HF9Encoding
    typealias Operation = HF9Swap
    typealias SourceStep = HF9ChangingSquare.SourceStep
    typealias ImageStep = HF9ChangingSquare.ImageStep
}
#endif

#if HF9_BAD_PREDECESSOR
// Equal images of the supplied y and x cannot certify an unrelated edge.
// SourceStep.Left must be the source of the left observation.
enum HF9RejectedPredecessor: ConservedReadingStep {
    typealias Left = HF9ConservedSquare.Left
    typealias Right = HF9ConservedSquare.Right
    typealias Sigma = HF9Space
    typealias Encoding = HF9Encoding
    typealias Operation = HF9Swap
    typealias SourceStep = HF9Record<HF9Unrelated, HF9Start, HF9Swap>
    typealias ImageStep = HF9FixedImage
}
#endif
