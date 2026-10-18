// A generic parameter list is read to its closing bracket, however deep
// its constraints nest. The function's parameter shares the good setting's
// name, and its constraint nests a generic type three brackets deep; Swift
// resolves the demand inside the function to the parameter, which conforms
// to the base setting only, and refuses it, and the court names both lines
// instead of losing the parameter among the brackets.

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
public protocol Marker<Value> { associatedtype Value }
public enum Box<T> {}
func demand<Good: Setting & Marker<Box<Box<Box<Bad>>>>>(_: Good.Type) {
    need(Use<Good>.self)
}
