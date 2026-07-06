import VerificationIsIdentification
import DocumentKit
import Organization

// architecture.svg, as a `Vector` composition (DESIGN7 §3): the exact layout accepted in
// DESIGN6 §3 (the V=I slab, the System/Query/View stack, DocumentKit, the two outputs, four
// dashed dependency arrows, every arrow label offset clear of its line), on the span engine:
// every zone is a weighed row over the surface, every straight arrow is a slice (its gap IS
// the arrow), and the one irregular piece left is the long dependency ROUTE, a stated path
// (§S22: route data, like a glyph's curve, is stated, not decomposed). Vertical positions
// stay stated tokens until the height walk lands.

// ── the aria-label — the one long sentence a screen reader gets in place of the drawing ──
enum ArchitectureLabel: Close {}
extension ArchitectureLabel {
    public static var typeName: String {
        "Architecture: System, Query, View, and DocumentKit are all written in the "
            + "VerificationIsIdentification (V=I) framework's types, the package's one dependency, "
            + "not Foundation — four dashed arrows, one shared label. The solid flow runs System to "
            + "Query to View to DocumentKit to the documentation site; View is also read a second way, "
            + "directly, by the console audit (swift run OrgDemo audit), bypassing the render engine "
            + "entirely."
    }
}
typealias ArchitectureSize = CanvasSize<WideSurface, ArchitectureTall>

// ── shared row anatomy: the slab's slice, the main column's slice, the right zone ──


// ── the four dependency arrows — all back to V=I, one shared label. The three short ones
// point back across their own gap slices; the long one from DocumentKit is a stated ROUTE,
// the file's one irregular path, its corners route data. ──

// The long dependency, walked by the pen: rise thirty in from DocumentKit's box edge,
// go up until the ceiling lane, left until the slab's centre, down until the slab's top.
// Three stopping conditions and a start; the corners derive.
typealias DependencyRise = GivenSpan<Plus<ArchBoxLeft, ArchRiseInset>>
enum ArrowDocumentKitToVI: DashedArrow {
    public typealias Path = UntilY<
        UntilX<
            UntilY<
                StartAt<DependencyRise, ArchThirdRowDrop>,
                ArchCeiling
            >,
            GivenSpan<ArchSlabCenter>
        >,
        ArchSlabDrop
    >
}

enum WrittenInItsTypesText: Close {}
extension WrittenInItsTypesText {
    public static var typeName: String { "written in its types" }
}
enum WrittenInItsTypesSpan: SpanLabelItalicMid {
    public typealias Y = Under<ArchCeiling, FirstCaptionBase>
    public typealias Size = TextXXS
    public typealias Content = WrittenInItsTypesText
}
enum WrittenInItsTypesRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchAnnotationLeft>.self
        Fixed<ArchAnnotationWide, WrittenInItsTypesSpan>.self
        RestAir.self
        RestAir.self
    }
}

/// A dashed arrow pointing back across its slice: the dependency's voice, dashed, head at
/// the slice's start. Stated here because only this diagram draws one.
enum DependencyBackPath<Y: Structure>: Close {}
extension DependencyBackPath {
    public static var typeName: String { "" }
}
enum DependencyArrowSpan<YLine: Structure>: SpanArrowBackAcross {
    public typealias Y = YLine
}
enum DependencyBackRow<YLine: Structure>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchDependencyLeft>.self
        Fixed<ArchDependencyWide, DashedBackSpan<YLine>>.self
        RestAir.self
    }
}
/// The dashed back-arrow itself: dashes and the shared head, drawn across the slice from
/// its end to its start.
public enum DashedBackSpan<YLine: Structure>: Close {}
extension DashedBackSpan: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<path d=\"M\(SpanPx<Sum<X, W>>.typeName),\(YLine.typeName) L\(SpanPx<X>.typeName),\(YLine.typeName)\" "
            + "stroke=\"\(TextSecondary.typeName)\" stroke-width=\"\(ArrowWidth.typeName)\" stroke-dasharray=\"\(DependencyDash.typeName)\" "
            + "fill=\"none\" marker-end=\"url(#\(ArrowHeadName.typeName))\"/>\n"
    }
}

