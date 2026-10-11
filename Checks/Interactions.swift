import VerificationIsIdentification
import Examples

// Matter M25a: both hidden sources have a response after the same new
// contact, but the old common response is absent from that contact.
// The catalogue is exactly the finite leaf/fork grammar, with three
// structurally distinct responses. Never here is a present leaf payload.
typealias ResponseAB = CandidateFork<CandidateLeaf<Never>, CandidateLeaf<Lit1>>
typealias ResponseBC = CandidateFork<CandidateLeaf<Lit1>, CandidateLeaf<Lit2>>
typealias ResponseAC = CandidateFork<CandidateLeaf<Never>, CandidateLeaf<Lit2>>
typealias ResponseSources = Paired<ResponseAB, ResponseBC>
typealias ResponseAFromAB = SelectCandidateLeft<SelectCandidateLeaf<Never>, CandidateLeaf<Lit1>>
typealias ResponseBFromAB = SelectCandidateRight<CandidateLeaf<Never>, SelectCandidateLeaf<Lit1>>
typealias ResponseBFromBC = SelectCandidateLeft<SelectCandidateLeaf<Lit1>, CandidateLeaf<Lit2>>
typealias ResponseCFromBC = SelectCandidateRight<CandidateLeaf<Lit1>, SelectCandidateLeaf<Lit2>>
typealias ResponseAFromAC = SelectCandidateLeft<SelectCandidateLeaf<Never>, CandidateLeaf<Lit2>>
typealias ResponseCFromAC = SelectCandidateRight<CandidateLeaf<Never>, SelectCandidateLeaf<Lit2>>

typealias CurrentCommonResponse = CommonCandidateResponse<
    ResponseSources, ResponseBFromAB, ResponseBFromBC>
typealias FirstSourceStillResponds = CommonCandidateResponse<
    Paired<ResponseAB, ResponseAC>, ResponseAFromAB, ResponseAFromAC>
typealias SecondSourceStillResponds = CommonCandidateResponse<
    Paired<ResponseBC, ResponseAC>, ResponseCFromBC, ResponseCFromAC>
enum DifferentResponsesAtSameNewContact: Null {
    typealias Left = Paired<FirstSourceStillResponds.Right, SecondSourceStillResponds.Right>
    typealias Right = Paired<Never, Lit2>
}

// Lift an actual response shared by a least catalogue and the contact to
// a catalogue containing that least one. Extra alternatives are arbitrary.
// The response and its source path follow from the existing constructors.
enum ResponseLiftsThroughInclusion<P: Pair, Q: Pair, Extra: Pair>: Null
where P.Left: Pair, Q.Left: Pair, P.Right == Q.Right {
    typealias Least = CommonCandidateResponse<Paired<P.Left, Q.Left>, P, Q>
    typealias LargerSelection = SelectCandidateLeft<P, Extra>
    typealias Larger = CommonCandidateResponse<
        Paired<LargerSelection.Left, Q.Left>, LargerSelection, Q>
    typealias Left = Cell<Least.Right, Larger.Left.Left.Left>
    typealias Right = Cell<Larger.Right, Least.Left.Left>
}
typealias LeastResponseSurvivesExtraAlternatives = ResponseLiftsThroughInclusion<
    SelectCandidateLeaf<Lit1>, ResponseBFromAB, ResponseAC>

#if INTERACTION_COMMON_RESPONSE_INVENTS_MENU_MEMBER
// A leaf carrying b exists, but its source is not the actual menu {a,c}.
typealias RejectedInventedMenuMember = CommonCandidateResponse<
    Paired<ResponseSources, ResponseAC>, CurrentCommonResponse, SelectCandidateLeaf<Lit1>>
#endif
#if INTERACTION_COMMON_RESPONSE_USES_FIRST_MENU_ENTRY
typealias RejectedCommonAtFirstMenuEntry = CommonCandidateResponse<
    Paired<ResponseSources, ResponseAC>, CurrentCommonResponse, ResponseAFromAC>
#endif
#if INTERACTION_COMMON_RESPONSE_USES_SECOND_MENU_ENTRY
typealias RejectedCommonAtSecondMenuEntry = CommonCandidateResponse<
    Paired<ResponseSources, ResponseAC>, CurrentCommonResponse, ResponseCFromAC>
#endif
#if INTERACTION_INDIVIDUAL_RESPONSES_ARE_COMMON
typealias RejectedIndividualResponsesAsCommon = CommonCandidateResponse<
    Paired<FirstSourceStillResponds.Left, SecondSourceStillResponds.Left>,
    FirstSourceStillResponds, SecondSourceStillResponds>
#endif

// LQ13 inverse question: simultaneous role changes preserve both contacts,
// while replacement with the partner retained has different boundaries.
// D, O and C are the diagonal, opposite and remaining contact entries.
enum FourRoleProfileSymmetries<D: Structure, O: Structure, C: Structure>: Null {
    typealias Source = MatrixEntries<
        MatrixEntries<D, C, C, O>, MatrixEntries<C, D, O, C>,
        MatrixEntries<C, O, D, C>, MatrixEntries<O, C, C, D>>
    typealias ExchangedColumns = MatrixEntries<
        SwapBoundaryReading<Source.Left.Left>.Answer,
        SwapBoundaryReading<Source.Left.Right>.Answer,
        SwapBoundaryReading<Source.Right.Left>.Answer,
        SwapBoundaryReading<Source.Right.Right>.Answer>
    typealias ExchangedBoth = SwapBoundaryReading<ExchangedColumns>
    typealias TransposedColumns = MatrixEntries<
        TransposeEntries<Source.Left.Left>.Answer,
        TransposeEntries<Source.Left.Right>.Answer,
        TransposeEntries<Source.Right.Left>.Answer,
        TransposeEntries<Source.Right.Right>.Answer>
    typealias TransposedBoth = TransposeEntries<TransposedColumns>
    typealias Left = Paired<ExchangedBoth.Answer, TransposedBoth.Answer>
    typealias Right = Paired<Source, Source>
}

// Never and Lit1 are distinct admission codes in these supplied tables.
// The assignments do not constitute physical measurements.
typealias OppositeOnlyContact = FourRoleProfileSymmetries<Lit1, Never, Lit1>
typealias OppositeBlockContact = FourRoleProfileSymmetries<Never, Never, Lit1>
// These are address codes for the four roles. Simultaneous symmetries above
// concern contact incidence, not every internal field of the address codes.
typealias FourContactRoles = CrossedRegionReadings<Never, Lit1>.Source
typealias GivenOppositeForms = Paired<FourContactRoles.Left.Left,
    FourContactRoles.Right.Right>
typealias GivenOppositeFormsDiffer = ZeroSuccessorBoundaryPairClass<Paired<
    GivenOppositeForms.Left.Left, GivenOppositeForms.Right.Left>, Never>
typealias SameGivenOppositeContact = AgreedBoundaryPairClass<Paired<
    OppositeOnlyContact.Source.Left.Left.Right.Right,
    OppositeBlockContact.Source.Left.Left.Right.Right>>
typealias OppositeBlockBoundaryAgreement = AgreedBoundaryPairClass<Paired<
    OppositeBlockContact.Source.Left.Left,
    OppositeBlockContact.Source.Right.Right>>
typealias OppositeOnlyBoundaryDifference = ZeroSuccessorBoundaryPairClass<Paired<
    OppositeOnlyContact.Source.Left.Left.Right.Right,
    OppositeOnlyContact.Source.Right.Right.Right.Right>, Never>
typealias SelfContactDistinguishes = ZeroSuccessorBoundaryPairClass<Paired<
    OppositeBlockContact.Source.Left.Left.Left.Left,
    OppositeOnlyContact.Source.Left.Left.Left.Left>, Never>

#if INTERACTION_JOINT_SYMMETRY_IDENTIFIES_CONTACT
enum RejectedJointSymmetryIdentifiesContact: Null {
    typealias Left = OppositeOnlyContact.Source
    typealias Right = OppositeBlockContact.Source
}
#endif
#if INTERACTION_JOINT_SYMMETRY_TRANSFERS_BOUNDARY
typealias RejectedJointSymmetryTransfersBoundary = AgreedBoundaryPairClass<Paired<
    OppositeOnlyContact.Source.Left.Left,
    OppositeOnlyContact.Source.Right.Right>>
#endif

// LQ17: two region readings come from the same four paired source roles.
// Joint labels recover each pair. One role's row label need not determine
// its column label, or conversely. The full table is a richer input.
enum CrossedRegionReadings<A: Structure, B: Structure>: Null {
    typealias Source = MatrixEntries<Paired<A, A>, Paired<A, B>,
        Paired<B, A>, Paired<B, B>>
    typealias Rows = MatrixEntries<Source.Left.Left.Left, Source.Left.Right.Left,
        Source.Right.Left.Left, Source.Right.Right.Left>
    typealias Columns = MatrixEntries<Source.Left.Left.Right, Source.Left.Right.Right,
        Source.Right.Left.Right, Source.Right.Right.Right>
    typealias Recovered = MatrixEntries<
        Paired<Rows.Left.Left, Columns.Left.Left>,
        Paired<Rows.Left.Right, Columns.Left.Right>,
        Paired<Rows.Right.Left, Columns.Right.Left>,
        Paired<Rows.Right.Right, Columns.Right.Right>>
    typealias Left = Paired<Paired<Rows, Columns>, Recovered>
    typealias Right = Paired<Paired<MatrixEntries<A, A, B, B>,
        MatrixEntries<A, B, A, B>>, Source>
}
typealias CrossedRegionContrast = CrossedRegionReadings<Never, Lit1>
typealias SameRowRegion = AgreedBoundaryPairClass<
    Paired<CrossedRegionContrast.Rows.Left.Left,
           CrossedRegionContrast.Rows.Left.Right>>
typealias DifferentColumnRegions = ZeroSuccessorBoundaryPairClass<
    Paired<CrossedRegionContrast.Columns.Left.Left,
           CrossedRegionContrast.Columns.Left.Right>, Never>
typealias SameColumnRegion = AgreedBoundaryPairClass<
    Paired<CrossedRegionContrast.Columns.Left.Left,
           CrossedRegionContrast.Columns.Right.Left>>
typealias DifferentRowRegions = ZeroSuccessorBoundaryPairClass<
    Paired<CrossedRegionContrast.Rows.Left.Left,
           CrossedRegionContrast.Rows.Right.Left>, Never>

#if INTERACTION_CROSSED_REGIONS_COARSEN_ROWS
typealias RejectedCrossedRegionsCoarsenRows = AgreedBoundaryPairClass<
    Paired<CrossedRegionContrast.Columns.Left.Left,
           CrossedRegionContrast.Columns.Left.Right>>
#endif
#if INTERACTION_CROSSED_REGIONS_COARSEN_COLUMNS
typealias RejectedCrossedRegionsCoarsenColumns = AgreedBoundaryPairClass<
    Paired<CrossedRegionContrast.Rows.Left.Left,
           CrossedRegionContrast.Rows.Right.Left>>
#endif

// AC7: equal total and count can hide whether two actual entries agree.
// Both numerators are constructed, with operands retained by NaturalSum.
enum SameAggregateDifferentContact: Null {
    typealias Split = AddZero<Lit2>
    typealias Flat = AddSuccessor<AddZero<Lit1>>
    typealias Left = Paired<Split.Answer, Paired<Split.Left, Flat.Left>>
    typealias Right = Paired<Flat.Answer,
        Paired<Paired<Never, Lit2>, Paired<Lit1, Lit1>>>
}
typealias AggregateSplitContact = ZeroSuccessorBoundaryPairClass<
    SameAggregateDifferentContact.Split.Left, Lit1>
typealias AggregateFlatContact = AgreedBoundaryPairClass<
    SameAggregateDifferentContact.Flat.Left>

#if INTERACTION_AVERAGE_IDENTIFIES_ENTRIES
enum RejectedAverageIdentifiesEntries: Null {
    typealias Left = SameAggregateDifferentContact.Split.Left
    typealias Right = SameAggregateDifferentContact.Flat.Left
}
#endif
#if INTERACTION_AVERAGE_CERTIFIES_AGREEMENT
typealias RejectedAverageCertifiesAgreement = AgreedBoundaryPairClass<
    SameAggregateDifferentContact.Split.Left>
#endif

