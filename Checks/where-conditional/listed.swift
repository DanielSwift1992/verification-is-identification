// A conditional conformance that lists two protocols before its where
// clause is a gate this court does not read, and the court names it instead
// of passing over it. The bad claim's setting lacks the premise, and a
// neighbour gate holds for the good setting. The compiler refuses the bad
// demand; the court gives no verdict and names the conformance it cannot
// read.

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
