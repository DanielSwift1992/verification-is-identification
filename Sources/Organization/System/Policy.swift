import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// The access policy names it once, as types. Every access in this target is
// decided against it at build time: an allowed access compiles, a denied one does
// not and names its reason. No policy engine runs. [V=I Thm 2]
// ═══════════════════════════════════════════════════════════════

/// This names the right to read a document, the floor of the capability refinement. `Open`, so a
/// rank is directly readable (`Symbol`).
public protocol CanView: Open {}
/// This names the right to change a document. Entails ``CanView``.
public protocol CanEdit: CanView {}   // law:allow — a rank level: its content is the conformance SET (who holds it), stronger than CanView by construction, not a synonym of it
/// This names the right to administer a document. Entails ``CanEdit``, and so ``CanView``.
public protocol CanAdmin: CanEdit {}   // law:allow — a rank level: its content is the conformance SET (who holds it), stronger than CanEdit by construction, not a synonym of it

/// This names a rank, cyclic: `Next` states the round-robin order a hire's level follows.
/// The roster emits each hire's rank directly by that rotation's index. A chain of
/// `Rank.Next` reads across thousands of hires serializes as a member chain that deep,
/// and the compiler's deserializer overflows resolving one person, so the rotation is
/// stated, never chained.
public protocol RankCycle: CanView {
    associatedtype Next: CanView & RankCycle
}

/// This is an individual contributor, carries ``CanView``.
public enum IndividualContributor: CanView, RankCycle {
    public typealias Next = Lead
}
/// This is a team lead, carries ``CanEdit``.
public enum Lead: CanEdit, RankCycle {
    public typealias Next = Manager
}
/// This is a manager, carries ``CanAdmin``.
public enum Manager: CanAdmin, RankCycle {
    public typealias Next = IndividualContributor
}

/// This names a department: one organizational unit. An atom: the type is the identity, and its
/// name is read off the type at the render boundary, not stored here (Law §0′). `Open`, so a
/// department is directly readable (`Symbol`). `Next` cycles the four: the rotation a
/// hire's department follows, stated the same way ``RankCycle`` states its round-robin.
public protocol Department: Open {
    associatedtype Next: Department
}

/// This is the Finance department.
public enum Finance: Department {
    public typealias Next = Engineering
}
/// This is the Engineering department.
public enum Engineering: Department {
    public typealias Next = Sales
}
/// This is the Sales department.
public enum Sales: Department {
    public typealias Next = People
}
/// This is the People (HR) department.
public enum People: Department {
    public typealias Next = Finance
}

/// This gives every department composed through `body`: the category ``AllDepartments``
/// conforms to, rather than writing `: Open` directly.
public protocol DepartmentDirectory: Open {}

/// This gives the four departments as one type. `AllDepartments.count` is read at the boundary:
/// the department count falls out of what compiles, the way the headcount does.
public enum AllDepartments: DepartmentDirectory {
    @StructureBuilder
    public static var body: some Structure {
        Finance.self
        Engineering.self
        Sales.self
        People.self
    }
}

/// This names an employee: a rank and a home department. Structurally a point in role-space,
/// `PAIR(Rank, Home)`, the same coordinate shape V=I gives its atoms, so `Employee`
/// roots in `Pair` rather than floating as a nominal tag. The role the saturation
/// collapses to (``RoleLibrary``) is this pair-coordinate. No name is stored: the
/// handle is the type itself.
public protocol Employee: Pair
where Left == Rank, Right == Home {
    associatedtype Rank: CanView
    associatedtype Home: Department
}

/// This names a document that lives in one department, its `Home`. `Open`, so a document is
/// directly readable (`Symbol`).
public protocol Doc: Open {
    associatedtype Home: Department
}

/// This names a document with an owner: the principal who may delete it.
public protocol Owned: Doc {
    associatedtype Owner: Employee
}

// Each department's shared space: anyone in the department may view it.

/// This is Finance's shared space.
public enum FinanceShare: Doc {
    public typealias Home = Finance
}

/// This is Engineering's shared space.
public enum EngineeringShare: Doc {
    public typealias Home = Engineering
}

/// This is Sales's shared space.
public enum SalesShare: Doc {
    public typealias Home = Sales
}

/// This is People's shared space.
public enum PeopleShare: Doc {
    public typealias Home = People
}

// ── The gates (the policy) ──

/// This names the mark an access earns when it is allowed. A gate (``View``, ``Administer``,
/// ``Delete``) conforms to it only when its rule holds, so `Authorized` is the verdict
/// "this access is proved". An access that is not authorized does not compile. Each gate is also
/// a V=I `Decidable` when it holds: a decision, in or out, so `decide` reads it as it reads any
/// policy's verdict. `Left` is the principal, `Right` the two-way outcome.
public protocol Authorized {}

/// This is View: anyone in the document's department may view it.
public enum View<
    Who: Employee,
    Of: Doc
> {}
extension View: Authorized, Pair, Decidable
where Who.Home == Of.Home {
    public typealias Left = Who
    public typealias Right = Never     // the verdict: in | out
}

/// This is Administer: only a manager, and only in the document's department.
public enum Administer<
    Who: Employee,
    Of: Doc
> {}
extension Administer: Authorized, Pair, Decidable
where Who.Rank: CanAdmin, Who.Home == Of.Home {
    public typealias Left = Who
    public typealias Right = Never
}

/// This is Delete: only a manager, and only the document's owner.
public enum Delete<
    Who: Employee,
    Of: Owned
> {}
extension Delete: Authorized, Pair, Decidable
where Who.Rank: CanAdmin, Of.Owner == Who {
    public typealias Left = Who
    public typealias Right = Never
}

// A gate builds nothing: it is a verdict, not an artifact, so its `Body` stays at the floor `Never`.
// (`Pair: Open: Structure`, and a CONDITIONAL `Pair` conformance needs unconditional `Open`.)
extension View: Open {}
extension Administer: Open {}
extension Delete: Open {}

/// This asserts an access in one written line: it instantiates only with an ``Authorized`` gate,
/// so `Granted<Administer<Alice, FinanceShare>>` compiles exactly when the policy allows that
/// access. A denied access does not instantiate: the build stops and names the premise that
/// failed. [V=I Thm 2]
public enum Granted<
    A: Authorized
> {}
extension Granted: Open {}

/// This names one premise of the gates, on its own: a principal whose rank reaches administrator.
/// It is `Decidable` exactly when `Who.Rank` carries ``CanAdmin``, so `decide` reads the rank half
/// of ``Administer`` and ``Delete`` apart from the rest. When a link does not form, this tells the
/// rank premise from the others: the reason a path is missing is itself a verdict.
public enum ReachesAdmin<
    Who: Employee
> {}
extension ReachesAdmin: Open {}
extension ReachesAdmin: Pair, Decidable
where Who.Rank: CanAdmin {
    public typealias Left = Who
    public typealias Right = Never     // the verdict: in | out, same floor as View/Administer/Delete
}

/// This names a gate seen as what it grants access to: its `Document`. The render layer reads the
/// document off a proved access through this projection, not authoring it. ``View``,
/// ``Administer``, and ``Delete`` each gate one document, their second parameter.
public protocol AccessGate {
    associatedtype Document: Doc
}
extension View: AccessGate {
public typealias Document = Of }
extension Administer: AccessGate {
public typealias Document = Of }
extension Delete: AccessGate {
public typealias Document = Of }
