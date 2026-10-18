// A name bound outside this file rebinds a file-scope name inside the body
// of an extension: within `extension Array`, `Element` is the array's own
// generic parameter, not the file's enum. This court does not read the
// members of a type another file declares, so a use inside a type or an
// extension body is refused at its line. The compiler refuses the demand;
// the court names the use instead of reading `Element` as the file's.

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
public enum Element: Required {}
extension Array {
    static func demand() { need(Use<Element>.self) }
}
