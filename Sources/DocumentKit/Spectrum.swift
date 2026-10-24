import Notation

/// Declares a composable sequence of brightness decisions.
public protocol Shade: Structure {}

/// Terminates a sequence of brightness decisions with empty text.
public enum Settled: Shade, Close {}
extension Settled {
    public static var typeName: String { "" }
}

/// Prefixes the supplied brightness sequence with a set bit.
public enum Brighter<
    Rest: Shade
>: Shade, Close {}
extension Brighter {
    public static var typeName: String { "1" + Rest.typeName }
}

/// Prefixes the supplied brightness sequence with a cleared bit.
public enum Dimmer<
    Rest: Shade
>: Shade, Close {}
extension Dimmer {
    public static var typeName: String { "0" + Rest.typeName }
}

/// Reads three eight-bit brightness sequences as an sRGB hexadecimal paint.
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

/// Reads three brightness sequences and the supplied cover as an RGBA paint.
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

/// States eight set brightness bits.
public typealias Undimmed =
    Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Brighter<Settled>>>>>>>>

/// States eight cleared brightness bits.
public typealias Quenched =
    Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Dimmer<Settled>>>>>>>>

/// Reads three fully set bands through Lit.
public typealias White = Lit<Undimmed, Undimmed, Undimmed>

/// Reads three fully cleared bands through Lit.
public typealias Black = Lit<Quenched, Quenched, Quenched>

/// Declares the three coordinate shares used by a canonical colour composition.
public protocol CanonicalWeights {
    associatedtype XShare: Structure
    associatedtype YShare: Structure
    associatedtype ZShare: Structure
}

/// States the empty magnitude at the origin of the intensity scale.
public typealias Rung0 = Never
public typealias Rung1 = Unit
public typealias Rung2 = Twice<Unit>
public typealias Rung3 = Plus<Twice<Unit>, Unit>
public typealias Rung4 = Twice<Twice<Unit>>
public typealias Rung5 = Plus<Twice<Twice<Unit>>, Unit>
public typealias Rung6 = Twice<Plus<Twice<Unit>, Unit>>
public typealias Rung7 = Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>
public typealias Rung8 = Twice<Twice<Twice<Unit>>>

