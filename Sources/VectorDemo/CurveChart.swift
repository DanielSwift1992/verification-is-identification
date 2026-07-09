import VerificationIsIdentification
import DocumentKit

// curve.svg — the saturation curve, drawn by the engine it measures. Grouped bars: one
// group per universe size N, one bar per emitter generation, bar height on a log scale
// (height = 70·log₁₀(seconds), stated below with each measurement), the true seconds
// printed on every bar. The measurements are stated facts with provenance: taken with
// `swift run Tools curve`, one commit per series, recorded in DESIGN21 v28–v32. The
// series colors are the palette's own roles, and the last group carries the frontier:
// the proof layer passes 6400 while the full site pipeline hits a frontend abort.

enum CurveChartLabel: Close {}
extension CurveChartLabel {
    public static var typeName: String {
        "Build seconds against the number of generated employees, grouped bars on a log "
            + "scale, one color per code layout, true seconds printed on each bar. Flat "
            + "bodies grow near-quadratic, slices drop the exponent, shards drop the "
            + "constant, and direct coordinates remove the serialized chain that crashed "
            + "the compiler: twelve thousand eight hundred employees build in 199 seconds."
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
    public static var typeName: String { "swift build seconds against N generated employees, four generations of code layout" }
}
enum CurveTitleY: Close {}
extension CurveTitleY {
    public static var typeName: String { "24" }
}
enum CurveFootText: Close {}
extension CurveFootText {
    public static var typeName: String {
        "log-scale bars, true seconds on each · reproduce: swift run Tools curve 400 800 1600 3200 6400 12800"
    }
}
enum CurveFootY: Close {}
extension CurveFootY {
    public static var typeName: String { "16" }
}

// ── one bar: a track lowered to its stated drop, the seconds printed above its top.
// Height = 70·log₁₀(seconds), rounded; drop = 214 − height − 4 (the axis rule's breath).
// Every pair below states its measurement in the comment beside it. ──

enum CurveValueAboveY: Close {}
extension CurveValueAboveY {
    public static var typeName: String { "-6" }   // above the bar's own top edge, local
}
enum CurveBarTrack<H: Structure, Fill: Structure>: SpanTrack {
    public typealias H = H
    public typealias Radius = R6
    public typealias Fill = Fill
}
enum CurveValueSpan<T: Structure>: SpanLabelMid {
    public typealias Y = CurveValueAboveY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
typealias CurveBarArt<
    Drop: Structure,
    H: Structure,
    Fill: Structure,
    Value: Structure
> = SpanLowered<Drop, Layered<CurveBarTrack<H, Fill>, CurveValueSpan<Value>>>

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

// ── the measurements, one enum pair per bar: stated, never computed (§S15) ──
// flat bodies (pre-fold emitter, DESIGN21 v28): 400→12s, 800→39s, 1600→192s, 3200 past
// the 13-minute budget (drawn at the >780s cap).

enum FlatH400: Close {}
extension FlatH400 {
    public static var typeName: String { "75" }    // 12s
}
enum FlatD400: Close {}
extension FlatD400 {
    public static var typeName: String { "135" }
}
enum FlatV400: Close {}
extension FlatV400 {
    public static var typeName: String { "12" }
}
enum FlatH800: Close {}
extension FlatH800 {
    public static var typeName: String { "111" }   // 39s
}
enum FlatD800: Close {}
extension FlatD800 {
    public static var typeName: String { "99" }
}
enum FlatV800: Close {}
extension FlatV800 {
    public static var typeName: String { "39" }
}
enum FlatH1600: Close {}
extension FlatH1600 {
    public static var typeName: String { "160" }   // 192s
}
enum FlatD1600: Close {}
extension FlatD1600 {
    public static var typeName: String { "50" }
}
enum FlatV1600: Close {}
extension FlatV1600 {
    public static var typeName: String { "192" }
}
enum FlatH3200: Close {}
extension FlatH3200 {
    public static var typeName: String { "202" }   // past 780s, the cap
}
enum FlatD3200: Close {}
extension FlatD3200 {
    public static var typeName: String { "8" }
}
enum FlatV3200: Close {}
extension FlatV3200 {
    public static var typeName: String { ">780" }
}

// folded bodies (slices of sixteen, DESIGN21 v29): 400→10s, 800→23s, 1600→70s, 3200→235s.

enum FoldH400: Close {}
extension FoldH400 {
    public static var typeName: String { "70" }    // 10s
}
enum FoldD400: Close {}
extension FoldD400 {
    public static var typeName: String { "140" }
}
enum FoldV400: Close {}
extension FoldV400 {
    public static var typeName: String { "10" }
}
enum FoldH800: Close {}
extension FoldH800 {
    public static var typeName: String { "95" }    // 23s
}
enum FoldD800: Close {}
extension FoldD800 {
    public static var typeName: String { "115" }
}
enum FoldV800: Close {}
extension FoldV800 {
    public static var typeName: String { "23" }
}
enum FoldH1600: Close {}
extension FoldH1600 {
    public static var typeName: String { "129" }   // 70s
}
enum FoldD1600: Close {}
extension FoldD1600 {
    public static var typeName: String { "81" }
}
enum FoldV1600: Close {}
extension FoldV1600 {
    public static var typeName: String { "70" }
}
enum FoldH3200: Close {}
extension FoldH3200 {
    public static var typeName: String { "166" }   // 235s
}
enum FoldD3200: Close {}
extension FoldD3200 {
    public static var typeName: String { "44" }
}
enum FoldV3200: Close {}
extension FoldV3200 {
    public static var typeName: String { "235" }
}

// sliced and sharded (files and renderers, DESIGN21 v30–v32, one commit, one method):
// measured at HEAD by `swift run Tools curve 400 800 1600 3200`.

enum ShardH400: Close {}
extension ShardH400 {
    public static var typeName: String { "73" }    // 11s
}
enum ShardD400: Close {}
extension ShardD400 {
    public static var typeName: String { "137" }
}
enum ShardV400: Close {}
extension ShardV400 {
    public static var typeName: String { "11" }
}
enum ShardH800: Close {}
extension ShardH800 {
    public static var typeName: String { "82" }    // 15s
}
enum ShardD800: Close {}
extension ShardD800 {
    public static var typeName: String { "128" }
}
enum ShardV800: Close {}
extension ShardV800 {
    public static var typeName: String { "15" }
}
enum ShardH1600: Close {}
extension ShardH1600 {
    public static var typeName: String { "103" }   // 30s
}
enum ShardD1600: Close {}
extension ShardD1600 {
    public static var typeName: String { "107" }
}
enum ShardV1600: Close {}
extension ShardV1600 {
    public static var typeName: String { "30" }
}
enum ShardH3200: Close {}
extension ShardH3200 {
    public static var typeName: String { "135" }   // 86s
}
enum ShardD3200: Close {}
extension ShardD3200 {
    public static var typeName: String { "75" }
}
enum ShardV3200: Close {}
extension ShardV3200 {
    public static var typeName: String { "86" }
}

// direct coordinates (DESIGN21 v40): the roster stopped deriving each hire from the
// previous one, so one person's serialized type stopped being an N-deep chain — the
// crash at 6400 was that chain overflowing the compiler's deserializer. Measured at
// HEAD: 9s, 13s, 23s, 34s, 82s, 199s.

enum DirH400: Close {}
extension DirH400 {
    public static var typeName: String { "67" }    // 9s
}
enum DirD400: Close {}
extension DirD400 {
    public static var typeName: String { "143" }
}
enum DirV400: Close {}
extension DirV400 {
    public static var typeName: String { "9" }
}
enum DirH800: Close {}
extension DirH800 {
    public static var typeName: String { "78" }    // 13s
}
enum DirD800: Close {}
extension DirD800 {
    public static var typeName: String { "132" }
}
enum DirV800: Close {}
extension DirV800 {
    public static var typeName: String { "13" }
}
enum DirH1600: Close {}
extension DirH1600 {
    public static var typeName: String { "95" }    // 23s
}
enum DirD1600: Close {}
extension DirD1600 {
    public static var typeName: String { "115" }
}
enum DirV1600: Close {}
extension DirV1600 {
    public static var typeName: String { "23" }
}
enum DirH3200: Close {}
extension DirH3200 {
    public static var typeName: String { "107" }   // 34s
}
enum DirD3200: Close {}
extension DirD3200 {
    public static var typeName: String { "103" }
}
enum DirV3200: Close {}
extension DirV3200 {
    public static var typeName: String { "34" }
}
enum DirH6400: Close {}
extension DirH6400 {
    public static var typeName: String { "134" }   // 82s
}
enum DirD6400: Close {}
extension DirD6400 {
    public static var typeName: String { "76" }
}
enum DirV6400: Close {}
extension DirV6400 {
    public static var typeName: String { "82" }
}
enum DirH12800: Close {}
extension DirH12800 {
    public static var typeName: String { "161" }   // 199s
}
enum DirD12800: Close {}
extension DirD12800 {
    public static var typeName: String { "49" }
}
enum DirV12800: Close {}
extension DirV12800 {
    public static var typeName: String { "199" }
}
enum ChainCrashNoteText: Close {}
extension ChainCrashNoteText {
    public static var typeName: String { "older layouts: compiler crash" }
}
enum ChainCrashNoteY: Close {}
extension ChainCrashNoteY {
    public static var typeName: String { "20" }
}

// ── the groups: three bars where three generations were measured, one accent bar and a
// wall note at the frontier. Slots by weights, no stated x. ──

enum CurveGroup<
    FlatD: Structure, FlatH: Structure, FlatV: Structure,
    FoldD: Structure, FoldH: Structure, FoldV: Structure,
    ShardD: Structure, ShardH: Structure, ShardV: Structure,
    DirD: Structure, DirH: Structure, DirV: Structure
>: HFlow {
    public typealias Given = CurveGroupWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<CurveBarWide, CurveBarArt<FlatD, FlatH, SurfaceTrack, FlatV>>.self
        Air<U2>.self
        Fixed<CurveBarWide, CurveBarArt<FoldD, FoldH, Ink, FoldV>>.self
        Air<U2>.self
        Fixed<CurveBarWide, CurveBarArt<ShardD, ShardH, ActionRole, ShardV>>.self
        Air<U2>.self
        Fixed<CurveBarWide, CurveBarArt<DirD, DirH, AccentRole, DirV>>.self
        RestAir.self
    }
}
enum DirectOnlyGroup<
    DirD: Structure, DirH: Structure, DirV: Structure
>: HFlow {
    public typealias Given = CurveGroupWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<CurveBarWide, CurveBarArt<DirD, DirH, AccentRole, DirV>>.self
        RestAir.self
    }
}