// AC7: retain each original entry while summing it and its actual square.
// Only the finite ProductZero/ProductSuccessor and addition constructions
// below establish the arithmetic. The open interfaces alone do not.
typealias MomentAdd2<N: IntegerValued> = AddSuccessor<AddSuccessor<AddZero<N>>>
typealias MomentAdd3<N: IntegerValued> = AddSuccessor<MomentAdd2<N>>
typealias MomentAdd4<N: IntegerValued> = AddSuccessor<MomentAdd3<N>>
typealias MomentAdd6<N: IntegerValued> = AddSuccessor<AddSuccessor<MomentAdd4<N>>>
typealias MomentThree = Examples.Succ<Lit2>
typealias MomentFour = Examples.Succ<MomentThree>
typealias MomentFive = Examples.Succ<MomentFour>
typealias MomentSixValue = Examples.Succ<Examples.Succ<MomentFour>>
typealias MomentEight = Examples.Succ<Examples.Succ<MomentSixValue>>
typealias MomentNine = Examples.Succ<MomentEight>
typealias MomentTen = Examples.Succ<MomentNine>
typealias MomentEleven = Examples.Succ<MomentTen>
typealias MomentTwelve = Examples.Succ<MomentEleven>
typealias MomentSquare0 = ProductZero<Never>
typealias MomentSquare1 = ProductSuccessor<ProductZero<Lit1>, AddZero<Lit1>>
typealias MomentTwoOnce = ProductSuccessor<ProductZero<Lit2>, AddZero<Lit2>>
typealias MomentSquare2 = ProductSuccessor<MomentTwoOnce, MomentAdd2<Lit2>>
typealias MomentThreeOnce = ProductSuccessor<ProductZero<MomentThree>, AddZero<MomentThree>>
typealias MomentThreeTwice = ProductSuccessor<MomentThreeOnce, MomentAdd3<MomentThree>>
typealias MomentSquare3 = ProductSuccessor<MomentThreeTwice, MomentAdd6<MomentThree>>

typealias MomentSix<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure> = AddressTriple<Paired<A, B>, Paired<C, D>, Paired<E, F>>
// This carrier checks only the joining of six supplied operand/answer pairs,
// adding from the final entry back to the first. F starts with zero + entry.
// Every instance below supplies actual finite additions, not arbitrary pairs.
enum SixEntrySum<A: Pair, B: Pair, C: Pair,
    D: Pair, E: Pair, F: Pair>: Pair
where A.Left: Pair, B.Left: Pair, C.Left: Pair,
      D.Left: Pair, E.Left: Pair, F.Left: Pair,
      A.Left.Left: Structure, B.Left.Left: Structure, C.Left.Left: Structure,
      D.Left.Left: Structure, E.Left.Left: Structure, F.Left.Left: Structure,
      F.Left.Right: Structure,
      F.Left.Left == Never, E.Left.Right == F.Right,
      D.Left.Right == E.Right, C.Left.Right == D.Right,
      B.Left.Right == C.Right, A.Left.Right == B.Right {
    typealias Left = MomentSix<A.Left.Left, B.Left.Left, C.Left.Left,
                              D.Left.Left, E.Left.Left, F.Left.Right>
    typealias Right = A.Right
}
typealias MomentFirstPopulation = SixEntrySum<
    AddZero<MomentSixValue>, AddZero<MomentSixValue>, AddZero<MomentSixValue>,
    MomentAdd2<MomentFour>, MomentAdd2<Lit2>, AddZero<Lit2>>
typealias MomentSecondPopulation = SixEntrySum<AddZero<MomentSixValue>, AddZero<MomentSixValue>,
    AddSuccessor<AddZero<MomentFive>>, AddSuccessor<AddZero<MomentFour>>,
    AddSuccessor<AddZero<MomentThree>>, AddZero<MomentThree>>
typealias MomentFirstSquares = SixEntrySum<
    AddZero<MomentTwelve>, AddZero<MomentTwelve>, AddZero<MomentTwelve>,
    MomentAdd4<MomentEight>, MomentAdd4<MomentFour>, AddZero<MomentFour>>
typealias MomentSecondSquares = SixEntrySum<AddZero<MomentTwelve>, AddZero<MomentTwelve>,
    AddSuccessor<AddZero<MomentEleven>>, AddSuccessor<AddZero<MomentTen>>,
    AddSuccessor<AddZero<MomentNine>>, AddZero<MomentNine>>
enum MomentSquaresUseSameEntryTwice: Null {
    typealias Left = MatrixEntries<MomentSquare0.Left.Left, MomentSquare1.Left.Left,
                                   MomentSquare2.Left.Left, MomentSquare3.Left.Left>
    typealias Right = MatrixEntries<MomentSquare0.Left.Right, MomentSquare1.Left.Right,
                                    MomentSquare2.Left.Right, MomentSquare3.Left.Right>
}
enum MomentSquaresRetainSources: Null {
    typealias Left = Paired<Paired<MomentFirstPopulation.Left, MomentSecondPopulation.Left>,
                            Paired<MomentFirstSquares.Left, MomentSecondSquares.Left>>
    typealias Right = Paired<Paired<
        MomentSix<MomentSquare0.Left.Left, MomentSquare0.Left.Left, MomentSquare0.Left.Left,
                  MomentSquare2.Left.Left, MomentSquare2.Left.Left, MomentSquare2.Left.Left>,
        MomentSix<MomentSquare0.Left.Left, MomentSquare0.Left.Left, MomentSquare1.Left.Left,
                  MomentSquare1.Left.Left, MomentSquare1.Left.Left, MomentSquare3.Left.Left>>, Paired<
        MomentSix<MomentSquare0.Answer, MomentSquare0.Answer, MomentSquare0.Answer,
                  MomentSquare2.Answer, MomentSquare2.Answer, MomentSquare2.Answer>,
        MomentSix<MomentSquare0.Answer, MomentSquare0.Answer, MomentSquare1.Answer,
                  MomentSquare1.Answer, MomentSquare1.Answer, MomentSquare3.Answer>>>
}
enum EqualFirstTwoMoments: Null {
    typealias Six = MomentSixValue
    typealias Twelve = MomentTwelve
    typealias Left = Paired<Paired<MomentFirstPopulation.Right, MomentFirstSquares.Right>,
                            Paired<MomentSecondPopulation.Right, MomentSecondSquares.Right>>
    typealias Right = Paired<Paired<Six, Twelve>, Paired<Six, Twelve>>
}
// The third original entry is zero in the first population and one in the
// second. Both actual source chains contain six entries. Their histograms
// also differ: (0,0,0,2,2,2) versus (0,0,1,1,1,3).
typealias EqualMomentsDistinctSources = ZeroSuccessorBoundaryPairClass<Paired<
    MomentFirstPopulation.Left.Right.Left.Left,
    MomentSecondPopulation.Left.Right.Left.Left>, Never>
#if INTERACTION_TWO_MOMENTS_IDENTIFY_SOURCE
enum RejectedTwoMomentsIdentifySource: Null {
    typealias Left = MomentFirstPopulation.Left
    typealias Right = MomentSecondPopulation.Left
}
#endif

// IiS24: local lists can agree up to an alternative-address exchange while
// the actual joining differs. No probability or spacetime claim is encoded.
enum BinaryContextProjectionAgreement<A: Structure, B: Structure>: Null {
    typealias C = BinaryContactAlternatives<A, B>
    typealias Local = BinaryContactLocalLists<A, B>
    typealias Left = Paired<Local.Left, C.Left>
    typealias Right = Paired<Local.Right,
        MatrixEntries<C.Equal, C.Equal, C.Equal, C.Opposed>>
}
typealias BinaryContextContrast = BinaryContactAlternatives<Never, Lit1>
typealias BinaryContextJoiningDifference = ZeroSuccessorBoundaryPairClass<
    Paired<BinaryContextContrast.Equal.Left.Right,
           BinaryContextContrast.Opposed.Left.Right>, Never>
typealias BinaryContextAlternativeAddressDifference = ZeroSuccessorBoundaryPairClass<
    Paired<BinaryContextContrast.EqualColumns.Answer.Right.Left,
           BinaryContextContrast.OpposedColumns.Answer.Right.Left>, Never>

#if INTERACTION_LOCAL_LISTS_IDENTIFY_JOINING
enum RejectedLocalListsIdentifyJoining: Null {
    typealias Left = BinaryContextContrast.Equal
    typealias Right = BinaryContextContrast.Opposed
}
#endif
#if INTERACTION_LOCAL_LISTS_RETAIN_ALTERNATIVE_ADDRESS
enum RejectedLocalListsRetainAlternativeAddress: Null {
    typealias Left = BinaryContextContrast.EqualColumns.Answer.Right
    typealias Right = BinaryContextContrast.OpposedColumns.Answer.Right
}
#endif

// IiS24: a local gate receives only its setting, guessed setting and payload.
// It emits that actual payload only when the two setting addresses agree.
enum AcceptedLocalGuess<P: Pair>: Pair
where P.Left: Pair, P.Left.Left == P.Left.Right {
    typealias Left = P
    typealias Right = P.Right
}

// C retains one guessed setting pair and two prepared joint alternatives.
// S is independently supplied. Each acceptance uses its own local packet.
enum CoincidenceRow<S: Pair, C: Pair>: Pair
where S.Left: Structure, S.Right: Structure, C.Left: Pair,
      C.Right: Pair, C.Right.Left: Pair, C.Right.Right: Pair,
      C.Right.Left.Left: Structure, C.Right.Left.Right: Structure,
      C.Right.Right.Left: Structure, C.Right.Right.Right: Structure,
      S.Left == C.Left.Left, S.Right == C.Left.Right {
    typealias FirstA = AcceptedLocalGuess<Paired<Paired<S.Left, C.Left.Left>, C.Right.Left.Left>>
    typealias FirstB = AcceptedLocalGuess<Paired<Paired<S.Right, C.Left.Right>, C.Right.Left.Right>>
    typealias SecondA = AcceptedLocalGuess<Paired<Paired<S.Left, C.Left.Left>, C.Right.Right.Left>>
    typealias SecondB = AcceptedLocalGuess<Paired<Paired<S.Right, C.Left.Right>, C.Right.Right.Right>>
    typealias Left = Paired<Paired<FirstA.Left, FirstB.Left>, Paired<SecondA.Left, SecondB.Left>>
    typealias Right = Paired<Paired<FirstA.Right, FirstB.Right>, Paired<SecondA.Right, SecondB.Right>>
}
typealias Guess00 = Paired<Never, Never>
typealias Guess01 = Paired<Never, Lit1>
typealias Guess10 = Paired<Lit1, Never>
typealias Guess11 = Paired<Lit1, Lit1>
typealias PreparedGuessCatalogue = MatrixEntries<
    Paired<Guess00, BinaryContextContrast.Equal>,
    Paired<Guess01, BinaryContextContrast.Equal>,
    Paired<Guess10, BinaryContextContrast.Equal>,
    Paired<Guess11, BinaryContextContrast.Opposed>>
enum PostselectedPRFromLocalPackets: Null {
    typealias At00 = CoincidenceRow<Guess00, PreparedGuessCatalogue.Left.Left>
    typealias At01 = CoincidenceRow<Guess01, PreparedGuessCatalogue.Left.Right>
    typealias At10 = CoincidenceRow<Guess10, PreparedGuessCatalogue.Right.Left>
    typealias At11 = CoincidenceRow<Guess11, PreparedGuessCatalogue.Right.Right>
    typealias Left = MatrixEntries<At00.Right, At01.Right, At10.Right, At11.Right>
    typealias Right = BinaryContextContrast.Left
}
// The same 10 guess is accepted at 10 but not at 00. Constant average
// efficiencies do not establish equality of these source-specific domains.
typealias GuessAdmissionDifference = ZeroSuccessorBoundaryPairClass<Paired<
    Guess00.Left, PreparedGuessCatalogue.Right.Left.Left.Left>, Never>
#if INTERACTION_COINCIDENCE_ERASES_GUESS_ADMISSION
typealias RejectedCoincidenceErasesGuessAdmission =
    CoincidenceRow<Guess00, PreparedGuessCatalogue.Right.Left>
#endif

