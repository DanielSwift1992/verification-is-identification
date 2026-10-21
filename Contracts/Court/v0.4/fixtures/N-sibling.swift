protocol Admitted {}
enum Match<A, B> {}
extension Match: Admitted where A == B {}
protocol Pair {}
enum A {
 enum Unit: Pair {}
 enum Leaf: Pair { typealias Left = Unit }
}
typealias Claim = Match<A.Leaf.Left, A.Unit>
