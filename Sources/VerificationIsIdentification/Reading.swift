// ═══════════════════════════════════════════════════════════════
// Reading Is Order (Dynamics).
//
// A binary zipper has two one-layer context constructors. Its navigation
// includes ascent as well as descent. Fold and unfold require specified
// algebras and coalgebras. Their universal properties do not choose a question
// or establish that every schedule preserves its answer. [Read R1–R4]
//
// Pure types (§0′). This historical interface joins named coordinates.
// Actual agreement uses VerdictIsInvariant, and transition agreement uses
// CommutingTransition. Fair finitary accumulation is a separate argument. [R5]
// ═══════════════════════════════════════════════════════════════

/// Joins time, fixed-order-scope and revelation interfaces. These parents do
/// not supply a zipper, an actual traversal or a preserved-source relation.
/// For fixed complete verification the survivor set is order-independent.
/// A selected answer additionally must be constant over that set. [Reading R3]
///
/// Initiality chooses no answer algebra. Finality equates maps only after
/// their coalgebra equations are established. Neither proves that time or
/// source-changing observations are irrelevant to every answer. [Reading R4]
public protocol Reading: HasTime, OrderIsOnlyFreedom, RevealsNotCreates {}
