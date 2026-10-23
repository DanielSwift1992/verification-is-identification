import Notation

/// XML serialization reads characters only at the output edge. Measurement and type
/// spelling keep the original text; composition keeps its already serialized markup.
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

/// Time is a rational reading of integer ticks, not integer lattice division.
public enum Seconds<Ticks: Structure, Frequency: Structure>: Close {}
extension Seconds {
    public static var typeName: String {
        precondition(Frequency.count > 0, "Seconds requires a positive frequency")
        return String(Double(Ticks.count) / Double(Frequency.count))
    }
}

// ═══════════════════════════════════════════════════════════════
// VECTOR is SVG as DocumentKit's second medium, the same mechanism Markup.swift
// uses for markdown: every atom is a `Close` read through `typeName`, every combinator is an
// `Open` protocol whose `body` composes atoms, walked by `typeName` into the drawing. SVG is
// text, and `typeName` already generates text: drawing is the same act as rendering a page,
// not a second one. The geometry is OURS: a `viewBox` fixes the coordinate system and aspect
// ratio, so embedding as an `<img>` (DocC's choice) scales both axes together,
// deterministically. The walls this file's laws name for markdown (§S15 no column width,
// §S19 no visible weight, §S21 fixed image margins) are walls of THAT medium, not this one.
//
// The geometry has three compositional interfaces: a divided axis hands each
// member its slice and derives the remainder; a span draws into that slice; a pen
// composes a path. Magnitudes come from the caller and are read through Tally,
// SpanPx, Halfway and Under. Binding supplies the required style readings.
// Per-instance content (a glyph's path data, a line's text) is a `Structure` hole, exactly
// like `Symbol`'s target or `TableCell`'s content.
// ═══════════════════════════════════════════════════════════════

// THE CANVAS CONTRACT — what the medium guarantees, and what it does not.
//
// GUARANTEED. A Canvas fixes a coordinate space of its own: viewBox W×H is a pixel
// grid that belongs to the composition. Inside it, the composition's geometry is
// its own, and the host cannot reach in: no margin, no centering, no theme
// rule moves anything within the viewBox. The host may scale the canvas ONLY
// as a whole, uniformly: the aspect is preserved, so a known width fixes the
// height. Nothing drifts.
//
// NOT GUARANTEED. The absolute on-screen size: markdown offers no pixel pin,
// so the canvas renders at container width. Right SHAPE always, exact screen
// pixels never promised. Text metrics: glyph width is the platform font's, and
// the craft is a fixed font-family and generous boxes (§S15's discipline:
// state the box, never compute the fit).
// ═══════════════════════════════════════════════════════════════

// GATE TIERS. Compile gate: an illegal type does not build (`Legible`,
// `WithinBounds`, the strongest form). Generation gate: an illegal VALUE
// stops `generate` with a named precondition (`BudgetedLabel`), weaker,
// still before anything ships. Host gate: what only the browser decides
// (hover, theme), declared, never trusted with correctness.
// ═══════════════════════════════════════════════════════════════

/// This marks a canvas that shows its source. Opting in costs nothing beyond this empty
/// conformance: the composition a conforming canvas's `body` shows is ALREADY the exact type its
/// `@StructureBuilder` folded (a left-nested `Paired` chain), so a reader can read that
/// SAME type back through `String(reflecting: Body.self)` and print it. The reader is
/// consuming driver's decompiler, a value-level concern. This medium only carries the
/// marker and, per canvas, the small `{ }` chip built from existing atoms (`GlyphRect`,
/// `Label`, `Linked`).
/// Nothing here can drift from what compiled, because nothing here is a second copy of it.
public protocol SelfShowing {}

/// This is several drawn pieces, composed through `body` into one: the SVG-medium counterpart of
/// Keeps the content fragment local to the drawing vocabulary. A canvas's `Content` hole accepts its composition.
public protocol Group: Open {}

