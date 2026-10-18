// The control for the lexical refusals: the built-in forms read as before.
// A directive, a built-in attribute, a property wrapper this text declares,
// one slash on a line, strings of every kind and interpolations that run
// code are no reason to refuse. The compiler accepts the world, and the
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
public struct Kept<V> {
    public var wrappedValue: V
    public init(wrappedValue: V) { self.wrappedValue = wrappedValue }
}
public enum Holder {
    @Kept public static var held = 1
}
let half = 1.0 / 2
let mark = "/* \(#line) */ // not a comment"
let raw = #"a "quoted" \#(half) and /* text"#
let block = """
    */ a closing marker, then \(mark.count)
    """
#warning("the built-in directives read as before")

public typealias GoodClaim = Use<Good>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
