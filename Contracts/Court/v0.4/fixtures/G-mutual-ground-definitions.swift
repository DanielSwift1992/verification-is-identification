protocol Pair { associatedtype Left }
protocol Recursive: Pair where Left: Recursive {}
