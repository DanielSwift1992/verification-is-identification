import VerificationIsIdentification

public enum ContactProfileQuestion: Close {}
public enum ContactProfileCalibrationQuestion: Close {}
public enum ContactProfileEqualityQuestion: Close {}
public enum ContactProfileChoiceQuestion: Close {}

/// Three actual observations q(x), q(u(x)), q(u²(x)). Here u is Left
/// and q is Right on the complete supplied image. No clock law is assumed.
public enum ContactProfile<T: Pair>: PredicateReading
where T.Left: Pair, T.Left.Left: Pair,
      T.Right: Structure, T.Left.Right: Structure, T.Left.Left.Right: Structure {
    public typealias Q0 = SecondEvidenceImage<T, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias U = FirstEvidenceImage<T, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Q1 = SequentialReading<U,
        SecondEvidenceImage<T.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias U2 = SequentialReading<U,
        FirstEvidenceImage<T.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Q2 = SequentialReading<U2,
        SecondEvidenceImage<T.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<Q0, JointEvidence<Q1, Q2>>
    public typealias Left = T
    public typealias Right = AddressTriple<T.Right, T.Left.Right, T.Left.Left.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactProfileQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ContactProfile.Answer
    }
}

/// An arbitrary unread tail remains inside every complete image.
public typealias ContactProfileChain<A: Structure, B: Structure,
    C: Structure, K: Structure> = Paired<Paired<Paired<K, C>, B>, A>

public enum FourContactProfiles<A: Pair, B: Pair, C: Pair, D: Pair>: PredicateReading
where A.Left: Pair, A.Left.Left: Pair, A.Right: Structure,
      A.Left.Right: Structure, A.Left.Left.Right: Structure,
      B.Left: Pair, B.Left.Left: Pair, B.Right: Structure,
      B.Left.Right: Structure, B.Left.Left.Right: Structure,
      C.Left: Pair, C.Left.Left: Pair, C.Right: Structure,
      C.Left.Right: Structure, C.Left.Left.Right: Structure,
      D.Left: Pair, D.Left.Left: Pair, D.Right: Structure,
      D.Left.Right: Structure, D.Left.Left.Right: Structure {
    public typealias Actual = PairedApplication<
        PairedApplication<ContactProfile<A>, ContactProfile<B>>,
        PairedApplication<ContactProfile<C>, ContactProfile<D>>>
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<ContactProfile<A>.Answer, ContactProfile<B>.Answer,
        ContactProfile<C>.Answer, ContactProfile<D>.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Answer>
        public typealias Right = Paired<FourContactProfiles.Left, FourContactProfiles.Answer>
    }
}

/// The positive clause consumes only an acquired four-profile fact.
/// Its premises are observed rotations, a constant profile, and 0/1
/// contrast. Neither injectivity nor equality of complete image states
/// is asked from the caller. The remaining two observed values are free.
public enum AcceptedContactProfiles<F: HasVerdict & Structure>: PredicateReading
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding,
      F.Answer: Pair, F.Answer.Left: Pair, F.Answer.Right: Pair,
      F.Answer.Left.Left: Pair, F.Answer.Left.Left.Right: Pair,
      F.Answer.Left.Right: Pair, F.Answer.Left.Right.Right: Pair,
      F.Answer.Right.Left: Pair, F.Answer.Right.Left.Right: Pair,
      F.Answer.Right.Right: Pair, F.Answer.Right.Right.Right: Pair,
      F.Answer.Left.Left.Left == Never,
      F.Answer.Left.Left.Right.Left == Lit1,
      F.Answer.Right.Left.Left == F.Answer.Left.Left.Right.Left,
      F.Answer.Right.Left.Right.Left == F.Answer.Left.Left.Right.Right,
      F.Answer.Right.Left.Right.Right == F.Answer.Left.Left.Left,
      F.Answer.Right.Right.Left == F.Answer.Left.Left.Right.Right,
      F.Answer.Right.Right.Right.Left == F.Answer.Left.Left.Left,
      F.Answer.Right.Right.Right.Right == F.Answer.Left.Left.Right.Left,
      F.Answer.Left.Right.Left == F.Answer.Left.Right.Right.Left,
      F.Answer.Left.Right.Left == F.Answer.Left.Right.Right.Right {
    public typealias Values = ReadRecordedAnswer<F>
    public typealias FirstPair = SequentialReading<Values,
        FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias First = SequentialReading<FirstPair,
        FirstEvidenceImage<F.Answer.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = SequentialReading<First,
        SecondEvidenceImage<F.Answer.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = SequentialReading<Tail,
        FirstEvidenceImage<F.Answer.Left.Left.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Left = F
    public typealias Right = F.Answer.Left.Left.Right.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactProfileCalibrationQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = AcceptedContactProfiles.Answer
    }
}

