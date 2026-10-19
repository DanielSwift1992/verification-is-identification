// A parenthesized metatype is a use this court does not read. The bad
// application stands in parentheses before `.self`; Swift refuses the
// demand, and the court names the line.

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
func demand() { need((Use<Bad>).self) }
