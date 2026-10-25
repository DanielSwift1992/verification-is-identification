import Alphabet
import Court
import Foundation
import GrammarLexicon
import VerificationIsIdentification

// ═══════════════════════════════════════════════════════
// LINTER carries source text into typed formations in a child Swift build.
// The build resolves emitted Swift names and checks scope/context grants;
// the exempt column requires only LintAtom.
// Law §T′ requires a derivation binding each source reference to a place and
// accounting for every input byte. Medium atoms and opaque contents are
// omitted here; no byte-covering read derivation reaches the child build.
// Reader debt: Contracts/Checks/grammar-reader-v1.md#open-debt.
// Rules for which bytes matter must be declared as types; the court checks
// the derivation against that declaration, including coverage and bindings.
// Correctness of replay and of the type checker are premises of the verdict.
// Lexemes come from registries; opaque bounds come from Court's shared lexer;
// a new registered atom is carried without edits to this file.
// Reflective names still need source bindings checked against the input.
// Portable findings run no child type check and share the open reader debt.
// The child build judges the presented formations; it does not establish
// that the source bytes and references were read as declared. Carrier delivery
// checks distinct destinations and exact read-back bytes, not that read derivation.
// ═══════════════════════════════════════════════════════

/// This is either a real, registered atom (read reflectively, not named here) or a character the
/// registry never claimed: still classified, still given a MECHANICAL code-point name, its
/// undeclared name is what makes the mirror refuse it. `String(describing:)` reads the
/// IDENTIFIER axis only (ROUND-UNIFY.md Phase 1): a unified atom's `typeName` is now its
/// CONTENT (the character it renders as, DocumentKit's reading), so this file must not read
/// `typeName` at all to recover a name — the two axes coincided before unification, not after.
private enum Classified {
    case known(any LintAtom.Type)
    case unknown(Character)

    var name: String {
        switch self {
        case .known(let atom): return String(describing: atom)
        case .unknown(let c): return "Char\(c.unicodeScalars.first?.value ?? 0)Atom"
        }
    }
    var atomType: (any LintAtom.Type)? {
        switch self {
        case .known(let atom): return atom
        case .unknown: return nil
        }
    }
}

enum Linter {
    // ── Tables built FROM the registries — this file's only "knowledge" is that the lists
    //    exist; what is IN them is the lexicon's and the schema's business. ──

    private static let glyphTable: [Character: any Lexeme.Type] = {
        var table: [Character: any Lexeme.Type] = [:]
        for lexeme in Alphabet.lexemes { table[lexeme.glyph] = lexeme }
        return table
    }()

    /// This gives spellings a word run can be, looked up AFTER the whole run is accumulated, so
    /// word-boundary correctness comes for free.
    private static let wordSpellings: [String: any Spelled.Type] = {
        var table: [String: any Spelled.Type] = [:]
        for spelled in Schema.spellings
        where spelled.spelling.first.map(isIdentifierChar) == true {
            table[spelled.spelling] = spelled
        }
        return table
    }()

    /// This gives spellings that start at punctuation, longest first (maximal munch, the one
    /// reading policy this file applies on its own terms, over whatever the schema declares).
    private static let punctuationSpellings: [any Spelled.Type] = {
        Schema.spellings
            .filter { $0.spelling.first.map(isIdentifierChar) != true }
            .sorted { $0.spelling.count > $1.spelling.count }
    }()

    private static func defaultMap() -> GrammarScopeMap {
        GrammarScopeMap(entries: Schema.scopes.map {
            GrammarScopeMap.Entry(prefix: $0.prefix, scope: String(describing: $0.scope))
        })
    }

    private static func isIdentifierChar(_ c: Character) -> Bool { c.isLetter || c.isNumber || c == "_" }