/// The observed family need not implement a three-cycle on complete states.
/// After three Left steps it reaches an arbitrary K, not its first image.
public enum ContactProfileFamily<C: Structure, D: Structure, K: Structure>: Close {
    public typealias A = ContactProfileChain<Never, Lit1, C, K>
    public typealias B = ContactProfileChain<D, D, D, K>
    public typealias CImage = ContactProfileChain<Lit1, C, Never, K>
    public typealias DImage = ContactProfileChain<C, Never, Lit1, K>
    public typealias Images = BoundaryWorking<A, B, CImage, DImage>
    public typealias Read = FourContactProfiles<A, B, CImage, DImage>
    public typealias Record = RecordReading<Read>
    public typealias Accept = AcceptedContactProfiles<Record.Right.Right>
    public enum ObservedPattern: Null {
        public typealias Left = Read.Answer
        public typealias Right = BoundaryWorking<AddressTriple<Never, Lit1, C>,
            AddressTriple<D, D, D>, AddressTriple<Lit1, C, Never>,
            AddressTriple<C, Never, Lit1>>
    }
    public enum PositiveReading: Null {
        public typealias Left = Accept.Answer
        public typealias Right = Lit1
    }
    public enum UnreadTailSurvives: Null {
        public typealias Left = Record.Right.Left.Left.Left.Left.Left.Left
        public typealias Right = K
    }
}

public typealias ContactProfileBitEquality = BoundaryWorking<Lit1, Never, Never, Lit1>
public typealias ContactProfileBoth = BoundaryWorking<Never, Never, Never, Lit1>
public typealias ContactProfileTables = AddressTriple<PhaseEqualityTable,
    ContactProfileBitEquality, ContactProfileBoth>

