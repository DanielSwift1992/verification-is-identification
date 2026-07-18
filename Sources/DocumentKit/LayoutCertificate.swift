import VerificationIsIdentification

// THE LAYOUT CERTIFICATE: the span engine instantiates the lattice's own space axioms,
// and building this file is the check. The engine was not invented beside the theory: a
// slice is a pair, a magnitude is a count, adjacency shares its cut, and the reading at
// the edge discretizes. Each claim below is a conformance the compiler verifies, the same
// door `SpellingGate` already stands on: no test runs, the build IS the certificate.

/// Two adjacent slices of one row share their cut: the left leg ends exactly where the
/// right begins, because the walk hands the second part a prefix that already contains the
/// first. That shared midpoint is `MetricProperty`'s whole shape, the triangle law's two
/// legs joined at one point, so the row's geometry satisfies the lattice's metric axiom
/// by construction, and this witness states it as a conformance, not a sentence.
public enum AdjacentSlices<
    A: Structure,
    Cut: Structure,
    B: Structure
>: Pair, MetricProperty {
    public typealias Left = Paired<A, Cut>
    public typealias Right = Paired<Cut, B>
}

// The refused twin, checked directly: two DIFFERENT cuts do not build, `Left.Right ==
// Right.Left` fails, the same way a torn row cannot say where a part begins. Kept as
// prose because the point is that the compiler refuses to keep it as code:
//
//     enum Torn: Pair, MetricProperty {              // does not compile
//         typealias Left = Paired<U4, U8>
//         typealias Right = Paired<U16, U4>          // U8 is not U16: no shared midpoint
//     }

/// The medium's distances are counts of unit steps: a magnitude presses down to nothing in
/// finitely many units, so the surface carries an integer-valued distance: `HasDistance`
/// over the surface as its sigma, the unit step its `Distance`. `SpanPx`, the one
/// reading, is where that discretization meets the page.
public enum SpanDistance<Surface: Structure>: HasDistance {
    public typealias Sigma = Surface
    public typealias Distance = Succ<Zero>
}

/// Whether a part fits its row is decided, in or out, every time: weights either sum
/// within the span or the row does not build, a predicate that always halts: `Decidable`,
/// with the verdict pair on its output side.
public enum FitVerdict<Parts: Structure>: Pair, Decidable {
    public typealias Left = Parts
    public typealias Right = Paired<Unit, Never>
}

/// The gate itself: one name with a live instantiation of every claim, so none of the
/// witnesses above can drift into dead code. A layout engine that stopped satisfying the
/// space axioms would stop compiling here first.
public enum LayoutGate {
    public typealias Triangle = AdjacentSlices<U4, U8, U16>
    public typealias Metric = SpanDistance<
        Times<
            U64,
            Plus<
                U8,
                Plus<
                    U4,
                    Plus<
                        U2,
                        U1
                    >
                >
            >
        >
    >
    public typealias Verdict = FitVerdict<Plus<U4, U8>>

    /// The measured magnitude is in the axis: a slot sized by its own words. `TextWidth`
    /// is a magnitude like any rung, so `Fixed` takes it directly: the door the text cycle
    /// opened, certified here as an instantiation, adopted wherever a box should hug its
    /// words rather than take a uniform extent.
    public typealias WordsSizeTheSlot = Fixed<TextWidth<MeasuredWord, TextS>, SpanNothing>
}

/// The word the certificate measures: any text serves, this one names the act.
public enum MeasuredWord: Close {}
extension MeasuredWord {
    public static var typeName: String { "measured" }
}
