# ``DocumentKit``

A render engine with no runtime: a page's `body` is a TYPE, composed the way any other type in the lattice is, and reading its `typeName` (`Structure`, VerificationIsIdentification) walks that composition once into markdown. There is no second pass, no array of nodes interpreted — the page IS the type, the render IS `typeName`.

## Build a page

A page is built the way everything else in this package is built: declare a type, compose its body, read the name.

1. **Declare the screen.** `enum MyPage: Screen {}` — a caseless enum, like every concrete type on the surface (SurfaceLaw §S2). `Screen` is your app's own page kind, one line — `public protocol Screen: Open {}` — declared beside your pages, the way the Organization showcase declares its own. There is nothing to instantiate: the page is the type.
2. **Compose the body.** `@StructureBuilder static var body: some Structure { … }` — statements fold into a `Pair`-cons chain. Every leaf is an atom or another combinator: a name enters through `Symbol`, a count through `Tally`, prose through a prose atom — a type whose `typeName` is the sentence. Organization spells its prose from a JSON manifest through a build plugin; this page carries its own.
3. **Compile.** Type-checking the body is the render happening: a table missing its header rule, a tab out of place, a count that does not fold — each is a build error, not a bad page.
4. **Read it.** `MyPage.typeName` IS the markdown. A demo executable writes it into the `.docc` catalog, so a `doc:` link resolves to this content instead of an empty auto-generated stub — that is the whole publishing pipeline.
5. **Curate it.** Add the page to the landing's Topics so it hangs where readers look, not at the navigator's root.

## Two kinds of combinator

Every combinator on the surface is an `Open` protocol carrying the hole (an `associatedtype`) plus the composition that reads it (`body`), realized by a caseless `enum` — never the reverse. A one-hole combinator's `{ }` door (`init`) lives on the protocol's own extension, shared by every conformer; a combinator with more than one hole (``Link``, ``Picture``, ``SizedPanel``) folds its statements through a single `Whole: Pair` parameter instead, the door living on the concrete enum. The gallery further down this page is a live instance of every shape below, rendered by the engine it exercises — reading it is reading what each row actually produces, not a description of it.

| Combinator | Is | 
| --- | --- | 
| ``Symbol`` | `Target` — a symbol link, the type's own name in backticks | 
| ``Page`` | `<doc:Target>` — a link to a page, named by its own identity | 
| ``Link`` | `[Label](doc:Target)` — a link whose display text is chosen | 
| ``Picture`` | `![Alt](Asset)` — an image embedded IN the body, not a link-grid tile | 
| ``Framed`` | the same content in a one-cell table — a border, for free, from `Table` alone | 
| ``Table``, ``TableRow``, ``TableCell`` | a table — rows of cells, a Pair-cons never an array. `RuleMark` is the header delimiter every table needs to be a table at all | 
| ``ListItem`` | one list line | 
| ``Noted``, ``Flagged``, ``Warned``, ``Tipped`` | a coloured aside — Note, Important, Warning, Tip | 
| ``TabGroup`` | DocC `@TabNavigator` | 
| ``SideBySide``, ``PanelOf`` | DocC `@Row`/`@Column`, equal width | 
| ``SizedPanel`` | `@Column(size: N)` — a relative weight read off the same magnitude lexicon the vector surface weighs (`WeightOf<U2>` reads 2), never a computed value; the one real foothold this render target has for layout, not a general solver (there is no markdown primitive for an absolute width to land in) | 
| `Tally` | a `Structure`'s `count`, read as digits — not typed in, folded as the compiler builds | 



## The one rendering path

`typeName` (`Structure`) is the whole engine: an atom (`Close`) overrides it to its own character; a combinator's default reads `Body.typeName`, recursing through whatever `body` composed. `DocumentKit` depends only on `VerificationIsIdentification` — the same mechanism draws the Organization showcase and this page, gallery included.

