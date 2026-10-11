import VerificationIsIdentification

/// Exchange the second and fourth fields of two legs. This involution
/// preserves every field, including both occurrences of a shared part.
/// G2d uses the legs' disjoint difference partitions, not their vertices.
public enum RegroupDistanceLegs<P: Pair>: Pair
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = Paired<Paired<P.Left.Left, P.Left.Right>, Paired<P.Right.Left, P.Right.Right>>
    public typealias Right = Paired<Paired<P.Left.Left, P.Right.Right>, Paired<P.Right.Left, P.Left.Right>>
}

/// Applying the same rearrangement twice recovers the actual leg fields.
/// The conclusion is not an equality supplied as a generic premise.
public enum DistanceLegsRestored<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = RegroupDistanceLegs<RegroupDistanceLegs<P>.Right>.Right
    public typealias Right = RegroupDistanceLegs<P>.Left
}

/// For the partition legs ((X,Y),(Y,Z)), the direct part (X,Z) is a
/// projection of the regrouped whole; the residual (Y,Y) remains addressed.
/// Interpreting X,Y,Z as the disjoint finite sets in G2d gives the bound.
/// An arbitrary MetricProperty diagram does not supply that interpretation.
public enum CancelDistanceDetour<P: MetricProperty>: Monotone
where P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = RegroupDistanceLegs<P>.Right
    public typealias Right = Left.Left
}

/// The two residual occurrences have the same type, derived from the shared
/// part of the two legs. Equal types here do not remove either occurrence.
public enum DistanceDetourHasTwoCopies<P: MetricProperty>: Null
where P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = CancelDistanceDetour<P>.Left.Right.Left
    public typealias Right = CancelDistanceDetour<P>.Left.Right.Right
}

/// Three addressed fields. A mask reads them as (root, left, right).
/// A source or a partition reads them as (first, middle, last).
public typealias AddressTriple<A: Structure, B: Structure, C: Structure> = Paired<A, Paired<B, C>>

/// Shape of a source triple beside its three address masks. Conformance
/// alone certifies this layout. The finite constructor grammar below
/// supplies the partition law, by structural induction over its children.
public protocol TreePartitionShape: Pair
where Left: Pair, Left.Right: Pair, Right: Pair, Right.Right: Pair,
      Left.Left: Structure, Left.Right.Left: Structure, Left.Right.Right: Structure,
      Right.Left: Structure, Right.Right.Left: Structure, Right.Right.Right: Structure {}

/// Prefix each child mask by its actual branch and add the root slot.
/// Never denotes an empty mask. In a constructed mask the root slot is
/// Never or Lit1. Empty padded masks need not be nominally Never.
public typealias PartitionBelowRoot<
    X: Structure, Y: Structure, Z: Structure,
    L: TreePartitionShape, R: TreePartitionShape
> = AddressTriple<
    AddressTriple<X, L.Right.Left, R.Right.Left>,
    AddressTriple<Y, L.Right.Right.Left, R.Right.Right.Left>,
    AddressTriple<Z, L.Right.Right.Right, R.Right.Right.Right>
>

/// The sole terminal in the stated grammar: all three source trees are NULL.
public enum EmptyTreePartition: TreePartitionShape {
    public typealias Left = AddressTriple<Never, Never, Never>
    public typealias Right = AddressTriple<Never, Never, Never>
}

// The seven nonempty root patterns. Each absent root requires both of
// its actual child sources to be Never. Present roots construct Paired
// from those children. No source tree or root classification is an output
// parameter. The digits name root presence, not a precomputed distance.

public enum TreePartition001<L: TreePartitionShape, R: TreePartitionShape>: TreePartitionShape
where L.Left.Left == Never, R.Left.Left == Never,
      L.Left.Right.Left == Never, R.Left.Right.Left == Never {
    public typealias Left = AddressTriple<Never, Never, Paired<L.Left.Right.Right, R.Left.Right.Right>>
    public typealias Right = PartitionBelowRoot<Never, Never, Lit1, L, R>
}

public enum TreePartition010<L: TreePartitionShape, R: TreePartitionShape>: TreePartitionShape
where L.Left.Left == Never, R.Left.Left == Never,
      L.Left.Right.Right == Never, R.Left.Right.Right == Never {
    public typealias Left = AddressTriple<Never, Paired<L.Left.Right.Left, R.Left.Right.Left>, Never>
    public typealias Right = PartitionBelowRoot<Never, Lit1, Never, L, R>
}

public enum TreePartition011<L: TreePartitionShape, R: TreePartitionShape>: TreePartitionShape
where L.Left.Left == Never, R.Left.Left == Never {
    public typealias Left = AddressTriple<Never, Paired<L.Left.Right.Left, R.Left.Right.Left>, Paired<L.Left.Right.Right, R.Left.Right.Right>>
    public typealias Right = PartitionBelowRoot<Lit1, Never, Never, L, R>
}

