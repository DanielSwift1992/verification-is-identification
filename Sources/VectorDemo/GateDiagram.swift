import VerificationIsIdentification
import DocumentKit
import Organization

// gate.svg — the state graph every named person's keypad walk draws (DESIGN19 §3), one
// abstract diagram instead of Alice's/Bob's/Carol's/Dave's four separate pictures: the shape is
// the same for all four, only the digits differ, and the digits already live on each person's
// own card. Five boxes and the transitions a real digit press makes: `k0`..`k3` name the exact
// fragment ids `NamedCard.swift` emits (`StateGroup`'s `Id`), so this picture and the mechanism
// it explains cannot drift apart: reading one is reading the other. `Unlocked` is not a sixth
// state of the same kind: it is the one box reached by a real link (`SitePath`, unchanged since
// DESIGN19 §0), not a fragment, drawn with its own border to mark that difference. `dead`
// collapses every wrong digit, from every state, onto one shared box (Program Is Path PiP6: an
// invalid step folds onto the path already there rather than opening a new one), and `reset`
// is the one way back out of it.
//
// The row is weights now, and the arrows between neighbours are the weighed gaps themselves
// (`SpanArrowAcross`): no statement names a position, and inserting a sixth box costs two
// lines, not a re-measure. The diagonal wrong-digit paths land the law the flow pilot could
// not: a box's centre is a FRACTION of the row (`Sum` of the start and a `Slice` through the
// same weight lexicon the row's body reads), and `SpanPx` of that fraction serves as the
// coordinate token any absolute piece can read. The cross-flow reference has its query.

enum GateLabel: Close {}
extension GateLabel {
    public static var typeName: String {
        "The keypad's state graph: k0 through k3 are the digits entered so far, correct one "
            + "moves to the next box, any other digit collapses to the one shared dead box, "
            + "reset returns to k0, and the last correct digit at k3 is a real link to Unlocked, "
            + "not another box in this picture."
    }
}
typealias GateSize = CanvasSize<GateSurface, GateTall>
// ── the shared lexicon: box, step, breath — every position below is a sum of these ──


enum GateTitleY: Close {}
extension GateTitleY {
    public static var typeName: String { "26" }
}
enum GateSubtitleY: Close {}
extension GateSubtitleY {
    public static var typeName: String { "46" }
}
enum GateCaptionAboveY: Close {}
extension GateCaptionAboveY {
    public static var typeName: String { "-8" }   // above the box's own top edge, local
}

// ── one box visual for every state: face, title on the middle, subtitle under it ──

