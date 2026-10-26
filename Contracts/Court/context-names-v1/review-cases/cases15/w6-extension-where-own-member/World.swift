public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public struct Box<T> { public typealias Inner = Leaf }
extension Box where T == Inner { public typealias Z = T }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Box<Leaf>.Z }
