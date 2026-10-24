import Foundation

/// One source view and lexical owner map precede either question. Original
/// bytes remain available separately for the count-rule body check.
enum CourtNotation {
    static func imports(_ text: String, lent: NameSet) throws -> [(module: String, line: Int)] {
        try WhereJudge.stripComments(text, lent: lent).components(separatedBy: "\n").enumerated().flatMap { index, line in
            WhereJudge.captures(#"\bimport\s+([^;\n]+)"#, line).map {
                (module: $0[0].trimmingCharacters(in: .whitespaces), line: index + 1)
            }
        }
    }

    /// Question selectors stated by PredicateReading declarations. Reading a
    /// selector does not establish an application or a numerical answer.
    static func countQuestions(_ text: String, path: String, lent: NameSet) throws -> [NameMap<String>] {
        let view = try DefinitionView.read(text, path: path, lent: lent, contextV2: true)
        let world = try WhereJudge.read(view.text, lent: lent, contextV2: true)
        var result: [NameMap<String>] = [], seen = NameSet()
        for name in world.conformers.keys.sorted() {
            let conformer = world.conformers[name]!
            guard conformer.protocols.containsName("PredicateReading"),
                  let predicate = conformer.table["Predicate"], let encoding = conformer.table["Encoding"],
                  let sigma = conformer.table["Sigma"] else { continue }
            if seen.insert([predicate, encoding, sigma].joined(separator: "\u{0}")).inserted {
                result.append(["predicate": predicate, "encoding": encoding, "sigma": sigma])
            }
        }
        return result
    }
    struct File {
        let context: CourtContext.Source
        let text: String
        let view: String
        let world: WhereJudge.World
        let notation: NotationScope
        let excluded: Int?
        let unchecked: [String]
    }

    static func read(_ context: CourtContext, texts: NameMap<String>,
                     selected: String?, documents: NameSet) throws -> [File] {
        let names = context.sources.flatMap { source in
            [(source.at["namespace"]!, source.namespace),
             (source.at["module"] ?? source.at["namespace"]!, source.module)]
                + Array(zip(source.importAddresses, source.imports))
        }
        try WhereJudge.checkWordSpellings(context.sources.map { ($0.source, texts[$0.input]!) }, names: names)
        let lent = NameSet(texts.values.flatMap { text -> NameSet in
            guard let clean = try? WhereJudge.stripComments(text) else { return [] }
            return (try? WhereJudge.declaredBuilders(clean)) ?? []
        })
        var files: [File] = []
        for source in context.sources {
            let text = texts[source.input]!
            let rawOwn = (WhereJudge.sameName(source.input, selected) || (selected == nil && source.role == "own"))
                && !documents.contains(source.input)
            let view = rawOwn ? (text: text, first: Optional<Int>.none)
                : try DefinitionView.read(text, path: source.source, lent: lent, contextV2: context.version == 2)
            let world = try WhereJudge.read(view.text, lent: lent, contextV2: context.version == 2)
            for imported in try imports(view.text, lent: lent) {
                guard source.imports.containsName(imported.module) else {
                    try WhereJudge.fail("\(source.source):\(imported.line): import '\(imported.module)' is not declared by the source context")
                }
            }
            var unchecked = view.first.map { [source.source + ":\($0)"] } ?? []
            if context.version == 2 {
                for (index, line) in try WhereJudge.blankCommentsAndStrings(text, lent: lent)
                    .components(separatedBy: "\n").enumerated() {
                    if line.range(of: #"^\s*#if\b"#, options: .regularExpression) != nil {
                        unchecked.append(source.source + ":\(index + 1) (conditional compilation)")
                    }
                }
            }
            files.append(File(context: source, text: text, view: view.text, world: world,
                notation: try NotationScope(world.clean), excluded: view.first, unchecked: unchecked.sorted()))
        }
        return files
    }
}
