import VerificationIsIdentification
import DocumentKit

// curve.svg — one company, two checkers, drawn by the engine it measures. Three row
// pairs, one per corpus size N: the build's bar is as wide as its seconds (three units
// per second), and the judge's bar is one hair wide, its exact seconds standing in the
// label. The measurements are stated facts with provenance: the build column taken with
// `swift run Tools curve` on the direct-coordinates layout (DESIGN21 v32), the judge
// column with `swift run Tools curve --judge` (the second judge, Curve.md's table).
// The four layouts the build crossed to reach these numbers live in Curve.md's series
// table: this figure carries the standing state, the page carries the history.

enum CurveChartLabel: Close {}
extension CurveChartLabel {
    public static var typeName: String {
        "One company, two checkers: paired horizontal bars, a bar's width is its "
            + "seconds. swift build proves the whole package in 34, 82, and 199 seconds "
            + "at N = 3200, 6400, and 12800. The judge reads the same company file in "
            + "0.28, 0.55, and 1.10 seconds: each doubling of N doubles the judge, and "
            + "the build grows near N to the 1.3."
    }
}

// ── the storeys: title, legend, plot, axis, foot — the frame is their sum ──

enum CurveTitleTall: Close {}
extension CurveTitleTall {
    public static var typeName: String { "36" }
}
enum CurveLegendTall: Close {}
extension CurveLegendTall {
    public static var typeName: String { "26" }
}
enum CurvePlotTall: Close {}
extension CurvePlotTall {
    public static var typeName: String { "214" }
}
enum CurveAxisTall: Close {}
extension CurveAxisTall {
    public static var typeName: String { "24" }
}
enum CurveFootTall: Close {}
extension CurveFootTall {
    public static var typeName: String { "26" }
}
// CurveWholeTall, the summed frame (36+26+214+24+26 = 326), lives in the dictionary too.
enum CurveLegendDrop: Close {}
extension CurveLegendDrop {
    public static var typeName: String { "36" }
}
enum CurvePlotDrop: Close {}
extension CurvePlotDrop {
    public static var typeName: String { "62" }    // title + legend
}
enum CurveAxisDrop: Close {}
extension CurveAxisDrop {
    public static var typeName: String { "276" }   // … + plot
}
enum CurveFootDrop: Close {}
extension CurveFootDrop {
    public static var typeName: String { "300" }   // … + axis
}

// ── the words ──

enum CurveTitleText: Close {}
extension CurveTitleText {
    public static var typeName: String { "One company, two checkers" }
}
enum CurveTitleY: Close {}
extension CurveTitleY {
    public static var typeName: String { "24" }
}
enum CurveAxisText: Close {}
extension CurveAxisText {
    public static var typeName: String {
        "a bar's width is its seconds · the judge's bar is one hair wide, its exact seconds stand in the label"
    }
}
enum CurveAxisTextY: Close {}
extension CurveAxisTextY {
    public static var typeName: String { "16" }
}
enum CurveFootText: Close {}
extension CurveFootText {
    public static var typeName: String {
        "each doubling of N doubles the judge, the build grows near N^1.3 · reproduce: swift run Tools curve --judge 3200 6400 12800"
    }
}
enum CurveFootY: Close {}
extension CurveFootY {
    public static var typeName: String { "16" }
}
enum LegendBuildText: Close {}
extension LegendBuildText {
    public static var typeName: String { "swift build, the whole package" }
}
enum LegendJudgeText: Close {}
extension LegendJudgeText {
    public static var typeName: String { "the judge, the same company file" }
}

// ── the measurements, one label per bar: stated, never computed (§S15).
// build (direct coordinates, `swift run Tools curve`, DESIGN21 v32): 3200 → 34 s,
// 6400 → 82 s, 12800 → 199 s. judge (`swift run Tools curve --judge`, Curve.md's
// table): 3200 → 0.28 s, 6400 → 0.55 s, 12800 → 1.10 s. ──

