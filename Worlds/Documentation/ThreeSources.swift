import Notation
import DocumentKit

// Composition, geometry and source claims belong to this world.
public enum ThreeSourcesAtom0: Close {}
extension ThreeSourcesAtom0 { public static var typeName: String { "0" } }
public enum ThreeSourcesAtom4: Close {}
extension ThreeSourcesAtom4 { public static var typeName: String { "none" } }
public enum ThreeSourcesAtom5: Close {}
extension ThreeSourcesAtom5 { public static var typeName: String { "1" } }
public enum ThreeSourcesAtom6: Close {}
extension ThreeSourcesAtom6 { public static var typeName: String { "One reading, three possible sources" } }
public enum ThreeSourcesAtom9: Close {}
extension ThreeSourcesAtom9 { public static var typeName: String { "start" } }
public enum ThreeSourcesAtom10: Close {}
extension ThreeSourcesAtom10 { public static var typeName: String { "The source is one of these three symbolic cases. All give the reading (1, 0)." } }
public enum ThreeSourcesAtom13: Close {}
extension ThreeSourcesAtom13 { public static var typeName: String { "We do not know which one is present." } }
public enum ThreeSourcesAtom23: Close {}
extension ThreeSourcesAtom23 { public static var typeName: String { "Three sources, one reading" } }
public enum ThreeSourcesAtom26: Close {}
extension ThreeSourcesAtom26 { public static var typeName: String { "Possible source states" } }
public enum ThreeSourcesAtom30: Close {}
extension ThreeSourcesAtom30 { public static var typeName: String { "Visible pair" } }
public enum ThreeSourcesAtom32: Close {}
extension ThreeSourcesAtom32 { public static var typeName: String { "(" } }
public enum ThreeSourcesAtom36: Close {}
extension ThreeSourcesAtom36 { public static var typeName: String { "," } }
public enum ThreeSourcesAtom41: Close {}
extension ThreeSourcesAtom41 { public static var typeName: String { ")" } }
public enum ThreeSourcesAtom45: Close {}
extension ThreeSourcesAtom45 { public static var typeName: String { "url(#arrow)" } }
public enum ThreeSourcesAtom49: Close {}
extension ThreeSourcesAtom49 { public static var typeName: String { "2" } }
public enum ThreeSourcesAtom51: Close {}
extension ThreeSourcesAtom51 { public static var typeName: String { "The reading keeps" } }
public enum ThreeSourcesAtom54: Close {}
extension ThreeSourcesAtom54 { public static var typeName: String { "two coordinates" } }
public enum ThreeSourcesAtom57: Close {}
extension ThreeSourcesAtom57 { public static var typeName: String { "E(α, β, r) = (α, β)" } }
public enum ThreeSourcesAtom64: Close {}
extension ThreeSourcesAtom64 { public static var typeName: String { "(1, 0)" } }
public enum ThreeSourcesAtom67: Close {}
extension ThreeSourcesAtom67 { public static var typeName: String { "middle" } }
public enum ThreeSourcesAtom68: Close {}
extension ThreeSourcesAtom68 { public static var typeName: String { "Only the third coordinate, r, differs. It is hidden from this reading." } }
public enum ThreeSourcesAtom73: Close {}
extension ThreeSourcesAtom73 { public static var typeName: String { "What can this reading answer?" } }
public enum ThreeSourcesAtom74: Close {}
extension ThreeSourcesAtom74 { public static var typeName: String { "What is the visible pair?" } }
public enum ThreeSourcesAtom77: Close {}
extension ThreeSourcesAtom77 { public static var typeName: String { "What is the hidden value?" } }
public enum ThreeSourcesAtom83: Close {}
extension ThreeSourcesAtom83 { public static var typeName: String { "(1, 0) in every case" } }
public enum ThreeSourcesAtom87: Close {}
extension ThreeSourcesAtom87 { public static var typeName: String { "Could be 0, 1, or 2" } }
public enum ThreeSourcesAtom91: Close {}
extension ThreeSourcesAtom91 { public static var typeName: String { "3" } }
public enum ThreeSourcesAtom93: Close {}
extension ThreeSourcesAtom93 { public static var typeName: String { "One operation, the same visible result" } }
public enum ThreeSourcesAtom94: Close {}
extension ThreeSourcesAtom94 { public static var typeName: String { "SwapVisible exchanges the first two coordinates and keeps the hidden one." } }
public enum ThreeSourcesAtom96: Close {}
extension ThreeSourcesAtom96 { public static var typeName: String { "Original state" } }
public enum ThreeSourcesAtom99: Close {}
extension ThreeSourcesAtom99 { public static var typeName: String { "After SwapVisible" } }
public enum ThreeSourcesAtom122: Close {}
extension ThreeSourcesAtom122 { public static var typeName: String { "(0, 1)" } }
public enum ThreeSourcesAtom132: Close {}
extension ThreeSourcesAtom132 { public static var typeName: String { "The full states still differ. The visible pair is (0, 1) in every case." } }
public enum ThreeSourcesAtom134: Close {}
extension ThreeSourcesAtom134 { public static var typeName: String { "The new reading follows by swapping the old pair: (1, 0) → (0, 1)." } }
public enum ThreeSourcesAtom136: Close {}
extension ThreeSourcesAtom136 { public static var typeName: String { "T(α, β, r) = (β, α, r)" } }
public enum ThreeSourcesAtom138: Close {}
extension ThreeSourcesAtom138 { public static var typeName: String { "E ∘ T = swap ∘ E" } }
public enum ThreeSourcesAtom141: Close {}
extension ThreeSourcesAtom141 { public static var typeName: String { "4" } }
public enum ThreeSourcesAtom143: Close {}
extension ThreeSourcesAtom143 { public static var typeName: String { "A different operation makes the hidden value matter" } }
public enum ThreeSourcesAtom144: Close {}
extension ThreeSourcesAtom144 { public static var typeName: String { "From the same original states, ExposeHidden puts r in the visible pair." } }
public enum ThreeSourcesAtom147: Close {}
extension ThreeSourcesAtom147 { public static var typeName: String { "After ExposeHidden" } }
public enum ThreeSourcesAtom153: Close {}
extension ThreeSourcesAtom153 { public static var typeName: String { "(0, 0)" } }
public enum ThreeSourcesAtom162: Close {}
extension ThreeSourcesAtom162 { public static var typeName: String { "(2, 0)" } }
public enum ThreeSourcesAtom163: Close {}
extension ThreeSourcesAtom163 { public static var typeName: String { "The old reading (1, 0) alone cannot tell us which new pair results." } }
public enum ThreeSourcesAtom165: Close {}
extension ThreeSourcesAtom165 { public static var typeName: String { "For this new answer, we need an observation that distinguishes these cases." } }
public enum ThreeSourcesAtom167: Close {}
extension ThreeSourcesAtom167 { public static var typeName: String { "U(α, β, r) = (r, 0, 0)" } }
public enum ThreeSourcesAtom170: Close {}
extension ThreeSourcesAtom170 { public static var typeName: String { "The source is one of three symbolic states: (1,0,0), (1,0,1), (1,0,2). The reading E keeps the first two coordinates, giving (1,0) in all three cases. It determines the visible pair, but not the hidden value. SwapVisible exchanges the first two coordinates and retains the third: the full outputs still differ, but all have visible pair (0,1). Starting from the original states, ExposeHidden instead maps (alpha,beta,r) to (r,0,0), giving three different visible pairs. The original reading alone cannot determine this new answer." } }
public enum ThreeSourcesAtom172: Close {}
extension ThreeSourcesAtom172 { public static var typeName: String { "Three symbolic source states yield the same visible pair (1,0). The reading determines that pair. The hidden value can be 0, 1 or 2." } }
public enum ThreeSourcesAtom174: Close {}
extension ThreeSourcesAtom174 { public static var typeName: String { "Two operations on the same three possible sources" } }
public enum ThreeSourcesAtom175: Close {}
extension ThreeSourcesAtom175 { public static var typeName: String { "SwapVisible produces distinct full states with the same visible pair (0,1). Starting again from the original states, ExposeHidden gives visible pairs (0,0), (1,0), and (2,0). The old reading alone cannot determine this new answer." } }


public enum ThreeSourcesPart0<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesAtom0
    public typealias Y = ThreeSourcesAtom0
    public typealias W = ThreeSourcesPart0LayoutW
    public typealias H = ThreeSourcesPart0LayoutH
    public typealias Radius = ThreeSourcesPart0LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = ThreeSourcesAtom4
    public typealias Width = ThreeSourcesPart0LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart1<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadline
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom6
    public typealias X = ThreeSourcesPart1LayoutX
    public typealias Y = ThreeSourcesPart1LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart2<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom10
    public typealias X = ThreeSourcesPart2LayoutX
    public typealias Y = ThreeSourcesPart2LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart3<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom13
    public typealias X = ThreeSourcesPart3LayoutX
    public typealias Y = ThreeSourcesPart3LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart4<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart4LayoutX
    public typealias Y = ThreeSourcesPart4LayoutY
    public typealias W = ThreeSourcesPart4LayoutW
    public typealias H = ThreeSourcesPart4LayoutH
    public typealias Radius = ThreeSourcesPart4LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart4LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart5<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart5LayoutX
    public typealias Y = ThreeSourcesPart5LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart6<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom23
    public typealias X = ThreeSourcesPart6LayoutX
    public typealias Y = ThreeSourcesPart6LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart7<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom26
    public typealias X = ThreeSourcesPart7LayoutX
    public typealias Y = ThreeSourcesPart7LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart8<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom30
    public typealias X = ThreeSourcesPart8LayoutX
    public typealias Y = ThreeSourcesPart8LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ReadingColumnMiddle
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart9<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart9LayoutX
    public typealias Y = ThreeSourcesPart9LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart10<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart10LayoutX
    public typealias Y = ThreeSourcesPart10LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart11<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart11LayoutX
    public typealias Y = ThreeSourcesPart11LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart12<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart12LayoutX
    public typealias Y = ThreeSourcesPart12LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart13<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart13LayoutX
    public typealias Y = ThreeSourcesPart13LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart14<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart14LayoutX
    public typealias Y = ThreeSourcesPart14LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart15<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart15LayoutX
    public typealias Y = ThreeSourcesPart15LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart16<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart16LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart16LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart17<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart17LayoutX
    public typealias Y = ThreeSourcesPart17LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart18<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart18LayoutX
    public typealias Y = ThreeSourcesPart18LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart19<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart19LayoutX
    public typealias Y = ThreeSourcesPart19LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart20<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart20LayoutX
    public typealias Y = ThreeSourcesPart20LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart21<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart21LayoutX
    public typealias Y = ThreeSourcesPart21LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart22<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart22LayoutX
    public typealias Y = ThreeSourcesPart22LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart23<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart23LayoutX
    public typealias Y = ThreeSourcesPart23LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart24<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart24LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart24LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart25<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart25LayoutX
    public typealias Y = ThreeSourcesPart25LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart26<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart26LayoutX
    public typealias Y = ThreeSourcesPart26LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart27<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart27LayoutX
    public typealias Y = ThreeSourcesPart27LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart28<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart28LayoutX
    public typealias Y = ThreeSourcesPart28LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart29<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart29LayoutX
    public typealias Y = ThreeSourcesPart29LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart30<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom49
    public typealias X = ThreeSourcesPart30LayoutX
    public typealias Y = ThreeSourcesPart30LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart31<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart31LayoutX
    public typealias Y = ThreeSourcesPart31LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart32<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart32LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart32LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart33<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom51
    public typealias X = ThreeSourcesPart33LayoutX
    public typealias Y = ThreeSourcesPart33LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart34<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom54
    public typealias X = ThreeSourcesPart34LayoutX
    public typealias Y = ThreeSourcesPart34LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart35<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart35LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart35LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart36<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom57
    public typealias X = ThreeSourcesPart36LayoutX
    public typealias Y = ThreeSourcesPart36LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart37<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart37LayoutX
    public typealias Y = ThreeSourcesPart37LayoutY
    public typealias W = ThreeSourcesPart37LayoutW
    public typealias H = ThreeSourcesPart37LayoutH
    public typealias Radius = ThreeSourcesPart37LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart37LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart38<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom64
    public typealias X = ThreeSourcesPart38LayoutX
    public typealias Y = ThreeSourcesPart38LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom67
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart39<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom68
    public typealias X = ThreeSourcesPart39LayoutX
    public typealias Y = ThreeSourcesPart39LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart40<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart40LayoutX
    public typealias Y = ThreeSourcesPart40LayoutY
    public typealias W = ThreeSourcesPart40LayoutW
    public typealias H = ThreeSourcesPart40LayoutH
    public typealias Radius = ThreeSourcesPart40LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart40LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart41<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom49
    public typealias X = ThreeSourcesPart41LayoutX
    public typealias Y = ThreeSourcesPart41LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart42<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom73
    public typealias X = ThreeSourcesPart42LayoutX
    public typealias Y = ThreeSourcesPart42LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart43<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom74
    public typealias X = ThreeSourcesPart43LayoutX
    public typealias Y = ThreeSourcesPart43LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart44<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom77
    public typealias X = ThreeSourcesPart44LayoutX
    public typealias Y = ThreeSourcesPart44LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart45<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart45LayoutX
    public typealias Y = ThreeSourcesPart45LayoutY
    public typealias W = ThreeSourcesPart45LayoutW
    public typealias H = ThreeSourcesPart45LayoutH
    public typealias Radius = ThreeSourcesPart45LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart45LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart46<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom83
    public typealias X = ThreeSourcesPart46LayoutX
    public typealias Y = ThreeSourcesPart46LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ok
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.OkOnPaper
}

