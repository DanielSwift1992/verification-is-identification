// A definitions file's parameterless alias of a gated application is a
// certificate this court does not judge outside the world. The world's
// demand uses the alias by name; Swift refuses it, and the court names the
// alias and its file.

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
func demand() { need(Claim.self) }
