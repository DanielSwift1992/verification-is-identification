// A definitions file that extends a type of this world is one this court
// cannot place. Beside this world, lent-definitions.swift extends Owner with
// `Left = Bad`, and within Owner `Left` would then be the bad setting; but
// whether that extension is this world's Owner (the definitions file could
// declare its own, privately, or sit in another module) and whether its
// member reaches this file are not facts the flat reader establishes. The
// compiler, given both files, refuses the demand; the court names the
// extension and gives no verdict.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
public enum Left: Required {}
public protocol Holder {}
public enum Owner: Holder {
    public typealias Claim = Use<Left>
}
func need<T: Admitted>(_: T.Type) {}
func demand() { need(Owner.Claim.self) }
public typealias GoodClaim = Use<Good>
