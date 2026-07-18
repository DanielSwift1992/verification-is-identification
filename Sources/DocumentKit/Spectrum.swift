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

// ── The spectral bridge: mixing is a type. A line's weight per rung is a
// stated magnitude (256ths of one full pour), a level is a stated rung, and a
// pour is Plus of Times — the sum lives in the structure and Tally's own count
// reads it. Nothing computes outside the one edge write that prints three
// counts, the same class of door as ``Lit``'s radix print. No chart is wired
// into the pour and nothing is clamped here: a value always exists, and the
// device behind the edge write decides its own reach. A quenched row is
// ``Never``, so beams differing only there pour to one identical value by
// construction. ──

/// A stated line weight per rung of the ladder: three magnitudes, chart-neutral,
/// in 256ths of one full pour. Stating them is the bridge's whole job. The
/// line weights below are coarse: their pedigree is the qualitative shape of
/// the visible locus, and refinement arrives as reference data, never as code.
/// The display primaries further down are exact, from published matrices.
public protocol CanonicalWeights {
    associatedtype XShare: Structure
    associatedtype YShare: Structure
    associatedtype ZShare: Structure
}

/// The picker's ladder, stated as magnitudes with a documented count: rung
/// zero is the floor, rung eight is one full pour.
public typealias Rung0 = Never
public typealias Rung1 = Unit
public typealias Rung2 = Twice<Unit>
public typealias Rung3 = Plus<Twice<Unit>, Unit>
public typealias Rung4 = Twice<Twice<Unit>>
public typealias Rung5 = Plus<Twice<Twice<Unit>>, Unit>
public typealias Rung6 = Twice<Plus<Twice<Unit>, Unit>>
public typealias Rung7 = Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>
public typealias Rung8 = Twice<Twice<Twice<Unit>>>

/// The H-α line, 656 nm, per rung: a long-wave pour, no short-wave part.
public enum HAlphaGlow: CanonicalWeights, Close {}
extension HAlphaGlow {
    public typealias XShare = Rung7
    public typealias YShare = Rung2
    public typealias ZShare = Never
    public static var typeName: String { "h-alpha" }
}

/// The H-β line, 486 nm, per rung: a short-wave pour with a middle lift.
public enum HBetaGlow: CanonicalWeights, Close {}
extension HBetaGlow {
    public typealias XShare = Rung2
    public typealias YShare = Rung7
    public typealias ZShare = Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Twice<Twice<Unit>>>>>
    public static var typeName: String { "h-beta" }
}

/// The Paschen-α line, 1875 nm, per rung: every share ``Never``. The line is
/// real and the standard observer receives none of it.
public enum PaschenGlow: CanonicalWeights, Close {}
extension PaschenGlow {
    public typealias XShare = Never
    public typealias YShare = Never
    public typealias ZShare = Never
    public static var typeName: String { "paschen-alpha" }
}

/// Neon's yellow-orange line, 585 nm, per rung.
public enum NeonYellowGlow: CanonicalWeights, Close {}
extension NeonYellowGlow {
    public typealias XShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Unit>
    public typealias YShare = Twice<Twice<Twice<Twice<Unit>>>>
    public typealias ZShare = Never
    public static var typeName: String { "neon-585" }
}

/// Neon's red-orange line, 640 nm, per rung.
public enum NeonRedGlow: CanonicalWeights, Close {}
extension NeonRedGlow {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Unit>
    public typealias YShare = Twice<Twice<Unit>>
    public typealias ZShare = Never
    public static var typeName: String { "neon-640" }
}

/// Sodium's D doublet, 589 nm, per rung: the yellow of a street lamp.
public enum SodiumDGlow: CanonicalWeights, Close {}
extension SodiumDGlow {
    public typealias XShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Twice<Unit>>
    public typealias YShare = Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>>
    public typealias ZShare = Never
    public static var typeName: String { "sodium-589" }
}

/// Sodium's infrared line, 819 nm, per rung: every share ``Never``. A second
/// blind row, so sodium carries its own metameric pair.
public enum SodiumIRGlow: CanonicalWeights, Close {}
extension SodiumIRGlow {
    public typealias XShare = Never
    public typealias YShare = Never
    public typealias ZShare = Never
    public static var typeName: String { "sodium-819" }
}

/// One canonical coordinate of a pour: three levels times their line's share,
/// summed by composition. The sum IS this type — Tally's count reads it, and
/// no code adds anything anywhere.
public typealias PouredCoordinate<
    A: Structure, ShareA: Structure,
    B: Structure, ShareB: Structure,
    C: Structure, ShareC: Structure
> = Plus<Times<A, ShareA>, Plus<Times<B, ShareB>, Times<C, ShareC>>>

/// The chart-neutral edge write: three canonical sums printed as the browser's
/// own device-independent form, `color(xyz-d65 …)`, in 256ths. The device maps
/// the value onto whatever it can reach — the clamp, where one must happen, is
/// the device's own, never the canon's. This door reads three counts and
/// prints them, the same class of door as ``Lit``'s radix print; a narrower
/// chart is one more door beside it, never a new pour.
public enum XYZWrite<
    X: Structure,
    Y: Structure,
    Z: Structure
