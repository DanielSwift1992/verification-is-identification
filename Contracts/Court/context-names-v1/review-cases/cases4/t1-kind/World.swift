public protocol Structure {}
public enum Leaf: Structure {}
public enum Kind: Structure {}
public protocol P { associatedtype Kind: Structure }
public enum Good: P { public typealias Kind = Leaf }
public typealias Chosen = Kind
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Kind {}
public enum Claim: Law { public typealias Value = Chosen }
