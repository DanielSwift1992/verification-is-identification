import VerificationIsIdentification

/// Complete finite acquisition for the twelve words of VC100a. Each Run
/// retains the fixed decoder resource beside the actual two-probe path.
/// The direct question is a current-source projection. Its equality with
/// decoding the acquired facts is derived separately for every admitted law.
public enum FourLeafAcquiredLaw: Close {
    public enum I: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.I, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route00<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row0>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = I.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum W: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.W, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route10<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row2>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = W.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum WW: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.WW, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route11<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row3>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = WW.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum Z: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.Z, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route01<FourLeafReplyTable>, Route00<FourLeafReplyTable.Row1>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = Z.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum ZW: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.ZW, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route01<FourLeafReplyTable>, Route10<FourLeafReplyTable.Row1>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = ZW.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum ZWW: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.ZWW, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route01<FourLeafReplyTable>, Route11<FourLeafReplyTable.Row1>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = ZWW.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum WZ: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.WZ, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route11<FourLeafReplyTable>, Route00<FourLeafReplyTable.Row3>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = WZ.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum WZW: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.WZW, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route00<FourLeafReplyTable>, Route10<FourLeafReplyTable.Row0>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = WZW.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum WZWW: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.WZWW, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route10<FourLeafReplyTable>, Route11<FourLeafReplyTable.Row2>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = WZWW.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum WWZ: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.WWZ, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route10<FourLeafReplyTable>, Route00<FourLeafReplyTable.Row2>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = WWZ.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum WWZW: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.WWZW, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route11<FourLeafReplyTable>, Route10<FourLeafReplyTable.Row3>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = WWZW.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
    public enum WWZWW: ReadingFactors {
        public typealias Run = StepBeside<FourLeafTwoProbe.WWZWW, FourLeafReplyTable>
        public typealias Left = FourLeafCurrentLaw<Run.Right>
        public typealias Observation = ExperimentReadingBeside<
            FourLeafInquiryFacts<Run.Right.Left>, FourLeafReplyTable>
        public typealias Right = FourLeafReplyDecoder<Observation.Answer,
            Route00<FourLeafReplyTable>, Route11<FourLeafReplyTable.Row0>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FourLeafResidentLawQuestion
        public typealias Answer = Left.Answer
        public enum RetainedInitialLaw: Null {
            public typealias Left = WWZWW.Answer
            public typealias Right = Run.Left.Left.Right.Right.Right.Left
        }
    }
}

