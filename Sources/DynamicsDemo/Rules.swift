import VerificationIsIdentification
import DocumentKit
import Examples

// ═══════════════════════════════════════════════════════════════
// THE RULES: the world's whole dynamics as triples on the dynamics medium
// (DocumentKit/Dynamics.swift), over the terms of Examples/Dynamics.swift.
// Pressing is `swift run Tools press <Rule>`: compare, substitute, or stand.
// A rule with a variable is a generic declaration, so the judge admits every
// application at once, before the first press.
// ═══════════════════════════════════════════════════════════════

// ── the lamp: one slot, two level-0 rules, a two-state automaton written as data ──

/// Off becomes on: a whole transition as one triple, no code anywhere.
public enum PowerOn: SlotRule {
    public typealias Slot = LampModeSlot
    public typealias From = LampOff
    public typealias Into = LampOn
}
/// On becomes off: the reverse triple, which is why undo is a button, not a mechanism.
public enum PowerOff: SlotRule {
    public typealias Slot = LampModeSlot
    public typealias From = LampOn
    public typealias Into = LampOff
}

// ── the counter: one slot, one level-1 rule, an infinite space from one triple ──

/// Whatever the count is, wrap it once: a rule with a variable. The generic
/// declaration IS the theorem that every application is well-typed: the compiler
/// admits `Tick<T>` for every `T: Counting`, so no reachable state can go wrong.
public enum BumpUp<T: Counting>: SlotRule {
    public typealias Slot = CountSlot
    public typealias From = T
    public typealias Into = Tick<T>
}

// ── the keypad: a walk of four right digits, its whole table written as
// thirty-one triples. The pin is 4-2-4-2. A right digit advances, a wrong digit
// mid-walk resets, and a wrong digit at the start needs NO rule at all: its
// press finds no matching pattern and the file stands, a no-op by absence. One
// physical key is a chord over its rules (Chord, one slot by the bound), and at
// any stage exactly one leaf can match: the table is data, end to end. ──

/// The right digits of the walk: 4 starts, 2 advances, 4 advances again, 2 unlocks.
public enum Key4StartsWalk: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage0
    public typealias Into = PinStage1
}
public enum Key2AdvancesStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage2
}
public enum Key4AdvancesStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage3
}
public enum Key2Unlocks: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinUnlocked
}
/// The right digits pressed at the wrong stage reset like any other wrong digit.
public enum Key4ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key4ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key2ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
/// Every other digit resets at every mid-walk stage: the off-path rows of the
/// table spelled out rather than computed, three triples per key.
public enum Key0ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key0ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key0ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key1ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key1ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key1ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key3ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key3ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key3ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key5ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key5ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key5ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key6ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key6ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key6ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key7ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key7ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key7ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key8ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key8ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key8ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}
public enum Key9ResetsStage1: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage1
    public typealias Into = PinStage0
}
public enum Key9ResetsStage2: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage2
    public typealias Into = PinStage0
}
public enum Key9ResetsStage3: SlotRule {
    public typealias Slot = PinProgressSlot
    public typealias From = PinStage3
    public typealias Into = PinStage0
}

