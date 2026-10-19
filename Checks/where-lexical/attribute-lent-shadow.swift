// The shadow of a lent attribute. The world declares a macro of the same
// name as the builder Primitive.swift lends, so `@StructureBuilder` in this
// world is the world's macro, and the lent declaration says nothing about
// it. The court refuses the world: a macro declaration is a form outside its
// fragment, and a name the world declares as a macro is not lent to it. The
// compiler refuses the pair as well, because the macro has no implementation.

public protocol Setting {}
public protocol Required: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}

@attached(member)
macro StructureBuilder() = #externalMacro(module: "Nowhere", type: "Nothing")

public enum Page: Open {
    @StructureBuilder
    public static var body: some Structure {
        Unit.self
    }
}

public typealias GoodClaim = Use<Good>
func need<T: Admitted>(_: T.Type) {}
func demandGood() { need(Use<Good>.self) }
