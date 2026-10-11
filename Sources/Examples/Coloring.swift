import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// A pinned two-machine schedule, derived through actual conflict equations.
// PinnedScheduleIsForced proves uniqueness of the assignment for arbitrary
// tasks satisfying the pin and three chain edges. ClosingConflict separately
// checks that the derived assignment satisfies the fourth edge. The legacy
// SystemCrystallizes declaration below does not provide either proof. [V=I U2b]
// ═══════════════════════════════════════════════════════════════

/// This names one of two machines. Each names its opposite: the unary type function
/// propagation walks across every conflict edge. [V=I §2.5]
public protocol Machine {
    static var name: String { get }
    associatedtype Opposite: Machine
}

/// Machine A: its opposite is ``MachineB``. [V=I §2.5]
public enum MachineA: Machine {
    public static let name = "A"
    public typealias Opposite = MachineB
}

/// Machine B: its opposite is ``MachineA``. [V=I §2.5]
public enum MachineB: Machine {
    public static let name = "B"
    public typealias Opposite = MachineA
}

/// A task carries the machine it is assigned, reduced by the type checker. [V=I §5.22]
public protocol Task { associatedtype Assigned: Machine }

/// This is a pinned task: a given. Its machine is fixed, the seed propagation grows from. [V=I §3]
public struct Pinned<
    M: Machine
>: Task {
public typealias Assigned = M }

/// A task in conflict with `Prev`: it is forced onto the opposite machine. The
/// type checker reduces the chain, so the assignment is derived, not guessed. [V=I §5.22]
public struct Conflicts<
    Prev: Task
>: Task {
public typealias Assigned = Prev.Assigned.Opposite }

/// A directed opposite equation. On MachineA/MachineB this means different
/// machines. Machine alone does not exclude self-opposites or longer cycles.
/// The conditional conformance checks the actual assigned coordinates. [V=I §3.5]
public protocol Separated {}
public enum Conflict<
    U: Task,
    V: Task
> {}
extension Conflict: Separated
where V.Assigned == U.Assigned.Opposite {}

/// Requires the edge certificate. Conflict's conditional conformance supplies
/// it from the actual opposite equation. [V=I Thm 1]
public enum Require<
    Edge: Separated
> {}

// The conflict graph names a 4-cycle of tasks, T0 pinned to machine A. Propagation
// forces T1, T2, T3, and the closing conflict T3–T0 is a constraint the derived
// assignment must satisfy. The whole schedule is a type function of one pin.
public typealias T0 = Pinned<MachineA>
public typealias T1 = Conflicts<T0>     // forced B
public typealias T2 = Conflicts<T1>     // forced A
public typealias T3 = Conflicts<T2>     // forced B
public typealias ClosingConflict = Require<Conflict<
    T3,
    T0
>>   // B vs A, satisfied, compiles

/// Represent the four assigned coordinates, independently of task wrapper names.
public typealias ScheduleAssignment<A: Task, B: Task, C: Task, D: Task> = Cell<
    Cell<A.Assigned, B.Assigned>, Cell<C.Assigned, D.Assigned>
>

/// Every assignment satisfying this pin and these three edges equals the
/// derived assignment. No equality to that complete assignment is a premise.
/// The fourth edge is unnecessary for uniqueness, but must be checked for
/// existence of a valid cycle. Task wrapper identity is not claimed. [V=I U2b]
public enum PinnedScheduleIsForced<A: Task, B: Task, C: Task, D: Task>: Null
where A.Assigned == MachineA, B.Assigned == A.Assigned.Opposite,
      C.Assigned == B.Assigned.Opposite, D.Assigned == C.Assigned.Opposite {
    public typealias Left = ScheduleAssignment<A, B, C, D>
    public typealias Right = ScheduleAssignment<T0, T1, T2, T3>
}

/// This reads the derived machine name of a task, back from the type the compiler
/// reduced. The propagation is the proof. This only labels it. [V=I §5.20]
public func machineName<
    T: Task
>(_: T.Type) -> String { T.Assigned.name }

/// Legacy interface witness. PinnedScheduleIsForced and ClosingConflict prove
/// the schedule claim through its actual tasks. SolutionSet does not encode
/// that assignment or certify its cardinality. [V=I U1, U2b]
public struct CrystallizedSchedule: SystemCrystallizes {
    public typealias Sigma       = Three
    public typealias Left        = Cell<
        Never,
        Never
    >
    public typealias Right       = Cell<
        Never,
        Never
    >
    public typealias Cache       = Grew<
        Never,
        Never
    >   // retaining shape, without an encoded conflict history
    public typealias SolutionSet = Never                // legacy Unique coordinate
    public typealias Equality    = Verdict<Never>       // legacy answer coordinate
}

/// With no pin, this four-cycle has two MachineA/MachineB assignments, exchanged
/// by swapping the machines. That conclusion uses the binary machine domain.
/// The Pair below is a legacy interface countermodel, not a survivor census.
public struct AmbiguousSchedule {
    public typealias Sigma       = Three
    public typealias Left        = Cell<
        Never,
        Never
    >
    public typealias Right       = Cell<
        Never,
        Never
    >
    public typealias Cache       = Grew<
        Never,
        Never
    >
    public typealias SolutionSet = Cell<
        Three,
        Never
    >   // unequal projections exclude Unique, without counting candidates
    public typealias Equality    = Verdict<Never>
}

// SHOW_UNSAT rejects the additional edge T0–T2 between actual A assignments.
// SHOW_AMBIGUOUS rejects the legacy coordinate's Unique conformance. It does
// not discover or count the unpinned graph's assignments.
#if SHOW_UNSAT
public typealias ImpossibleConflict = Require<Conflict<
    T0,
    T2
>>   // A vs A, cannot separate
#endif
#if SHOW_AMBIGUOUS
extension AmbiguousSchedule: SystemCrystallizes {}               // SolutionSet not Unique
#endif