> Warning: `typeName`'s walk concatenates strings on the way back UP the tree (`Paired.typeName = L.typeName + R.typeName`), so it is not tail-recursive — one `Structure` with enough total content in its own `body` can exhaust the call stack before it ever mis-renders (checked directly). Prefer several linked pages over one page trying to hold everything, the same choice Organization's showcase already makes.

## The gallery — every mechanism, live

Each mechanism below is shown three ways: the code that composes it, the markdown it renders to, and the render itself — produced by this page's own build.

### Symbol

`Symbol` renders a type's own Swift name in double backticks, the same shape a doc comment uses to link a real symbol. Below, a stand-in type renders as its own identifier.

Used like this:

```swift
Symbol { ExampleTarget.self }
```


Comes out like this:

``ExampleTarget``

### Page

`Page` links to another page by that page's own name — no separate title to keep in sync.

Used like this:

```swift
Page { ExampleTarget.self }
```


Comes out like this:

<doc:ExampleTarget>

### Link

`Link` is the same link, with its own chosen display text instead of the target's raw name.

Used like this:

```swift
Link { LinkLabel.self; ExampleTarget.self }
```


Comes out like this:

[a chosen label](doc:ExampleTarget)

### Picture

`Picture` embeds an image inside the page's own content, not only as a link-grid thumbnail.

Used like this:

```swift
Picture { Symbol { ExampleTarget.self }; ExampleAsset.self }
```


Comes out like this:

![``ExampleTarget``](example)

### Framed

`Framed` places content inside a one-cell table. It renders as plain left-aligned content — DocC does not draw a ring around a table cell, so this is a table, not a border.

Used like this:

```swift
Framed { Picture { Symbol { ExampleTarget.self }; ExampleAsset.self } }
```


Comes out like this:

| ![``ExampleTarget``](example) | 
| --- | 



### Spacer

`Spacer` is a column holding only width, no content. Two of them, flanking real content, pad it horizontally.

Used like this:

```swift
SideBySide {
    Spacer<WeightOf<U1>>.self
    PanelOf { Symbol { ExampleTarget.self } }
    Spacer<WeightOf<U1>>.self
}
```


Comes out like this:

@Row {
@Column(size: 1) {

}
@Column {
``ExampleTarget``
}
@Column(size: 1) {

}
}


### Gap — a rule table

A gap belongs to which two states are adjacent, not to either state alone. Below, five workflow transitions: an expected step gets a plain arrow, a step that skips or backslides gets a named, wider gap.

Used like this:

```swift
// the rule lives on the SPACE, stated once per pairing:
extension SpaceBetween where Left == ToDo, Right == Doing {
    static var typeName: String { " -> " }
}
extension SpaceBetween where Left == ToDo, Right == Done {
    static var typeName: String { "  ⚠ skipped review ⚠  " }
}

// read through a non-generic proxy (Surface Law §S17), once per pairing:
enum NormalToDoDoing: Close {}
extension NormalToDoDoing {
    static var typeName: String { SpaceBetween<ToDo, Doing>.typeName }
}

// used in a body:
ToDo.self; NormalToDoDoing.self; Doing.self
```


Comes out like this:

ToDo -> Doing

Doing -> Done

Blocked -> resumed -> Doing

ToDo  ⚠ skipped review ⚠  Done

Doing  ⚠ needs attention ⚠  Blocked

### Spacer, chosen by neighbor

The same rule, rendering a real column width instead of text: the gap beside a LOUD neighbor is wider than the gap between two quiet neighbors.

Used like this:

```swift
extension SpacerBetween where Left == Quiet, Right == Loud {
    static var typeName: String { Spacer<WeightOf<Plus<U2, U1>>>.typeName }
}

enum WideGapQuietLoud: Close {}
extension WideGapQuietLoud {
    static var typeName: String { SpacerBetween<Quiet, Loud>.typeName }
}

// used in a body:
SideBySide {
    PanelOf { Quiet.self }
    WideGapQuietLoud.self
    PanelOf { Loud.self }
}
```


