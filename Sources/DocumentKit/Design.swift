import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// DESIGN states Pulse, the design system, as the same mechanism the access layer already is.
// Tokens are atoms: a closed set, §S8, the same discipline every other palette
// in this file's neighbourhood keeps. The rule of COMBINATION is conditional conformance, the
// exact shape Policy.swift's `View<Who, Of>` gates an access: a pairing earns `Legible` only
// when the palette allows it, so an unreadable (foreground, background) pair does not pass
// review. It does not compile.
//
// A hex literal is declared NOWHERE: every colour is a walk from White (Spectrum.swift),
// eight halvings per band, and the machine forms (`#RRGGBB`, `rgba(...)`) exist only at the
// reading edge, the way a magnitude becomes digits only through `Tally`. Repainting the
// whole system is a walk edit here, no component touched. A component may compose colours and
// scales. It may not introduce a number of its own (§S15: stated, never computed), reviewed
// by eye for now, a linter is a later candidate.
//
// THE STYLE DNA, extracted from the reference system, held by the gates.
//
// Surfaces: Paper cards on a Mist ground, SoftShadow, R16. Chips and keys: R10.
// Text: Ink at two opacities (.80 primary, .54 secondary), never a third grey.
// Yellow is SCARCE: one hero element per screen, at most, an accent, never
// wallpaper (the reference uses it six times on a whole page). Blue is the
// interactive voice. Numbers wear Display. Everything breathes the S8 grid:
// a component states no number the scales do not own.
//
// TWO PALETTES, ONE VOCABULARY. The dark reference turned up a fact, not a coincidence: its
// card black, #1C1C1E, is byte-identical to this file's own `Ink`, and its text reads white at
// two opacities (.90/.70), an exact mirror of the light side's black-at-two-opacities move.
// Light and dark are not two unrelated palettes. They are two PROJECTIONS of the same eight
// roles (`SurfaceCard`, `SurfaceTrack`, `TextPrimary`, `TextSecondary`, `AccentRole`,
// `ActionRole`, `LineRole`, `OnAccent`), declared once, below, each carrying both a light and a
// dark value.
//
// A role is delivered to a canvas by whichever of two mechanisms fits that canvas's own use.
//
//   (B) INLINE CANVASES (Pulse, the keypad, the architecture diagram: anything the inline-swap
//   hook, footer.html, turns into real DOM) emit a role's colour as
//   `var(--vi-<role>, <light-hex>)`. Both palettes are declared exactly once, in footer.html's
//   own `<style>` block, switched by `prefers-color-scheme`: one file per canvas, a LIVE theme
//   switch with no reload (the file never changes, only the custom property the browser
//   resolves does), and a light fallback that reads correctly even with no CSS in scope at all
//   (a bare `<img>`). The role atoms below (`SurfaceCard` and its seven siblings) ARE this
//   mechanism: every inline-canvas component reads one of them, never a flat hex directly.
//
//   (A) `~dark.svg` DUPLICATES: DocC's own native mechanism (a file named `x~dark.svg` beside
//   `x.svg` resolves into a real `<picture><source media="prefers-color-scheme:dark">`, checked
//   directly against the generated site) for the small, numerous, non-interactive
//   grid tiles (the nine `card-*` icons, the avatar) where a second static file is cheaper than
//   threading a CSS variable through nine near-identical glyphs. The SAME composition drives
//   both files: `CardPalette` is a protocol two concrete types (`LightCardPalette`,
//   `DarkCardPalette`) satisfy, and the driver (`VectorDemo/main.swift`'s `runCards()`)
//   instantiates each card generic type TWICE, once per palette, the same lawful edge a name
//   pool substitutes at (SurfaceLaw §S23), not a second hand-authored file.
//
// Both mechanisms read the SAME eight roles. Only where a role's VALUE lands (a CSS custom
// property vs. a second literal SVG) differs, and that choice is the canvas's, made once, at
// the driver's edge, never a component's own decision.
//
// TRANSPARENCY. A canvas ground is transparent: the host's page shows through, and the
// composition must survive any host theme. Therefore text NEVER floats: every label sits on a
// surface role (card, track, chip). A floating label is legible on exactly one host theme,
// a bug wearing a style. Where a diagram's content cannot all sit on surfaces, the
// canvas earns an explicit backdrop role instead (architecture's case), stated, not defaulted.
// ═══════════════════════════════════════════════════════════════

