public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum K: Structure {}
public enum K: Structure {}
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == K {}
public enum Claim: Law { public typealias Value = K }
