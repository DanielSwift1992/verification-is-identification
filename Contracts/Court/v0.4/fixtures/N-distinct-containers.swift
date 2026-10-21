protocol Admitted {}
enum Match<A, B> {}
extension Match: Admitted where A == B {}
protocol Plain {}
enum A { enum Leaf: Plain {} }
enum B { enum Leaf: Plain {} }
typealias Claim = Match<A.Leaf, B.Leaf>
