import VerificationIsIdentification

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
// Vocabulary is exactly what today's artifacts need (§S8, no general solver), and it is
// three languages of one geometry: the DIVIDED AXIS (a row or column hands each member its
// slice and the remainder derives), the SPANS (leaves drawn into the slice they are handed),
// and the PEN (a path as constrained motion: straight until a named line, so corners
// derive). Every number a drawing speaks is a rung of the dictionary (Design.swift) or a
// magnitude of the lattice, read through `Tally`, `SpanPx`, `Halfway`, `Under`; the stated
// remainders are named holes (text baselines, glyph art), each argued where it stands.
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
// pixels never promised. Text metrics: glyph width is the platform font's;
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
/// `@StructureBuilder` folded (a left-nested `Paired` chain), so a reader (VectorDemo's
/// decompiler, a driver-level, value-level concern; this medium only carries the marker and,
/// per canvas, the small `{ }` chip built from existing atoms: `GlyphRect`, `Label`,
/// `Linked`) can read that SAME type back through `String(reflecting: Body.self)` and print it.
/// Nothing here can drift from what compiled, because nothing here is a second copy of it.
public protocol SelfShowing {}

/// This is several drawn pieces, composed through `body` into one: the SVG-medium counterpart of
/// `Fragment` (Organization/View/Screen.swift), local here since DocumentKit does not depend on
/// Organization. A canvas's `Content` hole is usually one of these.
public protocol Group: Open {}

/// This is the SVG root, like `Screen`/`Reference`, but the medium is source text, not markdown.
/// The canvas frame reads its viewBox off the same structures the rows slice: width and
/// height are counts, digits born here, at the edge, like every other reading.
public enum CanvasSize<W: Structure, H: Structure>: Close {}
extension CanvasSize {
    public static var typeName: String { "0 0 \(W.count) \(H.count)" }
}

public protocol Diagram: Open {
    associatedtype Size: Structure
    associatedtype AriaLabel: Structure
    associatedtype Content: Structure
}
extension Diagram {
    public static var typeName: String {
        // `data-vi-canvas="1"` — every canvas declares ITSELF, so the host needs no separate
        // name list to keep in sync by hand: a second list (footer.html's `WHITELIST`) is
        // exactly the kind of bookkeeping this medium's `body`/`typeName` discipline exists
        // to make unnecessary, and a name missing from it renders untheme'd with no error. A
        // marker on the root the canvas ALREADY emits needs no second list at all.
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"\(Size.typeName)\" role=\"img\" "
            + "data-vi-canvas=\"1\" "
            + "font-family=\"\(FontStack.typeName)\" aria-label=\"\(AriaLabel.typeName)\">\n"
            + Content.typeName + "\n</svg>\n"
    }
}

/// This is a rounded panel, corner-radius 12: the diagram's boxes.
public protocol Shape: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Fill: Structure
}
extension Shape {
    public static var typeName: String {
        "<rect x=\"\(X.typeName)\" y=\"\(Y.typeName)\" width=\"\(W.typeName)\" height=\"\(H.typeName)\" "
            + "rx=\"12\" fill=\"\(Fill.typeName)\"/>\n"
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
        "<rect width=\"\(W.typeName)\" height=\"\(H.typeName)\" fill=\"\(Fill.typeName)\"/>\n"
    }
}

/// This is a rounded panel at the origin: the avatar's full-bleed background (radius 16, the one
/// place a full-bleed panel is rounded).
public protocol RoundedFullBleedRect: Open {
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Fill: Structure
}
extension RoundedFullBleedRect {
    public static var typeName: String {
        "<rect width=\"\(W.typeName)\" height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\" fill=\"\(Fill.typeName)\"/>\n"
    }
}

/// This is `RoundedFullBleedRect` plus a border, the dark theme's surface treatment: a `SurfaceCard`
/// panel drops its shadow in the dark theme and gains a thin `LineRole` edge instead, so a flat
/// dark fill still reads as a distinct panel against the page. The stroke is drawn in BOTH
/// themes, at whichever value the role resolves to, pale enough against a light ground to read
/// This is the italic annotation of a stated drawing: an arrow bundle's label, offset clear of
/// its lines. Its coordinates are the route-data class (a drawing's own facts, stated once,
/// never derived — the same law GlyphAtlas and DiagramGeometry live under), which is why this
/// combinator keeps X where the axis world derives it. Only the gate and architecture
/// diagrams draw one, so its colour is the `TextSecondary` role, not a flat hex.
public protocol ItalicLabel: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Anchor: Structure
    associatedtype Size: Structure
    associatedtype Content: Structure
}
extension ItalicLabel {
    public static var typeName: String {
        "<text x=\"\(X.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"\(Anchor.typeName)\" "
            + "fill=\"\(TextSecondary.typeName)\" font-size=\"\(Size.typeName)\" font-style=\"italic\">\(Content.typeName)</text>\n"
    }
}

// ═══ THE PEN — drawing as constrained motion. A path is not a list of stated points: it
// is a start and a chain of moves, each move running straight UNTIL a named line — the
// stopping condition is a rung of the dictionary, so the endpoint DERIVES, and the free
// part of the drawing is exactly what the constraints leave free. Horizontal position is
// a fraction of the surface (read through `SpanPx`, the row's own coordinate language);
// vertical position is a magnitude (read by count). A diagonal is `SlideTo`: a straight
// line to a point both of whose coordinates already derive. Any arrow eats a pen chain
// whole — the chain's `typeName` IS the path's `d`. ═══

/// This is a position under the pen: where it stands after the moves so far. Every move
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
        "M\(SpanPx<X>.typeName),\(Y.count)"
    }
}

/// This runs the pen straight until the named horizontal line: the vertical move, its
/// direction implied by where the line stands, its endpoint derived, not stated.
public enum UntilY<
    Prev: Pen,
    Line: Structure
