import Swift

// ═══════════════════════════════════════════════════════════════
// VERDICT pins the two claims of Verdict Is Invariant: at an exact carry the
// admissible correspondences form a torsor under the carried content's own
// symmetry, and a court needs no representative — a predicate constant on every
// candidate the records admit is decided while identification stands open. The
// paper's worked instance is the correspondence between two records of one
// fact, but the claims are true for any reading that forgets, so they are
// here, on the encoding axis, beside the forgetting they judge across.
// ═══════════════════════════════════════════════════════════════

/// Any ambiguity at an exact birth is pure symmetry: the admissible
/// correspondences form a torsor under the carried content's automorphisms, so
/// above one candidate none is canonical until a record breaks the symmetry,
/// and a singleton names its mapping by uniqueness. Builds on
/// ``EncodingForgets``: a record that does not individuate equal carriers is
/// the encoding whose kernel the orbit is. [VI 2]
public protocol AmbiguityIsSymmetry: EncodingForgets {
    associatedtype CarriedSymmetry
}

/// A verdict needs no representative: a predicate constant on every candidate
/// the records admit is exact with identification still open, and where the
/// candidates disagree the state is open and names its missing premise.
/// Identification is sufficient for judgment and never necessary. Builds on
/// ``EncodingForgets``: the forgotten distinction leaves `|S| > 1`, and the
/// court asks whether the asked predicate reads it at all. [VI 3]
public protocol VerdictIsInvariant: EncodingForgets {
    associatedtype Predicate
}
