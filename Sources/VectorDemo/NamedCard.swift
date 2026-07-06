import VerificationIsIdentification
import DocumentKit
import Organization

// NAMED CARD is the named four's guest picture: the same header PersonHero already draws
// (avatar, identity, chips, access dots), plus a vault section a generated employee's card does
// not carry (DESIGN19 §1), the sign-in walk drawn INSIDE the canvas rather than linked out to a
// second picture and a second set of pages (DESIGN19 §2). Five states per person (k0..k3, dead),
// each a `StateGroup` (Vector.swift) switched by `:target`: a correct digit's key links to the
// next state's own fragment; any other key links to the one shared `dead` state; the last
// correct key, at k3, links to the REAL `SecretPage` address instead, `AliceUnlocked` and its
// three siblings, unchanged (DESIGN19 §0). Compilation still proves the walk: a wrong `Key<Dest>`
// here does not fail to build, but a MISSING or misnamed state does, the same way any other
// broken reference in this lattice does.
//
// The page that `SecretPage` resolves to is not this canvas again: it embeds the plain
// `PersonHero` instead, header alone (`runUnlockedHeroes`, below), since reaching that page
// already proved the walk. Asking again, on the very page the walk unlocks, is the one thing a
// visitor would not expect.

// ── the five states, one id atom each, shared across all four canvases (each person's canvas
//    is its own document, so the same bare fragment names cost nothing reused) ──

enum K0Id: Close {}
extension K0Id {
    public static var typeName: String { "k0" }
}
enum K1Id: Close {}
extension K1Id {
    public static var typeName: String { "k1" }
}
enum K2Id: Close {}
extension K2Id {
    public static var typeName: String { "k2" }
}
enum K3Id: Close {}
extension K3Id {
    public static var typeName: String { "k3" }
}
enum DeadId: Close {}
extension DeadId {
    public static var typeName: String { "dead" }
}

// ── the walk, derived from the digits: one state advances on one numeral's key ──

/// A walk state: everything off the path collapses into `dead` (Program Is Path PiP6);
/// exactly one slot advances. `AdvanceOn3<Next>` reads as "the digit three advances":
/// a person's four states spell the person's passcode in plain sight.
typealias OffPath = FragmentOf<DeadId>
typealias AdvanceOn1<Next: Structure> = KeypadFrame<Next, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath>
typealias AdvanceOn2<Next: Structure> = KeypadFrame<OffPath, Next, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath>
typealias AdvanceOn3<Next: Structure> = KeypadFrame<OffPath, OffPath, Next, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath>
typealias AdvanceOn4<Next: Structure> = KeypadFrame<OffPath, OffPath, OffPath, Next, OffPath, OffPath, OffPath, OffPath, OffPath>
typealias AdvanceOn5<Next: Structure> = KeypadFrame<OffPath, OffPath, OffPath, OffPath, Next, OffPath, OffPath, OffPath, OffPath>
typealias AdvanceOn6<Next: Structure> = KeypadFrame<OffPath, OffPath, OffPath, OffPath, OffPath, Next, OffPath, OffPath, OffPath>
typealias AdvanceOn7<Next: Structure> = KeypadFrame<OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, Next, OffPath, OffPath>
typealias AdvanceOn8<Next: Structure> = KeypadFrame<OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, Next, OffPath>
typealias AdvanceOn9<Next: Structure> = KeypadFrame<OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, OffPath, Next>

enum WalkState<
    StateId: Structure,
    Grid: Structure
>: StateGroup {
    public typealias Id = StateId
    public typealias Content = Grid
}

// ── the dead state, one for all four: its panel, message, and reset are spans ──

