public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Box<Line: Structure> {}
public typealias Junk = Box<Leaf>.Line
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
