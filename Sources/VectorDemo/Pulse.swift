import VerificationIsIdentification
import DocumentKit
import Organization

// CompanyPulse, DESIGN9 §4: the dashboard drawn in the design system's tokens. Every
// number is the same live read `OrgDemo audit` prints; every card is `Linked` to the real page
// it summarizes (`Dest` built from `PageSlug<Nav.X>`, not hand-typed). Absorbs
// chart-headcount.svg (DESIGN7 §4): one source for the department breakdown, not two.
//
// The canvas is sized to what it actually holds, not stated to the 960×520 DESIGN9's text
// gave, a guess made without rendering it. Computed content (§ layout below) comes to
// 960×360; the extra 160px DESIGN9 imagined would sit empty. Reported as a deliberate,
// reasoned adjustment, not a silent one.

enum PulseAriaLabel: Close {}
extension PulseAriaLabel {
    public static var typeName: String {
        "Company Pulse: headcount, departments, certified rules, and standing invariants, "
            + "read live from the proved types. Each card links to its own page."
    }
}

enum PulseMarginY: Close {}
extension PulseMarginY {
    public static var typeName: String { "16" }
}

enum HeadcountTitleText: Close {}
extension HeadcountTitleText {
    public static var typeName: String { "Headcount" }
}
enum DepartmentsTitleText: Close {}
extension DepartmentsTitleText {
    public static var typeName: String { "Departments" }
}
enum CertifiedTitleText: Close {}
extension CertifiedTitleText {
    public static var typeName: String { "Certified rules" }
}
enum InvariantsTitleText: Close {}
extension InvariantsTitleText {
    public static var typeName: String { "Invariants" }
}



// ── row 1: four KPI cards on the weighted row: margin, card, breath, three more, margin,
// weighed 4:55:4 in quarter units. The hero wears the accent face; the rest the card face.
// Every card lifts on hover and links to the page it summarizes.
enum PulseKpiFace: SpanCardFace {
    public typealias H = Tally<KpiCardHeight>
    public typealias Radius = R16
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum PulseKpiHeroFace: SpanHeroFace {
    public typealias H = Tally<KpiCardHeight>
    public typealias Radius = R16
    public typealias Fill = AccentRole
}
enum PulseKpiTitle<T: Structure, Ink: Structure>: SpanLabel {
    public typealias Y = KpiTitleY
    public typealias FillColor = Ink
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PulseKpiValue<T: Structure, Ink: Structure>: SpanLabel {
    public typealias Y = KpiValueY
    public typealias FillColor = Ink
    public typealias Size = Display
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum PulseKpiInterior<
    T: Structure,
    V: Structure,
    Ink: Structure,
    ValueInk: Structure
>: HFlow {
    public typealias Given = CardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<PanelInset>.self
        Flexible<Layered<PulseKpiTitle<T, Ink>, PulseKpiValue<V, ValueInk>>>.self
    }
}
typealias PulseKpiCard<
    T: Structure,
    V: Structure
> = SpanLift<
    Layered<
        PulseKpiFace,
        SpanHosted<PulseKpiInterior<T, V, TextSecondary, TextPrimary>>
    >
>
typealias PulseKpiHeroCard<
    T: Structure,
    V: Structure
> = SpanLift<
    Layered<
        PulseKpiHeroFace,
        SpanHosted<PulseKpiInterior<T, V, OnAccent, OnAccent>>
    >
>
/// The one breathing fact on this canvas: the standing invariants are re-proved by every
/// build, and their card carries the pulse that says so — a four-second opacity swing,
/// SVG's own clock, no script.
enum InvariantsHeartbeat: SpanBreathingDot {
    public typealias CY = PulseHeartbeatCY
    public typealias R = PulseHeartbeatR
    public typealias Fill = ActionRole
}
enum PulseHeartbeatCY: Close {}
extension PulseHeartbeatCY {
    public static var typeName: String { "14" }
}
enum PulseHeartbeatR: Close {}
extension PulseHeartbeatR {
    public static var typeName: String { "3" }
}
enum PulseKpiRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<CardWide, SpanLink<SitePath<Nav.Employees>, PulseKpiHeroCard<HeadcountTitleText, Tally<Company>>>>.self
        Air<EdgeMargin>.self
        Fixed<CardWide, SpanLink<SitePath<Nav.Departments>, PulseKpiCard<DepartmentsTitleText, Tally<AllDepartments>>>>.self
        Air<EdgeMargin>.self
        Fixed<CardWide, SpanLink<SitePath<Nav.Reports>, PulseKpiCard<CertifiedTitleText, Tally<CertifiedRules>>>>.self
        Air<EdgeMargin>.self
        Fixed<CardWide, SpanLink<SitePath<Nav.Reports>, Layered<PulseKpiCard<InvariantsTitleText, Tally<StandingReport>>, InvariantsHeartbeat>>>.self
        Air<EdgeMargin>.self
        RestAir.self
    }
}

