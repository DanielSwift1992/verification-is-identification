// A gated protocol in a definitions file binds the world's conformers
// unjudged. The world's witness conforms to a protocol the definitions file
// gates with an equality its two members break; Swift refuses the
// conformance, and the court names the protocol the witness reaches.

public protocol Setting {}
public protocol Required: Setting {}
public enum Bad: Setting {}
public enum Good: Required {}
public protocol Admitted {}
public enum Use<T: Setting> {}
extension Use: Admitted
where T: Required {}
func need<T: Admitted>(_: T.Type) {}
public typealias GoodClaim = Use<Good>
public enum Witness: Balanced {
    public typealias Left = Good
    public typealias Right = Bad
}
