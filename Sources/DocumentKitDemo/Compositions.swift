import Alphabet
import Notation
import DocumentKit

public protocol GallerySection: Open {}

public typealias VectorExampleSurface = Times<U8, Plus<U16, Plus<U8, Plus<U4, U2>>>>   // 240
public typealias VectorExampleHeightStructure = Times<U2, Plus<U32, U16>>               // 96
typealias VectorExampleColumnWide = Plus<U64, Plus<U32, Plus<U16, U8>>>   // half the surface: one tour station's column
typealias VectorExampleTriggerSlot = Plus<U32, U8>   // the reveal trigger's slot; its dot stands at the middle
typealias VectorExamplePanelInset = Plus<U32, Plus<U8, U4>>   // the revealed panel's text stands this far in
public typealias VectorExampleCanvasSize = CanvasSize<VectorExampleSurface, VectorExampleHeightStructure>

public enum VectorCanvasExampleAlt: Close {}
extension VectorCanvasExampleAlt {
    public static var typeName: String { "A plate reading Vector." }
}
enum VectorCanvasExampleText: Close {}
extension VectorCanvasExampleText {
    static var typeName: String { "Vector" }
}

enum VectorCanvasExamplePlate: RoundedFullBleedRect {
    typealias W = Tally<VectorExampleSurface>
    typealias H = Tally<VectorExampleHeightStructure>
    typealias Radius = R16
    typealias Fill = SurfaceCard
}
enum VectorCanvasExampleLabelY: Close {}
extension VectorCanvasExampleLabelY {
    static var typeName: String { "56" }
}
enum VectorCanvasExampleLabelSpan: SpanLabel {
    typealias Y = VectorCanvasExampleLabelY
    typealias FillColor = TextPrimary
    typealias Size = TitleT
    typealias Weight = WeightRegular
    typealias Content = VectorCanvasExampleText
}
enum VectorCanvasExampleLabel: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<S24Breath>.self
        Flexible<VectorCanvasExampleLabelSpan>.self
    }
}
public enum VectorCanvasExampleContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        VectorCanvasExamplePlate.self
        VectorCanvasExampleLabel.self
    }
}
public enum VectorCanvasExampleDiagram: Diagram {
    public typealias Binding = DocumentationBinding
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorCanvasExampleAlt
    public typealias Content = VectorCanvasExampleContent
}

enum VectorExampleSitePath<X>: Close {}
extension VectorExampleSitePath {
    static var typeName: String { DemoDocumentationRoot.typeName + PageSlug<X>.typeName }
}

public enum VectorHoverExampleAlt: Close {}
extension VectorHoverExampleAlt {
    public static var typeName: String { "A dot that reveals a panel on hover. Its click still navigates." }
}
enum VectorHoverDotCY: Close {}
extension VectorHoverDotCY {
    static var typeName: String { "20" }
}
enum VectorHoverDotSpan: SpanDot {
    typealias CY = VectorHoverDotCY
    typealias R = R10
    typealias Fill = ActionRole
}
enum VectorHoverExampleTrigger: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Fixed<VectorExampleTriggerSlot, SpanLink<SDKExampleSitePath<RestAir>, VectorHoverDotSpan>>.self
        RestAir.self
    }
}

enum VectorHoverPanelPlate: RoundedFullBleedRect {
    typealias W = Tally<VectorExampleSurface>
    typealias H = Tally<VectorExampleHeightStructure>
    typealias Radius = R10
    typealias Fill = SurfaceTrack
}
enum VectorHoverPanelText: Close {}
extension VectorHoverPanelText {
    static var typeName: String { "Revealed on hover" }
}
enum VectorHoverPanelLabelY: Close {}
extension VectorHoverPanelLabelY {
    static var typeName: String { "54" }
}
enum VectorHoverPanelLabelSpan: SpanLabel {
    typealias Y = VectorHoverPanelLabelY
    typealias FillColor = TextPrimary
    typealias Size = TextL
    typealias Weight = WeightRegular
    typealias Content = VectorHoverPanelText
}
enum VectorHoverPanelLabel: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<VectorExamplePanelInset>.self
        Flexible<VectorHoverPanelLabelSpan>.self
    }
}
enum VectorHoverExamplePanel: Group {
    @StructureBuilder
    static var body: some Structure {
        VectorHoverPanelPlate.self
        VectorHoverPanelLabel.self
    }
}
enum VectorHoverExampleReveal: HoverReveal {
    typealias Trigger = VectorHoverExampleTrigger
    typealias Panel = VectorHoverExamplePanel
}
public enum VectorHoverExampleContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        HoverRevealStyle.self
        VectorHoverExampleReveal.self
    }
}
public enum VectorHoverExampleDiagram: Diagram {
    public typealias Binding = DocumentationBinding
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorHoverExampleAlt
    public typealias Content = VectorHoverExampleContent
}