>: Close {}
extension UntilY: Pen {
    public typealias AtX = Prev.AtX
    public typealias AtY = Line
    public static var typeName: String {
        "\(Prev.typeName) L\(SpanPx<Prev.AtX>.typeName),\(Line.count)"
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
        "\(Prev.typeName) L\(SpanPx<Line>.typeName),\(Prev.AtY.count)"
    }
}

/// This slides the pen to a point whose two coordinates both derive: the diagonal. The
/// medium solves no angled intersections (that would take roots); it connects points the
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
        "\(Prev.typeName) L\(SpanPx<X>.typeName),\(Y.count)"
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
/// the stated font's own advances (GeneratedFontMetrics, spelled from Assets' Inter file
/// by `swift run Tools generate font`). The canvas contract keeps its caveat — a fallback
/// font approximates — so the measure serves generous boxes and honest gates: it may
/// over-provide, never under. A character outside the table measures as an "m".
public enum TextWidth<
    Content: Structure,
    TextSize: Structure
>: Close {}
extension TextWidth {
    public static var count: Int {
        var advances: [Int: Int] = [:]
        for pair in FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(FontUnitsPerEm.typeName) ?? 2048
        let size = Int(TextSize.typeName) ?? 0
        let fallback = advances[109] ?? units / 2
        let total = Content.typeName.unicodeScalars.reduce(0) { sum, scalar in
            sum + (advances[Int(scalar.value)] ?? fallback)
        }
        return (total * size + units - 1) / units
    }
}

/// This is the measured gate on a centred label: the words must fit the width the slice
/// hands over, and a text that outgrows its box refuses at generation, loudly, naming
/// itself — the same floor a crashed generator already is, now standing under every fitted
/// label instead of a reviewer's eye.
public protocol SpanLabelMidFitted: Spanning {
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
        let measured = TextWidth<Content, Size>.count
        let given = (2 * W.Left.count + W.Right.count) / (2 * W.Right.count)
        precondition(
            measured <= given,
            "SpanLabelMidFitted overflow in \(Self.self): \"\(Content.typeName)\" measures \(measured)px, the slice hands \(given)px"
        )
        return "<text x=\"\(SpanPx<MidOf<X, W>>.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"middle\" "
            + "fill=\"\(FillColor.typeName)\" font-weight=\"\(Weight.typeName)\" "
            + "font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
    }
}

/// This is the centred baseline, derived: where text of a size sits to stand visually
/// centred in a zone — the zone's middle plus half the font's own capital height, rounded
/// to the nearest pixel. The centred class of baselines stops being stated with this;
/// stacked lines (a title over a subtitle) remain stated, being design choices, not
/// centrings.
public enum CenteredBaseline<
    ZoneTall: Structure,
    TextSize: Structure
>: Close {}
extension CenteredBaseline {
    public static var typeName: String {
        let units = Int(FontUnitsPerEm.typeName) ?? 2048
        let cap = Int(FontCapHeight.typeName) ?? 0
        let size = Int(TextSize.typeName) ?? 0
        return String((ZoneTall.count * units + cap * size + units) / (2 * units))
    }
}

/// This is the wrapped centred label: the words fill measured lines within the width the
/// slice hands over, breaking greedily by the same measure the fitted gate reads, each
/// line one stated pitch below the last. Wrapping earns lines, never truncation: a single
/// word wider than the slice still refuses, loudly. The advance-table parse repeats
/// `TextWidth`'s by law — a value helper has no lawful home outside a witness body.
public protocol SpanLabelMidWrapped: Spanning {
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
        for pair in FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(FontUnitsPerEm.typeName) ?? 2048
        let size = Int(Size.typeName) ?? 0
        let fallback = advances[109] ?? units / 2
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
            "<text x=\"\(SpanPx<MidOf<X, W>>.typeName)\" y=\"\(base + pitch * index)\" text-anchor=\"middle\" "
                + "fill=\"\(FillColor.typeName)\" font-weight=\"\(Weight.typeName)\" "
                + "font-size=\"\(Size.typeName)\">\(text)</text>\n"
        }.joined()
    }
}

/// The wrapped label anchored at the START of its slice: the sheet's own voice, the same
/// greedy measured break the centred twin makes, each line one stated pitch below the
/// last. Wrapping earns lines, never truncation, and a single word wider than the slice
/// refuses loudly. The advance-table parse repeats `TextWidth`'s by law — a value helper
/// has no lawful home outside a witness body.
public protocol SpanLabelWrapped: Spanning {
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
        for pair in FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(FontUnitsPerEm.typeName) ?? 2048
        let size = Int(Size.typeName) ?? 0
        let fallback = advances[109] ?? units / 2
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
            "<text x=\"\(SpanPx<X>.typeName)\" y=\"\(base + pitch * index)\" text-anchor=\"start\" "
                + "fill=\"\(FillColor.typeName)\" font-weight=\"\(Weight.typeName)\" "
                + "font-size=\"\(Size.typeName)\">\(text)</text>\n"
        }.joined()
    }
}

/// The line count of a wrapped text as a type: how many measured lines the content
/// breaks into across a STATED width. The width is a dictionary rung, so the count
/// stands before any slice is handed over and a sheet's band may size itself as
/// `Times<LinePitch, LineTally<…>>` — keep the drawing's slice the same rung, or the
/// measure lies. The break repeats the wrapped labels' own, by the same law that
/// denies a value helper a home outside a witness body.
public enum LineTally<
    Content: Structure,
    Wide: Structure,
    Size: Structure
