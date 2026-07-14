// THE SURFACE LAW states how every combinator in the rendering layer must be written.
//
// The lattice's law (VerificationIsIdentification/Law.swift) governs the theory: pure types,
// no runtime, ever. `init` itself is forbidden there (§0′). The surface is one level up. It
// renders the lattice as text, so it needs a construction the theory does not: a `{ }`-callable
// shorthand for a generic leaf (`Symbol { Alice.self }` instead of `Symbol<Alice>.self`). This
// file is that one exception, stated once, so it reads as a decision and not a drift. `Tools
// surface` (SurfaceLint.swift) checks the checkable subset on every build; the rest is checked
// by review, the same split the core Law uses.

/// How every combinator on the rendering surface must be written: the grammar the whole View
/// layer speaks, one level above `Law`.
///
/// - term Combinator: a markup shape with one hole (`Symbol`, `TableCell`, `Table`, …),
///   an `Open` protocol carrying the hole (`associatedtype`) and the composition (`body`), realized
///   by a caseless `enum`.
/// - term Hole: the one thing that varies per use: `Target`, `Content`, `Message`, `Rows`, …
///   Always the protocol's `associatedtype`, not the enum's.
/// - term Door: the `{ }` call a hole is filled through, at the one place Swift allows it:
///   `init`, a member, not a second name.
///
/// ## §S1 · A combinator is a protocol, realized by an empty enum
///
/// ```swift
/// public protocol Reference: Open { associatedtype Target: Structure }
/// extension Reference {
///     @StructureBuilder public static var body: some Structure { Backtick.self; Target.self; Backtick.self }
/// }
/// public enum Symbol<Target: Structure>: Reference {}
/// ```
///
/// The protocol carries everything reusable: the hole and the composition that reads it. The
/// enum carries nothing: a bare name and its conformance. Two combinators sharing a hole name
/// (`Content`) still get two protocols: `body` differs, so the composition is not shared, only
/// the letter of the name is.
///
/// ## §S2 · Only protocol and enum
///
/// A `struct` or `class` can hold a runtime value. The surface holds none: every realizer is a
/// caseless `enum`, every category a `protocol`. `Tools grammar` rejects a `struct`/`class`/`actor`
/// on the surface (checked on every build).
///
/// ## §S3 · A door where a door exists — bare angles where none can
///
/// A combinator that HAS a door (an `Open` kind with its `init`, §S5) is always called
/// through it: `TableCell { Symbol { Alice.self } }`, not `TableCell<Symbol<Alice>>.self`.
/// Composition nests, and `{ }` reads left-to-right, the way the rendered text itself is built.
///
/// Two shapes have no door to offer, and their use sites lawfully read the bare generic leaf,
/// formatted by the angle rule (core Law §0″, "Angles open like a tree"):
///
/// - a `Close` READER: ``RawName`` (§S10), `ProtocolReference`, a verdict proxy, a derived
///   line. A `Close` is an empty enum. An `init` is a member it cannot carry (core Law §0″), so
///   the door is structurally unavailable: `ProtocolReference<any Workplace>.self` is its one
///   spelling, not a lapse.
/// - a page-local `Fragment` whose parameter is a single named type (a cut, a person, a team)
///   consumed by one page: a door there buys nothing back (§S8's test): `TimelineRow<
///   Cut2026>.self` reads as what it is, one row derived from one anchor.
///
/// > Note: neither is a hand-written cons-chain (the thing §6 of the core lattice's
/// > authored-layer check forbids, `Paired`/`Cons`/`Seq` spelled by hand). Both are ordinary
/// > generic instantiation, the same shape as `Array<Int>`. The line to hold: where content
/// > COMPOSES, the door. Where a parameter NAMES, the angles, and not a `Kind`-suffixed
/// > second name to fake a door where none exists (§S4's warning, from the other side).
///
/// ## §S4 · No free functions — the door is `init`, a member, not a second name
///
/// Swift will not let a type and a free function share one name: `enum Symbol<T>` and
/// `func Symbol(...)` collide (checked directly: "invalid redeclaration"). An `init` has no such
/// problem: it is a member of the type it constructs, not a second top-level declaration, so
/// `Symbol { Alice.self }` calls `Symbol.init(_:)` the same way `String(...)` calls `String`'s.
/// No `Kind`-suffixed second name, nothing to route around.
///
/// > Warning: a bare `Capitalized` free function is still forbidden (`Tools grammar` rejects it).
/// > The one exception is a door whose signature carries `.Type` (a metatype in, a metatype
/// > out), the mark that a category could not take the `init` shortcut. `Tally` is the reason
/// > the exception exists: it is `Close`, and a `Close` is written ONLY as an empty enum, no
/// > cases, no `init` (core Law §0″). A free function plus a hidden `Kind`-suffixed type is what
/// > is left when the shortcut itself is unavailable, not a choice made for convenience.
///
/// ## §S5 · The door lives on the protocol, not the enum
///
/// A protocol extension can default an `init` for every conformer, without declaring `init` a
/// protocol requirement (checked directly). So the door is written once, next to `body`, in the
/// SAME extension:
///
/// ```swift
/// extension Reference {
///     @StructureBuilder public static var body: some Structure { … }
///     public init(@StructureBuilder _ target: () -> Target) { fatalError() }
/// }
/// public enum Symbol<Target: Structure>: Reference {}   // nothing but the name
/// ```
///
/// Writing the same `init` again on every enum is not wrong, only repetitive: the protocol
/// already holds the hole (`Target`) the `init` closes over, the same associated type `body`
/// already reads.
///
/// ## §S6 · A door's hole is typed as a value, not a metatype
///
/// ```swift
/// public init(@StructureBuilder _ target: () -> Target) { fatalError() }   // right
/// public init(_ target: () -> Target.Type) { fatalError() }                // wrong — breaks nesting
/// ```
///
/// A leaf like `Alice.self` is a metatype (`Alice.Type`), but a NESTED combinator call
/// (`Symbol { Alice.self }`, used as someone else's hole) is already a VALUE of type
/// `Symbol<Alice>`: its `init` produced it. A hole typed `() -> Target.Type` accepts the
/// first case and rejects the second (checked directly: "generic parameter could not be
/// inferred"), so every door's hole is `@StructureBuilder () -> Target`, not `.Type`. The
/// builder's `buildExpression` converts either a bare metatype or an already-built value into
/// the same leaf.
///
/// ## §S7 · The `init` never runs — nothing downstream ever calls it
///
/// `typeName`/`count`/`labels` read `Body.typeName`, a static property of an ASSOCIATED TYPE,
/// resolved once at compile time. Nothing constructs an instance to get there, so a door's
/// `fatalError()` body is not reached in real use (checked directly: a leaf embedded in
/// another type's `body` does not run, only a bare top-level `let x = Symbol { … }` would, and
/// nothing on the surface writes that). The `init` exists for the CALL SYNTAX and the generic
/// inference alone.
///
/// > Note: The compiler prints this law back. A body's statements produce values of uninhabited
/// > types, so every statement after the first is flagged "will never be executed", thousands
/// > of them on a clean build, one per composed leaf. That is §S7 stated by the diagnostics
/// > engine, the design's signature and not a defect: the bodies exist to be READ as types,
/// > never to run. The count is large exactly because the composition is. Silencing it would
/// > take an inhabited carrier through the whole builder, a redesign parked until it earns
/// > itself.
///
/// ## §S8 · A combinator earns its protocol by genuine reuse
///
/// A protocol-plus-enum pair is worth writing when many different holes fill the same shape:
/// `Symbol` wraps hundreds of distinct types across every page. It is not worth writing for a
/// small, closed, named set that will not grow: the department/rank/workplace facets (ten rows,
/// Organization/View/Employees.swift's `FinanceCountRow`, `LeadCountRow`, …) are ten plain named
/// enums, no generic, no door, the same call already made for the four-person named team
/// (`Alice`, `Bob`, `Carol`, `Dave`, hand-enumerated everywhere they appear). Fewer than a
/// handful of uses, over a set that will not scale, does not buy back a combinator's cost.
///
/// > Tip: the test is not the current use count, it is whether the set could ever grow. `Symbol`
/// > gains a use every time a new page names a new type — genuinely open-ended. A department
/// > facet does not gain a fourth workplace next quarter.
///
/// ## §S9 · A multi-hole combinator still takes one door, not several
///
/// A combinator with N holes (four in `OwnersLine`, two in `Link`) still gets exactly one
/// `@StructureBuilder` `init` parameter, not one parameter per hole. The builder folds the N
/// statements left-associatively into nested `Paired`s (`Primitive.swift`'s `buildPartialBlock`):
/// for holes `s1…sN`, the fold is `Paired<Paired<…Paired<s1,s2>…,s(N-1)>,sN>`. A single generic
/// parameter `Whole: Pair` captures whatever the builder produced, and each hole is read back off
/// it by a `.Left`/`.Right` path:
///
/// ```swift
/// public enum Link<Whole: Pair>: TitledLink where Whole.Left: Structure, Whole.Right: Structure {
///     public typealias Label = Whole.Left
///     public typealias Target = Whole.Right
///     public init(@StructureBuilder _ content: () -> Whole) { fatalError() }
/// }
/// // Link { TextDigit._1.self; SomeTarget.self } — one body, two statements, not two parameters.
/// ```
///
/// > Warning: a function taking N separate closure parameters (`init(_ a: ..., _ b: ...)`) or N
/// > labeled trailing closures (`Foo { } b: { }`) was tried first and rejected. Both read as a
/// > parenthesized call wearing `{ }` as a costume. One `@StructureBuilder` parameter, many
/// > statements, is the only shape that reads as what it is: a body.
///
/// ## §S10 · A link reads the target's bare name, never its rendered content
///
/// `Target.typeName` walks `Target`'s `body`, correct for a combinator, wrong for a link. Linking
/// to a `Screen` with real content (`Page { EmployeesPage.self }`) would inline that whole page's
/// rendering inside the `<doc:…>` parentheses, because `DocLink`'s body composes `Target.self`
/// directly, and `Open.typeName` always walks down to `Body.typeName` (checked directly: a link
/// to a body-less marker like `Nav.Employees` renders fine, since it has no body to walk into.
/// A link to an actual `Screen` does not). The fix is a wrapper that
/// reads the identifier and stops there:
///
/// ```swift
/// public enum RawName<X>: Close {}
/// extension RawName { public static var typeName: String { String(describing: X.self) } }
/// // DocLink's body composes `RawName<Target>.self`, not `Target.self` directly.
/// ```
///
/// > Note: this is also why the `Nav` enum (Site.swift) exists as a SEPARATE set of body-less
/// > markers from the real `Screen` types they name: `Nav.Employees` is an address, `EmployeesPage`
/// > is the content. `RawName` makes that separation unnecessary for anything new: a link can
/// > name the real page directly.
///
/// ## §S11 · There is no fifth door — Swift has no higher-kinded types
///
/// A combinator's hole is always a concrete type (or a `Pair` of them, §S9), not another
/// generic type, unapplied, waiting for its arguments. `Foo<Bar, Int, String>` meaning "apply
/// `Bar` to `Int` and `String`" does not exist in Swift: a bare generic name like `Bar` has no
/// type of its to be a parameter with (checked directly: passing an unapplied generic as a
/// type argument fails with "generic parameter could not be inferred", not a workaround-able
/// error). This is the reason a combinator's protocol names each hole directly
/// (`associatedtype Target`) rather than taking a template it fills. There is no fifth door
/// (function, `init`, `<>`, `Pair`-fold) that reaches around this one.
///
/// ## §S12 · A verdict with more than one `where` needs a literal read, not a combinator
///
/// A cell whose `typeName` picks among several conditional extensions at different
/// specificities (`Capability`, `ViewCapability`, Organization/View/Cells.swift) reads correctly
/// at a literal call site, but reads the BASE case, wrong, the moment that reference passes
/// through ANY generic layer between the literal instantiation and the `.typeName` read. A door's
/// `init`, a shared protocol default, an associated-type delegate, or a plain generic function all
/// reproduce it identically (each checked directly, Cells.swift's header). This is not one of the
/// eleven rules above with a workaround: the fix is a NON-GENERIC proxy per concrete case,
/// resolved once at a literal site (`AliceFinanceView`, …), with nothing generic between that
/// resolution and its use. See Cells.swift for the full derivation: this entry exists so the
/// symptom (a verdict silently reading the wrong case) is recognized fast, not re-derived.
///
/// ## §S13 · A DocC directive's own argument syntax is never assumed, only checked
///
/// `@Tab` takes its title in parentheses (`@Tab("Title")`), not a bare quoted string after a
/// space (checked directly: `@Tab "Title"` fails with "Missing argument for unlabeled
/// parameter". The atoms read `TabLabel.self; ParenOpen.self; Quote.self; …`). Every other
/// directive used here (`@Row`, `@Column`, `@TabNavigator`, `@Links`, `@Metadata`,
/// `@PageImage`) was checked the same way before its atoms were written. DocC's directive
/// grammar is not uniform across directives, so a new one is checked, not patterned off the
/// last one that worked.
///
/// ## §S14 · A combinator's own closing brace needs its own trailing newline
///
/// `Content.self` composed directly against `CloseBrace.self` (no atom between them) glues
/// whatever `Content` last rendered onto the same line as the `}`. DocC then fails to find the
/// directive's end and reports the block as unterminated (checked directly:
/// `"'Row' contains unexpected content"`, `"'Tab' directive is unsupported as a child of the
/// 'Tab' directive"`, both symptoms of the SAME missing newline, in `Panel`'s body and in a
/// hand-written `@Tab { … }` block alike). Every combinator whose body ends `Content.self;
/// CloseBrace.self` needs a `Newline.self` between them, unconditionally: harmless when
/// `Content` already ended in one (an extra blank line inside a directive body parses fine),
/// load-bearing when it did not.
///
/// ## §S15 · A cheap effect reuses an existing combinator, not a new rendering path
///
/// `Framed` (a border) is `Table { TableRow { TableCell { Content.self } }; TableRow { TableCell
/// { RuleMark.self } } }`, a one-cell table, nothing new rendered, just `Table`/`TableRow`/
/// `TableCell` called a specific way. `SizedPanel` (a relative column weight, `@Column(size:
/// N)`) reads `N` through `WeightOf` off the SAME magnitude lexicon the vector surface
/// weighs (`U2`, `Plus`, the house count): both media share one axis of magnitudes, and each
/// surface only chooses its reading — `SpanPx` divides a fraction to a pixel, `WeightOf`
/// reads a count as a relative weight. A weight is stated, not computed, the same discipline
/// `Tally` keeps for `count` (the number comes from what compiles, not from arithmetic
/// written by hand). Neither combinator
/// needed a new atom or a new witness ability. The tell that an effect is cheap enough to build
/// is that it composes entirely from what already exists.
///
/// > Note: `SizedPanel` is not a general layout solver, and is not trying to become one. GFM
/// > markdown tables have no column-width primitive at all (checked directly: there is no
/// > syntax to carry a computed width to), so `@Column(size:)`'s relative weight is the one
/// > foothold this render target actually has. A constraint system with nowhere to send its
/// > answer is not a feature not yet built, it is a wall: see it and stop, the same as §S11.
///
/// ## §S16 · `typeName` is not tail-recursive — one `Structure` has a practical size limit
///
/// `Paired.typeName = L.typeName + R.typeName` (Primitive.swift) concatenates AFTER both sides
/// return, so it is not a tail call. Every level of composition is a real stack frame, in a
/// release build too (checked directly: a `Structure` whose `body` held twelve substantial
/// sections crashed `EXC_BAD_ACCESS` inside `Paired.typeName.getter`, in both debug and release,
/// while every one of those sections rendered fine read separately). The fix is not a deeper
/// stack, it is fewer statements in one `body`: prefer several linked pages, the same design
/// Organization's showcase already uses for 235 pages, over one page whose composition
/// tries to hold everything. A single `Structure` should read as one screen's worth of content,
/// not a whole site flattened into one type.
///
/// ## §S17 · §S12's trap is not about generic FUNCTIONS — it is about `@StructureBuilder` itself
///
/// A multi-`where` type (`Gap`'s `SpaceBetween<Left, Right>`, the same shape as `Capability`)
/// read the wrong, unconditional case even used seemingly directly as a body leaf:
/// `SpaceBetween<Quiet, Loud>.self`, written literally, with no function or protocol default in
/// sight (checked directly: rendered "" instead of the specific override). The reason: any
/// statement inside a `@StructureBuilder` body is folded into a `Paired<L, R>`
/// (`buildPartialBlock`, Primitive.swift), and `Paired`'s `typeName` extension reads `L`/`R`
/// through ITS generic parameters, so EVERY leaf in EVERY body is, unavoidably, read through
/// generic indirection, whether the source line looks literal or not. §S12's fix reads the same:
/// a non-generic proxy, its `typeName` resolving the specific case ONCE, in a declaration
/// with no enclosing generic parameter to blur it. Then the proxy, not the multi-`where`
/// type itself, is what a body composes.
///
/// ## §S18 · A shared total is checked by equality, never by type-level addition
///
/// `TwoRowGrid` (`2 3 5` and `3 1 6`, both summing to 10) requires `Row1.Total == Row2.Total`,
/// checked directly both ways: the matching grid compiles, and changing either row's declared
/// `Total` to a different marker makes the grid fail with "does not conform to protocol Open",
/// no `body` to inherit, a build error at the type, not a rendering mismatch caught later.
/// What is NOT checked, and could not be with this mechanism: that a row's weights truly
/// add up to what it claims. `IntegerValued`'s `Right` (VerificationIsIdentification) is an
/// ASSOCIATED type, and Swift resolves an associated type once per concrete type, not
/// conditionally per `where` clause, the same wall §S12 names for a static witness, and a
/// harder one for a value meant to be DERIVED by recursion rather than read off one case. So
/// each row states its total by hand, the same discipline `Y2029: Cycle { Length = Three }`
/// already uses (ReviewCycle.swift). The type system verifies the two DECLARATIONS agree,
/// not that either declaration is arithmetically correct. A real guarantee, smaller than it
/// first sounds: use it knowing which half is proved.
///
/// ## §S19 · `@Column(size:)`'s width, and several `Picture`s in one cell, are not visible:
/// checked in an actual browser, not guessed from the JSON model
///
/// Two more limits of this render target, found the same way §S16 was: by looking, not by
/// trusting the data model. `@Column(size: N)` is recorded correctly (`numberOfColumns` sums
/// every weight, each column reports its `size`, confirmed in the archive's JSON), but
/// THIS renderer draws every column the same width regardless, and several `Picture`s with no
/// atom between them do not sit side by side the way inline images do in ordinary HTML. They
/// stack VERTICALLY, one under the next, turning a "wider" bar into a "taller" one instead. The
/// one thing already confirmed to flow horizontally by its default is TEXT: `Gap`'s
/// repeated spaces render exactly as wide as they are (`SpaceBetween`, §S17), so a bar built
/// from a repeated CHARACTER (`Block`, "█") shows its proportion the same way a word's
/// length always has, no directive, no image, nothing for a renderer to choose whether to
/// honor. When a demonstration needs to be seen, not just correctly modeled, prefer the
/// primitive already proven to render the same everywhere over the one whose visible form is
/// the renderer's choice.
///
/// ## §S20 · Space is one mechanism: repeat one unit exactly N times, not three
///
/// `Spacer` (invisible), `Block`'s bars (filled), and a text frame's edges (`HLine`/`VLine`,
/// ruled) look like three features. They are one: state a unit and a count, by hand (the same
/// discipline `Y2029: Cycle { Length = Three }` and `TwoRowGrid`'s `Total` already use, §S18),
/// and repeat the unit that many times. The unit decides what it LOOKS like (`Space`, nothing
/// visible, `Block`, "█", a bar, `HLine`/`VLine`, a ruled edge), not what the mechanism
/// IS. This is also why a true two-axis grid (§S15's note, revisited) does not get built here:
/// TEXT is the one unit proven to repeat reliably in every renderer this file has actually
/// been read in (§S19). An image or a table cell is not, so "space" stays this one
/// mechanism, applied through whichever unit the moment calls for, rather than a second,
/// fancier one built on primitives already shown not to hold.
///
/// ## §S21 · A `@Column` centers an embedded image: a table cell does not
///
/// Checked directly, in the actual rendered page, not guessed from the JSON model: an image
/// (`Picture`) placed inside `PanelOf`/`@Column` gets a real, non-zero left AND right CSS margin
/// from the DocC theme (111px each side, on a 150px-wide image in a 372px column, exactly
/// centering it), regardless of the column's stated width (`SizedPanel`'s weight does not
/// change this, the same wall §S19 already names). The same image inside a `TableCell` gets
/// `margin: 0`, flush against the cell's edge. So "picture pinned to one side, content
/// beside it" is not a `@Row`/`@Column` job here. It is a one-row `Table`/`TableRow`/`TableCell`
/// (`CardPictureRow`, Organization/View/Dashboard.swift), the same cheap-reuse move §S15 already
/// names, for alignment instead of a border.
///
/// ## §S22 · Prose has two doors, and length picks one
///
/// Spelled prose (one `Glyph` atom per character, the ProseGen path) builds a generic type
/// whose mangled name grows with every character. Past a few hundred characters the compiled
/// binary hits a metadata ceiling before any rendering starts: "failed to demangle witness for
/// associated type 'Body' … Mangled type is too complex" (checked directly, on a ~500-character
/// paragraph, Organization/View/Reports.swift keeps the site and the exact text). This is a
/// DIFFERENT wall from §S16: not the render stack overflowing on the way up, but the type
/// itself too complex to instantiate at all. So prose has two doors, and length picks one:
/// SHORT prose (a caption, a heading, a template with typed holes) is spelled from atoms,
/// every character checked. LONG prose (a paragraph) is one `Close` atom whose `typeName` is
/// the literal text (the call every long caption in DocumentKit/Landing.swift makes). The
/// boundary is the demangler's, not a style choice: a paragraph-atom costs one type either way,
/// and a spelled paragraph costs one type PER CHARACTER in one mangled name.
///
/// ## §S23 · Generation is a gated construction
///
/// A generated artifact — a roster file, a card, a diagram — is a page whose medium is source
/// text: a `SourceFile` template composes typed skeleton atoms, its `typeName` IS the file, and
/// a thin driver writes it, the same three lines `render-doc` uses for markdown. The emitter
/// PROPOSES. The build is the gate — compilation, the linters, and the parity gates cut the
/// proposal to one survivor, which is Program Is Path's gated construction run on artifacts:
/// where the template and its rules admit exactly one output, regeneration is idempotent, and
/// the md5 gate is measuring `|S| = 1` at the artifact level. Two edges: the ENUMERATION
/// (two hundred employees) is a value-level fold in the driver — a type cannot be chosen by a
/// runtime index — and the data pools ride as typed chains read via `labels`, so only the
/// iteration itself lives outside the notation.
///
/// ## §S24 · The medium can carry what the host discards
///
/// A `Vector` composition may carry a link (`Linked`, its target read off the page TYPE by
/// `PageSlug` — a typo in an href is structurally impossible). Whether the link FIRES is the
/// host's decision, and each hosting path was checked directly: an `<img>`-embedded SVG
/// discards its anchors entirely. Raw inline `<svg>` in markdown is stripped by DocC's
/// parse down to bare text. And the static-hosting output holds no image markup at all —
/// 11,386 shell `index.html`s, the content living in `data/*.json`, rendered by the host's
/// script in the browser. The one sanctioned door is the host's template hook
/// (`--experimental-enable-custom-templates`, footer.html): a whitelist-scoped swap that
/// re-routes OUR generated images from `<img>` to inline `<svg>`, after which the anchors are
/// ordinary DOM links and a drawn keypad walks its state graph by click. The law to hold:
/// the medium always emits its full content. The host is granted doors, not workarounds —
/// and a host of our own would make the door unnecessary, not the content different.
///
/// ## §S25 · A many-cased gate routes through the case's own identity
///
/// Swift grants a generic type AT MOST ONE conditional conformance to a given protocol —
/// a whitelist written as `extension On: Legible where Fg == Paper, Bg == Ink {}` plus a second
/// pair is "conflicting conformance … even with different conditional bounds" (checked
/// directly, two extensions suffice to trigger it). So a gate with many legal cases cannot
/// hang them all on one generic's conformance. Route through the CASE's identity instead:
/// one protocol per case family (`LegibleOnInk`, `LegibleOnPaper`, …), each legal member
/// conforming unconditionally — a type may conform to any number of DIFFERENT protocols — and
/// the gated slot carries the constraint on its axis (`associatedtype Fg: LegibleOnInk`).
/// The refusal then lands at the illegal type's declaration ("`Muted` does not conform to
/// `LegibleOnInk`"), earlier and plainer than any `.typeName` dispatch could place it — the
/// same family of limits as §S12/§S17, met from the conformance side.
///
/// ## §S26 · A hover panel is interactive, not a tooltip
///
/// A revealed panel that carries links must survive the pointer's TRAVEL to it, and two
/// standard CSS habits silently kill that (both checked directly, one round each). First, a
/// reveal keyed only on the trigger's `:hover` dies the instant the pointer leaves the trigger
/// toward the panel — the reveal rule must include the panel's hover
/// (`.trigger:hover ~ .panel, .panel:hover`), so a reached panel holds itself open. Second,
/// `pointer-events` is NOT animatable: toggling it flips interactivity off the same instant
/// the trigger's hover drops, no matter what transition sits beside it. The close must be a
/// GRACE WINDOW instead — `visibility` delayed a few hundred ms — because visibility IS
/// delayable, and in SVG a `visibility: hidden` element already receives no pointer events
/// (`visiblePainted`). The rule of thumb the two collapse into: reveal on either hover, close
/// on a delay, and keep `pointer-events` away from a traversal.
///
/// ## §S27 · The OR of two constraint sets is an overload, not a conformance
///
/// §S25 gives a gate many legal CASES. A gate whose legality is a DISJUNCTION of two whole
/// constraint SETS ("preceded by a builder marker AND items are builder tokens, OR items are
/// plain tokens") hits the same one-conditional-conformance wall from another side — a shared
/// umbrella protocol cannot carry both arms (checked directly, in the grammar mirror's design).
/// The lawful door is OVERLOAD RESOLUTION: declare the same generic function twice, each arm's
/// constraint set on one overload, and Swift's overload resolution IS the disjunction — a site
/// satisfying either arm compiles, a site satisfying neither is refused with BOTH candidates'
/// unmet requirements named ("candidate requires 'SemicolonAtom' conform to 'PlainToken'" /
/// "candidate requires … 'OpensBuilder'"). The refusal is richer than a conformance failure:
/// it lists every door that was tried. Scope note: the overload pair lives in tooling-tier
/// code (the mirror's lexicon). On the pure surface §S4 still governs what a free function
/// may be — this section licenses the FORM where functions are already lawful.
///
/// ## §S28 · A button is a triple, and the form is the invariant
///
/// The dynamics medium (Dynamics.swift) gives a state file exactly one kind of motion: a
/// rewrite rule, the triple (slot, expected pattern, replacement template). Pressing is
/// identification — the pattern finds its slot's term whole or the press is a lawful no-op
/// that leaves the file byte-identical — and a rule may change nothing but its one slot's
/// term. The consequence is the invariant this section states: the FORM of a state file
/// never moves along any trajectory. Every reachable state carries the same slots, the same
/// buttons, the same shape; the diff between neighbouring states lives inside one alias.
/// What the class cannot say is part of the law, stated as sharply: a transition that needs
/// case analysis over an unbounded term is not a triple, and belongs to an encoder outside
/// the judge, whose product is judged as a file (the 2048 lane shift is the named example,
/// lived and removed). A rule that carries anything beyond its three aliases has left the
/// class, and the checker (`Tools lint`, the SLOT RULE check) refuses it by name.
///
/// ## §S29 · The judge sits on the edges, not the states
///
/// A rule with a variable is a GENERIC declaration, so the compiler admits its template for
/// every binding of the pattern's variables at once: one declaration, universally
/// quantified, checked before any press exists. With the starting file judged and every
/// rule judged, every reachable state of a chain is well-typed by induction — finitely many
/// checks cover unboundedly many trajectories, which no per-state testing reaches. The
/// running consequences come from the same three lines: rules over different slots commute
/// (independent aliases), a repeated press meets a stale pattern and stands (the no-op is
/// the concurrency answer), and a non-erasing rule's reverse triple is again a rule, so
/// undo is a button, not a mechanism.
///
/// ## §S30 · A key may carry a chord, and the chord is still an identification
///
/// One physical key can mean different moves at different states: a passcode digit starts
/// the walk at the gate and resets it mid-walk. The lawful form is a CHORD — one face over
/// several rules of the SAME slot (the sameness is the type's bound) whose patterns are
/// pairwise distinct (the distinctness is the applier's refusal). Then at any state at most
/// one rule matches, "first match" degenerates into THE match, and a chord press is the same
/// identification a single press is: apply the one that matched, or stand. No priority
/// exists to reason about, and the applier refuses an ambiguous chord by name instead of
/// picking silently.
public enum SurfaceLaw {}
