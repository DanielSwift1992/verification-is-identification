protocol Open {}
protocol IntegerValued {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
typealias Claim = Use<Numeral._0>
