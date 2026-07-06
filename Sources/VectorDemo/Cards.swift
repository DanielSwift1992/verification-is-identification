import VerificationIsIdentification
import DocumentKit

// The nine hub cards + the avatar, as `Vector` compositions (DESIGN7 §2): a 1:1 redraw of
// GenerateCards.swift's templates (same glyphs, same viewBox); byte-parity is not the gate
// here (the markup changes shape), visual parity is. Every circle and rect is a real atom
// (`GlyphCircle`/`GlyphRect`, parameters typed, not a string holding both); only a path's
// curve data stays literal (§S22: irregular content is stated, not decomposed), the same
// split `TextDigit` already draws between a stated digit and a computed one.
//
// DESIGN10 §5: one recipe for all nine, a ground, a glyph, plus ONE small `Accent` dot per
// icon (the DNA's one hero, applied even here), flat, no `SoftShadow` (these are DocC's
// grid tiles, not Pulse panels).
//
// DESIGN11: mechanism (A), the ground and the glyph are no longer flat atoms but a
// `CardPalette` (DocumentKit/Design.swift) read generically, so the SAME nine compositions,
// instantiated once with `LightCardPalette` and once with `DarkCardPalette`, are what
// `runCards()` writes as `card-x.svg` and `card-x~dark.svg`, the driver's edge substitution
// (SurfaceLaw §S23), not two hand-drawn files. `CardAccentDotFilled` stays non-generic:
// `Accent` carries the identical value in both palettes (DESIGN11 a1's table).

enum CardAccentDotX: Close {}
extension CardAccentDotX {
    public static var typeName: String { "290" }
}
enum CardAccentDotY: Close {}
extension CardAccentDotY {
    public static var typeName: String { "32" }
}
enum CardAccentDotR: Close {}
extension CardAccentDotR {
    public static var typeName: String { "8" }
}
enum CardAccentDot: GlyphCircle {
    public typealias CX = CardAccentDotX
    public typealias CY = CardAccentDotY
    public typealias R = CardAccentDotR
}

// A breathing pulse on the one accent dot each card already carries: a "live" signal, not a
// distraction (restrained on purpose, a dashboard is read, not watched), but visible at a
// glance, not just measurable in computed style: opacity AND radius both swing (animating `r`
// directly, an SVG presentation attribute CSS treats as animatable, needs no `transform-origin`
// bookkeeping the way a `scale()` would). CSS's animation clock, no runtime, nothing to
// script. Declared once per SVG FILE (each of the nine cards is its own document, `<style>`
// does not cross that boundary), referenced identically by all nine: one rule, read nine
// times, not nine copies of it.
enum CardAccentPulseClass: Close {}
extension CardAccentPulseClass {
    public static var typeName: String { "card-accent-pulse" }
}
enum CardAccentPulseStyle: Close {}
extension CardAccentPulseStyle {
    public static var typeName: String {
        """
        <style>
        @keyframes card-accent-pulse { 0%, 100% { opacity: 1; r: 8px; } 50% { opacity: 0.35; r: 5.5px; } }
        .card-accent-pulse circle { animation: card-accent-pulse 1.8s ease-in-out infinite; }
        </style>

        """
    }
}
enum CardAccentDotFilled: FilledGroupClassed {
    public typealias Class = CardAccentPulseClass
    public typealias Fill = Accent
    public typealias Content = CardAccentDot
}

// One recipe, stated once: a palette surface, the icon's glyph, the pulse rule, the
// accent dot. Nine cards are nine glyphs handed to the same three-layer body; a card
// cannot drift from the recipe because there is only one recipe to drift from.
enum HubCardBackground<
    Palette: CardPalette
>: FullBleedRect {
    public typealias W = CardWidth
    public typealias H = CardHeight
    public typealias Fill = Palette.Surface
}
enum HubCardBody<
    Palette: CardPalette,
    Glyph: Structure
>: Group {
    @StructureBuilder
    public static var body: some Structure {
        HubCardBackground<Palette>.self
        Glyph.self
        CardAccentPulseStyle.self
        CardAccentDotFilled.self
    }
}
enum HubCard<
    Palette: CardPalette,
    Glyph: Structure,
    Label: Structure
>: Diagram {
    public typealias Size = CardCanvasSize
    public typealias AriaLabel = Label
    public typealias Content = HubCardBody<Palette, Glyph>
}

