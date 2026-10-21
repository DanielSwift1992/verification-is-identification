protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
enum Box<T> { enum Leaf: Digit {} }
typealias Claim = Use<Box.Leaf>
