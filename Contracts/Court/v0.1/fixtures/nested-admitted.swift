// The control for unread applications: every application of a gated head
// stands where this court reads it. Uses on one line, a certificate at file
// scope and one in a conformer's table, a gate's where clause that names
// the gated head, an application inside another's arguments, and a generic
// alias of the gated head that the definitions file lends, applied in a use.
// The compiler accepts this previous control; the court now names its nested gate.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
func need<T: Admitted>(_: T.Type) {}
public typealias GoodClaim = Use<Good>
public protocol Holder {}
public enum Owner: Holder { public typealias Claim = Use<Good> }
public enum Twin<A> {}
extension Twin: Admitted
where A == Use<Good> {}
func demandGood() { need(Use<Good>.self) }
func demandOwned() { need(Owner.Claim.self) }
func demandTwin() { need(Twin<Use<Good>>.self) }
func demandWrapped() { need(Wrap<Good>.self) }
