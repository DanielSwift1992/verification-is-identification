import Kit
import Other
public typealias KitShape = Kit.Shape
public typealias OtherShape = Other.Shape
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == KitShape {}
public enum Claim: Law { public typealias Value = KitShape }
