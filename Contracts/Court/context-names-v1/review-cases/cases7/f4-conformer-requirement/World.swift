public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public protocol Q: Structure where Axis == Leaf { associatedtype Axis: Structure }
public enum Box<Line: Structure>: Q { public typealias Axis = Box.Line }
public typealias Probe = Box<Other>
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
