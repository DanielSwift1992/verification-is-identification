// A name this court resolves is declared once. The bad setting is declared
// again inside a function body, wearing the protocol the gate needs; Swift
// resolves the demand at file scope to the bad setting and refuses it, and
// the court names both lines instead of reading the inner declaration as
// the file's and holding the file over the good neighbour.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
func shadow() {
    enum Bad: Required {}
}
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }
public typealias GoodClaim = Use<Good>
