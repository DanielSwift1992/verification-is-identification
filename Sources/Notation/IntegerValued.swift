/// A recursive Right axis. A finite expression in the specified Never/Succ
/// grammar can interpret it as a unary count. This open protocol itself
/// supplies no terminal, unit-step constraint on Left, or finite depth.
/// CyclicNumeral in Checks/FiniteBoundary.swift is an admitted cycle. [EiF EF10]
public protocol IntegerValued: Pair
where Right: IntegerValued {}

extension Never: IntegerValued {}
