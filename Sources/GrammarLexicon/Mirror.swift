import Alphabet
import VerificationIsIdentification

// ═══════════════════════════════════════════════════════
// MIRROR states the schema: which words exist, which spans fold shut, which atoms a context
// admits, which words a directory's dialect permits, and what the final object is. Every fact
// here is a type, not a function; the few functions that exist are the result builder's own
// doors, and their constraints are the rules. The stream layer (the Alphabet target, shared
// with DocumentKit) carries source into this vocabulary, and the compiler decides against it:
// an allowed form compiles, a refused one names its own reason, the same shape Organization's
// access policy has. [V=I §1: schema is the decidable test; the build is VERIFY; a compiler
// error is REJECT(where, why); the build fact is PASS.]
// ═══════════════════════════════════════════════════════

// ── §1 Words of the analyzed language — spellings the rules read. Vocabulary, not stream. ──

public enum EnumWord: Spelled, Close { public static let spelling = "enum" }
public enum ExtensionWord: Spelled, Close { public static let spelling = "extension" }
public enum PublicWord: Spelled, Close { public static let spelling = "public" }
public enum StaticWord: Spelled, Close { public static let spelling = "static" }
public enum VarWord: Spelled, Close { public static let spelling = "var" }
public enum WhereWord: Spelled, Close { public static let spelling = "where" }
public enum SomeWord: Spelled, Close { public static let spelling = "some" }
/// This word is adjacent to `{` in every "some Structure {"; the `@StructureBuilder`
/// attribute sits two atoms earlier on the same line and does not touch the brace itself.
public enum StructureBuilderMark: Spelled, Close { public static let spelling = "Structure" }

// Law §0′'s own six: `func|var|let|init|subscript|deinit|operator`, the only words a scope
// may forbid outright, never a punctuation mark or a bracket.
public enum FuncWord: Spelled, Close { public static let spelling = "func" }
public enum ProtocolWord: Spelled, Close { public static let spelling = "protocol" }
public enum StructWord: Spelled, Close { public static let spelling = "struct" }
public enum ClassWord: Spelled, Close { public static let spelling = "class" }
/// Registered so it can be REFUSED: `actor` carries no scope token at all — a runtime
/// concurrency shape this codebase has never needed. The word is visible to every axis and
/// legal in none. The first legitimate need is one grant away, with its reason.
public enum ActorWord: Spelled, Close { public static let spelling = "actor" }
public enum TypealiasWord: Spelled, Close { public static let spelling = "typealias" }
public enum IfWord: Spelled, Close { public static let spelling = "if" }
public enum ElseWord: Spelled, Close { public static let spelling = "else" }
public enum ForWord: Spelled, Close { public static let spelling = "for" }
public enum WhileWord: Spelled, Close { public static let spelling = "while" }
public enum GuardWord: Spelled, Close { public static let spelling = "guard" }
public enum SwitchWord: Spelled, Close { public static let spelling = "switch" }
public enum DoWord: Spelled, Close { public static let spelling = "do" }
public enum CatchWord: Spelled, Close { public static let spelling = "catch" }
public enum RepeatWord: Spelled, Close { public static let spelling = "repeat" }
public enum DeferWord: Spelled, Close { public static let spelling = "defer" }
public enum LetWord: Spelled, Close { public static let spelling = "let" }
public enum InitWord: Spelled, Close { public static let spelling = "init" }
public enum SubscriptWord: Spelled, Close { public static let spelling = "subscript" }
public enum DeinitWord: Spelled, Close { public static let spelling = "deinit" }
public enum OperatorWord: Spelled, Close { public static let spelling = "operator" }

