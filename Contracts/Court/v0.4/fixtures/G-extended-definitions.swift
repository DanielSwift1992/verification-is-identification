protocol Marker {}
protocol Checked: Marker where Left == Right { associatedtype Left; associatedtype Right }
enum Unit {}
enum Other {}
enum Dependent: Marker { typealias Left = Unit; typealias Right = Other }
extension Dependent: Checked {}
