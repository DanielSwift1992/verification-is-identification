import VerificationIsIdentification
import DocumentKit
import Organization

// build-flow.svg — the tools' own diagram: what the build actually does, left to right,
// the way a cloud architecture is drawn — zones for the stages, cards for the parts, one
// role line each. Sources of truth feed the generators, generated Swift meets the gates
// inside swift build, and the outputs fall out. Nothing in this picture survives the
// build: the tools execute once and ship nothing.

enum BuildFlowLabel: Close {}
extension BuildFlowLabel {
    public static var typeName: String {
        "The build, left to right: sources of truth (the font file, the prose, the index "
            + "arithmetic) feed swift package generate; the generated Swift meets the gates "
            + "inside swift build (the strict law lint, the grammar mirror, the prose census, "
            + "the census atoms); the outputs are the site, the drawings, and the audit."
    }
}

// ── the words: every card a name and a role, engineer-plain ──

enum SourcesZoneTitle: Close {}
extension SourcesZoneTitle {
    public static var typeName: String { "Sources of truth" }
}
enum GenerateZoneTitle: Close {}
extension GenerateZoneTitle {
    public static var typeName: String { "swift package generate" }
}
enum GatesZoneTitle: Close {}
extension GatesZoneTitle {
    public static var typeName: String { "swift build — the gates" }
}
enum OutputsZoneTitle: Close {}
extension OutputsZoneTitle {
    public static var typeName: String { "The outputs" }
}

enum FontSourceName: Close {}
extension FontSourceName {
    public static var typeName: String { "InterVariable.ttf" }
}
enum FontSourceRole: Close {}
extension FontSourceRole {
    public static var typeName: String { "the font itself: metrics parsed, not guessed" }
}
enum ProseSourceName: Close {}
extension ProseSourceName {
    public static var typeName: String { "Prose.json" }
}
enum ProseSourceRole: Close {}
extension ProseSourceRole {
    public static var typeName: String { "the pages' prose, editable as data" }
}
enum IndexSourceName: Close {}
extension IndexSourceName {
    public static var typeName: String { "index arithmetic" }
}
enum IndexSourceRole: Close {}
extension IndexSourceRole {
    public static var typeName: String { "who works where, and when a field steps" }
}
enum RosterGenName: Close {}
extension RosterGenName {
    public static var typeName: String { "the roster" }
}
enum RosterGenRole: Close {}
extension RosterGenRole {
    public static var typeName: String { "204 people as checked-in Swift types" }
}
enum FontGenName: Close {}
extension FontGenName {
    public static var typeName: String { "font metrics" }
}
enum FontGenRole: Close {}
extension FontGenRole {
    public static var typeName: String { "advances and cap height as atoms" }
}
enum WalkGenName: Close {}
extension WalkGenName {
    public static var typeName: String { "the walk pages" }
}
enum WalkGenRole: Close {}
extension WalkGenRole {
    public static var typeName: String { "every step of the three walks, doors and all" }
}
enum LawGateName: Close {}
extension LawGateName {
    public static var typeName: String { "LawCheck, strict" }
}
enum LawGateRole: Close {}
extension LawGateRole {
    public static var typeName: String { "a violation refuses the build by name" }
}
enum GrammarGateName: Close {}
extension GrammarGateName {
    public static var typeName: String { "grammar mirror" }
}
enum GrammarGateRole: Close {}
extension GrammarGateRole {
    public static var typeName: String { "every file re-judged as typed objects" }
}
enum CensusGateName: Close {}
extension CensusGateName {
    public static var typeName: String { "prose census" }
}
enum CensusGateRole: Close {}
extension CensusGateRole {
    public static var typeName: String { "doc-comment budgets, held" }
}
enum CensusGenCardName: Close {}
extension CensusGenCardName {
    public static var typeName: String { "CensusGen" }
}
enum CensusGenCardRole: Close {}
extension CensusGenCardRole {
    public static var typeName: String { "the counts spelled into atoms, per build" }
}
enum PagesOutName: Close {}
extension PagesOutName {
    public static var typeName: String { "471 pages" }
}
enum PagesOutRole: Close {}
extension PagesOutRole {
    public static var typeName: String { "the whole site, re-proved" }
}
enum DrawingsOutName: Close {}
extension DrawingsOutName {
    public static var typeName: String { "the drawings" }
}
enum DrawingsOutRole: Close {}
extension DrawingsOutRole {
    public static var typeName: String { "every SVG re-derived" }
}
enum AuditOutName: Close {}
extension AuditOutName {
    public static var typeName: String { "the console audit" }
}
enum AuditOutRole: Close {}
extension AuditOutRole {
    public static var typeName: String { "swift run OrgDemo audit" }
}
enum FlowFooterText: Close {}
extension FlowFooterText {
    public static var typeName: String {
        "swift build is the run: types in, site out, and nothing is left running."
    }
}

// ── a card: name over a wrapped role, on a track, one per part ──

