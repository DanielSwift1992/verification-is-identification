public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol P { associatedtype Axis }
public enum Good: P { public enum Inner { public typealias Y = Axis } }
extension Good { public typealias Axis = Other }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Good.Inner.Y }
