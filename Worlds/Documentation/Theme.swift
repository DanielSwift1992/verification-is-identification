import Notation
import DocumentKit

public protocol FigureRegister {
    associatedtype Font: OutlineFontFace
    associatedtype Size: Structure
}

public enum FigureDefinitions<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        OutlineDefinitions<FigureSans400>.self
        OutlineDefinitions<FigureSans600>.self
        OutlineDefinitions<FigureMono400>.self
        FigureArrow<Theme, Theme.Muted>.self
    }
}
