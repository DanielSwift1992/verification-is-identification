import PackagePlugin
import Foundation

// Structural enforcement of THE LAW + the provenance layer. On every build of
// the VerificationIsIdentification target this runs the LawLint executable over the target's Swift
// sources and its .docc legend: pure types (§0′), no renames (§1), every axis
// closed (§2), and every [Tag] address resolving to a connected paper. A
// violation makes the build itself refuse to proceed — the rule never depends on
// anyone remembering it. The check is written in Swift, the medium the lattice is
// written in, and runs from a target (LawLint), never a shell script or a Python
// tool. (Topics-tree induction needs the symbol graph — see the TreeSort command.)
@main
struct LawCheck: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        let tool = try context.tool(named: "Tools")
        let sources = target.sourceFiles(withSuffix: "swift").map(\.path)
        let docc = target.directory.appending("VerificationIsIdentification.docc")
        let papersDir = docc.appending("Papers")

        // The provenance layer reads the legend and the per-paper Topics routes;
        // declare them as inputs so the check re-runs when a doc address changes.
        var doccInputs: [Path] = [docc.appending("Sources.md")]
        if let entries = try? FileManager.default.contentsOfDirectory(atPath: papersDir.string) {
            for entry in entries where entry.hasSuffix(".md") {
                doccInputs.append(papersDir.appending(entry))
            }
        }

        let stamp = context.pluginWorkDirectory.appending("lawcheck.stamp")
        return [
            .buildCommand(
                displayName: "THE LAW (§0′/§1/§2) + provenance",
                executable: tool.path,
                arguments: ["lint"] + sources.map(\.string) + ["--docc", docc.string, "--stamp", stamp.string],
                inputFiles: sources + doccInputs,
                outputFiles: [stamp]
            )
        ]
    }
}