enum CurvePlotRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<CurveGroupWide, SpanHosted<CurveGroup<FlatD400, FlatH400, FlatV400, FoldD400, FoldH400, FoldV400, ShardD400, ShardH400, ShardV400, DirD400, DirH400, DirV400>>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, SpanHosted<CurveGroup<FlatD800, FlatH800, FlatV800, FoldD800, FoldH800, FoldV800, ShardD800, ShardH800, ShardV800, DirD800, DirH800, DirV800>>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, SpanHosted<CurveGroup<FlatD1600, FlatH1600, FlatV1600, FoldD1600, FoldH1600, FoldV1600, ShardD1600, ShardH1600, ShardV1600, DirD1600, DirH1600, DirV1600>>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, SpanHosted<CurveGroup<FlatD3200, FlatH3200, FlatV3200, FoldD3200, FoldH3200, FoldV3200, ShardD3200, ShardH3200, ShardV3200, DirD3200, DirH3200, DirV3200>>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, SpanHosted<DirectOnlyGroup<DirD6400, DirH6400, DirV6400>>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, SpanHosted<DirectOnlyGroup<DirD12800, DirH12800, DirV12800>>>.self
        RestAir.self
    }
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

// ── the axis: one N label under each group, the wall note under the frontier ──

enum CurveAxisY: Close {}
extension CurveAxisY {
    public static var typeName: String { "16" }
}
enum CurveAxisSpan<T: Structure>: SpanLabelMid {
    public typealias Y = CurveAxisY
    public typealias FillColor = TextPrimary
    public typealias Size = TextXS
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum AxisN400: Close {}
extension AxisN400 {
    public static var typeName: String { "400" }
}
enum AxisN800: Close {}
extension AxisN800 {
    public static var typeName: String { "800" }
}
enum AxisN1600: Close {}
extension AxisN1600 {
    public static var typeName: String { "1600" }
}
enum AxisN3200: Close {}
extension AxisN3200 {
    public static var typeName: String { "3200" }
}
enum AxisN6400: Close {}
extension AxisN6400 {
    public static var typeName: String { "6400" }
}
enum AxisN12800: Close {}
extension AxisN12800 {
    public static var typeName: String { "12800" }
}
enum FrontierAxisArt: HFlow {
    public typealias Given = CurveGroupWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<CurveWallWide, Layered<CurveAxisSpan<AxisN6400>, SpanLowered<ChainCrashNoteY, CurveValueSpan<ChainCrashNoteText>>>>.self
        RestAir.self
    }
}
enum CurveAxisRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<CurveGroupWide, CurveAxisSpan<AxisN400>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, CurveAxisSpan<AxisN800>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, CurveAxisSpan<AxisN1600>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, CurveAxisSpan<AxisN3200>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, SpanHosted<FrontierAxisArt>>.self
        Air<HairBreath>.self
        Fixed<CurveGroupWide, CurveAxisSpan<AxisN12800>>.self
        RestAir.self
    }
}

