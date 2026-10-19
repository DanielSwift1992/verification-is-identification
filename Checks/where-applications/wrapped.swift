// A typealias that applies a gated head applies it in turn. A generic
// alias wraps the gated head, and a parameter's type applies the alias to
// the bad setting; Swift refuses the demand, and the court names the line.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
func need<T: Admitted>(_: T.Type) {}
public typealias GoodClaim = Use<Good>
public typealias Wrap<X: Setting> = Use<X>
func demand(_ type: Wrap<Bad>.Type) { need(type) }
