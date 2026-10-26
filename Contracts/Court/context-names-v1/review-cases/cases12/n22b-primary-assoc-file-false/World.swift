public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Axis: Structure {}
public protocol P<Axis> { associatedtype Axis }
public enum Good: P { public typealias Axis = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Axis {}
public enum Claim: Law { public typealias Value = Good.Axis }
