import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE GATE names how a keypad walk proves an identity, stated as a law, the same shape
// Architecture.swift states the showcase's own build in.
//
// This page is off the main path (DESIGN19 §3): the profile carries a small link to it, for
// whoever wants the mechanism, not the walk.
// ═══════════════════════════════════════════════════════════════

/// How the keypad walk proves an identity: the picture changes, the proof beneath it does not
/// (DESIGN19 §0).
///
/// ![The keypad's state graph: four correct digits in a row, every wrong one folding to dead,
/// the last correct digit a real link to Unlocked.](gate)
///
/// ## §1 · The door is a conditional conformance, not a check
///
/// `SecretPage<Page, Secret>: Screen where Page.Secret == Secret` (``SecretPage``) is the whole
/// gate: it conforms to `Screen` only when the type named for `Secret` really is `Page`'s.
/// Nothing runs to decide this: the compiler either finds the conformance or it does not, the
/// same identity-selects-body move `View`/`Administer`/`Delete` (System/Policy.swift) make for
/// access. Walking a keypad correctly does not compute the unlocked page; it names the one type
/// that makes this conformance hold.
///
/// ## §2 · The picture reads the same graph the states already are
///
/// Each named person carries a small typed state machine (`k0`..`k3`, `NamedCard.swift`): a
/// `StateGroup` per position, switched by CSS `:target`, not JavaScript. A correct digit's key
/// links to the next state's fragment (`FragmentOf`); the picture above draws exactly this
/// graph, generic over which four digits fill it. Nothing about the diagram is hand-drawn from a
/// description of the mechanism, it is the mechanism, read at one remove.
///
/// ## §3 · Wrong digits fold onto one state, never a tree
///
/// A password is one sequence out of nine to the fourth power. Rather than a wrong branch per
/// digit, every wrong digit, at every depth, resolves to the same `dead` state (Program Is Path
/// PiP6: an invalid continuation folds onto the path already there instead of opening a new
/// one). The keypad is that theorem's compiled witness: one shared line, not a 9⁴ tree, and
/// `reset` is the one way back out of it.
///
/// ## §4 · The last correct digit leaves the picture
///
/// `k3`'s correct key is not another fragment: it is a real link (`SitePath`) to that person's
/// `Unlocked` page, the one address `SecretPage` resolves to. The diagram marks it with a
/// different border for the same reason: reaching it is not a fifth position in the walk, it is
/// stepping out of the picture into the address the walk exists to prove reachable.
public enum GateMechanism: Close {}
