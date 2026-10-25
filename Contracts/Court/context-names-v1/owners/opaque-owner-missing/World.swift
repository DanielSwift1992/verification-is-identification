public struct Owner {}
public typealias Chosen = Owner.Missing
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
