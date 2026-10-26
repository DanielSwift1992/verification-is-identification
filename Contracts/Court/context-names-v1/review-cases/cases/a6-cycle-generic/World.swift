public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias A<T> = B<T>
public typealias B<T> = A<T>
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = A<Leaf> }
