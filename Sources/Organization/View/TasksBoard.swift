import VerificationIsIdentification
import DocumentKit

// ═══════════════════════════════════════════════════════════════
// TASKS + BOARD names every task, read off the types, laid out as a list and as a kanban.
// ═══════════════════════════════════════════════════════════════

/// This is one task's cells: title, assignee, status, all read straight off the type, not authored.
enum TaskRow<
    T: Task
>: Fragment {
    init(@StructureBuilder _ task: () -> T) { fatalError() }
    @StructureBuilder
    public static var body: some Structure {
        TableCell { Symbol { T.self } }
        TableCell { Symbol { T.Assignee.self } }
        TableCell { Symbol { T.Status.self } }
    }
}

enum TasksHeader: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { TaskHeader.self }
        TableCell { AssigneeHeader.self }
        TableCell { StatusHeader.self }
    }
}
enum TasksRule: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
        TableCell { RuleMark.self }
    }
}
enum AllTasksRows: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        TableRow { TasksHeader.self }
        TableRow { TasksRule.self }
        TableRow { TaskRow { Q3AccessAudit.self } }
        TableRow { TaskRow { UpdateOrganizationChart.self } }
        TableRow { TaskRow { RotateVaultKeys.self } }
        TableRow { TaskRow { ReviewImprovementPlanPolicy.self } }
        TableRow { TaskRow { FinanceReconciliation.self } }
        TableRow { TaskRow { OnboardNewHire.self } }
        TableRow { TaskRow { ArchiveOldRepositories.self } }
    }
}

/// This gives the one card TasksIntro's prose promises but leaves unlinked: "the same tasks lay
/// out as a kanban on the board" named the board without a way to click to it. One `ListItem`,
/// the same `LinkGrid` mechanism Dashboard's Catalogs uses for eight.
enum BoardLink: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        ListItem { Page { Nav.Board.self } }
    }
}

public enum TasksPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { TasksTitle.self }
        TasksIntro.self; Break.self
        DoubleHash.self; AllTasksHeading.self; Break.self
        Table { AllTasksRows.self }
        Break.self
        LinkGrid { BoardLink.self }
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; TasksTitle.self
    }
}

// ── The board: the callout-card columns give way to the true board, a drawn
// `Vector` canvas (`VectorDemo/Board.swift`) read from the same seven tasks. Each card's
// ‹/› is a real link one step into a what-if page (`View/WhatIf.swift`). `TasksPage`'s table
// above remains the honest fallback list. ──

enum BoardAsset: Close {}
extension BoardAsset {
    public static var typeName: String { "board" }
}
enum BoardAlt: Close {}
extension BoardAlt {
    public static var typeName: String { "Task Board" }
}
enum BoardBlock: Fragment {
    @StructureBuilder
    public static var body: some Structure {
        Picture { BoardAlt.self; BoardAsset.self }
        Break.self
        BoardCaption.self
    }
}

public enum BoardPage: Screen {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { BoardTitle.self }
        BoardIntro.self; Break.self
        BoardBlock.self
        Break.self
        Link { DashboardTitle.self; Nav.CompanyDashboard.self }; Chevron.self; Link { TasksTitle.self; Nav.Tasks.self }; Chevron.self; BoardTitle.self
    }
}
