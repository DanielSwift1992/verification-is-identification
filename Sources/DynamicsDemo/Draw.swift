import VerificationIsIdentification
import DocumentKit
import Examples

// THE WORLD'S FACE: three rows read off the compiled state, and the buttons ARE
// rule keys. A key compiles only if its rule exists (RuleKey's bound), so the
// drawing cannot show a press that does not stand. The lamp's ink is chosen by
// the slot's own term through a conformance, never by a branch.

protocol Glowing {
    associatedtype Ink: Structure
}
extension LampOff: Glowing {
    typealias Ink = Muted
}
extension LampOn: Glowing {
    typealias Ink = AccentRole
}

enum LampDotCY: Close {}
extension LampDotCY {
    public static var typeName: String { "16" }
}
enum LampDotR: Close {}
extension LampDotR {
    public static var typeName: String { "8" }
}
enum LampDot: SpanDot {
    typealias CY = LampDotCY
    typealias R = LampDotR
    typealias Fill = LampMode.Ink
}

enum OnWord: Close {}
extension OnWord {
    public static var typeName: String { "On" }
}
enum OffWord: Close {}
extension OffWord {
    public static var typeName: String { "Off" }
}
enum BumpWord: Close {}
extension BumpWord {
    public static var typeName: String { "+1" }
}
enum FourWord: Close {}
extension FourWord {
    public static var typeName: String { "4" }
}
enum TwoWord: Close {}
extension TwoWord {
    public static var typeName: String { "2" }
}
enum WorldAria: Close {}
extension WorldAria {
    public static var typeName: String {
        "The world's three slots, read from the compiled types: the lamp, the count, and the pin walk. The buttons are rule keys."
    }
}

enum KeyLabel<T: Structure>: SpanLabelMid {
    typealias Y = CenteredBaseline<TrackHeight, TextS>
    typealias FillColor = ActionRole
    typealias Size = TextS
    typealias Weight = WeightBold
    typealias Content = T
}
enum KeyTrack: SpanTrack {
    typealias H = Tally<TrackHeight>
    typealias Radius = R10
    typealias Fill = SurfaceTrack
}
typealias KeyFace<T: Structure> = Layered<KeyTrack, KeyLabel<T>>

enum SlotLabel<T: Structure>: SpanLabel {
    typealias Y = CenteredBaseline<TrackHeight, TextS>
    typealias FillColor = TextPrimary
    typealias Size = TextS
    typealias Weight = WeightRegular
    typealias Content = T
}
enum LampRow: HFlow {
    typealias Given = PanelWide
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Fixed<DotSlot, LampDot>.self
        Flexible<SlotLabel<TermText<LampMode>>>.self
        Fixed<KeySide, RuleKey<PowerOn, KeyFace<OnWord>>>.self
        Air<HairBreath>.self
        Fixed<KeySide, RuleKey<PowerOff, KeyFace<OffWord>>>.self
        Air<EdgeMargin>.self
    }
}
enum CountRow: HFlow {
    typealias Given = PanelWide
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Air<DotSlot>.self
        Flexible<SlotLabel<Tally<Count>>>.self
        Fixed<KeySide, RuleKey<BumpUp<Never>, KeyFace<BumpWord>>>.self
        Air<EdgeMargin>.self
    }
}
/// The two right digits' whole meanings, folded as nested pairs: any width, one
/// slot by the bound at every link, exactly one leaf matching at any stage.
typealias FourChord = Chord<
    Key4StartsWalk,
    Chord<Key4ResetsStage1, Chord<Key4AdvancesStage2, Key4ResetsStage3>>
>
typealias TwoChord = Chord<
    Key2AdvancesStage1,
    Chord<Key2ResetsStage2, Key2Unlocks>
>

enum PinRow: HFlow {
    typealias Given = PanelWide
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Air<DotSlot>.self
        Flexible<SlotLabel<TermText<PinProgress>>>.self
        Fixed<KeySide, RuleKey<FourChord, KeyFace<FourWord>>>.self
        Air<HairBreath>.self
        Fixed<KeySide, RuleKey<TwoChord, KeyFace<TwoWord>>>.self
        Air<EdgeMargin>.self
    }
}

/// The note's row: the literal slot drawn by an ordinary label — the text the
/// reader typed IS the typeName, and nothing reads it in between.
enum NoteRow: HFlow {
    typealias Given = PanelWide
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Air<DotSlot>.self
        Flexible<SlotLabel<Note>>.self
        Air<EdgeMargin>.self
    }
}

enum WorldArt: GrownDiagram {
    typealias Across = PanelWide
    typealias AriaLabel = WorldAria
    @StructureBuilder
    static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<TrackHeight, SpanHosted<LampRow>>.self
        Air<Breath>.self
        Fixed<TrackHeight, SpanHosted<CountRow>>.self
        Air<Breath>.self
        Fixed<TrackHeight, SpanHosted<PinRow>>.self
        Air<Breath>.self
        Fixed<TrackHeight, SpanHosted<NoteRow>>.self
        Air<EdgeMargin>.self
    }
}
