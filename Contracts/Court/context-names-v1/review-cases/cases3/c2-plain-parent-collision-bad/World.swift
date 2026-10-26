import Kit
public protocol Q: P where Axis == Kit.Leaf {}
public enum Bad: Q { public typealias Axis = Kit.Other }
public typealias Unused = Kit.Axis
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Kit.Leaf {}
public enum Claim: Law { public typealias Value = Kit.Leaf }
