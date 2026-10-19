// The control for a lent attribute. The world's page body is written with
// the builder Primitive.swift declares @resultBuilder. Lent beside the world,
// that declaration makes `@StructureBuilder` a form this court reads, the way
// a lent typealias makes a name mean its definition: the attribute adds no
// conformance. Alone, the world is refused at the attribute's line, because
// an attached macro is spelled the same way. The compiler accepts the pair,
// and the court admits the good claim and its application.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}

public enum Page: Open {
    @StructureBuilder
    public static var body: some Structure {
        Unit.self
    }
}

public typealias GoodClaim = Use<Good>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
