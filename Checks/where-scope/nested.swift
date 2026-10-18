// A declaration this court reads is read at file scope. The enum nested in
// a namespace wears the protocol the gate needs and shares its name with a
// file-scope struct this court does not read; Swift resolves the demand to
// the struct and refuses it, and the court names the nested declaration
// instead of reading it as the file's, at its line in the source: the
// excluded block above it is not read, and keeps its lines.

public protocol Setting {}
public protocol Required: Setting {}
public struct Plain: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
#if DEBUG
public enum Debugging: Setting {}
#endif
public enum Namespace {
    public enum Plain: Required {}
}
func need<T: Admitted>(_: T.Type) {}
func demandPlain() { need(Use<Plain>.self) }
public typealias GoodClaim = Use<Good>
