import Notation
import DocumentKit

// Each role selects a binding declared by the pinned palette owner.
public protocol FigureTheme: Open {
    associatedtype Background: Structure
    associatedtype Panel: Structure
    associatedtype Recessed: Structure
    associatedtype Highlight: Structure
    associatedtype OnHighlight: Structure
    associatedtype Ink: Structure
    associatedtype Muted: Structure
    associatedtype Rule: Structure
    associatedtype Law: Structure
    associatedtype Success: Structure
    associatedtype Warning: Structure
}

public enum FigureLight: FigureTheme {
    public typealias Background = BindPaperLight.Colour
    public typealias Panel = BindPaperLight.Colour
    public typealias Recessed = BindMistLight.Colour
    public typealias Highlight = BindAccentLight.Colour
    public typealias OnHighlight = BindInkLight.Colour
    public typealias Ink = BindTextLight.Colour
    public typealias Muted = BindMutedLight.Colour
    public typealias Rule = BindMutedLight.Colour
    public typealias Law = BindLawLight.Colour
    public typealias Success = BindOkLight.Colour
    public typealias Warning = BindRefusalLight.Colour
}

public enum FigureDark: FigureTheme {
    public typealias Background = BindSurfaceCardDark.Colour
    public typealias Panel = BindSurfaceCardDark.Colour
    public typealias Recessed = BindSurfaceCardDark.Colour
    public typealias Highlight = BindSurfaceCardDark.Colour
    public typealias OnHighlight = BindTextDark.Colour
    public typealias Ink = BindTextDark.Colour
    public typealias Muted = BindMutedDark.Colour
    public typealias Rule = BindMutedDark.Colour
    public typealias Law = BindTextDark.Colour
    public typealias Success = BindTextDark.Colour
    public typealias Warning = BindTextDark.Colour
}

public enum FigureDefinitions<Theme: FigureTheme>: Group {
    @StructureBuilder public static var body: some Structure {
        OutlineDefinitions<FigureFont400>.self
        OutlineDefinitions<FigureFont600>.self
        OutlineDefinitions<FigureFont650>.self
        OutlineDefinitions<FigureFont700>.self
        FigureArrow<Theme.Rule>.self
    }
}
