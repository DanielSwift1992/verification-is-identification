import Library
protocol Pair { associatedtype Left }
protocol Needs: Pair where Left: Marker {}
enum Demand: Needs { typealias Left = Dependent }
