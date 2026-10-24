import Alphabet
import Notation
import DocumentKit

public enum DemoModuleTitle: Close {}
extension DemoModuleTitle {
    public static var typeName: String { "DocumentKitDemo" }
}

public enum DemoSummary: Close {}
extension DemoSummary {
    public static var typeName: String { "Reads this owner\'s declared layout compositions with its supplied binding." }
}

public enum SDKDocumentationLink: Close {}
extension SDKDocumentationLink {
    public static var typeName: String { "## Documentation and demo pages\n\nThe SDK relations are documented at [DocumentKit](" + SDKDocumentationRoot.typeName + ")." }
}

public enum DemoPages: Close {}
extension DemoPages {
    public static var typeName: String {
        "- [Source of the declared canvas](" + DemoDocumentationRoot.typeName + "selfshowingexamplesource)\n"
            + "- [Station A](" + DemoDocumentationRoot.typeName + "vectortourstationa)\n"
            + "- [Station B](" + DemoDocumentationRoot.typeName + "vectortourstationb)\n"
            + "- [Covered visible claim](" + DemoDocumentationRoot.typeName + "coveredvisibleclaim)\n"
    }
}

public enum DemoGallery: Close {}
extension DemoGallery {
    public static var typeName: String {
        "## Declared layout compositions\n\n"
            + "![Canvas](vector-canvas-example)\n\n"
            + "![Hover pair](vector-hover-example)\n\n"
            + "![Canvas with its source link](vector-selfshowing-example)\n\n"
            + "![Station A](vector-tour-station-a)\n\n"
            + "![Station B](vector-tour-station-b)\n\n"
            + "![Owner roles](roles-plate)\n"
    }
}

/// Composes this owner's navigation and selected native drawing readouts.
public enum Landing: GallerySection {
    @StructureBuilder
    public static var body: some Structure {
        PageTitle { Symbol { DemoModuleTitle.self } }
        DemoSummary.self
        Break.self
        SDKDocumentationLink.self
        Break.self
        DemoPages.self
        Break.self
        DemoGallery.self
        Break.self
        MarkupGallery.self
    }
}

public enum SampleText: Close {}
extension SampleText {
    public static var typeName: String { "supplied content" }
}

public enum SampleLeft: Close {}
extension SampleLeft {
    public static var typeName: String { "left place" }
}

public enum SampleRight: Close {}
extension SampleRight {
    public static var typeName: String { "right place" }
}

public enum SampleAsset: Close {}
extension SampleAsset {
    public static var typeName: String { "example" }
}

public enum SampleLabel: Close {}
extension SampleLabel {
    public static var typeName: String { "demo module" }
}

public enum SampleFirstTab: Close {}
extension SampleFirstTab {
    public static var typeName: String { "First" }
}

public enum SampleSecondTab: Close {}
extension SampleSecondTab {
    public static var typeName: String { "Second" }
}

public enum SourceLabel: Close {}
extension SourceLabel {
    public static var typeName: String { "Declaration" }
}

public enum ReadingLabel: Close {}
extension ReadingLabel {
    public static var typeName: String { "Compiled markup" }
}

public enum MarkupGalleryTitle: Close {}
extension MarkupGalleryTitle {
    public static var typeName: String { "Markup declarations and readings" }
}

/// Shows an owner-supplied source excerpt beside its compiled composition reading.
/// Excerpt correspondence is reviewed at this consumer site. Reading supplies the native result.
public protocol MarkupReadout: Open {
    associatedtype Heading: Structure
    associatedtype Declaration: Structure
    associatedtype Reading: Structure
}
extension MarkupReadout {
    @StructureBuilder
    public static var body: some Structure {
        TripleHash.self; Heading.self; Break.self
        SourceLabel.self; Break.self
        CodeSample { Declaration.self }
        Break.self; ReadingLabel.self; Break.self
        TripleBacktick.self; Reading.self; Newline.self; TripleBacktick.self
        Break.self; Reading.self; Break.self
    }
}

public enum SymbolHeading: Close {}
extension SymbolHeading {
    public static var typeName: String { "Symbol" }
}
public enum SymbolDeclaration: Close {}
extension SymbolDeclaration {
    public static var typeName: String { "Symbol { DemoModuleTitle.self }" }
}
public enum SymbolReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        Symbol { DemoModuleTitle.self }
    }
}
public enum SymbolReadout: MarkupReadout {
    public typealias Heading = SymbolHeading
    public typealias Declaration = SymbolDeclaration
    public typealias Reading = SymbolReading
}

public enum PageHeading: Close {}
extension PageHeading {
    public static var typeName: String { "Page" }
}
public enum PageDeclaration: Close {}
extension PageDeclaration {
    public static var typeName: String { "Page { DemoModuleTitle.self }" }
}
public enum PageReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        Page { DemoModuleTitle.self }
    }
}
public enum PageReadout: MarkupReadout {
    public typealias Heading = PageHeading
    public typealias Declaration = PageDeclaration
    public typealias Reading = PageReading
}

