protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Pair where Left == Right {}
protocol Needs: Pair where Left: Checked {}
enum Unit {}
enum Other {}
enum Dependent: Checked { typealias Left = Unit; typealias Right = Other }
