import VerificationIsIdentification

// Exact two-block operator tracking for one data qubit and its owned coherent
// control. R is public; neither an actual control bit nor an input state is a
// type parameter. These constructors describe operators on both control blocks.
// Their external interpretation, including ownership of the physical carrier,
// is a separate finite primitive contract.

public protocol CoherentPhase: Open {
    associatedtype TimesI: CoherentPhase
    associatedtype Negated: CoherentPhase
}

public enum CoherentPhase0: Close, CoherentPhase {
    public typealias TimesI = CoherentPhase1
    public typealias Negated = CoherentPhase2
}

public enum CoherentPhase1: Close, CoherentPhase {
    public typealias TimesI = CoherentPhase2
    public typealias Negated = CoherentPhase3
}

public enum CoherentPhase2: Close, CoherentPhase {
    public typealias TimesI = CoherentPhase3
    public typealias Negated = CoherentPhase0
}

public enum CoherentPhase3: Close, CoherentPhase {
    public typealias TimesI = CoherentPhase0
    public typealias Negated = CoherentPhase1
}

/// The normal form is i^k X^a Z^b. In particular XZ is literal X times Z,
/// so Y = i XZ. Multiplication and conjugation below retain scalar phases.
public protocol CoherentBlock: Open {
    associatedtype Phase: CoherentPhase
    associatedtype Word: Pair
    associatedtype LeftX: CoherentBlock
    associatedtype LeftZ: CoherentBlock
    associatedtype ConjugatedH: CoherentBlock
    associatedtype ConjugatedS: CoherentBlock
    associatedtype TimesI: CoherentBlock
}

public typealias CoherentIdentityWord = Paired<QBit0, QBit0>

public enum CoherentI<K: CoherentPhase>: Close, CoherentBlock {
    public typealias Phase = K
    public typealias Word = Paired<QBit0, QBit0>
    public typealias LeftX = CoherentX<K>
    public typealias LeftZ = CoherentZ<K>
    public typealias ConjugatedH = CoherentI<K>
    public typealias ConjugatedS = CoherentI<K>
    public typealias TimesI = CoherentI<K.TimesI>
}

public enum CoherentX<K: CoherentPhase>: Close, CoherentBlock {
    public typealias Phase = K
    public typealias Word = Paired<QBit1, QBit0>
    public typealias LeftX = CoherentI<K>
    public typealias LeftZ = CoherentXZ<K.Negated>
    public typealias ConjugatedH = CoherentZ<K>
    public typealias ConjugatedS = CoherentXZ<K.TimesI>
    public typealias TimesI = CoherentX<K.TimesI>
}

public enum CoherentZ<K: CoherentPhase>: Close, CoherentBlock {
    public typealias Phase = K
    public typealias Word = Paired<QBit0, QBit1>
    public typealias LeftX = CoherentXZ<K>
    public typealias LeftZ = CoherentI<K>
    public typealias ConjugatedH = CoherentX<K>
    public typealias ConjugatedS = CoherentZ<K>
    public typealias TimesI = CoherentZ<K.TimesI>
}

public enum CoherentXZ<K: CoherentPhase>: Close, CoherentBlock {
    public typealias Phase = K
    public typealias Word = Paired<QBit1, QBit1>
    public typealias LeftX = CoherentZ<K>
    public typealias LeftZ = CoherentX<K.Negated>
    public typealias ConjugatedH = CoherentXZ<K.Negated>
    public typealias ConjugatedS = CoherentX<K.TimesI>
    public typealias TimesI = CoherentXZ<K.TimesI>
}

/// An exact but deliberately incomplete word reduction: H^2 = I and S^4 = I.
/// A missing target-word witness is not a proof that the operators differ.
/// Word is the actual reduced stack's finite syntax, used by the witnesses.
public protocol CoherentIdeal: Open {
    associatedtype Word: Structure
    associatedtype AfterH: CoherentIdeal
    associatedtype AfterS: CoherentIdeal
}

public enum CoherentIdealHSymbol: Close {}
public enum CoherentIdealS1Symbol: Close {}
public enum CoherentIdealS2Symbol: Close {}
public enum CoherentIdealS3Symbol: Close {}

