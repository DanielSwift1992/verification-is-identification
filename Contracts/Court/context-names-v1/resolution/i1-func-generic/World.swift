public protocol Structure {}
public enum Leaf: Structure {}
public enum Axis: Structure {}
public protocol Maker { func make<Axis: Structure>(_ value: Axis) -> Axis }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
