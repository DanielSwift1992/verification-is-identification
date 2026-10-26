public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol P { associatedtype Axis: Structure }
public protocol Q1: P {}
public protocol Q2: P {}
public protocol R: Q1, Q2 where Axis == Leaf {}
public enum Bad: R { public typealias Axis = Other }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