public enum CoherentIdealEmpty: Close, CoherentIdeal {
    public typealias Word = Never
    public typealias AfterH = CoherentIdealH<CoherentIdealEmpty>
    public typealias AfterS = CoherentIdealS1<CoherentIdealEmpty>
}

public enum CoherentIdealH<T: CoherentIdeal>: Close, CoherentIdeal {
    public typealias Tail = T
    public typealias Word = Paired<CoherentIdealHSymbol, Tail.Word>
    public typealias AfterH = Tail
    public typealias AfterS = CoherentIdealS1<CoherentIdealH<Tail>>
}

public enum CoherentIdealS1<T: CoherentIdeal>: Close, CoherentIdeal {
    public typealias Tail = T
    public typealias Word = Paired<CoherentIdealS1Symbol, Tail.Word>
    public typealias AfterH = CoherentIdealH<CoherentIdealS1<Tail>>
    public typealias AfterS = CoherentIdealS2<Tail>
}

public enum CoherentIdealS2<T: CoherentIdeal>: Close, CoherentIdeal {
    public typealias Tail = T
    public typealias Word = Paired<CoherentIdealS2Symbol, Tail.Word>
    public typealias AfterH = CoherentIdealH<CoherentIdealS2<Tail>>
    public typealias AfterS = CoherentIdealS3<Tail>
}

public enum CoherentIdealS3<T: CoherentIdeal>: Close, CoherentIdeal {
    public typealias Tail = T
    public typealias Word = Paired<CoherentIdealS3Symbol, Tail.Word>
    public typealias AfterH = CoherentIdealH<CoherentIdealS3<Tail>>
    public typealias AfterS = Tail
}

public enum CoherentOwnedResident<Owner: Structure>: Close {}

/// Each actual branch operator is Block_t times the common Ideal operator.
/// Resident names current availability and is distinct from the two blocks.
public protocol CoherentProgram: Pair
where Right == Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>> {
    associatedtype Public: QuantumBit
    associatedtype Owner: Structure
    associatedtype Resident: Structure
    associatedtype Block0: CoherentBlock
    associatedtype Block1: CoherentBlock
    associatedtype Ideal: CoherentIdeal
}

