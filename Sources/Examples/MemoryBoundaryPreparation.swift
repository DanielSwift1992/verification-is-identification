import VerificationIsIdentification

// A finite executable grammar, not a conformance claiming a CPTP error bound.
// Leaves are the existing Pauli operations; Paired means a private fair choice
// in this grammar. The interpreter must establish this meaning separately.
public enum MemoryBoundaryRegister: Close {}
public enum MemoryBoundaryPalette: Close {
    public typealias Retain = QI
    public typealias Uniform = Paired<Paired<QI, QX>, Paired<QY, QZ>>
    public typealias Half = Paired<Retain, Uniform>
}

// The choice is outside the COMPLETE current word. Keeping that word here
// prevents a recipe from silently rebuilding each internal A contact.
public enum MemoryBoundaryWord<P: JointProfile, Choice: Structure>: Pair {
    public typealias Left = Paired<MemoryBoundaryRegister, Choice>
    public typealias Right = P
    public typealias Question = P.Ideal.Word
}
public enum MemoryBoundaryPrograms<P: JointProfile>: Close {
    public typealias Retain = MemoryBoundaryWord<P, MemoryBoundaryPalette.Retain>
    public typealias Half = MemoryBoundaryWord<P, MemoryBoundaryPalette.Half>
    public typealias Uniform = MemoryBoundaryWord<P, MemoryBoundaryPalette.Uniform>
}

// Trace.Left addresses the word that supplied the acquisition. Passing the
// application through MemoryBoundaryUse requires that same word, not just
// the same data target or a label. Naming the application alone is weaker.
// The numeric record, preparation and actual local channel remain additional
// obligations of the executor; this type does not assert their acquisition.
public protocol MemoryBoundaryMatches {}
public enum MemoryBoundaryApplication<Plan: Pair, Trace: Pair>: Pair {
    public typealias Left = Trace
    public typealias Right = Plan
}
extension MemoryBoundaryApplication: MemoryBoundaryMatches
where Plan.Right == Trace.Left {}
public enum MemoryBoundaryUse<A: MemoryBoundaryMatches> {}