enum DependencyArrows: Group {
    @StructureBuilder
    public static var body: some Structure {
        ArrowDocumentKitToVI.self
        WrittenInItsTypesRow.self
        DependencyBackRow<Halfway<ArchSystemDrop, ArchSystemBottom>>.self
        DependencyBackRow<Halfway<ArchQueryDrop, ArchQueryBottom>>.self
        DependencyBackRow<Halfway<ArchThirdRowDrop, ArchThirdRowBottom>>.self
    }
}

// ── DESIGN11 b2 — the diagram explains itself. Hovering a layer box reveals a panel: a couple
// of words on what lives there (no census number stated here — §S15's own rule against a
// hand-typed count — only role-language a fact can't drift out from under) plus a `Linked`
// `open` into a real page that reads it. One shared panel row, placed at each box's own
// vertical; hovering a flow arrow (`HoverHighlight`) brightens its stroke. The panel and the
// highlight are BOTH dop-info, never the only copy of a fact the box's own always-visible
// title/subtitle already states. ──

enum OpenLinkText: Close {}
extension OpenLinkText {
    public static var typeName: String { "open →" }
}
enum PanelFace: SpanTrackOutlined {
    public typealias H = Tally<ArchPanelTall>
    public typealias Radius = R12
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
// In-panel and in-box baselines are typography, the stated hole: each hangs its words a
// stated fall under its zone's own rung, so the structure moves and the words follow.
enum PanelTitleBase: Close {}
extension PanelTitleBase {
    public static var typeName: String { "24" }
}
enum PanelBodyBase: Close {}
extension PanelBodyBase {
    public static var typeName: String { "50" }
}
enum PanelLinkBase: Close {}
extension PanelLinkBase {
    public static var typeName: String { "76" }
}
enum PanelTitleSpan<T: Structure>: SpanLabel {
    public typealias Y = PanelTitleBase
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum PanelBodySpan<T: Structure>: SpanLabel {
    public typealias Y = PanelBodyBase
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PanelLinkSpan: SpanLabel {
    public typealias Y = PanelLinkBase
    public typealias FillColor = ActionRole
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = OpenLinkText
}
enum PanelInterior<
    Title: Structure,
    Body: Structure,
    Target: Structure
>: HFlow {
    public typealias Given = ArchPanelWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<
            Layered<
                PanelTitleSpan<Title>,
                Layered<PanelBodySpan<Body>, SpanLink<Target, PanelLinkSpan>>
            >
        >.self
        Air<EdgeMargin>.self
    }
}
enum PanelRow<
    Title: Structure,
    Body: Structure,
    Target: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchPanelLeft>.self
        Fixed<
            ArchPanelWide,
            SpanSoftShadowed<Layered<PanelFace, SpanHosted<PanelInterior<Title, Body, Target>>>>
        >.self
        Air<PanelInset>.self
        RestAir.self
    }
}
enum PanelPlaced<
    DropY: Structure,
    Title: Structure,
    Body: Structure,
    Target: Structure
>: Dropped {
    public typealias Y = DropY
    public typealias Content = PanelRow<Title, Body, Target>
}

