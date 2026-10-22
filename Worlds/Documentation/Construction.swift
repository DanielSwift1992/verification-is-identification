import Notation
import DocumentKit

// Composition, geometry and source claims belong to this world.
public enum ConstructionAtom1: Close {}
extension ConstructionAtom1 { public static var typeName: String { "none" } }
public enum ConstructionAtom4: Close {}
extension ConstructionAtom4 { public static var typeName: String { "SEED" } }
public enum ConstructionAtom8: Close {}
extension ConstructionAtom8 { public static var typeName: String { "middle" } }
public enum ConstructionAtom9: Close {}
extension ConstructionAtom9 { public static var typeName: String { "0.88" } }
public enum ConstructionAtom10: Close {}
extension ConstructionAtom10 { public static var typeName: String { "MOVE" } }
public enum ConstructionAtom12: Close {}
extension ConstructionAtom12 { public static var typeName: String { "FLOOR" } }
public enum ConstructionAtom22: Close {}
extension ConstructionAtom22 { public static var typeName: String { "a" } }
public enum ConstructionAtom26: Close {}
extension ConstructionAtom26 { public static var typeName: String { "0" } }
public enum ConstructionAtom27: Close {}
extension ConstructionAtom27 { public static var typeName: String { "b" } }
public enum ConstructionAtom29: Close {}
extension ConstructionAtom29 { public static var typeName: String { "Pair" } }
public enum ConstructionAtom32: Close {}
extension ConstructionAtom32 { public static var typeName: String { "two sides · one boundary" } }
public enum ConstructionAtom34: Close {}
extension ConstructionAtom34 { public static var typeName: String { "expand" } }
public enum ConstructionAtom37: Close {}
extension ConstructionAtom37 { public static var typeName: String { "end" } }
public enum ConstructionAtom39: Close {}
extension ConstructionAtom39 { public static var typeName: String { "url(#arrow)" } }
public enum ConstructionAtom40: Close {}
extension ConstructionAtom40 { public static var typeName: String { "+ axis" } }
public enum ConstructionAtom42: Close {}
extension ConstructionAtom42 { public static var typeName: String { "start" } }
public enum ConstructionAtom43: Close {}
extension ConstructionAtom43 { public static var typeName: String { "compress" } }
public enum ConstructionAtom46: Close {}
extension ConstructionAtom46 { public static var typeName: String { "where" } }
public enum ConstructionAtom47: Close {}
extension ConstructionAtom47 { public static var typeName: String { "two moves" } }
public enum ConstructionAtom48: Close {}
extension ConstructionAtom48 { public static var typeName: String { "no third" } }
public enum ConstructionAtom53: Close {}
extension ConstructionAtom53 { public static var typeName: String { "∅" } }
public enum ConstructionAtom56: Close {}
extension ConstructionAtom56 { public static var typeName: String { "width × depth" } }
public enum ConstructionAtom57: Close {}
extension ConstructionAtom57 { public static var typeName: String { "finite — every chain ends at ∅" } }
public enum ConstructionAtom61: Close {}
extension ConstructionAtom61 { public static var typeName: String { "The construction law" } }
public enum ConstructionAtom62: Close {}
extension ConstructionAtom62 { public static var typeName: String { "One seed — Pair: two sides, one boundary. Two moves — expand, compress. One floor — finite: width times depth." } }

public enum ConstructionGround<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ConstructionAtom26
    public typealias Y = ConstructionAtom26
    public typealias W = ConstructionGroundLayoutW
    public typealias H = ConstructionGroundLayoutH
    public typealias Radius = ConstructionAtom26
    public typealias Fill = Theme.Paper
    public typealias Stroke = ConstructionAtom1
    public typealias Width = ConstructionAtom26
    public typealias Dash = ConstructionAtom1
}

public enum ConstructionPart0<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ConstructionPart0LayoutD
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Muted
    public typealias Width = ConstructionPart0LayoutWidth
    public typealias Dash = ConstructionAtom1
    public typealias Marker = ConstructionAtom1
}

