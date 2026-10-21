// header

#if true
public enum Unit {}
public enum Plus<A, B> {}
public protocol Admitted {}
public enum Match<A, B> {}
extension Match: Admitted
where A == B {}
func need<T: Admitted>(_: T.Type) {}
public typealias U2 = Plus<Unit, Unit>
public typealias Claim = Match<U2, Plus<Unit, Unit>>
func check() { need(Claim.self) }
#endif
