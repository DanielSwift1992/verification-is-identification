protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Pair where Left == Right {}
enum Holder: Pair { typealias Left = Missing; typealias Right = Missing }
