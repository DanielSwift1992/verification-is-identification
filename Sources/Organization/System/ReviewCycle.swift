import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE YEAR-CLOSE INTERLOCK names why you cannot close the year without the cut.
//
// The score is a given: someone graded each person, it is in the system, we do not
// decide it here. What we model is the structural law on top: TIME CANNOT ADVANCE
// until the cut is committed. The next cycle is reachable ONLY through this cycle's
// committed cut: a year that closed without firing is not a state you can write down.
//
// This is illegal-state-unrepresentable, the framework's own move: not "remember to
// run the cut" (a runtime check that can be skipped) but "the next year does not
// exist until you have." It echoes Matter M8: the next cycle ignites only once the
// current one is fixed (saturated). Here the fixing IS the cut.
// ═══════════════════════════════════════════════════════════════

/// These are named Peano numbers, the counting atoms. Each is a successor step in the chain.

public enum One: IntegerValued {
    public typealias Left = Never
    public typealias Right = Zero
}

public enum Two: IntegerValued {
    public typealias Left = Never
    public typealias Right = One
}

public enum Three: IntegerValued {
    public typealias Left = Never
    public typealias Right = Two
}

public enum Four: IntegerValued {
    public typealias Left = Never
    public typealias Right = Three
}

public enum Five: IntegerValued {
    public typealias Left = Never
    public typealias Right = Four
}

public enum Six: IntegerValued {
    public typealias Left = Never
    public typealias Right = Five
}

public enum Seven: IntegerValued {
    public typealias Left = Never
    public typealias Right = Six
}

public enum Eight: IntegerValued {
    public typealias Left = Never
    public typealias Right = Seven
}

public enum Nine: IntegerValued {
    public typealias Left = Never
    public typealias Right = Eight
}

public enum Ten: IntegerValued {
    public typealias Left = Never
    public typealias Right = Nine
}

/// This names a batch: an Open type whose body lists the employees being let go. The builder
/// folds the braces into a Paired chain, the type IS the cohort. `Length` states the batch's
/// size as a numeral. The count test welds the declaration to the body it lists
/// (`testBatchCountsItsEmployees`), so the two cannot quietly diverge.
public protocol Batch: Open {
    associatedtype Length: IntegerValued
}

/// This names a committed cut for a cycle: the recorded fact of it. It names the whole batch it
/// let go and the manager who enforced it. The decision (who) is the human's, recorded as types.
/// `Open`, so a cut is directly readable (`Symbol`).
///
/// The `Cohort.Length == Ten` pin is the band itself: 5% of the founding roster of 200, the
/// policy's number. A cut over a batch of any other declared size does not compile — the size
/// is proved at the close, not audited after it.
///
/// The policy also intends the enforcer to stand OUTSIDE the cohort being cut. A `where`
/// clause pins what a type IS; the medium has no clause for what a type is not, so that half
/// of the intent stays prose until a Distinct mechanism earns its way into the lattice. The
/// `Rank` pin below is the half that holds today.
public protocol CommittedCut: Open
where Cohort.Length == Ten {
    associatedtype Cycle: Organization.Cycle
    associatedtype Cohort: Batch
    associatedtype EnforcedBy: Employee
    where EnforcedBy.Rank: CanAdmin
}

/// This names a review cycle (a year). The first cycle is open by fiat. Every later cycle exists
/// ONLY as the closing of the previous one with its committed cut (`Closed`). There is
/// no other sanctioned constructor: you cannot name a later year without threading
/// every prior cut. The chain IS the list of cuts.
public protocol Cycle: Chain {}   // law:allow — a domain gate: CommittedCut.Cycle demands this category, so a bare Chain cannot sit in a cycle slot

/// This is the opening cycle: the only one granted for free. No year has closed yet, so no cut.
public enum FirstCycle: Cycle {
    public typealias Length = Zero
}

