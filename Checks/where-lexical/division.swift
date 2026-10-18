// The boundary of the slash rule: a division written without a space after
// its slash is refused with the regular expression literals, because this
// reader cannot tell it from the slash that opens one. The compiler accepts
// the world; the court gives no verdict and names the slash. The refusal
// narrows what the court reads and says nothing against the program.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
let half = 12/2
public typealias GoodClaim = Use<Good>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
