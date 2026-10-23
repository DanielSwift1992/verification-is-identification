import DocumentKit
import VerificationIsIdentification


/// Constructs two legs sharing the supplied Cut. MetricProperty checks exactly
/// Left.Right == Right.Left. This establishes the encoded seam, not a triangle
/// inequality or a proof that a rendering walk supplies these endpoints.
public enum AdjacentSlices<
    A: Structure,
    Cut: Structure,
    B: Structure
>: Pair, MetricProperty {
    public typealias Left = Paired<A, Cut>
    public typealias Right = Paired<Cut, B>
}


/// Supplies Surface and a unit-step numeral as coordinates of HasDistance.
/// No distance function on Surface is constructed here. SpanPx separately reads
/// fraction counts and rounds them when generating the rendered coordinates.
public enum SpanDistance<Surface: Structure>: HasDistance {
    public typealias Sigma = Surface
    public typealias Distance = Succ<Zero>
}

/// Retains Parts and a paired output shape. Decidable requires that pair shape,
/// not a fit decision. This declaration has no row capacity to compare with Parts.
/// Rest.count checks underflow when read, and HFlow checks its stretch count when
/// rendering. Those generation-time checks are not established by this conformance.
public enum FitVerdict<Parts: Structure>: Pair, Decidable {
    public typealias Left = Parts
    public typealias Right = Paired<Unit, Never>
}

/// Concrete instantiations of the checked shapes. Changes to a renderer that
/// preserve these types need their own verification against the layout contract.
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

    /// Checks that the measured-width type can supply a fixed slot. Its numeric
    /// text measurement and the renderer's use of that value are separate readings.
    public typealias WordsSizeTheSlot<Binding: DrawingStyle, Size: Structure> = Fixed<BoundTextWidth<Binding, MeasuredWord, Size>, SpanNothing>
}

/// The word the certificate measures: any text serves, this one names the act.
public enum MeasuredWord: Close {}
extension MeasuredWord {
    public static var typeName: String { "measured" }
}
