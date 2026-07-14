import VerificationIsIdentification
import DocumentKit
import Organization

// board.svg: DESIGN12 §1 / DESIGN21 v96. The TRUE board, drawn: seven tasks, each a lane of
// three stations, the card standing at its own real `Status` (read off `System/Tasks.swift`,
// title `Task.DisplayName` and assignee `Task.Assignee` read off the type, not a second
// hand-typed copy). The lane's other two stations are drawn empty: dashed slots that ARE the
// keys. Pressing a slot shows this task's card there, dashed, a try; pressing the home
// station brings the solid fact back. Every position is drawn at build time as a variant
// (`SpanVariant`, Vector.swift), so the host's hook only chooses which drawing shows and no
// geometry is ever computed after the build. A plain `<img>` shows the built truth alone.
//
// The lane keeps each task's geometry a function of its own state and nothing else. A
// falling column would make one card's place depend on every other card's state, 3^7 whole
// boards or a runtime layout, and runtime layout is the thing this package abolishes. The
// lane draws the product of independent states honestly: 21 variants, one per task and station.

typealias BoardSize = CanvasSize<WideSurface, BoardTall>
enum BoardAriaLabel: Close {}
extension BoardAriaLabel {
    public static var typeName: String {
        "The task board: three columns, To Do, In Progress, Done, read from each task's own "
            + "status. Each task is one lane whose empty stations are pressable slots: pressing "
            + "one shows the card there as a dashed preview, and the built status stays the fact."
    }
}
enum BoardWhatIfAriaLabel: Close {}
extension BoardWhatIfAriaLabel {
    public static var typeName: String {
        "The task board with one card previewed in a new column, marked as a preview, not a fact."
    }
}

// ── vertical tokens — the y axis speaks stated tokens until the height walk lands ──

enum TaskTitleY: Close {}
extension TaskTitleY {
    public static var typeName: String { "24" }
}
enum TaskAssigneeY: Close {}
extension TaskAssigneeY {
    public static var typeName: String { "42" }
}
enum ChipY: Close {}
extension ChipY {
    public static var typeName: String { "54" }
}
enum ChipHeight: Close {}
extension ChipHeight {
    public static var typeName: String { "20" }
}
enum ChipRelTextY: Close {}
extension ChipRelTextY {
    public static var typeName: String { "14" }
}

// ── card faces: the true card's stroked face under the fixed soft shadow, and the
// preview's dashed twin on the tint ──

