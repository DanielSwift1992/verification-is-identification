public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Axis = Other
public protocol P { associatedtype Axis: Structure }
extension P { public typealias Axis = Leaf }
public enum Good: P { public typealias Pick = Axis }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Good.Pick }
