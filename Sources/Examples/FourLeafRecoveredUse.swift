import VerificationIsIdentification

/// A prepared new probe and the actual acquired decoder input are supplied
/// at the consumer. Record the decoding beside its input, then install that
/// recorded address. The previous facts and fixed decoder table remain present.
public enum FourLeafInstallLaw<D: PredicateReading, P: Structure,
                              R: Structure>: Pair
where D.Left: Structure, D.Answer: Structure,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding {
    public typealias Prepared = LocalPhaseWorld<FourLeafCenter, P,
        Paired<FourLeafAddressProgram, Paired<FirstProjection, R>>>
    public typealias Record = RetainingRecordedReading<D>
    public typealias Decode = PairedApplication<Record,
        IdentityReading<Prepared, BeamSpace, SaturationEncoding>>

    public enum Install: Pair {
        public typealias Left = Decode.Answer
        public typealias Decoded = Left.Left
        public typealias Probe = Left.Right
        public typealias Resources = Probe.Right.Right
        public typealias Lab = Paired<Decoded, Resources.Right.Right>
        public typealias Context = Paired<Resources.Left,
            Paired<Decoded.Right.Answer, Paired<Resources.Right.Left, Lab>>>
        public typealias Right = LocalPhaseWorld<Probe.Left, Probe.Right.Left, Context>
    }

    public typealias Path = FollowedPair<Decode, Install>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
    public enum RetainsEvidence: Null {
        public typealias Left = Install.Lab.Left.Left
        public typealias Right = D.Left
    }
}

/// The new application root takes its law from the actual decoding above.
/// Its admitted S is a path in this root's catalogue; Selected additionally
/// requires S.Address to equal the address installed from the acquired facts.
public enum FourLeafRecoveredRoot<D: PredicateReading, A: Structure,
                                  B: Structure, C: Structure,
                                  E: Structure>: Close
where D.Left: Structure, D.Answer: Structure,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding {
    public typealias Install = FourLeafInstallLaw<D, BoundaryWorking<A, B, C, E>, Never>
    public typealias Context = Install.Right.Right.Right
    public typealias Root = FourLeafWordRoot<A, B, C, E, Context>

    public typealias Run<S: CandidateRemoval> = FollowedPair<Install, Root.Selected<S>>
    where S.Left == Root.Catalogue, S.Right: PredicateReading,
          S.Right.Left == Root.Words.Initial, S.Address == D.Answer,
          S.Right.Sigma == BeamSpace, S.Right.Encoding == SaturationEncoding
}
