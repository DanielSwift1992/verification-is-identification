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
        let modifiers: Set<String> = ["public", "internal", "private", "fileprivate", "package"]
        return StructuralSource.plain(try StructuralSource.tokens(text)).filter { !modifiers.contains($0) }
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
            if let body, try shape(StructuralSource.text(found[0].body)) != shape(body) {
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

    indirect enum Proof {
        case zero(R.Derivation)
        case unit(R.Derivation)
        case plus(R.Derivation, Proof, Proof)
    }

    struct Reader {
        let source: R.Source

        func derive(_ input: E, depth: Int = 0, budget: inout Int) throws -> Proof {
            guard depth < 128, budget > 0 else { throw Failure("count expression exceeds the finite reader budget") }
            budget -= 1
            let reduction = try R.derive(input, source: source, depthLimit: 128,
                                         nodeLimit: 50_000, headOnly: true)
            let output = try R.replay(reduction, source: source, nodeLimit: 100_000).output
            switch output {
            case .application("Never", []): return .zero(reduction)
            case .application("Unit", []): return .unit(reduction)
            case let .application("Plus", args):
                guard args.count == 2 else { throw Failure("Plus must have exactly two count operands") }
                let left = try derive(args[0], depth: depth + 1, budget: &budget)
                let right = try derive(args[1], depth: depth + 1, budget: &budget)
                return .plus(reduction, left, right)
            default: throw Failure("'\(output.text)' is outside the finite Unit/Never/Plus count fragment")
            }
        }

        /// Replay binds every arithmetic step to the original expression and
        /// source reduction. The certificate contains no asserted integer.
        func replay(_ proof: Proof, input: E, depth: Int = 0, budget: inout Int) throws -> Int {
            guard depth < 128, budget > 0 else { throw Failure("count proof exceeds the replay budget") }
            budget -= 1
            let reduction: R.Derivation
            switch proof {
            case let .zero(d), let .unit(d), let .plus(d, _, _): reduction = d
            }
            let ends = try R.replay(reduction, source: source, nodeLimit: 100_000)
            guard ends.input == input else { throw Failure("count proof changes its source") }
            switch (proof, ends.output) {
            case (.zero, .application("Never", [])): return 0
            case (.unit, .application("Unit", [])): return 1
            case let (.plus(_, l, r), .application("Plus", args)):
                guard args.count == 2 else { throw Failure("Plus proof must have exactly two operands") }
                let a = try replay(l, input: args[0], depth: depth + 1, budget: &budget)
                let b = try replay(r, input: args[1], depth: depth + 1, budget: &budget)
                let (sum, overflow) = a.addingReportingOverflow(b)
                guard !overflow else { throw Failure("count exceeds Int.max at '\(input.text)'") }
                return sum
            default: throw Failure("count proof uses a rule without its source shape")
            }
        }

        func count(_ input: E) throws -> Int {
            var constructionBudget = 50_000, replayBudget = 50_000
            let proof = try derive(input, budget: &constructionBudget)
            return try replay(proof, input: input, budget: &replayBudget)
        }
        func normal(_ input: E) throws -> E {
            let proof = try R.derive(input, source: source, depthLimit: 128, nodeLimit: 50_000)
            let ends = try R.replay(proof, source: source, nodeLimit: 100_000)
            guard ends.input == input else { throw Failure("field reduction changes its source") }
            return ends.output
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
            let source = try StructuralSource(files: files)
            try checkPrimitiveRules(files, source: source)
            let reader = Reader(source: R.Source(world: source.syntax, rigid: []))
            let predicate = try reader.normal(R.parse(options["--predicate"]!))
            let encoding = try reader.normal(R.parse(options["--encoding"]!))
            let sigma = try reader.normal(R.parse(options["--sigma"]!))
            // All presented files are checked: moving a counterexample into
            // the definitions position cannot hide its selected readings.
            var queue: [(anchor: String, site: String, input: E, nested: Bool)] = []
            for (path, text) in files {
                for hit in try metatypes(text) {
                    queue.append((path + ":" + hit.input.text, hit.input.text, hit.input, hit.nested))
                }
            }
            for d in source.declarations.values.sorted(by: { $0.name < $1.name })
            where d.parameters.isEmpty {
                queue.append((d.name, d.name, .application(d.name, []), false))
            }
            var seen: [String: Set<E>] = [:], discovered = 0, checked = 0, refusals: [String] = []
            while let job = queue.popLast() {
                guard discovered < 20_000 else { throw Failure("count application discovery exceeds its budget") }
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
                        queue.append((job.anchor, job.site + "." + axis, .field(root, axis), job.nested))
                    }
                    continue
                }
                guard !job.nested else {
                    throw Failure("nested reading application '\(job.site)' is outside this court's binding scope; present a closed typealias")
                }
                let actualPredicate = try reader.normal(.field(root, "Predicate"))
                if actualPredicate != predicate { continue }
                checked += 1
                guard try reader.normal(.field(root, "Encoding")) == encoding,
                    try reader.normal(.field(root, "Sigma")) == sigma
                else { throw Failure("'\(job.site)' changes the selected count signature") }
                let input: E = .field(root, "Left"), answer: E = .field(root, "Answer")
                let answerForm = try reader.normal(answer)
                let rightForm = try reader.normal(.field(root, "Right"))
                if rightForm != answerForm {
                    refusals.append("'\(job.site)' requires Right == Answer [PredicateReading]")
                }
                do {
                    let actual = try reader.count(input), declared = try reader.count(answer)
                    if actual != declared {
                        refusals.append("'\(job.site)' count Left = \(actual), but Answer = \(declared) [\(predicate.text)]")
                    }
                } catch { throw Failure("'\(job.site)' count reading unresolved: \(error)") }
            }
            guard checked > 0 else { throw Failure("no closed PredicateReading for the selected count signature was checked") }
            if !refusals.isEmpty {
                for refusal in refusals { print("✗ COUNT: \(refusal)") }
                exit(1)
            }
            print("✓ COUNT holds: \(checked) source-bound readings checked; finite Unit/Never/Plus rules and definition/count derivations replayed.")
            print("Scope: \(sigma.text) / \(encoding.text) / \(predicate.text); all \(files.count) presented files; closed aliases/top-level metatypes; Int range and reader budgets; nominal equality and Swift conformance are separate checks.")
        } catch {
            FileHandle.standardError.write(Data("✗ COUNT unresolved: \(error)\n".utf8))
            exit(2)
        }
    }
}

extension CountCourt.Reader {
    func normalHead(_ input: CountCourt.E) throws -> CountCourt.E {
        let proof = try CountCourt.R.derive(input, source: source, depthLimit: 128,
                                           nodeLimit: 50_000, headOnly: true)
        let ends = try CountCourt.R.replay(proof, source: source, nodeLimit: 100_000)
        guard ends.input == input else { throw CountCourt.Failure("application reduction changes its source") }
        return ends.output
    }
}
