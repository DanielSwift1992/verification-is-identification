import Notation

/// Escapes the supplied text at the XML serialization edge.
public enum XMLEscaped<Content: Structure>: Close {}
extension XMLEscaped {
    public static var typeName: String {
        Content.typeName.unicodeScalars.map { character -> String in
            switch character {
            case "&": return "&amp;"
            case "<": return "&lt;"
            case ">": return "&gt;"
            case "\"": return "&quot;"
            case "'": return "&apos;"
            default: return String(character)
            }
        }.joined()
    }
}

/// Reads ticks divided by the supplied frequency as seconds.
public enum Seconds<Ticks: Structure, Frequency: Structure>: Close {}
extension Seconds {
    public static var typeName: String {
        precondition(Frequency.count > 0, "Seconds requires a positive frequency")
        return String(Double(Ticks.count) / Double(Frequency.count))
    }
}

/// Marks a canvas whose consumer supplies a source presentation.
public protocol SelfShowing {}

/// Composes drawing fragments through its body.
public protocol Group: Open {}

/// Reads the supplied width and height as the canvas frame.
public enum CanvasSize<W: Structure, H: Structure>: Close {}
extension CanvasSize {
    public static var typeName: String { "0 0 \(W.count) \(H.count)" }
}

public protocol Diagram: Open, StyleBound {
    associatedtype Size: Structure
    associatedtype AriaLabel: Structure
    associatedtype Content: Structure
}
extension Diagram {
    public static var typeName: String {
        DeliveredSVG<Binding, DiagramMarkup<Self>>.typeName
    }
}

public enum DiagramMarkup<Root: Diagram>: Close {}
extension DiagramMarkup {
    public static var typeName: String {
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"\(XMLEscaped<Root.Size>.typeName)\" role=\"img\" "
            + "data-vi-canvas=\"1\" "
            + "font-family=\"\(XMLEscaped<Root.Binding.BodyFace>.typeName)\" aria-label=\"\(XMLEscaped<Root.AriaLabel>.typeName)\">\n"
            + Root.Content.typeName + "\n</svg>\n"
    }
}

/// Positions a panel with the radius supplied by its binding.
public protocol Shape: Open, StyleBound {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Fill: Structure
}
extension Shape {
    public static var typeName: String {
        "<rect x=\"\(XMLEscaped<X>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" width=\"\(XMLEscaped<W>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" "
            + "rx=\"\(XMLEscaped<Binding.ShapeRadius>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
    }
}

/// Draws a rectangle at the local origin with the supplied width, height and fill.
public protocol FullBleedRect: Open {
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Fill: Structure
}
extension FullBleedRect {
    public static var typeName: String {
        "<rect width=\"\(XMLEscaped<W>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
    }
}

/// Draws a rectangle at the local origin with its supplied radius and paint.
public protocol RoundedFullBleedRect: Open {
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
}
extension RoundedFullBleedRect {
    public static var typeName: String {
        "<rect width=\"\(XMLEscaped<W>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Radius>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
    }
}

