import Foundation

/// A separate court for a declared count question, not a rewrite of type equality.
/// It checks Left -> Answer on supplied PredicateReading applications. The
/// finite Unit/Never/Plus interpretation is enabled only after checking the
/// presented primitive definitions. This is a restricted source interpreter,
/// not execution of arbitrary Swift getters or a complete Swift type checker.
enum CountCourt {
    typealias R = DefinitionReduction
    typealias E = R.Expression
    typealias Failure = R.Failure

    struct Block {
        let kind: String
        let header: [String]
        let body: [String]
        let origin: String
        let resultBuilder: Bool
        var name: String { header.first ?? "" }
    }

    /// Read balanced top-level regions; a comment/string cannot plant a rule.
    static func blocks(_ files: [(String, String)]) throws -> [Block] {
        var result: [Block] = []
        for (origin, text) in files {
            let tokens = try StructuralSource.tokens(text)
            var i = 0
            while i < tokens.count {
                let kind = tokens[i]
                if ["enum", "struct", "class", "protocol", "extension"].contains(kind) {
                    var before = i - 1
                    while before >= 0,
                        ["\n", "public", "internal", "private", "fileprivate", "package"].contains(tokens[before])
                    { before -= 1 }
                    let resultBuilder = before >= 1 && tokens[before] == "resultBuilder" && tokens[before - 1] == "@"
                    i += 1
                    let start = i
                    while i < tokens.count, tokens[i] != "{" { i += 1 }
                    let header = StructuralSource.plain(Array(tokens[start..<i]))
                    let body = try StructuralSource.balanced(tokens, index: &i, open: "{", close: "}")
                    result.append(Block(kind: kind, header: header, body: body, origin: origin,
                                        resultBuilder: resultBuilder))
                } else if kind == "#" {
                    // Choosing a conditional primitive definition would change
                    // the reader. This court does not select compilation flags.
                    if i + 1 < tokens.count, tokens[i + 1] == "if" {
                        throw Failure("conditional compilation is outside the count fragment in \(origin)")
                    }
                    i += 1
                } else if kind == "{" {
                    _ = try StructuralSource.balanced(tokens, index: &i, open: "{", close: "}")
                } else { i += 1 }
            }
        }
        return result
    }

    static func shape(_ text: String) throws -> [String] {
        shape(try StructuralSource.tokens(text))
    }
    static func shape(_ words: [String]) -> [String] {
        let modifiers: Set<String> = ["public", "internal", "private", "fileprivate", "package"]
        return StructuralSource.plain(words).filter { !modifiers.contains($0) }
    }

    static func countGetters(_ block: Block) throws -> [[String]] {
        let ts = StructuralSource.plain(block.body)
        var result: [[String]] = [], i = 0
        while i < ts.count {
            if ["var", "let", "func"].contains(ts[i]), i + 1 < ts.count, ts[i + 1] == "count" {
                guard ts[i] == "var", i > 0, ts[i - 1] == "static",
                    i + 4 < ts.count, Array(ts[(i + 2)...(i + 4)]) == [":", "Int", "{"]
                else { throw Failure("unsupported count member on \(block.name) in \(block.origin)") }
                i += 4
                let body = try StructuralSource.balanced(ts, index: &i, open: "{", close: "}")
                result.append(StructuralSource.plain(body))
            } else if ts[i] == "{" {
                _ = try StructuralSource.balanced(ts, index: &i, open: "{", close: "}")
            } else { i += 1 }
        }
        return result
    }