enum SystemPanelTitleText: Close {}
extension SystemPanelTitleText {
    public static var typeName: String { "System/" }
}
enum SystemPanelBodyText: Close {}
extension SystemPanelBodyText {
    public static var typeName: String { "People, roles, departments, gates" }
}
enum SystemPanelTarget: Close {}
extension SystemPanelTarget {
    public static var typeName: String { "/documentation/organization/" + PageSlug<Nav.CompanyDashboard>.typeName }
}
enum QueryPanelTitleText: Close {}
extension QueryPanelTitleText {
    public static var typeName: String { "Query/" }
}
enum QueryPanelBodyText: Close {}
extension QueryPanelBodyText {
    public static var typeName: String { "Granted? Owns it? Invariants hold?" }
}
enum QueryPanelTarget: Close {}
extension QueryPanelTarget {
    public static var typeName: String { "/documentation/organization/" + PageSlug<Nav.Reports>.typeName }
}
enum ViewPanelTitleText: Close {}
extension ViewPanelTitleText {
    public static var typeName: String { "View/" }
}
enum ViewPanelBodyText: Close {}
extension ViewPanelBodyText {
    public static var typeName: String { "Every page composed from the system's types" }
}
enum ViewPanelTarget: Close {}
extension ViewPanelTarget {
    public static var typeName: String { "/documentation/organization/" + PageSlug<Nav.Employees>.typeName }
}
enum DocumentKitPanelTitleText: Close {}
extension DocumentKitPanelTitleText {
    public static var typeName: String { "DocumentKit" }
}
enum DocumentKitPanelBodyText: Close {}
extension DocumentKitPanelBodyText {
    public static var typeName: String { "typeName walks the page's body once" }
}
/// Not an Organization page: DocumentKit's module landing page, a different DocC target
/// entirely, a raw absolute path, not `SitePath`/`PageSlug` (those read Organization's
/// symbols), the plain-string door `<a href>` has always stood on (Vector.swift's `Linked`).
enum DocumentKitPanelTarget: Close {}
extension DocumentKitPanelTarget {
    public static var typeName: String { "/documentation/documentkit" }
}
// Every panel opens in the same right-zone slice, DocumentKit's included: anchored at its
// own box, that panel's 320 width would run 80 past the canvas edge.
typealias SystemPanelPlaced = PanelPlaced<Tally<ArchSystemDrop>, SystemPanelTitleText, SystemPanelBodyText, SystemPanelTarget>
typealias QueryPanelPlaced = PanelPlaced<Tally<ArchQueryDrop>, QueryPanelTitleText, QueryPanelBodyText, QueryPanelTarget>
typealias ViewPanelPlaced = PanelPlaced<Tally<ArchThirdRowDrop>, ViewPanelTitleText, ViewPanelBodyText, ViewPanelTarget>
typealias DocumentKitPanelPlaced = PanelPlaced<Tally<ArchFourthPanelDrop>, DocumentKitPanelTitleText, DocumentKitPanelBodyText, DocumentKitPanelTarget>

// ── the V=I slab — full height, everything answers to it. `Ink`, DESIGN10 §5 (was a bespoke
// indigo); text `Paper` throughout — the same pair the formal gate (`LegibleOnInk`) would
// grant, even though this diagram predates that mechanism and does not use it directly.
//
// DESIGN11 leaves this one pairing flat, on purpose: the slab is a fixed dark anchor by
// original design (DESIGN6 §3 — "everything answers to it"), not a panel meant to read as
// either theme's surface. `Ink`/`Paper` are not members of the eight-role table (a1) at all;
// converting them would either wash the slab out to the same white as the three lighter boxes
// beside it in the light theme (destroying the hierarchy the slab exists to draw), or require a
// role the table never asked for. Reported here, not silently kept. ──