/// Positions the supplied content with the binding's caption face, slant and paint.
public protocol ItalicLabel: Open, StyleBound {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Anchor: Structure
    associatedtype Size: Structure
    associatedtype Content: Structure
}
extension ItalicLabel {
    public static var typeName: String {
        "<text x=\"\(XMLEscaped<X>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"\(XMLEscaped<Anchor>.typeName)\" "
            + "fill=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" font-size=\"\(XMLEscaped<Size>.typeName)\" font-family=\"\(XMLEscaped<Binding.CaptionFace>.typeName)\" font-style=\"\(XMLEscaped<Binding.CaptionSlant>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}

/// Exposes the endpoint of a composed path as two fractional coordinates.
public protocol Pen: Structure {
    associatedtype AtX: Frac & Structure
    associatedtype AtY: Structure
}

/// States the initial coordinates of a path.
public enum StartAt<
    X: Frac & Structure,
    Y: Structure
>: Close {}
extension StartAt: Pen {
    public typealias AtX = X
    public typealias AtY = Y
    public static var typeName: String {
        "M\(XMLEscaped<SpanPx<X>>.typeName),\(Y.count)"
    }
}

/// Extends a path vertically to the supplied ordinate.
public enum UntilY<
    Prev: Pen,
    Ordinate: Structure
>: Close {}
extension UntilY: Pen {
    public typealias AtX = Prev.AtX
    public typealias AtY = Ordinate
    public static var typeName: String {
        "\(XMLEscaped<Prev>.typeName) L\(XMLEscaped<SpanPx<Prev.AtX>>.typeName),\(Ordinate.count)"
    }
}

/// Extends a path horizontally to the supplied abscissa.
public enum UntilX<
    Prev: Pen,
    Abscissa: Frac & Structure
>: Close {}
extension UntilX: Pen {
    public typealias AtX = Abscissa
    public typealias AtY = Prev.AtY
    public static var typeName: String {
        "\(XMLEscaped<Prev>.typeName) L\(XMLEscaped<SpanPx<Abscissa>>.typeName),\(Prev.AtY.count)"
    }
}

/// Extends a path to the supplied pair of coordinates.
public enum SlideTo<
    Prev: Pen,
    X: Frac & Structure,
    Y: Structure
>: Close {}
extension SlideTo: Pen {
    public typealias AtX = X
    public typealias AtY = Y
    public static var typeName: String {
        "\(XMLEscaped<Prev>.typeName) L\(XMLEscaped<SpanPx<X>>.typeName),\(Y.count)"
    }
}

/// Positions a line below its supplied row by the stated baseline offset.
public enum Under<
    Line: Structure,
    Baseline: Structure
>: Close {}
extension Under {
    public static var typeName: String {
        String(Line.count + (Int(Baseline.typeName) ?? 0))
    }
}

/// Reads text width from the binding's advances and fallback at the stated size.
public enum BoundTextWidth<
    Binding: DrawingStyle,
    Content: Structure,
    TextSize: Structure
>: Close {}
extension BoundTextWidth {
    public static var count: Int {
        var advances: [Int: Int] = [:]
        for pair in Binding.FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(Binding.FontUnitsPerEm.typeName) ?? 0
        let size = Int(TextSize.typeName) ?? 0
        let fallback = Int(Binding.FontFallbackAdvance.typeName) ?? 0
        precondition(fallback > 0, "\(Binding.self)#layout/FontFallbackAdvance: invalid metric")
        let total = Content.typeName.unicodeScalars.reduce(0) { sum, scalar in
            sum + (advances[Int(scalar.value)] ?? fallback)
        }
        return (total * size + units - 1) / units
    }
}

/// Centers the supplied text and refuses a measured width larger than its slice at rendering.
public protocol SpanLabelMidFitted: Spanning, StyleBound {
    associatedtype Y: Structure
    associatedtype FillColor: Structure
    associatedtype Size: Structure
    associatedtype Weight: Structure
    associatedtype Content: Structure
}
extension SpanLabelMidFitted {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        let measured = BoundTextWidth<Binding, Content, Size>.count
        let given = (2 * W.Left.count + W.Right.count) / (2 * W.Right.count)
        precondition(
            measured <= given,
            "SpanLabelMidFitted overflow in \(Self.self): \"\(Content.typeName)\" measures \(measured)px, the slice hands \(given)px"
        )
        return "<text x=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"middle\" "
            + "fill=\"\(XMLEscaped<FillColor>.typeName)\" font-weight=\"\(XMLEscaped<Weight>.typeName)\" "
            + "font-size=\"\(XMLEscaped<Size>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}

/// Reads a centered baseline from the zone and the binding's capital-height metric.
public enum BoundCenteredBaseline<
    Binding: DrawingStyle,
    ZoneTall: Structure,
    TextSize: Structure
>: Close {}
extension BoundCenteredBaseline {
    public static var typeName: String {
        let units = Int(Binding.FontUnitsPerEm.typeName) ?? 0
        let cap = Int(Binding.FontCapHeight.typeName) ?? 0
        let size = Int(TextSize.typeName) ?? 0
        return String((ZoneTall.count * units + cap * size + units) / (2 * units))
    }
}

/// Centers measured lines within its slice and refuses an overwide word at rendering.
public protocol SpanLabelMidWrapped: Spanning, StyleBound {
    associatedtype Y: Structure
    associatedtype LinePitch: Structure
    associatedtype FillColor: Structure
    associatedtype Size: Structure
    associatedtype Weight: Structure
    associatedtype Content: Structure
}
extension SpanLabelMidWrapped {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        var advances: [Int: Int] = [:]
        for pair in Binding.FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(Binding.FontUnitsPerEm.typeName) ?? 0
        let size = Int(Size.typeName) ?? 0
        let fallback = Int(Binding.FontFallbackAdvance.typeName) ?? 0
        precondition(fallback > 0, "\(Binding.self)#layout/FontFallbackAdvance: invalid metric")
        let given = (2 * W.Left.count + W.Right.count) / (2 * W.Right.count)
        let measured: (Substring) -> Int = { text in
            let total = text.unicodeScalars.reduce(0) { sum, scalar in
                sum + (advances[Int(scalar.value)] ?? fallback)
            }
            return (total * size + units - 1) / units
        }
        var lines: [Substring] = []
        var line = Substring("")
        for word in Content.typeName.split(separator: " ") {
            precondition(
                measured(word) <= given,
                "SpanLabelMidWrapped overflow in \(Self.self): the word \"\(word)\" measures \(measured(word))px, the slice hands \(given)px"
            )
            let candidate = line.isEmpty ? word : Substring("\(line) \(word)")
            if measured(candidate) <= given {
                line = candidate
            } else {
                lines.append(line)
                line = word
            }
        }
        if !line.isEmpty { lines.append(line) }
        let base = Int(Y.typeName) ?? 0
        let pitch = Int(LinePitch.typeName) ?? 0
        return lines.enumerated().map { index, text in
            let escaped = text.unicodeScalars.map { character -> String in
                switch character {
                case "&": return "&amp;"
                case "<": return "&lt;"
                case ">": return "&gt;"
                case "\"": return "&quot;"
                case "'": return "&apos;"
                default: return String(character)
                }
            }.joined()
            return "<text x=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" y=\"\(base + pitch * index)\" text-anchor=\"middle\" "
                + "fill=\"\(XMLEscaped<FillColor>.typeName)\" font-weight=\"\(XMLEscaped<Weight>.typeName)\" "
                + "font-size=\"\(XMLEscaped<Size>.typeName)\">\(escaped)</text>\n"
        }.joined()
    }
}

/// Starts measured lines at the slice origin and refuses an overwide word at rendering.
public protocol SpanLabelWrapped: Spanning, StyleBound {
    associatedtype Y: Structure
    associatedtype LinePitch: Structure
    associatedtype FillColor: Structure
    associatedtype Size: Structure
    associatedtype Weight: Structure
    associatedtype Content: Structure
}
extension SpanLabelWrapped {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        var advances: [Int: Int] = [:]
        for pair in Binding.FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(Binding.FontUnitsPerEm.typeName) ?? 0
        let size = Int(Size.typeName) ?? 0
        let fallback = Int(Binding.FontFallbackAdvance.typeName) ?? 0
        precondition(fallback > 0, "\(Binding.self)#layout/FontFallbackAdvance: invalid metric")
        let given = (2 * W.Left.count + W.Right.count) / (2 * W.Right.count)
        let measured: (Substring) -> Int = { text in
            let total = text.unicodeScalars.reduce(0) { sum, scalar in
                sum + (advances[Int(scalar.value)] ?? fallback)
            }
            return (total * size + units - 1) / units
        }
        var lines: [Substring] = []
        var line = Substring("")
        for word in Content.typeName.split(separator: " ") {
            precondition(
                measured(word) <= given,
                "SpanLabelWrapped overflow in \(Self.self): the word \"\(word)\" measures \(measured(word))px, the slice hands \(given)px"
            )
            let candidate = line.isEmpty ? word : Substring("\(line) \(word)")
            if measured(candidate) <= given {
                line = candidate
            } else {
                lines.append(line)
                line = word
            }
        }
        if !line.isEmpty { lines.append(line) }
        let base = Int(Y.typeName) ?? 0
        let pitch = Int(LinePitch.typeName) ?? 0
        return lines.enumerated().map { index, text in
            let escaped = text.unicodeScalars.map { character -> String in
                switch character {
                case "&": return "&amp;"
                case "<": return "&lt;"
                case ">": return "&gt;"
                case "\"": return "&quot;"
                case "'": return "&apos;"
                default: return String(character)
                }
            }.joined()
            return "<text x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" y=\"\(base + pitch * index)\" text-anchor=\"start\" "
                + "fill=\"\(XMLEscaped<FillColor>.typeName)\" font-weight=\"\(XMLEscaped<Weight>.typeName)\" "
                + "font-size=\"\(XMLEscaped<Size>.typeName)\">\(escaped)</text>\n"
        }.joined()
    }
}

/// Counts lines using the supplied width and the binding's advances.
public enum BoundLineTally<
    Binding: DrawingStyle,
    Content: Structure,
    Wide: Structure,
    Size: Structure
>: Close {}
extension BoundLineTally {
    public static var typeName: String { String(count) }
    public static var count: Int {
        var advances: [Int: Int] = [:]
        for pair in Binding.FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(Binding.FontUnitsPerEm.typeName) ?? 0
        let size = Int(Size.typeName) ?? 0
        let fallback = Int(Binding.FontFallbackAdvance.typeName) ?? 0
        precondition(fallback > 0, "\(Binding.self)#layout/FontFallbackAdvance: invalid metric")
        let given = Wide.count
        let measured: (Substring) -> Int = { text in
            let total = text.unicodeScalars.reduce(0) { sum, scalar in
                sum + (advances[Int(scalar.value)] ?? fallback)
            }
            return (total * size + units - 1) / units
        }
        var total = 0
        var line = Substring("")
        for word in Content.typeName.split(separator: " ") {
            let candidate = line.isEmpty ? word : Substring("\(line) \(word)")
            if measured(candidate) <= given {
                line = candidate
            } else {
                total += 1
                line = word
            }
        }
        if !line.isEmpty { total += 1 }
        return total
    }
}

/// Reads the midpoint of the supplied coordinate magnitudes.
public enum Halfway<
    A: Structure,
    B: Structure
>: Close {}
extension Halfway {
    public static var typeName: String {
        String((A.count + B.count) / 2)
    }
}

/// Draws the supplied path with its binding's dashed stroke and arrow marker.
public protocol DashedArrow: Open, StyleBound {
    associatedtype Path: Structure
}
extension DashedArrow {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<Path>.typeName)\" stroke=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ArrowWidth>.typeName)\" stroke-dasharray=\"\(XMLEscaped<Binding.DependencyDash>.typeName)\" "
            + "fill=\"\(XMLEscaped<Binding.NoPaint>.typeName)\" marker-end=\"url(#\(XMLEscaped<ArrowHeadName>.typeName))\"/>\n"
    }
}

