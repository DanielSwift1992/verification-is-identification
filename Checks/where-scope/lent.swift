// A member a definitions file writes for a conformer of this world binds
// its name inside the conformer before the file's scope does. Beside this
// world, lent-definitions.swift extends Owner with `Left = Bad`, so within
// Owner `Left` is the bad setting, not the file's enum. The court reads that
// extension as the conformer's, as it reads the world's own, and refuses the
// certificate for the premise Bad lacks; the compiler, given both files,
// refuses the demand.

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
