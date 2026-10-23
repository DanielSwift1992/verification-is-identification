import VerificationIsIdentification
import DocumentKit

// ── TwoRowGrid: several `SideBySide` rows read as ONE grid only when they agree on how wide
// they are, total: `2 3 5` and `3 1 6` are in the same grid because both add to 10, whatever
// they each split it into. There is no type-level ADDITION here to check that a row's
// weights truly sum to what it claims (`IntegerValued`'s `Right` is an ASSOCIATED type, and
// Swift resolves an associated type once per concrete type, never per `where` clause: the
// same wall §S12 already names for a static witness, harder still for a type derived by
// recursion). Each row declares its Total; TwoRowGrid requires their identity
// as a `where` clause on its own `body`. A row whose declared total does not match its
// partner's does not get a `body` at all, so the grid fails to compile, not fails to align.

public protocol HasTotal {
    associatedtype Total: IntegerValued
}
public protocol TwoRowGrid: Open {
    associatedtype Row1: HasTotal & Structure
    associatedtype Row2: HasTotal & Structure
}
extension TwoRowGrid
where Row1.Total == Row2.Total {
    @StructureBuilder
    public static var body: some Structure {
        Row1.self
        Break.self
        Row2.self
    }
}