enum SlabFace: SpanTrack {
    public typealias H = Tally<ArchSlabTall>
    public typealias Radius = R12
    public typealias Fill = Ink
}
enum SlabLineBold<T: Structure, YLine: Structure>: SpanLabelMid {
    public typealias Y = YLine
    public typealias FillColor = Paper
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum SlabLine<T: Structure, YLine: Structure>: SpanLabelMid {
    public typealias Y = YLine
    public typealias FillColor = Paper
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
// The slab's six-line stack: stated baselines under the slab's own drop.
enum ViStackBase1: Close {}
extension ViStackBase1 {
    public static var typeName: String { "160" }
}
enum ViStackBase2: Close {}
extension ViStackBase2 {
    public static var typeName: String { "182" }
}
enum ViStackBase3: Close {}
extension ViStackBase3 {
    public static var typeName: String { "204" }
}
enum ViStackBase4: Close {}
extension ViStackBase4 {
    public static var typeName: String { "230" }
}
enum ViStackBase5: Close {}
extension ViStackBase5 {
    public static var typeName: String { "244" }
}
enum ViStackBase6: Close {}
extension ViStackBase6 {
    public static var typeName: String { "258" }
}
enum ViText1: Close {}
extension ViText1 {
    public static var typeName: String { "Verification" }
}
enum ViText2: Close {}
extension ViText2 {
    public static var typeName: String { "Is" }
}
enum ViText3: Close {}
extension ViText3 {
    public static var typeName: String { "Identification" }
}
enum ViText4: Close {}
extension ViText4 {
    public static var typeName: String { "the type lattice," }
}
enum ViText5: Close {}
extension ViText5 {
    public static var typeName: String { "the one dependency" }
}
enum ViText6: Close {}
extension ViText6 {
    public static var typeName: String { "(not Foundation)" }
}
enum ViSlabRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<SlabLeft>.self
        Fixed<
            SlabWide,
            Layered<
                SpanLowered<Tally<ArchSlabDrop>, SlabFace>,
                Layered<
                    Layered<
                        SlabLineBold<ViText1, Under<ArchSlabDrop, ViStackBase1>>,
                        Layered<
                            SlabLineBold<ViText2, Under<ArchSlabDrop, ViStackBase2>>,
                            SlabLineBold<ViText3, Under<ArchSlabDrop, ViStackBase3>>
                        >
                    >,
                    Layered<
                        SlabLine<ViText4, Under<ArchSlabDrop, ViStackBase4>>,
                        Layered<
                            SlabLine<ViText5, Under<ArchSlabDrop, ViStackBase5>>,
                            SlabLine<ViText6, Under<ArchSlabDrop, ViStackBase6>>
                        >
                    >
                >
            >
        >.self
        RestAir.self
    }
}

// ── the baseline vocabulary: every stated text fall this canvas hangs under its rungs.
// Typography, the one stated hole; named once, read by role. ──

enum TallTitleBase: Close {}
extension TallTitleBase {
    public static var typeName: String { "34" }
}
enum BoxTitleBase: Close {}
extension BoxTitleBase {
    public static var typeName: String { "31" }
}
enum SnugTitleBase: Close {}
extension SnugTitleBase {
    public static var typeName: String { "28" }
}
enum FirstSubtitleBase: Close {}
extension FirstSubtitleBase {
    public static var typeName: String { "54" }
}
enum SecondSubtitleBase: Close {}
extension SecondSubtitleBase {
    public static var typeName: String { "68" }
}
enum WideSubtitleBase: Close {}
extension WideSubtitleBase {
    public static var typeName: String { "55" }
}
enum SnugFirstSubtitleBase: Close {}
extension SnugFirstSubtitleBase {
    public static var typeName: String { "47" }
}
enum SnugSecondSubtitleBase: Close {}
extension SnugSecondSubtitleBase {
    public static var typeName: String { "61" }
}
enum FirstCaptionBase: Close {}
extension FirstCaptionBase {
    public static var typeName: String { "24" }
}
enum SecondCaptionBase: Close {}
extension SecondCaptionBase {
    public static var typeName: String { "36" }
}
enum LoneCaptionBase: Close {}
extension LoneCaptionBase {
    public static var typeName: String { "23" }
}
enum GapFirstBase: Close {}
extension GapFirstBase {
    public static var typeName: String { "14" }
}
enum GapSecondBase: Close {}
extension GapSecondBase {
    public static var typeName: String { "26" }
}
enum OutputFirstCaptionBase: Close {}
extension OutputFirstCaptionBase {
    public static var typeName: String { "47" }
}
enum OutputSecondCaptionBase: Close {}
extension OutputSecondCaptionBase {
    public static var typeName: String { "59" }
}
enum TitleOnAccentBase: Close {}
extension TitleOnAccentBase {
    public static var typeName: String { "27" }
}
enum SubtitleOnAccentBase: Close {}
extension SubtitleOnAccentBase {
    public static var typeName: String { "45" }
}

// ── the main column's boxes: one face, centred titles, a hover dot on the top-right, each
// box a row that IS its own hover trigger ──

