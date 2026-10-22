import Notation

/// Supplies a world's faces, caption paint and shadow at the reading edge.
/// Requires each canvas to name its binding for type checking.
public protocol DrawingStyle: Structure {
    associatedtype BodyFace: Structure
    associatedtype CaptionFace: Structure
    associatedtype AccentRole: Paint
    associatedtype TextSecondary: Paint
    associatedtype ShadowPaint: Paint
    associatedtype ShadowOpacity: Structure
    associatedtype LeafCountBases: Structure
}

/// Marks a paint supplied by a world.
public protocol Paint: Structure {}

/// Supplies the ground and glyph of the same card composition.
public protocol CardPalette {
    associatedtype Surface: Paint
    associatedtype Glyph: Paint
}

/// Paints a canvas ground from the world's stated page role.
public enum PageBackdrop<Fill: Paint>: Close {}
extension PageBackdrop {
    public static var typeName: String {
        "<rect width=\"100%\" height=\"100%\" fill=\"" + XMLEscaped<Fill>.typeName + "\"/>\n"
    }
}

/// The filter's name, spelled once: the def states its `id` through this atom and every
/// applier builds its `url()` from the same atom, so a rename cannot strand an applier.
public enum SoftShadowName: Close {}
extension SoftShadowName {
    public static var typeName: String { "soft-shadow" }
}
/// `SurfaceCardShadow`'s name, held to the same rule.
public enum SurfaceCardShadowName: Close {}
extension SurfaceCardShadowName {
    public static var typeName: String { "surface-card-shadow" }
}
/// The envelope both shadow filters share: room around the shape for the blur to paint in.
public enum ShadowEnvelope: Close {}
extension ShadowEnvelope {
    public static var typeName: String { "x=\"-20%\" y=\"-20%\" width=\"140%\" height=\"140%\"" }
}
public enum ShadowCast<Binding: DrawingStyle>: Close {}
extension ShadowCast {
    public static var typeName: String {
        "dx=\"0\" dy=\"5\" stdDeviation=\"10\" flood-color=\"" + XMLEscaped<Binding.ShadowPaint>.typeName + "\""
    }
}
/// Reads the shadow paint and opacity from the canvas binding.
public enum SoftShadow<Binding: DrawingStyle>: Close {}
extension SoftShadow {
    public static var typeName: String {
        "<filter id=\"" + SoftShadowName.typeName + "\" " + ShadowEnvelope.typeName + ">\n"
            + "<feDropShadow " + ShadowCast<Binding>.typeName + " flood-opacity=\"" + XMLEscaped<Binding.ShadowOpacity>.typeName + "\"/>\n"
            + "</filter>\n"
    }
}
/// This is `SoftShadow` applied to a subtree, the one place a `Paper` card differs from a flat
/// `RoundedFullBleedRect`.
public protocol Shadowed: Open {
    associatedtype Content: Structure
}
extension Shadowed {
    public static var typeName: String {
        "<g filter=\"url(#" + SoftShadowName.typeName + ")\">\n" + Content.typeName + "</g>\n"
    }
}

/// Lets the host switch a surface shadow through its named opacity variable.
public enum SurfaceCardShadow<Binding: DrawingStyle>: Close {}
extension SurfaceCardShadow {
    public static var typeName: String {
        "<filter id=\"" + SurfaceCardShadowName.typeName + "\" " + ShadowEnvelope.typeName + ">\n"
            + "<feDropShadow " + ShadowCast<Binding>.typeName
            + " flood-opacity=\"var(--vi-surface-card-shadow-opacity, " + XMLEscaped<Binding.ShadowOpacity>.typeName + ")\"/>\n"
            + "</filter>\n"
    }
}
/// This is `SurfaceCardShadow` applied to a subtree: `KpiCardBackground`'s wrapper, the
/// theme-conditional twin of `Shadowed`.
public protocol ThemedShadowed: Open {
    associatedtype Content: Structure
}
extension ThemedShadowed {
    public static var typeName: String {
        "<g filter=\"url(#" + SurfaceCardShadowName.typeName + ")\">\n" + Content.typeName + "</g>\n"
    }
}

