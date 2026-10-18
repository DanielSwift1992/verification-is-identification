// An attribute outside the built-in ones, which this text does not declare
// as a result builder or a property wrapper, is refused by name: an attached
// macro is spelled the same way and can add a conformance this court never
// sees. Here it would add the premise the bad setting lacks; the compiler,
// which has no such attribute either, refuses the file, and the court names
// the attribute instead of judging without it.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
@AddsRequired
public enum Marked: Setting {}
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }
public typealias GoodClaim = Use<Good>
