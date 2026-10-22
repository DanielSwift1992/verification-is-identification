import Swift
public protocol Leaf {}
extension String: Leaf {}
public protocol HasValue { associatedtype Value }
public protocol HasLeaf: HasValue where Value: Leaf {}
public enum Use: HasLeaf { public typealias Value = String }
