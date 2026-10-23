import Notation
import DocumentKit

public typealias FigureRegister = OutlineRegister

public enum FigureDefinitions<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        OutlineDefinitions<FigureSans400>.self
        OutlineDefinitions<FigureSans600>.self
        OutlineDefinitions<FigureMono400>.self
        FigureArrow<Theme, Theme.Muted>.self
    }
}
