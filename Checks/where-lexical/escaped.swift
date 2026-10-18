// A bare regular expression literal whose last pattern character is an
// escaped slash ends in `\//`, which reads as a comment if the literal is
// not refused first. It is: the slash that opens it opens no comment and
// has no whitespace after it. The literal carries the text of a conformance
// the bad setting lacks; the compiler, given bare literals, refuses the bad
// demand, and the court names the opening slash instead of reading the text
// as source.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
let fake = /extension Bad: Required {1}\//
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }
public typealias GoodClaim = Use<Good>
