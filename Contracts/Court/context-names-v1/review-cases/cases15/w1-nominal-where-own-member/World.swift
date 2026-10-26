public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public struct Box<T> where T == Inner { public typealias Inner = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Box<Leaf>.Inner }
