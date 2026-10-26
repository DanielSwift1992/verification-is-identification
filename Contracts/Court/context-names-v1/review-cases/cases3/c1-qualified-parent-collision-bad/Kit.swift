public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Axis = Leaf
public protocol P { associatedtype Axis: Structure }
