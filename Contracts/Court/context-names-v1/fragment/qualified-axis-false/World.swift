public protocol Structure {}
public enum Leaf: Structure {}
public enum Axis: Structure {}
public protocol P: Structure where Self.Axis == Leaf { associatedtype Axis: Structure }
public enum BadAxis: Structure {}
public enum Good: P { public typealias Axis = BadAxis }
public typealias Chosen = Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