/// This is the SVG root, like `Screen`/`Reference`, but the medium is source text, not markdown.
/// The canvas frame reads its viewBox off the same structures the rows slice: width and
/// height are counts, digits born here, at the edge, like every other reading.
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
        // `data-vi-canvas="1"` — every canvas declares ITSELF, so the host needs no separate
        // name list to keep in sync by hand: a second list (footer.html's `WHITELIST`) is
        // exactly the kind of bookkeeping this medium's `body`/`typeName` discipline exists
        // to make unnecessary, and a name missing from it renders untheme'd with no error. A
        // marker on the root the canvas ALREADY emits needs no second list at all.
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"\(XMLEscaped<Root.Size>.typeName)\" role=\"img\" "
            + "data-vi-canvas=\"1\" "
            + "font-family=\"\(XMLEscaped<Root.Binding.BodyFace>.typeName)\" aria-label=\"\(XMLEscaped<Root.AriaLabel>.typeName)\">\n"
            + Root.Content.typeName + "\n</svg>\n"
    }
}

/// Positions a rounded panel with the radius supplied by its binding.
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

/// This is a sharp-cornered panel at the origin: a card's full-bleed background.
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

/// Positions a rounded full-bleed panel at the origin with its declared radius.
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

/// Draws Content at X and Y with the caption face, slant and paint of Binding.
/// Coordinates and size are supplied by the composition.
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

// ═══ THE PEN — drawing as constrained motion. A path is not a list of stated points: it
// is a start and a chain of moves, each move running straight UNTIL a named line — the
// stopping condition is a rung of the dictionary, so the endpoint DERIVES, and the free
// part of the drawing is exactly what the constraints leave free. Horizontal position is
// a fraction of the surface (read through `SpanPx`, the row's own coordinate language), and
// vertical position is a magnitude (read by count). A diagonal is `SlideTo`: a straight
// line to a point both of whose coordinates already derive. Any arrow eats a pen chain
// whole — the chain's `typeName` IS the path's `d`. ═══

/// This is a position under the pen: where it is after the moves so far. Every move
/// exposes its end, so the next move's stopping line is all it needs to state.
public protocol Pen: Structure {
    associatedtype AtX: Frac & Structure
    associatedtype AtY: Structure
}

/// This puts the pen down: a start names the one point no motion can derive.
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

/// This runs the pen straight until the named horizontal line: the vertical move, its
/// direction implied by where the line is, its endpoint derived, not stated.
public enum UntilY<
    Prev: Pen,
    Line: Structure
>: Close {}
extension UntilY: Pen {
    public typealias AtX = Prev.AtX
    public typealias AtY = Line
    public static var typeName: String {
        "\(XMLEscaped<Prev>.typeName) L\(XMLEscaped<SpanPx<Prev.AtX>>.typeName),\(Line.count)"
    }
}

/// This runs the pen straight until the named vertical line: the horizontal move.
public enum UntilX<
    Prev: Pen,
    Line: Frac & Structure
>: Close {}
extension UntilX: Pen {
    public typealias AtX = Line
    public typealias AtY = Prev.AtY
    public static var typeName: String {
        "\(XMLEscaped<Prev>.typeName) L\(XMLEscaped<SpanPx<Line>>.typeName),\(Prev.AtY.count)"
    }
}

/// This slides the pen to a point whose two coordinates both derive: the diagonal. The
/// medium solves no angled intersections (that would take roots): it connects points the
/// rungs already determine.
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

/// This reads a text line hanging a stated baseline under a named row: the structure is
/// the row's rung, the baseline is typography (the one stated hole), and moving the row
/// carries its words along.
public enum Under<
    Line: Structure,
    Baseline: Structure
>: Close {}
extension Under {
    public static var typeName: String {
        String(Line.count + (Int(Baseline.typeName) ?? 0))
    }
}

/// This reads a text's measured width at a size, in canvas pixels, rounded up: the sum of
/// the stated font's own advances (GeneratedFontMetrics, spelled from the world's stated font file
/// by `swift run FontMetrics`). The world supplies the advance for a character outside
/// its table. A measured fit is relative to these supplied metrics.
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

/// This is the measured gate on a centred label: the words must fit the width the slice
/// hands over, and the gate refuses a text that outgrows its box at generation, loudly,
/// by name: the same floor a crashed generator already is, under every fitted
/// label instead of a reviewer's eye.
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

