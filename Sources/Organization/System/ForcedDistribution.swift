import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// FORCED DISTRIBUTION names the stack-rank / improvement-plan policy.
//
// The policy: every review cycle, rank the company and let the bottom share go.
// Microsoft ran this until 2013, Amazon ran a version of it, and General Electric
// under Welch made it famous as "rank and yank".
//
// This demo does NOT rank anyone or compute the cut. A real system would, from the
// performance scores it has, and if it did, you would derive the cut from those
// scores. Here the score is a given and the decision (who is let go) is recorded as
// data. What the types model is two things:
//   • the RULE: a below-bar review puts you on an improvement plan, proved by the
//     ImprovementPlan gate below.
//   • the ENFORCEMENT: the year cannot close until the cut is committed, proved by
//     the interlock in ReviewCycle.swift. The next year is a type you cannot form
//     without recording who was cut, so a policy like this is in force by construction,
//     not by a process you hope someone runs.
// ═══════════════════════════════════════════════════════════════

// ── The compile-time policy: ratings, the bar, and the ImprovementPlan gate. ──

/// This names a performance rating. The bar is a refinement: meeting it entails being rated.
public protocol Rated {}
/// This is at or above the line: safe from the cut.
public protocol MeetsTheBar: Rated {}   // law:allow — the bar itself: which ratings conform IS the policy line the cut reads
/// This names a rating above the bar: exceeds expectations.
public enum Exceeds: MeetsTheBar {}
/// This names a rating at the bar: meets expectations.
public enum Meets: MeetsTheBar {}
/// This is below the line: the band the cut draws from.
public enum BelowBar: Rated {}

/// A reviewed employee carries a rating for the cycle.
public protocol Reviewed {
    associatedtype Rating: Rated
}

/// This names the ImprovementPlan gate: the policy RULE, certified at build: a below-bar review
/// puts you on the plan, and nothing else does. `OnImprovementPlan` is to ImprovementPlan what
/// `Authorized` is to the access gates: the marker the gate earns only when its where-clause holds.
public protocol OnImprovementPlan {}
/// This is the gate that puts a reviewed employee on the plan: it earns ``OnImprovementPlan``
/// only when `Who.Rating == BelowBar`. Below the bar, on the plan, and nothing else.
public enum ImprovementPlan<
    Who: Reviewed
> {}
extension ImprovementPlan: OnImprovementPlan
where Who.Rating == BelowBar {}

/// This is a stand-in for a below-bar review: the class the ImprovementPlan rule is proved over.
/// Certify the representative and every real below-bar review inherits the consequence.
public enum BelowBarReview: Reviewed {
    public typealias Rating = BelowBar
}

/// This is a stand-in for a meets-bar review: the rule must NOT fire here.
public enum MeetsBarReview: Reviewed {
    public typealias Rating = Meets
}

// The ImprovementPlan rule: ImprovementPlan<BelowBarReview> conforms (OnImprovementPlan).
// ImprovementPlan<MeetsBarReview> is rejected: Meets != BelowBar. The conformance IS the proof.
// The rule fires only below bar.
//
// The demo stops here: it does not rank the company or pick the cohort. The score is a
// given, and who is let go is recorded as data: the committed cut in ReviewCycle.swift.
// The enforcement is the interlock there: the year cannot close until that cut is committed.
