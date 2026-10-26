public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Slot: Structure {}
public enum Container: Structure { public enum Slot: Structure {}
public typealias Pick = Slot }
public typealias Chosen = Container.Pick
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Container.Slot {}
public enum Claim: Law { public typealias Value = Chosen }
