public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Axis: Structure {}
public struct Box<T> {}
public typealias Wrap<Axis> = Box<Axis>
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
