public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Axis: Structure {}
public protocol P { associatedtype Axis: Structure }
public enum Good: P { public typealias Axis = Leaf }
public typealias Chosen = Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Axis {}
public enum Claim: Law { public typealias Value = Chosen }