// ── Scales — the only numbers a component is allowed to introduce ──

public enum S8: Close {}
extension S8 {
    public static var typeName: String { "8" }
}
public enum S16: Close {}
extension S16 {
    public static var typeName: String { "16" }
}
public enum S24: Close {}
extension S24 {
    public static var typeName: String { "24" }
}
public enum S32: Close {}
extension S32 {
    public static var typeName: String { "32" }
}

// ── Stroke voices: the two widths every line in the system speaks, the dash of a
// dependency, and the one arrowhead every arrow shares. Named once, and a combinator reads
// its voice, never a bare number. ──
public enum HairlineWidth: Close {}
extension HairlineWidth {
    public static var typeName: String { "1" }
}
public enum ArrowWidth: Close {}
extension ArrowWidth {
    public static var typeName: String { "2" }
}
public enum DependencyDash: Close {}
extension DependencyDash {
    public static var typeName: String { "4 3" }
}
public enum ArrowHeadName: Close {}
extension ArrowHeadName {
    public static var typeName: String { "a" }
}

public enum R4: Close {}
extension R4 {
    public static var typeName: String { "4" }
}
public enum R6: Close {}
extension R6 {
    public static var typeName: String { "6" }
}
public enum R10: Close {}
extension R10 {
    public static var typeName: String { "10" }
}
public enum R16: Close {}
extension R16 {
    public static var typeName: String { "16" }
}
public enum R20: Close {}
extension R20 {
    public static var typeName: String { "20" }
}
public enum R12: Close {}
extension R12 {
    public static var typeName: String { "12" }
}

public enum TextXXS: Close {}
extension TextXXS {
    public static var typeName: String { "10" }
}
public enum TextXS: Close {}
extension TextXS {
    public static var typeName: String { "11" }
}
public enum TextS: Close {}
extension TextS {
    public static var typeName: String { "13" }
}
public enum TextM: Close {}
extension TextM {
    public static var typeName: String { "15" }
}
public enum TextL: Close {}
extension TextL {
    public static var typeName: String { "17" }
}
public enum TitleT: Close {}
extension TitleT {
    public static var typeName: String { "21" }
}
public enum DisplayS: Close {}
extension DisplayS {
    public static var typeName: String { "28" }
}
public enum Display: Close {}
extension Display {
    public static var typeName: String { "40" }
}

// A world grants these categories to its paints after checking its own pairs.
// The wrappers require the grant; the mechanism grants no concrete colour.

public protocol LegibleOnInk: Paint {}

/// This is a foreground legible against the `SurfaceCard` role.
public protocol LegibleOnSurfaceCard: Paint {}

/// This is a foreground legible against the `SurfaceTrack` role.
public protocol LegibleOnSurfaceTrack: Paint {}   // law:allow — a palette gate: its content is which foregrounds conform; the reading site (a Gated wrapper) comes and goes with canvases, the category stays

/// This is a foreground legible against the `AccentRole` role.
public protocol LegibleOnAccentRole: Paint {}   // law:allow — same palette-gate class as its SurfaceTrack sibling

/// This marks a foreground legible against a `NavyTint` background, unused (see above), kept as-is.
public protocol LegibleOnNavyTint: Paint {}

// Span labels carry an explicit fill, while these wrappers also require a pairing grant.