// The four `Structure` witnesses this codebase's convention names as a `static var`, the
// only var-names a scope may accept without an exemption.
public enum TypeNameWord: Spelled, Close { public static let spelling = "typeName" }
public enum CountWord: Spelled, Close { public static let spelling = "count" }
public enum SpelledWord: Spelled, Close { public static let spelling = "spelled" }
public enum TimesWord: Spelled, Close { public static let spelling = "Times" }
public enum U1Word: Spelled, Close { public static let spelling = "U1" }
public enum U2Word: Spelled, Close { public static let spelling = "U2" }
public enum U4Word: Spelled, Close { public static let spelling = "U4" }
public enum U8Word: Spelled, Close { public static let spelling = "U8" }
public enum U16Word: Spelled, Close { public static let spelling = "U16" }
public enum U32Word: Spelled, Close { public static let spelling = "U32" }
public enum U64Word: Spelled, Close { public static let spelling = "U64" }
public enum U128Word: Spelled, Close { public static let spelling = "U128" }
public enum U256Word: Spelled, Close { public static let spelling = "U256" }
public enum U512Word: Spelled, Close { public static let spelling = "U512" }
public enum LabelsWord: Spelled, Close { public static let spelling = "labels" }
public enum BodyWord: Spelled, Close { public static let spelling = "body" }

// ── §2 Spans the analyzed language folds shut — comments and strings, with their closers.
//    The quote glyph is the stream's; that it OPENS an opaque span is knowledge, so the
//    conformance is granted here. ──

public enum LineCommentOpen: Spelled, ForeignOpener, ForeignAtom, Close {
    public static let spelling = "//"
    public typealias Closer = Newline
}
public enum BlockCommentOpen: Spelled, ForeignOpener, ForeignAtom, Close {
    public static let spelling = "/*"
    public typealias Closer = BlockCommentClose
}
public enum BlockCommentClose: Spelled, Close { public static let spelling = "*/" }
public enum TripleQuote: Spelled, ForeignOpener, ForeignAtom, Close {
    public static let spelling = "\"\"\""
    public typealias Closer = TripleQuote
}
extension Quote: ForeignOpener, ForeignAtom {
    public typealias Closer = Quote
}
extension Backslash: Escapes {}

/// Atoms conforming here mean "the block that follows is a builder body," routed through
/// identity (SurfaceLaw §S25): the stream asks one protocol question, not a specific word.
public protocol OpensBuilder: LintAtom {}
extension StructureBuilderMark: OpensBuilder {}

/// These atoms head a DECLARATION or a control clause, the other half of the same question.
/// A brace whose sentence (everything since the last block boundary) began with one of these
/// is a plain body: an enum's, a func's, an `if`'s. A brace with no head in its sentence is a
/// builder call (`ListItem { … }`, the init-is-the-door shape), and `;` chains are at home
/// there. The stream records the fact. These conformances carry the whole meaning.
public protocol DeclarationHead: LintAtom {}
extension EnumWord: DeclarationHead {}
extension ExtensionWord: DeclarationHead {}
extension ProtocolWord: DeclarationHead {}
extension StructWord: DeclarationHead {}
extension ClassWord: DeclarationHead {}
extension ActorWord: DeclarationHead {}
extension FuncWord: DeclarationHead {}
extension VarWord: DeclarationHead {}
extension LetWord: DeclarationHead {}
extension InitWord: DeclarationHead {}
extension SubscriptWord: DeclarationHead {}
extension DeinitWord: DeclarationHead {}
extension IfWord: DeclarationHead {}
extension ElseWord: DeclarationHead {}
extension ForWord: DeclarationHead {}
extension WhileWord: DeclarationHead {}
extension GuardWord: DeclarationHead {}
extension SwitchWord: DeclarationHead {}
extension DoWord: DeclarationHead {}
extension CatchWord: DeclarationHead {}
extension RepeatWord: DeclarationHead {}
extension DeferWord: DeclarationHead {}

// ── §2′ The EXEMPT door: a block stands outside the rules only by NAMING why, as a real type,
//    in a real conformance the host build itself compiles. No comment can carry this: a `//…`
//    span folds shut into one foreign atom before the schema ever sees inside it. ──

/// This names a reason a block may stand outside the rules: declared once, documented at
/// declaration, not a string. The census counts these. A comment it could not even see.
public protocol ExemptionReason {}

/// This door lives in declaration land: conform a real type to it and NAME the reason. The
/// stream sees the word in the block's sentence and carries the block under the exempt
/// builder. The conformance compiles in the host build too: an exemption IS code.
public protocol GrammarExempt {
    associatedtype Because: ExemptionReason
}

