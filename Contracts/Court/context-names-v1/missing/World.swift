import Kit
public typealias Shape = Kit.Absent
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Shape {}
public enum Claim: Law { public typealias Value = Shape }
