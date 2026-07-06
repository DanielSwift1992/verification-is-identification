import Foundation
import VerificationIsIdentification
import DocumentKit

// `swift run DocumentKitDemo render-doc`: writes Landing.typeName into DocumentKit's own
// .docc catalog as the module's landing page (DocumentKit.md), the same shape Organization's
// OrgDemo already proved out, scoped entirely to DocumentKit (no Organization dependency).

let catalog = "Sources/DocumentKit/DocumentKit.docc/"

func write(_ content: String, _ name: String) {
    try? content.write(toFile: catalog + name + ".md", atomically: true, encoding: .utf8)
}

func writeSVG(_ content: String, _ name: String) {
    try? content.write(toFile: catalog + "Resources/" + name + ".svg", atomically: true, encoding: .utf8)
}

guard CommandLine.arguments.contains("render-doc") else {
    print("usage: swift run DocumentKitDemo render-doc")
    exit(0)
}

// The Vector-medium section's live examples (DESIGN14 §2, ROUND-UNIFY.md Phase 5): real
// `Diagram` compositions, written the same way VectorDemo writes Organization's.
writeSVG(VectorCanvasExampleDiagram.typeName, "vector-canvas-example")
writeSVG(VectorHoverExampleDiagram.typeName, "vector-hover-example")
writeSVG(VectorSelfShowingExampleDiagram.typeName, "vector-selfshowing-example")
writeSVG(VectorTourStationADiagram.typeName, "vector-tour-station-a")
writeSVG(VectorTourStationBDiagram.typeName, "vector-tour-station-b")

// RolesPlate, both themes: one Palette, instantiated twice, DocC's own x/x~dark asset-swap
// (the same mechanism the nine cards + avatar already use).
writeSVG(RolesPlate<LightRolesPalette>.typeName, "roles-plate")
writeSVG(RolesPlate<DarkRolesPalette>.typeName, "roles-plate~dark")

// The self-showing canvas's badge links here: its code block reads the SAME atom
// (`SelfShowingExampleSourceCode`) the gallery's "Used like this" block already shows, so the
// linked page cannot drift from the block the reader already read.
write(SelfShowingExampleSourcePage.typeName, "SelfShowingExampleSource")

// The tour's two stations: each page shows only its OWN dot; the click across is the tour.
write(VectorTourStationAPage.typeName, "VectorTourStationA")
write(VectorTourStationBPage.typeName, "VectorTourStationB")

write(Landing.typeName, "DocumentKit")

print("rendered 4 pages: DocumentKit + SelfShowingExampleSource + 2 tour stations, 5 Vector-section examples")





