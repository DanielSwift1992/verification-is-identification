public protocol Root {}
public enum Unit: Root {}
public protocol Reading: Root {}
public enum Box<T>: Reading {}
public protocol HasValue: Root { associatedtype Value }
public protocol HasReading: HasValue where Value: Reading {}
public typealias Argument = Argument