/// A fixed finite comparison program. The supplied clauses are the existing
/// four Routes, selected by their actual local bit inputs. Images, source
/// coordinates and the unknown encoder are not inputs of this reader.
public enum CompareContactProfiles<F: HasVerdict & Structure,
    R: PredicateReading, S: PredicateReading,
    T: PredicateReading, U: PredicateReading>: PredicateReading
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding,
      F.Answer: Pair, F.Answer.Left: Pair, F.Answer.Right: Pair,
      F.Answer.Left.Right: Pair, F.Answer.Right.Right: Pair,
      F.Answer.Left.Left: Structure, F.Answer.Left.Right.Left: Structure,
      F.Answer.Left.Right.Right: Structure, F.Answer.Right.Left: Structure,
      F.Answer.Right.Right.Left: Structure, F.Answer.Right.Right.Right: Structure,
      R.Left == Paired<Paired<F.Answer.Left.Left, F.Answer.Left.Right.Left>, PhaseEqualityTable>,
      R.Answer: Structure,
      S.Left == Paired<Paired<F.Answer.Right.Left, F.Answer.Right.Right.Left>, R.Answer>,
      S.Answer: Structure,
      T.Left == Paired<Paired<F.Answer.Left.Right.Right, F.Answer.Right.Right.Right>, ContactProfileBitEquality>,
      T.Answer: Structure,
      U.Left == Paired<Paired<S.Answer, T.Answer>, ContactProfileBoth>,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace, T.Sigma == BeamSpace, U.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding,
      T.Encoding == SaturationEncoding, U.Encoding == SaturationEncoding {
    public typealias Left = Paired<F, ContactProfileTables>
    public typealias Fact = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Profiles = SequentialReading<Fact, ReadRecordedAnswer<F>>
    public typealias A = SequentialReading<Profiles,
        FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias B = SequentialReading<Profiles,
        SecondEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias A0 = SequentialReading<A,
        FirstEvidenceImage<A.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias ATail = SequentialReading<A,
        SecondEvidenceImage<A.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias A1 = SequentialReading<ATail,
        FirstEvidenceImage<ATail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias A2 = SequentialReading<ATail,
        SecondEvidenceImage<ATail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias B0 = SequentialReading<B,
        FirstEvidenceImage<B.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias BTail = SequentialReading<B,
        SecondEvidenceImage<B.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias B1 = SequentialReading<BTail,
        FirstEvidenceImage<BTail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias B2 = SequentialReading<BTail,
        SecondEvidenceImage<BTail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Tables = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias FirstTwoTable = SequentialReading<Tables,
        FirstEvidenceImage<ContactProfileTables, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias MoreTables = SequentialReading<Tables,
        SecondEvidenceImage<ContactProfileTables, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias LastTable = SequentialReading<MoreTables,
        FirstEvidenceImage<MoreTables.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias BothTable = SequentialReading<MoreTables,
        SecondEvidenceImage<MoreTables.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Row = SequentialReading<JointEvidence<JointEvidence<A0, A1>, FirstTwoTable>, R>
    public typealias FirstTwo = SequentialReading<JointEvidence<JointEvidence<B0, B1>, Row>, S>
    public typealias Last = SequentialReading<JointEvidence<JointEvidence<A2, B2>, LastTable>, T>
    public typealias Actual = SequentialReading<JointEvidence<JointEvidence<FirstTwo, Last>, BothTable>, U>
    public typealias Right = U.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactProfileEqualityQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = CompareContactProfiles.Answer
    }
}

/// Acquire calibration at the encoder field of the actual prepared source.
public enum ReadResidentContactProfiles<W: Pair, R: PredicateReading>: PredicateReading
where W.Right == R.Left, R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Frame = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Actual = SequentialReading<Frame, R>
    public typealias Left = W
    public typealias Right = R.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = R.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ReadResidentContactProfiles.Answer
    }
}

/// First acquire the calibration profiles; run the real paired probe from
/// precisely that retained source; then record profiles of its two images.
/// The old calibration fact and all earlier source records survive.
public enum AcquireContactProfileComparison<E: Pair, C: PredicateReading,
    V: PredicateReading>: Pair
where E.Left: Structure, E.Right: Pair, E.Right.Right: HasVerdict & Structure,
      E.Right.Right.Sigma == BeamSpace, E.Right.Right.Encoding == SaturationEncoding,
      C.Left == E.Left, C.Sigma == BeamSpace, C.Encoding == SaturationEncoding,
      V.Left == E.Right.Right.Answer, V.Sigma == BeamSpace,
      V.Encoding == SaturationEncoding, V.Answer: Structure {
    public typealias Calibration = RecordReading<C>
    public typealias Probe = StepBeside<E, Calibration.Right.Right>
    public typealias Earlier = FollowedPair<Calibration, Probe>
    public typealias Run = FirstEvidenceImage<Probe.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias ImagesFact = SequentialReading<Run,
        SecondEvidenceImage<E.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Images = SequentialReading<ImagesFact, ReadRecordedAnswer<E.Right.Right>>
    public enum Profiles: PredicateReading {
        public typealias Actual = SequentialReading<Images, V>
        public typealias Left = Probe.Right
        public typealias Right = V.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = V.Predicate
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = Profiles.Answer
        }
    }
    public typealias Record = RecordReading<Profiles>
    public typealias Actual = FollowedPair<Earlier, Record>
    public typealias Left = E.Left
    public typealias Right = Paired<Paired<E.Right, FactOf<C>>, FactOf<Profiles>>
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<AcquireContactProfileComparison.Left, AcquireContactProfileComparison.Right>
    }
    public enum RetainedCalibration: Null {
        public typealias Left = AcquireContactProfileComparison.Right.Left.Right
        public typealias Right = Calibration.Right.Right
    }
}

