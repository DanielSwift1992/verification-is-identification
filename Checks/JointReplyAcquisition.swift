import VerificationIsIdentification
import Examples

enum JointReplyExample: Close {
    typealias A = RoutingAddress00
    typealias B = RoutingAddress01
    typealias C = RoutingAddress10
    typealias D = RoutingAddress11
    // Forward point tables of W and Z, not their payload-output tables.
    typealias First = JointReplyAcquisition<C, B, D, A, B, A, D, C>
    typealias Decode = PairedReplyWords<First.Memory.Answer,
        Route10<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row2>,
        Route01<FourLeafReplyTable>, Route00<FourLeafReplyTable.Row1>>
    // The same actual common input shift changes both tables.
    typealias Shifted = JointReplyAcquisition<B, C, A, D, A, B, C, D>
    typealias OtherDecode = PairedReplyWords<Shifted.Memory.Answer,
        Route01<FourLeafReplyTable>, Route10<FourLeafReplyTable.Row1>,
        Route00<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row0>>
}

#if !LOCAL_PHASE_JOINT_REPLY_WRONG_LOOKUP && !LOCAL_PHASE_JOINT_REPLY_SAME_PRESENTATION
enum JointReplyActualAcquisition<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, G: Structure, H: Structure>: Null {
    typealias P = JointReplyAcquisition<A, B, C, D, E, F, G, H>
    typealias Left = Paired<P.RecordedPairs.Left, P.CurrentSource.Left>
    typealias Right = Paired<P.RecordedPairs.Right, P.CurrentSource.Right>
}

enum JointReplyActualWords: Null {
    typealias F = JointReplyExample
    typealias Left = Paired<F.Decode.Answer, F.OtherDecode.Answer>
    typealias Right = Paired<Paired<FourLeafLawAddresses.W, FourLeafLawAddresses.Z>,
        Paired<FourLeafLawAddresses.ZW, FourLeafLawAddresses.I>>
}

enum JointReplySourcesAreLinked: Null {
    typealias F = JointReplyExample
    typealias Left = F.First.Change.Right
    typealias Right = F.Shifted.Initial
}

enum JointReplyUsesOnlyAcquiredMemory: Null {
    typealias F = JointReplyExample
    typealias Left = Paired<F.Decode.Left, F.OtherDecode.Left>
    typealias Right = Paired<F.First.Memory.Answer, F.Shifted.Memory.Answer>
}

// Arbitrary changes in the four unmeasured fields do not change the
// decoder's input, including the stored facts' operation addresses.
enum JointReplyMemoryDoesNotCarryHiddenFields<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure,
    G: Structure, H: Structure, I: Structure, J: Structure,
    K: Structure, L: Structure>: Null {
    typealias Left = JointReplyAcquisition<A, B, C, D, E, F, G, H>.Memory.Answer
    typealias Right = JointReplyAcquisition<A, B, I, J, E, F, K, L>.Memory.Answer
}

// The two decoded presentations have one relative effect: W^-1 then Z,
// and (ZW)^-1. The actual paths below prove the second inverse on payloads.
enum JointReplySameRelativeEffect<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias V = PhaseWordCatalogue<A, B, C, D>
    typealias Twice = FollowedPair<V.ZW, PhaseWordCatalogue<C, A, B, D>.ZW>
    typealias Left = Paired<V.WWZ.Left, V.WWZ.Right>
    typealias Right = Paired<Twice.Left, Twice.Right>
}
#endif

#if LOCAL_PHASE_JOINT_REPLY_WRONG_LOOKUP
enum RejectedJointReplyWrongRow: Pair {
    typealias F = JointReplyExample
    typealias Wrong = PairedReplyWords<F.First.Memory.Answer,
        Route00<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row0>,
        Route01<FourLeafReplyTable>, Route00<FourLeafReplyTable.Row1>>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

#if LOCAL_PHASE_JOINT_REPLY_SAME_PRESENTATION
enum RejectedJointReplySamePresentation: Null {
    typealias F = JointReplyExample
    typealias Left = F.Decode.Answer
    typealias Right = F.OtherDecode.Answer
}
#endif