enum TaskCardFacePlain: SpanTrackOutlined {
    public typealias H = Tally<TaskCardTall>
    public typealias Radius = R12
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
typealias TaskCardFace = SpanSoftShadowed<TaskCardFacePlain>
enum TaskCardFacePreviewPlain: SpanTrackDashed {
    public typealias H = Tally<TaskCardTall>
    public typealias Radius = R12
    public typealias Fill = ActionTint
    public typealias Stroke = ActionRole
}
typealias TaskCardFacePreview = SpanSoftShadowed<TaskCardFacePreviewPlain>

// ── the card's text pieces, each in the 16-padded text slice of its card ──

enum TaskTitleSpan<T: Structure>: SpanLabel {
    public typealias Y = TaskTitleY
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum TaskAssigneeSpan<T: Structure>: SpanLabel {
    public typealias Y = TaskAssigneeY
    public typealias FillColor = TextSecondary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PreviewBadgeText: Close {}
extension PreviewBadgeText {
    public static var typeName: String { "Preview" }
}
enum PreviewBadgeSpan: SpanLabelEnd {
    public typealias Y = TaskTitleY
    public typealias FillColor = ActionRole
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = PreviewBadgeText
}
/// The card's one text slice: sixteen in from either edge of the 280-wide card.
enum CardTextRow<Content: Spanning>: HFlow {
    public typealias Given = DocumentCardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<Content>.self
        Air<EdgeMargin>.self
    }
}

// ── the three status chips — fixed appearance, DESIGN11 b3's colour rule: `Done` is the
// board's one `AccentRole` (the DNA's scarce hero, its meaning singular even though every
// finished card repeats it — the same reading DESIGN10 gave the nine cards' one dot each).
// Chip TEXT is `TaskState.DisplayName` (System/Tasks.swift), not a second local literal. ──

enum StatusChipTrack<Fill: Structure>: SpanTrack {
    public typealias H = ChipHeight
    public typealias Radius = R10
    public typealias Fill = Fill
}
enum StatusChipLabel<Ink: Structure, T: Structure>: SpanLabel {
    public typealias Y = ChipRelTextY
    public typealias FillColor = Ink
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum StatusChipInterior<Ink: Structure, T: Structure>: HFlow {
    public typealias Given = StatusChipWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<HairBreath>.self
        Flexible<StatusChipLabel<Ink, T>>.self
    }
}
typealias StatusChipArt<
    Fill: Structure,
    Ink: Structure,
    T: Structure
> = SpanLowered<
    ChipY,
    Layered<StatusChipTrack<Fill>, SpanHosted<StatusChipInterior<Ink, T>>>
>
enum TaskChipRow<Chip: Spanning>: HFlow {
    public typealias Given = DocumentCardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<StatusChipWide, Chip>.self
        RestAir.self
    }
}
typealias ToDoChipSpan = StatusChipArt<SurfaceTrack, TextPrimary, Organization.ToDo.DisplayName>
typealias InProgressChipSpan = StatusChipArt<ActionRole, OnActionRole, InProgress.DisplayName>
typealias DoneChipSpan = StatusChipArt<AccentRole, OnAccent, Organization.Done.DisplayName>

/// Which chip visual represents each status: a DRAWING choice (colour, shape), so it lives
/// here, not on `TaskState` itself (System/Tasks.swift stays presentation-free). Retroactive
/// conformance is legal Swift since the PROTOCOL is new in this module.
protocol HasChipVisual: TaskState {
    associatedtype ChipVisual: Spanning
}
extension Organization.ToDo: HasChipVisual {
typealias ChipVisual = ToDoChipSpan }
extension InProgress: HasChipVisual {
typealias ChipVisual = InProgressChipSpan }
extension Organization.Done: HasChipVisual {
typealias ChipVisual = DoneChipSpan }

// ── card compositions: the true card, the unaffected static, the dashed preview ──

typealias TaskCardCoreSpan<
    T: Task,
    Chip: Spanning
> = Layered<
    SpanHosted<CardTextRow<TaskTitleSpan<T.DisplayName>>>,
    Layered<SpanHosted<CardTextRow<TaskAssigneeSpan<T.Assignee>>>, SpanHosted<TaskChipRow<Chip>>>
>
typealias StaticCardSpan<
    T: Task,
    Chip: Spanning
> = Layered<
    TaskCardFace,
    TaskCardCoreSpan<T, Chip>
>
typealias PreviewCardSpan<
    T: Task,
    Chip: Spanning
> = Layered<
    TaskCardFacePreview,
    Layered<TaskCardCoreSpan<T, Chip>, SpanHosted<CardTextRow<PreviewBadgeSpan>>>
>

// ── a column: its header on the slice's start, four card slots lowered to the row tokens ──

enum ColumnHeaderBaseline: Close {}
extension ColumnHeaderBaseline {
    public static var typeName: String { "20" }
}
enum ColumnHeaderSpan<T: Structure>: SpanLabel {
    public typealias Y = ColumnHeaderBaseline
    public typealias FillColor = TextPrimary
    public typealias Size = TextL
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum BoardColumn<
    Header: Structure,
    R1: Spanning,
    R2: Spanning,
    R3: Spanning,
    R4: Spanning
>: VFlow {
    public typealias Given = BoardColumnTall
    public typealias Across = DocumentCardWide
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<BoardHeaderZone, ColumnHeaderSpan<Header>>.self
        Fixed<TaskCardTall, R1>.self
        Air<Breath>.self
        Fixed<TaskCardTall, R2>.self
        Air<Breath>.self
        Fixed<TaskCardTall, R3>.self
        Air<Breath>.self
        Fixed<TaskCardTall, R4>.self
        RestAir.self
    }
}
typealias BoardColumnArt<
    Header: Structure,
    R1: Spanning,
    R2: Spanning,
    R3: Spanning,
    R4: Spanning
> = SpanHosted<BoardColumn<Header, R1, R2, R3, R4>>
enum BoardRow<
    C1: Spanning,
    C2: Spanning,
    C3: Spanning
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<BoardEdge>.self
        Fixed<DocumentCardWide, C1>.self
        Air<Gutter>.self
        Fixed<DocumentCardWide, C2>.self
        Air<Gutter>.self
        Fixed<DocumentCardWide, C3>.self
        RestAir.self
    }
}