public enum ThreeSourcesPart47<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart47LayoutX
    public typealias Y = ThreeSourcesPart47LayoutY
    public typealias W = ThreeSourcesPart47LayoutW
    public typealias H = ThreeSourcesPart47LayoutH
    public typealias Radius = ThreeSourcesPart47LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart47LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart48<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom87
    public typealias X = ThreeSourcesPart48LayoutX
    public typealias Y = ThreeSourcesPart48LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart49<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart49LayoutX
    public typealias Y = ThreeSourcesPart49LayoutY
    public typealias W = ThreeSourcesPart49LayoutW
    public typealias H = ThreeSourcesPart49LayoutH
    public typealias Radius = ThreeSourcesPart49LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart49LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart50<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom91
    public typealias X = ThreeSourcesPart50LayoutX
    public typealias Y = ThreeSourcesPart50LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart51<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom93
    public typealias X = ThreeSourcesPart51LayoutX
    public typealias Y = ThreeSourcesPart51LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart52<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom94
    public typealias X = ThreeSourcesPart52LayoutX
    public typealias Y = ThreeSourcesPart52LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart53<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom96
    public typealias X = ThreeSourcesPart53LayoutX
    public typealias Y = ThreeSourcesPart53LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart54<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom99
    public typealias X = ThreeSourcesPart54LayoutX
    public typealias Y = ThreeSourcesPart54LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart55<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom30
    public typealias X = ThreeSourcesPart55LayoutX
    public typealias Y = ThreeSourcesPart55LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ReadingColumnMiddle
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart56<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart56LayoutX
    public typealias Y = ThreeSourcesPart56LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart57<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart57LayoutX
    public typealias Y = ThreeSourcesPart57LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart58<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart58LayoutX
    public typealias Y = ThreeSourcesPart58LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart59<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart59LayoutX
    public typealias Y = ThreeSourcesPart59LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart60<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart60LayoutX
    public typealias Y = ThreeSourcesPart60LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart61<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart61LayoutX
    public typealias Y = ThreeSourcesPart61LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart62<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart62LayoutX
    public typealias Y = ThreeSourcesPart62LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart63<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart63LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart63LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart64<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart64LayoutX
    public typealias Y = ThreeSourcesPart64LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart65<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart65LayoutX
    public typealias Y = ThreeSourcesPart65LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart66<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart66LayoutX
    public typealias Y = ThreeSourcesPart66LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart67<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart67LayoutX
    public typealias Y = ThreeSourcesPart67LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart68<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart68LayoutX
    public typealias Y = ThreeSourcesPart68LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart69<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart69LayoutX
    public typealias Y = ThreeSourcesPart69LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart70<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart70LayoutX
    public typealias Y = ThreeSourcesPart70LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart71<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart71LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart71LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart72<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart72LayoutX
    public typealias Y = ThreeSourcesPart72LayoutY
    public typealias W = ThreeSourcesPart72LayoutW
    public typealias H = ThreeSourcesPart72LayoutH
    public typealias Radius = ThreeSourcesPart72LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart72LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart73<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom122
    public typealias X = ThreeSourcesPart73LayoutX
    public typealias Y = ThreeSourcesPart73LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom67
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart74<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart74LayoutX
    public typealias Y = ThreeSourcesPart74LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart75<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart75LayoutX
    public typealias Y = ThreeSourcesPart75LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart76<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart76LayoutX
    public typealias Y = ThreeSourcesPart76LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart77<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart77LayoutX
    public typealias Y = ThreeSourcesPart77LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart78<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart78LayoutX
    public typealias Y = ThreeSourcesPart78LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart79<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart79LayoutX
    public typealias Y = ThreeSourcesPart79LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart80<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart80LayoutX
    public typealias Y = ThreeSourcesPart80LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart81<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart81LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart81LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart82<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart82LayoutX
    public typealias Y = ThreeSourcesPart82LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart83<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart83LayoutX
    public typealias Y = ThreeSourcesPart83LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart84<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart84LayoutX
    public typealias Y = ThreeSourcesPart84LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart85<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart85LayoutX
    public typealias Y = ThreeSourcesPart85LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart86<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart86LayoutX
    public typealias Y = ThreeSourcesPart86LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart87<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart87LayoutX
    public typealias Y = ThreeSourcesPart87LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart88<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart88LayoutX
    public typealias Y = ThreeSourcesPart88LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart89<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart89LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart89LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart90<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart90LayoutX
    public typealias Y = ThreeSourcesPart90LayoutY
    public typealias W = ThreeSourcesPart90LayoutW
    public typealias H = ThreeSourcesPart90LayoutH
    public typealias Radius = ThreeSourcesPart90LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart90LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart91<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom122
    public typealias X = ThreeSourcesPart91LayoutX
    public typealias Y = ThreeSourcesPart91LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom67
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart92<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart92LayoutX
    public typealias Y = ThreeSourcesPart92LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart93<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart93LayoutX
    public typealias Y = ThreeSourcesPart93LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart94<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart94LayoutX
    public typealias Y = ThreeSourcesPart94LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart95<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart95LayoutX
    public typealias Y = ThreeSourcesPart95LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart96<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart96LayoutX
    public typealias Y = ThreeSourcesPart96LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart97<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom49
    public typealias X = ThreeSourcesPart97LayoutX
    public typealias Y = ThreeSourcesPart97LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart98<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart98LayoutX
    public typealias Y = ThreeSourcesPart98LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart99<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart99LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart99LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart100<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart100LayoutX
    public typealias Y = ThreeSourcesPart100LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart101<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart101LayoutX
    public typealias Y = ThreeSourcesPart101LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart102<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart102LayoutX
    public typealias Y = ThreeSourcesPart102LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart103<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart103LayoutX
    public typealias Y = ThreeSourcesPart103LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart104<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart104LayoutX
    public typealias Y = ThreeSourcesPart104LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart105<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom49
    public typealias X = ThreeSourcesPart105LayoutX
    public typealias Y = ThreeSourcesPart105LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart106<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart106LayoutX
    public typealias Y = ThreeSourcesPart106LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart107<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart107LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart107LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart108<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart108LayoutX
    public typealias Y = ThreeSourcesPart108LayoutY
    public typealias W = ThreeSourcesPart108LayoutW
    public typealias H = ThreeSourcesPart108LayoutH
    public typealias Radius = ThreeSourcesPart108LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart108LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart109<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom122
    public typealias X = ThreeSourcesPart109LayoutX
    public typealias Y = ThreeSourcesPart109LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom67
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart110<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom132
    public typealias X = ThreeSourcesPart110LayoutX
    public typealias Y = ThreeSourcesPart110LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart111<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom134
    public typealias X = ThreeSourcesPart111LayoutX
    public typealias Y = ThreeSourcesPart111LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart112<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom136
    public typealias X = ThreeSourcesPart112LayoutX
    public typealias Y = ThreeSourcesPart112LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart113<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom138
    public typealias X = ThreeSourcesPart113LayoutX
    public typealias Y = ThreeSourcesPart113LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart114<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart114LayoutX
    public typealias Y = ThreeSourcesPart114LayoutY
    public typealias W = ThreeSourcesPart114LayoutW
    public typealias H = ThreeSourcesPart114LayoutH
    public typealias Radius = ThreeSourcesPart114LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart114LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart115<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom141
    public typealias X = ThreeSourcesPart115LayoutX
    public typealias Y = ThreeSourcesPart115LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart116<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureHeadsmall
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom143
    public typealias X = ThreeSourcesPart116LayoutX
    public typealias Y = ThreeSourcesPart116LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart117<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom144
    public typealias X = ThreeSourcesPart117LayoutX
    public typealias Y = ThreeSourcesPart117LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart118<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom96
    public typealias X = ThreeSourcesPart118LayoutX
    public typealias Y = ThreeSourcesPart118LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart119<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom147
    public typealias X = ThreeSourcesPart119LayoutX
    public typealias Y = ThreeSourcesPart119LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart120<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureCaption
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom30
    public typealias X = ThreeSourcesPart120LayoutX
    public typealias Y = ThreeSourcesPart120LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ReadingColumnMiddle
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart121<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart121LayoutX
    public typealias Y = ThreeSourcesPart121LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart122<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart122LayoutX
    public typealias Y = ThreeSourcesPart122LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart123<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart123LayoutX
    public typealias Y = ThreeSourcesPart123LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart124<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart124LayoutX
    public typealias Y = ThreeSourcesPart124LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart125<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart125LayoutX
    public typealias Y = ThreeSourcesPart125LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart126<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart126LayoutX
    public typealias Y = ThreeSourcesPart126LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart127<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart127LayoutX
    public typealias Y = ThreeSourcesPart127LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart128<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart128LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart128LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart129<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart129LayoutX
    public typealias Y = ThreeSourcesPart129LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart130<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart130LayoutX
    public typealias Y = ThreeSourcesPart130LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart131<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart131LayoutX
    public typealias Y = ThreeSourcesPart131LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart132<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart132LayoutX
    public typealias Y = ThreeSourcesPart132LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart133<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart133LayoutX
    public typealias Y = ThreeSourcesPart133LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart134<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart134LayoutX
    public typealias Y = ThreeSourcesPart134LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart135<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart135LayoutX
    public typealias Y = ThreeSourcesPart135LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart136<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart136LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart136LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart137<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart137LayoutX
    public typealias Y = ThreeSourcesPart137LayoutY
    public typealias W = ThreeSourcesPart137LayoutW
    public typealias H = ThreeSourcesPart137LayoutH
    public typealias Radius = ThreeSourcesPart137LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart137LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart138<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom153
    public typealias X = ThreeSourcesPart138LayoutX
    public typealias Y = ThreeSourcesPart138LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom67
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart139<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart139LayoutX
    public typealias Y = ThreeSourcesPart139LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart140<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart140LayoutX
    public typealias Y = ThreeSourcesPart140LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart141<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart141LayoutX
    public typealias Y = ThreeSourcesPart141LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart142<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart142LayoutX
    public typealias Y = ThreeSourcesPart142LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart143<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart143LayoutX
    public typealias Y = ThreeSourcesPart143LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart144<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart144LayoutX
    public typealias Y = ThreeSourcesPart144LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart145<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart145LayoutX
    public typealias Y = ThreeSourcesPart145LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart146<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart146LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart146LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart147<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart147LayoutX
    public typealias Y = ThreeSourcesPart147LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart148<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart148LayoutX
    public typealias Y = ThreeSourcesPart148LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart149<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart149LayoutX
    public typealias Y = ThreeSourcesPart149LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart150<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart150LayoutX
    public typealias Y = ThreeSourcesPart150LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart151<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart151LayoutX
    public typealias Y = ThreeSourcesPart151LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart152<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart152LayoutX
    public typealias Y = ThreeSourcesPart152LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart153<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart153LayoutX
    public typealias Y = ThreeSourcesPart153LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart154<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart154LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart154LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart155<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart155LayoutX
    public typealias Y = ThreeSourcesPart155LayoutY
    public typealias W = ThreeSourcesPart155LayoutW
    public typealias H = ThreeSourcesPart155LayoutH
    public typealias Radius = ThreeSourcesPart155LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart155LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart156<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom64
    public typealias X = ThreeSourcesPart156LayoutX
    public typealias Y = ThreeSourcesPart156LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom67
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart157<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart157LayoutX
    public typealias Y = ThreeSourcesPart157LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart158<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom5
    public typealias X = ThreeSourcesPart158LayoutX
    public typealias Y = ThreeSourcesPart158LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart159<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart159LayoutX
    public typealias Y = ThreeSourcesPart159LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart160<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart160LayoutX
    public typealias Y = ThreeSourcesPart160LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart161<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart161LayoutX
    public typealias Y = ThreeSourcesPart161LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart162<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom49
    public typealias X = ThreeSourcesPart162LayoutX
    public typealias Y = ThreeSourcesPart162LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart163<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart163LayoutX
    public typealias Y = ThreeSourcesPart163LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart164<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart164LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart164LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart165<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom32
    public typealias X = ThreeSourcesPart165LayoutX
    public typealias Y = ThreeSourcesPart165LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart166<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom49
    public typealias X = ThreeSourcesPart166LayoutX
    public typealias Y = ThreeSourcesPart166LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart167<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart167LayoutX
    public typealias Y = ThreeSourcesPart167LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart168<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart168LayoutX
    public typealias Y = ThreeSourcesPart168LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart169<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom36
    public typealias X = ThreeSourcesPart169LayoutX
    public typealias Y = ThreeSourcesPart169LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart170<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom0
    public typealias X = ThreeSourcesPart170LayoutX
    public typealias Y = ThreeSourcesPart170LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart171<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom41
    public typealias X = ThreeSourcesPart171LayoutX
    public typealias Y = ThreeSourcesPart171LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Muted
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.MutedOnPaper
}