/// This marks a colour atom over `Structure`, not `Close` directly (SurfaceLaw §2: `Close`
/// seals a concrete leaf, a protocol may not claim to BE one), read the same way every other
/// atom is. Every concrete colour below conforms to both: `Paint` for the palette constraints,
/// `Close` for its reading.
public protocol Paint: Structure {}

public enum Ink: Paint, Close {}
extension Ink {
    public static var typeName: String {
        Lit<
            Dimmer<Dimmer<Dimmer<Brighter<Brighter<Brighter<Dimmer<Dimmer<Settled>>>>>>>>,
            Dimmer<Dimmer<Dimmer<Brighter<Brighter<Brighter<Dimmer<Dimmer<Settled>>>>>>>>,
            Dimmer<Dimmer<Dimmer<Brighter<Brighter<Brighter<Brighter<Dimmer<Settled>>>>>>>>
        >.typeName
    }
}
public enum Paper: Paint, Close {}
extension Paper {
    public static var typeName: String { White.typeName }
}
public enum Mist: Paint, Close {}
extension Mist {
    public static var typeName: String {
        Lit<
            Brighter<Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Dimmer<Settled>>>>>>>>,
            Brighter<Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Brighter<Settled>>>>>>>>,
            Brighter<Brighter<Brighter<Brighter<Brighter<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
        >.typeName
    }
}
public enum Accent: Paint, Close {}
extension Accent {
    public static var typeName: String {
        Lit<
            Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Settled>>>>>>>>,
            Brighter<Brighter<Dimmer<Brighter<Brighter<Brighter<Dimmer<Brighter<Settled>>>>>>>>,
            Dimmer<Dimmer<Brighter<Dimmer<Brighter<Brighter<Dimmer<Brighter<Settled>>>>>>>>
        >.typeName
    }
}
public enum Muted: Paint, Close {}
extension Muted {
    public static var typeName: String {
        Lit<
            Brighter<Dimmer<Dimmer<Dimmer<Brighter<Dimmer<Brighter<Dimmer<Settled>>>>>>>>,
            Brighter<Dimmer<Dimmer<Dimmer<Brighter<Dimmer<Brighter<Dimmer<Settled>>>>>>>>,
            Brighter<Dimmer<Dimmer<Dimmer<Brighter<Brighter<Brighter<Dimmer<Settled>>>>>>>>
        >.typeName
    }
}
public enum Line: Paint, Close {}
extension Line {
    public static var typeName: String {
        Lit<
            Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Dimmer<Dimmer<Settled>>>>>>>>,
            Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Dimmer<Brighter<Settled>>>>>>>>,
            Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Brighter<Brighter<Settled>>>>>>>>
        >.typeName
    }
}

