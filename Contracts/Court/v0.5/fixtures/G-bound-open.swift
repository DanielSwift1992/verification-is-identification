public protocol Root {}
public protocol Shape: Root {}
public protocol OtherKind: Root {}
public enum Unit: Shape {}
public enum Bad: OtherKind {}
public protocol Reading: Root {}
public enum Box<T: Shape>: Reading {}
public protocol HasValue: Root { associatedtype Value }
public protocol HasReading: HasValue where Value: Reading {}
public enum Use<T: Root>: HasReading { public typealias Value = Box<T> }
