public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Axis = Leaf
public protocol P { associatedtype Axis }
public typealias PP = P
public enum Good: PP { public typealias Axis = Other
public typealias Y = Axis }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Good.Y }
