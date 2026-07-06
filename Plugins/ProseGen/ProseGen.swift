import PackagePlugin
import Foundation

// Generates prose from Sources/Organization/Prose.json on every build of the Organization
// target — the SPM way (a build tool plugin, like LawCheck), not a script a human has to
// remember to run. Prose.json is the tracked source (anyone can edit it directly); the two
// Swift files it spells into (the alphabet + the prose types) are written into the plugin's
// own work directory and never committed — regenerated fresh every build, the same relationship
// GeneratedTeam.swift's generator has to its output, except the artifact itself is not checked
// in. If Prose.json does not exist yet, this plugin contributes nothing (a fresh checkout with
// no prose content still builds).
@main
struct ProseGen: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        let proseJSON = target.directory.appending("Prose.json")
        guard FileManager.default.fileExists(atPath: proseJSON.string) else { return [] }

        let tool = try context.tool(named: "Tools")
        let proseSwift = context.pluginWorkDirectory.appending("GeneratedProse.swift")
        let alphabetSwift = context.pluginWorkDirectory.appending("GeneratedAlphabet.swift")

        return [
            .buildCommand(
                displayName: "Spelling prose from Prose.json",
                executable: tool.path,
                arguments: ["prose", proseJSON.string, proseSwift.string, alphabetSwift.string],
                inputFiles: [proseJSON],
                outputFiles: [proseSwift, alphabetSwift]
            )
        ]
    }
}
