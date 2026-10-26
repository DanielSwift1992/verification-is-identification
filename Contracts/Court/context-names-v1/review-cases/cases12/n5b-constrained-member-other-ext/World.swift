public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public struct Box<T> {}
extension Box where T == Leaf { public typealias Axis = Other }
extension Box { public typealias Y = Axis }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Other {}
public enum Claim: Law { public typealias Value = Box<Other>.Y }
