public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Axis = Leaf
public protocol P { associatedtype Axis: Structure }
public typealias PP = P
public protocol Q: PP where Axis == Leaf {}
public enum Good: Q { public typealias Axis = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
