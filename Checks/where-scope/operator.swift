// An operator's generic parameter list is read like a word's. The function
// is the operator `<`, whose generic parameter shares the good setting's
// name and conforms to the base setting only; a reader that took only a
// word for a function's name would pass the list over. Swift resolves the
// demand inside the operator to the parameter and refuses it, and the court
// names both declarations of the name instead of resolving it at file
// scope to the good setting.

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
func < <Good: Setting>(_ lhs: Good, _ rhs: Good) -> Bool {
    need(Use<Good>.self)
    return false
}
