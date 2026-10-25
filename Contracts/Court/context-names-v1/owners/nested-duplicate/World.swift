public protocol Structure {}
public enum Leaf: Structure {}
public enum Container { public enum Slot: Structure {}
public enum Slot: Structure {} }
public typealias Chosen = Leaf
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
