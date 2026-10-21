protocol Structure {}
protocol Pair { associatedtype Left; associatedtype Right }
enum Unit: Structure {}
enum Paired<L, R>: Pair { typealias Left = L; typealias Right = R }