    /// These checks bind the small interpreter to the actual supplied engine.
    /// Other getters, result builders, overrides and modules are not inferred.
    static func checkPrimitiveRules(_ files: [(String, String)], source: StructuralSource) throws {
        let read = try blocks(files)
        let protected: Set<String> = ["Structure", "Open", "Close", "Pair", "Null",
                                      "Never", "Unit", "Plus", "Paired", "StructureBuilder"]
        for name in protected {
            if source.conditionalSubjects.contains(name) {
                throw Failure("conditional definition of count primitive '\(name)'")
            }
        }
        func declaration(_ name: String, kind: String, header: String, body: String? = nil) throws {
            let found = read.filter { $0.name == name && $0.kind != "extension" }
            guard found.count == 1, found[0].kind == kind,
                found[0].header == StructuralSource.plain(try StructuralSource.tokens(header))
            else { throw Failure("missing or changed count primitive declaration '\(name)'") }
            if name == "StructureBuilder", !found[0].resultBuilder {
                throw Failure("StructureBuilder is not declared @resultBuilder in \(found[0].origin)")
            }
            if let body, try shape(found[0].body) != shape(body) {
                throw Failure("changed count primitive body '\(name)' in \(found[0].origin)")
            }
        }
        try declaration("Unit", kind: "enum", header: "Unit: Close", body: "")
        try declaration("Plus", kind: "enum", header: "Plus<A: Structure, B: Structure>: Open", body: """
            @StructureBuilder public static var body: some Structure { A.self B.self }
            """)
        try declaration("Paired", kind: "enum", header: "Paired<L: Structure, R: Structure>: Pair", body: """
            case paired(L, R)
            public typealias Left = L
            public typealias Right = R
            """)
        try declaration("StructureBuilder", kind: "enum", header: "StructureBuilder", body: """
            public static func buildExpression<T: Structure>(_ type: T.Type) -> T { fatalError() }
            public static func buildExpression(_ string: String) -> String { string }
            @_disfavoredOverload public static func buildExpression<V: Structure>(_ value: V) -> V { value }
            public static func buildPartialBlock<V: Structure>(first: V) -> V { first }
            public static func buildPartialBlock<A: Structure, B: Structure>(accumulated: A, next: B) -> Paired<A, B> { .paired(accumulated, next) }
            public static func buildBlock() -> Never { fatalError() }
            public static func buildEither<A: Structure, B: Structure>(first: A) -> Paired<A, B> { fatalError() }
            public static func buildEither<A: Structure, B: Structure>(second: B) -> Paired<A, B> { fatalError() }
            """)
        try declaration("Close", kind: "protocol", header: "Close: Structure", body: "")
        // These parent/Body relations determine the count dispatch used above.
        guard source.declarations["Structure"]?.kind == "protocol",
            source.declarations["Open"]?.parents == ["Structure"],
            (source.declarations["Open"]?.axes.contains { $0.name == "Body" && $0.fallback == "Never" }) == true,
            source.declarations["Pair"]?.parents == ["Open"],
            source.declarations["Null"]?.parents == ["Pair"],
            (source.conformanceChoices("Never").contains { $0.0 == "Null" && $0.1.isEmpty }),
            (source.conformanceChoices("Never").contains { $0.0 == "Close" && $0.1.isEmpty })
        else { throw Failure("missing count-dispatch foundation (Structure/Open/Pair/Null/Never)") }

        var rules: [String: [[String]]] = [:]
        for block in read {
            guard protected.contains(block.name) else { continue }
            // Even an empty added conformance can introduce a more specific
            // getter through its protocol. Do not infer that it is harmless.
            if block.kind == "extension", ["Unit", "Plus", "StructureBuilder"].contains(block.name)
            { throw Failure("extension changes the count primitive '\(block.name)' in \(block.origin)") }
            for getter in try countGetters(block) {
                let key = block.kind + " " + block.header.joined(separator: " ")
                rules[key, default: []].append(getter)
            }
        }
        let expected: [String: [[String]]] = [
            "protocol Structure": [["get"]],
            "extension Structure": [["1"]],
            "extension Open where Body == Never": [["1"]],
            "extension Open": [["Body", ".", "count"]],
            "extension Paired": [["L", ".", "count", "+", "R", ".", "count"]],
            "extension Never : Null": [["0"]],
        ]
        guard rules == expected else {
            throw Failure("changed, missing or duplicated primitive count getters; expected the supplied 0/1/Body/Paired rules")
        }
    }

    /// Metatype applications are discovered from tokens, not comment/string text.
    static func metatypes(_ text: String) throws -> [(input: E, nested: Bool)] {
        let ts = StructuralSource.plain(try StructuralSource.tokens(text))
        var roots: [(input: E, nested: Bool)] = [], braces = 0
        for i in ts.indices {
            if ts[i] == "{" { braces += 1 }
            if ts[i] == "}" { braces -= 1 }
            guard ts[i] == ".", i + 1 < ts.count, ts[i + 1] == "self" else { continue }
            var start = i, depth = 0
            while start > 0 {
                let t = ts[start - 1]
                if t == ">" { depth += 1 }
                if t == "<" { depth -= 1 }
                if depth < 0 { break }
                if depth == 0, !StructuralSource.identifier(t), !["<", ">", "."].contains(t) { break }
                start -= 1
            }
            if start < i, let root = try? R.parse(StructuralSource.text(Array(ts[start..<i]))) {
                roots.append((root, braces > 0))
            }
        }
        return roots
    }

