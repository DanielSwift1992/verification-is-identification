public enum Leaf {}
public enum Other {}
public typealias Axis = Leaf
public protocol Q: P where Axis == Leaf {}
public enum Bad: Q { public typealias Axis = Other }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
