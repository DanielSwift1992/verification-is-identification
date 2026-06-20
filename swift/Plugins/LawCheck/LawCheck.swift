import PackagePlugin

// Structural enforcement of THE LAW. A prebuild command runs lint-law.sh
// before every build of the Theory target: pure types (§0′) and no renames
// (§1). A violation makes the build itself refuse to proceed — the rule never
// depends on anyone remembering it. This is the "compiler IS the verifier"
// ethos applied to the law that governs the code.
@main
struct LawCheck: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let script = context.package.directory.appending("lint-law.sh")
        return [
            .prebuildCommand(
                displayName: "THE LAW — pure types (§0′), no renames (§1)",
                executable: script,
                arguments: [],
                outputFilesDirectory: context.pluginWorkDirectory.appending("LawCheck")
            )
        ]
    }
}