public enum ThreeSourcesPart172<Theme: DrawingPalette>: FigureRoute {
    public typealias D = ThreeSourcesPart172LayoutD
    public typealias Fill = ThreeSourcesAtom4
    public typealias Stroke = Theme.Muted
    public typealias Width = ThreeSourcesPart172LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
    public typealias Marker = ThreeSourcesAtom45
}

public enum ThreeSourcesPart173<Theme: DrawingPalette>: FigurePanel {
    public typealias X = ThreeSourcesPart173LayoutX
    public typealias Y = ThreeSourcesPart173LayoutY
    public typealias W = ThreeSourcesPart173LayoutW
    public typealias H = ThreeSourcesPart173LayoutH
    public typealias Radius = ThreeSourcesPart173LayoutRadius
    public typealias Fill = Theme.Paper
    public typealias Stroke = Theme.Line
    public typealias Width = ThreeSourcesPart173LayoutWidth
    public typealias Dash = ThreeSourcesAtom4
}

public enum ThreeSourcesPart174<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom162
    public typealias X = ThreeSourcesPart174LayoutX
    public typealias Y = ThreeSourcesPart174LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom67
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart175<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom163
    public typealias X = ThreeSourcesPart175LayoutX
    public typealias Y = ThreeSourcesPart175LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart176<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureSpeech
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom165
    public typealias X = ThreeSourcesPart176LayoutX
    public typealias Y = ThreeSourcesPart176LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesPart177<Theme: DrawingPalette>: OutlineLabel {
    public typealias Register = FigureFact
    public typealias Font = Register.Font
    public typealias Content = ThreeSourcesAtom167
    public typealias X = ThreeSourcesPart177LayoutX
    public typealias Y = ThreeSourcesPart177LayoutY
    public typealias Size = Register.Size
    public typealias Fill = Theme.Ink
    public typealias Anchor = ThreeSourcesAtom9
    public typealias Tracking = ThreeSourcesAtom0
    public typealias Legibility = Theme.InkOnPaper
}

public enum ThreeSourcesLayer0<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart0<Theme>.self
        ThreeSourcesPart1<Theme>.self
        ThreeSourcesPart2<Theme>.self
        ThreeSourcesPart3<Theme>.self
        ThreeSourcesPart4<Theme>.self
        ThreeSourcesPart5<Theme>.self
        ThreeSourcesPart6<Theme>.self
    }
}

public enum ThreeSourcesLayer1<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart7<Theme>.self
        ThreeSourcesPart8<Theme>.self
        ThreeSourcesPart9<Theme>.self
        ThreeSourcesPart10<Theme>.self
        ThreeSourcesPart11<Theme>.self
        ThreeSourcesPart12<Theme>.self
        ThreeSourcesPart13<Theme>.self
        ThreeSourcesPart14<Theme>.self
    }
}

public enum ThreeSourcesLayer2<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart15<Theme>.self
        ThreeSourcesPart16<Theme>.self
        ThreeSourcesPart17<Theme>.self
        ThreeSourcesPart18<Theme>.self
        ThreeSourcesPart19<Theme>.self
        ThreeSourcesPart20<Theme>.self
        ThreeSourcesPart21<Theme>.self
        ThreeSourcesPart22<Theme>.self
    }
}

public enum ThreeSourcesLayer3<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart23<Theme>.self
        ThreeSourcesPart24<Theme>.self
        ThreeSourcesPart25<Theme>.self
        ThreeSourcesPart26<Theme>.self
        ThreeSourcesPart27<Theme>.self
        ThreeSourcesPart28<Theme>.self
        ThreeSourcesPart29<Theme>.self
        ThreeSourcesPart30<Theme>.self
    }
}

public enum ThreeSourcesLayer4<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart31<Theme>.self
        ThreeSourcesPart32<Theme>.self
        ThreeSourcesPart33<Theme>.self
        ThreeSourcesPart34<Theme>.self
        ThreeSourcesPart35<Theme>.self
        ThreeSourcesPart36<Theme>.self
        ThreeSourcesPart37<Theme>.self
        ThreeSourcesPart38<Theme>.self
    }
}

public enum ThreeSourcesLayer5<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart39<Theme>.self
        ThreeSourcesPart40<Theme>.self
        ThreeSourcesPart41<Theme>.self
        ThreeSourcesPart42<Theme>.self
        ThreeSourcesPart43<Theme>.self
        ThreeSourcesPart44<Theme>.self
        ThreeSourcesPart45<Theme>.self
        ThreeSourcesPart46<Theme>.self
    }
}

public enum ThreeSourcesLayer6<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart47<Theme>.self
        ThreeSourcesPart48<Theme>.self
        ThreeSourcesPart49<Theme>.self
        ThreeSourcesPart50<Theme>.self
        ThreeSourcesPart51<Theme>.self
        ThreeSourcesPart52<Theme>.self
        ThreeSourcesPart53<Theme>.self
        ThreeSourcesPart54<Theme>.self
    }
}

public enum ThreeSourcesLayer7<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart55<Theme>.self
        ThreeSourcesPart56<Theme>.self
        ThreeSourcesPart57<Theme>.self
        ThreeSourcesPart58<Theme>.self
        ThreeSourcesPart59<Theme>.self
        ThreeSourcesPart60<Theme>.self
        ThreeSourcesPart61<Theme>.self
        ThreeSourcesPart62<Theme>.self
    }
}

public enum ThreeSourcesLayer8<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart63<Theme>.self
        ThreeSourcesPart64<Theme>.self
        ThreeSourcesPart65<Theme>.self
        ThreeSourcesPart66<Theme>.self
        ThreeSourcesPart67<Theme>.self
        ThreeSourcesPart68<Theme>.self
        ThreeSourcesPart69<Theme>.self
        ThreeSourcesPart70<Theme>.self
    }
}

public enum ThreeSourcesLayer9<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart71<Theme>.self
        ThreeSourcesPart72<Theme>.self
        ThreeSourcesPart73<Theme>.self
        ThreeSourcesPart74<Theme>.self
        ThreeSourcesPart75<Theme>.self
        ThreeSourcesPart76<Theme>.self
        ThreeSourcesPart77<Theme>.self
        ThreeSourcesPart78<Theme>.self
    }
}

public enum ThreeSourcesLayer10<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart79<Theme>.self
        ThreeSourcesPart80<Theme>.self
        ThreeSourcesPart81<Theme>.self
        ThreeSourcesPart82<Theme>.self
        ThreeSourcesPart83<Theme>.self
        ThreeSourcesPart84<Theme>.self
        ThreeSourcesPart85<Theme>.self
        ThreeSourcesPart86<Theme>.self
    }
}

public enum ThreeSourcesLayer11<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart87<Theme>.self
        ThreeSourcesPart88<Theme>.self
        ThreeSourcesPart89<Theme>.self
        ThreeSourcesPart90<Theme>.self
        ThreeSourcesPart91<Theme>.self
        ThreeSourcesPart92<Theme>.self
        ThreeSourcesPart93<Theme>.self
        ThreeSourcesPart94<Theme>.self
    }
}

public enum ThreeSourcesLayer12<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart95<Theme>.self
        ThreeSourcesPart96<Theme>.self
        ThreeSourcesPart97<Theme>.self
        ThreeSourcesPart98<Theme>.self
        ThreeSourcesPart99<Theme>.self
        ThreeSourcesPart100<Theme>.self
        ThreeSourcesPart101<Theme>.self
        ThreeSourcesPart102<Theme>.self
    }
}

public enum ThreeSourcesLayer13<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart103<Theme>.self
        ThreeSourcesPart104<Theme>.self
        ThreeSourcesPart105<Theme>.self
        ThreeSourcesPart106<Theme>.self
        ThreeSourcesPart107<Theme>.self
        ThreeSourcesPart108<Theme>.self
        ThreeSourcesPart109<Theme>.self
        ThreeSourcesPart110<Theme>.self
    }
}