// ── the board is 7 lanes of drawn variants: per task, one variant per station, every
// position drawn ahead of time. A variant fills its whole lane: the card at its station,
// dashed empty slots at the other two, and the slots ARE the keys. The resting variant is
// the built status (solid card); the try variants wear the dashed preview. The host shows
// the pressed position and hides the owner's others, any number of moves, there and back
// (SpanVariant / SpanVariantKey, Vector.swift). Nothing navigates, nothing scrolls, and a
// plain <img> shows the built truth alone. ──

enum PosToDo: Close {}
extension PosToDo {
    public static var typeName: String { "todo" }
}
enum PosInProgress: Close {}
extension PosInProgress {
    public static var typeName: String { "inprogress" }
}
enum PosDone: Close {}
extension PosDone {
    public static var typeName: String { "done" }
}
enum ShownYes: Close {}
extension ShownYes {
    public static var typeName: String { "1" }
}
enum ShownNo: Close {}
extension ShownNo {
    public static var typeName: String { "0" }
}

/// This spells `fill="none"`: the ghost slot is an outline only, quieter than the filled
/// dashed preview it invites.
enum NoFillInk: Close {}
extension NoFillInk {
    public static var typeName: String { "none" }
}
/// The empty station: a dashed card-sized outline with one word of invitation in the
/// action colour, centred by the derived baseline. Wrapped in a variant key it IS the
/// move: press the slot, the card stands there. "Try" is the caption's own noun.
enum GhostSlotFace: SpanTrackDashed {
    public typealias H = Tally<TaskCardTall>
    public typealias Radius = R12
    public typealias Fill = NoFillInk
    public typealias Stroke = LineRole
}
enum GhostTryText: Close {}
extension GhostTryText {
    public static var typeName: String { "Try" }
}
enum GhostTrySpan: SpanLabelMidFitted {
    public typealias Y = CenteredBaseline<TaskCardTall, TextS>
    public typealias FillColor = ActionRole
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = GhostTryText
}
typealias GhostKeyAt<T: Task, To: Structure> = SpanVariantKey<
    RawName<T>,
    To,
    Layered<GhostSlotFace, GhostTrySpan>
>

/// One variant of a task's lane: the card at the named station, ghost keys at the other
/// two. The whole lane is one drawing, so a variant switch never leaves a hole behind.
typealias LaneAtToDo<
    T: Task,
    Card: Spanning,
    Shown: Structure
> = SpanVariant<
    RawName<T>,
    PosToDo,
    SpanHosted<TaskMatrixRow<Card, GhostKeyAt<T, PosInProgress>, GhostKeyAt<T, PosDone>>>,
    Shown
>
typealias LaneAtInProgress<
    T: Task,
    Card: Spanning,
    Shown: Structure
> = SpanVariant<
    RawName<T>,
    PosInProgress,
    SpanHosted<TaskMatrixRow<GhostKeyAt<T, PosToDo>, Card, GhostKeyAt<T, PosDone>>>,
    Shown
>
typealias LaneAtDone<
    T: Task,
    Card: Spanning,
    Shown: Structure
> = SpanVariant<
    RawName<T>,
    PosDone,
    SpanHosted<TaskMatrixRow<GhostKeyAt<T, PosToDo>, GhostKeyAt<T, PosInProgress>, Card>>,
    Shown
>