public enum TreePartition100<L: TreePartitionShape, R: TreePartitionShape>: TreePartitionShape
where L.Left.Right.Left == Never, R.Left.Right.Left == Never,
      L.Left.Right.Right == Never, R.Left.Right.Right == Never {
    public typealias Left = AddressTriple<Paired<L.Left.Left, R.Left.Left>, Never, Never>
    public typealias Right = PartitionBelowRoot<Lit1, Never, Never, L, R>
}

public enum TreePartition101<L: TreePartitionShape, R: TreePartitionShape>: TreePartitionShape
where L.Left.Right.Left == Never, R.Left.Right.Left == Never {
    public typealias Left = AddressTriple<Paired<L.Left.Left, R.Left.Left>, Never, Paired<L.Left.Right.Right, R.Left.Right.Right>>
    public typealias Right = PartitionBelowRoot<Never, Lit1, Never, L, R>
}

public enum TreePartition110<L: TreePartitionShape, R: TreePartitionShape>: TreePartitionShape
where L.Left.Right.Right == Never, R.Left.Right.Right == Never {
    public typealias Left = AddressTriple<Paired<L.Left.Left, R.Left.Left>, Paired<L.Left.Right.Left, R.Left.Right.Left>, Never>
    public typealias Right = PartitionBelowRoot<Never, Never, Lit1, L, R>
}

public enum TreePartition111<L: TreePartitionShape, R: TreePartitionShape>: TreePartitionShape {
    public typealias Left = AddressTriple<Paired<L.Left.Left, R.Left.Left>, Paired<L.Left.Right.Left, R.Left.Right.Left>, Paired<L.Left.Right.Right, R.Left.Right.Right>>
    public typealias Right = PartitionBelowRoot<Never, Never, Never, L, R>
}

/// Bind the existing cancellation kernel to this diagram's actual masks.
/// For finite expressions in EmptyTreePartition / TreePartition001...111,
/// the induction in G2e identifies those masks with the source differences.
public typealias PartitionedTreeDistance<P: TreePartitionShape> = CancelDistanceDetour<
    Path<P.Right.Left, P.Right.Right.Left, P.Right.Right.Right>
>

/// Every reachable root slot is empty. The two child masks carry the same
/// relation. This accepts padded zero masks without equating them to Never.
/// It does not require a finite unfolding or supply a cardinality reader.
public protocol EmptyAddressMask: Pair
where Left == Never, Right: Pair,
      Right.Left: EmptyAddressMask, Right.Right: EmptyAddressMask {}

extension Never: EmptyAddressMask {}

extension Paired: EmptyAddressMask
where L == Never, R: Pair,
      R.Left: EmptyAddressMask, R.Right: EmptyAddressMask {}

/// The direct masks are empty and the actual endpoint types agree. The
/// conformances below derive all three constraints from child relations.
/// They never request the parent's endpoint equality as a premise. [G2f]
public protocol ZeroTreeDifference: TreePartitionShape
where Right.Left: EmptyAddressMask, Right.Right.Right: EmptyAddressMask,
      Left.Left == Left.Right.Right {}

extension EmptyTreePartition: ZeroTreeDifference {}

extension TreePartition010: ZeroTreeDifference
where L: ZeroTreeDifference, R: ZeroTreeDifference {}

extension TreePartition101: ZeroTreeDifference
where L: ZeroTreeDifference, R: ZeroTreeDifference {}

extension TreePartition111: ZeroTreeDifference
where L: ZeroTreeDifference, R: ZeroTreeDifference {}

/// The middle source lies on a shortest path between the endpoints in the
/// finite tree grammar. The conditional constructors derive empty Y from
/// their children and root pattern. They do not assume a scalar bound. [G2h]
public protocol GeodesicTreePartition: TreePartitionShape
where Right.Right.Left: EmptyAddressMask {}

extension EmptyTreePartition: GeodesicTreePartition {}

extension TreePartition001: GeodesicTreePartition
where L: GeodesicTreePartition, R: GeodesicTreePartition {}

extension TreePartition011: GeodesicTreePartition
where L: GeodesicTreePartition, R: GeodesicTreePartition {}

extension TreePartition100: GeodesicTreePartition
where L: GeodesicTreePartition, R: GeodesicTreePartition {}

extension TreePartition110: GeodesicTreePartition
where L: GeodesicTreePartition, R: GeodesicTreePartition {}

extension TreePartition111: GeodesicTreePartition
where L: GeodesicTreePartition, R: GeodesicTreePartition {}

/// Before: remaining differences Z beside removed differences X. After: Z.
/// The actual occupied-address reading in X proves strictness. Y is empty
/// by the partition relation, so this is progress toward its fixed target.
/// The source triple and witness remain named. No distance count is needed.
/// G2h uses the finite partition and concrete projection-reading grammars.
public enum StrictTreeProgress<
    P: GeodesicTreePartition,
    R: PredicateReading
