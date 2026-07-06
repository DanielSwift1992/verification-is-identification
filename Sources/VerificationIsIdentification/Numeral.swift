
// ═══════════════════════════════════════════════════════════════
// NUMERAL names the ten atoms of positional notation, and numbers as chains of digits.
//
// Pure types (§0′). A DIGIT is a leaf atom: one of ten distinguished points, as
// fundamental as Pair and Null. A NUMBER is an Open type whose body chains digits
// through the StructureBuilder: `{ Numeral._1.self; Numeral._0.self }` is ten.
//
// This is the decimal system expressed in the lattice. The digits are domain-agnostic:
// a password, a band count, a year, all are chains of the same ten atoms. The unary
// Peano successor (IntegerValued: Right: IntegerValued) is the COUNTING mechanism;
// these digits are the NAMING mechanism. Both are valid: one counts by folding,
// the other names by composing atoms.
// ═══════════════════════════════════════════════════════════════

/// This names a digit: one of ten distinguishable atoms, the base of positional notation.
/// `Open`, not `Close` (Law §0″: `Close` must be a concrete enum, not a protocol), the same
/// shape as `Employee`: each `Numeral._N` is a leaf that does not customize `body`, so it
/// counts as one.
public protocol Digit: Open {}

/// The ten digits, namespaced. Write `Numeral._3` for the digit three.
public enum Numeral {
    public enum _0: Digit {}
    public enum _1: Digit {}
    public enum _2: Digit {}
    public enum _3: Digit {}
    public enum _4: Digit {}
    public enum _5: Digit {}
    public enum _6: Digit {}
    public enum _7: Digit {}
    public enum _8: Digit {}
    public enum _9: Digit {}
}


/// Zero names the empty count: the Peano floor, both sides already closed.
public enum Zero: IntegerValued {
    public typealias Left = Never
    public typealias Right = Never
}

/// Succ names one more than its predecessor: the unary counting step. Where the digits above
/// NAME a number, this chain COUNTS one, the ladder `IntegerValued` describes.
public enum Succ<
    Predecessor: IntegerValued
>: IntegerValued {
    public typealias Left = Never
    public typealias Right = Predecessor
}
