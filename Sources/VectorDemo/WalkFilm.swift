import VerificationIsIdentification
import DocumentKit
import Organization

// walk-film.svg — the phone-book walk playing itself to one person, a film of pure
// statics. Every frame is the real step: the two door faces are `NameSpan` witnesses of
// the very shelves they name, the word line is the path spelled so far, and the chosen
// door wears the accent. SVG's own clock (SMIL, TimedReveal/FrozenReveal) advances the
// frames; the last frame freezes on the survivor — the film ends in the fixed point it
// was walking to, and a real link stands on the name. The frames are generated with the
// walk itself (GeneratedWalkFilm.swift): the shelves shift when the roster changes, and
// the film follows.

typealias FilmCanvasSize = CanvasSize<WideSurface, FilmTall>
enum FilmTall: Close {}
extension FilmTall {
    public static var typeName: String { "150" }
}
enum FilmWordY: Close {}
extension FilmWordY {
    public static var typeName: String { "34" }
}
enum FilmDoorAY: Close {}
extension FilmDoorAY {
    public static var typeName: String { "76" }
}
enum FilmDoorBY: Close {}
extension FilmDoorBY {
    public static var typeName: String { "110" }
}

enum FilmGroundPlate: SpanTrackOutlined {
    public typealias H = FilmTall
    public typealias Radius = R12
    public typealias Fill = SurfaceCard
    public typealias Stroke = LineRole
}
enum FilmGroundRow: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Flexible<FilmGroundPlate>.self
    }
}

enum FilmWordSpan<T: Structure>: SpanLabelMid {
    public typealias Y = FilmWordY
    public typealias FillColor = TextSecondary
    public typealias Size = TextXS
    public typealias Weight = WeightRegular
    public typealias Content = T
}
enum FilmDoorSpan<T: Structure, Y: Structure, Ink: Structure, W: Structure>: SpanLabelMid {
    public typealias Y = Y
    public typealias FillColor = Ink
    public typealias Size = TextS
    public typealias Weight = W
    public typealias Content = T
}

/// One step's picture: the word so far, then both door faces, the taken one bold in the
/// action voice, the other quiet. `Taken`/`Passed` are the faces in walk order.
enum FilmStepArt<
    Word: Structure,
    DoorA: Structure,
    DoorB: Structure,
    InkA: Structure,
    WeightA: Structure,
    InkB: Structure,
    WeightB: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<
            Layered<
                FilmWordSpan<Word>,
                Layered<
                    FilmDoorSpan<DoorA, FilmDoorAY, InkA, WeightA>,
                    FilmDoorSpan<DoorB, FilmDoorBY, InkB, WeightB>
                >
            >
        >.self
        Air<EdgeMargin>.self
    }
}
typealias FilmStepLeft<Word: Structure, DoorA: Structure, DoorB: Structure> =
    FilmStepArt<Word, DoorA, DoorB, ActionRole, WeightBold, TextSecondary, WeightRegular>
typealias FilmStepRight<Word: Structure, DoorA: Structure, DoorB: Structure> =
    FilmStepArt<Word, DoorA, DoorB, TextSecondary, WeightRegular, ActionRole, WeightBold>

enum FilmSurvivorY: Close {}
extension FilmSurvivorY {
    public static var typeName: String { "82" }
}
/// The last frame: the survivor's name, large, on a real link to their page.
enum FilmSurvivorArt<
    Face: Structure,
    To: Structure
>: HFlow {
    public typealias Given = WideSurface
    @StructureBuilder
    public static var body: some Structure & Divides {
        Air<EdgeMargin>.self
        Flexible<
            SpanLink<
                SitePath<To>,
                SpanLift<FilmDoorSpan<Face, FilmSurvivorY, TextPrimary, WeightBold>>
            >
        >.self
        Air<EdgeMargin>.self
    }
}
