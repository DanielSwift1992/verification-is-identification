import Alphabet
import Notation

public enum DoubleHash: Close {}
extension DoubleHash {
    public static var typeName: String { "## " }
}

public enum TripleHash: Close {}
extension TripleHash {
    public static var typeName: String { "### " }
}

public enum Break: Close {}
extension Break {
    public static var typeName: String { "\n\n" }
}

/// Writes a CommonMark hard line break within a block.
public enum HardBreak: Close {}
extension HardBreak {
    public static var typeName: String { "  \n" }
}

public enum Pipe: Close {}
extension Pipe {
    public static var typeName: String { "| " }
}

public enum PipeSep: Close {}
extension PipeSep {
    public static var typeName: String { " | " }
}

/// Writes the separator between adjacent breadcrumb labels.
public enum Chevron: Close {}
extension Chevron {
    public static var typeName: String { " › " }
}

/// Writes the delimiter cell separating a table header from its body.
public enum RuleMark: Close {}
extension RuleMark {
    public static var typeName: String { "---" }
}

public enum Bullet: Close {}
extension Bullet {
    public static var typeName: String { "- " }
}

public enum Callout: Close {}
extension Callout {
    public static var typeName: String { "> " }
}

public enum ColonSpace: Close {}
extension ColonSpace {
    public static var typeName: String { ": " }
}

public enum OpenBrace: Close {}
extension OpenBrace {
    public static var typeName: String { " {\n" }
}

public enum CloseBrace: Close {}
extension CloseBrace {
    public static var typeName: String { "}\n" }
}

public enum NoteLabel: Close {}
extension NoteLabel {
    public static var typeName: String { "Note" }
}

public enum ImportantLabel: Close {}
extension ImportantLabel {
    public static var typeName: String { "Important" }
}

public enum WarningLabel: Close {}
extension WarningLabel {
    public static var typeName: String { "Warning" }
}

public enum TipLabel: Close {}
extension TipLabel {
    public static var typeName: String { "Tip" }
}

public enum TabNavigatorLabel: Close {}
extension TabNavigatorLabel {
    public static var typeName: String { "TabNavigator" }
}

public enum TabLabel: Close {}
extension TabLabel {
    public static var typeName: String { "Tab" }
}

public enum LinksLabel: Close {}
extension LinksLabel {
    public static var typeName: String { "Links(visualStyle: detailedGrid)" }
}

public enum RowLabel: Close {}
extension RowLabel {
    public static var typeName: String { "Row" }
}

public enum ColumnLabel: Close {}
extension ColumnLabel {
    public static var typeName: String { "Column" }
}

/// Composes a target through one associated place. Its shared builder initializer supplies the call syntax.
public protocol Reference: Open {
    associatedtype Target: Structure
}
extension Reference {
    @StructureBuilder
    public static var body: some Structure {
        Backtick.self
        Backtick.self
        Target.self
        Backtick.self
        Backtick.self
    }
    public init(@StructureBuilder _ target: () -> Target) { fatalError() }
}
/// Writes the supplied target identifier as a symbol reference.
public enum Symbol<
    Target: Structure
>: Reference {}

/// Writes the supplied target identifier as a DocC topic reference.
public enum TopicReference<X>: Close {}
extension TopicReference {
    public static var typeName: String { "<doc:\(RawName<X>.typeName)>" }
}
/// Reads a target identifier independently of the target content.
public enum RawName<X>: Close {}
extension RawName {
    public static var typeName: String { String(describing: X.self) }
}

/// Writes the supplied type identifier as a symbol reference.
public enum ProtocolReference<X>: Close {}
extension ProtocolReference {
    public static var typeName: String { "``" + String(describing: X.self) + "``" }
}

/// Composes the target identifier into a DocC address.
public protocol DocLink: Open {
    associatedtype Target: Structure
}
extension DocLink {
    @StructureBuilder
    public static var body: some Structure {
        AngleOpen.self
        Letter.d.self
        Letter.o.self
        Letter.c.self
        Colon.self
        RawName<Target>.self
        AngleClose.self
    }
    public init(@StructureBuilder _ target: () -> Target) { fatalError() }
}
/// Writes a DocC reference to the supplied target identifier.
public enum Page<
    Target: Structure
