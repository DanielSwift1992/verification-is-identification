// The control for the scope refusals: a body may declare what this court
// does not read, under names it does not resolve. A namespace holds a plain
// enums, a function holds a local struct and a typealias, a
// conformer holds a member typealias, and a block under a plain flag, which
// a compilation without the flag skips, holds a struct of the good name. A
// function's generic parameters, under fresh names, carry a constraint that
// nests three brackets deep around an arrow, and the operator `<` declares
// a generic parameter under a fresh name. A type's where clause spells
// `repeat`, a class declares `class` members after constants that compare
// numbers, and after a constant named `actor` a function runs a `repeat`
// loop before its application. The compiler accepts the world, and the
// court admits the good claim and all three applications.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
public enum Namespace {
    public enum Plain {}
    public enum Local: Setting {}
}
public enum Holder: Setting {
    public typealias Kept = Good
}
func scratch() {
#if NEVER
    struct Good {}
#endif
    struct Scratch {}
    typealias Kept = Good
    _ = (Scratch(), Kept.self)
}
public typealias GoodClaim = Use<Good>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
public protocol Marker<Value> { associatedtype Value }
public enum Box<T> {}
func demandDeep<Fresh: Setting & Marker<Box<Box<(Int) -> Good>>>, Other>(_: Fresh.Type, _: Other.Type) {
    need(Use<Good>.self)
}
public struct Pack<each T> where repeat each T: Setting {}
func < <Fresh: Setting>(_ lhs: Fresh, _ rhs: Fresh) -> Bool { false }
let comparison = 1 < 2
let ordered = (1 < 2) && (2 <= 3)
open class Counter {
    open class func make() -> Int { 1 }
    class var count: Int { 2 }
}
let actor = 1
func demandAfterLoop() {
    var turns = 0
    repeat { turns += 1 } while turns < 2
    need(Use<Good>.self)
}
