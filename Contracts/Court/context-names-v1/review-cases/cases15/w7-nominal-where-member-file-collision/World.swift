public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Inner = Leaf
public struct Box<T> where T == Inner { public typealias Inner = Other }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
