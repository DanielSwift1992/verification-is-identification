import VerificationIsIdentification
import DocumentKit
import Organization

// architecture.svg — the package, drawn by the engine it describes. One flow, top down:
// the lattice everything composes, the engine that reads it (rendering and the guided
// walks), the company written in both, and the two outputs every build produces. The
// frame derives from the row talls and nothing else, every row falls on a summed drop
// (the fascia), and the numbers on the boxes are the census this very build counted
// (CensusGen), so the picture cannot claim what the code stopped being. Hovering a box
// reveals one line and a door that really opens.

enum ArchitectureLabel: Close {}
extension ArchitectureLabel {
    public static var typeName: String {
        "The package, top down: the V=I type lattice, the DocumentKit engine that renders "
            + "and walks it, the Organization written in both, and the two outputs "
            + "of every build, the rendered site and the console audit. Each box names its role, "
            + "its parts, and its census, counted by this build, and opens on click."
    }
}

// ── the geometry: widths derive from the surface, drops from the talls ──

typealias ArchInner = Rest<WideSurface, Twice<EdgeMargin>>
typealias ArchPairBoxWide = Half<Rest<ArchInner, Gutter>>
typealias ArchBarDrop = EdgeMargin
typealias ArchGapOneDrop = Plus<ArchBarDrop, ArchStackTall>
typealias ArchEngineDrop = Plus<ArchGapOneDrop, ArchGapTall>
typealias ArchGapTwoDrop = Plus<ArchEngineDrop, ArchStackTall>
typealias ArchCompanyDrop = Plus<ArchGapTwoDrop, ArchGapTall>
typealias ArchGapThreeDrop = Plus<ArchCompanyDrop, ArchStackTall>
typealias ArchOutputsDrop = Plus<ArchGapThreeDrop, ArchGapTall>
typealias ArchFooterLineDrop = Plus<ArchOutputsDrop, Plus<ArchOutputTall, S24Breath>>
typealias ArchWholeTall = Plus<ArchFooterLineDrop, Plus<ArchFooterTall, EdgeMargin>>

// ── the baseline vocabulary: this canvas's stated text falls (typography, the one hole) ──

enum ArchCaptionBase: Close {}
extension ArchCaptionBase {
    public static var typeName: String { "24" }
}
enum ArchOutputTitleBase: Close {}
extension ArchOutputTitleBase {
    public static var typeName: String { "27" }
}
enum ArchOutputSubtitleBase: Close {}
extension ArchOutputSubtitleBase {
    public static var typeName: String { "45" }
}
enum ArchFooterBase: Close {}
extension ArchFooterBase {
    public static var typeName: String { "14" }
}

// ── the census lines, read off the atoms this build wrote (CensusGen) ──

enum LatticeStatsText: Close {}
extension LatticeStatsText {
    public static var typeName: String {
        "\(CensusLatticeTypes.typeName) types · \(CensusLatticeRuntimeFunctions.typeName) runtime functions"
    }
}
enum EngineStatsText: Close {}
extension EngineStatsText {
    public static var typeName: String {
        "\(CensusEngineTypes.typeName) types · \(CensusEngineRuntimeFunctions.typeName) runtime"
    }
}
enum CompanyStatsText: Close {}
extension CompanyStatsText {
    public static var typeName: String {
        "\(Tally<RosterSpan0000To0203>.typeName) people · \(CensusCompanyTypes.typeName) types · "
            + "\(CensusCompanyRuntimeFunctions.typeName) runtime functions"
    }
}
enum ArchFooterText: Close {}
extension ArchFooterText {
    public static var typeName: String {
        "Nothing above runs at runtime: \(CensusLatticeRuntimeFunctions.typeName) functions in the core, "
            + "\(CensusEngineRuntimeFunctions.typeName) in the engine, "
            + "\(CensusCompanyRuntimeFunctions.typeName) in the demo, no structs, no classes. The "
            + "\(CensusToolingRuntimeFunctions.typeName) functions that do execute are the build tools, counted by this build."
    }
}

// ── the words ──

