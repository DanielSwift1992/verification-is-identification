import Foundation

/// Reads the declared type-relation fragment. Value/member-function bodies are
/// retained only as balanced regions; they are not claims proved by this reader.
struct StructuralSource {
    typealias Failure = DefinitionReduction.Failure
    struct AddressedFailure: Error, CustomStringConvertible {
        let description: String
        init(_ description: String) { self.description = description }
    }
    struct Requirement: Equatable {
        enum Kind { case equal, member }
        let kind: Kind
        let left: String
        let right: String
    }
    struct Axis {
        let name: String
        let constraints: [Requirement]
        let fallback: String?
    }
    struct Declaration {
        let name: String
        let kind: String
        let parameters: [String]
        let parents: [String]
        let requirements: [Requirement]
        var fields: [String: String]
        var fieldAccess: [String: String] = [:]
        let axes: [Axis]
        let alias: String?
        var unsupported: [String]
        let bodyWitness: Bool
        let origin: String
    }
    var declarations: [String: Declaration] = [:]
    // Preserved for clients which emit declarations into a separate Swift file.
    // This does not change the existing relation/application judgements.
    var access: [String: String] = [:]
    var extensions: [String: [Declaration]] = [:]
    var defaultProviders: [String: [String: String]] = [:]
    var syntax = WhereJudge.World()
    var excludedConditionals = 0
    var conditionalSubjects: Set<String> = []

    struct Address: Codable, Equatable {
        let path: String
        let line: Int
        let start: Int
        let end: Int
        func matches(_ other: Address) -> Bool {
            Data(path.utf8) == Data(other.path.utf8) && line == other.line && start == other.start && end == other.end
        }
    }
    struct Literal: Codable, Equatable {
        let at: Address
        let bytes: String
        let judged: Bool
    }
    struct Lexed {
        var words: [String] = []
        var starts: [Int] = []
        var ends: [Int] = []
        var lines: [Int] = []
        var literals: [Int: Range<Int>] = [:]
        var interpolated: Set<Int> = []
    }
    var addresses: [String: Address] = [:]
    var extensionAddresses: [String: Address] = [:]
    var literals: [String: Literal] = [:]

    struct Token: Codable {
        let word: String
        let bytes: Range<Int>
    }
    static func locatedTokens(_ source: String) throws -> [Token] {
        let read = try scan(source, carrying: true)
        return read.words.indices.map { Token(word: read.words[$0], bytes: read.starts[$0]..<read.ends[$0]) }
    }
    static func tokens(_ source: String) throws -> [String] {
        try scan(source).words
    }

