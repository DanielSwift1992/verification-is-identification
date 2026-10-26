public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol P { associatedtype Axis }
public struct Box<T> {}
extension Box: P where T == Leaf { public typealias Axis = Other }
extension Box { public typealias Y = Axis }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Other {}
public enum Claim: Law { public typealias Value = Box<Leaf>.Y }
