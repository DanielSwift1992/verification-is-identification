protocol Law { associatedtype Profile; associatedtype Command }
enum A {}
enum MissingCommand: Law { typealias Profile = A }
