/// Closes declared imports over re-export edges on the common lexical tape.
/// The context resolver and binding relation use this one module graph.
struct ContextImports {
    private let exports: NameMap<NameSet>
    init(_ files: [CourtNotation.File], words: [[String]]) {
        var edges = NameMap<NameSet>()
        for (file, raw) in zip(files, words) {
            let tape = raw.filter { !WhereJudge.sameName($0, "\n") }
            guard tape.count >= 4 else { continue }
            for i in 0..<(tape.count - 3)
            where WhereJudge.sameNames(Array(tape[i..<(i + 3)]), ["@", "_exported", "import"]) {
                edges[file.context.module, default: []].insert(tape[i + 3])
            }
        }
        exports = edges
    }
    func visible(_ source: CourtContext.Source) -> NameSet {
        var result = NameSet(source.imports + [source.module])
        var pending = Array(result)
        while let module = pending.popLast() {
            for next in exports[module] ?? []
            where result.insert(next).inserted {
                pending.append(next)
            }
        }
        return result
    }
}
