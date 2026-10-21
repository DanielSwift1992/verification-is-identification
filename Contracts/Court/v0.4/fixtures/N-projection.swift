protocol Admitted {}
enum Match<A, B> {}
extension Match: Admitted where A == B {}
enum Unit {}
protocol Pair {}
enum A { enum Leaf: Pair { typealias Left = Unit } }
typealias Claim = Match<A.Leaf.Left, Unit>
