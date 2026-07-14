import VerificationIsIdentification
import DocumentKit
import Organization

// documents-hero.svg: DESIGN11 c. Six document cards, the same six rows
// `View/Documents.swift`'s table lists, an owned one (`FinanceVault`/`EngineeringRepo`)
// carrying a small `AccentRole` dot, the one hero mark this hero repeats with a singular
// meaning (DESIGN10's card-icon dot, DESIGN11 b3's Done chip, the same reading each time:
// scarce in use, not in count). Each card is `Linked` to the document's own page, the same
// address the table under it names: a card that says FinanceVault lands on FinanceVault.
//
// Design.swift's `Chip` (140 wide, built for short values like "66"/"On-site") overflows a
// document's name ("EngineeringRepo"), checked directly, the text ran past the chip's
// edge. Rather than widen the shared atom (Pulse's chips need exactly its current
// proportions), this hero draws a wider local card, the same shape a `KpiCard` is at
// heart: a name line, a note line, `SurfaceCard` + `LineRole` behind both.

enum DocHeroAriaLabel: Close {}
extension DocHeroAriaLabel {
    public static var typeName: String {
        "The six documents: two owned, marked with a dot, four shared, each card linking to "
            + "that document's own page."
    }
}

enum DocNameY: Close {}
extension DocNameY {
    public static var typeName: String { "20" }
}
enum DocNoteY: Close {}
extension DocNoteY {
    public static var typeName: String { "38" }
}
enum DocDotLocalY: Close {}
extension DocDotLocalY {
    public static var typeName: String { "16" }
}
enum DocDotR: Close {}
extension DocDotR {
    public static var typeName: String { "5" }
}

enum FinanceVaultNoteText: Close {}
extension FinanceVaultNoteText {
    public static var typeName: String { "owned — Alice" }
}
enum EngineeringRepoNoteText: Close {}
extension EngineeringRepoNoteText {
    public static var typeName: String { "owned — Dave" }
}
enum SharedNoteText: Close {}
extension SharedNoteText {
    public static var typeName: String { "shared space" }
}

// The card, drawn into its slice: face, a name over its note one weighed pad in, and for
// owned documents an accent dot centered in its own end slice (4:58:8 of the card's 70
// quarters). Every x derives; the link spans the whole card.
enum DocFace: SpanCardFace {
    public typealias H = Tally<DocumentCardTall>
    public typealias Radius = R10
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum DocNameSpan<T: Structure>: SpanLabel {
    public typealias Y = DocNameY
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum DocNoteSpan<T: Structure>: SpanLabel {
    public typealias Y = DocNoteY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum DocOwnedDotSpan: SpanDot {
    public typealias CY = DocDotLocalY
    public typealias R = DocDotR
    public typealias Fill = AccentRole
}
enum DocInteriorOwned<
    D: Structure,
    N: Structure
>: HFlow {
    public typealias Given = DocumentCardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<Layered<DocNameSpan<D>, DocNoteSpan<N>>>.self
        Fixed<WideMargin, DocOwnedDotSpan>.self
    }
}
enum DocInteriorShared<
    D: Structure,
    N: Structure
>: HFlow {
    public typealias Given = DocumentCardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<Layered<DocNameSpan<D>, DocNoteSpan<N>>>.self
    }
}
typealias DocOwnedCard<
    D: Structure,
    N: Structure
> = Layered<
    DocFace,
    SpanHosted<DocInteriorOwned<D, N>>
>
typealias DocSharedCard<
    D: Structure,
    N: Structure
> = Layered<
    DocFace,
    SpanHosted<DocInteriorShared<D, N>>
>

// The six cards divide the surface twice over: each row is dictionary-wide cards with
// breaths between and the side fields as the equally shared remainder — centred by
// construction — and the column grows the frame from an inset, two card rows, a breath.
enum DocCardsRow1: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<DocumentCardWide, SpanLink<SitePath<FinanceVault>, DocOwnedCard<FinanceVault, FinanceVaultNoteText>>>.self
        Air<Breath>.self
        Fixed<DocumentCardWide, SpanLink<SitePath<EngineeringRepo>, DocOwnedCard<EngineeringRepo, EngineeringRepoNoteText>>>.self
        Air<Breath>.self
        Fixed<DocumentCardWide, SpanLink<SitePath<FinanceShare>, DocSharedCard<FinanceShare, SharedNoteText>>>.self
        RestAir.self
    }
}
enum DocCardsRow2: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<DocumentCardWide, SpanLink<SitePath<EngineeringShare>, DocSharedCard<EngineeringShare, SharedNoteText>>>.self
        Air<Breath>.self
        Fixed<DocumentCardWide, SpanLink<SitePath<SalesShare>, DocSharedCard<SalesShare, SharedNoteText>>>.self
        Air<Breath>.self
        Fixed<DocumentCardWide, SpanLink<SitePath<PeopleShare>, DocSharedCard<PeopleShare, SharedNoteText>>>.self
        RestAir.self
    }
}

enum DocDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SurfaceCardShadow.self
    }
}
enum DocHeroStrip: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = DocHeroAriaLabel
    public typealias Defs = DocDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<DocumentCardTall, SpanHosted<DocCardsRow1>>.self
        Air<StripInset>.self
        Fixed<DocumentCardTall, SpanHosted<DocCardsRow2>>.self
        Air<S24Breath>.self
    }
}

func runDocumentsHero() {
    write(DocHeroStrip.typeName, "documents-hero")
    print("generated 1 documents hero (Vector composition)")
}