public enum GrammarExemptMark: Spelled, Close { public static let spelling = "GrammarExempt" }
/// An atom whose LINE POSITION the law reads. Supplementary information lives in ONE home —
/// `where` heads its line, always — so the eye never hunts between two places (the rule: what
/// can sit in two places should sit in one. Friction dies, the gaze lands where expected).
/// The stream spells the fact: a line-sensitive atom found midline is carried as `Midline<A>`.
/// `Midline` holds no context token, so the refusal names the law by name.
public protocol LineSensitive: LintAtom {}
extension WhereWord: LineSensitive {}
extension VarWord: LineSensitive {}
extension TypealiasWord: LineSensitive {}

/// `Midline<A>` carries the fact that an atom did not head its line. Ungranted, so not legal.
public enum Midline<A: LintAtom>: LintAtom {}

/// A word that names one of the four `Structure` witnesses, the only names a scope may accept
/// after `var` without an exemption.
public protocol WitnessName: LintAtom {}
extension TypeNameWord: WitnessName {}
extension CountWord: WitnessName {}
extension SpelledWord: WitnessName {}
extension LabelsWord: WitnessName {}
extension BodyWord: WitnessName {}

/// An atom whose NEIGHBOR the law reads. Adjacency is a fact the stream already has (the atom
/// right after this one), a plain record, not an interpretation. The stream carries the two as
/// ONE fact, `Declares<A, B>`, the same move `Midline` makes for POSITION, now for NEIGHBORHOOD.
/// Grants on `Declares` (below, §4) decide what a given pairing MEANS, per scope.
public protocol PairSensitive: LintAtom {}
extension VarWord: PairSensitive {}

/// `Declares<A, B>` carries the fact that an atom's declared name sits right after it.
public enum Declares<A: LintAtom, B: LintAtom>: LintAtom {}

/// A modifier the eye already reads as part of the declaration it precedes. `public static var
/// x` is one home, not two, so `public`/`static` stay TRANSPARENT to line-heading: the stream
/// does not count them as "the atom that used up this line's head." It carries that open for
/// whichever `LineSensitive` word (or anything else) comes next on the same line.
public protocol LineModifier: LintAtom {}
extension PublicWord: LineModifier {}
extension StaticWord: LineModifier {}

public protocol OpensExempt: LintAtom {}
extension GrammarExemptMark: OpensExempt {}
extension GrammarExemptMark: PlainToken, BuilderToken {}
extension GrammarExemptMark: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}

// ── §3 The CONTEXT axis — a plain block vs a builder body, read off the atom before the
//    brace (a fact the stream records, never interprets). Refused until granted, and a grant
//    names each context it enters: no universal class exists on this axis either. The one
//    asymmetry today: `;` lives in builder bodies only. ──

public protocol PlainToken: LintAtom {}
public protocol BuilderToken: LintAtom {}

