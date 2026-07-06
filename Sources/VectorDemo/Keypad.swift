import VerificationIsIdentification
import DocumentKit
import Organization

// The drawn keypad: nine digit keys in a three-by-three weighted grid, each `Linked` to
// wherever pressing it leads. DESIGN19 §2 embeds the keys inside a person's profile canvas,
// one `StateGroup` per depth reached by `:target` (Vector.swift). A key is ONE generic face:
// the digit it shows is the lattice numeral the passcodes are composed of (`Numeral._3`,
// Team.swift), read off the type itself, so there is no second place a digit is stated. The
// grid is weights in fives, margin 3, key 16, breath 3, along both axes; a keypad laid by
// weights cannot misplace a key any more than a weighed row can overflow its span.

/// The base path every Organization page's real site address shares, the one fact a caller
/// supplies. `PageSlug<X>` (DocumentKit/Vector.swift) reads the rest from the type itself.
enum SitePath<X>: Close {}
extension SitePath {
    public static var typeName: String { "/documentation/organization/" + PageSlug<X>.typeName }
}

// ── the digit's face: the numeral's own name, underscore shed ──

/// A digit key's face reads the numeral's own name: `_3`'s face is 3. The atoms the
/// passcodes chain are the atoms the keypad shows.
enum DigitFace<D: Digit>: Close {}
extension DigitFace {
    public static var typeName: String { String(String(describing: D.self).dropFirst()) }
}

// ── the key: one visual for all nine, digit and destination the only variation ──

enum KeyDigitBaseline: Close {}
extension KeyDigitBaseline {
    public static var typeName: String { "50" }
}

enum KeyTrack: SpanTrack {
    public typealias H = Tally<KeySide>
    public typealias Radius = R10
    public typealias Fill = SurfaceTrack
}
enum KeyDigitLabel<D: Digit>: SpanLabelMid {
    public typealias Y = KeyDigitBaseline
    public typealias FillColor = TextPrimary
    public typealias Size = DisplayS
    public typealias Weight = WeightBold
    public typealias Content = DigitFace<D>
}
typealias Key<
    D: Digit,
    Dest: Structure
> = SpanLink<
    Dest,
    SpanLift<Layered<KeyTrack, KeyDigitLabel<D>>>
>

// ── the grid: three rows of three. The keys are EQUAL flexible members between pitch
// breaths, so no key states a side; the vertical stacks fixed key rows at the same pitch,
// and the frame is the given the caller already had. ──

enum KeypadRow<
    DA: Digit, TA: Structure,
    DB: Digit, TB: Structure,
    DC: Digit, TC: Structure
>: HFlow {
    public typealias Given = KeypadSide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<KeyPitch>.self
        Flexible<Key<DA, TA>>.self
        Air<KeyPitch>.self
        Flexible<Key<DB, TB>>.self
        Air<KeyPitch>.self
        Flexible<Key<DC, TC>>.self
        Air<KeyPitch>.self
    }
}
// ── the keypad's ground and its hover rule ──

enum KeypadFrame<
    T1: Structure, T2: Structure, T3: Structure,
    T4: Structure, T5: Structure, T6: Structure,
    T7: Structure, T8: Structure, T9: Structure
>: VFlow {
    public typealias Given = KeypadSide
    public typealias Across = KeypadSide
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<KeyPitch>.self
        Fixed<KeySide, SpanHosted<KeypadRow<Numeral._1, T1, Numeral._2, T2, Numeral._3, T3>>>.self
        Air<KeyPitch>.self
        Fixed<KeySide, SpanHosted<KeypadRow<Numeral._4, T4, Numeral._5, T5, Numeral._6, T6>>>.self
        Air<KeyPitch>.self
        Fixed<KeySide, SpanHosted<KeypadRow<Numeral._7, T7, Numeral._8, T8, Numeral._9, T9>>>.self
        RestAir.self
    }
}

enum KeypadBackground: FullBleedRect {
    public typealias W = Tally<KeypadSide>
    public typealias H = Tally<KeypadSide>
    public typealias Fill = SurfaceCard
}

/// The lift-and-tint rule for a keypad's keys: Pulse's shared `HoverStyle`
/// (Vector.swift) only lifts. A key additionally tints to `ActionTintRole` on hover (yellow has
/// no hero on the keypad, so the tint is blue, not `AccentRole`; mechanism B re-points the
/// tint at its role), a rule specific enough to this one canvas
/// that it does not belong on every lifted group.
enum KeypadHoverStyle: Close {}
extension KeypadHoverStyle {
    public static var typeName: String {
        """
        <style>
        .hover-lift { transform: translate(var(--tx), var(--ty)); transition: transform 150ms ease; cursor: pointer; }
        .hover-lift:hover { transform: translate(var(--tx), calc(var(--ty) - 2px)); }
        .hover-lift rect { transition: fill 150ms ease; }
        .hover-lift:hover rect { fill: \(ActionTintRole.typeName); }
        </style>

        """
    }
}