public enum ThreeSourcesLayer14<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart111<Theme>.self
        ThreeSourcesPart112<Theme>.self
        ThreeSourcesPart113<Theme>.self
        ThreeSourcesPart114<Theme>.self
        ThreeSourcesPart115<Theme>.self
        ThreeSourcesPart116<Theme>.self
        ThreeSourcesPart117<Theme>.self
        ThreeSourcesPart118<Theme>.self
    }
}

public enum ThreeSourcesLayer15<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart119<Theme>.self
        ThreeSourcesPart120<Theme>.self
        ThreeSourcesPart121<Theme>.self
        ThreeSourcesPart122<Theme>.self
        ThreeSourcesPart123<Theme>.self
        ThreeSourcesPart124<Theme>.self
        ThreeSourcesPart125<Theme>.self
        ThreeSourcesPart126<Theme>.self
    }
}

public enum ThreeSourcesLayer16<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart127<Theme>.self
        ThreeSourcesPart128<Theme>.self
        ThreeSourcesPart129<Theme>.self
        ThreeSourcesPart130<Theme>.self
        ThreeSourcesPart131<Theme>.self
        ThreeSourcesPart132<Theme>.self
        ThreeSourcesPart133<Theme>.self
        ThreeSourcesPart134<Theme>.self
    }
}

public enum ThreeSourcesLayer17<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart135<Theme>.self
        ThreeSourcesPart136<Theme>.self
        ThreeSourcesPart137<Theme>.self
        ThreeSourcesPart138<Theme>.self
        ThreeSourcesPart139<Theme>.self
        ThreeSourcesPart140<Theme>.self
        ThreeSourcesPart141<Theme>.self
        ThreeSourcesPart142<Theme>.self
    }
}

public enum ThreeSourcesLayer18<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart143<Theme>.self
        ThreeSourcesPart144<Theme>.self
        ThreeSourcesPart145<Theme>.self
        ThreeSourcesPart146<Theme>.self
        ThreeSourcesPart147<Theme>.self
        ThreeSourcesPart148<Theme>.self
        ThreeSourcesPart149<Theme>.self
        ThreeSourcesPart150<Theme>.self
    }
}

public enum ThreeSourcesLayer19<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart151<Theme>.self
        ThreeSourcesPart152<Theme>.self
        ThreeSourcesPart153<Theme>.self
        ThreeSourcesPart154<Theme>.self
        ThreeSourcesPart155<Theme>.self
        ThreeSourcesPart156<Theme>.self
        ThreeSourcesPart157<Theme>.self
        ThreeSourcesPart158<Theme>.self
    }
}

public enum ThreeSourcesLayer20<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart159<Theme>.self
        ThreeSourcesPart160<Theme>.self
        ThreeSourcesPart161<Theme>.self
        ThreeSourcesPart162<Theme>.self
        ThreeSourcesPart163<Theme>.self
        ThreeSourcesPart164<Theme>.self
        ThreeSourcesPart165<Theme>.self
        ThreeSourcesPart166<Theme>.self
    }
}

public enum ThreeSourcesLayer21<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart167<Theme>.self
        ThreeSourcesPart168<Theme>.self
        ThreeSourcesPart169<Theme>.self
        ThreeSourcesPart170<Theme>.self
        ThreeSourcesPart171<Theme>.self
        ThreeSourcesPart172<Theme>.self
        ThreeSourcesPart173<Theme>.self
        ThreeSourcesPart174<Theme>.self
    }
}

public enum ThreeSourcesLayer22<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesPart175<Theme>.self
        ThreeSourcesPart176<Theme>.self
        ThreeSourcesPart177<Theme>.self
    }
}

public enum ThreeSourcesContent<Theme: DrawingPalette>: Group {
    @StructureBuilder public static var body: some Structure {
        ThreeSourcesLayer0<Theme>.self
        ThreeSourcesLayer1<Theme>.self
        ThreeSourcesLayer2<Theme>.self
        ThreeSourcesLayer3<Theme>.self
        ThreeSourcesLayer4<Theme>.self
        ThreeSourcesLayer5<Theme>.self
        ThreeSourcesLayer6<Theme>.self
        ThreeSourcesLayer7<Theme>.self
        ThreeSourcesLayer8<Theme>.self
        ThreeSourcesLayer9<Theme>.self
        ThreeSourcesLayer10<Theme>.self
        ThreeSourcesLayer11<Theme>.self
        ThreeSourcesLayer12<Theme>.self
        ThreeSourcesLayer13<Theme>.self
        ThreeSourcesLayer14<Theme>.self
        ThreeSourcesLayer15<Theme>.self
        ThreeSourcesLayer16<Theme>.self
        ThreeSourcesLayer17<Theme>.self
        ThreeSourcesLayer18<Theme>.self
        ThreeSourcesLayer19<Theme>.self
        ThreeSourcesLayer20<Theme>.self
        ThreeSourcesLayer21<Theme>.self
        ThreeSourcesLayer22<Theme>.self
    }
}

public enum ThreeSourcesView0: AccessibleFigure {
    public typealias Binding = FigureLight
    public typealias Frame = ThreeSourcesView0LayoutFrame
    public typealias Title = ThreeSourcesAtom6
    public typealias Description = ThreeSourcesAtom170
    public typealias Definitions = FigureDefinitions<FigureLight>
    public typealias Content = ThreeSourcesContent<FigureLight>
}

public enum ThreeSourcesView1: AccessibleFigure {
    public typealias Binding = FigureLight
    public typealias Frame = ThreeSourcesView1LayoutFrame
    public typealias Title = ThreeSourcesAtom6
    public typealias Description = ThreeSourcesAtom172
    public typealias Definitions = FigureDefinitions<FigureLight>
    public typealias Content = ThreeSourcesContent<FigureLight>
}

public enum ThreeSourcesView2: AccessibleFigure {
    public typealias Binding = FigureLight
    public typealias Frame = ThreeSourcesView2LayoutFrame
    public typealias Title = ThreeSourcesAtom174
    public typealias Description = ThreeSourcesAtom175
    public typealias Definitions = FigureDefinitions<FigureLight>
    public typealias Content = ThreeSourcesContent<FigureLight>
}

public enum ThreeSourcesPart0LayoutW: Close {}
extension ThreeSourcesPart0LayoutW { public static var typeName: String { "806.4" } }

public enum ThreeSourcesPart0LayoutH: Close {}
extension ThreeSourcesPart0LayoutH { public static var typeName: String { "1245.6" } }

public enum ThreeSourcesPart0LayoutRadius: Close {}
extension ThreeSourcesPart0LayoutRadius { public static var typeName: String { "11.52" } }

public enum ThreeSourcesPart0LayoutWidth: Close {}
extension ThreeSourcesPart0LayoutWidth { public static var typeName: String { "0.72" } }

public enum ThreeSourcesPart1LayoutX: Close {}
extension ThreeSourcesPart1LayoutX { public static var typeName: String { "28.8" } }

public enum ThreeSourcesPart1LayoutY: Close {}
extension ThreeSourcesPart1LayoutY { public static var typeName: String { "41.04" } }

public enum ThreeSourcesPart2LayoutX: Close {}
extension ThreeSourcesPart2LayoutX { public static var typeName: String { "28.8" } }

public enum ThreeSourcesPart2LayoutY: Close {}
extension ThreeSourcesPart2LayoutY { public static var typeName: String { "72" } }

public enum ThreeSourcesPart3LayoutX: Close {}
extension ThreeSourcesPart3LayoutX { public static var typeName: String { "28.8" } }

public enum ThreeSourcesPart3LayoutY: Close {}
extension ThreeSourcesPart3LayoutY { public static var typeName: String { "96.48" } }

public enum ThreeSourcesPart4LayoutX: Close {}
extension ThreeSourcesPart4LayoutX { public static var typeName: String { "28.8" } }

public enum ThreeSourcesPart4LayoutY: Close {}
extension ThreeSourcesPart4LayoutY { public static var typeName: String { "119.52" } }

public enum ThreeSourcesPart4LayoutW: Close {}
extension ThreeSourcesPart4LayoutW { public static var typeName: String { "748.8" } }

public enum ThreeSourcesPart4LayoutH: Close {}
extension ThreeSourcesPart4LayoutH { public static var typeName: String { "230.4" } }

public enum ThreeSourcesPart4LayoutRadius: Close {}
extension ThreeSourcesPart4LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart4LayoutWidth: Close {}
extension ThreeSourcesPart4LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart5LayoutX: Close {}
extension ThreeSourcesPart5LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart5LayoutY: Close {}
extension ThreeSourcesPart5LayoutY { public static var typeName: String { "151.2" } }

public enum ThreeSourcesPart6LayoutX: Close {}
extension ThreeSourcesPart6LayoutX { public static var typeName: String { "79.2" } }

public enum ThreeSourcesPart6LayoutY: Close {}
extension ThreeSourcesPart6LayoutY { public static var typeName: String { "151.2" } }

public enum ThreeSourcesPart7LayoutX: Close {}
extension ThreeSourcesPart7LayoutX { public static var typeName: String { "75.6" } }

public enum ThreeSourcesPart7LayoutY: Close {}
extension ThreeSourcesPart7LayoutY { public static var typeName: String { "185.76" } }

public enum ThreeSourcesPart8LayoutX: Close {}
extension ThreeSourcesPart8LayoutX { public static var typeName: String { "643.68" } }

public enum ThreeSourcesPart8LayoutY: Close {}
extension ThreeSourcesPart8LayoutY { public static var typeName: String { "185.76" } }

public enum ThreeSourcesPart9LayoutX: Close {}
extension ThreeSourcesPart9LayoutX { public static var typeName: String { "108" } }

public enum ThreeSourcesPart9LayoutY: Close {}
extension ThreeSourcesPart9LayoutY { public static var typeName: String { "222.48" } }

public enum ThreeSourcesPart10LayoutX: Close {}
extension ThreeSourcesPart10LayoutX { public static var typeName: String { "115.526" } }

public enum ThreeSourcesPart10LayoutY: Close {}
extension ThreeSourcesPart10LayoutY { public static var typeName: String { "222.48" } }

public enum ThreeSourcesPart11LayoutX: Close {}
extension ThreeSourcesPart11LayoutX { public static var typeName: String { "123.051" } }

public enum ThreeSourcesPart11LayoutY: Close {}
extension ThreeSourcesPart11LayoutY { public static var typeName: String { "222.48" } }

public enum ThreeSourcesPart12LayoutX: Close {}
extension ThreeSourcesPart12LayoutX { public static var typeName: String { "130.577" } }

public enum ThreeSourcesPart12LayoutY: Close {}
extension ThreeSourcesPart12LayoutY { public static var typeName: String { "222.48" } }

public enum ThreeSourcesPart13LayoutX: Close {}
extension ThreeSourcesPart13LayoutX { public static var typeName: String { "138.103" } }

public enum ThreeSourcesPart13LayoutY: Close {}
extension ThreeSourcesPart13LayoutY { public static var typeName: String { "222.48" } }

public enum ThreeSourcesPart14LayoutX: Close {}
extension ThreeSourcesPart14LayoutX { public static var typeName: String { "145.628" } }

public enum ThreeSourcesPart14LayoutY: Close {}
extension ThreeSourcesPart14LayoutY { public static var typeName: String { "222.48" } }

public enum ThreeSourcesPart15LayoutX: Close {}
extension ThreeSourcesPart15LayoutX { public static var typeName: String { "153.154" } }

public enum ThreeSourcesPart15LayoutY: Close {}
extension ThreeSourcesPart15LayoutY { public static var typeName: String { "222.48" } }