enum N3200Text: Close {}
extension N3200Text {
    public static var typeName: String { "N = 3200" }
}
enum N6400Text: Close {}
extension N6400Text {
    public static var typeName: String { "N = 6400" }
}
enum N12800Text: Close {}
extension N12800Text {
    public static var typeName: String { "N = 12800" }
}
enum Build3200Text: Close {}
extension Build3200Text {
    public static var typeName: String { "34 s" }
}
enum Build6400Text: Close {}
extension Build6400Text {
    public static var typeName: String { "82 s" }
}
enum Build12800Text: Close {}
extension Build12800Text {
    public static var typeName: String { "199 s" }
}
enum Judge3200Text: Close {}
extension Judge3200Text {
    public static var typeName: String { "0.28 s" }
}
enum Judge6400Text: Close {}
extension Judge6400Text {
    public static var typeName: String { "0.55 s" }
}
enum Judge12800Text: Close {}
extension Judge12800Text {
    public static var typeName: String { "1.10 s" }
}

// ── one row: the N name on its column, the bar as wide as its seconds, the seconds
// after the bar. The judge's row leaves the name column empty and its bar is a hair. ──

enum CurveRowLabelY: Close {}
extension CurveRowLabelY {
    public static var typeName: String { "16" }
}
enum CurveNameSpan<T: Structure>: SpanLabel {
    public typealias Y = CurveRowLabelY
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum CurveValueSpan<T: Structure>: SpanLabel {
    public typealias Y = CurveRowLabelY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum CurveHairRadius: Close {}
extension CurveHairRadius {
    public static var typeName: String { "1" }
}
enum CurveBuildBar: SpanTrack {
    public typealias H = Tally<CurveBarThick>
    public typealias Radius = R6
    public typealias Fill = AccentRole
}
enum CurveJudgeBar: SpanTrack {
    public typealias H = Tally<CurveBarThick>
    public typealias Radius = CurveHairRadius
    public typealias Fill = ActionRole
}
enum CurveBuildRow<
    NameText: Structure,
    Wide: Structure,
    ValueText: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<CurveNameColumn, CurveNameSpan<NameText>>.self
        Fixed<Wide, CurveBuildBar>.self
        Air<HairBreath>.self
        Flexible<CurveValueSpan<ValueText>>.self
        Air<EdgeMargin>.self
    }
}
enum CurveJudgeRow<
    ValueText: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Air<CurveNameColumn>.self
        Fixed<HairBreath, CurveJudgeBar>.self
        Air<HairBreath>.self
        Flexible<CurveValueSpan<ValueText>>.self
        Air<EdgeMargin>.self
    }
}

// ── the row drops: pairs of 24 with a 4 breath inside, 22 between groups ──

enum CurveBuild3200Drop: Close {}
extension CurveBuild3200Drop {
    public static var typeName: String { "70" }
}
enum CurveJudge3200Drop: Close {}
extension CurveJudge3200Drop {
    public static var typeName: String { "98" }
}
enum CurveBuild6400Drop: Close {}
extension CurveBuild6400Drop {
    public static var typeName: String { "144" }
}
enum CurveJudge6400Drop: Close {}
extension CurveJudge6400Drop {
    public static var typeName: String { "172" }
}
enum CurveBuild12800Drop: Close {}
extension CurveBuild12800Drop {
    public static var typeName: String { "218" }
}
enum CurveJudge12800Drop: Close {}
extension CurveJudge12800Drop {
    public static var typeName: String { "246" }
}

// ── the ground: one rounded card under the whole figure, so every label sits on a
// surface role and the chart reads as a card among the site's cards ──

enum CurvePlate: SpanTrackOutlined {
    public typealias H = Tally<CurveWholeTall>
    public typealias Radius = R12
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum CurvePlateRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<CurvePlate>.self
    }
}