enum GateBoxFace: SpanTrackOutlined {
    public typealias H = Tally<GateBoxTall>
    public typealias Radius = R10
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum GateUnlockedFace: SpanTrackOutlined {
    public typealias H = Tally<GateBoxTall>
    public typealias Radius = R10
    public typealias Fill = SurfaceCard
    public typealias Stroke = ActionRole
}
enum GateBoxTitleSpan<Text: Structure>: SpanLabelMid {
    public typealias Y = GateTitleY
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = Text
}
enum GateBoxSubtitleSpan<Text: Structure>: SpanLabelMid {
    public typealias Y = GateSubtitleY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = Text
}
typealias GateBoxArt<
    Title: Structure,
    Subtitle: Structure
> = Layered<
    GateBoxFace,
    Layered<GateBoxTitleSpan<Title>, GateBoxSubtitleSpan<Subtitle>>
>
enum GateStepArrow: SpanArrowAcross {
    public typealias Y = Tally<GateArrowDrop>
}

// ── the states' words ──

enum GateK0Text: Close {}
extension GateK0Text {
    public static var typeName: String { "k0" }
}
enum GateK0SubtitleText: Close {}
extension GateK0SubtitleText {
    public static var typeName: String { "0 digits" }
}
enum GateK1Text: Close {}
extension GateK1Text {
    public static var typeName: String { "k1" }
}
enum GateK1SubtitleText: Close {}
extension GateK1SubtitleText {
    public static var typeName: String { "1 digit" }
}
enum GateK2Text: Close {}
extension GateK2Text {
    public static var typeName: String { "k2" }
}
enum GateK2SubtitleText: Close {}
extension GateK2SubtitleText {
    public static var typeName: String { "2 digits" }
}
enum GateK3Text: Close {}
extension GateK3Text {
    public static var typeName: String { "k3" }
}
enum GateK3SubtitleText: Close {}
extension GateK3SubtitleText {
    public static var typeName: String { "3 digits" }
}
enum GateUnlockedText: Close {}
extension GateUnlockedText {
    public static var typeName: String { "Unlocked" }
}
enum GateUnlockedSubtitleText: Close {}
extension GateUnlockedSubtitleText {
    public static var typeName: String { "real address" }
}
enum GateRealLinkText: Close {}
extension GateRealLinkText {
    public static var typeName: String { "a real link, not a fragment" }
}
enum GateRealLinkCaption: SpanLabelItalic {
    public typealias Y = GateCaptionAboveY
    public typealias Size = TextXXS
    public typealias Content = GateRealLinkText
}
typealias GateUnlockedArt = Layered<
    GateUnlockedFace,
    Layered<
        Layered<GateBoxTitleSpan<GateUnlockedText>, GateBoxSubtitleSpan<GateUnlockedSubtitleText>>,
        GateRealLinkCaption
    >
>

// ── the row itself: four boxes, three step-arrows, one wide breath-arrow, the last box.
// The connectors ARE the space between neighbours; insert a box, and every arrow after it
// moves because it never held a coordinate to begin with. ──

enum GateRow: HFlow {
    public typealias Given = GateSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Fixed<GateBoxWide, GateBoxArt<GateK0Text, GateK0SubtitleText>>.self
        Fixed<GateStep, GateStepArrow>.self
        Fixed<GateBoxWide, GateBoxArt<GateK1Text, GateK1SubtitleText>>.self
        Fixed<GateStep, GateStepArrow>.self
        Fixed<GateBoxWide, GateBoxArt<GateK2Text, GateK2SubtitleText>>.self
        Fixed<GateStep, GateStepArrow>.self
        Fixed<GateBoxWide, GateBoxArt<GateK3Text, GateK3SubtitleText>>.self
        Fixed<GateBreath, GateStepArrow>.self
        Fixed<GateBoxWide, GateUnlockedArt>.self
        RestAir.self
    }
}
enum GateRowPlaced: Dropped {
    public typealias Y = Tally<GateRowDrop>
    public typealias Content = GateRow
}

// ── dead — one shared box below the row. Its slice rides its own row; the four arrows INTO
// it read each state's centre as a FRACTION of the same lexicon the row's body reads: one
// vocabulary, one geometry, nothing mirrored by hand. ──

enum GateDeadText: Close {}
extension GateDeadText {
    public static var typeName: String { "dead" }
}
enum GateDeadSubtitleText: Close {}
extension GateDeadSubtitleText {
    public static var typeName: String { "every wrong digit" }
}
typealias GateDeadShift = Plus<Twice<Plus<GateBoxWide, GateStep>>, StripInset>

enum GateDeadRow: HFlow {
    public typealias Given = GateSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<GateDeadShift>.self
        Fixed<GateBoxWide, GateBoxArt<GateDeadText, GateDeadSubtitleText>>.self
        RestAir.self
    }
}
enum GateDeadPlaced: Dropped {
    public typealias Y = Tally<GateDeadDrop>
    public typealias Content = GateDeadRow
}

// ── centres as fractions: the query the flow pilot lacked. `SpanPx` of a fraction is a
// coordinate token any absolute piece can read; these read the row's own weights. ──

typealias GateCenterAt<Prefix: Structure> = GivenSpan<Plus<Prefix, GateHalfBox>>
typealias GateK0Center = GateCenterAt<Never>
typealias GateK1Center = GateCenterAt<Plus<GateBoxWide, GateStep>>
typealias GateK2Center = GateCenterAt<Twice<Plus<GateBoxWide, GateStep>>>
typealias GateK3Center = GateCenterAt<Plus<Twice<Plus<GateBoxWide, GateStep>>, Plus<GateBoxWide, GateStep>>>
typealias GateDeadCenter = GateCenterAt<GateDeadShift>

