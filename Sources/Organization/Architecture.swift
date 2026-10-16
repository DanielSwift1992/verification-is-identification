import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE ARCHITECTURE names how the showcase is built, stated as a law.
//
// The doc-comment below is the statement, the way Law.swift states the lattice's law. It is
// not enforced by a plugin, it is checked by reading. System/, Query/, and View/ enact it.
// ═══════════════════════════════════════════════════════════════

/// How this showcase is built: the compiler checks the model's presented type relations, and
/// queries and views read that model into pages through explicit rendering.
///
/// The shape is the one SwiftUI and Elm share — a view is a pure function of state, redrawn when
/// the state changes — with two substitutions that come from V=I. The state is not values in
/// memory, it is the type lattice (the company, `System/`). The build checks its presented type
/// relations. `swift run OrgDemo render-doc` writes the generated DocC Markdown. ``Architecture``
/// is the anchor, and the sections below are its statement.
///
/// - term One source: the company as types (`System/`), the model everything reads from.
/// - term One direction: System to Query to Reader to Screen to render. The View depends on the
///   types, never the types on the View.
/// - term One runtime: reading. Every value is read from a type at the View boundary, and the
///   layers above hold none.
///
/// ## §1 · The model is the type lattice
///
/// State lives in the types and nowhere else (Law §0′). The company, who exists, what each
/// person is, what the policy says, is `System/`, pure types: no stored `var`, no string, no
/// runtime. To know a fact is to ask the compiler, not to read a value.
///
/// ## §2 · The only runtime is reading
///
/// `Query/` is the compiler's verdict: does this access conform, who owns this, still types.
/// The View holds no runtime either: a page is a type, composed from the system's types,
/// and the one place a type becomes text is the `typeName` door: `Symbol` for a name, `Tally`
/// for a count, read once as the page renders. The dependency points one way, View toward
/// System. The page reads the model through its types. Its prose and renderers still need review
/// to check that the page describes those types accurately.
///
/// ## §3 · A write enters the system as a type
///
/// > Important: There is no runtime store anywhere, not even for the things that change. An
/// > external event, a hire, a firing, an hour logged at a badge reader, becomes state only by
/// > being converted into a type, through a mechanism. The roster generator is one such
/// > mechanism: it writes the company as types. A ``CommittedCut`` is another: it writes a
/// > year's decision as a type. The runtime does not hold the change, it reads the type the change
/// > became.
///
/// ## §4 · Model edits and compilation
///
/// A domain update enters `System/` as a type edit. Recompilation checks the presented type
/// relations for that edit, applying the framework's write/prove equation to this supplied
/// representation. The explicit `swift run OrgDemo render-doc` command writes generated Markdown.
/// DocC builds documentation from those files and the symbol graph. Prose and renderers still
/// need review against the modeled claims (§2).
///
/// ## §5 · A change costs what it moves (Distance Is Cost)
///
/// Two changes, two costs. Changing the PERSPECTIVE, which page, who you signed in as (`Params`),
/// is a cheap re-reading at a new coordinate, the runtime move SwiftUI makes when `@State`
/// changes. Changing the DOMAIN, the company or policy, needs a build to check its type relations. A
/// static document fixes the perspective ahead of time, so the pages are a closed set of links. A
/// live app would set it at runtime, with open controls. Both read the one `view(Σ, params)`.
///
/// That perspective is the app's local state, and it is the head of a `Chain`: the path walked to
/// reach here, kept whole and read at its latest value. Reading the state resolves a link. The
/// chain stays walkable behind it, the breadcrumb is that walk, and a move conses a new head
/// without dropping the old, so the state is reversible and loses nothing. This is `@State` with
/// the value a static resolve of a path, not a stored variable.
///
/// Perspective does NOT multiply the pages, because most content does not depend on it: the
/// company is the same for everyone, so the dashboard and catalogs are ONE shared copy
/// (identified across viewers). Only the perspective-DEPENDENT part, your access, varies, and it
/// is the minimal subtree the encoding bounds: your card, one per person, reached by signing in.
/// Shared-where-equal plus minimal-where-it-differs is what keeps it from exploding into pages ×
/// viewers, the same collapse-by-identification the sign-in flow uses on its wrong states.
///
/// An INTERACTION is a flow of perspective changes (`Flow`, DocumentKit): a sign-in walks a
/// keypad, each press a re-read at a new state, and it commits to the domain only at the end
/// (signing in IS identifying). To stay finite it identifies indistinguishable states: every
/// wrong prefix of a length is one node, the same verification-is-identification, used to
/// minimize. The static backend renders one page per state. The same flow would drive a live
/// app's in-place updates.
///
/// ## §6 · Each stage is one of the framework's readings
///
/// The pipeline is not borrowed from SwiftUI, it is V=I's algebra applied to a screen. Each
/// stage is a reading the framework already names.
///
/// | Stage | What it does | The reading |
/// | --- | --- | --- |
/// | Verdict (`Query/`) | a type to yes or no | `Decidable` |
/// | Projection (`Symbol`, `Tally`) | a type to its one settled value | `Measurable` |
/// | Layout (`SideBySide`, `PanelOf`, a table) | types to a tree | `Pair` and an orientation |
/// | Render (`typeName`) | the tree to a medium | the lens, Perspective Is Encoding |
///
/// Generated pages use `typeName` on page types composed over `(Σ, perspective)`. The reading
/// pipeline makes their order explicit (Reading Is Order). `OrgDemo` writes their Markdown,
/// and DocC builds documentation from those files and the symbol graph. The artifacts gate
/// regenerates the committed files and compares the results. Prose and renderers still need
/// review against the modeled claims, as described in §2.
public enum Architecture {}