// M39: each symbol carries its declared landmark/interior tag. The two
// clauses read actual input fields. Their composition retains the raw word
// and the preceding landmark, rather than supplying the final record.
typealias MarkedLandmark<L: Structure> = Paired<Never, L>
typealias UnmarkedInterior = Paired<Lit1, Never>
enum VisitLandmark<P: Pair>: Pair
where P.Right: Pair, P.Right.Left == Never {
    typealias Left = P
    typealias Right = P.Right.Right
}
enum PassInterior<P: Pair>: Pair
where P.Right: Pair, P.Right.Left == Lit1 {
    typealias Left = P
    typealias Right = P.Left
}
enum FourLandmarkSteps<F: Pair, G: Pair, H: Pair, J: Pair>: Pair
where F.Left: Pair, G.Left: Pair, H.Left: Pair, J.Left: Pair,
      F.Left.Left: Structure, F.Left.Right: Structure,
      G.Left.Right: Structure, H.Left.Right: Structure, J.Left.Right: Structure,
      F.Right: Structure, G.Right: Structure, H.Right: Structure, J.Right: Structure,
      G.Left.Left == F.Right, H.Left.Left == G.Right, J.Left.Left == H.Right {
    typealias Left = Paired<F.Left.Left, MatrixEntries<
        F.Left.Right, G.Left.Right, H.Left.Right, J.Left.Right>>
    typealias Right = MatrixEntries<F.Right, G.Right, H.Right, J.Right>
}
enum ReverseFourEntries<M: Pair>: Pair
where M.Left: Pair, M.Right: Pair,
      M.Left.Left: Structure, M.Left.Right: Structure,
      M.Right.Left: Structure, M.Right.Right: Structure {
    typealias Left = M
    typealias Right = MatrixEntries<M.Right.Right, M.Right.Left,
        M.Left.Right, M.Left.Left>
}
// Space section 3a: one traversal has two reversing involutions. Keeping
// the current first reading selects the anchored one in this source family.
enum RotateFourEntries<W: Pair>: Pair
where W.Left: Pair, W.Right: Pair,
      W.Left.Left: Structure, W.Left.Right: Structure,
      W.Right.Left: Structure, W.Right.Right: Structure {
    typealias Left = W
    typealias Right = MatrixEntries<W.Left.Right, W.Right.Left,
        W.Right.Right, W.Left.Left>
}
enum AnchoredFourEntryReversal<W: Pair>: Pair
where W.Left: Pair, W.Right: Pair,
      W.Left.Left: Structure, W.Left.Right: Structure,
      W.Right.Left: Structure, W.Right.Right: Structure {
    typealias Left = W
    typealias Right = MatrixEntries<W.Left.Left, W.Right.Right,
        W.Right.Left, W.Left.Right>
}
enum OneTraversalTwoReversals<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Source = MatrixEntries<A, B, C, D>
    typealias Anchored = AnchoredFourEntryReversal<Source>
    typealias Shifted = ReverseFourEntries<Source>
    typealias AnchoredTwice = AnchoredFourEntryReversal<Anchored.Right>
    typealias ShiftedTwice = ReverseFourEntries<Shifted.Right>
    typealias AnchoredStep = RotateFourEntries<Anchored.Right>
    typealias ShiftedStep = RotateFourEntries<Shifted.Right>
    typealias AnchoredBack = AnchoredFourEntryReversal<AnchoredStep.Right>
    typealias ShiftedBack = ReverseFourEntries<ShiftedStep.Right>
    typealias Inverse = MatrixEntries<Source.Right.Right, Source.Left.Left,
        Source.Left.Right, Source.Right.Left>
    typealias Left = MatrixEntries<AnchoredTwice.Right, ShiftedTwice.Right,
        AnchoredBack.Right, ShiftedBack.Right>
    typealias Right = MatrixEntries<Source, Source, Inverse, Inverse>
}
typealias TraversalReversalContrast = OneTraversalTwoReversals<Never, Lit1, Lit2, Lit1>
typealias AnchoredReversalReturnsThisSource = AgreedBoundaryPairClass<Paired<
    TraversalReversalContrast.Anchored.Right, TraversalReversalContrast.Source>>
typealias ReversalFirstReadingDiffers = ZeroSuccessorBoundaryPairClass<Paired<
    TraversalReversalContrast.Anchored.Right.Left.Left,
    TraversalReversalContrast.Shifted.Right.Left.Left>, Never>
#if INTERACTION_DYNAMICS_IDENTIFIES_REVERSAL
enum RejectedDynamicsIdentifiesReversal: Null {
    typealias Left = TraversalReversalContrast.Anchored.Right
    typealias Right = TraversalReversalContrast.Shifted.Right
}
#endif

enum LandmarkReversal<A: Structure, B: Structure, C: Structure>: Null {
    typealias Raw = MatrixEntries<MarkedLandmark<A>, UnmarkedInterior,
        MarkedLandmark<B>, MarkedLandmark<C>>
    typealias Back = ReverseFourEntries<Raw>.Right
    typealias F = VisitLandmark<Paired<C, Raw.Left.Left>>
    typealias G = PassInterior<Paired<F.Right, Raw.Left.Right>>
    typealias H = VisitLandmark<Paired<G.Right, Raw.Right.Left>>
    typealias J = VisitLandmark<Paired<H.Right, Raw.Right.Right>>
    typealias Forward = FourLandmarkSteps<F, G, H, J>
    typealias R = VisitLandmark<Paired<A, Back.Left.Left>>
    typealias S = VisitLandmark<Paired<R.Right, Back.Left.Right>>
    typealias T = PassInterior<Paired<S.Right, Back.Right.Left>>
    typealias V = VisitLandmark<Paired<T.Right, Back.Right.Right>>
    typealias Backward = FourLandmarkSteps<R, S, T, V>
    typealias BackwardAtForwardPositions = ReverseFourEntries<Backward.Right>.Right
    typealias Left = MatrixEntries<Forward.Left.Right, Backward.Left.Right,
        Forward.Right, Backward.Right>
    typealias Right = MatrixEntries<Raw, Back,
        MatrixEntries<A, A, B, C>, MatrixEntries<C, B, B, A>>
}
typealias LandmarkContrast = LandmarkReversal<Never, Lit1, Lit2>
// At landmark A and at the following interior position the forward label
// agrees. Reversing the source direction gives different labels there.
typealias SameForwardLandmark = AgreedBoundaryPairClass<Paired<
    LandmarkContrast.Forward.Right.Left.Left,
    LandmarkContrast.Forward.Right.Left.Right>>
typealias DifferentReversedLandmark = ZeroSuccessorBoundaryPairClass<Paired<
    LandmarkContrast.BackwardAtForwardPositions.Left.Left,
    LandmarkContrast.BackwardAtForwardPositions.Left.Right>, Never>
enum InteriorReversalExchangesBoundaryPair<A: Structure, B: Structure,
    C: Structure>: Null {
    typealias L = LandmarkReversal<A, B, C>
    typealias Previous = L.Forward.Right.Left.Right
    typealias Next = L.BackwardAtForwardPositions.Left.Right
    typealias Left = SwapBoundaryReading<Paired<Previous, Next>>.Answer
    typealias Right = Paired<B, A>
}
#if INTERACTION_LANDMARK_RECORD_COMMUTES_WITH_REVERSAL
enum RejectedLandmarkRecordReversal: Null {
    typealias Left = ReverseFourEntries<LandmarkContrast.Forward.Right>.Right
    typealias Right = LandmarkContrast.Backward.Right
}
#endif

// M39: a delay record retains every source entry but its reversal must
// exchange both window order and the two addresses within each window.
enum DelayPairReading<T: Pair>: Pair
where T.Right: Pair, T.Left: Structure,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = T
    typealias Right = Paired<Paired<T.Left, T.Right.Left>,
        Paired<T.Right.Left, T.Right.Right>>
}
enum DelayPairRecovery<W: Pair>: Pair
where W.Left: Pair, W.Right: Pair,
      W.Left.Left: Structure, W.Left.Right: Structure,
      W.Right.Right: Structure, W.Left.Right == W.Right.Left {
    typealias Left = W
    typealias Right = AddressTriple<W.Left.Left, W.Left.Right, W.Right.Right>
}
enum DelayPairIsLossless<A: Structure, B: Structure, C: Structure>: Null {
    typealias Raw = AddressTriple<A, B, C>
    typealias Left = DelayPairRecovery<DelayPairReading<Raw>.Right>.Right
    typealias Right = Raw
}
enum DelayPairReversal<A: Structure, B: Structure, C: Structure>: Null {
    typealias Raw = AddressTriple<A, B, C>
    typealias Back = AddressTriple<Raw.Right.Right, Raw.Right.Left, Raw.Left>
    typealias Forward = DelayPairReading<Raw>.Right
    typealias Exchanged = PairedApplication<
        SwapBoundaryReading<Forward.Left>, SwapBoundaryReading<Forward.Right>>
    typealias Left = SwapBoundaryReading<Exchanged.Answer>.Answer
    typealias Right = DelayPairReading<Back>.Right
}
#if INTERACTION_DELAY_PAIR_REVERSES_WITHOUT_FIELD_EXCHANGE
typealias RejectedDelayPairOrdinaryReversal = DelayPairRecovery<
    SwapBoundaryReading<DelayPairReading<AddressTriple<Never, Never, Lit1>>.Right>.Answer>
#endif

// AC7 section 6d: the consumer joins actual words at their common field.
// Reversing a closed first word preserves that seam and its continuation.
enum JoinedFourEntryWords<L: Pair, R: Pair>: Pair
where L.Left: Pair, L.Right: Pair, R.Left: Pair, R.Right: Pair,
      L.Left.Left: Structure, L.Left.Right: Structure,
      L.Right.Left: Structure, L.Right.Right: Structure,
      R.Left.Right: Structure, R.Right.Left: Structure, R.Right.Right: Structure,
      L.Right.Right == R.Left.Left {
    typealias Left = Paired<L, R>
    typealias Right = Paired<L, AddressTriple<
        R.Left.Right, R.Right.Left, R.Right.Right>>
}
enum ClosedBlockReversalPreservesContinuation<
    A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure>: Null {
    typealias Forward = JoinedFourEntryWords<
        MatrixEntries<A, B, C, A>, MatrixEntries<A, D, E, F>>
    typealias Reversed = JoinedFourEntryWords<
        ReverseFourEntries<Forward.Left.Left>.Right, Forward.Left.Right>
    typealias Restored = JoinedFourEntryWords<
        ReverseFourEntries<Reversed.Left.Left>.Right, Reversed.Left.Right>
    typealias Left = Paired<Reversed.Right.Right, Restored.Right>
    typealias Right = Paired<Forward.Right.Right, Forward.Right>
}
typealias OpenBlockSource = JoinedFourEntryWords<
    MatrixEntries<Never, Lit2, Lit2, Lit1>,
    MatrixEntries<Lit1, Never, Lit2, Never>>
#if INTERACTION_OPEN_BLOCK_REVERSAL_PRESERVES_SEAM
typealias RejectedOpenBlockReversalPreservesSeam = JoinedFourEntryWords<
    ReverseFourEntries<OpenBlockSource.Left.Left>.Right, OpenBlockSource.Left.Right>
#endif

// M39: four seed slots route the source twice and each opposite-pair
// entry once. Equal seed weights are an explicit preparation premise.
enum OppositePairReading<P: Pair>: Pair
where P.Left: Structure, P.Right: Pair,
      P.Right.Left: Structure, P.Right.Right: Structure {
    typealias Left = P
    typealias Right = MatrixEntries<P.Left, P.Left,
        P.Right.Left, P.Right.Right>
}
enum ExchangeLastTwoSeeds<W: Pair>: Pair
where W.Left: Structure, W.Right: Pair,
      W.Right.Left: Structure, W.Right.Right: Structure {
    typealias Left = W
    typealias Right = Paired<W.Left, SwapBoundaryReading<W.Right>.Answer>
}
enum TwoPairRecording<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Source = MatrixEntries<A, B, C, D>
    typealias First = OppositePairReading<Paired<Source.Left.Left, Source.Right>>
    typealias Second = OppositePairReading<Paired<Source.Left.Right, Source.Right>>
    typealias Third = OppositePairReading<Paired<Source.Right.Left, Source.Left>>
    typealias Fourth = OppositePairReading<Paired<Source.Right.Right, Source.Left>>

    // Each catalogue below rearranges all eight actual source-seed slots.
    typealias FirstMixture = MatrixEntries<
        Paired<First.Right.Left.Left, First.Right.Left.Right>,
        Paired<Second.Right.Left.Left, Second.Right.Left.Right>,
        Paired<First.Right.Right.Left, Second.Right.Right.Left>,
        Paired<First.Right.Right.Right, Second.Right.Right.Right>>
    typealias SecondMixture = MatrixEntries<
        Paired<Third.Right.Right.Left, Fourth.Right.Right.Left>,
        Paired<Third.Right.Right.Right, Fourth.Right.Right.Right>,
        Paired<Third.Right.Left.Left, Third.Right.Left.Right>,
        Paired<Fourth.Right.Left.Left, Fourth.Right.Left.Right>>

    // Output reversal exchanges A/B and C/D in the same routing rule.
    typealias ReversedFrame = PairedApplication<
        SwapBoundaryReading<Source.Left>, SwapBoundaryReading<Source.Right>>
    typealias ReversedOutputs = MatrixEntries<
        OppositePairReading<Paired<ReversedFrame.Answer.Left.Left,
            ReversedFrame.Answer.Right>>.Right,
        OppositePairReading<Paired<ReversedFrame.Answer.Left.Right,
            ReversedFrame.Answer.Right>>.Right,
        OppositePairReading<Paired<ReversedFrame.Answer.Right.Left,
            ReversedFrame.Answer.Left>>.Right,
        OppositePairReading<Paired<ReversedFrame.Answer.Right.Right,
            ReversedFrame.Answer.Left>>.Right>
    // Reverse source columns at the original frame. The final two seed
    // slots must exchange as well. This preserves the uniform seed law.
    typealias ReversedSources = MatrixEntries<
        ExchangeLastTwoSeeds<Second.Right>.Right,
        ExchangeLastTwoSeeds<First.Right>.Right,
        ExchangeLastTwoSeeds<Fourth.Right>.Right,
        ExchangeLastTwoSeeds<Third.Right>.Right>
    typealias Left = Paired<FirstMixture, ReversedOutputs>
    typealias Right = Paired<SecondMixture, ReversedSources>
}
typealias FourSourceRecording = TwoPairRecording<Never, Lit1, Lit2, MomentThree>
typealias SameTwoPairRecordLaw = AgreedBoundaryPairClass<Paired<
    FourSourceRecording.FirstMixture, FourSourceRecording.SecondMixture>>