enum MainBoxFace<H: Structure>: SpanTrackOutlined {
    public typealias H = H
    public typealias Radius = R12
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum BoxDotSpan<CY: Structure>: SpanDot {
    public typealias CY = CY
    public typealias R = HoverAffordanceRadius
    public typealias Fill = ActionRole
}
enum MainBoxDotRow<CY: Structure>: HFlow {
    public typealias Given = ArchColumnWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<DotSlot, BoxDotSpan<CY>>.self
        Air<HairBreath>.self
    }
}

enum SystemTitleText: Close {}
extension SystemTitleText {
    public static var typeName: String { "System/" }
}
enum SystemSubtitle1Text: Close {}
extension SystemSubtitle1Text {
    public static var typeName: String { "people · roles · departments · documents" }
}
enum SystemSubtitle2Text: Close {}
extension SystemSubtitle2Text {
    public static var typeName: String { "gates · the year-close interlock" }
}
enum MainTitleSpan<T: Structure, YLine: Structure, TitleSize: Structure>: SpanLabelMid {
    public typealias Y = YLine
    public typealias FillColor = TextPrimary
    public typealias Size = TitleSize
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum MainSubtitleSpan<T: Structure, YLine: Structure>: SpanLabelMid {
    public typealias Y = YLine
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum SystemRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchColumnLeft>.self
        Fixed<
            ArchColumnWide,
            Layered<
                SpanLowered<Tally<ArchSystemDrop>, MainBoxFace<Tally<ArchSystemTall>>>,
                Layered<
                    Layered<MainTitleSpan<SystemTitleText, Under<ArchSystemDrop, TallTitleBase>, TextL>, MainSubtitleSpan<SystemSubtitle1Text, Under<ArchSystemDrop, FirstSubtitleBase>>>,
                    Layered<MainSubtitleSpan<SystemSubtitle2Text, Under<ArchSystemDrop, SecondSubtitleBase>>, SpanHosted<MainBoxDotRow<Tally<Plus<ArchSystemDrop, ArchDotDip>>>>>
                >
            >
        >.self
        RestAir.self
        RestAir.self
    }
}
enum SystemArrowRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchColumnLeft>.self
        Fixed<ArchColumnWide, FlowArrowDown<Tally<ArchSystemBottom>, Tally<Rest<ArchQueryDrop, ArchFlowNose>>>>.self
        RestAir.self
        RestAir.self
    }
}
enum FlowArrowDown<FromY: Structure, ToY: Structure>: SpanArrowDown {
    public typealias FromY = FromY
    public typealias ToY = ToY
}
typealias ArrowCaptionLeft = ArchCaptionLeft
enum ArrowCaptionSpan<T: Structure, YLine: Structure>: SpanLabelItalic {
    public typealias Y = YLine
    public typealias Size = TextXXS
    public typealias Content = T
}
enum ArrowCaptionRow<Caption: Spanning>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArrowCaptionLeft>.self
        Fixed<ArchCaptionWide, Caption>.self
        RestAir.self
        RestAir.self
    }
}
enum SystemArrowLabel1Text: Close {}
extension SystemArrowLabel1Text {
    public static var typeName: String { "compiling enforces the policy" }
}
enum SystemArrowLabel2Text: Close {}
extension SystemArrowLabel2Text {
    public static var typeName: String { "and proves every access" }
}
enum SystemReveal: HoverReveal {
    public typealias Trigger = SystemRow
    public typealias Panel = SystemPanelPlaced
}
enum SystemArrowHighlighted: HoverHighlight {
    public typealias Content = SystemArrowRow
}
enum SystemSection: Group {
    @StructureBuilder
    public static var body: some Structure {
        SystemReveal.self
        SystemArrowHighlighted.self
        ArrowCaptionRow<ArrowCaptionSpan<SystemArrowLabel1Text, Under<ArchSystemBottom, FirstCaptionBase>>>.self
        ArrowCaptionRow<ArrowCaptionSpan<SystemArrowLabel2Text, Under<ArchSystemBottom, SecondCaptionBase>>>.self
    }
}

