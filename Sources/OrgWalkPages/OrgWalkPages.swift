import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// ORG WALK PAGES holds the generated walk page types, as its own module.
//
// One module is one emit job and one name-lookup scope, and both grow with the
// declarations inside: at 6400 people the walk pages alone drove the frontend past its
// own limits inside OrgDemo (DESIGN21 v32). Here they stand apart — the form move one
// level above file sharding — so the page types check and emit beside the demo instead
// of inside it. OrgDemo imports this module and keeps only the render hands that write
// the pages to disk.
// ═══════════════════════════════════════════════════════════════

/// The module's one hand-written anchor: the generated shards fill the directory around
/// it, written by `swift package generate org`.
public enum OrgWalkPagesModule: Close {}