>: DocLink {}

/// Composes the supplied label and target identifier into a titled DocC link.
public protocol TitledLink: Open {
    associatedtype Label: Structure
    associatedtype Target: Structure
}
extension TitledLink {
    @StructureBuilder
    public static var body: some Structure {
        SquareOpen.self
        Label.self
        SquareClose.self
        ParenOpen.self
        Letter.d.self
        Letter.o.self
        Letter.c.self
        Colon.self
        RawName<Target>.self
        ParenClose.self
    }
}
/// Reads label and target from the two sides of its composed Pair.
public enum Link<
    Whole: Pair
>: TitledLink
where Whole.Left: Structure, Whole.Right: Structure {
    public typealias Label = Whole.Left
    public typealias Target = Whole.Right
    public init(@StructureBuilder _ content: () -> Whole) { fatalError() }
}

/// Composes the supplied alternative text and resource into an image reference.
public protocol ImageEmbed: Open {
    associatedtype Alt: Structure
    associatedtype Asset: Structure
}
extension ImageEmbed {
    @StructureBuilder
    public static var body: some Structure {
        Exclamation.self
        SquareOpen.self
        Alt.self
        SquareClose.self
        ParenOpen.self
        Asset.self
        ParenClose.self
    }
}
/// Reads alternative text and asset from the two sides of its composed Pair.
public enum Picture<
    Whole: Pair
>: ImageEmbed
where Whole.Left: Structure, Whole.Right: Structure {
    public typealias Alt = Whole.Left
    public typealias Asset = Whole.Right
    public init(@StructureBuilder _ content: () -> Whole) { fatalError() }
}

/// Reads the supplied structure count as text.
public typealias TallyKind<
    Of: Structure
> = Notation.Tally<Of>
/// Reads the supplied structure count at the composition edge.
public func Tally<
    Of: Structure
>(_ of: () -> Of.Type) -> TallyKind<Of>.Type { TallyKind<Of>.self }