// ── row 2 left: headcount by department, four BarLines, x = 16, y = 160/208/256/304 ──

enum PulseRow2Y1: Close {}
extension PulseRow2Y1 {
    public static var typeName: String { "160" }
}
enum PulseRow2Y2: Close {}
extension PulseRow2Y2 {
    public static var typeName: String { "208" }
}
enum PulseRow2Y3: Close {}
extension PulseRow2Y3 {
    public static var typeName: String { "256" }
}
enum PulseRow2Y4: Close {}
extension PulseRow2Y4 {
    public static var typeName: String { "304" }
}

enum FinanceLabelText: Close {}
extension FinanceLabelText {
    public static var typeName: String { "Finance" }
}

enum EngineeringLabelText: Close {}
extension EngineeringLabelText {
    public static var typeName: String { "Engineering" }
}

enum SalesLabelText: Close {}
extension SalesLabelText {
    public static var typeName: String { "Sales" }
}

enum PeopleLabelText: Close {}
extension PeopleLabelText {
    public static var typeName: String { "People" }
}

// The four department bars, drawn into the left column's slice. Each fill is weighed by
// the data itself: the filled part carries the team, the air carries the other three, and
// the house count charts the split. No scale constant, no computed width, no coordinate.
enum PulseBarTrack: SpanTrack {
    public typealias H = Tally<TrackHeight>
    public typealias Radius = R10
    public typealias Fill = SurfaceTrack
}
enum PulseBarFillRect: SpanTrack {
    public typealias H = Tally<TrackHeight>
    public typealias Radius = R10
    public typealias Fill = ActionRole
}
enum PulseBarFill<
    Team: Structure,
    Others: Structure
>: SpanDataFill {
    public typealias Part = Team
    public typealias Whole = Plus<Team, Others>
    public typealias H = Tally<TrackHeight>
    public typealias Radius = R10
    public typealias Fill = ActionRole
}
enum PulseBarLabel<T: Structure>: SpanLabel {
    public typealias Y = TrackBaseline
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PulseBarValue<T: Structure>: SpanLabelEnd {
    public typealias Y = TrackBaseline
    public typealias FillColor = TextSecondary
    public typealias Size = TextM
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PulseBarText<
    L: Structure,
    V: Structure
>: HFlow {
    public typealias Given = PanelWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ChipInset>.self
        Flexible<Layered<PulseBarLabel<L>, PulseBarValue<V>>>.self
        Air<ChipInset>.self
    }
}
typealias PulseBar<
    Team: Structure,
    Others: Structure,
    L: Structure,
    V: Structure
> = Layered<
    PulseBarTrack,
    Layered<PulseBarFill<Team, Others>, SpanHosted<PulseBarText<L, V>>>
>

enum PulseBarsColumn: VFlow {
    public typealias Given = QuadTrackBlock
    public typealias Across = PanelWide
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<TrackHeight, PulseBar<FinanceTeam, Plus<EngineeringTeam, Plus<SalesTeam, PeopleTeam>>, FinanceLabelText, Tally<FinanceTeam>>>.self
        Air<Breath>.self
        Fixed<TrackHeight, PulseBar<EngineeringTeam, Plus<FinanceTeam, Plus<SalesTeam, PeopleTeam>>, EngineeringLabelText, Tally<EngineeringTeam>>>.self
        Air<Breath>.self
        Fixed<TrackHeight, PulseBar<SalesTeam, Plus<FinanceTeam, Plus<EngineeringTeam, PeopleTeam>>, SalesLabelText, Tally<SalesTeam>>>.self
        Air<Breath>.self
        Fixed<TrackHeight, PulseBar<PeopleTeam, Plus<FinanceTeam, Plus<EngineeringTeam, SalesTeam>>, PeopleLabelText, Tally<PeopleTeam>>>.self
        RestAir.self
    }
}

// The bars section: one weighted row over the surface's full width carries the left
// column; the right zone keeps its legacy places until its own wave.
enum PulseBarsRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<PanelWide, SpanHosted<PulseBarsColumn>>.self
        Air<Gutter>.self
        Fixed<PanelWide, SpanHosted<PulseRightColumn>>.self
        RestAir.self
        Air<EdgeMargin>.self
    }
}