Comes out like this:

@Row {
@Column {
quiet
}
@Column(size: 3) {

}
@Column {
LOUD
}
}
@Row {
@Column {
quiet
}
@Column(size: 1) {

}
@Column {
quiet
}
}


### Table

A header row, its required delimiter row, then data.

Used like this:

```swift
Table {
    TableRow { TableCell { FieldHeading.self }; TableCell { ValueHeading.self } }
    TableRow { TableCell { RuleMark.self }; TableCell { RuleMark.self } }
    TableRow { TableCell { EngineFieldName.self }; TableCell { EngineFieldValue.self } }
}
```


Comes out like this:

| Field | Value | 
| --- | --- | 
| Engine | DocumentKit | 



### List

A bullet list, one item per line.

Used like this:

```swift
ListItem { ListItemOne.self }
ListItem { ListItemTwo.self }
```


Comes out like this:

- a body is a type
- typeName walks it once


### Callouts

The same box, four labels: Note, Important, Warning, Tip.

Used like this:

```swift
Noted { CalloutMessage.self }
Flagged { CalloutMessage.self }
Warned { CalloutMessage.self }
Tipped { CalloutMessage.self }
```


Comes out like this:

> Note: the same combinator, four labels

> Important: the same combinator, four labels

> Warning: the same combinator, four labels

> Tip: the same combinator, four labels



### Tabs

Two panes, selectable at read time.

Used like this:

```swift
// no `@Tab` combinator yet: DocC requires the parenthesized form, so the atoms are
// written directly, the same call `Section` above makes:
TabGroup {
    At.self; TabLabel.self; ParenOpen.self; Quote.self; FirstTabLabel.self; Quote.self; ParenClose.self; OpenBrace.self
    FirstTabBody.self
    Newline.self
    CloseBrace.self
    At.self; TabLabel.self; ParenOpen.self; Quote.self; SecondTabLabel.self; Quote.self; ParenClose.self; OpenBrace.self
    SecondTabBody.self
    Newline.self
    CloseBrace.self
}
```


Comes out like this:

@TabNavigator {
@Tab("One") {
the first tab's content
}
@Tab("Two") {
the second tab's content
}
}


### Columns

Two panels, side by side, equal width.

Used like this:

```swift
SideBySide {
    PanelOf { LeftPanelBody.self }
    PanelOf { RightPanelBody.self }
}
```


Comes out like this:

@Row {
@Column {
left
}
@Column {
right
}
}


### Weighted columns

Two panels at a stated 1:2 ratio. The ratio renders here as repeated `█` blocks — column width itself does not visibly change in this renderer.

Used like this:

```swift
SideBySide {
    SizedPanel { Bar1.self; WeightOf<U1>.self }
    SizedPanel { Bar2.self; WeightOf<U2>.self }
}
```


Comes out like this:

@Row {
@Column(size: 1) {
█
}
@Column(size: 2) {
██
}
}


### Tally

A type's own count, read off as digits — never typed in by hand.

Used like this:

```swift
Tally { CountedTriple.self }
```


Comes out like this:

3

## The second medium: Vector

The gallery above is markdown, DocC's own document medium. `Vector` is DocumentKit's second: SVG, read by the identical mechanism — an atom is a `Close` reading its own `typeName`, a combinator is an `Open` protocol whose `body` composes atoms. A `viewBox` fixes the coordinate system, so embedding the result as an `<img>` scales both axes together, deterministically. Both examples at the end of this section are real compositions, generating their own drawing, the same way every markdown example above generates its own text.

### The canvas contract

**Guaranteed.** A canvas fixes its own coordinate space: `viewBox` W×H is a pixel grid that belongs to the composition. Inside it, placement is absolute (`Placed`), and the host cannot reach in — no margin, no centering, no theme rule moves anything within the `viewBox`. The host may scale the canvas only as a whole, uniformly: the aspect is preserved, so a known width fixes the height. Nothing drifts.

