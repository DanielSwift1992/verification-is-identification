import Alphabet
import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// THE ALPHABET spells prose from atoms, the way `Numeral` spells a number from digits.
//
// `Glyph` and the punctuation/medium atoms come from the shared `Alphabet` target;
// GrammarLexicon reads the same declarations, so a character's identifier and its rendered
// content cannot drift apart the way three separate copies once did. Only letters and digits
// stay here: this common set (`Letter.a`...`z`, `TextDigit`) is named by hand, so generated
// prose reads as `Letter.t; Letter.h; Letter.e` rather than opaque code points, and the stream
// reads whole word runs instead of one character at a time. Anything outside this set (an em
// dash, …) the ProseGen plugin generates on demand, named by Unicode scalar (`Char8212`) into
// GeneratedAlphabet.swift, so the alphabet stays exactly as big as the content needs and no
// bigger. Only readability is traded away for the rare case, not coverage. A word is an `Open`
// type whose `body` chains glyphs; a sentence chains words the same way `Numeral` chains
// digits. No string is hand-set on a sentence: every character is a real, checked atom. A hole
// in a template (`{count}`) becomes a generic parameter, filled at the call site by a real
// `Structure` (``Tally``, ``Reference``).
// ═══════════════════════════════════════════════════════════════

/// Lowercase letters, namespaced under `Letter` so `a`...`z` do not collide with the rest of
/// the lattice. Write `Letter.a` for the character, `Cap<Letter.a>` for its capital.
public enum Letter {
    public enum a: Glyph {}
    public enum b: Glyph {}
    public enum c: Glyph {}
    public enum d: Glyph {}
    public enum e: Glyph {}
    public enum f: Glyph {}
    public enum g: Glyph {}
    public enum h: Glyph {}
    public enum i: Glyph {}
    public enum j: Glyph {}
    public enum k: Glyph {}
    public enum l: Glyph {}
    public enum m: Glyph {}
    public enum n: Glyph {}
    public enum o: Glyph {}
    public enum p: Glyph {}
    public enum q: Glyph {}
    public enum r: Glyph {}
    public enum s: Glyph {}
    public enum t: Glyph {}
    public enum u: Glyph {}
    public enum v: Glyph {}
    public enum w: Glyph {}
    public enum x: Glyph {}
    public enum y: Glyph {}
    public enum z: Glyph {}
}
extension Letter.a {
    public static var typeName: String { "a" }
}
extension Letter.b {
    public static var typeName: String { "b" }
}
extension Letter.c {
    public static var typeName: String { "c" }
}
extension Letter.d {
    public static var typeName: String { "d" }
}
extension Letter.e {
    public static var typeName: String { "e" }
}
extension Letter.f {
    public static var typeName: String { "f" }
}
extension Letter.g {
    public static var typeName: String { "g" }
}
extension Letter.h {
    public static var typeName: String { "h" }
}
extension Letter.i {
    public static var typeName: String { "i" }
}
extension Letter.j {
    public static var typeName: String { "j" }
}
extension Letter.k {
    public static var typeName: String { "k" }
}
extension Letter.l {
    public static var typeName: String { "l" }
}
extension Letter.m {
    public static var typeName: String { "m" }
}
extension Letter.n {
    public static var typeName: String { "n" }
}
extension Letter.o {
    public static var typeName: String { "o" }
}
extension Letter.p {
    public static var typeName: String { "p" }
}
extension Letter.q {
    public static var typeName: String { "q" }
}
extension Letter.r {
    public static var typeName: String { "r" }
}
extension Letter.s {
    public static var typeName: String { "s" }
}
extension Letter.t {
    public static var typeName: String { "t" }
}
extension Letter.u {
    public static var typeName: String { "u" }
}
extension Letter.v {
    public static var typeName: String { "v" }
}
extension Letter.w {
    public static var typeName: String { "w" }
}
extension Letter.x {
    public static var typeName: String { "x" }
}
extension Letter.y {
    public static var typeName: String { "y" }
}
extension Letter.z {
    public static var typeName: String { "z" }
}

/// The capital of any single-character `Structure` — reads `L`'s one character and upper-cases
/// it, so the alphabet stays 26 atoms, not 52.
public enum Cap<
    L: Structure
>: Close {}
extension Cap {
    public static var typeName: String { L.typeName.uppercased() }
}

/// The ten digits, as text glyphs (distinct from `Numeral`'s counting atoms — a glyph's
/// `typeName` is its digit character, a `Numeral`'s is its Swift case name).
public enum TextDigit {
    public enum _0: Glyph {}
    public enum _1: Glyph {}
    public enum _2: Glyph {}
    public enum _3: Glyph {}
    public enum _4: Glyph {}
    public enum _5: Glyph {}
    public enum _6: Glyph {}
    public enum _7: Glyph {}
    public enum _8: Glyph {}
    public enum _9: Glyph {}
}
extension TextDigit._0 {
    public static var typeName: String { "0" }
}
extension TextDigit._1 {
    public static var typeName: String { "1" }
}
extension TextDigit._2 {
    public static var typeName: String { "2" }
}
extension TextDigit._3 {
    public static var typeName: String { "3" }
}
extension TextDigit._4 {
    public static var typeName: String { "4" }
}
extension TextDigit._5 {
    public static var typeName: String { "5" }
}
extension TextDigit._6 {
    public static var typeName: String { "6" }
}
extension TextDigit._7 {
    public static var typeName: String { "7" }
}
extension TextDigit._8 {
    public static var typeName: String { "8" }
}
extension TextDigit._9 {
    public static var typeName: String { "9" }
}