public protocol GatedBoldTextOnInk: Open {
    associatedtype Fg: LegibleOnInk
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Anchor: Structure
    associatedtype Size: Structure
    associatedtype Content: Structure
}
extension GatedBoldTextOnInk {
    public static var typeName: String {
        "<text x=\"\(X.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"\(Anchor.typeName)\" "
            + "fill=\"\(Fg.typeName)\" font-weight=\"700\" font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
    }
}
public protocol GatedTextOnNavyTint: Open {
    associatedtype Fg: LegibleOnNavyTint
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Anchor: Structure
    associatedtype Size: Structure
    associatedtype Content: Structure
}
extension GatedTextOnNavyTint {
    public static var typeName: String {
        "<text x=\"\(X.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"\(Anchor.typeName)\" "
            + "fill=\"\(Fg.typeName)\" font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
    }
}
public protocol GatedTextOnSurfaceCard: Open {
    associatedtype Fg: LegibleOnSurfaceCard
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Anchor: Structure
    associatedtype Size: Structure
    associatedtype Content: Structure
}
extension GatedTextOnSurfaceCard {
    public static var typeName: String {
        "<text x=\"\(X.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"\(Anchor.typeName)\" "
            + "fill=\"\(Fg.typeName)\" font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
    }
}

// ── Card metrics: the heights and baselines the span-drawn KPI cards read. The card art
// itself is on the span engine (`SpanCardFace`/`SpanHeroFace` and `SpanLabel`). What the
// design system keeps is the vertical word: how tall a metric tile is, where its title
// and value are. `AccentRole`'s only legal foreground remains `OnAccent`: one hero per screen. ──

public typealias KpiCardHeight = Plus<
    U64,
    Plus<
        U32,
        Plus<
            U16,
            U8
        >
    >
>   // the metric tile's height
public enum KpiTitleY: Close {}
extension KpiTitleY {
    public static var typeName: String { "36" }
}
public enum KpiValueY: Close {}
extension KpiValueY {
    public static var typeName: String { "92" }
}
public enum AnchorStart: Close {}
extension AnchorStart {
    public static var typeName: String { "start" }
}
public enum AnchorEnd: Close {}
extension AnchorEnd {
    public static var typeName: String { "end" }
}
public enum AnchorMiddle: Close {}
extension AnchorMiddle {
    public static var typeName: String { "middle" }
}

// ── AXIS POLICY AND ELEMENT EXTENTS — the dictionary a divided axis speaks. A canvas
// names these, and only this file spells them in rungs. `EdgeMargin` is at a canvas's
// edges, `Breath` between neighbours. An element's extent is the width it takes off the
// axis, one named step per element kind. ──

// `EdgeMargin` and `Breath` share a rung by decision, and keep two names: the edge of a
// canvas and the space between neighbours are different promises, free to diverge, and a
// canvas that says which one it means survives the day one of them moves.
public typealias EdgeMargin = U16
public typealias HairBreath = U8
public typealias S24Breath = Plus<U16, U8>
public typealias StripInset = Plus<U8, U2>
public typealias Gutter = Plus<U32, U16>
public typealias QuadTrackBlock = Plus<
    Times<U4, TrackHeight>,
    Times<Plus<U2, U1>, Breath>
>   // four tracks and their three breaths
public typealias PanelWide = Times<
    U8,
    Plus<
        U32,
        Plus<
            U16,
            Plus<
                U4,
                Plus<
                    U2,
                    U1
                >
            >
        >
    >
>   // eight fifty-fives: the dashboard's half panel
public typealias Breath = U16
public typealias CardWide = Plus<
    U128,
    Plus<
        U64,
        Plus<
            U16,
            Plus<
                U8,
                U4
            >
        >
    >
>   // the catalog card, and the summary strip's chip
public typealias DocumentCardWide = Plus<
    U256,
    Plus<
        U16,
        U8
    >
>   // the document card
public typealias VerdictCardTall = Plus<U64, U16>
public typealias CatalogCardTall = Plus<
    U64,
    Plus<
        U32,
        Plus<
            U8,
            Plus<
                U4,
                U2
            >
        >
    >
>
public typealias DocumentCardTall = Plus<U32, Plus<U16, U2>>
public typealias WideMargin = U32
public typealias AvatarSide = Plus<U64, U32>
public typealias PersonChipWide = Plus<
    U128,
    Plus<
        U32,
        Plus<
            U8,
            Plus<
                U4,
                Plus<
                    U2,
                    U1
                >
            >
        >
    >