/// Translates the supplied content by its vertical offset.
public protocol Dropped: Open {
    associatedtype Y: Structure
    associatedtype Content: Structure
}
extension Dropped {
    public static var typeName: String {
        "<g transform=\"translate(0, \(XMLEscaped<Y>.typeName))\">\n" + Content.typeName + "</g>\n"
    }
}

/// Translates the supplied content to its coordinates and applies its uniform scale.
public protocol PlacedScaled: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Scale: Structure
    associatedtype Content: Structure
}
extension PlacedScaled {
    public static var typeName: String {
        "<g transform=\"translate(\(XMLEscaped<X>.typeName),\(XMLEscaped<Y>.typeName)) scale(\(XMLEscaped<Scale>.typeName))\">\n" + Content.typeName + "</g>\n"
    }
}

public protocol WithinBounds: Structure {}   // law:allow — common interface for an owner-declared placement relation

/// Wraps the supplied content in an SVG anchor with the supplied target.
public protocol Linked: Open {
    associatedtype Target: Structure
    associatedtype Content: Structure
}
extension Linked {
    public static var typeName: String {
        "<a href=\"\(XMLEscaped<Target>.typeName)\">\n" + Content.typeName + "</a>\n"
    }
}

/// Reads the binding's hover-transform rule for a canvas.
public enum BoundHoverStyle<Binding: DrawingStyle>: Close {}
extension BoundHoverStyle {
    public static var typeName: String {
        """
        <style>
        .hover-lift { transform: translate(var(--tx), var(--ty)); transition: transform \(XMLEscaped<Binding.HoverTransition>.typeName) \(XMLEscaped<Binding.HoverEase>.typeName); cursor: \(XMLEscaped<Binding.HoverCursor>.typeName); }
        .hover-lift:hover { transform: translate(var(--tx), calc(var(--ty) - \(XMLEscaped<Binding.HoverLift>.typeName))); }
        </style>

        """
    }
}

/// Groups a trigger and panel within one hover scope.
public protocol HoverReveal: Open {
    associatedtype Trigger: Structure
    associatedtype Panel: Structure
}
extension HoverReveal {
    public static var typeName: String {
        "<g class=\"hover-pair\">\n"
            + "<g class=\"hover-trigger\">\n" + Trigger.typeName + "</g>\n"
            + "<g class=\"hover-panel\">\n" + Panel.typeName + "</g>\n"
            + "</g>\n"
    }
}

/// Wraps content in the class selected by the shared hover rule.
public protocol HoverHighlight: Open {
    associatedtype Content: Structure
}
extension HoverHighlight {
    public static var typeName: String {
        "<g class=\"hover-highlight\">\n" + Content.typeName + "</g>\n"
    }
}
/// Reveals a panel while either half is hovered and uses the binding's transition intervals.
public enum HoverRevealStyle<Binding: DrawingStyle>: Close {}
extension HoverRevealStyle {
    public static var typeName: String {
        """
        <style>
        .hover-pair .hover-panel { opacity: \(XMLEscaped<Binding.HiddenOpacity>.typeName); visibility: hidden; transition: opacity \(XMLEscaped<Binding.HoverTransition>.typeName) \(XMLEscaped<Binding.HoverEase>.typeName) \(XMLEscaped<Binding.HoverFadeDelay>.typeName), visibility \(XMLEscaped<Binding.ImmediateDuration>.typeName) \(XMLEscaped<Binding.HoverVisibilityEase>.typeName) \(XMLEscaped<Binding.HoverGrace>.typeName); }
        .hover-pair .hover-trigger { cursor: \(XMLEscaped<Binding.HoverCursor>.typeName); }
        .hover-pair .hover-trigger:hover ~ .hover-panel, .hover-pair .hover-panel:hover { opacity: \(XMLEscaped<Binding.VisibleOpacity>.typeName); visibility: visible; transition-delay: \(XMLEscaped<Binding.ImmediateDuration>.typeName); }
        .hover-highlight { transition: stroke \(XMLEscaped<Binding.HoverTransition>.typeName) \(XMLEscaped<Binding.HoverEase>.typeName), stroke-width \(XMLEscaped<Binding.HoverTransition>.typeName) \(XMLEscaped<Binding.HoverEase>.typeName); cursor: \(XMLEscaped<Binding.HoverCursor>.typeName); }
        .hover-highlight:hover { stroke: \(XMLEscaped<Binding.AccentRole>.typeName); stroke-width: \(XMLEscaped<Binding.HoverStrokeWidth>.typeName); }
        </style>

        """
    }
}

/// Reads the supplied type's identifier in lowercase for the consumer's address composition.
public enum PageSlug<X>: Close {}
extension PageSlug {
    public static var typeName: String { String(describing: X.self).lowercased() }
}

/// Draws a rectangle whose paint is inherited from its enclosing group.
public protocol GlyphRect: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
}
extension GlyphRect {
    public static var typeName: String {
        "<rect x=\"\(XMLEscaped<X>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" width=\"\(XMLEscaped<W>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Radius>.typeName)\"/>\n"
    }
}

/// Draws a rectangle with a border and the supplied binding.
public protocol GlyphRectStroked: Open, StyleBound {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Stroke: Structure
}
extension GlyphRectStroked {
    public static var typeName: String {
        "<rect x=\"\(XMLEscaped<X>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" width=\"\(XMLEscaped<W>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Radius>.typeName)\" "
            + "fill=\"\(XMLEscaped<Binding.NoPaint>.typeName)\" stroke=\"\(XMLEscaped<Stroke>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.HairlineWidth>.typeName)\"/>\n"
    }
}

