import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// TASKS, work items as org entities, the same way people are.
//
// A task is a TYPE, like `Alice`, not a row of strings a view types out. Its assignee
// is an `Employee`, so you can only assign work to someone the roster holds: an
// assignee who is not an employee will not compile. Its status is a typed atom. Its
// title is the type's own name, read at the render boundary (`label`); nothing here
// stores a string of its own (Law §0′). The board (View/Board.swift) reads these tasks
// and lays them out, it authors none of them.
//
// Status is a directory, exactly like `Gender` or `Department`: a protocol whose
// elements are empty enums (atoms). It is a CLOSED set in lifecycle order, so the
// board's columns are read off it, never invented.
// ═══════════════════════════════════════════════════════════════

/// This names a task's state, one column of the board. An atom: the type is the value, and its
/// name is read at render. The three states form a closed directory in lifecycle order.
/// `Open`, so a state is directly readable (`Symbol`). `DisplayName` is the humanized,
/// space-separated form (a page title cannot carry a raw `Symbol`'s
/// backticks, DocC does not render them in a heading), declared once here, read by
/// both the board's drawing (VectorDemo) and the what-if pages' prose, so the two
/// cannot drift to different wording for the same state.
public protocol TaskState: Open {
    associatedtype DisplayName: Structure
}
/// This has not yet started.
public enum ToDo: TaskState {
    public typealias DisplayName = ToDoDisplayName
}
public enum ToDoDisplayName: Close {}
extension ToDoDisplayName {
    public static var typeName: String { "To Do" }
}
/// This is underway.
public enum InProgress: TaskState {
    public typealias DisplayName = InProgressDisplayName
}
public enum InProgressDisplayName: Close {}
extension InProgressDisplayName {
    public static var typeName: String { "In Progress" }
}
/// This is finished.
public enum Done: TaskState {
    public typealias DisplayName = DoneDisplayName
}
public enum DoneDisplayName: Close {}
extension DoneDisplayName {
    public static var typeName: String { "Done" }
}

/// This names a task: a work item composed from the org. The assignee is a real ``Employee`` and
/// the status a typed ``TaskState``, so a card carries a live deeplink and a known
/// column. No field is a stored string, the composition is the record (cf. ``Person``).
/// `Open`, so a task is directly readable (`Symbol`). `DisplayName` is the humanized
/// title (see ``TaskState/DisplayName``'s note): the one place this task's plain-
/// English name is spelled, read by both the drawn board and the what-if pages.
public protocol Task: Open {
    associatedtype Assignee: Employee
    associatedtype Status: TaskState
    associatedtype DisplayName: Structure
}

/// This is the quarterly access audit, Alice's, and signed off.
public enum Q3AccessAudit: Task {
    public typealias Assignee = Alice
    public typealias Status = Done
    public typealias DisplayName = Q3AccessAuditDisplayName
}
public enum Q3AccessAuditDisplayName: Close {}
extension Q3AccessAuditDisplayName {
    public static var typeName: String { "Q3 Access Audit" }
}

/// This is refreshing the organization chart for the new hires, Carol's, and done.
public enum UpdateOrganizationChart: Task {
    public typealias Assignee = Carol
    public typealias Status = Done
    public typealias DisplayName = UpdateOrganizationChartDisplayName
}
public enum UpdateOrganizationChartDisplayName: Close {}
extension UpdateOrganizationChartDisplayName {
    public static var typeName: String { "Org Chart Update" }
}

/// This is the quarterly vault key rotation, Dave's, underway.
public enum RotateVaultKeys: Task {
    public typealias Assignee = Dave
    public typealias Status = InProgress
    public typealias DisplayName = RotateVaultKeysDisplayName
}
public enum RotateVaultKeysDisplayName: Close {}
extension RotateVaultKeysDisplayName {
    public static var typeName: String { "Rotate Vault Keys" }
}

/// This is drafting the objection memo on the improvement-plan policy, Bob's, underway.
public enum ReviewImprovementPlanPolicy: Task {
    public typealias Assignee = Bob
    public typealias Status = InProgress
    public typealias DisplayName = ReviewImprovementPlanPolicyDisplayName
}
public enum ReviewImprovementPlanPolicyDisplayName: Close {}
extension ReviewImprovementPlanPolicyDisplayName {
    public static var typeName: String { "Review PIP Policy" }
}

/// This is closing the quarter's books, Alice's, underway.
public enum FinanceReconciliation: Task {
    public typealias Assignee = Alice
    public typealias Status = InProgress
    public typealias DisplayName = FinanceReconciliationDisplayName
}
public enum FinanceReconciliationDisplayName: Close {}
extension FinanceReconciliationDisplayName {
    public static var typeName: String { "Finance Reconciliation" }
}

/// This is granting a new hire their department access, Carol's, queued.
public enum OnboardNewHire: Task {
    public typealias Assignee = Carol
    public typealias Status = ToDo
    public typealias DisplayName = OnboardNewHireDisplayName
}
public enum OnboardNewHireDisplayName: Close {}
extension OnboardNewHireDisplayName {
    public static var typeName: String { "Onboard New Hire" }
}

/// This is moving the old repositories to cold storage, Dave's, queued.
public enum ArchiveOldRepositories: Task {
    public typealias Assignee = Dave
    public typealias Status = ToDo
    public typealias DisplayName = ArchiveOldRepositoriesDisplayName
}
public enum ArchiveOldRepositoriesDisplayName: Close {}
extension ArchiveOldRepositoriesDisplayName {
    public static var typeName: String { "Archive Old Repos" }
}
