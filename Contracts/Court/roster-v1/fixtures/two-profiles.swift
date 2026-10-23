protocol Law { associatedtype Profile; associatedtype Command }
enum A {}
enum B {}
enum TwoProfiles: Law { typealias Profile = A; typealias Profile = B; typealias Command = A }
