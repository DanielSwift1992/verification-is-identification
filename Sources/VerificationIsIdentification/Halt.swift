import Swift

/// A supplied source step leaves the observed answer fixed.
/// The commuting square binds both source readings to that step.
/// It constrains the presented applications. A global evaluator, bijectivity,
/// target membership and an invariant measure remain premises of the source. [Halt HF9]
public protocol ConservedReadingStep: CommutingTransition
where ImageStep: Null {}
