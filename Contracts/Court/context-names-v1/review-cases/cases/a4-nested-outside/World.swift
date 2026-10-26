public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Container { public enum Slot: Structure {} }
public typealias Chosen = Slot
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Container.Slot {}
public enum Claim: Law { public typealias Value = Chosen }