>: Close {}
extension LineTally {
    public static var typeName: String { String(count) }
    public static var count: Int {
        var advances: [Int: Int] = [:]
        for pair in FontAdvanceTable.typeName.split(separator: " ") {
            let parts = pair.split(separator: ":")
            if parts.count == 2, let code = Int(parts[0]), let width = Int(parts[1]) {
                advances[code] = width
            }
        }
        let units = Int(FontUnitsPerEm.typeName) ?? 2048
        let size = Int(Size.typeName) ?? 0
        let fallback = advances[109] ?? units / 2
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
/// (a midpoint of magnitudes), for annotations that stand between.
public enum Halfway<
    A: Structure,
    B: Structure
>: Close {}
extension Halfway {
    public static var typeName: String {
        String((A.count + B.count) / 2)
    }
}

/// This is a dashed dependency arrow: every arrow "written in its types" makes, back to V=I.
public protocol DashedArrow: Open {
    associatedtype Path: Structure
}
extension DashedArrow {
    public static var typeName: String {
        "<path d=\"\(Path.typeName)\" stroke=\"\(TextSecondary.typeName)\" stroke-width=\"\(ArrowWidth.typeName)\" stroke-dasharray=\"\(DependencyDash.typeName)\" "
            + "fill=\"none\" marker-end=\"url(#\(ArrowHeadName.typeName))\"/>\n"
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
        "<g transform=\"translate(0, \(Y.typeName))\">\n" + Content.typeName + "</g>\n"
    }
}

/// This is a drop with a uniform scale: the one hook a canvas needs to reuse ANOTHER canvas's
/// glyph at a different size (a person card's small avatar disc, drawn from the SAME
/// `AvatarShapes` the full-size avatar canvas already draws, not a second, redrawn-smaller
/// copy of the same two shapes).
public protocol PlacedScaled: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype Scale: Structure
    associatedtype Content: Structure
}
extension PlacedScaled {
    public static var typeName: String {
        "<g transform=\"translate(\(X.typeName),\(Y.typeName)) scale(\(Scale.typeName))\">\n" + Content.typeName + "</g>\n"
    }
}

// ── DESIGN11/12 — the space gate (prototype, one canvas). A coordinate atom's VALUE (its
// `typeName` string) is never checked against a canvas's bounds — nothing here proves
// `X + W <= CanvasWidth`. The natural fix, a generic `AtMost<A, B>` Peano `≤` via recursive
// conditional conformance, hits the SAME wall the contrast gate did (SurfaceLaw §S25): Swift
// refuses a second conditional conformance of one generic pair type to one protocol, so the
// base case and the inductive step cannot both be written as conformances of the same `AtMost`.
// Checked directly — an isolated two-extension probe reproduces the identical
// "conflicting conformance" error `On<Fg, Bg>: Legible` gave.
//
// The move that DOES work is the same one the contrast gate found: route through the CASE'S OWN
// identity, not a shared generic pair. `WithinBounds` is the FLOOR every canvas marker
// refines — `Paint`'s own role relative to `LegibleOnInk` and its siblings, not a thing granted
// directly. A canvas's legal positions are a small, closed, ENUMERATED set (`CycleNodeX1`…`X4`,
// not "any integer"), and its own marker (`WithinCyclesHero`, CyclesHero.swift — the reference
// instance) is granted, unconditionally, only to the coordinate atoms THAT canvas's author has
// checked fit — an ungranted value is not rejected by a computed comparison, it is never
// GRANTED, the illegal-state-unrepresentable move (ReviewCycle.swift's "the next state does not
// exist until") applied to geometry.
//
// DESIGN12 §3 — a first draft of this file left `WithinBounds` itself doing the granting, which
// over-promises: a grant is a fact about the ATOM, GLOBAL and permanent (`extension N100:
// WithinBounds {}` reads as legal everywhere `WithinBounds` is asked for, on any canvas, not
// scoped to the one that checked it) — the same way granting `Paper: LegibleOnInk` is a global
// fact about `Paper`, not a per-call-site promise. The floor stays shared; what must NOT be
// shared is the thing that actually gets CHECKED (a drop whose vertical is
// bound). That belongs to each canvas, declared locally — `CyclesLowered` (CyclesHero.swift)
// requires `X`/`Y`: `WithinCyclesHero`, not the bare floor, so a position only ONE canvas
// vetted cannot satisfy a DIFFERENT canvas's placement by accident. No shared `GriddedPlaced`
// lives here for that reason — copying its four lines per canvas is the cost of the guarantee
// actually holding; at a second canvas the pattern above is already the right shape to repeat.
public protocol WithinBounds: Structure {}   // law:allow — the §S25 floor: a per-case grant certificate, conformance IS the vetting, refined per canvas as the comment above states

/// This wraps a subtree in a real link. `Target` is a page path from the site's closed set of
/// addresses (the same universe `<doc:…>` links resolve into: `/documentation/organization/…`),
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
        "<a href=\"\(Target.typeName)\">\n" + Content.typeName + "</a>\n"
    }
}

/// This is the one shared rule every lifted group reads, declared once per canvas that uses them.
public enum HoverStyle: Close {}
extension HoverStyle {
    public static var typeName: String {
        """
        <style>
        .hover-lift { transform: translate(var(--tx), var(--ty)); transition: transform 150ms ease; cursor: pointer; }
        .hover-lift:hover { transform: translate(var(--tx), calc(var(--ty) - 2px)); }
        </style>

        """
    }
}

/// This is a trigger that reveals a panel on hover: "the diagram explaining itself." Both
/// halves sit inside a common wrapper (`.hover-pair`) so the CSS sibling rule below stays scoped
/// to THIS pair. Without that wrapper, a `.hover-trigger:hover ~ .hover-panel` selector would
/// match every panel on the whole canvas, not just its (checked directly: two ungrouped
/// pairs cross-lit each other's panels). The panel is a dose of DOP-INFO, not the only copy of
/// what it says (§S8's floor for a progressive-enhancement atom): it holds no fact a plain
/// reading of the canvas lacks, only a closer one. Works only where the inline-swap hook has
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

