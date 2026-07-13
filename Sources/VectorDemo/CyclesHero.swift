import VerificationIsIdentification
import DocumentKit
import Organization

// cycles-hero.svg: DESIGN11 c. A horizontal timeline, four year-nodes; hovering one reveals
// its batch (`Cut.Cohort.labels`, the SAME live read `View/CyclesPage.swift`'s
// `BatchLine<Cut>` already folds into its listed line, not a second list kept beside it). Each
// node is `Linked` to the year's committed cut (`SitePath<Cut2026>`, not
// `SitePath<CutPage<Cut2026>>`: `CutPage` is generic and merges onto `Cut2026`'s OWN symbol
// page at build time, `OrgDemo/main.swift`'s `write(CutPage<Cut2026>.typeName, "Cut2026")`;
// `PageSlug` reads a generic instantiation's full signature, not a friendly name, checked
// directly, the same landmine `WhatIfPage` hit, so the concrete cut type is the address).
//
// The x axis rides the span engine: nodes and panels are weighed slices of the surface, so
// an off-canvas X (the class of bug the space gate below was built against) is no longer
// even expressible sideways. The edge panels' clamping is now plain weights: the first
// panel's slice starts 8 from the left edge, the last ends 8 from the right, stated, visible.

enum CyclesHeroAriaLabel: Close {}
extension CyclesHeroAriaLabel {
    public static var typeName: String {
        "The review-cycle timeline, four years: hover a year to see its cohort, read live from "
            + "the committed cut."
    }
}

// ── the space gate (DESIGN11 prototype, DESIGN12 §3 cleanup — Vector.swift's `WithinBounds`)
// — this canvas's closed set of legal VERTICAL positions. The x axis is weights now, safe by
// construction; y still speaks in stated tokens until the height walk lands, and the gate
// keeps guarding exactly that axis: the panel's historical `Y = -90` (clipped above the
// viewBox) stays a compile error here, not a rendering surprise. ──
public protocol WithinCyclesHero: WithinBounds {}

/// `SpanLowered`'s stricter twin, scoped to THIS canvas: the drop must already be granted
/// `WithinCyclesHero`, not the shared floor, so a vertical only one canvas vetted cannot
/// satisfy a different canvas's layout by accident.
typealias CyclesLowered<
    Y: WithinCyclesHero,
    Content: Spanning
> = SpanLowered<Y, Content>

enum CycleLineY: Close {}
extension CycleLineY {
    public static var typeName: String { "44" }
}
enum CycleNodeR: Close {}
extension CycleNodeR {
    public static var typeName: String { "22" }
}
enum CycleYearY: Close {}
extension CycleYearY {
    public static var typeName: String { "50" }
}
enum CycleAffordanceCY: Close {}
extension CycleAffordanceCY {
    public static var typeName: String { "60" }
}

// ── the track: one rule across its slice, 40 in from either edge ──

enum CycleTrackRule: SpanRule {
    public typealias Y = CycleLineY
    public typealias Stroke = TextSecondary
}
enum CycleTrackRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<TimelineInset>.self
        Flexible<CycleTrackRule>.self
        Air<TimelineInset>.self
    }
}

// ── the year node in its slice: accent disc, year on its middle, affordance dot at the
// bottom-right corner (the same corner a notification dot reads on any avatar) ──

enum CycleNodeDisc: SpanDot {
    public typealias CY = CycleLineY
    public typealias R = CycleNodeR
    public typealias Fill = AccentRole
}
enum CycleYearSpan<T: Structure>: SpanLabelMid {
    public typealias Y = CycleYearY
    public typealias FillColor = OnAccent
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum CycleAffordanceDotSpan: SpanDot {
    public typealias CY = CycleAffordanceCY
    public typealias R = HoverAffordanceRadius
    public typealias Fill = ActionRole
}
enum CycleAffordanceSubRow: HFlow {
    public typealias Given = CycleSlotWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<CycleAffordanceInset>.self
        Fixed<DotSlot, CycleAffordanceDotSpan>.self
        RestAir.self
    }
}
typealias CycleNodeArt<Short: Structure> = Layered<
    CycleNodeDisc,
    Layered<CycleYearSpan<Short>, SpanHosted<CycleAffordanceSubRow>>
>
enum CutTriggerRow<
    Shift: Structure,
    Short: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<Shift>.self
        Fixed<CycleSlotWide, CycleNodeArt<Short>>.self
        RestAir.self
    }
}
typealias SlotShiftFirst = Never
typealias SlotShiftSecond = CycleSlotWide
typealias SlotShiftThird = Plus<CycleSlotWide, CycleSlotWide>
typealias SlotShiftFourth = Plus<CycleSlotWide, Plus<CycleSlotWide, CycleSlotWide>>

