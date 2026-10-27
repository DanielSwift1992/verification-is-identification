public protocol Structure {}
public enum Leaf: Structure {}
public protocol P { associatedtype X: Structure }
public enum Holder: P { public enum X: Structure {}
 public typealias Pick = X }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Holder.X {}
public enum Claim: Law { public typealias Value = Holder.Pick }
