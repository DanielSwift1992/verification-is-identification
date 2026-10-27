import Kit
public enum Item {}
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Item {}
public enum Claim: Law { public typealias Value = Item }
