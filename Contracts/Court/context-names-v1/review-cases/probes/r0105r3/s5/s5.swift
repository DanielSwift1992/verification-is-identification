public enum Leaf {}
public protocol P { associatedtype Axis }
public protocol Q: P where Axis == Leaf {}
