import VerificationIsIdentification

/// Only the four W=(0 2 3) equations. The target Right contact is free.
public protocol CycleContactImage: Pair
where Left: Pair, Right: Pair,
      Left.Left: Pair, Left.Right: Pair, Right.Left: Pair, Right.Right: Pair,
      Left.Left.Left == Right.Left, Right.Left.Left == Right.Right,
      Right.Right.Left == Left.Left, Left.Right.Left == Left.Right {}

/// Add only Z at source positions 0 and 2: six equations altogether.
/// No condition is imposed at source positions 1 or 3 for this contact.
public protocol SeparatingContactImage: CycleContactImage
where Left.Left.Right == Left.Right, Right.Left.Right == Right.Right {}

/// Every other possible merger destroys the active contrast h(0) != h(2).
/// Merger 02 is that contrast itself and needs no additional propagation.
public enum ActiveContrastMerge01<T: CycleContactImage>: Null
where T.Left.Left == T.Left.Right {
    public typealias Left = T.Left.Left
    public typealias Right = T.Right.Left
}
public enum ActiveContrastMerge03<T: CycleContactImage>: Null
where T.Left.Left == T.Right.Right {
    public typealias Left = T.Left.Left
    public typealias Right = T.Right.Left
}
public enum ActiveContrastMerge12<T: CycleContactImage>: Null
where T.Left.Right == T.Right.Left {
    public typealias Left = T.Left.Left
    public typealias Right = T.Right.Left
}
public enum ActiveContrastMerge13<T: CycleContactImage>: Null
where T.Left.Right == T.Right.Right {
    public typealias Left = T.Left.Left
    public typealias Right = T.Right.Left
}
public enum ActiveContrastMerge23<T: CycleContactImage>: Null
where T.Right.Left == T.Right.Right {
    public typealias Left = T.Left.Left
    public typealias Right = T.Right.Left
}

/// The two extra equations transfer a cycle collapse to the fixed contrast
/// h(0) != h(1). Each constructor derives that equality from one merger.
public enum FixedContrastMerge02<T: SeparatingContactImage>: Null
where T.Left.Left == T.Right.Left {
    public typealias Left = T.Left.Left
    public typealias Right = T.Left.Right
}
public enum FixedContrastMerge03<T: SeparatingContactImage>: Null
where T.Left.Left == T.Right.Right {
    public typealias Left = T.Left.Left
    public typealias Right = T.Left.Right
}
public enum FixedContrastMerge12<T: SeparatingContactImage>: Null
where T.Left.Right == T.Right.Left {
    public typealias Left = T.Left.Left
    public typealias Right = T.Left.Right
}
public enum FixedContrastMerge13<T: SeparatingContactImage>: Null
where T.Left.Right == T.Right.Right {
    public typealias Left = T.Left.Left
    public typealias Right = T.Left.Right
}
public enum FixedContrastMerge23<T: SeparatingContactImage>: Null
where T.Right.Left == T.Right.Right {
    public typealias Left = T.Left.Left
    public typealias Right = T.Left.Right
}

/// Six sufficient equations do not imply the two untested Z equations.
/// The four nodes are distinct, while their Right map merges A/B and C/D.
public enum SparseFaithfulContactImage: SeparatingContactImage {
    public enum A: Pair {
        public typealias Left = C
        public typealias Right = B
    }
    public enum B: Pair {
        public typealias Left = B
        public typealias Right = B
    }
    public enum C: Pair {
        public typealias Left = D
        public typealias Right = D
    }
    public enum D: Pair {
        public typealias Left = A
        public typealias Right = D
    }
    public typealias Left = Paired<A, B>
    public typealias Right = Paired<C, D>
}

/// Four W equations and Z at 0/1 all hold, but only two images remain.
/// The location of the two extra comparisons is essential.
public enum MisplacedSixContactImage: CycleContactImage {
    public enum A: Pair {
        public typealias Left = A
        public typealias Right = B
    }
    public enum B: Pair {
        public typealias Left = B
        public typealias Right = A
    }
    public typealias Left = Paired<A, B>
    public typealias Right = Paired<A, A>
    public enum TestedZ01: Null {
        public typealias Left = Paired<A.Right, B.Right>
        public typealias Right = Paired<B, A>
    }
}

/// The three active W edges and an active contrast do not prevent the
/// untested fixed source position from sharing image A with position 0.
public enum ThreeActiveEdgesMayLoseFixed: Pair {
    public enum A: Pair {
        public typealias Left = C
        public typealias Right = A
    }
    public enum C: Pair {
        public typealias Left = D
        public typealias Right = C
    }
    public enum D: Pair {
        public typealias Left = A
        public typealias Right = D
    }
    public typealias Left = Paired<A, A>
    public typealias Right = Paired<C, D>
    public enum ActiveEdges: Null {
        public typealias Left = AddressTriple<A.Left, C.Left, D.Left>
        public typealias Right = AddressTriple<C, D, A>
    }
}

