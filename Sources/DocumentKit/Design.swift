import Notation

/// Supplies a world's faces, caption paint and shadow at the reading edge.
/// Requires each canvas to name its binding for type checking.
public protocol DrawingStyle: Structure, StyleKeys {
    associatedtype PaintFallbacks: Structure
    associatedtype BodyFace: Structure
    associatedtype CaptionFace: Structure
    associatedtype Accent: Paint
    associatedtype AccentRole: Paint
    associatedtype Action: Paint
    associatedtype ActionRole: Paint
    associatedtype ActionTint: Paint
    associatedtype ActionTintRole: Paint
    associatedtype Bad: Paint
    associatedtype Ink: Paint
    associatedtype InkPrimary: Paint
    associatedtype InkSecondary: Paint
    associatedtype KnownName: Paint
    associatedtype Line: Paint
    associatedtype LineRole: Paint
    associatedtype LocalType: Paint
    associatedtype Mist: Paint
    associatedtype Muted: Paint
    associatedtype NavyTint: Paint
    associatedtype Ok: Paint
    associatedtype OnAccent: Paint
    associatedtype OnActionRole: Paint
    associatedtype Paper: Paint
    associatedtype StatusMark: Paint
    associatedtype SurfaceCard: Paint
    associatedtype SurfacePage: Paint
    associatedtype SurfaceTrack: Paint
    associatedtype TextPrimary: Paint
    associatedtype TextSecondary: Paint
    associatedtype ShadowPaint: Paint
    associatedtype ShadowOpacity: Structure
    associatedtype LeafCountBases: Structure
}

/// Requires the reader to select a world's style when compiling its composition.
public protocol StyleBound {
    associatedtype Binding: DrawingStyle
}

/// Serializes the owner's portable paint before its exact CSS spelling.
public enum DeliveredSVG<Binding: DrawingStyle, Markup: Structure>: Close {}
extension DeliveredSVG {
    public static var typeName: String {
        var fallbacks: [String: String] = [:]
        for row in Binding.PaintFallbacks.typeName.split(separator: "\n") {
            let fields = row.split(separator: "|", maxSplits: 1, omittingEmptySubsequences: false)
            precondition(fields.count == 2, "\(Binding.self)#paints: invalid fallback row")
            fallbacks[String(fields[0])] = String(fields[1])
        }
        let paints: [String: String] = [
            "Accent": Binding.Accent.typeName,
            "AccentRole": Binding.AccentRole.typeName,
            "Action": Binding.Action.typeName,
            "ActionRole": Binding.ActionRole.typeName,
            "ActionTint": Binding.ActionTint.typeName,
            "ActionTintRole": Binding.ActionTintRole.typeName,
            "Bad": Binding.Bad.typeName,
            "Ink": Binding.Ink.typeName,
            "InkPrimary": Binding.InkPrimary.typeName,
            "InkSecondary": Binding.InkSecondary.typeName,
            "KnownName": Binding.KnownName.typeName,
            "Line": Binding.Line.typeName,
            "LineRole": Binding.LineRole.typeName,
            "LocalType": Binding.LocalType.typeName,
            "Mist": Binding.Mist.typeName,
            "Muted": Binding.Muted.typeName,
            "NavyTint": Binding.NavyTint.typeName,
            "Ok": Binding.Ok.typeName,
            "OnAccent": Binding.OnAccent.typeName,
            "OnActionRole": Binding.OnActionRole.typeName,
            "Paper": Binding.Paper.typeName,
            "StatusMark": Binding.StatusMark.typeName,
            "SurfaceCard": Binding.SurfaceCard.typeName,
            "SurfacePage": Binding.SurfacePage.typeName,
            "SurfaceTrack": Binding.SurfaceTrack.typeName,
            "TextPrimary": Binding.TextPrimary.typeName,
            "TextSecondary": Binding.TextSecondary.typeName,
        ]
        return Markup.typeName.split(separator: ">", omittingEmptySubsequences: false).map { piece -> String in
            var fields = piece.split(separator: "\"", omittingEmptySubsequences: false).map(String.init)
            var declarations = ""
            var styleIndex: Int?
            for index in fields.indices.filter({ $0 % 2 == 1 }) {
                let prefix = fields[index - 1]
                if prefix.hasSuffix("style=") { styleIndex = index }
                for property in ["fill", "stroke", "flood-color", "data-background"].filter({ prefix.hasSuffix($0 + "=") }) {
                    var paint = fields[index]
                    if paint.hasPrefix("var(--vi-role-"), paint.hasSuffix(")") {
                        let role = String(paint.dropFirst("var(--vi-role-".count).dropLast())
                        guard let reading = paints[role] else {
                            preconditionFailure("SVG paint reference is outside the declared role vocabulary: \(role)")
                        }
                        paint = reading
                        fields[index] = reading
                    }
                    if property != "data-background", let fallback = fallbacks[paint], fallback != paint {
                        fields[index] = fallback
                        declarations += property + ":" + fallback + ";" + property + ":" + paint + ";"
                    }
                }
            }
            if declarations.isEmpty { return fields.joined(separator: "\"") }
            if let index = styleIndex {
                fields[index] = declarations + fields[index]
                return fields.joined(separator: "\"")
            }
            let tag = fields.joined(separator: "\"")
            if tag.hasSuffix("/") { return String(tag.dropLast()) + " style=\"" + declarations + "\"/" }
            return tag + " style=\"" + declarations + "\""
        }.joined(separator: ">")
    }
}