enum SelfShowingExampleSource {}   // a bare name-token — PageSlug only reads String(describing:)

enum SelfShowingExampleSourceCode: Close {}
extension SelfShowingExampleSourceCode {
    static var typeName: String {
        """
        public enum VectorSelfShowingExampleDiagram: Diagram, SelfShowing {
            public typealias Binding = DocumentationBinding
            public typealias Size = VectorExampleCanvasSize
            public typealias AriaLabel = VectorSelfShowingExampleAlt
            public typealias Content = VectorSelfShowingExampleContent
        }
        """
    }
}
typealias SelfShowingExampleSourceTitle = VectorSelfShowingExampleText
enum SelfShowingExampleSourceCaption: Close {}
extension SelfShowingExampleSourceCaption {
    static var typeName: String {
        "The source page and the gallery's code block read the same declared source atom."
    }
}
public enum SelfShowingExampleSourcePage: GallerySection {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { SelfShowingExampleSourceTitle.self }
        SelfShowingExampleSourceCaption.self
        Break.self
        CodeSample { SelfShowingExampleSourceCode.self }
    }
}

public enum VectorSelfShowingExampleAlt: Close {}
extension VectorSelfShowingExampleAlt {
    public static var typeName: String { "A plate reading Self-showing, with a chip that links to its own source." }
}
enum VectorSelfShowingExampleText: Close {}
extension VectorSelfShowingExampleText {
    static var typeName: String { "Self-showing" }
}
enum VectorSelfShowingExamplePlate: RoundedFullBleedRect {
    typealias W = Tally<VectorExampleSurface>
    typealias H = Tally<VectorExampleHeightStructure>
    typealias Radius = R16
    typealias Fill = SurfaceCard
}
enum VectorSelfShowingExampleLabelY: Close {}
extension VectorSelfShowingExampleLabelY {
    static var typeName: String { "56" }
}
enum VectorSelfShowingExampleLabelSpan: SpanLabel {
    typealias Y = VectorSelfShowingExampleLabelY
    typealias FillColor = TextPrimary
    typealias Size = TitleT
    typealias Weight = WeightRegular
    typealias Content = VectorSelfShowingExampleText
}
enum VectorSelfShowingExampleLabel: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<S24Breath>.self
        Flexible<VectorSelfShowingExampleLabelSpan>.self
    }
}

enum SelfShowingBadgeChipText: Close {}
extension SelfShowingBadgeChipText {
    static var typeName: String { "{ }" }
}
enum SelfShowingBadgeChipHeight: Close {}
extension SelfShowingBadgeChipHeight {
    static var typeName: String { "20" }
}
enum SelfShowingBadgeChipTrack: SpanTrack {
    typealias H = SelfShowingBadgeChipHeight
    typealias Radius = R6
    typealias Fill = SurfaceTrack
}
enum SelfShowingBadgeChipTextDY: Close {}
extension SelfShowingBadgeChipTextDY {
    static var typeName: String { "14" }
}
enum SelfShowingBadgeChipLabel: SpanLabel {
    typealias Y = SelfShowingBadgeChipTextDY
    typealias FillColor = TextSecondary
    typealias Size = TextS
    typealias Weight = WeightRegular
    typealias Content = SelfShowingBadgeChipText
}
enum SelfShowingBadgeChipInterior: HFlow {
    typealias Given = SourceLinkWidth
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<HairBreath>.self
        Flexible<SelfShowingBadgeChipLabel>.self
    }
}
enum SelfShowingBadgeChipRow: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        RestAir.self
        Fixed<
            SourceLinkWidth,
            SpanLink<
                VectorExampleSitePath<SelfShowingExampleSource>,
                Layered<SelfShowingBadgeChipTrack, SpanHosted<SelfShowingBadgeChipInterior>>
            >
        >.self
        Air<HairBreath>.self
    }
}
enum SelfShowingBadgeChipY: Close {}
extension SelfShowingBadgeChipY {
    static var typeName: String { "68" }
}
enum SelfShowingBadgeDropped: Dropped {
    typealias Y = SelfShowingBadgeChipY
    typealias Content = SelfShowingBadgeChipRow
}
public enum VectorSelfShowingExampleContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        VectorSelfShowingExamplePlate.self
        VectorSelfShowingExampleLabel.self
        SelfShowingBadgeDropped.self
    }
}
public enum VectorSelfShowingExampleDiagram: Diagram, SelfShowing {
    public typealias Binding = DocumentationBinding
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorSelfShowingExampleAlt
    public typealias Content = VectorSelfShowingExampleContent
}

