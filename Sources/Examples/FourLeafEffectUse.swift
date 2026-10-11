import VerificationIsIdentification

/// Representatives for the value question on (A,B,B,B), indexed by the
/// observed destination of input zero. These are actual library addresses.
/// Selecting one does not identify the unknown resident law.
public enum FourLeafEffectRepresentatives: Pair {
    public typealias Left = Paired<FourLeafLawAddresses.I, FourLeafLawAddresses.Z>
    public typealias Right = Paired<FourLeafLawAddresses.W, FourLeafLawAddresses.WW>
}

/// Read one acquired answer beside the supplied representative table.
/// The original source and its unknown law are absent from this input.
public typealias FourLeafEffectDecoder<F: HasVerdict & Structure,
    R: PredicateReading> = SequentialReading<
        ReadingBesideInput<ReadRecordedAnswer<F>, FourLeafEffectRepresentatives>, R>
where F.Answer: Structure, F.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding,
      R.Left == Paired<F.Answer, FourLeafEffectRepresentatives>,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding

/// Reassociate existing fields after the actual first probe. The original
/// world and full decoder table are parked behind the consumer's program.
/// They do not enter the one-fact decoder. Every supplied field is retained.
public enum FourLeafBeginEffect<W: Structure, F: Structure,
    P: Structure, H: Structure>: Pair {
    public typealias Prepared = LocalPhaseWorld<FourLeafCenter, P,
        Paired<FourLeafAddressProgram, Paired<FirstProjection, H>>>
    public typealias Resources = Paired<FourLeafReplyTable,
        Paired<FourLeafEffectRepresentatives, Prepared>>
    public typealias Left = Paired<Paired<W, F>, Resources>
    public typealias Probe = Left.Right.Right.Right
    public typealias Context = Probe.Right.Right
    public typealias Archive = Paired<Left.Left.Left,
        Paired<Left.Right.Left, Context.Right.Right>>
    public typealias NewContext = Paired<Context.Left,
        Paired<Context.Right.Left, Archive>>
    public typealias Right = Paired<Paired<Left.Left.Right, Left.Right.Right.Left>,
        LocalPhaseWorld<Probe.Left, Probe.Right.Left, NewContext>>

    public enum Undo: Pair {
        public typealias Left = FourLeafBeginEffect.Right
        public typealias Probe = Left.Right
        public typealias Context = Probe.Right.Right
        public typealias Archive = Context.Right.Right
        public typealias OldContext = Paired<Context.Left,
            Paired<Context.Right.Left, Archive.Right.Right>>
        public typealias OldProbe = LocalPhaseWorld<Probe.Left, Probe.Right.Left, OldContext>
        public typealias Right = Paired<Paired<Archive.Left, Left.Left.Left>,
            Paired<Archive.Right.Left, Paired<Left.Left.Right, OldProbe>>>
    }
    public enum RestoresInput: Null {
        public typealias Left = Undo.Right
        public typealias Right = FourLeafBeginEffect.Left
    }
}

/// Continue at the actual first acquisition endpoint, install its decoded
/// representative, and expose the consumer's actual word library. Sufficiency is derived
/// by the twelve concrete clauses; it is not an extra premise on this root.
public enum FourLeafOneFactRoot<D: PredicateReading,
    A: Structure, B: Structure, H: Structure,
    W: Structure, T: Structure>: Close
where D.Left == Paired<T, FourLeafEffectRepresentatives>,
      D.Answer: Structure, D.Sigma == BeamSpace,
      D.Encoding == SaturationEncoding {
    public typealias Focus = FourLeafBeginEffect<W, T,
        BoundaryWorking<A, B, B, B>, H>
    public typealias Install = FourLeafInstallLaw<D,
        BoundaryWorking<A, B, B, B>, Focus.Archive>
    public typealias BeforeUse = FollowedPair<Focus, Install>
    public typealias Context = Install.Right.Right.Right
    public typealias Root = FourLeafWordRoot<A, B, B, B, Context>

    public typealias Run<S: CandidateRemoval> = FollowedPair<BeforeUse, Root.Selected<S>>
    where S.Left == Root.Catalogue, S.Right: PredicateReading,
          S.Right.Left == Root.Words.Initial, S.Address == D.Answer,
          S.Right.Sigma == BeamSpace, S.Right.Encoding == SaturationEncoding
}
