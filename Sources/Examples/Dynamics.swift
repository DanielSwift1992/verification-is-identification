import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE DYNAMICS TERMS: the worlds a state file can hold, as pure types. The lamp's
// two faces, the counter's floor and wrap, the keypad's three stages. The rules
// that move a world between these terms are triples beside the world itself
// (DynamicsDemo/Rules.swift) on the dynamics medium (DocumentKit/Dynamics.swift):
// this file is the alphabet alone. A slot marker names its alias by dropping the
// `Slot` suffix, so a marker and a live alias never share a name in any module.
// ═══════════════════════════════════════════════════════════════

/// The lamp's one slot: the marker drops its `Slot` suffix to name the alias a
/// state file carries, `typealias LampMode = <term>`.
public enum LampModeSlot {}
public enum LampOff {}
public enum LampOn {}

/// This marks the terms the counter's slot may hold: the floor and every wrap of
/// it. The constraint is what the judge checks a press against, for all bindings
/// at once. A counting term is a structure, so its chain folds to a number the
/// way every chain in this package does, and ``Tally`` reads it with no reader
/// written anywhere.
///
/// > Important: `Counting` deliberately stands apart from `IntegerValued`, and
/// > ``Tick`` is no alias of `Succ`, though both wrap by one. The axis is the
/// > grammar of moves: a number can be added and halved, a count of events can
/// > only grow. Merged, every numeric rule would match the counter's slot and
/// > the counter's rule would match every numeric slot — the axis split is what
/// > keeps a button on its own slot.
public protocol Counting: Structure {}
extension Never: Counting {}
/// One step more than its content: the counter's only constructor. Its count is
/// the structural fold: one more than what it wraps.
public enum Tick<Previous: Counting>: Counting {}
extension Tick {
    public static var count: Int { Previous.count + 1 }
}

/// The counter's one slot: the state file's alias is `Count`.
public enum CountSlot {}

/// The keypad's one slot: the state file's alias is `PinProgress`.
public enum PinProgressSlot {}
public enum PinStage0 {}
public enum PinStage1 {}
public enum PinStage2 {}
public enum PinStage3 {}
public enum PinUnlocked {}
