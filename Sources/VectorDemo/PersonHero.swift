import VerificationIsIdentification
import DocumentKit
import Organization

// PersonHero — one 960×150 canvas per generated employee (`person-emp####.svg`): identity,
// role, and access, read straight off the compiled roster. Every word on the card is `Who`'s
// field, read, not retyped, with ONE exception, unavoidable: the two access dots.
// `ViewDotColor<Who, Of>`'s conditional dispatch (Organization/View/Cells.swift), read through
// THIS canvas's generic body, hits the exact generic-indirection limit Cells.swift's
// header names (a conditionally-typed witness resolves once for the READING type's generic
// bound, not per later instantiation), so `PersonHero` takes both colours, and its accent
// slot, as EXPLICIT parameters, already resolved at whichever literal site instantiates it, one
// generated line per `Emp####` (`GeneratedPersonHeroes.swift`), the same fix `TaskCardCore`'s
// `Chip` parameter already stands on (Board.swift). The named four's picture is bigger,
// `NamedCard` (NamedCard.swift): the same header, plus a vault section this type does not carry.
//
// The header is ONE weighted row over the whole 960, in single pixel units: margin 27,
// avatar 96, breath 20, the identity-and-chips region 541, breath 10, the access region 252,
// margin 14. Vertical positions stay stated tokens behind `SpanLowered` until the height walk.

enum PersonHeroAriaLabel: Close {}
extension PersonHeroAriaLabel {
    public static var typeName: String {
        "A person's identity, role, and access, read from the compiled roster."
    }
}

// ── the avatar disc — reuse `AvatarShapes` (Cards.swift) at a smaller scale, never a second,
// redrawn glyph ──

enum PersonHeroAvatarScale: Close {}
extension PersonHeroAvatarScale {
    public static var typeName: String { "0.48" }
}
enum PersonHeroAvatarFace: SpanTrack {
    public typealias H = Tally<AvatarSide>
    public typealias Radius = R16
    public typealias Fill = SurfaceTrack
}
enum PersonHeroAvatarGlyphFilled: FilledGroup {
    public typealias Fill = TextSecondary
    public typealias Content = AvatarShapes
}
enum PersonHeroAvatarScaled: PlacedScaled {
    public typealias X = N0
    public typealias Y = N0
    public typealias Scale = PersonHeroAvatarScale
    public typealias Content = PersonHeroAvatarGlyphFilled
}
typealias PersonHeroAvatar = Layered<PersonHeroAvatarFace, SpanHosted<PersonHeroAvatarScaled>>

// ── name + handle — the name is budget-gated (the class of overflow DESIGN12's own
// negative probe already caught once, for a different label) ──

enum PersonHeroNameY: Close {}
extension PersonHeroNameY {
    public static var typeName: String { "26" }
}
enum PersonHeroHandleY: Close {}
extension PersonHeroHandleY {
    public static var typeName: String { "44" }
}
enum PersonHeroNameBudget: Close {}
extension PersonHeroNameBudget {
    public static var typeName: String { "40" }
}
enum PersonHeroNameText<
    Who: Employee & Person
>: Close {}
extension PersonHeroNameText {
    public static var typeName: String { "\(Who.Given.typeName) \(Who.Family.typeName)" }
}
enum PersonHeroHandleText<
    Who: Employee & Person
>: Close {}
extension PersonHeroHandleText {
    public static var typeName: String { String(describing: Who.self) }
}
enum PersonHeroNameSpan<
    Who: Employee & Person
>: SpanLabelBudgeted {
    public typealias Y = PersonHeroNameY
    public typealias FillColor = TextPrimary
    public typealias Size = TextL
    public typealias Weight = WeightRegular
    public typealias Content = PersonHeroNameText<Who>
    public typealias Budget = PersonHeroNameBudget
}
enum PersonHeroHandleSpan<
    Who: Employee & Person
>: SpanLabel {
    public typealias Y = PersonHeroHandleY
    public typealias FillColor = TextSecondary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = PersonHeroHandleText<Who>
}

// ── chip row — Rank · Department (Linked to the Departments hub) · Site: three equal spans
// of 175 with breaths of 8, one generous shared width (THE CANVAS CONTRACT's doctrine: state
// the box, never compute the fit) rather than a width per literal value ──

enum PersonHeroChipY: Close {}
extension PersonHeroChipY {
    public static var typeName: String { "66" }
}
enum PersonHeroChipHeight: Close {}
extension PersonHeroChipHeight {
    public static var typeName: String { "24" }
}
enum PersonHeroChipTextDY: Close {}
extension PersonHeroChipTextDY {
    public static var typeName: String { "16" }
}
enum PersonHeroChipTrack: SpanTrack {
    public typealias H = PersonHeroChipHeight
    public typealias Radius = R12
    public typealias Fill = SurfaceTrack
}
enum PersonHeroChipLabelSpan<
    T: Structure