// ── dashboard — four tiles ──
enum DashboardTile1: GlyphRect {
    public typealias X = N110
    public typealias Y = N46
    public typealias W = N44
    public typealias H = N38
    public typealias Radius = N7
}
enum DashboardTile2: GlyphRect {
    public typealias X = N166
    public typealias Y = N46
    public typealias W = N44
    public typealias H = N38
    public typealias Radius = N7
}
enum DashboardTile3: GlyphRect {
    public typealias X = N110
    public typealias Y = N96
    public typealias W = N44
    public typealias H = N38
    public typealias Radius = N7
}
enum DashboardTile4: GlyphRect {
    public typealias X = N166
    public typealias Y = N96
    public typealias W = N44
    public typealias H = N38
    public typealias Radius = N7
}
enum DashboardTiles: Group {
    @StructureBuilder
    public static var body: some Structure {
        DashboardTile1.self
        DashboardTile2.self
        DashboardTile3.self
        DashboardTile4.self
    }
}
enum DashboardGlyph<
    Palette: CardPalette
>: FilledGroup {
    public typealias Fill = Palette.Glyph
    public typealias Content = DashboardTiles
}
enum DashboardLabelText: Close {}
extension DashboardLabelText {
    public static var typeName: String { "dashboard" }
}
typealias DashboardCard<Palette: CardPalette> = HubCard<
    Palette,
    DashboardGlyph<Palette>,
    DashboardLabelText
>

// ── employees — two people ──
enum EmployeesHead1: GlyphCircle {
    public typealias CX = N130
    public typealias CY = N74
    public typealias R = N22
}
enum EmployeesShoulders1Path: Close {}
extension EmployeesShoulders1Path {
    public static var typeName: String { "M96 126c0-21 16-32 34-32s34 11 34 32" }
}
enum EmployeesShoulders1: GlyphPath {
public typealias D = EmployeesShoulders1Path }
enum EmployeesHead2: GlyphCircle {
    public typealias CX = N196
    public typealias CY = N82
    public typealias R = N17
}
enum EmployeesShoulders2Path: Close {}
extension EmployeesShoulders2Path {
    public static var typeName: String { "M174 126c2-15 11-23 22-23s20 8 22 23" }
}
enum EmployeesShoulders2: GlyphPath {
public typealias D = EmployeesShoulders2Path }
enum EmployeesFigures: Group {
    @StructureBuilder
    public static var body: some Structure {
        EmployeesHead1.self
        EmployeesShoulders1.self
        EmployeesHead2.self
        EmployeesShoulders2.self
    }
}
enum EmployeesGlyph<
    Palette: CardPalette
>: StrokedGroup {
    public typealias Stroke = Palette.Glyph
    public typealias Content = EmployeesFigures
}
enum EmployeesLabelText: Close {}
extension EmployeesLabelText {
    public static var typeName: String { "employees" }
}
typealias EmployeesCard<Palette: CardPalette> = HubCard<
    Palette,
    EmployeesGlyph<Palette>,
    EmployeesLabelText
>

// ── departments — org chart ──
enum DepartmentsBox1: GlyphRect {
    public typealias X = N142
    public typealias Y = N40
    public typealias W = N36
    public typealias H = N26
    public typealias Radius = N5
}
enum DepartmentsBox2: GlyphRect {
    public typealias X = N104
    public typealias Y = N108
    public typealias W = N36
    public typealias H = N26
    public typealias Radius = N5
}
enum DepartmentsBox3: GlyphRect {
    public typealias X = N180
    public typealias Y = N108
    public typealias W = N36
    public typealias H = N26
    public typealias Radius = N5
}
enum DepartmentsLinesPath: Close {}
extension DepartmentsLinesPath {
    public static var typeName: String { "M160 66v20M122 88v20M198 88v20M122 88h76" }
}
enum DepartmentsLines: GlyphPath {
public typealias D = DepartmentsLinesPath }
enum DepartmentsShapes: Group {
    @StructureBuilder
    public static var body: some Structure {
        DepartmentsBox1.self
        DepartmentsBox2.self
        DepartmentsBox3.self
        DepartmentsLines.self
    }
}
enum DepartmentsGlyph<
    Palette: CardPalette
>: StrokedGroup {
    public typealias Stroke = Palette.Glyph
    public typealias Content = DepartmentsShapes
}
enum DepartmentsLabelText: Close {}
extension DepartmentsLabelText {
    public static var typeName: String { "departments" }
}
typealias DepartmentsCard<Palette: CardPalette> = HubCard<
    Palette,
    DepartmentsGlyph<Palette>,
    DepartmentsLabelText
>

