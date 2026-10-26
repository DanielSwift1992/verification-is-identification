public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Axis: Structure {}
public protocol P: Structure where Self.Axis == Leaf { associatedtype Axis: Structure }
public enum Bad: P { public typealias Axis = Other }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
