import Kit
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Kit.Café {}
public enum Claim: Law { public typealias Value = Kit.Café }
