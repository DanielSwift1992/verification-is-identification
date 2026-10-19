// A use written across lines is read on one line or refused. The bad
// application's generic arguments start on the line after its head; Swift
// reads it as the same metatype and refuses the demand, and the court names
// the line instead of passing the use over beside the good claim.

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
func demand() {
    need(Use<
        Bad>.self)
}
