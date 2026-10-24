import Foundation

extension WhereJudge {
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
    }
    struct LexicalFailure: Error, CustomStringConvertible {
        let line: Int
        let byte: Int
        let description: String
    }
    struct LexicalReading {
        struct AttributeUse {
            let name: String
            let line: Int
            let byte: Int
        }
        let blanked: String
        let tape: Lexed
        let declared: Set<String>
        let shadowed: Set<String>
        let attributes: [AttributeUse]

        func validateAttributes(lent: Set<String>, scope: LexicalScope) throws {
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
                               lent: Set<String> = [], carrying: Bool = true) throws -> LexicalReading {
        let read = try lexicalScan(source, scope: scope, carrying: carrying)
        try read.validateAttributes(lent: lent, scope: scope)
        return read
    }
    /// Scan each supplied byte string once before discharging attribute uses.
    /// Only declarations from those same readings can lend a builder name.
    /// No caller can submit an unchecked scan as a structural certificate.
    static func lexicalReadings(_ files: [(String, String)], scope: LexicalScope,
                                lent: Set<String> = [], carrying: Bool = true) throws -> [LexicalReading] {
        func addressed<T>(_ origin: String, _ read: () throws -> T) throws -> T {
            do { return try read() }
            catch let error as LexicalFailure {
                throw StructuralSource.AddressedFailure("\(origin):\(error.line): \(error.description) (byte \(error.byte))")
            }
        }
        let scanned = try files.map { origin, text in
            try addressed(origin) { try lexicalScan(text, scope: scope, carrying: carrying) }
        }
        let builders = lent.union(scanned.flatMap { $0.declared })
        for (file, read) in zip(files, scanned) {
            try addressed(file.0) { try read.validateAttributes(lent: builders, scope: scope) }
        }
        return scanned
    }
    private static func lexicalScan(_ source: String, scope: LexicalScope,
                                    carrying: Bool) throws -> LexicalReading {
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
        var kept = String.UnicodeScalarView(), tape = Lexed()
        var stack: [Context] = [.code(start: 0, interpolated: false, parentheses: 0)]
        var index = 0, interpolationCount = 0
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
        func keep(_ width: Int) {
            for offset in 0..<width { kept.append(scalars[index + offset]) }
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
            kept.append("\n")
            if top { emit("\n", index, index + width) }
            index += width
        }
        func name(after offset: Int) -> String {
            var spelled = String.UnicodeScalarView()
            while let next = scalar(offset + spelled.count),
                  next == "_" || ("a"..."z").contains(next) || ("A"..."Z").contains(next)
                      || (!spelled.isEmpty && ("0"..."9").contains(next)) {
                spelled.append(next)
            }
            return String(spelled)
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
                        kept.append("(")
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
                if current == "/", scalar(1) == "/" {
                    if inSingleLineInterpolation() {
                        try refuse("line comment in single-line string interpolation is not a Swift literal", at: index)
                    }
                    while index < scalars.count, !isNewline(scalar(0)) { index += 1 }
                } else if current == "/", scalar(1) == "*" {
                    kept.append(" ")
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
                        let spelled = name(after: 1)
                        if !directives.contains(spelled) {
                            try refuse("the macro '#\(spelled)' is not among the forms this court reads", at: index)
                        }
                        keep(1)
                        if top { emit("#", at, index) }
                    }
                } else if current == "`" {
                    try refuse("a backquoted identifier is not among the forms this court reads", at: index)
                } else if current == "@" {
                    let spelled = name(after: 1)
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
                    keep(1)
                    while let next = scalar(0), next.properties.isAlphabetic || next.properties.numericType != nil
                        || next.properties.generalCategory == .nonspacingMark || next.properties.generalCategory == .spacingMark || next == "_" {
                        keep(1)
                    }
                    if top { emit(spelling(at, index), at, index) }
                } else {
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
        let declared = declaredBuilders(read)
        let shadowed = Set(captures(#"(?<!\.)\bmacro\s+(\w+)"#, read).map { $0[0] })
        return LexicalReading(blanked: read, tape: tape, declared: declared, shadowed: shadowed,
            attributes: unreadAttributes.map { .init(name: $0.name, line: lines[$0.start], byte: offsets[$0.start]) })
    }
}