enum DeadStateText: Close {}
extension DeadStateText {
    public static var typeName: String { "Off path — press reset" }
}
enum DeadStateHeight: Close {}
extension DeadStateHeight {
    public static var typeName: String { "285" }
}
enum DeadMessageBaseline: Close {}
extension DeadMessageBaseline {
    public static var typeName: String { "130" }
}
enum ResetBaseline: Close {}
extension ResetBaseline {
    public static var typeName: String { "160" }
}
enum ResetLinkText: Close {}
extension ResetLinkText {
    public static var typeName: String { "reset" }
}
enum DeadFace: SpanTrack {
    public typealias H = DeadStateHeight
    public typealias Radius = R10
    public typealias Fill = SurfaceTrack
}
enum DeadMessage: SpanLabel {
    public typealias Y = DeadMessageBaseline
    public typealias FillColor = TextSecondary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = DeadStateText
}
enum ResetLabel: SpanLabel {
    public typealias Y = ResetBaseline
    public typealias FillColor = ActionRole
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = ResetLinkText
}
enum DeadInterior: HFlow {
    public typealias Given = DeadPanelWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<DeadInset>.self
        Flexible<Layered<DeadMessage, SpanLink<FragmentOf<K0Id>, ResetLabel>>>.self
    }
}
enum DeadFrame: HFlow {
    public typealias Given = KeypadSide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Fixed<DeadPanelWide, Layered<DeadFace, SpanHosted<DeadInterior>>>.self
        RestAir.self
    }
}
typealias DeadState = WalkState<DeadId, DeadFrame>

// ── one keypad region for all four people: ground, switch rule, dead state, four states ──

enum PersonKeypad<
    G0: Structure,
    G1: Structure,
    G2: Structure,
    G3: Structure
>: Group {
    @StructureBuilder
    public static var body: some Structure {
        KeypadBackground.self
        StateSwitchStyle<K0Id>.self
        KeypadHoverStyle.self
        DeadState.self
        WalkState<K0Id, G0>.self
        WalkState<K1Id, G1>.self
        WalkState<K2Id, G2>.self
        WalkState<K3Id, G3>.self
    }
}

// ── the vault block: heading, the passcode read off the pass TYPE, the keypad in a row ──

/// The caption under "Sign in" is computed from the same `Secret` the gate checks
/// (`SpelledSecret`, Organization/System/Login.swift), never typed a second time.
enum PassCaptionText<P: SpelledSecret>: Close {}
extension PassCaptionText {
    public static var typeName: String { "Password: " + P.spelled }
}

enum VaultHeadingText: Close {}
extension VaultHeadingText {
    public static var typeName: String { "Sign in" }
}
enum VaultHeadingY: Close {}
extension VaultHeadingY {
    public static var typeName: String { "70" }
}
enum VaultCaptionY: Close {}
extension VaultCaptionY {
    public static var typeName: String { "92" }
}
enum VaultKeypadY: Close {}
extension VaultKeypadY {
    public static var typeName: String { "110" }
}
enum VaultHeadingSpan: SpanLabel {
    public typealias Y = VaultHeadingY
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = VaultHeadingText
}
enum VaultCaptionSpan<P: SpelledSecret>: SpanLabel {
    public typealias Y = VaultCaptionY
    public typealias FillColor = TextSecondary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = PassCaptionText<P>
}
enum VaultTextRow<P: SpelledSecret>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<WideMargin>.self
        Flexible<Layered<VaultHeadingSpan, VaultCaptionSpan<P>>>.self
    }
}
enum VaultKeypadRow<Keypad: Structure>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<WideMargin>.self
        Fixed<KeypadSide, SpanHosted<Keypad>>.self
        RestAir.self
    }
}
enum VaultKeypadPlaced<Keypad: Structure>: Dropped {
    public typealias Y = VaultKeypadY
    public typealias Content = VaultKeypadRow<Keypad>
}
enum VaultBlock<P: SpelledSecret, Keypad: Structure>: Group {
    @StructureBuilder
    public static var body: some Structure {
        VaultTextRow<P>.self
        VaultKeypadPlaced<Keypad>.self
    }
}

// ── the four people: each walk spells its passcode, each caption reads the pass type ──

