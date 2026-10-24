
// ═══════════════════════════════════════════════════════════════
// NUMERAL names the ten atoms of positional notation, and numbers as chains of digits.
//
// Pure types (§0′). A DIGIT is a leaf atom: one of ten distinguished points, as
// fundamental as Pair and Null. A NUMBER is an Open type whose body chains digits
// through the StructureBuilder: `{ Numeral._1.self; Numeral._0.self }` is ten.
//
// Positional notation uses the same ten atoms at every place. The unary
// Peano successor supplies a unary constructor grammar, while these digits
// name positional notation. Neither IntegerValued alone nor the default
// Structure.count reader establishes the natural-number interpretation.
// ═══════════════════════════════════════════════════════════════

/// This names a digit: one of ten distinguishable atoms, the base of positional notation.
/// Each of ``Numeral``'s digit types inherits ``Open``'s default `Never` body
/// and reads a count of one.
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


/// A chosen zero numeral with two Never sides. It is nominally distinct
/// from Never, which other constructor conventions use as their zero.
public enum Zero: IntegerValued {
    public typealias Left = Never
    public typealias Right = Never
}

/// A unary successor constructor. Finite expressions ending at a declared
/// zero admit the usual count by induction. The bound on Predecessor alone
/// also permits cyclic IntegerValued conformers. [EiF EF10]
public enum Succ<
    Predecessor: IntegerValued
>: IntegerValued {
    public typealias Left = Never
    public typealias Right = Predecessor
}
