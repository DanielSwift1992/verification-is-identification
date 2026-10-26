public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public typealias Junk = Nonexistent
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
