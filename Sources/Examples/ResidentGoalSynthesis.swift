import VerificationIsIdentification

// A requested binary question on the existing eight monitor states.
// Its rows specify the question; they do not assert that a current reading
// determines its answer. Applications must establish that relation separately.
public enum ResidentAnswers8<
    B000: QuantumBit, B001: QuantumBit, B010: QuantumBit, B011: QuantumBit,
    B100: QuantumBit, B101: QuantumBit, B110: QuantumBit, B111: QuantumBit
>: Close {
    public typealias State000 = B000
    public typealias State001 = B001
    public typealias State010 = B010
    public typealias State011 = B011
    public typealias State100 = B100
    public typealias State101 = B101
    public typealias State110 = B110
    public typealias State111 = B111
}

// The planner's finite states are projections of this current source.
// Entry and exit in a request refer to different occurrences of these states.
public enum ResidentGoalSynthesisRoot: Close {
    public typealias Source = ResidentGoalMemoryRoot
    public typealias State000 = ResidentHistoryLast0<QBit0, QBit0>
    public typealias State001 = ResidentHistoryLast1<QBit0, QBit0>
    public typealias State010 = ResidentHistoryLast0<QBit0, QBit1>
    public typealias State011 = ResidentHistoryLast1<QBit0, QBit1>
    public typealias State100 = ResidentHistoryLast0<QBit1, QBit0>
    public typealias State101 = ResidentHistoryLast1<QBit1, QBit0>
    public typealias State110 = ResidentHistoryLast0<QBit1, QBit1>
    public typealias State111 = ResidentHistoryLast1<QBit1, QBit1>
}
