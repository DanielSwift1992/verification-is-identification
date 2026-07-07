import PackagePlugin
import Foundation

// Spells the census into atoms on every build of the Organization target, the same
// relationship ProseGen has to Prose.json: the source is the repository's own Swift, the
// artifact lives in the plugin's work directory and is never committed, and the page that
// wears the numbers cannot go stale because the numbers are re-counted by the build that
// renders it. Input tracking rides this target's own sources (the same simplification
// LawCheck makes): a change in a sibling target refreshes the counts on the next build
// that touches this one, and a clean build — every deploy — counts everything fresh.
@main
struct CensusGen: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        let tool = try context.tool(named: "Tools")
        let censusSwift = context.pluginWorkDirectory.appending("GeneratedCensus.swift")
        return [
            .buildCommand(
                displayName: "Counting the census into atoms",
                executable: tool.path,
                arguments: ["census", "--emit", censusSwift.string],
                inputFiles: target.sourceFiles(withSuffix: "swift").map(\.path),
                outputFiles: [censusSwift]
            )
        ]
    }
}
