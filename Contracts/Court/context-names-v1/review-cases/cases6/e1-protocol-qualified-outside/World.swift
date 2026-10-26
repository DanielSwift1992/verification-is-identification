public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol P { associatedtype Axis: Structure }
public typealias Chosen = P.Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = P.Axis }
