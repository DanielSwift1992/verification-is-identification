import VerificationIsIdentification
import DocumentKit
import Organization

// GOLDEN PLATE — one run that prints the kit's newest forms as `name = value`
// lines, for the playground's golden vectors. Nothing here is a site artifact:
// the plate exists so the port can seal each form against the kit's own
// reading, and a new form earns a new line, never a new mechanism.

enum PlateFace: SpanLabelMid {
    public typealias Y = ArchCaptionBase
    public typealias FillColor = TextSecondary
    public typealias Size = TextXXS
    public typealias Weight = WeightRegular
    public typealias Content = PlateWord
}
enum PlateWord: Close {}
extension PlateWord {
    public static var typeName: String { "plate" }
}

enum PlateSlot: Close {}
extension PlateSlot {
    public static var typeName: String { "PlateSlot" }
}
enum PlateOn: Close {}
extension PlateOn {
    public static var typeName: String { "PlateOn" }
}
enum PlateRule: SlotRule {
    public typealias Slot = PlateSlot
    public typealias From = PlateSlot
    public typealias Into = PlateOn
}
enum PlateSet<Level: Close>: SlotRule {
    public typealias Slot = PlateSlot
    public typealias From = PlateSlot
    public typealias Into = Level
}

func plateLine(_ name: String, _ value: String) {
    print("golden: \(name) = \(value)")
}