/// This is a small mark meaning "hover this," placed once at each `HoverReveal` trigger's corner
/// so the affordance is visible before a reader happens to find it by accident, the same
/// discipline a `SelfShowing` canvas's `{ }` chip already gives (a hoverable/clickable
/// surface should say so, not rely on a reader's cursor wandering over it). `CX`/`CY` is the one
/// This is a stroke that reads as clickable and answers hover with emphasis (a flow
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
/// open, and the close is a GRACE WINDOW, not an instant: `visibility` flips only 400ms after
/// the pointer leaves, so the traverse from trigger to panel survives the gap between them.
/// `pointer-events` is deliberately absent: it is not animatable, so toggling it would end
/// interactivity the instant the trigger's `:hover` drops, killing the traverse. In SVG,
/// `visibility: hidden` already withholds pointer events (`visiblePainted`), and visibility IS
/// The affordance dot's one radius: the small blue "there is more here" marker every
/// hoverable box wears, sized once.
public enum HoverAffordanceRadius: Close {}
extension HoverAffordanceRadius {
    public static var typeName: String { "5" }
}

/// delayable. The open is instant (`transition-delay: 0s` on the matched rule).
public enum HoverRevealStyle: Close {}
extension HoverRevealStyle {
    public static var typeName: String {
        """
        <style>
        .hover-pair .hover-panel { opacity: 0; visibility: hidden; transition: opacity 150ms ease 250ms, visibility 0s linear 400ms; }
        .hover-pair .hover-trigger { cursor: pointer; }
        .hover-pair .hover-trigger:hover ~ .hover-panel, .hover-pair .hover-panel:hover { opacity: 1; visibility: visible; transition-delay: 0s; }
        .hover-highlight { transition: stroke 150ms ease, stroke-width 150ms ease; cursor: pointer; }
        .hover-highlight:hover { stroke: \(AccentRole.typeName); stroke-width: 3; }
        </style>

        """
    }
}

/// This reads a type's Swift name, lowercased: the URL slug DocC's static-hosting build assigns each
/// page (`CompanyDashboard` renders at `.../companydashboard`), read the same mechanical way
/// `RawName` reads a symbol's bare identifier (Markup.swift), not restated by hand. A caller
/// builds a real site path from a page TYPE with this plus its base path, the way `Linked`'s
/// targets are meant to be built, not a string someone has to keep in sync with the symbol.
public enum PageSlug<X>: Close {}
extension PageSlug {
    public static var typeName: String { String(describing: X.self).lowercased() }
}

/// This is a bare rounded rect inside a tinted group: no fill of its, colour comes from the
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
        "<rect x=\"\(X.typeName)\" y=\"\(Y.typeName)\" width=\"\(W.typeName)\" height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\"/>\n"
    }
}

/// This is `GlyphRect` plus a border, `RoundedFullBleedRectStroked`'s same move, sized to a small
/// glyph instead of a full-bleed panel: a swatch whose fill might legitimately match
/// whatever it sits on (RolesPlate's "Card" swatch, on a Card-coloured backing) still reads
/// as a shape in its right.
public protocol GlyphRectStroked: Open {
    associatedtype X: Structure
    associatedtype Y: Structure
    associatedtype W: Structure
    associatedtype H: Structure
    associatedtype Radius: Structure
    associatedtype Stroke: Structure
}
extension GlyphRectStroked {
    public static var typeName: String {
        "<rect x=\"\(X.typeName)\" y=\"\(Y.typeName)\" width=\"\(W.typeName)\" height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\" "
            + "fill=\"none\" stroke=\"\(Stroke.typeName)\" stroke-width=\"\(HairlineWidth.typeName)\"/>\n"
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
        "<circle cx=\"\(CX.typeName)\" cy=\"\(CY.typeName)\" r=\"\(R.typeName)\"/>\n"
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
        "<path d=\"\(D.typeName)\"/>\n"
    }
}

/// This is a bare path whose stroke is thicker than the group around it (Board's three connectors,
/// width 6 against the group's inherited 9).
public protocol GlyphPathThick: Open {
    associatedtype D: Structure
}
extension GlyphPathThick {
    public static var typeName: String {
        "<path d=\"\(D.typeName)\" stroke-width=\"6\"/>\n"
    }
}

/// This is a path that carries its full stroke rather than inheriting one, a sibling of a tinted
/// group, not a child of it (Reports' baseline, drawn after the bars it marks). `Stroke` is a
/// `CardPalette`'s `Glyph` (mechanism A): the only consumer, `Cards.swift`, is a
/// grid-tile context, driven twice (light/dark) at the driver's edge, not a CSS role.
public protocol StandaloneStrokedPath: Open {
    associatedtype Stroke: Paint
    associatedtype D: Structure
}
extension StandaloneStrokedPath {
    public static var typeName: String {
        "<path d=\"\(D.typeName)\" \(GlyphStroke<Stroke>.typeName)/>\n"
    }
}

/// This is a group tinted by fill: every glyph drawn as solid shapes (Dashboard's tiles, Reports'
/// bars, the avatar's silhouette).
public protocol FilledGroup: Open {
    associatedtype Fill: Structure
    associatedtype Content: Structure
}
extension FilledGroup {
    public static var typeName: String {
        "<g fill=\"\(Fill.typeName)\">\n" + Content.typeName + "</g>\n"
    }
}

/// This is `FilledGroup` plus a CSS class: the one hook a purely declarative canvas needs to let a
/// `<style>` atom (elsewhere in the SAME file, a `@keyframes` rule the class names) reach in and
/// animate something, the same edge `HoverReveal`'s `.hover-trigger`/`.hover-panel` classes
/// already stand on. Still no runtime: the class and the rule are both compiled text. What plays
/// is CSS's animation clock, not a script.
public protocol FilledGroupClassed: Open {
    associatedtype Class: Structure
    associatedtype Fill: Structure
    associatedtype Content: Structure
}
extension FilledGroupClassed {
    public static var typeName: String {
        "<g class=\"\(Class.typeName)\" fill=\"\(Fill.typeName)\">\n" + Content.typeName + "</g>\n"
    }
}