>   // the identity chip
public typealias ChipTripletWide = Plus<
    Times<Plus<U2, U1>, PersonChipWide>,
    Times<U2, HairBreath>
>   // three chips and their two breaths
public typealias AccessWide = Plus<
    U128,
    Plus<
        U64,
        Plus<
            U32,
            Plus<
                U16,
                Plus<
                    U8,
                    U4
                >
            >
        >
    >
>   // the access column
public typealias DotSlot = Plus<U8, U4>
public typealias ChipPad = Plus<U8, Plus<U4, U2>>
public typealias HeaderTall = Plus<AvatarSide, Twice<S24Breath>>
public typealias WideSurface = Times<
    U64,
    Plus<
        U8,
        Plus<
            U4,
            Plus<
                U2,
                U1
            >
        >
    >
>   // sixty-four fifteens: the standard page-wide surface
public typealias RankChipWide = Plus<U128, Plus<U8, U4>>
public typealias VerdictChipWide = Plus<U64, Plus<U16, Plus<U8, U2>>>
public typealias VerdictChipTall = Plus<U16, Plus<U4, U2>>
public typealias BadgeChipWide = Plus<U16, Plus<U8, Plus<U4, U2>>>
public typealias StatusChipWide = Plus<U64, Plus<U16, Plus<U8, U4>>>
// `ChipInset` shares `DotSlot`'s rung by decision: a chip's inner margin and the slot a
// status dot takes are different promises that happen to measure alike today.
public typealias ChipInset = Plus<U8, U4>
public typealias DeadPanelWide = Plus<U256, Plus<U16, Plus<U8, Plus<U4, U1>>>>
public typealias PanelInset = Plus<U16, U4>
public typealias DeadInset = PanelInset
public typealias RtoSurface = Times<
    U16,
    Plus<
        U32,
        Plus<
            U8,
            Plus<
                U4,
                U1
            >
        >
    >
>   // sixteen forty-fives: the arrangements strip
public typealias BoardTall = Times<U8, Plus<U32, Plus<U16, Plus<U8, Plus<U4, U1>>>>>
public typealias GateTall = Times<U8, Plus<U32, Plus<U2, U1>>>
public typealias ArchCaptionWide = Plus<U256, Plus<U16, Plus<U8, Plus<U2, U1>>>>
// ── The gate's vertical fascia: the row's drop, the box, the fall to dead, and the reset
// swing — every horizontal line of the diagram, named once, so the pen's stopping
// conditions and the boxes' faces read the same rungs. `GateArrowDrop` states half the box
// (the medium has no division of a rung). `GateFallTall` is the one free height the fall
// takes. ──
// ── The architecture's row rungs: the bar, the box, the gap an arrow falls through, the
// nose it stops short by, and the footer line. The drops are sums the canvas composes. ──
// The build-flow band: four zones across the inner width, three gutters between, every
// width a quarter of what remains — and the zone's own storeys, summed like the boxes'.
// ── the saturation curve's rungs (curve.svg): group and bar slots, legend slots,
// and the summed frame — the chart's one surface, spoken here so the demo names
// magnitudes and never spells units. ──
public typealias CurveBarThick = Plus<U16, U8>
public typealias CurveNameColumn = Plus<U64, U32>
public typealias CurveLegendTextWide = Plus<U128, Plus<U32, U16>>
public typealias CurveBuildWide3200 = Plus<U64, Plus<U32, Plus<U4, U2>>>       // 34 s × 3
public typealias CurveBuildWide6400 = Plus<U128, Plus<U64, Plus<U32, Plus<U16, Plus<U4, U2>>>>>   // 82 s × 3
public typealias CurveBuildWide12800 = Plus<U512, Plus<U64, Plus<U16, Plus<U4, U1>>>>             // 199 s × 3
public typealias LegendChipWide = Plus<U16, U2>
public typealias LegendTextWide = Plus<U64, Plus<U32, Plus<U16, U8>>>
public typealias LegendWideTextWide = Plus<U64, Plus<U64, Plus<U32, Plus<U16, Plus<U8, Plus<U4, U2>>>>>>
public typealias CurveWholeTall = Plus<U64, Plus<U64, Plus<U64, Plus<U64, Plus<U64, Plus<U4, U2>>>>>>
// 150: the walk film's strip height, a count the canvas reads.
public typealias FilmStripTall = Plus<U128, Plus<U16, Plus<U4, U2>>>

