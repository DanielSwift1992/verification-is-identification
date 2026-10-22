import Notation
import DocumentKit

// The gate data reader supplies these roles and measured registers from its pin.
public protocol FigureRegister {
    associatedtype Font: OutlineFontFace
    associatedtype Size: Structure
}

public protocol FigureTheme: Open {
    associatedtype Background: Structure
    associatedtype Panel: Structure
    associatedtype Ink: Structure
    associatedtype Muted: Structure
    associatedtype Rule: Structure
    associatedtype Ok: Structure
    associatedtype Bad: Structure
    associatedtype KnownName: Structure
}

public enum FigureLight: FigureTheme {
    public typealias Background = GatePaperLit
    public typealias Panel = GatePaperLit
    public typealias Ink = GateInkLit
    public typealias Muted = GateMutedLit
    public typealias Rule = GateLineLit
    public typealias Ok = GateOkLit
    public typealias Bad = GateBadLit
    public typealias KnownName = GateKnownNameLit
}

public enum FigureDark: FigureTheme {
    public typealias Background = GatePaperDim
    public typealias Panel = GatePaperDim
    public typealias Ink = GateInkDim
    public typealias Muted = GateMutedDim
    public typealias Rule = GateLineDim
    public typealias Ok = GateOkDim
    public typealias Bad = GateBadDim
    public typealias KnownName = GateKnownNameDim
}

public enum FigureDefinitions<Theme: FigureTheme>: Group {
    @StructureBuilder public static var body: some Structure {
        OutlineDefinitions<FigureSans400>.self
        OutlineDefinitions<FigureSans600>.self
        OutlineDefinitions<FigureMono400>.self
        FigureArrow<Theme.Muted>.self
    }
}
