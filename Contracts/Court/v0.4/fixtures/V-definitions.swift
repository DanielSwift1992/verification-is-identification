protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Pair where Left == Right {}
enum Unit {}
enum Holder {
 public static func value<T>() { _ = Box<T>.self }
}
