protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
enum Numeral { enum _0: Digit {} }
typealias Claim = Use<Numeral._0>