/// This is a clip region, named: several sharp-cornered pieces (a stacked bar's segments, each
/// a `Fill` each chooses, so a shared rounded-rect wrapper cannot carry all their colours at once)
/// sitting on a rounded track still need to read as ONE rounded shape, not squared-off corners
/// hiding the track's rounding entirely underneath them. `Shape` is `Structure`, not a fixed
/// This is a group tinted by stroke, width 9: every glyph drawn as outlines (Employees' figures,
/// Departments' org chart, Documents' page, Tasks' checkmarks, Directories' rows, Cycles'
/// arrows, Board's columns). `Stroke` is a `CardPalette`'s `Glyph`, see
/// `StandaloneStrokedPath`.
public protocol StrokedGroup: Open {
    associatedtype Stroke: Paint
    associatedtype Content: Structure
}
extension StrokedGroup {
    public static var typeName: String {
        "<g \(GlyphStroke<Stroke>.typeName)>\n" + Content.typeName + "</g>\n"
    }
}

/// This is the stroke convention every outline glyph uses: width 9, rounded caps and joins, no
/// fill, declared once, read by `StrokedGroup` and `StandaloneStrokedPath`. Generic over its
/// colour (`C`) since the cards' glyph colour is now a `CardPalette` choice (mechanism
/// A: the same composition driven twice, light and dark) rather than a fixed `Ink`.
public enum GlyphStroke<
    C: Paint
>: Close {}
extension GlyphStroke {
    public static var typeName: String {
        "stroke=\"\(C.typeName)\" stroke-width=\"9\" stroke-linecap=\"round\" stroke-linejoin=\"round\" fill=\"none\""
    }
}

/// The two markers both arrow kinds reuse, declared once per canvas that draws arrows.
public enum ArrowMarkers: Close {}
extension ArrowMarkers {
    public static var typeName: String {
        """
        <defs>
        <marker id="\(ArrowHeadName.typeName)" markerWidth="9" markerHeight="9" refX="5" refY="3" orient="auto">
        <path d="M0,0 L6,3 L0,6 Z" fill="\(TextSecondary.typeName)"/>
        </marker>
        </defs>

        """
    }
}

// THE STATE SWITCH — a canvas's own walk, read by `:target`, not a second page per position
// (DESIGN19 §2). A fragment link (`Linked`, above) already reaches an id anywhere in the
// document; `StateGroup` gives that id a group to hide until it is the current one, and
// `StateSwitchStyle` gives the whole canvas its resting position, the state nothing else
// has targeted yet. Checked directly, in an actual inlined SVG (DESIGN19 §4 probes 1-2):
// `:target` switches a sibling group, and `svg:not(:has(.vi-state:target)) #k0` is exactly
// the fallback CSS `:has()` makes possible. Inert inside a plain `<img>` (DocC's own
// fallback), the same progressive floor `Linked`'s click already stands on.

/// This is one addressable position in a canvas's walk: hidden until `Id` is the page's
/// current fragment. `Id` is the BARE name (`"k0"`, the `<g id="...">` the browser matches
/// against); a caller reaches it through `Linked`, whose `Target` wants the `"#"`-prefixed
/// form instead (``FragmentOf``, below reads one from the other).
public protocol StateGroup: Open {
    associatedtype Id: Structure
    associatedtype Content: Structure
}
extension StateGroup {
    public static var typeName: String {
        "<g id=\"\(Id.typeName)\" class=\"vi-state\">\n" + Content.typeName + "</g>\n"
    }
}

/// This is the one shared rule every `StateGroup` reads: hidden unless `:target`, and
/// `DefaultId` shown when NOTHING has been targeted yet, `:has()` read against the canvas's
/// sibling groups, not a script (checked directly, DESIGN19 §4 probe 2). A reset link should
/// name a REAL state's id (`"#k0"`), never the bare empty fragment `"#"`: checked directly, a
/// bare `#` scrolls the whole page to its top (the browser's "top of document" special case for
/// an empty fragment), not just this canvas back to rest.
public enum StateSwitchStyle<DefaultId: Structure>: Close {}
extension StateSwitchStyle {
    public static var typeName: String {
        """
        <style>
        .vi-state { display: none; }
        .vi-state:target { display: inline; }
        svg:not(:has(.vi-state:target)) #\(DefaultId.typeName) { display: inline; }
        </style>

        """
    }
}

/// One drawn variant of an owner, independent of every other owner on the canvas. Where
/// `StateGroup` switches the whole canvas on one `:target`, a canvas can carry many owners
/// whose variants move independently, and one fragment cannot hold that product. So a
/// variant declares its owner and its position as data, the owner's resting variant ships
/// visible, the rest ship hidden, and the host's inline hook flips them per owner on a key
/// press. Inside a plain `<img>` the resting variants stand alone: the built truth.
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
        "<g class=\"vi-variant\" data-vi-owner=\"\(Owner.typeName)\" data-vi-at=\"\(Position.typeName)\""
            + (ShownAtRest.typeName == "1" ? "" : " style=\"display:none\"")
            + ">\n" + Content.rendered(atX: x, width: w) + "</g>\n"
    }
}

