// A member alias of a body this court does not read is no certificate it
// judges. A struct's member alias names the bad application and the demand
// uses it; Swift refuses the demand, and the court names the alias's line.

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
public struct Holder { public typealias Claim = Use<Bad> }
func demand() { need(Holder.Claim.self) }
