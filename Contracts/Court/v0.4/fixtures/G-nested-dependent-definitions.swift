protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Pair where Left == Right {}
enum Unit {}
enum Other {}
enum Namespace {
 enum Dependent: Checked { typealias Left = Unit; typealias Right = Other }
}
