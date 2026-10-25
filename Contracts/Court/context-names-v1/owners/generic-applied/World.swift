import Kit
import API
public typealias Chosen = Wrap<Leaf>
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