// ── documents — a page with a folded corner ──
enum DocumentsPagePath: Close {}
extension DocumentsPagePath {
    public static var typeName: String { "M128 42h42l26 26v66a6 6 0 0 1-6 6h-62a6 6 0 0 1-6-6V48a6 6 0 0 1 6-6z" }
}
enum DocumentsPage: GlyphPath {
public typealias D = DocumentsPagePath }
enum DocumentsCornerPath: Close {}
extension DocumentsCornerPath {
    public static var typeName: String { "M170 42v26h26" }
}
enum DocumentsCorner: GlyphPath {
public typealias D = DocumentsCornerPath }
enum DocumentsLinesPath: Close {}
extension DocumentsLinesPath {
    public static var typeName: String { "M140 92h40M140 110h40M140 74h18" }
}
enum DocumentsLines: GlyphPath {
public typealias D = DocumentsLinesPath }
enum DocumentsShapes: Group {
    @StructureBuilder
    public static var body: some Structure {
        DocumentsPage.self
        DocumentsCorner.self
        DocumentsLines.self
    }
}
enum DocumentsGlyph<
    Palette: CardPalette
>: StrokedGroup {
    public typealias Stroke = Palette.Glyph
    public typealias Content = DocumentsShapes
}
enum DocumentsLabelText: Close {}
extension DocumentsLabelText {
    public static var typeName: String { "documents" }
}
typealias DocumentsCard<Palette: CardPalette> = HubCard<
    Palette,
    DocumentsGlyph<Palette>,
    DocumentsLabelText
>

// ── tasks — checklist ──
enum TasksCheck1Path: Close {}
extension TasksCheck1Path {
    public static var typeName: String { "M108 60l8 8 16-18" }
}
enum TasksCheck1: GlyphPath {
public typealias D = TasksCheck1Path }
enum TasksLine1Path: Close {}
extension TasksLine1Path {
    public static var typeName: String { "M150 60h62" }
}
enum TasksLine1: GlyphPath {
public typealias D = TasksLine1Path }
enum TasksCheck2Path: Close {}
extension TasksCheck2Path {
    public static var typeName: String { "M108 90l8 8 16-18" }
}
enum TasksCheck2: GlyphPath {
public typealias D = TasksCheck2Path }
enum TasksLine2Path: Close {}
extension TasksLine2Path {
    public static var typeName: String { "M150 90h62" }
}
enum TasksLine2: GlyphPath {
public typealias D = TasksLine2Path }
enum TasksCheck3Path: Close {}
extension TasksCheck3Path {
    public static var typeName: String { "M108 120l8 8 16-18" }
}
enum TasksCheck3: GlyphPath {
public typealias D = TasksCheck3Path }
enum TasksLine3Path: Close {}
extension TasksLine3Path {
    public static var typeName: String { "M150 120h62" }
}
enum TasksLine3: GlyphPath {
public typealias D = TasksLine3Path }
enum TasksShapes: Group {
    @StructureBuilder
    public static var body: some Structure {
        TasksCheck1.self
        TasksLine1.self
        TasksCheck2.self
        TasksLine2.self
        TasksCheck3.self
        TasksLine3.self
    }
}
enum TasksGlyph<
    Palette: CardPalette
>: StrokedGroup {
    public typealias Stroke = Palette.Glyph
    public typealias Content = TasksShapes
}
enum TasksLabelText: Close {}
extension TasksLabelText {
    public static var typeName: String { "tasks" }
}
typealias TasksCard<Palette: CardPalette> = HubCard<
    Palette,
    TasksGlyph<Palette>,
    TasksLabelText
>

// ── directories — stacked rows ──
enum DirectoriesRow1: GlyphRect {
    public typealias X = N106
    public typealias Y = N50
    public typealias W = N108
    public typealias H = N24
    public typealias Radius = N6
}
enum DirectoriesRow2: GlyphRect {
    public typealias X = N106
    public typealias Y = N84
    public typealias W = N108
    public typealias H = N24
    public typealias Radius = N6
}
enum DirectoriesRow3: GlyphRect {
    public typealias X = N106
    public typealias Y = N118
    public typealias W = N108
    public typealias H = N24
    public typealias Radius = N6
}
enum DirectoriesRows: Group {
    @StructureBuilder
    public static var body: some Structure {
        DirectoriesRow1.self
        DirectoriesRow2.self
        DirectoriesRow3.self
    }
}
enum DirectoriesGlyph<
    Palette: CardPalette
>: StrokedGroup {
    public typealias Stroke = Palette.Glyph
    public typealias Content = DirectoriesRows
}
enum DirectoriesLabelText: Close {}
extension DirectoriesLabelText {
    public static var typeName: String { "directories" }
}
typealias DirectoriesCard<Palette: CardPalette> = HubCard<
    Palette,
    DirectoriesGlyph<Palette>,
    DirectoriesLabelText
