import VerificationIsIdentification
import DocumentKit
import Organization

// board.svg: DESIGN11 b3 / DESIGN12 §1. The TRUE board, drawn: the seven tasks laid out by
// their own real `Status`, read off `System/Tasks.swift` directly, title (`Task.DisplayName`)
// and assignee (`Task.Assignee`, itself a real `Employee` whose bare name IS its `typeName`) are
// both READ off the type, not a second hand-typed copy. A card's ‹/› is `Linked` to a one-step
// what-if page (`View/WhatIf.swift`), a closed action space, exactly the off-path keypad's own
// shape: ToDo has no ‹, Done has no ›, and a what-if page offers no move at all.
//
// The board rides the span engine: three column slices of 280 with breaths of 40 and margins
// of 20, each column a stack of four card slots lowered to the row tokens. A what-if board is
// the same row of columns with one slot swapped: the moved card sits IN its hypothetical
// column's slot, dash-stroked (`SpanTrackDashed`) on an `ActionTint` ground plus a small
// "Preview" badge; the other six keep their true slots. No ‹/› on a what-if board: one step,
// then closed, the same floor the what-if PAGE's own banner already states in prose.

typealias BoardSize = CanvasSize<WideSurface, BoardTall>
enum BoardAriaLabel: Close {}
extension BoardAriaLabel {
    public static var typeName: String {
        "The task board: three columns, To Do, In Progress, Done, read from each task's own "
            + "status. Every card links one step to a what-if page showing it in a neighbouring column."
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
enum NavY: Close {}
extension NavY {
    public static var typeName: String { "84" }
}
enum ArrowAffordanceCY: Close {}
extension ArrowAffordanceCY {
    public static var typeName: String { "84" }
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
enum PrevArrowText: Close {}
extension PrevArrowText {
    public static var typeName: String { "‹" }
}
enum NextArrowText: Close {}
extension NextArrowText {
    public static var typeName: String { "›" }
}
enum PrevArrowSpan: SpanLabel {
    public typealias Y = NavY
    public typealias FillColor = ActionRole
    public typealias Size = TitleT
    public typealias Weight = WeightBold
    public typealias Content = PrevArrowText
}
enum NextArrowSpan: SpanLabelEnd {
    public typealias Y = NavY
    public typealias FillColor = ActionRole
    public typealias Size = TitleT
    public typealias Weight = WeightBold
    public typealias Content = NextArrowText
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

// ── the ‹/› what-if triggers — present only where a neighbour status actually exists
// (DESIGN11 b3: ToDo has no ‹, Done has no ›). DESIGN13 §1: each is also a hover trigger
// (the true board shows the ghost of the move in place, no navigation, while the arrow's
// click still navigates to the full what-if page); a small dot marks it hoverable, the same
// affordance CyclesHero's nodes carry, beside the glyph at the arrow's own baseline. ──

enum ArrowDotSpan: SpanDot {
    public typealias CY = ArrowAffordanceCY
    public typealias R = HoverAffordanceRadius
    public typealias Fill = ActionRole
}
enum PrevDotRow: HFlow {
    public typealias Given = DocumentCardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<NavDotInsetLead>.self
        Fixed<NavDotWide, ArrowDotSpan>.self
        RestAir.self
    }
}
enum NextDotRow: HFlow {
    public typealias Given = DocumentCardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<NavDotWide, ArrowDotSpan>.self
        Air<NavDotInsetTail>.self
    }
}
typealias PrevTriggerArt<Target: Structure> = Layered<
    SpanLink<Target, SpanHosted<CardTextRow<PrevArrowSpan>>>,
    SpanHosted<PrevDotRow>
>
typealias NextTriggerArt<Target: Structure> = Layered<
    SpanLink<Target, SpanHosted<CardTextRow<NextArrowSpan>>>,
    SpanHosted<NextDotRow>
>

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

// ── the hover pairs live at the canvas frame, never inside a card: both halves spell
// absolute lanes and slot drops, and a pair hosted in a card would re-base the panel at
// that card's own corner. The lanes are the columns' true insets, read off `BoardRow`. ──

typealias SlotDropFirst = BoardHeaderZone
typealias SlotDropSecond = Plus<BoardHeaderZone, BoardSlotPitch>
typealias SlotDropThird = Plus<BoardHeaderZone, Plus<BoardSlotPitch, BoardSlotPitch>>
typealias SlotDropFourth = Plus<BoardHeaderZone, Plus<BoardSlotPitch, Plus<BoardSlotPitch, BoardSlotPitch>>>
enum BoardCell<
    Lane: Structure,
    DropY: Structure,
    Art: Spanning
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<Lane>.self
        Fixed<DocumentCardWide, SpanLowered<Tally<DropY>, Art>>.self
        RestAir.self
    }
}
typealias LaneToDo = BoardEdge
typealias LaneInProgress = Plus<LaneToDo, Plus<DocumentCardWide, Gutter>>
typealias LaneDone = Plus<LaneInProgress, Plus<DocumentCardWide, Gutter>>
typealias PreviewPanel<
    Lane: Structure,
    DropY: Structure,
    T: Task,
    Chip: Spanning
> = BoardCell<Lane, DropY, PreviewCardSpan<T, Chip>>

// ── the ten reveals — one per legal move, DESIGN13 §1. Each trigger is the card's ‹/›
// art seated at that card's own lane and slot, each panel the ghost at the move's target
// cell, and the pair is one `HoverReveal` so the CSS sibling rule stays scoped to it. ──

enum OnboardNewHireInProgressReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneToDo, SlotDropFirst, NextTriggerArt<SitePath<WhatIfOnboardNewHireInProgress>>>
    public typealias Panel = PreviewPanel<LaneInProgress, SlotDropFourth, OnboardNewHire, InProgressChipSpan>
}
enum ArchiveOldRepositoriesInProgressReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneToDo, SlotDropSecond, NextTriggerArt<SitePath<WhatIfArchiveOldRepositoriesInProgress>>>
    public typealias Panel = PreviewPanel<LaneInProgress, SlotDropFourth, ArchiveOldRepositories, InProgressChipSpan>
}
enum RotateVaultKeysToDoReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneInProgress, SlotDropFirst, PrevTriggerArt<SitePath<WhatIfRotateVaultKeysToDo>>>
    public typealias Panel = PreviewPanel<LaneToDo, SlotDropThird, RotateVaultKeys, ToDoChipSpan>
}
enum RotateVaultKeysDoneReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneInProgress, SlotDropFirst, NextTriggerArt<SitePath<WhatIfRotateVaultKeysDone>>>
    public typealias Panel = PreviewPanel<LaneDone, SlotDropThird, RotateVaultKeys, DoneChipSpan>
}
enum ReviewImprovementPlanPolicyToDoReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneInProgress, SlotDropSecond, PrevTriggerArt<SitePath<WhatIfReviewImprovementPlanPolicyToDo>>>
    public typealias Panel = PreviewPanel<LaneToDo, SlotDropThird, ReviewImprovementPlanPolicy, ToDoChipSpan>
}
enum ReviewImprovementPlanPolicyDoneReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneInProgress, SlotDropSecond, NextTriggerArt<SitePath<WhatIfReviewImprovementPlanPolicyDone>>>
    public typealias Panel = PreviewPanel<LaneDone, SlotDropThird, ReviewImprovementPlanPolicy, DoneChipSpan>
}
enum FinanceReconciliationToDoReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneInProgress, SlotDropThird, PrevTriggerArt<SitePath<WhatIfFinanceReconciliationToDo>>>
    public typealias Panel = PreviewPanel<LaneToDo, SlotDropThird, FinanceReconciliation, ToDoChipSpan>
}
enum FinanceReconciliationDoneReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneInProgress, SlotDropThird, NextTriggerArt<SitePath<WhatIfFinanceReconciliationDone>>>
    public typealias Panel = PreviewPanel<LaneDone, SlotDropThird, FinanceReconciliation, DoneChipSpan>
}
enum Q3AccessAuditInProgressReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneDone, SlotDropFirst, PrevTriggerArt<SitePath<WhatIfQ3AccessAuditInProgress>>>
    public typealias Panel = PreviewPanel<LaneInProgress, SlotDropFourth, Q3AccessAudit, InProgressChipSpan>
}
enum UpdateOrganizationChartInProgressReveal: HoverReveal {
    public typealias Trigger = BoardCell<LaneDone, SlotDropSecond, PrevTriggerArt<SitePath<WhatIfUpdateOrganizationChartInProgress>>>
    public typealias Panel = PreviewPanel<LaneInProgress, SlotDropFourth, UpdateOrganizationChart, InProgressChipSpan>
}

// ── the true board: each card in its own status's column, the hover pairs one layer
// above the cards, at the canvas frame ──

typealias ToDoColumnTrue = BoardColumnArt<
    Organization.ToDo.DisplayName,
    StaticCardSpan<OnboardNewHire, OnboardNewHire.Status.ChipVisual>,
    StaticCardSpan<ArchiveOldRepositories, ArchiveOldRepositories.Status.ChipVisual>,
    SpanNothing,
    SpanNothing
>
typealias InProgressColumnTrue = BoardColumnArt<
    InProgress.DisplayName,
    StaticCardSpan<RotateVaultKeys, RotateVaultKeys.Status.ChipVisual>,
    StaticCardSpan<ReviewImprovementPlanPolicy, ReviewImprovementPlanPolicy.Status.ChipVisual>,
    StaticCardSpan<FinanceReconciliation, FinanceReconciliation.Status.ChipVisual>,
    SpanNothing
>
typealias DoneColumnTrue = BoardColumnArt<
    Organization.Done.DisplayName,
    StaticCardSpan<Q3AccessAudit, Q3AccessAudit.Status.ChipVisual>,
    StaticCardSpan<UpdateOrganizationChart, UpdateOrganizationChart.Status.ChipVisual>,
    SpanNothing,
    SpanNothing
>
enum BoardReveals: Group {
    @StructureBuilder
    public static var body: some Structure {
        OnboardNewHireInProgressReveal.self
        ArchiveOldRepositoriesInProgressReveal.self
        RotateVaultKeysToDoReveal.self
        RotateVaultKeysDoneReveal.self
        ReviewImprovementPlanPolicyToDoReveal.self
        ReviewImprovementPlanPolicyDoneReveal.self
        FinanceReconciliationToDoReveal.self
        FinanceReconciliationDoneReveal.self
        Q3AccessAuditInProgressReveal.self
        UpdateOrganizationChartInProgressReveal.self
    }
}

enum BoardDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SoftShadow.self
        HoverRevealStyle.self
    }
}
enum BoardContent: Group, SelfShowing {
    @StructureBuilder
    public static var body: some Structure {
        BoardRow<ToDoColumnTrue, InProgressColumnTrue, DoneColumnTrue>.self
        BoardReveals.self
    }
}
enum BoardDiagram: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = BoardAriaLabel
    public typealias Defs = BoardDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<BoardColumnTall, SpanHosted<BoardContent>>.self
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
