// The control for the lexical refusals: the built-in forms read as before.
// A directive, a built-in attribute, a property wrapper this text declares
// with another attribute between it and the type, a division with a space
// after its slash, comments, strings of every kind and interpolations that
// run code are no reason to refuse. The compiler accepts the world, and the
// court admits the good claim and its application.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}

@available(*, deprecated, message: "kept for the check")
public enum Retired: Setting {}
@propertyWrapper
@available(*, deprecated, message: "kept for the check")
public struct Kept<V> {
    public var wrappedValue: V
    public init(wrappedValue: V) { self.wrappedValue = wrappedValue }
}
public enum Holder {
    @Kept public static var held = 1
}
let count = 12 / 6 // a comment after code
let mark = "/* \(#line) */ // not a comment"
let raw = #"a "quoted" \#(count) and /* text"#
let block = """
    */ a closing marker, then \(mark.count)
    """
#warning("the built-in directives read as before")

public typealias GoodClaim = Use<Good>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
