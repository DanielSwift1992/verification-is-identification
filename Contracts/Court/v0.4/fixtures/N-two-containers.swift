protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
enum A { enum Leaf: Digit {} }
enum B { enum Leaf: Digit {} }
typealias First = Use<A.Leaf>
typealias Second = Use<B.Leaf>
