import Foundation

/// Serializes the common scalar identity as its written text.
/// Accepted T0083 supplies this same conformance on the shared carrier.
extension ScalarName: Codable {
    init(from decoder: Decoder) throws {
        self.init(try decoder.singleValueContainer().decode(String.self))
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(text)
    }
}

/// Binds the admitted context's nominal references to full declaration places.
/// The common lexical tape supplies positions; the fragment admits no shadowing.
enum ContextNameBinding {
    struct Place: Codable, Hashable {
        let components: [ScalarName]
        init(parts: [String]) { components = parts.map(ScalarName.init) }
        var parts: [String] { components.map(\.text) }
        var text: String { parts.joined(separator: ".") }
    }
    struct Declaration: Codable, Equatable {
        let input: ScalarName
        let source: ScalarName
        let line: Int
        let offset: Int
        let place: Place
        let kind: ScalarName
    }
    struct Reference: Codable, Equatable {
        let input: ScalarName
        let scopes: [Place]
        let source: ScalarName
        let line: Int
        let offset: Int
        let end: Int
        let spelling: ScalarName
        let declaration: Place
    }
    struct Input: Codable, Equatable {
        let input: ScalarName
        let module: ScalarName
        let imports: [ScalarName]
        let source: ScalarName
        let sha256: String
        let viewSHA256: String
    }
    struct Certificate: Codable {
        let schema: ScalarName
        let selected: ScalarName
        let inputs: [Input]
        let declarations: [Declaration]
        let references: [Reference]
    }
    struct Scope {
        let file: Int
        let start: Int
        let open: Int
        let end: Int
        let place: Place
    }
    struct Index {
        let certificate: Certificate
        private let byInput: [ScalarName: [Int: Reference]]
        init(certificate: Certificate) {
            self.certificate = certificate
            var bound: [ScalarName: [Int: Reference]] = [:]
            for reference in certificate.references {
                bound[reference.input, default: [:]][reference.offset] = reference
            }
            byInput = bound
        }
        func reference(input: String, offset: Int) -> Reference? {
            byInput[ScalarName(input)]?[offset]
        }
        func place(input: String, offset: Int) -> Place? {
            reference(input: input, offset: offset)?.declaration
                ?? certificate.declarations.first { $0.input == ScalarName(input) && $0.offset == offset }?.place
        }
        /// Replays every place and occurrence against the complete source-derived
        /// relation. Omitting, adding or redirecting an edge cannot pass coverage.
        func replay(_ candidate: Certificate) throws {
            let expected = certificate
            guard candidate.schema == expected.schema, candidate.selected == expected.selected,
                  candidate.inputs.count == expected.inputs.count,
                  candidate.declarations.count == expected.declarations.count,
                  candidate.references.count == expected.references.count else {
                let source = expected.inputs.first?.source.text ?? "context"
                try WhereJudge.fail("\(source):1: name binding certificate: source/declaration/reference coverage differs")
            }
            for (a, b) in zip(candidate.inputs, expected.inputs) {
                guard a == b else { try WhereJudge.fail("\(b.source.text):1: name binding input differs") }
            }
            for (a, b) in zip(candidate.declarations, expected.declarations) {
                guard a == b else {
                    try WhereJudge.fail("\(b.source.text):\(b.line): name binding declaration differs")
                }
            }
            for (a, b) in zip(candidate.references, expected.references) {
                guard a == b else {
                    try WhereJudge.fail("\(b.source.text):\(b.line): name binding reference differs at view byte \(b.offset)")
                }
            }
        }
    }

    private static func fileEnd(_ tape: WhereJudge.Lexed) -> Int { tape.ends.last ?? 0 }

