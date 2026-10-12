import VerificationIsIdentification
import Examples
import GrammarLexicon
import Alphabet

// Both original answers reduce to the checked floor, without a caller's
// additional equality between the outputs or between the actual sources.
enum PEFloorFollows<L: CheckedSpellingAdmission, R: CheckedSpellingAdmission>: Null {
    typealias Left = L.Left.Answer
    typealias Right = R.Left.Answer
}

enum PESpace {}
enum PETypedVocabulary {}
enum PEPlainPlace {}
enum PEBuilderPlace {}
enum PEAdmissionQuestion<Place> {}
enum PESpellingQuestion {}
enum PEWrongFloor {}

enum PEPair<A, B>: Pair {
    typealias Left = A
    typealias Right = B
}

enum PEReading<Source, Image, Question>: PredicateReading {
    typealias Left = Source
    typealias Right = Image
    typealias Sigma = PESpace
    typealias Encoding = PETypedVocabulary
    typealias Predicate = Question
    typealias Answer = Image
}

// The real vocabulary supplies these grants. This example starts with the
// spelled atom; deriving that atom from arbitrary source text remains separate.
// The constraints are exactly LatticeScopePlainTokens.buildExpression's door.
enum PEPlainAdmission<Token: LatticeToken & PlainToken>: CheckedSpellingAdmission {
    typealias Left = PEReading<PEPair<Token, PEPlainPlace>, Never, PEAdmissionQuestion<PEPlainPlace>>
    typealias Observation = PEReading<Left.Left, Token, PESpellingQuestion>
    typealias Right = PEReading<Token, Never, PEAdmissionQuestion<PEPlainPlace>>
    typealias Sigma = PESpace
    typealias Encoding = PETypedVocabulary
    typealias Predicate = Left.Predicate
    typealias Answer = Never
}

// Builder admission has a different question. Its genuine Semicolon grant
// does not supply the missing PlainToken conformance.
enum PEBuilderAdmission<Token: LatticeToken & BuilderToken>: CheckedSpellingAdmission {
    typealias Left = PEReading<PEPair<Token, PEBuilderPlace>, Never, PEAdmissionQuestion<PEBuilderPlace>>
    typealias Observation = PEReading<Left.Left, Token, PESpellingQuestion>
    typealias Right = PEReading<Token, Never, PEAdmissionQuestion<PEBuilderPlace>>
    typealias Sigma = PESpace
    typealias Encoding = PETypedVocabulary
    typealias Predicate = Left.Predicate
    typealias Answer = Never
}

typealias PEFirst = PEPlainAdmission<WhereWord>
typealias PESecond = PEPlainAdmission<TypealiasWord>
typealias PEPlainResults = AdmissionReadingResults<PEFirst, PESecond>
typealias PECommonFloor = PEFloorFollows<PEFirst, PESecond>
typealias PEBuilderSemicolon = PEBuilderAdmission<Semicolon>
typealias PEBuilderResults = AdmissionReadingResults<PEBuilderSemicolon, PEBuilderSemicolon>

// Check the existing builders too, rather than merely naming a similar gate.
enum PEActualPlainBlock: Formation {
    @LatticeScopePlainTokens
    static var body: Never.Type {
        WhereWord.self
        TypealiasWord.self
    }
}

enum PEActualBuilderBlock: Formation {
    @LatticeScopeBuilderTokens
    static var body: Never.Type {
        Semicolon.self
    }
}

#if PE_BAD_MIDLINE
// WhereWord itself has the grant; its recorded midline name does not.
typealias PERejectedMidline = PEPlainAdmission<Midline<WhereWord>>
#endif

#if PE_BAD_SCOPE
// FuncWord has PlainToken and ToolsToken, but no LatticeToken.
typealias PERejectedScope = PEPlainAdmission<FuncWord>
#endif

#if PE_BAD_FLOOR
// This is a valid factorization with a different output; it is not the
// vocabulary's checked floor required by CheckedSpellingAdmission.
enum PERejectedFloor: CheckedSpellingAdmission {
    typealias Left = PEReading<PEFirst.Left.Left, PEWrongFloor, PEFirst.Predicate>
    typealias Observation = PEFirst.Observation
    typealias Right = PEReading<Observation.Answer, PEWrongFloor, PEFirst.Predicate>
    typealias Sigma = PESpace
    typealias Encoding = PETypedVocabulary
    typealias Predicate = PEFirst.Predicate
    typealias Answer = PEWrongFloor
}
#endif

#if PE_BAD_SOURCE_INFERENCE
// Both artifacts pass, and their floors coincide. Their sources do not.
enum PERejectedSourceInference: Null {
    typealias Left = PEPlainResults.Left.Left
    typealias Right = PEPlainResults.Right.Left
}
#endif

#if PE_BAD_QUESTION
// A common floor alone cannot transfer a plain-context answer to a builder
// question. Both supplied branches are valid in their respective places.
typealias PERejectedQuestion = AdmissionReadingResults<PEFirst, PEBuilderSemicolon>
#endif
