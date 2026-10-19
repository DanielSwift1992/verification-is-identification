// WHERE JUDGE — the second judge learns the conditional grammar. A world file
// states enums with typealias tables, top-level and generic typealiases,
// extensions gated by `where` equalities, and protocols gated the same way. A
// parameterless typealias whose right side names a gated head is a certificate,
// judged like a use, and extra definition files lend their typealiases so a
// name's meaning is its one written definition wherever that definition is.
// This judge reads a fragment of those statements and normalizes its terms —
// aliases unfolded, generic parameters substituted, dotted axes resolved
// through the conformer's own table — and then judges each use of a gated
// head and each conformer of a gated protocol. A rewrite comes from the
// supplied definitions. Names such as Plus, Times and Twice have no built-in
// equations here. Equal readings of two types (including their counts) do not
// establish type identity or license substitution in arbitrary contexts.
// Each successful normalization constructs and replays a DefinitionReduction
// derivation against the read source. Distinct resulting forms mean this court
// has not established the required equality, not a proof of general inequality.
// Declaration reading, generic applicability and membership remain separate
// obligations; this is not a complete Swift checker. Other ports do not acquire
// these properties by sharing the same canon version label.

import Foundation

enum WhereJudge {
    typealias Term = Press.Term

    /// Identifies the normalization rules, not evidence that a separate port
    /// implements them. Version four replays source-defined reduction derivations.
    static let canonVersion = 4

    struct Conformer {
        let name: String
        let parameters: [String]
        var protocols: [String]
        var table: [String: String]
    }

    struct AliasRule {
        let parameters: [String]
        let body: String
    }

    struct GatedExtension {
        let head: String
        let proto: String
        let equalities: [(String, String)]
        let memberships: [(String, String)]
        let unjudged: [String]
    }

    struct GatedProtocol {
        let name: String
        let equalities: [(String, String)]
        let memberships: [(String, String)]
        let unjudged: [String]
    }

    /// Internal failures are data. Only the legacy CLI boundary writes to
    /// stderr and exits; callers can distinguish unread syntax from unavailable
    /// input without interpreting diagnostic text or a process exit status.
    enum Failure: Error {
        case unsupported([String])
        case input([String])
        case open([String])

        var messages: [String] {
            switch self {
            case let .unsupported(messages), let .input(messages), let .open(messages): return messages
            }
        }
    }

    static func fail(_ message: String) throws -> Never {
        throw Failure.unsupported([message])
    }

    static func failAll(_ messages: [String]) throws -> Never {
        throw Failure.unsupported(messages)
    }

    // ── reading the world ──

    // A comment states nothing, and a string states no declaration. Before
    // any line is read, comments and the contents of string literals are
    // blanked by one scan that knows Swift's lexical forms: a line comment
    // runs to its line's end, a block comment nests, and a string is plain,
    // multiline (`"""`) or raw (`#"…"#`, any number of `#`), with escapes and
    // interpolations `\(…)` whose code is read as code. So comment markers in
    // a string open nothing, a quote in a comment opens nothing, and a
    // declaration spelled inside either is no premise. A block comment reads
    // as a space, a string keeps its delimiters, and both keep their line
    // breaks, so the lines below stay the source's lines.
    //
    // What the scan does not recognise is refused, never read as code: a
    // regular expression literal `#/…/#`; a slash in code that opens no comment
    // and has no whitespace after it, since a bare `/…/` literal opens with
    // exactly such a slash (it may not start with a space or a tab, and `//`
    // and `/*` are always comments), so the literal is refused before its text
    // can be read, and a division written without a space after its slash is
    // refused with it; a backquoted identifier; and a macro or directive
    // outside the built-in ones. An attribute outside the built-in ones reads
    // only when the same text puts `@resultBuilder` or `@propertyWrapper` on a
    // struct, enum, class or actor of that name, with other attributes and
    // modifiers allowed between them; any other, an attached macro above all,
    // can add a conformance this court never sees, and is refused at its first
    // use. Each is a reader failure that names its line, as is an unterminated
    // comment, string or interpolation.
    static let directives: Set<String> = [
        "if", "elseif", "else", "endif", "sourceLocation", "warning", "error",
        "available", "unavailable", "selector", "keyPath", "file", "fileID",
        "filePath", "line", "column", "function", "dsohandle", "isolation",
        "colorLiteral", "imageLiteral", "fileLiteral",
    ]
    static let attributes: Set<String> = [
        "available", "frozen", "inlinable", "usableFromInline", "discardableResult",
        "inline", "retroactive", "preconcurrency", "unchecked", "escaping",
        "autoclosure", "Sendable", "MainActor", "objc", "nonobjc", "testable", "main",
        "unknown", "convention", "propertyWrapper", "resultBuilder",
        "dynamicMemberLookup", "dynamicCallable", "warn_unqualified_access",
        "_disfavoredOverload", "_exported", "_implementationOnly", "_spi",
        "_alwaysEmitIntoClient", "_transparent",
    ]

    static func blankCommentsAndStrings(_ text: String, lent: Set<String> = []) throws -> String {
        enum Context {
            case code(interpolated: Bool, parentheses: Int)
            case comment(depth: Int)
            case string(hashes: Int, multiline: Bool)
        }
        let scalars = Array(text.unicodeScalars)
        var kept = String.UnicodeScalarView()
        var stack: [Context] = [.code(interpolated: false, parentheses: 0)]
        var index = 0
        var line = 1
        var unreadAttributes: [(name: String, line: Int)] = []
        func scalar(_ offset: Int) -> Unicode.Scalar? {
            index + offset < scalars.count ? scalars[index + offset] : nil
        }
        func repeats(_ mark: Unicode.Scalar, from offset: Int, _ count: Int) -> Bool {
            (0..<count).allSatisfy { scalar(offset + $0) == mark }
        }
        func keep(_ width: Int) {
            for offset in 0..<width { kept.append(scalars[index + offset]) }
            index += width
        }
        func newline() {
            kept.append("\n")
            line += 1
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
        func refuse(_ reason: String) throws -> Never {
            try fail("cannot read line \(line): \(reason)")
        }
        while index < scalars.count {
            let current = scalars[index]
            switch stack[stack.count - 1] {
            case let .comment(depth):
                if current == "/", scalar(1) == "*" {
                    stack[stack.count - 1] = .comment(depth: depth + 1)
                    index += 2
                } else if current == "*", scalar(1) == "/" {
                    if depth == 1 {
                        stack.removeLast()
                    } else {
                        stack[stack.count - 1] = .comment(depth: depth - 1)
                    }
                    index += 2
                } else {
                    if current == "\n" { newline() }
                    index += 1
                }
            case let .string(hashes, multiline):
                let quotes = multiline ? 3 : 1
                if current == "\\", repeats("#", from: 1, hashes) {
                    // an escape, or an interpolation whose code is read as code
                    if scalar(1 + hashes) == "(" {
                        kept.append("(")
                        stack.append(.code(interpolated: true, parentheses: 0))
                    } else if scalar(1 + hashes) == "\n" {
                        newline()
                    }
                    index += 2 + hashes
                } else if repeats("\"", from: 0, quotes), repeats("#", from: quotes, hashes) {
                    stack.removeLast()
                    keep(quotes + hashes)
                } else if current == "\n", !multiline {
                    try fail("unterminated string literal")
                } else {
                    if current == "\n" { newline() }
                    index += 1
                }
            case let .code(interpolated, parentheses):
                if current == "/", scalar(1) == "/" {
                    while index < scalars.count, scalars[index] != "\n" { index += 1 }
                } else if current == "/", scalar(1) == "*" {
                    kept.append(" ")
                    stack.append(.comment(depth: 1))
                    index += 2
                } else if current == "/" {
                    if let next = scalar(1), next == " " || next == "\t" || next == "\n" || next == "\r" {
                        keep(1)
                    } else {
                        try refuse("a slash with no whitespace after it may open a regular "
                            + "expression literal, which this court does not read")
                    }
                } else if current == "#" || current == "\"" {
                    var hashes = 0
                    while scalar(hashes) == "#" { hashes += 1 }
                    if scalar(hashes) == "\"" {
                        let multiline = repeats("\"", from: hashes, 3)
                        stack.append(.string(hashes: hashes, multiline: multiline))
                        keep(hashes + (multiline ? 3 : 1))
                    } else if scalar(hashes) == "/" {
                        try refuse("a regular expression literal is not among the forms this court reads")
                    } else {
                        let spelled = name(after: 1)
                        if !directives.contains(spelled) {
                            try refuse("the macro '#\(spelled)' is not among the forms this court reads")
                        }
                        keep(1)
                    }
                } else if current == "@" {
                    let spelled = name(after: 1)
                    if !attributes.contains(spelled) { unreadAttributes.append((spelled, line)) }
                    keep(1)
                } else if current == "`" {
                    try refuse("a backquoted identifier is not among the forms this court reads")
                } else if current == "\n" {
                    newline()
                    index += 1
                } else if interpolated, current == "(" {
                    stack[stack.count - 1] = .code(interpolated: true, parentheses: parentheses + 1)
                    keep(1)
                } else if interpolated, current == ")" {
                    if parentheses == 0 {
                        stack.removeLast()
                    } else {
                        stack[stack.count - 1] = .code(interpolated: true, parentheses: parentheses - 1)
                    }
                    keep(1)
                } else {
                    keep(1)
                }
            }
        }
        switch stack[stack.count - 1] {
        case .comment: try fail("unterminated block comment")
        case .string: try fail("unterminated string literal")
        case let .code(interpolated, _):
            if interpolated { try fail("unterminated string interpolation") }
        }
        let read = String(kept)
        let declared = declaredBuilders(read)
        let undeclared = unreadAttributes.filter { !declared.contains($0.name) && !lent.contains($0.name) }
        if let use = undeclared.first {
            try fail("cannot read line \(use.line): the attribute '@\(use.name)' "
                + "is not among the forms this court reads")
        }
        return read
    }

    // The names a read text declares as a result builder or a property
    // wrapper, with other attributes and modifiers allowed between the
    // declaring attribute and the type. An attribute of such a name adds no
    // conformance, so it is a form this court reads, in the text that
    // declares it and in a world that text is lent to.
    static func declaredBuilders(_ read: String) -> Set<String> {
        Set(captures(
            #"@(?:resultBuilder|propertyWrapper)\s+(?:(?:@\w+(?:\([^()]*\))?|public|internal|fileprivate"#
                + #"|private|package|open|final|indirect)\s+)*(?:struct|enum|class|actor)\s+(\w+)"#, read
        ).map { $0[0] })
    }

    static func stripComments(_ text: String, lent: Set<String> = []) throws -> String {
        // Conditional compilation is outside this court's scope. Omit the
        // complete block, including nested alternatives; never expose a tail
        // merely because an inner #endif was encountered. An omitted line
        // stays as an empty one, so the lines read are the source's lines.
        //
        // Omitting a block reads the file as a compilation that skips it, and
        // only a block under a plain flag, with no alternative of its own, is
        // one that a compilation without the flag skips. Any other condition,
        // `#if true` or `#if !FLAG` above all, and an `#else` or `#elseif` of
        // an outer block, holds source that compilation may read, a
        // declaration that rebinds a name among it, so each is refused at its
        // line rather than omitted.
        var flaggedDepth = 0
        var kept: [String] = []
        for (index, line) in try blankCommentsAndStrings(text, lent: lent)
            .split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
            let bare = line.trimmingCharacters(in: .whitespaces)
            if bare.range(of: #"^#if\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0,
                   bare.range(of: #"^#if\s+(?!true$)[A-Za-z_][A-Za-z0-9_]*$"#, options: .regularExpression) == nil {
                    try fail("cannot read line \(index + 1): '\(bare)' is not a plain compilation flag, "
                        + "and this court omits only a block a compilation without its flag skips")
                }
                flaggedDepth += 1
                kept.append("")
                continue
            }
            if bare.range(of: #"^#endif\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { try fail("unmatched #endif") }
                flaggedDepth -= 1
                kept.append("")
                continue
            }
            if bare.range(of: #"^#(?:else|elseif)\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { try fail("conditional branch outside #if") }
                if flaggedDepth == 1 {
                    try fail("cannot read line \(index + 1): '\(bare)' opens a branch a compilation without "
                        + "the flag reads, and this court omits only a block that compilation skips")
                }
                kept.append("")
                continue
            }
            kept.append(flaggedDepth > 0 ? "" : String(line))
        }
        if flaggedDepth != 0 { try fail("unterminated #if block") }
        return kept.joined(separator: "\n")
    }

