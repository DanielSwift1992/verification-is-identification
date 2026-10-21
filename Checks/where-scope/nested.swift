// The nested enum belongs to Namespace. The file-scope struct Plain does
// not wear Required. Reading the nested name must preserve this negative
// demand; its good neighbor does not discharge it. The excluded flag keeps
// the source line coordinates. v0.4 reads the nested identity and refuses
// the unsatisfied membership instead of refusing all nested enums.


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