/// This is the centred baseline, derived: the y where the reader sees text of a size
/// centred in its zone (the zone's middle plus half the font's own capital height, rounded
/// to the nearest pixel). With this the centred class of baselines derives. Stacked
/// lines (a title over a subtitle) remain stated: design choices, not
/// centrings.
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

/// This is the wrapped centred label: the words fill measured lines within the width the
/// slice hands over, breaking greedily by the same measure the fitted gate reads, each
/// line one stated pitch below the last. Wrapping earns lines, never truncation: the gate
/// still refuses a single word wider than the slice, loudly. The advance-table parse
/// repeats `TextWidth`'s by law: a value helper has no lawful home outside a witness body.
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

/// The wrapped label anchored at the START of its slice: the sheet's own voice, the same
/// greedy measured break the centred twin makes, each line one stated pitch below the
/// last. Wrapping earns lines, never truncation, and the gate refuses a single word wider than
/// the slice, loudly. The advance-table parse repeats `TextWidth`'s by law: a value
/// helper has no lawful home outside a witness body.
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

/// The line count of a wrapped text as a type: how many measured lines the content
/// breaks into across a STATED width. The width is a dictionary rung, so the count
/// is fixed before any slice is handed over and a sheet's band may be sized as
/// `Times<LinePitch, LineTally<…>>`. Keep the drawing's slice the same rung, or the
/// measure lies. The break repeats the wrapped labels' own, by the same law that
/// denies a value helper a home outside a witness body.
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

/// This reads the line halfway between two named lines: the one division the fascia keeps
/// (a midpoint of magnitudes), for annotations between the two.
public enum Halfway<
    A: Structure,
    B: Structure
>: Close {}
extension Halfway {
    public static var typeName: String {
        String((A.count + B.count) / 2)
    }
}

/// This is a dashed dependency arrow: the arrow every "written in its types" diagram
/// draws back to V=I.
public protocol DashedArrow: Open, StyleBound {
    associatedtype Path: Structure
}
extension DashedArrow {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<Path>.typeName)\" stroke=\"\(XMLEscaped<Binding.TextSecondary>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ArrowWidth>.typeName)\" stroke-dasharray=\"\(XMLEscaped<Binding.DependencyDash>.typeName)\" "
            + "fill=\"\(XMLEscaped<Binding.NoPaint>.typeName)\" marker-end=\"url(#\(XMLEscaped<ArrowHeadName>.typeName))\"/>\n"
    }
}

/// This is an absolutely-placed subtree: a translate group, for a whole glyph or a whole box moved as
/// one unit rather than every child restating the same offset.
public protocol Dropped: Open {
    associatedtype Y: Structure
    associatedtype Content: Structure
}
extension Dropped {
    public static var typeName: String {
        "<g transform=\"translate(0, \(XMLEscaped<Y>.typeName))\">\n" + Content.typeName + "</g>\n"
    }
}

/// Translates Content to X and Y, then applies its declared uniform Scale.
/// The same Content can participate in several placements without redrawing its path.
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

// WithinBounds is the common interface for an owner's placement grant.
// A canvas refines it with its own relation and requires that refinement at the
// placement site. A conformance to the common interface alone does not establish
// X + W <= CanvasWidth or any other numerical bound. The owner must supply the
// relation that connects the coordinate, extent and canvas.
public protocol WithinBounds: Structure {}   // law:allow — common interface for an owner-declared placement relation

/// This wraps a subtree in a real link. `Target` is a page path from the site's closed set of
/// addresses (the same universe `<doc:…>` links resolve into: `/documentation/<module>/…`),
/// not an arbitrary URL, a curated destination, named at the call site, not computed. Always
/// emitted: the atom does not know or care which host reads it. Inert inside a plain `<img>`
/// (DocC's choice), made a real DOM anchor by the inline-swap hook, which is a decision the
/// HOST makes about how to embed the medium, not a capability this file adds.
public protocol Linked: Open {
    associatedtype Target: Structure
    associatedtype Content: Structure
}
extension Linked {
    public static var typeName: String {
        "<a href=\"\(XMLEscaped<Target>.typeName)\">\n" + Content.typeName + "</a>\n"
    }
}

