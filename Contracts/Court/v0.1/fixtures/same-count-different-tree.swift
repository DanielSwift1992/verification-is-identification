public enum Unit {}
public enum Plus<A, B> {}
public protocol Admitted {}
public enum Match<A, B> {}
extension Match: Admitted
where A == B {}
func need<T: Admitted>(_: T.Type) {}
public typealias Claim = Match<Plus<Plus<Unit, Unit>, Unit>, Plus<Unit, Plus<Unit, Unit>>>
func check() { need(Claim.self) }