    static func captures(_ pattern: String, _ text: String) -> [[String]] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).map { match in
            (1..<match.numberOfRanges).map { index in
                guard let bounds = Range(match.range(at: index), in: text) else { return "" }
                return String(text[bounds])
            }
        }
    }

    // This reader resolves every name in one scope, the file's. A name
    // declared in a body (a function's, or another type's) is bound there,
    // and Swift resolves a use inside that body to it. Read as file-scope, a
    // nested declaration could stand for a name declared elsewhere or
    // overwrite one declared here, and a second declaration of a name the
    // reader resolves, of any form, could rebind it where a use sits: either
    // way a good neighbour would pass the file. So a declaration this reader
    // reads at file scope is refused when it sits inside a body, and a name
    // it reads at file scope is refused when it is declared more than once.
    // Each refusal names the name and its lines.

    /// The brace depth and the line before each UTF-16 offset of the read
    /// text, the coordinates a regular expression match is reported in.
    struct Scope {
        var depth: [Int] = [0]
        var line: [Int] = [1]

        init(_ text: String) {
            for unit in text.utf16 {
                depth.append(depth[depth.count - 1] + (unit == 0x7B ? 1 : unit == 0x7D ? -1 : 0))
                line.append(line[line.count - 1] + (unit == 0x0A ? 1 : 0))
            }
        }
    }

    // A body opened by a type or an extension holds that type's members in
    // scope, and a member bound outside this file (an external type's generic
    // parameter, an associated type of a protocol another file declares)
    // rebinds a name there that this reader resolves at file scope. For each
    // UTF-16 offset of the read text, the number of type or extension bodies
    // around it. The header a brace closes runs from the previous brace or
    // semicolon, so it may begin with the tail of an expression before the
    // declaration. A header that spells a type or an extension keyword, read
    // as it is written, opens that type's body or is refused at its line:
    // reading the header's brackets decides which declaration the brace
    // belongs to, and may refuse, but never hides the keyword. The brace
    // opens a type or extension body when the last declaring keyword outside
    // the header's brackets names a type or an extension, since a generic
    // list, a parameter list or an attribute's arguments may spell `let`,
    // `each` or any word, and a header that ends in `repeat` opens a loop.
    // `class` before a member's keyword, modifiers between them, is that
    // member's modifier (`class func`, `override class var`), the kind an
    // import names (`import struct M.T`) declares nothing, a keyword after a
    // dot is a member's name, and `actor` is a keyword only before a name
    // (`let actor = 1` declares no type), so none of them names a type.
    static func typeBodies(_ text: String) throws -> [Int] {
        let keyword = try! NSRegularExpression(
            pattern: #"(?<!\.)\b(extension|enum|struct|class|actor(?=\s+[A-Za-z_])|protocol|func|init|deinit|subscript|var|let"#
                + #"|get|set|willSet|didSet|if|else|for|while|switch|case|default|do|catch|guard|defer)\b"#
        )
        func words(_ header: String) -> [String] {
            keyword.matches(in: header, range: NSRange(header.startIndex..., in: header))
                .compactMap { Range($0.range(at: 1), in: header) }
                .map { String(header[$0]) }
        }
        let notDeclaring = try! NSRegularExpression(
            pattern: #"\bimport\s+(?:struct|class|enum|protocol|typealias|func|var|let)\b|\bclass(?=(?:\s+(?:public|"#
                + #"private|fileprivate|internal|package|open|final|override|required|convenience|dynamic"#
                + #"|nonisolated))*\s+(?:func|var|let|subscript|init)\b)"#
        )
        let typeKeywords: Set<String> = ["extension", "enum", "struct", "class", "actor", "protocol"]
        let units = Array(text.utf16)
        var depth: [Int] = [0]
        var opened: [Bool] = []
        var segmentStart = 0
        var line = 1
        for (offset, unit) in units.enumerated() {
            var current = depth[depth.count - 1]
            if unit == 0x0A { line += 1 }
            if unit == 0x7B {
                let spelled = String(utf16CodeUnits: Array(units[segmentStart..<offset]), count: offset - segmentStart)
                let header = notDeclaring.stringByReplacingMatches(
                    in: spelled, range: NSRange(spelled.startIndex..., in: spelled), withTemplate: " "
                )
                var isType = false
                let named = words(header).filter { typeKeywords.contains($0) }
                if !named.isEmpty {
                    let outside = outsideBrackets(Array(header.utf16))
                    let flat = outside.map { String(utf16CodeUnits: $0, count: $0.count) } ?? ""
                    let loops = flat.trimmingCharacters(in: .whitespacesAndNewlines).hasSuffix("repeat")
                    isType = outside != nil && !loops && typeKeywords.contains(words(flat).last ?? "")
                    if !isType {
                        try fail("cannot read line \(line): this court cannot tell whether the body opened here "
                            + "belongs to a type or an extension")
                    }
                }
                opened.append(isType)
                if isType { current += 1 }
                segmentStart = offset + 1
            } else if unit == 0x7D {
                if let wasType = opened.popLast(), wasType { current -= 1 }
                segmentStart = offset + 1
            } else if unit == 0x3B {
                segmentStart = offset + 1
            }
            depth.append(current)
        }
        return depth
    }

    // An angle bracket is a generic bracket only where Swift's grammar makes
    // it one. In an expression, and a header region may begin with one, a
    // `<` opens generic arguments only when it is bound to the name before it
    // with no space between (`Use<Good>`) and does not begin an operator such
    // as `<=` or `<<`; spaced, it is a comparison (`1 < 2`). A `>` closes the
    // innermost open angle bracket, and the `>` of an arrow `->` closes none.
    // Parentheses and square brackets nest with them; a closing one that
    // meets an angle bracket left open shows that `<` to be a comparison
    // (`(a<b)`), and one that meets nothing closes what opened before the
    // region. The text outside every bracket is returned, or nil when a
    // closing bracket meets an opener of another kind or a bracket is still
    // open at the end: a region whose brackets this reader cannot place.
    static func outsideBrackets(_ units: [UInt16]) -> [UInt16]? {
        var open: [UInt16] = []
        var flat: [UInt16] = []
        for (index, unit) in units.enumerated() {
            let before: UInt16 = index > 0 ? units[index - 1] : 0x20
            let after: UInt16 = index + 1 < units.count ? units[index + 1] : 0x20
            if unit == 0x28 || unit == 0x5B
                || (unit == 0x3C && isWordUnit(before) && after != 0x3D && after != 0x3C) {
                open.append(unit)
            } else if unit == 0x29 || unit == 0x5D {
                while open.last == 0x3C { open.removeLast() }
                if let last = open.popLast(), last != (unit == 0x29 ? 0x28 : 0x5B) { return nil }
            } else if unit == 0x3E, before != 0x2D, open.last == 0x3C {
                open.removeLast()
            } else if open.isEmpty {
                flat.append(unit)
            }
        }
        return open.isEmpty ? flat : nil
    }

    // A UTF-16 unit of a word (a letter, a digit, an underscore, or any
    // character past ASCII), and one of the spaces between tokens.
    static func isWordUnit(_ unit: UInt16) -> Bool {
        (unit >= 0x30 && unit <= 0x39) || (unit >= 0x41 && unit <= 0x5A) || (unit >= 0x61 && unit <= 0x7A)
            || unit == 0x5F || unit >= 0x80
    }

    static func isSpaceUnit(_ unit: UInt16) -> Bool { unit == 0x20 || (0x09...0x0D).contains(unit) }

    // The ASCII operator signs this reader accepts in a function name.
    // Punctuation outside this set is not silently consumed as a name.
    static func isOperatorUnit(_ unit: UInt16) -> Bool {
        switch unit {
        case 0x2F, 0x3D, 0x2D, 0x2B, 0x21, 0x2A, 0x25, 0x3C, 0x3E,
             0x26, 0x7C, 0x5E, 0x7E, 0x3F, 0x2E: return true
        default: return false
        }
    }

    static func spelledLines(_ lines: [Int]) -> String {
        let spelled = lines.map(String.init)
        guard spelled.count > 1 else { return "line \(spelled[0])" }
        return "lines " + spelled.dropLast().joined(separator: ", ") + " and " + spelled[spelled.count - 1]
    }

    // The captures of a declaration this reader reads as file-scope: the
    // pattern begins at the declaring keyword, and its first group is the
    // declared name.
    static func declarations(_ pattern: String, _ text: String, _ scope: Scope) throws -> [[String]] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        let range = NSRange(text.startIndex..., in: text)
        return try regex.matches(in: text, range: range).map { match in
            let groups: [String] = (1..<match.numberOfRanges).map { index in
                guard let bounds = Range(match.range(at: index), in: text) else { return "" }
                return String(text[bounds])
            }
            let start = match.range.location
            if scope.depth[start] > 0 {
                let spelled = Range(match.range, in: text).map { String(text[$0]) } ?? ""
                let keyword = spelled.prefix { !$0.isWhitespace }
                try fail("cannot read line \(scope.line[start]): the \(keyword) '\(groups[0])' is declared "
                    + "inside a body, and this court reads declarations at file scope")
            }
            return groups
        }
    }

    // The group ranges of the same declarations, in the read text's UTF-16
    // coordinates, for a reader that must know where each group stands.
    static func declarationSpans(_ pattern: String, _ text: String, _ scope: Scope) throws -> [[NSRange]] {
        _ = try declarations(pattern, text, scope)
        let regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        return regex.matches(in: text, range: NSRange(text.startIndex..., in: text)).map { match in
            (1..<match.numberOfRanges).map { match.range(at: $0) }
        }
    }

    // Every declaration of a name, in any scope and of any form: a nominal
    // type, a protocol, a typealias, an associated type, a generic parameter.
    // `file` holds the names this reader reads at file scope: an enum, a
    // protocol or a typealias outside every body.
    static func declaredNames(_ text: String, _ scope: Scope) throws
        -> (lines: [String: [Int]], file: Set<String>) {
        var lines: [String: [Int]] = [:]
        var file = Set<String>()
        let range = NSRange(text.startIndex..., in: text)
        let nominal = try! NSRegularExpression(
            pattern: #"\b(enum|struct|class|actor|protocol|typealias|associatedtype)\s+(\w+)"#
        )
        for match in nominal.matches(in: text, range: range) {
            guard let kind = Range(match.range(at: 1), in: text).map({ String(text[$0]) }),
                  let name = Range(match.range(at: 2), in: text).map({ String(text[$0]) }) else { continue }
            let start = match.range.location
            lines[name, default: []].append(scope.line[start])
            if scope.depth[start] == 0, ["enum", "protocol", "typealias"].contains(kind) {
                file.insert(name)
            }
        }
        // A generic parameter list is read wherever a declaration may carry
        // one: after the name of a function, a type or a typealias, and after
        // `init` or `subscript`. The name is read by its lexical class, a word
        // or an operator (`func < <T>`, `func ==< T>`, whose last `<` opens the
        // list even across whitespace), so a list is never passed over because
        // its name is not a word. `class` before a member's keyword is a modifier, and `actor`
        // is a keyword only before a name. The list is read to its balanced
        // closing bracket, however deep its constraints nest; one this reader
        // cannot close before the header ends is refused.
        let declaring = try! NSRegularExpression(
            pattern: #"(?<!\.)\b(func|enum|struct|class|actor|typealias|init|subscript)\b"#
        )
        let modifying: Set<String> = [
            "func", "var", "let", "subscript", "init", "deinit", "static", "final", "override", "required",
            "convenience", "dynamic", "nonisolated", "public", "private", "fileprivate", "internal", "package", "open",
        ]
        let units = Array(text.utf16)
        for match in declaring.matches(in: text, range: range) {
            guard let kind = Range(match.range(at: 1), in: text).map({ String(text[$0]) }) else { continue }
            var cursor = match.range.location + match.range.length
            if kind == "init", cursor < units.count, units[cursor] == 0x3F || units[cursor] == 0x21 { cursor += 1 }
            if kind != "init", kind != "subscript" {
                while cursor < units.count, isSpaceUnit(units[cursor]) { cursor += 1 }
                let nameStart = cursor
                if kind == "func", cursor < units.count, !isWordUnit(units[cursor]) {
                    while cursor < units.count, isOperatorUnit(units[cursor]) {
                        cursor += 1
                    }
                    var next = cursor
                    while next < units.count, isSpaceUnit(units[next]) { next += 1 }
                    if cursor - nameStart > 1, units[cursor - 1] == 0x3C, next < units.count, isWordUnit(units[next]) {
                        cursor -= 1
                    }
                } else {
                    while cursor < units.count, isWordUnit(units[cursor]) { cursor += 1 }
                }
                let name = String(utf16CodeUnits: Array(units[nameStart..<cursor]), count: cursor - nameStart)
                if kind == "class", name.isEmpty || modifying.contains(name) { continue }
                if kind == "actor", name.isEmpty { continue }
                if name.isEmpty {
                    try fail("cannot read line \(scope.line[match.range.location]): the name this \(kind) declares "
                        + "is not one this court reads")
                }
            }
            while cursor < units.count, isSpaceUnit(units[cursor]) { cursor += 1 }
            if kind == "func", cursor == units.count || (units[cursor] != 0x3C && units[cursor] != 0x28) {
                try fail("cannot read line \(scope.line[match.range.location]): the function name is not followed "
                    + "by a parameter list this court reads")
            }
            guard cursor < units.count, units[cursor] == 0x3C else { continue }
            let start = cursor + 1
            var depth = 1
            var end = start
            while end < units.count, depth > 0 {
                let unit = units[end]
                if unit == 0x7B || unit == 0x7D || unit == 0x3B { break }
                if unit == 0x3C { depth += 1 }
                if unit == 0x3E, end == 0 || units[end - 1] != 0x2D { depth -= 1 }
                end += 1
            }
            guard depth == 0 else {
                try fail("cannot read line \(scope.line[match.range.location]): its generic parameter list "
                    + "does not close where this court can read it")
            }
            let list = String(utf16CodeUnits: Array(units[start..<(end - 1)]), count: end - 1 - start)
            for parameter in parameterNames(list) {
                // a parameter pack is spelled `each T`, a value parameter `let n: Int`
                let bare = parameter.split(whereSeparator: \.isWhitespace).last.map(String.init) ?? parameter
                lines[bare, default: []].append(scope.line[start])
            }
        }
        return (lines.mapValues { $0.sorted() }, file)
    }

    // The names a generic parameter list declares, split at its top-level
    // commas. The `>` of an arrow `->`, which a constraint may spell inside
    // its brackets, closes no bracket.
    static func parameterNames(_ list: String) -> [String] {
        guard !list.isEmpty else { return [] }
        var names: [String] = []
        var depth = 0
        var piece = ""
        var previous: Character = " "
        for character in list {
            if character == "<" { depth += 1 }
            if character == ">", previous != "-" { depth -= 1 }
            previous = character
            if character == ",", depth == 0 {
                names.append(piece)
                piece = ""
            } else {
                piece.append(character)
            }
        }
        names.append(piece)
        return names.map { piece in
            let bare = piece.split(separator: ":").first.map(String.init) ?? piece
            return bare.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    // A line break inside generic arguments does not end a typealias. Keep
    // projected continuations too; reject an unbalanced RHS as a reader
    // failure rather than judging its truncated prefix as a different type.
    static func readAliases(_ text: String) throws -> [[String]] {
        try readAliasSpans(text).map(\.fields)
    }

    // The same aliases, each with the range of its right side in the read
    // text's UTF-16 coordinates.
    static func readAliasSpans(_ text: String) throws -> [(fields: [String], body: NSRange, declaration: NSRange)] {
        let header = try! NSRegularExpression(
            pattern: #"typealias\s+(\w+)\s*(?:<([^>]*)>)?\s*=\s*"#,
            options: [.dotMatchesLineSeparators]
        )
        var result: [(fields: [String], body: NSRange, declaration: NSRange)] = []
        var cursor = text.startIndex
        while cursor < text.endIndex,
              let match = header.firstMatch(in: text, range: NSRange(cursor..., in: text)),
              let bounds = Range(match.range, in: text),
              let nameBounds = Range(match.range(at: 1), in: text) {
            let name = String(text[nameBounds])
            let parameters = Range(match.range(at: 2), in: text).map { String(text[$0]) } ?? ""
            let start = bounds.upperBound
            var end = start
            var depth = 0
            while end < text.endIndex {
                let character = text[end]
                if character == "<" { depth += 1 }
                if character == ">" {
                    depth -= 1
                    if depth < 0 { try fail("cannot read typealias '\(name)': unbalanced generic arguments") }
                }
                if character == "{" || character == "}" || character == ";" { break }
                if character == "\n", depth == 0 {
                    let following = text[text.index(after: end)...]
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    if !following.hasPrefix(".") { break }
                }
                end = text.index(after: end)
            }
            if depth != 0 { try fail("cannot read typealias '\(name)': unbalanced generic arguments") }
            let body = String(text[start..<end])
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: #"\s*\.\s*"#, with: ".", options: .regularExpression)
                .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            if body.isEmpty { try fail("cannot read typealias '\(name)': empty right side") }
            let tail = text[end...].trimmingCharacters(in: .whitespacesAndNewlines)
            let conditional = body.range(of: #"\bwhere\b"#, options: .regularExpression) != nil
                || tail.range(of: #"^where\b"#, options: .regularExpression) != nil
            result.append(([name, parameters, body, conditional ? "where" : ""], NSRange(start..<end, in: text), match.range))
            cursor = end
        }
        return result
    }

    // Member aliases belong to their declaration. Exporting them into the
    // world's namespace can turn an unrelated alias into a false equality.
    // Keep line boundaries so multiline top-level aliases remain readable.
    // A body's text becomes one space per UTF-16 unit, so what stands outside
    // keeps the read text's coordinates.
    static func outsideBodies(_ text: String) throws -> String {
        var depth = 0
        var result: [UInt16] = []
        for unit in text.utf16 {
            if unit == 0x7B { depth += 1 }
            result.append(depth == 0 || unit == 0x0A ? unit : 0x20)
            if unit == 0x7D { depth -= 1 }
            if depth < 0 { try fail("unmatched declaration brace") }
        }
        if depth != 0 { try fail("unterminated declaration body") }
        return String(utf16CodeUnits: result, count: result.count)
    }

    // A gate's where carries three kinds of conjunct. An equality is judged
    // against the canon. A membership, a colon and a bare protocol name, is
    // judged against the protocols the conformer's declaration and extensions
    // list, closed over the refinements the file presents. Anything else used
    // to be dropped in silence, and a court may not drop a condition in
    // silence: it is named at its gate instead, so a half-read law is a
    // refusal, never a verdict that counts what it never read.
    static func splitConjuncts(_ clause: String) throws
        -> (equalities: [(String, String)], memberships: [(String, String)], unjudged: [String]) {
        var parts: [String] = []
        var depth = 0
        var piece = ""
        var previous: Character = " "
        for character in clause {
            if character == "<" { depth += 1 }
            if character == ">", previous != "-" { depth -= 1 }
            previous = character
            if character == ",", depth == 0 {
                parts.append(piece)
                piece = ""
            } else {
                piece.append(character)
            }
        }
        parts.append(piece)
        var equalities: [(String, String)] = []
        var memberships: [(String, String)] = []
        var unjudged: [String] = []
        for part in parts {
            let bare = part.trimmingCharacters(in: .whitespacesAndNewlines)
            if bare.isEmpty { continue }
            // The `>` of an arrow closes no bracket, so a conjunct that spells
            // a function type ends at its own comma. A function type is a term
            // this court does not read, and no verdict is given over a law
            // that holds one: the conjunct is named instead.
            if bare.contains("->") {
                try fail("cannot read the where clause conjunct '\(bare)': a function type is a term this court "
                    + "does not read")
            }
            let sides = part.components(separatedBy: "==")
            if sides.count == 2 {
                equalities.append((
                    sides[0].trimmingCharacters(in: .whitespacesAndNewlines),
                    sides[1].trimmingCharacters(in: .whitespacesAndNewlines)
                ))
                continue
            }
            let claim = bare.components(separatedBy: ":")
            if claim.count == 2 {
                let lhs = claim[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let proto = claim[1].trimmingCharacters(in: .whitespacesAndNewlines)
                if lhs.isEmpty == false,
                   proto.range(of: #"^\w+$"#, options: .regularExpression) != nil {
                    memberships.append((lhs, proto))
                    continue
                }
            }
            unjudged.append(bare)
        }
        return (equalities, memberships, unjudged)
    }

    struct World {
        var conformers: [String: Conformer] = [:]
        var aliases: [String: AliasRule] = [:]
        var gates: [GatedExtension] = []
        var gatedProtocols: [String: GatedProtocol] = [:]
        var protocolParents: [String: [String]] = [:]
        var protocolAxes: [String: Set<String>] = [:]
        var parameters: [String: [String]] = [:]
        var conditionalDeclarations: Set<String> = []
        var presentedBodies: Set<String> = []
        var uses: [String] = []
        var useLines: [Int] = []
        var certificateLines: [String: Int] = [:]
        /// Uses and parameterless certificates are judged at their root.
        /// A parsed range does not discharge a gate nested inside that root.
        var rootApplicationSpans: [NSRange] = []
        /// the lines each name of this file is declared at, in any scope
        var declared: [String: [Int]] = [:]
        /// the lines at which this file extends each name, in any form
        var extensions: [String: [Int]] = [:]
        /// the names this file declares at file scope as a type, a protocol
        /// or a typealias: the names another file's extension can reach
        var fileTypes: Set<String> = []
        /// every name this file's code spells
        var names: Set<String> = []
        /// the read text, the line before each of its UTF-16 offsets, the
        /// ranges this court reads as uses, certificates and gate clauses,
        /// and the right sides of the typealiases at file scope
        var clean = ""
        var lineAt: [Int] = []
        var readSpans: [NSRange] = []
        var aliasSpans: [NSRange] = []
    }

    static func read(_ text: String, lent: Set<String> = []) throws -> World {
        let clean = try stripComments(text, lent: lent)
        let scope = Scope(clean)
        var world = World()

        // Use the same Unicode word class as the declaration reader. A name
        // it reads cannot disappear when checking which gates reach the file.
        world.names = Set(captures(#"\b(\w+)\b"#, clean).map { $0[0] })
        let names = try declaredNames(clean, scope)
        world.declared = names.lines
        for name in names.file.sorted(by: { (names.lines[$0]![0], $0) < (names.lines[$1]![0], $1) })
        where names.lines[name]!.count > 1 {
            try fail("cannot read '\(name)': it is declared at \(spelledLines(names.lines[name]!)), "
                + "and this court has no scope rule to choose between them")
        }

        // A presented declaration can have a body this flat reader cannot read.
        // Such a body does not license reflexivity of an unestablished field.
        for hit in try declarations(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\s*\{"#, clean, scope
        ) {
            world.presentedBodies.insert(hit[0])
        }

        for hit in try declarations(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\bwhere\s+[^{}]+\{"#, clean, scope
        ) {
            world.conditionalDeclarations.insert(hit[0])
        }

        for hit in try declarations(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*([\w,\s]+?)\s*\{([^{}]*)\}"#, clean, scope
        ) {
            let name = hit[0]
            let parameters = parameterNames(hit[1])
            let protocols = hit[2]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            var table: [String: String] = [:]
            for aliasHit in try readAliases(hit[3]) where aliasHit[1].isEmpty {
                guard table[aliasHit[0]] == nil else {
                    try fail("duplicate definition of '\(name).\(aliasHit[0])'")
                }
                table[aliasHit[0]] = aliasHit[2]
            }
            world.conformers[name] = Conformer(
                name: name, parameters: parameters, protocols: protocols, table: table
            )
        }

        for hit in try declarations(#"enum\s+(\w+)\s*<([^>]*)>"#, clean, scope) {
            world.parameters[hit[0]] = parameterNames(hit[1])
        }

        // An unconditional extension of a presented conformer adds the
        // protocols its header lists, whatever its body holds: the header
        // states the conformance, so a body this reader cannot read does not
        // drop the obligation. A where clause always carries ':' or '==', so
        // the list cannot swallow one, and a gated extension stays a gate. A
        // type with no inheritance list (`enum Foo {}`) is not presented, so
        // its extensions add nothing.
        for hit in try declarations(#"extension\s+(\w+)\s*:\s*([\w,\s]+?)\s*\{"#, clean, scope) {
            let name = hit[0]
            let listed = hit[1]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            if world.conformers[name] != nil {
                world.conformers[name]!.protocols += listed
            }
        }

        // An extension body inside the flat fragment lends its parameterless
        // aliases to a presented conformer. A body outside it is not read, so
        // an axis only that body defines has no definition here, and its
        // projection is unread rather than opaque.
        for hit in try declarations(
            #"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}"#, clean, scope
        ) {
            let name = hit[0]
            if world.conformers[name] != nil {
                for aliasHit in try readAliases(hit[1]) where aliasHit[1].isEmpty {
                    guard world.conformers[name]!.table[aliasHit[0]] == nil else {
                        try fail("duplicate definition of '\(name).\(aliasHit[0])'")
                    }
                    world.conformers[name]!.table[aliasHit[0]] = aliasHit[2]
                }
            }
        }

        let fileType = try! NSRegularExpression(pattern: #"\b(?:enum|struct|class|actor|protocol|typealias)\s+(\w+)"#)
        for match in fileType.matches(in: clean, range: NSRange(clean.startIndex..., in: clean))
        where scope.depth[match.range.location] == 0 {
            if let bounds = Range(match.range(at: 1), in: clean) { world.fileTypes.insert(String(clean[bounds])) }
        }
        // An extension's owner is read in full. One named through a qualifier
        // (`main.Owner`, `Module.Type`, `Outer.Inner`, with whitespace or
        // comments between their tokens as well) is a type this court
        // does not resolve, so it is refused at its line rather than read as
        // its first word.
        let extended = try! NSRegularExpression(pattern: #"(?<!\.)\bextension\b"#)
        let cleanUnits = Array(clean.utf16)
        for match in extended.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            let line = scope.line[match.range.location]
            var cursor = match.range.location + match.range.length
            while cursor < cleanUnits.count, isSpaceUnit(cleanUnits[cursor]) { cursor += 1 }
            let nameStart = cursor
            while cursor < cleanUnits.count, isWordUnit(cleanUnits[cursor]) { cursor += 1 }
            if cursor == nameStart {
                try fail("cannot read line \(line): the type this extension extends is not one this court reads")
            }
            var parts = [String(utf16CodeUnits: Array(cleanUnits[nameStart..<cursor]), count: cursor - nameStart)]
            while true {
                while cursor < cleanUnits.count, isSpaceUnit(cleanUnits[cursor]) { cursor += 1 }
                guard cursor < cleanUnits.count, cleanUnits[cursor] == 0x2E else { break }
                cursor += 1
                while cursor < cleanUnits.count, isSpaceUnit(cleanUnits[cursor]) { cursor += 1 }
                let partStart = cursor
                while cursor < cleanUnits.count, isWordUnit(cleanUnits[cursor]) { cursor += 1 }
                guard cursor > partStart else {
                    try fail("cannot read line \(line): the type this extension extends is not one this court reads")
                }
                parts.append(String(utf16CodeUnits: Array(cleanUnits[partStart..<cursor]), count: cursor - partStart))
            }
            let spelled = parts.joined(separator: ".")
            if parts.count > 1 {
                try fail("cannot read line \(line): the extension of '\(spelled)' names its type through a qualifier, "
                    + "which this court does not resolve")
            }
            let tailStart = cursor
            var tailEnd = cursor
            while tailEnd < cleanUnits.count, isWordUnit(cleanUnits[tailEnd]) { tailEnd += 1 }
            let tail = String(utf16CodeUnits: Array(cleanUnits[tailStart..<tailEnd]), count: tailEnd - tailStart)
            guard cursor < cleanUnits.count,
                  cleanUnits[cursor] == 0x3A || cleanUnits[cursor] == 0x7B || tail == "where" else {
                try fail("cannot read line \(line): the type this extension extends is not one this court reads")
            }
            world.extensions[spelled, default: []].append(line)
        }

        for hit in try readAliases(try outsideBodies(clean)) {
            guard world.aliases[hit[0]] == nil else {
                try fail("duplicate definition of typealias '\(hit[0])'")
            }
            if !hit[3].isEmpty { world.conditionalDeclarations.insert(hit[0]) }
            world.aliases[hit[0]] = AliasRule(
                parameters: parameterNames(hit[1]),
                body: hit[2]
            )
        }

        // An extension of a typealias extends the type the alias names, and
        // this court does not follow an extension through an alias.
        let throughAlias = world.extensions
            .filter { world.aliases[$0.key] != nil }
            .sorted(by: { $0.key < $1.key })
        if let first = throughAlias.first {
            try fail("cannot read '\(first.key)': it is a typealias, extended at \(spelledLines(first.value)), and this "
                + "court does not follow an extension through an alias to its type")
        }

        // A where clause this reader cannot read as a gate is refused by name,
        // never passed over: an unread condition would leave every claim
        // over it unjudged, and a neighbour that holds would pass the file.
        // A conditional conformance is read with one protocol before its
        // where clause, a conditional protocol with an inheritance list.
        for hit in try declarations(#"extension\s+(\w+)\s*:\s*([^{}]*?)\bwhere\b"#, clean, scope)
        where hit[1].range(of: #"^\w+\s+$"#, options: .regularExpression) == nil {
            let listed = hit[1].split(whereSeparator: \.isWhitespace).joined(separator: " ")
            try fail("cannot read conditional conformance '\(hit[0]): \(listed)': "
                + "this court reads one protocol per conditional extension")
        }
        for hit in try declarations(#"protocol\s+(\w+)\b([^{}]*?)\bwhere\b"#, clean, scope)
        where hit[1].range(of: #"^\s*:\s*[\w,\s]+?\s+$"#, options: .regularExpression) == nil {
            try fail("cannot read conditional protocol '\(hit[0])': "
                + "this court reads a where clause after an inheritance list of plain names")
        }

        for hit in try declarations(
            #"extension\s+(\w+)\s*:\s*(\w+)\s+where\s+([^{]+)\{"#, clean, scope
        ) {
            let conjuncts = try splitConjuncts(hit[2])
            world.gates.append(GatedExtension(
                head: hit[0], proto: hit[1],
                equalities: conjuncts.equalities,
                memberships: conjuncts.memberships,
                unjudged: conjuncts.unjudged
            ))
        }

        for hit in try declarations(
            #"protocol\s+(\w+)\s*:\s*[\w,\s]+?\s+where\s+([^{]+)\{"#, clean, scope
        ) {
            let conjuncts = try splitConjuncts(hit[1])
            world.gatedProtocols[hit[0]] = GatedProtocol(
                name: hit[0],
                equalities: conjuncts.equalities,
                memberships: conjuncts.memberships,
                unjudged: conjuncts.unjudged
            )
        }

        // the refinement ladder, read from what is presented: a protocol's
        // parents are the material the membership walk closes over
        for hit in try declarations(
            #"protocol\s+(\w+)\s*:\s*([\w,\s]+?)\s*(?:\s+where|\{)"#, clean, scope
        ) {
            world.protocolParents[hit[0]] = hit[1]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
        }
        for hit in try declarations(#"protocol\s+(\w+)\s*\{"#, clean, scope)
        where world.protocolParents[hit[0]] == nil {
            world.protocolParents[hit[0]] = []
        }

        for hit in try declarations(#"protocol\s+(\w+)[^{}]*\{([^{}]*)\}"#, clean, scope) {
            world.protocolAxes[hit[0]] = Set(captures(#"associatedtype\s+(\w+)"#, hit[1]).map { $0[0] })
        }

        // A use is an application written as a metatype: the chain of names,
        // dots and balanced generic arguments that stands before `.self` on
        // its line. A use is read at file scope; one inside a type or an
        // extension body may name a member this court does not read, so it is
        // refused there.
        let bodies = try typeBodies(clean)
        let units = Array(clean.utf16)
        var read: [NSRange] = []
        let metatype = try! NSRegularExpression(pattern: #"\.self\b"#)
        for match in metatype.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            var index = match.range.location - 1
            while index >= 0, isSpaceUnit(units[index]) { index -= 1 }
            let end = index + 1
            var chained = true
            while index >= 0 {
                if units[index] == 0x3E, index == 0 || units[index - 1] != 0x2D {
                    var depth = 0
                    var open = index
                    while open >= 0 {
                        let unit = units[open]
                        if unit == 0x3E, open == 0 || units[open - 1] != 0x2D { depth += 1 }
                        if unit == 0x3C { depth -= 1 }
                        if depth == 0 || unit == 0x7B || unit == 0x7D || unit == 0x3B { break }
                        open -= 1
                    }
                    guard open > 0, units[open] == 0x3C, depth == 0, isWordUnit(units[open - 1]) else {
                        chained = false
                        break
                    }
                    index = open - 1
                }
                guard isWordUnit(units[index]) else { break }
                while index >= 0, isWordUnit(units[index]) { index -= 1 }
                guard index >= 0, units[index] == 0x2E else { break }
                index -= 1
            }
            let start = index + 1
            guard chained, start < end else { continue }
            let spelled = String(utf16CodeUnits: Array(units[start..<end]), count: end - start)
            guard spelled.contains("<"), !spelled.contains("->"),
                  spelled.range(of: #"^[\w.<>, ]+$"#, options: .regularExpression) != nil else { continue }
            let use = spelled
            if bodies[start] > 0 {
                try fail("cannot read line \(scope.line[start]): the use '\(use)' sits in the body of a type "
                    + "or an extension, whose members this court does not read")
            }
            world.uses.append(use)
            world.useLines.append(scope.line[start])
            read.append(NSRange(location: start, length: end - start))
            world.rootApplicationSpans.append(NSRange(location: start, length: end - start))
        }

        // What this court reads of a gated head's applications: the uses
        // above, the right sides of the typealiases at file scope and in a
        // presented conformer's table, and the gates' where clauses. The
        // check that nothing else applies one waits for every file.
        for span in try readAliasSpans(try outsideBodies(clean)) {
            world.certificateLines[span.fields[0]] = scope.line[span.declaration.location]
            world.aliasSpans.append(span.body)
            if span.fields[1].isEmpty { world.rootApplicationSpans.append(span.body) }
        }
        read += world.aliasSpans
        for spans in try declarationSpans(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*([\w,\s]+?)\s*\{([^{}]*)\}"#, clean, scope
        ) {
            let table = spans[3]
            guard let bounds = Range(table, in: clean), let owner = Range(spans[0], in: clean) else { continue }
            for span in try readAliasSpans(String(clean[bounds])) where span.fields[1].isEmpty {
                world.certificateLines[String(clean[owner]) + "." + span.fields[0]] = scope.line[table.location + span.declaration.location]
                read.append(NSRange(location: table.location + span.body.location, length: span.body.length))
                world.rootApplicationSpans.append(NSRange(location: table.location + span.body.location, length: span.body.length))
            }
        }
        for spans in try declarationSpans(
            #"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}"#, clean, scope
        ) {
            guard let owner = Range(spans[0], in: clean), world.conformers[String(clean[owner])] != nil,
                  let bounds = Range(spans[1], in: clean) else { continue }
            for span in try readAliasSpans(String(clean[bounds])) where span.fields[1].isEmpty {
                world.certificateLines[String(clean[owner]) + "." + span.fields[0]] = scope.line[spans[1].location + span.declaration.location]
                read.append(NSRange(location: spans[1].location + span.body.location, length: span.body.length))
                world.rootApplicationSpans.append(NSRange(location: spans[1].location + span.body.location, length: span.body.length))
            }
        }
        for spans in try declarationSpans(#"extension\s+(\w+)\s*:\s*(\w+)\s+where\s+([^{]+)\{"#, clean, scope) {
            read.append(spans[2])
        }
        for spans in try declarationSpans(#"protocol\s+(\w+)\s*:\s*[\w,\s]+?\s+where\s+([^{]+)\{"#, clean, scope) {
            read.append(spans[1])
        }
        world.readSpans = read
        world.clean = clean
        world.lineAt = scope.line
        return world
    }

    // ── source-relative reduction, with replayed derivations ──

    // The term reader consumes the whole expression. An unread suffix cannot
    // be turned into an opaque atom and then accepted by reflexivity.
    static func parseTerm(_ text: Substring) throws -> Term {
        do { return try DefinitionReduction.parse(String(text)).legacy }
        catch { try fail("cannot read term: \(error)") }
    }

    static func substitute(_ term: Term, _ bindings: [String: Term]) throws -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let values = try bindings.mapValues {
                try DefinitionReduction.parse(Press.serialize($0), allowRigidNames: true)
            }
            return try expression.substituting(values).legacy
        } catch { try fail("cannot substitute term: \(error)") }
    }

    static func normalize(_ term: Term, _ world: World, rigid: Set<String> = []) throws -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            return try DefinitionReduction.normalForm(expression, source: source).output.legacy
        } catch { try fail("unresolved definition reduction: \(error)") }
    }

    static func canon(_ text: String, _ world: World) throws -> String {
        Press.serialize(try normalize(try parseTerm(Substring(text)), world))
    }

    // A claim meets the gate its definition names. A head spelled through an
    // alias or a member alias is unfolded before the gate is looked up, so an
    // intermediate name cannot carry a claim past its gate. A nominal head is
    // already the name a gate is looked up by, and a world that presents no
    // gate has no lookup to prepare. The gate itself reads the arguments.
    static func gatedForm(_ term: Term, _ world: World, rigid: Set<String> = []) throws -> Term {
        guard !world.gates.isEmpty,
              world.aliases[term.head] != nil || term.head.contains(".") else { return term }
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            return try DefinitionReduction.headForm(expression, source: source).output.legacy
        } catch { try fail("unresolved definition reduction: \(error)") }
    }

    // does the conformer wear the protocol: the lists of its declaration and
    // its extensions, closed over the refinement ladder the file presents
    static func wears(_ conformer: Conformer, _ proto: String, _ world: World) -> Bool {
        inheritedProtocols(conformer.protocols, world).contains(proto)
    }

    static func inheritedProtocols(_ protocols: [String], _ world: World) -> Set<String> {
        var seen = Set<String>()
        var pile = protocols
        while let name = pile.popLast() {
            if seen.insert(name).inserted {
                pile.append(contentsOf: world.protocolParents[name] ?? [])
            }
        }
        return seen
    }

    static func conformerContext(_ conformer: Conformer, _ world: World) throws
        -> (bindings: [String: Term], rigid: Set<String>) {
        guard Set(conformer.parameters).count == conformer.parameters.count else {
            try fail("cannot bind conformer '\(conformer.name)': duplicate generic parameters")
        }
        // Alpha-rename bound parameters outside the source identifier grammar.
        // No nominal declaration or alias may supply a value for a free
        // parameter merely by sharing its spelling.
        let variables = conformer.parameters.indices.map {
            Term(head: "$free_\(conformer.name)_\($0)", args: [])
        }
        let owner = Term(head: conformer.name, args: variables)
        let rigid = Set(variables.map { $0.head })
        var bindings = Dictionary(uniqueKeysWithValues: zip(conformer.parameters, variables))
        bindings["Self"] = owner
        var axes = Set(conformer.table.keys)
        for proto in inheritedProtocols(conformer.protocols, world) {
            axes.formUnion(world.protocolAxes[proto] ?? [])
        }
        for axis in axes where !conformer.parameters.contains(axis) {
            bindings[axis] = Term(head: Press.serialize(owner) + "." + axis, args: [])
        }
        return (bindings, rigid)
    }

    // A question's formal parameters must be bound by this actual application.
    // zip alone would leave missing parameters free to resolve as global names.
    // A declaration with zero parameters still has obligations to discharge.
    static func gateBindings(_ term: Term, _ world: World) throws -> [String: Term] {
        guard let parameters = world.parameters[term.head] ?? world.conformers[term.head]?.parameters else {
            try fail("cannot bind gate '\(term.head)': no declaration parameters were read")
        }
        guard parameters.count == term.args.count, Set(parameters).count == parameters.count else {
            try fail("cannot bind gate '\(term.head)': expected \(parameters.count) distinct arguments, received \(term.args.count)")
        }
        var bindings = Dictionary(uniqueKeysWithValues: zip(parameters, term.args))
        bindings["Self"] = term
        if let owner = world.conformers[term.head] {
            var axes = Set(owner.table.keys)
            for proto in inheritedProtocols(owner.protocols, world) {
                axes.formUnion(world.protocolAxes[proto] ?? [])
            }
            for axis in axes where bindings[axis] == nil {
                bindings[axis] = Term(head: Press.serialize(term) + "." + axis, args: [])
            }
        }
        return bindings
    }

    // A missing ancestor may carry an obligation; absence is not an empty gate.
    static func requireProtocolGrounds(_ protocols: [String], _ world: World) throws {
        for name in inheritedProtocols(protocols, world).sorted() {
            guard world.protocolParents[name] != nil || world.gatedProtocols[name] != nil else {
                throw Failure.open(["no declared protocol grounds for '\(name)'"])
            }
        }
    }

    // one membership judged: the left side resolves through the same canon
    // the equalities use, the resolved name must be a presented conformer,
    // and the conformer must wear the protocol through the ladder. Either
    // failure is a refusal in this court's own voice, at the site that
    // required it. Applied generic types have a separate boundary: knowing
    // the head's protocol list does not establish its argument constraints.
    static func judgeMemberships(
        _ memberships: [(String, String)], site: String, tag: String?,
        bindings: [String: Term], world: World,
        counted: inout Int, refusals: inout [String], rigid: Set<String> = [],
        requireGrounds: Bool = false
    ) throws {
        let mark = tag.map { " [\($0)]" } ?? ""
        for (lhs, proto) in memberships {
            if requireGrounds { try requireProtocolGrounds([proto], world) }
            counted += 1
            let lhsTerm = try substitute(try parseTerm(Substring(lhs)), bindings)
            let resolved = try normalize(lhsTerm, world, rigid: rigid)
            let spelled = Press.serialize(resolved)
            if world.conformers[resolved.head] == nil, world.presentedBodies.contains(resolved.head) {
                try fail("cannot read declaration '\(resolved.head)': its body is outside this court's flat-definition fragment")
            }
            guard resolved.args.isEmpty else {
                try fail("cannot judge membership of '\(spelled)' in '\(proto)' required by '\(site)': "
                    + "generic applicability is not established by this membership reader")
            }
            guard let wearer = world.conformers[resolved.head] else {
                if requireGrounds {
                    throw Failure.open(["no declared conformance grounds for '\(spelled)' required by '\(site)'"])
                }
                refusals.append(
                    "'\(site)' requires the type '\(lhs)' (aka '\(spelled)') conform to "
                        + "'\(proto)', and no conformer of that name is presented\(mark)"
                )
                continue
            }
            if requireGrounds {
                try requireProtocolGrounds(wearer.protocols, world)
                let inherited = inheritedProtocols(wearer.protocols, world)
                if let gated = inherited.sorted().first(where: { world.gatedProtocols[$0] != nil }) {
                    try fail("membership of '\(spelled)' depends on gated conformance '\(gated)'; "
                        + "this selected-application profile does not discharge dependent conformer obligations")
                }
            }
            if wears(wearer, proto, world) == false {
                let worn = wearer.protocols.joined(separator: ", ")
                refusals.append(
                    "'\(site)' requires the type '\(lhs)' (aka '\(resolved.head)') conform to "
                        + "'\(proto)', and '\(resolved.head): \(worn)' does not carry it\(mark)"
                )
            }
        }
    }

    // ── the judgement ──

    struct Judgment {
        let equalities: Int
        let memberships: Int
        let uses: Int
        let excludesConditional: Bool
        let refusals: [String]
    }

    /// The original text/exit interface is retained at this single boundary.
    static func run(_ arguments: [String]) {
        do {
            let result = try judge(arguments)
            if result.refusals.isEmpty {
                if result.excludesConditional {
                    print("THE WHERE scope: conditional compilation blocks are excluded.")
                }
                print("✓ THE WHERE holds: \(result.equalities) equalities and \(result.memberships) memberships judged across \(result.uses) uses, the certificates, and the gated conformers, source-replayed definition reductions (canon v\(canonVersion)).")
            } else {
                for refusal in result.refusals { print("✗ \(refusal)") }
                exit(1)
            }
        } catch let failure as Failure {
            for message in failure.messages {
                FileHandle.standardError.write(Data("✗ THE WHERE: \(message)\n".utf8))
            }
            exit(2)
        } catch {
            FileHandle.standardError.write(Data("✗ THE WHERE: internal error: \(error)\n".utf8))
            exit(2)
        }
    }

    /// Reader failures are thrown to the caller. This retains the legacy aggregate
    /// judgment; it is not yet a per-application request/coverage protocol.
    struct Prepared {
        let path: String
        let world: World
        let ownAliases: [String: AliasRule]
        let excludesConditional: Bool
    }

    enum Selection: Equatable {
        case certificate(String)
        case use(Int)
        case conformer(String)
    }

    static func fileText(_ path: String) throws -> String {
        guard let text = try? String(contentsOfFile: path, encoding: .utf8) else {
            throw Failure.input(["cannot read \(path)"])
        }
        return text
    }

    static func judge(_ arguments: [String]) throws -> Judgment {
        try evaluate(prepare(arguments))
    }

    static func prepare(_ arguments: [String],
                        load: (String) throws -> String = fileText) throws -> Prepared {
        guard let path = arguments.first else {
            throw Failure.input(["usage: judge where <world.swift> [definitions.swift ...]"])
        }
        let text = try load(path)
        // A definitions file that declares a result builder or a property
        // wrapper lends that attribute to the world the way it lends its
        // typealiases: the declaration supplies the premise that the
        // attribute adds no conformance. A definitions file this scan cannot
        // read lends nothing here; it is refused below, in its turn.
        let lentBuilders = Set(arguments.dropFirst().flatMap { extra -> Set<String> in
            guard let more = try? load(extra), let clean = try? stripComments(more) else { return [] }
            return declaredBuilders(clean)
        })
        var world = try read(text, lent: lentBuilders)
        var excludesConditional = text.range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
        let ownAliases = world.aliases
        // Extra files supply alias definitions, not a second version of the
        // same source. This flat reader has no module-resolution rule with
        // which to choose between duplicates, so a collision is unresolved.
        var aliasOrigins = Dictionary(uniqueKeysWithValues: world.aliases.keys.map { ($0, path) })
        let extras: [(path: String, text: String, world: World)] = try arguments.dropFirst().map { extra in
            let more = try load(extra)
            return (extra, more, try read(more))
        }
        // A typealias of any file may be extended from another, and such an
        // extension extends the alias's type, through the alias, as well.
        var anyAlias = Set(world.aliases.keys)
        for extra in extras { anyAlias.formUnion(extra.world.aliases.keys) }
        let worldThroughAlias = world.extensions
            .filter { anyAlias.contains($0.key) }
            .sorted(by: { $0.key < $1.key })
        if let first = worldThroughAlias.first {
            try fail("cannot read '\(first.key)': it is a typealias, extended at \(spelledLines(first.value)), and this "
                + "court does not follow an extension through an alias to its type")
        }
        // A gate binds every file of the module, and this court judges the
        // gates of the world it reads. A definitions file's gated extension of
        // a head the world names, and its gated protocol, when a protocol the
        // world names reaches it through the refinements any file presents,
        // would bind the world unjudged, so each is refused by name.
        var ancestry = world.protocolParents
        for extra in extras {
            ancestry.merge(extra.world.protocolParents) { first, _ in first }
        }
        for extra in extras {
            for gate in extra.world.gates where world.names.contains(gate.head) {
                try fail("cannot read the gate '\(gate.head): \(gate.proto)' in '\(extra.path)': this court judges "
                    + "the gates of the world it reads, and '\(path)' names '\(gate.head)'")
            }
            let gated = Set(extra.world.gatedProtocols.keys)
            guard !gated.isEmpty else { continue }
            for name in world.names.sorted() {
                var reached: Set<String> = []
                var walk = [name]
                while let next = walk.popLast() {
                    guard reached.insert(next).inserted else { continue }
                    walk += ancestry[next] ?? []
                }
                if let first = reached.intersection(gated).sorted().first {
                    try fail("cannot read '\(name)': it reaches '\(first)', a gated protocol of '\(extra.path)', and "
                        + "this court judges the gated protocols of the world it reads")
                }
            }
        }
        for (extra, more, lent) in extras {
            excludesConditional = excludesConditional
                || more.range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
            // A definitions file that extends a type, a protocol or a typealias
            // this world declares at file scope may add a member that binds a
            // name inside the world's type, a conformance, or a gate. Whether
            // that extension is the world's type at all (the definitions file
            // may declare its own type of the name, privately, or sit in
            // another module) and whether its members reach this file (a
            // private or fileprivate member does not) are facts this flat
            // reader does not establish, so such an extension is refused rather
            // than read or passed over, and so is one of a typealias, which
            // extends the alias's type, whichever file declares it.
            let extendsWorld = lent.extensions
                .filter { world.fileTypes.contains($0.key) || anyAlias.contains($0.key) }
                .sorted(by: { $0.key < $1.key })
            if let first = extendsWorld.first {
                try fail("cannot read '\(first.key)': '\(extra)' extends it at \(spelledLines(first.value)), and this court "
                    + "cannot tell that the extension is this world's type, or that its members reach this file")
            }
            for (name, rule) in lent.aliases.sorted(by: { $0.key < $1.key }) {
                guard aliasOrigins[name] == nil else {
                    try fail("ambiguous definition of '\(name)' in '\(aliasOrigins[name]!)' and '\(extra)'")
                }
                if let lines = world.declared[name] {
                    try fail("cannot read '\(name)': it is a typealias in '\(extra)' and is declared at "
                        + "\(spelledLines(lines)) of '\(path)', and this court has no scope rule to choose between them")
                }
                world.aliases[name] = rule
                aliasOrigins[name] = extra
            }
        }
        // A gated head is judged where it is applied, so every application of
        // one is read, or refused at its line, never passed over. A typealias
        // whose right side names a gated head, in any file, applies it in turn,
        // and its own applications count. In the world an application is read
        // as a use, as the right side of a typealias at file scope or in a
        // presented conformer's table, or in a gate's where clause; written
        // anywhere else (a parameter's type, a member alias of a body this
        // reader does not read, a local alias, a parenthesized metatype, a use
        // across lines) it binds a demand this court never judges, and a
        // neighbour would pass the file. A definitions file is read for its
        // typealiases alone: there an application is read only as the right
        // side of a generic one, and a parameterless one that applies a gated
        // head is a certificate this court does not judge outside the world.
        var gatedNames = Set(world.gates.map(\.head))
        var grown = true
        while grown {
            grown = false
            for (name, rule) in world.aliases.sorted(by: { $0.key < $1.key }) where !gatedNames.contains(name) {
                let spelled = Set(captures(#"\b(\w+)\b"#, rule.body).map { $0[0] })
                if !spelled.isDisjoint(with: gatedNames) {
                    gatedNames.insert(name)
                    grown = true
                }
            }
        }
        for extra in extras {
            for (name, rule) in extra.world.aliases.sorted(by: { $0.key < $1.key }) where rule.parameters.isEmpty {
                if gatedNames.contains(name) {
                    try fail("cannot read '\(name)': '\(extra.path)' defines it as an application of a gated head, and "
                        + "this court judges certificates in the world it reads")
                }
            }
        }
        let declaring: Set<String> = ["enum", "struct", "class", "actor", "typealias", "protocol"]
        var unreadPlaces: [(line: Int, message: String)] = []
        // A use or a certificate is judged only at the head its definition
        // exposes. Reading Optional<Use<Bad>> as a term does not judge Use,
        // and the outer gate of Twin<Use<Bad>> does not judge the inner one.
        // Generic aliases defer their arguments until application, so inspect
        // the exposed root as well as its written arguments. Nested gates are
        // a named boundary, including a gate reached through an argument alias.
        for span in world.rootApplicationSpans {
            guard let bounds = Range(span, in: world.clean) else { continue }
            let spelled = String(world.clean[bounds]).trimmingCharacters(in: .whitespacesAndNewlines)
            let names = Set(captures(#"\b(\w+)\b"#, spelled).map { $0[0] })
            guard !names.isDisjoint(with: gatedNames) else { continue }
            let term = try parseTerm(Substring(spelled))
            let claim = try gatedForm(term, world)
            let arguments = (term.args + claim.args).map(Press.serialize).joined(separator: ",")
            let nested = Set(captures(#"\b(\w+)\b"#, arguments).map { $0[0] }).intersection(gatedNames)
            if !nested.isEmpty || !world.gates.contains(where: { $0.head == claim.head }) {
                let line = world.lineAt[span.location]
                unreadPlaces.append((line, "cannot read line \(line) of '\(path)': '\(spelled)' contains "
                    + "a gated application outside the root this court judges"))
            }
        }
        func unread(_ file: World, _ spans: [NSRange], _ spelledPath: String) {
            let units = Array(file.clean.utf16)
            var places: [(line: Int, message: String)] = []
            for name in gatedNames.sorted() {
                // Comments have become spaces; qualification can still have
                // spaces before or after each dot, including across lines.
                let applied = try! NSRegularExpression(pattern: #"(?<![\w.])((?:\w+\s*\.\s*)*)"#
                    + NSRegularExpression.escapedPattern(for: name) + #"\s*<"#)
                for match in applied.matches(in: file.clean, range: NSRange(file.clean.startIndex..., in: file.clean)) {
                    let at = match.range.location
                    if !spans.filter({ NSLocationInRange(at, $0) }).isEmpty { continue }
                    var wordEnd = at
                    while wordEnd > 0, isSpaceUnit(units[wordEnd - 1]) { wordEnd -= 1 }
                    var wordStart = wordEnd
                    while wordStart > 0, isWordUnit(units[wordStart - 1]) { wordStart -= 1 }
                    let word = String(utf16CodeUnits: Array(units[wordStart..<wordEnd]), count: wordEnd - wordStart)
                    if declaring.contains(word) { continue }
                    // a metatype whose generic arguments run across lines is a
                    // use this court reads only on one line
                    var close = match.range.location + match.range.length
                    var depth = 1
                    var broken = false
                    while close < units.count, depth > 0 {
                        let unit = units[close]
                        if unit == 0x3C { depth += 1 }
                        if unit == 0x3E, units[close - 1] != 0x2D { depth -= 1 }
                        if unit == 0x0A { broken = true }
                        if unit == 0x7B || unit == 0x7D || unit == 0x3B { break }
                        close += 1
                    }
                    var after = close
                    while after < units.count, isSpaceUnit(units[after]) { after += 1 }
                    let metatype = depth == 0 && after + 4 < units.count
                        && String(utf16CodeUnits: Array(units[after..<(after + 5)]), count: 5) == ".self"
                    let reason = metatype && broken
                        ? "a use written across lines, which this court reads on one line"
                        : "a place where this court reads no use and no certificate"
                    places.append((file.lineAt[at], "cannot read line \(file.lineAt[at]) of '\(spelledPath)': '\(name)' "
                        + "applies a gated head in \(reason)"))
                }
            }
            unreadPlaces += places.sorted(by: { ($0.line, $0.message) < ($1.line, $1.message) })
        }
        unread(world, world.readSpans, path)
        unreadPlaces.sort { ($0.line, $0.message) < ($1.line, $1.message) }
        for extra in extras { unread(extra.world, extra.world.aliasSpans, extra.path) }
        if !unreadPlaces.isEmpty { try failAll(unreadPlaces.map(\.message)) }

        return Prepared(path: path, world: world, ownAliases: ownAliases,
                        excludesConditional: excludesConditional)
    }

    static func evaluate(_ prepared: Prepared, selection: Selection? = nil,
                         requireGrounds: Bool = false) throws -> Judgment {
        let world = prepared.world
        let ownAliases = prepared.ownAliases
        let excludesConditional = prepared.excludesConditional
        var refusals: [String] = []
        var judged = 0
        var members = 0

        // a gate that carries what no court here judges is named at once:
        // the defect is the law's own spelling, not any use of it
        for gate in world.gates {
            for part in gate.unjudged {
                refusals.append(
                    "the gate '\(gate.head): \(gate.proto)' carries '\(part)', "
                        + "a conjunct this court does not judge"
                )
            }
        }
        for gated in world.gatedProtocols.values.sorted(by: { $0.name < $1.name }) {
            for part in gated.unjudged {
                refusals.append(
                    "the gated protocol '\(gated.name)' carries '\(part)', "
                        + "a conjunct this court does not judge"
                )
            }
        }

        // A typealias certificate is a judged point: a parameterless alias in the
        // world whose right side names a gated head states the gate's equalities
        // for those arguments, and the refusal names the certificate.
        var certificates: [(name: String, term: Term, rigid: Set<String>)] = try ownAliases
            .filter { $0.value.parameters.isEmpty }
            .map { ($0.key, try parseTerm(Substring($0.value.body)), []) }
        // A local certificate is still checked, but in its actual owner.
        // Removing it from the global namespace must not remove its obligation.
        for conformer in world.conformers.values {
            let context = try conformerContext(conformer, world)
            for (name, body) in conformer.table {
                certificates.append((conformer.name + "." + name,
                    try substitute(try parseTerm(Substring(body)), context.bindings), context.rigid))
            }
        }
        for certificate in certificates.sorted(by: { $0.name < $1.name }) {
            guard selection == nil || selection == .certificate(certificate.name) else { continue }
            let name = certificate.name
            let term = certificate.term
            let body = Press.serialize(term)
            let claim = try gatedForm(term, world, rigid: certificate.rigid)
            let matching = world.gates.filter { $0.head == claim.head }
            guard !matching.isEmpty else { continue }
            let bindings = try gateBindings(claim, world)
            for gate in matching {
                if requireGrounds { try requireProtocolGrounds([gate.proto], world) }
                for (left, right) in gate.equalities {
                    judged += 1
                    let leftTerm = try substitute(try parseTerm(Substring(left)), bindings)
                    let rightTerm = try substitute(try parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(try normalize(leftTerm, world, rigid: certificate.rigid))
                    let rightCanon = Press.serialize(try normalize(rightTerm, world, rigid: certificate.rigid))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(name) = \(body)' requires the types '\(left)' (aka '\(leftCanon)') and "
                                + "'\(right)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
                        )
                    }
                }
                try judgeMemberships(
                    gate.memberships, site: "\(name) = \(body)", tag: gate.proto,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals, rigid: certificate.rigid, requireGrounds: requireGrounds
                )
            }
        }

        for (index, use) in world.uses.enumerated() {
            guard selection == nil || selection == .use(index) else { continue }
            let claim = try gatedForm(try parseTerm(Substring(use)), world)
            let matching = world.gates.filter { $0.head == claim.head }
            guard !matching.isEmpty else { continue }
            let bindings = try gateBindings(claim, world)
            for gate in matching {
                if requireGrounds { try requireProtocolGrounds([gate.proto], world) }
                for (left, right) in gate.equalities {
                    judged += 1
                    let leftTerm = try substitute(try parseTerm(Substring(left)), bindings)
                    let rightTerm = try substitute(try parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(try normalize(leftTerm, world))
                    let rightCanon = Press.serialize(try normalize(rightTerm, world))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(use)' requires the types '\(left)' (aka '\(leftCanon)') and "
                                + "'\(right)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
                        )
                    }
                }
                try judgeMemberships(
                    gate.memberships, site: use, tag: gate.proto,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals, requireGrounds: requireGrounds
                )
            }
        }

        for conformer in world.conformers.values.sorted(by: { $0.name < $1.name }) {
            guard selection == nil || selection == .conformer(conformer.name) else { continue }
            if requireGrounds { try requireProtocolGrounds(conformer.protocols, world) }
            let protocols = inheritedProtocols(conformer.protocols, world)
            let (bindings, rigid) = try conformerContext(conformer, world)
            // Membership inheritance and equality inheritance are the same
            // dependency closure. A child cannot discard a parent's gate.
            for protoName in protocols.sorted() {
                guard let gated = world.gatedProtocols[protoName] else { continue }
                for (left, right) in gated.equalities {
                    judged += 1
                    let leftTerm = try substitute(try parseTerm(Substring(left)), bindings)
                    let rightTerm = try substitute(try parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(try normalize(leftTerm, world, rigid: rigid))
                    let rightCanon = Press.serialize(try normalize(rightTerm, world, rigid: rigid))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(conformer.name): \(protoName)' requires the types '\(left)' "
                                + "(aka '\(leftCanon)') and '\(right)' (aka '\(rightCanon)') be equivalent"
                        )
                    }
                }
                try judgeMemberships(
                    gated.memberships, site: "\(conformer.name): \(protoName)", tag: nil,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals, rigid: rigid, requireGrounds: requireGrounds
                )
            }
        }

        if refusals.isEmpty && judged == 0 && members == 0 {
            if requireGrounds { throw Failure.open(["no equality or membership grounds for the selected application"]) }
            try fail("no equalities or memberships were judged; no certificate established")
        }
        return Judgment(equalities: judged, memberships: members, uses: world.uses.count,
                        excludesConditional: excludesConditional, refusals: refusals)
    }
}
