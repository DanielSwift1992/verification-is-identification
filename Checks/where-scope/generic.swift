// A generic parameter is a declaration of its name. The function's
// parameter shares the good setting's name and is bound to no protocol;
// Swift resolves the demand inside the function to the parameter and
// refuses it, and the court names both lines instead of resolving the name
// at file scope to the good setting.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
func need<T: Admitted>(_: T.Type) {}
func demandParameter<Good>(_: Good.Type) { need(Use<Good>.self) }
public typealias GoodClaim = Use<Good>
