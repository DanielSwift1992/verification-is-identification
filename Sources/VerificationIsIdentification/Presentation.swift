import Notation

import Swift

// ── the presented half of the axis. ``LawIsTarget`` reaches the law from
//    observations: examples arrive until one law survives. Presentation reaches
//    the same fixed target from the author's side: the law is WRITTEN, a finite
//    transition table as a structure in Σ, and the judge checks the written
//    claims before any step is taken. Identification and presentation meet at
//    the same object, and only the direction of travel differs. One space has
//    one name (Law §1): the presented law is ``LawLivesInSigma`` and its press
//    is ``LawIsTarget``. The two protocols below are presentation's own. Lived
//    first as the rewrite-triple medium (a button over a state file is a
//    triple, pressed and judged), then lifted here. ──

/// The judgement is on the edges, not the states: a step with a variable is a
/// universally quantified claim, checked once for every binding, so finitely
/// many checks cover every reachable trajectory by induction from a judged
/// start. Per-state testing never reaches this bound. The judge admits the presented
/// law's whole behaviour before its first step. [DiS 5]
public protocol EdgesCarryTheJudgement: LawLivesInSigma, BehaviorIsStructure {}

/// The form is the invariant of a presented law: a step rewrites one slot's
/// term and nothing else, so the shape of the state (its slots, its keys) is
/// invariant along any trajectory, and the difference between neighbouring
/// states is inside one term. The invariant form is itself a structure. [DiS 4]
public protocol FormIsInvariant: LawLivesInSigma {
    associatedtype Form: Pair
}

// ───────────────────────────────────────────────────────────────
// Recorded, not pinned (the house pattern, beside Basis B8b and Gen GD7).
//
// MERGE IS COMMUTATION. Preserved read inputs and disjoint writes suffice for
// commuting edits. Under separate law-support conditions, the merge inherits
// each applicable group of verdicts. The two complete branch verdicts need
// not already be green. Locality bounds sufficient rechecks, not necessary
// work. IndependentReadingOrders constructs the disjoint pair case with
// actual applications. The general finite-interface proof is in MiC1-MiC4.
// ───────────────────────────────────────────────────────────────