typealias TwoPairPreparationDifference = ZeroSuccessorBoundaryPairClass<Paired<
    FourSourceRecording.First.Left.Left,
    FourSourceRecording.Third.Left.Left>, Lit1>
#if INTERACTION_SAME_RECORD_LAW_IDENTIFIES_PREPARATION
enum RejectedSameRecordLawIdentifiesPreparation: Null {
    typealias Left = FourSourceRecording.Source.Left
    typealias Right = FourSourceRecording.Source.Right
}
#endif

// LQ13: the constructed sum 1 + N has a successor answer for every N.
// It cannot reach the zero reference, even though finite natural addition
// has total composition and cancellation. No supplied sum claim is used.
typealias PositiveSumCannotReachZero<N: IntegerValued> = ZeroSuccessorBoundaryPairClass<
    Paired<Never, AddSuccessor<AddZero<N>>.Answer>, N>

// LiR7: independent closed-loop witnesses need not retain one common source.
// These are actual field exchanges, without a distance or DNA interpretation.
typealias LoopLastTwo<A: Structure, B: Structure, C: Structure> = PairedApplication<
    IdentityReading<A, BeamSpace, SaturationEncoding>,
    SwapBoundaryReading<Paired<B, C>>>

enum FirstLoopHasFixedSource<A: Structure, C: Structure>: Null {
    typealias Source = AddressTriple<A, A, C>
    typealias Left = SwapFirstTwoTriple<Source>.Answer
    typealias Right = Source
}

enum SecondLoopHasFixedSource<A: Structure, C: Structure>: Null {
    typealias Source = AddressTriple<A, C, C>
    typealias Left = LoopLastTwo<A, C, C>.Answer
    typealias Right = Source
}

// Both return equations address the same three fields. Equality of the
// outside fields follows from the computed exchanges, not a supplied answer.
enum SharedLoopReturn<S: Pair>: Null
where S.Right: Pair, S.Left: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure,
      SwapFirstTwoTriple<S>.Answer == AddressTriple<S.Left, S.Right.Left, S.Right.Right>,
      LoopLastTwo<S.Left, S.Right.Left, S.Right.Right>.Answer
        == AddressTriple<S.Left, S.Right.Left, S.Right.Right> {
    typealias Left = S.Left
    typealias Right = S.Right.Right
}

typealias FirstLoopWitness = FirstLoopHasFixedSource<Never, Lit1>.Source
typealias SecondLoopWitness = SecondLoopHasFixedSource<Never, Lit1>.Source
typealias LoopWitnessContrast = ZeroSuccessorBoundaryPairClass<
    Paired<FirstLoopWitness.Left, FirstLoopWitness.Right.Right>, Never>
enum LoopWitnessesKeepSameOutsideFields: Null {
    typealias Left = Paired<FirstLoopWitness.Left, FirstLoopWitness.Right.Right>
    typealias Right = Paired<SecondLoopWitness.Left, SecondLoopWitness.Right.Right>
}
enum SharedLoopReturnAtUniformSource<A: Structure>: Null {
    typealias Common = SharedLoopReturn<AddressTriple<A, A, A>>
    typealias Left = Common.Left
    typealias Right = Common.Right
}

#if INTERACTION_LOCAL_LOOP_WITNESSES_GLUE
typealias RejectedLocalLoopWitnessesGlue = SharedLoopReturn<FirstLoopWitness>
#endif
#if INTERACTION_LOOP_RETURN_IS_IDENTITY
enum RejectedLoopReturnAsIdentity: Null {
    typealias Left = SwapFirstTwoTriple<SecondLoopWitness>.Answer
    typealias Right = SecondLoopWitness
}
#endif

// S4: a short-long-short shape cycle with alternating retained contacts.
// Inputs and endpoints are joint relations. The net translation is derived.
// Arithmetic starts at actual AddZero constructors, not supplied NaturalSum.
typealias ContactAddOne<N: IntegerValued> = AddSuccessor<AddZero<N>>

// Starting from a short body, extend its right endpoint by one while the
// left endpoint is retained. Then retain that right endpoint and recover
// the short body's left endpoint as its actual successor predecessor.
enum AnchoredCycleForcesTranslation<N: IntegerValued>: Null {
    typealias One = ContactAddOne<N>
    typealias Start = Paired<N, One.Answer>
    typealias Extension = ContactAddOne<Start.Right>
    typealias Extended = Paired<Start.Left, Extension.Answer>
    typealias Finish = Paired<Extended.Right.Right, Extended.Right>
    typealias Left = Finish
    typealias Right = Paired<ContactAddOne<Start.Left>.Answer,
                            ContactAddOne<Start.Right>.Answer>
}

// Shorten under the original left support instead. The body length cycle
// agrees, while the resulting position relative to the retained ground does not.
enum RetainedLeftSupportReturns<N: IntegerValued>: Null {
    typealias Cycle = AnchoredCycleForcesTranslation<N>
    typealias Finish = Paired<Cycle.Extended.Left, Cycle.Extended.Right.Right>
    typealias Left = Finish
    typealias Right = Cycle.Start
}

// Both contractions yield the original short separation. This checks the
// omitted shape reading as well as the distinct substrate positions.
enum BothSupportHistoriesRestoreLength<N: IntegerValued>: Null {
    typealias Moving = AnchoredCycleForcesTranslation<N>
    typealias Stationary = RetainedLeftSupportReturns<N>
    typealias Left = Paired<ContactAddOne<Moving.Finish.Left>.Answer,
                           ContactAddOne<Stationary.Finish.Left>.Answer>
    typealias Right = Paired<Moving.Finish.Right, Stationary.Finish.Right>
}

typealias AnchoredFiniteCycle = AnchoredCycleForcesTranslation<Never>
typealias GroundContactActuallyChanges = ZeroSuccessorBoundaryPairClass<
    Paired<AnchoredFiniteCycle.Start.Left, AnchoredFiniteCycle.Finish.Left>, Never>
enum SameStrokeHasStationaryRealization: Null {
    typealias Stationary = RetainedLeftSupportReturns<Never>
    typealias Left = Stationary.Left
    typealias Right = AnchoredFiniteCycle.Start
}

#if INTERACTION_SHAPE_RETURN_IS_CONTACT_RETURN
enum RejectedShapeReturnAsContactReturn: Null {
    typealias Left = AnchoredFiniteCycle.Finish
    typealias Right = AnchoredFiniteCycle.Start
}
#endif
#if INTERACTION_BOTH_SUPPORTS_ALLOW_EXTENSION
enum RejectedBothSupportsExtension: Null {
    typealias Left = AnchoredFiniteCycle.Extended
    typealias Right = AnchoredFiniteCycle.Start
}
#endif

// Space §3a: closed excursions join at one actual endpoint. A swap and
// its actual inverse can enclose any certified return at the swapped source.
// IdentityReading is the empty excursion. Finite nesting and joining give
// the cancellation grammar used by the tree argument, without a runtime.
enum JoinedClosedContacts<P: Null, Q: Null>: Null
where P.Right == Q.Left {
    typealias Left = P.Left
    typealias Right = Q.Right
}

enum SwapAroundClosedContact<A: Structure, B: Structure, C: Null>: Null
where C.Left == Paired<B, A> {
    typealias Forward = SwapBoundaryReading<Paired<A, B>>
    typealias Backward = SwapBoundaryReading<C.Right>
    typealias Left = Forward.Left
    typealias Right = Backward.Answer
}

typealias EmptyContactExcursion = IdentityReading<
    Paired<Lit1, Never>, BeamSpace, SaturationEncoding>
typealias SimpleContactExcursion = SwapAroundClosedContact<
    Never, Lit1, EmptyContactExcursion>
typealias NestedContactExcursion = SwapAroundClosedContact<
    Never, Lit1, DoubleSwapReturn<Lit1, Never>>
typealias JoinedContactExcursions = JoinedClosedContacts<
    SimpleContactExcursion, NestedContactExcursion>
typealias ExcursionInteriorReallyDiffers = ZeroSuccessorBoundaryPairClass<Paired<
    NestedContactExcursion.Forward.Left.Left,
    NestedContactExcursion.Forward.Answer.Left>, Never>

#if INTERACTION_RETRACE_RESTARTS_INTERIOR
typealias RejectedRetraceRestartsInterior = SwapAroundClosedContact<
    Never, Lit1, IdentityReading<Paired<Never, Lit1>, BeamSpace, SaturationEncoding>>
#endif

// S28: local strict between-points need not share one midpoint reading.
// Every sum is an actual finite constructor expression. The six sorted
// inputs are checked against one source and the preceding computed outputs.
typealias MidpointAdd2<B: IntegerValued> = AddSuccessor<AddSuccessor<AddZero<B>>>
typealias MidpointAdd3<B: IntegerValued> = AddSuccessor<MidpointAdd2<B>>
typealias MidpointAdd4<B: IntegerValued> = AddSuccessor<MidpointAdd3<B>>
typealias MidpointAdd5<B: IntegerValued> = AddSuccessor<MidpointAdd4<B>>

// These projections only collect addresses. The actual arguments below
// are constructor terms rooted at AddZero, never supplied arithmetic claims.
typealias MidpointOperands<G: NaturalSum, D: NaturalSum, T: NaturalSum> =
    AddressTriple<Paired<G.Left.Left, G.Answer>, D.Left, T.Left>
typealias MidpointExpected<L: IntegerValued, H: IntegerValued, D: NaturalSum> =
    AddressTriple<Paired<L, H>, Paired<H, H>, Paired<L, D.Answer>>

enum BiasedMidpointTrace: Null {
    typealias Source = MatrixEntries<Never, Lit2, Lit1, Lit1>
    typealias ABGap = AddZero<Source.Left.Right>
    typealias ABTwice = MidpointAdd2<Source.Left.Right>
    typealias AB = AddZero<ABTwice.Answer>
    typealias CDGap = AddSuccessor<AddZero<Never>>
    typealias CDTwice = AddSuccessor<AddZero<Source.Right.Right>>
    typealias CD = AddSuccessor<AddZero<CDTwice.Answer>>
    typealias ACGap = AddZero<Source.Right.Left>
    typealias ACTwice = AddSuccessor<AddZero<Source.Right.Left>>
    typealias AC = AddZero<ACTwice.Answer>
    typealias BDGap = AddSuccessor<AddZero<Lit1>>
    typealias BDTwice = MidpointAdd2<Source.Left.Right>
    typealias BD = AddSuccessor<AddZero<BDTwice.Answer>>
    typealias RowsGap = MidpointAdd3<Lit1>
    typealias RowsTwice = MidpointAdd4<AB.Answer>
    typealias Rows = MidpointAdd3<RowsTwice.Answer>
    typealias ColumnsGap = MidpointAdd2<Examples.Succ<Lit2>>
    typealias ColumnsTwice = MidpointAdd5<BD.Answer>
    typealias Columns = MidpointAdd2<ColumnsTwice.Answer>
    typealias Left = Paired<
        AddressTriple<MidpointOperands<ABGap, ABTwice, AB>,
                      MidpointOperands<CDGap, CDTwice, CD>,
                      MidpointOperands<ACGap, ACTwice, AC>>,
        AddressTriple<MidpointOperands<BDGap, BDTwice, BD>,
                      MidpointOperands<RowsGap, RowsTwice, Rows>,
                      MidpointOperands<ColumnsGap, ColumnsTwice, Columns>>>
    typealias Right = Paired<
        AddressTriple<MidpointExpected<Source.Left.Left, Source.Left.Right, ABTwice>,
                      MidpointExpected<Source.Right.Left, Source.Right.Right, CDTwice>,
                      MidpointExpected<Source.Left.Left, Source.Right.Left, ACTwice>>,
        AddressTriple<MidpointExpected<Source.Right.Right, Source.Left.Right, BDTwice>,
                      MidpointExpected<CD.Answer, AB.Answer, RowsTwice>,
                      MidpointExpected<AC.Answer, BD.Answer, ColumnsTwice>>>
}

