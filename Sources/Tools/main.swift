import Foundation

// Tools is the package's build-time helpers as one executable with several subcommands,
// so the docs build has a single support module instead of one per tool.
//   lint       the construction-law check (§1 RENAME, §2 OPEN AXIS, PROVENANCE), run by the
//              LawCheck build plugin on Organization, checked by hand elsewhere.
//   tree-sort  induce or check the Topics tree from the symbol graph, run by the
//              tree-sort command plugin.
//   grammar    the grammar mirror: carries a file's source as typed atoms and lets the
//              child build's conformances judge it, per file, per scope. Supersedes the
//              old regex-based `surface`/`angles`/`layout` checks (retired: their §0′/§S4/
//              §S22 rules are now this checker's schema, more precisely, per file).
//   prose      spell Prose.json into Glyph atoms + Open types, run by the ProseGen build plugin.
//   census     count declarations per target: the "almost no functions" claim, as a number.
//   site       build the combined DocC archive and serve it locally (`site fast` skips checks).
//   curve      the saturation instrument: growing universes, timed builds, the growth law
//              read off the doublings; `--fanout a,b,c N` sweeps the packing, `--judge`
//              seats the second arbiter's column beside the compiler's.
//   judge      the second arbiter: a linear checker over the generated System fragment;
//              `diff N` seats both checkers on one corpus under planted lies, `chain N`
//              replays the derivation-chain spelling at any depth.
//   generate   regenerate the roster: a checked-in artifact, not a build
//              product, the same split `tree-sort write` makes for the Topics tree. The card
//              art, the architecture diagram, and the headcount chart are
//              VectorDemo's: Tools cannot depend on DocumentKit (its
//              LawCheck plugin depends on Tools, the reverse would cycle). `swift package
//              generate` is the complete entry point (its plugin runs Tools THEN VectorDemo,
//              Plugins/GenerateCommand/GenerateCommand.swift, verified end to end);
//              this executable's `generate all` reaches only what it can import, and
//              does NOT shell out to `swift run VectorDemo` itself, tried once, deadlocked,
//              when reached FROM INSIDE the plugin's subprocess (a nested `swift run`
//              fights the outer `swift package generate` invocation for the same build lock).
//              `swift package generate` names the complete path in its error message below.
switch Array(CommandLine.arguments.dropFirst()).first {
case "lint":      Lint.run(Array(CommandLine.arguments.dropFirst(2)))
case "tree-sort": TreeSortTool.run(Array(CommandLine.arguments.dropFirst(2)))
case "prose":     ProseGenTool.run(Array(CommandLine.arguments.dropFirst(2)))
case "grammar":   Linter.run(Array(CommandLine.arguments.dropFirst(2)))
case "site":      Site.run(Array(CommandLine.arguments.dropFirst(2)))
case "curve":     Curve.run(Array(CommandLine.arguments.dropFirst(2)))
case "census":    Census.run(Array(CommandLine.arguments.dropFirst(2)))
case "judge":     Judge.run(Array(CommandLine.arguments.dropFirst(2)))
case "generate":
    let sub = Array(CommandLine.arguments.dropFirst(2))
    let rest = Array(sub.dropFirst())
    switch sub.first {
    case "org":   GenerateOrg.run(rest)
    case "font":  GenerateFont.run(rest)
    case "all":
        GenerateOrg.run(rest)
        GenerateFont.run([])
        print("Tools generate all: roster and font metrics; cards/diagram/pulse/board/heroes are VectorDemo's; the complete regenerate is `swift package generate` (or `swift package generate all`), not this command alone.")
    default:
        FileHandle.standardError.write(Data("usage: Tools generate <org|font|all> [N]: the COMPLETE regenerate is `swift package generate`\n".utf8))
        exit(2)
    }
default:
    FileHandle.standardError.write(Data("usage: Tools <lint|tree-sort|grammar|prose|census|generate|site|curve> ...\n".utf8))
    exit(2)
}