// ── Query ──
enum QueryTitleText: Close {}
extension QueryTitleText {
    public static var typeName: String { "Query/" }
}
enum QuerySubtitleText: Close {}
extension QuerySubtitleText {
    public static var typeName: String { "granted? · who owns it? · do the invariants hold?" }
}
enum QueryRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchColumnLeft>.self
        Fixed<
            ArchColumnWide,
            Layered<
                SpanLowered<Tally<ArchQueryDrop>, MainBoxFace<Tally<ArchLowBoxTall>>>,
                Layered<
                    Layered<MainTitleSpan<QueryTitleText, Under<ArchQueryDrop, BoxTitleBase>, TextM>, MainSubtitleSpan<QuerySubtitleText, Under<ArchQueryDrop, FirstSubtitleBase>>>,
                    SpanHosted<MainBoxDotRow<Tally<Plus<ArchQueryDrop, ArchDotDip>>>>
                >
            >
        >.self
        RestAir.self
        RestAir.self
    }
}
enum QueryArrowRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchColumnLeft>.self
        Fixed<ArchColumnWide, FlowArrowDown<Tally<ArchQueryBottom>, Tally<Rest<ArchThirdRowDrop, ArchFlowNose>>>>.self
        RestAir.self
        RestAir.self
    }
}
enum QueryArrowLabelText: Close {}
extension QueryArrowLabelText {
    public static var typeName: String { "verdicts" }
}
enum QueryReveal: HoverReveal {
    public typealias Trigger = QueryRow
    public typealias Panel = QueryPanelPlaced
}
enum QueryArrowHighlighted: HoverHighlight {
    public typealias Content = QueryArrowRow
}
enum QuerySection: Group {
    @StructureBuilder
    public static var body: some Structure {
        QueryReveal.self
        QueryArrowHighlighted.self
        ArrowCaptionRow<ArrowCaptionSpan<QueryArrowLabelText, Under<ArchQueryBottom, LoneCaptionBase>>>.self
    }
}

// ── View ──
enum ViewTitleText: Close {}
extension ViewTitleText {
    public static var typeName: String { "View/" }
}
enum ViewSubtitleText: Close {}
extension ViewSubtitleText {
    public static var typeName: String { "every page is a type composed from the system's types" }
}
enum ViewRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchColumnLeft>.self
        Fixed<
            ArchColumnWide,
            Layered<
                SpanLowered<Tally<ArchThirdRowDrop>, MainBoxFace<Tally<ArchLowBoxTall>>>,
                Layered<
                    Layered<MainTitleSpan<ViewTitleText, Under<ArchThirdRowDrop, BoxTitleBase>, TextM>, MainSubtitleSpan<ViewSubtitleText, Under<ArchThirdRowDrop, WideSubtitleBase>>>,
                    SpanHosted<MainBoxDotRow<Tally<Plus<ArchThirdRowDrop, ArchDotDip>>>>
                >
            >
        >.self
        RestAir.self
        RestAir.self
    }
}
// The arrow to DocumentKit crosses the gap between View's right edge and DocumentKit's
// left edge; its two-line caption sits on the same gap's middle.
enum ViewArrowSpan: SpanArrowAcross {
    public typealias Y = Halfway<ArchThirdRowDrop, ArchThirdRowBottom>
}
enum ViewArrowLabel1Text: Close {}
extension ViewArrowLabel1Text {
    public static var typeName: String { "typeName" }
}
enum ViewArrowLabel2Text: Close {}
extension ViewArrowLabel2Text {
    public static var typeName: String { "walks them" }
}
enum GapCaptionSpan<T: Structure, YLine: Structure>: SpanLabelItalicMid {
    public typealias Y = YLine
    public typealias Size = TextXXS
    public typealias Content = T
}
enum ViewToDocumentKitGapRow<Content: Spanning>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchGapLeft>.self
        Fixed<ArchGapWide, Content>.self
        RestAir.self
        RestAir.self
    }
}
enum ViewReveal: HoverReveal {
    public typealias Trigger = ViewRow
    public typealias Panel = ViewPanelPlaced
}
enum ViewArrowHighlighted: HoverHighlight {
    public typealias Content = ViewToDocumentKitGapRow<ViewArrowSpan>
}
enum ViewSection: Group {
    @StructureBuilder
    public static var body: some Structure {
        ViewReveal.self
        ViewArrowHighlighted.self
        ViewToDocumentKitGapRow<GapCaptionSpan<ViewArrowLabel1Text, Under<ArchThirdRowDrop, GapFirstBase>>>.self
        ViewToDocumentKitGapRow<GapCaptionSpan<ViewArrowLabel2Text, Under<ArchThirdRowDrop, GapSecondBase>>>.self
    }
}