/// Draws a circle whose paint is inherited from its enclosing group.
public protocol GlyphCircle: Open {
    associatedtype CX: Structure
    associatedtype CY: Structure
    associatedtype R: Structure
}
extension GlyphCircle {
    public static var typeName: String {
        "<circle cx=\"\(XMLEscaped<CX>.typeName)\" cy=\"\(XMLEscaped<CY>.typeName)\" r=\"\(XMLEscaped<R>.typeName)\"/>\n"
    }
}

/// Draws the supplied path with inherited paint.
public protocol GlyphPath: Open {
    associatedtype D: Structure
}
extension GlyphPath {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<D>.typeName)\"/>\n"
    }
}

/// Draws the supplied path with the binding's thick stroke.
public protocol GlyphPathThick: Open, StyleBound {
    associatedtype D: Structure
}
extension GlyphPathThick {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<D>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ThickGlyphWidth>.typeName)\"/>\n"
    }
}

/// Draws a path with its own paint and the binding's stroke readings.
public protocol StandaloneStrokedPath: Open, StyleBound {
    associatedtype Stroke: Paint
    associatedtype D: Structure
}
extension StandaloneStrokedPath {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<D>.typeName)\" \(BoundGlyphStroke<Binding, Stroke>.typeName)/>\n"
    }
}

/// Supplies the stated fill to its composed content.
public protocol FilledGroup: Open {
    associatedtype Fill: Structure
    associatedtype Content: Structure
}
extension FilledGroup {
    public static var typeName: String {
        "<g fill=\"\(XMLEscaped<Fill>.typeName)\">\n" + Content.typeName + "</g>\n"
    }
}

/// Supplies a fill and CSS class to its composed content.
public protocol FilledGroupClassed: Open {
    associatedtype Class: Structure
    associatedtype Fill: Structure
    associatedtype Content: Structure
}
extension FilledGroupClassed {
    public static var typeName: String {
        "<g class=\"\(XMLEscaped<Class>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\">\n" + Content.typeName + "</g>\n"
    }
}

/// Supplies the selected paint and binding's stroke readings to its glyphs.
public protocol StrokedGroup: Open, StyleBound {
    associatedtype Stroke: Paint
    associatedtype Content: Structure
}
extension StrokedGroup {
    public static var typeName: String {
        "<g \(BoundGlyphStroke<Binding, Stroke>.typeName)>\n" + Content.typeName + "</g>\n"
    }
}

/// Reads stroke width, caps, joins and fill from the binding and selected paint.
public enum BoundGlyphStroke<
    Binding: DrawingStyle,
    C: Paint
>: Close {}
extension BoundGlyphStroke {
    public static var typeName: String {
        "stroke=\"\(XMLEscaped<C>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.GlyphStrokeWidth>.typeName)\" stroke-linecap=\"\(XMLEscaped<Binding.GlyphLineCap>.typeName)\" stroke-linejoin=\"\(XMLEscaped<Binding.GlyphLineJoin>.typeName)\" fill=\"\(XMLEscaped<Binding.NoPaint>.typeName)\""
    }
}

/// Declares the marker referenced by arrows in the same canvas.
public enum ArrowMarkers<Binding: DrawingStyle>: Close {}
extension ArrowMarkers {
    public static var typeName: String {
        """
        <defs>
        <marker id="\(XMLEscaped<ArrowHeadName>.typeName)" markerWidth="\(XMLEscaped<Binding.MarkerWidth>.typeName)" markerHeight="\(XMLEscaped<Binding.MarkerHeight>.typeName)" refX="\(XMLEscaped<Binding.MarkerX>.typeName)" refY="\(XMLEscaped<Binding.MarkerY>.typeName)" orient="\(XMLEscaped<Binding.MarkerOrient>.typeName)">
        <path d="\(XMLEscaped<Binding.MarkerPath>.typeName)" fill="\(XMLEscaped<Binding.TextSecondary>.typeName)"/>
        </marker>
        </defs>

        """
    }
}

/// Associates content with a supplied fragment identifier and the shared state class.
public protocol StateGroup: Open {
    associatedtype Id: Structure
    associatedtype Content: Structure
}
extension StateGroup {
    public static var typeName: String {
        "<g id=\"\(XMLEscaped<Id>.typeName)\" class=\"vi-state\">\n" + Content.typeName + "</g>\n"
    }
}

/// Shows the targeted group, or the supplied default when no state group is targeted.
public enum StateSwitchStyle<DefaultId: Structure>: Close {}
extension StateSwitchStyle {
    public static var typeName: String {
        """
        <style>
        .vi-state { display: none; }
        .vi-state:target { display: inline; }
        svg:not(:has(.vi-state:target)) #\(XMLEscaped<DefaultId>.typeName) { display: inline; }
        </style>

        """
    }
}

/// Serializes an owner's variant and initial visibility for the host reader.
public enum SpanVariant<
    Owner: Structure,
    Position: Structure,
    Content: Spanning,
    ShownAtRest: Structure
>: Close {}
extension SpanVariant: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g class=\"vi-variant\" data-vi-owner=\"\(XMLEscaped<Owner>.typeName)\" data-vi-at=\"\(XMLEscaped<Position>.typeName)\""
            + (ShownAtRest.typeName == "1" ? "" : " style=\"display:none\"")
            + ">\n" + Content.rendered(atX: x, width: w) + "</g>\n"
    }
}

/// Serializes a pressable term and its slot on a clickable face. The host judges rule selection.
public enum RuleKey<
    R: Pressable,
    Face: Spanning
>: Close {}
extension RuleKey: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        var names: [String] = []
        var pile: [Substring] = [Substring(String(describing: R.self))]
        while let term = pile.popLast() {
            let left = term.drop(while: { $0.isWhitespace })
            let text = Substring(left.reversed().drop(while: { $0.isWhitespace }).reversed())
            if text.hasPrefix("Exactly<"), text.hasSuffix(">") {
                let whole = text.dropFirst("Exactly<".count).dropLast()
                names.append(String(whole.filter { $0 != " " }))
                continue
            }
            guard text.hasPrefix("Chord<"), text.hasSuffix(">") else {
                names.append(String(text.split(separator: "<").first ?? ""))
                continue
            }
            let inner = text.dropFirst("Chord<".count).dropLast()
            var depth = 0
            var cut = inner.startIndex
            for (offset, character) in inner.enumerated() {
                if character == "<" { depth += 1 }
                if character == ">" { depth -= 1 }
                if character == ",", depth == 0 {
                    cut = inner.index(inner.startIndex, offsetBy: offset)
                    break
                }
            }
            if cut == inner.startIndex {
                names.append(String(inner.split(separator: "<").first ?? ""))
                continue
            }
            pile.append(inner[inner.index(after: cut)...])
            pile.append(inner[inner.startIndex..<cut])
        }
        let rules = names.joined(separator: " ").unicodeScalars.map { character -> String in
                switch character {
                case "&": return "&amp;"
                case "<": return "&lt;"
                case ">": return "&gt;"
                case "\"": return "&quot;"
                case "'": return "&apos;"
                default: return String(character)
                }
            }.joined()
        let slot = String(describing: R.Slot.self).unicodeScalars.map { character -> String in
                switch character {
                case "&": return "&amp;"
                case "<": return "&lt;"
                case ">": return "&gt;"
                case "\"": return "&quot;"
                case "'": return "&apos;"
                default: return String(character)
                }
            }.joined()
        return "<g class=\"vi-rule\" data-vi-rules=\"\(rules)\" data-vi-slot=\"\(slot)\" cursor=\"pointer\">\n"
            + Face.rendered(atX: x, width: w) + "</g>\n"
    }
}