/// A whole lane by its built status: solid card at the fact, dashed previews at the tries,
/// the fact's variant resting visible. Three shapes cover all seven tasks.
typealias LaneBuiltToDo<T: Task> = Layered<
    LaneAtToDo<T, StaticCardSpan<T, ToDoChipSpan>, ShownYes>,
    Layered<
        LaneAtInProgress<T, PreviewCardSpan<T, InProgressChipSpan>, ShownNo>,
        LaneAtDone<T, PreviewCardSpan<T, DoneChipSpan>, ShownNo>
    >
>
typealias LaneBuiltInProgress<T: Task> = Layered<
    LaneAtInProgress<T, StaticCardSpan<T, InProgressChipSpan>, ShownYes>,
    Layered<
        LaneAtToDo<T, PreviewCardSpan<T, ToDoChipSpan>, ShownNo>,
        LaneAtDone<T, PreviewCardSpan<T, DoneChipSpan>, ShownNo>
    >
>
typealias LaneBuiltDone<T: Task> = Layered<
    LaneAtDone<T, StaticCardSpan<T, DoneChipSpan>, ShownYes>,
    Layered<
        LaneAtToDo<T, PreviewCardSpan<T, ToDoChipSpan>, ShownNo>,
        LaneAtInProgress<T, PreviewCardSpan<T, InProgressChipSpan>, ShownNo>
    >
>

// ── the rows: one per task, its solid cell at the built status, dashed cells beside ──

enum BoardHeaderRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<BoardEdge>.self
        Fixed<DocumentCardWide, ColumnHeaderSpan<Organization.ToDo.DisplayName>>.self
        Air<Gutter>.self
        Fixed<DocumentCardWide, ColumnHeaderSpan<InProgress.DisplayName>>.self
        Air<Gutter>.self
        Fixed<DocumentCardWide, ColumnHeaderSpan<Organization.Done.DisplayName>>.self
        RestAir.self
    }
}
enum TaskMatrixRow<
    C1: Spanning,
    C2: Spanning,
    C3: Spanning
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<BoardEdge>.self
        Fixed<DocumentCardWide, C1>.self
        Air<Gutter>.self
        Fixed<DocumentCardWide, C2>.self
        Air<Gutter>.self
        Fixed<DocumentCardWide, C3>.self
        RestAir.self
    }
}

enum BoardMatrix: VFlow {
    public typealias Given = BoardMatrixTall
    public typealias Across = WideSurface
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<BoardHeaderZone, SpanHosted<BoardHeaderRow>>.self
        Fixed<TaskCardTall, LaneBuiltToDo<OnboardNewHire>>.self
        Air<Breath>.self
        Fixed<TaskCardTall, LaneBuiltToDo<ArchiveOldRepositories>>.self
        Air<Breath>.self
        Fixed<TaskCardTall, LaneBuiltInProgress<RotateVaultKeys>>.self
        Air<Breath>.self
        Fixed<TaskCardTall, LaneBuiltInProgress<ReviewImprovementPlanPolicy>>.self
        Air<Breath>.self
        Fixed<TaskCardTall, LaneBuiltInProgress<FinanceReconciliation>>.self
        Air<Breath>.self
        Fixed<TaskCardTall, LaneBuiltDone<Q3AccessAudit>>.self
        Air<Breath>.self
        Fixed<TaskCardTall, LaneBuiltDone<UpdateOrganizationChart>>.self
        Flexible<SpanNothing>.self
    }
}

enum BoardDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SoftShadow.self
    }
}
enum BoardContent: Group, SelfShowing {
    @StructureBuilder
    public static var body: some Structure {
        BoardMatrix.self
    }
}
enum BoardDiagram: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = BoardAriaLabel
    public typealias Defs = BoardDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<BoardMatrixTall, SpanHosted<BoardContent>>.self
        Air<Breath>.self
        Fixed<Never, SpanHosted<BoardSelfShowingRow>>.self
        Air<S24Breath>.self
    }
}

// ── the ten what-if boards (DESIGN12 §1 corrects DESIGN11 b3's count: 7 tasks × "≤2
// neighbours" is 10, not 14 — two ToDo and two Done tasks have exactly ONE neighbour each,
// not two). Each board is the same row of columns with one slot emptied and one slot
// previewed; the statics are the same spans the true board draws, un-linked. ──