    /// The roster uses the same scanner, retaining original byte coordinates.
    /// Literal contents are carried without evaluating Swift escapes or values.
    static func scan(_ source: String, carrying: Bool = false) throws -> Lexed {
        let chars = Array(carrying ? source : WhereJudge.sourceLines(source))
        var offsets = [0], lines = [1]
        if carrying {
            for c in chars {
                offsets.append(offsets.last! + String(c).utf8.count)
                lines.append(lines.last! + ((c == "\n" || c == "\r\n" || c == "\r") ? 1 : 0))
            }
        }
        func newline(_ c: Character) -> Bool { c == "\n" || (carrying && (c == "\r\n" || c == "\r")) }
        var result = Lexed(), i = 0, interpolationCount = 0
        func emit(_ word: String, from start: Int, to end: Int) {
            result.words.append(word)
            if carrying {
                result.starts.append(offsets[start])
                result.ends.append(offsets[end])
                result.lines.append(lines[start])
            }
        }
        func rawStringBegins() -> Bool {
            guard i < chars.count, chars[i] == "#" else { return false }
            var j = i
            while j < chars.count, chars[j] == "#" { j += 1 }
            return j < chars.count && chars[j] == "\""
        }
        func skipString() throws {
            let triple = i + 2 < chars.count && chars[i + 1] == "\"" && chars[i + 2] == "\""
            i += triple ? 3 : 1
            while i < chars.count {
                if chars[i] == "\\" {
                    if i + 1 < chars.count, chars[i + 1] == "(" {
                        interpolationCount += 1
                        i += 2
                        try skipInterpolation()
                    } else {
                        i += min(2, chars.count - i)
                    }
                    continue
                }
                if chars[i] == "\"",
                    !triple || (i + 2 < chars.count && chars[i + 1] == "\"" && chars[i + 2] == "\"")
                {
                    i += triple ? 3 : 1
                    return
                }
                i += 1
            }
            throw Failure("unterminated string")
        }
        func skipInterpolation() throws {
            var depth = 1
            while i < chars.count {
                if rawStringBegins() {
                    throw Failure("raw string literals are outside structural reader scope")
                }
                if chars[i] == "\"" {
                    try skipString()
                    continue
                }
                if i + 1 < chars.count, chars[i] == "/", chars[i + 1] == "/" {
                    i += 2
                    while i < chars.count, !newline(chars[i]) { i += 1 }
                    continue
                }
                if i + 1 < chars.count, chars[i] == "/", chars[i + 1] == "*" {
                    i += 2
                    var comments = 1
                    while i < chars.count, comments > 0 {
                        if i + 1 < chars.count, chars[i] == "/", chars[i + 1] == "*" {
                            comments += 1
                            i += 2
                        } else if i + 1 < chars.count, chars[i] == "*", chars[i + 1] == "/" {
                            comments -= 1
                            i += 2
                        } else {
                            i += 1
                        }
                    }
                    if comments != 0 { throw Failure("unterminated interpolation comment") }
                    continue
                }
                if chars[i] == "(" { depth += 1 }
                if chars[i] == ")" {
                    depth -= 1
                    if depth == 0 {
                        i += 1
                        return
                    }
                }
                i += 1
            }
            throw Failure("unterminated string interpolation")
        }
        while i < chars.count {
            let c = chars[i]
            if c == "\n" || (carrying && (c == "\r\n" || c == "\r")) {
                emit("\n", from: i, to: i + 1)
                i += 1
                continue
            }
            if c.isWhitespace {
                i += 1
                continue
            }
            if c == "/", i + 1 < chars.count, chars[i + 1] == "/" {
                i += 2
                while i < chars.count, !newline(chars[i]) { i += 1 }
                continue
            }
            if c == "/", i + 1 < chars.count, chars[i + 1] == "*" {
                i += 2
                var depth = 1
                while i < chars.count, depth > 0 {
                    if i + 1 < chars.count, chars[i] == "/", chars[i + 1] == "*" {
                        depth += 1
                        i += 2
                    } else if i + 1 < chars.count, chars[i] == "*", chars[i + 1] == "/" {
                        depth -= 1
                        i += 2
                    } else {
                        if newline(chars[i]) { emit("\n", from: i, to: i + 1) }
                        i += 1
                    }
                }
                if depth != 0 { throw Failure("unterminated block comment") }
                continue
            }
            if rawStringBegins() {
                guard carrying else { throw Failure("raw string literals are outside structural reader scope") }
                let start = i
                while chars[i] == "#" { i += 1 }
                let hashes = i - start
                let quotes = i + 2 < chars.count && chars[i + 1] == "\"" && chars[i + 2] == "\"" ? 3 : 1
                i += quotes
                let content = i
                let closer = Array(String(repeating: "\"", count: quotes) + String(repeating: "#", count: hashes))
                while i + closer.count <= chars.count && Array(chars[i..<(i + closer.count)]) != closer { i += 1 }
                guard i + closer.count <= chars.count else { throw Failure("unterminated raw string literal") }
                result.literals[result.words.count] = offsets[content]..<offsets[i]
                if String(chars[content..<i]).contains("\\" + String(repeating: "#", count: hashes) + "(") {
                    result.interpolated.insert(result.words.count)
                }
                i += closer.count
                emit("@literal", from: start, to: i)
                continue
            }
            if c == "\"" {
                let start = i
                let quotes = i + 2 < chars.count && chars[i + 1] == "\"" && chars[i + 2] == "\"" ? 3 : 1
                let before = interpolationCount
                try skipString()
                if carrying && interpolationCount != before { result.interpolated.insert(result.words.count) }
                if carrying { result.literals[result.words.count] = offsets[start + quotes]..<offsets[i - quotes] }
                emit("@literal", from: start, to: i)
                continue
            }
            if c.isLetter || c == "_" {
                let start = i
                i += 1
                while i < chars.count, chars[i].isLetter || chars[i].isNumber || chars[i] == "_" {
                    i += 1
                }
                emit(String(chars[start..<i]), from: start, to: i)
                continue
            }
            if c == "=", i + 1 < chars.count, chars[i + 1] == "=" {
                emit("==", from: i, to: i + 2)
                i += 2
                continue
            }
            emit(String(c), from: i, to: i + 1)
            i += 1
        }
        return result
    }