// ── the legend: a chip per generation, its label beside it ──

enum LegendChipTall: Close {}
extension LegendChipTall {
    public static var typeName: String { "12" }
}
enum LegendChipDrop: Close {}
extension LegendChipDrop {
    public static var typeName: String { "6" }
}
enum LegendLabelY: Close {}
extension LegendLabelY {
    public static var typeName: String { "16" }
}
enum LegendChip<Fill: Structure>: SpanTrack {
    public typealias H = LegendChipTall
    public typealias Radius = R6
    public typealias Fill = Fill
}
enum LegendLabel<T: Structure>: SpanLabelMid {
    public typealias Y = LegendLabelY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum LegendFlatText: Close {}
extension LegendFlatText {
    public static var typeName: String { "flat bodies" }
}
enum LegendFoldText: Close {}
extension LegendFoldText {
    public static var typeName: String { "folded into slices" }
}
enum LegendShardText: Close {}
extension LegendShardText {
    public static var typeName: String { "sliced and sharded" }
}
enum LegendDirectText: Close {}
extension LegendDirectText {
    public static var typeName: String { "direct coordinates" }
}
enum CurveLegendRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<LegendChipWide, SpanLowered<LegendChipDrop, LegendChip<SurfaceTrack>>>.self
        Air<HairBreath>.self
        Fixed<LegendTextWide, LegendLabel<LegendFlatText>>.self
        Air<Breath>.self
        Fixed<LegendChipWide, SpanLowered<LegendChipDrop, LegendChip<Ink>>>.self
        Air<HairBreath>.self
        Fixed<LegendTextWide, LegendLabel<LegendFoldText>>.self
        Air<Breath>.self
        Fixed<LegendChipWide, SpanLowered<LegendChipDrop, LegendChip<ActionRole>>>.self
        Air<HairBreath>.self
        Fixed<LegendTextWide, LegendLabel<LegendShardText>>.self
        Air<Breath>.self
        Fixed<LegendChipWide, SpanLowered<LegendChipDrop, LegendChip<AccentRole>>>.self
        Air<HairBreath>.self
        Fixed<LegendWideTextWide, LegendLabel<LegendDirectText>>.self
        RestAir.self
    }
}

// ── the slot widths are the dictionary's rungs (Design.swift): the demo names
// magnitudes, the dictionary spells them ──

// ── the rows on their summed drops, the frame grown from the storeys ──

enum CurveTitleSpan: SpanLabelMid {
    public typealias Y = CurveTitleY
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = CurveTitleText
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
        CurveDropAt<CurvePlotDrop, CurvePlotRow>.self
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
    print("generated 1 saturation curve (Vector composition, measurements stated)")
}