/// The rule key: a clickable face carrying what a key may stand on — one rule, or a
/// chord of rules folded as nested pairs (`Chord`, Dynamics.swift). Placing it is a
/// proof obligation: the key does not compile unless every leaf is a rule and the whole
/// chord shares one slot, so a drawn button can never name a press that does not stand.
/// The attribute lists the chord's leaves in declaration order; the host applies the ONE
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
        // The leaf names out of a chord's cons: `Chord` nodes recurse, anything else
        // is a leaf named bare, its generic tail dropped.
        func leaves(of term: Substring) -> [String] {
            let text = term.trimmingCharacters(in: .whitespaces)
            guard text.hasPrefix("Chord<"), text.hasSuffix(">") else {
                return [String(text.split(separator: "<").first ?? "")]
            }
            let inner = text.dropFirst("Chord<".count).dropLast()
            var depth = 0
            for (offset, character) in inner.enumerated() {
                if character == "<" { depth += 1 }
                if character == ">" { depth -= 1 }
                if character == ",", depth == 0 {
                    let cut = inner.index(inner.startIndex, offsetBy: offset)
                    return leaves(of: inner[inner.startIndex..<cut])
                        + leaves(of: inner[inner.index(after: cut)...])
                }
            }
            return [String(inner.split(separator: "<").first ?? "")]
        }
        let names = leaves(of: Substring(String(describing: R.self))).joined(separator: " ")
        return "<g class=\"vi-rule\" data-vi-rules=\"\(names)\" data-vi-slot=\"\(String(describing: R.Slot.self))\" cursor=\"pointer\">\n"
            + Face.rendered(atX: x, width: w) + "</g>\n"
    }
}

/// The key that moves an owner to a position: a clickable face carrying the move as data.
/// The host's hook reads it and shows that owner's variant at the named position, hiding
/// its others. Emitted always, inert inside a plain `<img>`, the same floor `Linked` stands on.
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
        "<g class=\"vi-variant-key\" data-vi-owner=\"\(Owner.typeName)\" data-vi-to=\"\(Position.typeName)\" cursor=\"pointer\">\n"
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

// THE MAGNITUDES live in the lattice's engine room now (VerificationIsIdentification,
// Primitive.swift): Unit, Plus, Twice, Times, and Tally, the counting read. The design
// system's ladder (Design.swift) names the rungs; the walk below only ever slices them.

/// A fraction is any pair of structures: the left side counts the numerator, the right side
/// the denominator. Nothing else exists to know about it.
public protocol Frac: Pair
where Left: Structure, Right: Structure {}
extension Paired: Frac
where L: Structure, R: Structure {}

/// The span vocabulary is spelled entirely as fractions. `GivenSpan` is a whole width over
/// one; a sum cross-multiplies; a midpoint doubles the denominator around the origin.
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
/// v5 asks of leaf art. A weighed part hands its slice down; a spanning leaf fills it.
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
// states a number, a weight, or a position: it lists what stands on the axis, in order.
// A fixed member takes its dictionary magnitude off the given whole; a space takes the
// policy's; whatever remains belongs to the flexible members, equally. The rest is a
// lattice witness (`Rest`), counted only at the read, where taking too much is refused.
// The two axes are one mechanism turned; a vertical axis with no flexible member HAS its
// own height — the sum of what its members take — so a canvas built of such axes derives
// its frame instead of stating it.

/// This is one member of a divided axis. `Taken` is the magnitude it removes from the
/// whole (its dictionary size, or nothing for a flexible member); `Stretch` counts it
/// among those sharing the remainder (`Unit`, or `Never` for a fixed one). The fold sums
/// both chains the way `FoldW` once did: as types, with the read left to the edge.
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
/// translate places it; inside, it draws from local zero into its stated span.
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
        "<g transform=\"translate(\(SpanPx<X>.typeName), 0)\">\n"
            + Content.rendered(atX: RowStart.self, width: GivenSpan<W>.self)
            + "</g>\n"
    }
}

/// RestAir is the stated empty remainder: the one member every axis under a given may end
/// with when nothing stretches — it owns whatever is left, draws nothing, and wraps
/// nothing. "The rest stays empty," said in one word.
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
        "<g transform=\"translate(\(SpanPx<X>.typeName), 0)\">\n"
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
/// free share reads as the lattice's Rest over the count of stretchy members; an axis with
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
/// members serves both directions; the axis picks the conformance.
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
        "<g transform=\"translate(0, \(SpanPx<Y>.typeName))\">\n"
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
        "<g transform=\"translate(0, \(SpanPx<Y>.typeName))\">\n"
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
/// members take. No flexible member can stand here (there is no remainder to share on an
/// axis that grows to fit), and no one states the frame: the axis IS the frame.
public protocol GrownDiagram: Open {
    associatedtype Across: Structure
    associatedtype AriaLabel: Structure
    /// Filters, styles, and other defs the canvas carries before its axis: not members,
    /// they take no height. `Never` by default: most canvases carry none.
    associatedtype Defs: Structure = Never
}
extension GrownDiagram
where Body: DividesY & Structure {
    public static var typeName: String {
        precondition(
            Body.Stretch.count == 0,
            "A grown axis has no remainder to share: \(Self.self) grows to fit its members, so a flexible member cannot stand here."
        )
        return "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 \(Across.count) \(Body.Taken.count)\" role=\"img\" "
            + "data-vi-canvas=\"1\" font-family=\"Inter, Roboto, system-ui, sans-serif\" "
            + "aria-label=\"\(AriaLabel.typeName)\">\n"
            + Defs.typeName
            + Body.rendered(
                atY: RowStart.self,
                width: GivenSpan<Across>.self,
                free: Paired<Never, Unit>.self
            )
            + "</svg>\n"
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

/// This face fills its slice: rounded, stroked, shadowed. Height stays a given token
/// until the vertical axis migrates; width is the slice, read at the edge.
public protocol SpanCardFace: Spanning {
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
            + "<rect x=\"\(SpanPx<X>.typeName)\" width=\"\(SpanPx<W>.typeName)\" height=\"\(H.typeName)\" "
            + "rx=\"\(Radius.typeName)\" fill=\"\(Fill.typeName)\" stroke=\"\(Stroke.typeName)\" stroke-width=\"\(HairlineWidth.typeName)\"/>\n"
            + "</g>\n"
    }
}

/// This text anchors at its slice's origin. The y and size stay given tokens until the
/// vertical axis migrates; the x derives.
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
        "<text x=\"\(SpanPx<X>.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"start\" "
            + "fill=\"\(FillColor.typeName)\" font-weight=\"\(Weight.typeName)\" "
            + "font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
    }
}

