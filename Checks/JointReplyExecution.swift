import VerificationIsIdentification
import Examples

enum JointReplyExecutionInputs: Close {
    typealias A = RoutingAddress00
    typealias B = RoutingAddress01
    typealias C = RoutingAddress10
    typealias D = RoutingAddress11
    typealias First = JointReplyAcquisition<C, B, D, A, B, A, D, C>
    typealias Decode = PairedReplyWords<First.Memory.Answer,
        Route10<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row2>,
        Route01<FourLeafReplyTable>, Route00<FourLeafReplyTable.Row1>>
    typealias Shifted = JointReplyAcquisition<B, C, A, D, A, B, C, D>
    typealias OtherDecode = PairedReplyWords<Shifted.Memory.Answer,
        Route01<FourLeafReplyTable>, Route10<FourLeafReplyTable.Row1>,
        Route00<FourLeafReplyTable>, Route01<FourLeafReplyTable.Row0>>
}

enum JointReplyExecuted<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Close {
    typealias F = JointReplyExecutionInputs
    typealias Begin = JointReplyBegin<F.First.Memory, BoundaryWorking<A, B, C, D>, R>
    typealias Acquired = StepBeside<F.First.Run, Begin.Prepared>
    typealias Prefix = FollowedPair<Acquired, Begin>
    typealias K = Begin.Right.Right.Right
    typealias IR = FourLeafInverseRoot<A, B, C, D, K>
    typealias IP = FirstEvidenceImage<F.Decode.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    typealias First = JointReplySelection<IR, F.Decode, IP, IR.SelectW>
    typealias FR = FourLeafWordRoot<C, B, D, A, K>
    typealias FP = SecondEvidenceImage<F.Decode.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    typealias Second = JointReplySelection<FR, F.Decode, FP, FR.SelectZ>
    typealias Run = FollowedPair<FollowedPair<Prefix, First>, Second>

    typealias OtherBegin = JointReplyBegin<F.Shifted.Memory, BoundaryWorking<A, B, C, D>, R>
    typealias OtherAcquired = StepBeside<F.Shifted.Run, OtherBegin.Prepared>
    typealias OtherPrefix = FollowedPair<OtherAcquired, OtherBegin>
    typealias OtherK = OtherBegin.Right.Right.Right
    typealias OtherIR = FourLeafInverseRoot<A, B, C, D, OtherK>
    typealias OtherIP = FirstEvidenceImage<F.OtherDecode.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    typealias OtherFirst = JointReplySelection<OtherIR, F.OtherDecode, OtherIP, OtherIR.SelectZW>
    typealias OtherFR = FourLeafWordRoot<B, C, A, D, OtherK>
    typealias OtherFP = SecondEvidenceImage<F.OtherDecode.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    typealias OtherSecond = JointReplySelection<OtherFR, F.OtherDecode, OtherFP, OtherFR.SelectI>
    typealias OtherRun = FollowedPair<FollowedPair<OtherPrefix, OtherFirst>, OtherSecond>
}

enum JointReplyFrameInputs: Close {
    typealias F = JointReplyExecutionInputs
    typealias Change = ReplyFrameChange<F.A, F.B, F.C, F.D>
    typealias KeepReplies = StepBeside<StepBeside<StepBeside<Change,
        F.First.Second.Right.Right>, F.First.First.Right.Right>, FourLeafReplyTable>
    typealias Changed = FollowedPair<F.First.Run, KeepReplies>
    typealias Memory = RetainedJointReplyMemory<Changed.Right>
}

enum JointReplyReframed<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Close {
    typealias F = JointReplyExecutionInputs
    typealias Change = JointReplyFrameInputs.Change
    typealias Changed = JointReplyFrameInputs.Changed
    typealias Memory = JointReplyFrameInputs.Memory
    typealias Begin = JointReplyBegin<Memory, BoundaryWorking<A, B, C, D>, R>
    typealias Prefix = FollowedPair<StepBeside<Changed, Begin.Prepared>, Begin>
    typealias K = Begin.Right.Right.Right
    typealias Enter = ReplyWorkingFrame<A, B, C, D, K>
    typealias IP = FirstEvidenceImage<F.Decode.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    typealias FP = SecondEvidenceImage<F.Decode.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    typealias IR = FourLeafInverseRoot<B, A, C, D, K>
    typealias First = JointReplySelection<IR, F.Decode, IP, IR.SelectW>
    typealias FR = FourLeafWordRoot<C, A, D, B, K>
    typealias Second = JointReplySelection<FR, F.Decode, FP, FR.SelectZ>
    typealias Leave = ReplyWorkingFrame<A, C, B, D, K>
    typealias Action = FollowedPair<FollowedPair<FollowedPair<Enter, First>, Second>, Leave>
    typealias Run = FollowedPair<Prefix, Action>

