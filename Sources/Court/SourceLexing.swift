import Foundation

extension WhereJudge {
    /// Identity of a written name component, without canonical equivalence.
    /// Ownership/context binds that spelling to a declaration's place.
    /// Every name key and reconstructed name comparison uses this relation.
    static func sameName(_ lhs: String, _ rhs: String) -> Bool {
        lhs.unicodeScalars.elementsEqual(rhs.unicodeScalars)
    }
    static func sameName(_ lhs: ScalarName, _ rhs: ScalarName) -> Bool { lhs == rhs }
    static func sameName(_ lhs: ScalarName, _ rhs: String) -> Bool { lhs == ScalarName(rhs) }
    static func sameName(_ lhs: String, _ rhs: ScalarName) -> Bool { ScalarName(lhs) == rhs }
    static func sameNames(_ lhs: [ScalarName], _ rhs: [String]) -> Bool { lhs == rhs.map { ScalarName($0) } }
    static func sameNames(_ lhs: [String], _ rhs: [String]) -> Bool {
        lhs.count == rhs.count && zip(lhs, rhs).allSatisfy { sameName($0, $1) }
    }
    static func sameName(_ lhs: String?, _ rhs: String?) -> Bool {
        switch (lhs, rhs) {
        case let (.some(a), .some(b)): return sameName(a, b)
        case (.none, .none): return true
        default: return false
        }
    }
    static func sameNames(_ lhs: [String]?, _ rhs: [String]?) -> Bool {
        switch (lhs, rhs) {
        case let (.some(a), .some(b)): return sameNames(a, b)
        case (.none, .none): return true
        default: return false
        }
    }
    /// One lexical judgement, with two projections: the notation's blanked
    /// text and the structural reader's addressed tape. Neither projection
    /// scans delimiters again. Admission modes are named in Press's calculus.
    enum LexicalScope { case notation, projection, declarations }
    struct Lexed {
        var words: [String] = []
        var starts: [Int] = []
        var ends: [Int] = []
        var lines: [Int] = []
        var literals: [Int: Range<Int>] = [:]
        var interpolated: Set<Int> = []
        // Code directives are attached to their tape token. In interpolation
        // that is the enclosing literal token; its contents are not rescanned.
        var directives: [Int: [WordOccurrence]] = [:]
    }
    /// Tokens of the notation's blanked projection, in that projection's UTF-16
    /// coordinates. They are emitted while the common lexer keeps code, never
    /// by lexing the blanked string again (interpolation has lost its escape).
    struct NotationToken {
        let spelling: ScalarName
        var range: NSRange
        let word: Bool
    }
    private struct NotationProjection {
        var tokens: [NotationToken] = []
        var pending: [Unicode.Scalar] = []
        var start = 0
        var offset = 0

        mutating func flush() {
            guard !pending.isEmpty else { return }
            tokens.append(NotationToken(spelling: ScalarName(String(String.UnicodeScalarView(pending))),
                range: NSRange(location: start, length: offset - start), word: true))
            pending.removeAll(keepingCapacity: true)
        }
        mutating func append(_ scalar: Unicode.Scalar) {
            // The existing notation's word class: Alphabetic, Mark, Nd, Pc,
            // Join_Control. This is a projection class, not a new admission
            // rule: the common lexical judgement has already classified code.
            let category = scalar.properties.generalCategory
            let word = scalar.properties.isAlphabetic || category == .nonspacingMark
                || category == .spacingMark || category == .enclosingMark
                || category == .decimalNumber || category == .connectorPunctuation
                || scalar.value == 0x200C || scalar.value == 0x200D
            let width = scalar.value > 0xFFFF ? 2 : 1
            if word {
                if pending.isEmpty { start = offset }
                pending.append(scalar)
            } else {
                flush()
                if !scalar.properties.isWhitespace {
                    tokens.append(NotationToken(spelling: ScalarName(String(scalar)),
                        range: NSRange(location: offset, length: width), word: false))
                }
            }
            offset += width
        }
    }
    struct LexicalFailure: Error, CustomStringConvertible {
        let line: Int
        let byte: Int
        let description: String
        func addressed(_ origin: String) -> String {
            description.hasPrefix("distinct scalar spellings") ? description
                : "\(origin):\(line): \(description) (byte \(byte))"
        }
    }
    struct WordOccurrence {
        let spelling: String
        let line: Int
        let byte: Int
    }
    /// Canonical String equivalence is used ONLY for a collision diagnostic.
    /// It does not establish identity or supply keys to the courts' name maps.
    /// Semantic identity is independent of this normalization-based diagnostic.
    struct WordGuard {
        var first: [String: (WordOccurrence, String)] = [:]
        mutating func insert(_ word: WordOccurrence, origin: String) throws {
            if let (prior, path) = first[word.spelling] {
                guard sameName(prior.spelling, word.spelling) else {
                    func shown(_ text: String) -> String {
                        "'" + text + "' [" + text.unicodeScalars.map {
                            "U+" + String($0.value, radix: 16, uppercase: true)
                        }.joined(separator: " ") + "]"
                    }
                    throw LexicalFailure(line: word.line, byte: word.byte,
                        description: "distinct scalar spellings under one String key: " + shown(word.spelling)
                            + " at \(origin):\(word.line) (byte \(word.byte)); first " + shown(prior.spelling)
                            + " at \(path):\(prior.line) (byte \(prior.byte))")
                }
            } else { first[word.spelling] = (word, origin) }
        }
    }
    struct LexicalReading {
        struct AttributeUse {
            let name: String
            let line: Int
            let byte: Int
        }
        let words: [WordOccurrence]
        let blanked: String
        let tape: Lexed
        let notation: [NotationToken]
        let declared: NameSet
        let shadowed: NameSet
        let attributes: [AttributeUse]

