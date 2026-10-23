import DocumentKitCertificates
import Foundation
import VerificationIsIdentification
import DocumentKit


let catalog = "Sources/DocumentKitDemo/DocumentKitDemo.docc/"

if CommandLine.arguments.dropFirst().first == "claim" {
    let statement = "# A Covered Visible Answer\n\n" + PublishedVisibleClaim.typeName
    if CommandLine.arguments.contains("--write") {
        do {
            try statement.write(
                toFile: "Sources/DocumentKitDemo/DocumentKitDemo.docc/CoveredVisibleClaim.md",
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

writeSVG(VectorCanvasExampleDiagram.typeName, "vector-canvas-example")
writeSVG(VectorHoverExampleDiagram.typeName, "vector-hover-example")
writeSVG(VectorSelfShowingExampleDiagram.typeName, "vector-selfshowing-example")
writeSVG(VectorTourStationADiagram.typeName, "vector-tour-station-a")
writeSVG(VectorTourStationBDiagram.typeName, "vector-tour-station-b")

writeSVG(RolesPlate<LightRolesPalette>.typeName, "roles-plate")
writeSVG(RolesPlate<DarkRolesPalette>.typeName, "roles-plate~dark")

write(SelfShowingExampleSourcePage.typeName, "SelfShowingExampleSource")

write(VectorTourStationAPage.typeName, "VectorTourStationA")
write(VectorTourStationBPage.typeName, "VectorTourStationB")

write(Landing.typeName, "DocumentKitDemo")

print("rendered 4 pages: DocumentKitDemo + SelfShowingExampleSource + 2 tour stations, 5 Vector-section examples")


