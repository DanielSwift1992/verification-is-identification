public enum Leaf {}
public protocol P { associatedtype Slot }
extension P { public typealias Slot = Leaf }
extension P { public typealias Slot = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