/// This is the one shared rule every lifted group reads, declared once per canvas that uses them.
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

/// This is a trigger that reveals a panel on hover: "the diagram explaining itself." Both
/// halves are inside a common wrapper (`.hover-pair`) so the CSS sibling rule below is scoped
/// to THIS pair. Without that wrapper, a `.hover-trigger:hover ~ .hover-panel` selector would
/// match every panel on the whole canvas, not just its own (checked directly: two ungrouped
/// pairs cross-lit each other's panels). The panel is a dose of DOP-INFO, not the only copy of
/// what it says (§S8's floor for a progressive-enhancement atom): it contains no fact a plain
/// reading of the canvas lacks, only a closer one. It works only where the inline-swap hook has
/// turned the embedding into real DOM (`HoverLift`'s floor), inert inside a plain `<img>`.
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

/// This is a stroke with the pointer cursor that answers hover with emphasis (a flow
/// arrow): CSS `stroke`/`stroke-width` set here outrank the SVG PRESENTATION ATTRIBUTE
/// `SolidArrow`/`DashedArrow` already write (the same override `HoverLift`'s note names,
/// a style-sheet rule always outranks a presentation attribute, no `!important` needed), so the
/// line brightens without the drawing atom underneath knowing anything happened to it.
public protocol HoverHighlight: Open {
    associatedtype Content: Structure
}
extension HoverHighlight {
    public static var typeName: String {
        "<g class=\"hover-highlight\">\n" + Content.typeName + "</g>\n"
    }
}
/// This is the one shared rule every `HoverReveal`/`HoverHighlight` reads, declared once per canvas.
///
/// The panel is INTERACTIVE, not a tooltip: links inside it must be reachable and clickable.
/// Two mechanics carry that (both checked against the standard CSS traps): the reveal rule
/// includes `.hover-panel:hover`. Once the pointer reaches the panel, the panel holds itself
/// open; the world supplies the grace window after
/// the pointer leaves, so the traverse from trigger to panel survives the gap between them.
/// `pointer-events` is deliberately absent: it is not animatable, so toggling it would end
/// interactivity the instant the trigger's `:hover` drops, killing the traverse. In SVG,
/// `visibility: hidden` already withholds pointer events (`visiblePainted`), and visibility IS
/// delayable. The world supplies both transition intervals.
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

/// Marks a hover affordance with the paint and radius declared by its world.

/// This reads a type's Swift name, lowercased: the URL slug DocC's static-hosting build assigns each
/// page (`ExamplePage` renders at `.../examplepage`), read the same mechanical way
/// `RawName` reads a symbol's bare identifier (Markup.swift), not restated by hand. A caller
/// builds a real site path from a page TYPE with this plus its base path, the way `Linked`'s
/// targets are meant to be built, not a string someone has to keep in sync with the symbol.
public enum PageSlug<X>: Close {}
extension PageSlug {
    public static var typeName: String { String(describing: X.self).lowercased() }
}

/// This is a bare rounded rect inside a tinted group: no fill of its own, colour comes from the
/// enclosing `FilledGroup`/`StrokedGroup` (SVG's presentation-attribute inheritance, the
/// same reason a glyph's four tiles state one `fill` for the group, not four).
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

/// This is `GlyphRect` plus a border, sized to a small
/// glyph instead of a full-bleed panel: a swatch whose fill might legitimately match
/// whatever it is on (RolesPlate's "Card" swatch, on a Card-coloured backing) is still
/// a shape in its own right.
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

/// This is a bare circle inside a tinted group, the same inheritance as `GlyphRect`.
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

/// This is a bare path inside a tinted group: the curve data itself is stated, not computed (the
/// same discipline `TextDigit` keeps for a stated cap: read, not built). Only the wrapping
/// element is typed.
public protocol GlyphPath: Open {
    associatedtype D: Structure
}
extension GlyphPath {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<D>.typeName)\"/>\n"
    }
}

