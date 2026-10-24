public typealias Shape = Loop
public typealias Loop = Shape
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Shape {}
public enum Claim: Law { public typealias Value = Shape }
