import DocumentKitCertificates
import Foundation
import VerificationIsIdentification
import DocumentKit

// `swift run DocumentKitDemo render-doc`: writes Landing.typeName into DocumentKit's own
// .docc catalog as the module's landing page (DocumentKit.md).

let catalog = "Sources/DocumentKit/DocumentKit.docc/"

// Only the rendering boundary reads strings. The statement's applicability
// and covered answer have already been checked in Claim.swift.
if CommandLine.arguments.dropFirst().first == "claim" {
    let statement = "# A Covered Visible Answer\n\n" + PublishedVisibleClaim.typeName
    if CommandLine.arguments.contains("--write") {
        do {
            try statement.write(
                toFile: "Sources/DocumentKit/DocumentKit.docc/CoveredVisibleClaim.md",
                atomically: true,
                encoding: .utf8
            )
        } catch {
            FileHandle.standardError.write(Data("claim: cannot write the current statement: \(error)\n".utf8))
            exit(1)
        }
    } else {
        print(statement, terminator: "")
    }
    exit(0)
}

func write(_ content: String, _ name: String) {
    try? content.write(toFile: catalog + name + ".md", atomically: true, encoding: .utf8)
}

func writeSVG(_ content: String, _ name: String) {
    try? content.write(toFile: catalog + "Resources/" + name + ".svg", atomically: true, encoding: .utf8)
}

guard CommandLine.arguments.contains("render-doc") else {
    print("usage: swift run DocumentKitDemo <render-doc|claim>")
    exit(0)
}

// Each Vector example writes the readout of its declared Diagram composition.
writeSVG(VectorCanvasExampleDiagram.typeName, "vector-canvas-example")
writeSVG(VectorHoverExampleDiagram.typeName, "vector-hover-example")
writeSVG(VectorSelfShowingExampleDiagram.typeName, "vector-selfshowing-example")
writeSVG(VectorTourStationADiagram.typeName, "vector-tour-station-a")
writeSVG(VectorTourStationBDiagram.typeName, "vector-tour-station-b")

// RolesPlate, both themes: one Palette, instantiated twice, DocC's own x/x~dark asset-swap
// The caller supplies each palette; DocC selects the corresponding resource.
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


