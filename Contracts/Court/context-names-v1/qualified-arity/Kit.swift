public protocol Marker {}
public enum Shape: Marker {}
public enum Box<T: Marker>: Marker {}
