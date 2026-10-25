public protocol Structure {}
public enum Leaf: Structure {}
public enum Slot: Structure {}
public enum Container { public enum Slot: Structure {}
public enum Inner: Structure { public typealias Value = Slot }
}
public typealias Chosen = Container.Inner.Value
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Container.Slot {}
public enum Claim: Law { public typealias Value = Chosen }
