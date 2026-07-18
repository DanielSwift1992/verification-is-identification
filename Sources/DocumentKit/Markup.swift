import Alphabet
import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// DOCUMENTKIT composes documents as type-level chains of atoms. A symbol is a `Close`
// whose `typeName` is its character; a combinator is an `Open` protocol whose body
// composes atoms through `{ Type.self }`; `typeName` walks the chain and prints the page.
//
// A combinator is used through its `init`: the call takes a `@StructureBuilder` closure,
// so a nested combinator call composes the same way a bare `X.self` leaf does. The
// `init` lives once, on the protocol's extension, and every concrete realizer is an
// empty enum that inherits it along with `body`.
//
// Walls, each checked directly against the toolchain: the `init` parameter is typed as
// a builder closure returning a VALUE, since nesting breaks under an `X.Type` parameter.
// The `init` body is `fatalError()` and never runs; Swift needs the `init` for call
// syntax and generic inference only, and no reading (`typeName`, `count`, `labels`)
// ever constructs an instance or executes a getter.
// ═══════════════════════════════════════════════════════════════

// ── Atoms: Backtick/Hash/Space/Newline/At/Quote come from the shared Alphabet target.
//    Everything below is a markdown-structural COMPOUND (its own surrounding whitespace baked
//    in), not a single character, so it stays here. ──

public enum DoubleHash: Close {}
extension DoubleHash {
    public static var typeName: String { "## " }
}

public enum TripleHash: Close {}
extension TripleHash {
    public static var typeName: String { "### " }
}

public enum Break: Close {}
extension Break {
    public static var typeName: String { "\n\n" }
}

/// This forces a line break WITHIN one block: two trailing spaces before the newline, the
/// CommonMark "hard break" (checked directly: a bare `Newline` inside an aside collapses to a
/// single space in the rendered model, a soft break. This does not). It is the only way to get
/// a second visual line inside the SAME `> Note: …` box without a blank line, which would close
/// the aside instead.
public enum HardBreak: Close {}
extension HardBreak {
    public static var typeName: String { "  \n" }
}

public enum Pipe: Close {}
extension Pipe {
    public static var typeName: String { "| " }
}

public enum PipeSep: Close {}
extension PipeSep {
    public static var typeName: String { " | " }
}

/// This renders a breadcrumb's own separator: `Parent › Child`, the same trail `Nav`/`Place`
/// (Site.swift) already reads through `Up`.
public enum Chevron: Close {}
extension Chevron {
    public static var typeName: String { " › " }
}

/// This renders the GFM header-delimiter cell (`---`): a `TableCell { RuleMark.self }` reads
/// exactly like any other cell, so a header's own rule row is written with the same
/// `TableRow { TableCell { … } }` shape as the header itself, one `RuleMark` per column. GFM
/// (and DocC's renderer) needs this delimiter line to tell a header from an ordinary
/// row. A grid missing it renders as one run-together paragraph, not a table. Named `RuleMark`,
/// not `Dash`, because `Alphabet.swift` already has a `Dash` (a single `-`, a prose glyph).
public enum RuleMark: Close {}
extension RuleMark {
    public static var typeName: String { "---" }
}

public enum Bullet: Close {}
extension Bullet {
    public static var typeName: String { "- " }
}

public enum Callout: Close {}
extension Callout {
    public static var typeName: String { "> " }
}

public enum ColonSpace: Close {}
extension ColonSpace {
    public static var typeName: String { ": " }
}

public enum OpenBrace: Close {}
extension OpenBrace {
    public static var typeName: String { " {\n" }
}

public enum CloseBrace: Close {}
extension CloseBrace {
    public static var typeName: String { "}\n" }
}

// ── Word atoms ──

public enum NoteLabel: Close {}
extension NoteLabel {
    public static var typeName: String { "Note" }
}

public enum ImportantLabel: Close {}
extension ImportantLabel {
    public static var typeName: String { "Important" }
}

public enum WarningLabel: Close {}
extension WarningLabel {
    public static var typeName: String { "Warning" }
}

public enum TipLabel: Close {}
extension TipLabel {
    public static var typeName: String { "Tip" }
}

public enum TabNavigatorLabel: Close {}
extension TabNavigatorLabel {
    public static var typeName: String { "TabNavigator" }
}

public enum TabLabel: Close {}
extension TabLabel {
    public static var typeName: String { "Tab" }
}

public enum LinksLabel: Close {}
extension LinksLabel {
    public static var typeName: String { "Links(visualStyle: detailedGrid)" }
}