    /// This reads in. One pass over one file, emitting as it reads. Which block type an opener
    /// becomes is two mechanical facts: the file's scope and whether the atom just before it
    /// grants `OpensBuilder`, and only an `AlwaysPairs` opener becomes a block at all.
    /// Word runs are classified here; opaque bounds, including nested interpolation,
    /// come from the common scalar lexer rather than a second span scanner.
    static func carried(_ content: String, path: String, scopeName: String) throws -> String {
        let spans = try GrammarSpans(content, path: path)
        let chars = Array(content)
        var i = 0
        var lastType: (any LintAtom.Type)? = Alphabet.defaultWord   // the file's start
        var headSeen = true   // the file's start heads a plain sentence
        var lineHeaded = true   // and heads its line
        var exemptSeen = false   // the reader selected Exempt; its column requires only LintAtom

        /// This is one open block being carried: its pairing opener, the name its parent will
        /// reference it by, the builder attribute its scope×context names, and its body
        /// text as accumulated so far. Navigation, not duplication (Formation's doc): a
        /// closed block leaves as a SMALL DECLARATION and its parent keeps one reference line,
        /// the emitted package never holds a nested expression. References and carrier
        /// groups receive mechanical names from counters.
        struct Carried {
            let opener: (any OpeningAtom.Type)?
            let name: String
            let attribute: String
            let indent: String
            var text = ""
        }
        var frames = [Carried(opener: nil, name: "", attribute: "", indent: "        ")]
        var declarations: [String] = []
        var blockCount = 0

        func advance(_ n: Int) { i = Swift.min(i + n, chars.count) }

        func emit(_ statement: String) {
            frames[frames.count - 1].text += frames[frames.count - 1].indent + statement + "\n"
        }

        // Groups already classified statements in order under their original builder.
        // Formation admits each group; the same scope×context checks every leaf.
        var groupCount = 0
        func writtenBody(_ text: String, _ attribute: String, _ indent: String) -> String {
            var lines = text.components(separatedBy: "\n").dropLast().map { $0 }
            var groups = ""
            while lines.count > 128 {
                var references: [String] = []
                for start in stride(from: 0, to: lines.count, by: 128) {
                    let name = "CarrierGroup\(groupCount)"
                    groupCount += 1
                    groups += indent + "enum \(name): Formation {\n"
                        + indent + "    @\(attribute) static var body: Never.Type {\n"
                        + lines[start..<min(start + 128, lines.count)].joined(separator: "\n") + "\n"
                        + indent + "    }\n" + indent + "}\n"
                    references.append(indent + "    \(name).self")
                }
                lines = references
            }
            return groups + indent + "@\(attribute) static var body: Never.Type {\n"
                + lines.map { $0 + "\n" }.joined() + indent + "}\n"
        }

        /// This gives one classified atom at the current position, consuming as many characters
        /// as it spans: the WORD path (accumulate the whole identifier run, THEN look up the run)
        /// or the SPELLING/GLYPH path (longest match first). A general word also hands back its
        /// text: decoration for the emitted line, so a refusal reads like the source.
        func nextAtom() -> (Classified, wordText: String?) {
            guard i < chars.count else { return (.unknown("\0"), nil) }
            let c = chars[i]
            if isIdentifierChar(c) {
                var word = ""
                var j = i
                while j < chars.count, isIdentifierChar(chars[j]) {
                    word.append(chars[j])
                    j += 1
                }
                advance(word.count)
                if let spelled = wordSpellings[word] { return (.known(spelled), nil) }
                return (.known(Alphabet.defaultWord), word)
            }
            for spelled in punctuationSpellings {
                let n = spelled.spelling.count
                guard i + n <= chars.count else { continue }
                if String(chars[i..<(i + n)]) == spelled.spelling {
                    advance(n)
                    return (.known(spelled), nil)
                }
            }
            if let lexeme = glyphTable[c] {
                advance(1)
                return (.known(lexeme), nil)
            }
            advance(1)
            return (.unknown(c), nil)
        }

        while i < chars.count {
            if let span = spans.at[i] {
                let atom: (any LintAtom.Type)? = punctuationSpellings.first { $0.spelling == span.opening }
                    ?? (span.opening.count == 1 ? glyphTable[Character(span.opening)] : nil)
                guard let atom, atom is any ForeignOpener.Type else {
                    throw GrammarSpans.Refusal(description: "\(path):\(span.line): unregistered foreign opener '\(span.opening)'")
                }
                emit("\(String(describing: atom)).self")
                lastType = atom
                i = span.end
                continue
            }
            let (classified, wordText) = nextAtom()

            guard let atom = classified.atomType else {
                emit("\(classified.name).self")   // undeclared name: the refusal itself
                lastType = nil
                continue
            }

            if atom is any DeclarationHead.Type {
                headSeen = true   // this sentence, when it reaches its brace, is a plain body
            }
            if atom is any OpensExempt.Type {
                exemptSeen = true
            }
            if atom is any ForeignOpener.Type {
                throw GrammarSpans.Refusal(description: "\(path):1: foreign opener has no shared lexical span")
            }
            if atom is any MediumAtom.Type {
                if (atom as? any Lexeme.Type).map({ $0.glyph.isNewline }) == true {
                    lineHeaded = true   // the next atom heads its line
                }
                continue   // splits runs, not content, does not update the mark before
            }
            let headsItsLine = lineHeaded
            if !(atom is any LineModifier.Type) {
                lineHeaded = false   // a modifier stays transparent — the head is still open
            }
            if let opening = atom as? any OpeningAtom.Type {
                if opening is any AlwaysPairs.Type {
                    let opensBuilder = lastType.map { $0 is any OpensBuilder.Type } ?? false
                    let context = exemptSeen ? "Exempt" : ((opensBuilder || !headSeen) ? "Builder" : "Plain")
                    headSeen = false
                    exemptSeen = false
                    blockCount += 1
                    frames.append(Carried(opener: opening, name: "B\(blockCount)",
                                          attribute: scopeName + context + "Tokens",
                                          indent: "            "))
                } else {
                    emit("\(classified.name).self")
                }
                lastType = atom
                continue
            }
            if let closing = atom as? any ClosingAtom.Type {
                if frames.count > 1, let top = frames[frames.count - 1].opener, closing.opensType == top {
                    let frame = frames.removeLast()
                    declarations.append(
                        "    enum \(frame.name): Formation {\n"
                        + writtenBody(frame.text, frame.attribute, "        ")
                        + "    }\n")
                    emit("\(frame.name).self")
                    headSeen = false
                    exemptSeen = false
                } else {
                    emit("\(classified.name).self")
                }
                lastType = atom
                continue
            }

            if atom is any LineSensitive.Type, !headsItsLine {
                emit("Midline<\(classified.name)>.self")
                lastType = atom
                continue
            }
            if atom is any PairSensitive.Type {
                // Adjacency, recorded as a fact: whatever immediately follows (mediums do not
                // count, they split runs, not content) becomes this atom's declared
                // name, carried as ONE fact, `Declares<A, B>`, instead of two separate atoms.
                var paired = nextAtom().0
                while case .known(let pairedAtom) = paired, pairedAtom is any MediumAtom.Type {
                    if (pairedAtom as? any Lexeme.Type).map({ $0.glyph.isNewline }) == true {
                        lineHeaded = true
                    }
                    paired = nextAtom().0
                }
                lineHeaded = false
                emit("Declares<\(classified.name), \(paired.name)>.self")
                lastType = paired.atomType
                continue
            }
            emit("\(classified.name).self" + (wordText.map { "   // \($0)" } ?? ""))
            lastType = atom
        }

        while frames.count > 1 {   // reached by a raw string the reader misreads (grammar-reader-v1)
            let frame = frames.removeLast()
            frames[frames.count - 1].text += frame.text
        }

        let fileName = carrierName(path)
        return "// carried: \(path) [\(scopeName)]\n"
            + "import Alphabet\n"
            + "enum \(fileName): Formation {\n"
            + "    static let verdict = Linter(Self.self)\n"
            + declarations.joined()
            + writtenBody(frames[0].text, "\(scopeName)PlainTokens", "    ")
            + "}\n"
    }