>

// ── reports — bar chart ──
enum ReportsBar1: GlyphRect {
    public typealias X = N120
    public typealias Y = N98
    public typealias W = N18
    public typealias H = N36
    public typealias Radius = N4
}
enum ReportsBar2: GlyphRect {
    public typealias X = N151
    public typealias Y = N76
    public typealias W = N18
    public typealias H = N58
    public typealias Radius = N4
}
enum ReportsBar3: GlyphRect {
    public typealias X = N182
    public typealias Y = N56
    public typealias W = N18
    public typealias H = N78
    public typealias Radius = N4
}
enum ReportsBars: Group {
    @StructureBuilder
    public static var body: some Structure {
        ReportsBar1.self
        ReportsBar2.self
        ReportsBar3.self
    }
}
enum ReportsBarsFilled<
    Palette: CardPalette
>: FilledGroup {
    public typealias Fill = Palette.Glyph
    public typealias Content = ReportsBars
}
enum ReportsBaselinePath: Close {}
extension ReportsBaselinePath {
    public static var typeName: String { "M108 134h104" }
}
enum ReportsBaseline<
    Palette: CardPalette
>: StandaloneStrokedPath {
    public typealias Stroke = Palette.Glyph
    public typealias D = ReportsBaselinePath
}
enum ReportsGlyph<
    Palette: CardPalette
>: Group {
    @StructureBuilder
    public static var body: some Structure {
        ReportsBarsFilled<Palette>.self
        ReportsBaseline<Palette>.self
    }
}
enum ReportsLabelText: Close {}
extension ReportsLabelText {
    public static var typeName: String { "reports" }
}
typealias ReportsCard<Palette: CardPalette> = HubCard<
    Palette,
    ReportsGlyph<Palette>,
    ReportsLabelText
>

// ── cycles — two curved arrows (sync) ──
enum CyclesArc1Path: Close {}
extension CyclesArc1Path {
    public static var typeName: String { "M126 92a34 34 0 0 1 58-24" }
}
enum CyclesArc1: GlyphPath {
public typealias D = CyclesArc1Path }
enum CyclesArc2Path: Close {}
extension CyclesArc2Path {
    public static var typeName: String { "M194 92a34 34 0 0 1-58 24" }
}
enum CyclesArc2: GlyphPath {
public typealias D = CyclesArc2Path }
enum CyclesHead1Path: Close {}
extension CyclesHead1Path {
    public static var typeName: String { "M186 46v22h-22" }
}
enum CyclesHead1: GlyphPath {
public typealias D = CyclesHead1Path }
enum CyclesHead2Path: Close {}
extension CyclesHead2Path {
    public static var typeName: String { "M134 138v-22h22" }
}
enum CyclesHead2: GlyphPath {
public typealias D = CyclesHead2Path }
enum CyclesShapes: Group {
    @StructureBuilder
    public static var body: some Structure {
        CyclesArc1.self
        CyclesArc2.self
        CyclesHead1.self
        CyclesHead2.self
    }
}
enum CyclesGlyph<
    Palette: CardPalette
>: StrokedGroup {
    public typealias Stroke = Palette.Glyph
    public typealias Content = CyclesShapes
}
enum CyclesLabelText: Close {}
extension CyclesLabelText {
    public static var typeName: String { "cycles" }
}
typealias CyclesCard<Palette: CardPalette> = HubCard<
    Palette,
    CyclesGlyph<Palette>,
    CyclesLabelText
>

// ── board — kanban columns ──
enum BoardColumn1: GlyphRect {
    public typealias X = N104
    public typealias Y = N46
    public typealias W = N34
    public typealias H = N88
    public typealias Radius = N7
}
enum BoardColumn2: GlyphRect {
    public typealias X = N143
    public typealias Y = N46
    public typealias W = N34
    public typealias H = N88
    public typealias Radius = N7
}
enum BoardColumn3: GlyphRect {
    public typealias X = N182
    public typealias Y = N46
    public typealias W = N34
    public typealias H = N88
    public typealias Radius = N7
}
enum BoardHandlesPath: Close {}
extension BoardHandlesPath {
    public static var typeName: String { "M112 66h18M151 66h18M190 66h18" }
}
enum BoardHandles: GlyphPathThick {
public typealias D = BoardHandlesPath }
enum BoardShapes: Group {
    @StructureBuilder
    public static var body: some Structure {
        BoardColumn1.self
        BoardColumn2.self
        BoardColumn3.self
        BoardHandles.self
    }
}
enum BoardGlyph<
    Palette: CardPalette