// ── DocumentKit ──
enum DocumentKitTitleText: Close {}
extension DocumentKitTitleText {
    public static var typeName: String { "DocumentKit" }
}
enum DocumentKitSubtitle1Text: Close {}
extension DocumentKitSubtitle1Text {
    public static var typeName: String { "the render engine — pages" }
}
enum DocumentKitSubtitle2Text: Close {}
extension DocumentKitSubtitle2Text {
    public static var typeName: String { "are types, `typeName` walks them" }
}
enum DocumentKitSubtitleSpan<T: Structure, YLine: Structure>: SpanLabelMid {
    public typealias Y = YLine
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum DocumentKitDotRow: HFlow {
    public typealias Given = ArchBoxWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<DotSlot, BoxDotSpan<Tally<Plus<ArchThirdRowDrop, ArchDotDip>>>>.self
        Air<HairBreath>.self
    }
}
enum DocumentKitRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchBoxLeft>.self
        Fixed<
            ArchBoxWide,
            Layered<
                SpanLowered<Tally<ArchThirdRowDrop>, MainBoxFace<Tally<ArchLowBoxTall>>>,
                Layered<
                    Layered<MainTitleSpan<DocumentKitTitleText, Under<ArchThirdRowDrop, SnugTitleBase>, TextM>, DocumentKitSubtitleSpan<DocumentKitSubtitle1Text, Under<ArchThirdRowDrop, SnugFirstSubtitleBase>>>,
                    Layered<DocumentKitSubtitleSpan<DocumentKitSubtitle2Text, Under<ArchThirdRowDrop, SnugSecondSubtitleBase>>, SpanHosted<DocumentKitDotRow>>
                >
            >
        >.self
        RestAir.self
        RestAir.self
    }
}
enum DocumentKitReveal: HoverReveal {
    public typealias Trigger = DocumentKitRow
    public typealias Panel = DocumentKitPanelPlaced
}
/// No arrow to highlight: DocumentKit is this flow's endpoint, only reached (View's
/// arrow already carries that hover).
enum DocumentKitSection: Group {
    @StructureBuilder
    public static var body: some Structure {
        DocumentKitReveal.self
    }
}

// ── the two outputs: View read directly (console audit), DocumentKit rendered (the site) ──

enum ConsoleArrowRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchConsoleArrowLeft>.self
        Fixed<DotSlot, FlowArrowDown<Tally<ArchThirdRowBottom>, Tally<Rest<ArchOutputDrop, ArchOutputNose>>>>.self
        RestAir.self
    }
}
enum SiteArrowRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchSiteArrowLeft>.self
        Fixed<DotSlot, FlowArrowDown<Tally<ArchThirdRowBottom>, Tally<Rest<ArchOutputDrop, ArchOutputNose>>>>.self
        RestAir.self
        RestAir.self
    }
}
enum ConsoleArrowLabel1Text: Close {}
extension ConsoleArrowLabel1Text {
    public static var typeName: String { "printed by the demo," }
}
enum ConsoleArrowLabel2Text: Close {}
extension ConsoleArrowLabel2Text {
    public static var typeName: String { "bypassing the engine" }
}
enum ConsoleCaptionRow<Caption: Spanning>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchConsoleCaptionLeft>.self
        Fixed<ArchConsoleCaptionWide, Caption>.self
        RestAir.self
        RestAir.self
    }
}
enum OutputArrows: Group {
    @StructureBuilder
    public static var body: some Structure {
        ConsoleArrowRow.self
        ConsoleCaptionRow<ArrowCaptionSpan<ConsoleArrowLabel1Text, Under<ArchThirdRowBottom, OutputFirstCaptionBase>>>.self
        ConsoleCaptionRow<ArrowCaptionSpan<ConsoleArrowLabel2Text, Under<ArchThirdRowBottom, OutputSecondCaptionBase>>>.self
        SiteArrowRow.self
    }
}