/// This dot fills and centers in its slice. The vertical stays a token until the height axis
/// migrates.
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
        "<circle cx=\"\(SpanPx<MidOf<X, W>>.typeName)\" cy=\"\(CY.typeName)\" "
            + "r=\"\(R.typeName)\" fill=\"\(Fill.typeName)\"/>\n"
    }
}

/// This reveals its content on a stated cue and hides it after a stated dwell: one frame
/// of a film, run by SVG's own clock (SMIL `set`, no script). A film is a sequence of
/// these with consecutive cues; the reader's browser executes the schedule, and the
/// artifact stays a pure composition.
public enum TimedReveal<
    Begin: Structure,
    Dwell: Structure,
    Content: Structure
>: Close {}
extension TimedReveal {
    public static var typeName: String {
        "<g opacity=\"0\"><set attributeName=\"opacity\" to=\"1\" "
            + "begin=\"\(Begin.typeName)s\" dur=\"\(Dwell.typeName)s\"/>\n"
            + Content.typeName + "</g>\n"
    }
}

/// This reveals its content on a stated cue and keeps it: a film's last frame, the fixed
/// point the sequence rests in. The freeze is the film's whole ending — nothing loops,
/// nothing runs, the survivor stays on screen.
public enum FrozenReveal<
    Begin: Structure,
    Content: Structure
>: Close {}
extension FrozenReveal {
    public static var typeName: String {
        "<g opacity=\"0\"><set attributeName=\"opacity\" to=\"1\" "
            + "begin=\"\(Begin.typeName)s\" fill=\"freeze\"/>\n"
            + Content.typeName + "</g>\n"
    }
}

