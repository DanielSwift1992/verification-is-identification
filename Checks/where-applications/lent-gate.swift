// A gate in a definitions file binds the world unjudged. The definitions
// file declares the gated head and its gate, and the world demands the bad
// application beside a gate of its own; Swift refuses the demand, and the
// court names the definitions file's gate.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Pair<T: Setting> {}
extension Pair: Admitted
where T: Required {}
func need<T: Admitted>(_: T.Type) {}
public typealias GoodClaim = Pair<Good>
func demand() { need(Use<Bad>.self) }
