public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias A = B
public typealias B = C
public typealias C = A
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = A }
