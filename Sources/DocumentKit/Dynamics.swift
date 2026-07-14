import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE DYNAMICS MEDIUM: a button over a state file is a rewrite triple, not a
// program. A state file is a form whose slots are `typealias <Slot> = <term>`
// lines, and a rule names one slot, one expected pattern, one replacement
// template. Pressing compares and substitutes: one match or none, and a
// mismatch leaves the file byte-identical. The one applier lives in Tools
// (`swift run Tools press <Rule>`), is the same few lines for every domain,
// and no domain logic is ever written as code: a system's behaviour is its
// triples.
//
// The judge sits on the edges, not the states: a rule with a variable is a
// generic declaration, so the compiler admits every application at once, and
// every reachable state of a chain is well-typed before the first press. In
// the theory's own axis this is the Law relocated one step further: where
// `HasLaw` identifies a transition law from observed examples, a triple is
// the law PRESENTED by its author, and the build is the gate it must pass.
// ═══════════════════════════════════════════════════════════════

/// What a key may stand on: one slot's worth of pressing. A single rule is the
/// base case and a chord of rules is the cons, so a key's bound never grows an
/// arity: any width is nested pairs of this one protocol, the same law every
/// tree in this package obeys.
public protocol Pressable {
    associatedtype Slot   // law:allow — read by RuleKey's slot attribute and by the one applier (Tools press): the medium's reader stands outside the judge
}

/// One rewrite rule: the slot it owns, the pattern it expects, the template it
/// leaves. A rule whose template cannot stand for every binding of its
/// pattern's variables refuses to compile on its own line, so a dictionary of
/// rules that builds is a dictionary whose every press is safe. The axes are
/// read by the medium's one applier (Tools press) and by ``RuleKey``'s slot
/// attribute: the reader of a state file's dynamics stands outside the module,
/// which is the medium's whole point.
public protocol SlotRule: Pressable {
    associatedtype From   // law:allow — the pattern: compared by the one applier, never inside the module
    associatedtype Into   // law:allow — the template: substituted by the one applier, never inside the module
}

/// The chord's cons: two pressables of the SAME slot under one face. Nesting
/// this one pair reaches any width, and the one-slot bound rides every link of
/// the chain. At any state at most one leaf of a lawful chord matches, so a
/// chord press stays an identification (§S30), whatever its width.
public enum Chord<
    A: Pressable,
    B: Pressable
>: Pressable
where A.Slot == B.Slot {
    public typealias Slot = A.Slot
}