    // Host delivery relation, not a derivation of the source reader's choices.
    // One plan owns destinations for both copied inputs and source carriers.
    struct CarrierFile {
        let source: String
        let path: String
        let bytes: Data
        let carrier: Bool
    }
    struct CarrierFailure: Error, CustomStringConvertible {
        let description: String
        init(_ text: String) { description = text }
    }
    struct CarrierPlan {
        let files: [CarrierFile]
        init(roster: [String], files: [CarrierFile]) throws {
            var origins: [String: String] = [:]
            for file in files {
                let destination = file.path.folding(options: .caseInsensitive, locale: nil)
                if let first = origins[destination] {
                    throw CarrierFailure(file.source + ":1: carrier destination collision at "
                        + file.path + "; also " + first + ":1")
                }
                origins[destination] = file.source
            }
            let carriers = files.filter { $0.carrier }.map { $0.source }
            guard Set(roster).count == roster.count, carriers.count == roster.count,
                  Set(carriers) == Set(roster) else {
                throw CarrierFailure("carrier roster: source paths and carrier files are not one-to-one")
            }
            self.files = files
        }
        func install(at root: URL,
                     write: (Data, URL) throws -> Void = { try $0.write(to: $1, options: .withoutOverwriting) }) throws -> Int {
            for file in files {
                let destination = root.appendingPathComponent(file.path)
                do {
                    try FileManager.default.createDirectory(at: destination.deletingLastPathComponent(),
                                                            withIntermediateDirectories: true)
                    try write(file.bytes, destination)
                } catch {
                    throw CarrierFailure(file.source + ":1: cannot write " + file.path + ": " + String(describing: error))
                }
            }
            return try verify(at: root)
        }
        func verify(at root: URL) throws -> Int {
            var readBack = 0
            for file in files {
                do {
                    let actual = try Data(contentsOf: root.appendingPathComponent(file.path))
                    guard actual == file.bytes else { throw CarrierFailure("written bytes differ") }
                } catch {
                    throw CarrierFailure(file.source + ":1: cannot read back " + file.path + ": " + String(describing: error))
                }
                if file.carrier { readBack += 1 }
            }
            // No extra Swift input may reach the compiler beside the planned files.
            let parents = Set(files.compactMap { file -> String? in
                let parts = file.path.split(separator: "/")
                return parts.count > 2 && parts[0] == "Sources" ? parts.prefix(2).joined(separator: "/") : nil
            })
            for parent in parents.sorted() {
                let names = try Linter.swiftInputs(in: root.appendingPathComponent(parent))
                let expected = Set(files.filter { $0.path.hasPrefix(parent + "/") }
                    .map { String($0.path.dropFirst(parent.count + 1)) })
                guard Set(names) == expected else {
                    throw CarrierFailure(parent + ":1: written Swift inputs differ from the carrier plan")
                }
            }
            return readBack
        }
    }
    static func carrierName(_ path: String) -> String {
        String(path.map { isIdentifierChar($0) ? $0 : "_" })
    }

