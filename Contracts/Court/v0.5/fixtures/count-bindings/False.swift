import Engine
import One
import Two
public protocol PredicateReading: Close { associatedtype Left: Structure; associatedtype Right: Structure; associatedtype Answer: Structure; associatedtype Sigma: Structure; associatedtype Encoding: Structure; associatedtype Predicate: Structure }
public enum UnaryArithmeticEncoding: Close {}
public enum Measure: Close {}
public enum UnitsQuestion: Close {}
public enum Reading<A: Structure, B: Structure>: PredicateReading {
 public typealias Left = A
 public typealias Right = B
 public typealias Answer = B
 public typealias Sigma = Measure
 public typealias Encoding = UnaryArithmeticEncoding
 public typealias Predicate = UnitsQuestion
}
public typealias Probe = Reading<Plus<One.Mark,Two.Mark>,Unit>
