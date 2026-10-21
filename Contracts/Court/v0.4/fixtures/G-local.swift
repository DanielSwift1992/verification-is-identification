protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Pair where Left == Right {}
enum Unit {}
enum Other {}
enum Record: Checked {
 typealias Left = Unit
 typealias Right = Unit
}
