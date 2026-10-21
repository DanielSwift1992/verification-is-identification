import Library
enum A: Recursive { typealias Left = B }
enum B: Recursive { typealias Left = A }
