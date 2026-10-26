public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Axis: Structure {}
public protocol P { associatedtype Axis: Structure }
public protocol Q: P where Axis == Leaf {}
public enum Good: Q { public typealias Axis = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
