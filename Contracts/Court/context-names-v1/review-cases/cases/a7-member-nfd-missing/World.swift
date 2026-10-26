public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Box { public enum Café: Structure {} }
public typealias Chosen = Box.Café
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Box.Café {}
public enum Claim: Law { public typealias Value = Chosen }