/// Declares the canonical coordinate shares for this colour basis.
public enum HAlphaGlow: CanonicalWeights, Close {}
extension HAlphaGlow {
    public typealias XShare = Twice<Twice<Twice<Unit>>>
    public typealias YShare = Plus<Twice<Unit>, Unit>
    public typealias ZShare = Never
    public static var typeName: String { "h-alpha" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum HBetaGlow: CanonicalWeights, Close {}
extension HBetaGlow {
    public typealias XShare = Plus<Twice<Unit>, Unit>
    public typealias YShare = Plus<Twice<Twice<Twice<Unit>>>, Twice<Unit>>
    public typealias ZShare = Plus<Twice<Twice<Twice<Twice<Twice<Unit>>>>>, Unit>
    public static var typeName: String { "h-beta" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum PaschenGlow: CanonicalWeights, Close {}
extension PaschenGlow {
    public typealias XShare = Never
    public typealias YShare = Never
    public typealias ZShare = Never
    public static var typeName: String { "paschen-alpha" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum NeonYellowGlow: CanonicalWeights, Close {}
extension NeonYellowGlow {
    public typealias XShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>>>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Twice<Unit>>>, Twice<Unit>>>
    public typealias ZShare = Never
    public static var typeName: String { "neon-585" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum NeonRedGlow: CanonicalWeights, Close {}
extension NeonRedGlow {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Unit>>
    public typealias YShare = Plus<Twice<Twice<Unit>>, Unit>
    public typealias ZShare = Never
    public static var typeName: String { "neon-640" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum SodiumDGlow: CanonicalWeights, Close {}
extension SodiumDGlow {
    public typealias XShare = Plus<Twice<Twice<Twice<Twice<Twice<Unit>>>>>, Unit>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Twice<Unit>>>, Unit>>
    public typealias ZShare = Never
    public static var typeName: String { "sodium-589" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum SodiumIRGlow: CanonicalWeights, Close {}
extension SodiumIRGlow {
    public typealias XShare = Never
    public typealias YShare = Never
    public typealias ZShare = Never
    public static var typeName: String { "sodium-819" }
}

/// Composes three level-share products as one counted coordinate.
public typealias PouredCoordinate<
    A: Structure, ShareA: Structure,
    B: Structure, ShareB: Structure,
    C: Structure, ShareC: Structure
> = Plus<Times<A, ShareA>, Plus<Times<B, ShareB>, Times<C, ShareC>>>

/// Reads three supplied counts as XYZ coordinates at the canonical scale.
public enum XYZWrite<
    X: Structure,
    Y: Structure,
    Z: Structure
>: Close {}
extension XYZWrite {
    public static var typeName: String { XYZRatioWrite<X, Y, Z, Unit>.typeName }
}

/// Reads three coordinates at the explicitly supplied scale.
public enum XYZRatioWrite<X: Structure, Y: Structure, Z: Structure, Scale: Structure>: Close {}
extension XYZRatioWrite {
    public static var typeName: String {
        let divisor = Scale.count
        precondition(divisor > 0, "XYZRatioWrite requires a positive scale")
        let thousandths: (Int) -> String = { value in
            let scaled = value * 1000 / (256 * divisor)
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

/// Declares the canonical coordinate shares for this colour basis.
public enum SRGBRedPrimary: CanonicalWeights, Close {}
extension SRGBRedPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Unit>>
    public typealias YShare = Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>
    public typealias ZShare = Unit
    public static var typeName: String { "srgb-red" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum SRGBGreenPrimary: CanonicalWeights, Close {}
extension SRGBGreenPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Unit>, Unit>>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>>
    public typealias ZShare = Twice<Twice<Unit>>
    public static var typeName: String { "srgb-green" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum SRGBBluePrimary: CanonicalWeights, Close {}
extension SRGBBluePrimary {
    public typealias XShare = Twice<Plus<Twice<Unit>, Unit>>
    public typealias YShare = Twice<Unit>
    public typealias ZShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Twice<Unit>>>, Plus<Twice<Twice<Unit>>, Twice<Unit>>>>
    public static var typeName: String { "srgb-blue" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum P3RedPrimary: CanonicalWeights, Close {}
extension P3RedPrimary {
    public typealias XShare = Twice<Twice<Twice<Twice<Unit>>>>
    public typealias YShare = Plus<Twice<Twice<Unit>>, Plus<Twice<Unit>, Unit>>
    public typealias ZShare = Never
    public static var typeName: String { "p3-red" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum P3GreenPrimary: CanonicalWeights, Close {}
extension P3GreenPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Unit>>>, Unit>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Unit>>, Twice<Unit>>>
    public typealias ZShare = Unit
    public static var typeName: String { "p3-green" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum P3BluePrimary: CanonicalWeights, Close {}
extension P3BluePrimary {
    public typealias XShare = Twice<Plus<Twice<Unit>, Unit>>
    public typealias YShare = Plus<Twice<Unit>, Unit>
    public typealias ZShare = Plus<Twice<Twice<Twice<Twice<Twice<Unit>>>>>, Unit>
    public static var typeName: String { "p3-blue" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum Rec2020RedPrimary: CanonicalWeights, Close {}
extension Rec2020RedPrimary {
    public typealias XShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Twice<Twice<Unit>>>
    public typealias YShare = Twice<Twice<Twice<Unit>>>
    public typealias ZShare = Never
    public static var typeName: String { "rec2020-red" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum Rec2020GreenPrimary: CanonicalWeights, Close {}
extension Rec2020GreenPrimary {
    public typealias XShare = Plus<Twice<Twice<Unit>>, Unit>
    public typealias YShare = Plus<Twice<Twice<Twice<Twice<Unit>>>>, Plus<Twice<Twice<Unit>>, Twice<Unit>>>
    public typealias ZShare = Unit
    public static var typeName: String { "rec2020-green" }
}

/// Declares the canonical coordinate shares for this colour basis.
public enum Rec2020BluePrimary: CanonicalWeights, Close {}
extension Rec2020BluePrimary {
    public typealias XShare = Plus<Twice<Twice<Unit>>, Unit>
    public typealias YShare = Twice<Unit>
    public typealias ZShare = Plus<Twice<Twice<Twice<Twice<Twice<Unit>>>>>, Twice<Unit>>
    public static var typeName: String { "rec2020-blue" }
}

/// Declares the canonical coordinate shares for this colour basis.
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
