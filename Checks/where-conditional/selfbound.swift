// A conditional protocol whose where clause stands without an inheritance
// list is a gate this court does not read, and the court names it instead of
// judging its conformers without the condition. One conformer breaks the
// condition and one keeps it. The compiler refuses the first; the court
// gives no verdict and names the protocol it cannot read.

public protocol Bound {}
public enum Tight: Bound {}
public enum Loose: Bound {}

public protocol Banded {
    associatedtype Band: Bound
}
public protocol StrictlyBanded
where Self: Banded, Self.Band == Tight {}

public enum Later: Banded, StrictlyBanded {
    public typealias Band = Loose
}
public enum Settled: Banded, StrictlyBanded {
    public typealias Band = Tight
}
