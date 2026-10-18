// Comment markers and declarations inside string literals are text, and a
// quote inside a comment opens no string. Every literal form carries a marker
// or a declaration here: a plain string with an escaped quote, a multiline
// string, raw strings with one and two #, a raw multiline string, and an
// interpolation that nests a string. The real declarations between them are
// read: the compiler refuses the bad claim's demand, the court refuses the
// bad claim and its application, and the good neighbour holds.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}

let openingMarker = "/* \" still the same string"
public typealias BadClaim = Use<Bad>
func need<T: Admitted>(_: T.Type) {}
func demandBad() { need(Use<Bad>.self) }
let closingMarker = "*/"
let multiline = """
    */ /* a block marker on its own line
    extension Bad: Required {}
    """
let raw = #"a quote " and /* inside a raw string"#
let rawer = ##"a "# and */ inside"##
let rawMultiline = #"""
    a "" and """ inside, then /*
    """#
let nested = "outer \(String("inner /* string")) still outer */"
// a quote in a comment " opens no string
/* nor in a block " comment */
public typealias GoodClaim = Use<Good>