enum VectorTourStationA {}   // bare name-tokens — PageSlug only reads String(describing:)
enum VectorTourStationB {}

enum VectorTourDotCY: Close {}
extension VectorTourDotCY {
    static var typeName: String { "40" }
}
enum VectorTourDot: SpanDot {
    typealias CY = VectorTourDotCY
    typealias R = R20
    typealias Fill = ActionRole
}
enum VectorTourStationALinkToB: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Fixed<VectorExampleColumnWide, SpanLink<VectorExampleSitePath<VectorTourStationB>, VectorTourDot>>.self
        RestAir.self
    }
}
enum VectorTourLabelY: Close {}
extension VectorTourLabelY {
    static var typeName: String { "76" }
}
enum VectorTourLabelAText: Close {}
extension VectorTourLabelAText {
    static var typeName: String { "Station A" }
}
enum VectorTourLabelBText: Close {}
extension VectorTourLabelBText {
    static var typeName: String { "Station B" }
}
enum VectorTourLabelSpan<T: Structure>: SpanLabelMid {
    typealias Y = VectorTourLabelY
    typealias FillColor = TextPrimary
    typealias Size = TextS
    typealias Weight = WeightRegular
    typealias Content = T
}
enum VectorTourLabelA: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Fixed<VectorExampleColumnWide, VectorTourLabelSpan<VectorTourLabelAText>>.self
        RestAir.self
    }
}
enum VectorTourLabelB: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<VectorExampleColumnWide>.self
        Fixed<VectorExampleColumnWide, VectorTourLabelSpan<VectorTourLabelBText>>.self
        RestAir.self
    }
}

public enum VectorTourExampleAlt: Close {}
extension VectorTourExampleAlt {
    public static var typeName: String { "Station A, a dot linked to Station B's page." }
}
enum VectorTourExampleAsset: Close {}
extension VectorTourExampleAsset {
    static var typeName: String { "vector-tour-station-a" }
}
public enum VectorTourStationAContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        VectorTourStationALinkToB.self
        VectorTourLabelA.self
    }
}
public enum VectorTourStationADiagram: Diagram {
    public typealias Binding = DocumentationBinding
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorTourExampleAlt
    public typealias Content = VectorTourStationAContent
}

enum VectorTourStationBLinkToA: HFlow {
    typealias Given = VectorExampleSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<VectorExampleColumnWide>.self
        Fixed<VectorExampleColumnWide, SpanLink<VectorExampleSitePath<VectorTourStationA>, VectorTourDot>>.self
        RestAir.self
    }
}
public enum VectorTourStationBAlt: Close {}
extension VectorTourStationBAlt {
    public static var typeName: String { "Station B, a dot linked back to Station A's page." }
}
public enum VectorTourStationBContent: Group {
    @StructureBuilder
    public static var body: some Structure {
        VectorTourStationBLinkToA.self
        VectorTourLabelB.self
    }
}
public enum VectorTourStationBDiagram: Diagram {
    public typealias Binding = DocumentationBinding
    public typealias Size = VectorExampleCanvasSize
    public typealias AriaLabel = VectorTourStationBAlt
    public typealias Content = VectorTourStationBContent
}