    static func inputRoster(_ paths: [String]) throws -> [String] {
        var origins: [String: String] = [:]
        for path in paths {
            if let first = origins[path], !first.utf8.elementsEqual(path.utf8) {
                throw CarrierFailure(path + ":1: canonically equal source paths have different UTF-8 bytes; also " + first + ":1")
            }
            origins[path] = path
        }
        return origins.keys.sorted()
    }

    static func swiftInputs(in directory: URL) throws -> [String] {
        let root = directory.standardizedFileURL
        var failure: String?
        guard let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: nil,
            errorHandler: { url, error in
                failure = url.path + ":1: cannot list Swift inputs: " + String(describing: error)
                return false
            }) else { throw CarrierFailure(root.path + ":1: cannot enumerate Swift inputs") }
        let urls = enumerator.compactMap { $0 as? URL }
        if let failure { throw CarrierFailure(failure) }
        var paths: [String] = []
        for url in urls
        where url.path.hasSuffix(".swift") {
            let path = url.standardizedFileURL.path
            guard path.hasPrefix(root.path + "/") else {
                throw CarrierFailure(path + ":1: enumerated Swift input is outside its root")
            }
            paths.append(String(path.dropFirst(root.path.count + 1)))
        }
        return paths.sorted()
    }

    // ── THE CHECK — present the carried formations to the child type checker ──

    static func run(_ args: [String]) {
        // No arguments names the whole gate: every .swift under Sources, the pre-commit run
        // (`swift run Tools grammar`). The child build keeps this off the incremental build;
        // the LawCheck plugin header states the split.
        var paths: [String] = [], mapPath: String?, receiptPath: String?
        var portable = false, exportPath: String?
        var index = 0
        while index < args.count {
            let arg = args[index]
            if ["--scope-map", "--receipt", "--export-policy"].contains(arg) {
                guard index + 1 < args.count else { print("THE GRAMMAR: missing value for " + arg)
                 exit(2) }
                index += 1
                if arg == "--scope-map" { mapPath = args[index] }
                else if arg == "--receipt" { receiptPath = args[index] }
                else { exportPath = args[index] }
            } else if arg == "--portable" { portable = true }
            else if arg.hasPrefix("--") { print("THE GRAMMAR: unknown option " + arg)
             exit(2) }
            else { paths.append(arg) }
            index += 1
        }
        if let output = exportPath {
            do { try GrammarPolicyCensus.data().write(to: URL(fileURLWithPath: output))
             return }
            catch { print("THE GRAMMAR: cannot export policy: \(error)")
             exit(2) }
        }
        let arguments = paths.isEmpty ? ["Sources"] : paths
        let map: GrammarScopeMap
        do {
            if let path = mapPath {
                map = try GrammarScopeMap.read(String(contentsOfFile: path, encoding: .utf8),
                                               scopes: Set(GrammarPolicyCensus.scopes))
            } else { map = defaultMap() }
        } catch { print("THE GRAMMAR: scope map refused: \(error)")
         exit(1) }

        let repoPath = FileManager.default.currentDirectoryPath
        var files: [String] = []
        for argument in arguments {
            let path = NSString(string: argument).isAbsolutePath && argument.hasPrefix(repoPath + "/")
                ? String(argument.dropFirst(repoPath.count + 1)) : argument
            guard GrammarScopeMap.sourcePath(path) else { print("THE GRAMMAR: non-relative source path '\(path)'")
             exit(1) }
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else {
                FileHandle.standardError.write(Data("cannot read \(path)\n".utf8))
                exit(2)
            }
            if isDirectory.boolValue {
                var discoveryFailure: String?
                guard let enumerator = FileManager.default.enumerator(
                    at: URL(fileURLWithPath: path), includingPropertiesForKeys: nil,
                    errorHandler: { url, error in
                        discoveryFailure = url.path + ":1: " + String(describing: error)
                        return false
                    }) else {
                    print("THE GRAMMAR: cannot enumerate source path " + path)
                    exit(2)
                }
                let nested = enumerator.compactMap { $0 as? URL }
                    .filter { $0.path.hasSuffix(".swift") }.map { $0.path }.sorted()
                if let failure = discoveryFailure {
                    print("THE GRAMMAR: cannot enumerate source path " + failure)
                    exit(2)
                }
                for absolute in nested {
                    guard absolute.hasPrefix(repoPath + "/") else {
                        print("THE GRAMMAR: enumerated path is outside source root: " + absolute)
                        exit(2)
                    }
                    files.append(String(absolute.dropFirst(repoPath.count + 1)))
                }
            } else {
                files.append(path)
            }
        }

        do { files = try inputRoster(files) }
        catch {
            print("THE GRAMMAR: " + String(describing: error))
            exit(2)
        }
        var assigned: [String: String] = [:]
        for path in files {
            do { assigned[path] = try map.scope(for: path) }
            catch {
                print("THE GRAMMAR: the mirror does not build: \(path):1: \(error)")
                print(carrierName(path))
                exit(1)
            }
        }
        if let receipt = receiptPath {
            let object: [String: Any] = ["format": "vi-grammar-coverage/1", "scope_map": mapPath ?? "Schema.scopes", "files": assigned, "source_sha256": Dictionary(uniqueKeysWithValues: files.map { ($0, FileManager.default.contents(atPath: $0).map(grammarSHA256) ?? "unread") }), "law": "vi-grammar-policy/1", "policy_sha256": (try? GrammarPolicyCensus.data()).map(grammarSHA256) ?? "unread", "scope_map_sha256": mapPath.flatMap { FileManager.default.contents(atPath: $0) }.map(grammarSHA256) ?? "registry"]
            do { try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys, .prettyPrinted]).write(to: URL(fileURLWithPath: receipt)) }
            catch { print("THE GRAMMAR: cannot write coverage receipt: \(error)")
             exit(2) }
        }
        if portable {
            var refused = false
            for path in files {
                do {
                    let source = try String(contentsOfFile: path, encoding: .utf8)
                    for finding in try GrammarPolicyCensus.policy().findings(source, scope: assigned[path]!, path: path) {
                        print("\(path):\(finding.line): \(finding.atom) is not granted \(finding.scope)/\(finding.context)")
                        refused = true
                    }
                } catch { print("\(error is Judge.SourceLexicalFailure || error is GrammarSpans.Refusal ? "" : path + ":1: ")\(error)")
                 refused = true }
            }
            if refused { print("THE GRAMMAR: the portable mirror refuses")
             exit(1) }
            print("THE GRAMMAR: portable reading holds: \(files.count) file(s); Swift bodies not compiled")
            return
        }

        // The vocabulary, the alphabet and the seed the mirror is judged by are the theory's. Run
        // from the theory they sit under this root; the showcase package runs the same gate from
        // its own root and names the theory checkout in VI_THEORY_PATH. A root that lacks them
        // is refused, never judged with an empty vocabulary.
        let theoryPath = ProcessInfo.processInfo.environment["VI_THEORY_PATH"]
            .map { NSString(string: $0).standardizingPath } ?? repoPath
        let lexiconDir = NSString(string: theoryPath).appendingPathComponent("Sources/GrammarLexicon")
        let alphabetDir = NSString(string: theoryPath).appendingPathComponent("Sources/Alphabet")
        let notationDir = NSString(string: theoryPath).appendingPathComponent("Sources/Notation")
        for required in [lexiconDir, alphabetDir, notationDir, NSString(string: theoryPath).appendingPathComponent("Sources/VerificationIsIdentification")] {
            guard FileManager.default.fileExists(atPath: required) else {
                FileHandle.standardError.write(Data("cannot read \(required): set VI_THEORY_PATH to the theory checkout\n".utf8))
                exit(2)
            }
        }
        let scratch = NSString(string: NSTemporaryDirectory()).appendingPathComponent("grammar-mirror-\(UUID().uuidString)")

        // No package dependency at all: GrammarLexicon itself declares none (pure types), so
        // the vocabulary and schema the mirror is judged by are copied in verbatim as sibling
        // sources, same module as the carried objects. A dependency on the WHOLE repo would
        // make SwiftPM resolve the repo's external dependency (swift-docc-plugin, remote)
        // on every invocation, network-shaped work with nothing to do with the check. Alphabet
        // rides along as its target (Mirror.swift imports it directly, same as the real
        // Package.swift), not flattened into MirrorSource: its atoms are shared with
        // DocumentKit's copy of this same target in the real build.
        let packageManifest = """
        // swift-tools-version: 5.9
        import PackageDescription
        let package = Package(
            name: "Mirror",
            platforms: [.macOS(.v13)],
            targets: [
                .target(name: "Notation", path: "Sources/Notation"),
                .target(name: "VerificationIsIdentification", dependencies: ["Notation"], path: "Sources/VerificationIsIdentification"),
                .target(name: "Alphabet", dependencies: ["Notation"], path: "Sources/Alphabet"),
                .target(name: "MirrorSource", dependencies: ["VerificationIsIdentification", "Alphabet"], path: "Sources/MirrorSource"),
            ]
        )
        """
        let plan: CarrierPlan
        let scratchURL = URL(fileURLWithPath: scratch)
        do {
            var planned = [CarrierFile(source: "mirror manifest", path: "Package.swift",
                                       bytes: Data(packageManifest.utf8), carrier: false)]
            for (source, target) in [
                (lexiconDir, "Sources/MirrorSource"),
                (NSString(string: theoryPath).appendingPathComponent("Sources/VerificationIsIdentification"), "Sources/VerificationIsIdentification"),
                (alphabetDir, "Sources/Alphabet"),
                (notationDir, "Sources/Notation")
            ] {
                let names: [String]
                do { names = try swiftInputs(in: URL(fileURLWithPath: source)) }
                catch { throw CarrierFailure(source + ":1: cannot list copy inputs: " + String(describing: error)) }
                for name in names
                where name.hasSuffix(".swift") {
                    let origin = NSString(string: source).appendingPathComponent(name)
                    do {
                        planned.append(CarrierFile(source: origin, path: target + "/" + name,
                                                   bytes: try Data(contentsOf: URL(fileURLWithPath: origin)), carrier: false))
                    } catch { throw CarrierFailure(origin + ":1: cannot read copy input: " + String(describing: error)) }
                }
            }
            for path in files {
                let content: String
                do { content = try String(contentsOfFile: path, encoding: .utf8) }
                catch { throw CarrierFailure(path + ":1: cannot read source: " + String(describing: error)) }
                planned.append(CarrierFile(source: path, path: "Sources/MirrorSource/" + carrierName(path) + ".swift",
                                           bytes: Data(try carried(content, path: path, scopeName: assigned[path]!).utf8), carrier: true))
            }
            plan = try CarrierPlan(roster: files, files: planned)
            guard !FileManager.default.fileExists(atPath: scratch) else {
                throw CarrierFailure("scratch destination already exists: " + scratch)
            }
            _ = try plan.install(at: scratchURL)
        } catch {
            if error is Judge.SourceLexicalFailure || error is GrammarSpans.Refusal {
                print("THE GRAMMAR: \(error)")
                print("scratch kept at \(scratch)")
                exit(1)
            }
            print("THE GRAMMAR: carrier delivery refused: \(error)")
            print("scratch kept at \(scratch)")
            exit(2)
        }

        // The child build gets a hard deadline and an off-thread pipe reader: a wedged build
        // (or one whose output outgrows the pipe) must not wedge THIS process with it.
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", "build", "--package-path", scratch]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        final class OutputBox {
        var data = Data() }
        let box = OutputBox()
        let drained = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            box.data = pipe.fileHandleForReading.readDataToEndOfFile()
            drained.signal()
        }

        do { try process.run() }
        catch {
            print("THE GRAMMAR: cannot start child build: \(error)")
            print("scratch kept at \(scratch)")
            exit(2)
        }
        // 900s: a wedge-catcher, not a pace-setter. A cold CI runner builds the mirror
        // several times slower than a warm laptop (~40s here, past 240s there), and the
        // deadline exists to catch a hung build, so it stays far above any honest one.
        let deadline = Date().addingTimeInterval(900)
        while process.isRunning, Date() < deadline {
            Thread.sleep(forTimeInterval: 0.1)
        }
        if process.isRunning {
            process.terminate()
            Thread.sleep(forTimeInterval: 1)
            kill(process.processIdentifier, SIGKILL)
            print("THE GRAMMAR: the mirror's build passed its deadline and was killed; scratch kept at \(scratch)")
            exit(3)
        }
        _ = drained.wait(timeout: .now() + 5)
        let output = String(data: box.data, encoding: .utf8) ?? ""

        if process.terminationStatus == 0 {
            let verified: Int
            do { verified = try plan.verify(at: scratchURL) }
            catch {
                print("THE GRAMMAR: carrier delivery refused after build: \(error)")
                print("scratch kept at \(scratch)")
                exit(2)
            }
            print("✓ THE GRAMMAR holds: \(verified) carrier file(s) written and read back; emitted formations build (source reading remains debt).")
            try? FileManager.default.removeItem(atPath: scratch)
        } else {
            print("THE GRAMMAR: the mirror does not build:\n")
            print(output)
            print("scratch kept at \(scratch)")
            exit(1)
        }
    }
}