/// Serializes the owner and variant requested by a clickable face.
public enum SpanVariantKey<
    Owner: Structure,
    Position: Structure,
    Face: Spanning
>: Close {}
extension SpanVariantKey: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g class=\"vi-variant-key\" data-vi-owner=\"\(XMLEscaped<Owner>.typeName)\" data-vi-to=\"\(XMLEscaped<Position>.typeName)\" cursor=\"pointer\">\n"
            + Face.rendered(atX: x, width: w) + "</g>\n"
    }
}

/// Prefixes the supplied identifier with the fragment delimiter.
public enum FragmentOf<X: Structure>: Close {}
extension FragmentOf {
    public static var typeName: String { "#" + X.typeName }
}

/// Relates a numerator and denominator through the two sides of a Pair.
public protocol Frac: Pair
where Left: Structure, Right: Structure {}
extension Paired: Frac
where L: Structure, R: Structure {}

/// Represents the supplied width over the unit denominator.
public typealias GivenSpan<Width: Structure> = Paired<
    Width,
    Unit
>
public typealias Sum<
    A: Frac,
    B: Frac
> = Paired<
    Plus<Times<A.Left, B.Right>, Times<B.Left, A.Right>>,
    Times<A.Right, B.Right>
>
public typealias MidOf<
    X: Frac,
    W: Frac
> = Paired<
    Plus<Times<Twice<X.Left>, W.Right>, Times<W.Left, X.Right>>,
    Times<Twice<X.Right>, W.Right>
>

/// Reads the fraction's counts as a rounded pixel coordinate.
public enum SpanPx<S: Frac>: Close {}
extension SpanPx {
    public static var typeName: String {
        String((2 * S.Left.count + S.Right.count) / (2 * S.Right.count))
    }
}

/// Reads content at the origin and width supplied by an enclosing divided axis.
public protocol Spanning {
    static func rendered<X: Frac & Structure, W: Frac & Structure>(
        atX x: X.Type,
        width w: W.Type
    ) -> String
}

/// States the axis origin as zero over one.
public typealias RowStart = Paired<
    Never,
    Unit
>

/// Declares a member's fixed extent and count of flexible shares.
public protocol Takes {
    associatedtype Taken: Structure
    associatedtype Stretch: Structure
}
public protocol Divides: Takes {
    static func rendered<
        X: Frac & Structure,
        Free: Frac & Structure
    >(
        atX x: X.Type,
        free f: Free.Type
    ) -> String
}

/// Multiplies a free share by the supplied count of flexible members.
public typealias Stretched<
    Free: Frac,
    By: Structure
> = Paired<
    Times<Free.Left, By>,
    Free.Right
>

/// Draws content within a slice of its supplied fixed extent.
public enum Fixed<
    W: Structure,
    Content: Spanning
>: Close {}
extension Fixed: Divides {
    public typealias Taken = W
    public typealias Stretch = Never
    public static func rendered<
        X: Frac & Structure,
        Free: Frac & Structure
    >(
        atX x: X.Type,
        free f: Free.Type
    ) -> String {
        "<g transform=\"translate(\(XMLEscaped<SpanPx<X>>.typeName), 0)\">\n"
            + Content.rendered(atX: RowStart.self, width: GivenSpan<W>.self)
            + "</g>\n"
    }
}

/// Receives the remaining share and draws empty content.
public enum RestAir: Close {}
extension RestAir: Divides {
    public typealias Taken = Never
    public typealias Stretch = Unit
    public static func rendered<
        X: Frac & Structure,
        Free: Frac & Structure
    >(
        atX x: X.Type,
        free f: Free.Type
    ) -> String { "" }
}
extension RestAir: DividesY {
    public static func rendered<
        Y: Frac & Structure,
        Across: Frac & Structure,
        Free: Frac & Structure
    >(
        atY y: Y.Type,
        width w: Across.Type,
        free f: Free.Type
    ) -> String { "" }
}

/// Takes the supplied fixed extent and draws empty content.
public enum Air<S: Structure>: Close {}
extension Air: Divides {
    public typealias Taken = S
    public typealias Stretch = Never
    public static func rendered<
        X: Frac & Structure,
        Free: Frac & Structure
    >(
        atX x: X.Type,
        free f: Free.Type
    ) -> String { "" }
}

/// Draws content within one share of the remaining extent.
public enum Flexible<Content: Spanning>: Close {}
extension Flexible: Divides {
    public typealias Taken = Never
    public typealias Stretch = Unit
    public static func rendered<
        X: Frac & Structure,
        Free: Frac & Structure
    >(
        atX x: X.Type,
        free f: Free.Type
    ) -> String {
        "<g transform=\"translate(\(XMLEscaped<SpanPx<X>>.typeName), 0)\">\n"
            + Content.rendered(atX: RowStart.self, width: f)
            + "</g>\n"
    }
}

extension Paired: Takes
where L: Takes, R: Takes {
    public typealias Taken = Plus<L.Taken, R.Taken>
    public typealias Stretch = Plus<L.Stretch, R.Stretch>
}
extension Paired: Divides
where L: Divides, R: Divides {
    public static func rendered<
        X: Frac & Structure,
        Free: Frac & Structure
    >(
        atX x: X.Type,
        free f: Free.Type
    ) -> String {
        L.rendered(atX: x, free: f)
            + R.rendered(
                atX: Sum<X, Sum<GivenSpan<L.Taken>, Stretched<Free, L.Stretch>>>.self,
                free: f
            )
    }
}

/// Distributes a supplied width among the composed members in body order.
public protocol HFlow: Open {
    associatedtype Given: Structure
}
extension HFlow
where Body: Divides & Structure {
    public static var typeName: String {
        precondition(
            Body.Stretch.count > 0,
            "An axis under a given owes its remainder to someone: end \(Self.self) with a flexible member (Flexible<SpanNothing> states that the rest stays empty)."
        )
        return Body.rendered(
            atX: RowStart.self,
            free: Paired<Rest<Given, Body.Taken>, Body.Stretch>.self
        )
    }
}