public enum LinkHeading: Close {}
extension LinkHeading {
    public static var typeName: String { "Link" }
}
public enum LinkDeclaration: Close {}
extension LinkDeclaration {
    public static var typeName: String { "Link { SampleLabel.self; DemoModuleTitle.self }" }
}
public enum LinkReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        Link { SampleLabel.self; DemoModuleTitle.self }
    }
}
public enum LinkReadout: MarkupReadout {
    public typealias Heading = LinkHeading
    public typealias Declaration = LinkDeclaration
    public typealias Reading = LinkReading
}

public enum PictureHeading: Close {}
extension PictureHeading {
    public static var typeName: String { "Picture" }
}
public enum PictureDeclaration: Close {}
extension PictureDeclaration {
    public static var typeName: String { "Picture { SampleLabel.self; SampleAsset.self }" }
}
public enum PictureReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        Picture { SampleLabel.self; SampleAsset.self }
    }
}
public enum PictureReadout: MarkupReadout {
    public typealias Heading = PictureHeading
    public typealias Declaration = PictureDeclaration
    public typealias Reading = PictureReading
}

public enum FramedHeading: Close {}
extension FramedHeading {
    public static var typeName: String { "Framed" }
}
public enum FramedDeclaration: Close {}
extension FramedDeclaration {
    public static var typeName: String { "Framed { SampleText.self }" }
}
public enum FramedReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        Framed { SampleText.self }
    }
}
public enum FramedReadout: MarkupReadout {
    public typealias Heading = FramedHeading
    public typealias Declaration = FramedDeclaration
    public typealias Reading = FramedReading
}

public enum SpacerHeading: Close {}
extension SpacerHeading {
    public static var typeName: String { "Spacer" }
}
public enum SpacerDeclaration: Close {}
extension SpacerDeclaration {
    public static var typeName: String { "SideBySide { Spacer<WeightOf<U1>>.self; PanelOf { SampleText.self }; Spacer<WeightOf<U1>>.self }" }
}
public enum SpacerReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        SideBySide { Spacer<WeightOf<U1>>.self; PanelOf { SampleText.self }; Spacer<WeightOf<U1>>.self }
    }
}
public enum SpacerReadout: MarkupReadout {
    public typealias Heading = SpacerHeading
    public typealias Declaration = SpacerDeclaration
    public typealias Reading = SpacerReading
}

public enum GapHeading: Close {}
extension GapHeading {
    public static var typeName: String { "Gap" }
}
public enum GapDeclaration: Close {}
extension GapDeclaration {
    public static var typeName: String { "SpaceBetween<SampleLeft, SampleRight>.self" }
}
public enum GapReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        SpaceBetween<SampleLeft, SampleRight>.self
    }
}
public enum GapReadout: MarkupReadout {
    public typealias Heading = GapHeading
    public typealias Declaration = GapDeclaration
    public typealias Reading = GapReading
}

public enum TableHeading: Close {}
extension TableHeading {
    public static var typeName: String { "Table" }
}
public enum TableDeclaration: Close {}
extension TableDeclaration {
    public static var typeName: String { "Table {\n    TableRow { TableCell { SampleLeft.self }; TableCell { SampleRight.self } }\n    TableRow { TableCell { RuleMark.self }; TableCell { RuleMark.self } }\n    TableRow { TableCell { SampleText.self }; TableCell { SampleText.self } }\n}" }
}
public enum TableReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        Table {
            TableRow { TableCell { SampleLeft.self }; TableCell { SampleRight.self } }
            TableRow { TableCell { RuleMark.self }; TableCell { RuleMark.self } }
            TableRow { TableCell { SampleText.self }; TableCell { SampleText.self } }
        }
    }
}
public enum TableReadout: MarkupReadout {
    public typealias Heading = TableHeading
    public typealias Declaration = TableDeclaration
    public typealias Reading = TableReading
}

public enum ListHeading: Close {}
extension ListHeading {
    public static var typeName: String { "List" }
}
public enum ListDeclaration: Close {}
extension ListDeclaration {
    public static var typeName: String { "ListItem { SampleLeft.self }\nListItem { SampleRight.self }" }
}
public enum ListReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        ListItem { SampleLeft.self }
        ListItem { SampleRight.self }
    }
}
public enum ListReadout: MarkupReadout {
    public typealias Heading = ListHeading
    public typealias Declaration = ListDeclaration
    public typealias Reading = ListReading
}