public typealias FlowZoneGaps = Plus<Gutter, Twice<Gutter>>
public typealias FlowZoneWide = Half<Half<Rest<Rest<WideSurface, Twice<EdgeMargin>>, FlowZoneGaps>>>
public typealias FlowZoneTitleStorey = Plus<U16, Plus<U8, U4>>
public typealias FlowCardNameStorey = Plus<U16, U4>
public typealias FlowCardRoleStorey = Plus<U16, Plus<U8, U4>>
public typealias FlowCardTall = Plus<FlowCardNameStorey, FlowCardRoleStorey>
public typealias FlowCardGap = Plus<U8, U4>
public typealias FlowCardPitch = Plus<FlowCardTall, FlowCardGap>
public typealias FlowZoneTall = Plus<
    FlowZoneTitleStorey,
    Plus<Times<U4, FlowCardPitch>, Plus<U4, HairBreath>>
>

// The architecture box's three storeys, summed into its tall: the title's, the component
// plaques', the census line's. The height follows the stack, not an eyeballed slab.
public typealias ArchTitleStorey = Plus<U32, U8>
public typealias ArchRoleStorey = U32
public typealias ArchPlaqueStorey = Plus<VerdictChipTall, U16>
public typealias ArchStatsStorey = Plus<U16, Plus<U8, U4>>
public typealias ArchStackTall = Plus<
    ArchTitleStorey,
    Plus<ArchRoleStorey, Plus<ArchPlaqueStorey, ArchStatsStorey>>
>
public typealias ArchGapTall = Plus<U32, U16>
public typealias ArchNose = Plus<U8, U2>
public typealias ArchFooterTall = Plus<U16, U4>

public typealias ArchDotDip = Plus<U8, Plus<U4, U2>>
public typealias ArchOutputTall = U64
public typealias GateRowDrop = Plus<U16, U4>
public typealias GateBoxTall = Plus<U32, Plus<U16, Plus<U8, U4>>>
public typealias GateBoxBottom = Plus<GateRowDrop, GateBoxTall>
public typealias GateFallTall = Plus<U64, Plus<U16, Plus<U8, U2>>>
public typealias GateDeadDrop = Plus<GateBoxBottom, GateFallTall>
public typealias GateDeadBottom = Plus<GateDeadDrop, GateBoxTall>
public typealias GateResetSwing = Plus<U16, U4>
public typealias GateResetTurn = Plus<GateDeadBottom, GateResetSwing>
public typealias GateArrowDrop = Plus<U16, Plus<U8, Plus<U4, U2>>>
public typealias GateBoxWide = Plus<U128, U2>
public typealias GateHalfBox = Half<GateBoxWide>
public typealias GateStep = Plus<U32, Plus<U8, Plus<U4, U1>>>
public typealias GateBreath = Plus<U64, Plus<U16, Plus<U8, U2>>>
public typealias GateSurface = Times<
    U2,
    Plus<
        U256,
        Plus<
            U128,
            Plus<
                U64,
                Plus<
                    U16,
                    U1
                >
            >
        >
    >
>   // the gate graph's whole width
public typealias CycleSlotWide = Times<
    U16,
    Plus<
        U8,
        Plus<
            U4,
            Plus<
                U2,
                U1
            >
        >
    >