enum VectorTourStationACaption: Close {}
extension VectorTourStationACaption {
    static var typeName: String { "This canvas links to the other declared station." }
}
enum VectorTourStationBCaption: Close {}
extension VectorTourStationBCaption {
    static var typeName: String { "This canvas links back to the first declared station." }
}
public enum VectorTourStationAPage: GallerySection {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { VectorTourLabelAText.self }
        VectorTourStationACaption.self
        Break.self
        Picture { VectorTourExampleAlt.self; VectorTourExampleAsset.self }
    }
}
public enum VectorTourStationBPage: GallerySection {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { VectorTourLabelBText.self }
        VectorTourStationBCaption.self
        Break.self
        Picture { VectorTourStationBAlt.self; VectorTourStationBAsset.self }
    }
}
enum VectorTourStationBAsset: Close {}
extension VectorTourStationBAsset {
    static var typeName: String { "vector-tour-station-b" }
}


public protocol RolesPalette {
    associatedtype CardColor: Structure
    associatedtype TrackColor: Structure
    associatedtype PrimaryColor: Structure
    associatedtype SecondaryColor: Structure
    associatedtype AccentColor: Structure
    associatedtype ActionColor: Structure
    associatedtype LineColor: Structure
    associatedtype OnAccentColor: Structure
}
enum RolesPlateWidth: Close {}
extension RolesPlateWidth {
    static var typeName: String { "240" }
}
enum RolesPlateHeight: Close {}
extension RolesPlateHeight {
    static var typeName: String { "148" }
}
public typealias RolesPlateHeightStructure = Times<U4, Plus<U32, Plus<U4, U1>>>   // 148
public typealias RolesPlateSize = CanvasSize<RolesPlateSurface, RolesPlateHeightStructure>
enum RolesPlateRow1Y: Close {}
extension RolesPlateRow1Y {
static var typeName: String { "16" } }
enum RolesPlateRow2Y: Close {}
extension RolesPlateRow2Y {
static var typeName: String { "76" } }
enum RolesPlateLabelRow1Y: Close {}
extension RolesPlateLabelRow1Y {
static var typeName: String { "56" } }
enum RolesPlateLabelRow2Y: Close {}
extension RolesPlateLabelRow2Y {
static var typeName: String { "116" } }
enum RolesPlateSwatchH: Close {}
extension RolesPlateSwatchH {
static var typeName: String { "24" } }
enum RolesPlateCardLabelText: Close {}
extension RolesPlateCardLabelText {
static var typeName: String { "Card" } }
enum RolesPlateTrackLabelText: Close {}
extension RolesPlateTrackLabelText {
static var typeName: String { "Track" } }
enum RolesPlatePrimaryLabelText: Close {}
extension RolesPlatePrimaryLabelText {
static var typeName: String { "Primary" } }
enum RolesPlateSecondaryLabelText: Close {}
extension RolesPlateSecondaryLabelText {
static var typeName: String { "Secondary" } }
enum RolesPlateAccentLabelText: Close {}
extension RolesPlateAccentLabelText {
static var typeName: String { "Accent" } }
enum RolesPlateActionLabelText: Close {}
extension RolesPlateActionLabelText {
static var typeName: String { "Action" } }
enum RolesPlateLineLabelText: Close {}
extension RolesPlateLineLabelText {
static var typeName: String { "Line" } }
enum RolesPlateOnAccentLabelText: Close {}
extension RolesPlateOnAccentLabelText {
static var typeName: String { "On accent" } }

enum RolesPlateBackingPlate<
    Palette: RolesPalette
>: RoundedFullBleedRect {
    typealias W = RolesPlateWidth
    typealias H = RolesPlateHeight
    typealias Radius = R16
    typealias Fill = Palette.CardColor
}

enum RolesSwatchFace<
    Fill: Structure,
    Line: Structure
>: SpanTrackOutlined {
    typealias H = RolesPlateSwatchH
    typealias Radius = R4
    typealias Fill = Fill
    typealias Stroke = Line
}
enum RolesCellLabel<
    Ink: Structure,
    T: Structure,
    LabelY: Structure
>: SpanLabel {
    typealias Y = LabelY
    typealias FillColor = Ink
    typealias Size = TextXXS
    typealias Weight = WeightRegular
    typealias Content = T
}
typealias RolesCell<
    Fill: Structure,
    Line: Structure,
    Ink: Structure,
    T: Structure,
    RowY: Structure,
    LabelY: Structure
