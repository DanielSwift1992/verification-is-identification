import VerificationIsIdentification
import DocumentKit
import Organization

// DESIGN12 §2: the `{ }` chip, a small corner mark opting a canvas INTO "show your own code",
// `Linked` to `<Name>Source.md` (`OrgDemo/main.swift` writes it, `Decompiler.swift` computes its
// body). Built entirely from existing Vector atoms (`GlyphRect`, `FilledGroup`, `Label`,
// `Linked`), no new medium-level protocol needed beyond the marker (`SelfShowing`,
// DocumentKit/Vector.swift). A bare name-token per canvas (`PulseSource` and its two siblings,
// below) gives `SitePath` a slug to build from without a real `Screen` type existing for it:
// `SitePath<X>` only ever reads `String(describing: X.self)` (`PageSlug`), so any named type
// works; a page written straight to the catalog (not through `Structure`/`typeName`, since its
// body is a runtime `String(reflecting:)` read, not a compile-time composition) still resolves.

enum PulseSource {}
enum BoardSource {}
enum CyclesHeroSource {}

enum SelfShowingBadgeText: Close {}
extension SelfShowingBadgeText {
    public static var typeName: String { "{ }" }
}
enum SelfShowingBadgeHeight: Close {}
extension SelfShowingBadgeHeight {
    public static var typeName: String { "20" }
}
enum SelfShowingBadgeTextDY: Close {}
extension SelfShowingBadgeTextDY {
    public static var typeName: String { "14" }
}

enum SelfShowingBadgeTrack: SpanTrack {
    public typealias H = SelfShowingBadgeHeight
    public typealias Radius = R6
    public typealias Fill = SurfaceTrack
}
enum SelfShowingBadgeLabelSpan: SpanLabel {
    public typealias Y = SelfShowingBadgeTextDY
    public typealias FillColor = TextSecondary
    public typealias Size = TextS
    public typealias Weight = WeightRegular
    public typealias Content = SelfShowingBadgeText
}
enum SelfShowingBadgeInterior: HFlow {
    public typealias Given = BadgeChipWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<HairBreath>.self
        Flexible<SelfShowingBadgeLabelSpan>.self
    }
}
/// The badge rides one row for every canvas: the whole surface, the chip's slice eight
/// from the right edge, the link around it. Only the drop differs per canvas.
enum SelfShowingBadgeRow<Target: Structure>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<BadgeChipWide, SpanLink<Target, Layered<SelfShowingBadgeTrack, SpanHosted<SelfShowingBadgeInterior>>>>.self
        Air<HairBreath>.self
    }
}

typealias PulseSelfShowingRow = SelfShowingBadgeRow<SitePath<PulseSource>>

typealias BoardSelfShowingRow = SelfShowingBadgeRow<SitePath<BoardSource>>

typealias CyclesSelfShowingRow = SelfShowingBadgeRow<SitePath<CyclesHeroSource>>
