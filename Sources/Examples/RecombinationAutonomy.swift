import VerificationIsIdentification

/// A source is a node of one supplied contact graph: Left is its successor,
/// Right its current reading. These are two actual paths from that node.
public enum PresentAndNext<N: Pair>: Close
where N.Left: Pair, N.Right: Structure, N.Left.Right: Structure {
    public typealias Step = FirstEvidenceImage<N, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Present = SecondEvidenceImage<N, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias AtNext = SecondEvidenceImage<N.Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Next = SequentialReading<Step, AtNext>
    public typealias Joint = JointEvidence<Present, Next>
    public enum Endpoint: Null {
        public typealias Left = Joint.Answer
        public typealias Right = Paired<N.Right, N.Left.Right>
    }
}

/// The three addressed readings are obtained by iterating one actual Left
/// contact. A declared cycle length is not used to manufacture the third.
public enum ThreeContactObservation<N: Pair>: Close
where N.Left: Pair, N.Left.Left: Pair, N.Right: Structure,
      N.Left.Right: Structure, N.Left.Left.Right: Structure {
    public typealias First = PresentAndNext<N>
    public typealias SecondStep = FirstEvidenceImage<N.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Twice = SequentialReading<First.Step, SecondStep>
    public typealias Third = SequentialReading<Twice,
        SecondEvidenceImage<N.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Reading = JointEvidence<First.Present, JointEvidence<First.Next, Third>>
}

/// Only the reading returns after three contacts. The complete source need
/// not return. That one addressed relation derives the cyclic update of the
/// three-reading frame; autonomy of the current reading is never requested.
public enum ThreeReadingReturnFrame<N: Pair>: Null
where N.Left: Pair, N.Left.Left: Pair, N.Left.Left.Left: Pair,
      N.Right: Structure, N.Left.Right: Structure, N.Left.Left.Right: Structure,
      N.Left.Left.Left.Right == N.Right {
    public typealias Before = ThreeContactObservation<N>
    public typealias After = ThreeContactObservation<N.Left>
    public typealias Actual = SequentialReading<Before.First.Step, After.Reading>
    public typealias Rotate = TripleFrameMaps<Before.Reading.Answer>.F120
    public typealias Left = Actual.Answer
    public typealias Right = Rotate.Answer
}

/// One three-cycle and one fixed node. The current reading is (A,A,B,B).
/// Distinct A/B give the four temporal pairs AA, AB, BA, BB. The graph is
/// finite and reversible by construction; its current reading is not an
/// autonomous binary state. LQ18 proves the obstruction for every binary cut.
public enum ThreeCycleWithFixed<A: Structure, B: Structure>: Close {
    public enum P: Pair {
        public typealias Left = Q
        public typealias Right = A
    }
    public enum Q: Pair {
        public typealias Left = R
        public typealias Right = A
    }
    public enum R: Pair {
        public typealias Left = P
        public typealias Right = B
    }
    public enum F: Pair {
        public typealias Left = F
        public typealias Right = B
    }
    public enum AllReturns: Null {
        public typealias Left = Paired<Paired<P.Left.Left.Left, Q.Left.Left.Left>,
            Paired<R.Left.Left.Left, F.Left.Left.Left>>
        public typealias Right = Paired<Paired<P, Q>, Paired<R, F>>
    }
    public enum TemporalTable: Null {
        public typealias Left = Paired<Paired<PresentAndNext<P>.Joint.Answer,
            PresentAndNext<Q>.Joint.Answer>, Paired<PresentAndNext<R>.Joint.Answer,
            PresentAndNext<F>.Joint.Answer>>
        public typealias Right = Paired<Paired<Paired<A, A>, Paired<A, B>>,
            Paired<Paired<B, A>, Paired<B, B>>>
    }
    public enum FirstChannelContrast: Null {
        public typealias Left = Paired<Paired<P.Right, Q.Right>, Paired<P.Left.Right, Q.Left.Right>>
        public typealias Right = Paired<Paired<A, A>, Paired<A, B>>
    }
    public enum SecondChannelContrast: Null {
        public typealias Left = Paired<Paired<P.Left.Right, R.Left.Right>,
            Paired<P.Left.Left.Right, R.Left.Left.Right>>
        public typealias Right = Paired<Paired<A, A>, Paired<B, A>>
    }
}

/// Record the current answer, take the actual contact, record its answer,
/// and take the same contact twice more. The supplied three-step relation
/// returns the working source. The two acquired facts and old memory stay.
/// No current-channel autonomy is required by this constructor.
public enum RecordThreeCycle<N: Pair, H: Structure>: Close
where N.Left: Pair, N.Left.Left: Pair, N.Left.Left.Left == N,
      N.Right: Structure, N.Left.Right: Structure {
    public typealias Views = PresentAndNext<N>
    public typealias Root = Paired<N, H>
    public typealias First = ArchiveProfileRead<Root, Views.Present>
    public typealias F0 = FactOf<Views.Present>
    public typealias F1 = FactOf<Views.AtNext>
    public typealias M0 = Paired<H, F0>
    public typealias Move = StepBeside<Views.Step, M0>
    public typealias Second = ArchiveProfileRead<Move.Right, Views.AtNext>
    public typealias Memory = Paired<M0, F1>
    public typealias Step2 = FirstEvidenceImage<N.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Step3 = FirstEvidenceImage<N.Left.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Back2 = StepBeside<Step2, Memory>
    public typealias Back3 = StepBeside<Step3, Memory>
    public typealias Actual = FollowedPair<FollowedPair<FollowedPair<FollowedPair<First, Move>,
        Second>, Back2>, Back3>
    public typealias Result = Paired<N, Memory>
    public typealias Saved = SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Earlier = SequentialReading<Saved,
        FirstEvidenceImage<Memory, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Fact0 = SequentialReading<Earlier,
        SecondEvidenceImage<M0, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Fact1 = SequentialReading<Saved,
        SecondEvidenceImage<Memory, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Facts = JointEvidence<Fact0, Fact1>
    public typealias Decoder = TwoRecordedAnswers<Paired<F0, F1>>
    public typealias Decoded = SequentialReading<Facts, Decoder>
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, Result>
    }
    public enum FactsRecoverTheTemporalPair: Null {
        public typealias Left = Decoded.Answer
        public typealias Right = Views.Joint.Answer
    }
    public enum OnlyTheFactsEnterTheDecoder: Null {
        public typealias Left = Facts.Answer
        public typealias Right = Decoder.Left
    }
}

/// Transport the reading to the next node through the actual inverse U².
/// Its pullback equals the old answer. This constructs a changed reading;
/// it does not establish that the stationary Right reading is preserved.
public enum TransportThreeCycleReading<N: Pair>: Close
where N.Left: Pair, N.Left.Left: Pair, N.Left.Left.Left == N,
      N.Right: Structure, N.Left.Right: Structure {
    public typealias Old = PresentAndNext<N>
    public typealias Step2 = FirstEvidenceImage<N.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Step3 = FirstEvidenceImage<N.Left.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Inverse = SequentialReading<Step2, Step3>
    public typealias Transported = SequentialReading<Inverse, Old.Present>
    public typealias Pullback = SequentialReading<Old.Step, Transported>
    public enum AnswerReturns: Null {
        public typealias Left = Pullback.Answer
        public typealias Right = Old.Present.Answer
    }
}
