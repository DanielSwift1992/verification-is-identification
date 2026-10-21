protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Cycle where Left == Right {}
protocol Cycle: Checked {}
enum Unit {}
