public protocol Structure {}
public enum Leaf: Structure {}
public enum Axis: Structure {}
public protocol P { associatedtype Axis: Structure }
public enum Binding: P { public typealias Axis = Leaf }
public typealias Chosen = Binding.Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Chosen }
