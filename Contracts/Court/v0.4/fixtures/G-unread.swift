protocol Pair { associatedtype Left; associatedtype Right }
protocol Checked: Pair where Left: Pair & Marker {}
