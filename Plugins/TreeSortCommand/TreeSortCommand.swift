import PackagePlugin
import Foundation

// `swift package tree-sort [audit|emit|check|write]` — induce or check the Topics
// tree from the type lattice. The clean Swift replacement for tree-sort.py: it
// asks the package manager for the compiler's symbol graph (the type lattice
// describing itself), then runs the TreeSort tool over it and the .docc catalog.
//
// A command plugin, not a build gate: getting the symbol graph needs the
// PackageManager API, available only to command plugins. `check` fails on drift
// (Topics ≠ what the types induce); `write` regenerates landing + routes.
@main
struct TreeSortCommand: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let mode = arguments.first ?? "check"
        guard let theory = context.package.targets.first(where: { $0.name == "VerificationIsIdentification" }) else {
            Diagnostics.error("VerificationIsIdentification target not found"); return
        }
        let result = try packageManager.getSymbolGraph(
            for: theory,
            options: .init(minimumAccessLevel: .public, includeSynthesized: false, includeSPI: false))
        let graph = result.directoryPath.appending("VerificationIsIdentification.symbols.json")
        let docc = theory.directory.appending("VerificationIsIdentification.docc")
        let tool = try context.tool(named: "Tools")

        let process = Process()
        process.executableURL = URL(fileURLWithPath: tool.path.string)
        process.arguments = ["tree-sort", graph.string, docc.string, mode]
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus != 0 {
            Diagnostics.error("tree-sort \(mode): the Topics tree drifts from the type lattice (status \(process.terminationStatus))")
        }
    }
}
