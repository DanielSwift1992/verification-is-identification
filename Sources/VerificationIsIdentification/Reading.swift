// ═══════════════════════════════════════════════════════════════
// Reading Is Order (Dynamics).
//
// Existence Is Finite froze the static; this reads it in motion. The agent is
// the order in which the standing structure is read — a zipper over Σ whose
// step is the rule's derivative ∂F = 2X (left or right, no third). The two
// organs are an F-coalgebra (generate, ν-ward) and an F-algebra (discriminate,
// μ-ward), dual; the order is the sole freedom and changes no result.
//
// Pure types (§0′). The zipper and the coalgebra/algebra duality are the
// paper's mathematics; the type level carries the one claim that intersects the
// lattice — the reading is time-indexed order that reveals, never creates.
// ═══════════════════════════════════════════════════════════════

/// The reading is the order of traversal: time-indexed, free, and revealing.
/// Intersects ``HasTime`` (the agent moves over discrete time), ``OrderIsOnlyFreedom``
/// (the order is its sole freedom), and ``RevealsNotCreates`` (it reads a structure
/// that pre-exists the call). [Read R1-R5]
///
/// > Note: The dynamic adds order, not facts. The anamorphism into the behaviour
/// > space is unique, so any fair reading reaches the same result. Time is the
/// > track the reading leaves, never a term in the verdict.
public protocol Reading: HasTime, OrderIsOnlyFreedom, RevealsNotCreates {}
