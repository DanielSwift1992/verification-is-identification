import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// RETURN TO OFFICE names a real policy (Amazon 2023, JPMorgan, Disney), written as types.
//
// The policy has two halves, and they cost differently. WHERE a person works, on site,
// hybrid, remote, is an atom: a positive fact, a marker the compiler reads and proves
// against. WHETHER they logged six hours across four days is a count against a threshold. The
// count is state like any other, so it enters the System as a typed quantity, converted from
// the badge system the way the roster is generated from the company: state is not held at
// the view. What the lattice carries only heavily is the ordered comparison (count >= six),
// Peano `>=`, the same ordered move the headcount cap makes. So the demo proves the cheap half,
// the arrangement, and leaves the ordered threshold out for legibility: it does not pretend a
// count cannot be typed. (Distance Is Cost: a marker is cheap, an ordered threshold heavy.)
// ═══════════════════════════════════════════════════════════════

/// This names where a person works. A directory atom, like a name or a department: the type is
/// the arrangement, and its name is read off at the render boundary, not stored here (Law §0′).
/// `Open`, so an atom (`OnSite`) is directly readable (`Symbol`). `Next` cycles the three, the
/// generator's round-robin seed for a hire's arrangement (`Coloring`'s propagation, one more
/// value than a binary flip).
public protocol Workplace: Open {
    associatedtype Next: Workplace
}

/// This names a work arrangement that brings the person to the office. The marker the
/// office-minimum reads, refining ``Workplace`` the way ``CanEdit`` refines ``CanView``. On-site
/// and hybrid carry it. Remote does not, so a remote arrangement cannot meet the minimum.
public protocol ComesToOffice: Workplace {}   // law:allow — the verdict category itself: membership (OnSite, Hybrid in; Remote out) IS the policy the page checks

/// This is on site every day.
public enum OnSite: ComesToOffice {
    public typealias Next = Hybrid
}
/// This splits the week between office and home.
public enum Hybrid: ComesToOffice {
    public typealias Next = Remote
}
/// This is fully remote, carrying no office presence.
public enum Remote: Workplace {
    public typealias Next = OnSite
}

/// This names the verdict an arrangement earns when it satisfies the office minimum, the way
/// ``Authorized`` is the verdict an access earns when it is allowed. An arrangement that does
/// not bring the person in does not conform, so it cannot be written down as one that does. Like
/// ``Authorized`` the gate is a V=I `Decidable` when it holds, so `decide` reads it the same way.
public protocol MeetsOfficeMinimum {}

/// This names the office-minimum gate, keyed on the arrangement. It earns the verdict only when
/// the arrangement ``ComesToOffice``, so ``OfficeArrangement`` over ``Remote`` does not conform
/// and does not compile as one that meets the minimum. The rule is positive: a marker holds, so
/// the compiler can settle it, exactly as it settles an access. [V=I Thm 2]
public enum OfficeArrangement<
    Site: Workplace
> {}
extension OfficeArrangement: Open {}   // a verdict builds nothing, Body stays Never (Pair: Open)
extension OfficeArrangement: MeetsOfficeMinimum, Pair, Decidable
where Site: ComesToOffice {
    public typealias Left = Site
    public typealias Right = Never     // the verdict: in | out, same floor as the access gates
}

// The arrangements that meet the minimum:
//   OfficeArrangement<OnSite>:  conforms (MeetsOfficeMinimum)
//   OfficeArrangement<Hybrid>:  conforms
//   OfficeArrangement<Remote>:  refused, below the minimum
// The conformance IS the proof. No binding needed.