/// Reads members along a vertical axis with the supplied width and free share.
public protocol DividesY: Takes {
    static func rendered<
        Y: Frac & Structure,
        Across: Frac & Structure,
        Free: Frac & Structure
    >(
        atY y: Y.Type,
        width w: Across.Type,
        free f: Free.Type
    ) -> String
}
extension Fixed: DividesY {
    public static func rendered<
        Y: Frac & Structure,
        Across: Frac & Structure,
        Free: Frac & Structure
    >(
        atY y: Y.Type,
        width w: Across.Type,
        free f: Free.Type
    ) -> String {
        "<g transform=\"translate(0, \(XMLEscaped<SpanPx<Y>>.typeName))\">\n"
            + Content.rendered(atX: RowStart.self, width: w)
            + "</g>\n"
    }
}
extension Air: DividesY {
    public static func rendered<
        Y: Frac & Structure,
        Across: Frac & Structure,
        Free: Frac & Structure
    >(
        atY y: Y.Type,
        width w: Across.Type,
        free f: Free.Type
    ) -> String { "" }
}
extension Flexible: DividesY {
    public static func rendered<
        Y: Frac & Structure,
        Across: Frac & Structure,
        Free: Frac & Structure
    >(
        atY y: Y.Type,
        width w: Across.Type,
        free f: Free.Type
    ) -> String {
        "<g transform=\"translate(0, \(XMLEscaped<SpanPx<Y>>.typeName))\">\n"
            + Content.rendered(atX: RowStart.self, width: w)
            + "</g>\n"
    }
}
extension Paired: DividesY
where L: DividesY, R: DividesY {
    public static func rendered<
        Y: Frac & Structure,
        Across: Frac & Structure,
        Free: Frac & Structure
    >(
        atY y: Y.Type,
        width w: Across.Type,
        free f: Free.Type
    ) -> String {
        L.rendered(atY: y, width: w, free: f)
            + R.rendered(
                atY: Sum<Y, Sum<GivenSpan<L.Taken>, Stretched<Free, L.Stretch>>>.self,
                width: w,
                free: f
            )
    }
}

/// Distributes a supplied height among members and passes the stated width across them.
public protocol VFlow: Open {
    associatedtype Given: Structure
    associatedtype Across: Structure
}
extension VFlow
where Body: DividesY & Structure {
    public static var typeName: String {
        precondition(
            Body.Stretch.count > 0,
            "An axis under a given owes its remainder to someone: end \(Self.self) with a flexible member (Flexible<SpanNothing> states that the rest stays empty)."
        )
        return Body.rendered(
            atY: RowStart.self,
            width: GivenSpan<Across>.self,
            free: Paired<Rest<Given, Body.Taken>, Body.Stretch>.self
        )
    }
}

/// Derives height from fixed vertical members and uses the supplied width and binding.
public protocol GrownDiagram: Open, StyleBound {
    associatedtype Across: Structure
    associatedtype AriaLabel: Structure
    /// Supplies definitions before the axis without taking height.
    associatedtype Defs: Structure = Never
    /// Supplies the ground before the axis without taking height.
    associatedtype Backdrop: Structure = Never
}
extension GrownDiagram
where Body: DividesY & Structure {
    public static var typeName: String {
        DeliveredSVG<Binding, GrownDiagramMarkup<Self>>.typeName
    }
}

public enum GrownDiagramMarkup<Root: GrownDiagram>: Close
where Root.Body: DividesY & Structure {}
extension GrownDiagramMarkup {
    public static var typeName: String {
        precondition(
            Root.Body.Stretch.count == 0,
            "A grown axis has no remainder to share: \(Root.self) grows to fit its members, so a flexible member cannot stand here."
        )
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 \(Root.Across.count) \(Root.Body.Taken.count)\" role=\"img\" "
            + "data-vi-canvas=\"1\" font-family=\"\(XMLEscaped<Root.Binding.BodyFace>.typeName)\" "
            + "aria-label=\"\(XMLEscaped<Root.AriaLabel>.typeName)\">\n"
            + Root.Defs.typeName
            + Root.Backdrop.typeName
            + Root.Body.rendered(
                atY: RowStart.self,
                width: GivenSpan<Root.Across>.self,
                free: Paired<Never, Unit>.self
            )
            + "</svg>\n"
    }
}

/// Renders its content when the two supplied counts are equal.
public enum EdgeSame<
    A: Structure,
    B: Structure,
    Then: Spanning
>: Close {}
extension EdgeSame: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        guard A.count == B.count else { return "" }
        return Then.rendered(atX: x, width: w)
    }
}

/// Renders its content when the first supplied count is at least the second.
public enum EdgeAtLeast<
    A: Structure,
    B: Structure,
    Then: Spanning
>: Close {}
extension EdgeAtLeast: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        guard A.count >= B.count else { return "" }
        return Then.rendered(atX: x, width: w)
    }
}

/// Renders its content when the supplied count is even.
public enum EdgeEven<
    A: Structure,
    Then: Spanning
>: Close {}
extension EdgeEven: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        guard A.count % 2 == 0 else { return "" }
        return Then.rendered(atX: x, width: w)
    }
}

/// Renders its content when the supplied count is odd.
public enum EdgeOdd<
    A: Structure,
    Then: Spanning
>: Close {}
extension EdgeOdd: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        guard A.count % 2 == 1 else { return "" }
        return Then.rendered(atX: x, width: w)
    }
}

/// Draws two spanning compositions at the same origin and width in body order.
public enum Layered<
    A: Spanning,
    B: Spanning
>: Close {}
extension Layered: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        A.rendered(atX: x, width: w) + B.rendered(atX: x, width: w)
    }
}

/// Fills its slice using the supplied height, radius and card palette.
public protocol SpanCardFace: Spanning, StyleBound {
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
    associatedtype Stroke: Structure
}
extension SpanCardFace {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g filter=\"url(#" + SurfaceCardShadowName.typeName + ")\">\n"
            + "<rect x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" width=\"\(XMLEscaped<SpanPx<W>>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" "
            + "rx=\"\(XMLEscaped<Radius>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\" stroke=\"\(XMLEscaped<Stroke>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.HairlineWidth>.typeName)\"/>\n"
            + "</g>\n"
    }
}

/// Anchors its text at the slice origin with its declared register.
public protocol SpanLabel: Spanning {
    associatedtype Y: Structure
    associatedtype FillColor: Structure
    associatedtype Size: Structure
    associatedtype Weight: Structure
    associatedtype Content: Structure
}
extension SpanLabel {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<text x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"start\" "
            + "fill=\"\(XMLEscaped<FillColor>.typeName)\" font-weight=\"\(XMLEscaped<Weight>.typeName)\" "
            + "font-size=\"\(XMLEscaped<Size>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}

/// Centers a disk within its slice at the stated ordinate.
public protocol SpanDot: Spanning {
    associatedtype CY: Structure
    associatedtype R: Structure
    associatedtype Fill: Structure
}
extension SpanDot {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<circle cx=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" cy=\"\(XMLEscaped<CY>.typeName)\" "
            + "r=\"\(XMLEscaped<R>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
    }
}

/// Reads the binding's timed reveal rule for the supplied content.
public enum BoundTimedReveal<
    Binding: DrawingStyle,
    Begin: Structure,
    Dwell: Structure,
    Content: Structure
