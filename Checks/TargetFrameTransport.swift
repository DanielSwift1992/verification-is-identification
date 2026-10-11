import VerificationIsIdentification
import Examples

#if !FRAME_SINGLE_TARGET && !FRAME_STALE_PAIR
enum RetainedTargetPairSurvivesTheActualContact<A: Structure, B: Structure,
    R: Structure>: Null {
    typealias P = TargetFrameTransport<TargetFrame<A, B, R>>
    typealias Left = P.Left
    typealias Right = P.Right
}
enum NextTargetIsReadFromTheTransportedPair<A: Structure, B: Structure,
    R: Structure>: Null {
    typealias P = TargetFrameTransport<TargetFrame<A, B, R>>
    typealias Direct = SequentialReading<P.Contact,
        ReadFrameTarget<P.Contact.Answer>>
    typealias Decoded = SequentialReading<P.MemoryPath,
        ReadFrameTarget<P.MemoryPath.Answer>>
    typealias Left = Direct.Answer
    typealias Right = Decoded.Answer
}
enum FrameExchangeHasAnActualReverse<A: Structure, B: Structure,
    R: Structure>: Null {
    typealias S = TargetFrame<A, B, R>
    typealias Once = ExchangeFrameTargets<S>
    typealias Twice = SequentialReading<Once, ExchangeFrameTargets<Once.Answer>>
    typealias Left = Twice.Answer
    typealias Right = S
}
enum UnreadFrameFieldsAreNotNeededForThisOrbit<A: Structure, B: Structure,
    R: Structure, T: Structure>: Null {
    typealias P = TargetFrameTransport<TargetFrame<A, B, R>>
    typealias Q = TargetFrameTransport<TargetFrame<A, B, T>>
    typealias Left = P.MemoryPath.Answer
    typealias Right = Q.MemoryPath.Answer
}
enum EqualCurrentTargetsCanHideDifferentNextTargets: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias C = Examples.Succ<B>
    typealias X = TargetFrame<A, B, C>
    typealias Y = TargetFrame<A, C, B>
    typealias Left = ReadFrameTarget<X>.Answer
    typealias Right = ReadFrameTarget<Y>.Answer
}
#endif

#if FRAME_SINGLE_TARGET
enum RejectedCurrentTargetDeterminesTheTargetAfterFrameChange: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias C = Examples.Succ<B>
    typealias X = ExchangeFrameTargets<TargetFrame<A, B, C>>
    typealias Y = ExchangeFrameTargets<TargetFrame<A, C, B>>
    typealias Left = ReadFrameTarget<X.Answer>.Answer
    typealias Right = ReadFrameTarget<Y.Answer>.Answer
}
#endif

#if FRAME_STALE_PAIR
enum RejectedRetainedPairFromAnotherFrame: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias C = Examples.Succ<B>
    typealias Actual = ReadFrameTargetPair<TargetFrame<A, B, C>>
    typealias Stale = ReadFrameTargetPair<TargetFrame<A, C, B>>
    typealias Invalid = SequentialReading<Actual,
        ExchangeRetainedTargets<Stale.Answer>>
    typealias Left = Invalid.Answer
    typealias Right = Paired<B, A>
}
#endif
