import VerificationIsIdentification

/// The marked position is a working state, not an observer's phase label.
/// The known center preparation remains inside the source of each word.
public typealias FourLeafCenter = FourLeafStageLabels<Lit1, Never, Never, Never, Never>
public typealias FourLeafPhaseMark0 = BoundaryWorking<Lit1, Never, Never, Never>
public typealias FourLeafPhaseMark1 = BoundaryWorking<Never, Lit1, Never, Never>
public typealias FourLeafPhaseMark2 = BoundaryWorking<Never, Never, Lit1, Never>
public typealias FourLeafPhaseMark3 = BoundaryWorking<Never, Never, Never, Lit1>

/// Z executes the same named contact on stage and phase at each of its six
/// boundaries. Grouping all stage actions separately from all phase actions
/// would have the same endpoint, but is not the path presented here.
public enum FourLeafJointZ<A: Structure, B: Structure, C: Structure,
                           D: Structure, K: Structure>: PredicateReading {
    public typealias Stage = FourLeafShortStageWord<Lit1, Never, Never, Never, Never>
    public typealias Phase = FourLeafShortPhaseWord<A, B, C, D>
    public typealias S0 = PairedApplication<Stage.S0, ExperimentReadingBeside<Phase.S0, K>>
    public typealias S1 = PairedApplication<Stage.S1, ExperimentReadingBeside<Phase.S1, K>>
    public typealias S2 = PairedApplication<Stage.S2, ExperimentReadingBeside<Phase.S2, K>>
    public typealias S3 = PairedApplication<Stage.S3, ExperimentReadingBeside<Phase.S3, K>>
    public typealias S4 = PairedApplication<Stage.S4, ExperimentReadingBeside<Phase.S4, K>>
    public typealias S5 = PairedApplication<Stage.S5, ExperimentReadingBeside<Phase.S5, K>>
    public typealias Path = FollowedPair<
        FollowedPair<FollowedPair<S0, S1>, FollowedPair<S2, S3>>, FollowedPair<S4, S5>>
    public typealias Left = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<A, B, C, D>, K>
    public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<B, A, D, C>, K>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Path.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<FourLeafJointZ.Left, FourLeafJointZ.Right>
        public typealias Right = Paired<Path.Left, Path.Answer>
    }
}

/// W likewise retains twelve actual coupled contacts. K is unchanged beside
/// each phase action and may include the law, prepared instruments and past.
/// This supplies a static path; executing it needs its resident instruction
/// sequence, rather than an outside command index or a free change of law.
public enum FourLeafJointW<A: Structure, B: Structure, C: Structure,
                           D: Structure, K: Structure>: PredicateReading {
    public typealias Stage = FourLeafStageWord<Lit1, Never, Never, Never, Never>
    public typealias Phase = FourLeafPhaseWord<A, B, C, D>
    public typealias S0 = PairedApplication<Stage.S0, ExperimentReadingBeside<Phase.S0, K>>
    public typealias S1 = PairedApplication<Stage.S1, ExperimentReadingBeside<Phase.S1, K>>
    public typealias S2 = PairedApplication<Stage.S2, ExperimentReadingBeside<Phase.S2, K>>
    public typealias S3 = PairedApplication<Stage.S3, ExperimentReadingBeside<Phase.S3, K>>
    public typealias S4 = PairedApplication<Stage.S4, ExperimentReadingBeside<Phase.S4, K>>
    public typealias S5 = PairedApplication<Stage.S5, ExperimentReadingBeside<Phase.S5, K>>
    public typealias S6 = PairedApplication<Stage.S6, ExperimentReadingBeside<Phase.S6, K>>
    public typealias S7 = PairedApplication<Stage.S7, ExperimentReadingBeside<Phase.S7, K>>
    public typealias S8 = PairedApplication<Stage.S8, ExperimentReadingBeside<Phase.S8, K>>
    public typealias S9 = PairedApplication<Stage.S9, ExperimentReadingBeside<Phase.S9, K>>
    public typealias S10 = PairedApplication<Stage.S10, ExperimentReadingBeside<Phase.S10, K>>
    public typealias S11 = PairedApplication<Stage.S11, ExperimentReadingBeside<Phase.S11, K>>
    public typealias First = FollowedPair<FollowedPair<S0, S1>, S2>
    public typealias Second = FollowedPair<FollowedPair<S3, S4>, S5>
    public typealias Third = FollowedPair<FollowedPair<S6, S7>, S8>
    public typealias Fourth = FollowedPair<FollowedPair<S9, S10>, S11>
    public typealias Path = FollowedPair<FollowedPair<First, Second>, FollowedPair<Third, Fourth>>
    public typealias Left = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<A, B, C, D>, K>
    public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<D, B, A, C>, K>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Path.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<FourLeafJointW.Left, FourLeafJointW.Right>
        public typealias Right = Paired<Path.Left, Path.Answer>
    }
}

