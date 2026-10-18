// An extension of a typealias extends the alias's type. The definitions
// file names the world's Owner through an alias of its own and extends the
// alias with a member alias of the good setting's name that stands for the
// bad one; a reader that took the alias for a type of the definitions file
// would pass the extension over. Swift resolves the certificate's name
// inside Owner to the member and refuses the demand, and the court refuses
// the extension through the alias.

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
public enum Left: Required {}
public protocol Holder {}
public enum Owner: Holder { public typealias Claim = Use<Left> }
func demand() { need(Owner.Claim.self) }
