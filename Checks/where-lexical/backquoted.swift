// A backquoted identifier is not among the forms this court reads. A raw
// identifier can spell a conformance the bad setting lacks; the compiler
// refuses the bad demand, and the court names the identifier instead of
// reading its text as source.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
func `extension Bad: Required {}`() {}
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }
public typealias GoodClaim = Use<Good>