/// This closes a cycle: well-formed only with a cut committed FOR THAT cycle, and the
/// closed state IS the next cycle. [Matter M8]
public enum Closed<
    Prev: Cycle,
    TheCut: CommittedCut
>: Cycle
where TheCut.Cycle == Prev {
    public typealias Length = Succ<Prev.Length>
}

// ── Batches — each lists employees through the body pattern ──

/// This is the 2026 batch: 10 employees being let go
public enum Batch2026: Batch {
    public typealias Length = Ten
    @StructureBuilder
    public static var body: some Structure {
        Emp0002.self; Emp0100.self; Emp0101.self; Emp0102.self; Emp0103.self
        Emp0104.self; Emp0105.self; Emp0106.self; Emp0107.self; Emp0108.self
    }
}

/// This is the 2027 batch
public enum Batch2027: Batch {
    public typealias Length = Ten
    @StructureBuilder
    public static var body: some Structure {
        Emp0004.self; Emp0110.self; Emp0111.self; Emp0112.self; Emp0113.self
        Emp0114.self; Emp0115.self; Emp0116.self; Emp0117.self; Emp0118.self
    }
}

/// This is the 2028 batch
public enum Batch2028: Batch {
    public typealias Length = Ten
    @StructureBuilder
    public static var body: some Structure {
        Emp0006.self; Emp0120.self; Emp0121.self; Emp0122.self; Emp0123.self
        Emp0124.self; Emp0125.self; Emp0126.self; Emp0127.self; Emp0128.self
    }
}

/// This is the 2029 batch
public enum Batch2029: Batch {
    public typealias Length = Ten
    @StructureBuilder
    public static var body: some Structure {
        Emp0008.self; Emp0130.self; Emp0131.self; Emp0132.self; Emp0133.self
        Emp0134.self; Emp0135.self; Emp0136.self; Emp0137.self; Emp0138.self
    }
}

// ── The timeline ──

/// This is 2026's committed cut.
public enum Cut2026: CommittedCut {
    public typealias Cycle = FirstCycle
    public typealias Cohort = Batch2026
    public typealias EnforcedBy = Emp0011
}

/// This 2027 exists only because 2026 was closed WITH its cut.
public enum Y2027: Cycle {
    public typealias Length = One
}
extension Y2027: Pair {
    public typealias Left = FirstCycle
    public typealias Right = Cut2026
}

/// This is 2027's committed cut.
public enum Cut2027: CommittedCut {
    public typealias Cycle = Y2027
    public typealias Cohort = Batch2027
    public typealias EnforcedBy = Emp0011
}

/// This is 2028
public enum Y2028: Cycle {
    public typealias Length = Two
}
extension Y2028: Pair {
    public typealias Left = Y2027
    public typealias Right = Cut2027
}

/// This is 2028's committed cut.
public enum Cut2028: CommittedCut {
    public typealias Cycle = Y2028
    public typealias Cohort = Batch2028
    public typealias EnforcedBy = Emp0011
}

/// This is 2029
public enum Y2029: Cycle {
    public typealias Length = Three
}
extension Y2029: Pair {
    public typealias Left = Y2028
    public typealias Right = Cut2028
}

/// This is 2029's committed cut.
public enum Cut2029: CommittedCut {
    public typealias Cycle = Y2029
    public typealias Cohort = Batch2029
    public typealias EnforcedBy = Emp0011
}

/// This is 2030: the chain through four closes.
public enum Y2030: Cycle {
    public typealias Length = Four
}
extension Y2030: Pair {
    public typealias Left = Y2029
    public typealias Right = Cut2029
}

// The chain structure IS the timeline proof. Reading it back (as an array of cuts)
// is a View concern, not here.
//   • a cut whose `EnforcedBy` is not a manager: an individual contributor cannot enforce
//     the policy (`EnforcedBy.Rank: CanAdmin` fails to hold), so the cut will not form.
//   • There is no `Closed<Y2027>` without a cut argument: the year will not advance.
//     You cannot close it without firing.
