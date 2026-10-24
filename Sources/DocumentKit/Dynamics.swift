import Notation

/// Declares the slot associated with a pressable term.
public protocol Pressable {
    associatedtype Slot   // law:allow — read by RuleKey's slot attribute and by the one applier (Tools press): the medium's reader stands outside the judge
}

/// Declares a slot, source pattern and replacement term for a press.
public protocol SlotRule: Pressable {
    associatedtype From   // law:allow — the pattern: compared by the one applier, never inside the module
    associatedtype Into   // law:allow — the template: substituted by the one applier, never inside the module
}

/// Marks an applied pressable term while retaining its declared slot.
public enum Exactly<Rule: Pressable>: Pressable {
    public typealias Slot = Rule.Slot
}

/// Pairs pressable terms whose Slot types are equal. The host checks pattern selection.
public enum Chord<
    A: Pressable,
    B: Pressable
>: Pressable
where A.Slot == B.Slot {
    public typealias Slot = A.Slot
}

/// Reads the supplied term identifier as text for serialization.
public enum TermText<T>: Close {}
extension TermText {
    public static var typeName: String { String(describing: T.self) }
}