    // A different actuator frame k=H D is equally sufficient for this D.
    // Its entry is H then D^-1; exit is D then H. The same acquired policy
    // runs between them, and never reads which frame was installed.
    typealias ExtraEntry = FourLeafJointCatalogue<B, A, C, D, K>.ZW
    typealias OtherIR = FourLeafInverseRoot<C, B, A, D, K>
    typealias OtherFirst = JointReplySelection<OtherIR, F.Decode, IP, OtherIR.SelectW>
    typealias OtherFR = FourLeafWordRoot<A, B, D, C, K>
    typealias OtherSecond = JointReplySelection<OtherFR, F.Decode, FP, OtherFR.SelectZ>
    typealias ExtraExit = FourLeafJointCatalogue<B, A, C, D, K>.WWZ
    typealias OtherAction = FollowedPair<FollowedPair<FollowedPair<
        FollowedPair<FollowedPair<Enter, ExtraEntry>, OtherFirst>, OtherSecond>, ExtraExit>, Leave>
    typealias OtherRun = FollowedPair<Prefix, OtherAction>
}

#if !LOCAL_PHASE_REPLY_EXECUTION_INVERSE_SELECTION && !LOCAL_PHASE_REPLY_EXECUTION_OLD_WORKING && !LOCAL_PHASE_REPLY_EXECUTION_FORWARD_AS_INVERSE && !LOCAL_PHASE_REPLY_FRAME_UNCHANGED_ACTION && !LOCAL_PHASE_REPLY_FRAME_SAME_TRANSPORT
enum JointReplyInverseCalibration<A: Structure, B: Structure, C: Structure,
    D: Structure, K: Structure>: Null {
    typealias T = FourLeafInverseCalibration<A, B, C, D, K>
    typealias Root = FourLeafInverseRoot<A, B, C, D, K>
    typealias Left = Paired<T.Left, Paired<Root.AddressesMatch.Left, Root.LibraryMatches.Left>>
    typealias Right = Paired<T.Right, Paired<Root.AddressesMatch.Right, Root.LibraryMatches.Right>>
}

enum JointReplyCompleteApplication<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias E = JointReplyExecuted<A, B, C, D, R>
    typealias Left = Paired<E.Run.Right, E.OtherRun.Right>
    typealias Right = Paired<
        LocalPhaseWorld<FourLeafCenter, BoundaryWorking<B, C, A, D>, E.K>,
        LocalPhaseWorld<FourLeafCenter, BoundaryWorking<B, C, A, D>, E.OtherK>>
}

enum JointReplyApplicationRetainsAcquisition<A: Structure, B: Structure,
    C: Structure, D: Structure, R: Structure>: Null {
    typealias E = JointReplyExecuted<A, B, C, D, R>
    typealias FirstArchive = E.Run.Right.Right.Right.Right.Right
    typealias SecondArchive = E.OtherRun.Right.Right.Right.Right.Right
    typealias Left = Paired<Paired<FirstArchive.Left.Left, FirstArchive.Right>,
        Paired<SecondArchive.Left.Left, SecondArchive.Right>>
    typealias Right = Paired<Paired<E.F.First.Run.Right, R>, Paired<E.F.Shifted.Run.Right, R>>
}

// This current input position was not one of the two acquired probes.
// Its first channel returns 0, its second returns 2. A fresh marker at 0
// is sent to 2 by the acquired policy, matching those independent fields.
enum JointReplyPredictsUnmeasuredContact: Null {
    typealias E = JointReplyExecuted<Lit1, Never, Never, Never, Never>
    typealias Current = E.F.First.Change.Right
    typealias Left = Paired<Paired<Current.Left.Right.Left, Current.Right.Right.Left>,
        Paired<E.Run.Left.Right.Right.Left, E.Run.Right.Right.Left>>
    typealias Right = Paired<Paired<FourLeafMarked0.Answer, FourLeafMarked2.Answer>,
        Paired<FourLeafMarked0.Left, FourLeafMarked2.Left>>
}