public enum ConstructionPart1<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ConstructionPart1LayoutD
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Muted
    public typealias Width = ConstructionPart1LayoutWidth
    public typealias Dash = ConstructionAtom1
    public typealias Marker = ConstructionAtom1
}

public enum ConstructionPart2<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureRubric
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom4
    public typealias X = ConstructionPart2LayoutX
    public typealias Y = ConstructionPart2LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom9
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart3<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureRubric
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom10
    public typealias X = ConstructionPart3LayoutX
    public typealias Y = ConstructionPart3LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom9
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart4<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureRubric
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom12
    public typealias X = ConstructionPart4LayoutX
    public typealias Y = ConstructionPart4LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom9
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart5<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ConstructionPart5LayoutX
    public typealias Y = ConstructionPart5LayoutY
    public typealias W = ConstructionPart5LayoutW
    public typealias H = ConstructionPart5LayoutH
    public typealias Radius = ConstructionPart5LayoutRadius
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Line
    public typealias Width = ConstructionPart5LayoutWidth
    public typealias Dash = ConstructionAtom1
}

public enum ConstructionPart6<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ConstructionPart6LayoutD
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Muted
    public typealias Width = ConstructionPart6LayoutWidth
    public typealias Dash = ConstructionAtom1
    public typealias Marker = ConstructionAtom1
}

public enum ConstructionPart7<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom22
    public typealias X = ConstructionPart7LayoutX
    public typealias Y = ConstructionPart7LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.InkOnPaper
}

public enum ConstructionPart8<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom27
    public typealias X = ConstructionPart8LayoutX
    public typealias Y = ConstructionPart8LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.InkOnPaper
}

public enum ConstructionPart9<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom29
    public typealias X = ConstructionPart9LayoutX
    public typealias Y = ConstructionPart9LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.LocalType
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.LocalTypeOnPaper
}

public enum ConstructionPart10<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom32
    public typealias X = ConstructionPart10LayoutX
    public typealias Y = ConstructionPart10LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart11<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom34
    public typealias X = ConstructionPart11LayoutX
    public typealias Y = ConstructionPart11LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ConstructionAtom37
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.InkOnPaper
}

public enum ConstructionPart12<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ConstructionPart12LayoutD
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Muted
    public typealias Width = ConstructionPart12LayoutWidth
    public typealias Dash = ConstructionAtom1
    public typealias Marker = ConstructionAtom39
}

public enum ConstructionPart13<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom40
    public typealias X = ConstructionPart13LayoutX
    public typealias Y = ConstructionPart13LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom42
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart14<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom43
    public typealias X = ConstructionPart14LayoutX
    public typealias Y = ConstructionPart14LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ConstructionAtom37
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.InkOnPaper
}

public enum ConstructionPart15<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ConstructionPart15LayoutD
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Muted
    public typealias Width = ConstructionPart15LayoutWidth
    public typealias Dash = ConstructionAtom1
    public typealias Marker = ConstructionAtom39
}

public enum ConstructionPart16<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom46
    public typealias X = ConstructionPart16LayoutX
    public typealias Y = ConstructionPart16LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.LocalType
    public typealias Anchor = ConstructionAtom42
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.LocalTypeOnPaper
}

public enum ConstructionPart17<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom47
    public typealias X = ConstructionPart17LayoutX
    public typealias Y = ConstructionPart17LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.InkOnPaper
}

public enum ConstructionPart18<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom48
    public typealias X = ConstructionPart18LayoutX
    public typealias Y = ConstructionPart18LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart19<Theme: DrawingPalette>: FigureDisk {
    public typealias X = ConstructionPart19LayoutX
    public typealias Y = ConstructionPart19LayoutY
    public typealias Radius = ConstructionPart19LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = ConstructionAtom1
    public typealias Width = ConstructionPart19LayoutWidth
}

public enum ConstructionPart20<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ConstructionPart20LayoutD
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Muted
    public typealias Width = ConstructionPart20LayoutWidth
    public typealias Dash = ConstructionAtom1
    public typealias Marker = ConstructionAtom1
}

