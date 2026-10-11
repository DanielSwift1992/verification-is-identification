import VerificationIsIdentification

/// The twenty-step U cycle in the thirty-state faithful carrier. Every step
/// is one of the actual four contact rows at its source, with exact seams.
public enum FaithfulFourLeafCycle: Null {
    public typealias F = FaithfulFourLeafPhases
    public typealias S0 = F.E.C0
    public typealias S1 = F.E.L02
    public typealias S2 = F.B.L03
    public typealias S3 = F.P.L02
    public typealias S4 = F.A.L00
    public typealias S5 = F.A.C1
    public typealias S6 = F.A.L10
    public typealias S7 = F.E.L12
    public typealias S8 = F.C.L10
    public typealias S9 = F.P.L11
    public typealias S10 = F.P.C2
    public typealias S11 = F.P.L20
    public typealias S12 = F.A.L21
    public typealias S13 = F.Q.L20
    public typealias S14 = F.C.L22
    public typealias S15 = F.C.C3
    public typealias S16 = F.C.L31
    public typealias S17 = F.Q.L32
    public typealias S18 = F.B.L31
    public typealias S19 = F.E.L33
    public typealias Path = FollowedPair<FollowedPair<FollowedPair<FollowedPair<FollowedPair<S0, S1>, S2>, FollowedPair<S3, S4>>, FollowedPair<FollowedPair<FollowedPair<S5, S6>, S7>, FollowedPair<S8, S9>>>, FollowedPair<FollowedPair<FollowedPair<FollowedPair<S10, S11>, S12>, FollowedPair<S13, S14>>, FollowedPair<FollowedPair<FollowedPair<S15, S16>, S17>, FollowedPair<S18, S19>>>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

/// Five disjoint two-cycles complete the same selected U on the ten other
/// states. Each inverse is the same primitive contact at its actual new source.
public enum FaithfulFourLeafRemainder: Close {
    public typealias F = FaithfulFourLeafPhases
    public enum CenterB: Null {
        public typealias Forward = F.B.C1
        public typealias Backward = F.B.L11
        public typealias Path = FollowedPair<Forward, Backward>
        public typealias Left = Path.Left
        public typealias Right = Path.Right
    }
    public enum CenterQ: Null {
        public typealias Forward = F.Q.C1
        public typealias Backward = F.Q.L11
        public typealias Path = FollowedPair<Forward, Backward>
        public typealias Left = Path.Left
        public typealias Right = Path.Right
    }
    public enum Leaf0: Null {
        public typealias Forward = F.C.L02
        public typealias Backward = F.Q.L02
        public typealias Path = FollowedPair<Forward, Backward>
        public typealias Left = Path.Left
        public typealias Right = Path.Right
    }
    public enum Leaf2: Null {
        public typealias Forward = F.E.L20
        public typealias Backward = F.B.L20
        public typealias Path = FollowedPair<Forward, Backward>
        public typealias Left = Path.Left
        public typealias Right = Path.Right
    }
    public enum Leaf3: Null {
        public typealias Forward = F.A.L31
        public typealias Backward = F.P.L31
        public typealias Path = FollowedPair<Forward, Backward>
        public typealias Left = Path.Left
        public typealias Right = Path.Right
    }
}

/// Group the thirty actual U rows by stage and then by the six independently
/// specified phase preparations. SourceCoverage equates that domain with the
/// complete 5×6 product. This does not enlarge it to arbitrary phase tuples.
public enum FaithfulFourLeafWhole: Close {
    public typealias C = FaithfulFourLeafCycle
    public typealias R = FaithfulFourLeafRemainder
    public typealias Rows0 = Paired<Paired<Paired<C.S0, C.S5>, R.CenterB.Forward>, Paired<Paired<C.S15, C.S10>, R.CenterQ.Forward>>
    public typealias Rows1 = Paired<Paired<Paired<C.S1, C.S4>, C.S2>, Paired<Paired<R.Leaf0.Forward, C.S3>, R.Leaf0.Backward>>
    public typealias Rows2 = Paired<Paired<Paired<C.S7, C.S6>, R.CenterB.Backward>, Paired<Paired<C.S8, C.S9>, R.CenterQ.Backward>>
    public typealias Rows3 = Paired<Paired<Paired<R.Leaf2.Forward, C.S12>, R.Leaf2.Backward>, Paired<Paired<C.S14, C.S11>, C.S13>>
    public typealias Rows4 = Paired<Paired<Paired<C.S19, R.Leaf3.Forward>, C.S18>, Paired<Paired<C.S16, R.Leaf3.Backward>, C.S17>>
    public typealias Rows = Paired<Paired<Paired<Rows0, Rows1>, Rows2>, Paired<Rows3, Rows4>>
    public enum SourceCoverage: Null {
        public typealias Left = Paired<Paired<Paired<Paired<Paired<Paired<C.S0.Left, C.S5.Left>, R.CenterB.Forward.Left>, Paired<Paired<C.S15.Left, C.S10.Left>, R.CenterQ.Forward.Left>>, Paired<Paired<Paired<C.S1.Left, C.S4.Left>, C.S2.Left>, Paired<Paired<R.Leaf0.Forward.Left, C.S3.Left>, R.Leaf0.Backward.Left>>>, Paired<Paired<Paired<C.S7.Left, C.S6.Left>, R.CenterB.Backward.Left>, Paired<Paired<C.S8.Left, C.S9.Left>, R.CenterQ.Backward.Left>>>, Paired<Paired<Paired<Paired<R.Leaf2.Forward.Left, C.S12.Left>, R.Leaf2.Backward.Left>, Paired<Paired<C.S14.Left, C.S11.Left>, C.S13.Left>>, Paired<Paired<Paired<C.S19.Left, R.Leaf3.Forward.Left>, C.S18.Left>, Paired<Paired<C.S16.Left, R.Leaf3.Backward.Left>, C.S17.Left>>>>
        public typealias Right = Paired<Paired<Paired<Paired<Paired<Paired<Paired<FourLeafStageLabels<Lit1, Never, Never, Never, Never>, FaithfulFourLeafPhases.E.Phase.Input>, Paired<FourLeafStageLabels<Lit1, Never, Never, Never, Never>, FaithfulFourLeafPhases.A.Phase.Input>>, Paired<FourLeafStageLabels<Lit1, Never, Never, Never, Never>, FaithfulFourLeafPhases.B.Phase.Input>>, Paired<Paired<Paired<FourLeafStageLabels<Lit1, Never, Never, Never, Never>, FaithfulFourLeafPhases.C.Phase.Input>, Paired<FourLeafStageLabels<Lit1, Never, Never, Never, Never>, FaithfulFourLeafPhases.P.Phase.Input>>, Paired<FourLeafStageLabels<Lit1, Never, Never, Never, Never>, FaithfulFourLeafPhases.Q.Phase.Input>>>, Paired<Paired<Paired<Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FaithfulFourLeafPhases.E.Phase.Input>, Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FaithfulFourLeafPhases.A.Phase.Input>>, Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FaithfulFourLeafPhases.B.Phase.Input>>, Paired<Paired<Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FaithfulFourLeafPhases.C.Phase.Input>, Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FaithfulFourLeafPhases.P.Phase.Input>>, Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FaithfulFourLeafPhases.Q.Phase.Input>>>>, Paired<Paired<Paired<Paired<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, FaithfulFourLeafPhases.E.Phase.Input>, Paired<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, FaithfulFourLeafPhases.A.Phase.Input>>, Paired<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, FaithfulFourLeafPhases.B.Phase.Input>>, Paired<Paired<Paired<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, FaithfulFourLeafPhases.C.Phase.Input>, Paired<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, FaithfulFourLeafPhases.P.Phase.Input>>, Paired<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, FaithfulFourLeafPhases.Q.Phase.Input>>>>, Paired<Paired<Paired<Paired<Paired<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, FaithfulFourLeafPhases.E.Phase.Input>, Paired<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, FaithfulFourLeafPhases.A.Phase.Input>>, Paired<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, FaithfulFourLeafPhases.B.Phase.Input>>, Paired<Paired<Paired<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, FaithfulFourLeafPhases.C.Phase.Input>, Paired<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, FaithfulFourLeafPhases.P.Phase.Input>>, Paired<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, FaithfulFourLeafPhases.Q.Phase.Input>>>, Paired<Paired<Paired<Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FaithfulFourLeafPhases.E.Phase.Input>, Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FaithfulFourLeafPhases.A.Phase.Input>>, Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FaithfulFourLeafPhases.B.Phase.Input>>, Paired<Paired<Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FaithfulFourLeafPhases.C.Phase.Input>, Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FaithfulFourLeafPhases.P.Phase.Input>>, Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FaithfulFourLeafPhases.Q.Phase.Input>>>>>
    }
}