enum FlowCardFace: SpanTrack {
    public typealias H = Tally<FlowCardTall>
    public typealias Radius = R6
    public typealias Fill = SurfaceTrack
}
enum FlowCardNameSpan<T: Structure>: SpanLabelMid {
    public typealias Y = CenteredBaseline<FlowCardNameStorey, TextXS>
    public typealias FillColor = TextPrimary
    public typealias Size = TextXS
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum FlowRoleFirstBase: Close {}
extension FlowRoleFirstBase {
    public static var typeName: String { "11" }
}
enum FlowRolePitch: Close {}
extension FlowRolePitch {
    public static var typeName: String { "12" }
}
enum FlowCardRoleSpan<T: Structure>: SpanLabelMidWrapped {
    public typealias Y = Under<FlowCardNameStorey, FlowRoleFirstBase>
    public typealias LinePitch = FlowRolePitch
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum FlowCardInterior<Name: Structure, Role: Structure>: HFlow {
    public typealias Given = Rest<FlowZoneWide, Twice<EdgeMargin>>
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<StripInset>.self
        Flexible<Layered<FlowCardNameSpan<Name>, FlowCardRoleSpan<Role>>>.self
        Air<StripInset>.self
    }
}
enum FlowCardRow<Name: Structure, Role: Structure>: HFlow {
    public typealias Given = FlowZoneWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<
            Layered<
                FlowCardFace,
                SpanHosted<FlowCardInterior<Name, Role>>
            >
        >.self
        Air<EdgeMargin>.self
    }
}
typealias FlowCard<Name: Structure, Role: Structure> = SpanHosted<FlowCardRow<Name, Role>>

// ── a zone: an outlined frame, its title, and its cards stacked on the pitch ──

enum FlowZoneFace: SpanTrackOutlined {
    public typealias H = Tally<FlowZoneTall>
    public typealias Radius = R12
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum FlowZoneTitleSpan<T: Structure>: SpanLabelMid {
    public typealias Y = CenteredBaseline<FlowZoneTitleStorey, TextXXS>
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightBold
    public typealias Content = T
}
typealias ThreeCardZoneArt<
    Title: Structure,
    NameA: Structure, RoleA: Structure,
    NameB: Structure, RoleB: Structure,
    NameC: Structure, RoleC: Structure
> = Layered<
    FlowZoneFace,
    Layered<
        FlowZoneTitleSpan<Title>,
        Layered<
            SpanLowered<Tally<FlowZoneTitleStorey>, FlowCard<NameA, RoleA>>,
            Layered<
                SpanLowered<Tally<Plus<FlowZoneTitleStorey, FlowCardPitch>>, FlowCard<NameB, RoleB>>,
                SpanLowered<Tally<Plus<FlowZoneTitleStorey, Twice<FlowCardPitch>>>, FlowCard<NameC, RoleC>>
            >
        >
    >
>
typealias FourCardZoneArt<
    Title: Structure,
    NameA: Structure, RoleA: Structure,
    NameB: Structure, RoleB: Structure,
    NameC: Structure, RoleC: Structure,
    NameD: Structure, RoleD: Structure
> = Layered<
    ThreeCardZoneArt<Title, NameA, RoleA, NameB, RoleB, NameC, RoleC>,
    SpanLowered<Tally<Plus<FlowZoneTitleStorey, Plus<Twice<FlowCardPitch>, FlowCardPitch>>>, FlowCard<NameD, RoleD>>
>

// ── the band: four zones, three arrows across the gutters at the band's middle ──

enum FlowAcrossArrow: SpanArrowAcross {
    public typealias Y = Halfway<Never, FlowZoneTall>
}
enum BuildFlowRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<
            FlowZoneWide,
            ThreeCardZoneArt<
                SourcesZoneTitle,
                FontSourceName, FontSourceRole,
                ProseSourceName, ProseSourceRole,
                IndexSourceName, IndexSourceRole
            >
        >.self
        Fixed<Gutter, FlowAcrossArrow>.self
        Fixed<
            FlowZoneWide,
            ThreeCardZoneArt<
                GenerateZoneTitle,
                RosterGenName, RosterGenRole,
                FontGenName, FontGenRole,
                WalkGenName, WalkGenRole
            >
        >.self
        Fixed<Gutter, FlowAcrossArrow>.self
        Fixed<
            FlowZoneWide,
            FourCardZoneArt<
                GatesZoneTitle,
                LawGateName, LawGateRole,
                GrammarGateName, GrammarGateRole,
                CensusGateName, CensusGateRole,
                CensusGenCardName, CensusGenCardRole
            >
        >.self
        Fixed<Gutter, FlowAcrossArrow>.self
        Fixed<
            FlowZoneWide,
            ThreeCardZoneArt<
                OutputsZoneTitle,
                PagesOutName, PagesOutRole,
                DrawingsOutName, DrawingsOutRole,
                AuditOutName, AuditOutRole
            >
        >.self
        RestAir.self
    }
}
enum FlowFooterSpan: SpanLabelMid {
    public typealias Y = CenteredBaseline<EdgeMargin, TextXXS>
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = FlowFooterText
}
enum FlowFooterRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<FlowFooterSpan>.self
    }
}
enum BuildFlowDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        ArrowMarkers.self
    }
}
enum BuildFlowDiagram: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = BuildFlowLabel
    public typealias Defs = BuildFlowDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<FlowZoneTall, SpanHosted<BuildFlowRow>>.self
        Air<HairBreath>.self
        Fixed<EdgeMargin, SpanHosted<FlowFooterRow>>.self
        Air<EdgeMargin>.self
    }
}

func runBuildFlow() {
    write(BuildFlowDiagram.typeName, "build-flow")
    print("generated 1 build-flow diagram (Vector composition)")
}
