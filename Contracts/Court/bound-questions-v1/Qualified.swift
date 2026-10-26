import Engine
public protocol PredicateReading: Close { associatedtype Left: Structure; associatedtype Right: Structure; associatedtype Answer: Structure; associatedtype Sigma: Structure; associatedtype Encoding: Structure; associatedtype Predicate: Structure }
public enum UnaryArithmeticEncoding: Close {}
public enum Measure: Close {}
public enum UnitsQuestion: Close {}
public enum Reading<A: Structure, B: Structure, C: Structure>: PredicateReading {
 public typealias Left = A
 public typealias Right = Plus<B,C>
 public typealias Answer = Self.Right
 public typealias Sigma = Measure
 public typealias Encoding = UnaryArithmeticEncoding
 public typealias Predicate = UnitsQuestion
}
public typealias Probe = Reading<Plus<Unit,Unit>,Unit,Unit>
public enum Note: Close {}
extension World.Note { public static var typeName: String { "" } }
public protocol Equation: Null {}
public enum Witness: Equation {
 public typealias Left = Probe.Answer
 public typealias Right = Plus<Unit,Unit>
}
