import VerificationIsIdentification

// ═══════════════════════════════════════════════════════════════
// SPECTRUM states colour by the house's one move: division. The atom is White, the whole of
// a screen's light, three wavelength bands at full power. Matter absorbs part of that light,
// and the colour an eye receives is the part that SURVIVES, so a colour here is a walk: for
// each band, eight halvings of its brightness, each door naming which half lived. Eight
// halvings settle a band to one of 256 levels; three settled bands name one of 16,777,216
// colours. Every colour is 24 doors from White.
//
// The first cut of White parts the long waves (the red band) from the short; the second cut
// parts the short into the middle band (green) and the blue. A cut makes two doors, and the
// two doors of one cut are COMPLEMENTS: eat the red band and the survivor is cyan, eat the
// green and it is magenta, eat the blue and it is yellow. The colour wheel's opposite pairs
// fall out of the cuts, the way the phone book's shelves fall out of the roster.
//
// The walk is the identity, so a relation between colours is a relation between words: a
// shared prefix is a shared neighbourhood, and flipping every door is taking the complement.
// The machine forms (`#RRGGBB`, `rgba(...)`) exist only at the reading edge, the same edge
// where a magnitude becomes digits: ``Lit`` and ``Veiled`` are to colour what `Tally` and
// `SpanPx` are to number, the one doors a canvas may take.
// ═══════════════════════════════════════════════════════════════

/// This marks one band's brightness mid-walk: some halvings taken, the rest still open.
/// Both doors carry it forward, and ``Settled`` closes it.
public protocol Shade: Structure {}

/// This ends a band's walk: every halving is taken, the level is decided. Its reading adds
/// no mark, and the readers below insist on finding exactly eight marks before it.
public enum Settled: Shade, Close {}
extension Settled {
    public static var typeName: String { "" }
}

/// This is the door where the brighter half of the band survives the cut. It reads as the
/// mark `1` ahead of the rest of the walk.
public enum Brighter<
    Rest: Shade
>: Shade, Close {}
extension Brighter {
    public static var typeName: String { "1" + Rest.typeName }
}

/// This is the other door of the same cut, ``Brighter``'s complement: the dimmer half
/// survives, mark `0`.
public enum Dimmer<
    Rest: Shade
>: Shade, Close {}
extension Dimmer {
    public static var typeName: String { "0" + Rest.typeName }
}

/// This reads three settled bands as one colour, `#RRGGBB`: the long band (red), then the
/// middle (green), then the short (blue). Inside the read, a walk folds to its level, 0
/// through 255, door marks taken as a binary number, most significant cut first, and a walk
/// of any other depth refuses right here, the way `Rest` refuses an underflow. The one door
/// a canvas may take to a colour; a bare hex anywhere else is the smell this door exists to
/// remove.
public enum Lit<
    LongBand: Shade,
    MiddleBand: Shade,
    ShortBand: Shade
>: Close {}
extension Lit {
    public static var typeName: String {
        let digits: (String) -> String = { marks in
            precondition(marks.count == 8, "a band settles in eight cuts, not \(marks.count)")
            var level = 0
            for mark in marks {
                level = level * 2 + (mark == "1" ? 1 : 0)
            }
            let printed = String(level, radix: 16, uppercase: true)
            return level < 16 ? "0" + printed : printed
        }
        return "#" + digits(LongBand.typeName)
            + digits(MiddleBand.typeName)
            + digits(ShortBand.typeName)
    }
}

/// This reads the same three bands carried at partial cover, `rgba(R,G,B,A)`: ink at eighty
/// hundredths, a hairline at fifteen. The levels fold the way ``Lit``'s do, printed decimal
/// because the `rgba` spelling wants them so. The cover is a stated atom (``Cover06`` and
/// its siblings), never a computed number.
public enum Veiled<
    LongBand: Shade,
    MiddleBand: Shade,
    ShortBand: Shade,
    Cover: Structure
>: Close {}
extension Veiled {
    public static var typeName: String {
        let level: (String) -> String = { marks in
            precondition(marks.count == 8, "a band settles in eight cuts, not \(marks.count)")
            var folded = 0
            for mark in marks {
                folded = folded * 2 + (mark == "1" ? 1 : 0)
            }
            return String(folded)
        }
        return "rgba(" + level(LongBand.typeName)
            + "," + level(MiddleBand.typeName)
            + "," + level(ShortBand.typeName)
            + "," + Cover.typeName + ")"
    }
}

/// This is a band kept whole: the brighter half survives all eight cuts, full power.
public typealias Undimmed =
    Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Settled>>>>>>>>

/// This is a band fully eaten: the dimmer half survives all eight cuts, no light left.
public typealias Quenched =
    Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>

/// This is the atom itself: all three bands whole. Every colour in the house walks down
/// from here.
public typealias White = Lit<Undimmed, Undimmed, Undimmed>

/// This is White fully eaten, the far end of every walk. Shadows read it.
public typealias Black = Lit<Quenched, Quenched, Quenched>

// ── The covers: how much of the ground a veiled colour hides, in hundredths. Seven rungs
// exist because seven are used; a component states no cover these do not own. ──

public enum Cover06: Close {}
extension Cover06 {
    public static var typeName: String { "0.06" }
}
public enum Cover15: Close {}
extension Cover15 {
    public static var typeName: String { "0.15" }
}
public enum Cover16: Close {}
extension Cover16 {
    public static var typeName: String { "0.16" }
}
public enum Cover54: Close {}
extension Cover54 {
    public static var typeName: String { "0.54" }
}
public enum Cover70: Close {}
extension Cover70 {
    public static var typeName: String { "0.70" }
}
public enum Cover80: Close {}
extension Cover80 {
    public static var typeName: String { "0.80" }
}
public enum Cover90: Close {}
extension Cover90 {
    public static var typeName: String { "0.90" }
}
