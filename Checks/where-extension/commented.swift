// A conformance that only a comment or a disabled branch states is no
// conformance. One setting's extension sits in a block comment that nests a
// second comment, and the other's in an outer #if whose inner #if closes
// first. The compiler, given neither flag, refuses both demands, and the
// court refuses both claims for the premise nothing states.

public protocol Setting {}
public protocol Required: Setting {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}

// /* a line comment opens no block
public enum Commented: Setting {}
/*
extension Commented: Required {}
/* a nested comment closes here */
extension Commented: Required {}
*/

public enum Disabled: Setting {}
#if OUTER_FLAG
#if INNER_FLAG
#endif
extension Disabled: Required {}
#endif

public typealias CommentedClaim = Use<Commented>
public typealias DisabledClaim = Use<Disabled>

func need<T: Admitted>(_: T.Type) {}
func demandCommented() { need(CommentedClaim.self) }
func demandDisabled() { need(DisabledClaim.self) }
