import PackagePlugin
import Foundation

// `swift package generate [org|cards|diagram|chart|all] [N]` regenerates the
// roster, the card art, the architecture diagram, and the headcount chart. Two tools behind
// one verb: `org` is Tools' own (GenerateOrg, dependency-free); `cards`/`diagram`/`chart`
// are VectorDemo's, they compose real `Structure`/`Open`/`typeName`
// from DocumentKit's `Vector` medium, a dependency Tools itself cannot take (DocumentKit's
// LawCheck plugin depends ON Tools, the reverse would cycle). All four write straight into the
// package directory, checked-in artifacts, not build products: LawCheck and `Tools grammar`
// lint the generated Swift the same as hand-written code, the way `tree-sort write` regenerates
// Topics as a tracked file rather than a build-tool output. The named four's own sign-in states
// (Card.swift, VectorDemo/PersonHero.swift) are hand-written, not generated: a small, closed set
// (Surface Law §S8), the same call the roster's four named people already make.
// A command plugin, not a build gate, for the same reason TreeSortCommand is one: writing to
// the package directory needs a command plugin's permissions.
@main
struct GenerateCommand: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let mode = arguments.first ?? "all"
        let rest = Array(arguments.dropFirst())

        func run(_ toolName: String, _ args: [String]) throws {
            let tool = try context.tool(named: toolName)
            let process = Process()
            process.executableURL = URL(fileURLWithPath: tool.path.string)
            process.arguments = args
            try process.run()
            process.waitUntilExit()
            if process.terminationStatus != 0 {
                Diagnostics.error("generate \(args.joined(separator: " ")): exited with status \(process.terminationStatus)")
            }
        }

        switch mode {
        case "org":
            try run("Tools", ["generate", mode] + rest)
        case "cards", "diagram", "chart":
            try run("VectorDemo", [mode])
        case "all":
            try run("Tools", ["generate", "all"] + rest)
            try run("VectorDemo", ["all"])
        default:
            Diagnostics.error("usage: swift package generate <org|cards|diagram|chart|all> [N]")
        }
    }
}
