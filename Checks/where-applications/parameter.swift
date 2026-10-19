// A parameter's type applies a gated head where no use is read. The bad
// application is a parameter's metatype, and the demand passes the
// parameter on; Swift refuses the demand, and the court names the line.

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
func demand(_ type: Use<Bad>.Type) { need(type) }