    static func plain(_ tokens: [String]) -> [String] { tokens.filter { $0 != "\n" } }
    static func text(_ tokens: [String]) -> String { plain(tokens).joined(separator: " ") }
    static func identifier(_ word: String) -> Bool {
        guard let first = word.first, first.isLetter || first == "_" else { return false }
        return word.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }
    static func split(_ tokens: [String], at separator: String) -> [[String]] {
        var depth = 0, parts: [[String]] = [[]]
        for t in tokens {
            if t == "<" || t == "(" || t == "[" { depth += 1 }
            if t == ">" || t == ")" || t == "]" { depth -= 1 }
            if t == separator, depth == 0 {
                parts.append([])
            } else {
                parts[parts.count - 1].append(t)
            }
        }
        return parts
    }
    static func requirements(_ tokens: [String], unsupported: inout [String]) -> [Requirement] {
        if plain(tokens).isEmpty { return [] }
        var result: [Requirement] = []
        for part in split(plain(tokens), at: ",") {
            if let at = part.firstIndex(of: "=="), !part[(at + 1)...].contains("=="), at > 0,
                at + 1 < part.count
            {
                result.append(
                    Requirement(
                        kind: .equal, left: text(Array(part[..<at])),
                        right: text(Array(part[(at + 1)...]))))
            } else if let at = part.firstIndex(of: ":"), at > 0 {
                let right = split(Array(part[(at + 1)...]), at: "&")
                if right.allSatisfy({ $0.count == 1 && identifier($0[0]) }) {
                    for p in right {
                        result.append(
                            Requirement(kind: .member, left: text(Array(part[..<at])), right: p[0]))
                    }
                } else {
                    unsupported.append(text(part))
                }
            } else {
                unsupported.append(text(part))
            }
        }
        return result
    }

    static func declaration(kind: String, header: [String], body: [String], origin: String) throws
        -> Declaration
    {
        var h = plain(header), errors: [String] = []
        guard !h.isEmpty, identifier(h[0]) else {
            throw Failure("unread declaration header in \(origin)")
        }
        let name = h.removeFirst()
        var params: [String] = [], reqs: [Requirement] = []
        if h.first == "<" {
            var depth = 0, close: Int?
            for (i, t) in h.enumerated() {
                if t == "<" { depth += 1 }
                if t == ">" {
                    depth -= 1
                    if depth == 0 {
                        close = i
                        break
                    }
                }
            }
            guard let end = close else { throw Failure("unclosed parameters on \(name)") }
            for p in split(Array(h[1..<end]), at: ",") {
                guard let parameter = p.first, identifier(parameter) else {
                    throw Failure("unread parameter on \(name)")
                }
                params.append(parameter)
                if p.count > 1 { reqs += requirements(p, unsupported: &errors) }
            }
            h.removeFirst(end + 1)
        }
        if Set(params).count != params.count { errors.append("duplicate generic parameter") }
        var parents: [String] = [], alias: String?
        let whereAt = h.firstIndex(of: "where")
        let prefix = whereAt.map { Array(h[..<$0]) } ?? h
        if let at = whereAt { reqs += requirements(Array(h[(at + 1)...]), unsupported: &errors) }
        if kind == "typealias" {
            if prefix.first == "=" {
                alias = text(Array(prefix.dropFirst()))
            } else {
                errors.append("missing alias body")
            }
        } else if prefix.first == ":" {
            for p in split(Array(prefix.dropFirst()), at: ",") {
                if p.count == 1 && identifier(p[0]) {
                    parents.append(p[0])
                } else {
                    errors.append("unread parent: " + text(p))
                }
            }
        } else if !prefix.isEmpty {
            errors.append("unread header: " + text(prefix))
        }
        var fields: [String: String] = [:], fieldAccess: [String: String] = [:], axes: [Axis] = [],
            bodyWitness = false
        var memberAccess = "internal"
        var i = 0
        while i < body.count {
            if ["public", "internal", "private", "fileprivate", "package", "open"].contains(body[i])
            {
                memberAccess = body[i]
                i += 1
                continue
            }
            if ["let", "var", "func"].contains(body[i]) { memberAccess = "internal" }
            if body[i] == "{" {
                _ = try balanced(body, index: &i, open: "{", close: "}")
                memberAccess = "internal"
                continue
            }
            if body[i] == "#" {
                errors.append("conditional member declarations")
                i += 1
                continue
            }
            if body[i] == "var", i + 1 < body.count, body[i + 1] == "body" { bodyWitness = true }
            if body[i] == "enum" || body[i] == "struct" || body[i] == "class" {
                errors.append("nested type declaration")
            }
            if body[i] == "typealias" {
                i += 1
                let line = statement(body, index: &i)
                let member = try declaration(
                    kind: "typealias", header: line, body: [], origin: origin + "." + name)
                if !member.parameters.isEmpty || !member.requirements.isEmpty
                    || !member.unsupported.isEmpty
                {
                    errors.append("unsupported member alias " + member.name)
                }
                if fields[member.name] != nil { errors.append("duplicate field " + member.name) }
                fields[member.name] = member.alias
                fieldAccess[member.name] = memberAccess
                memberAccess = "internal"
                continue
            }
            if body[i] == "associatedtype" {
                i += 1
                var a = plain(statement(body, index: &i))
                guard !a.isEmpty, identifier(a[0]) else {
                    errors.append("unread associatedtype")
                    continue
                }
                let axis = a.removeFirst()
                var fallback: String?
                if let equal = a.firstIndex(of: "=") {
                    fallback = text(Array(a[(equal + 1)...]))
                    a = Array(a[..<equal])
                }
                var bounds: [Requirement] = []
                if !a.isEmpty { bounds = requirements([axis] + a, unsupported: &errors) }
                axes.append(Axis(name: axis, constraints: bounds, fallback: fallback))
                memberAccess = "internal"
                continue
            }
            i += 1
        }
        return Declaration(
            name: name, kind: kind, parameters: params, parents: parents,
            requirements: reqs, fields: fields, fieldAccess: fieldAccess, axes: axes, alias: alias,
            unsupported: errors, bodyWitness: bodyWitness, origin: origin)
    }

