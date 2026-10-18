// A where clause may spell `repeat`, and it opens no loop there. The class
// conforms to a base that its definitions file declares with a member
// alias of the shared name, and its where clause constrains a parameter
// pack; the use sits in the class body. Swift resolves the name there to
// the inherited member, the bad setting, and refuses the use, and the court
// refuses to read a use inside a type's body instead of reading its header
// as a loop and the name at file scope.

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
public final class Owner<each T>: Base where repeat each T: Setting {
    public static func demand() { need(Use<Element>.self) }
}
