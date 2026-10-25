// comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment 
import Kit
import Other
public protocol P: Structure where Self.Axis == Leaf { associatedtype Axis: Structure }
public enum Good: P { public typealias Axis = Leaf }
public typealias Chosen = Kit.Axis
public typealias OtherAxis = Other.Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
