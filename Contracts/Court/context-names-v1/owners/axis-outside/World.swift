public protocol Structure {}
public enum Leaf: Structure {}
public protocol P { associatedtype Axis: Structure }
public typealias Chosen = Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
