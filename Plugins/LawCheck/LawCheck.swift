import PackagePlugin
import Foundation

// Cross-file construction checks (§1 RENAME and §2 OPEN AXIS). The consumer
// declares strict mode with a UTF-8 LawCheck.strict file containing "strict"
// in its own target directory, excluded from SwiftPM sources. Absence retains
// report mode. Target names have no role in selecting behavior.
// Report mode retains diagnostics while allowing the build.
// It admits no code under §0′ and records or discharges no debt.
// Consumers declare strictness at their own boundary.
// Grammar is a separate gate: its disposable compiler does not run on each build.
// Targets on which Tools depends must be linted directly to avoid a plugin cycle.
@main
struct LawCheck: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        let tool = try context.tool(named: "Tools")
        let sources = target.sourceFiles(withSuffix: "swift").map(\.path)
        let declaration = target.directory.appending("LawCheck.strict")
        let strict = FileManager.default.fileExists(atPath: declaration.string)
        if strict {
            let policy = try String(contentsOfFile: declaration.string, encoding: .utf8)
            guard policy.trimmingCharacters(in: .whitespacesAndNewlines) == "strict" else {
                Diagnostics.error("\(declaration.string): expected strict")
                return []
            }
        }
        let stamp = context.pluginWorkDirectory.appending("lawcheck.stamp")
        var arguments = ["lint"] + sources.map(\.string) + ["--stamp", stamp.string]
        // SwiftPM can reuse the planned command when only declaration bytes
        // change. The linter must validate that input again when it executes.
        if strict { arguments += ["--strict-declaration", declaration.string] }
        return [
            .buildCommand(
                displayName: "THE LAW (§0′/§1/§2), \(strict ? "strict" : "report") mode — \(target.name)",
                executable: tool.path,
                arguments: arguments,
                inputFiles: sources + (strict ? [declaration] : []),
                outputFiles: [stamp]
            )
        ]
    }
}
