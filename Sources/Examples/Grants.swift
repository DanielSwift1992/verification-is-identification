import VerificationIsIdentification

// ═══ THE GRANT WORLD — access over declared realms, the domain genre as one page.
//
// Nothing in the genre is fixed to any roster. A realm is a declared atom, and
// the fourth realm is one line, not a schema change. A verb set is a protocol
// class, and containment is conformance: a writer reads because ``Writes``
// refines ``Reads``, so "which verbs does this key carry" is answered by the
// class ladder, never by a list. A subject and a room each state their realm as
// an axis, and one gate carries both tiers at once: the compiler holds the
// key's class (a conformance pin), and the second judge holds the posting
// equality (swift run Tools judge where), reading the world's own declarations
// and knowing no name in advance. The Organization showcase adds a second,
// hand-written record of its policy for the differential seat, and that record
// is the seat's price, not the genre's: this world lives whole in one text.
// ═══════════════════════════════════════════════════════════════

// ── the verb ladder: a set of verbs is a class, containment is conformance ──

/// The right to read. The floor of the ladder.
public protocol Reads {}
/// The right to write. A writer reads: the class refines ``Reads``.
public protocol Writes: Reads {}
/// The right to administer. An administrator writes, and so reads.
public protocol Administers: Writes {}

/// The three keys, one per class. A key's verbs are its conformances.
public enum ReaderKey: Reads {}
public enum WriterKey: Writes {}
public enum WardenKey: Administers {}

// ── the realms: declared atoms, any number ──

public protocol Realm {}
public enum Archive: Realm {}
public enum Foundry: Realm {}
public enum Harbor: Realm {}

// ── the subjects and the rooms: each states its realm as an axis ──

public protocol Keeper {
    associatedtype Post: Realm
    associatedtype Key
}
public protocol Room {
    associatedtype Place: Realm
}

public enum Ledger: Room {
    public typealias Place = Archive
}
public enum Anvil: Room {
    public typealias Place = Foundry
}

public enum Clerk: Keeper {
    public typealias Post = Archive
    public typealias Key = ReaderKey
}
public enum Smith: Keeper {
    public typealias Post = Foundry
    public typealias Key = WriterKey
}
public enum Warden: Keeper {
    public typealias Post = Harbor
    public typealias Key = WardenKey
}

// ── the gate: two tiers in one where ──

/// Entry to work a room: the keeper's key must write, and the keeper must be
/// posted where the room is. The compiler decides the key's class, and the
/// judge decides the posting equality from the declarations above.
public protocol Entered {}
public enum Enter<
    Who: Keeper,
    Into: Room
> {}
extension Enter: Entered
where Who.Key: Writes, Who.Post == Into.Place {}

// The certificates: each names one entry, and the judge folds both sides of
// the posting equality from the world's own tables.
public typealias SmithAtTheAnvil = Enter<Smith, Anvil>
public typealias ClerkAtTheLedger = Enter<Clerk, Ledger>

/// The compiled witness: the smith writes and is posted at the foundry, so the
/// conformance is granted by the compiler itself.
public let smithMayWork: Entered.Type = Enter<Smith, Anvil>.self

#if SHOW_REJECT
/// The refusal, twice over: the clerk's key only reads, and the clerk is
/// posted at the archive, not the foundry. The compiler names both.
public let clerkMayNotForge: Entered.Type = Enter<Clerk, Anvil>.self
#endif