    static func read(_ files: [CourtNotation.File], selected: String,
                     reading supplied: [WhereJudge.LexicalReading]? = nil, imports given: ContextImports? = nil) throws -> Index {
        let readings = try supplied ?? WhereJudge.lexicalReadings(files.map { ($0.context.source, $0.world.clean) },
            scope: .notation, carrying: true)
        let wordOffsets = readings.map { Set($0.words.map(\.byte)) }
        let tapes = readings.map { reading -> WhereJudge.Lexed in
            let indices = reading.tape.words.indices.filter { !WhereJudge.sameName(reading.tape.words[$0], "\n") }
            var t = WhereJudge.Lexed()
            t.words = indices.map { reading.tape.words[$0] }
            t.starts = indices.map { reading.tape.starts[$0] }
            t.ends = indices.map { reading.tape.ends[$0] }
            t.lines = indices.map { reading.tape.lines[$0] }
            return t
        }
        var declarations: [Declaration] = [], scopes: [Scope] = []
        var byPlace: [Place: Declaration] = [:]
        var declaredTokens: [Set<Int>] = files.map { _ in [] }
        let nominal: NameSet = ["enum", "struct", "class", "actor", "protocol"]
        let kinds = nominal.union(["typealias", "associatedtype"])
        func owner(_ file: Int, _ offset: Int) -> Place {
            scopes.last { $0.file == file && $0.open < offset && offset < $0.end }?.place
                ?? Place(parts: [files[file].context.module])
        }
        func append(_ file: Int, _ token: Int, _ place: Place, _ kind: String) throws {
            let tape = tapes[file], source = files[file].context.source
            if let prior = byPlace[place] {
                try WhereJudge.fail("\(source):\(tape.lines[token]): duplicate declaration '\(place.text)' in the same owner; first \(prior.source.text):\(prior.line)")
            }
            let declaration = Declaration(input: ScalarName(files[file].context.input), source: ScalarName(source), line: tape.lines[token],
                offset: tape.starts[token], place: place, kind: ScalarName(kind))
            declarations.append(declaration)
            byPlace[place] = declaration
            declaredTokens[file].insert(token)
        }
        // Type owners and their children are read in lexical order. No regular
        // expression or second identifier alphabet selects a declaration here.
        for (file, tape) in tapes.enumerated() {
            for i in tape.words.indices {
                let word = tape.words[i]
                if WhereJudge.sameName(word, "extension"), i + 1 < tape.words.count {
                    var names = [tape.words[i + 1]], cursor = i + 2
                    while cursor + 1 < tape.words.count && WhereJudge.sameName(tape.words[cursor], ".") {
                        names.append(tape.words[cursor + 1]); cursor += 2
                    }
                    var open = cursor
                    while open < tape.words.count && !WhereJudge.sameName(tape.words[open], "{") { open += 1 }
                    if open < tape.words.count {
                        var end = open + 1, depth = 1
                        while end < tape.words.count && depth > 0 {
                            if WhereJudge.sameName(tape.words[end], "{") { depth += 1 }
                            if WhereJudge.sameName(tape.words[end], "}") { depth -= 1 }
                            end += 1
                        }
                        if depth == 0 {
                            let module = files[file].context.module
                            let full = declarations.first { WhereJudge.sameNames($0.place.parts, [module] + names) }?.place
                                ?? Place(parts: [module] + names)
                            scopes.append(Scope(file: file, start: tape.starts[i + 1], open: tape.starts[open],
                                end: tape.ends[end - 1], place: full))
                        }
                    }
                }
                guard kinds.contains(word), i + 1 < tape.words.count,
                      wordOffsets[file].contains(tape.starts[i + 1]),
                      i == 0 || ![".", "import"].containsName(tape.words[i - 1]) else { continue }
                if WhereJudge.sameName(word, "class"),
                   ["func", "var", "let", "subscript", "init"].containsName(tape.words[i + 1]) { continue }
                let parent = owner(file, tape.starts[i])
                let place = Place(parts: parent.parts + [tape.words[i + 1]])
                try append(file, i + 1, place, word)
                if WhereJudge.sameName(word, "typealias"), i + 2 < tape.words.count,
                   WhereJudge.sameName(tape.words[i + 2], "<") {
                    var cursor = i + 3, depth = 1, expectsName = true
                    while cursor < tape.words.count && depth > 0 {
                        let token = tape.words[cursor]
                        if depth == 1 && expectsName && wordOffsets[file].contains(tape.starts[cursor]) {
                            try append(file, cursor, Place(parts: place.parts + [token]), "parameter")
                            expectsName = false
                        }
                        if WhereJudge.sameName(token, "<") { depth += 1 }
                        if WhereJudge.sameName(token, ">") { depth -= 1 }
                        if depth == 1 && WhereJudge.sameName(token, ",") { expectsName = true }
                        cursor += 1
                    }
                    var end = cursor, nesting = 0
                    while end < tape.words.count {
                        let token = tape.words[end]
                        if end > cursor && nesting == 0 && tape.lines[end] > tape.lines[end - 1]
                            && !["=", ","].containsName(tape.words[end - 1]) { break }
                        if ["<", "(", "["].containsName(token) { nesting += 1 }
                        if [">", ")", "]"].containsName(token) { nesting -= 1 }
                        if nesting == 0 && [";", "}"].containsName(token) { break }
                        end += 1
                    }
                    let upper = end < tape.words.count ? tape.starts[end] : fileEnd(tape)
                    scopes.append(Scope(file: file, start: tape.starts[i + 1], open: tape.starts[i + 1],
                        end: upper, place: place))
                }
                if nominal.contains(word) {
                    var open = i + 2
                    while open < tape.words.count && !WhereJudge.sameName(tape.words[open], "{") { open += 1 }
                    guard open < tape.words.count else { try WhereJudge.fail("\(files[file].context.source):\(tape.lines[i]): nominal owner has no body") }
                    var end = open + 1, depth = 1
                    while end < tape.words.count && depth > 0 {
                        if WhereJudge.sameName(tape.words[end], "{") { depth += 1 }
                        if WhereJudge.sameName(tape.words[end], "}") { depth -= 1 }
                        end += 1
                    }
                    guard depth == 0 else { try WhereJudge.fail("\(files[file].context.source):\(tape.lines[i]): nominal owner body is incomplete") }
                    scopes.append(Scope(file: file, start: tape.starts[i + 1], open: tape.starts[open],
                        end: tape.ends[end - 1], place: place))
                    // A generic parameter is a declaration of this owner. Its
                    // constraints are references, not additional parameter names.
                    if i + 2 < open, WhereJudge.sameName(tape.words[i + 2], "<") {
                        var depth = 1, cursor = i + 3, expectsName = true
                        while cursor < open && depth > 0 {
                            let token = tape.words[cursor]
                            if depth == 1 && expectsName && wordOffsets[file].contains(tape.starts[cursor]) {
                                try append(file, cursor, Place(parts: place.parts + [token]), "parameter")
                                expectsName = false
                            }
                            if WhereJudge.sameName(token, "<") { depth += 1 }
                            if WhereJudge.sameName(token, ">") { depth -= 1 }
                            if depth == 1 && WhereJudge.sameName(token, ",") { expectsName = true }
                            cursor += 1
                        }
                    }
                }
            }
        }
        let imports = given ?? ContextImports(files, words: tapes.map(\.words))
        let byName = Dictionary(grouping: declarations, by: { ScalarName($0.place.parts.last!) })
        var references: [Reference] = [], ambiguities: [String] = []
        let modules = NameSet(files.map(\.context.module))
        for (file, tape) in tapes.enumerated() {
            let accessible = imports.visible(files[file].context)
            let orderedScopes = scopes.filter { $0.file == file }.sorted { $0.start < $1.start }
            var active: [Scope] = [], scopeCursor = 0
            for i in tape.words.indices {
                let word = tape.words[i]
                let position = tape.starts[i]
                while scopeCursor < orderedScopes.count && orderedScopes[scopeCursor].start <= position {
                    active.append(orderedScopes[scopeCursor]); scopeCursor += 1
                }
                active.removeAll { position >= $0.end }
                guard wordOffsets[file].contains(tape.starts[i]), !declaredTokens[file].contains(i),
                      i == 0 || ![".", "import"].containsName(tape.words[i - 1]) else { continue }
                var candidates = Set((byName[ScalarName(word)] ?? []).filter { declaration in
                    let parent = Array(declaration.place.parts.dropLast())
                    if parent.count == 1 { return accessible.contains(parent[0]) }
                    return active.contains { WhereJudge.sameNames($0.place.parts, parent) }
                }.map(\.place))
                if WhereJudge.sameName(word, "Self"), let own = active.last(where: {
                    byPlace[$0.place].map { nominal.contains($0.kind.text) } ?? false
                }) {
                    candidates = [own.place]
                }
                var end = i, spelling = word
                if modules.contains(word), i + 2 < tape.words.count,
                   WhereJudge.sameName(tape.words[i + 1], ".") {
                    guard candidates.isEmpty, accessible.contains(word) else {
                        try WhereJudge.fail("\(files[file].context.source):\(tape.lines[i]): module qualifier '\(word)' is ambiguous or not imported")
                    }
                    let full = Place(parts: [word, tape.words[i + 2]])
                    candidates = byPlace[full] == nil ? [] : [full]
                    guard !candidates.isEmpty else {
                        try WhereJudge.fail("\(files[file].context.source):\(tape.lines[i]): module '\(word)' has no declaration '\(tape.words[i + 2])'")
                    }
                    end = i + 2
                    spelling = word + "." + tape.words[i + 2]
                }
                if candidates.count > 1 {
                    let places = candidates.map(\.text).sorted().joined(separator: ", ")
                    ambiguities.append("\(files[file].context.source):\(tape.lines[i]): ambiguous name \(word): write Owner.\(word) or Module.\(word); visible: \(places)")
                    continue
                }
                guard var target = candidates.first else { continue }
                // A concrete member path selects its declared owner. A generic
                // or associated projection retains its existing reduction rules.
                while end + 2 < tape.words.count && WhereJudge.sameName(tape.words[end + 1], ".") {
                    let member = Place(parts: target.parts + [tape.words[end + 2]])
                    guard byPlace[member] != nil else { break }
                    target = member
                    spelling += "." + tape.words[end + 2]
                    end += 2
                }
                references.append(Reference(input: ScalarName(files[file].context.input), scopes: active.map(\.place),
                    source: ScalarName(files[file].context.source),
                    line: tape.lines[i], offset: tape.starts[i], end: tape.ends[end],
                    spelling: ScalarName(spelling), declaration: target))
            }
        }
        if !ambiguities.isEmpty { try WhereJudge.failAll(ambiguities) }
        let certificate = Certificate(schema: ScalarName("vi.court.context-name-bindings/1"), selected: ScalarName(selected),
            inputs: files.map { Input(input: ScalarName($0.context.input), module: ScalarName($0.context.module), imports: $0.context.imports.map(ScalarName.init),
                source: ScalarName($0.context.source), sha256: $0.context.sha256,
                viewSHA256: courtSHA256(Data($0.world.clean.utf8))) },
            declarations: declarations, references: references)
        return Index(certificate: certificate)
    }

