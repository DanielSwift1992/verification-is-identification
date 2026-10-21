protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
enum A {
 enum Leaf: Digit {}
 enum Leaf: Digit {}
}
typealias Claim = Use<A.Leaf>
