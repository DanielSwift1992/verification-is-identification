public protocol Structure {}
public enum Leaf: Structure {}
public enum Other: Structure {}
public enum Box { public static func <<<Axis>(lhs: Box, rhs: Axis) -> Box { lhs } }
public protocol Reading { associatedtype Value }
public protocol Law: Reading where Value == Leaf {}
public enum Claim: Law { public typealias Value = Leaf }