    /// Transports a byte-bound binding derivation independently of a particular
    /// equality question. Replay reads the same inputs and checks every edge.
    static func run(_ arguments: [String], replay: Bool) {
        do {
            var words = arguments, proofPath: String?
            if replay {
                guard !words.isEmpty else { try WhereJudge.fail("name binding replay needs a certificate") }
                proofPath = words.removeFirst()
            }
            var paths: [String] = [], contextPath: String?, documents = NameSet(), i = 0
            while i < words.count {
                if WhereJudge.sameName(words[i], "--context"), contextPath == nil, i + 1 < words.count {
                    contextPath = words[i + 1]
                    i += 2
                } else if WhereJudge.sameName(words[i], "--document"), i + 1 < words.count,
                          documents.insert(words[i + 1]).inserted {
                    i += 2
                } else {
                    guard !words[i].hasPrefix("--") else { try WhereJudge.fail("unsupported name binding option") }
                    paths.append(words[i]); i += 1
                }
            }
            guard !paths.isEmpty, let contextPath else {
                try WhereJudge.fail("name bindings need sources and --context")
            }
            var texts = NameMap<String>()
            for path in paths { texts[path] = try WhereJudge.fileText(path) }
            let context = try CourtContext(text: WhereJudge.fileText(contextPath), paths: paths, texts: texts)
            guard context.version == 2 else { try WhereJudge.fail("name bindings require context/2") }
            let own = context.sources.filter { WhereJudge.sameName($0.role, "own") }.sorted { WhereContextNames.less(ScalarName($0.input), ScalarName($1.input)) }
            guard !own.isEmpty, documents.isSubset(of: NameSet(own.map(\.input))) else {
                try WhereJudge.fail("name bindings need own sources and declared own documents")
            }
            let indices = try own.map { source in
                let files = try CourtNotation.read(context, texts: texts, selected: source.input, documents: documents)
                return try read(files, selected: source.input)
            }
            let proofs = try proofPath.map {
                try CourtJSON.decoder().decode([Certificate].self, from: Data(contentsOf: URL(fileURLWithPath: $0)))
            } ?? indices.map(\.certificate)
            guard proofs.count == indices.count else { try WhereJudge.fail("name binding question coverage differs") }
            for (index, proof) in zip(indices, proofs) { try index.replay(proof) }
            let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
            FileHandle.standardOutput.write(try encoder.encode(proofs) + Data([10]))
        } catch {
            FileHandle.standardError.write(Data(("name binding replay refused: \(error)\n").utf8))
            exit(2)
        }
    }

}
