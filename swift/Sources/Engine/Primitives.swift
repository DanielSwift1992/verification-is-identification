// §2 Peano naturals — type-level arithmetic.

public protocol Nat: Sendable {
    static var value: Int { get }
}

/// Zero.
public enum Z: Nat {
    public static var value: Int { 0 }
}

/// Successor.
public enum S<N: Nat>: Nat {
    public static var value: Int { N.value + 1 }
}

public typealias N0 = Z
public typealias N1 = S<N0>
public typealias N2 = S<N1>
public typealias N3 = S<N2>
public typealias N4 = S<N3>
public typealias N5 = S<N4>
public typealias N6 = S<N5>
public typealias N7 = S<N6>
public typealias N8 = S<N7>
public typealias N9 = S<N8>