public enum ThreeSourcesPart16LayoutWidth: Close {}
extension ThreeSourcesPart16LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart16LayoutD: Close {}
extension ThreeSourcesPart16LayoutD { public static var typeName: String { "M172.678 215.28H280.8L364.32 255.6" } }

public enum ThreeSourcesPart17LayoutX: Close {}
extension ThreeSourcesPart17LayoutX { public static var typeName: String { "108" } }

public enum ThreeSourcesPart17LayoutY: Close {}
extension ThreeSourcesPart17LayoutY { public static var typeName: String { "262.8" } }

public enum ThreeSourcesPart18LayoutX: Close {}
extension ThreeSourcesPart18LayoutX { public static var typeName: String { "115.526" } }

public enum ThreeSourcesPart18LayoutY: Close {}
extension ThreeSourcesPart18LayoutY { public static var typeName: String { "262.8" } }

public enum ThreeSourcesPart19LayoutX: Close {}
extension ThreeSourcesPart19LayoutX { public static var typeName: String { "123.051" } }

public enum ThreeSourcesPart19LayoutY: Close {}
extension ThreeSourcesPart19LayoutY { public static var typeName: String { "262.8" } }

public enum ThreeSourcesPart20LayoutX: Close {}
extension ThreeSourcesPart20LayoutX { public static var typeName: String { "130.577" } }

public enum ThreeSourcesPart20LayoutY: Close {}
extension ThreeSourcesPart20LayoutY { public static var typeName: String { "262.8" } }

public enum ThreeSourcesPart21LayoutX: Close {}
extension ThreeSourcesPart21LayoutX { public static var typeName: String { "138.103" } }

public enum ThreeSourcesPart21LayoutY: Close {}
extension ThreeSourcesPart21LayoutY { public static var typeName: String { "262.8" } }

public enum ThreeSourcesPart22LayoutX: Close {}
extension ThreeSourcesPart22LayoutX { public static var typeName: String { "145.628" } }

public enum ThreeSourcesPart22LayoutY: Close {}
extension ThreeSourcesPart22LayoutY { public static var typeName: String { "262.8" } }

public enum ThreeSourcesPart23LayoutX: Close {}
extension ThreeSourcesPart23LayoutX { public static var typeName: String { "153.154" } }

public enum ThreeSourcesPart23LayoutY: Close {}
extension ThreeSourcesPart23LayoutY { public static var typeName: String { "262.8" } }

public enum ThreeSourcesPart24LayoutWidth: Close {}
extension ThreeSourcesPart24LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart24LayoutD: Close {}
extension ThreeSourcesPart24LayoutD { public static var typeName: String { "M172.678 255.6H280.8L364.32 255.6" } }

public enum ThreeSourcesPart25LayoutX: Close {}
extension ThreeSourcesPart25LayoutX { public static var typeName: String { "108" } }

public enum ThreeSourcesPart25LayoutY: Close {}
extension ThreeSourcesPart25LayoutY { public static var typeName: String { "303.12" } }

public enum ThreeSourcesPart26LayoutX: Close {}
extension ThreeSourcesPart26LayoutX { public static var typeName: String { "115.526" } }

public enum ThreeSourcesPart26LayoutY: Close {}
extension ThreeSourcesPart26LayoutY { public static var typeName: String { "303.12" } }

public enum ThreeSourcesPart27LayoutX: Close {}
extension ThreeSourcesPart27LayoutX { public static var typeName: String { "123.051" } }

public enum ThreeSourcesPart27LayoutY: Close {}
extension ThreeSourcesPart27LayoutY { public static var typeName: String { "303.12" } }

public enum ThreeSourcesPart28LayoutX: Close {}
extension ThreeSourcesPart28LayoutX { public static var typeName: String { "130.577" } }

public enum ThreeSourcesPart28LayoutY: Close {}
extension ThreeSourcesPart28LayoutY { public static var typeName: String { "303.12" } }

public enum ThreeSourcesPart29LayoutX: Close {}
extension ThreeSourcesPart29LayoutX { public static var typeName: String { "138.103" } }

public enum ThreeSourcesPart29LayoutY: Close {}
extension ThreeSourcesPart29LayoutY { public static var typeName: String { "303.12" } }

public enum ThreeSourcesPart30LayoutX: Close {}
extension ThreeSourcesPart30LayoutX { public static var typeName: String { "145.628" } }

public enum ThreeSourcesPart30LayoutY: Close {}
extension ThreeSourcesPart30LayoutY { public static var typeName: String { "303.12" } }

public enum ThreeSourcesPart31LayoutX: Close {}
extension ThreeSourcesPart31LayoutX { public static var typeName: String { "153.154" } }

public enum ThreeSourcesPart31LayoutY: Close {}
extension ThreeSourcesPart31LayoutY { public static var typeName: String { "303.12" } }

public enum ThreeSourcesPart32LayoutWidth: Close {}
extension ThreeSourcesPart32LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart32LayoutD: Close {}
extension ThreeSourcesPart32LayoutD { public static var typeName: String { "M172.678 295.92H280.8L364.32 255.6" } }

public enum ThreeSourcesPart33LayoutX: Close {}
extension ThreeSourcesPart33LayoutX { public static var typeName: String { "342.72" } }

public enum ThreeSourcesPart33LayoutY: Close {}
extension ThreeSourcesPart33LayoutY { public static var typeName: String { "211.68" } }

public enum ThreeSourcesPart34LayoutX: Close {}
extension ThreeSourcesPart34LayoutX { public static var typeName: String { "342.72" } }

public enum ThreeSourcesPart34LayoutY: Close {}
extension ThreeSourcesPart34LayoutY { public static var typeName: String { "232.56" } }

public enum ThreeSourcesPart35LayoutWidth: Close {}
extension ThreeSourcesPart35LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart35LayoutD: Close {}
extension ThreeSourcesPart35LayoutD { public static var typeName: String { "M372.96 255.6H583.68" } }

public enum ThreeSourcesPart36LayoutX: Close {}
extension ThreeSourcesPart36LayoutX { public static var typeName: String { "378.72" } }

public enum ThreeSourcesPart36LayoutY: Close {}
extension ThreeSourcesPart36LayoutY { public static var typeName: String { "283.68" } }

public enum ThreeSourcesPart37LayoutX: Close {}
extension ThreeSourcesPart37LayoutX { public static var typeName: String { "595.68" } }

public enum ThreeSourcesPart37LayoutY: Close {}
extension ThreeSourcesPart37LayoutY { public static var typeName: String { "231.6" } }

public enum ThreeSourcesPart37LayoutW: Close {}
extension ThreeSourcesPart37LayoutW { public static var typeName: String { "96" } }

public enum ThreeSourcesPart37LayoutH: Close {}
extension ThreeSourcesPart37LayoutH { public static var typeName: String { "48" } }

public enum ThreeSourcesPart37LayoutRadius: Close {}
extension ThreeSourcesPart37LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart37LayoutWidth: Close {}
extension ThreeSourcesPart37LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart38LayoutX: Close {}
extension ThreeSourcesPart38LayoutX { public static var typeName: String { "643.68" } }

public enum ThreeSourcesPart38LayoutY: Close {}
extension ThreeSourcesPart38LayoutY { public static var typeName: String { "260.1" } }

public enum ThreeSourcesPart39LayoutX: Close {}
extension ThreeSourcesPart39LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart39LayoutY: Close {}
extension ThreeSourcesPart39LayoutY { public static var typeName: String { "329.76" } }

public enum ThreeSourcesPart40LayoutX: Close {}
extension ThreeSourcesPart40LayoutX { public static var typeName: String { "28.8" } }

public enum ThreeSourcesPart40LayoutY: Close {}
extension ThreeSourcesPart40LayoutY { public static var typeName: String { "367.2" } }

public enum ThreeSourcesPart40LayoutW: Close {}
extension ThreeSourcesPart40LayoutW { public static var typeName: String { "748.8" } }

public enum ThreeSourcesPart40LayoutH: Close {}
extension ThreeSourcesPart40LayoutH { public static var typeName: String { "165.6" } }

public enum ThreeSourcesPart40LayoutRadius: Close {}
extension ThreeSourcesPart40LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart40LayoutWidth: Close {}
extension ThreeSourcesPart40LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart41LayoutX: Close {}
extension ThreeSourcesPart41LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart41LayoutY: Close {}
extension ThreeSourcesPart41LayoutY { public static var typeName: String { "399.6" } }

public enum ThreeSourcesPart42LayoutX: Close {}
extension ThreeSourcesPart42LayoutX { public static var typeName: String { "79.2" } }

public enum ThreeSourcesPart42LayoutY: Close {}
extension ThreeSourcesPart42LayoutY { public static var typeName: String { "399.6" } }

public enum ThreeSourcesPart43LayoutX: Close {}
extension ThreeSourcesPart43LayoutX { public static var typeName: String { "54.72" } }

public enum ThreeSourcesPart43LayoutY: Close {}
extension ThreeSourcesPart43LayoutY { public static var typeName: String { "439.2" } }

public enum ThreeSourcesPart44LayoutX: Close {}
extension ThreeSourcesPart44LayoutX { public static var typeName: String { "54.72" } }

public enum ThreeSourcesPart44LayoutY: Close {}
extension ThreeSourcesPart44LayoutY { public static var typeName: String { "495.36" } }

public enum ThreeSourcesPart45LayoutX: Close {}
extension ThreeSourcesPart45LayoutX { public static var typeName: String { "388.8" } }

public enum ThreeSourcesPart45LayoutY: Close {}
extension ThreeSourcesPart45LayoutY { public static var typeName: String { "416.88" } }

public enum ThreeSourcesPart45LayoutW: Close {}
extension ThreeSourcesPart45LayoutW { public static var typeName: String { "357.84" } }

public enum ThreeSourcesPart45LayoutH: Close {}
extension ThreeSourcesPart45LayoutH { public static var typeName: String { "42.48" } }

public enum ThreeSourcesPart45LayoutRadius: Close {}
extension ThreeSourcesPart45LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart45LayoutWidth: Close {}
extension ThreeSourcesPart45LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart46LayoutX: Close {}
extension ThreeSourcesPart46LayoutX { public static var typeName: String { "405.36" } }

public enum ThreeSourcesPart46LayoutY: Close {}
extension ThreeSourcesPart46LayoutY { public static var typeName: String { "444.24" } }

public enum ThreeSourcesPart47LayoutX: Close {}
extension ThreeSourcesPart47LayoutX { public static var typeName: String { "388.8" } }

public enum ThreeSourcesPart47LayoutY: Close {}
extension ThreeSourcesPart47LayoutY { public static var typeName: String { "473.04" } }

public enum ThreeSourcesPart47LayoutW: Close {}
extension ThreeSourcesPart47LayoutW { public static var typeName: String { "357.84" } }

public enum ThreeSourcesPart47LayoutH: Close {}
extension ThreeSourcesPart47LayoutH { public static var typeName: String { "42.48" } }

public enum ThreeSourcesPart47LayoutRadius: Close {}
extension ThreeSourcesPart47LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart47LayoutWidth: Close {}
extension ThreeSourcesPart47LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart48LayoutX: Close {}
extension ThreeSourcesPart48LayoutX { public static var typeName: String { "405.36" } }

public enum ThreeSourcesPart48LayoutY: Close {}
extension ThreeSourcesPart48LayoutY { public static var typeName: String { "500.4" } }

public enum ThreeSourcesPart49LayoutX: Close {}
extension ThreeSourcesPart49LayoutX { public static var typeName: String { "28.8" } }

