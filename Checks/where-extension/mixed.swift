// A conformance whose extension body the court cannot read is still the
// conformer's. One refinement is stated in an extension with a method in its
// body and fails for its loose bound; its neighbour, stated in an empty
// extension, holds. The compiler refuses the first, and the court refuses it
// too, rather than counting the neighbour and passing the file.

public protocol Bound {}
public enum Tight: Bound {}
public enum Loose: Bound {}

public protocol Banded {
    associatedtype Band: Bound
}
public protocol StrictlyBanded: Banded
where Band == Tight {}

public enum Later: Banded {
    public typealias Band = Loose
}
extension Later: StrictlyBanded {
    func ignored() {}
}

public enum Settled: Banded {
    public typealias Band = Tight
}
extension Settled: StrictlyBanded {}
