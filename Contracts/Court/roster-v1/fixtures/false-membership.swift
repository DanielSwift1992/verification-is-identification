protocol Law { associatedtype Axis: Atom }
protocol Atom {}
enum A {}
enum False: Law { typealias Axis = A }