>: StrokedGroup {
    public typealias Stroke = Palette.Glyph
    public typealias Content = BoardShapes
}
enum BoardLabelText: Close {}
extension BoardLabelText {
    public static var typeName: String { "board" }
}
typealias BoardCard<Palette: CardPalette> = HubCard<
    Palette,
    BoardGlyph<Palette>,
    BoardLabelText
>

// ── avatar — neutral profile silhouette, the same recipe (DESIGN10 §5) ──
enum AvatarAccentDotX: Close {}
extension AvatarAccentDotX {
    public static var typeName: String { "170" }
}
enum AvatarAccentDot: GlyphCircle {
    public typealias CX = AvatarAccentDotX
    public typealias CY = CardAccentDotY
    public typealias R = CardAccentDotR
}
enum AvatarAccentDotFilled: FilledGroup {
    public typealias Fill = Accent
    public typealias Content = AvatarAccentDot
}
enum AvatarHead: GlyphCircle {
    public typealias CX = N100
    public typealias CY = N78
    public typealias R = N32
}
enum AvatarShouldersPath: Close {}
extension AvatarShouldersPath {
    public static var typeName: String { "M48 166c0-32 24-50 52-50s52 18 52 50z" }
}
enum AvatarShoulders: GlyphPath {
public typealias D = AvatarShouldersPath }
enum AvatarShapes: Group {
    @StructureBuilder
    public static var body: some Structure {
        AvatarHead.self
        AvatarShoulders.self
    }
}
enum AvatarGlyph<
    Palette: CardPalette
>: FilledGroup {
    public typealias Fill = Palette.Glyph
    public typealias Content = AvatarShapes
}
enum AvatarLabelText: Close {}
extension AvatarLabelText {
    public static var typeName: String { "employee" }
}
enum AvatarBackground<
    Palette: CardPalette
>: RoundedFullBleedRect {
    public typealias W = Tally<AvatarCanvasSide>
    public typealias H = Tally<AvatarCanvasSide>
    public typealias Radius = R16
    public typealias Fill = Palette.Surface
}
enum AvatarBody<
    Palette: CardPalette
>: Group {
    @StructureBuilder
    public static var body: some Structure {
        AvatarBackground<Palette>.self
        AvatarGlyph<Palette>.self
        AvatarAccentDotFilled.self
    }
}
enum AvatarDrawing<
    Palette: CardPalette
>: Diagram {
    public typealias Size = AvatarCanvasSize
    public typealias AriaLabel = AvatarLabelText
    public typealias Content = AvatarBody<Palette>
}

func runCards() {
    write(DashboardCard<LightCardPalette>.typeName, "card-dashboard")
    write(DashboardCard<DarkCardPalette>.typeName, "card-dashboard~dark")
    write(EmployeesCard<LightCardPalette>.typeName, "card-employees")
    write(EmployeesCard<DarkCardPalette>.typeName, "card-employees~dark")
    write(DepartmentsCard<LightCardPalette>.typeName, "card-departments")
    write(DepartmentsCard<DarkCardPalette>.typeName, "card-departments~dark")
    write(DocumentsCard<LightCardPalette>.typeName, "card-documents")
    write(DocumentsCard<DarkCardPalette>.typeName, "card-documents~dark")
    write(TasksCard<LightCardPalette>.typeName, "card-tasks")
    write(TasksCard<DarkCardPalette>.typeName, "card-tasks~dark")
    write(DirectoriesCard<LightCardPalette>.typeName, "card-directories")
    write(DirectoriesCard<DarkCardPalette>.typeName, "card-directories~dark")
    write(ReportsCard<LightCardPalette>.typeName, "card-reports")
    write(ReportsCard<DarkCardPalette>.typeName, "card-reports~dark")
    write(CyclesCard<LightCardPalette>.typeName, "card-cycles")
    write(CyclesCard<DarkCardPalette>.typeName, "card-cycles~dark")
    write(BoardCard<LightCardPalette>.typeName, "card-board")
    write(BoardCard<DarkCardPalette>.typeName, "card-board~dark")
    print("generated 9 card SVGs × 2 themes in \(out) (Vector composition, CardPalette)")
    write(AvatarDrawing<LightCardPalette>.typeName, "avatar")
    write(AvatarDrawing<DarkCardPalette>.typeName, "avatar~dark")
    print("generated 1 profile avatar × 2 themes (Vector composition, CardPalette)")
}
