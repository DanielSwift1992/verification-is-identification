// §4 Engine

/// Element of Σ (§2.1).
public protocol State: Sendable {}

/// Mapping claim: Input → Output, verified by type constraints.
public protocol Rule: Sendable {
    associatedtype Input: State
    associatedtype Output: State
}

/// Compilation gate (§4.7).
public protocol Gate: Sendable {
    associatedtype Claim: Rule
    static func verify()
    static func identify(input: Claim.Input.Type) -> Claim.Output.Type
}

/// Compilation = verification. If this compiles, the claim holds.
public enum CompilationGate<R: Rule>: Gate {
    public typealias Claim = R
    public static func verify() {}
    public static func identify(input: R.Input.Type) -> R.Output.Type {
        R.Output.self
    }
}
