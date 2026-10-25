/// Closes declared imports over re-export edges on the common lexical tape.
/// The context resolver and binding relation use this one module graph.
struct ContextImports {
    private let exports: NameMap<NameSet>
    init(_ files: [CourtNotation.File], words: [[String]]) throws {
        var graph = NameMap<[(String, String)]>()
        for file in files {
            for (i, target) in file.context.imports.enumerated() {
                let address = i < file.context.importAddresses.count
                    ? file.context.importAddresses[i] : file.context.source + ":1 imports"
                graph[file.context.module, default: []].append((target, address))
            }
        }
        var visited = NameSet(), active = NameSet()
        func visit(_ module: String) throws {
            guard !visited.contains(module) else { return }
            active.insert(module)
            for (target, address) in graph[module] ?? [] {
                guard !active.contains(target) else {
                    try WhereJudge.fail("context \(address): cyclic imports: \(module) -> \(target)")
                }
                try visit(target)
            }
            active.remove(module)
            visited.insert(module)
        }
        for module in graph.keys.sorted() { try visit(module) }
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
