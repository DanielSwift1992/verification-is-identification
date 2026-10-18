// The control for the scope refusals: a body may declare what this court
// does not read, under names it does not resolve. A namespace holds a plain
// enum and a struct, a function holds a local struct and a typealias, and a
// conformer holds a member typealias. The compiler accepts the world, and
// the court admits the good claim and its application.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
public enum Namespace {
    public enum Plain {}
    public struct Local: Setting {}
}
public enum Holder: Setting {
    public typealias Kept = Good
}
func scratch() {
    struct Scratch {}
    typealias Kept = Good
    _ = (Scratch(), Kept.self)
}
public typealias GoodClaim = Use<Good>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