// Black at two opacities, not a third grey, the reference's own move: `InkSecondary` is the
// light-surface secondary text. `Muted` stays for dark surfaces (`Ink`-backed panels),
// unchanged.
//
// Every atom on this page stays exactly as it was. They remain the LIGHT half of
// mechanism (A)'s two literal files (`Cards.swift`'s `LightCardPalette` reads them directly)
// and the light fallback baked into mechanism (B)'s role atoms below. Nothing here is deleted.
// The role atoms are new names ADDED alongside, not a replacement of this vocabulary.
public enum InkPrimary: Paint, Close {}
extension InkPrimary {
    public static var typeName: String {
        Veiled<Quenched, Quenched, Quenched, Cover80>.typeName
    }
}
public enum InkSecondary: Paint, Close {}
extension InkSecondary {
    public static var typeName: String {
        Veiled<Quenched, Quenched, Quenched, Cover54>.typeName
    }
}
public enum Action: Paint, Close {}
extension Action {
    public static var typeName: String {
        Lit<
            Dimmer<Dimmer<Brighter<Brighter<Dimmer<Dimmer<Brighter<Brighter<Settled>>>>>>>>,
            Dimmer<Brighter<Brighter<Dimmer<Brighter<Brighter<Brighter<Brighter<Settled>>>>>>>>,
            Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Brighter<Dimmer<Settled>>>>>>>>
        >.typeName
    }
}
/// This is a background tint, not a foreground: it is not granted a `LegibleOnX` conformance
/// (SurfaceLaw keeps `Paint` for anything wanting the gate. A tint used as `Fill` on a
/// `Shape`-family combinator needs only `Structure`, so a bare `Close` is enough and correct).
public enum ActionTint: Close {}
extension ActionTint {
    public static var typeName: String {
        Veiled<
            Dimmer<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Brighter<Dimmer<Settled>>>>>>>>,
            Brighter<Dimmer<Dimmer<Dimmer<Brighter<Dimmer<Brighter<Brighter<Settled>>>>>>>>,
            Brighter<Brighter<Brighter<Brighter<Brighter<Dimmer<Dimmer<Brighter<Settled>>>>>>>>,
            Cover16
        >.typeName
    }
}
public enum NavyTint: Close {}
extension NavyTint {
    public static var typeName: String {
        Veiled<
            Dimmer<Dimmer<Brighter<Dimmer<Dimmer<Brighter<Dimmer<Dimmer<Settled>>>>>>>>,
            Dimmer<Brighter<Dimmer<Dimmer<Brighter<Dimmer<Brighter<Dimmer<Settled>>>>>>>>,
            Dimmer<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Settled>>>>>>>>,
            Cover06
        >.typeName
    }
}
public enum FontStack: Close {}
extension FontStack {
    public static var typeName: String { "Inter, Roboto, system-ui, sans-serif" }
}

// ── The dark HALF of mechanism (A)'s two literal files. The nine cards and the avatar need
// only two colours with a dark counterpart (the rest lives in footer.html's CSS only,
// mechanism (B)). RolesPlate is mechanism (A)'s second consumer, drawing all eight
// roles as a grid tile, so the remaining six get their dark half here too, from footer.html's
// OWN `@media (prefers-color-scheme: dark)` block: the SAME values that CSS block already
// carries, read here, not reinvented. ──

public enum SurfaceCardDark: Paint, Close {}
extension SurfaceCardDark {
    public static var typeName: String { Ink.typeName }
}
public enum SurfaceTrackDark: Paint, Close {}
extension SurfaceTrackDark {
    public static var typeName: String {
        Veiled<Undimmed, Undimmed, Undimmed, Cover15>.typeName
    }
}
public enum TextPrimaryDark: Paint, Close {}
extension TextPrimaryDark {
    public static var typeName: String {
        Veiled<Undimmed, Undimmed, Undimmed, Cover90>.typeName
    }
}
public enum TextSecondaryDark: Paint, Close {}
extension TextSecondaryDark {
    public static var typeName: String {
        Veiled<Undimmed, Undimmed, Undimmed, Cover70>.typeName
    }
}
public enum AccentRoleDark: Paint, Close {}
extension AccentRoleDark {
    public static var typeName: String { Accent.typeName }
}
public enum ActionRoleDark: Paint, Close {}
extension ActionRoleDark {
    public static var typeName: String {
        Lit<
            Dimmer<Brighter<Dimmer<Dimmer<Brighter<Dimmer<Dimmer<Brighter<Settled>>>>>>>>,
            Dimmer<Brighter<Brighter<Brighter<Dimmer<Dimmer<Brighter<Dimmer<Settled>>>>>>>>,
            Brighter<Brighter<Dimmer<Dimmer<Brighter<Brighter<Brighter<Brighter<Settled>>>>>>>>
        >.typeName
    }
}
// `LineRoleDark` happens to share `SurfaceTrackDark`'s value by decision: a hairline and a
// track read the same on ink today, and the two roles keep two names, free to diverge.
public enum LineRoleDark: Paint, Close {}
extension LineRoleDark {
    public static var typeName: String {
        Veiled<Undimmed, Undimmed, Undimmed, Cover15>.typeName
    }
}
public enum OnAccentDark: Paint, Close {}
extension OnAccentDark {
    public static var typeName: String { Ink.typeName }
}

