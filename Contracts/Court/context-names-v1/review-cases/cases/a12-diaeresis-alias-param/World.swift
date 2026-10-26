import Kit
public protocol Structure {}
public enum Leaf: Structure {}
public typealias W¨<T> = Kit.Box<T>
public typealias Chosen = W¨<Leaf>
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Kit.Box<Leaf> {}
public enum Claim: Law { public typealias Value = Chosen }