extension BraceOpen: PlainToken, BuilderToken {}
extension BraceClose: PlainToken, BuilderToken {}
extension AngleOpen: PlainToken, BuilderToken {}
extension AngleClose: PlainToken, BuilderToken {}
extension ParenOpen: PlainToken, BuilderToken {}
extension ParenClose: PlainToken, BuilderToken {}
extension SquareOpen: PlainToken, BuilderToken {}
extension SquareClose: PlainToken, BuilderToken {}
extension Colon: PlainToken, BuilderToken {}
extension Comma: PlainToken, BuilderToken {}
extension Period: PlainToken, BuilderToken {}
extension Equals: PlainToken, BuilderToken {}
extension At: PlainToken, BuilderToken {}
extension Backslash: PlainToken, BuilderToken {}
extension Slash: PlainToken, BuilderToken {}
extension Quote: PlainToken, BuilderToken {}
extension Dash: PlainToken, BuilderToken {}
extension PlusSign: PlainToken, BuilderToken {}
extension Asterisk: PlainToken, BuilderToken {}
extension Percent: PlainToken, BuilderToken {}
extension Question: PlainToken, BuilderToken {}
extension Exclamation: PlainToken, BuilderToken {}
extension Ampersand: PlainToken, BuilderToken {}
extension PipeAtom: PlainToken, BuilderToken {}
extension Caret: PlainToken, BuilderToken {}
extension Tilde: PlainToken, BuilderToken {}
extension Hash: PlainToken, BuilderToken {}
extension Backtick: PlainToken, BuilderToken {}
extension Dollar: PlainToken, BuilderToken {}
extension WordAtom: PlainToken, BuilderToken {}
extension EnumWord: PlainToken, BuilderToken {}
extension ExtensionWord: PlainToken, BuilderToken {}
extension PublicWord: PlainToken, BuilderToken {}
extension StaticWord: PlainToken, BuilderToken {}
extension VarWord: PlainToken, BuilderToken {}
extension WhereWord: PlainToken, BuilderToken {}
extension SomeWord: PlainToken, BuilderToken {}
extension StructureBuilderMark: PlainToken, BuilderToken {}
extension LineCommentOpen: PlainToken, BuilderToken {}
extension BlockCommentOpen: PlainToken, BuilderToken {}
extension TripleQuote: PlainToken, BuilderToken {}
extension FuncWord: PlainToken, BuilderToken {}
extension ProtocolWord: PlainToken, BuilderToken {}
extension StructWord: PlainToken, BuilderToken {}
extension ClassWord: PlainToken, BuilderToken {}
extension ActorWord: PlainToken, BuilderToken {}
extension TypealiasWord: PlainToken, BuilderToken {}
extension IfWord: PlainToken, BuilderToken {}
extension ElseWord: PlainToken, BuilderToken {}
extension ForWord: PlainToken, BuilderToken {}
extension WhileWord: PlainToken, BuilderToken {}
extension GuardWord: PlainToken, BuilderToken {}
extension SwitchWord: PlainToken, BuilderToken {}
extension DoWord: PlainToken, BuilderToken {}
extension CatchWord: PlainToken, BuilderToken {}
extension RepeatWord: PlainToken, BuilderToken {}
extension DeferWord: PlainToken, BuilderToken {}
extension LetWord: PlainToken, BuilderToken {}
extension InitWord: PlainToken, BuilderToken {}
extension SubscriptWord: PlainToken, BuilderToken {}
extension DeinitWord: PlainToken, BuilderToken {}
extension OperatorWord: PlainToken, BuilderToken {}
extension TypeNameWord: PlainToken, BuilderToken {}
extension CountWord: PlainToken, BuilderToken {}
extension SpelledWord: PlainToken, BuilderToken {}
extension TimesWord: PlainToken, BuilderToken {}
extension U1Word: PlainToken, BuilderToken {}
extension U2Word: PlainToken, BuilderToken {}
extension U4Word: PlainToken, BuilderToken {}
extension U8Word: PlainToken, BuilderToken {}
extension U16Word: PlainToken, BuilderToken {}
extension U32Word: PlainToken, BuilderToken {}
extension U64Word: PlainToken, BuilderToken {}
extension U128Word: PlainToken, BuilderToken {}
extension U256Word: PlainToken, BuilderToken {}
extension U512Word: PlainToken, BuilderToken {}
extension LabelsWord: PlainToken, BuilderToken {}
extension BodyWord: PlainToken, BuilderToken {}

/// `Declares<A, B>` carries the context axis exactly as its two atoms do: a var-with-name
/// pair is a plain member wherever `var` itself already was, nothing new to grant.
extension Declares: PlainToken
where A: PlainToken, B: PlainToken {}
extension Declares: BuilderToken
where A: BuilderToken, B: BuilderToken {}

extension Semicolon: BuilderToken {}     // the one asymmetric grant — PlainToken stays absent

// ── §4 The SCOPE axis (DESIGN16 §1) — which words a DIALECT permits at all, read off the
//    file's own directory (`Schema.scopes` below). EVERYTHING is refused until granted, and a
//    grant names its scopes one by one: there is no universal class, deliberately — a width
//    every dialect happens to need is still six separate decisions, written out, so widening
//    ANY scope is a diff on its own line. Law §0′'s six words and the operator glyphs are
//    value-code's width over the pure lattice, granted to `ToolsToken` and NOT to
//    `LatticeToken` — the resolver enforces §0′ with no `if` anywhere checking a keyword.
//    The grants list IS the audit. ──

