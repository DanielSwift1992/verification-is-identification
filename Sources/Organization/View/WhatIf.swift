import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// WHAT-IF names the board's true state: ONE typealias per task (`Task.Status`,
// System/Tasks.swift): Σ holds a single answer, so a click here cannot rewrite the company,
// that would be the site lying about what the system holds. The honest, useful frame is a
// one-step counterfactual: "if this ONE task's status typealias read differently, here is what
// changes", closed after that one step, the same way an off-path keypad digit has nowhere
// further to go.
//
// `WhatIfPage<T, N>` is the whole page, generic over the task and the hypothetical neighbour
// status: one engine, not ten bespoke bodies. Its banner ALWAYS reads `T.Status`, the type's
// REAL value, regardless of which hypothetical `N` the page is showing. The page can show
// any arrangement, but the sentence about what the system actually holds does not drift from the
// type itself. `Task`/`TaskState` are `Open`, so `Symbol` reads them directly, live.
// ═══════════════════════════════════════════════════════════════

enum WhatIfLeadText: Close {}
extension WhatIfLeadText {
    public static var typeName: String { "What if: " }
}
enum WhatIfArrowText: Close {}
extension WhatIfArrowText {
    public static var typeName: String { " → " }
}

/// DocC reads a page's first paragraph as its summary, and a summary cannot hold an image — the
/// board `Picture` below would otherwise trip that check (confirmed: `swift package
/// generate-documentation` warns "Image in document summary will not be displayed" without this
/// line). One short sentence of real text ahead of it satisfies DocC and doubles as the plain-
/// text description a screen reader meets before the picture's alt text.
enum WhatIfIntroText: Close {}
extension WhatIfIntroText {
    public static var typeName: String { "One task, redrawn in a hypothetical column." }
}

enum WhatIfBannerLeadText: Close {}
extension WhatIfBannerLeadText {
    public static var typeName: String { "What-if view: the system holds " }
}
enum WhatIfEqualsText: Close {}
extension WhatIfEqualsText {
    public static var typeName: String { " = " }
}
enum WhatIfBannerRestText: Close {}
extension WhatIfBannerRestText {
    public static var typeName: String {
        ". To make this board real, change one typealias and rebuild — the act IS the write IS the proof."
    }
}

enum BackToBoardText: Close {}
extension BackToBoardText {
    public static var typeName: String { "back to the true board" }
}
enum WhatIfCrumbText: Close {}
extension WhatIfCrumbText {
    public static var typeName: String { "What if" }
}

/// This names the what-if board's picture: `board-whatif-<task>-<status>.svg`
/// (`VectorDemo/Board.swift`), the SAME seven cards the true board draws, with `T` alone
/// re-drawn in `N`'s column, dashed and badged "Preview" and dashed, so a hypothetical reads
/// as unmistakably not the real board.
/// Slug/alt both read off `T`/`N` directly, so a page and its picture cannot drift.
enum WhatIfBoardAsset<
    T: Task,
    N: TaskState
>: Close {}
extension WhatIfBoardAsset {
    public static var typeName: String {
        "board-whatif-" + String(describing: T.self).lowercased() + "-" + String(describing: N.self).lowercased()
    }
}
enum WhatIfBoardAlt<
    T: Task,
    N: TaskState
>: Close {}
extension WhatIfBoardAlt {
    public static var typeName: String {
        "The task board with " + T.DisplayName.typeName + " previewed in the " + N.DisplayName.typeName + " column."
    }
}

/// This is the one engine behind all ten what-if pages, generic over the task and the
/// hypothetical status. Every word of prose is read off `T`/`N` themselves, not authored per
/// instance. Ten thin, CONCRETE wrapper types below each instantiate it once: a concrete name
/// (not a `typealias`) because `PageSlug`/`SitePath` read a type's Swift name
/// (`String(describing:)`), and that reads a generic instantiation's full signature
/// (`WhatIfPage<RotateVaultKeys, ToDo>`) instead of a friendly slug, checked directly against
/// the compiler. A concrete `enum` whose `body` is one reference to this generic keeps both: the
/// engine stays written once, and the page's URL stays clean.
///
/// Title is flat: `T.DisplayName`/`N.DisplayName` (plain text), not `Symbol { T.self }`
/// (double-backtick), since DocC does not render symbol-link syntax inside a heading, only
/// literal text. The board picture comes first.
/// The Noted banner names the one sentence that must not drift from what the system actually
/// holds, and reads `Symbol` because it is body prose, not a heading, where backticks render fine.
enum WhatIfPage<
    T: Task,
    N: TaskState
>: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { WhatIfLeadText.self; T.DisplayName.self; WhatIfArrowText.self; N.DisplayName.self }
        WhatIfIntroText.self; Break.self
        Picture {
            WhatIfBoardAlt<
                T,
                N
            >.self
            WhatIfBoardAsset<
                T,
                N
            >.self
        }
        Break.self
        Noted {
            WhatIfBannerLeadText.self
            Symbol { T.self }
            WhatIfEqualsText.self
            Symbol { T.Status.self }
            WhatIfBannerRestText.self
        }
        Break.self
        Link { BackToBoardText.self; Nav.Board.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self
        Link { TasksTitle.self; Nav.Tasks.self }; Chevron.self
        Link { BoardTitle.self; Nav.Board.self }; Chevron.self
        WhatIfCrumbText.self
    }
}

public enum WhatIfOnboardNewHireInProgress: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            OnboardNewHire,
            InProgress
        >.self
    }
}
public enum WhatIfArchiveOldRepositoriesInProgress: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            ArchiveOldRepositories,
            InProgress
        >.self
    }
}
public enum WhatIfRotateVaultKeysToDo: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            RotateVaultKeys,
            ToDo
        >.self
    }
}
public enum WhatIfRotateVaultKeysDone: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            RotateVaultKeys,
            Done
        >.self
    }
}
public enum WhatIfReviewImprovementPlanPolicyToDo: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            ReviewImprovementPlanPolicy,
            ToDo
        >.self
    }
}
public enum WhatIfReviewImprovementPlanPolicyDone: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            ReviewImprovementPlanPolicy,
            Done
        >.self
    }
}
public enum WhatIfFinanceReconciliationToDo: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            FinanceReconciliation,
            ToDo
        >.self
    }
}
public enum WhatIfFinanceReconciliationDone: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            FinanceReconciliation,
            Done
        >.self
    }
}
public enum WhatIfQ3AccessAuditInProgress: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            Q3AccessAudit,
            InProgress
        >.self
    }
}
public enum WhatIfUpdateOrganizationChartInProgress: Screen {
    @StructureBuilder
    public static var body: some Structure {
        WhatIfPage<
            UpdateOrganizationChart,
            InProgress
        >.self
    }
}
