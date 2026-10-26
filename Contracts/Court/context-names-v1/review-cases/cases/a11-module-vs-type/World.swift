import Kit
public enum Kit {}
public protocol Structure {}
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Kit.Shape {}
public enum Claim: Law { public typealias Value = Kit.Shape }