/// Observable W returns already follow without any source contrast. The
/// lossy two-image graph satisfies this too; return is not source recovery.
public enum CycleImageReturns<T: CycleContactImage>: Null {
    public typealias A = T.Left.Left
    public typealias B = T.Left.Right
    public typealias C = T.Right.Left
    public typealias D = T.Right.Right
    public typealias Left = BoundaryWorking<A.Left.Left.Left, B.Left.Left.Left,
        C.Left.Left.Left, D.Left.Left.Left>
    public typealias Right = BoundaryWorking<A, B, C, D>
}

public enum ContactSquareEquality: Close {}

/// An admitted comparison branch: the common target contact is the actual
/// First projection, returning Never, while the expected image is Succ<N>.
/// Constructor separation supplies the false bit; a name does not prove it.
public enum ZeroContactMismatch<P: PredicateReading, Q: PredicateReading,
    M: IntegerValued, N: IntegerValued>: PredicateReading
where P.Left == Q.Left, P.Answer == Succ<M>, Q.Answer == Succ<N>,
      P.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding {
    public typealias Contact = FirstEvidenceImage<P.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Applied = SequentialReading<P, Contact>
    public typealias Expected = Q
    public typealias Boundary = ZeroSuccessorDistinction<N>
    public enum ActualBoundary: Null {
        public typealias Left = Paired<Applied.Answer, Q.Answer>
        public typealias Right = Paired<Boundary.Left, Boundary.Right>
    }
    public typealias Left = P.Left
    public typealias Right = Never
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactSquareEquality
    public typealias Answer = Right
}

/// Read a retained packet of four h images. Both target contacts use the
/// same First projection on those images. All eight comparison outcomes
/// are recorded, while the packet itself remains in the complete record.
public enum ZeroTargetContactReadings<A: IntegerValued, B: IntegerValued,
    C: IntegerValued, D: IntegerValued>: Close {
    public typealias Root = BoundaryWorking<Succ<A>, Succ<B>, Succ<C>, Succ<D>>
    public typealias FirstPair = FirstEvidenceImage<Root, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias LastPair = SecondEvidenceImage<Root, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias H0 = SequentialReading<FirstPair,
        FirstEvidenceImage<FirstPair.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias H1 = SequentialReading<FirstPair,
        SecondEvidenceImage<FirstPair.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias H2 = SequentialReading<LastPair,
        FirstEvidenceImage<LastPair.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias H3 = SequentialReading<LastPair,
        SecondEvidenceImage<LastPair.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias W0 = ZeroContactMismatch<H0, H2, A, C>
    public typealias W1 = ZeroContactMismatch<H1, H1, B, B>
    public typealias W2 = ZeroContactMismatch<H2, H3, C, D>
    public typealias W3 = ZeroContactMismatch<H3, H0, D, A>
    public typealias Z0 = ZeroContactMismatch<H0, H1, A, B>
    public typealias Z1 = ZeroContactMismatch<H1, H0, B, A>
    public typealias Z2 = ZeroContactMismatch<H2, H3, C, D>
    public typealias Z3 = ZeroContactMismatch<H3, H2, D, C>
    public typealias SourceWords = PhaseWordCatalogue<Succ<A>, Succ<B>, Succ<C>, Succ<D>>
    public enum WordTargets: Null {
        public typealias Left = Paired<
            BoundaryWorking<W0.Expected.Answer, W1.Expected.Answer, W2.Expected.Answer, W3.Expected.Answer>,
            BoundaryWorking<Z0.Expected.Answer, Z1.Expected.Answer, Z2.Expected.Answer, Z3.Expected.Answer>>
        public typealias Right = Paired<SourceWords.WW.Right, SourceWords.Z.Right>
    }
    public typealias W = JointEvidence<JointEvidence<W0, W1>, JointEvidence<W2, W3>>
    public typealias Z = JointEvidence<JointEvidence<Z0, Z1>, JointEvidence<Z2, Z3>>
    public typealias Reading = JointEvidence<W, Z>
    public typealias Record = RecordReading<Reading>
}

public enum NegativeSquaresDoNotIdentifyPassage: Close {
    public typealias Faithful = ZeroTargetContactReadings<Never, Lit1, Lit2, Succ<Lit2>>
    public typealias FixedLoss = ZeroTargetContactReadings<Never, Lit1, Never, Never>
    public typealias ActiveLoss = ZeroTargetContactReadings<Never, Never, Lit2, Never>
    public enum SameFullFact: Null {
        public typealias Left = Paired<FixedLoss.Record.Right.Right, ActiveLoss.Record.Right.Right>
        public typealias Right = Paired<Faithful.Record.Right.Right, Faithful.Record.Right.Right>
    }
    public enum SameGivenContrastEndpoints: Null {
        public typealias Left = Paired<FixedLoss.Root.Left,
            Paired<ActiveLoss.Root.Left.Left, ActiveLoss.Root.Right.Left>>
        public typealias Right = Paired<Faithful.Root.Left,
            Paired<Faithful.Root.Left.Left, Faithful.Root.Right.Left>>
    }
}