public enum ConstructionPart21<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ConstructionPart21LayoutD
    public typealias Fill = ConstructionAtom1
    public typealias Stroke = Theme.Muted
    public typealias Width = ConstructionPart21LayoutWidth
    public typealias Dash = ConstructionAtom1
    public typealias Marker = ConstructionAtom1
}

public enum ConstructionPart22<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom53
    public typealias X = ConstructionPart22LayoutX
    public typealias Y = ConstructionPart22LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart23<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom53
    public typealias X = ConstructionPart23LayoutX
    public typealias Y = ConstructionPart23LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionPart24<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom56
    public typealias X = ConstructionPart24LayoutX
    public typealias Y = ConstructionPart24LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.InkOnPaper
}

public enum ConstructionPart25<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ConstructionAtom57
    public typealias X = ConstructionPart25LayoutX
    public typealias Y = ConstructionPart25LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ConstructionAtom8
    public typealias Tracking = ConstructionAtom26
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ConstructionLayer0<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ConstructionGround<Theme>.self
        ConstructionPart0<Theme>.self
        ConstructionPart1<Theme>.self
        ConstructionPart2<Theme>.self
        ConstructionPart3<Theme>.self
        ConstructionPart4<Theme>.self
        ConstructionPart5<Theme>.self
        ConstructionPart6<Theme>.self
    }
}

public enum ConstructionLayer1<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ConstructionPart7<Theme>.self
        ConstructionPart8<Theme>.self
        ConstructionPart9<Theme>.self
        ConstructionPart10<Theme>.self
        ConstructionPart11<Theme>.self
        ConstructionPart12<Theme>.self
        ConstructionPart13<Theme>.self
        ConstructionPart14<Theme>.self
    }
}

public enum ConstructionLayer2<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ConstructionPart15<Theme>.self
        ConstructionPart16<Theme>.self
        ConstructionPart17<Theme>.self
        ConstructionPart18<Theme>.self
        ConstructionPart19<Theme>.self
        ConstructionPart20<Theme>.self
        ConstructionPart21<Theme>.self
        ConstructionPart22<Theme>.self
    }
}

public enum ConstructionLayer3<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ConstructionPart23<Theme>.self
        ConstructionPart24<Theme>.self
        ConstructionPart25<Theme>.self
    }
}

public enum ConstructionContent<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ConstructionLayer0<Theme>.self
        ConstructionLayer1<Theme>.self
        ConstructionLayer2<Theme>.self
        ConstructionLayer3<Theme>.self
    }
}

public enum ConstructionView0: AccessibleFigure {
    public typealias Binding = FigureLight
    public typealias Frame = ConstructionView0LayoutFrame
    public typealias Title = ConstructionAtom61
    public typealias Description = ConstructionAtom62
    public typealias Definitions = FigureDefinitions<FigureLight>
    public typealias Content = ConstructionContent<FigureLight>
}

public enum ConstructionView1: AccessibleFigure {
    public typealias Binding = FigureDark
    public typealias Frame = ConstructionView0LayoutFrame
    public typealias Title = ConstructionAtom61
    public typealias Description = ConstructionAtom62
    public typealias Definitions = FigureDefinitions<FigureDark>
    public typealias Content = ConstructionContent<FigureDark>
}

public enum ConstructionGroundLayoutW: Close {}
extension ConstructionGroundLayoutW { public static var typeName: String { "518.4" } }

public enum ConstructionGroundLayoutH: Close {}
extension ConstructionGroundLayoutH { public static var typeName: String { "144" } }

public enum ConstructionPart0LayoutWidth: Close {}
extension ConstructionPart0LayoutWidth { public static var typeName: String { "0.72" } }

public enum ConstructionPart0LayoutD: Close {}
extension ConstructionPart0LayoutD { public static var typeName: String { "M172.8 33.12L172.8 128.16" } }

public enum ConstructionPart1LayoutWidth: Close {}
extension ConstructionPart1LayoutWidth { public static var typeName: String { "0.72" } }

