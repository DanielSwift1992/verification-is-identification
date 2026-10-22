import Notation

/// Carries outlines from explicitly assigned font sources at stated weights.
/// Each glyph row states codepoint, advance, source, weight and SVG path, separated by `|`.
public protocol OutlineFontFace: Open {
    associatedtype Units: Structure
    associatedtype Glyphs: Structure
}

/// Shares the declared glyph paths within a figure. The SVG needs no installed font.
public enum OutlineDefinitions<Face: OutlineFontFace>: Close {}
extension OutlineDefinitions {
    public static var typeName: String {
        var result = "<defs>\n"
        var seen: Set<Int> = []
        for row in Face.Glyphs.typeName.split(separator: "\n") {
            let parts = row.split(separator: "|", maxSplits: 4, omittingEmptySubsequences: false)
            precondition(parts.count == 5, "Outline font: malformed glyph row")
            guard let code = Int(parts[0]), let advance = Double(parts[1]) else {
                preconditionFailure("Outline font: malformed glyph metric")
            }
            precondition(advance >= 0 && seen.insert(code).inserted, "Outline font: duplicate or negative metric")
            result += "<path id=\"\(Face.self)-glyph-\(code)\" data-font-source=\"\(parts[2])\" data-font-weight=\"\(parts[3])\" d=\"\(parts[4])\"/>\n"
        }
        return result + "</defs>\n"
    }
}

/// Positions text with the same advances that supplied its glyph paths.
/// Missing glyphs refuse at generation with their Unicode address.
public protocol OutlineLabel: Open {
    associatedtype Font: OutlineFontFace
    associatedtype Content: Structure
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Size: Structure
    associatedtype Fill: Paint
    associatedtype Legibility: LegiblePaintPair
    where Legibility.Foreground == Fill
    associatedtype Anchor: Structure
    associatedtype Tracking: Structure = Never
    associatedtype MaxWidth: Structure = Never
}
extension OutlineLabel {
    public static var typeName: String {
        precondition(Legibility.Proof.Left.count == Legibility.Proof.Right.count, "Outline label contrast: \(Self.self)")
        guard let units = Double(Font.Units.typeName), units > 0,
              let size = Double(Size.typeName), size > 0 else {
            preconditionFailure("Outline label: invalid units or size")
        }
        var advances: [Int: Double] = [:]
        for row in Font.Glyphs.typeName.split(separator: "\n") {
            let parts = row.split(separator: "|", maxSplits: 4, omittingEmptySubsequences: false)
            guard parts.count == 5, let code = Int(parts[0]), let advance = Double(parts[1]) else {
                preconditionFailure("Outline label: malformed glyph row")
            }
            precondition(advance >= 0 && advances[code] == nil, "Outline label: duplicate or negative metric")
            advances[code] = advance
        }
        let tracking = Tracking.typeName.isEmpty ? 0 : Double(Tracking.typeName)
        precondition(tracking != nil, "Outline label: invalid tracking")
        let step = tracking! * units / size
        var width = 0.0
        var glyphs: [(Int, Double)] = []
        for scalar in Content.typeName.unicodeScalars {
            let code = Int(scalar.value)
            guard let advance = advances[code] else {
                preconditionFailure("Outline glyph missing: U+\(String(code, radix: 16).uppercased()) in \(Self.self)")
            }
            glyphs.append((code, width))
            width += Double(advance) + step
        }
        let anchor = Anchor.typeName
        precondition(["start", "middle", "end"].contains(anchor), "Outline label: unsupported anchor")
        width -= glyphs.isEmpty ? 0 : step
        if !MaxWidth.typeName.isEmpty {
            guard let budget = Double(MaxWidth.typeName), budget > 0 else {
                preconditionFailure("Outline label: invalid width budget")
            }
            precondition(width * size / units <= budget, "Outline label overflow in \(Self.self): declared width \(budget)")
        }
        let offset = anchor == "middle" ? -width / 2 : (anchor == "end" ? -width : 0)
        let scale = size / units
        var result = "<g role=\"img\" aria-label=\"\(XMLEscaped<Content>.typeName)\" data-vi-text=\"\(XMLEscaped<Content>.typeName)\" data-font-face=\"\(Font.self)\" data-declaration=\"\(XMLEscaped<RawName<Self>>.typeName)\" data-background=\"\(XMLEscaped<Legibility.Background>.typeName)\" data-legibility=\"\(XMLEscaped<Legibility.WitnessName>.typeName)\" "
            + "fill=\"\(XMLEscaped<Fill>.typeName)\" transform=\"translate(\(X.typeName) \(Y.typeName)) scale(\(scale) \(-scale))\">\n"
        for (code, x) in glyphs {
            result += "<use href=\"#\(Font.self)-glyph-\(code)\" data-codepoint=\"\(code)\" transform=\"translate(\(x + offset) 0)\"/>\n"
        }
        return result + "</g>\n"
    }
}

