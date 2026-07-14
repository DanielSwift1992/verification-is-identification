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
/// at once.
public protocol Counting {}
extension Never: Counting {}
/// One step more than its content: the counter's only constructor.
public enum Tick<Previous: Counting>: Counting {}

/// The counter's one slot: the state file's alias is `Count`.
public enum CountSlot {}

/// The keypad's one slot: the state file's alias is `PinProgress`.
public enum PinProgressSlot {}
public enum PinStage0 {}
public enum PinStage1 {}
public enum PinStage2 {}
public enum PinStage3 {}
public enum PinUnlocked {}