// After the same eleven predecessor reads the calculated numerators
// are zero and one. Their common denominator after two levels is nine.
typealias MidpointSharedPrefix<N: IntegerValued> =
    N.Right.Right.Right.Right.Right.Right.Right.Right.Right.Right.Right
typealias BiasedMidpointPositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<MidpointSharedPrefix<BiasedMidpointTrace.Rows.Answer>,
           MidpointSharedPrefix<BiasedMidpointTrace.Columns.Answer>>, Never>

#if INTERACTION_LOCAL_MIDPOINTS_GLUE
enum RejectedLocalMidpointsGlue: Null {
    typealias Left = BiasedMidpointTrace.Rows.Answer
    typealias Right = BiasedMidpointTrace.Columns.Answer
}
#endif

// S31: regrouping ordinary equal divisions changes the endpoint weights.
// Both numerators have denominator four. Every addition begins at AddZero,
// and all six operand pairs are checked against the one addressed source.
enum RegroupedDivisionTrace: Null {
    typealias Source = AddressTriple<Never, Never, MidpointAdd4<Never>.Answer>
    typealias AB = AddZero<Source.Right.Left>
    typealias CC = MidpointAdd4<Source.Right.Right>
    typealias First = AddZero<CC.Answer>
    typealias AA = AddZero<Source.Left>
    typealias BC = AddZero<Source.Right.Right>
    typealias Second = AddZero<BC.Answer>
    typealias Left = Paired<
        AddressTriple<AB.Left, CC.Left, First.Left>,
        AddressTriple<AA.Left, BC.Left, Second.Left>>
    typealias Right = Paired<
        AddressTriple<Paired<Source.Left, Source.Right.Left>,
                     Paired<Source.Right.Right, Source.Right.Right>,
                     Paired<AB.Answer, CC.Answer>>,
        AddressTriple<Paired<Source.Left, Source.Left>,
                     Paired<Source.Right.Left, Source.Right.Right>,
                     Paired<AA.Answer, BC.Answer>>>
}

typealias RegroupedDivisionPositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<RegroupedDivisionTrace.Second.Answer.Right.Right.Right.Right,
           RegroupedDivisionTrace.First.Answer.Right.Right.Right.Right>,
    MidpointAdd3<Never>.Answer>

#if INTERACTION_CENTRE_ONLY_REGROUPING
enum RejectedCentreOnlyRegrouping: Null {
    typealias Left = RegroupedDivisionTrace.First.Answer
    typealias Right = RegroupedDivisionTrace.Second.Answer
}
#endif

// S32: a seven-position table carries right composition by R(t)=t+1
// at Left and D(t)=2t at Right. Only fields are rearranged. The two
// selectors generate the 21 affine maps used in the article.
enum SevenAffineFields<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, G: Structure>: Pair {
    typealias Fields = Paired<AddressTriple<A, B, C>, MatrixEntries<D, E, F, G>>
    typealias Left = SevenAffineFields<B, C, D, E, F, G, A>
    typealias Right = SevenAffineFields<A, C, E, G, B, D, F>
}

// These equalities follow for arbitrary resident fields. The source
// correspondence is kept through each right-composed application.
enum SevenAffineRelations<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, G: Structure>: Null {
    typealias Source = SevenAffineFields<A, B, C, D, E, F, G>
    typealias R7 = Source.Left.Left.Left.Left.Left.Left.Left
    typealias D3 = Source.Right.Right.Right
    typealias DR = Source.Right.Left
    typealias R2D = Source.Left.Left.Right
    typealias Left = AddressTriple<R7.Fields, D3.Fields, DR.Fields>
    typealias Right = AddressTriple<Source.Fields, Source.Fields, R2D.Fields>
}

// Centre candidates are verified by c a^-1 c=b on the same source
// table. Unique recovery of c is proved from the group square map in S32,
// not assumed from the names of these finite candidates.
enum ReversibleCentreCrossing: Null {
    typealias Source = SevenAffineFields<Never, Lit1, Lit2,
        MidpointAdd3<Never>.Answer, MidpointAdd4<Never>.Answer,
        MidpointAdd5<Never>.Answer, MidpointAdd5<Lit1>.Answer>
    typealias X = Source.Left
    typealias Y = Source.Right
    typealias XY = Source.Left.Left.Left.Left.Left.Right.Right
    typealias XYAfterInverseX = XY.Left.Left.Left.Left.Left.Left
    typealias XYReflection = XYAfterInverseX.Left.Left.Left.Left.Left.Right.Right
    typealias HalfX = Source.Left.Left.Left.Left
    typealias HalfXSquare = HalfX.Left.Left.Left.Left
    typealias HalfY = Source.Right.Right
    typealias HalfYSquare = HalfY.Right.Right
    typealias HalfXY = Source.Left.Left.Left.Left.Right
    typealias HalfXYSquare = HalfXY.Left.Left.Left.Left.Right
    typealias OfHalves = Source.Left.Left.Left.Left.Left.Right
    typealias OfHalvesAfterInverseHalfX = OfHalves.Left.Left.Left
    typealias OfHalvesReflection = OfHalvesAfterInverseHalfX.Left.Left.Left.Left.Left.Right
    typealias Left = Paired<
        AddressTriple<Source.Fields, XYReflection.Fields, HalfXSquare.Fields>,
        AddressTriple<HalfYSquare.Fields, HalfXYSquare.Fields, OfHalvesReflection.Fields>>
    typealias Right = Paired<
        AddressTriple<Source.Fields, Y.Fields, X.Fields>,
        AddressTriple<Y.Fields, XY.Fields, HalfY.Fields>>
}

// The zero-position images are four and five. After four predecessor
// readings the same two compositions retain a zero/successor contrast.
typealias ReversibleCentrePositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<ReversibleCentreCrossing.HalfXY.Fields.Left.Left.Right.Right.Right.Right,
           ReversibleCentreCrossing.OfHalves.Fields.Left.Left.Right.Right.Right.Right>, Never>

#if INTERACTION_REVERSIBLE_CENTRES_FORCE_MEDIAL
enum RejectedReversibleCentresMedial: Null {
    typealias Left = ReversibleCentreCrossing.HalfXY.Fields
    typealias Right = ReversibleCentreCrossing.OfHalves.Fields
}
#endif

// Two local projections retain a shared boundary. The paired
// source is coupled by B, not an unrestricted product of separate boundaries.
typealias CoupledContactOrders<X: Structure, B: Structure, Y: Structure> = IndependentContactOrders<
    FirstEvidenceImage<Paired<Paired<X, B>, B>, Never, Never, FirstProjection>,
    SecondEvidenceImage<Paired<B, Paired<B, Y>>, Never, Never, SecondProjection>
>

// LQ16: the output identities hold for arbitrary actual fields. The
// equality is derived in each body, rather than passed as a premise.
enum CutDiagonal<A: Structure, B: Structure>: Null {
    typealias X = Paired<A, B>
    typealias Left = PairRecombination<Paired<X, X>>.Right
    typealias Right = X
}

enum CutDiagonalRecoversSources<A: Structure, B: Structure>: Null {
    typealias X = Paired<A, B>
    typealias Output = PairRecombination<Paired<X, X>>.Right
    typealias Left = Paired<Output, Output>
    typealias Right = Paired<X, X>
}

typealias CutDiagonalHasReversedAgreement<A: Structure, B: Structure> = ReversedCutAgreement<
    Paired<Paired<A, B>, Paired<A, B>>
>

// Swapping the source places swaps the complementary outputs. Combined
// with CutExchangeReturns this recovers unordered pairs on both sides.
// It does not recover an ordered source after discarding output order.
enum CutExchangeTransportsSwap<X: Pair>: Null
where X.Left: Pair, X.Right: Pair,
      X.Left.Left: Structure, X.Left.Right: Structure,
      X.Right.Left: Structure, X.Right.Right: Structure {
    typealias Output = ResidentCutExchange<X>.Right
    typealias Left = ResidentCutExchange<Paired<X.Right, X.Left>>.Right
    typealias Right = Paired<Output.Right, Output.Left>
}

enum CutLeftAbsorption<X: Pair, Y: Pair, Z: Pair>: Null
where X.Left: Structure, Y.Right: Structure, Z.Right: Structure {
    typealias First = PairRecombination<Paired<X, Y>>.Right
    typealias Left = PairRecombination<Paired<First, Z>>.Right
    typealias Right = PairRecombination<Paired<X, Z>>.Right
}

enum CutRightAbsorption<X: Pair, Y: Pair, Z: Pair>: Null
where X.Left: Structure, Y.Left: Structure, Z.Right: Structure {
    typealias Second = PairRecombination<Paired<Y, Z>>.Right
    typealias Left = PairRecombination<Paired<X, Second>>.Right
    typealias Right = PairRecombination<Paired<X, Z>>.Right
}

enum CutExchangeReturns<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Source = Paired<Paired<A, B>, Paired<C, D>>
    typealias First = ResidentCutExchange<Source>
    typealias Left = ResidentCutExchange<First.Right>.Right
    typealias Right = Source
}

enum CutOutputsRecoverFields<X: Pair, Y: Pair>: Null
where X.Left: Pair, X.Right: Pair, Y.Left: Pair, Y.Right: Pair,
      X.Left.Left: Structure, X.Left.Right: Structure,
      X.Right.Left: Structure, X.Right.Right: Structure,
      Y.Left.Left: Structure, Y.Left.Right: Structure,
      Y.Right.Left: Structure, Y.Right.Right: Structure,
      ResidentCutExchange<X>.Right == ResidentCutExchange<Y>.Right {
    typealias Left = Paired<Paired<X.Left.Left, X.Left.Right>, Paired<X.Right.Left, X.Right.Right>>
    typealias Right = Paired<Paired<Y.Left.Left, Y.Left.Right>, Paired<Y.Right.Left, Y.Right.Right>>
}

enum CutForcesComplementaryContact<X: Pair>: Null
where X.Left: Pair, X.Right: Pair,
      X.Left.Left: Pair, X.Left.Right: Pair,
      X.Right.Left: Pair, X.Right.Right: Pair,
      X.Left.Left.Right == X.Left.Right.Left,
      X.Right.Left.Right == X.Right.Right.Left,
      X.Left.Left.Right == X.Right.Right.Left {
    typealias Exchange = EqualityContactCut<X>
    typealias Left = Exchange.Right.Right.Left.Right
    typealias Right = Exchange.Right.Right.Right.Left
}

enum CutCanExchangeContactsAgain<X: Pair>: Null
where X.Left: Pair, X.Right: Pair,
      X.Left.Left: Pair, X.Left.Right: Pair,
      X.Right.Left: Pair, X.Right.Right: Pair,
      X.Left.Left.Right == X.Left.Right.Left,
      X.Right.Left.Right == X.Right.Right.Left,
      X.Left.Left.Right == X.Right.Right.Left {
    typealias Second = EqualityContactCut<EqualityContactCut<X>.Right>
    typealias Left = Second.Right
    typealias Right = Paired<Paired<X.Left.Left, X.Left.Right>, Paired<X.Right.Left, X.Right.Right>>
}

// A legal output need not have a legal complementary output in the same
// admitted carrier. Both original vacancy witnesses are positive.
typealias CutVacancySource = Paired<Paired<Never, Lit1>, Paired<Lit1, Never>>
typealias CutFirstSourceAdmitted = FirstVacancy<AddressTriple<
    CutVacancySource.Left.Left, CutVacancySource.Left.Right, Lit1
>>
typealias CutSecondSourceAdmitted = SecondVacancy<AddressTriple<
    CutVacancySource.Right.Left, CutVacancySource.Right.Right, Lit1
>>
typealias CutVacancyExchange = ResidentCutExchange<CutVacancySource>
typealias CutMixedOutputAdmitted = FirstVacancy<AddressTriple<
    CutVacancyExchange.Right.Left.Left, CutVacancyExchange.Right.Left.Right, Lit1
>>