>: SpanLabel {
    public typealias Y = PersonHeroChipTextDY
    public typealias FillColor = TextPrimary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PersonHeroChipInterior<
    T: Structure
>: HFlow {
    public typealias Given = PersonChipWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ChipPad>.self
        Flexible<PersonHeroChipLabelSpan<T>>.self
    }
}
typealias PersonHeroChipSpan<T: Structure> = Layered<
    PersonHeroChipTrack,
    SpanHosted<PersonHeroChipInterior<T>>
>
enum PersonHeroChipTriplet<
    Who: Employee & Person
>: HFlow {
    public typealias Given = ChipTripletWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Fixed<PersonChipWide, PersonHeroChipSpan<Who.Rank>>.self
        Air<HairBreath>.self
        Fixed<PersonChipWide, SpanLink<SitePath<Nav.Departments>, PersonHeroChipSpan<Who.Home>>>.self
        Air<HairBreath>.self
        Fixed<PersonChipWide, PersonHeroChipSpan<Who.Site>>.self
        RestAir.self
    }
}

// ── access section — two rows (Finance / Engineering), each a dot (`FinanceDot`/`EngineeringDot`
// — already-resolved colours, see this file's header) plus the vault's name. Only two
// vaults exist at all, so their labels are two fixed atoms, not a generic reveal. ──

enum PersonHeroAccessRow1Y: Close {}
extension PersonHeroAccessRow1Y {
    public static var typeName: String { "32" }
}
enum PersonHeroAccessRow2Y: Close {}
extension PersonHeroAccessRow2Y {
    public static var typeName: String { "66" }
}
enum PersonHeroDotR: Close {}
extension PersonHeroDotR {
    public static var typeName: String { "6" }
}
enum PersonHeroAccessLabelDY: Close {}
extension PersonHeroAccessLabelDY {
    public static var typeName: String { "5" }
}
enum PersonHeroFinanceVaultText: Close {}
extension PersonHeroFinanceVaultText {
    public static var typeName: String { "Finance Vault" }
}
enum PersonHeroEngineeringRepoText: Close {}
extension PersonHeroEngineeringRepoText {
    public static var typeName: String { "Engineering Repo" }
}
enum PersonHeroAccessDotSpan<
    Fill: Structure
>: SpanDot {
    public typealias CY = N0
    public typealias R = PersonHeroDotR
    public typealias Fill = Fill
}
enum PersonHeroAccessLabelSpan<
    T: Structure
>: SpanLabel {
    public typealias Y = PersonHeroAccessLabelDY
    public typealias FillColor = TextSecondary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum PersonHeroAccessSpanRow<
    Fill: Structure,
    T: Structure
>: HFlow {
    public typealias Given = AccessWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Fixed<DotSlot, PersonHeroAccessDotSpan<Fill>>.self
        Air<StripInset>.self
        Flexible<PersonHeroAccessLabelSpan<T>>.self
    }
}
typealias PersonHeroAccessRegion<
    FinanceDot: Structure,
    EngineeringDot: Structure
> = Layered<
    SpanLowered<PersonHeroAccessRow1Y, SpanHosted<PersonHeroAccessSpanRow<FinanceDot, PersonHeroFinanceVaultText>>>,
    SpanLowered<PersonHeroAccessRow2Y, SpanHosted<PersonHeroAccessSpanRow<EngineeringDot, PersonHeroEngineeringRepoText>>>
>

// ── the header row: the whole 960 weighed once, every x a prefix of the chain ──

enum PersonHeroHeaderRow<
    Who: Employee & Person,
    FinanceDot: Structure,
    EngineeringDot: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<S24Breath>.self
        Fixed<AvatarSide, PersonHeroAvatar>.self
        Air<S24Breath>.self
        Fixed<
            ChipTripletWide,
            Layered<
                Layered<PersonHeroNameSpan<Who>, PersonHeroHandleSpan<Who>>,
                SpanLowered<PersonHeroChipY, SpanHosted<PersonHeroChipTriplet<Who>>>
            >
        >.self
        RestAir.self
        Fixed<AccessWide, PersonHeroAccessRegion<FinanceDot, EngineeringDot>>.self
        Air<EdgeMargin>.self
    }
}

// ── accent slot — the one place the three person-classes actually differ (DESIGN14 §3's own
// hierarchy: the named four's real CTA, a departed employee's quiet note, nothing for an
// active generated one — its role-string is already in the chip row). ──