/// The same twelve words on the coupled carrier. No independently supplied
/// stage and phase words are paired after their endpoints happen to agree.
public enum FourLeafJointCatalogue<A: Structure, B: Structure, C: Structure,
                                   D: Structure, K: Structure>: Close {
    public typealias Initial = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<A, B, C, D>, K>
    public typealias I = IdentityReading<Initial, BeamSpace, SaturationEncoding>
    public typealias W = FourLeafJointW<A, B, C, D, K>
    public typealias Z = FourLeafJointZ<A, B, C, D, K>

    // Each reusable word has a compact interface and its actual composition.
    // Endpoints derives that interface generically. A caller does not unfold
    // every contact merely to carry the operation as a catalogue member.
    public enum WW: PredicateReading {
        public typealias Actual = FollowedPair<W, FourLeafJointW<D, B, A, C, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<C, B, D, A>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<WW.Left, WW.Right>
        }
    }
    public enum ZW: PredicateReading {
        public typealias Actual = FollowedPair<Z, FourLeafJointW<B, A, D, C, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<C, A, B, D>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<ZW.Left, ZW.Right>
        }
    }
    public enum ZWW: PredicateReading {
        public typealias Actual = FollowedPair<ZW, FourLeafJointW<C, A, B, D, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<D, A, C, B>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<ZWW.Left, ZWW.Right>
        }
    }
    public enum WZ: PredicateReading {
        public typealias Actual = FollowedPair<W, FourLeafJointZ<D, B, A, C, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<B, D, C, A>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<WZ.Left, WZ.Right>
        }
    }
    public enum WZW: PredicateReading {
        public typealias Actual = FollowedPair<WZ, FourLeafJointW<B, D, C, A, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<A, D, B, C>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<WZW.Left, WZW.Right>
        }
    }
    public enum WZWW: PredicateReading {
        public typealias Actual = FollowedPair<WZW, FourLeafJointW<A, D, B, C, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<C, D, A, B>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<WZWW.Left, WZWW.Right>
        }
    }
    public enum WWZ: PredicateReading {
        public typealias Actual = FollowedPair<WW, FourLeafJointZ<C, B, D, A, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<B, C, A, D>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<WWZ.Left, WWZ.Right>
        }
    }
    public enum WWZW: PredicateReading {
        public typealias Actual = FollowedPair<WWZ, FourLeafJointW<B, C, A, D, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<D, C, B, A>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<WWZW.Left, WWZW.Right>
        }
    }
    public enum WWZWW: PredicateReading {
        public typealias Actual = FollowedPair<WWZW, FourLeafJointW<D, C, B, A, K>>
        public typealias Left = Initial
        public typealias Right = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<A, C, D, B>, K>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoints: Null {
            public typealias Left = Paired<Actual.Left, Actual.Answer>
            public typealias Right = Paired<WWZWW.Left, WWZWW.Right>
        }
    }
}
