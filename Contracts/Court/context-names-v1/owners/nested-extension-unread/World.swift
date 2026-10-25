public protocol Structure {}
public enum Leaf: Structure {}
public enum Container { public enum Slot: Structure {} }
extension Container.Slot { public typealias Other = Leaf }
public typealias Chosen = Container.Slot
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
