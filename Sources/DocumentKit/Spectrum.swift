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

// ── The spectral bridge: a stated line weight is the SHAPE of one full pour —
// which bands, in which proportions — and the door's ladder is the stated
// discretization of the edge: how many rungs climb to full. Shape and ladder
// are orthogonal by law (depth is a walk), so there is one weight per line and
// one Steps atom per instrument, never a second table. A gas is not a door
// parameter: a gas is a world's alphabet of slots, and the kit only states the
// weights its lines pour. A line beyond the eye is a quenched row, so beams
// differing only there mix to one identical colour by construction. ──

/// A stated line weight: the shape of one full pour into the three bands, each
/// share a walk like every colour here.
public protocol GlowWeights {
    associatedtype LongShare: Shade
    associatedtype MiddleShare: Shade
    associatedtype ShortShare: Shade
}

/// The H-α line at full pour: nearly the whole long band, nothing else. The
/// red of a hydrogen lamp.
public enum HAlphaGlow: GlowWeights, Close {}
extension HAlphaGlow {
    public typealias LongShare = Brighter<Brighter<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias MiddleShare = Quenched
    public typealias ShortShare = Quenched
    public static var typeName: String { "h-alpha" }
}

/// The H-β line at full pour: a middle-and-short shape, the blue-green of the
/// same lamp.
public enum HBetaGlow: GlowWeights, Close {}
extension HBetaGlow {
    public typealias LongShare = Quenched
    public typealias MiddleShare = Brighter<Dimmer<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias ShortShare = Brighter<Brighter<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public static var typeName: String { "h-beta" }
}

/// The Paschen-α line at full pour: every band quenched. The line is real and
/// the eye receives none of it.
public enum PaschenGlow: GlowWeights, Close {}
extension PaschenGlow {
    public typealias LongShare = Quenched
    public typealias MiddleShare = Quenched
    public typealias ShortShare = Quenched
    public static var typeName: String { "paschen-alpha" }
}

/// Neon's strong yellow-orange line, 585 nm, at full pour.
public enum NeonYellowGlow: GlowWeights, Close {}
extension NeonYellowGlow {
    public typealias LongShare = Brighter<Brighter<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias MiddleShare = Brighter<Dimmer<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias ShortShare = Quenched
    public static var typeName: String { "neon-585" }
}

/// Neon's red-orange line, 640 nm, at full pour.
public enum NeonRedGlow: GlowWeights, Close {}
extension NeonRedGlow {
    public typealias LongShare = Brighter<Brighter<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias MiddleShare = Dimmer<Dimmer<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias ShortShare = Quenched
    public static var typeName: String { "neon-640" }
}

/// Sodium's D doublet, 589 nm, at full pour: the yellow of a street lamp.
public enum SodiumDGlow: GlowWeights, Close {}
extension SodiumDGlow {
    public typealias LongShare = Brighter<Brighter<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias MiddleShare = Brighter<Dimmer<Dimmer<Brighter<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>
    public typealias ShortShare = Quenched
    public static var typeName: String { "sodium-589" }
}

/// Sodium's infrared line, 819 nm, at full pour: quenched in every band. A
/// second blind row, so sodium carries its own metameric pair.
public enum SodiumIRGlow: GlowWeights, Close {}
extension SodiumIRGlow {
    public typealias LongShare = Quenched
    public typealias MiddleShare = Quenched
    public typealias ShortShare = Quenched
    public static var typeName: String { "sodium-819" }
}

/// Eight rungs to full: the stated ladder of a picker whose levels climb 0
/// through 8.
public typealias EightSteps = Twice<Twice<Twice<Unit>>>

/// This is the additive door: three weighted sources, each a stated shape
/// poured at its level, one stated ladder for the instrument. A rung is the
/// shape divided by the steps, the bands sum before the edge, and the clamp is
/// the edge's own saturation. ``Lit`` and ``Veiled`` read one finished walk;
/// this door exists because a mix must be summed before it is encoded.
public enum SpectralFill<
    FirstWeights: GlowWeights, FirstLevel: Structure,
    SecondWeights: GlowWeights, SecondLevel: Structure,
    ThirdWeights: GlowWeights, ThirdLevel: Structure,
    Steps: Structure
>: Close {}
extension SpectralFill {
    public static var typeName: String {
        let walk: (String) -> Int = { marks in
            precondition(marks.count == 8, "a band settles in eight cuts, not \(marks.count)")
            var level = 0
            for mark in marks {
                level = level * 2 + (mark == "1" ? 1 : 0)
            }
            return level
        }
        let steps = Steps.count
        precondition(steps > 0, "a ladder has at least one rung")
        let band: (Int, Int, Int) -> Int = { first, second, third in
            let poured = FirstLevel.count * first + SecondLevel.count * second + ThirdLevel.count * third
            return min(255, poured / steps)
        }
        let red = band(
            walk(FirstWeights.LongShare.typeName),
            walk(SecondWeights.LongShare.typeName),
            walk(ThirdWeights.LongShare.typeName)
        )
        let green = band(
            walk(FirstWeights.MiddleShare.typeName),
            walk(SecondWeights.MiddleShare.typeName),
            walk(ThirdWeights.MiddleShare.typeName)
        )
        let blue = band(
            walk(FirstWeights.ShortShare.typeName),
            walk(SecondWeights.ShortShare.typeName),
            walk(ThirdWeights.ShortShare.typeName)
        )
        return "rgb(\(red),\(green),\(blue))"
    }
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