// The fall: put the pen at a state's bottom edge and slide to dead's top centre: both
// points derived, the diagonal free.
enum GateWrongArrow<Center: Frac & Structure>: DashedArrow {
    public typealias Path = SlideTo<StartAt<Center, GateBoxBottom>, GateDeadCenter, GateDeadDrop>
}
enum GateAnyOtherDigitText: Close {}
extension GateAnyOtherDigitText {
    public static var typeName: String { "any other digit, from any state" }
}
// The annotation stands beside the bundle: its height is the halfway line of the fall,
// derived; its X is the one stated number left in this file, where beside the lines the
// words sit is route data, a drawing's own fact.
enum GateAnyOtherDigitX: Close {}
extension GateAnyOtherDigitX {
    public static var typeName: String { "645" }
}
enum GateAnyOtherDigitLabel: ItalicLabel {
    public typealias X = GateAnyOtherDigitX
    public typealias Y = Halfway<GateBoxBottom, GateDeadDrop>
    public typealias Anchor = AnchorMiddle
    public typealias Size = TextXXS
    public typealias Content = GateAnyOtherDigitText
}
enum GateWrongArrows: Group {
    @StructureBuilder
    public static var body: some Structure {
        GateWrongArrow<GateK0Center>.self
        GateWrongArrow<GateK1Center>.self
        GateWrongArrow<GateK2Center>.self
        GateWrongArrow<GateK3Center>.self
        GateAnyOtherDigitLabel.self
    }
}

// ── reset — dead's own way back to k0, routed below the wrong-digit paths so it reads as its
// own line, not a fifth arrow lost among them. The same centre fractions, read again. ──

// Reset, walked by the pen: start under dead, go down until the turn line, go left until
// k0's centre, go up until the boxes' bottom edge. Four stopping conditions, no point
// stated.
enum GateArrowReset: DashedArrow {
    public typealias Path = UntilY<
        UntilX<
            UntilY<
                StartAt<GateDeadCenter, GateDeadBottom>,
                GateResetTurn
            >,
            GateK0Center
        >,
        GateBoxBottom
    >
}
enum GateResetText: Close {}
extension GateResetText {
    public static var typeName: String { "reset" }
}
// The label hangs one text baseline under the turn line: the 13 is typography (the one
// stated hole), the line it hangs from is the pen's own rung.
enum GateResetBaseline: Close {}
extension GateResetBaseline {
    public static var typeName: String { "13" }
}
enum GateResetLabelY: Close {}
extension GateResetLabelY {
    public static var typeName: String {
        String(GateResetTurn.count + Int(GateResetBaseline.typeName)!)
    }
}
enum GateResetLabel: ItalicLabel {
    public typealias X = SpanPx<GateK1Center>
    public typealias Y = GateResetLabelY
    public typealias Anchor = AnchorMiddle
    public typealias Size = TextXXS
    public typealias Content = GateResetText
}
enum GateResetGroup: Group {
    @StructureBuilder
    public static var body: some Structure {
        GateArrowReset.self
        GateResetLabel.self
    }
}

// ── the whole diagram ──

enum GateContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        ArrowMarkers.self
        SoftShadow.self
        GateWrongArrows.self
        GateResetGroup.self
        GateRowPlaced.self
        GateDeadPlaced.self
    }
}
// A stated frame by decision: the gate's height is route data (diagonal arrow bundles,
// hand-drawn), not a sum of members, so there is nothing for a grown frame to derive.
enum GateDiagram: Diagram {
    public typealias Size = GateSize
    public typealias AriaLabel = GateLabel
    public typealias Content = GateContent
}

func runGateDiagram() {
    write(GateDiagram.typeName, "gate")
    print("generated 1 gate state-graph diagram (weighed row, arrows are the gaps, centres are fractions)")
}
