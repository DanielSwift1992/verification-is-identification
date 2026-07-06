import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// LOGIN names authentication as identification, on the keypad.
//
// A password is an Open type whose body chains digits (Numeral._0 through ._9)
// through the StructureBuilder. The builder folds the braces into a Paired chain:
// the type IS the password.
//
// Honest boundary: on a static site every page is published, so this shows the SHAPE, only the
// valid path reaches the door, every other runs out the length, not real secrecy.
// ═══════════════════════════════════════════════════════════════

/// This names a password: an Open type whose body IS the key sequence, composed via
/// StructureBuilder.
public protocol Secret: Open {}

/// A digit can spell itself (the numeral's own name, underscore shed), and a chain of
/// digits spells the chain. A `Secret` whose body is spelled digits can then state its
/// passcode as text, read off the very type the gate checks, never typed a second time.
/// The value appears only at a reading edge, the same edge `Tally`'s `count` is.
public protocol Spelled {
    static var spelled: String { get }
}
extension Spelled
where Self: Digit {
    public static var spelled: String { String(String(describing: Self.self).dropFirst()) }
}
extension Numeral._0: Spelled {}
extension Numeral._1: Spelled {}
extension Numeral._2: Spelled {}
extension Numeral._3: Spelled {}
extension Numeral._4: Spelled {}
extension Numeral._5: Spelled {}
extension Numeral._6: Spelled {}
extension Numeral._7: Spelled {}
extension Numeral._8: Spelled {}
extension Numeral._9: Spelled {}
extension Paired: Spelled
where L: Spelled, R: Spelled {
    public static var spelled: String { "\(L.spelled) \(R.spelled)" }
}
/// The passcodes below opt in by conformance; the spelling itself is derived, not stated:
/// the requirement is witnessed by the constrained extension right here, where the body's
/// underlying digits are visible.
public protocol SpelledSecret: Secret {
    static var spelled: String { get }
}
extension SpelledSecret
where Body: Spelled {
    public static var spelled: String { Body.spelled }
}

/// This is a credentialed principal: an employee carrying a secret. The password is a type,
/// ``Pass``, composed through the body pattern. Not a stored string.
public protocol Credentialed: Person {
    associatedtype Pass: Secret
}