>   // a quarter of the timeline
public typealias TimelineInset = Plus<U32, U8>
public typealias CycleAffordanceInset = Plus<U128, U2>
public typealias CyclePanelDropSecond = Plus<U128, Plus<U32, Plus<U16, U4>>>
public typealias CyclePanelDropThird = Plus<U256, Plus<U128, Plus<U32, U4>>>
public typealias CyclePanelInsetLast = Plus<U512, Plus<U64, U16>>
public typealias RevealPanelWide = Plus<
    U256,
    Plus<
        U64,
        Plus<
            U32,
            U8
        >
    >
>   // the hover panel
public typealias CyclesZoneTall = Plus<U128, Plus<U32, Plus<U8, U2>>>
public typealias TaskCardTall = Plus<U64, Plus<U16, Plus<U8, U2>>>
public typealias BoardHeaderZone = Plus<U32, U8>
public typealias BoardSlotPitch = Plus<TaskCardTall, Breath>
public typealias BoardEdge = Plus<U8, U4>
public typealias BoardMatrixTall = Plus<
    BoardHeaderZone,
    Plus<
        Times<Plus<U4, Plus<U2, U1>>, TaskCardTall>,
        Times<Plus<U4, U2>, Breath>
    >
>
public typealias BoardColumnTall = Plus<
    BoardHeaderZone,
    Plus<
        Times<U4, TaskCardTall>,
        Times<Plus<U2, U1>, Breath>
    >
>
public typealias KeypadSide = Times<
    U4,
    Plus<
        U64,
        Plus<
            U8,
            Plus<
                U2,
                U1
            >
        >
    >
>   // four seventy-fives: the keypad's side
public typealias HubCardWide = Times<U64, Plus<U4, U1>>
public typealias HubCardTall = Times<U4, Plus<U32, Plus<U8, Plus<U4, U1>>>>
public typealias AvatarCanvasSide = Times<U8, Plus<U16, Plus<U8, U1>>>
public typealias KeyPitch = Plus<U8, Plus<U4, Plus<U2, U1>>>
public typealias KeySide = Plus<U64, U16>
public typealias VaultZoneTall = Times<
    U4,
    Plus<
        U64,
        Plus<
            U32,
            Plus<
                U8,
                U1
            >
        >
    >
>   // the sign-in zone under a named header

// ── Track metrics: THE standard track. One height, one baseline, for every 32-tall bar,
// chip, and split the medium draws. Three canvases once carried three names for this one
// fact. The bar itself is span-drawn, and the design system keeps the vertical word. ──

public typealias TrackHeight = U32
// The CENTRED class of baselines derives now: `CenteredBaseline` (Vector.swift) reads the
// zone's middle plus half the font's own capital height (GeneratedFontMetrics), and this
// rung is its first conversion — the derived value reproduces the old stated "21" to the
// pixel. STACKED baselines (a title over a subtitle) remain stated per canvas: they are
// design choices, not centrings, and the hole they keep open is named in place.
public typealias TrackBaseline = CenteredBaseline<TrackHeight, TextS>

public enum N0: Close {}
extension N0 {
    public static var typeName: String { "0" }
}

/// This is a rect with its fill AND stroke: the one segment (`SplitBar`'s tinted third) that
/// needs a border to read against a near-transparent fill (§S8: built for the one place it is
/// needed, not a general two-attribute rect).
public protocol GlyphRectFillStroke: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
    associatedtype Stroke: Structure
}
extension GlyphRectFillStroke {
    public static var typeName: String {
        "<rect x=\"\(X.typeName)\" y=\"\(Y.typeName)\" width=\"\(W.typeName)\" height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\" "
            + "fill=\"\(Fill.typeName)\" stroke=\"\(Stroke.typeName)\" stroke-width=\"1\"/>\n"
    }
}

// ── The space ladder — the design system's rungs. Every magnitude in the medium composes
//    from these by name, and a canvas states proportions, and the seed (`SpaceSeed`) is the one
//    number that turns a count into pixels. The numerals themselves are the lattice's
//    (Primitive.swift): one ladder, spelled once, read by every target. ──
