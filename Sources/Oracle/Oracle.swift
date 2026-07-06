import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// ORACLE names the walk: authorship and navigation as the V=I game itself.
//
// The seed says: draw a distinction, or close one, until a single structure survives. Read
// forward, that is verification. Read the other way, it is a walk: at every `Pair` the
// walker chooses left or right, the survivor set halves, and arriving IS the collapse
// |S|: many → 1. Finding a page and checking it is yours are one act.
//
// There is deliberately no node protocol here. The fork is `Pair` itself: any composed
// body in the system is already a walkable space, so a second ontology would be a second
// artifact. This module holds only what a walk adds to the lattice:
//
//   readings  a door must show what stands behind it, and the reading is a witness of the
//             subtree (`labels`, `count`), so a door cannot say what its half does not hold.
//   letters   the two moves. A finished walk is a word in them; the word is the path, the
//             path is an object (Program Is Path), and its length is the distance the
//             metric papers already measure. A step page spells its word back, read off
//             the position: a tree gives every node exactly one path from the root.
//
// The walker supplies the one thing the lattice cannot: which half the wanted thing is in.
// Content is the core's, order is the walker's (Reading Is Order §5.25: order is the sole
// freedom). A walker that can only choose between two doors can only ever produce
// admissible walks: refusal is not enforced on it, it is unspellable for it.
// ═══════════════════════════════════════════════════════════════

/// This reads a subtree out as every leaf name in body order: the face of a door narrow
/// enough to name its whole half. A reading is a witness, so it cannot drift from the tree.
public enum RollCall<Of: Structure>: Close {}
extension RollCall {
    public static var typeName: String { Of.labels.joined(separator: ", ") }
}

/// These are the two letters a walk is written in. A finished walk is a word in them, and
/// the word is itself an object: the walker's path, breadcrumb, and audit, all one chain.
public enum WentLeft: Close {}
extension WentLeft {
    public static var typeName: String { "left" }
}
public enum WentRight: Close {}
extension WentRight {
    public static var typeName: String { "right" }
}

/// This labels the word a walker has spelled so far: the letters of the walk shown back as
/// the object they form. A step page carries its own word because a tree gives every node
/// exactly one path from the root; nothing is stored, the word is read off the position.
public enum WordSoFar: Close {}
extension WordSoFar {
    public static var typeName: String { "The word so far: " }
}
public enum StepDot: Close {}
extension StepDot {
    public static var typeName: String { " · " }
}