// ── the two output boxes — the diagram's own one hero (DESIGN10 §5): two READINGS of the
// same proved types, the meaning `AccentRole` marks here (DESIGN11: `OnAccent` text, its only
// legal pairing). ──

enum OutputFace: SpanTrack {
    public typealias H = Tally<ArchOutputTall>
    public typealias Radius = R12
    public typealias Fill = AccentRole
}
enum OutputTitleSpan<T: Structure>: SpanLabelMid {
    public typealias Y = Under<ArchOutputDrop, TitleOnAccentBase>
    public typealias FillColor = OnAccent
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum OutputSubtitleSpan<T: Structure>: SpanLabelMid {
    public typealias Y = Under<ArchOutputDrop, SubtitleOnAccentBase>
    public typealias FillColor = OnAccent
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum ConsoleTitleText: Close {}
extension ConsoleTitleText {
    public static var typeName: String { "Console audit" }
}
enum ConsoleSubtitleText: Close {}
extension ConsoleSubtitleText {
    public static var typeName: String { "swift run OrgDemo audit" }
}
enum SiteTitleText: Close {}
extension SiteTitleText {
    public static var typeName: String { "This documentation" }
}
enum SiteSubtitleText: Close {}
extension SiteSubtitleText {
    public static var typeName: String { "generated from the same types" }
}
typealias OutputBoxArt<
    Title: Structure,
    Subtitle: Structure
> = Layered<
    SpanLowered<Tally<ArchOutputDrop>, OutputFace>,
    Layered<OutputTitleSpan<Title>, OutputSubtitleSpan<Subtitle>>
>
enum OutputBoxesRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ArchColumnLeft>.self
        Fixed<ArchOutputWide, OutputBoxArt<ConsoleTitleText, ConsoleSubtitleText>>.self
        Air<ArchOutputGap>.self
        Fixed<ArchOutputWide, OutputBoxArt<SiteTitleText, SiteSubtitleText>>.self
        RestAir.self
        RestAir.self
    }
}

// ── footer ──
enum FooterText: Close {}
extension FooterText {
    public static var typeName: String { "System and Query hold no stored values: the View is the only place a type becomes one." }
}
enum FooterSpan: SpanLabelMid {
    public typealias Y = Tally<ArchFooterDrop>
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = FooterText
}
enum FooterRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<FooterSpan>.self
    }
}

// ── the whole diagram ──
// SVG has no z-index: paint order IS document order, so a hover panel only ever renders
// "on top" of content declared BEFORE it. OutputArrows/OutputBoxesRow/FooterRow sit here,
// ahead of every box section, precisely because View's and DocumentKit's own panels reach
// down into the same screen region the output boxes and footer occupy. DocumentKitSection
// comes before ViewSection for the same reason, one level up: View's panel opens across
// DocumentKit's box; declared later, it would paint under that box instead of above it.
enum ArchitectureContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        ArrowMarkers.self
        SoftShadow.self
        HoverRevealStyle.self
        DependencyArrows.self
        OutputArrows.self
        OutputBoxesRow.self
        FooterRow.self
        ViSlabRow.self
        SystemSection.self
        QuerySection.self
        DocumentKitSection.self
        ViewSection.self
    }
}
// A stated frame by decision: the architecture's vertical is zone rungs plus an L-route
// (DiagramGeometry.swift), stated facts of one drawing, not a divided axis for a frame to
// derive. The zones become axes the day the route does; until then the frame is stated.
enum ArchitectureDiagram: Diagram {
    public typealias Size = ArchitectureSize
    public typealias AriaLabel = ArchitectureLabel
    public typealias Content = ArchitectureContent
}

func runDiagram() {
    write(ArchitectureDiagram.typeName, "architecture")
    print("generated 1 architecture diagram (Vector composition)")
}
