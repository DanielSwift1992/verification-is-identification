protocol Structure {}
protocol Pair { associatedtype Left; associatedtype Right }
protocol Frac: Pair where Left: Structure, Right: Structure {}
enum Unit: Structure {}
