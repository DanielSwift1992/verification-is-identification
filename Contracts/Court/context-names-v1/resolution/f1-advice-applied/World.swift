public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Line: Structure {}
public protocol P { associatedtype Axis }
public enum Box<Line: Structure> {}
extension Box: P { public typealias Axis = Box.Line }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