public enum LatticeScope: LintAtom {}
/// This scope names the lattice's engine room: `Primitive.swift` alone, keyed by its path (a
/// path is as mechanical a fact as a directory). The law itself carves this exception: the ONE
/// `@resultBuilder` the system allows (SurfaceLaw §S4) and the readers (`typeName`, `count`,
/// `labels`, §S7's doors) live there, and nowhere else in the lattice may a `func`, a `var`
/// or an operator appear. The registry line IS that sentence of the law.
public enum EngineScope: LintAtom {}
public enum SurfaceScope: LintAtom {}
public enum SystemScope: LintAtom {}
public enum ToolsScope: LintAtom {}
public enum DemoScope: LintAtom {}

public protocol LatticeToken: LintAtom {}
public protocol EngineToken: LintAtom {}
public protocol SurfaceToken: LintAtom {}
public protocol SystemToken: LintAtom {}
public protocol ToolsToken: LintAtom {}
public protocol DemoToken: LintAtom {}
extension BraceOpen: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension BraceClose: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension AngleOpen: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension AngleClose: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension ParenOpen: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension ParenClose: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension SquareOpen: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension SquareClose: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Colon: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Comma: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Semicolon: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Period: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Equals: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension At: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Backslash: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Slash: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension Quote: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension WordAtom: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension EnumWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension ExtensionWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension PublicWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension StaticWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension WhereWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension SomeWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension StructureBuilderMark: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension LineCommentOpen: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension BlockCommentOpen: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension TripleQuote: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension ProtocolWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension TypealiasWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension IfWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension ElseWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension ForWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension WhileWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension GuardWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension SwitchWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension DoWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension CatchWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension RepeatWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension DeferWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension TypeNameWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension CountWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
/// The passcode reader's witness lives in the system beside the secrets it spells and
/// is read by the cards; the lattice keeps no such word.
extension SpelledWord: SystemToken, DemoToken, ToolsToken {}
// The magnitudes' words: a canvas SPEAKS the dictionary and never spells a rung, so
// DemoToken is deliberately absent, and so is SystemToken. The refusal IS the gun.
extension TimesWord: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U1Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U2Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U4Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U8Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U16Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U32Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U64Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U128Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U256Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension U512Word: LatticeToken, EngineToken, SurfaceToken, ToolsToken {}
extension LabelsWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension BodyWord: LatticeToken, EngineToken, SurfaceToken, SystemToken, ToolsToken, DemoToken {}
extension StructWord: ToolsToken, EngineToken, DemoToken {}
extension ClassWord: ToolsToken, EngineToken, DemoToken {}

// Law §0′'s six carry ToolsToken only; LatticeToken stays absent, so the resolver refuses them
// wherever a block's own scope is the lattice.
extension FuncWord: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
/// `var` alone is not checked again once paired (`PairSensitive` merges it with its
/// declared name): the grants below land on `Declares<VarWord, _>`, not bare `VarWord`.
/// Protocol composition — `CanView & RankCycle` — is type language, not value code. The System
/// dialect states capabilities with it (Policy.swift).
extension Ampersand: SystemToken {}
extension LetWord: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension InitWord: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension SubscriptWord: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension DeinitWord: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension OperatorWord: ToolsToken, EngineToken, SurfaceToken, DemoToken {}

// `var`, PAIRED with its own declared name: Tools/Engine/Surface/Demo
// stay as wide as `var` itself always was (any name), and only System narrows, to the four
// `Structure` witnesses. A `var` whose name is not one of the four still carries `ToolsToken`
// etc. (unaffected), but fails `SystemToken`: the resolver refuses it there with no `if`
// anywhere checking a variable's name; `GrammarExempt` is the door for a real exception.
extension Declares: ToolsToken
where A == VarWord {}
extension Declares: EngineToken
where A == VarWord {}
extension Declares: SurfaceToken
where A == VarWord {}
extension Declares: DemoToken
where A == VarWord {}
extension Declares: SystemToken
where A == VarWord, B: WitnessName {}

