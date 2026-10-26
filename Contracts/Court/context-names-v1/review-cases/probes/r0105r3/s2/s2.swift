public enum Leaf {}
public protocol P { associatedtype Axis }
public struct Box<T>: P where T == Axis { public typealias Axis = Leaf }
