// Commands belong to the record itself, not an independently executable list.
protocol Law { associatedtype Profile; associatedtype Group }
enum OrphanCommand: Law { static var typeName: String { #"echo orphan"# } }