        func validateAttributes(lent: NameSet, scope: LexicalScope) throws {
            let borrowed = lent.subtracting(shadowed)
            let undeclared = attributes.filter { !declared.contains($0.name) && !borrowed.contains($0.name) }
            if let use = undeclared.first {
                let suffix = scope == .notation ? "" : " (unsupported attribute)"
                throw LexicalFailure(line: use.line, byte: use.byte,
                    description: "the attribute '@\(use.name)' is not among the forms this court reads" + suffix)
            }
        }
    }
    static func lexicalReading(_ source: String, scope: LexicalScope = .notation,
                               lent: NameSet = [], carrying: Bool = true,
                               notating: Bool = false) throws -> LexicalReading {
        let read = try lexicalScan(source, scope: scope, carrying: carrying, notating: notating)
        try read.validateAttributes(lent: lent, scope: scope)
        return read
    }
    /// Scan each supplied byte string once before discharging attribute uses.
    /// Only declarations from those same readings can lend a builder name.
    /// No caller can submit an unchecked scan as a structural certificate.
    static func lexicalReadings(_ files: [(String, String)], scope: LexicalScope,
                                lent: NameSet = [], carrying: Bool = true, arguments: [(String, String)] = []) throws -> [LexicalReading] {
        try lexicalReadingsResults(files, scope: scope, lent: lent, carrying: carrying, arguments: arguments).map { try $0.get() }
    }
    /// All original inputs are scanned, then uses are checked against that set.
    /// Results only defer failure reporting; they never admit an unchecked tape.
    static func lexicalReadingsResults(_ files: [(String, String)], scope: LexicalScope,
                                       lent: NameSet = [], carrying: Bool = true, arguments: [(String, String)] = []) -> [Result<LexicalReading, Error>] {
        func addressed<T>(_ origin: String, _ read: () throws -> T) throws -> T {
            do { return try read() }
            catch let error as LexicalFailure {
                throw StructuralSource.AddressedFailure(error.addressed(origin))
            }
        }
        let scanned = files.map { origin, text in
            Result { try addressed(origin) { try lexicalScan(text, scope: scope, carrying: carrying, origin: origin) } }
        }
        do {
            var guardWords = WordGuard()
            for (file, result) in zip(files, scanned) {
                if let read = try? result.get() {
                    try addressed(file.0) {
                        for word in read.words { try guardWords.insert(word, origin: file.0) }
                    }
                }
            }
            for (origin, text) in arguments {
                try addressed(origin) {
                    let read = try lexicalScan(text, scope: .declarations, carrying: false, origin: origin)
                    for word in read.words { try guardWords.insert(word, origin: origin) }
                }
            }
        } catch { return files.map { _ in .failure(error) } }
        let builders = lent.union(scanned.flatMap { (try? $0.get().declared) ?? [] })
        return zip(files, scanned).map { file, result in
            Result {
                let read = try result.get()
                try addressed(file.0) { try read.validateAttributes(lent: builders, scope: scope) }
                return read
            }
        }
    }
    static func checkWordSpellings(_ files: [(String, String)], arguments: [(String, String)] = [], names: [(String, String)] = [], locatedNames: [(String, WordOccurrence)] = []) throws {
        var guardWords = WordGuard()
        for (origin, text) in files + arguments {
            let reading: LexicalReading
            do { reading = try lexicalScan(text, scope: .notation, carrying: false, origin: origin) }
            catch let error as LexicalFailure {
                if error.description.hasPrefix("distinct scalar spellings") {
                    throw StructuralSource.AddressedFailure(error.addressed(origin))
                }
                continue // The caller still has to judge this input in its own scope.
            }
            do { for word in reading.words { try guardWords.insert(word, origin: origin) } }
            catch let error as LexicalFailure {
                throw StructuralSource.AddressedFailure(error.addressed(origin))
            }
        }
        // These are already declared name values of the notation-independent
        // context, not Swift text to reinterpret. Preserve their provenance.
        for (address, name) in names {
            let origin = "context " + address + " (name value)"
            do { try guardWords.insert(WordOccurrence(spelling: name, line: 1, byte: 0), origin: origin) }
            catch let error as LexicalFailure { throw StructuralSource.AddressedFailure(error.description) }
        }
        for (origin, word) in locatedNames {
            do { try guardWords.insert(word, origin: origin) }
            catch let error as LexicalFailure { throw StructuralSource.AddressedFailure(error.addressed(origin)) }
        }
    }
    static func declaredBuilders(_ text: String) throws -> NameSet {
        try lexicalScan(text, scope: .notation, carrying: false).declared
    }
    private static func builderNames(_ words: [String]) -> NameSet {
        let ts = words.filter { $0 != "\n" }
        let modifiers: NameSet = ["public", "internal", "fileprivate", "private", "package", "open", "final", "indirect"]
        var names: NameSet = []
        for start in ts.indices {
            guard ts[start] == "@" else { continue }
            guard start + 1 < ts.count, ["resultBuilder", "propertyWrapper"].containsName(ts[start + 1]) else { continue }
            var i = start + 2
            while i < ts.count {
                if modifiers.contains(ts[i]) { i += 1; continue }
                if ts[i] == "@", i + 1 < ts.count {
                    i += 2
                    if i < ts.count, ts[i] == "(" {
                        var depth = 0
                        repeat {
                            if ts[i] == "(" { depth += 1 }
                            if ts[i] == ")" { depth -= 1 }
                            i += 1
                        } while i < ts.count && depth > 0
                    }
                    continue
                }
                break
            }
            if i + 1 < ts.count, ["struct", "enum", "class", "actor"].contains(ts[i]),
               let first = ts[i + 1].unicodeScalars.first, first.properties.isAlphabetic || first == "_" {
                names.insert(ts[i + 1])
            }
        }
        return names
    }
    // Swift swift-6.2.3-RELEASE/lib/Parse/Lexer.cpp:
    // isValidIdentifierContinuationCodePoint / isValidIdentifierStartCodePoint.
    // The candidate alphabet below remains a conservative additional bound.
    private static func swiftIdentifierContinuation(_ scalar: Unicode.Scalar) -> Bool {
        switch scalar.value {
        case 0x24, 0x30...0x39, 0x41...0x5A, 0x5F, 0x61...0x7A,
             0xA8, 0xAA, 0xAD, 0xAF, 0xB2...0xB5, 0xB7...0xBA, 0xBC...0xBE,
             0xC0...0xD6, 0xD8...0xF6, 0xF8...0xFF, 0x100...0x167F,
             0x1681...0x180D, 0x180F...0x1FFF, 0x200B...0x200D, 0x202A...0x202E,
             0x203F...0x2040, 0x2054, 0x2060...0x206F, 0x2070...0x218F,
             0x2460...0x24FF, 0x2776...0x2793, 0x2C00...0x2DFF, 0x2E80...0x2FFF,
             0x3004...0x3007, 0x3021...0x302F, 0x3031...0x303F, 0x3040...0xD7FF,
             0xF900...0xFD3D, 0xFD40...0xFDCF, 0xFDF0...0xFE44, 0xFE47...0xFFF8,
             0x10000...0x1FFFD, 0x20000...0x2FFFD, 0x30000...0x3FFFD,
             0x40000...0x4FFFD, 0x50000...0x5FFFD, 0x60000...0x6FFFD,
             0x70000...0x7FFFD, 0x80000...0x8FFFD, 0x90000...0x9FFFD,
             0xA0000...0xAFFFD, 0xB0000...0xBFFFD, 0xC0000...0xCFFFD,
             0xD0000...0xDFFFD, 0xE0000...0xEFFFD: return true
        default: return false
        }
    }
    private static func swiftIdentifierStart(_ scalar: Unicode.Scalar) -> Bool {
        guard swiftIdentifierContinuation(scalar) else { return false }
        switch scalar.value {
        case 0x24, 0x30...0x39, 0x300...0x36F, 0x1DC0...0x1DFF,
             0x20D0...0x20FF, 0xFE20...0xFE2F: return false
        default: return true
        }
    }
    private static func wordCandidate(_ scalar: Unicode.Scalar) -> Bool {
        scalar.properties.isAlphabetic || scalar.properties.numericType != nil
            || scalar.properties.generalCategory == .nonspacingMark
            || scalar.properties.generalCategory == .spacingMark || scalar == "_"
    }
    private static func lexicalScan(_ source: String, scope: LexicalScope,
                                    carrying: Bool, origin: String = "input",
                                    notating: Bool = false) throws -> LexicalReading {
        enum Context {
            case code(start: Int, interpolated: Bool, parentheses: Int)
            case comment(start: Int, depth: Int)
            case string(start: Int, hashes: Int, quotes: Int, interpolations: Int)
        }
        let scalars = Array(source.unicodeScalars)
        var offsets = [0], lines = [1]
        for (at, c) in scalars.enumerated() {
            offsets.append(offsets.last! + String(c).utf8.count)
            let breakLine = c == "\r" || (c == "\n" && (at == 0 || scalars[at - 1] != "\r"))
            lines.append(lines.last! + (breakLine ? 1 : 0))
        }
        var kept = String.UnicodeScalarView(), tape = Lexed(), notation = NotationProjection()
        var stack: [Context] = [.code(start: 0, interpolated: false, parentheses: 0)]
        var index = 0, interpolationCount = 0
        var words: [WordOccurrence] = [], guardWords = WordGuard()
        var attributeWordEnd: Int?, pendingAttribute: Int?
        var unreadAttributes: [(name: String, start: Int)] = []
        func scalar(_ offset: Int) -> Unicode.Scalar? {
            index + offset < scalars.count ? scalars[index + offset] : nil
        }
        func repeats(_ mark: Unicode.Scalar, from offset: Int, _ count: Int) -> Bool {
            (0..<count).allSatisfy { scalar(offset + $0) == mark }
        }
        func spelling(_ from: Int, _ to: Int) -> String {
            String(String.UnicodeScalarView(scalars[from..<to]))
        }
        func emit(_ word: String, _ from: Int, _ to: Int) {
            tape.words.append(word)
            if carrying {
                tape.starts.append(offsets[from])
                tape.ends.append(offsets[to])
                tape.lines.append(lines[from])
            }
        }
        func append(_ scalar: Unicode.Scalar) {
            kept.append(scalar)
            if notating { notation.append(scalar) }
        }
        func keep(_ width: Int) {
            for offset in 0..<width { append(scalars[index + offset]) }
            index += width
        }
        func isNewline(_ c: Unicode.Scalar?) -> Bool { c == "\r" || c == "\n" }
        func inSingleLineInterpolation() -> Bool {
            for context in stack.reversed() {
                if case let .string(_, _, quotes, _) = context { return quotes == 1 }
            }
            return false
        }
        func newline(top: Bool) throws {
            if inSingleLineInterpolation() {
                try refuse("newline in single-line string interpolation is not a Swift literal", at: index)
            }
            let width = scalar(0) == "\r" && scalar(1) == "\n" ? 2 : 1
            append("\n")
            if top { emit("\n", index, index + width) }
            index += width
        }
        // Attributes, directives, declarations and all other words use this
        // same scalar reader. Never borrow a prefix of an unread identifier.
        func wordEnd(from start: Int) throws -> Int {
            guard start < scalars.count else { try refuse("missing identifier", at: index) }
            let first = scalars[start]
            guard Self.swiftIdentifierStart(first) else {
                try refuse("identifier start " + String(format: "U+%04X", first.value) + " is outside the declared Swift table", at: start)
            }
            guard first.properties.isAlphabetic || first == "_" else {
                try refuse("identifier start " + String(format: "U+%04X", first.value) + " is outside the conservative word alphabet", at: start)
            }
            var end = start + 1
            while end < scalars.count, Self.wordCandidate(scalars[end]) {
                guard Self.swiftIdentifierContinuation(scalars[end]) else {
                    try refuse("identifier continuation " + String(format: "U+%04X", scalars[end].value) + " is outside the declared Swift table", at: end)
                }
                end += 1
            }
            if end < scalars.count, scalars[end] == "$" || (scalars[end].value >= 0x80 && !scalars[end].properties.isWhitespace) {
                try refuse("identifier continuation " + String(format: "U+%04X", scalars[end].value) + " is outside the conservative word alphabet", at: end)
            }
            return end
        }
        func refuse(_ reason: String, at start: Int) throws -> Never {
            throw LexicalFailure(line: lines[start], byte: offsets[start], description: reason)
        }
        while index < scalars.count {
            let current = scalars[index], at = index, top = stack.count == 1
            switch stack[stack.count - 1] {
            case let .comment(start, depth):
                if current == "/", scalar(1) == "*" {
                    stack[stack.count - 1] = .comment(start: start, depth: depth + 1)
                    index += 2
                } else if current == "*", scalar(1) == "/" {
                    if depth == 1 { stack.removeLast() }
                    else { stack[stack.count - 1] = .comment(start: start, depth: depth - 1) }
                    index += 2
                } else if isNewline(current) { try newline(top: stack.count == 2) }
                else { index += 1 }
            case let .string(start, hashes, quotes, before):
                if current == "\\", repeats("#", from: 1, hashes) {
                    let escaped = 1 + hashes
                    if scalar(escaped) == "(" {
                        if hashes > 0 && scope != .notation {
                            try refuse("raw string interpolation is outside structural reader scope", at: index)
                        }
                        interpolationCount += 1
                        append("(")
                        stack.append(.code(start: index, interpolated: true, parentheses: 0))
                        index += escaped + 1
                    } else if isNewline(scalar(escaped)) {
                        if quotes == 1 { try refuse("escaped newline in a single-line string is not a Swift literal", at: index) }
                        index += escaped
                        try newline(top: false)
                    } else { index = min(index + escaped + 1, scalars.count) }
                } else if repeats("\"", from: 0, quotes), repeats("#", from: quotes, hashes) {
                    stack.removeLast()
                    keep(quotes + hashes)
                    if stack.count == 1 {
                        if carrying {
                            tape.literals[tape.words.count] = offsets[start + hashes + quotes]..<offsets[at]
                            if before != interpolationCount { tape.interpolated.insert(tape.words.count) }
                        }
                        emit("@literal", start, index)
                    }
                } else if isNewline(current) {
                    if quotes == 1 {
                        try refuse(hashes > 0 ? "unterminated raw string literal" : "unterminated string literal", at: start)
                    }
                    try newline(top: false)
                } else { index += 1 }
            case let .code(start, interpolated, parentheses):
                if let attribute = pendingAttribute, !current.properties.isWhitespace,
                   !(current == "/" && (scalar(1) == "/" || scalar(1) == "*")) {
                    if current == "." || current == "<" {
                        try refuse("only a single-word attribute name is read; qualified or generic attribute names are unsupported (attribute byte \(offsets[attribute]))", at: index)
                    }
                    pendingAttribute = nil
                }
                if current == "/", scalar(1) == "/" {
                    if inSingleLineInterpolation() {
                        try refuse("line comment in single-line string interpolation is not a Swift literal", at: index)
                    }
                    while index < scalars.count, !isNewline(scalar(0)) { index += 1 }
                } else if current == "/", scalar(1) == "*" {
                    append(" ")
                    stack.append(.comment(start: index, depth: 1))
                    index += 2
                } else if current == "/" {
                    guard let next = scalar(1), next == " " || next == "\t" || isNewline(next) else {
                        try refuse("a slash with no whitespace after it may open a regular expression literal, which this court does not read", at: index)
                    }
                    keep(1)
                    if top { emit("/", at, index) }
                } else if current == "#" || current == "\"" {
                    var hashes = 0
                    while scalar(hashes) == "#" { hashes += 1 }
                    if scalar(hashes) == "\"" {
                        if hashes > 0 && (scope == .projection || (scope != .notation && !top)) {
                            try refuse("raw string literals are outside structural reader scope", at: index)
                        }
                        let quotes = repeats("\"", from: hashes, 3) ? 3 : 1
                        stack.append(.string(start: index, hashes: hashes, quotes: quotes, interpolations: interpolationCount))
                        keep(hashes + quotes)
                    } else if scalar(hashes) == "/" {
                        try refuse("a regular expression literal is not among the forms this court reads", at: index)
                    } else {
                        if scope == .declarations { try refuse("directives are outside strict declaration scope", at: index) }
                        let spelled = try spelling(index + 1, wordEnd(from: index + 1))
                        if !directives.contains(spelled) {
                            try refuse("the macro '#\(spelled)' is not among the forms this court reads", at: index)
                        }
                        tape.directives[tape.words.count, default: []].append(
                            WordOccurrence(spelling: spelled, line: lines[index], byte: offsets[index]))
                        keep(1)
                        if top { emit("#", at, index) }
                    }
                } else if current == "`" {
                    try refuse("a backquoted identifier is not among the forms this court reads", at: index)
                } else if current == "@" {
                    let end = try wordEnd(from: index + 1)
                    attributeWordEnd = end
                    let spelled = spelling(index + 1, end)
                    if !attributes.contains(spelled) { unreadAttributes.append((spelled, index)) }
                    keep(1)
                    if top { emit("@", at, index) }
                } else if isNewline(current) { try newline(top: top) }
                else if interpolated, current == "(" {
                    stack[stack.count - 1] = .code(start: start, interpolated: true, parentheses: parentheses + 1)
                    keep(1)
                } else if interpolated, current == ")" {
                    if parentheses == 0 { stack.removeLast() }
                    else { stack[stack.count - 1] = .code(start: start, interpolated: true, parentheses: parentheses - 1) }
                    keep(1)
                } else if current.properties.isWhitespace {
                    if scope != .notation, ![" ", "\t", "\u{000B}", "\u{000C}", "\u{00A0}"].contains(current) {
                        let code = String(format: "U+%04X", current.value)
                        try refuse("whitespace \(code) is outside structural lexical grammar", at: index)
                    }
                    keep(1)
                }
                else if current.properties.isAlphabetic || current == "_" {
                    let end = try wordEnd(from: index)
                    let word = WordOccurrence(spelling: spelling(at, end), line: lines[at], byte: offsets[at])
                    try guardWords.insert(word, origin: origin)
                    words.append(word)
                    if attributeWordEnd == end {
                        pendingAttribute = at
                        attributeWordEnd = nil
                    }
                    keep(end - index)
                    if top { emit(word.spelling, at, index) }
                } else {
                    if current == "$", let next = scalar(1), next.properties.isAlphabetic || next == "_" {
                        try refuse("identifier start U+0024 is outside the conservative word alphabet", at: index)
                    }
                    if current.value >= 0x80, Self.wordCandidate(current), !Self.swiftIdentifierStart(current) {
                        try refuse("identifier start " + String(format: "U+%04X", current.value) + " is outside the declared Swift table", at: index)
                    }
                    // The structural modes have a closed code-scalar alphabet.
                    // Literal/comment contents were classified above; an unknown
                    // code scalar cannot become trivia in the production reader.
                    let punctuation = "(){}[],:;.=<>+-*%&|^~!?$\\".unicodeScalars
                    if scope != .notation, !("0"..."9").contains(current), !punctuation.contains(current) {
                        let code = String(format: "U+%04X", current.value)
                        try refuse("unread token '\(current)' (\(code)) is outside structural lexical grammar", at: at)
                    }
                    // The legacy notation projection retains its existing
                    // residual-scalar policy; the table names that difference.
                    let width = current == "=" && scalar(1) == "=" ? 2 : 1
                    keep(width)
                    if top { emit(spelling(at, index), at, index) }
                }
            }
        }
        switch stack[stack.count - 1] {
        case let .comment(start, _): try refuse("unterminated block comment", at: start)
        case let .string(start, hashes, _, _):
            try refuse(hashes > 0 ? "unterminated raw string literal" : "unterminated string literal", at: start)
        case let .code(start, interpolated, _):
            if interpolated { try refuse("unterminated string interpolation", at: start) }
        }
        let read = String(kept)
        let declared = builderNames(tape.words)
        let plain = tape.words.filter { $0 != "\n" }
        var shadowed = NameSet()
        for i in plain.indices {
            guard plain[i] == "macro", i + 1 < plain.count,
                  i == 0 || plain[i - 1] != "." else { continue }
            if let first = plain[i + 1].unicodeScalars.first, Self.swiftIdentifierStart(first) {
                shadowed.insert(plain[i + 1])
            }
        }
        notation.flush()
        return LexicalReading(words: words, blanked: read, tape: tape, notation: notation.tokens, declared: declared, shadowed: shadowed,
            attributes: unreadAttributes.map { .init(name: $0.name, line: lines[$0.start], byte: offsets[$0.start]) })
    }
}