/// Reads a path stroke from the binding independently of its surrounding group.
public protocol GlyphPathThick: Open, StyleBound {
    associatedtype D: Structure
}
extension GlyphPathThick {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<D>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.ThickGlyphWidth>.typeName)\"/>\n"
    }
}

/// Draws D with its own Stroke and the glyph-stroke readings of Binding.
/// The path can participate outside a group that supplies an inherited fill.
public protocol StandaloneStrokedPath: Open, StyleBound {
    associatedtype Stroke: Paint
    associatedtype D: Structure
}
extension StandaloneStrokedPath {
    public static var typeName: String {
        "<path d=\"\(XMLEscaped<D>.typeName)\" \(BoundGlyphStroke<Binding, Stroke>.typeName)/>\n"
    }
}

/// Supplies Fill to the shapes composed by Content.
public protocol FilledGroup: Open {
    associatedtype Fill: Structure
    associatedtype Content: Structure
}
extension FilledGroup {
    public static var typeName: String {
        "<g fill=\"\(XMLEscaped<Fill>.typeName)\">\n" + Content.typeName + "</g>\n"
    }
}

/// This is `FilledGroup` plus a CSS class: the one hook a purely declarative canvas needs to let a
/// `<style>` atom (elsewhere in the SAME file, a `@keyframes` rule the class names) reach in and
/// animate something, the same edge `HoverReveal`'s `.hover-trigger`/`.hover-panel` classes
/// are already on. Still no runtime: the class and the rule are both compiled text. What plays
/// is CSS's animation clock, not a script.
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

/// Groups outlined glyphs with the binding's stroke and the selected card paint.
public protocol StrokedGroup: Open, StyleBound {
    associatedtype Stroke: Paint
    associatedtype Content: Structure
}
extension StrokedGroup {
    public static var typeName: String {
        "<g \(BoundGlyphStroke<Binding, Stroke>.typeName)>\n" + Content.typeName + "</g>\n"
    }
}

/// Reads the binding's glyph width, caps, joins and fill for the selected card paint.
/// Shares that reading between `StrokedGroup` and `StandaloneStrokedPath`.
public enum BoundGlyphStroke<
    Binding: DrawingStyle,
    C: Paint
>: Close {}
extension BoundGlyphStroke {
    public static var typeName: String {
        "stroke=\"\(XMLEscaped<C>.typeName)\" stroke-width=\"\(XMLEscaped<Binding.GlyphStrokeWidth>.typeName)\" stroke-linecap=\"\(XMLEscaped<Binding.GlyphLineCap>.typeName)\" stroke-linejoin=\"\(XMLEscaped<Binding.GlyphLineJoin>.typeName)\" fill=\"\(XMLEscaped<Binding.NoPaint>.typeName)\""
    }
}

/// The two markers both arrow kinds reuse, declared once per canvas that draws arrows.
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

// THE STATE SWITCH — a canvas's own walk, read by `:target`, not a second page per position
// (DESIGN19 §2). A fragment link (`Linked`, above) already reaches an id anywhere in the
// document, and `StateGroup` gives that id a group to hide until it is the current one, and
// `StateSwitchStyle` gives the whole canvas its resting position, the state nothing else
// has targeted yet. Checked directly, in an actual inlined SVG (DESIGN19 §4 probes 1-2):
// `:target` switches a sibling group, and `svg:not(:has(.vi-state:target)) #k0` is exactly
// the fallback CSS `:has()` makes possible. Inert inside a plain `<img>` (DocC's own
// fallback), the same progressive floor `Linked`'s click is already on.

/// This is one addressable position in a canvas's walk: hidden until `Id` is the page's
/// current fragment. `Id` is the BARE name (`"k0"`, the `<g id="...">` the browser matches
/// against). A caller reaches it through `Linked`, whose `Target` wants the `"#"`-prefixed
/// form instead (``FragmentOf``, below, reads one from the other).
public protocol StateGroup: Open {
    associatedtype Id: Structure
    associatedtype Content: Structure
}
extension StateGroup {
    public static var typeName: String {
        "<g id=\"\(XMLEscaped<Id>.typeName)\" class=\"vi-state\">\n" + Content.typeName + "</g>\n"
    }
}

