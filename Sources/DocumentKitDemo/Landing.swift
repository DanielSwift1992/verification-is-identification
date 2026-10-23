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
    public static var typeName: String { "## SDK relations\n\nThe SDK relations are documented at [DocumentKit](" + SDKDocumentationRoot.typeName + ")." }
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
    }
}
