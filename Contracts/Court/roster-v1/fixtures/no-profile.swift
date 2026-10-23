protocol Law { associatedtype Profile; associatedtype Command }
enum C {}
enum MissingProfile: Law { typealias Command = C }