/// This is the one shared rule every `StateGroup` reads: hidden unless `:target`, and
/// `DefaultId` shown when NOTHING has been targeted yet, `:has()` read against the canvas's
/// sibling groups, not a script (checked directly, DESIGN19 §4 probe 2). A reset link should
/// name a REAL state's id (`"#k0"`), never the bare empty fragment `"#"`: checked directly, on a
/// bare `#` the browser scrolls the whole page to its top (its "top of document" special case for
/// an empty fragment), not just this canvas back to rest.
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

/// One drawn variant of an owner, independent of every other owner on the canvas. Where
/// `StateGroup` switches the whole canvas on one `:target`, a canvas can have many owners
/// whose variants move independently, and that product does not fit in one fragment. So a
/// variant declares its owner and its position as data, the owner's resting variant ships
/// visible, the rest ship hidden, and the host's inline hook flips them per owner on a key
/// press. Inside a plain `<img>` only the resting variants are visible: the built truth.
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

/// The rule key: a clickable face carrying the key's rules: one rule, or a
/// chord of rules folded as nested pairs (`Chord`, Dynamics.swift). Placing it is a
/// proof obligation: the key does not compile unless every leaf is a rule and the whole
/// chord shares one slot, so a drawn button can never name a press that does not stand.
/// The attribute lists the chord's leaves in declaration order. The host applies the ONE
/// whose pattern matches, or stands (§S30). Inert inside a plain `<img>`.
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
        // The leaf names out of a chord's cons: a `Chord` node splits at its top-level
        // comma and both halves return to the pile (right first, so declaration order
        // survives the pops). An `Exactly` leaf is spelled whole, spaces shed, because
        // the press supplies the atom and the atom travels with the press. Any other
        // leaf is named bare, its placeholder tail dropped. A stack walk, not a
        // helper: the witness remains one body.
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

/// The key that moves an owner to a position: a clickable face carrying the move as data.
/// The host's hook reads it and shows that owner's variant at the named position, hiding
/// its others. Emitted always, inert inside a plain `<img>`, the same floor `Linked` is on.
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

/// This reads a state's fragment address: `"#"` + `X`'s bare id, the one form `Linked`'s
/// `Target` wants. One atom, not two written by hand per state, the same reuse `SitePath<X>`
/// gives a real page address.
public enum FragmentOf<X: Structure>: Close {}
extension FragmentOf {
    public static var typeName: String { "#" + X.typeName }
}

// Notation supplies Unit, Plus, Twice, Times and Tally. The caller composes
// magnitudes from those constructors; the walk divides the supplied magnitudes.

/// A fraction is any pair of structures: the left side counts the numerator, the right side
/// the denominator. Nothing else exists to know about it.
public protocol Frac: Pair
where Left: Structure, Right: Structure {}
extension Paired: Frac
where L: Structure, R: Structure {}

/// The span vocabulary is spelled entirely as fractions. `GivenSpan` is a whole width over
/// one, a sum cross-multiplies, and a midpoint doubles the denominator around the origin.
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

/// SpanPx is the one reading: any fraction-pair in, digits out through its own `typeName`.
/// The left count over the right count, divided once, here, rounded to the whole pixel.
public enum SpanPx<S: Frac>: Close {}
extension SpanPx {
    public static var typeName: String {
        String((2 * S.Left.count + S.Right.count) / (2 * S.Right.count))
    }
}

/// Content that draws itself INTO a span it is handed, instead of owning a width: the shape
/// the divided axis asks of leaf art. A weighed part hands its slice down. A spanning
/// leaf fills it.
public protocol Spanning {
    static func rendered<X: Frac & Structure, W: Frac & Structure>(
        atX x: X.Type,
        width w: W.Type
    ) -> String
}

/// RowStart names the zero offset a walk begins at: nothing over one.
public typealias RowStart = Paired<
    Never,
    Unit
>

