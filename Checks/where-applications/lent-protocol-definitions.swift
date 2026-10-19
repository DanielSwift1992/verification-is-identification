// The definitions beside lent-protocol.swift: a protocol gated by an
// equality of its two members.

public protocol Twofold {
    associatedtype Left
    associatedtype Right
}
public protocol Balanced: Twofold
where Left == Right {}
