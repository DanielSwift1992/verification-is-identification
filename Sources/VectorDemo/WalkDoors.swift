import VerificationIsIdentification
import DocumentKit
import Organization

// The walk's doors, drawn: two cards on a strip, each a real link wearing the RollCall of
// the very half it opens, so a door's face is a witness and its click is the choice. Inert
// as a bare image; live once the host inlines the canvas (the tour stations' own door).
// Only walks with short faces are drawn — the site walk's roll calls outrun a card's width,
// and splitting them into lines is glyph metrics, the stated hole the text cycle owns.

enum WalkDoorTitleBase: Close {}
extension WalkDoorTitleBase {
    public static var typeName: String { "46" }
}
enum WalkDoorFace: SpanCardFace {
    public typealias H = Tally<VerdictCardTall>
    public typealias Radius = R16
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum WalkDoorLabel<Face: Structure>: SpanLabelMid {
    public typealias Y = WalkDoorTitleBase
    public typealias FillColor = TextPrimary
    public typealias Size = TextM
    public typealias Weight = WeightBold
    public typealias Content = Face
}
typealias WalkDoorArt<
    Face: Structure,
    To: Structure
> = SpanLink<To, Layered<WalkDoorFace, SpanHosted<WalkDoorInterior<Face>>>>
enum WalkDoorInterior<Face: Structure>: HFlow {
    public typealias Given = CardWide
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<WalkDoorLabel<Face>>.self
    }
}
enum WalkDoorsRow<
    FaceA: Structure,
    ToA: Structure,
    FaceB: Structure,
    ToB: Structure
>: HFlow {
    public typealias Given = RtoSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        RestAir.self
        Fixed<CardWide, WalkDoorArt<FaceA, ToA>>.self
        Air<Breath>.self
        Fixed<CardWide, WalkDoorArt<FaceB, ToB>>.self
        RestAir.self
    }
}
enum WalkDoorsDefs: Group {
    @StructureBuilder
    public static var body: some Structure {
        SurfaceCardShadow.self
    }
}
enum WalkDoorsStrip<
    Alt: Structure,
    FaceA: Structure,
    ToA: Structure,
    FaceB: Structure,
    ToB: Structure
>: GrownDiagram {
    public typealias Across = RtoSurface
    public typealias AriaLabel = Alt
    public typealias Defs = WalkDoorsDefs
    @StructureBuilder
    public static var body: some Structure & DividesY {
        Air<EdgeMargin>.self
        Fixed<VerdictCardTall, SpanHosted<WalkDoorsRow<FaceA, ToA, FaceB, ToB>>>.self
        Air<EdgeMargin>.self
    }
}
