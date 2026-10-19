// The boundary of a lent attribute. The lent declaration shows that
// `@StructureBuilder` is a builder and not a macro; it does not show which
// Body the builder built. A gate that asks for that Body meets a declaration
// whose body is outside the flat fragment: the court does not read it, so it
// gives no verdict on the claim, neither holds nor refused. The compiler, which
// reads the body, refuses the demand: the page's Body is the opaque
// `some Structure` the builder returned, not Never.

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
public protocol Flat {}
public enum Shows<P: Open> {}
extension Shows: Flat
where P.Body == Never {}

public typealias GoodClaim = Use<Good>
public typealias PageIsFlat = Shows<Page>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
func needFlat<T: Flat>(_: T.Type) {}
func demandFlat() { needFlat(Shows<Page>.self) }