// Rebracketing must retain intermediate admission, not just final fields.
// For 00,10,01 the left path is admitted; the right intermediate is the
// same occupied complement refused by the two existing vacancy checks.
typealias CutBracketFirst = PairRecombination<Paired<Paired<Never, Never>, CutVacancySource.Right>>
typealias CutBracketLeft = PairRecombination<Paired<CutBracketFirst.Right, CutVacancySource.Left>>
typealias CutBracketLeftAdmitted = FirstVacancy<AddressTriple<
    CutBracketLeft.Right.Left, CutBracketLeft.Right.Right, Lit1
>>
enum CutRightBracketIsForbiddenComplement: Null {
    typealias Left = PairRecombination<Paired<CutVacancySource.Right, CutVacancySource.Left>>.Right
    typealias Right = CutVacancyExchange.Right.Right
}

typealias CutSourceZero = Paired<Paired<Never, Never>, Paired<Never, Never>>
typealias CutSourceChanged = Paired<Paired<Never, Lit1>, Paired<Never, Never>>
enum CutPrimaryOutputsAgree: Null {
    typealias Left = PairRecombination<CutSourceZero>.Right
    typealias Right = PairRecombination<CutSourceChanged>.Right
}
typealias CutComplementDistinguishes = ZeroSuccessorBoundaryPairClass<Paired<
    ResidentCutExchange<CutSourceZero>.Right.Right.Right,
    ResidentCutExchange<CutSourceChanged>.Right.Right.Right
>, Never>

// Nominal form identity is an additional distinction. A field-only map
// cannot promise to reconstruct an arbitrary nominal wrapper.
enum NominalCutSource: Pair {
    typealias Left = Paired<Never, Never>
    typealias Right = Paired<Never, Never>
}
enum CutNominalFieldsAgree: Null {
    typealias Left = ResidentCutExchange<NominalCutSource>.Right
    typealias Right = ResidentCutExchange<CutSourceZero>.Right
}

#if INTERACTION_CUT_PRIMARY_IDENTIFIES_SOURCE
enum RejectedCutPrimaryRecovery: Null {
    typealias Left = CutSourceZero
    typealias Right = CutSourceChanged
}
#endif
#if INTERACTION_CUT_UNORDERED_RESULT
typealias RejectedCutUnorderedResult = ReversedCutAgreement<CutVacancySource>
#endif
#if INTERACTION_CUT_COMPLEMENT_FIRST_VACANCY
typealias RejectedCutComplementFirst = FirstVacancy<AddressTriple<
    CutVacancyExchange.Right.Right.Left, CutVacancyExchange.Right.Right.Right, Lit1
>>
#endif
#if INTERACTION_CUT_COMPLEMENT_SECOND_VACANCY
typealias RejectedCutComplementSecond = SecondVacancy<AddressTriple<
    CutVacancyExchange.Right.Right.Left, CutVacancyExchange.Right.Right.Right, Lit1
>>
#endif
#if INTERACTION_CUT_ERASES_COMPLEMENT
enum RejectedCutComplementErasure: Null {
    typealias Left = ResidentCutExchange<CutSourceZero>.Right
    typealias Right = ResidentCutExchange<CutSourceChanged>.Right
}
#endif
#if INTERACTION_CUT_RECOVERS_NOMINAL_SHELL
enum RejectedCutNominalRecovery: Null {
    typealias Left = ResidentCutExchange<ResidentCutExchange<NominalCutSource>.Right>.Right
    typealias Right = NominalCutSource
}
#endif
#if INTERACTION_CUT_INDEPENDENT_SOURCE_CONTACTS_SUFFICE
typealias RejectedCutWithoutCrossContact = EqualityContactCut<Paired<
    Paired<Paired<Never, Never>, Paired<Never, Never>>,
    Paired<Paired<Never, Lit1>, Paired<Lit1, Never>>
>>
#endif

// LQ13: in the group contact d=a*b*c, the crossed rows (e,e)/(g,g) and
// columns (e,e)/(h,h) have three admitted corners. Here g*g=e, but
// g*h*g and h differ on the same three-field source.
enum AdjacentContactSwapReturns<X: Structure, Y: Structure, Z: Structure>: Null {
    typealias Source = AddressTriple<X, Y, Z>
    typealias G = SwapFirstTwoTriple<Source>
    typealias GG = SequentialReading<G, SwapFirstTwoTriple<G.Answer>>
    typealias GGG = SequentialReading<GG, SwapFirstTwoTriple<GG.Answer>>
    typealias H = PairedApplication<IdentityReading<X, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<Paired<Y, Z>>>
    typealias HH = SequentialReading<H,
        PairedApplication<IdentityReading<H.Answer.Left, BeamSpace, SaturationEncoding>,
            SwapBoundaryReading<H.Answer.Right>>>
    typealias Grouped = SequentialReading<GG, HH>
    typealias GHG = AdjacentSwapConjugation<X, Y, Z>.Reading
    typealias Interleaved = SequentialReading<GHG,
        LoopLastTwo<Z, Y, X>>
    // g²=e and g³=g also certify agreement of rows (e,e)/(g,g)
    // on partners e and g. The h partner below separates those rows.
    // Space §3a: both words use each involution twice, but their actual
    // intermediates force different results. No output rotation is a premise.
    typealias Left = Paired<AddressTriple<GG.Answer, HH.Answer, GGG.Answer>,
                            Paired<Grouped.Answer, Interleaved.Answer>>
    typealias Right = Paired<AddressTriple<Source, Source, G.Answer>,
                             Paired<Source, AddressTriple<Z, X, Y>>>
}
typealias CoupledReturnOrder = AdjacentContactSwapReturns<Never, Lit1, Lit2>
typealias CoupledReturnOrderReallyDiffers = ZeroSuccessorBoundaryPairClass<Paired<
    CoupledReturnOrder.Grouped.Answer.Left,
    CoupledReturnOrder.Interleaved.Answer.Left>, Lit1>
#if INTERACTION_SEPARATE_RETURNS_ERASE_ORDER
enum RejectedSeparateReturnsEraseOrder: Null {
    typealias Left = CoupledReturnOrder.Grouped.Answer
    typealias Right = CoupledReturnOrder.Interleaved.Answer
}
#endif
typealias CrossedConjugation = AdjacentSwapConjugation<Never, Lit1, Lit2>
typealias CrossedOriginalSwap = PairedApplication<
    IdentityReading<Never, BeamSpace, SaturationEncoding>,
    SwapBoundaryReading<Paired<Lit1, Lit2>>>
enum CrossedContactComparesSameSource: Null {
    typealias Left = CrossedConjugation.Reading.Left
    typealias Right = CrossedOriginalSwap.Left
}
typealias CrossedContactPositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<CrossedOriginalSwap.Answer.Left, CrossedConjugation.Reading.Answer.Left>, Lit1>

#if INTERACTION_CROSSED_SEAM_FROM_TWO_CUTS
enum RejectedCrossedSeamFromTwoCuts: Null {
    typealias Left = CrossedConjugation.Reading.Answer
    typealias Right = CrossedOriginalSwap.Answer
}
#endif

// LQ13: eight distinct resident fields expose a shared central exchange
// and different squares, computed from the actual pair applications.
typealias SquareField3 = Examples.Succ<Lit2>
typealias SquareField4 = Examples.Succ<SquareField3>
typealias SquareField5 = Examples.Succ<SquareField4>
typealias SquareField6 = Examples.Succ<SquareField5>
typealias SquareField7 = Examples.Succ<SquareField6>
typealias SquareContrast = SameCommutatorDifferentSquares<
    Never, Lit1, Lit2, SquareField3, SquareField4, SquareField5, SquareField6, SquareField7>
typealias SquareContrastPositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<SquareContrast.P2.Answer.Left.Left.Left, SquareContrast.I2.Answer.Left.Left.Left>, Never>
typealias ProductSquarePositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<SquareContrast.Source.Left.Left.Left, SquareContrast.PQ2.Answer.Left.Left.Left>, Never>

// LQ13 / IiS10: the same quarter phase on both complex modes commutes
// with mode exchange and relative sign. Rephasing each primitive by it
// changes its square from the source to the computed central exchange.
enum CommonQuarterRephasingChangesSquares<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Null {
    typealias S = SameCommutatorDifferentSquares<A, B, C, D, E, F, G, H>
    typealias RephasedP = SequentialReading<S.P, PairedQuarterTurn<
        S.ThirdAxis, S.FourthAxis, S.FirstAxis, S.SecondAxis>>
    typealias PhaseThenP = SequentialReading<S.I, SwapBoundaryReading<S.I.Answer>>
    typealias RephasedQ = SequentialReading<S.Q, PairedQuarterTurn<
        S.FirstAxis, S.SecondAxis, S.ReversedThird, S.ReversedFourth>>
    typealias PhaseThenQ = SequentialReading<S.I, LowerFrameFlip<
        S.SecondAxis, S.ReversedFirst, S.FourthAxis, S.ReversedThird>>
    typealias SecondP = SequentialReading<RephasedP,
        SwapBoundaryReading<RephasedP.Answer>>
    typealias SecondQ = SequentialReading<RephasedQ, LowerFrameFlip<
        S.SecondAxis, S.ReversedFirst, S.ReversedFourth, S.ThirdAxis>>
    typealias RephasedP2 = SequentialReading<SecondP, PairedQuarterTurn<
        S.SecondAxis, S.ReversedFirst, S.FourthAxis, S.ReversedThird>>
    typealias RephasedQ2 = SequentialReading<SecondQ, PairedQuarterTurn<
        S.SecondAxis, S.ReversedFirst, S.FourthAxis, S.ReversedThird>>
    typealias Left = MatrixEntries<RephasedP.Answer, RephasedQ.Answer,
        RephasedP2.Answer, RephasedQ2.Answer>
    typealias Right = MatrixEntries<PhaseThenP.Answer, PhaseThenQ.Answer,
        S.Z.Answer, S.Z.Answer>
}
typealias QuarterRephasingContrast = CommonQuarterRephasingChangesSquares<
    Never, Lit1, Lit2, SquareField3, SquareField4, SquareField5, SquareField6, SquareField7>
#if INTERACTION_QUARTER_REPHASING_PRESERVES_SQUARE
enum RejectedQuarterRephasingPreservesSquare: Null {
    typealias Left = QuarterRephasingContrast.RephasedP2.Answer
    typealias Right = QuarterRephasingContrast.S.P2.Answer
}
#endif

// IiS22: nine involutions, with commuting first two actions in each context.
// Products of the other five composite actions already compute their squares
// in FrameSquareProducts. No commutation or return is a caller premise.
enum FrameSquareContextOrders<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Null {
    typealias S = FrameSquare<A, B, C, D, E, F, G, H>
    typealias P = FrameSquareProducts<A, B, C, D, E, F, G, H>
    typealias X1Twice = SequentialReading<S.X1, FrameSquare<E, F, G, H, A, B, C, D>.X1>
    typealias X2Twice = SequentialReading<S.X2, FrameSquare<C, D, A, B, G, H, E, F>.X2>
    typealias Z1Twice = SequentialReading<S.Z1, FrameSquare<A, B, C, D, F, E, H, G>.Z1>
    typealias Z2Twice = SequentialReading<S.Z2, FrameSquare<A, B, D, C, E, F, H, G>.Z2>
    typealias R1 = SequentialReading<S.X2, FrameSquare<C, D, A, B, G, H, E, F>.X1>
    typealias R2 = SequentialReading<S.Z1, FrameSquare<A, B, C, D, F, E, H, G>.Z2>
    typealias R3 = SequentialReading<S.A32, FrameSquare<C, D, A, B, H, G, F, E>.A31>
    typealias C1 = SequentialReading<S.Z2, FrameSquare<A, B, D, C, E, F, H, G>.X1>
    typealias C2 = SequentialReading<S.Z1, FrameSquare<A, B, C, D, F, E, H, G>.X2>
    typealias C3 = SequentialReading<S.A23, FrameSquare<A, B, D, C, F, E, G, H>.A13>
    typealias Left = AddressTriple<
        MatrixEntries<X1Twice.Answer, X2Twice.Answer, Z1Twice.Answer, Z2Twice.Answer>,
        AddressTriple<R1.Answer, R2.Answer, R3.Answer>,
        AddressTriple<C1.Answer, C2.Answer, C3.Answer>
    >
    typealias Right = AddressTriple<
        MatrixEntries<P.Source, P.Source, P.Source, P.Source>,
        AddressTriple<S.A13.Answer, S.A23.Answer, S.A33.Answer>,
        AddressTriple<S.A31.Answer, S.A32.Answer, P.Column3Prefix.Answer>
    >
}

// Identifying the sixth return with its source forces all four resident
// frames to collapse. Their side equalities are consequences of that one
// proposed return, not four extra premises or a finite list of examples.
enum FrameSquareTrivialReturnCollapsesFrames<
    A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure
