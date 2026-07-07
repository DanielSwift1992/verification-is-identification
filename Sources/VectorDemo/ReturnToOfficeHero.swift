import VerificationIsIdentification
import DocumentKit
import Organization

// rto-hero.svg, DESIGN11 c. Three arrangement cards, each a verdict chip read off the same
// conformance the page's own table already checks (`OfficeArrangement<Site>: MeetsOfficeMinimum`;
// System/ReturnToOffice.swift's own closing comment names exactly which two conform). Static,
// not `Linked` (DESIGN11's own table asks it only of Departments/Cycles/Documents).
//
// The axis divides the surface: three dictionary-wide cards with breaths between, and the
// side fields are the remainder, shared equally by the two flexible edges: centred by
// construction, stated by no one. The frame grows from the vertical members.

enum RtoHeroAriaLabel: Close {}
extension RtoHeroAriaLabel {
    public static var typeName: String {
        "The three work arrangements and whether each meets the office minimum, read off the "
            + "same conformance the table below checks."
    }
}

enum RtoNameY: Close {}
extension RtoNameY {
    public static var typeName: String { "28" }
}
enum RtoVerdictChipY: Close {}
extension RtoVerdictChipY {
    public static var typeName: String { "44" }
}
typealias RtoVerdictTextY = CenteredBaseline<VerdictChipTall, TextXXS>

enum YesText: Close {}
extension YesText {
    public static var typeName: String { "Meets minimum" }
}
enum NoText: Close {}
extension NoText {
    public static var typeName: String { "Below minimum" }
}
// The card, drawn into its slice: a face that fills the slice's width, a name and a verdict
// chip standing one margin in. The interior divides the card the way the row divides the
// surface; every x derives.
enum RtoFace: SpanCardFace {
    public typealias H = Tally<VerdictCardTall>
    public typealias Radius = R16
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum RtoNameSpan<T: Structure>: SpanLabel {
    public typealias Y = RtoNameY
    public typealias FillColor = TextPrimary
    public typealias Size = TextL
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum RtoVerdictTrack<Fill: Structure>: SpanTrack {
    public typealias H = Tally<VerdictChipTall>
    public typealias Radius = R10
    public typealias Fill = Fill
}
enum RtoVerdictLabel<Ink: Structure, T: Structure>: SpanLabel {
    public typealias Y = RtoVerdictTextY
    public typealias FillColor = Ink
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum RtoVerdictInterior<Ink: Structure, T: Structure>: HFlow {
    public typealias Given = VerdictChipWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<HairBreath>.self
        Flexible<RtoVerdictLabel<Ink, T>>.self
    }
}
enum RtoVerdictRow<Fill: Structure, Ink: Structure, T: Structure>: HFlow {
    public typealias Given = CardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Fixed<VerdictChipWide, Layered<RtoVerdictTrack<Fill>, SpanHosted<RtoVerdictInterior<Ink, T>>>>.self
        RestAir.self
    }
}
typealias RtoYesChip = SpanLowered<RtoVerdictChipY, SpanHosted<RtoVerdictRow<AccentRole, OnAccent, YesText>>>
typealias RtoNoChip = SpanLowered<RtoVerdictChipY, SpanHosted<RtoVerdictRow<SurfaceTrack, TextPrimary, NoText>>>
enum RtoInterior<
    T: Structure,
    Chip: Spanning
>: HFlow {
    public typealias Given = CardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<Layered<RtoNameSpan<T>, Chip>>.self
    }
}
typealias RtoCardArt<
    T: Structure,
    Chip: Spanning
> = Layered<
    RtoFace,
    SpanHosted<RtoInterior<T, Chip>>
>

enum RtoCardsRow: HFlow {
    public typealias Given = RtoSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<CardWide, RtoCardArt<OnSite, RtoYesChip>>.self
        Air<Breath>.self
        Fixed<CardWide, RtoCardArt<Hybrid, RtoYesChip>>.self
        Air<Breath>.self
        Fixed<CardWide, RtoCardArt<Remote, RtoNoChip>>.self
        RestAir.self
    }
}

enum RtoDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SurfaceCardShadow.self
    }
}
enum RtoHeroStrip: GrownDiagram {
    public typealias Across = RtoSurface
    public typealias AriaLabel = RtoHeroAriaLabel
    public typealias Defs = RtoDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<VerdictCardTall, SpanHosted<RtoCardsRow>>.self
        Air<EdgeMargin>.self
    }
}

func runReturnToOfficeHero() {
    write(RtoHeroStrip.typeName, "rto-hero")
    print("generated 1 return-to-office hero (Vector composition)")
}
