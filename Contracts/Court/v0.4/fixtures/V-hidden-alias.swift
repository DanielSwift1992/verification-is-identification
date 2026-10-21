protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Pair where Left == Right {}
enum Unit {}
enum Holder {
 public static var value: Int { 0 }; typealias Hidden = Unit
}