public enum RowLabel: Close {}
extension RowLabel {
    public static var typeName: String { "Row" }
}

public enum ColumnLabel: Close {}
extension ColumnLabel {
    public static var typeName: String { "Column" }
}

// ── Reference — ``Target`` ──

public protocol Reference: Open {
    associatedtype Target: Structure
}
extension Reference {
    @StructureBuilder
    public static var body: some Structure {
        Backtick.self
        Backtick.self
        Target.self
        Backtick.self
        Backtick.self
    }
    public init(@StructureBuilder _ target: () -> Target) { fatalError() }
}
/// This renders `Target` as a symbol link, read at render (the type's name, backtick-quoted).
public enum Symbol<
    Target: Structure
>: Reference {}

/// This reads a type's Swift name, never its rendered content: `X.typeName` walks `X`'s `body`
/// (that is the whole point of the cascade everywhere else), but a link needs the page's ID,
/// not the page's content embedded inline. `String(describing:)` reads the bare identifier
/// regardless of what `X` composes, so linking to an actual `Screen` (real body, real content)
/// does not inline that screen's whole rendering into the link.
/// This renders a bare curation link, `<doc:Name>`: the one form DocC's Topics accept for
/// nesting an article under another, read off the type name like every address.
public enum TopicReference<X>: Close {}
extension TopicReference {
    public static var typeName: String { "<doc:\(RawName<X>.typeName)>" }
}
public enum RawName<X>: Close {}
extension RawName {
    public static var typeName: String { String(describing: X.self) }
}

/// This gives a double-backtick reference to a PROTOCOL, the same visible shape `Symbol` gives
/// a concrete type, for the one case `Symbol` cannot take: `Symbol<Target: Structure>` requires
/// a concrete, `Structure`-conforming type, and a bare protocol (`CanView`, a directory) is
/// neither concrete nor, by itself, `Structure`-conforming: `Symbol { CanView.self }` does not
/// compile (checked directly). `X` carries no constraint at all, exactly `RawName`'s door, so
/// any protocol name fits.
public enum ProtocolReference<X>: Close {}
extension ProtocolReference {
    public static var typeName: String { "``" + String(describing: X.self) + "``" }
}

// ── DocLink — <doc:Target>, a link to a rendered page (not a declared Swift symbol) ──

public protocol DocLink: Open {
    associatedtype Target: Structure
}
extension DocLink {
    @StructureBuilder
    public static var body: some Structure {
        AngleOpen.self
        Letter.d.self
        Letter.o.self
        Letter.c.self
        Colon.self
        RawName<Target>.self
        AngleClose.self
    }
    public init(@StructureBuilder _ target: () -> Target) { fatalError() }
}
/// This renders `<doc:Target>`, a link to another rendered page, by its page id.
public enum Page<
    Target: Structure
>: DocLink {}

// ── TitledLink — [Label](doc:Target), a link with its own display text ──

public protocol TitledLink: Open {
    associatedtype Label: Structure
    associatedtype Target: Structure
}
extension TitledLink {
    @StructureBuilder
    public static var body: some Structure {
        SquareOpen.self
        Label.self
        SquareClose.self
        ParenOpen.self
        Letter.d.self
        Letter.o.self
        Letter.c.self
        Colon.self
        RawName<Target>.self
        ParenClose.self
    }
}
/// This renders `[Label](doc:Target)`, a link whose display text is chosen, not the target's
/// name. Two holes, one `{ }` body of two statements, the same `Paired.Left`/`.Right` reading
/// generic prose entries with more than one hole use (`Tools/Prose.swift`).
public enum Link<
    Whole: Pair
>: TitledLink
where Whole.Left: Structure, Whole.Right: Structure {
    public typealias Label = Whole.Left
    public typealias Target = Whole.Right
    public init(@StructureBuilder _ content: () -> Whole) { fatalError() }
}

// ── Picture: ![Alt](Asset), an image embedded IN the body, distinct from `@PageImage`
// (Metadata, written at the render boundary in OrgDemo): that shows a page's picture only when
// the page is a TILE in a link grid; this shows it on the page itself, the way a hero image
// reads. Checked directly: a page with only `@PageImage` and no `Picture` in its own body shows
// no image at all when you navigate to the page directly — the two are not the same door.
// `Asset` is a plain `Close` naming an asset file (its own `typeName` IS the file's bare name,
// no `RawName` indirection needed — there is no body to recurse into).
public protocol ImageEmbed: Open {
    associatedtype Alt: Structure
    associatedtype Asset: Structure
}
extension ImageEmbed {
    @StructureBuilder
    public static var body: some Structure {
        Exclamation.self
        SquareOpen.self
        Alt.self
        SquareClose.self
        ParenOpen.self
        Asset.self
        ParenClose.self
    }
}
/// This renders `![Alt](Asset)`, two holes, the same `Whole: Pair` fold `Link` uses.
public enum Picture<
    Whole: Pair
