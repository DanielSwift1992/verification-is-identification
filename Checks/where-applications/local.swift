// A typealias in a function body is a certificate this court does not
// read. The local alias names the bad application and the demand uses the
// alias; Swift refuses the demand, and the court names the alias's line.

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
    typealias Local = Use<Bad>
    need(Local.self)
}
