import VerificationIsIdentification

/// Boundary roles (a,b,c,d) are actual inputs and their shared Left images.
public enum FunctionalBoundaryReading<A: Pair, B: Pair>: PredicateReading
where A.Left: Structure, B.Left: Structure {
    public typealias Left = Paired<A, B>
    public typealias ARead = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias BRead = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias CRead = SequentialReading<ARead,
        FirstEvidenceImage<A, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias DRead = SequentialReading<BRead,
        FirstEvidenceImage<B, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = JointEvidence<JointEvidence<ARead, BRead>, JointEvidence<CRead, DRead>>
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// A later input identity activates the conditional output identity.
/// The consumer does not ask for output equality as another premise.
public enum AliasActivatesBoundary<T: Null>: Null
where T.Left: Pair, T.Left.Left: Structure {
    public typealias Reading = FunctionalBoundaryReading<T.Left, T.Right>
    public typealias Left = Reading.Answer.Right.Left
    public typealias Right = Reading.Answer.Right.Right
}

/// With no functional row coupling c,d to a,b, their values remain free.
public enum UncoupledBoundary<A: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = Paired<A, Paired<C, D>>
    public typealias Right = BoundaryWorking<A, A, C, D>
}

/// The private intermediate is obtained through the actual shared contact.
public enum SharedHiddenPath<T: Pair>: PredicateReading
where T.Left: Pair, T.Left.Right: Structure {
    public typealias First = FirstEvidenceImage<T, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Second = SecondEvidenceImage<T.Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Actual = SequentialReading<First, Second>
    public typealias Left = T
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Sharing the entry and both contacts also identifies the hidden intermediate
/// and final answers. No separate identity of the intermediates is supplied.
public enum SharedEntryForcesHiddenAgreement<T: Null>: Null
where T.Left: Pair, T.Left.Left: Pair, T.Left.Left.Right: Structure {
    public typealias A = SharedHiddenPath<T.Left>
    public typealias B = SharedHiddenPath<T.Right>
    public typealias Left = Paired<A.First.Answer, A.Answer>
    public typealias Right = Paired<B.First.Answer, B.Answer>
}

public enum SeparatedHiddenPaths: Close {
    public typealias A = Paired<Paired<Never, Never>, Never>
    public typealias B = Paired<Paired<Never, Lit1>, Never>
    public typealias First = SharedHiddenPath<A>
    public typealias Second = SharedHiddenPath<B>
    public enum Answers: Null {
        public typealias Left = Paired<First.Answer, Second.Answer>
        public typealias Right = Paired<Never, Lit1>
    }
}

/// A shared two-node substructure, closed under both target contacts.
/// The two private nodes are constructed beside it; their contacts enter
/// the shared substructure without modifying its laws.
public enum ClosedBoundaryJoin<P: Pair, Q: Pair>: Close
where P.Left == Q, Q.Left == P, P.Right == P, Q.Right == Q {
    public typealias Boundary = Paired<P, Q>
    public typealias PrivateG = Paired<P, P>
    public typealias PrivateH = Paired<Q, Q>
    public typealias Whole = Paired<Boundary, Paired<PrivateG, PrivateH>>
    public typealias BoundaryRead = FirstEvidenceImage<Whole, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Interiors = SecondEvidenceImage<Whole, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias GRead = SequentialReading<Interiors,
        FirstEvidenceImage<Interiors.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias HRead = SequentialReading<Interiors,
        SecondEvidenceImage<Interiors.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias G = JointEvidence<BoundaryRead, GRead>
    public typealias H = JointEvidence<BoundaryRead, HRead>
    public typealias Joint = JointEvidence<G, H>
    public enum CommonBoundary: Null {
        public typealias Left = G.Answer.Left
        public typealias Right = H.Answer.Left
    }
    public enum PreservedRows: Null {
        public typealias Left = Paired<BoundaryWorking<P.Left, Q.Left, P.Right, Q.Right>,
            Paired<Paired<G.Answer.Right.Left, G.Answer.Right.Right>,
                Paired<H.Answer.Right.Left, H.Answer.Right.Right>>>
        public typealias Right = Paired<BoundaryWorking<Q, P, P, Q>,
            Paired<Paired<P, P>, Paired<Q, Q>>>
    }
}

public enum ClosedBoundaryNodes: Close {
    public enum P: Pair, HasVerdict {
        public typealias Left = Q
        public typealias Right = P
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = BoundaryProbeQuestion
        public typealias Answer = Never
    }
    public enum Q: Pair, HasVerdict {
        public typealias Left = P
        public typealias Right = Q
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = BoundaryProbeQuestion
        public typealias Answer = Lit1
    }
    public enum BoundaryProbeQuestion: Close {}
    public typealias Joined = ClosedBoundaryJoin<P, Q>
    public typealias PrivateGReply = SequentialReading<
        FirstEvidenceImage<Joined.PrivateG, BeamSpace, SaturationEncoding, FirstProjection>,
        ReadRecordedAnswer<P>>
    public typealias PrivateHReply = SequentialReading<
        FirstEvidenceImage<Joined.PrivateH, BeamSpace, SaturationEncoding, FirstProjection>,
        ReadRecordedAnswer<Q>>
    public enum DifferentInteriors: Null {
        public typealias Left = Paired<PrivateGReply.Answer, PrivateHReply.Answer>
        public typealias Right = Paired<Never, Lit1>
    }
}

/// The other participant uses the actual Right contact. Its answer identity
/// is obtained from the received input identity, not from a verdict label.
public enum AliasActivatesOtherBoundary<T: Null>: Null
where T.Left: Pair, T.Left.Right: Structure {
    public typealias A = SecondEvidenceImage<T.Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias B = SecondEvidenceImage<T.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Left = A.Answer
    public typealias Right = B.Answer
}

/// Three conditional exchanges: G uses Left, H uses Right, G uses Left.
/// The only supplied identity concerns the original entries. Every later
/// identity is produced by the preceding actual-contact construction.
public enum AlternatingBoundaryClosure<T: Null>: Null
where T.Left: Pair, T.Left.Left: Pair, T.Left.Left.Right: Pair,
      T.Left.Left.Right.Left: Structure {
    public typealias First = AliasActivatesBoundary<T>
    public typealias Second = AliasActivatesOtherBoundary<First>
    public typealias Third = AliasActivatesBoundary<Second>
    public typealias Left = Third.Left
    public typealias Right = Third.Right
}

/// This is the complete path whose endpoint the three exchanges determine.
public enum AlternatingBoundaryPath<T: Pair>: PredicateReading
where T.Left: Pair, T.Left.Right: Pair, T.Left.Right.Left: Structure {
    public typealias First = FirstEvidenceImage<T, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Second = SequentialReading<First,
        SecondEvidenceImage<T.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = SequentialReading<Second,
        FirstEvidenceImage<Second.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Left = T
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// A free unshared entry can retain a different terminal answer. Declaring
/// the entries equal would activate all three conditional exchanges.
public enum OpenAlternatingBoundary: Close {
    public typealias A = Paired<Paired<Never, Paired<Never, Never>>, Never>
    public typealias B = Paired<Paired<Never, Paired<Lit1, Never>>, Never>
    public typealias ARead = AlternatingBoundaryPath<A>
    public typealias BRead = AlternatingBoundaryPath<B>
    public enum TerminalContrast: Null {
        public typealias Left = Paired<ARead.Answer, BRead.Answer>
        public typealias Right = Paired<Never, Lit1>
    }
}

/// Three joint role images in a product of two interpretations. Recovering
/// either component gives its original three-role boundary. This constructs
/// an interpretation; it does not claim acquisition of an unknown source.
public enum ProductBoundary<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure>: Close {
    public typealias First = Paired<A, D>
    public typealias Second = Paired<B, E>
    public typealias Third = Paired<C, F>
    public typealias Whole = AddressTriple<First, Second, Third>
}

extension ProductBoundary {
    public enum ComponentsSurvive: Null {
        public typealias Left = Paired<
            AddressTriple<First.Left, Second.Left, Third.Left>,
            AddressTriple<First.Right, Second.Right, Third.Right>>
        public typealias Right = Paired<AddressTriple<A, B, C>, AddressTriple<D, E, F>>
    }
}

/// One interpretation identifies a with b; the other identifies a with c.
/// Their joint interpretation identifies neither pair, witnessed by actual
/// component projections with positive Never/Succ contrasts.
public enum AlternativeBoundaryProduct: Close {
    public typealias Product = ProductBoundary<Never, Never, Lit1, Never, Lit1, Never>
    public typealias ABFirst = SecondEvidenceImage<Product.First,
        BeamSpace, SaturationEncoding, SecondProjection>
    public typealias ABSecond = SecondEvidenceImage<Product.Second,
        BeamSpace, SaturationEncoding, SecondProjection>
    public typealias ACFirst = FirstEvidenceImage<Product.First,
        BeamSpace, SaturationEncoding, FirstProjection>
    public typealias ACSecond = FirstEvidenceImage<Product.Third,
        BeamSpace, SaturationEncoding, FirstProjection>
}

extension AlternativeBoundaryProduct {
    public enum BothContrasts: Null {
        public typealias Left = Paired<Paired<ABFirst.Answer, ABSecond.Answer>,
            Paired<ACFirst.Answer, ACSecond.Answer>>
        public typealias Right = Paired<Paired<Never, Lit1>, Paired<Never, Lit1>>
    }
}

/// The two unary contacts share an output role x. Each antecedent identity
/// closes one leg; neither endpoint equality is supplied independently.
public enum JoinedConditionalBoundary<A: Null, B: Null>: Null
where A.Left: Pair, B.Left: Pair,
      A.Left.Left: Structure, B.Left.Right: Structure,
      A.Right.Left == B.Left.Right {
    public typealias First = AliasActivatesBoundary<A>
    public typealias Second = AliasActivatesOtherBoundary<B>
    public typealias Left = First.Left
    public typealias Right = Second.Right
}

/// Packing the two antecedents as one tuple identity keeps their joint
/// structure. Projections recover both premises of the same constructor.
public enum PackedConditionalBoundary<T: Null>: Null
where T.Left: Pair, T.Left.Left: Pair, T.Left.Right: Pair,
      T.Left.Left.Left: Structure, T.Left.Right.Right: Structure,
      T.Right.Left.Left == T.Left.Right.Right {
    public typealias First = AliasActivatesBoundary<T>
    public typealias Second = AliasActivatesOtherBoundary<T>
    public typealias Joined = JoinedConditionalBoundary<First, Second>
    public typealias Left = Joined.Left
    public typealias Right = Joined.Right
}

/// The open graph has actual rows f(a)=c,f(b)=x,g(u)=x,g(v)=d.
/// It does not yet require either a=b or u=v.
public enum OpenConditionalChain<A: Pair, B: Pair, U: Pair, V: Pair>: Pair
where A.Left: Structure, B.Left: Structure,
      U.Right: Structure, V.Right: Structure, B.Left == U.Right {
    public typealias Left = Paired<Paired<A, B>, Paired<U, V>>
    public typealias C = FirstEvidenceImage<A, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias XFromFirst = FirstEvidenceImage<B, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias XFromSecond = SecondEvidenceImage<U, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias D = SecondEvidenceImage<V, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Right = Paired<C.Answer, D.Answer>
    public enum SameIntermediate: Null {
        public typealias Left = XFromFirst.Answer
        public typealias Right = XFromSecond.Answer
    }
}

public enum ConditionalChainMissingOne: Close {
    public typealias FirstOnly = OpenConditionalChain<
        Paired<Never, Never>, Paired<Never, Never>,
        Paired<Never, Never>, Paired<Never, Lit1>>
    public typealias SecondOnly = OpenConditionalChain<
        Paired<Never, Never>, Paired<Lit1, Never>,
        Paired<Never, Lit1>, Paired<Never, Lit1>>
    public enum FirstInputIdentity: Null {
        public typealias Left = FirstOnly.Left.Left.Left
        public typealias Right = FirstOnly.Left.Left.Right
    }
    public enum SecondInputIdentity: Null {
        public typealias Left = SecondOnly.Left.Right.Left
        public typealias Right = SecondOnly.Left.Right.Right
    }
    public enum BothTerminalContrasts: Null {
        public typealias Left = Paired<FirstOnly.Right, SecondOnly.Right>
        public typealias Right = Paired<Paired<Never, Lit1>, Paired<Never, Lit1>>
    }
}

/// A nonzero joint witness discharges all premises and uses the packed
/// constructor on the same source rows, rather than merely naming its answer.
public enum ClosedConditionalChain: Close {
    public typealias FirstInput = Paired<Lit1, Never>
    public typealias SecondInput = Paired<Never, Lit1>
    public typealias Graph = OpenConditionalChain<FirstInput, FirstInput,
        SecondInput, SecondInput>
    public enum Inputs: Null {
        public typealias Left = Paired<Graph.Left.Left.Left, Graph.Left.Right.Left>
        public typealias Right = Paired<Graph.Left.Left.Right, Graph.Left.Right.Right>
    }
    public typealias Closed = PackedConditionalBoundary<Inputs>
    public enum SameOuterReadings: Null {
        public typealias Left = Paired<Closed.Left, Closed.Right>
        public typealias Right = Graph.Right
    }
}
