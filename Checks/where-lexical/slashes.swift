// A bare regular expression literal, `/…/`, cannot be told from two
// divisions by this reader, so a second slash on one line is refused by
// name. The literal carries the text of a conformance the bad setting
// lacks; the compiler, given bare literals, refuses the bad demand.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
let fake = /extension Bad: Required {1}/
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }
public typealias GoodClaim = Use<Good>
