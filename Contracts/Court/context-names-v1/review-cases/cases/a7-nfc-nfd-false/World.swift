public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Café: Structure {}
public enum Café: Structure {}
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Café {}
public enum Claim: Law { public typealias Value = Café }