    static func balanced(_ tokens: [String], index: inout Int, open: String, close: String) throws
        -> [String]
    {
        guard index < tokens.count, tokens[index] == open else { throw Failure("expected \(open)") }
        index += 1
        let begin = index
        var depth = 1
        while index < tokens.count {
            if tokens[index] == open { depth += 1 }
            if tokens[index] == close {
                depth -= 1
                if depth == 0 {
                    let value = Array(tokens[begin..<index])
                    index += 1
                    return value
                }
            }
            index += 1
        }
        throw Failure("unclosed \(open)")
    }
    static func statement(_ tokens: [String], index: inout Int) -> [String] {
        let begin = index
        var depth = 0
        while index < tokens.count {
            let t = tokens[index]
            if depth == 0, t == ";" || t == "}" { break }
            if depth == 0, t == "\n" {
                var next = index + 1
                while next < tokens.count, tokens[next] == "\n" { next += 1 }
                let last = plain(Array(tokens[begin..<index])).last
                if next == tokens.count
                    || (tokens[next] != "." && tokens[next] != "where" && last != ","
                        && last != "=")
                {
                    break
                }
            }
            if t == "<" || t == "(" || t == "[" { depth += 1 }
            if t == ">" || t == ")" || t == "]" { depth -= 1 }
            index += 1
        }
        let result = Array(tokens[begin..<index])
        if index < tokens.count, tokens[index] == ";" || tokens[index] == "\n" { index += 1 }
        return result
    }

    struct Region {
        let declaration: Declaration
        let body: [String]
        let tokenRange: Range<Int>
        let headerRange: Range<Int>
    }
    static func readDeclaration(_ ts: [String], index: inout Int, origin: String) throws -> Region {
        let start = index, kind = ts[index]
        index += 1
        let begin = index
        let header: [String], body: [String], headerEnd: Int
        if kind == "typealias" {
            header = statement(ts, index: &index)
            headerEnd = begin + header.count
            body = []
        } else {
            while index < ts.count, ts[index] != "{" { index += 1 }
            headerEnd = index
            header = Array(ts[begin..<index])
            body = try balanced(ts, index: &index, open: "{", close: "}")
        }
        let d = try declaration(kind: kind, header: header, body: body, origin: origin)
        return Region(declaration: d, body: body, tokenRange: start..<index, headerRange: begin..<headerEnd)
    }