public enum CalloutsHeading: Close {}
extension CalloutsHeading {
    public static var typeName: String { "Callouts" }
}
public enum CalloutsDeclaration: Close {}
extension CalloutsDeclaration {
    public static var typeName: String { "Noted { SampleText.self }\nFlagged { SampleText.self }\nWarned { SampleText.self }\nTipped { SampleText.self }" }
}
public enum CalloutsReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        Noted { SampleText.self }
        Flagged { SampleText.self }
        Warned { SampleText.self }
        Tipped { SampleText.self }
    }
}
public enum CalloutsReadout: MarkupReadout {
    public typealias Heading = CalloutsHeading
    public typealias Declaration = CalloutsDeclaration
    public typealias Reading = CalloutsReading
}

public enum TabsHeading: Close {}
extension TabsHeading {
    public static var typeName: String { "Tabs" }
}
public enum TabsDeclaration: Close {}
extension TabsDeclaration {
    public static var typeName: String { "TabGroup {\n    At.self; TabLabel.self; ParenOpen.self; Quote.self; SampleFirstTab.self; Quote.self; ParenClose.self; OpenBrace.self\n    SampleLeft.self; Newline.self; CloseBrace.self\n    At.self; TabLabel.self; ParenOpen.self; Quote.self; SampleSecondTab.self; Quote.self; ParenClose.self; OpenBrace.self\n    SampleRight.self; Newline.self; CloseBrace.self\n}" }
}
public enum TabsReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        TabGroup {
            At.self; TabLabel.self; ParenOpen.self; Quote.self; SampleFirstTab.self; Quote.self; ParenClose.self; OpenBrace.self
            SampleLeft.self; Newline.self; CloseBrace.self
            At.self; TabLabel.self; ParenOpen.self; Quote.self; SampleSecondTab.self; Quote.self; ParenClose.self; OpenBrace.self
            SampleRight.self; Newline.self; CloseBrace.self
        }
    }
}
public enum TabsReadout: MarkupReadout {
    public typealias Heading = TabsHeading
    public typealias Declaration = TabsDeclaration
    public typealias Reading = TabsReading
}

public enum ColumnsHeading: Close {}
extension ColumnsHeading {
    public static var typeName: String { "Columns" }
}
public enum ColumnsDeclaration: Close {}
extension ColumnsDeclaration {
    public static var typeName: String { "SideBySide { PanelOf { SampleLeft.self }; PanelOf { SampleRight.self } }" }
}
public enum ColumnsReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        SideBySide { PanelOf { SampleLeft.self }; PanelOf { SampleRight.self } }
    }
}
public enum ColumnsReadout: MarkupReadout {
    public typealias Heading = ColumnsHeading
    public typealias Declaration = ColumnsDeclaration
    public typealias Reading = ColumnsReading
}

public enum WeightedColumnsHeading: Close {}
extension WeightedColumnsHeading {
    public static var typeName: String { "WeightedColumns" }
}
public enum WeightedColumnsDeclaration: Close {}
extension WeightedColumnsDeclaration {
    public static var typeName: String { "SideBySide {\n    SizedPanel { SampleLeft.self; WeightOf<U1>.self }\n    SizedPanel { SampleRight.self; WeightOf<U2>.self }\n}" }
}
public enum WeightedColumnsReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        SideBySide {
            SizedPanel { SampleLeft.self; WeightOf<U1>.self }
            SizedPanel { SampleRight.self; WeightOf<U2>.self }
        }
    }
}
public enum WeightedColumnsReadout: MarkupReadout {
    public typealias Heading = WeightedColumnsHeading
    public typealias Declaration = WeightedColumnsDeclaration
    public typealias Reading = WeightedColumnsReading
}

public enum TallyHeading: Close {}
extension TallyHeading {
    public static var typeName: String { "Tally" }
}
public enum TallyDeclaration: Close {}
extension TallyDeclaration {
    public static var typeName: String { "DocumentKit.Tally { U2.self }" }
}
public enum TallyReading: Open {
    @StructureBuilder
    public static var body: some Structure {
        DocumentKit.Tally { U2.self }
    }
}
public enum TallyReadout: MarkupReadout {
    public typealias Heading = TallyHeading
    public typealias Declaration = TallyDeclaration
    public typealias Reading = TallyReading
}

/// Composes the demo owner's markup examples without filling the SDK consumer place.
public enum MarkupGallery: Open {
    @StructureBuilder
    public static var body: some Structure {
        DoubleHash.self; MarkupGalleryTitle.self; Break.self
        SymbolReadout.self
        PageReadout.self
        LinkReadout.self
        PictureReadout.self
        FramedReadout.self
        SpacerReadout.self
        GapReadout.self
        TableReadout.self
        ListReadout.self
        CalloutsReadout.self
        TabsReadout.self
        ColumnsReadout.self
        WeightedColumnsReadout.self
        TallyReadout.self
    }
}