enum PersonHeroAccentY: Close {}
extension PersonHeroAccentY {
    public static var typeName: String { "124" }
}

/// Nothing — an active generated employee's accent slot: the role string already sits in
/// the chip row, so there is nothing further to say here. One statement, rendering no visible
/// mark, keeps `@StructureBuilder`'s fold (which needs at least one) satisfied.
enum NoAccentBlock: Close {}
extension NoAccentBlock {
    public static var typeName: String { "" }
}

enum LeftInChipText<
    Year: Structure
>: Close {}
extension LeftInChipText {
    public static var typeName: String { "Left in \(Year.typeName)" }
}
enum LeftInChipFace: SpanTrackOutlined {
    public typealias H = PersonHeroChipHeight
    public typealias Radius = R12
    public typealias Fill = SurfaceTrack
    public typealias Stroke = LineRole
}
enum LeftInChipLabelSpan<
    Year: Structure
>: SpanLabel {
    public typealias Y = PersonHeroChipTextDY
    public typealias FillColor = TextSecondary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = LeftInChipText<Year>
}
enum LeftInChipInterior<
    Year: Structure
>: HFlow {
    public typealias Given = PersonChipWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<ChipPad>.self
        Flexible<LeftInChipLabelSpan<Year>>.self
    }
}
/// The departed chip stands alone at the accent slot, its width its dictionary extent.
enum LeftInChip<
    Year: Structure
>: HFlow {
    public typealias Given = PersonChipWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Fixed<PersonChipWide, Layered<LeftInChipFace, SpanHosted<LeftInChipInterior<Year>>>>.self
        RestAir.self
    }
}
enum LeftIn2026Year: Close {}
extension LeftIn2026Year {
    public static var typeName: String { "2026" }
}
enum LeftIn2027Year: Close {}
extension LeftIn2027Year {
    public static var typeName: String { "2027" }
}
enum LeftIn2028Year: Close {}
extension LeftIn2028Year {
    public static var typeName: String { "2028" }
}
enum LeftIn2029Year: Close {}
extension LeftIn2029Year {
    public static var typeName: String { "2029" }
}
enum LeftIn2026Chip: Group {
    @StructureBuilder
    public static var body: some Structure {
        LeftInChip<LeftIn2026Year>.self
    }
}
enum LeftIn2027Chip: Group {
    @StructureBuilder
    public static var body: some Structure {
        LeftInChip<LeftIn2027Year>.self
    }
}
enum LeftIn2028Chip: Group {
    @StructureBuilder
    public static var body: some Structure {
        LeftInChip<LeftIn2028Year>.self
    }
}
enum LeftIn2029Chip: Group {
    @StructureBuilder
    public static var body: some Structure {
        LeftInChip<LeftIn2029Year>.self
    }
}

// ── the canvas itself ──

enum PersonHeroAccentRow<
    AccentBlock: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<AccessWide, SpanHosted<AccentBlock>>.self
        Air<EdgeMargin>.self
    }
}
enum PersonHeroAccentPlaced<
    AccentBlock: Structure
>: Dropped {
    public typealias Y = PersonHeroAccentY
    public typealias Content = PersonHeroAccentRow<AccentBlock>
}

enum PersonHeroCanvas<
    Who: Employee & Person,
    FinanceDot: Structure,
    EngineeringDot: Structure,
    AccentBlock: Structure
>: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = PersonHeroAriaLabel
    public typealias Defs = PersonHeroDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<S24Breath>.self
        Fixed<AvatarSide, SpanHosted<PersonHeroHeaderRow<Who, FinanceDot, EngineeringDot>>>.self
        Fixed<Never, SpanHosted<PersonHeroAccentRow<AccentBlock>>>.self
        Air<S24Breath>.self
    }
}
enum PersonHeroDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SoftShadow.self
    }
}
typealias PersonHero<
    Who: Employee & Person,
    FinanceDot: Structure,
    EngineeringDot: Structure,
    AccentBlock: Structure
> = PersonHeroCanvas<Who, FinanceDot, EngineeringDot, AccentBlock>

// A named person's GUEST picture is `NamedCard`'s (NamedCard.swift), not this file's plain
// `PersonHero`: the same header, plus the vault section a generated employee's card does not
// carry. This type stays the 200 generated employees' canvas (`GeneratedPersonHeroes.swift`)
// AND a named person's SIGNED-IN picture (`runUnlockedHeroes`, NamedCard.swift): once the walk
// resolves, there is nothing personal left to unlock, so that page's header is this same plain
// shape, not `NamedCard`'s again.