typealias StaticOnboard = StaticCardSpan<OnboardNewHire, OnboardNewHire.Status.ChipVisual>
typealias StaticArchive = StaticCardSpan<ArchiveOldRepositories, ArchiveOldRepositories.Status.ChipVisual>
typealias StaticRotate = StaticCardSpan<RotateVaultKeys, RotateVaultKeys.Status.ChipVisual>
typealias StaticReview = StaticCardSpan<ReviewImprovementPlanPolicy, ReviewImprovementPlanPolicy.Status.ChipVisual>
typealias StaticFinance = StaticCardSpan<FinanceReconciliation, FinanceReconciliation.Status.ChipVisual>
typealias StaticAudit = StaticCardSpan<Q3AccessAudit, Q3AccessAudit.Status.ChipVisual>
typealias StaticChart = StaticCardSpan<UpdateOrganizationChart, UpdateOrganizationChart.Status.ChipVisual>

typealias ToDoColumnBoth = BoardColumnArt<Organization.ToDo.DisplayName, StaticOnboard, StaticArchive, SpanNothing, SpanNothing>
typealias ToDoColumnNoOnboard = BoardColumnArt<Organization.ToDo.DisplayName, SpanNothing, StaticArchive, SpanNothing, SpanNothing>
typealias ToDoColumnNoArchive = BoardColumnArt<Organization.ToDo.DisplayName, StaticOnboard, SpanNothing, SpanNothing, SpanNothing>
typealias ToDoColumnPlus<P: Spanning> = BoardColumnArt<Organization.ToDo.DisplayName, StaticOnboard, StaticArchive, P, SpanNothing>
typealias InProgressColumnAll = BoardColumnArt<InProgress.DisplayName, StaticRotate, StaticReview, StaticFinance, SpanNothing>
typealias InProgressColumnNoRotate = BoardColumnArt<InProgress.DisplayName, SpanNothing, StaticReview, StaticFinance, SpanNothing>
typealias InProgressColumnNoReview = BoardColumnArt<InProgress.DisplayName, StaticRotate, SpanNothing, StaticFinance, SpanNothing>
typealias InProgressColumnNoFinance = BoardColumnArt<InProgress.DisplayName, StaticRotate, StaticReview, SpanNothing, SpanNothing>
typealias InProgressColumnPlus<P: Spanning> = BoardColumnArt<InProgress.DisplayName, StaticRotate, StaticReview, StaticFinance, P>
typealias DoneColumnBoth = BoardColumnArt<Organization.Done.DisplayName, StaticAudit, StaticChart, SpanNothing, SpanNothing>
typealias DoneColumnNoAudit = BoardColumnArt<Organization.Done.DisplayName, SpanNothing, StaticChart, SpanNothing, SpanNothing>
typealias DoneColumnNoChart = BoardColumnArt<Organization.Done.DisplayName, StaticAudit, SpanNothing, SpanNothing, SpanNothing>
typealias DoneColumnPlus<P: Spanning> = BoardColumnArt<Organization.Done.DisplayName, StaticAudit, StaticChart, P, SpanNothing>

enum WhatIfContent<
    C1: Spanning,
    C2: Spanning,
    C3: Spanning
>: Group {
    @StructureBuilder
    public static var body: some Structure {
        SoftShadow.self
        BoardRow<C1, C2, C3>.self
    }
}
// A stated frame by decision, not a leftover: the what-if boards must stand in the SAME
// frame as the live board whatever their columns hold, because the page reads them as
// alternate takes of one picture. A grown frame would breathe with the content and break
// that promise; the live board grows, the counterfactuals hold its pose.
enum WhatIfBoard<
    C1: Spanning,
    C2: Spanning,
    C3: Spanning
>: Diagram {
    public typealias Size = BoardSize
    public typealias AriaLabel = BoardWhatIfAriaLabel
    public typealias Content = WhatIfContent<C1, C2, C3>
}

