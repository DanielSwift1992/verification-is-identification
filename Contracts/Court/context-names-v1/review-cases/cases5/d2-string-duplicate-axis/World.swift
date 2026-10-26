public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol P { @available(*, deprecated, message: "associatedtype Axis: Structure")
associatedtype Axis: Structure }
public enum Good: P { public typealias Axis = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
