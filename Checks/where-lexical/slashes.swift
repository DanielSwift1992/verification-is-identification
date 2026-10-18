// A bare regular expression literal, `/…/`, opens with a slash that opens
// no comment and has no whitespace after it, so such a slash in code is
// refused by name before the literal's text can be read. The literal
// carries the text of a conformance the bad setting lacks; the compiler,
// given bare literals, refuses the bad demand.

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
