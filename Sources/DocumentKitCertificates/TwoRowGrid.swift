import VerificationIsIdentification
import DocumentKit


/// Declares the total type supplied by a row.
public protocol HasTotal {
    associatedtype Total: IntegerValued
}
/// Composes two rows when their declared Total types are equal.
/// The equality checks the declared types. Arithmetic of the row weights is a separate reading.
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