// THE DIVIDED AXIS — layout as the division of space (DESIGN21 v10). A canvas never
// states a number, a weight, or a position: it lists what is on the axis, in order.
// A fixed member takes its dictionary magnitude off the given whole, a space takes the
// policy's, and whatever remains belongs to the flexible members, equally. The rest is a
// lattice witness (`Rest`), counted only at the read, where taking too much is refused.
// The two axes are one mechanism turned, and a vertical axis with no flexible member HAS its
// own height — the sum of what its members take — so a canvas built of such axes derives
// its frame instead of stating it.

/// This is one member of a divided axis. `Taken` is the magnitude it removes from the
/// whole (its dictionary size, or nothing for a flexible member). `Stretch` counts it
/// among those sharing the remainder (`Unit`, or `Never` for a fixed one). The fold sums
/// both chains as types, with the read left to the edge.
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

/// This scales the free share by a count of flexible members: numerator times the count,
/// the fraction a run of stretchy neighbours spans together.
public typealias Stretched<
    Free: Frac,
    By: Structure
> = Paired<
    Times<Free.Left, By>,
    Free.Right
>

/// A fixed member takes content into a slice of its stated dictionary magnitude. The walk's
/// translate places it. Inside, it draws from local zero into its stated span.
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

/// RestAir is the stated empty remainder: the one member every axis under a given may end
/// with when nothing stretches: it owns whatever is left, draws nothing, and wraps
/// nothing. "The rest is empty," said in one word.
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

/// A space member takes the axis policy's magnitude and draws nothing.
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

/// A flexible member spans one share of whatever remains once every fixed
/// member and space took its magnitude.
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

/// The horizontal divided axis takes a given whole and members in order, no number anywhere. The
/// free share is the lattice's Rest over the count of stretchy members. An axis with
/// no flexible member leaves it unread.
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

/// This is the vertical word of the same axis: a member's `Taken` is the height it removes,
/// its `Stretch` counts it among those sharing the vertical remainder. One lexicon of
/// members serves both directions. The axis picks the conformance.
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

/// The vertical divided axis runs under a given height: members take their extents down the
/// page, flexible ones share the vertical remainder, and every member spans the width
/// handed across.
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

