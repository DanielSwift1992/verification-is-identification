import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// A certified scheduler names the V=I loop as a working tool.
//
// Declare tasks and conflicts; pin one task. The compiler PROPAGATES the forced
// assignment (each conflicting task takes the opposite machine) and reports the
// V=I trichotomy: |S| = 1 derived and certified, |S| = 0 proven impossible (it
// does not compile), |S| > 1 ambiguous (not Unique, search is the encoder's).
//
// Nothing runs. Propagation is type reduction; the constraint is a `where`; the
// gate is SystemCrystallizes. Because a pinned, connected graph forces one
// assignment, the compiler CHECKING it is the compiler FINDING it: verification
// is identification. [V=I Thm 2]
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

/// This names a conflict edge that must hold: the two tasks land on different machines.
/// The constraint is the `where`. An edge whose endpoints share a machine cannot
/// conform, so the schedule that violates it cannot be built. [V=I §3.5]
public protocol Separated {}
public enum Conflict<
    U: Task,
    V: Task
> {}
extension Conflict: Separated
where V.Assigned == U.Assigned.Opposite {}

/// This is a satisfied constraint, certified by the type checker: it forms only when its
/// conflict edge separates its endpoints. [V=I Thm 1]
public enum Require<
    Edge: Separated
> {}

// The conflict graph names a 4-cycle of tasks, T0 pinned to machine A. Propagation
// forces T1, T2, T3; the closing conflict T3–T0 is a constraint the derived
// assignment must satisfy. The whole schedule is a type function of one pin.
public typealias T0 = Pinned<MachineA>
public typealias T1 = Conflicts<T0>     // forced B
public typealias T2 = Conflicts<T1>     // forced A
public typealias T3 = Conflicts<T2>     // forced B
public typealias ClosingConflict = Require<Conflict<
    T3,
    T0
>>   // B vs A, satisfied, compiles

/// This reads the derived machine name of a task, back from the type the compiler
/// reduced. The propagation is the proof. This only labels it. [V=I §5.20]
public func machineName<
    T: Task
>(_: T.Type) -> String { T.Assigned.name }

/// |S| = 1: the pinned, connected, consistent schedule is forced to one
/// assignment, so it crystallizes. The build is the certificate. [V=I Thm 2]
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
    >   // resolved conflicts ACCUMULATE (I3)
    public typealias SolutionSet = Never                // the forced unique assignment (|S| = 1)
    public typealias Equality    = Verdict<Never>       // same-machine test (decidable)
}

/// This gives |S| > 1: the SAME graph with `T0` left free admits two assignments (swap A↔B).
/// Its solution set is a genuine `Pair`, the case `Unique` excludes, the
/// determined part is delegated to search (the encoder, E2). [V=I §5.14]
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
    >   // |S| = 2, not Unique
    public typealias Equality    = Verdict<Never>
}

// Build with the flags to make the compiler rule on the other two verdicts:
//   -DSHOW_UNSAT       add conflict T0–T2 (both forced to A) → |S| = 0, refused
//   -DSHOW_AMBIGUOUS   claim the unpinned graph crystallizes → |S| > 1, refused
#if SHOW_UNSAT
public typealias ImpossibleConflict = Require<Conflict<
    T0,
    T2
>>   // A vs A, cannot separate
#endif
#if SHOW_AMBIGUOUS
extension AmbiguousSchedule: SystemCrystallizes {}               // SolutionSet not Unique
#endif