    struct ReadingCertificate: Codable {
        struct Unit: Codable {
            let kind: String
            let lower: Int
            let upper: Int
        }
        let tokens: [Token]
        let units: [Unit]
    }
    struct FileReading {
        let tokens: [Token]
        let regions: [Region]
        let certificate: ReadingCertificate
    }
    /// Every non-trivia token is covered by one top-level grammar production.
    /// Value bodies are balanced carried regions, not established relations.
    static func regions(_ source: String, origin: String) throws -> FileReading {
        let located = try locatedTokens(source), ts = located.map(\.word)
        var units: [ReadingCertificate.Unit] = [], i = 0
        while i < ts.count {
            let start = i, kind = ts[i]
            if ["\n", ";", "public", "internal", "private", "fileprivate", "package", "open"].contains(kind) {
                i += 1
            } else if kind == "@" {
                guard i + 1 < ts.count, ts[i + 1] == "resultBuilder" else { throw Failure("unsupported attribute in \(origin)") }
                i += 2
            } else if kind == "import" {
                i += 1
                _ = statement(ts, index: &i)
            } else if ["enum", "struct", "protocol", "extension", "typealias"].contains(kind) {
                _ = try readDeclaration(ts, index: &i, origin: origin)
            } else {
                throw Failure("unread token '\(kind)' at \(origin):byte \(located[i].bytes.lowerBound)")
            }
            units.append(.init(kind: kind, lower: start, upper: i))
        }
        return try replayReading(ReadingCertificate(tokens: located, units: units), source: source, origin: origin)
    }
    /// Grammar judgement on supplied byte spans and production boundaries.
    /// No whole-file declaration search and no printer/round-trip is involved.
    /// Each lexical production is judged on its own raw bytes by the same
    /// lexical grammar; gaps must derive trivia, never an omitted token.
    static func replayReading(_ proof: ReadingCertificate, source: String, origin: String) throws -> FileReading {
        let bytes = Array(source.utf8)
        func slice(_ lower: Int, _ upper: Int) throws -> String {
            guard lower >= 0, upper >= lower, upper <= bytes.count,
                let text = String(bytes: bytes[lower..<upper], encoding: .utf8) else {
                throw Failure("invalid UTF-8 span at \(origin):byte \(lower)")
            }
            return text
        }
        var end = 0
        var previous: Token?
        for token in proof.tokens {
            guard token.bytes.lowerBound >= end, token.bytes.upperBound > token.bytes.lowerBound else { throw Failure("overlapping lexical spans in \(origin)") }
            guard try locatedTokens(slice(end, token.bytes.lowerBound)).isEmpty else { throw Failure("uncovered token at \(origin):byte \(end)") }
            let raw = try slice(token.bytes.lowerBound, token.bytes.upperBound)
            let local = try locatedTokens(raw)
            guard local.count == 1, local[0].word == token.word, local[0].bytes == 0..<raw.utf8.count else {
                throw Failure("invalid lexical production at \(origin):byte \(token.bytes.lowerBound)")
            }
            if let previous {
                let joined = try locatedTokens(slice(previous.bytes.lowerBound, token.bytes.upperBound))
                let offset = previous.bytes.lowerBound
                guard joined.count == 2, joined[0].word == previous.word, joined[1].word == token.word,
                    joined[0].bytes == 0..<(previous.bytes.upperBound - offset),
                    joined[1].bytes == (token.bytes.lowerBound - offset)..<(token.bytes.upperBound - offset) else {
                    throw Failure("non-maximal lexical production at \(origin):byte \(offset)")
                }
            }
            previous = token
            end = token.bytes.upperBound
        }
        guard try locatedTokens(slice(end, bytes.count)).isEmpty else { throw Failure("uncovered token at \(origin):byte \(end)") }
        let ts = proof.tokens.map(\.word)
        var regions: [Region] = [], next = 0
        for unit in proof.units {
            guard unit.lower == next, unit.upper > next, unit.upper <= ts.count, ts[next] == unit.kind else { throw Failure("uncovered or changed grammar production in \(origin)") }
            let part = Array(ts[unit.lower..<unit.upper])
            if ["import", "typealias"].contains(unit.kind), unit.upper < ts.count,
                part.last != "\n", part.last != ";" {
                throw Failure("false statement boundary in \(origin)")
            }
            if ["\n", ";", "public", "internal", "private", "fileprivate", "package", "open"].contains(unit.kind) {
                guard part.count == 1 else { throw Failure("extra tokens in qualifier/separator production") }
                if unit.kind != "\n" && unit.kind != ";" {
                    var following = unit.upper
                    while following < ts.count, ["\n", "public", "internal", "private", "fileprivate", "package", "open"].contains(ts[following]) { following += 1 }
                    guard following < ts.count, ["import", "enum", "struct", "protocol", "extension", "typealias"].contains(ts[following]) else { throw Failure("unattached qualifier in \(origin)") }
                }
            } else if unit.kind == "@" {
                guard part == ["@", "resultBuilder"] else { throw Failure("unsupported attribute in \(origin)") }
                var following = unit.upper
                while following < ts.count, ["\n", "public", "internal", "private", "fileprivate", "package"].contains(ts[following]) { following += 1 }
                guard following < ts.count, ["enum", "struct"].contains(ts[following]) else { throw Failure("unattached resultBuilder attribute in \(origin)") }
            } else if unit.kind == "import" {
                var i = 1
                let path = plain(statement(part, index: &i))
                guard i == part.count, path.count % 2 == 1, path.enumerated().allSatisfy({ $0.offset % 2 == 0 ? identifier($0.element) : $0.element == "." }) else { throw Failure("unsupported import in \(origin)") }
            } else {
                guard ["enum", "struct", "protocol", "extension", "typealias"].contains(unit.kind) else { throw Failure("unknown grammar production in \(origin)") }
                var i = 0
                let region = try readDeclaration(part, index: &i, origin: origin)
                guard i == part.count else { throw Failure("unread declaration suffix in \(origin)") }
                regions.append(Region(declaration: region.declaration, body: region.body,
                    tokenRange: unit.lower..<unit.upper,
                    headerRange: (unit.lower + region.headerRange.lowerBound)..<(unit.lower + region.headerRange.upperBound)))
            }
            next = unit.upper
        }
        guard next == ts.count else { throw Failure("uncovered grammar suffix in \(origin)") }
        return FileReading(tokens: proof.tokens, regions: regions, certificate: proof)
    }