>: Null
where FrameSquareProducts<A, B, C, D, E, F, G, H>.Column3.Answer ==
      FrameSquareProducts<A, B, C, D, E, F, G, H>.Source {
    typealias Left = MatrixEntries<A, C, E, G>
    typealias Right = MatrixEntries<B, D, F, H>
}

typealias ContextSquareContrast = FrameSquareProducts<
    Never, Lit1, Lit2, SquareField3, SquareField4, SquareField5, SquareField6, SquareField7>
typealias ContextSquarePositiveRefusal = ZeroSuccessorBoundaryPairClass<
    Paired<ContextSquareContrast.Source.Left.Left.Left,
        ContextSquareContrast.Column3.Answer.Left.Left.Left>, Never>
typealias CollapsedContextSquare = FrameSquareProducts<Never, Never, Lit1, Lit1, Lit2, Lit2, Never, Never>
enum CollapsedFramesAdmitTrivialReturn: Null {
    typealias Left = CollapsedContextSquare.Column3.Answer
    typealias Right = CollapsedContextSquare.Source
}

#if INTERACTION_CONTEXT_SQUARE_ERASES_RETURN
enum RejectedContextSquareReturn: Null {
    typealias Left = ContextSquareContrast.Column3.Answer
    typealias Right = ContextSquareContrast.Source
}
#endif

#if INTERACTION_CONTEXT_SQUARE_RESTARTS_SOURCE
typealias RejectedContextSquareSource = SequentialReading<
    ContextSquareContrast.Square.A31, ContextSquareContrast.Square.A32>
#endif

#if INTERACTION_PAIRING_DETERMINES_SQUARE
enum RejectedPairingDeterminesSquare: Null {
    typealias Left = SquareContrast.P2.Answer
    typealias Right = SquareContrast.I2.Answer
}
#endif

// Local returns P²=Q²=id do not authorize (PQ)²=id. The same actual
// compositions force the retained central exchange in the combined square.
#if INTERACTION_LOCAL_SQUARES_ERASE_CROSSING
enum RejectedLocalSquaresEraseCrossing: Null {
    typealias Left = SquareContrast.PQ2.Answer
    typealias Right = SquareContrast.Source
}
#endif

// Three actual equality contacts derive the fourth boundary equality.
typealias ThreeCornerCodes = Paired<Paired<Never, Never>, Paired<Never, Never>>
typealias ForcedFourthContact = ThreeContactsForceFourth<ThreeCornerCodes>
typealias FourthContactAgrees = AgreedBoundaryPairClass<
    Paired<ForcedFourthContact.Left, ForcedFourthContact.Right>
>

// The actual vacancy relation remains expressible. Its occupied third
// coordinate prevents that coordinate from supplying a spurious witness.
typealias PairVacancy00First = FirstVacancy<AddressTriple<Never, Never, Lit1>>
typealias PairVacancy00Second = SecondVacancy<AddressTriple<Never, Never, Lit1>>
typealias PairVacancy01 = FirstVacancy<AddressTriple<Never, Lit1, Lit1>>
typealias PairVacancy10 = SecondVacancy<AddressTriple<Lit1, Never, Lit1>>

#if INTERACTION_CONTACT_FOURTH_CORNER_DIFFERS
typealias RejectedFourthCornerSeparation = ZeroSuccessorBoundaryPairClass<
    Paired<ForcedFourthContact.Left, ForcedFourthContact.Right>, Never
>
#endif

enum ContactExchangeReturns<A: Structure, B: Structure, C: Structure, S: Structure>: Null {
    typealias Original = Paired<Paired<Paired<A, S>, Paired<S, C>>, Paired<B, S>>
    typealias First = ResidentContactExchange<Original>
    typealias Second = ResidentContactExchange<First.Right>
    typealias Left = Second.Right
    typealias Right = Original
}

enum ContactExchangeKeepsPartner<X: Pair>: Null
where X.Left: Pair, X.Left.Left: Pair, X.Left.Right: Pair, X.Right: Pair,
      X.Left.Left.Right == X.Left.Right.Left,
      X.Right.Right == X.Left.Right.Left {
    typealias Left = ResidentContactExchange<X>.Right.Left.Right
    typealias Right = X.Left.Right
}

enum ContactExchangeKeepsOldLocal<X: Pair>: Null
where X.Left: Pair, X.Left.Left: Pair, X.Left.Right: Pair, X.Right: Pair,
      X.Left.Left.Right == X.Left.Right.Left,
      X.Right.Right == X.Left.Right.Left {
    typealias Left = ResidentContactExchange<X>.Right.Right
    typealias Right = X.Left.Left
}

// Project the same application onto its actual contact endpoints. The
// generic conservation result consumes those endpoints, not a new promise.
typealias ContactExchangeBoundary<X: Pair> = RetainedPartnerForcesBoundary<
    Paired<X.Left, ResidentContactExchange<X>.Right.Left>
>
where X.Left: Pair, X.Left.Left: Pair, X.Left.Right: Pair, X.Right: Pair,
      X.Left.Left.Right == X.Left.Right.Left,
      X.Right.Right == X.Left.Right.Left

typealias ZeroContact = Paired<Paired<Never, Never>, Paired<Never, Lit1>>
typealias ChangedInterior = ResidentContactExchange<Paired<ZeroContact, Paired<Lit1, Never>>>
typealias ContactInteriorDiffers = ZeroSuccessorDistinction<Never>
enum ContactReallyChangesInterior: Null {
    typealias Left = Paired<ChangedInterior.Left.Left.Left.Left, ChangedInterior.Right.Left.Left.Left>
    typealias Right = Paired<ContactInteriorDiffers.Left, ContactInteriorDiffers.Right>
}

#if INTERACTION_CONTACT_WRONG_RESERVE
typealias RejectedContactReserve = ResidentContactExchange<
    Paired<ZeroContact, Paired<Never, Lit1>>
>
#endif
#if INTERACTION_CONTACT_BROKEN_SOURCE
typealias RejectedBrokenContact = ResidentContactExchange<Paired<
    Paired<Paired<Never, Lit1>, Paired<Never, Never>>, Paired<Lit1, Never>
>>
#endif
#if INTERACTION_CONTACT_ERASES_RESERVE
enum RejectedContactReserveErasure: Null {
    typealias Left = ChangedInterior.Right.Right
    typealias Right = Paired<Lit1, Never>
}
#endif
#if INTERACTION_CONTACT_RETAINS_CHANGED_PARTNER
typealias RejectedChangedPartner = RetainedPartnerForcesBoundary<Paired<
    ZeroContact, Paired<Paired<Never, Lit1>, Paired<Lit1, Lit1>>
>>
#endif

// VC23b: all three witnesses exist at one symmetric source. A valid clause
// does not determine which clause should supply a distinguished position.
typealias VacantTriple = AddressTriple<Never, Never, Never>
typealias OccupiedTriple = AddressTriple<Lit1, Lit1, Lit1>
typealias VacancyFirst = FirstVacancy<VacantTriple>
typealias VacancySecond = SecondVacancy<VacantTriple>
typealias VacancyThird = ThirdVacancy<VacantTriple>
typealias VacancyChoicesDiffer = SuccessorZeroBoundaryPairClass<
    Paired<VacancyFirst.Right.Left, VacancySecond.Right.Left>, Never
>

enum VacancyInputIsSwapFixed: Null {
    typealias Left = SwapFirstTwoTriple<VacantTriple>.Answer
    typealias Right = VacantTriple
}

// A change of positions transports the clause and its actual source.
// The selected answer changes with it, rather than remaining first.
enum VacancyClauseTransport<A: Structure, B: Structure>: Null {
    typealias X = AddressTriple<Never, A, B>
    typealias Left = SwapFirstTwoTriple<FirstVacancy<X>.Right>.Answer
    typealias Right = SecondVacancy<SwapFirstTwoTriple<X>.Answer>.Right
}

enum ThirdVacancyClauseTransport<A: Structure, B: Structure>: Null {
    typealias X = AddressTriple<A, B, Never>
    typealias Left = SwapFirstTwoTriple<ThirdVacancy<X>.Right>.Answer
    typealias Right = ThirdVacancy<SwapFirstTwoTriple<X>.Answer>.Right
}

typealias RotatedVacancyCoordinates<X: Pair> = Paired<RotateThree<X>.Left, RotateThree<X>.Right>
where X.Left: Structure, X.Right: Pair,
      X.Right.Left: Structure, X.Right.Right: Structure

enum VacancyClauseRotates<A: Structure, B: Structure>: Null {
    typealias X = AddressTriple<Never, A, B>
    typealias Left = RotatedVacancyCoordinates<FirstVacancy<X>.Right>
    typealias Right = ThirdVacancy<RotatedVacancyCoordinates<X>>.Right
}

// Retaining the whole vacancy pattern instead of choosing a position
// respects readdressing. For binary coordinates it attains VC23b's bound
// under all permutations. The general minimality proof is in the paper.
enum CompleteVacancyPatternTransports<X: Pair>: Null
where X.Left: Structure, X.Right: Pair,
      X.Right.Left: Structure, X.Right.Right: Structure {
    typealias Original = IdentityReading<X, BeamSpace, SaturationEncoding>
    typealias Changed = IdentityReading<SwapFirstTwoTriple<X>.Answer, BeamSpace, SaturationEncoding>
    typealias Left = SwapFirstTwoTriple<Original.Answer>.Answer
    typealias Right = Changed.Answer
}

// The two zero positions in 001 have no distinguished member under their
// exchange. A fixed first-position choice is valid, but not equivariant.
typealias TwoVacancies = AddressTriple<Never, Never, Lit1>
enum TwoVacanciesAreSwapFixed: Null {
    typealias Left = SwapFirstTwoTriple<TwoVacancies>.Answer
    typealias Right = TwoVacancies
}

// In the declared cyclic order, take the zero immediately before the one.
// These three source-bound choices rotate together. The all-vacant source
// instead needs the rotation-fixed mask selecting every vacancy.
typealias CyclicVacancy001 = SecondVacancy<TwoVacancies>
typealias CyclicVacancy010 = FirstVacancy<AddressTriple<Never, Lit1, Never>>
typealias CyclicVacancy100 = ThirdVacancy<AddressTriple<Lit1, Never, Never>>
enum CyclicVacancyChoicesTransport: Null {
    typealias Left = AddressTriple<
        RotatedVacancyCoordinates<CyclicVacancy001.Right>,
        RotatedVacancyCoordinates<CyclicVacancy010.Right>,
        RotatedVacancyCoordinates<CyclicVacancy100.Right>
    >
    typealias Right = AddressTriple<
        CyclicVacancy010.Right, CyclicVacancy100.Right, CyclicVacancy001.Right
    >
}
enum EveryVacancyMaskIsRotationFixed: Null {
    typealias Left = RotatedVacancyCoordinates<OccupiedTriple>
    typealias Right = OccupiedTriple
}

// Each state after two distinct fillings has a directly checked vacancy.
// The final 111 has none of these three clauses. M67's capacity extension
// proves this obstruction for any bounded depth and reversible toggles.
typealias PairFill12 = ThirdVacancy<AddressTriple<Lit1, Lit1, Never>>
typealias PairFill13 = SecondVacancy<AddressTriple<Lit1, Never, Lit1>>
typealias PairFill23 = FirstVacancy<AddressTriple<Never, Lit1, Lit1>>

#if INTERACTION_FULL_FIRST_VACANCY
typealias RejectedFullFirstVacancy = FirstVacancy<OccupiedTriple>
#endif
#if INTERACTION_FULL_SECOND_VACANCY
typealias RejectedFullSecondVacancy = SecondVacancy<OccupiedTriple>
#endif
#if INTERACTION_FULL_THIRD_VACANCY
typealias RejectedFullThirdVacancy = ThirdVacancy<OccupiedTriple>
#endif
#if INTERACTION_VALID_CHOICE_IS_EQUIVARIANT
enum RejectedVacancyChoiceEquivariance: Null {
    typealias Left = FirstVacancy<SwapFirstTwoTriple<TwoVacancies>.Answer>.Right
    typealias Right = SwapFirstTwoTriple<FirstVacancy<TwoVacancies>.Right>.Answer
}
#endif
#if INTERACTION_CYCLIC_WITNESS_REFLECTION
enum RejectedCyclicVacancyReflection: Null {
    typealias Left = CyclicVacancy001.Right
    typealias Right = SwapFirstTwoTriple<CyclicVacancy001.Right>.Answer
}
#endif

// Generic premises mention source fields only. The quotient output square
// and preservation of the current answer are derived inside each witness.
typealias ConstantClassSquare<B: BeamShape> = RepeatClassTransition<B>
where B.AlphaLevel == B.PaschenLevel, B.AlphaLevel == B.BetaLevel