>: ImageEmbed
where Whole.Left: Structure, Whole.Right: Structure {
    public typealias Alt = Whole.Left
    public typealias Asset = Whole.Right
    public init(@StructureBuilder _ content: () -> Whole) { fatalError() }
}

// ── Tally — a Structure's count, rendered as digits ──

/// This is the concrete count-reader, never spelled directly: call ``Tally(_:)``. Not `Open`,
/// it has nothing to compose, only a derived string to show, and a `Close` is written ONLY as
/// an empty enum, no cases, no `init` (Law, Primitive.swift), so it cannot take the
/// `init`-is-the-door shortcut every `Open` combinator above uses. A free function is the one
/// place that shortcut is unavailable, not a choice.
public typealias TallyKind<
    Of: Structure
> = VerificationIsIdentification.Tally<Of>
/// This renders the count of a `Structure` as its digits, the boundary where a type-level fold
/// (`count`, VerificationIsIdentification) becomes visible text, the way ``Symbol`` gives a
/// type's name.
public func Tally<
    Of: Structure
>(_ of: () -> Of.Type) -> TallyKind<Of>.Type { TallyKind<Of>.self }

// ── Title — # Content\n\n ──

public protocol Title: Open {
    associatedtype Content: Structure
}
extension Title {
    @StructureBuilder
    public static var body: some Structure {
        Hash.self
        Space.self
        Content.self
        Break.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum PageTitle<
    Content: Structure
>: Title {}

// ── Section: ## Heading\n\nContent\n\n, no combinator: a page's own body just writes the
// five atoms directly (`DoubleHash.self; Heading.self; Break.self`, then the content, then
// `Break.self`). The pattern is five atoms; writing it inline each time is not repetition worth
// a combinator, the same call made for ``CountRow``/``Ratio`` (Organization).

// ── Note ──

public protocol Note: Open {
    associatedtype Message: Structure
}
extension Note {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        NoteLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Noted<
    Message: Structure
>: Note {}

// ── Important ──

public protocol Important: Open {
    associatedtype Message: Structure
}
extension Important {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        ImportantLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Flagged<
    Message: Structure
>: Important {}

// ── Warning ──

public protocol Warning: Open {
    associatedtype Message: Structure
}
extension Warning {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        WarningLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Warned<
    Message: Structure
>: Warning {}

// ── Tip ──

public protocol Tip: Open {
    associatedtype Message: Structure
}
extension Tip {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        TipLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Tipped<
    Message: Structure
>: Tip {}

// ── Grid ──

public protocol Grid: Open {
    associatedtype Rows: Structure
}
extension Grid {
    @StructureBuilder
    public static var body: some Structure {
        Rows.self
        Newline.self
    }
    public init(@StructureBuilder _ rows: () -> Rows) { fatalError() }
}
public enum Table<
    Rows: Structure
>: Grid {}

// ── Row ──

public protocol Row: Open {
    associatedtype Cells: Structure
}
extension Row {
    @StructureBuilder
    public static var body: some Structure {
        Pipe.self
        Cells.self
        Newline.self
    }
    public init(@StructureBuilder _ cells: () -> Cells) { fatalError() }
}
public enum TableRow<
    Cells: Structure
>: Row {}

// ── Field ──

public protocol Field: Open {
    associatedtype Content: Structure
}
extension Field {
    @StructureBuilder
    public static var body: some Structure {
        Content.self
        PipeSep.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum TableCell<
    Content: Structure
>: Field {}

// ── Item ──

public protocol Item: Open {
    associatedtype Content: Structure
}
extension Item {
    @StructureBuilder
    public static var body: some Structure {
        Bullet.self
        Content.self
        Newline.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum ListItem<
    Content: Structure
>: Item {}

// ── Tabs ──

public protocol Tabs: Open {
    associatedtype Content: Structure
}
extension Tabs {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        TabNavigatorLabel.self
        OpenBrace.self
        Content.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum TabGroup<
    Content: Structure
>: Tabs {}

// ── Tab: @Tab("Title") { Content }, no combinator, the same call as ``Section`` above: a
// page's own body writes the atoms directly. DocC requires the parenthesized form — a bare
// `@Tab "Title"` does not parse (checked directly: "Missing argument for unlabeled parameter"). ──

// ── Links ──

public protocol Links: Open {
    associatedtype Content: Structure
}
extension Links {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        LinksLabel.self
        OpenBrace.self
        Content.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum LinkGrid<
    Content: Structure
>: Links {}

// ── Columns ──

public protocol Columns: Open {
    associatedtype Panels: Structure
}
extension Columns {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        RowLabel.self
        OpenBrace.self
        Panels.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ panels: () -> Panels) { fatalError() }
}
public enum SideBySide<
    Panels: Structure
>: Columns {}

// ── Panel ──

public protocol Panel: Open {
    associatedtype Content: Structure
}
extension Panel {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        ColumnLabel.self
        OpenBrace.self
        Content.self
        Newline.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum PanelOf<
    Content: Structure
>: Panel {}

// ── SizedPanel — @Column(size: N) { Content }, a panel that also states its relative weight ──
//
// The weight is a TYPE, not a computed value: `TextDigit._2` reads "2" the same way it reads a
// password digit. Nothing here counts or measures anything, the caller states the weight
// directly, the way a `where` clause states a constraint rather than solving for one. This is
// deliberately NOT a general layout solver: GFM/markdown tables have no column-width primitive
// at all (checked directly, there is no syntax to carry a computed width to), and DocC's own
// `@Column` only ever takes a relative weight, never a size a solver would compute. `SizedPanel`
// is the one foothold this render target actually has, not a first step toward one that
// does not exist.

/// The markdown surface reads the same magnitudes the vector surface weighs: a column's
/// relative size is a count-structure's reading, digits born at this one door. One lexicon
/// of magnitudes serves both media. Only the reading differs by surface.
public enum WeightOf<S: Structure>: Close {}
extension WeightOf {
    public static var typeName: String { String(S.count) }
}

public protocol WeightedPanel: Open {
    associatedtype Content: Structure
    associatedtype Weight: Structure
}
extension WeightedPanel {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        ColumnLabel.self
        ParenOpen.self
        Letter.s.self; Letter.i.self; Letter.z.self; Letter.e.self; Colon.self; Space.self
        Weight.self
        ParenClose.self
        OpenBrace.self
        Content.self
        Newline.self
        CloseBrace.self
    }
}
/// This renders `@Column(size: Weight) { Content }`, two holes, the same `Whole: Pair` fold
/// `Link`/`Picture` use. The door is HERE, not on `WeightedPanel`'s extension, because
/// `Whole` is not one of the protocol's associated types, the same shape `Link`/`Picture`
/// already settled on for every two-hole combinator.
public enum SizedPanel<
    Whole: Pair
>: WeightedPanel
where Whole.Left: Structure, Whole.Right: Structure {
    public typealias Content = Whole.Left
    public typealias Weight = Whole.Right
    public init(@StructureBuilder _ content: () -> Whole) { fatalError() }
}

// ── Frame — content in a one-cell table. One header cell, a delimiter row, no body rows: the
// minimum a GFM table needs to be a table at all (Surface Law: a delimiter row is not optional,
// RuleMark's whole reason for existing). Lightweight because it reuses Table/TableRow/TableCell
// as-is, no new atoms, no new rendering path.
//
// > Warning: checked directly. DocC's theme does not draw a full ring around a table cell, so
// > `Framed` alone reads as left-aligned content, not a bordered box. A drawn border was tried
// > and removed (SurfaceLaw §S19/§S20): this render target has no primitive for one.

public protocol Frame: Open {
    associatedtype Content: Structure
}
extension Frame {
    @StructureBuilder
    public static var body: some Structure {
        Table {
            TableRow { TableCell { Content.self } }
            TableRow { TableCell { RuleMark.self } }
        }
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum Framed<
    Content: Structure
>: Frame {}

// ── CodeFence: ```swift\nContent\n```, a real Swift call site, fenced so DocC renders it as
// code rather than prose. `Reference`/`DocLink`/etc. above show a combinator's OUTPUT. This
// shows the call that produced it, the thing a developer copies. `Content` is always a literal
// snippet (a `Close` atom whose `typeName` IS the source text), never derived from the type it
// documents: there is no reflection from a `body`'s type-level composition back to the Swift
// source that wrote it, so the two are kept side by side by hand and must be kept in sync by
// hand, the same discipline `TwoRowGrid`'s hand-stated `Total` already relies on.

public enum TripleBacktickSwift: Close {}
extension TripleBacktickSwift {
    public static var typeName: String { "```swift\n" }
}

public enum TripleBacktick: Close {}
extension TripleBacktick {
    public static var typeName: String { "```\n" }
}

public protocol CodeFence: Open {
    associatedtype Content: Structure
}
extension CodeFence {
    @StructureBuilder
    public static var body: some Structure {
        TripleBacktickSwift.self
        Content.self
        Newline.self
        TripleBacktick.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum CodeSample<
    Content: Structure
>: CodeFence {}

// ── Spacer: a column that holds only width, no content. `Content` is fixed to `Never` (the
// lattice's own empty leaf, `typeName = ""`), so there is nothing to compose, only a weight to
// state. No `{ }` door, `Spacer<TextDigit._1>.self` is complete on its own, a bare metatype
// leaf the same as `Alice.self` anywhere else. Flank real content with two of these to get
// horizontal padding, the cheapest read of "insert something that holds space."

public enum Spacer<
    Weight: Structure
>: WeightedPanel {
    public typealias Content = Never
}

// ── Gap: the rule of behavior belongs to the SPACE, not to either neighbor. `Gap<Left,
// Right>` names what is adjacent; its own `typeName` is the width, chosen by which specific
// pairing matched, never stored as a property on `Left` or `Right`. No neighbor ever states
// "my own margin," so there is nothing for two neighbors' margins to disagree about (the
// classic CSS collapse). One type reads the boundary, once. The default (no more specific
// `where` matched) is zero: adjacent by default, spaced only where a pairing says so.
//
// > Warning: this is the SAME shape `Capability` (Organization/View/Cells.swift, Surface Law
// > §S12) already hit: a type whose `typeName` picks among several `where`-conditioned
// > extensions reads correctly ONLY at a literal, concrete call site (`Gap<Quiet, Loud>.self`,
// > written directly), never through a generic parameter standing in for `Left`/`Right`. This
// > is not a general "the compiler infers the right gap between any two things" mechanism. It
// > is a literal lookup table, one entry at a time, the same discipline Cells.swift's proxies
// > already use for access.

public protocol Gap: Structure {
    associatedtype Left
    associatedtype Right
}
public enum SpaceBetween<
    Left,
    Right
>: Gap {}
extension SpaceBetween {
    public static var typeName: String { "" }
}

// ── SpacerBetween — the same rule (the pairing chooses, not either neighbor), rendering a
// real `@Column(size:)` weight instead of text spaces: a `Gap` meant to sit inside a
// `SideBySide` row, next to `PanelOf`/`SizedPanel`. Default weight 1 (a thin gap, never zero:
// a zero-weight `@Column` is still a column DocC has to lay out, unlike `SpaceBetween`'s "" for
// plain text, so the floor here is the thinnest real column, not none at all).
//
// > Warning: read this only through a non-generic proxy (§S17). Used directly as a body leaf,
// > it folds into `Paired` the same as any other statement, and reads the unconditional default
// > regardless of which pairing it names.

public enum SpacerBetween<
    Left,
    Right
>: Gap {}
extension SpacerBetween {
    public static var typeName: String { Spacer<WeightOf<Unit>>.typeName }
}

// ── TwoRowGrid: several `SideBySide` rows read as ONE grid only when they agree on how wide
// they are, total: `2 3 5` and `3 1 6` sit in the same grid because both add to 10, whatever
// they each split it into. There is no type-level ADDITION here to check that a row's
// weights truly sum to what it claims (`IntegerValued`'s `Right` is an ASSOCIATED type, and
// Swift resolves an associated type once per concrete type, never per `where` clause: the
// same wall §S12 already names for a static witness, harder still for a type derived by
// recursion). What IS checked, for real: each row states its own `Total` by hand (the same
// discipline `Y2029: Cycle { Length = Three }` already uses, ReviewCycle.swift; the script
// decides only WHEN, never derives WHICH), and `TwoRowGrid` requires `Row1.Total == Row2.Total`
// as a `where` clause on its own `body`. A row whose declared total does not match its
// partner's does not get a `body` at all, so the grid fails to compile, not fails to align.

public protocol HasTotal {
    associatedtype Total: IntegerValued
}
public protocol TwoRowGrid: Open {
    associatedtype Row1: HasTotal & Structure
    associatedtype Row2: HasTotal & Structure
}
extension TwoRowGrid
where Row1.Total == Row2.Total {
    @StructureBuilder
    public static var body: some Structure {
        Row1.self
        Break.self
        Row2.self
    }
}
