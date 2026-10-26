public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Container { public enum Slot: Structure {}
public enum Inner { public enum Slot: Structure {}
public enum Probe: Structure { public typealias Value = Slot } } }
public typealias Chosen = Container.Inner.Probe.Value
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Container.Inner.Slot {}
public enum Claim: Law { public typealias Value = Chosen }