/// This names the two colours a card icon needs: a ground and a glyph (`Accent`'s one dot
/// stays fixed, both palettes, so it is not a member: the eight-role table gives it the
/// identical value twice). `LightCardPalette`/`DarkCardPalette` are the driver's edge
/// substitution (SurfaceLaw
/// §S23): the SAME nine card compositions, run twice, are what produces `card-x.svg` and
/// `card-x~dark.svg`.
public protocol CardPalette {
    associatedtype Surface: Paint
    associatedtype Glyph: Paint
}
public enum LightCardPalette: CardPalette {
    public typealias Surface = Mist
    public typealias Glyph = Ink
}
public enum DarkCardPalette: CardPalette {
    public typealias Surface = SurfaceTrackDark
    public typealias Glyph = TextPrimaryDark
}

// ── The eight roles mechanism (B) speaks. Each wraps `var(--vi-<role>, <light read>)`, and
// the light fallback READS the pigment atom above it, one declaration point. footer.html's
// `<style>` block restates the same values literally (that file is not Swift-rendered, so the
// two cannot share one declaration: a seam, not an oversight, the same edge SurfaceLaw §S23
// already names for a generated artifact's own non-generated neighbours). Keeping footer.html
// in step is a discipline, not a guarantee. Changing a role means editing both places. ──