enum JointReplyFramePreservesOldMemory<A: Structure, B: Structure,
    C: Structure, D: Structure, R: Structure>: Null {
    typealias E = JointReplyReframed<A, B, C, D, R>
    typealias Left = Paired<E.Memory.Answer, E.Change.Return.Left>
    typealias Right = Paired<E.F.Decode.Left, E.Change.Return.Right>
}

enum JointReplyCoordinatedFrames<A: Structure, B: Structure,
    C: Structure, D: Structure, R: Structure>: Null {
    typealias E = JointReplyReframed<A, B, C, D, R>
    typealias Left = Paired<E.Run.Right, E.OtherRun.Right>
    typealias Answer = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<C, A, B, D>, E.K>
    typealias Right = Paired<Answer, Answer>
}

// No current observation was added to the decoder. The changed current
// channels at an unmeasured input now say 1→2, which the old memory plus
// the coordinated actuator correctly applies to a fresh marker at 1.
enum JointReplyPredictsAfterFrameChange: Null {
    typealias E = JointReplyReframed<Never, Lit1, Never, Never, Never>
    typealias Current = E.Change.Right
    typealias Left = Paired<Paired<Current.Left.Right.Left, Current.Right.Right.Left>,
        Paired<E.Run.Left.Right.Right.Left, E.Run.Right.Right.Left>>
    typealias Right = Paired<Paired<FourLeafMarked1.Answer, FourLeafMarked2.Answer>,
        Paired<FourLeafMarked1.Left, FourLeafMarked2.Left>>
}
#endif

#if LOCAL_PHASE_REPLY_EXECUTION_INVERSE_SELECTION
enum RejectedReplyInverseSelection<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Pair {
    typealias E = JointReplyExecuted<A, B, C, D, R>
    typealias Wrong = JointReplySelection<E.IR, E.F.Decode, E.IP, E.IR.SelectWW>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

#if LOCAL_PHASE_REPLY_EXECUTION_OLD_WORKING
enum RejectedReplyOldWorking<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Pair {
    typealias E = JointReplyExecuted<A, B, C, D, R>
    typealias Old = FourLeafWordRoot<A, B, C, D, E.K>
    typealias Second = JointReplySelection<Old, E.F.Decode, E.FP, Old.SelectZ>
    typealias Wrong = FollowedPair<E.First, Second>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

#if LOCAL_PHASE_REPLY_EXECUTION_FORWARD_AS_INVERSE
enum RejectedReplyForwardAsInverse<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Null {
    typealias E = JointReplyExecuted<A, B, C, D, R>
    typealias WrongRoot = FourLeafWordRoot<A, B, C, D, E.K>
    typealias First = JointReplySelection<WrongRoot, E.F.Decode, E.IP, WrongRoot.SelectW>
    typealias Next = FourLeafWordRoot<D, B, A, C, E.K>
    typealias Second = JointReplySelection<Next, E.F.Decode, E.FP, Next.SelectZ>
    typealias Wrong = FollowedPair<First, Second>
    typealias Left = Wrong.Right.Right.Left
    typealias Right = BoundaryWorking<B, C, A, D>
}
#endif

#if LOCAL_PHASE_REPLY_FRAME_UNCHANGED_ACTION
enum RejectedReplyUnchangedActuator<A: Structure, B: Structure,
    C: Structure, D: Structure, R: Structure>: Null {
    typealias E = JointReplyReframed<A, B, C, D, R>
    typealias IR = FourLeafInverseRoot<A, B, C, D, E.K>
    typealias First = JointReplySelection<IR, E.F.Decode, E.IP, IR.SelectW>
    typealias FR = FourLeafWordRoot<C, B, D, A, E.K>
    typealias Second = JointReplySelection<FR, E.F.Decode, E.FP, FR.SelectZ>
    typealias Wrong = FollowedPair<First, Second>
    typealias Left = Wrong.Right
    typealias Right = E.Action.Right
}
#endif

#if LOCAL_PHASE_REPLY_FRAME_SAME_TRANSPORT
enum RejectedReplySameActuatorFrame<A: Structure, B: Structure,
    C: Structure, D: Structure, R: Structure>: Null {
    typealias E = JointReplyReframed<A, B, C, D, R>
    typealias Left = E.Enter.Right
    typealias Right = FollowedPair<E.Enter, E.ExtraEntry>.Right
}
#endif
