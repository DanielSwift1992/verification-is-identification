import VerificationIsIdentification

// ═══════════════════════════════════════════════════════
// ALPHABET declares one type per character, shared by both readers in the package:
// DocumentKit renders a character through `Glyph`, and GrammarLexicon's stream
// classifies it through `Lexeme`. An atom that conforms to both states its character
// once, as `glyph`; `typeName` is derived from it in the one extension below, so the
// two readings cannot drift apart.
//
// The file holds plain single characters: the four bracket pairs, ordinary
// punctuation, and the whitespace medium. Letters and digits live in DocumentKit,
// because the stream reads identifiers as whole word runs. Markdown compounds
// ("## ", "| ") live in DocumentKit too: they are spans that carry whitespace,
// not characters. One symbol, one name, one declaration.
// ═══════════════════════════════════════════════════════

// ── Shapes — what any token stream can ask of an atom. The shapes carry no rules;
//    the rules live in GrammarLexicon. ──

public protocol LintAtom {}

/// A one-character atom; its glyph identifies it.
public protocol Lexeme: LintAtom {
    static var glyph: Character { get }
}
/// A multi-character atom; its spelling identifies it. The spelled words themselves are
/// vocabulary and live with the rules, in GrammarLexicon.
public protocol Spelled: LintAtom {
    static var spelling: String { get }
}

public protocol OpeningAtom: LintAtom {}
public protocol ClosingAtom: LintAtom { associatedtype Opens: OpeningAtom }
extension ClosingAtom {
    public static var opensType: any OpeningAtom.Type { Opens.self }
}

/// Marks an opener the analyzed language itself closes: in source that compiles, every
/// `{`, `(` and `[` meets its close. Only such an opener becomes a block in the mirror;
/// an angle can also mean less-than, so it stays an ordinary atom.
public protocol AlwaysPairs: OpeningAtom {}

/// A medium atom splits runs and never becomes content itself: whitespace.
public protocol MediumAtom: LintAtom {}

/// An opaque span reads as one atom; nothing inside it is classified.
public protocol ForeignAtom: LintAtom {}

/// Opens a span consumed raw until `Closer` appears; the opener then stands for the
/// whole run. `Closer` names any atom: a line comment, for example, closes at the newline.
public protocol ForeignOpener: LintAtom { associatedtype Closer: LintAtom }
extension ForeignOpener {
    public static var closerType: any LintAtom.Type { Closer.self }
}
/// Suspends closer-matching for the character after this one. When that character opens
/// a bracket, the suspension covers one balanced run: interpolation stays inside its string.
public protocol Escapes: LintAtom {}

// ── The rendering half (moved from DocumentKit/Alphabet.swift). ──

/// Renders one character: a leaf atom whose `typeName` is the character itself.
public protocol Glyph: Open {}

/// A glyph that is also a lexeme renders the `glyph` it declares: the character is stated once,
/// and both readings derive from it.
extension Glyph
where Self: Lexeme {
    public static var typeName: String { String(glyph) }
}

// ── Brackets — four pairs; the mirror matches them through their Opening/Closing roles. ──

public enum BraceOpen: AlwaysPairs, Lexeme, Glyph, Close { public static let glyph: Character = "{" }
public enum BraceClose: ClosingAtom, Lexeme, Glyph, Close {
    public typealias Opens = BraceOpen
    public static let glyph: Character = "}"
}
public enum AngleOpen: OpeningAtom, Lexeme, Glyph, Close { public static let glyph: Character = "<" }
public enum AngleClose: ClosingAtom, Lexeme, Glyph, Close {
    public typealias Opens = AngleOpen
    public static let glyph: Character = ">"
}
public enum ParenOpen: AlwaysPairs, Lexeme, Glyph, Close { public static let glyph: Character = "(" }
public enum ParenClose: ClosingAtom, Lexeme, Glyph, Close {
    public typealias Opens = ParenOpen
    public static let glyph: Character = ")"
}
public enum SquareOpen: AlwaysPairs, Lexeme, Glyph, Close { public static let glyph: Character = "[" }
public enum SquareClose: ClosingAtom, Lexeme, Glyph, Close {
    public typealias Opens = SquareOpen
    public static let glyph: Character = "]"
}

// ── Ordinary punctuation — one plain-English name each. ──

