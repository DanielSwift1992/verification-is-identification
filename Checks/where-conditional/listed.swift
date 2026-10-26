// A conditional conformance listing two protocols is two gates with the same
// condition. The bad claim lacks their shared premise; each refusal names
// that protocol's structural place. A neighbouring good gate cannot hide it.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public protocol Marked {}
public enum Use<T: Setting> {}
extension Use: Admitted, Marked
where T: Required {}
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }

public protocol OtherAdmitted {}
public enum OtherUse<T: Setting> {}
extension OtherUse: OtherAdmitted
where T: Required {}
public typealias OtherGood = OtherUse<Good>