    struct Evaluation {
        let checked: Int
        let refusals: [String]
        let byPath: [String: Int]
        let pathRefusals: [String: [String]]
        let scope: String
    }
    static func evaluate(_ files: [(String, String)], source: StructuralSource,
                         options: [String: String]) throws -> Evaluation {
            let reader = Reader(source: R.Source(world: source.syntax, rigid: []))
            let predicate = try reader.normal(R.parse(options["--predicate"]!))
            let encoding = try reader.normal(R.parse(options["--encoding"]!))
            let sigma = try reader.normal(R.parse(options["--sigma"]!))
            // All presented files are checked: moving a counterexample into
            // the definitions position cannot hide its selected readings.
            var queue: [(anchor: String, site: String, input: E, nested: Bool, path: String)] = []
            for (path, text) in files {
                for hit in try metatypes(text) {
                    queue.append((path + ":" + hit.input.text, hit.input.text, hit.input, hit.nested, path))
                }
            }
            for d in source.declarations.values.sorted(by: { $0.name < $1.name })
            where d.parameters.isEmpty {
                queue.append((d.name, d.name, .application(d.name, []), false, d.origin))
            }
            var seen: [String: Set<E>] = [:], discovered = 0, checked = 0, refusals: [String] = []
            var byPath: [String: Int] = [:], pathRefusals: [String: [String]] = [:]
            while let job = queue.popLast() {
                guard discovered < 20_000 else { throw Failure("count application discovery exceeds its budget") }
                let reader = Reader(source: R.Source(world: source.syntax, rigid: []))
                let root = try reader.normalHead(job.input)
                if !seen[job.anchor, default: []].insert(root).inserted { continue }
                discovered += 1
                guard case let .application(name, args) = root,
                    let declaration = source.declarations[name], declaration.kind != "protocol"
                else { continue }
                guard declaration.parameters.count == args.count else {
                    throw Failure("unbound reading application '\(root.text)'")
                }
                let parents = source.protocolClosure(source.conformanceChoices(name).map { $0.0 })
                if !parents.contains("PredicateReading") {
                    // Certificate fields can carry applied generic readings.
                    for axis in source.syntax.conformers[name]?.table.keys.sorted() ?? [] {
                        queue.append((job.anchor, job.site + "." + axis, .field(root, axis), job.nested, job.path))
                    }
                    continue
                }
                guard !job.nested else {
                    throw Failure("nested reading application '\(job.site)' is outside this court's binding scope; present a closed typealias")
                }
                let actualPredicate = try reader.normal(.field(root, "Predicate"))
                if actualPredicate != predicate { continue }
                checked += 1
                byPath[job.path, default: 0] += 1
                let beforeRefusals = refusals.count
                guard try reader.normal(.field(root, "Encoding")) == encoding,
                    try reader.normal(.field(root, "Sigma")) == sigma
                else { throw Failure("'\(job.site)' changes the selected count signature") }
                do {
                    let result = try reader.reading(root)
                    if !result.rightEqualsAnswer {
                        refusals.append("'\(job.site)' requires Right == Answer [PredicateReading]")
                    }
                    if result.actual != result.declared {
                        refusals.append("'\(job.site)' count Left = \(result.actual), but Answer = \(result.declared) [\(predicate.text)]")
                    }
                } catch { throw Failure("'\(job.site)' count reading unresolved: \(error)") }
                pathRefusals[job.path, default: []] += refusals.dropFirst(beforeRefusals)

            }
            return Evaluation(checked: checked, refusals: refusals, byPath: byPath, pathRefusals: pathRefusals,
                scope: "\(sigma.text) / \(encoding.text) / \(predicate.text)")
    }

