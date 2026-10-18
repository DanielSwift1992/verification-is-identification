// An extension's owner is read in full. The definitions file extends the
// world's Owner through the module's name, `main.Owner`, with a member
// alias of the good setting's name that stands for the bad one; a reader
// that took the first word for the owner would find no type `main` here
// and pass the extension over. Swift resolves the certificate's name
// inside Owner to the member and refuses the demand, and the court refuses
// the qualified owner at its line.

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
