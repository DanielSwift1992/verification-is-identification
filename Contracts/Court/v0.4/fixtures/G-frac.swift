import Core
protocol Frac: Pair where Left: Structure, Right: Structure {}
extension Paired: Frac where L: Structure, R: Structure {}