typealias ZeroSuccessorClassSquare<B: BeamShape, N: IntegerValued> = ZeroSuccessorClassTransition<B, N>
where B.AlphaLevel == Never, B.BetaLevel == Examples.Succ<N>, B.PaschenLevel == Never

typealias SuccessorZeroClassSquare<B: BeamShape, N: IntegerValued> = SuccessorZeroClassTransition<B, N>
where B.AlphaLevel == Examples.Succ<N>, B.BetaLevel == Never, B.PaschenLevel == Examples.Succ<N>

enum ReadyClassKeepsAlpha<B: BeamShape>: Null
where B.AlphaLevel == B.PaschenLevel {
    typealias Left = ReadRecordedAnswer<ReadyClassReading<B>.Answer>.Answer
    typealias Right = B.AlphaLevel
}

enum ZeroBlockedClassKeepsAlpha<B: BeamShape, N: IntegerValued>: Null
where B.AlphaLevel == Never, B.PaschenLevel == Examples.Succ<N> {
    typealias Left = ReadRecordedAnswer<ZeroBlockedClassReading<B, N>.Answer>.Answer
    typealias Right = B.AlphaLevel
}

enum SuccessorBlockedClassKeepsAlpha<B: BeamShape, N: IntegerValued>: Null
where B.AlphaLevel == Examples.Succ<N>, B.PaschenLevel == Never {
    typealias Left = ReadRecordedAnswer<SuccessorBlockedClassReading<B, N>.Answer>.Answer
    typealias Right = B.AlphaLevel
}

enum ZeroObstructionUsesSource<B: BeamShape, N: IntegerValued>: Null
where B.AlphaLevel == Never, B.PaschenLevel == Examples.Succ<N> {
    typealias O = ZeroBlockedClassFactors<B, N>.Right.Obstruction
    typealias Left = Paired<O.Left, O.Right>
    typealias Right = Paired<B.AlphaLevel, B.PaschenLevel>
}

enum SuccessorObstructionUsesSource<B: BeamShape, N: IntegerValued>: Null
where B.AlphaLevel == Examples.Succ<N>, B.PaschenLevel == Never {
    typealias O = SuccessorBlockedClassFactors<B, N>.Right.Obstruction
    typealias Left = Paired<O.Left, O.Right>
    typealias Right = Paired<B.AlphaLevel, B.PaschenLevel>
}

enum ClassBeam<A: IntegerValued, B: IntegerValued, C: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = B
    typealias PaschenLevel = C
}

// The exhaustive binary classification is a list of type applications, not
// a runtime table. The minimality argument is VC49, not a count from a script.
typealias Class000 = ReadyClassReading<ClassBeam<Never, Never, Never>>.Answer
typealias Class001 = ZeroBlockedClassReading<ClassBeam<Never, Never, Lit1>, Never>.Answer
typealias Class010 = ReadyClassReading<ClassBeam<Never, Lit1, Never>>.Answer
typealias Class011 = ZeroBlockedClassReading<ClassBeam<Never, Lit1, Lit1>, Never>.Answer
typealias Class100 = SuccessorBlockedClassReading<ClassBeam<Lit1, Never, Never>, Never>.Answer
typealias Class101 = ReadyClassReading<ClassBeam<Lit1, Never, Lit1>>.Answer
typealias Class110 = SuccessorBlockedClassReading<ClassBeam<Lit1, Lit1, Never>, Never>.Answer
typealias Class111 = ReadyClassReading<ClassBeam<Lit1, Lit1, Lit1>>.Answer

enum BlockedZeroDiscardsBeta<B: IntegerValued, C: IntegerValued, N: IntegerValued>: Null {
    typealias Left = ZeroBlockedClassReading<ClassBeam<Never, B, Examples.Succ<N>>, N>.Answer
    typealias Right = ZeroBlockedClassReading<ClassBeam<Never, C, Examples.Succ<N>>, N>.Answer
}

enum BlockedSuccessorDiscardsBeta<B: IntegerValued, C: IntegerValued, N: IntegerValued>: Null {
    typealias Left = SuccessorBlockedClassReading<ClassBeam<Examples.Succ<N>, B, Never>, N>.Answer
    typealias Right = SuccessorBlockedClassReading<ClassBeam<Examples.Succ<N>, C, Never>, N>.Answer
}

typealias ClassStep000 = ConstantClassSquare<ClassBeam<Never, Never, Never>>
typealias ClassStep010 = ZeroSuccessorClassSquare<ClassBeam<Never, Lit1, Never>, Never>
typealias ClassStep101 = SuccessorZeroClassSquare<ClassBeam<Lit1, Never, Lit1>, Never>
typealias ClassStep111 = ConstantClassSquare<ClassBeam<Lit1, Lit1, Lit1>>

// Each remaining distinction has a named observation: the present answer,
// an available action, or the answer after that action. No global Boolean
// valuation or inhabitance of these caseless proof objects is requested.
#if INTERACTION_IDENTIFIES_ZERO_SUCCESSOR
enum RejectedZeroSuccessorEquality<N: IntegerValued>: Null {
    typealias Left = ZeroSuccessorDistinction<N>.Left
    typealias Right = ZeroSuccessorDistinction<N>.Right
}
#endif

#if INTERACTION_BLOCKS_EQUAL_FIELDS
typealias RejectedEqualFieldsBlocked = ZeroBlockedClassReading<ClassBeam<Never, Lit1, Never>, Never>
#endif

#if INTERACTION_MERGES_READY_FUTURES
enum RejectedReadyFutureMerger: Null {
    typealias Left = Class000
    typealias Right = Class010
}
#endif

#if INTERACTION_MERGES_AVAILABILITY
enum RejectedAvailabilityMerger: Null {
    typealias Left = Class001
    typealias Right = Class000
}
#endif

#if INTERACTION_WRONG_CLASS_SUCCESSOR
enum RejectedClassSuccessor: Null {
    typealias Left = ClassStep010.ImageStep.Answer
    typealias Right = Class101
}
#endif

#if INTERACTION_READY_STEP_FROM_BLOCKED
typealias RejectedReadyFromBlocked = SequentialReading<
    ZeroBlockedClassReading<ClassBeam<Never, Never, Lit1>, Never>,
    RepeatReadyImage<Never>
>
#endif

// Fixture records isolate the output-square equations from domain reflection.
enum InteractionReading<S, E, P, A, Candidate>: PredicateReading {
    typealias Left = Candidate
    typealias Right = A
    typealias Sigma = S
    typealias Encoding = E
    typealias Predicate = P
    typealias Answer = A
}

// A successful square alone need not reflect an operation's domain. This
// image step swaps every visible pair, including one from a disabled source.
enum VisibleSuccessSquare<B: BeamShape>: CommutingTransition
where B.AlphaLevel == B.PaschenLevel {
    typealias Left = VisibleReading<B>
    typealias Right = VisibleReading<SwapVisible<B>>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Operation = MatchedSwapOperation
    typealias SourceStep = InteractionReading<BeamSpace, EyeEncoding, MatchedSwapOperation, SwapVisible<B>, B>
    typealias ImageStep = InteractionReading<BeamSpace, EyeEncoding, MatchedSwapOperation, SwapImageReading<EyeImage<B>>.Answer, EyeImage<B>>
}

typealias EnabledExample = MatchedSwapTransition<RedBeamWithIR>
typealias SuccessfulVisibleExample = VisibleSuccessSquare<RedBeamWithIR>

enum EnabledAndDisabledShareVisibleImage: Null {
    typealias Left = EyeImage<RedBeamWithIR>
    typealias Right = EyeImage<RedBeam>
}

// Equal complete images transfer the resident condition, not just the result.
enum AvailableStepTransfers<A: BeamShape, B: BeamShape>: VerdictIsInvariant
where FullSpectrumImage<A> == FullSpectrumImage<B>,
      A.AlphaLevel == A.PaschenLevel {
    typealias Left = MatchedSwapTransition<A>.Right
    typealias Right = MatchedSwapTransition<B>.Right
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = FullSpectrumQuestion
    typealias Answer = Left.Answer
}

// The converse also constructs an enabled source step from the image condition.
enum ImageConditionEnablesSource<B: BeamShape>: Null
where FullSpectrumImage<B>.Left == FullSpectrumImage<B>.Right.Right {
    typealias Left = MatchedSwapSource<B>.Answer
    typealias Right = SwapVisible<B>
}

enum AvailableImageUpdateFollows<B: BeamShape>: Null
where B.AlphaLevel == B.PaschenLevel {
    typealias Left = MatchedSwapTransition<B>.ImageStep.Answer
    typealias Right = FullSpectrumImage<SwapVisible<B>>
}

enum SuccessorConditionUsesOldBeta<B: BeamShape>: Null {
    typealias Left = Paired<SwapVisible<B>.AlphaLevel, SwapVisible<B>.PaschenLevel>
    typealias Right = Paired<B.BetaLevel, B.PaschenLevel>
}

enum UniformMatch<L: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = L
    typealias BetaLevel = L
    typealias PaschenLevel = L
}

typealias RepeatableExample<L: IntegerValued> = TwiceMatchedSwap<UniformMatch<L>>

// The disabled middle source agrees at the only word it permits: the empty
// one. The two enabled sources have different answers after the guarded swap.
typealias LeftCommonAnswer = JoinedVerdict<
    SpectrumAlphaSource<UniformMatch<Lit1>>,
    SpectrumAlphaSource<RedBeam>
>
typealias RightCommonAnswer = JoinedVerdict<
    SpectrumAlphaSource<RedBeam>,
    SpectrumAlphaSource<RedBeamWithIR>
>

enum TwoAvailableStepsReturnImage<B: BeamShape>: Null
where B.AlphaLevel == B.PaschenLevel, B.BetaLevel == B.PaschenLevel {
    typealias Left = TwiceMatchedSwap<B>.Right.Answer
    typealias Right = FullSpectrumImage<B>
}

typealias AcquiredAvailableFuture<B: BeamShape & Structure> = AnswerFromAcquiredObservation<AlphaAfterMatchedSwap<B>>
where B.AlphaLevel == B.PaschenLevel

enum AvailableFutureUsesAcquiredFact<B: BeamShape & Structure>: Null
where B.AlphaLevel == B.PaschenLevel {
    typealias Left = AcquiredAvailableFuture<B>.Right.Left
    typealias Right = FactOf<FullSpectrumReading<B>>
}

enum AvailableFutureAnswerFollows<B: BeamShape & Structure>: Null
where B.AlphaLevel == B.PaschenLevel {
    typealias Left = AcquiredAvailableFuture<B>.Right.Answer
    typealias Right = B.BetaLevel
}

typealias UnguardedFuture = QuestionAlongTransition<
    SpectrumFirstTransition<RedBeam>,
    SpectrumAlphaFactors<SwapVisible<RedBeam>>
>

// The total extension gives the same value at the disabled source. It does
// not establish availability of the differently specified guarded question.
enum SameSwapValueDoesNotSupplyAvailability: Null {
    typealias Left = AlphaAfterMatchedSwap<RedBeamWithIR>.Answer
    typealias Right = UnguardedFuture.Answer
}

#if INTERACTION_DISABLED_SOURCE
typealias RejectedDisabledSource = MatchedSwapTransition<RedBeam>
#endif

#if INTERACTION_DISABLED_IMAGE
typealias RejectedDisabledImage = MatchedSwapImage<FullSpectrumImage<RedBeam>>
#endif

#if INTERACTION_REPEAT_AFTER_GUARD_CHANGES
typealias RejectedRepeatedMatch = TwiceMatchedSwap<RedBeamWithIR>
#endif

#if INTERACTION_REUSES_OLD_SOURCE_STEP
typealias RejectedOldStep = JoinedTransition<EnabledExample, EnabledExample>
#endif

#if INTERACTION_VISIBLE_IMAGE_INVENTS_AVAILABILITY
typealias RejectedVisiblePermission<A: BeamShape, B: BeamShape> = MatchedSwapTransition<B>
where EyeImage<A> == EyeImage<B>, A.AlphaLevel == A.PaschenLevel
#endif

#if INTERACTION_ERASES_ACTION_CONDITION
enum RejectedGuardedAsUnguardedQuestion: Null {
    typealias Left = AlphaAfterMatchedSwap<RedBeamWithIR>.Predicate
    typealias Right = UnguardedFuture.Predicate
}
#endif

#if INTERACTION_SHARED_FUTURES_ARE_TRANSITIVE
typealias RejectedCommonFutureTransitivity = JoinedVerdict<
    AlphaAfterMatchedSwap<UniformMatch<Lit1>>.Left,
    AlphaAfterMatchedSwap<RedBeamWithIR>.Left
>
#endif
