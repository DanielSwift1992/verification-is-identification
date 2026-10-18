// A regular expression literal is not among the forms this court reads,
// and a declaration spelled inside one is no premise. The literal carries
// the text of a conformance the bad setting lacks; the compiler refuses the
// bad demand, and the court names the literal instead of reading the text
// as source and holding the file over the good neighbour.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
let fake = #/extension Bad: Required {1}/#
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }
public typealias GoodClaim = Use<Good>
