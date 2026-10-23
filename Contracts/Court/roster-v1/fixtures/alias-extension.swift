protocol Law { associatedtype Axis: Atom }
protocol Atom {}
enum A: Atom {}
typealias Alias = A
enum Later { typealias Axis = Alias }
extension Later: Law {}
