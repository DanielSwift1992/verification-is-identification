import Foundation

/// Binds the admitted context's nominal references to full declaration places.
/// The common lexical tape supplies positions; the fragment admits no shadowing.
enum ContextNameBinding {
    struct Place: Codable, Hashable {
        let components: [ScalarName]
        init(parts: [String]) { components = parts.map { ScalarName($0) } }
        init(components: [ScalarName]) { self.components = components }
        var parts: [String] { components.map(\.text) }
        var text: String { parts.joined(separator: ".") }
    }
    struct Site: Codable, Hashable {
        let input: ScalarName
        let source: ScalarName
        let line: Int
        let offset: Int
    }
    struct Declaration: Codable, Equatable {
        let input: ScalarName
        let source: ScalarName
        let line: Int
        let offset: Int
        let place: Place
        let kind: ScalarName
        var definitions: [Site] = []
        var site: Site { Site(input: input, source: source, line: line, offset: offset) }
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
        var extensionBody = false
    }
    struct Index {
        let certificate: Certificate
        private let byInput: [ScalarName: [Int: Reference]]
        private let bySite: [ScalarName: [Int: Place]]
        init(certificate: Certificate) {
            self.certificate = certificate
            var bound: [ScalarName: [Int: Reference]] = [:]
            var places: [ScalarName: [Int: Place]] = [:]
            // The first declaration row owns a site; a reference overrides it.
            // This is the same ordered relation as the former linear lookup.
            for declaration in certificate.declarations {
                for site in [declaration.site] + declaration.definitions {
                    if places[site.input]?[site.offset] == nil {
                        places[site.input, default: [:]][site.offset] = declaration.place
                    }
                }
            }
            for reference in certificate.references {
                bound[reference.input, default: [:]][reference.offset] = reference
                places[reference.input, default: [:]][reference.offset] = reference.declaration
            }
            byInput = bound
            bySite = places
        }
        func reference(input: String, offset: Int) -> Reference? {
            byInput[ScalarName(input)]?[offset]
        }
        func place(input: String, offset: Int) -> Place? {
            bySite[ScalarName(input)]?[offset]
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
        let imports = given ?? ContextImports(files, words: tapes.map(\.words))
        var declarations: [Declaration] = [], scopes: [Scope] = []
        var byPlace: [Place: Declaration] = [:]
        var defaults: Set<Site> = []
        var declaredTokens: [Set<Int>] = files.map { _ in [] }
        let nominal: NameSet = ["enum", "struct", "class", "actor", "protocol"]
        let kinds = nominal.union(["typealias", "associatedtype"])
        // Index supplied file-level nominal owners before visiting extensions.
        // The result does not depend on source order or the extension's module.
        var roots = NameMap<Set<Place>>()
        for (file, tape) in tapes.enumerated() {
            var depth = 0
            for i in tape.words.indices {
                let word = tape.words[i]
                if WhereJudge.sameName(word, "}") { depth -= 1 }
                if depth == 0, nominal.contains(word), i + 1 < tape.words.count,
                   wordOffsets[file].contains(tape.starts[i + 1]),
                   i == 0 || ![".", "import"].containsName(tape.words[i - 1]),
                   !["func", "var", "let", "subscript", "init"].containsName(tape.words[i + 1]) {
                    roots[tape.words[i + 1], default: []].insert(
                        Place(parts: [files[file].context.module, tape.words[i + 1]]))
                }
                if WhereJudge.sameName(word, "{") { depth += 1 }
            }
        }
        let modules = NameSet(files.map(\.context.module))
        func extendedOwner(_ names: [String], file: Int, token: Int) throws -> Place {
            let available = imports.visible(files[file].context)
            if names.count > 1, modules.contains(names[0]) {
                guard available.contains(names[0]) else {
                    try WhereJudge.fail("\(files[file].context.source):\(tapes[file].lines[token]): extension module is not imported")
                }
                return Place(parts: names)
            }
            let candidates = (roots[names[0]] ?? []).filter { available.contains($0.parts[0]) }
            if candidates.count == 1, let root = candidates.first {
                return Place(parts: root.parts + names.dropFirst())
            }
            if candidates.isEmpty, names.count == 1,
               CourtContext.intrinsicExports(version: 2).containsName(names[0]) {
                let place = Place(parts: ["Swift", names[0]])
                if byPlace[place] == nil {
                    let rule = ScalarName("vi.court.context/2#intrinsic-" + names[0])
                    let declaration = Declaration(input: rule, source: rule, line: 1, offset: 0,
                        place: place, kind: ScalarName("intrinsic"))
                    declarations.append(declaration)
                    byPlace[place] = declaration
                }
                return place
            }
            try WhereJudge.fail("\(files[file].context.source):\(tapes[file].lines[token]): extension owner '\(names.joined(separator: "."))' is missing or ambiguous in the supplied context")
        }
        func owner(_ file: Int, _ offset: Int) -> Place {
            scopes.last { $0.file == file && $0.open < offset && offset < $0.end }?.place
                ?? Place(parts: [files[file].context.module])
        }
        func append(_ file: Int, _ token: Int, _ place: Place, _ kind: String) throws {
            let tape = tapes[file], source = files[file].context.source
            let declaration = Declaration(input: ScalarName(files[file].context.input), source: ScalarName(source), line: tape.lines[token],
                offset: tape.starts[token], place: place, kind: ScalarName(kind))
            declarations.append(declaration)
            byPlace[place] = declaration
            let insideExtension = scopes.last { $0.file == file && $0.open < tape.starts[token] && tape.starts[token] < $0.end }?.extensionBody ?? false
            if insideExtension, WhereJudge.sameName(kind, "typealias"),
               token + 1 == tape.words.count || !WhereJudge.sameName(tape.words[token + 1], "<") {
                defaults.insert(declaration.site)
            }
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
                        names.append(tape.words[cursor + 1])
                        cursor += 2
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
                            let full = try extendedOwner(names, file: file, token: i)
                            scopes.append(Scope(file: file, start: tape.starts[i + 1], open: tape.starts[open],
                                end: tape.ends[end - 1], place: full, extensionBody: true))
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
        // An associated slot is declared once. A parameterless typealias in
        // its protocol extension defines that slot's default, not another slot.
        let grouped = Dictionary(grouping: declarations, by: \.place)
        var unique: [Declaration] = [], seen: Set<Place> = []
        for row in declarations {
            guard seen.insert(row.place).inserted else { continue }
            let group = grouped[row.place]!
            if group.count == 1 { unique.append(row)
                continue }
            let axes = group.filter { $0.kind == ScalarName("associatedtype") }
            let definitions = group.filter { defaults.contains($0.site) }
            guard group.count == 2, axes.count == 1, definitions.count == 1 else {
                let last = group.last!
                try WhereJudge.fail("\(last.source.text):\(last.line): duplicate declaration '\(last.place.text)' in the same owner; first \(row.source.text):\(row.line)")
            }
            var axis = axes[0]
            axis.definitions = definitions.map(\.site)
            unique.append(axis)
        }
        declarations = unique
        byPlace = Dictionary(uniqueKeysWithValues: declarations.map { ($0.place, $0) })
        for declaration in declarations
        where declaration.place.parts.count > 2 {
            let parent = Place(parts: Array(declaration.place.parts.dropLast()))
            guard byPlace[parent] != nil else {
                try WhereJudge.fail("\(declaration.source.text):\(declaration.line): declaration owner '\(parent.text)' is not provided")
            }
        }
        for scope in scopes {
            guard byPlace[scope.place] != nil else {
                let line = tapes[scope.file].starts.firstIndex(of: scope.start).map { tapes[scope.file].lines[$0] } ?? 1
                try WhereJudge.fail("\(files[scope.file].context.source):\(line): scope owner '\(scope.place.text)' is not provided")
            }
        }
        let intrinsic = ScalarName("intrinsic")
        let intrinsicRoots = Dictionary(grouping: declarations.filter {
            $0.kind == intrinsic && $0.place.components.count == 2
        }, by: { $0.place.components.last! })
        var references: [Reference] = [], ambiguities: [String] = []
        for (file, tape) in tapes.enumerated() {
            let accessible = imports.visible(files[file].context)
            let moduleParents = accessible.map { Place(parts: [$0]) }
            let orderedScopes = scopes.filter { $0.file == file }.sorted { $0.start < $1.start }
            var active: [Scope] = [], scopeCursor = 0
            for i in tape.words.indices {
                let word = tape.words[i]
                let position = tape.starts[i]
                while scopeCursor < orderedScopes.count && orderedScopes[scopeCursor].start <= position {
                    active.append(orderedScopes[scopeCursor])
                    scopeCursor += 1
                }
                active.removeAll { position >= $0.end }
                guard wordOffsets[file].contains(tape.starts[i]), !declaredTokens[file].contains(i),
                      i == 0 || ![".", "import"].containsName(tape.words[i - 1]) else { continue }
                // A visible declaration's parent is an imported module, an
                // active lexical owner, or an intrinsic profile root.
                let name = ScalarName(word)
                var candidates: Set<Place> = []
                for parent in moduleParents + active.map(\.place) {
                    let candidate = Place(components: parent.components + [name])
                    if byPlace[candidate] != nil { candidates.insert(candidate) }
                }
                for declaration in intrinsicRoots[name] ?? [] {
                    candidates.insert(declaration.place)
                }
                if WhereJudge.sameName(word, "Self"), let own = active.last(
                    where: {
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
                guard let selected = candidates.first else { continue }
                var target = selected
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
            inputs: files.map { Input(input: ScalarName($0.context.input), module: ScalarName($0.context.module), imports: $0.context.imports.map { ScalarName($0) },
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
                    paths.append(words[i])
                    i += 1
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
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
            FileHandle.standardOutput.write(try encoder.encode(proofs) + Data([10]))
        } catch {
            FileHandle.standardError.write(Data(("name binding replay refused: \(error)\n").utf8))
            exit(2)
        }
    }

}
