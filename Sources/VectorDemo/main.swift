import Foundation
import VerificationIsIdentification
import DocumentKit

// VectorDemo — the driver for DocumentKit's second medium, `Vector` (DESIGN7). Lives outside
// Tools because Tools cannot depend on DocumentKit (DocumentKit's own LawCheck plugin depends on
// Tools, the reverse would cycle); this is the same shape OrgDemo/DocumentKitDemo already are.
// `swift package generate cards|diagram|all` (GenerateCommand) invokes this for the subcommands
// that need real `Structure`/`Open`/`typeName`, and Tools for `org`, which does not.

let out = "Sources/Organization/Organization.docc/Resources"

func write(_ content: String, _ name: String) {
    try? content.write(toFile: "\(out)/\(name).svg", atomically: true, encoding: .utf8)
}

let coreOut = "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Resources"

func writeCore(_ content: String, _ name: String) {
    try? content.write(toFile: "\(coreOut)/\(name).svg", atomically: true, encoding: .utf8)
}

// ── Shared size atoms — every card is the same canvas, the avatar its own ──

typealias CardCanvasSize = CanvasSize<HubCardWide, HubCardTall>
typealias AvatarCanvasSize = CanvasSize<AvatarCanvasSide, AvatarCanvasSide>
enum CardWidth: Close {}
extension CardWidth {
    public static var typeName: String { "320" }
}
enum CardHeight: Close {}
extension CardHeight {
    public static var typeName: String { "180" }
}

func run(_ args: [String]) {
    let mode = args.first ?? "all"
    if mode == "cards" || mode == "all" { runCards() }
    if mode == "diagram" || mode == "all" {
        runDiagram()
        runBuildFlow()
        runGateDiagram()
    }
    if mode == "curve" || mode == "all" { runCurveChart() }
    if mode == "film" || mode == "all" { renderWalkFilm() }
    if mode == "pulse" || mode == "all" { runPulse() }
    if mode == "board" || mode == "all" { runBoard() }
    if mode == "heroes" || mode == "all" {
        runDepartmentsHero()
        runCyclesHero()
        runReturnToOfficeHero()
        runEmployeesHero()
        runDocumentsHero()
    }
    if mode == "people" || mode == "all" {
        runNamedCards()
        renderPersonHeroes()
    }
    if mode == "doors" || mode == "all" {
        runRoleDoors()
        runSiteDoors()
    }
    if mode == "source" || mode == "all" { runSelfShowing() }
    if !["cards", "diagram", "curve", "film", "pulse", "board", "heroes", "people", "doors", "source", "all"].contains(mode) {
        print("usage: VectorDemo <cards|diagram|curve|film|pulse|board|heroes|people|source|all>")
    }
}

run(Array(CommandLine.arguments.dropFirst()))