enum LatticeTitleText: Close {}
extension LatticeTitleText {
    public static var typeName: String { "Verification Is Identification — the core" }
}
enum LatticeRoleText: Close {}
extension LatticeRoleText {
    public static var typeName: String {
        "A plain SwiftPM library: write rules as protocols and states as types, and swift build becomes the checker"
    }
}
enum EngineRoleText: Close {}
extension EngineRoleText {
    public static var typeName: String {
        "Renders markdown and SVG from types, and carries the guided walks: a page is a type, search is navigation"
    }
}
enum CompanyRoleText: Close {}
extension CompanyRoleText {
    public static var typeName: String {
        "The at-scale demo: 204 people, the access policy, and the review cycles, modeled and proved"
    }
}
enum EngineTitleText: Close {}
extension EngineTitleText {
    public static var typeName: String { "DocumentKit" }
}
enum CompanyTitleText: Close {}
extension CompanyTitleText {
    public static var typeName: String { "Organization — System · Query · View" }
}
enum SiteBoxTitleText: Close {}
extension SiteBoxTitleText {
    public static var typeName: String { "The site" }
}
enum SiteBoxSubtitleText: Close {}
extension SiteBoxSubtitleText {
    public static var typeName: String { "every page re-proved by this build" }
}
enum ConsoleTitleText: Close {}
extension ConsoleTitleText {
    public static var typeName: String { "The console audit" }
}
enum ConsoleSubtitleText: Close {}
extension ConsoleSubtitleText {
    public static var typeName: String { "swift run OrgDemo audit" }
}
enum FlowCaptionOneText: Close {}
extension FlowCaptionOneText {
    public static var typeName: String { "everything below imports it; a green build means the model is consistent" }
}
enum FlowCaptionTwoText: Close {}
extension FlowCaptionTwoText {
    public static var typeName: String { "the demo application, written in both" }
}
enum PapersPlaqueText: Close {}
extension PapersPlaqueText {
    public static var typeName: String { "Pair" }
}
enum AxesPlaqueText: Close {}
extension AxesPlaqueText {
    public static var typeName: String { "Tally" }
}
enum OperationsPlaqueText: Close {}
extension OperationsPlaqueText {
    public static var typeName: String { "Decidable" }
}
enum MarkupPlaqueText: Close {}
extension MarkupPlaqueText {
    public static var typeName: String { "markdown" }
}
enum VectorPlaqueText: Close {}
extension VectorPlaqueText {
    public static var typeName: String { "SVG layout" }
}
enum PenPlaqueText: Close {}
extension PenPlaqueText {
    public static var typeName: String { "text metrics" }
}
enum WalksPlaqueText: Close {}
extension WalksPlaqueText {
    public static var typeName: String { "guided walks" }
}
enum SystemPlaqueText: Close {}
extension SystemPlaqueText {
    public static var typeName: String { "System/" }
}
enum QueryPlaqueText: Close {}
extension QueryPlaqueText {
    public static var typeName: String { "Query/" }
}
enum ViewPlaqueText: Close {}
extension ViewPlaqueText {
    public static var typeName: String { "View/" }
}
enum SiteBoxTarget: Close {}
extension SiteBoxTarget {
    public static var typeName: String { "/documentation/organization" }
}
enum LatticePanelTarget: Close {}
extension LatticePanelTarget {
    public static var typeName: String { "/documentation/verificationisidentification" }
}
enum EnginePanelTarget: Close {}
extension EnginePanelTarget {
    public static var typeName: String { "/documentation/documentkit" }
}
enum FlowCaptionThreeText: Close {}
extension FlowCaptionThreeText {
    public static var typeName: String { "both generated from the same types" }
}

// ── the plaques: a box shows its components right on its face, each plaque sized by its
// own words (TextWidth, the measured magnitude standing in the axis) — nothing hidden,
// nothing to hover for. The whole box is one link; hovering only lifts it. ──