public protocol Title: Open {
    associatedtype Content: Structure
}
extension Title {
    @StructureBuilder
    public static var body: some Structure {
        Hash.self
        Space.self
        Content.self
        Break.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum PageTitle<
    Content: Structure
>: Title {}

/// Composes its content into a note block.
public protocol Note: Open {
    associatedtype Message: Structure
}
extension Note {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        NoteLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Noted<
    Message: Structure
>: Note {}

public protocol Important: Open {
    associatedtype Message: Structure
}
extension Important {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        ImportantLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Flagged<
    Message: Structure
>: Important {}

public protocol Warning: Open {
    associatedtype Message: Structure
}
extension Warning {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        WarningLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Warned<
    Message: Structure
>: Warning {}

public protocol Tip: Open {
    associatedtype Message: Structure
}
extension Tip {
    @StructureBuilder
    public static var body: some Structure {
        Callout.self
        TipLabel.self
        ColonSpace.self
        Message.self
        Break.self
    }
    public init(@StructureBuilder _ message: () -> Message) { fatalError() }
}
public enum Tipped<
    Message: Structure
>: Tip {}

public protocol Grid: Open {
    associatedtype Rows: Structure
}
extension Grid {
    @StructureBuilder
    public static var body: some Structure {
        Rows.self
        Newline.self
    }
    public init(@StructureBuilder _ rows: () -> Rows) { fatalError() }
}
public enum Table<
    Rows: Structure
>: Grid {}

public protocol Row: Open {
    associatedtype Cells: Structure
}
extension Row {
    @StructureBuilder
    public static var body: some Structure {
        Pipe.self
        Cells.self
        Newline.self
    }
    public init(@StructureBuilder _ cells: () -> Cells) { fatalError() }
}
public enum TableRow<
    Cells: Structure
>: Row {}

public protocol Field: Open {
    associatedtype Content: Structure
}
extension Field {
    @StructureBuilder
    public static var body: some Structure {
        Content.self
        PipeSep.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
/// Composes the supplied content as one field of a row.
public enum TableCell<
    Content: Structure
>: Field {}

public protocol Item: Open {
    associatedtype Content: Structure
}
extension Item {
    @StructureBuilder
    public static var body: some Structure {
        Bullet.self
        Content.self
        Newline.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum ListItem<
    Content: Structure
>: Item {}

/// Composes its content within a tab navigator and terminates the directive on its own line.
public protocol Tabs: Open {
    associatedtype Content: Structure
}
extension Tabs {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        TabNavigatorLabel.self
        OpenBrace.self
        Content.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum TabGroup<
    Content: Structure
>: Tabs {}

public protocol Links: Open {
    associatedtype Content: Structure
}
extension Links {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        LinksLabel.self
        OpenBrace.self
        Content.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum LinkGrid<
    Content: Structure
>: Links {}

/// Composes its content within a row and terminates the directive on its own line.
public protocol Columns: Open {
    associatedtype Panels: Structure
}
extension Columns {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        RowLabel.self
        OpenBrace.self
        Panels.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ panels: () -> Panels) { fatalError() }
}
public enum SideBySide<
    Panels: Structure
>: Columns {}

/// Composes its content within a column and terminates the directive on its own line.
public protocol Panel: Open {
    associatedtype Content: Structure
}
extension Panel {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        ColumnLabel.self
        OpenBrace.self
        Content.self
        Newline.self
        CloseBrace.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum PanelOf<
    Content: Structure
>: Panel {}

/// Reads the supplied count as a relative column weight.
public enum WeightOf<S: Structure>: Close {}
extension WeightOf {
    public static var typeName: String { String(S.count) }
}

/// Composes content within a column whose relative size is the supplied Weight.
public protocol WeightedPanel: Open {
    associatedtype Content: Structure
    associatedtype Weight: Structure
}
extension WeightedPanel {
    @StructureBuilder
    public static var body: some Structure {
        At.self
        ColumnLabel.self
        ParenOpen.self
        Letter.s.self; Letter.i.self; Letter.z.self; Letter.e.self; Colon.self; Space.self
        Weight.self
        ParenClose.self
        OpenBrace.self
        Content.self
        Newline.self
        CloseBrace.self
    }
}
/// Reads weight and content from its composed Pair and writes a weighted column.
public enum SizedPanel<
    Whole: Pair
>: WeightedPanel
where Whole.Left: Structure, Whole.Right: Structure {
    public typealias Content = Whole.Left
    public typealias Weight = Whole.Right
    public init(@StructureBuilder _ content: () -> Whole) { fatalError() }
}

/// Composes content and a delimiter in a single-column table.
public protocol Frame: Open {
    associatedtype Content: Structure
}
extension Frame {
    @StructureBuilder
    public static var body: some Structure {
        Table {
            TableRow { TableCell { Content.self } }
            TableRow { TableCell { RuleMark.self } }
        }
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum Framed<
    Content: Structure
>: Frame {}

public enum TripleBacktickSwift: Close {}
extension TripleBacktickSwift {
    public static var typeName: String { "```swift\n" }
}

public enum TripleBacktick: Close {}
extension TripleBacktick {
    public static var typeName: String { "```\n" }
}

/// Composes content between code delimiters with a final line break.
public protocol CodeFence: Open {
    associatedtype Content: Structure
}
extension CodeFence {
    @StructureBuilder
    public static var body: some Structure {
        TripleBacktickSwift.self
        Content.self
        Newline.self
        TripleBacktick.self
    }
    public init(@StructureBuilder _ content: () -> Content) { fatalError() }
}
public enum CodeSample<
    Content: Structure
>: CodeFence {}

/// Writes a weighted column with empty content.
public enum Spacer<
    Weight: Structure
>: WeightedPanel {
    public typealias Content = Never
}

/// Declares two open neighboring places for a consumer-defined reading.
public protocol Gap: Structure {
    associatedtype Left
    associatedtype Right
}
/// Supplies the empty default reading for two neighboring places. Specialized readings are resolved at a concrete consumer site.
public enum SpaceBetween<
    Left,
    Right
>: Gap {}
extension SpaceBetween {
    public static var typeName: String { "" }
}

/// Supplies a unit-width column for two neighboring places. Specialized readings are resolved at a concrete consumer site.
public enum SpacerBetween<
    Left,
    Right
>: Gap {}
extension SpacerBetween {
    public static var typeName: String { Spacer<WeightOf<Unit>>.typeName }
}