>: Close {}
extension BoundTimedReveal {
    public static var typeName: String {
        "<g opacity=\"\(XMLEscaped<Binding.HiddenOpacity>.typeName)\"><set attributeName=\"opacity\" to=\"\(XMLEscaped<Binding.VisibleOpacity>.typeName)\" "
            + "begin=\"\(XMLEscaped<Begin>.typeName)s\" dur=\"\(XMLEscaped<Dwell>.typeName)s\"/>\n"
            + Content.typeName + "</g>\n"
    }
}

/// Reads the binding's frozen reveal rule for the supplied content.
public enum BoundFrozenReveal<
    Binding: DrawingStyle,
    Begin: Structure,
    Content: Structure
>: Close {}
extension BoundFrozenReveal {
    public static var typeName: String {
        "<g opacity=\"\(XMLEscaped<Binding.HiddenOpacity>.typeName)\"><set attributeName=\"opacity\" to=\"\(XMLEscaped<Binding.VisibleOpacity>.typeName)\" "
            + "begin=\"\(XMLEscaped<Begin>.typeName)s\" fill=\"freeze\"/>\n"
            + Content.typeName + "</g>\n"
    }
}

/// Centers a disk and reads its animation from the binding.
public protocol SpanBreathingDot: Spanning, StyleBound {
    associatedtype CY: Structure
    associatedtype R: Structure
    associatedtype Fill: Structure
}
extension SpanBreathingDot {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<circle cx=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" cy=\"\(XMLEscaped<CY>.typeName)\" "
            + "r=\"\(XMLEscaped<R>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\">"
            + "<animate attributeName=\"opacity\" values=\"\(XMLEscaped<Binding.BreatheValues>.typeName)\" dur=\"\(XMLEscaped<Binding.BreatheDuration>.typeName)\" "
            + "repeatCount=\"indefinite\"/></circle>\n"
    }
}

/// Wraps spanning content in an anchor with the supplied target.
public enum SpanLink<
    Target: Structure,
    Content: Spanning
>: Close {}
extension SpanLink: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<a href=\"\(XMLEscaped<Target>.typeName)\">\n"
            + Content.rendered(atX: x, width: w)
            + "</a>\n"
    }
}

