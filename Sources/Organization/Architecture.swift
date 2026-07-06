import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE ARCHITECTURE names how the showcase is built, stated as a law.
//
// The doc-comment below is the statement, the way Law.swift states the lattice's law. It is
// not enforced by a plugin, it is checked by reading. System/, Query/, and View/ enact it.
// ═══════════════════════════════════════════════════════════════

/// How this showcase is built: a declarative, one-directional architecture where the model is a
/// lattice of types and the update is recompilation.
///
/// The shape is the one SwiftUI and Elm share — a view is a pure function of state, redrawn when
/// the state changes — with two substitutions that come from V=I. The state is not values in
/// memory, it is the type lattice (the company, `System/`). The redraw is not a runtime event,
/// it is the build: changing the state recompiles, and compiling re-proves. The ``Architecture``
/// symbol is the anchor, and the sections below are its statement.
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
/// System, so a page shows only what the types hold. A page cannot overstate the system,
/// because it has nothing beyond the types themselves to overstate with.
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
/// ## §4 · To act is to write is to prove
///
/// There is no action as a separate thing. Every action is an edit to `System/`, an edit is a
/// recompilation, and a recompilation re-proves the whole system. So `act` collapses into
/// `write`, and `write` is `prove`, the framework's equation, lifted to the application.
/// The build is the update loop, and verification is identification: the proof that the new
/// state is consistent IS the new view, re-derived every build, so it cannot drift.
///
/// ## §5 · A change costs what it moves (Distance Is Cost)
///
/// Two changes, two costs. Changing the PERSPECTIVE, which page, who you signed in as (`Params`),
/// is a cheap re-reading at a new coordinate, the runtime move SwiftUI makes when `@State`
/// changes. Changing the DOMAIN, the company, the policy, is an expensive re-proof, the build. A
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
/// The whole site is `typeName` of a page-type composed over `(Σ, perspective)`: a composition
/// of readings. The rendered site is the order those readings induce (Reading Is Order), not a
/// second artifact kept in step by hand. This law is enacted, not declared: `System/`, `Query/`,
/// and `View/` are its statement in code, and a page that contradicted it (a stored value, a
/// hand-typed count, a verdict the gates refuse) has nothing to compile against.
public enum Architecture {}
