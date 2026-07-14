import VerificationIsIdentification

/// A page, composed through `body`: the category every screen conforms to, rather than
/// writing `: Open` directly (Law §0″: `Open` is a protocol). `typeName` is the rendered
/// markdown: reading a screen's name renders the whole page (`Open.typeName` walks `body`).
public protocol Screen: Open {}

/// A body-only fragment: grouped children with no medium of their own (a table's rows, a
/// row's cells, a list's items). The category ad-hoc groupings conform to, so `body` never
/// needs a bespoke protocol per grouping.
public protocol Fragment: Open {}