    init(files: [(String, String)], notationFiles: [CourtNotation.File] = [], roster: Bool = false, readings: [FileReading] = []) throws {
        // Already replayed structural readings can feed the same court without
        // a second textual read. Clients cannot inject declarations into a proof:
        // FileReading is constructed by replayReading, not decoded from JSON.
        for reading in readings {
            for region in reading.regions {
                let d = region.declaration
                if d.kind == "extension" { extensions[d.name, default: []].append(d) }
                else {
                    guard declarations[d.name] == nil else { throw Failure("duplicate declaration \(d.name)") }
                    declarations[d.name] = d
                }
            }
        }
        for (origin, source) in files {
            let lexed: Lexed
            do { lexed = try Self.scan(source, carrying: roster) }
            catch {
                if roster { throw AddressedFailure("\(origin):1: \(error)") }
                throw error
            }
            let ts = lexed.words
            var i = 0
            var pendingAccess = "internal"
            while i < ts.count {
                if ["public", "internal", "private", "fileprivate", "package", "open"].contains(
                    ts[i])
                {
                    pendingAccess = ts[i]
                    i += 1
                    continue
                }
                if ["import", "let", "var", "func"].contains(ts[i]) { pendingAccess = "internal" }
                if ts[i] == "#", i + 1 < ts.count, ts[i + 1] == "if" {
                    if roster { throw AddressedFailure("\(origin):\(lexed.lines[i]): conditional declarations are outside roster scope") }
                    excludedConditionals += 1
                    var depth = 1
                    i += 2
                    while i < ts.count, depth > 0 {
                        // A skipped branch may alter a declaration used outside
                        // it. Do not silently choose the branch's absence.
                        if ["enum", "struct", "class", "protocol", "extension", "typealias"]
                            .contains(ts[i]),
                            i + 1 < ts.count, Self.identifier(ts[i + 1])
                        {
                            conditionalSubjects.insert(ts[i + 1])
                        }
                        if ts[i] == "#", i + 1 < ts.count {
                            if ts[i + 1] == "if" { depth += 1 }
                            if ts[i + 1] == "endif" { depth -= 1 }
                        }
                        i += 1
                    }
                    if depth != 0 { throw Failure("unclosed #if in \(origin)") }
                    pendingAccess = "internal"
                    continue
                }
                let kind = ts[i]
                if ["enum", "struct", "protocol", "extension", "typealias"].contains(kind) {
                    let start = i
                    i += 1
                    var header: [String] = [], body: [String] = [], bodyStart = i, bodyEnd = i
                    if kind == "typealias" {
                        header = Self.statement(ts, index: &i)
                    } else {
                        let begin = i
                        while i < ts.count, ts[i] != "{" { i += 1 }
                        header = Array(ts[begin..<i])
                        bodyStart = i + 1
                        body = try Self.balanced(ts, index: &i, open: "{", close: "}")
                    }
                    bodyEnd = max(bodyStart, i - 1)
                    let d = try Self.declaration(
                        kind: kind, header: header, body: body, origin: origin)
                    if roster {
                        let at = Address(path: origin, line: lexed.lines[start], start: lexed.starts[start], end: lexed.ends[max(start, i - 1)])
                        guard d.unsupported.isEmpty else { throw AddressedFailure("\(origin):\(at.line): \(d.name): \(d.unsupported.joined(separator: "; "))") }
                        if kind != "extension" { addresses[d.name] = at }
                        else if extensionAddresses[d.name] == nil { extensionAddresses[d.name] = at }
                        let literal = try Self.rosterLiteral(lexed, body: kind == "typealias" ? bodyStart..<bodyStart : bodyStart..<bodyEnd, source: source, origin: origin)
                        if let literal {
                            guard literals[d.name] == nil else { throw AddressedFailure("\(origin):\(literal.at.line): duplicate typeName on \(d.name)") }
                            literals[d.name] = literal
                        }
                    }
                    if kind == "extension" {
                        extensions[d.name, default: []].append(d)
                    } else {
                        guard declarations[d.name] == nil else {
                            if roster { throw AddressedFailure("\(origin):\(lexed.lines[start]): duplicate declaration \(d.name)") }
                            throw Failure("duplicate declaration \(d.name)")
                        }
                        declarations[d.name] = d
                        access[d.name] = pendingAccess
                    }
                    pendingAccess = "internal"
                } else if roster && ts[i] == "import" {
                    i += 1
                    guard i < ts.count, Self.identifier(ts[i]) else { throw AddressedFailure("\(origin):1: unsupported import") }
                    i += 1
                    guard i == ts.count || ["\n", ";"].contains(ts[i]) else { throw AddressedFailure("\(origin):\(lexed.lines[i]): unsupported import suffix") }
                } else if roster && !["\n", ";"].contains(ts[i]) {
                    throw AddressedFailure("\(origin):\(lexed.lines[i]): '\(ts[i])' is outside roster declaration scope")
                } else if ts[i] == "{" {
                    _ = try Self.balanced(ts, index: &i, open: "{", close: "}")
                    pendingAccess = "internal"
                } else {
                    i += 1
                }
            }
        }
        for file in notationFiles {
            let lent = Set(notationFiles.flatMap { WhereJudge.declaredBuilders($0.world.clean) })
            let clean = try WhereJudge.stripComments(file.text, lent: lent)
            let notation = try NotationScope(clean)
            for declaration in try notation.structural(clean, origin: file.context.input) {
                guard declaration.kind == "enum" || declaration.kind == "struct" || declaration.kind == "protocol" else { continue }
                declarations[declaration.name] = declaration
            }
            syntax.namespaces.formUnion(notation.namespaces)
            syntax.nestedNames.formUnion(notation.nested.values)
        }
        if !notationFiles.isEmpty {
            syntax.contextVersion = 2
            syntax.intrinsicSwift = notationFiles.contains { $0.world.intrinsicSwift }
        }
        // An extension supplies an explicitly named external nominal subject.
        // No physical or runtime interpretation of this external name is inferred.
        for (name, exts) in extensions
        where declarations[name] == nil {
            declarations[name] = Declaration(
                name: name, kind: "external", parameters: [], parents: [],
                requirements: [], fields: [:], fieldAccess: [:], axes: [], alias: nil,
                unsupported: [], bodyWitness: false,
                origin: exts[0].origin)
            if roster { addresses[name] = extensionAddresses[name] }
        }
        for name in conditionalSubjects
        where declarations[name] != nil {
            declarations[name]!.unsupported.append(
                "conditional compilation can alter this declaration")
        }
        try buildSyntax()
    }