enum CurveAxisRule: SpanRule {
    public typealias Y = CurvePlotTall
    public typealias Stroke = TextSecondary
}
enum CurveAxisRuleRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<CurveAxisRule>.self
        Air<EdgeMargin>.self
    }
}

// ── the legend: one chip per checker, the same colors the bars wear ──

enum LegendChipDrop: Close {}
extension LegendChipDrop {
    public static var typeName: String { "6" }
}
enum CurveLegendChipTall: Close {}
extension CurveLegendChipTall {
    public static var typeName: String { "12" }
}
enum LegendChip<Fill: Structure>: SpanTrack {
    public typealias H = CurveLegendChipTall
    public typealias Radius = R4
    public typealias Fill = Fill
}
enum LegendLabel<T: Structure>: SpanLabel {
    public typealias Y = CurveRowLabelY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum CurveLegendRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Air<CurveNameColumn>.self
        Fixed<LegendChipWide, SpanLowered<LegendChipDrop, LegendChip<AccentRole>>>.self
        Air<HairBreath>.self
        Fixed<CurveLegendTextWide, LegendLabel<LegendBuildText>>.self
        Air<Breath>.self
        Fixed<LegendChipWide, SpanLowered<LegendChipDrop, LegendChip<ActionRole>>>.self
        Air<HairBreath>.self
        Flexible<LegendLabel<LegendJudgeText>>.self
        Air<EdgeMargin>.self
    }
}

// ── the words on their storeys, the frame grown from the sum ──

enum CurveTitleSpan: SpanLabelMid {
    public typealias Y = CurveTitleY
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = CurveTitleText
}
enum CurveAxisSpan: SpanLabelMid {
    public typealias Y = CurveAxisTextY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = CurveAxisText
}
enum CurveFootSpan: SpanLabelMid {
    public typealias Y = CurveFootY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = CurveFootText
}
enum CurveTitleRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<CurveTitleSpan>.self
    }
}
enum CurveAxisRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<CurveAxisSpan>.self
    }
}
enum CurveFootRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<CurveFootSpan>.self
    }
}
enum CurveTitleDrop: Close {}
extension CurveTitleDrop {
    public static var typeName: String { "0" }
}
enum CurveDropAt<
    Line: Structure,
    Content: Structure
>: Dropped {
    public typealias Y = Line
    public typealias Content = Content
}
enum CurveChartContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        CurveDropAt<CurveTitleDrop, CurvePlateRow>.self
        CurveDropAt<CurveTitleDrop, CurveTitleRow>.self
        CurveDropAt<CurveLegendDrop, CurveLegendRow>.self
        CurveDropAt<CurveBuild3200Drop, CurveBuildRow<N3200Text, CurveBuildWide3200, Build3200Text>>.self
        CurveDropAt<CurveJudge3200Drop, CurveJudgeRow<Judge3200Text>>.self
        CurveDropAt<CurveBuild6400Drop, CurveBuildRow<N6400Text, CurveBuildWide6400, Build6400Text>>.self
        CurveDropAt<CurveJudge6400Drop, CurveJudgeRow<Judge6400Text>>.self
        CurveDropAt<CurveBuild12800Drop, CurveBuildRow<N12800Text, CurveBuildWide12800, Build12800Text>>.self
        CurveDropAt<CurveJudge12800Drop, CurveJudgeRow<Judge12800Text>>.self
        CurveDropAt<CurvePlotDrop, CurveAxisRuleRow>.self
        CurveDropAt<CurveAxisDrop, CurveAxisRow>.self
        CurveDropAt<CurveFootDrop, CurveFootRow>.self
    }
}
enum CurveChartDiagram: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = CurveChartLabel
    public typealias Defs = SoftShadow
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<CurveWholeTall, SpanHosted<CurveChartContent>>.self
    }
}

func runCurveChart() {
    writeCore(CurveChartDiagram.typeName, "curve")
    print("generated 1 two-checker curve (Vector composition, measurements stated)")
}
