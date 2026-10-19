import Foundation
import Court

// Tools is the package's build-time helpers as one executable with several subcommands,
// so the docs build has a single support module instead of one per tool. The showcase
// package runs this same executable from its own root for its lint, census, voice and
// plain judge; its prose, generate, curve and `judge diff`/`judge chain` are its own
// ShowcaseTools.
//   lint       the construction-law check (§1 RENAME, §2 OPEN AXIS, PROVENANCE), run by the
//              LawCheck build plugin on the showcase's library targets, checked by hand here.
//   tree-sort  induce or check the Topics tree from the symbol graph, run by the
//              tree-sort command plugin.
//   grammar    the grammar mirror: carries a file's source as typed atoms and lets the
//              child build's conformances judge it, per file, per scope. Supersedes the
//              old regex-based `surface`/`angles`/`layout` checks (retired: their §0′/§S4/
//              §S22 rules are now this checker's schema, more precisely, per file).
//   census     count declarations per target: the "almost no functions" claim, as a number.
//   voice      the lexical baseline gate: candidate counts per scope do not exceed authored pins.
//   site       build the combined DocC archive and serve it locally (`site fast` skips checks).
//   judge      the second arbiter: a linear checker over the fragment of the paths it is given.
//   press      one rewrite triple applied to one state file, `--file` and `--rules` named.
switch Array(CommandLine.arguments.dropFirst()).first {
case "lint":      Lint.run(Array(CommandLine.arguments.dropFirst(2)))
case "tree-sort": TreeSortTool.run(Array(CommandLine.arguments.dropFirst(2)))
case "grammar":   Linter.run(Array(CommandLine.arguments.dropFirst(2)))
case "site":      Site.run(Array(CommandLine.arguments.dropFirst(2)))
case "census":    Census.run(Array(CommandLine.arguments.dropFirst(2)))
case "judge":     Judge.run(Array(CommandLine.arguments.dropFirst(2)))
case "quotes":    Quotes.run(Array(CommandLine.arguments.dropFirst(2)))
case "papers":    PaperFamilies.run(Array(CommandLine.arguments.dropFirst(2)))
case "readme":    ReadmeCheck.run(Array(CommandLine.arguments.dropFirst(2)))
case "voice":     VoiceTool.run(Array(CommandLine.arguments.dropFirst(2)))
case "press":     Press.run(Array(CommandLine.arguments.dropFirst(2)))
case "ablate":    Ablate.run(Array(CommandLine.arguments.dropFirst(2)))
default:
    FileHandle.standardError.write(Data("usage: Tools <lint|tree-sort|grammar|census|site|judge|quotes|papers|readme|voice|press|ablate> ...\n".utf8))
    exit(2)
}
