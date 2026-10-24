public protocol Marker {}
public enum Shape: Marker {}
public enum Wrong {}
public enum Box<T: Marker>: Marker {}
