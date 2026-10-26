public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
@available(*, deprecated, message: #"enum Phantom: Structure {}"#)
public enum Marked: Structure {}
public typealias Chosen = Phantom
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Phantom {}
public enum Claim: Law { public typealias Value = Chosen }
