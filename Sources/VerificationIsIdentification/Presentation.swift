import Swift

// ── the presented half of the axis. ``LawIsTarget`` reaches the law from
//    observations: examples arrive until one law survives. The four protocols
//    below reach the same fixed target from the author's side: the law is
//    WRITTEN — a finite transition table as a structure in Σ — and the judge
//    checks the written claims before any step is taken. Identification and
//    presentation meet at the same object, and only the direction of travel
//    differs. Lived first as the rewrite-triple medium (a button over a state
//    file is a triple, pressed and judged), then lifted here. ──

/// The law can be presented instead of identified: its author writes the
/// finite transition table as a structure in Σ, whole, and the judge verifies
/// the written claims. The same fixed target ``LawIsTarget`` reaches from
/// examples, reached from the author's side: presentation is identification
/// with the search already spent. The written table has norm and distance like any
/// structure in Σ, so presented laws are comparable before any step. [DiS 1]
public protocol PresentedLaw: HasLaw, DistanceOnStructures {}

/// One step of a presented law fires iff its written pattern IS the state's
/// term: a comparison, not a search, `|S| ≤ 1` by the pattern's linearity. A
/// chord of steps over one slot with pairwise distinct patterns keeps the
/// bound: at most one leaf matches at any state, so a key of many meanings
/// is still an identification, never a priority. [DiS 2]
public protocol PressIsIdentification: PresentedLaw, PassIsIdentification {}

/// The judgement is on the edges, not the states: a step with a variable is a
/// universally quantified claim, checked once for every binding, so finitely
/// many checks cover every reachable trajectory by induction from a judged
/// start. Per-state testing never reaches this bound. The judge admits the presented
/// law's whole behaviour before its first step. [DiS 5]
public protocol EdgesCarryTheJudgement: PresentedLaw, BehaviorIsStructure {}

/// The form is the invariant of a presented law: a step rewrites one slot's
/// term and nothing else, so the shape of the state (its slots, its keys) is
/// invariant along any trajectory, and the difference between neighbouring
/// states is inside one term. The invariant form is itself a structure. [DiS 4]
public protocol FormIsInvariant: PresentedLaw {
    associatedtype Form: Pair
}