/// Fills its slice with a rounded track at the stated height.
public protocol SpanTrack: Spanning {
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
}
extension SpanTrack {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<rect x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" width=\"\(XMLEscaped<SpanPx<W>>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" "
            + "rx=\"\(XMLEscaped<Radius>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
    }
}
/// Fills its slice with the supplied paint, radius, height and shadow reference.
public protocol SpanHeroFace: Spanning {
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
}
extension SpanHeroFace {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g filter=\"url(#" + SoftShadowName.typeName + ")\">\n"
            + "<rect x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" width=\"\(XMLEscaped<SpanPx<W>>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" "
            + "rx=\"\(XMLEscaped<Radius>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
            + "</g>\n"
    }
}
/// Wraps spanning content in the shared hover-transform class.
public enum SpanLift<Content: Spanning>: Close {}
extension SpanLift: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g class=\"hover-lift\" style=\"--tx:0px;--ty:0px\">\n"
            + Content.rendered(atX: x, width: w)
            + "</g>\n"
    }
}
/// Places a composed structure at its slice origin.
public enum SpanHosted<Content: Structure>: Close {}
extension SpanHosted: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        Content.typeName
    }
}
/// Refuses text above the limit read by Int(Budget.typeName), using Int.max when that conversion fails.
public protocol SpanLabelBudgeted: Spanning {
    associatedtype Y: Structure
    associatedtype FillColor: Structure
    associatedtype Size: Structure
    associatedtype Weight: Structure
    associatedtype Content: Structure
    associatedtype Budget: Structure
}
extension SpanLabelBudgeted {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        let text = Content.typeName
        let limit = Int(Budget.typeName) ?? Int.max
        precondition(
            text.count <= limit,
            "SpanLabelBudgeted overflow in \(Self.self): \"\(text)\" is \(text.count) characters, budget is \(limit)"
        )
        return "<text x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"start\" "
            + "fill=\"\(XMLEscaped<FillColor>.typeName)\" font-weight=\"\(XMLEscaped<Weight>.typeName)\" "
            + "font-size=\"\(XMLEscaped<Size>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}
/// Offsets spanning content vertically by the supplied magnitude.
public enum SpanLowered<Y: Structure, Content: Spanning>: Close {}
extension SpanLowered: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g transform=\"translate(0, \(XMLEscaped<Y>.typeName))\">\n"
            + Content.rendered(atX: x, width: w)
            + "</g>\n"
    }
}
/// Draws a horizontal rule across its slice with the binding's stroke width.
public protocol SpanRule: Spanning, StyleBound {
    associatedtype Y: Structure
    associatedtype Stroke: Structure
}
extension SpanRule {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<line x1=\"\(XMLEscaped<SpanPx<X>>.typeName)\" y1=\"\(XMLEscaped<Y>.typeName)\" "
            + "x2=\"\(XMLEscaped<SpanPx<Sum<X, W>>>.typeName)\" y2=\"\(XMLEscaped<Y>.typeName)\" "
            + "stroke=\"\(XMLEscaped<Stroke>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ArrowWidth>.typeName)\"/>\n"
    }
}
/// Wraps spanning content in the shared shadow reference.
public enum SpanSoftShadowed<Content: Spanning>: Close {}
extension SpanSoftShadowed: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g filter=\"url(#" + SoftShadowName.typeName + ")\">\n"
            + Content.rendered(atX: x, width: w)
            + "</g>\n"
    }
}
/// Draws a slice-filling outline with the binding's dash pattern.
public protocol SpanTrackDashed: Spanning, StyleBound {
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
    associatedtype Stroke: Structure
}
extension SpanTrackDashed {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<rect x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" width=\"\(XMLEscaped<SpanPx<W>>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Radius>.typeName)\" "
            + "fill=\"\(XMLEscaped<Fill>.typeName)\" stroke=\"\(XMLEscaped<Stroke>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.HairlineWidth>.typeName)\" stroke-dasharray=\"\(XMLEscaped<Binding.DependencyDash>.typeName)\"/>\n"
    }
}
/// Draws empty content for any supplied slice.
public enum SpanNothing: Close {}
extension SpanNothing: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String { "" }
}
/// Groups a spanning trigger and supplied panel under one hover scope.
public enum SpanHoverReveal<Trigger: Spanning, Panel: Structure>: Close {}
extension SpanHoverReveal: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g class=\"hover-pair\">\n"
            + "<g class=\"hover-trigger\">\n" + Trigger.rendered(atX: x, width: w) + "</g>\n"
            + "<g class=\"hover-panel\">\n" + Panel.typeName + "</g>\n"
            + "</g>\n"
    }
}
/// Draws an arrow from the slice start to its end at the stated baseline.
public protocol SpanArrowAcross: Spanning, StyleBound {
    associatedtype Y: Structure
}
extension SpanArrowAcross {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<line x1=\"\(XMLEscaped<SpanPx<X>>.typeName)\" y1=\"\(XMLEscaped<Y>.typeName)\" "
            + "x2=\"\(XMLEscaped<SpanPx<Sum<X, W>>>.typeName)\" y2=\"\(XMLEscaped<Y>.typeName)\" "
            + "stroke=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ArrowWidth>.typeName)\" marker-end=\"url(#\(XMLEscaped<ArrowHeadName>.typeName))\"/>\n"
    }
}
/// Draws an arrow from the slice end to its start at the stated baseline.
public protocol SpanArrowBackAcross: Spanning, StyleBound {
    associatedtype Y: Structure
}
extension SpanArrowBackAcross {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<line x1=\"\(XMLEscaped<SpanPx<Sum<X, W>>>.typeName)\" y1=\"\(XMLEscaped<Y>.typeName)\" "
            + "x2=\"\(XMLEscaped<SpanPx<X>>.typeName)\" y2=\"\(XMLEscaped<Y>.typeName)\" "
            + "stroke=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ArrowWidth>.typeName)\" marker-end=\"url(#\(XMLEscaped<ArrowHeadName>.typeName))\"/>\n"
    }
}
/// Draws an arrow at the slice midpoint between the stated baselines.
public protocol SpanArrowDown: Spanning, StyleBound {
    associatedtype FromY: Structure
    associatedtype ToY: Structure
}
extension SpanArrowDown {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<line x1=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" y1=\"\(XMLEscaped<FromY>.typeName)\" "
            + "x2=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" y2=\"\(XMLEscaped<ToY>.typeName)\" "
            + "stroke=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ArrowWidth>.typeName)\" marker-end=\"url(#\(XMLEscaped<ArrowHeadName>.typeName))\"/>\n"
    }
}
/// Reads the supplied text at the slice origin with the binding's caption paint and slant.
public protocol SpanLabelItalic: Spanning, StyleBound {
    associatedtype Y: Structure
    associatedtype Size: Structure
    associatedtype Content: Structure
}
extension SpanLabelItalic {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<text x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"start\" "
            + "fill=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" font-size=\"\(XMLEscaped<Size>.typeName)\" "
            + "font-family=\"\(XMLEscaped<Binding.CaptionFace>.typeName)\" font-style=\"\(XMLEscaped<Binding.CaptionSlant>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}
/// Reads the supplied caption at the slice midpoint.
public protocol SpanLabelItalicMid: Spanning, StyleBound {
    associatedtype Y: Structure
    associatedtype Size: Structure
    associatedtype Content: Structure
}
extension SpanLabelItalicMid {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<text x=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"middle\" "
            + "fill=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" font-size=\"\(XMLEscaped<Size>.typeName)\" "
            + "font-family=\"\(XMLEscaped<Binding.CaptionFace>.typeName)\" font-style=\"\(XMLEscaped<Binding.CaptionSlant>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}
/// Fills Part over Whole of the supplied width using the stated geometry and paint.
public protocol SpanDataFill: Spanning {
    associatedtype Part: Structure
    associatedtype Whole: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
}
extension SpanDataFill {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<rect x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" "
            + "width=\"\(XMLEscaped<SpanPx<Paired<Times<W.Left, Part>, Times<W.Right, Whole>>>>.typeName)\" "
            + "height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Radius>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
    }
}
/// Starts after Prefix and fills Part over Whole of the supplied width.
public protocol SpanDataSegment: Spanning, StyleBound {
    associatedtype Prefix: Structure
    associatedtype Part: Structure
    associatedtype Whole: Structure
    associatedtype H: Structure
    associatedtype Fill: Structure
}
extension SpanDataSegment {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<rect x=\"\(XMLEscaped<SpanPx<Sum<X, Paired<Times<W.Left, Prefix>, Times<W.Right, Whole>>>>>.typeName)\" "
            + "width=\"\(XMLEscaped<SpanPx<Paired<Times<W.Left, Part>, Times<W.Right, Whole>>>>.typeName)\" "
            + "height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Binding.SquareRadius>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\"/>\n"
    }
}
/// Anchors the supplied text at its slice midpoint.
public protocol SpanLabelMid: Spanning {
    associatedtype Y: Structure
    associatedtype FillColor: Structure
    associatedtype Size: Structure
    associatedtype Weight: Structure
    associatedtype Content: Structure
}
extension SpanLabelMid {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<text x=\"\(XMLEscaped<SpanPx<MidOf<X, W>>>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"middle\" "
            + "fill=\"\(XMLEscaped<FillColor>.typeName)\" font-weight=\"\(XMLEscaped<Weight>.typeName)\" "
            + "font-size=\"\(XMLEscaped<Size>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}
/// Anchors the supplied text at its slice end.
public protocol SpanLabelEnd: Spanning {
    associatedtype Y: Structure
    associatedtype FillColor: Structure
    associatedtype Size: Structure
    associatedtype Weight: Structure
    associatedtype Content: Structure
}
extension SpanLabelEnd {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<text x=\"\(XMLEscaped<SpanPx<Sum<X, W>>>.typeName)\" y=\"\(XMLEscaped<Y>.typeName)\" text-anchor=\"end\" "
            + "fill=\"\(XMLEscaped<FillColor>.typeName)\" font-weight=\"\(XMLEscaped<Weight>.typeName)\" "
            + "font-size=\"\(XMLEscaped<Size>.typeName)\">\(XMLEscaped<Content>.typeName)</text>\n"
    }
}

/// Declares a rounded clipping path derived from its slice and supplied identifier.
public protocol SpanClipDef: Spanning {
    associatedtype Id: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
}
extension SpanClipDef {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<clipPath id=\"\(XMLEscaped<Id>.typeName)\">\n"
            + "<rect x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" width=\"\(XMLEscaped<SpanPx<W>>.typeName)\" "
            + "height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Radius>.typeName)\"/>\n"
            + "</clipPath>\n"
    }
}
public enum SpanClipped<
    Id: Structure,
    Content: Spanning
>: Close {}
extension SpanClipped: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g clip-path=\"url(#\(XMLEscaped<Id>.typeName))\">\n"
            + Content.rendered(atX: x, width: w)
            + "</g>\n"
    }
}
/// Draws a slice-filling rectangle with its declared outline.
public protocol SpanTrackOutlined: Spanning, StyleBound {
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
    associatedtype Stroke: Structure
}
extension SpanTrackOutlined {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<rect x=\"\(XMLEscaped<SpanPx<X>>.typeName)\" width=\"\(XMLEscaped<SpanPx<W>>.typeName)\" height=\"\(XMLEscaped<H>.typeName)\" rx=\"\(XMLEscaped<Radius>.typeName)\" "
            + "fill=\"\(XMLEscaped<Fill>.typeName)\" stroke=\"\(XMLEscaped<Stroke>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.HairlineWidth>.typeName)\"/>\n"
    }
}

