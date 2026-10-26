public enum Leaf {}
public class Box<T> where T == Box.Inner { public typealias Inner = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