/// This dot breathes: the same centered disc a ``SpanDot`` places, carrying SVG's own
/// declarative clock — opacity swings once every four seconds, forever (SMIL, the
/// medium's stated timeline, no script). Time lives in the reader's browser, never in
/// the artifact: the animation is a child element of the circle, and the drawing stays
/// a pure composition. The voice is for one fact per canvas: a claim that is re-proved
/// by every build may breathe, wallpaper may not.
public protocol SpanBreathingDot: Spanning {
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
        "<circle cx=\"\(SpanPx<MidOf<X, W>>.typeName)\" cy=\"\(CY.typeName)\" "
            + "r=\"\(R.typeName)\" fill=\"\(Fill.typeName)\">"
            + "<animate attributeName=\"opacity\" values=\"1;0.55;1\" dur=\"4s\" "
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
        "<a href=\"\(Target.typeName)\">\n"
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
        "<rect x=\"\(SpanPx<X>.typeName)\" width=\"\(SpanPx<W>.typeName)\" height=\"\(H.typeName)\" "
            + "rx=\"\(Radius.typeName)\" fill=\"\(Fill.typeName)\"/>\n"
    }
}
/// This face carries the accent panel: the one hero a screen may carry. The accent never goes flat
/// in the dark theme, so its shadow is the fixed soft one, and it wears no edge.
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
            + "<rect x=\"\(SpanPx<X>.typeName)\" width=\"\(SpanPx<W>.typeName)\" height=\"\(H.typeName)\" "
            + "rx=\"\(Radius.typeName)\" fill=\"\(Fill.typeName)\"/>\n"
            + "</g>\n"
    }
}
/// This wraps a spanning card in the hover affordance: the same lift class the keys wear,
/// base transform zero. The walk already placed the card; hover only lifts it.
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
/// from local zero, the same hospitality a column's `Band` extends. The door for whole
/// composed regions (a keypad, a legend) to ride a weighted row.
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
/// checked once at generate time, in span clothing.
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
        return "<text x=\"\(SpanPx<X>.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"start\" "
            + "fill=\"\(FillColor.typeName)\" font-weight=\"\(Weight.typeName)\" "
            + "font-size=\"\(Size.typeName)\">\(text)</text>\n"
    }
}
/// This drops spanning content down by a stated token. The y axis still
/// speaks in tokens until the height walk lands; this is that door, named, in one place.
public enum SpanLowered<Y: Structure, Content: Spanning>: Close {}
extension SpanLowered: Spanning {
    public static func rendered<
        X: Frac & Structure,
        W: Frac & Structure
    >(
        atX x: X.Type,
        width w: W.Type
    ) -> String {
        "<g transform=\"translate(0, \(Y.typeName))\">\n"
            + Content.rendered(atX: x, width: w)
            + "</g>\n"
    }
}
/// This draws a horizontal rule across its slice at a stated baseline: a timeline's track,
/// a divider. Two units of stroke, the rule's own weight, stated here once.
public protocol SpanRule: Spanning {
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
        "<line x1=\"\(SpanPx<X>.typeName)\" y1=\"\(Y.typeName)\" "
            + "x2=\"\(SpanPx<Sum<X, W>>.typeName)\" y2=\"\(Y.typeName)\" "
            + "stroke=\"\(Stroke.typeName)\" stroke-width=\"\(ArrowWidth.typeName)\"/>\n"
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
public protocol SpanTrackDashed: Spanning {
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
        "<rect x=\"\(SpanPx<X>.typeName)\" width=\"\(SpanPx<W>.typeName)\" height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\" "
            + "fill=\"\(Fill.typeName)\" stroke=\"\(Stroke.typeName)\" stroke-width=\"\(HairlineWidth.typeName)\" stroke-dasharray=\"\(DependencyDash.typeName)\"/>\n"
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
/// same classes `HoverReveal` writes, for a trigger that lives inside a slice.
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
/// start, head on its end. The gap between two neighbours IS the arrow; no position is held.
public protocol SpanArrowAcross: Spanning {
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
        "<line x1=\"\(SpanPx<X>.typeName)\" y1=\"\(Y.typeName)\" "
            + "x2=\"\(SpanPx<Sum<X, W>>.typeName)\" y2=\"\(Y.typeName)\" "
            + "stroke=\"\(TextSecondary.typeName)\" stroke-width=\"\(ArrowWidth.typeName)\" marker-end=\"url(#\(ArrowHeadName.typeName))\"/>\n"
    }
}
/// The same arrow points LEFT here: head on the slice's start, for a dependency that points back.
public protocol SpanArrowBackAcross: Spanning {
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
        "<line x1=\"\(SpanPx<Sum<X, W>>.typeName)\" y1=\"\(Y.typeName)\" "
            + "x2=\"\(SpanPx<X>.typeName)\" y2=\"\(Y.typeName)\" "
            + "stroke=\"\(TextSecondary.typeName)\" stroke-width=\"\(ArrowWidth.typeName)\" marker-end=\"url(#\(ArrowHeadName.typeName))\"/>\n"
    }
}
/// This draws a solid flow arrow DOWN the page on its slice's middle, between two stated
/// baselines: the vertical stroke of a stacked flow.
public protocol SpanArrowDown: Spanning {
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
        "<line x1=\"\(SpanPx<MidOf<X, W>>.typeName)\" y1=\"\(FromY.typeName)\" "
            + "x2=\"\(SpanPx<MidOf<X, W>>.typeName)\" y2=\"\(ToY.typeName)\" "
            + "stroke=\"\(TextSecondary.typeName)\" stroke-width=\"\(ArrowWidth.typeName)\" marker-end=\"url(#\(ArrowHeadName.typeName))\"/>\n"
    }
}
/// This draws the italic caption voice at its slice's origin: an arrow's aside, a
/// difference worth a whisper. `TextSecondary` is the voice's one colour, stated here.
public protocol SpanLabelItalic: Spanning {
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
        "<text x=\"\(SpanPx<X>.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"start\" "
            + "fill=\"\(TextSecondary.typeName)\" font-size=\"\(Size.typeName)\" "
            + "font-style=\"italic\">\(Content.typeName)</text>\n"
    }
}
/// The italic caption voice sits on its slice's MIDDLE here: the label an arrow wears when
/// it stands between two boxes rather than beside one.
public protocol SpanLabelItalicMid: Spanning {
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
        "<text x=\"\(SpanPx<MidOf<X, W>>.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"middle\" "
            + "fill=\"\(TextSecondary.typeName)\" font-size=\"\(Size.typeName)\" "
            + "font-style=\"italic\">\(Content.typeName)</text>\n"
    }
}
/// This fills the LEADING share of its slice by the data itself: the part over the whole,
/// a fraction of the handed width, digits once at the edge. The chart IS the data; no
/// weight layer stands between a team and its bar.
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
        "<rect x=\"\(SpanPx<X>.typeName)\" "
            + "width=\"\(SpanPx<Paired<Times<W.Left, Part>, Times<W.Right, Whole>>>.typeName)\" "
            + "height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\" fill=\"\(Fill.typeName)\"/>\n"
    }
}
/// One data segment of a stacked bar starts after the parts already laid (`Prefix`)
/// and spans its part, both as fractions of the whole over the handed width.
public protocol SpanDataSegment: Spanning {
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
        "<rect x=\"\(SpanPx<Sum<X, Paired<Times<W.Left, Prefix>, Times<W.Right, Whole>>>>.typeName)\" "
            + "width=\"\(SpanPx<Paired<Times<W.Left, Part>, Times<W.Right, Whole>>>.typeName)\" "
            + "height=\"\(H.typeName)\" rx=\"0\" fill=\"\(Fill.typeName)\"/>\n"
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
        "<text x=\"\(SpanPx<MidOf<X, W>>.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"middle\" "
            + "fill=\"\(FillColor.typeName)\" font-weight=\"\(Weight.typeName)\" "
            + "font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
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
        "<text x=\"\(SpanPx<Sum<X, W>>.typeName)\" y=\"\(Y.typeName)\" text-anchor=\"end\" "
            + "fill=\"\(FillColor.typeName)\" font-weight=\"\(Weight.typeName)\" "
            + "font-size=\"\(Size.typeName)\">\(Content.typeName)</text>\n"
    }
}

/// This pair draws a clip rounded to its slice, and the group that wears it. The shape derives from the
/// slice like everything else; only the id is a name.
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
        "<clipPath id=\"\(Id.typeName)\">\n"
            + "<rect x=\"\(SpanPx<X>.typeName)\" width=\"\(SpanPx<W>.typeName)\" "
            + "height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\"/>\n"
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
        "<g clip-path=\"url(#\(Id.typeName))\">\n"
            + Content.rendered(atX: x, width: w)
            + "</g>\n"
    }
}
/// This renders a slice-filling rect with an outline: the segment whose tint alone cannot hold its
/// edge.
public protocol SpanTrackOutlined: Spanning {
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
        "<rect x=\"\(SpanPx<X>.typeName)\" width=\"\(SpanPx<W>.typeName)\" height=\"\(H.typeName)\" rx=\"\(Radius.typeName)\" "
            + "fill=\"\(Fill.typeName)\" stroke=\"\(Stroke.typeName)\" stroke-width=\"\(HairlineWidth.typeName)\"/>\n"
    }
}

/// These name the regular and the bold text weight, once, for span labels.
public enum WeightRegular: Close {}
extension WeightRegular {
    public static var typeName: String { "400" }
}
public enum WeightBold: Close {}
extension WeightBold {
    public static var typeName: String { "700" }
}

