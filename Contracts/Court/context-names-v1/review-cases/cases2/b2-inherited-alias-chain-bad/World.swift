public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Axis = Leaf
public protocol P { associatedtype Axis: Structure }
public protocol Q: P where Axis == Leaf {}
public enum Bad: Q { public typealias Axis = Other }
public typealias Chosen = Bad.Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Chosen }