/// Gives a composition a frame, title and description, including cropped roots.
public protocol AccessibleFigure: Open, StyleBound {
    associatedtype Frame: Structure
    associatedtype Title: Structure
    associatedtype Description: Structure
    associatedtype Definitions: Structure
    associatedtype Content: Structure
}
extension AccessibleFigure {
    public static var typeName: String {
        DeliveredSVG<Binding, AccessibleMarkup<Self>>.typeName
    }
}

public enum AccessibleMarkup<Root: AccessibleFigure>: Close {}
extension AccessibleMarkup {
    public static var typeName: String {
        let frame = Root.Frame.typeName.split(separator: " ")
        precondition(frame.count == 4, "Figure frame requires x, y, width and height")
        let raw = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(frame[2])\" height=\"\(frame[3])\" viewBox=\"\(XMLEscaped<Root.Frame>.typeName)\" role=\"img\" aria-labelledby=\"title desc\" data-vi-canvas=\"1\">\n"
            + "<title id=\"title\">\(XMLEscaped<Root.Title>.typeName)</title>\n"
            + "<desc id=\"desc\">\(XMLEscaped<Root.Description>.typeName)</desc>\n"
            + Root.Definitions.typeName + Root.Content.typeName + "</svg>\n"
        let attributes = raw.split(separator: "\"", omittingEmptySubsequences: false)
        var references: Set<String> = []
        for index in attributes.indices.filter({ $0 % 2 == 1 }) {
            if attributes[index - 1].hasSuffix("href="), attributes[index].hasPrefix("#") {
                references.insert(String(attributes[index].dropFirst()))
            }
        }
        let required = raw.split(separator: "\n", omittingEmptySubsequences: false).filter { line in
            if line.hasPrefix("<path id="), line.contains("data-font-source=") {
                let fields = line.split(separator: "\"", omittingEmptySubsequences: false)
                return fields.count > 1 && references.contains(String(fields[1]))
            }
            return true
        }.joined(separator: "\n")
        return required
    }
}

/// States the panel geometry and its declared paints at the serialization edge.
public protocol FigurePanel: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
    associatedtype Stroke: Structure
    associatedtype Width: Structure
    associatedtype Dash: Structure
}
extension FigurePanel {
    public static var typeName: String {
        "<rect x=\"\(X.typeName)\" y=\"\(Y.typeName)\" width=\"\(W.typeName)\" height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\" "
            + "fill=\"\(XMLEscaped<Fill>.typeName)\" stroke=\"\(XMLEscaped<Stroke>.typeName)\" stroke-width=\"\(Width.typeName)\" stroke-dasharray=\"\(Dash.typeName)\"/>\n"
    }
}

/// Carries a route, its line style and the marker chosen by its composition.
public protocol FigureRoute: Open {
    associatedtype D: Structure
    associatedtype Fill: Structure
    associatedtype Stroke: Structure
    associatedtype Width: Structure
    associatedtype Dash: Structure
    associatedtype Marker: Structure
}
extension FigureRoute {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<D>.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\" stroke=\"\(XMLEscaped<Stroke>.typeName)\" "
            + "stroke-width=\"\(Width.typeName)\" stroke-dasharray=\"\(Dash.typeName)\" marker-end=\"\(Marker.typeName)\"/>\n"
    }
}

/// Places a shared arrowhead in the declared ink of its composition.
public enum FigureArrow<Binding: DrawingStyle, Colour: Structure>: Close {}
extension FigureArrow {
    public static var typeName: String {
        "<defs><marker id=\"arrow\" viewBox=\"\(XMLEscaped<StyleValue<Binding, StyleKeys.FigureArrowBox>>.typeName)\" refX=\"\(XMLEscaped<StyleValue<Binding, StyleKeys.FigureArrowX>>.typeName)\" refY=\"\(XMLEscaped<StyleValue<Binding, StyleKeys.FigureArrowY>>.typeName)\" markerWidth=\"\(XMLEscaped<StyleValue<Binding, StyleKeys.FigureArrowWidth>>.typeName)\" markerHeight=\"\(XMLEscaped<StyleValue<Binding, StyleKeys.FigureArrowHeight>>.typeName)\" orient=\"auto-start-reverse\">"
            + "<path d=\"\(XMLEscaped<StyleValue<Binding, StyleKeys.FigureArrowPath>>.typeName)\" fill=\"\(XMLEscaped<Colour>.typeName)\"/></marker></defs>\n"
    }
}

/// States a disk with its declared paints.
public protocol FigureDisk: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
    associatedtype Stroke: Structure
    associatedtype Width: Structure
}
extension FigureDisk {
    public static var typeName: String {
        "<circle cx=\"\(X.typeName)\" cy=\"\(Y.typeName)\" r=\"\(Radius.typeName)\" fill=\"\(XMLEscaped<Fill>.typeName)\" "
            + "stroke=\"\(XMLEscaped<Stroke>.typeName)\" stroke-width=\"\(Width.typeName)\"/>\n"
    }
}