typealias AliceKeypad = PersonKeypad<
    AdvanceOn3<FragmentOf<K1Id>>,
    AdvanceOn1<FragmentOf<K2Id>>,
    AdvanceOn4<FragmentOf<K3Id>>,
    AdvanceOn1<SitePath<AliceUnlocked>>
>
typealias BobKeypad = PersonKeypad<
    AdvanceOn2<FragmentOf<K1Id>>,
    AdvanceOn7<FragmentOf<K2Id>>,
    AdvanceOn1<FragmentOf<K3Id>>,
    AdvanceOn8<SitePath<BobUnlocked>>
>
typealias CarolKeypad = PersonKeypad<
    AdvanceOn1<FragmentOf<K1Id>>,
    AdvanceOn6<FragmentOf<K2Id>>,
    AdvanceOn1<FragmentOf<K3Id>>,
    AdvanceOn8<SitePath<CarolUnlocked>>
>
typealias DaveKeypad = PersonKeypad<
    AdvanceOn1<FragmentOf<K1Id>>,
    AdvanceOn4<FragmentOf<K2Id>>,
    AdvanceOn1<FragmentOf<K3Id>>,
    AdvanceOn4<SitePath<DaveUnlocked>>
>
typealias AliceVaultBlock = VaultBlock<AlicePass, AliceKeypad>
typealias BobVaultBlock = VaultBlock<BobPass, BobKeypad>
typealias CarolVaultBlock = VaultBlock<CarolPass, CarolKeypad>
typealias DaveVaultBlock = VaultBlock<DavePass, DaveKeypad>

// ── the canvas itself — PersonHero's own header, reused whole, plus the vault block below ──

enum NamedCardDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SoftShadow.self
    }
}
enum NamedCard<
    Who: Employee & Person,
    FinanceDot: Structure,
    EngineeringDot: Structure,
    VaultBlock: Structure
>: GrownDiagram {
    public typealias Across = WideSurface
    public typealias AriaLabel = PersonHeroAriaLabel
    public typealias Defs = NamedCardDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<S24Breath>.self
        Fixed<AvatarSide, SpanHosted<PersonHeroHeaderRow<Who, FinanceDot, EngineeringDot>>>.self
        Fixed<VaultZoneTall, SpanHosted<VaultBlock>>.self
    }
}

func runUnlockedHeroes() {
    write(PersonHero<Alice, AliceFinanceDot, AliceEngineeringDot, NoAccentBlock>.typeName, "person-alice-unlocked")
    write(PersonHero<Bob, BobFinanceDot, BobEngineeringDot, NoAccentBlock>.typeName, "person-bob-unlocked")
    write(PersonHero<Carol, CarolFinanceDot, CarolEngineeringDot, NoAccentBlock>.typeName, "person-carol-unlocked")
    write(PersonHero<Dave, DaveFinanceDot, DaveEngineeringDot, NoAccentBlock>.typeName, "person-dave-unlocked")
    print("generated 4 signed-in heroes (Alice/Bob/Carol/Dave), header alone, no keypad")
}

func runNamedCards() {
    write(NamedCard<
        Alice,
        AliceFinanceDot,
        AliceEngineeringDot,
        AliceVaultBlock
    >.typeName, "person-alice")
    write(NamedCard<
        Bob,
        BobFinanceDot,
        BobEngineeringDot,
        BobVaultBlock
    >.typeName, "person-bob")
    write(NamedCard<
        Carol,
        CarolFinanceDot,
        CarolEngineeringDot,
        CarolVaultBlock
    >.typeName, "person-carol")
    write(NamedCard<
        Dave,
        DaveFinanceDot,
        DaveEngineeringDot,
        DaveVaultBlock
    >.typeName, "person-dave")
    runUnlockedHeroes()
    print("generated 4 named cards (Alice/Bob/Carol/Dave), keypad walk embedded in each")
}