    /// Only a direct static typeName literal is a byte carrier. A computed
    /// expression, local declaration or method cannot hide another roster row.
    static func rosterLiteral(_ lexed: Lexed, body: Range<Int>, source: String, origin: String) throws -> Literal? {
        let indices = body.filter { lexed.words[$0] != "\n" }
        let words = indices.map { lexed.words[$0] }
        var result: Literal?
        for n in words.indices {
            if ["func", "init", "subscript", "enum", "struct", "class", "actor", "protocol"].contains(words[n]) {
                throw AddressedFailure("\(origin):\(lexed.lines[indices[n]]): nested declarations/functions are outside roster scope")
            }
            guard ["let", "var"].contains(words[n]) else { continue }
            guard n > 0, words[n - 1] == "static", n + 5 < words.count,
                words[n + 1] == "typeName", words[n + 2] == ":", words[n + 3] == "String"
            else { throw AddressedFailure("\(origin):\(lexed.lines[indices[n]]): only a static typeName byte carrier is supported") }
            if words[n + 4] == "{", words[n + 5] == "get", n + 6 < words.count, words[n + 6] == "}" { continue }
            let value = n + 5
            guard (words[n + 4] == "{" && n + 6 < words.count && words[n + 6] == "}") || words[n + 4] == "=",
                let range = lexed.literals[indices[value]], !lexed.interpolated.contains(indices[value]), result == nil,
                words[n + 4] != "=" || value + 1 == words.count || lexed.words[(indices[value] + 1)..<indices[value + 1]].contains("\n") || words[value + 1] == ";"
            else { throw AddressedFailure("\(origin):\(lexed.lines[indices[n]]): typeName must be one direct literal, not a computed value") }
            let bytes = Array(source.utf8)
            result = Literal(at: Address(path: origin, line: lexed.lines[indices[value]], start: range.lowerBound, end: range.upperBound),
                bytes: Data(bytes[range]).base64EncodedString(), judged: false)
        }
        return result
    }

