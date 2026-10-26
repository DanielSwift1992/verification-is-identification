public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol R {}
public protocol P { associatedtype Axis: Structure }
public protocol Q: R & P where Axis == Leaf {}
public enum Bad: Q { public typealias Axis = Other }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