**Not guaranteed.** The absolute on-screen size: markdown offers no pixel pin, so the canvas renders at container width — the right shape, always; exact screen pixels, never promised. Text metrics: glyph width is the platform font's; the craft is a fixed font family and generous boxes — state the box, never compute the fit.

### Roles and themes

Light and dark are not two unrelated palettes; they are two projections of the same eight roles, each declared once, carrying both a light and a dark value. A role reaches a canvas by whichever of two mechanisms fits that canvas's own use: inline canvases (anything the inline-swap hook, `footer.html`, turns into real DOM) read a role as `var(--vi-<role>, <light-hex>)`, switched live by `prefers-color-scheme`, with a light fallback that still reads correctly even with no CSS in scope at all — a bare `<img>`. The small, numerous, non-interactive grid tiles use the other mechanism instead: a second, literal `x~dark.svg` file beside `x.svg`, DocC's own native asset-swap. Both read the SAME eight roles; only where a role's value lands differs, and that choice is the canvas's own, made once, at the driver's edge. One rule holds regardless of mechanism: a canvas's ground is transparent, so text never floats — every label sits on a surface role (card, track, chip), never directly on the transparent ground, because a floating label is only legible on the one host theme its fallback hex happens to match.

| Role | What it is | 
| --- | --- | 
| `SurfaceCard` | a card's own background | 
| `SurfaceTrack` | a track or chip's own background | 
| `TextPrimary` | primary text, on either surface above | 
| `TextSecondary` | secondary text, on either surface above | 
| `AccentRole` | the one scarce accent — a hero element per screen, never wallpaper | 
| `OnAccent` | text legible against `AccentRole` | 
| `ActionRole` | the interactive voice — links, live values | 
| `LineRole` | a thin border, or a denied/neutral dot | 



### Gate tiers

**Compile gate.** An illegal type does not build (`Legible`, `WithinBounds` — the strongest form). **Generation gate.** An illegal value stops `generate` with a named precondition (`BudgetedLabel`) — weaker, still before anything ships. **Host gate.** What only the browser decides (hover, theme) — declared, never trusted with correctness.

Three of these are live in the site today. The five `Legible*` protocols above (`LegibleOnSurfaceCard`, `LegibleOnSurfaceTrack`, `LegibleOnAccentRole`, and two more) are compile gates on every (foreground, background) pairing — an unreadable pair does not build. `WithinCyclesHero` (Organization's own review-cycle diagram) is the same tier applied to placement: a canvas's own closed set of legal positions, so a position only one canvas vetted cannot satisfy a different canvas's layout by accident. `BudgetedLabel` is the generation gate — a stated character ceiling, checked once, at generate time, against the real text a label carries (checked directly: lowering a label's budget below its longest real name crashes `generate` with exactly this precondition, then raised back).

### The interactive layer

`Linked` wraps a subtree in a real link: `Target` is a page path from the site's own closed set of addresses, never an arbitrary URL, named at the call site, not computed. It is always emitted — inert inside a plain `<img>` (DocC's own embed choice) — and becomes a real, clickable DOM anchor only once the host inlines the canvas (the inline-swap hook, `footer.html`), a decision the host makes about how to embed the medium, not a capability this file adds.

`PageSlug<X>` reads a page type's own Swift name, lowercased — the same URL slug DocC's static-hosting build assigns it. A caller builds a real site path from a page TYPE with this, never a string kept in sync by hand.

`HoverReveal` pairs a `Trigger` and a `Panel`: hovering either reveals the panel, while the trigger's own click still navigates. The panel must survive the pointer's OWN travel to it, so the reveal is keyed on either half's hover, the close is a delay rather than an instant cutoff, and `pointer-events` is never touched mid-transition (SurfaceLaw §S26 — found by checking directly, not assumed).

`SelfShowing` costs nothing beyond an empty conformance: a canvas that opts in can read its own already-compiled composition back out as text and print it as a small `{ }` chip on the page — nothing here is a second copy of what compiled, so nothing here can drift from it.