/// Marks a paint supplied by a world.
public protocol Paint: Structure {}

/// Names a CSS paint slot whose value is supplied by the world's binding.
protocol PaintRole: Paint {} // law:allow: closed SDK slot vocabulary; owners supply Paint values
private enum PaintSlot<Role: PaintRole>: Close {}
extension PaintSlot {
    static var typeName: String { "var(--vi-role-" + String(describing: Role.self) + ")" }
}

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
/// `SurfaceCardShadow`'s name, held to the same rule.
public enum ShadowEnvelope<Binding: DrawingStyle>: Close {}
extension ShadowEnvelope {
    public static var typeName: String {
        "x=\"" + XMLEscaped<Binding.ShadowX>.typeName + "\" y=\"" + XMLEscaped<Binding.ShadowY>.typeName
            + "\" width=\"" + XMLEscaped<Binding.ShadowWidth>.typeName + "\" height=\"" + XMLEscaped<Binding.ShadowHeight>.typeName + "\""
    }
}
public enum ShadowCast<Binding: DrawingStyle>: Close {}
extension ShadowCast {
    public static var typeName: String {
        "dx=\"" + XMLEscaped<Binding.ShadowDx>.typeName + "\" dy=\"" + XMLEscaped<Binding.ShadowDy>.typeName
            + "\" stdDeviation=\"" + XMLEscaped<Binding.ShadowDeviation>.typeName + "\" flood-color=\"" + XMLEscaped<Binding.ShadowPaint>.typeName + "\""
    }
}
/// Reads the shadow paint and opacity from the canvas binding.
public enum SoftShadow<Binding: DrawingStyle>: Close {}
extension SoftShadow {
    public static var typeName: String {
        "<filter id=\"" + SoftShadowName.typeName + "\" " + ShadowEnvelope<Binding>.typeName + ">\n"
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
        "<filter id=\"" + SurfaceCardShadowName.typeName + "\" " + ShadowEnvelope<Binding>.typeName + ">\n"
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

public enum ArrowHeadName: Close {}
extension ArrowHeadName {
    public static var typeName: String { "a" }
}

// A world grants these categories to its paints after checking its own pairs.
// The wrappers require the grant; the mechanism grants no concrete colour.

public protocol LegibleOnInk: Paint {} // law:allow: owner-declared contrast category

/// This is a foreground legible against the `SurfaceCard` role.
public protocol ReadableOnSurfaceCard: Paint {} // law:allow: owner-declared contrast category
public protocol LegibleOnSurfaceCard: ReadableOnSurfaceCard {} // law:allow: owner-declared contrast category

/// This is a foreground legible against the `SurfaceTrack` role.
public protocol ReadableOnSurfaceTrack: Paint {} // law:allow: owner-declared contrast category
public protocol LegibleOnSurfaceTrack: ReadableOnSurfaceTrack {}   // law:allow — a palette gate: its content is which foregrounds conform; the reading site (a Gated wrapper) comes and goes with canvases, the category stays

/// This is a foreground legible against the `AccentRole` role.
public protocol LegibleOnAccentRole: Paint {}   // law:allow — same palette-gate class as its SurfaceTrack sibling

/// This marks a foreground legible against a `NavyTint` background, unused (see above), kept as-is.
public protocol ReadableOnNavyTint: Paint {} // law:allow: owner-declared contrast category
public protocol LegibleOnNavyTint: ReadableOnNavyTint {} // law:allow: owner-declared contrast category

// Span labels carry an explicit fill, while these wrappers also require a pairing grant.

public protocol GatedBoldTextOnInk: Open, StyleBound {
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
            + "fill=\"\(Fg.typeName)\" font-weight=\"\(XMLEscaped<Binding.BoldWeight>.typeName)\" font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
    }
}
public protocol GatedTextOnNavyTint: Open {
    associatedtype Fg: ReadableOnNavyTint
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
    associatedtype Fg: ReadableOnSurfaceCard
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

// Style names are declared below. The owner supplies their values and equations.

public enum N0: Close {}
extension N0 {
    public static var typeName: String { "0" }
}

/// This is a rect with its fill AND stroke: the one segment (`SplitBar`'s tinted third) that
/// needs a border to read against a near-transparent fill (§S8: built for the one place it is
/// needed, not a general two-attribute rect).
public protocol GlyphRectFillStroke: Open, StyleBound {
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
            + "fill=\"\(Fill.typeName)\" stroke=\"\(Stroke.typeName)\" stroke-width=\"\(XMLEscaped<Binding.HairlineWidth>.typeName)\"/>\n"
    }
}

public enum Accent: PaintRole, Close {}
extension Accent {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum AccentRole: PaintRole, Close {}
extension AccentRole {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol AccessWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum Action: PaintRole, Close {}
extension Action {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum ActionRole: PaintRole, Close {}
extension ActionRole {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum ActionTint: PaintRole, Close {}
extension ActionTint {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum ActionTintRole: PaintRole, Close {}
extension ActionTintRole {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol ArchCaptionWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchDotDip: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchFooterTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchGapTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchNose: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchOutputTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchPlaqueStorey: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchRoleStorey: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchStackTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchStatsStorey: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArchTitleStorey: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ArrowWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol AvatarCanvasSide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol AvatarSide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum Bad: PaintRole, Close {}
extension Bad {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol BadgeChipWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BoardColumnTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BoardEdge: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BoardHeaderZone: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BoardMatrixTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BoardSlotPitch: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BoardTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BoldWeight: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol Breath: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BreatheDuration: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol BreatheValues: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CardWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CatalogCardTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CenteredBaseline: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ChipInset: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ChipPad: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ChipTripletWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CurveBarThick: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CurveBuildWide12800: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CurveBuildWide3200: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CurveBuildWide6400: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CurveLegendTextWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CurveNameColumn: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CurveWholeTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CycleAffordanceInset: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CyclePanelDropSecond: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CyclePanelDropThird: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CyclePanelInsetLast: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CycleSlotWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol CyclesZoneTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol DeadInset: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol DeadPanelWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol DependencyDash: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol Display: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol DisplayS: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol DocumentCardTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol DocumentCardWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol DotSlot: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol EdgeMargin: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FigureArrowBox: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FigureArrowHeight: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FigureArrowPath: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FigureArrowOrient: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FigureArrowWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FigureArrowX: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FigureArrowY: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FilmStripTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowCardGap: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowCardNameStorey: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowCardPitch: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowCardRoleStorey: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowCardTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowZoneGaps: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowZoneTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowZoneTitleStorey: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FlowZoneWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FontAdvanceTable: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FontCapHeight: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FontStack: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol FontUnitsPerEm: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateArrowDrop: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateBoxBottom: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateBoxTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateBoxWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateBreath: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateDeadBottom: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateDeadDrop: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateFallTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateHalfBox: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateResetSwing: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateResetTurn: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateRowDrop: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateStep: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateSurface: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GateTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol GlyphStrokeWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol Gutter: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HairBreath: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HairlineWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HeaderTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HoverAffordanceRadius: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HoverFadeDelay: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HoverGrace: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HoverLift: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HoverStrokeWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HoverTransition: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HubCardTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HubCardWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum Ink: PaintRole, Close {}
extension Ink {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum InkPrimary: PaintRole, Close {}
extension InkPrimary {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum InkSecondary: PaintRole, Close {}
extension InkSecondary {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol KeyPitch: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol KeySide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol KeypadSide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum KnownName: PaintRole, Close {}
extension KnownName {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol KpiCardHeight: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol KpiTitleY: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol KpiValueY: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol LegendChipWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol LegendTextWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol LegendWideTextWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum Line: PaintRole, Close {}
extension Line {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum LineRole: PaintRole, Close {}
extension LineRole {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum LocalType: PaintRole, Close {}
extension LocalType {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol MarkerHeight: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol MarkerPath: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol MarkerOrient: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol MarkerWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol MarkerX: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol MarkerY: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum Mist: PaintRole, Close {}
extension Mist {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum Muted: PaintRole, Close {}
extension Muted {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum NavyTint: PaintRole, Close {}
extension NavyTint {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum Ok: PaintRole, Close {}
extension Ok {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum OnAccent: PaintRole, Close {}
extension OnAccent {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum OnActionRole: PaintRole, Close {}
extension OnActionRole {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol PanelInset: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol PanelWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum Paper: PaintRole, Close {}
extension Paper {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol PersonChipWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol QuadTrackBlock: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol R10: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol R12: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol R16: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol R20: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol R4: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol R6: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol RankChipWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol RevealPanelWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol RtoSurface: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol S16: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol S24: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol S24Breath: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol S32: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol S8: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShadowDeviation: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShadowDx: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShadowDy: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShadowHeight: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShadowWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShadowX: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShadowY: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ShapeRadius: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum SoftShadowName: Close {}
extension SoftShadowName {
    public static var typeName: String { "soft-shadow" }
}

public protocol StatusChipWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum StatusMark: PaintRole, Close {}
extension StatusMark {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol StripInset: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum SurfaceCard: PaintRole, Close {}
extension SurfaceCard {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum SurfaceCardShadowName: Close {}
extension SurfaceCardShadowName {
    public static var typeName: String { "surface-card-shadow" }
}

public enum SurfacePage: PaintRole, Close {}
extension SurfacePage {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum SurfaceTrack: PaintRole, Close {}
extension SurfaceTrack {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol TaskCardTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TextL: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TextM: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum TextPrimary: PaintRole, Close {}
extension TextPrimary {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol TextS: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public enum TextSecondary: PaintRole, Close {}
extension TextSecondary {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public protocol TextWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TextXS: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TextXXS: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol ThickGlyphWidth: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TimelineInset: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TitleT: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TrackBaseline: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol TrackHeight: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol VaultZoneTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol VerdictCardTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol VerdictChipTall: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol VerdictChipWide: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol WeightBold: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol WeightRegular: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol WideMargin: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol WideSurface: Structure {} // law:allow: owner-bound style name; the world supplies its reading

public protocol HoverStyle: Structure {} // law:allow: owner-bound interaction style name

/// Requires the owner's foreground, its ground and the equality used for that pair.
public protocol ReadablePaintPair {
    associatedtype WitnessName: Structure
    associatedtype Foreground: Paint
    associatedtype Background: Paint
    associatedtype Proof: Pair
    where Proof.Left: Structure, Proof.Right: Structure
}

/// Marks an owner pair checked by its stated Legible equality.
public protocol LegiblePaintPair: ReadablePaintPair {} // law:allow: named contrast category

/// Names the palette channels shared by the drawing readers.
public protocol DrawingPalette: DrawingStyle {
    associatedtype InkOnPaper: LegiblePaintPair
    where InkOnPaper.Foreground == Ink, InkOnPaper.Background == Paper
    associatedtype MutedOnPaper: ReadablePaintPair
    where MutedOnPaper.Foreground == Muted, MutedOnPaper.Background == Paper
    associatedtype OkOnPaper: LegiblePaintPair
    where OkOnPaper.Foreground == Ok, OkOnPaper.Background == Paper
    associatedtype BadOnPaper: LegiblePaintPair
    where BadOnPaper.Foreground == Bad, BadOnPaper.Background == Paper
    associatedtype KnownNameOnPaper: LegiblePaintPair
    where KnownNameOnPaper.Foreground == KnownName, KnownNameOnPaper.Background == Paper
    associatedtype LocalTypeOnPaper: LegiblePaintPair
    where LocalTypeOnPaper.Foreground == LocalType, LocalTypeOnPaper.Background == Paper
}

/// Requires every named style field before a world can supply a binding.
public protocol StyleKeys {
    associatedtype NoPaint: Structure
    associatedtype SquareRadius: Structure
    associatedtype HiddenOpacity: Structure
    associatedtype VisibleOpacity: Structure
    associatedtype ImmediateDuration: Structure
    associatedtype TableSortHintOpacity: Structure
    associatedtype TableSortActiveOpacity: Structure
    associatedtype TableSortHintSize: Structure
    associatedtype TableSortCursor: Structure
    associatedtype Cover06: Structure
    associatedtype Cover15: Structure
    associatedtype Cover16: Structure
    associatedtype Cover54: Structure
    associatedtype Cover70: Structure
    associatedtype Cover80: Structure
    associatedtype Cover90: Structure
    associatedtype FontFallbackAdvance: Structure
    associatedtype CaptionSlant: Structure
    associatedtype GlyphLineCap: Structure
    associatedtype GlyphLineJoin: Structure
    associatedtype HoverCursor: Structure
    associatedtype HoverEase: Structure
    associatedtype HoverVisibilityEase: Structure
    associatedtype ArrowWidth: Structure
    associatedtype BoldWeight: Structure
    associatedtype BreatheDuration: Structure
    associatedtype BreatheValues: Structure
    associatedtype DependencyDash: Structure
    associatedtype FigureArrowBox: Structure
    associatedtype FigureArrowHeight: Structure
    associatedtype FigureArrowPath: Structure
    associatedtype FigureArrowOrient: Structure
    associatedtype FigureArrowWidth: Structure
    associatedtype FigureArrowX: Structure
    associatedtype FigureArrowY: Structure
    associatedtype FontAdvanceTable: Structure
    associatedtype FontCapHeight: Structure
    associatedtype FontUnitsPerEm: Structure
    associatedtype GlyphStrokeWidth: Structure
    associatedtype HairlineWidth: Structure
    associatedtype HoverFadeDelay: Structure
    associatedtype HoverGrace: Structure
    associatedtype HoverLift: Structure
    associatedtype HoverStrokeWidth: Structure
    associatedtype HoverTransition: Structure
    associatedtype MarkerHeight: Structure
    associatedtype MarkerPath: Structure
    associatedtype MarkerOrient: Structure
    associatedtype MarkerWidth: Structure
    associatedtype MarkerX: Structure
    associatedtype MarkerY: Structure
    associatedtype ShadowDeviation: Structure
    associatedtype ShadowDx: Structure
    associatedtype ShadowDy: Structure
    associatedtype ShadowHeight: Structure
    associatedtype ShadowWidth: Structure
    associatedtype ShadowX: Structure
    associatedtype ShadowY: Structure
    associatedtype ShapeRadius: Structure
    associatedtype ThickGlyphWidth: Structure
}

public protocol TimedReveal: Structure {} // law:allow: owner-bound composition name
public protocol FrozenReveal: Structure {} // law:allow: owner-bound composition name
