public protocol Structure {}
public enum Leaf: Structure {}
public enum Binding: Structure { public typealias Axis = Leaf }
public typealias Chosen = Binding.Missing
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Chosen {}
public enum Claim: Law { public typealias Value = Chosen }