typealias WhatIfOnboardNewHireInProgressBoard = WhatIfBoard<
    ToDoColumnNoOnboard,
    InProgressColumnPlus<PreviewCardSpan<OnboardNewHire, InProgressChipSpan>>,
    DoneColumnBoth
>
typealias WhatIfArchiveOldRepositoriesInProgressBoard = WhatIfBoard<
    ToDoColumnNoArchive,
    InProgressColumnPlus<PreviewCardSpan<ArchiveOldRepositories, InProgressChipSpan>>,
    DoneColumnBoth
>
typealias WhatIfRotateVaultKeysToDoBoard = WhatIfBoard<
    ToDoColumnPlus<PreviewCardSpan<RotateVaultKeys, ToDoChipSpan>>,
    InProgressColumnNoRotate,
    DoneColumnBoth
>
typealias WhatIfRotateVaultKeysDoneBoard = WhatIfBoard<
    ToDoColumnBoth,
    InProgressColumnNoRotate,
    DoneColumnPlus<PreviewCardSpan<RotateVaultKeys, DoneChipSpan>>
>
typealias WhatIfReviewImprovementPlanPolicyToDoBoard = WhatIfBoard<
    ToDoColumnPlus<PreviewCardSpan<ReviewImprovementPlanPolicy, ToDoChipSpan>>,
    InProgressColumnNoReview,
    DoneColumnBoth
>
typealias WhatIfReviewImprovementPlanPolicyDoneBoard = WhatIfBoard<
    ToDoColumnBoth,
    InProgressColumnNoReview,
    DoneColumnPlus<PreviewCardSpan<ReviewImprovementPlanPolicy, DoneChipSpan>>
>
typealias WhatIfFinanceReconciliationToDoBoard = WhatIfBoard<
    ToDoColumnPlus<PreviewCardSpan<FinanceReconciliation, ToDoChipSpan>>,
    InProgressColumnNoFinance,
    DoneColumnBoth
>
typealias WhatIfFinanceReconciliationDoneBoard = WhatIfBoard<
    ToDoColumnBoth,
    InProgressColumnNoFinance,
    DoneColumnPlus<PreviewCardSpan<FinanceReconciliation, DoneChipSpan>>
>
typealias WhatIfQ3AccessAuditInProgressBoard = WhatIfBoard<
    ToDoColumnBoth,
    InProgressColumnPlus<PreviewCardSpan<Q3AccessAudit, InProgressChipSpan>>,
    DoneColumnNoAudit
>
typealias WhatIfUpdateOrganizationChartInProgressBoard = WhatIfBoard<
    ToDoColumnBoth,
    InProgressColumnPlus<PreviewCardSpan<UpdateOrganizationChart, InProgressChipSpan>>,
    DoneColumnNoChart
>

func runBoard() {
    write(BoardDiagram.typeName, "board")
    write(WhatIfOnboardNewHireInProgressBoard.typeName, "board-whatif-onboardnewhire-inprogress")
    write(WhatIfArchiveOldRepositoriesInProgressBoard.typeName, "board-whatif-archiveoldrepositories-inprogress")
    write(WhatIfRotateVaultKeysToDoBoard.typeName, "board-whatif-rotatevaultkeys-todo")
    write(WhatIfRotateVaultKeysDoneBoard.typeName, "board-whatif-rotatevaultkeys-done")
    write(WhatIfReviewImprovementPlanPolicyToDoBoard.typeName, "board-whatif-reviewimprovementplanpolicy-todo")
    write(WhatIfReviewImprovementPlanPolicyDoneBoard.typeName, "board-whatif-reviewimprovementplanpolicy-done")
    write(WhatIfFinanceReconciliationToDoBoard.typeName, "board-whatif-financereconciliation-todo")
    write(WhatIfFinanceReconciliationDoneBoard.typeName, "board-whatif-financereconciliation-done")
    write(WhatIfQ3AccessAuditInProgressBoard.typeName, "board-whatif-q3accessaudit-inprogress")
    write(WhatIfUpdateOrganizationChartInProgressBoard.typeName, "board-whatif-updateorganizationchart-inprogress")
    print("generated 1 task board + 10 what-if boards (Vector composition, live status)")
}
