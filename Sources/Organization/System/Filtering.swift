import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// FILTER AS VERIFICATION names not a runtime computation, a type the checker proves.
//
// Law §0′: you read a fact by asking the type checker, not by computing a value. So a filter is
// not `.filter` over an array (a runtime, a foreign `Array`). It is a CHAIN whose cons forms ONLY
// when the head carries the property: `where Head.Rank: CanAdmin`. A non-matching head does not
// compile, so the chain that compiles IS exactly the matches: verification is identification. Its
// `Length` is the count, a type, folded for free. Nothing runs, nothing is collected.
//
// The chain is written by the same mechanism that writes the roster (the generator, Law §3): it
// proposes the members, the compiler verifies each, the View reads the count. The filter lives in
// the lattice, our world: `Pair`/`Null`, all the way down.
// ═══════════════════════════════════════════════════════════════

/// This names a chain of employees who ADMINISTER: managers. Each link names its `Head`, and
/// `Head.Rank: CanAdmin` is the filter the compiler checks. `Length` counts them.
public protocol Administrators: Chain {
    associatedtype Head: Employee
    where Head.Rank: CanAdmin
}

/// This is the end of the chain: no managers, length `Zero`.
public enum NoAdmins: Chain {
    public typealias Length = Zero
}

/// This gives three managers of the company, as a VERIFIED chain. Each link compiled with
/// `Head.Rank: CanAdmin`, so each is a manager: the filter is proved, not computed.

/// This is the tail: Emp0008 (manager).
public enum Managers3: Administrators {
    public typealias Length = One
    public typealias Head = Emp0008
}
extension Managers3: Pair {
    public typealias Left = Emp0008
    public typealias Right = NoAdmins
}

/// This names Emp0005 ahead of Managers3.
public enum Managers2: Administrators {
    public typealias Length = Two
    public typealias Head = Emp0005
}
extension Managers2: Pair {
    public typealias Left = Emp0005
    public typealias Right = Managers3
}

/// This is the head: Emp0002 ahead of Managers2.
public enum ManagersHere: Administrators {
    public typealias Length = Three
    public typealias Head = Emp0002
}
extension ManagersHere: Pair {
    public typealias Left = Emp0002
    public typealias Right = Managers2
}

// ── Filter by department, rank, and work arrangement: a marker per leaf, composed through `body`. ──
//
// The old cons (`AlsoInDepartment` and its rank/site twins) formed only when the head's property
// matched the chain's — verified link by link. The same proof now sits on one marker per member,
// declared with the where-clause directly on the type, so a wrong pairing does not just fail a
// conformance, it fails to NAME the type at all. The marker is the leaf a `body` block lists; the
// builder folds the leaves and `count` reads the size — the cons-chain's job, without the chain.

/// This names an employee verified to belong to one department: forms only when `E.Home == D`.
public enum VerifiedInDepartment<
    E: Employee,
    D: Department
>: Close
where E.Home == D {}

/// This names an employee verified to hold one rank: forms only when `E.Rank == R`.
public enum VerifiedAtRank<
    E: Employee,
    R
>: Close
where E.Rank == R {}

/// This names an employee verified at one work arrangement: forms only when `E.Site == S`.
public enum VerifiedAtWorkplace<
    E: Employee & Person,
    S: Workplace
>: Close
where E.Site == S {}

/// This names an access verified to be a same-department view: forms only when `Who.Home ==
/// Of.Home`, the filter ``View``'s conditional conformance checks (Policy.swift), carried per
/// leaf for `body`.
public enum VerifiedView<
    Who: Employee,
    Of: Doc
>: Close
where Who.Home == Of.Home {}

