protocol Pair { associatedtype Left }
protocol Need: Pair where Left: P {}
