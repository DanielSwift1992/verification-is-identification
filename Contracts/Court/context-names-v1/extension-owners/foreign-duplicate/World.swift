import Kit
extension Box { public typealias Item = Leaf }
extension Box { public typealias Item = Leaf }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