public enum ThreeSourcesPart49LayoutY: Close {}
extension ThreeSourcesPart49LayoutY { public static var typeName: String { "557.28" } }

public enum ThreeSourcesPart49LayoutW: Close {}
extension ThreeSourcesPart49LayoutW { public static var typeName: String { "748.8" } }

public enum ThreeSourcesPart49LayoutH: Close {}
extension ThreeSourcesPart49LayoutH { public static var typeName: String { "326.88" } }

public enum ThreeSourcesPart49LayoutRadius: Close {}
extension ThreeSourcesPart49LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart49LayoutWidth: Close {}
extension ThreeSourcesPart49LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart50LayoutX: Close {}
extension ThreeSourcesPart50LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart50LayoutY: Close {}
extension ThreeSourcesPart50LayoutY { public static var typeName: String { "590.4" } }

public enum ThreeSourcesPart51LayoutX: Close {}
extension ThreeSourcesPart51LayoutX { public static var typeName: String { "79.2" } }

public enum ThreeSourcesPart51LayoutY: Close {}
extension ThreeSourcesPart51LayoutY { public static var typeName: String { "590.4" } }

public enum ThreeSourcesPart52LayoutX: Close {}
extension ThreeSourcesPart52LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart52LayoutY: Close {}
extension ThreeSourcesPart52LayoutY { public static var typeName: String { "621.36" } }

public enum ThreeSourcesPart53LayoutX: Close {}
extension ThreeSourcesPart53LayoutX { public static var typeName: String { "85.68" } }

public enum ThreeSourcesPart53LayoutY: Close {}
extension ThreeSourcesPart53LayoutY { public static var typeName: String { "657.36" } }

public enum ThreeSourcesPart54LayoutX: Close {}
extension ThreeSourcesPart54LayoutX { public static var typeName: String { "352.8" } }

public enum ThreeSourcesPart54LayoutY: Close {}
extension ThreeSourcesPart54LayoutY { public static var typeName: String { "657.36" } }

public enum ThreeSourcesPart55LayoutX: Close {}
extension ThreeSourcesPart55LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart55LayoutY: Close {}
extension ThreeSourcesPart55LayoutY { public static var typeName: String { "657.36" } }

public enum ThreeSourcesPart56LayoutX: Close {}
extension ThreeSourcesPart56LayoutX { public static var typeName: String { "87.84" } }

public enum ThreeSourcesPart56LayoutY: Close {}
extension ThreeSourcesPart56LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart57LayoutX: Close {}
extension ThreeSourcesPart57LayoutX { public static var typeName: String { "95.3656" } }

public enum ThreeSourcesPart57LayoutY: Close {}
extension ThreeSourcesPart57LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart58LayoutX: Close {}
extension ThreeSourcesPart58LayoutX { public static var typeName: String { "102.891" } }

public enum ThreeSourcesPart58LayoutY: Close {}
extension ThreeSourcesPart58LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart59LayoutX: Close {}
extension ThreeSourcesPart59LayoutX { public static var typeName: String { "110.417" } }

public enum ThreeSourcesPart59LayoutY: Close {}
extension ThreeSourcesPart59LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart60LayoutX: Close {}
extension ThreeSourcesPart60LayoutX { public static var typeName: String { "117.943" } }

public enum ThreeSourcesPart60LayoutY: Close {}
extension ThreeSourcesPart60LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart61LayoutX: Close {}
extension ThreeSourcesPart61LayoutX { public static var typeName: String { "125.468" } }

public enum ThreeSourcesPart61LayoutY: Close {}
extension ThreeSourcesPart61LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart62LayoutX: Close {}
extension ThreeSourcesPart62LayoutX { public static var typeName: String { "132.994" } }

public enum ThreeSourcesPart62LayoutY: Close {}
extension ThreeSourcesPart62LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart63LayoutWidth: Close {}
extension ThreeSourcesPart63LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart63LayoutD: Close {}
extension ThreeSourcesPart63LayoutD { public static var typeName: String { "M152.518 685.44H320.4" } }

public enum ThreeSourcesPart64LayoutX: Close {}
extension ThreeSourcesPart64LayoutX { public static var typeName: String { "355.68" } }

public enum ThreeSourcesPart64LayoutY: Close {}
extension ThreeSourcesPart64LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart65LayoutX: Close {}
extension ThreeSourcesPart65LayoutX { public static var typeName: String { "363.206" } }

public enum ThreeSourcesPart65LayoutY: Close {}
extension ThreeSourcesPart65LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart66LayoutX: Close {}
extension ThreeSourcesPart66LayoutX { public static var typeName: String { "370.731" } }

public enum ThreeSourcesPart66LayoutY: Close {}
extension ThreeSourcesPart66LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart67LayoutX: Close {}
extension ThreeSourcesPart67LayoutX { public static var typeName: String { "378.257" } }

public enum ThreeSourcesPart67LayoutY: Close {}
extension ThreeSourcesPart67LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart68LayoutX: Close {}
extension ThreeSourcesPart68LayoutX { public static var typeName: String { "385.783" } }

public enum ThreeSourcesPart68LayoutY: Close {}
extension ThreeSourcesPart68LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart69LayoutX: Close {}
extension ThreeSourcesPart69LayoutX { public static var typeName: String { "393.308" } }

public enum ThreeSourcesPart69LayoutY: Close {}
extension ThreeSourcesPart69LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart70LayoutX: Close {}
extension ThreeSourcesPart70LayoutX { public static var typeName: String { "400.834" } }

public enum ThreeSourcesPart70LayoutY: Close {}
extension ThreeSourcesPart70LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart71LayoutWidth: Close {}
extension ThreeSourcesPart71LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart71LayoutD: Close {}
extension ThreeSourcesPart71LayoutD { public static var typeName: String { "M420.358 685.44H609.28" } }

public enum ThreeSourcesPart72LayoutX: Close {}
extension ThreeSourcesPart72LayoutX { public static var typeName: String { "621.28" } }

public enum ThreeSourcesPart72LayoutY: Close {}
extension ThreeSourcesPart72LayoutY { public static var typeName: String { "667.44" } }

public enum ThreeSourcesPart72LayoutW: Close {}
extension ThreeSourcesPart72LayoutW { public static var typeName: String { "88" } }

public enum ThreeSourcesPart72LayoutH: Close {}
extension ThreeSourcesPart72LayoutH { public static var typeName: String { "33.84" } }

public enum ThreeSourcesPart72LayoutRadius: Close {}
extension ThreeSourcesPart72LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart72LayoutWidth: Close {}
extension ThreeSourcesPart72LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart73LayoutX: Close {}
extension ThreeSourcesPart73LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart73LayoutY: Close {}
extension ThreeSourcesPart73LayoutY { public static var typeName: String { "692.64" } }

public enum ThreeSourcesPart74LayoutX: Close {}
extension ThreeSourcesPart74LayoutX { public static var typeName: String { "87.84" } }

public enum ThreeSourcesPart74LayoutY: Close {}
extension ThreeSourcesPart74LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart75LayoutX: Close {}
extension ThreeSourcesPart75LayoutX { public static var typeName: String { "95.3656" } }

public enum ThreeSourcesPart75LayoutY: Close {}
extension ThreeSourcesPart75LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart76LayoutX: Close {}
extension ThreeSourcesPart76LayoutX { public static var typeName: String { "102.891" } }

public enum ThreeSourcesPart76LayoutY: Close {}
extension ThreeSourcesPart76LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart77LayoutX: Close {}
extension ThreeSourcesPart77LayoutX { public static var typeName: String { "110.417" } }

public enum ThreeSourcesPart77LayoutY: Close {}
extension ThreeSourcesPart77LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart78LayoutX: Close {}
extension ThreeSourcesPart78LayoutX { public static var typeName: String { "117.943" } }

public enum ThreeSourcesPart78LayoutY: Close {}
extension ThreeSourcesPart78LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart79LayoutX: Close {}
extension ThreeSourcesPart79LayoutX { public static var typeName: String { "125.468" } }

public enum ThreeSourcesPart79LayoutY: Close {}
extension ThreeSourcesPart79LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart80LayoutX: Close {}
extension ThreeSourcesPart80LayoutX { public static var typeName: String { "132.994" } }

public enum ThreeSourcesPart80LayoutY: Close {}
extension ThreeSourcesPart80LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart81LayoutWidth: Close {}
extension ThreeSourcesPart81LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart81LayoutD: Close {}
extension ThreeSourcesPart81LayoutD { public static var typeName: String { "M152.518 725.04H320.4" } }

public enum ThreeSourcesPart82LayoutX: Close {}
extension ThreeSourcesPart82LayoutX { public static var typeName: String { "355.68" } }

public enum ThreeSourcesPart82LayoutY: Close {}
extension ThreeSourcesPart82LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart83LayoutX: Close {}
extension ThreeSourcesPart83LayoutX { public static var typeName: String { "363.206" } }

public enum ThreeSourcesPart83LayoutY: Close {}
extension ThreeSourcesPart83LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart84LayoutX: Close {}
extension ThreeSourcesPart84LayoutX { public static var typeName: String { "370.731" } }

public enum ThreeSourcesPart84LayoutY: Close {}
extension ThreeSourcesPart84LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart85LayoutX: Close {}
extension ThreeSourcesPart85LayoutX { public static var typeName: String { "378.257" } }

public enum ThreeSourcesPart85LayoutY: Close {}
extension ThreeSourcesPart85LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart86LayoutX: Close {}
extension ThreeSourcesPart86LayoutX { public static var typeName: String { "385.783" } }

public enum ThreeSourcesPart86LayoutY: Close {}
extension ThreeSourcesPart86LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart87LayoutX: Close {}
extension ThreeSourcesPart87LayoutX { public static var typeName: String { "393.308" } }

public enum ThreeSourcesPart87LayoutY: Close {}
extension ThreeSourcesPart87LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart88LayoutX: Close {}
extension ThreeSourcesPart88LayoutX { public static var typeName: String { "400.834" } }

public enum ThreeSourcesPart88LayoutY: Close {}
extension ThreeSourcesPart88LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart89LayoutWidth: Close {}
extension ThreeSourcesPart89LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart89LayoutD: Close {}
extension ThreeSourcesPart89LayoutD { public static var typeName: String { "M420.358 725.04H609.28" } }

public enum ThreeSourcesPart90LayoutX: Close {}
extension ThreeSourcesPart90LayoutX { public static var typeName: String { "621.28" } }

public enum ThreeSourcesPart90LayoutY: Close {}
extension ThreeSourcesPart90LayoutY { public static var typeName: String { "707.04" } }

public enum ThreeSourcesPart90LayoutW: Close {}
extension ThreeSourcesPart90LayoutW { public static var typeName: String { "88" } }

public enum ThreeSourcesPart90LayoutH: Close {}
extension ThreeSourcesPart90LayoutH { public static var typeName: String { "33.84" } }

public enum ThreeSourcesPart90LayoutRadius: Close {}
extension ThreeSourcesPart90LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart90LayoutWidth: Close {}
extension ThreeSourcesPart90LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart91LayoutX: Close {}
extension ThreeSourcesPart91LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart91LayoutY: Close {}
extension ThreeSourcesPart91LayoutY { public static var typeName: String { "732.24" } }

public enum ThreeSourcesPart92LayoutX: Close {}
extension ThreeSourcesPart92LayoutX { public static var typeName: String { "87.84" } }