>: Monotone
where R.Left == P.Right.Left, R.Answer == Lit1 {
    public typealias Partition = P
    public typealias Witness = R
    public typealias Sources = P.Left
    public typealias Left = Paired<P.Right.Right.Right, P.Right.Left>
    public typealias Right = P.Right.Right.Right
}

/// Attach the difference certificate to two actual readings of the same
/// input and context. Their computed answers are the partition's current
/// and proposed trees. Their predicates can differ: these are two candidate
/// operations, not an assertion of agreement between those operations.
/// The projection-reading grammar supplies their application semantics. [G13]
public enum TreeReadingProgress<
    Before: PredicateReading, After: PredicateReading,
    P: GeodesicTreePartition, R: PredicateReading
>: Pair
where Before.Left == After.Left,
      Before.Sigma == After.Sigma, Before.Encoding == After.Encoding,
      Before.Answer == P.Left.Left, After.Answer == P.Left.Right.Left,
      R.Left == P.Right.Left, R.Answer == Lit1 {
    public typealias Left = Paired<Before, After>
    public typealias Right = StrictTreeProgress<P, R>
}

/// Primitive projection questions used in a mask-address reading.
public enum FirstProjection: Close {}
public enum SecondProjection: Close {}

/// Read the occupancy bit at the current mask root through the existing
/// projection constructor. The answer is computed from M, not supplied.
public typealias ReadMaskRoot<M: Pair, S, E> = FirstEvidenceImage<M, S, E, FirstProjection>

/// Follow the actual left mask and then the supplied continuation. The
/// same SequentialReading used elsewhere checks each composition seam.
public typealias ReadMaskLeft<M: Pair, T: PredicateReading> = SequentialReading<
    SequentialReading<
        SecondEvidenceImage<M, T.Sigma, T.Encoding, SecondProjection>,
        FirstEvidenceImage<M.Right, T.Sigma, T.Encoding, FirstProjection>
    >,
    T
>
where M.Right: Pair, T.Left == M.Right.Left

public typealias ReadMaskRight<M: Pair, T: PredicateReading> = SequentialReading<
    SequentialReading<
        SecondEvidenceImage<M, T.Sigma, T.Encoding, SecondProjection>,
        SecondEvidenceImage<M.Right, T.Sigma, T.Encoding, SecondProjection>
    >,
    T
>
where M.Right: Pair, T.Left == M.Right.Right

/// Pair two output changes. The first removes an addressed difference and
/// the second introduces no detour. Lift the first witness through the
/// actual left mask to certify strict progress of the paired outputs. [G13]
public typealias PairedTreeProgress<
    P: GeodesicTreePartition, Q: GeodesicTreePartition, R: PredicateReading
> = StrictTreeProgress<
    TreePartition111<P, Q>, ReadMaskLeft<TreePartition111<P, Q>.Right.Left, R>
>
where R.Left == P.Right.Left, R.Answer == Lit1

/// Retain the actual source triple beside an occupied direct-difference
/// reading. R begins at this partition's (X,Z), not at an unrelated mask.
/// G2g uses the generated partition and projection-reading grammars.
/// An arbitrary PredicateReading declaration is not a certified evaluator.
public enum TreeDifferenceAt<P: TreePartitionShape, R: PredicateReading>: Pair
where R.Left == PartitionedTreeDistance<P>.Right, R.Answer == Lit1 {
    public typealias Left = P.Left
    public typealias Right = R
}

/// Layout of a round application. The finite grammar consists of the NULL
/// identity, root growth/shrinkage and PairedTreeRound below. Its induction
/// proves the compatible-frontier interpretation, not arbitrary conformers.
public protocol TreeRoundShape: PredicateReading
where Left: Structure, Answer: Structure {}

extension IdentityReading: TreeRoundShape
where X == Never {}

public enum GrowAtRoot: Close {}
public enum ShrinkAtRoot: Close {}

/// One frontier edit: create a childless root from the actual NULL input.
public enum GrowTreeRoot<S, E>: TreeRoundShape {
    public typealias Left = Never
    public typealias Right = Paired<Never, Never>
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = GrowAtRoot
    public typealias Answer = Right
}

/// The inverse frontier edit requires an actual childless root.
public enum ShrinkTreeRoot<S, E>: TreeRoundShape {
    public typealias Left = Paired<Never, Never>
    public typealias Right = Never
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = ShrinkAtRoot
    public typealias Answer = Right
}

/// Keep the common parent and apply compatible rounds in its disjoint
/// children. A parent edit cannot be hidden inside this same round.
/// The application uses actual projections and JointEvidence. [G14b]
public enum PairedTreeRound<L: TreeRoundShape, R: TreeRoundShape>: TreeRoundShape
where L.Sigma == R.Sigma, L.Encoding == R.Encoding {
    public typealias Application = PairedApplication<L, R>
    public typealias Left = Application.Left
    public typealias Right = Application.Answer
    public typealias Sigma = Application.Sigma
    public typealias Encoding = Application.Encoding
    public typealias Predicate = Application.Predicate
    public typealias Answer = Right
}
