public protocol P { associatedtype Axis }
public typealias Other = P
public typealias Chosen = Other.Missing
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