public enum ThreeSourcesPart92LayoutY: Close {}
extension ThreeSourcesPart92LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart93LayoutX: Close {}
extension ThreeSourcesPart93LayoutX { public static var typeName: String { "95.3656" } }

public enum ThreeSourcesPart93LayoutY: Close {}
extension ThreeSourcesPart93LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart94LayoutX: Close {}
extension ThreeSourcesPart94LayoutX { public static var typeName: String { "102.891" } }

public enum ThreeSourcesPart94LayoutY: Close {}
extension ThreeSourcesPart94LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart95LayoutX: Close {}
extension ThreeSourcesPart95LayoutX { public static var typeName: String { "110.417" } }

public enum ThreeSourcesPart95LayoutY: Close {}
extension ThreeSourcesPart95LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart96LayoutX: Close {}
extension ThreeSourcesPart96LayoutX { public static var typeName: String { "117.943" } }

public enum ThreeSourcesPart96LayoutY: Close {}
extension ThreeSourcesPart96LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart97LayoutX: Close {}
extension ThreeSourcesPart97LayoutX { public static var typeName: String { "125.468" } }

public enum ThreeSourcesPart97LayoutY: Close {}
extension ThreeSourcesPart97LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart98LayoutX: Close {}
extension ThreeSourcesPart98LayoutX { public static var typeName: String { "132.994" } }

public enum ThreeSourcesPart98LayoutY: Close {}
extension ThreeSourcesPart98LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart99LayoutWidth: Close {}
extension ThreeSourcesPart99LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart99LayoutD: Close {}
extension ThreeSourcesPart99LayoutD { public static var typeName: String { "M152.518 764.64H320.4" } }

public enum ThreeSourcesPart100LayoutX: Close {}
extension ThreeSourcesPart100LayoutX { public static var typeName: String { "355.68" } }

public enum ThreeSourcesPart100LayoutY: Close {}
extension ThreeSourcesPart100LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart101LayoutX: Close {}
extension ThreeSourcesPart101LayoutX { public static var typeName: String { "363.206" } }

public enum ThreeSourcesPart101LayoutY: Close {}
extension ThreeSourcesPart101LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart102LayoutX: Close {}
extension ThreeSourcesPart102LayoutX { public static var typeName: String { "370.731" } }

public enum ThreeSourcesPart102LayoutY: Close {}
extension ThreeSourcesPart102LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart103LayoutX: Close {}
extension ThreeSourcesPart103LayoutX { public static var typeName: String { "378.257" } }

public enum ThreeSourcesPart103LayoutY: Close {}
extension ThreeSourcesPart103LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart104LayoutX: Close {}
extension ThreeSourcesPart104LayoutX { public static var typeName: String { "385.783" } }

public enum ThreeSourcesPart104LayoutY: Close {}
extension ThreeSourcesPart104LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart105LayoutX: Close {}
extension ThreeSourcesPart105LayoutX { public static var typeName: String { "393.308" } }

public enum ThreeSourcesPart105LayoutY: Close {}
extension ThreeSourcesPart105LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart106LayoutX: Close {}
extension ThreeSourcesPart106LayoutX { public static var typeName: String { "400.834" } }

public enum ThreeSourcesPart106LayoutY: Close {}
extension ThreeSourcesPart106LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart107LayoutWidth: Close {}
extension ThreeSourcesPart107LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart107LayoutD: Close {}
extension ThreeSourcesPart107LayoutD { public static var typeName: String { "M420.358 764.64H609.28" } }

public enum ThreeSourcesPart108LayoutX: Close {}
extension ThreeSourcesPart108LayoutX { public static var typeName: String { "621.28" } }

public enum ThreeSourcesPart108LayoutY: Close {}
extension ThreeSourcesPart108LayoutY { public static var typeName: String { "746.64" } }

public enum ThreeSourcesPart108LayoutW: Close {}
extension ThreeSourcesPart108LayoutW { public static var typeName: String { "88" } }

public enum ThreeSourcesPart108LayoutH: Close {}
extension ThreeSourcesPart108LayoutH { public static var typeName: String { "33.84" } }

public enum ThreeSourcesPart108LayoutRadius: Close {}
extension ThreeSourcesPart108LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart108LayoutWidth: Close {}
extension ThreeSourcesPart108LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart109LayoutX: Close {}
extension ThreeSourcesPart109LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart109LayoutY: Close {}
extension ThreeSourcesPart109LayoutY { public static var typeName: String { "771.84" } }

public enum ThreeSourcesPart110LayoutX: Close {}
extension ThreeSourcesPart110LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart110LayoutY: Close {}
extension ThreeSourcesPart110LayoutY { public static var typeName: String { "814.32" } }

public enum ThreeSourcesPart111LayoutX: Close {}
extension ThreeSourcesPart111LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart111LayoutY: Close {}
extension ThreeSourcesPart111LayoutY { public static var typeName: String { "842.4" } }

public enum ThreeSourcesPart112LayoutX: Close {}
extension ThreeSourcesPart112LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart112LayoutY: Close {}
extension ThreeSourcesPart112LayoutY { public static var typeName: String { "867.6" } }

public enum ThreeSourcesPart113LayoutX: Close {}
extension ThreeSourcesPart113LayoutX { public static var typeName: String { "381.6" } }

public enum ThreeSourcesPart113LayoutY: Close {}
extension ThreeSourcesPart113LayoutY { public static var typeName: String { "867.6" } }

public enum ThreeSourcesPart114LayoutX: Close {}
extension ThreeSourcesPart114LayoutX { public static var typeName: String { "28.8" } }

public enum ThreeSourcesPart114LayoutY: Close {}
extension ThreeSourcesPart114LayoutY { public static var typeName: String { "901.44" } }

public enum ThreeSourcesPart114LayoutW: Close {}
extension ThreeSourcesPart114LayoutW { public static var typeName: String { "748.8" } }

public enum ThreeSourcesPart114LayoutH: Close {}
extension ThreeSourcesPart114LayoutH { public static var typeName: String { "326.88" } }

public enum ThreeSourcesPart114LayoutRadius: Close {}
extension ThreeSourcesPart114LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart114LayoutWidth: Close {}
extension ThreeSourcesPart114LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart115LayoutX: Close {}
extension ThreeSourcesPart115LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart115LayoutY: Close {}
extension ThreeSourcesPart115LayoutY { public static var typeName: String { "934.56" } }

public enum ThreeSourcesPart116LayoutX: Close {}
extension ThreeSourcesPart116LayoutX { public static var typeName: String { "79.2" } }

public enum ThreeSourcesPart116LayoutY: Close {}
extension ThreeSourcesPart116LayoutY { public static var typeName: String { "934.56" } }

public enum ThreeSourcesPart117LayoutX: Close {}
extension ThreeSourcesPart117LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart117LayoutY: Close {}
extension ThreeSourcesPart117LayoutY { public static var typeName: String { "965.52" } }

public enum ThreeSourcesPart118LayoutX: Close {}
extension ThreeSourcesPart118LayoutX { public static var typeName: String { "85.68" } }

public enum ThreeSourcesPart118LayoutY: Close {}
extension ThreeSourcesPart118LayoutY { public static var typeName: String { "1001.52" } }

public enum ThreeSourcesPart119LayoutX: Close {}
extension ThreeSourcesPart119LayoutX { public static var typeName: String { "345.6" } }

public enum ThreeSourcesPart119LayoutY: Close {}
extension ThreeSourcesPart119LayoutY { public static var typeName: String { "1001.52" } }

public enum ThreeSourcesPart120LayoutX: Close {}
extension ThreeSourcesPart120LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart120LayoutY: Close {}
extension ThreeSourcesPart120LayoutY { public static var typeName: String { "1001.52" } }

public enum ThreeSourcesPart121LayoutX: Close {}
extension ThreeSourcesPart121LayoutX { public static var typeName: String { "87.84" } }

public enum ThreeSourcesPart121LayoutY: Close {}
extension ThreeSourcesPart121LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart122LayoutX: Close {}
extension ThreeSourcesPart122LayoutX { public static var typeName: String { "95.3656" } }

public enum ThreeSourcesPart122LayoutY: Close {}
extension ThreeSourcesPart122LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart123LayoutX: Close {}
extension ThreeSourcesPart123LayoutX { public static var typeName: String { "102.891" } }

public enum ThreeSourcesPart123LayoutY: Close {}
extension ThreeSourcesPart123LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart124LayoutX: Close {}
extension ThreeSourcesPart124LayoutX { public static var typeName: String { "110.417" } }

public enum ThreeSourcesPart124LayoutY: Close {}
extension ThreeSourcesPart124LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart125LayoutX: Close {}
extension ThreeSourcesPart125LayoutX { public static var typeName: String { "117.943" } }

public enum ThreeSourcesPart125LayoutY: Close {}
extension ThreeSourcesPart125LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart126LayoutX: Close {}
extension ThreeSourcesPart126LayoutX { public static var typeName: String { "125.468" } }

public enum ThreeSourcesPart126LayoutY: Close {}
extension ThreeSourcesPart126LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart127LayoutX: Close {}
extension ThreeSourcesPart127LayoutX { public static var typeName: String { "132.994" } }

public enum ThreeSourcesPart127LayoutY: Close {}
extension ThreeSourcesPart127LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart128LayoutWidth: Close {}
extension ThreeSourcesPart128LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart128LayoutD: Close {}
extension ThreeSourcesPart128LayoutD { public static var typeName: String { "M152.518 1029.6H320.4" } }

public enum ThreeSourcesPart129LayoutX: Close {}
extension ThreeSourcesPart129LayoutX { public static var typeName: String { "355.68" } }

public enum ThreeSourcesPart129LayoutY: Close {}
extension ThreeSourcesPart129LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart130LayoutX: Close {}
extension ThreeSourcesPart130LayoutX { public static var typeName: String { "363.206" } }

public enum ThreeSourcesPart130LayoutY: Close {}
extension ThreeSourcesPart130LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart131LayoutX: Close {}
extension ThreeSourcesPart131LayoutX { public static var typeName: String { "370.731" } }

public enum ThreeSourcesPart131LayoutY: Close {}
extension ThreeSourcesPart131LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart132LayoutX: Close {}
extension ThreeSourcesPart132LayoutX { public static var typeName: String { "378.257" } }

public enum ThreeSourcesPart132LayoutY: Close {}
extension ThreeSourcesPart132LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart133LayoutX: Close {}
extension ThreeSourcesPart133LayoutX { public static var typeName: String { "385.783" } }

public enum ThreeSourcesPart133LayoutY: Close {}
extension ThreeSourcesPart133LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart134LayoutX: Close {}
extension ThreeSourcesPart134LayoutX { public static var typeName: String { "393.308" } }

public enum ThreeSourcesPart134LayoutY: Close {}
extension ThreeSourcesPart134LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart135LayoutX: Close {}
extension ThreeSourcesPart135LayoutX { public static var typeName: String { "400.834" } }

public enum ThreeSourcesPart135LayoutY: Close {}
extension ThreeSourcesPart135LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart136LayoutWidth: Close {}
extension ThreeSourcesPart136LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart136LayoutD: Close {}
extension ThreeSourcesPart136LayoutD { public static var typeName: String { "M420.358 1029.6H609.28" } }

public enum ThreeSourcesPart137LayoutX: Close {}
extension ThreeSourcesPart137LayoutX { public static var typeName: String { "621.28" } }

public enum ThreeSourcesPart137LayoutY: Close {}
extension ThreeSourcesPart137LayoutY { public static var typeName: String { "1011.6" } }

