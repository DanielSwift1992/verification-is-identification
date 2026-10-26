import Kit
public typealias Shape = Kit.Shape
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == World.Shape {}
public enum Claim: Law { public typealias Value = World.Shape }
