import Kit
public typealias Box = Kit.Box<Kit.Wrong>
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Box {}
public enum Claim: Law { public typealias Value = Box }
