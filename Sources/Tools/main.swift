import Foundation

// Tools — the package's build-time helpers as one executable with two subcommands,
// so the docs build has a single support module instead of one per tool.
//   lint       the construction-law check, run by the LawCheck build plugin.
//   tree-sort  induce or check the Topics tree from the symbol graph, run by the
//              tree-sort command plugin.
switch Array(CommandLine.arguments.dropFirst()).first {
case "lint":      Lint.run(Array(CommandLine.arguments.dropFirst(2)))
case "tree-sort": TreeSortTool.run(Array(CommandLine.arguments.dropFirst(2)))
default:
    FileHandle.standardError.write(Data("usage: Tools <lint|tree-sort> ...\n".utf8))
    exit(2)
}
