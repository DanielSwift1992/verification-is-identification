protocol Text { static var typeName: String { get } }
protocol Profile: Text {}
protocol Group: Text {}
protocol Law: Text where Command == Self {
    associatedtype Command: Law = Self
    associatedtype Profile: Text
    associatedtype Group: Text
}
enum VI: Text { static var typeName: String { #"vi"# } }
enum Serial: Text { static var typeName: String { #"serial"# } }
enum First: Law {
    typealias Profile = VI
    typealias Group = Serial
    static var typeName: String { #"echo observed"# }
}