// ── the reveal panel: a card face in its slice, lowered through the gated drop, four
// baselines on an 18-unit rhythm under the box's top ──

enum CyclePanelY: Close {}
extension CyclePanelY {
    public static var typeName: String { "60" }
}
extension CyclePanelY: WithinCyclesHero {}
enum CyclePanelHeight: Close {}
extension CyclePanelHeight {
    public static var typeName: String { "80" }
}
enum CyclePanelLine1Y: Close {}
extension CyclePanelLine1Y {
    public static var typeName: String { "18" }
}
enum CyclePanelLine2Y: Close {}
extension CyclePanelLine2Y {
    public static var typeName: String { "36" }
}
enum CyclePanelLine3Y: Close {}
extension CyclePanelLine3Y {
    public static var typeName: String { "54" }
}
enum CyclePanelLine4Y: Close {}
extension CyclePanelLine4Y {
    public static var typeName: String { "72" }
}

enum CyclePanelFace: SpanCardFace {
    public typealias H = CyclePanelHeight
    public typealias Radius = R16
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum CyclePanelTitleSpan<T: Structure>: SpanLabel {
    public typealias Y = CyclePanelLine1Y
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = T
}
enum CyclePanelNamesSpan<T: Structure>: SpanLabel {
    public typealias Y = CyclePanelLine2Y
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum CyclePanelNames2Span<T: Structure>: SpanLabel {
    public typealias Y = CyclePanelLine3Y
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
// DESIGN14 §4: the panel's own discoverability, the whole panel already sits inside the node's
// outer `Linked` anchor (`Cut2026Node` and its three siblings, below), so clicking anywhere on
// it already navigates; nothing on the panel itself said so. `ActionRole` (the interactive
// voice, Design.swift's DNA) marks this line as the one that means "click," the same way
// the trigger's dot already does. Not a second `Linked`: nesting an `<a>` inside the one
// this panel already sits in would be invalid SVG; the click-through is already there.
enum CyclePanelOpenText: Close {}
extension CyclePanelOpenText {
    public static var typeName: String { "Open →" }
}
enum CyclePanelOpenSpan: SpanLabel {
    public typealias Y = CyclePanelLine4Y
    public typealias FillColor = ActionRole
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = CyclePanelOpenText
}
enum CutPanelInterior<
    Title: Structure,
    Names: Structure,
    Names2: Structure
>: HFlow {
    public typealias Given = CyclePanelWeight
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<
            Layered<
                CyclePanelTitleSpan<Title>,
                Layered<
                    CyclePanelNamesSpan<Names>,
                    Layered<CyclePanelNames2Span<Names2>, CyclePanelOpenSpan>
                >
            >
        >.self
        Air<EdgeMargin>.self
    }
}
typealias CyclePanelWeight = RevealPanelWide
enum CutPanelRow<
    Shift: Structure,
    Title: Structure,
    Names: Structure,
    Names2: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<Shift>.self
        Fixed<
            CyclePanelWeight,
            CyclesLowered<
                CyclePanelY,
                Layered<CyclePanelFace, SpanHosted<CutPanelInterior<Title, Names, Names2>>>
            >
        >.self
        RestAir.self
    }
}

// ── the four years: trigger and panel airs per node. The two edge panels shift inward to
// keep an 8 margin at either side of the surface, stated in their airs, not clipped. ──

typealias Cut2026PanelShift = PanelEdgeInset
typealias Cut2027PanelShift = CyclePanelDropSecond
typealias Cut2028PanelShift = CyclePanelDropThird
typealias Cut2029PanelShift = CyclePanelInsetLast
typealias PanelEdgeInset = HairBreath

enum Cut2026TitleText: Close {}
extension Cut2026TitleText {
    public static var typeName: String { "2026 — 10 people, 5% of the founding 200" }
}
enum Cut2026NamesText: Close {}
extension Cut2026NamesText {
    public static var typeName: String { Batch2026.labels.prefix(5).joined(separator: ", ") }
}
enum Cut2026Names2Text: Close {}
extension Cut2026Names2Text {
    public static var typeName: String { Batch2026.labels.suffix(5).joined(separator: ", ") }
}
enum Cut2026Short: Close {}
extension Cut2026Short {
    public static var typeName: String { "'26" }
}
enum Cut2026Reveal: HoverReveal {
    public typealias Trigger = CutTriggerRow<SlotShiftFirst, Cut2026Short>
    public typealias Panel = CutPanelRow<
        Cut2026PanelShift,
        Cut2026TitleText, Cut2026NamesText, Cut2026Names2Text
    >
}
enum Cut2026Node: Linked {
    public typealias Target = SitePath<Cut2026>
    public typealias Content = Cut2026Reveal
}

