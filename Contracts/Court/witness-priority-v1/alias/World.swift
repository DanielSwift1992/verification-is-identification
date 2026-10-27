public protocol Structure {}
public enum Leaf: Structure {}
public protocol P { associatedtype X: Structure }
public protocol Q: P {}
public enum Holder: Q { public typealias X = Leaf
 public typealias Pick = X }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Holder.Pick }
