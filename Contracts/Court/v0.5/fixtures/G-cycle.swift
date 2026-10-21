public protocol Root {}
public protocol HasValue: Root { associatedtype Value }
public protocol Checked: HasValue where Value: Checked {}
public enum Box<T: Root>: Checked { public typealias Value = Box<T> }
public enum Use: Checked { public typealias Value = Box<Use> }