typealias PlaqueWide<Label: Structure> = Plus<TextWidth<Label, TextXXS>, Twice<HairBreath>>
enum PlaqueFace: SpanTrack {
    public typealias H = Tally<VerdictChipTall>
    public typealias Radius = R6
    public typealias Fill = SurfaceTrack
}
enum PlaqueLabel<T: Structure>: SpanLabelMid {
    public typealias Y = CenteredBaseline<VerdictChipTall, TextXXS>
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
typealias Plaque<Label: Structure> = Fixed<
    PlaqueWide<Label>,
    Layered<PlaqueFace, PlaqueLabel<Label>>
>
enum InkPlaqueFace: SpanTrackOutlined {
    public typealias H = Tally<VerdictChipTall>
    public typealias Radius = R6
    public typealias Fill = Ink
    public typealias Stroke = TextSecondary
}
enum InkPlaqueLabel<T: Structure>: SpanLabelMid {
    public typealias Y = CenteredBaseline<VerdictChipTall, TextXXS>
    public typealias FillColor = Paper
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
typealias InkPlaque<Label: Structure> = Fixed<
    PlaqueWide<Label>,
    Layered<InkPlaqueFace, InkPlaqueLabel<Label>>
>


enum ThreePlaqueRow<
    A: Structure,
    B: Structure,
    C: Structure,
    Wide: Structure
>: HFlow {
    public typealias Given = Wide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Plaque<A>.self
        Air<HairBreath>.self
        Plaque<B>.self
        Air<HairBreath>.self
        Plaque<C>.self
        RestAir.self
    }
}
enum ThreeInkPlaqueRow<
    A: Structure,
    B: Structure,
    C: Structure,
    Wide: Structure
>: HFlow {
    public typealias Given = Wide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        InkPlaque<A>.self
        Air<HairBreath>.self
        InkPlaque<B>.self
        Air<HairBreath>.self
        InkPlaque<C>.self
        RestAir.self
    }
}

enum FourPlaqueRow<
    A: Structure,
    B: Structure,
    C: Structure,
    D: Structure,
    Wide: Structure
>: HFlow {
    public typealias Given = Wide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Plaque<A>.self
        Air<HairBreath>.self
        Plaque<B>.self
        Air<HairBreath>.self
        Plaque<C>.self
        Air<HairBreath>.self
        Plaque<D>.self
        RestAir.self
    }
}

// ── one box vocabulary: a face, a title, the component plaques, a stats line ──

