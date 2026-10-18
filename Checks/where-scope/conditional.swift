// A block under `#if true` is compiled, so a declaration in it can rebind a
// file-scope name where a use sits. This court omits only a block under a
// plain flag, which a compilation without the flag skips; any other block
// is refused at its line. The compiler, reading the block, refuses the
// demand; the court names the condition instead of omitting the block.

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
func demand() {
#if true
    struct Good {}
#endif
    need(Use<Good>.self)
}
