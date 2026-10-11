import VerificationIsIdentification

// Two resident words. A program is an actual ordered pair of instructions.
// This finite basis is not a universal computer or an unbounded storage claim.
public enum ResidentHS: Pair {
    public typealias Left = JointHLabel
    public typealias Right = JointSLabel
}
public enum ResidentSH: Pair {
    public typealias Left = JointSLabel
    public typealias Right = JointHLabel
}

// The next instruction is read from the resident program. Program content
// survives both branches, while the two-state clock is actually permuted.
public enum ResidentAtZero<P: Pair>: Pair {
    public typealias Left = Paired<P, QBit0>
    public typealias Right = Paired<P, QBit0.Flipped>
    public typealias Instruction = P.Left
}
public enum ResidentAtOne<P: Pair>: Pair {
    public typealias Left = Paired<P, QBit1>
    public typealias Right = Paired<P, QBit1.Flipped>
    public typealias Instruction = P.Right
}
public enum ResidentInterpreterRoot: Close {
    public typealias Program0 = ResidentHS
    public typealias Program1 = ResidentSH
    public typealias Row00 = ResidentAtZero<Program0>
    public typealias Row01 = ResidentAtOne<Program0>
    public typealias Row10 = ResidentAtZero<Program1>
    public typealias Row11 = ResidentAtOne<Program1>
    public typealias ServiceAction = QZ
    public typealias ServiceRenewal = MemoryBoundaryPalette.Uniform
    // A fair choice of two JOINT controls, not two independent coins.
    public typealias CoordinatedPC = Paired<Paired<QI, QI>, Paired<QX, QX>>
    // A separately selectable expansion of allowed future contacts.
    public typealias ReopenService = JointCZLabel
}
