enum Measure: Close {}
enum UnitsQuestion: Close {}
enum Probe: PredicateReading {
 typealias Sigma = Measure
 typealias Encoding = UnaryArithmeticEncoding
 typealias Predicate = UnitsQuestion
 typealias Left = Plus<Unit, Plus<Unit, Unit>>
 typealias Right = Plus<Plus<Unit, Unit>, Unit>
 typealias Answer = Plus<Unit, Plus<Unit, Unit>>
}
