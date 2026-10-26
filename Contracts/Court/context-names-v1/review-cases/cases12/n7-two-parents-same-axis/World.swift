public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol P1 { associatedtype Axis: Structure }
public protocol P2 { associatedtype Axis: Structure }
public protocol R: P1, P2 where Axis == Leaf {}
public enum Good: R { public typealias Axis = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