public enum ThreeSourcesPart137LayoutW: Close {}
extension ThreeSourcesPart137LayoutW { public static var typeName: String { "88" } }

public enum ThreeSourcesPart137LayoutH: Close {}
extension ThreeSourcesPart137LayoutH { public static var typeName: String { "33.84" } }

public enum ThreeSourcesPart137LayoutRadius: Close {}
extension ThreeSourcesPart137LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart137LayoutWidth: Close {}
extension ThreeSourcesPart137LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart138LayoutX: Close {}
extension ThreeSourcesPart138LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart138LayoutY: Close {}
extension ThreeSourcesPart138LayoutY { public static var typeName: String { "1036.8" } }

public enum ThreeSourcesPart139LayoutX: Close {}
extension ThreeSourcesPart139LayoutX { public static var typeName: String { "87.84" } }

public enum ThreeSourcesPart139LayoutY: Close {}
extension ThreeSourcesPart139LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart140LayoutX: Close {}
extension ThreeSourcesPart140LayoutX { public static var typeName: String { "95.3656" } }

public enum ThreeSourcesPart140LayoutY: Close {}
extension ThreeSourcesPart140LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart141LayoutX: Close {}
extension ThreeSourcesPart141LayoutX { public static var typeName: String { "102.891" } }

public enum ThreeSourcesPart141LayoutY: Close {}
extension ThreeSourcesPart141LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart142LayoutX: Close {}
extension ThreeSourcesPart142LayoutX { public static var typeName: String { "110.417" } }

public enum ThreeSourcesPart142LayoutY: Close {}
extension ThreeSourcesPart142LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart143LayoutX: Close {}
extension ThreeSourcesPart143LayoutX { public static var typeName: String { "117.943" } }

public enum ThreeSourcesPart143LayoutY: Close {}
extension ThreeSourcesPart143LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart144LayoutX: Close {}
extension ThreeSourcesPart144LayoutX { public static var typeName: String { "125.468" } }

public enum ThreeSourcesPart144LayoutY: Close {}
extension ThreeSourcesPart144LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart145LayoutX: Close {}
extension ThreeSourcesPart145LayoutX { public static var typeName: String { "132.994" } }

public enum ThreeSourcesPart145LayoutY: Close {}
extension ThreeSourcesPart145LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart146LayoutWidth: Close {}
extension ThreeSourcesPart146LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart146LayoutD: Close {}
extension ThreeSourcesPart146LayoutD { public static var typeName: String { "M152.518 1069.2H320.4" } }

public enum ThreeSourcesPart147LayoutX: Close {}
extension ThreeSourcesPart147LayoutX { public static var typeName: String { "355.68" } }

public enum ThreeSourcesPart147LayoutY: Close {}
extension ThreeSourcesPart147LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart148LayoutX: Close {}
extension ThreeSourcesPart148LayoutX { public static var typeName: String { "363.206" } }

public enum ThreeSourcesPart148LayoutY: Close {}
extension ThreeSourcesPart148LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart149LayoutX: Close {}
extension ThreeSourcesPart149LayoutX { public static var typeName: String { "370.731" } }

public enum ThreeSourcesPart149LayoutY: Close {}
extension ThreeSourcesPart149LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart150LayoutX: Close {}
extension ThreeSourcesPart150LayoutX { public static var typeName: String { "378.257" } }

public enum ThreeSourcesPart150LayoutY: Close {}
extension ThreeSourcesPart150LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart151LayoutX: Close {}
extension ThreeSourcesPart151LayoutX { public static var typeName: String { "385.783" } }

public enum ThreeSourcesPart151LayoutY: Close {}
extension ThreeSourcesPart151LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart152LayoutX: Close {}
extension ThreeSourcesPart152LayoutX { public static var typeName: String { "393.308" } }

public enum ThreeSourcesPart152LayoutY: Close {}
extension ThreeSourcesPart152LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart153LayoutX: Close {}
extension ThreeSourcesPart153LayoutX { public static var typeName: String { "400.834" } }

public enum ThreeSourcesPart153LayoutY: Close {}
extension ThreeSourcesPart153LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart154LayoutWidth: Close {}
extension ThreeSourcesPart154LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart154LayoutD: Close {}
extension ThreeSourcesPart154LayoutD { public static var typeName: String { "M420.358 1069.2H609.28" } }

public enum ThreeSourcesPart155LayoutX: Close {}
extension ThreeSourcesPart155LayoutX { public static var typeName: String { "621.28" } }

public enum ThreeSourcesPart155LayoutY: Close {}
extension ThreeSourcesPart155LayoutY { public static var typeName: String { "1051.2" } }

public enum ThreeSourcesPart155LayoutW: Close {}
extension ThreeSourcesPart155LayoutW { public static var typeName: String { "88" } }

public enum ThreeSourcesPart155LayoutH: Close {}
extension ThreeSourcesPart155LayoutH { public static var typeName: String { "33.84" } }

public enum ThreeSourcesPart155LayoutRadius: Close {}
extension ThreeSourcesPart155LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart155LayoutWidth: Close {}
extension ThreeSourcesPart155LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart156LayoutX: Close {}
extension ThreeSourcesPart156LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart156LayoutY: Close {}
extension ThreeSourcesPart156LayoutY { public static var typeName: String { "1076.4" } }

public enum ThreeSourcesPart157LayoutX: Close {}
extension ThreeSourcesPart157LayoutX { public static var typeName: String { "87.84" } }

public enum ThreeSourcesPart157LayoutY: Close {}
extension ThreeSourcesPart157LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart158LayoutX: Close {}
extension ThreeSourcesPart158LayoutX { public static var typeName: String { "95.3656" } }

public enum ThreeSourcesPart158LayoutY: Close {}
extension ThreeSourcesPart158LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart159LayoutX: Close {}
extension ThreeSourcesPart159LayoutX { public static var typeName: String { "102.891" } }

public enum ThreeSourcesPart159LayoutY: Close {}
extension ThreeSourcesPart159LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart160LayoutX: Close {}
extension ThreeSourcesPart160LayoutX { public static var typeName: String { "110.417" } }

public enum ThreeSourcesPart160LayoutY: Close {}
extension ThreeSourcesPart160LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart161LayoutX: Close {}
extension ThreeSourcesPart161LayoutX { public static var typeName: String { "117.943" } }

public enum ThreeSourcesPart161LayoutY: Close {}
extension ThreeSourcesPart161LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart162LayoutX: Close {}
extension ThreeSourcesPart162LayoutX { public static var typeName: String { "125.468" } }

public enum ThreeSourcesPart162LayoutY: Close {}
extension ThreeSourcesPart162LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart163LayoutX: Close {}
extension ThreeSourcesPart163LayoutX { public static var typeName: String { "132.994" } }

public enum ThreeSourcesPart163LayoutY: Close {}
extension ThreeSourcesPart163LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart164LayoutWidth: Close {}
extension ThreeSourcesPart164LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart164LayoutD: Close {}
extension ThreeSourcesPart164LayoutD { public static var typeName: String { "M152.518 1108.8H320.4" } }

public enum ThreeSourcesPart165LayoutX: Close {}
extension ThreeSourcesPart165LayoutX { public static var typeName: String { "355.68" } }

public enum ThreeSourcesPart165LayoutY: Close {}
extension ThreeSourcesPart165LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart166LayoutX: Close {}
extension ThreeSourcesPart166LayoutX { public static var typeName: String { "363.206" } }

public enum ThreeSourcesPart166LayoutY: Close {}
extension ThreeSourcesPart166LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart167LayoutX: Close {}
extension ThreeSourcesPart167LayoutX { public static var typeName: String { "370.731" } }

public enum ThreeSourcesPart167LayoutY: Close {}
extension ThreeSourcesPart167LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart168LayoutX: Close {}
extension ThreeSourcesPart168LayoutX { public static var typeName: String { "378.257" } }

public enum ThreeSourcesPart168LayoutY: Close {}
extension ThreeSourcesPart168LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart169LayoutX: Close {}
extension ThreeSourcesPart169LayoutX { public static var typeName: String { "385.783" } }

public enum ThreeSourcesPart169LayoutY: Close {}
extension ThreeSourcesPart169LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart170LayoutX: Close {}
extension ThreeSourcesPart170LayoutX { public static var typeName: String { "393.308" } }

public enum ThreeSourcesPart170LayoutY: Close {}
extension ThreeSourcesPart170LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart171LayoutX: Close {}
extension ThreeSourcesPart171LayoutX { public static var typeName: String { "400.834" } }

public enum ThreeSourcesPart171LayoutY: Close {}
extension ThreeSourcesPart171LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart172LayoutWidth: Close {}
extension ThreeSourcesPart172LayoutWidth { public static var typeName: String { "1.296" } }

public enum ThreeSourcesPart172LayoutD: Close {}
extension ThreeSourcesPart172LayoutD { public static var typeName: String { "M420.358 1108.8H609.28" } }

public enum ThreeSourcesPart173LayoutX: Close {}
extension ThreeSourcesPart173LayoutX { public static var typeName: String { "621.28" } }

public enum ThreeSourcesPart173LayoutY: Close {}
extension ThreeSourcesPart173LayoutY { public static var typeName: String { "1090.8" } }

public enum ThreeSourcesPart173LayoutW: Close {}
extension ThreeSourcesPart173LayoutW { public static var typeName: String { "88" } }

public enum ThreeSourcesPart173LayoutH: Close {}
extension ThreeSourcesPart173LayoutH { public static var typeName: String { "33.84" } }

public enum ThreeSourcesPart173LayoutRadius: Close {}
extension ThreeSourcesPart173LayoutRadius { public static var typeName: String { "8.64" } }

public enum ThreeSourcesPart173LayoutWidth: Close {}
extension ThreeSourcesPart173LayoutWidth { public static var typeName: String { "1.08" } }

public enum ThreeSourcesPart174LayoutX: Close {}
extension ThreeSourcesPart174LayoutX { public static var typeName: String { "665.28" } }

public enum ThreeSourcesPart174LayoutY: Close {}
extension ThreeSourcesPart174LayoutY { public static var typeName: String { "1116" } }

public enum ThreeSourcesPart175LayoutX: Close {}
extension ThreeSourcesPart175LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart175LayoutY: Close {}
extension ThreeSourcesPart175LayoutY { public static var typeName: String { "1157.76" } }

public enum ThreeSourcesPart176LayoutX: Close {}
extension ThreeSourcesPart176LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart176LayoutY: Close {}
extension ThreeSourcesPart176LayoutY { public static var typeName: String { "1185.12" } }

public enum ThreeSourcesPart177LayoutX: Close {}
extension ThreeSourcesPart177LayoutX { public static var typeName: String { "46.8" } }

public enum ThreeSourcesPart177LayoutY: Close {}
extension ThreeSourcesPart177LayoutY { public static var typeName: String { "1211.04" } }

public enum ThreeSourcesView0LayoutFrame: Close {}
extension ThreeSourcesView0LayoutFrame { public static var typeName: String { "0 0 806.4 1245.6" } }

public enum ThreeSourcesView1LayoutFrame: Close {}
extension ThreeSourcesView1LayoutFrame { public static var typeName: String { "0 0 806.4 541.44" } }

public enum ThreeSourcesView2LayoutFrame: Close {}
extension ThreeSourcesView2LayoutFrame { public static var typeName: String { "0 545.76 806.4 699.84" } }

public enum ReadingColumnMiddle: Close {}
extension ReadingColumnMiddle { public static var typeName: String { "middle" } }