// Operator glyphs are value-code punctuation: Tools' width, and the engine room's (the readers
// concatenate: `typeName + typeName` is the reading itself), the same asymmetry as the six.
extension Dash: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension PlusSign: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Asterisk: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Percent: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Question: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Exclamation: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Ampersand: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension PipeAtom: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Caret: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Tilde: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Hash: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Backtick: ToolsToken, EngineToken, SurfaceToken, DemoToken {}
extension Dollar: ToolsToken, EngineToken, SurfaceToken, DemoToken {}

// ── Census builders for the schema's OWN registries (words, scopes) — the same variadic-body
//    shape Alphabet's LexemeCensus already has, one per list this file declares. ──

@resultBuilder
public enum SpellingCensus {
    public static func buildExpression<T: Spelled>(_ atom: T.Type) -> [any Spelled.Type] { [atom] }
    public static func buildPartialBlock(first: [any Spelled.Type]) -> [any Spelled.Type] { first }
    public static func buildPartialBlock(accumulated: [any Spelled.Type], next: [any Spelled.Type]) -> [any Spelled.Type] {
        accumulated + next
    }
}

@resultBuilder
public enum ScopeCensus {
    public static func buildExpression(_ entry: (String, any LintAtom.Type)) -> [(prefix: String, scope: any LintAtom.Type)] {
        [(prefix: entry.0, scope: entry.1)]
    }
    public static func buildPartialBlock(first: [(prefix: String, scope: any LintAtom.Type)]) -> [(prefix: String, scope: any LintAtom.Type)] {
        first
    }
    public static func buildPartialBlock(accumulated: [(prefix: String, scope: any LintAtom.Type)], next: [(prefix: String, scope: any LintAtom.Type)]) -> [(prefix: String, scope: any LintAtom.Type)] {
        accumulated + next
    }
}

// ── §5 Registry — the schema's own census, read as VALUES by the stream: which spellings
//    exist, which directory carries which scope. Longest match first is the reader's one
//    policy, applied to whatever these lists hold. ──

public enum Schema {
    @SpellingCensus
    public static var spellings: [any Spelled.Type] {
        LineCommentOpen.self
        BlockCommentOpen.self
        BlockCommentClose.self
        TripleQuote.self
        EnumWord.self
        ExtensionWord.self
        PublicWord.self
        StaticWord.self
        VarWord.self
        WhereWord.self
        SomeWord.self
        StructureBuilderMark.self
        FuncWord.self
        ProtocolWord.self
        StructWord.self
        ClassWord.self
        ActorWord.self
        TypealiasWord.self
        IfWord.self
        ElseWord.self
        ForWord.self
        WhileWord.self
        GuardWord.self
        SwitchWord.self
        DoWord.self
        CatchWord.self
        RepeatWord.self
        DeferWord.self
        LetWord.self
        InitWord.self
        SubscriptWord.self
        DeinitWord.self
        OperatorWord.self
        GrammarExemptMark.self
        TypeNameWord.self
        CountWord.self
        SpelledWord.self
        TimesWord.self
        U1Word.self
        U2Word.self
        U4Word.self
        U8Word.self
        U16Word.self
        U32Word.self
        U64Word.self
        U128Word.self
        U256Word.self
        U512Word.self
        LabelsWord.self
        BodyWord.self
    }
    @ScopeCensus
    public static var scopes: [(prefix: String, scope: any LintAtom.Type)] {
        ("Sources/VerificationIsIdentification/Primitive.swift", EngineScope.self)
        ("Sources/VerificationIsIdentification", LatticeScope.self)
        ("Sources/DocumentKit", SurfaceScope.self)
        ("Sources/Organization/View", SurfaceScope.self)
        ("Sources/Organization/System", SystemScope.self)
        ("Sources/Organization/Query", SystemScope.self)
        ("Sources/Organization", SystemScope.self)
        ("Sources/Tools", ToolsScope.self)
        ("Plugins", ToolsScope.self)
        ("Sources/GrammarLexicon", ToolsScope.self)
        ("Sources/Alphabet", ToolsScope.self)
        ("Sources/Examples", DemoScope.self)
        ("Sources/OrgDemo", DemoScope.self)
        ("Sources/OrgWalkPages", DemoScope.self)
        ("Sources/VectorDemo", DemoScope.self)
        ("Sources/DocumentKitDemo", DemoScope.self)
    }
}

