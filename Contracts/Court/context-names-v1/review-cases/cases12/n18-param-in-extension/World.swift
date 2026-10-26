public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public struct Box<T> {}
extension Box { public typealias Y = T }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Box<Leaf>.Y }
