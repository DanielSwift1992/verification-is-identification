import Library
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Checked {}
typealias Claim = Use<Namespace.Dependent>
