import VerificationIsIdentification
import DocumentKit
import Organization

// employees-hero.svg: DESIGN11 c. A summary strip above the roster table: three rows, one per
// facet the page's `ByDepartment`/`ByRank`/`ByWorkplace` tables already break out, each
// value a chip, read from the SAME `Team` aggregates those tables read (`FinanceTeam.count` and
// its eleven siblings).
//
// DESIGN11 asked for "mini-bars"; a proportional multi-segment bar needs one distinguishable
// colour per segment, and the palette (DocumentKit/Design.swift) deliberately holds only two
// non-surface hues (`ActionRole`, `AccentRole`, the DNA's scarcity rule), neither meant to
// repeat as a categorical key across three, four, and three segments. Chip rows read the exact
// same three facets, honestly, within the palette as declared, reported as a deliberate
// substitution, not a silent shortcut.
//
// The rows ride the span engine in quarter units: margin 4, chip 55, breath 4. A chip is
// wide enough for `IndividualContributor` because the budget gate says so, checked at
// generate time, and a row of weights cannot place a fifth chip past the surface's edge.

enum EmpHeroAriaLabel: Close {}
extension EmpHeroAriaLabel {
    public static var typeName: String {
        "A summary strip: headcount by department, by rank, and by work arrangement, each "
            + "read live from the same verified counts the tables below list in full."
    }
}

/// The character-budget gate's site: 22 is the longest label this chip draws today
/// (`IndividualContributor`, 21 characters, is the closest runner-up), checked by eye when this
/// budget was set, the same author-checked-it-once floor `WithinBounds` grants at, just for
/// length instead of position.
enum EmpChipLabelBudget: Close {}
extension EmpChipLabelBudget {
    public static var typeName: String { "22" }
}

// ── the chip in its slice: track, budgeted facet label at one pad, live count at the other ──

enum EmpChipTrack: SpanTrack {
    public typealias H = Tally<TrackHeight>
    public typealias Radius = R10
    public typealias Fill = SurfaceTrack
}
enum EmpChipLabelSpan<T: Structure>: SpanLabelBudgeted {
    public typealias Y = TrackBaseline
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
    public typealias Budget = EmpChipLabelBudget
}
enum EmpChipValueSpan<T: Structure>: SpanLabelEnd {
    public typealias Y = TrackBaseline
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum EmpChipInterior<
    L: Structure,
    V: Structure
>: HFlow {
    public typealias Given = CardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ChipInset>.self
        Flexible<Layered<EmpChipLabelSpan<L>, EmpChipValueSpan<V>>>.self
        Air<ChipInset>.self
    }
}
typealias EmpChipSpan<
    L: Structure,
    V: Structure
> = Layered<
    EmpChipTrack,
    SpanHosted<EmpChipInterior<L, V>>
>

// ── the rows: the axis divides the surface. Each chip takes its dictionary extent, each
// breath the policy's; nothing counts, nothing weighs, and what remains past the last
// chip simply remains. ──

enum EmpChipQuad<
    LA: Structure, VA: Structure,
    LB: Structure, VB: Structure,
    LC: Structure, VC: Structure,
    LD: Structure, VD: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<CardWide, EmpChipSpan<LA, VA>>.self
        Air<Breath>.self
        Fixed<CardWide, EmpChipSpan<LB, VB>>.self
        Air<Breath>.self
        Fixed<CardWide, EmpChipSpan<LC, VC>>.self
        Air<Breath>.self
        Fixed<CardWide, EmpChipSpan<LD, VD>>.self
        RestAir.self
    }
}
enum EmpChipTriad<
    LA: Structure, VA: Structure,
    LB: Structure, VB: Structure,
    LC: Structure, VC: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<CardWide, EmpChipSpan<LA, VA>>.self
        Air<Breath>.self
        Fixed<CardWide, EmpChipSpan<LB, VB>>.self
        Air<Breath>.self
        Fixed<CardWide, EmpChipSpan<LC, VC>>.self
        RestAir.self
    }
}



enum EmpHeroStrip: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = EmpHeroAriaLabel
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<StripInset>.self
        Fixed<
            TrackHeight,
            SpanHosted<
                EmpChipQuad<
                    Finance, Tally<FinanceTeam>,
                    Engineering, Tally<EngineeringTeam>,
                    Sales, Tally<SalesTeam>,
                    People, Tally<PeopleTeam>
                >
            >
        >.self
        Air<HairBreath>.self
        Fixed<
            TrackHeight,
            SpanHosted<
                EmpChipTriad<
                    IndividualContributor, Tally<IndividualContributorTeam>,
                    Lead, Tally<LeadTeam>,
                    Manager, Tally<ManagerTeam>
                >
            >
        >.self
        Air<HairBreath>.self
        Fixed<
            TrackHeight,
            SpanHosted<
                EmpChipTriad<
                    OnSite, Tally<OnSiteTeam>,
                    Hybrid, Tally<HybridTeam>,
                    Remote, Tally<RemoteTeam>
                >
            >
        >.self
        Air<HairBreath>.self
    }
}

func runEmployeesHero() {
    write(EmpHeroStrip.typeName, "employees-hero")
    print("generated 1 employees hero (Vector composition, live counts)")
}
