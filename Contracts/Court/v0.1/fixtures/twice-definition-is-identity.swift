public enum Unit {}
public enum Plus<A, B> {}
public protocol Admitted {}
public enum Match<A, B> {}
extension Match: Admitted
where A == B {}
func need<T: Admitted>(_: T.Type) {}
public typealias Twice<T> = T
public typealias Claim = Match<Twice<Unit>, Plus<Unit, Unit>>
func check() { need(Claim.self) }
