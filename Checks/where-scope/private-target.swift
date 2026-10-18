// A definitions file may extend a type of its own that shares a name with a
// type of this world. Beside this world, private-target-definitions.swift
// declares a private struct Left and gives it Required; the world's Left
// stays without it, and the compiler, given both files, refuses the demand.
// The court cannot tell the two Lefts apart, so it names the extension and
// gives no verdict instead of lending Required to the world's Left.

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
public enum Left: Setting {}
public protocol Holder {}
public enum Owner: Holder {
    public typealias Claim = Use<Left>
}
func demand() { need(Owner.Claim.self) }