/// The local procedure receives two finite facts, fixed truth tables
/// and its payload table. It has no encoder or raw-source parameter.
public enum ContactProfileDecision<C: PredicateReading, G: HasVerdict & Structure, Q: PredicateReading,
    A: PredicateReading, K: Pair>: PredicateReading
where C.Left: HasVerdict & Structure, C.Answer == Lit1,
      C.Sigma == BeamSpace, C.Encoding == SaturationEncoding,
      Q.Left == Paired<G, ContactProfileTables>, Q.Answer: Structure,
      A.Left == Paired<Q.Answer, K>, A.Answer: Structure,
      Q.Sigma == BeamSpace, A.Sigma == BeamSpace,
      Q.Encoding == SaturationEncoding, A.Encoding == SaturationEncoding {
    public typealias Left = Paired<Paired<C.Left, G>, Paired<ContactProfileTables, K>>
    public typealias Facts = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Calibration = SequentialReading<Facts,
        FirstEvidenceImage<Facts.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Check = SequentialReading<Calibration, C>
    public typealias Query = SequentialReading<Facts,
        SecondEvidenceImage<Facts.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Resources = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Tables = SequentialReading<Resources,
        FirstEvidenceImage<Resources.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Comparison = SequentialReading<JointEvidence<Query, Tables>, Q>
    public typealias Payloads = SequentialReading<Resources,
        SecondEvidenceImage<Resources.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Choice = SequentialReading<JointEvidence<Comparison, Payloads>, A>
    public typealias Checked = JointEvidence<Check, Choice>
    public typealias Actual = SequentialReading<Checked,
        SecondEvidenceImage<Checked.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Right = A.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ContactProfileChoiceQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ContactProfileDecision.Answer
    }
}

/// Read the two facts at their actual current addresses, then apply the
/// supplied local procedure while retaining the full acquired whole.
public enum ApplyContactProfileDecision<E: Pair, D: PredicateReading, K: Pair>: Pair
where E.Left: Structure, E.Right: Pair, E.Right.Left: Pair,
      E.Right.Left.Right: HasVerdict & Structure, E.Right.Right: HasVerdict & Structure,
      D.Left == Paired<Paired<E.Right.Left.Right, E.Right.Right>, Paired<ContactProfileTables, K>>,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<E, Paired<ContactProfileTables, K>>
    public typealias Acquired = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Old = SequentialReading<Acquired,
        FirstEvidenceImage<E.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Calibration = SequentialReading<Old,
        SecondEvidenceImage<E.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Query = SequentialReading<Acquired,
        SecondEvidenceImage<E.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Resources = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Observation = JointEvidence<JointEvidence<Calibration, Query>, Resources>
    public enum Read: PredicateReading {
        public typealias Actual = SequentialReading<Observation, D>
        public typealias Left = Run.Right
        public typealias Right = D.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = D.Predicate
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = Read.Answer
        }
    }
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Paired<E.Left, Paired<ContactProfileTables, K>>
    public typealias Right = Paired<Paired<E.Right, Paired<ContactProfileTables, K>>,
        AnswerFact<BeamSpace, SaturationEncoding, D.Predicate, D.Answer>>
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<ApplyContactProfileDecision.Left, ApplyContactProfileDecision.Right>
    }
}