### A drawn canvas

A canvas, a plate, and a label — the three pieces the contract above names, composed the way any `Diagram` is.

Used like this:

```swift
public enum VectorCanvasExampleContent: Group {
    public static var body: some Structure {
        VectorCanvasExamplePlate.self
        VectorCanvasExampleLabel.self
    }
}
public enum VectorCanvasExampleDiagram: Diagram {
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorCanvasExampleAlt
    public typealias Content = VectorCanvasExampleContent
}
```


Comes out like this:

![A plate reading Vector.](vector-canvas-example)

### Hover reveals more

A trigger and a panel, paired by `HoverReveal` — hover the dot below to see the panel; its own click still navigates.

Used like this:

```swift
enum VectorHoverExampleReveal: HoverReveal {
    typealias Trigger = VectorHoverExampleTrigger
    typealias Panel = VectorHoverExamplePanel
}
```


Comes out like this:

![A dot that reveals a panel on hover; its own click still navigates.](vector-hover-example)

### The gate, both ways

`GatedTextOnSurfaceCard` requires `Fg: LegibleOnSurfaceCard` (Design.swift) — a compile gate, not a review note. The same declaration, one legal foreground and one illegal one.

This compiles:

```swift
enum LegalLabel: GatedTextOnSurfaceCard {
    typealias Fg = TextPrimary   // TextPrimary: LegibleOnSurfaceCard
    typealias X = N0
    typealias Y = N0
    typealias Anchor = AnchorStart
    typealias Size = TextS
    typealias Content = ProbeText
}
```


This does not — the compiler's own words:

```swift
enum IllegalLabel: GatedTextOnSurfaceCard {
    typealias Fg = SurfaceTrack   // a background, not a legible foreground
    typealias X = N0
    typealias Y = N0
    typealias Anchor = AnchorStart
    typealias Size = TextS
    typealias Content = ProbeText
}
```


```
error: type 'IllegalLabel' does not conform to protocol 'GatedTextOnSurfaceCard'
note: possibly intended match 'IllegalLabel.Fg' (aka 'SurfaceTrack') does not
conform to 'LegibleOnSurfaceCard'
```


### A canvas that shows its own code

`SelfShowing` costs nothing beyond the marker — the badge in the corner links to a page carrying this SAME canvas's own composition, read off the same atom the code block below shows, so it cannot drift from what actually compiled.

Used like this:

```swift
public enum VectorSelfShowingExampleDiagram: Diagram, SelfShowing {
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorSelfShowingExampleAlt
    public typealias Content = VectorSelfShowingExampleContent
}
```


Comes out like this:

![A plate reading Self-showing, with a chip that links to its own source.](vector-selfshowing-example)

### A linked tour

Two canvases, each `Linked` to the OTHER's own page. Visit Station A below, click its dot, land on Station B — click ITS dot, land back on Station A. Inert here (a plain `<img>`); real once the host inlines it.

Used like this:

```swift
enum VectorTourStationALinkToB: HFlow {
    static var body: some Structure & Divides {
        Fixed<VectorExampleColumnWide, SpanLink<
            VectorExampleSitePath<VectorTourStationB>, VectorTourDot>>.self
        RestAir.self
    }
}
// Station B mirrors it, linked back to Station A.
```


Comes out like this:

![Station A, a dot linked to Station B's own page.](vector-tour-station-a)

### RolesPlate, both themes

The table above, drawn: the same `Palette`, instantiated once per theme, the same edge substitution `LightCardPalette`/`DarkCardPalette` already stands on. DocC swaps the file, never the type.

Used like this:

```swift
writeSVG(RolesPlate<LightRolesPalette>.typeName, "roles-plate")
writeSVG(RolesPlate<DarkRolesPalette>.typeName, "roles-plate~dark")
```


Comes out like this:

![The eight roles, each as its own colour swatch.](roles-plate)