    static func contextRead(_ context: CourtContext, texts: [String: String], documents: Set<String>,
                            options: [String: String]) throws -> [CourtSourcesReport.Row] {
        guard Set(options.keys) == ["--predicate", "--encoding", "--sigma"] else {
            throw Failure("count context needs predicate, encoding and sigma")
        }
        let paths = context.sources.map(\.input)
        guard let contextPath = texts.keys.filter({ !paths.contains($0) }).first, !paths.isEmpty else {
            throw Failure("count context needs its explicit file and sources")
        }
        let selected = context.sources.filter { $0.role == "own" }.map(\.input)
        for first in selected.isEmpty ? [paths[0]] : selected {
            let prepared = try WhereContext.prepare([first] + paths.filter { $0 != first }, contextPath: contextPath,
                load: { texts[$0]! }, documents: documents, batch: true, notationOnly: true)
            if !prepared.world.contextUnresolved.isEmpty { try WhereJudge.failAll(prepared.world.contextUnresolved) }
        }
        let notation = try CourtNotation.read(context, texts: texts, selected: nil, documents: documents)
        let original = context.sources.map { ($0.input, texts[$0.input]!) }
        let source = try StructuralSource(files: original, notationFiles: notation)
        try checkPrimitiveRules(original, source: source)
        // Count's all-input question still discovers closed negative readings
        // carried among definitions. Only explicitly selected Document views
        // exclude implementation bodies; count rules always use original bytes.
        let readings = notation.map { ($0.context.input, documents.contains($0.context.input) ? $0.view : $0.text) }
        let evaluation = try evaluate(readings, source: source, options: options)
        return notation.map { file in
            var row = CourtSourcesReport.Row(path: file.context.input, source: file.context.source)
            row.readings = evaluation.byPath[file.context.input] ?? 0
            row.diagnostics = evaluation.pathRefusals[file.context.input] ?? []
            row.outcome = row.diagnostics.isEmpty ? (row.readings == 0 ? "empty" : "holds") : "not-established"
            row.unchecked = file.unchecked
            return row
        }
    }

    static func run(_ arguments: [String]) {
        do {
            var paths: [String] = [], options: [String: String] = [:], i = 0
            while i < arguments.count {
                let word = arguments[i]
                if word.hasPrefix("--") {
                    guard ["--predicate", "--encoding", "--sigma"].contains(word),
                        options[word] == nil, i + 1 < arguments.count,
                        !arguments[i + 1].hasPrefix("--")
                    else { throw Failure("unsupported, duplicate or incomplete count option '\(word)'") }
                    options[word] = arguments[i + 1]
                    i += 2
                } else {
                    paths.append(word)
                    i += 1
                }
            }
            guard !paths.isEmpty, options.count == 3 else {
                throw Failure("usage: judge count <world.swift> [definitions.swift ...] --predicate <P> --encoding <E> --sigma <S>")
            }
            let files = try paths.map { ($0, try String(contentsOfFile: $0, encoding: .utf8)) }
            for (path, text) in files {
                let clean = try WhereJudge.stripComments(text)
                let notation = try NotationScope(clean)
                if let entry = notation.nested.sorted(by: { $0.key < $1.key }).first {
                    let line = WhereJudge.Scope(clean).line[entry.key]
                    throw Failure("cannot read line \(line) of '\(path)': nested declaration '\(entry.value)' is outside the count notation fragment")
                }
            }
            let source = try StructuralSource(files: files)
            try checkPrimitiveRules(files, source: source)
            let evaluation = try evaluate(files, source: source, options: options)
            let checked = evaluation.checked, refusals = evaluation.refusals
            guard checked > 0 else { throw Failure("no closed PredicateReading for the selected count signature was checked") }
            if !refusals.isEmpty {
                for refusal in refusals { print("✗ COUNT: \(refusal)") }
                exit(1)
            }
            print("✓ COUNT holds: \(checked) source-bound readings checked; finite Unit/Never/Plus rules and definition/count derivations replayed.")
            print("Scope: \(evaluation.scope); all \(files.count) presented files; closed aliases/top-level metatypes; Int range and reader budgets; nominal equality and Swift conformance are separate checks.")
        } catch {
            FileHandle.standardError.write(Data("✗ COUNT unresolved: \(error)\n".utf8))
            exit(2)
        }
    }
}
