import PackagePlugin
import Foundation

// Structural enforcement of THE LAW's cross-file checks (§0′/scope itself is now
// the grammar mirror's job, more precisely, per file; this plugin's LawLint stays for §1 RENAME
// and §2 OPEN AXIS, which are whole-module). Attached to Organization, DocumentKit, and
// VectorDemo (Package.swift); the lattice-side targets Tools itself depends
// on stay hand-checked (`swift run Tools lint <dir>…`). The check is written in Swift, the
// medium the lattice is written in, and runs from a target (Tools), not a shell script or a
// Python tool. (Topics-tree induction needs the symbol graph, see the TreeSort command.)
//
// THE GUN IS IN THE BUILD for the library targets: Organization and DocumentKit run `--strict`,
// so a violation REFUSES the build there, the same way the palette gate refuses an illegible
// pairing. VectorDemo stays report mode by design, not leniency: a demo target's drivers
// (`runPulse`, `write`, the mode switch) are the sanctioned value edge §0′ leaves open, so
// strict would refuse lawful code; the report keeps the edge visible instead of silencing it.
//
// The grammar mirror (`swift run Tools grammar`, no arguments = all of Sources) does NOT ride
// the incremental build: each run compiles a disposable child package (~40 s for one target),
// which would put minutes on every build. It is the pre-commit gate, run by hand, same
// standing as the census.
//
// PROVENANCE (`--docc`/`--strict`) only ever applied to VerificationIsIdentification, keyed on
// `target.name`, but that target cannot carry this plugin: Tools now depends on
// VerificationIsIdentification (GrammarLexicon reads its `Close`/`Never`), and this plugin
// depends on Tools, so attaching it there would cycle. Checked by hand instead
// (`swift run Tools lint Sources/VerificationIsIdentification --docc
// Sources/VerificationIsIdentification/VerificationIsIdentification.docc --strict`) until the
// mirror grows a cross-file axis of its own.
@main
struct LawCheck: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        let tool = try context.tool(named: "Tools")
        let sources = target.sourceFiles(withSuffix: "swift").map(\.path)

        let libraryTargets: Set<String> = ["Organization", "DocumentKit"]
        let strict = libraryTargets.contains(target.name)

        let stamp = context.pluginWorkDirectory.appending("lawcheck.stamp")
        var arguments = ["lint"] + sources.map(\.string) + ["--stamp", stamp.string]
        if strict { arguments.append("--strict") }
        return [
            .buildCommand(
                displayName: "THE LAW (§0′/§1/§2), \(strict ? "strict" : "report") mode — \(target.name)",
                executable: tool.path,
                arguments: arguments,
                inputFiles: sources,
                outputFiles: [stamp]
            )
        ]
    }
}