> = Layered<
    SpanLowered<RowY, RolesSwatchFace<Fill, Line>>,
    RolesCellLabel<Ink, T, LabelY>
>
public typealias RolesPlateSurface = Times<
    U4,
    Plus<
        U32,
        Plus<
            U16,
            Plus<
                U8,
                U4
            >
        >
    >
>   // four sixties: the plate's whole width
enum RolesPlateRowOne<Palette: RolesPalette>: HFlow {
    typealias Given = RolesPlateSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.CardColor, Palette.LineColor, Palette.PrimaryColor, RolesPlateCardLabelText, RolesPlateRow1Y, RolesPlateLabelRow1Y>>.self
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.TrackColor, Palette.LineColor, Palette.PrimaryColor, RolesPlateTrackLabelText, RolesPlateRow1Y, RolesPlateLabelRow1Y>>.self
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.PrimaryColor, Palette.LineColor, Palette.PrimaryColor, RolesPlatePrimaryLabelText, RolesPlateRow1Y, RolesPlateLabelRow1Y>>.self
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.SecondaryColor, Palette.LineColor, Palette.PrimaryColor, RolesPlateSecondaryLabelText, RolesPlateRow1Y, RolesPlateLabelRow1Y>>.self
        RestAir.self
    }
}
enum RolesPlateRowTwo<Palette: RolesPalette>: HFlow {
    typealias Given = RolesPlateSurface
    @StructureBuilder
    static var body: some Structure & Divides {
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.AccentColor, Palette.LineColor, Palette.PrimaryColor, RolesPlateAccentLabelText, RolesPlateRow2Y, RolesPlateLabelRow2Y>>.self
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.ActionColor, Palette.LineColor, Palette.PrimaryColor, RolesPlateActionLabelText, RolesPlateRow2Y, RolesPlateLabelRow2Y>>.self
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.LineColor, Palette.LineColor, Palette.PrimaryColor, RolesPlateLineLabelText, RolesPlateRow2Y, RolesPlateLabelRow2Y>>.self
        Air<U8>.self
        Fixed<Plus<U32, Plus<U16, U2>>, RolesCell<Palette.OnAccentColor, Palette.LineColor, Palette.PrimaryColor, RolesPlateOnAccentLabelText, RolesPlateRow2Y, RolesPlateLabelRow2Y>>.self
        RestAir.self
    }
}
public enum RolesPlateContent<Palette: RolesPalette>: Group {
    @StructureBuilder
    public static var body: some Structure {
        RolesPlateBackingPlate<Palette>.self
        RolesPlateRowOne<Palette>.self
        RolesPlateRowTwo<Palette>.self
    }
}
public enum RolesPlateAlt: Close {}
extension RolesPlateAlt {
    public static var typeName: String { "Eight role names, shown with the documentation world’s paints." }
}
public enum RolesPlate<Palette: RolesPalette>: Diagram {
    public typealias Binding = DocumentationBinding
    public typealias Size = RolesPlateSize
    public typealias AriaLabel = RolesPlateAlt
    public typealias Content = RolesPlateContent<Palette>
}


enum SDKExampleSitePath<X>: Close {}
extension SDKExampleSitePath {
    static var typeName: String { SDKDocumentationRoot.typeName + PageSlug<X>.typeName }
}

public enum LightRolesPalette: RolesPalette {
    public typealias CardColor = SurfaceCard
    public typealias TrackColor = SurfaceTrack
    public typealias PrimaryColor = TextPrimary
    public typealias SecondaryColor = TextSecondary
    public typealias AccentColor = AccentRole
    public typealias ActionColor = ActionRole
    public typealias LineColor = LineRole
    public typealias OnAccentColor = OnAccent
}

public enum DarkRolesPalette: RolesPalette {
    public typealias CardColor = SurfaceCardDark
    public typealias TrackColor = SurfaceTrackDark
    public typealias PrimaryColor = TextPrimaryDark
    public typealias SecondaryColor = TextSecondaryDark
    public typealias AccentColor = AccentRoleDark
    public typealias ActionColor = ActionRoleDark
    public typealias LineColor = LineRoleDark
    public typealias OnAccentColor = OnAccentDark
}
