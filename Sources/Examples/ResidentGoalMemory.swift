import VerificationIsIdentification

// A finite classical monitor of acquired replies. These are symbolic states
// of the controller, not descriptions of the retained quantum service.
public protocol ResidentHistoryShape: Open {
    associatedtype Relative: QuantumBit
    associatedtype First: QuantumBit
    associatedtype Last: QuantumBit
    associatedtype Different: QuantumBit
    associatedtype Reply0: ResidentHistoryShape
    associatedtype Reply1: ResidentHistoryShape
}

public enum ResidentHistoryLast0<R: QuantumBit, F: QuantumBit>: Close, ResidentHistoryShape {
    public typealias Relative = R
    public typealias First = F
    public typealias Last = QBit0
    public typealias Different = F
    public typealias Reply0 = ResidentHistoryLast0<R.Flipped, F>
    public typealias Reply1 = ResidentHistoryLast1<R, F>
}

public enum ResidentHistoryLast1<R: QuantumBit, F: QuantumBit>: Close, ResidentHistoryShape {
    public typealias Relative = R
    public typealias First = F
    public typealias Last = QBit1
    public typealias Different = F.Flipped
    public typealias Reply0 = ResidentHistoryLast0<R.Flipped, F>
    public typealias Reply1 = ResidentHistoryLast1<R, F>
}

// The second field selects the same recipient operation I/Z in all goals.
// The question is fixed before saturation; the builder must preserve it.
public typealias ResidentContinueQuestion<S: ResidentHistoryShape> = Paired<S.Relative, QBit0>
public typealias ResidentFirstQuestion<S: ResidentHistoryShape> = Paired<S.Relative, S.First>
public typealias ResidentAgreementQuestion<S: ResidentHistoryShape> = Paired<S.Relative, S.Different>

public enum ResidentGoalMemoryRoot: Close {
    public typealias Source = ResidentRawReplyRoot
    public typealias Recipient = Paired<QI, QZ>
    // These monitor states are obtained after the first actual Install and
    // source tick. No caller supplies an unknown first reply to the executor.
    public typealias Acquired0 = ResidentHistoryLast0<Source.Interpreter.At0.Right.Right, Source.Acquired0>
    public typealias Acquired1 = ResidentHistoryLast1<Source.Interpreter.At1.Right.Right, Source.Acquired1>
}