public enum ConstructionPart1LayoutD: Close {}
extension ConstructionPart1LayoutD { public static var typeName: String { "M345.6 33.12L345.6 128.16" } }

public enum ConstructionPart2LayoutX: Close {}
extension ConstructionPart2LayoutX { public static var typeName: String { "86.4" } }

public enum ConstructionPart2LayoutY: Close {}
extension ConstructionPart2LayoutY { public static var typeName: String { "23.04" } }

public enum ConstructionPart3LayoutX: Close {}
extension ConstructionPart3LayoutX { public static var typeName: String { "259.2" } }

public enum ConstructionPart3LayoutY: Close {}
extension ConstructionPart3LayoutY { public static var typeName: String { "23.04" } }

public enum ConstructionPart4LayoutX: Close {}
extension ConstructionPart4LayoutX { public static var typeName: String { "432" } }

public enum ConstructionPart4LayoutY: Close {}
extension ConstructionPart4LayoutY { public static var typeName: String { "23.04" } }

public enum ConstructionPart5LayoutX: Close {}
extension ConstructionPart5LayoutX { public static var typeName: String { "59.04" } }

public enum ConstructionPart5LayoutY: Close {}
extension ConstructionPart5LayoutY { public static var typeName: String { "45.36" } }

public enum ConstructionPart5LayoutW: Close {}
extension ConstructionPart5LayoutW { public static var typeName: String { "54.72" } }

public enum ConstructionPart5LayoutH: Close {}
extension ConstructionPart5LayoutH { public static var typeName: String { "33.12" } }

public enum ConstructionPart5LayoutRadius: Close {}
extension ConstructionPart5LayoutRadius { public static var typeName: String { "6.48" } }

public enum ConstructionPart5LayoutWidth: Close {}
extension ConstructionPart5LayoutWidth { public static var typeName: String { "1.08" } }

public enum ConstructionPart6LayoutWidth: Close {}
extension ConstructionPart6LayoutWidth { public static var typeName: String { "1.44" } }

public enum ConstructionPart6LayoutD: Close {}
extension ConstructionPart6LayoutD { public static var typeName: String { "M86.4 45.36L86.4 78.48" } }

public enum ConstructionPart7LayoutX: Close {}
extension ConstructionPart7LayoutX { public static var typeName: String { "72.72" } }

public enum ConstructionPart7LayoutY: Close {}
extension ConstructionPart7LayoutY { public static var typeName: String { "65.52" } }

public enum ConstructionPart8LayoutX: Close {}
extension ConstructionPart8LayoutX { public static var typeName: String { "100.08" } }

public enum ConstructionPart8LayoutY: Close {}
extension ConstructionPart8LayoutY { public static var typeName: String { "65.52" } }

public enum ConstructionPart9LayoutX: Close {}
extension ConstructionPart9LayoutX { public static var typeName: String { "86.4" } }

public enum ConstructionPart9LayoutY: Close {}
extension ConstructionPart9LayoutY { public static var typeName: String { "108" } }

public enum ConstructionPart10LayoutX: Close {}
extension ConstructionPart10LayoutX { public static var typeName: String { "86.4" } }

public enum ConstructionPart10LayoutY: Close {}
extension ConstructionPart10LayoutY { public static var typeName: String { "122.4" } }

public enum ConstructionPart11LayoutX: Close {}
extension ConstructionPart11LayoutX { public static var typeName: String { "249.12" } }

public enum ConstructionPart11LayoutY: Close {}
extension ConstructionPart11LayoutY { public static var typeName: String { "59.04" } }

public enum ConstructionPart12LayoutWidth: Close {}
extension ConstructionPart12LayoutWidth { public static var typeName: String { "1.08" } }

public enum ConstructionPart12LayoutD: Close {}
extension ConstructionPart12LayoutD { public static var typeName: String { "M253.44 56.16L276.48 56.16" } }

public enum ConstructionPart13LayoutX: Close {}
extension ConstructionPart13LayoutX { public static var typeName: String { "283.68" } }