enum Cut2027TitleText: Close {}
extension Cut2027TitleText {
    public static var typeName: String { "2027 — 10 people, 5% of the founding 200" }
}
enum Cut2027NamesText: Close {}
extension Cut2027NamesText {
    public static var typeName: String { Batch2027.labels.prefix(5).joined(separator: ", ") }
}
enum Cut2027Names2Text: Close {}
extension Cut2027Names2Text {
    public static var typeName: String { Batch2027.labels.suffix(5).joined(separator: ", ") }
}
enum Cut2027Short: Close {}
extension Cut2027Short {
    public static var typeName: String { "'27" }
}
enum Cut2027Reveal: HoverReveal {
    public typealias Trigger = CutTriggerRow<SlotShiftSecond, Cut2027Short>
    public typealias Panel = CutPanelRow<
        Cut2027PanelShift,
        Cut2027TitleText, Cut2027NamesText, Cut2027Names2Text
    >
}
enum Cut2027Node: Linked {
    public typealias Target = SitePath<Cut2027>
    public typealias Content = Cut2027Reveal
}

enum Cut2028TitleText: Close {}
extension Cut2028TitleText {
    public static var typeName: String { "2028 — 10 people, 5% of the founding 200" }
}
enum Cut2028NamesText: Close {}
extension Cut2028NamesText {
    public static var typeName: String { Batch2028.labels.prefix(5).joined(separator: ", ") }
}
enum Cut2028Names2Text: Close {}
extension Cut2028Names2Text {
    public static var typeName: String { Batch2028.labels.suffix(5).joined(separator: ", ") }
}
enum Cut2028Short: Close {}
extension Cut2028Short {
    public static var typeName: String { "'28" }
}
enum Cut2028Reveal: HoverReveal {
    public typealias Trigger = CutTriggerRow<SlotShiftThird, Cut2028Short>
    public typealias Panel = CutPanelRow<
        Cut2028PanelShift,
        Cut2028TitleText, Cut2028NamesText, Cut2028Names2Text
    >
}
enum Cut2028Node: Linked {
    public typealias Target = SitePath<Cut2028>
    public typealias Content = Cut2028Reveal
}

enum Cut2029TitleText: Close {}
extension Cut2029TitleText {
    public static var typeName: String { "2029 — 10 people, 5% of the founding 200" }
}
enum Cut2029NamesText: Close {}
extension Cut2029NamesText {
    public static var typeName: String { Batch2029.labels.prefix(5).joined(separator: ", ") }
}
enum Cut2029Names2Text: Close {}
extension Cut2029Names2Text {
    public static var typeName: String { Batch2029.labels.suffix(5).joined(separator: ", ") }
}
enum Cut2029Short: Close {}
extension Cut2029Short {
    public static var typeName: String { "'29" }
}
enum Cut2029Reveal: HoverReveal {
    public typealias Trigger = CutTriggerRow<SlotShiftFourth, Cut2029Short>
    public typealias Panel = CutPanelRow<
        Cut2029PanelShift,
        Cut2029TitleText, Cut2029NamesText, Cut2029Names2Text
    >
}
enum Cut2029Node: Linked {
    public typealias Target = SitePath<Cut2029>
    public typealias Content = Cut2029Reveal
}

enum CyclesDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SurfaceCardShadow.self
        HoverRevealStyle.self
    }
}
enum CyclesZone: Group {
    @StructureBuilder
    public static var body: some Structure {
        CycleTrackRow.self
        Cut2026Node.self
        Cut2027Node.self
        Cut2028Node.self
        Cut2029Node.self
    }
}
enum CyclesHeroStrip: GrownDiagram, SelfShowing {
    public typealias Across = WideSurface
    public typealias AriaLabel = CyclesHeroAriaLabel
    public typealias Defs = CyclesDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Fixed<CyclesZoneTall, SpanHosted<CyclesZone>>.self
        Fixed<Never, SpanHosted<CyclesSelfShowingRow>>.self
        Air<S24Breath>.self
    }
}

func runCyclesHero() {
    write(CyclesHeroStrip.typeName, "cycles-hero")
    print("generated 1 cycles hero (Vector composition, live batch labels)")
}