public enum SurfaceCard: Paint, Close {}
extension SurfaceCard {
    public static var typeName: String { "var(--vi-surface-card, " + Paper.typeName + ")" }
}
public enum SurfaceTrack: Paint, Close {}
extension SurfaceTrack {
    public static var typeName: String { "var(--vi-surface-track, " + Mist.typeName + ")" }
}
public enum TextPrimary: Paint, Close {}
extension TextPrimary {
    public static var typeName: String { "var(--vi-text-primary, " + InkPrimary.typeName + ")" }
}
public enum TextSecondary: Paint, Close {}
extension TextSecondary {
    public static var typeName: String { "var(--vi-text-secondary, " + InkSecondary.typeName + ")" }
}
public enum AccentRole: Paint, Close {}
extension AccentRole {
    public static var typeName: String { "var(--vi-accent, " + Accent.typeName + ")" }
}
public enum ActionRole: Paint, Close {}
extension ActionRole {
    public static var typeName: String { "var(--vi-action, " + Action.typeName + ")" }
}
public enum LineRole: Paint, Close {}
extension LineRole {
    public static var typeName: String {
        "var(--vi-line, " + Lit<
                Brighter<Brighter<Brighter<Dimmer<Brighter<Dimmer<Brighter<Dimmer<Settled>>>>>>>>,
                Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Dimmer<Dimmer<Settled>>>>>>>>,
                Brighter<Brighter<Brighter<Dimmer<Brighter<Brighter<Brighter<Dimmer<Settled>>>>>>>>
            >.typeName + ")"
    }
}
public enum OnAccent: Paint, Close {}
extension OnAccent {
    public static var typeName: String { "var(--vi-on-accent, " + Ink.typeName + ")" }
}
/// This is not one of the eight-role table's rows: `ActionTint` gets a role here by the same
/// mechanism because the keypad's hover tint and `SplitBar`'s outlined segment both live in
/// mechanism-B canvases and so cannot stay a flat hex either. Its dark value is DERIVED, not
/// given: the light tint is `Action` at 16% alpha, so the dark tint is `ActionRole`'s dark
/// hex (`#4972CF` = `rgb(73,114,207)`) at the same 16%, a reasoned extension
/// of the stated table, not a silent invention.
public enum ActionTintRole: Close {}
extension ActionTintRole {
    public static var typeName: String { "var(--vi-action-tint, " + ActionTint.typeName + ")" }
}
/// This is also not one of the eight rows: the board needs a status chip's text to read
/// against `ActionRole` (the `InProgress` chip). `ActionRole`'s blue is dark enough, both
/// palettes, that white text reads against either, a theme-INVARIANT value, unlike
/// `TextPrimary`/`TextSecondary` (which flip because their backgrounds do). Reasoned the
/// same way `ActionTintRole` was, not given by the table.
public enum OnActionRole: Paint, Close {}
extension OnActionRole {
    public static var typeName: String { "var(--vi-on-action, " + Paper.typeName + ")" }
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
/// The cast both shadow filters share: straight down five, blurred ten, black.
public enum ShadowCast: Close {}
extension ShadowCast {
    public static var typeName: String {
        "dx=\"0\" dy=\"5\" stdDeviation=\"10\" flood-color=\"" + Black.typeName + "\""
    }
}
/// The resting opacity: `SoftShadow` reads it directly, `SurfaceCardShadow` as the
/// light-theme fallback under its CSS variable.
public enum ShadowRestOpacity: Close {}
extension ShadowRestOpacity {
    public static var typeName: String { "0.10" }
}

/// This is the one shadow every `Paper` card reads: a filter def, declared once per canvas
/// that uses it (`ArrowMarkers`' shape), not restated per card. Fixed in both themes.
/// `HeroKpiCard` (an `AccentRole` panel) is not the table row asked to go flat in the dark
/// theme. Only `SurfaceCard` is (`SurfaceCardShadow`, below).
public enum SoftShadow: Close {}
extension SoftShadow {
    public static var typeName: String {
        "<filter id=\"" + SoftShadowName.typeName + "\" " + ShadowEnvelope.typeName + ">\n"
            + "<feDropShadow " + ShadowCast.typeName + " flood-opacity=\"" + ShadowRestOpacity.typeName + "\"/>\n"
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

/// A `SurfaceCard` panel is flat in the dark theme: no shadow, a thin `LineRole` edge instead.
/// It therefore reads its shadow through THIS filter, not
/// `SoftShadow`. Its opacity is a CSS variable, `0.10` light / `0` dark, declared once in
/// footer.html next to the eight roles. Two filter defs, not one switched by a theme, because
/// only `SurfaceCard` (not `AccentRole`) was asked to go flat.
public enum SurfaceCardShadow: Close {}
extension SurfaceCardShadow {
    public static var typeName: String {
        "<filter id=\"" + SurfaceCardShadowName.typeName + "\" " + ShadowEnvelope.typeName + ">\n"
            + "<feDropShadow " + ShadowCast.typeName
            + " flood-opacity=\"var(--vi-surface-card-shadow-opacity, " + ShadowRestOpacity.typeName + ")\"/>\n"
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
// dependency, and the one arrowhead every arrow shares. Named once; a combinator reads
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

// ── The gate: a pairing renders only when the palette allows it.
//
// A single generic pair type, `On<Fg, Bg>`, conditionally conforming to `Legible`
// for exactly the seven legible pairs below, is not buildable (checked directly against the
// compiler): Swift refuses more than one conditional conformance of the SAME generic type to
// the SAME protocol, even with disjoint `where` bounds.
//   "conflicting conformance of 'On<Fg, Bg>' to protocol 'Legible'; there cannot be more than
//    one conformance, even with different conditional bounds"
// Confirmed with as few as two extensions, so no rephrasing of the `where` clause escapes it.
//
// The gate still lives at the type level, checked by the compiler, not a linter. It just
// routes through the BACKGROUND's identity instead of a shared generic pair: each
// background states which foregrounds read against it, once, as an ordinary (unconditional)
// conformance on the concrete colour. There is no limit on how many DIFFERENT protocols one
// concrete type may conform to, only on conditionally reconforming the SAME generic/protocol
// pair. An illegal foreground for a given background still fails to compile: it fails at the
// component's OWN declaration (the associated type constraint below), not merely at a later
// call to `typeName`.
//
// The gates name the ROLE a mechanism-B component actually reads
// (`LegibleOnSurfaceCard`, not `LegibleOnPaper`): `Paper`/`Mist`/`Accent` are mechanism (A)'s
// own literal hexes (`Cards.swift` draws no gated text at all, so they never needed the gate).
// `SurfaceCard`/`SurfaceTrack`/`AccentRole` are the role atoms mechanism-B components hold. The
// legible PAIR itself is unchanged, same light-mode contrast the reference checked, only the
// name moves to match what is actually being paired now. `LegibleOnInk`/`LegibleOnNavyTint`
// stay untouched: no component reads them (`Ink` marks the architecture
// diagram's own fixed dark anchor, deliberately outside the role system, see `Diagram.swift`;
// `NavyTint` is unused infrastructure), so there is nothing here to rename. ──

/// This marks a foreground legible against an `Ink` background, unused (see above), kept as-is.
public protocol LegibleOnInk: Paint {}
extension Paper: LegibleOnInk {}
extension Accent: LegibleOnInk {}

/// This is a foreground legible against the `SurfaceCard` role.
public protocol LegibleOnSurfaceCard: Paint {}
extension TextPrimary: LegibleOnSurfaceCard {}
extension TextSecondary: LegibleOnSurfaceCard {}
extension ActionRole: LegibleOnSurfaceCard {}

/// This is a foreground legible against the `SurfaceTrack` role.
public protocol LegibleOnSurfaceTrack: Paint {}   // law:allow — a palette gate: its content is which foregrounds conform; the reading site (a Gated wrapper) comes and goes with canvases, the category stays
extension TextPrimary: LegibleOnSurfaceTrack {}
extension TextSecondary: LegibleOnSurfaceTrack {}
extension ActionRole: LegibleOnSurfaceTrack {}

/// This is a foreground legible against the `AccentRole` role.
public protocol LegibleOnAccentRole: Paint {}   // law:allow — same palette-gate class as its SurfaceTrack sibling
extension OnAccent: LegibleOnAccentRole {}

/// This marks a foreground legible against a `NavyTint` background, unused (see above), kept as-is.
public protocol LegibleOnNavyTint: Paint {}
extension Ink: LegibleOnNavyTint {}
extension InkPrimary: LegibleOnNavyTint {}
extension InkSecondary: LegibleOnNavyTint {}

// ── The legibility law after the span walk: the `Legible*` protocols below REMAIN the
// pairing law — an unreadable (foreground, background) pair is still not a granted pair —
// but the per-piece text wrappers that once carried the constraint died with their last
// consumers. A span label states its role colour and its slice carries no surface type
// for a constraint to bind against; binding one needs surface-typed slices, the Canon
// engine's own next step, stated here so the gap reads as a decision, not an oversight. ──

// ── Gated text: the design system's own `Label`. `Fg` is constrained to a background's
// legible-foreground protocol, so an off-palette pair does not conform to the associated type
// at all. The type does not compile, the same way an access without `Authorized` does not
// (Policy.swift). Built only where a component actually needs it (§S8): card text sits on
// `SurfaceCard`, track text sits on `SurfaceTrack`. ──

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
// itself lives on the span engine (`SpanCardFace`/`SpanHeroFace` and `SpanLabel`); what the
// design system keeps is the vertical word: how tall a metric tile stands, where its title
// and value sit. `AccentRole`'s only legal foreground stays `OnAccent`: one hero per screen. ──

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
// names these; only this file spells them in rungs. `EdgeMargin` stands at a canvas's
// edges, `Breath` between neighbours; an element's extent is the width it takes off the
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
// (the medium has no division of a rung); `GateFallTall` is the one free height the fall
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
// chip, and split the medium draws; three canvases used to hold three names for this one
// fact. The bar itself is span-drawn; the design system keeps the vertical word. ──

public typealias TrackHeight = U32
// The CENTRED class of baselines derives now: `CenteredBaseline` (Vector.swift) reads the
// zone's middle plus half the font's own capital height (GeneratedFontMetrics), and this
// rung is its first conversion — the derived value reproduces the old stated "21" to the
// pixel. STACKED baselines (a title over a subtitle) remain stated per canvas: they are
// design choices, not centrings, and the hole they keep open is named where they stand.
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
//    from these by name; a canvas states proportions, and the seed (`SpaceSeed`) is the one
//    number that turns a count into pixels. ──

public typealias U1 = Unit
public typealias U2 = Twice<U1>
public typealias U4 = Twice<U2>
public typealias U8 = Twice<U4>
public typealias U16 = Twice<U8>
public typealias U32 = Twice<U16>
public typealias U64 = Twice<U32>
public typealias U128 = Twice<U64>
public typealias U256 = Twice<U128>
public typealias U512 = Twice<U256>