public enum ConstructionPart13LayoutY: Close {}
extension ConstructionPart13LayoutY { public static var typeName: String { "59.04" } }

public enum ConstructionPart14LayoutX: Close {}
extension ConstructionPart14LayoutX { public static var typeName: String { "249.12" } }

public enum ConstructionPart14LayoutY: Close {}
extension ConstructionPart14LayoutY { public static var typeName: String { "74.88" } }

public enum ConstructionPart15LayoutWidth: Close {}
extension ConstructionPart15LayoutWidth { public static var typeName: String { "1.08" } }

public enum ConstructionPart15LayoutD: Close {}
extension ConstructionPart15LayoutD { public static var typeName: String { "M276.48 72L253.44 72" } }

public enum ConstructionPart16LayoutX: Close {}
extension ConstructionPart16LayoutX { public static var typeName: String { "283.68" } }

public enum ConstructionPart16LayoutY: Close {}
extension ConstructionPart16LayoutY { public static var typeName: String { "74.88" } }

public enum ConstructionPart17LayoutX: Close {}
extension ConstructionPart17LayoutX { public static var typeName: String { "259.2" } }

public enum ConstructionPart17LayoutY: Close {}
extension ConstructionPart17LayoutY { public static var typeName: String { "108" } }

public enum ConstructionPart18LayoutX: Close {}
extension ConstructionPart18LayoutX { public static var typeName: String { "259.2" } }

public enum ConstructionPart18LayoutY: Close {}
extension ConstructionPart18LayoutY { public static var typeName: String { "122.4" } }

public enum ConstructionPart19LayoutX: Close {}
extension ConstructionPart19LayoutX { public static var typeName: String { "432" } }

public enum ConstructionPart19LayoutY: Close {}
extension ConstructionPart19LayoutY { public static var typeName: String { "47.52" } }

public enum ConstructionPart19LayoutRadius: Close {}
extension ConstructionPart19LayoutRadius { public static var typeName: String { "3.6" } }

public enum ConstructionPart19LayoutWidth: Close {}
extension ConstructionPart19LayoutWidth { public static var typeName: String { "0.72" } }

public enum ConstructionPart20LayoutWidth: Close {}
extension ConstructionPart20LayoutWidth { public static var typeName: String { "1.08" } }

public enum ConstructionPart20LayoutD: Close {}
extension ConstructionPart20LayoutD { public static var typeName: String { "M431.28 51.12L420.48 66.24" } }

public enum ConstructionPart21LayoutWidth: Close {}
extension ConstructionPart21LayoutWidth { public static var typeName: String { "1.08" } }

public enum ConstructionPart21LayoutD: Close {}
extension ConstructionPart21LayoutD { public static var typeName: String { "M432.72 51.12L443.52 66.24" } }

public enum ConstructionPart22LayoutX: Close {}
extension ConstructionPart22LayoutX { public static var typeName: String { "420.48" } }

public enum ConstructionPart22LayoutY: Close {}
extension ConstructionPart22LayoutY { public static var typeName: String { "74.88" } }

public enum ConstructionPart23LayoutX: Close {}
extension ConstructionPart23LayoutX { public static var typeName: String { "443.52" } }

public enum ConstructionPart23LayoutY: Close {}
extension ConstructionPart23LayoutY { public static var typeName: String { "74.88" } }

public enum ConstructionPart24LayoutX: Close {}
extension ConstructionPart24LayoutX { public static var typeName: String { "432" } }

public enum ConstructionPart24LayoutY: Close {}
extension ConstructionPart24LayoutY { public static var typeName: String { "108" } }

public enum ConstructionPart25LayoutX: Close {}
extension ConstructionPart25LayoutX { public static var typeName: String { "432" } }

public enum ConstructionPart25LayoutY: Close {}
extension ConstructionPart25LayoutY { public static var typeName: String { "122.4" } }

public enum ConstructionView0LayoutFrame: Close {}
extension ConstructionView0LayoutFrame { public static var typeName: String { "0 0 518.4 144" } }
