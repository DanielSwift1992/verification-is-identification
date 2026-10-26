public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol P { associatedtype Axis }
public enum Good: P { public typealias Axis = Leaf
public typealias Y = Axis }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Good.Y }
