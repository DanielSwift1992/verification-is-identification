import Alphabet
import Foundation
import GrammarLexicon
import VerificationIsIdentification

// ═══════════════════════════════════════════════════════
// LINTER names the world door, and the only runtime the grammar has. Two contacts, nothing else:
// reading strings in (files → the carried representation, one object per file, written the way
// this project writes every generated .swift) and the final check (one `swift build` over the
// disposable package). The source is not treated as code, it is a token stream, carried IN
// STREAM ORDER: an opener becomes `SomeBlock {`, an atom becomes `SomeAtom.self`, a closer
// becomes `}`. Nothing is assembled, reordered, or judged here; every question below is a
// protocol question or a registry lookup, and every atom name written became text through
// `typeName` of the metatype the registry handed over. What the carried object MEANS is
// decided entirely by the schema (GrammarLexicon/Mirror.swift) inside the child build:
// a compiler error there is REJECT(where, why); the build fact is PASS. [V=I §1]
//
// MEASURABLE (not disciplinary): grep this file, no character/string literal spells a lexeme,
// no identifier names a single concrete atom the lexicon declares, no line:column address is
// ever computed or embedded as a name (the v4 lesson: `lineHeaded` tracks only a BOUNDARY fact,
// "did a newline (or a foreign span closing on one) just pass", not a number). Add a brand-new
// atom or spelling to a registry: this file carries it with no edit here.
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

    /// This names the text belonging to any KNOWN atom, read off whichever of the two lexeme
    /// protocols it conforms to. Used only to recognize a `ForeignOpener`'s `Closer` (and, during
    /// that same opaque run, an `Escapes` atom) in the raw stream.
    private static func text(of atom: any LintAtom.Type) -> String {
        if let lexeme = atom as? any Lexeme.Type { return String(lexeme.glyph) }
        if let spelled = atom as? any Spelled.Type { return spelled.spelling }
        return ""
    }

    /// This reads longest prefix first: the same maximal-munch policy the spellings get, now
    /// over `Schema.scopes`, so a nested directory does not lose to a shorter enclosing one.
    private static let scopesByLength: [(prefix: String, scope: any LintAtom.Type)] = {
        Schema.scopes.sorted { $0.prefix.count > $1.prefix.count }
    }()

    /// This names the file's scope: a mechanical fact about ITS PATH (repo-root-relative, the
    /// same convention `Schema.scopes` and Census.swift's targets use), not a decision this file
    /// makes about what a directory MEANS: absent from the registry means the file carries a
    /// scope name no block type in the schema answers to.
    private static func scope(for path: String) -> any LintAtom.Type {
        for entry in scopesByLength
        where path.hasPrefix(entry.prefix) {
            return entry.scope
        }
        return Alphabet.defaultWord
    }

    private static func isIdentifierChar(_ c: Character) -> Bool { c.isLetter || c.isNumber || c == "_" }

    /// This reads in. One pass over one file, emitting as it reads. Which block type an opener
    /// becomes is two mechanical facts: the file's scope and whether the atom just before it
    /// grants `OpensBuilder`, and only an `AlwaysPairs` opener becomes a block at all.
    /// Everything else is the cursor's machinery: word runs, foreign spans, one balanced
    /// sub-run when an escape meets an opener inside a span.
    static func carried(_ content: String, path: String, scopeName: String) -> String {
        let chars = Array(content)
        var i = 0
        var lastType: (any LintAtom.Type)? = Alphabet.defaultWord   // the file's start
        var headSeen = true   // the file's start heads a plain sentence
        var lineHeaded = true   // and heads its line
        var exemptSeen = false   // this sentence named the exempt door (DESIGN17 §2)

        /// This is one open block being carried: its pairing opener, the name its parent will
        /// reference it by, the builder attribute its scope×context names, and its body
        /// text as accumulated so far. Navigation, not duplication (Formation's doc): a
        /// closed block leaves as a SMALL DECLARATION and its parent keeps one reference line,
        /// the emitted package never holds a nested expression, so the child compiler's
        /// work stays linear in the source. `blockCount` is the one number in this file: a
        /// reference needs a name, a name needs a counter.
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

        /// This gives one classified atom at the current position, consuming as many characters
        /// as it spans: the WORD path (accumulate the whole identifier run, THEN look up the run)
        /// or the SPELLING/GLYPH path (longest match first). A general word also hands back its
        /// text: decoration for the emitted line, so a refusal reads like the source.
        func nextAtom() -> (Classified, wordText: String?) {
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

        /// This names a `ForeignOpener` glyph or spelling at the current position: the question
        /// a raw span asks about its inside when an escape suspends it.
        func foreignOpenerHere() -> (any ForeignOpener.Type)? {
            for spelled in punctuationSpellings {
                guard let opener = spelled as? any ForeignOpener.Type else { continue }
                let n = spelled.spelling.count
                guard i + n <= chars.count else { continue }
                if String(chars[i..<(i + n)]) == spelled.spelling {
                    advance(n)
                    return opener
                }
            }
            if let opener = glyphTable[chars[i]] as? any ForeignOpener.Type {
                advance(1)
                return opener
            }
            return nil
        }

        /// This is one balanced bracket run consumed raw: what an escape followed by an
        /// `OpeningAtom` means inside a foreign span (interpolation, stated atom-generically).
        /// Foreign spans inside it fold shut recursively, so a quote in there does not end the
        /// outer span.
        func consumeBalanced(_ opener: any OpeningAtom.Type) {
            var open = 0
            while i < chars.count {
                if let foreign = foreignOpenerHere() {
                    consumeForeignSpan(closer: foreign.closerType)
                    continue
                }
                if let lexeme = glyphTable[chars[i]] {
                    if let opening = lexeme as? any OpeningAtom.Type, opening == opener {
                        open += 1
                        advance(1)
                        continue
                    }
                    if let closing = lexeme as? any ClosingAtom.Type, closing.opensType == opener {
                        open -= 1
                        advance(1)
                        if open == 0 { return }
                        continue
                    }
                }
                advance(1)
            }
        }

        /// This gives raw consumption for a `ForeignOpener`'s span: no classification inside it,
        /// only the generic questions any opener asks: "does `closerText` start here" (ends
        /// the span, closer consumed too), "is the atom right here an `Escapes` atom" (skip it
        /// and whatever follows, or, when what follows OPENS, one balanced run).
        func consumeForeignSpan(closer: any LintAtom.Type) {
            let closerText = text(of: closer)
            while i < chars.count {
                if !closerText.isEmpty, i + closerText.count <= chars.count,
                   String(chars[i..<(i + closerText.count)]) == closerText {
                    advance(closerText.count)
                    return
                }
                if let lexeme = glyphTable[chars[i]], lexeme is any Escapes.Type {
                    advance(1)
                    guard i < chars.count else { return }
                    if let opening = glyphTable[chars[i]] as? any OpeningAtom.Type {
                        consumeBalanced(opening)
                    } else {
                        advance(1)
                    }
                    continue
                }
                advance(1)
            }
        }

        while i < chars.count {
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
            if let opener = atom as? any ForeignOpener.Type {
                consumeForeignSpan(closer: opener.closerType)
                emit("\(classified.name).self")
                lastType = atom
                if (opener.closerType as? any Lexeme.Type).map({ $0.glyph.isNewline }) == true {
                    lineHeaded = true   // the span closed AT a newline, the next atom heads its line
                }
                continue
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
                        + "        @\(frame.attribute) static var body: Never.Type {\n"
                        + frame.text
                        + "        }\n"
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

        while frames.count > 1 {   // cannot happen for source that itself compiles
            let frame = frames.removeLast()
            frames[frames.count - 1].text += frame.text
        }

        let fileName = String(path.map { isIdentifierChar($0) ? $0 : "_" })
        return "// carried: \(path) [\(scopeName)]\n"
            + "import Alphabet\n"
            + "enum \(fileName): Formation {\n"
            + "    static let verdict = Linter(Self.self)\n"
            + declarations.joined()
            + "    @\(scopeName)PlainTokens static var body: Never.Type {\n"
            + frames[0].text
            + "    }\n"
            + "}\n"
    }

    // ── THE CHECK — the second and last world contact ──

    static func run(_ args: [String]) {
        // No arguments names the whole gate: every .swift under Sources, the pre-commit run
        // (`swift run Tools grammar`). The child build keeps this off the incremental build;
        // the LawCheck plugin header states the split.
        let arguments = args.isEmpty ? ["Sources"] : args

        let repoPath = FileManager.default.currentDirectoryPath
        var files: [String] = []
        for argument in arguments {
            let path = NSString(string: argument).isAbsolutePath ? String(argument.dropFirst(repoPath.count + 1)) : argument
            var isDirectory: ObjCBool = false
            guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else {
                FileHandle.standardError.write(Data("cannot read \(path)\n".utf8))
                exit(2)
            }
            if isDirectory.boolValue {
                let nested = (FileManager.default.enumerator(atPath: path)?.compactMap { $0 as? String } ?? [])
                    .filter { $0.hasSuffix(".swift") }
                    .sorted()
                files.append(contentsOf: nested.map { NSString(string: path).appendingPathComponent($0) })
            } else {
                files.append(path)
            }
        }

        let lexiconDir = NSString(string: repoPath).appendingPathComponent("Sources/GrammarLexicon")
        let alphabetDir = NSString(string: repoPath).appendingPathComponent("Sources/Alphabet")
        let scratch = NSString(string: NSTemporaryDirectory()).appendingPathComponent("grammar-mirror")
        let sourcesDir = NSString(string: scratch).appendingPathComponent("Sources/MirrorSource")
        try? FileManager.default.removeItem(atPath: scratch)
        try? FileManager.default.createDirectory(atPath: sourcesDir, withIntermediateDirectories: true)

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
                .target(name: "VerificationIsIdentification", path: "Sources/VerificationIsIdentification"),
                .target(name: "Alphabet", dependencies: ["VerificationIsIdentification"], path: "Sources/Alphabet"),
                .target(name: "MirrorSource", dependencies: ["VerificationIsIdentification", "Alphabet"], path: "Sources/MirrorSource"),
            ]
        )
        """
        try? packageManifest.write(toFile: NSString(string: scratch).appendingPathComponent("Package.swift"),
                                   atomically: true, encoding: .utf8)

        let lexiconFiles = (try? FileManager.default.contentsOfDirectory(atPath: lexiconDir)) ?? []
        for file in lexiconFiles
        where file.hasSuffix(".swift") {
            try? FileManager.default.copyItem(atPath: NSString(string: lexiconDir).appendingPathComponent(file),
                                              toPath: NSString(string: sourcesDir).appendingPathComponent(file))
        }

        // The lattice rides along as the real module it is: the vocabulary's atoms are
        // `Close`, its fold floor is `Never`, and the certificate beside them
        // (GrammarLexicon/Certificate.swift) conforms the lattice's instance protocols,
        // so every run of the check re-certifies the checker in the same build that carries
        // the verdict. Copied verbatim (the lattice imports nothing), not re-declared.
        let seedSource = NSString(string: repoPath).appendingPathComponent("Sources/VerificationIsIdentification")
        let seedDir = NSString(string: scratch).appendingPathComponent("Sources/VerificationIsIdentification")
        try? FileManager.default.createDirectory(atPath: seedDir, withIntermediateDirectories: true)
        let seedFiles = (try? FileManager.default.contentsOfDirectory(atPath: seedSource)) ?? []
        for file in seedFiles
        where file.hasSuffix(".swift") {
            try? FileManager.default.copyItem(atPath: NSString(string: seedSource).appendingPathComponent(file),
                                              toPath: NSString(string: seedDir).appendingPathComponent(file))
        }

        let alphabetScratchDir = NSString(string: scratch).appendingPathComponent("Sources/Alphabet")
        try? FileManager.default.createDirectory(atPath: alphabetScratchDir, withIntermediateDirectories: true)
        let alphabetFiles = (try? FileManager.default.contentsOfDirectory(atPath: alphabetDir)) ?? []
        for file in alphabetFiles
        where file.hasSuffix(".swift") {
            try? FileManager.default.copyItem(atPath: NSString(string: alphabetDir).appendingPathComponent(file),
                                              toPath: NSString(string: alphabetScratchDir).appendingPathComponent(file))
        }

        for path in files {
            guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
                FileHandle.standardError.write(Data("cannot read \(path)\n".utf8))
                exit(2)
            }
            let scopeName = String(describing: scope(for: path))
            let fileName = String(path.map { isIdentifierChar($0) ? $0 : "_" })
            try? carried(content, path: path, scopeName: scopeName)
                .write(toFile: NSString(string: sourcesDir).appendingPathComponent(fileName + ".swift"),
                       atomically: true, encoding: .utf8)
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

        try? process.run()
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
            print("✓ THE GRAMMAR holds: \(files.count) file(s) carried, and every verdict object builds.")
            try? FileManager.default.removeItem(atPath: scratch)
        } else {
            print("THE GRAMMAR: the mirror does not build:\n")
            print(output)
            print("scratch kept at \(scratch)")
            exit(1)
        }
    }
}



