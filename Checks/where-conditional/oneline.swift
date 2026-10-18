// A conditional conformance written on one line is the same gate. The bad
// claim's setting lacks the premise, and a neighbour gate written over two
// lines holds for the good setting. The compiler refuses the bad demand; the
// court reads the one-line gate and refuses the bad claim and its
// application rather than counting the neighbour and passing the file.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted where T: Required {}
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }

public protocol OtherAdmitted {}
public enum OtherUse<T: Setting> {}
extension OtherUse: OtherAdmitted
where T: Required {}
public typealias OtherGood = OtherUse<Good>
