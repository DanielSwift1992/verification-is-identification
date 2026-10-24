import Notation

/// Supplies a world's faces, caption paint and shadow at the reading edge. Requires each canvas to name its binding for type checking.
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

/// Declares the shadow filter under the shared filter identifier.
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
/// Wraps Content with the soft-shadow filter reference.
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
/// Wraps Content with the surface-card shadow filter reference.
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

public protocol LegibleOnInk: Paint {} // law:allow: owner-declared contrast category

/// This is a foreground legible against the `SurfaceCard` role.
public protocol ReadableOnSurfaceCard: Paint {} // law:allow: owner-declared contrast category
public protocol LegibleOnSurfaceCard: ReadableOnSurfaceCard {} // law:allow: owner-declared contrast category

/// This is a foreground legible against the `SurfaceTrack` role.
public protocol ReadableOnSurfaceTrack: Paint {} // law:allow: owner-declared contrast category
public protocol LegibleOnSurfaceTrack: ReadableOnSurfaceTrack {}   // law:allow — a palette gate: its content is which foregrounds conform; the reading site (a Gated wrapper) comes and goes with canvases, the category stays

/// This is a foreground legible against the `AccentRole` role.
public protocol LegibleOnAccentRole: Paint {}   // law:allow — same palette-gate class as its SurfaceTrack sibling

/// Marks a foreground granted for the NavyTint background by its owner.
public protocol ReadableOnNavyTint: Paint {} // law:allow: owner-declared contrast category
public protocol LegibleOnNavyTint: ReadableOnNavyTint {} // law:allow: owner-declared contrast category

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

public enum N0: Close {}
extension N0 {
    public static var typeName: String { "0" }
}

/// Draws a rectangle with its supplied fill, stroke and geometry.
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

public enum Bad: PaintRole, Close {}
extension Bad {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

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

public enum KnownName: PaintRole, Close {}
extension KnownName {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

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

public enum Paper: PaintRole, Close {}
extension Paper {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum SoftShadowName: Close {}
extension SoftShadowName {
    public static var typeName: String { "soft-shadow" }
}

public enum StatusMark: PaintRole, Close {}
extension StatusMark {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

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

public enum TextPrimary: PaintRole, Close {}
extension TextPrimary {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

public enum TextSecondary: PaintRole, Close {}
extension TextSecondary {
    public static var typeName: String { PaintSlot<Self>.typeName }
}

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