public enum CoherentSourceStart<R: QuantumBit>: CoherentProgram {
    public typealias Public = R
    public typealias Owner = CoherentSourceStart<R>
    public typealias Resident = CoherentOwnedResident<Owner>
    public typealias Left = R
    public typealias Block0 = CoherentI<CoherentPhase0>
    public typealias Block1 = CoherentI<CoherentPhase0>
    public typealias Ideal = CoherentIdealEmpty
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// Use the same currently owned control as a Z control on the data.
public enum CoherentCZ<P: CoherentProgram>: CoherentProgram
where P.Resident == CoherentOwnedResident<P.Owner> {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0
    public typealias Block1 = Previous.Block1.LeftZ
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// Use the same currently owned control as an X control on the data.
public enum CoherentCX<P: CoherentProgram>: CoherentProgram
where P.Resident == CoherentOwnedResident<P.Owner> {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0
    public typealias Block1 = Previous.Block1.LeftX
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// Act by H on the data: conjugate each residual and update the ideal word.
public enum CoherentH<P: CoherentProgram>: CoherentProgram {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0.ConjugatedH
    public typealias Block1 = Previous.Block1.ConjugatedH
    public typealias Ideal = Previous.Ideal.AfterH
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// Act by S on the data. An S dagger is the actual three-S composition.
public enum CoherentS<P: CoherentProgram>: CoherentProgram {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0.ConjugatedS
    public typealias Block1 = Previous.Block1.ConjugatedS
    public typealias Ideal = Previous.Ideal.AfterS
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// The publicly known exponent is zero, so this public X application is identity.
public enum CoherentPublicX0<P: CoherentProgram>: CoherentProgram
where P.Public == QBit0 {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0
    public typealias Block1 = Previous.Block1
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// The publicly known exponent is one, so X acts on both control blocks.
public enum CoherentPublicX1<P: CoherentProgram>: CoherentProgram
where P.Public == QBit1 {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0.LeftX
    public typealias Block1 = Previous.Block1.LeftX
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// The publicly known exponent is zero, so this public Z application is identity.
public enum CoherentPublicZ0<P: CoherentProgram>: CoherentProgram
where P.Public == QBit0 {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0
    public typealias Block1 = Previous.Block1
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// The publicly known exponent is one, so Z acts on both control blocks.
public enum CoherentPublicZ1<P: CoherentProgram>: CoherentProgram
where P.Public == QBit1 {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0.LeftZ
    public typealias Block1 = Previous.Block1.LeftZ
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// Act by S on the actual memory carrier: only its one block acquires i.
public enum CoherentMemoryS<P: CoherentProgram>: CoherentProgram
where P.Resident == CoherentOwnedResident<P.Owner> {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Previous.Resident
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0
    public typealias Block1 = Previous.Block1.TimesI
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// Withdraw the control port. This declares loss of access, not physical erasure.
public enum CoherentWithdraw<P: CoherentProgram>: CoherentProgram {
    public typealias Previous = P
    public typealias Public = Previous.Public
    public typealias Owner = Previous.Owner
    public typealias Resident = Never
    public typealias Left = Previous
    public typealias Block0 = Previous.Block0
    public typealias Block1 = Previous.Block1
    public typealias Ideal = Previous.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Paired<Ideal, Resident>>
}

/// Both sources are derived by the actual CZ, public Z, H, CZ word.
/// The aliases supply no final frame or correctness certificate.
public typealias CoherentSource0 = CoherentCZ<
    CoherentH<CoherentPublicZ0<CoherentCZ<CoherentSourceStart<QBit0>>>>>
public typealias CoherentSource1 = CoherentCZ<
    CoherentH<CoherentPublicZ1<CoherentCZ<CoherentSourceStart<QBit1>>>>>

public enum CoherentOperatorSpace: Close {}
public enum CoherentOperatorEncoding: Close {}
public enum CoherentDataQuestion: Close {}
public enum CoherentJointQuestion: Close {}

/// Data-only equivalence ignores a scalar in each orthogonal memory block.
public enum ReadCoherentData<P: CoherentProgram>: PredicateReading {
    public typealias Left = P
    public typealias Right = Paired<Paired<P.Block0.Word, P.Block1.Word>, P.Ideal.Word>
    public typealias Sigma = CoherentOperatorSpace
    public typealias Encoding = CoherentOperatorEncoding
    public typealias Predicate = CoherentDataQuestion
    public typealias Answer = Right
}

/// Joint equivalence additionally retains the phases of the two memory blocks.
public enum ReadCoherentJoint<P: CoherentProgram>: PredicateReading {
    public typealias Left = P
    public typealias Right = Paired<
        ReadCoherentData<P>.Answer, Paired<P.Block0.Phase, P.Block1.Phase>>
    public typealias Sigma = CoherentOperatorSpace
    public typealias Encoding = CoherentOperatorEncoding
    public typealias Predicate = CoherentJointQuestion
    public typealias Answer = Right
}

public typealias CoherentIdealTargetWord = Paired<CoherentIdealHSymbol, Never>

public typealias CoherentDataTarget = Paired<
    Paired<CoherentIdentityWord, CoherentIdentityWord>,
    CoherentIdealTargetWord>

/// The actual word restores the data action H in both memory blocks.
/// Independent block phases are permitted for this question.
public enum CoherentDataWitness<P: CoherentProgram>: Null
where P.Block0.Word == CoherentIdentityWord,
      P.Block1.Word == CoherentIdentityWord,
      P.Ideal.Word == CoherentIdealTargetWord {
    public typealias Program = P
    public typealias Reading = ReadCoherentData<P>
    public typealias Left = Reading.Answer
    public typealias Right = CoherentDataTarget
}

/// The actual word restores I on memory and H on data up to one common phase.
/// This operator equality does not itself assert contact availability.
public enum CoherentJointWitness<P: CoherentProgram>: Null
where P.Block0.Word == CoherentIdentityWord,
      P.Block1.Word == CoherentIdentityWord,
      P.Ideal.Word == CoherentIdealTargetWord,
      P.Block0.Phase == P.Block1.Phase {
    public typealias Program = P
    public typealias Reading = ReadCoherentJoint<P>
    public typealias Left = Reading.Answer
    public typealias Right = Paired<
        CoherentDataTarget, Paired<P.Block0.Phase, P.Block0.Phase>>
}
