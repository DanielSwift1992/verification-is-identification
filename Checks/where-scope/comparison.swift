// A comparison opens no bracket. A constant compares two numbers on the
// line before a class; a reader that counted its `<` as an open generic
// bracket would read the class keyword as inside it and the class body as
// no type's. The class conforms to a base that its definitions file declares
// with a member alias of the shared name, and the use sits in the class
// body. Swift resolves the name there to the inherited member, the bad
// setting, and refuses the use, and the court refuses to read a use inside
// a type's body.

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
let comparison = 1 < 2
public final class Owner: Base {
    public static func demand() { need(Use<Element>.self) }
}
