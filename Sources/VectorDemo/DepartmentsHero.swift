import VerificationIsIdentification
import DocumentKit
import Organization

// departments-hero.svg — DESIGN11 c. Four department cards: name, live `Tally` headcount, and
// a one-line read of what each carries (a shared space every department has; two also carry an
// owned vault, named after its owner), the same facts `View/Departments.swift`'s cards already
// state, drawn instead of listed. Each card links to its own department's page, the same
// address the catalog table under it names: a card that says Finance lands on Finance.

enum DeptHeroAriaLabel: Close {}
extension DeptHeroAriaLabel {
    public static var typeName: String {
        "The four departments, each card its live headcount and what it carries: a shared "
            + "space every one has, an owned vault the two that carry one."
    }
}

enum DeptNameY: Close {}
extension DeptNameY {
    public static var typeName: String { "28" }
}
enum DeptCountY: Close {}
extension DeptCountY {
    public static var typeName: String { "68" }
}
enum DeptNoteY: Close {}
extension DeptNoteY {
    public static var typeName: String { "92" }
}

enum FinanceNoteText: Close {}
extension FinanceNoteText {
    public static var typeName: String { "shared + vault (Alice)" }
}
enum EngineeringNoteText: Close {}
extension EngineeringNoteText {
    public static var typeName: String { "shared + vault (Dave)" }
}
enum SharedSpaceOnlyText: Close {}
extension SharedSpaceOnlyText {
    public static var typeName: String { "shared space only" }
}
// The card, drawn into its slice: face, name, headcount, note, one weighed pad in
// (4 of the card's 54 quarters). Every x derives; the link spans the whole card.
enum DeptFace: SpanCardFace {
    public typealias H = Tally<CatalogCardTall>
    public typealias Radius = R16
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum DeptNameSpan<T: Structure>: SpanLabel {
    public typealias Y = DeptNameY
    public typealias FillColor = TextPrimary
    public typealias Size = TextL
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum DeptCountSpan<T: Structure>: SpanLabel {
    public typealias Y = DeptCountY
    public typealias FillColor = TextPrimary
    public typealias Size = DisplayS
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum DeptNoteSpan<T: Structure>: SpanLabel {
    public typealias Y = DeptNoteY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum DeptInterior<
    D: Structure,
    C: Structure,
    N: Structure
>: HFlow {
    public typealias Given = CardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<Layered<DeptNameSpan<D>, Layered<DeptCountSpan<C>, DeptNoteSpan<N>>>>.self
    }
}
typealias DeptCardArt<
    D: Structure,
    C: Structure,
    N: Structure
> = Layered<
    DeptFace,
    SpanHosted<DeptInterior<D, C, N>>
>

// The four cards divide the surface: dictionary-wide cards, breaths between, and the side
// fields are the remainder, shared equally by the two flexible edges. The hand-typed X
// columns once let a fourth card overrun the viewBox by 44 pixels; an axis cannot say that.
enum DeptCardsRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<CardWide, SpanLink<SitePath<Finance>, DeptCardArt<Finance, Tally<FinanceTeam>, FinanceNoteText>>>.self
        Air<Breath>.self
        Fixed<CardWide, SpanLink<SitePath<Engineering>, DeptCardArt<Engineering, Tally<EngineeringTeam>, EngineeringNoteText>>>.self
        Air<Breath>.self
        Fixed<CardWide, SpanLink<SitePath<Sales>, DeptCardArt<Sales, Tally<SalesTeam>, SharedSpaceOnlyText>>>.self
        Air<Breath>.self
        Fixed<CardWide, SpanLink<SitePath<People>, DeptCardArt<People, Tally<PeopleTeam>, SharedSpaceOnlyText>>>.self
        RestAir.self
    }
}
enum DeptDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SurfaceCardShadow.self
    }
}
enum DeptHeroStrip: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = DeptHeroAriaLabel
    public typealias Defs = DeptDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<CatalogCardTall, SpanHosted<DeptCardsRow>>.self
        Air<EdgeMargin>.self
    }
}

func runDepartmentsHero() {
    write(DeptHeroStrip.typeName, "departments-hero")
    print("generated 1 departments hero (Vector composition, live counts)")
}
