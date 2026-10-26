import Kit
public protocol Structure {}
public enum Shape: Structure {}
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Shape {}
public enum Claim: Law { public typealias Value = Shape }