enum ArchBarFace: SpanTrack {
    public typealias H = Tally<ArchStackTall>
    public typealias Radius = R12
    public typealias Fill = Ink
}
enum ArchBoxFace: SpanTrackOutlined {
    public typealias H = Tally<ArchStackTall>
    public typealias Radius = R12
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum ArchOutputFace: SpanTrack {
    public typealias H = Tally<ArchOutputTall>
    public typealias Radius = R12
    public typealias Fill = AccentRole
}
enum BarTitleSpan: SpanLabelMid {
    public typealias Y = CenteredBaseline<ArchTitleStorey, TextL>
    public typealias FillColor = Paper
    public typealias Size = TextL
    public typealias Weight = WeightBold
    public typealias Content = LatticeTitleText
}
enum BarStatsSpan: SpanLabelMid {
    public typealias Y = Under<
        Plus<ArchTitleStorey, Plus<ArchRoleStorey, ArchPlaqueStorey>>,
        CenteredBaseline<ArchStatsStorey, TextXXS>
    >
    public typealias FillColor = Paper
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = LatticeStatsText
}
enum ArchTitleSpan<T: Structure>: SpanLabelMid {
    public typealias Y = CenteredBaseline<ArchTitleStorey, TextM>
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
// The role line: what the box does and why, wrapped by the font's own measure into the
// two-line storey under the title.
enum RoleFirstBase: Close {}
extension RoleFirstBase {
    public static var typeName: String { "12" }
}
enum RolePitch: Close {}
extension RolePitch {
    public static var typeName: String { "13" }
}
enum RoleSpan<T: Structure>: SpanLabelMidWrapped {
    public typealias Y = Under<ArchTitleStorey, RoleFirstBase>
    public typealias LinePitch = RolePitch
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum InkRoleSpan<T: Structure>: SpanLabelMidWrapped {
    public typealias Y = Under<ArchTitleStorey, RoleFirstBase>
    public typealias LinePitch = RolePitch
    public typealias FillColor = Paper
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum RoleRow<T: Structure, Wide: Structure>: HFlow {
    public typealias Given = Wide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<RoleSpan<T>>.self
        Air<EdgeMargin>.self
    }
}
enum InkRoleRow<T: Structure, Wide: Structure>: HFlow {
    public typealias Given = Wide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<InkRoleSpan<T>>.self
        Air<EdgeMargin>.self
    }
}
enum ArchStatsSpan<T: Structure>: SpanLabelMid {
    public typealias Y = Under<
        Plus<ArchTitleStorey, Plus<ArchRoleStorey, ArchPlaqueStorey>>,
        CenteredBaseline<ArchStatsStorey, TextXXS>
    >
    public typealias FillColor = ActionRole
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
typealias ArchBoxArt<
    Wide: Structure,
    To: Structure,
    Title: Structure,
    Role: Structure,
    PlaqueA: Structure,
    PlaqueB: Structure,
    PlaqueC: Structure,
    Stats: Structure
> = SpanLink<
    To,
    SpanLift<
        Layered<
            ArchBoxFace,
            Layered<
                Layered<ArchTitleSpan<Title>, SpanHosted<RoleRow<Role, Wide>>>,
                Layered<
                    SpanLowered<Tally<Plus<ArchTitleStorey, ArchRoleStorey>>, SpanHosted<ThreePlaqueRow<PlaqueA, PlaqueB, PlaqueC, Wide>>>,
                    ArchStatsSpan<Stats>
                >
            >
        >
    >
>
enum ArchOutputTitleSpan<T: Structure>: SpanLabelMid {
    public typealias Y = ArchOutputTitleBase
    public typealias FillColor = OnAccent
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum ArchOutputSubtitleSpan<T: Structure>: SpanLabelMid {
    public typealias Y = ArchOutputSubtitleBase
    public typealias FillColor = OnAccent
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
typealias ArchOutputArt<
    Title: Structure,
    Subtitle: Structure
> = Layered<
    ArchOutputFace,
    Layered<ArchOutputTitleSpan<Title>, ArchOutputSubtitleSpan<Subtitle>>
>

// ── the rows, each falling on its summed drop, each box one whole link ──

enum LatticeBarRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<
            ArchInner,
            SpanLink<
                LatticePanelTarget,
                SpanLift<
                    Layered<
                        ArchBarFace,
                        Layered<
                            Layered<BarTitleSpan, SpanHosted<InkRoleRow<LatticeRoleText, ArchInner>>>,
                            Layered<
                                SpanLowered<Tally<Plus<ArchTitleStorey, ArchRoleStorey>>, SpanHosted<ThreeInkPlaqueRow<PapersPlaqueText, AxesPlaqueText, OperationsPlaqueText, ArchInner>>>,
                                BarStatsSpan
                            >
                        >
                    >
                >
            >
        >.self
        RestAir.self
    }
}
enum EngineBoxRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<
            ArchInner,
            SpanLink<
                EnginePanelTarget,
                SpanLift<
                    Layered<
                        ArchBoxFace,
                        Layered<
                            Layered<ArchTitleSpan<EngineTitleText>, SpanHosted<RoleRow<EngineRoleText, ArchInner>>>,
                            Layered<
                                SpanLowered<Tally<Plus<ArchTitleStorey, ArchRoleStorey>>, SpanHosted<FourPlaqueRow<MarkupPlaqueText, VectorPlaqueText, PenPlaqueText, WalksPlaqueText, ArchInner>>>,
                                ArchStatsSpan<EngineStatsText>
                            >
                        >
                    >
                >
            >
        >.self
        RestAir.self
    }
}
enum CompanyBoxRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<ArchInner, ArchBoxArt<ArchInner, SitePath<Nav.CompanyDashboard>, CompanyTitleText, CompanyRoleText, SystemPlaqueText, QueryPlaqueText, ViewPlaqueText, CompanyStatsText>>.self
        RestAir.self
    }
}
enum OutputsRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<ArchPairBoxWide, SpanLink<SiteBoxTarget, SpanLift<ArchOutputArt<SiteBoxTitleText, SiteBoxSubtitleText>>>>.self
        Air<Gutter>.self
        Fixed<ArchPairBoxWide, ArchOutputArt<ConsoleTitleText, ConsoleSubtitleText>>.self
        RestAir.self
    }
}