/// The grown canvas derives its own frame: width is the given, height is the sum of what the vertical
/// members take. The axis admits no flexible member (there is no remainder to share on an
/// axis that grows to fit), and no one states the frame: the axis IS the frame.
public protocol GrownDiagram: Open, StyleBound {
    associatedtype Across: Structure
    associatedtype AriaLabel: Structure
    /// Filters, styles, and other defs the canvas carries before its axis: not members,
    /// they take no height. `Never` by default: most canvases carry none.
    associatedtype Defs: Structure = Never
    /// The ground under the axis, painted before any member and taking no height. `Never` by
    /// default: a canvas ground is transparent (the design law), and a canvas whose content
    /// cannot all be on surfaces states `PageBackdrop` here instead.
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

/// This reads the equality of two magnitudes at the edge and branches there:
/// when the counts agree, the face renders. When they differ, nothing does.
/// Equality of magnitudes is decided no earlier than the reading, the same
/// edge a clamp or a tally is on, and a conjunction of equalities is the
/// nesting of this form inside itself.
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

/// This reads an order of two magnitudes at the edge and branches there: when
/// the first count reaches the second, the face renders. Short of it, nothing
/// does. With `Times` for cross-multiplication a ratio bound is the same
/// comparison (4.5:1 is nine to two), and a strict bound is this form with
/// one unit added to the bar. Thresholds of every kind are compositions of
/// this one door.
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

/// This reads a magnitude's parity at the edge and renders on even: the count
/// splits into pairs or it does not, and the face follows the split. With its
/// odd twin below, a fringe is a living reader of its gap: when the gap changes,
/// the parity follows the file, and no certificate goes stale.
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

/// The odd twin of ``EdgeEven``: renders when the count leaves one over.
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

/// This draws two spanning layers at the same origin and width: a background under its content,
/// a name over its chip. Order is depth, the way a body's order always is.
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

/// This face fills its slice: rounded, stroked, shadowed. Height is a stated token, the
/// vertical axis's word here. Width is the slice, read at the edge.
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

/// This text anchors at its slice's origin. The y and size are stated tokens, the
/// vertical axis's word here. The x derives.
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

/// This dot fills and centers in its slice. The vertical is a stated token, the height
/// axis's word here.
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

/// This reveals its content on a stated cue and hides it after a stated dwell: one frame
/// of a film, run by SVG's own clock (SMIL `set`, no script). A film is a sequence of
/// these with consecutive cues. The reader's browser executes the schedule, and the
/// artifact remains a pure composition.
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

/// This reveals its content on a stated cue and keeps it: a film's last frame, the fixed
/// point the sequence rests in. The freeze is the film's whole ending: nothing loops,
/// nothing runs, and the survivor is on screen for good.
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

/// Draws a centered disc with an SVG opacity animation.
/// Binding supplies the opacity sequence and duration; the host advances the timeline.
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

/// This wraps a live link around spanning content: the anchor spans whatever its content spans.
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

/// A rounded track filling its slice, and a fill weighed by the data itself: the filled part
/// carries the very structure it charts, the air carries the rest, and the house count does
/// the charting. A bar is a track, a data-weighed fill, a label at its start, a value at its
/// end.
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
/// Fills the slice with a rounded face and the referenced shadow filter.
/// The composition supplies height, radius and paint.
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
/// This wraps a spanning card in the hover affordance: the same lift class the keys carry,
/// base transform zero. The walk already placed the card. Hover only lifts it.
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
/// A structure hosted in a slice: the walk's translate places it, and inside it draws
/// from local zero, the same hospitality a column's `Band` extends. The door that puts whole
/// composed Content on a weighted row.
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
/// This label carries a budget: the same stated character ceiling `BudgetedLabel` enforces,
/// checked once at generate time, in span form.
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
/// This drops spanning content down by a stated token. The y axis
/// speaks in tokens here, and this is that door, named, in one place.
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
/// This draws a horizontal rule across its slice at a stated baseline: a timeline's track,
/// a divider. Binding supplies its stroke width.
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
/// This wraps spanning content in the fixed soft shadow, the same filter `Shadowed` reads.
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
/// This renders a slice-filling rect with a DASHED stroke: the preview's "not committed"
/// voice, the dash pattern stated here once.
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
/// This draws nothing and spans anything: the empty slot of a generic column.
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
/// This pairs an in-walk trigger with an absolutely drawn panel under one hover scope: the
/// same classes `HoverReveal` writes, for a trigger inside a slice.
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
/// This draws a solid flow arrow ACROSS its slice at a local baseline: tail on the slice's
/// start, head on its end. The gap between two neighbours IS the arrow. No position is stated.
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
/// The same arrow points LEFT here: head on the slice's start, for a dependency that points back.
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
/// This draws a solid flow arrow DOWN the page on its slice's middle, between two stated
/// baselines: the vertical stroke of a stacked flow.
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
/// This draws the italic caption voice at its slice's origin: an arrow's aside, a
/// difference worth a whisper. `TextSecondary` is the voice's one colour, stated here.
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
/// The italic caption voice anchors at its slice's MIDDLE here: the label of an arrow
/// between two boxes rather than beside one.
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
/// Fills Part over Whole of the handed width.
/// The composition supplies the counted structures, height, radius and paint.
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
/// One data segment of a stacked bar starts after the parts already laid (`Prefix`)
/// and spans its part, both as fractions of the whole over the handed width.
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
/// A label whose anchor is the MIDDLE of its slice: a key's digit, a column's title.
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
/// A label whose anchor is the END of its slice.
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

/// This pair draws a clip rounded to its slice, and the group that carries it: several
/// sharp-cornered pieces on a rounded track (a stacked bar's segments, each choosing its
/// fill) are still ONE rounded shape to the eye, not squared corners over the track's
/// rounding. The shape derives from the slice like everything else. Only the id is a name.
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
/// This renders a slice-filling rect with an outline: the segment whose tint alone does not draw its
/// edge.
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

/// These name the regular and the bold text weight, once, for span labels.