    func protocolClosure(_ names: [String]) -> Set<String> {
        var seen: Set<String> = [], work = names
        while let p = work.popLast() {
            if seen.insert(p).inserted { work += declarations[p]?.parents ?? [] }
        }
        return seen
    }
    func conformanceChoices(_ name: String) -> [(String, [Requirement])] {
        guard let d = declarations[name] else { return [] }
        var result = d.parents.map { ($0, [Requirement]()) }
        for e in extensions[name] ?? [] {
            result += e.parents.map { ($0, e.requirements) }
        }
        return result
    }
    mutating func buildSyntax() throws {
        for name in declarations.keys.sorted() {
            var d = declarations[name]!
            if d.kind == "protocol" {
                syntax.protocolParents[name] = d.parents
                syntax.protocolAxes[name] = Set(d.axes.map(\.name))
                continue
            }
            if d.kind == "typealias" {
                if let body = d.alias {
                    syntax.aliases[name] = WhereJudge.AliasRule(
                        parameters: d.parameters, body: body)
                }
                continue
            }
            var fields = d.fields
            var bodyWitness = d.bodyWitness
            var conditionalAxes: Set<String> = []
            for e in extensions[name] ?? []
            where !e.requirements.isEmpty && !e.fields.isEmpty {
                conditionalAxes.formUnion(e.fields.keys)
            }
            for e in extensions[name] ?? []
            where e.requirements.isEmpty {
                bodyWitness = bodyWitness || e.bodyWitness
                if !e.fields.isEmpty { d.unsupported += e.unsupported }
                for (axis, value) in e.fields {
                    if fields[axis] != nil { d.unsupported.append("duplicate field \(axis)") }
                    fields[axis] = value
                }
            }
            let parents = conformanceChoices(name).map { $0.0 }
            for axis in conditionalAxes { fields.removeValue(forKey: axis) }
            var defaults: [String: (String, String)] = [:]
            for p in protocolClosure(parents).sorted() {
                for axis in declarations[p]?.axes ?? [] {
                    guard let value = axis.fallback, fields[axis.name] == nil,
                        !conditionalAxes.contains(axis.name)
                    else { continue }
                    if axis.name == "Body", bodyWitness { continue }
                    if let old = defaults[axis.name], old.1 != value {
                        d.unsupported.append("ambiguous default \(axis.name)")
                    }
                    defaults[axis.name] = (p, value)
                }
            }
            for (axis, (p, value)) in defaults {
                fields[axis] = value
                defaultProviders[name, default: [:]][axis] = p
            }
            declarations[name] = d
            syntax.parameters[name] = d.parameters
            syntax.conformers[name] = WhereJudge.Conformer(
                name: name, parameters: d.parameters, protocols: parents, table: fields)
            syntax.presentedBodies.insert(name)
        }
    }
}
