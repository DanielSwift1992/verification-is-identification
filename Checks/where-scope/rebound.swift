// A declaration this court does not read still binds its name. A typealias
// inside a function body rebinds the good setting's name to the bad one;
// Swift resolves the demand inside that body to the bad setting and refuses
// it, and the court names both lines instead of resolving the name at file
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
func demandRebound() {
    typealias Good = Bad
    need(Use<Good>.self)
}
public typealias GoodClaim = Use<Good>
