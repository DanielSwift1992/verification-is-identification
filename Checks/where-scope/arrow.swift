// An arrow inside a generic parameter list closes no bracket. The first
// parameter's constraint spells a function type, whose `->` a bracket
// count would read as a closing `>`; the second parameter shares the good
// setting's name and conforms to the base setting only. Swift resolves the
// demand inside the function to the parameter and refuses it, and the court
// names both lines instead of losing the parameter after the arrow.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
func need<T: Admitted>(_: T.Type) {}
public typealias GoodClaim = Use<Good>
public protocol Marker<Value> { associatedtype Value }
func demand<Other: Marker<(Int) -> Int>, Good: Setting>(_: Other.Type, _: Good.Type) {
    need(Use<Good>.self)
}