public enum Colon: Lexeme, Glyph, Close { public static let glyph: Character = ":" }
public enum Comma: Lexeme, Glyph, Close { public static let glyph: Character = "," }
public enum Semicolon: Lexeme, Glyph, Close { public static let glyph: Character = ";" }
public enum Period: Lexeme, Glyph, Close { public static let glyph: Character = "." }
public enum Dash: Lexeme, Glyph, Close { public static let glyph: Character = "-" }
public enum Apostrophe: Lexeme, Glyph, Close { public static let glyph: Character = "'" }
public enum Question: Lexeme, Glyph, Close { public static let glyph: Character = "?" }
public enum Exclamation: Lexeme, Glyph, Close { public static let glyph: Character = "!" }
public enum At: Lexeme, Glyph, Close { public static let glyph: Character = "@" }
public enum Quote: Lexeme, Glyph, Close { public static let glyph: Character = "\"" }
public enum Backtick: Lexeme, Glyph, Close { public static let glyph: Character = "`" }
public enum Hash: Lexeme, Glyph, Close { public static let glyph: Character = "#" }
public enum Equals: Lexeme, Close { public static let glyph: Character = "=" }
public enum Backslash: Lexeme, Close { public static let glyph: Character = "\\" }
public enum Slash: Lexeme, Close { public static let glyph: Character = "/" }
public enum PlusSign: Lexeme, Close { public static let glyph: Character = "+" }
public enum Asterisk: Lexeme, Close { public static let glyph: Character = "*" }
public enum Percent: Lexeme, Close { public static let glyph: Character = "%" }
public enum Ampersand: Lexeme, Close { public static let glyph: Character = "&" }
/// Keeps its suffix because `Pipe` in DocumentKit already names the markdown table-cell
/// compound ("| "); this is the bare glyph.
public enum PipeAtom: Lexeme, Close { public static let glyph: Character = "|" }
public enum Caret: Lexeme, Close { public static let glyph: Character = "^" }
public enum Tilde: Lexeme, Close { public static let glyph: Character = "~" }
public enum Dollar: Lexeme, Close { public static let glyph: Character = "$" }

// ── Medium — Space and Newline render in prose as well; Tab and CarriageReturn serve
//    the stream only. ──

public enum Space: Lexeme, MediumAtom, Glyph, Close { public static let glyph: Character = " " }
public enum Newline: Lexeme, MediumAtom, Glyph, Close { public static let glyph: Character = "\n" }
public enum Tab: Lexeme, MediumAtom, Close { public static let glyph: Character = "\t" }
public enum CarriageReturn: Lexeme, MediumAtom, Close { public static let glyph: Character = "\r" }

// ── The general word: a run of letters, digits, `_`. Every identifier without a spelling
//    of its own reads as this atom. ──

public enum WordAtom: LintAtom, Close {}

// ── Census builder — the registry below lists its atoms as a body, like every tree here;
//    the fold collects the listed types into a value a reader can walk. ──

@resultBuilder
public enum LexemeCensus {
    public static func buildExpression<T: Lexeme>(_ atom: T.Type) -> [any Lexeme.Type] { [atom] }
    public static func buildPartialBlock(first: [any Lexeme.Type]) -> [any Lexeme.Type] { first }
    public static func buildPartialBlock(accumulated: [any Lexeme.Type], next: [any Lexeme.Type]) -> [any Lexeme.Type] {
        accumulated + next
    }
}

// ── Registry — the census of this file's atoms. The readers build their tables from this
//    body, so an atom left out of it is one they cannot see. ──

public enum Alphabet {
    @LexemeCensus
    public static var lexemes: [any Lexeme.Type] {
        BraceOpen.self
        BraceClose.self
        AngleOpen.self
        AngleClose.self
        ParenOpen.self
        ParenClose.self
        SquareOpen.self
        SquareClose.self
        Colon.self
        Comma.self
        Semicolon.self
        Period.self
        Dash.self
        Apostrophe.self
        Question.self
        Exclamation.self
        At.self
        Quote.self
        Backtick.self
        Hash.self
        Equals.self
        Backslash.self
        Slash.self
        PlusSign.self
        Asterisk.self
        Percent.self
        Ampersand.self
        PipeAtom.self
        Caret.self
        Tilde.self
        Dollar.self
        Space.self
        Newline.self
        Tab.self
        CarriageReturn.self
    }
    /// Stands for any word with no spelling of its own. Readers take it from here rather than naming it.
    public static let defaultWord: any LintAtom.Type = WordAtom.self
}
