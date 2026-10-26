import Kit
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Axis = Leaf
public enum Good: P { public typealias Axis = Other
public typealias Y = Kit.P }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