// ── §6 Blocks and their builders — where the schema meets the compiler. The carried source is
//    one nested-init object per file, the init-is-the-door shape every combinator in this
//    project has; `buildExpression`'s constraint is the whole check. An ungranted atom fails on
//    its own line, named by the compiler; a scope the registry never named spells a block type
//    that does not exist here. The fold is flat (every step lands on `Never` — the seed's
//    own floor: checked means nothing remains to be distinguished, which is Null), the nesting
//    is the source's own bracket nesting — closure inside closure, never a cons chain
//    (SurfaceLaw §S22). ──

/// One carried block — a small declaration whose `body` re-states the block's atoms and
/// REFERENCES its child blocks by name, the way a page references a fragment. Navigation, not
/// duplication: the compiler checks many small bodies quickly (linear). One large inlined
/// expression can starve the solver instead (261 closures nested in one initializer, measured
/// against the same code as separate declarations: seconds versus a stall). Finiteness comes
/// from small parts and links, the house's §S22 answer.
public protocol Formation {
    static var body: Never.Type { get }
}

@resultBuilder
public enum LatticeScopePlainTokens {
    public static func buildExpression<T: LatticeToken & PlainToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum LatticeScopeBuilderTokens {
    public static func buildExpression<T: LatticeToken & BuilderToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum EngineScopePlainTokens {
    public static func buildExpression<T: EngineToken & PlainToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum EngineScopeBuilderTokens {
    public static func buildExpression<T: EngineToken & BuilderToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum SurfaceScopePlainTokens {
    public static func buildExpression<T: SurfaceToken & PlainToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum SurfaceScopeBuilderTokens {
    public static func buildExpression<T: SurfaceToken & BuilderToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum SystemScopePlainTokens {
    public static func buildExpression<T: SystemToken & PlainToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum SystemScopeBuilderTokens {
    public static func buildExpression<T: SystemToken & BuilderToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum ToolsScopePlainTokens {
    public static func buildExpression<T: ToolsToken & PlainToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum ToolsScopeBuilderTokens {
    public static func buildExpression<T: ToolsToken & BuilderToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum DemoScopePlainTokens {
    public static func buildExpression<T: DemoToken & PlainToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum DemoScopeBuilderTokens {
    public static func buildExpression<T: DemoToken & BuilderToken>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

// ── The EXEMPT column (DESIGN17 §2) — the thirteenth builder per scope-row: constrained by
//    `LintAtom` alone, neither a context token nor a scope token, so a block this door admits
//    carries anything the DICTIONARY names — an unregistered symbol is still no real type here,
//    still refused — but neither axis of RULE (context, scope) is asked of it at all. ──

@resultBuilder
public enum LatticeScopeExemptTokens {
    public static func buildExpression<T: LintAtom>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum EngineScopeExemptTokens {
    public static func buildExpression<T: LintAtom>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum SurfaceScopeExemptTokens {
    public static func buildExpression<T: LintAtom>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum SystemScopeExemptTokens {
    public static func buildExpression<T: LintAtom>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum ToolsScopeExemptTokens {
    public static func buildExpression<T: LintAtom>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

@resultBuilder
public enum DemoScopeExemptTokens {
    public static func buildExpression<T: LintAtom>(_: T.Type) -> Never.Type { Never.self }
    public static func buildExpression<B: Formation>(_: B.Type) -> Never.Type { Never.self }
    public static func buildBlock() -> Never.Type { Never.self }
    public static func buildPartialBlock(first: Never.Type) -> Never.Type { first }
    public static func buildPartialBlock(accumulated: Never.Type, next: Never.Type) -> Never.Type { accumulated }
}

// ── §7 The final object ──

/// This closes the theory's shape: `RawString` is the source carried into our representation
/// (an object built of Lexicon atoms under this schema's builders), and holding a `Linter`
/// value is holding the verdict. The object exists only in a mirror that compiled, and a
/// mirror that compiled is the source identified in our vocabulary. [V=I §0 step 11]
public struct Linter<RawString> {
    public init(_: RawString) {}
}