>: Close {}
extension XYZWrite {
    public static var typeName: String {
        let thousandths: (Int) -> String = { value in
            let scaled = value * 1000 / 256
            let whole = scaled / 1000
            let rest = scaled % 1000
            let padded = rest < 10 ? "00\(rest)" : rest < 100 ? "0\(rest)" : "\(rest)"
            return "\(whole).\(padded)"
        }
        return "color(xyz-d65 " + thousandths(X.count)
            + " " + thousandths(Y.count)
            + " " + thousandths(Z.count) + ")"
    }
}

// ── The stated displays: a primary is a stated source like any line, so a
// display is three CanonicalWeights atoms and nothing new. Unlike the lines,
// a primary's pedigree is exact: each triple below is the column of the
// standard's own published conversion matrix (sRGB: IEC 61966-2-1; Display
// P3: SMPTE EG 432-1; Rec.2020: ITU-R BT.2020), stated on the lattice at one
// thirty-second per rung, rounded once. With them a chart's cone is data, and
// a gamut badge is a threshold read at the edge, never a clamp in the canon. ──

/// The sRGB red primary: 0.4124, 0.2126, 0.0193, in thirty-seconds per rung.
public enum SRGBRedPrimary: CanonicalWeights, Close {}
extension SRGBRedPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Unit>>
    public typealias YShare = Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>
    public typealias ZShare = Unit
    public static var typeName: String { "srgb-red" }
}

/// The sRGB green primary: 0.3576, 0.7152, 0.1192.
public enum SRGBGreenPrimary: CanonicalWeights, Close {}
extension SRGBGreenPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Unit>, Unit>>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>>
    public typealias ZShare = Twice<Twice<Unit>>
    public static var typeName: String { "srgb-green" }
}

/// The sRGB blue primary: 0.1805, 0.0722, 0.9505.
public enum SRGBBluePrimary: CanonicalWeights, Close {}
extension SRGBBluePrimary {
    public typealias XShare = Twice<Plus<Twice<Unit>, Unit>>
    public typealias YShare = Twice<Unit>
    public typealias ZShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Twice<Unit>>>>
    public static var typeName: String { "srgb-blue" }
}

/// The Display P3 red primary: 0.4866, 0.2290, 0.0000.
public enum P3RedPrimary: CanonicalWeights, Close {}
extension P3RedPrimary {
    public typealias XShare = Twice<Twice<Twice<Twice<Unit>>>>
    public typealias YShare = Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>
    public typealias ZShare = Never
    public static var typeName: String { "p3-red" }
}

/// The Display P3 green primary: 0.2657, 0.6917, 0.0451.
public enum P3GreenPrimary: CanonicalWeights, Close {}
extension P3GreenPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Unit>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Unit>>, Twice<Unit>>>
    public typealias ZShare = Unit
    public static var typeName: String { "p3-green" }
}

/// The Display P3 blue primary: 0.1982, 0.0793, 1.0439. The Z share passes one
/// full pour: the canon has no ceiling, and the lattice states beyond it.
public enum P3BluePrimary: CanonicalWeights, Close {}
extension P3BluePrimary {
    public typealias XShare = Twice<Plus<Twice<Unit>, Unit>>
    public typealias YShare = Plus<Twice<Unit>, Unit>
    public typealias ZShare = Plus<Twice<Twice<Twice<Twice<Twice<Unit>>>>>, Unit>
    public static var typeName: String { "p3-blue" }
}

/// The Rec.2020 red primary: 0.6370, 0.2627, 0.0000.
public enum Rec2020RedPrimary: CanonicalWeights, Close {}
extension Rec2020RedPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Twice<Twice<Unit>>>
    public typealias YShare = Twice<Twice<Twice<Unit>>>
    public typealias ZShare = Never
    public static var typeName: String { "rec2020-red" }
}

/// The Rec.2020 green primary: 0.1446, 0.6780, 0.0281.
public enum Rec2020GreenPrimary: CanonicalWeights, Close {}
extension Rec2020GreenPrimary {
    public typealias XShare = Plus<Twice<Twice<Unit>>, Unit>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Unit>>, Twice<Unit>>>
    public typealias ZShare = Unit
    public static var typeName: String { "rec2020-green" }
}

/// The Rec.2020 blue primary: 0.1689, 0.0593, 1.0610. The widest stated blue,
/// and its Z passes one full pour by two thirty-seconds.
public enum Rec2020BluePrimary: CanonicalWeights, Close {}
extension Rec2020BluePrimary {
    public typealias XShare = Plus<Twice<Twice<Unit>>, Unit>
    public typealias YShare = Twice<Unit>
    public typealias ZShare = Plus<Twice<Twice<Twice<Twice<Twice<Unit>>>>>, Twice<Unit>>
    public static var typeName: String { "rec2020-blue" }
}

/// This reads a band's perceptual rung at the edge: the position of the
/// highest lit door, zero for a quenched band. Brightness perception runs on
/// ratios, a halving is one ratio, so the rung is the level's logarithm and
/// equal rung-steps are equal felt steps. Felt distance is a difference of
/// rungs, never of counts.
public enum PerceptualRung<Band: Shade>: Close {}
extension PerceptualRung {
    public static var typeName: String {
        let marks = Band.typeName
        precondition(marks.count == 8, "a band settles in eight cuts, not \(marks.count)")
        for (offset, mark) in marks.enumerated() {
            if mark == "1" { return String(8 - offset) }
        }
        return "0"
    }
}