// ── the gaps: an arrow falls through its own slice, a caption stands beside it ──

// The arrow breathes on both ends: one nose of air below the box above, one before the
// box it points at.
enum GapArrowSpan: SpanArrowDown {
    public typealias FromY = Tally<ArchNose>
    public typealias ToY = Tally<Rest<ArchGapTall, ArchNose>>
}
enum GapCaptionSpan<T: Structure>: SpanLabelItalic {
    public typealias Y = ArchCaptionBase
    public typealias Size = TextXXS
    public typealias Content = T
}
enum CenteredGapArrow<Wide: Structure>: HFlow {
    public typealias Given = Wide
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<DotSlot, GapArrowSpan>.self
        RestAir.self
    }
}
enum FlowGapRow<Caption: Structure>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<ArchInner, SpanHosted<GapWithCaption<Caption>>>.self
        RestAir.self
    }
}
enum GapWithCaption<Caption: Structure>: HFlow {
    public typealias Given = ArchInner
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<Gutter>.self
        Fixed<DotSlot, GapArrowSpan>.self
        Air<Gutter>.self
        Fixed<ArchCaptionWide, GapCaptionSpan<Caption>>.self
        RestAir.self
    }
}
enum TwinGapRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<ArchPairBoxWide, SpanHosted<CenteredGapArrow<ArchPairBoxWide>>>.self
        Air<Gutter>.self
        Fixed<ArchPairBoxWide, SpanHosted<CenteredGapArrow<ArchPairBoxWide>>>.self
        RestAir.self
    }
}
enum FlowCaptionCenterRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<ArchCaptionWide, GapCaptionSpan<FlowCaptionThreeText>>.self
        RestAir.self
    }
}
enum ArchFooterSpan: SpanLabelMid {
    public typealias Y = ArchFooterBase
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = ArchFooterText
}
enum ArchFooterRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<ArchFooterSpan>.self
    }
}

// ── the whole diagram: the frame is the one summed rung; nothing is hidden, every box
// opens by its own click, and the hover-lift style is the one interaction ──

enum ArchitectureContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        DropAt<Tally<ArchBarDrop>, LatticeBarRow>.self
        DropAt<Tally<ArchGapOneDrop>, FlowGapRow<FlowCaptionOneText>>.self
        DropAt<Tally<ArchEngineDrop>, EngineBoxRow>.self
        DropAt<Tally<ArchGapTwoDrop>, FlowGapRow<FlowCaptionTwoText>>.self
        DropAt<Tally<ArchCompanyDrop>, CompanyBoxRow>.self
        DropAt<Tally<ArchGapThreeDrop>, TwinGapRow>.self
        DropAt<Tally<ArchGapThreeDrop>, FlowCaptionCenterRow>.self
        DropAt<Tally<ArchOutputsDrop>, OutputsRow>.self
        DropAt<Tally<ArchFooterLineDrop>, ArchFooterRow>.self
    }
}
/// The generic dropper this canvas rides: a row and its summed line, one door for all.
enum DropAt<
    Line: Structure,
    Content: Structure
>: Dropped {
    public typealias Y = Line
    public typealias Content = Content
}
enum ArchitectureDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        ArrowMarkers.self
        SoftShadow.self
        HoverRevealStyle.self
    }
}
enum ArchitectureDiagram: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = ArchitectureLabel
    public typealias Defs = ArchitectureDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<ArchWholeTall, SpanHosted<ArchitectureContent>>.self
    }
}

func runDiagram() {
    write(ArchitectureDiagram.typeName, "architecture")
    print("generated 1 architecture diagram (Vector composition, census live)")
}
