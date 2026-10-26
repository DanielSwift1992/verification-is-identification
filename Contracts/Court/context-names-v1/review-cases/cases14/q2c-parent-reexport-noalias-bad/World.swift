import Mid
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol Q: P where Axis == Leaf {}
public enum Bad: Q { public typealias Axis = Other }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