func runGoldens() {
    plateLine("Rung0.count", String(Rung0.count))
    plateLine("Rung1.count", String(Rung1.count))
    plateLine("Rung2.count", String(Rung2.count))
    plateLine("Rung3.count", String(Rung3.count))
    plateLine("Rung4.count", String(Rung4.count))
    plateLine("Rung5.count", String(Rung5.count))
    plateLine("Rung6.count", String(Rung6.count))
    plateLine("Rung7.count", String(Rung7.count))
    plateLine("Rung8.count", String(Rung8.count))

    plateLine("HAlphaGlow", "\(HAlphaGlow.typeName) X=\(HAlphaGlow.XShare.count) Y=\(HAlphaGlow.YShare.count) Z=\(HAlphaGlow.ZShare.count)")
    plateLine("HBetaGlow", "\(HBetaGlow.typeName) X=\(HBetaGlow.XShare.count) Y=\(HBetaGlow.YShare.count) Z=\(HBetaGlow.ZShare.count)")
    plateLine("PaschenGlow", "\(PaschenGlow.typeName) X=\(PaschenGlow.XShare.count) Y=\(PaschenGlow.YShare.count) Z=\(PaschenGlow.ZShare.count)")
    plateLine("NeonYellowGlow", "\(NeonYellowGlow.typeName) X=\(NeonYellowGlow.XShare.count) Y=\(NeonYellowGlow.YShare.count) Z=\(NeonYellowGlow.ZShare.count)")
    plateLine("NeonRedGlow", "\(NeonRedGlow.typeName) X=\(NeonRedGlow.XShare.count) Y=\(NeonRedGlow.YShare.count) Z=\(NeonRedGlow.ZShare.count)")
    plateLine("SodiumDGlow", "\(SodiumDGlow.typeName) X=\(SodiumDGlow.XShare.count) Y=\(SodiumDGlow.YShare.count) Z=\(SodiumDGlow.ZShare.count)")
    plateLine("SodiumIRGlow", "\(SodiumIRGlow.typeName) X=\(SodiumIRGlow.XShare.count) Y=\(SodiumIRGlow.YShare.count) Z=\(SodiumIRGlow.ZShare.count)")

    plateLine("SRGBRedPrimary", "\(SRGBRedPrimary.typeName) X=\(SRGBRedPrimary.XShare.count) Y=\(SRGBRedPrimary.YShare.count) Z=\(SRGBRedPrimary.ZShare.count)")
    plateLine("SRGBGreenPrimary", "\(SRGBGreenPrimary.typeName) X=\(SRGBGreenPrimary.XShare.count) Y=\(SRGBGreenPrimary.YShare.count) Z=\(SRGBGreenPrimary.ZShare.count)")
    plateLine("SRGBBluePrimary", "\(SRGBBluePrimary.typeName) X=\(SRGBBluePrimary.XShare.count) Y=\(SRGBBluePrimary.YShare.count) Z=\(SRGBBluePrimary.ZShare.count)")
    plateLine("P3RedPrimary", "\(P3RedPrimary.typeName) X=\(P3RedPrimary.XShare.count) Y=\(P3RedPrimary.YShare.count) Z=\(P3RedPrimary.ZShare.count)")
    plateLine("P3GreenPrimary", "\(P3GreenPrimary.typeName) X=\(P3GreenPrimary.XShare.count) Y=\(P3GreenPrimary.YShare.count) Z=\(P3GreenPrimary.ZShare.count)")
    plateLine("P3BluePrimary", "\(P3BluePrimary.typeName) X=\(P3BluePrimary.XShare.count) Y=\(P3BluePrimary.YShare.count) Z=\(P3BluePrimary.ZShare.count)")
    plateLine("Rec2020RedPrimary", "\(Rec2020RedPrimary.typeName) X=\(Rec2020RedPrimary.XShare.count) Y=\(Rec2020RedPrimary.YShare.count) Z=\(Rec2020RedPrimary.ZShare.count)")
    plateLine("Rec2020GreenPrimary", "\(Rec2020GreenPrimary.typeName) X=\(Rec2020GreenPrimary.XShare.count) Y=\(Rec2020GreenPrimary.YShare.count) Z=\(Rec2020GreenPrimary.ZShare.count)")
    plateLine("Rec2020BluePrimary", "\(Rec2020BluePrimary.typeName) X=\(Rec2020BluePrimary.XShare.count) Y=\(Rec2020BluePrimary.YShare.count) Z=\(Rec2020BluePrimary.ZShare.count)")

    plateLine(
        "PouredCoordinate(Rung8*HAlphaX + Rung0*HBetaX + Rung0*PaschenX).count",
        String(PouredCoordinate<Rung8, HAlphaGlow.XShare, Rung0, HBetaGlow.XShare, Rung0, PaschenGlow.XShare>.count)
    )
    plateLine(
        "XYZWrite(full h-alpha)",
        XYZWrite<
            PouredCoordinate<Rung8, HAlphaGlow.XShare, Rung0, HBetaGlow.XShare, Rung0, PaschenGlow.XShare>,
            PouredCoordinate<Rung8, HAlphaGlow.YShare, Rung0, HBetaGlow.YShare, Rung0, PaschenGlow.YShare>,
            PouredCoordinate<Rung8, HAlphaGlow.ZShare, Rung0, HBetaGlow.ZShare, Rung0, PaschenGlow.ZShare>
        >.typeName
    )

    plateLine("PerceptualRung(Undimmed)", PerceptualRung<Undimmed>.typeName)
    plateLine("PerceptualRung(Quenched)", PerceptualRung<Quenched>.typeName)
    plateLine("PerceptualRung(walk 00010011)", PerceptualRung<Dimmer<Dimmer<Dimmer<Brighter<Dimmer<Dimmer<Brighter<Brighter<Settled>>>>>>>>>.typeName)

    plateLine("EdgeSame(equal)", EdgeSame<Rung4, Rung4, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("EdgeSame(unequal)", EdgeSame<Rung4, Rung5, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("EdgeAtLeast(holds)", EdgeAtLeast<Rung5, Rung4, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("EdgeAtLeast(short)", EdgeAtLeast<Rung4, Rung5, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("EdgeEven(Rung4)", EdgeEven<Rung4, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("EdgeOdd(Rung4)", EdgeOdd<Rung4, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("EdgeOdd(Rung5)", EdgeOdd<Rung5, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))

    plateLine("RuleKey(bare generic)", RuleKey<PlateRule, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("RuleKey(Exactly instance)", RuleKey<Exactly<PlateSet<PlateOn>>, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))
    plateLine("RuleKey(bare would cut it)", RuleKey<PlateSet<PlateOn>, PlateFace>.rendered(atX: RowStart.self, width: GivenSpan<WideSurface>.self))

    print("golden plate: 40 lines, sealed by this build")
}