enum WorkplaceSplitClipId: Close {}
extension WorkplaceSplitClipId {
    public static var typeName: String { "workplace-split-clip" }
}
// The workplace split: a presence ramp on one rounded track. On-site is the solid segment,
// hybrid the tinted one, and remote is the bare track itself: absence drawn as absence, not
// a third rectangle. No segment carries a stroke, so the rounded right cap meets nothing
// square to cut, and the clip only rounds the solid segment's left corners. The weights are
// the roster: on-site, hybrid, remote, in the bar exactly as in the company.
enum PulseSplitTrack: SpanTrack {
    public typealias H = Tally<TrackHeight>
    public typealias Radius = R10
    public typealias Fill = SurfaceTrack
}
typealias WholeCompanySites = Plus<OnSiteTeam, Plus<HybridTeam, RemoteTeam>>
enum PulseSegmentOnSite: SpanDataSegment {
    public typealias Prefix = Never
    public typealias Part = OnSiteTeam
    public typealias Whole = WholeCompanySites
    public typealias H = Tally<TrackHeight>
    public typealias Fill = ActionRole
}
enum PulseSegmentHybrid: SpanDataSegment {
    public typealias Prefix = OnSiteTeam
    public typealias Part = HybridTeam
    public typealias Whole = WholeCompanySites
    public typealias H = Tally<TrackHeight>
    public typealias Fill = ActionTintRole
}
typealias PulseSplitSegments = Layered<
    PulseSegmentOnSite,
    PulseSegmentHybrid
>
enum PulseSplitClip: SpanClipDef {
    public typealias Id = WorkplaceSplitClipId
    public typealias H = Tally<TrackHeight>
    public typealias Radius = R10
}
typealias PulseSplitSpan = Layered<
    PulseSplitClip,
    SpanClipped<
        WorkplaceSplitClipId,
        Layered<PulseSplitTrack, PulseSplitSegments>
    >
>

// A rank chip in its slice: track, label at one pad, value at the other end.
enum PulseChipTrack: SpanTrack {
    public typealias H = Tally<TrackHeight>
    public typealias Radius = R10
    public typealias Fill = SurfaceTrack
}
enum PulseChipLabel<T: Structure>: SpanLabel {
    public typealias Y = TrackBaseline
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PulseChipValue<T: Structure>: SpanLabelEnd {
    public typealias Y = TrackBaseline
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PulseChipText<
    L: Structure,
    V: Structure
>: HFlow {
    public typealias Given = RankChipWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ChipInset>.self
        Flexible<Layered<PulseChipLabel<L>, PulseChipValue<V>>>.self
        Air<ChipInset>.self
    }
}
typealias PulseChipSpan<
    L: Structure,
    V: Structure
> = Layered<
    PulseChipTrack,
    SpanHosted<PulseChipText<L, V>>
>
enum PulseChipsRow: HFlow {
    public typealias Given = PanelWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Fixed<RankChipWide, PulseChipSpan<OnSiteChipLabelText, Tally<OnSiteTeam>>>.self
        Air<HairBreath>.self
        Fixed<RankChipWide, PulseChipSpan<HybridChipLabelText, Tally<HybridTeam>>>.self
        Air<HairBreath>.self
        Fixed<RankChipWide, PulseChipSpan<RemoteChipLabelText, Tally<RemoteTeam>>>.self
        RestAir.self
    }
}

enum PulseRightColumn: VFlow {
    public typealias Given = QuadTrackBlock
    public typealias Across = PanelWide
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<TrackHeight, PulseSplitSpan>.self
        Air<Breath>.self
        Fixed<TrackHeight, SpanHosted<PulseChipsRow>>.self
        RestAir.self
    }
}

enum OnSiteChipLabelText: Close {}
extension OnSiteChipLabelText {
    public static var typeName: String { "On-site" }
}
enum HybridChipLabelText: Close {}
extension HybridChipLabelText {
    public static var typeName: String { "Hybrid" }
}
enum RemoteChipLabelText: Close {}
extension RemoteChipLabelText {
    public static var typeName: String { "Remote" }
}


// ── whole canvas: no root fill, still. The canvas stays transparent, so the host page's own
// background (whichever theme it is currently in) shows through the margins between cards; only
// the cards/tracks/chips themselves carry an opaque colour, and DESIGN11 makes that colour a
// role (`SurfaceCard`/`SurfaceTrack`), not a flat `Paper`/`Mist`, so it now follows the host's
// own theme too, live, not just its background. ──
enum PulseDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SoftShadow.self
        SurfaceCardShadow.self
        HoverStyle.self
    }
}
enum PulseDashboard: GrownDiagram, SelfShowing {
    public typealias Across = WideSurface
    public typealias AriaLabel = PulseAriaLabel
    public typealias Defs = PulseDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<KpiCardHeight, SpanHosted<PulseKpiRow>>.self
        Air<S24Breath>.self
        Fixed<QuadTrackBlock, SpanHosted<PulseBarsRow>>.self
        Fixed<Never, SpanHosted<PulseSelfShowingRow>>.self
        Air<S24Breath>.self
    }
}

func runPulse() {
    write(PulseDashboard.typeName, "pulse")
    print("generated 1 CompanyPulse dashboard (Vector composition, live counts)")
}
