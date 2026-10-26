public enum Leaf {}
public protocol P { associatedtype Axis }
extension P { public typealias Axis = Leaf }
public typealias Axis = Int
public enum Good: P { public typealias Y = Axis }
let x: Good.Y.Type = Int.self
