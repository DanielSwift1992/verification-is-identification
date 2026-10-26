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
        var table: NameMap<String>
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
        var writtenEqualities: [(String, String)]? = nil
        var writtenUnjudged: [String]? = nil
    }

    struct GatedProtocol {
        let name: String
        let equalities: [(String, String)]
        let memberships: [(String, String)]
        let unjudged: [String]
        var writtenEqualities: [(String, String)]? = nil
        var writtenUnjudged: [String]? = nil
    }

    /// Internal failures are data. Only the legacy CLI boundary writes to
    /// stderr and exits; callers can distinguish unread syntax from unavailable
    /// input without interpreting diagnostic text or a process exit status.
    enum Failure: Error {
        case unsupported([String])
        case input([String])
        case open([String])
        case refused([String])
        case empty([String])

        var messages: [String] {
            switch self {
            case let .unsupported(messages), let .input(messages), let .open(messages),
                 let .refused(messages), let .empty(messages): return messages
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
    static let directives: NameSet = [
        "if", "elseif", "else", "endif", "sourceLocation", "warning", "error",
        "available", "unavailable", "selector", "keyPath", "file", "fileID",
        "filePath", "line", "column", "function", "dsohandle", "isolation",
        "colorLiteral", "imageLiteral", "fileLiteral",
    ]
    static let attributes: NameSet = [
        "available", "frozen", "inlinable", "usableFromInline", "discardableResult",
        "inline", "retroactive", "preconcurrency", "unchecked", "escaping",
        "autoclosure", "Sendable", "MainActor", "objc", "nonobjc", "testable", "main",
        "unknown", "convention", "propertyWrapper", "resultBuilder",
        "dynamicMemberLookup", "dynamicCallable", "warn_unqualified_access",
        "_disfavoredOverload", "_exported", "_implementationOnly", "_spi",
        "_alwaysEmitIntoClient", "_transparent",
    ]

    // Swift has exactly three line-break spellings. Canonicalize before any
    // Character-based split: CRLF is one Character, not a Character LF.
    // This changes only the reader's view, never the source bytes or input hash.
    // Do not use isNewline: VT/FF/NEL/LS/PS must not end a Swift line comment.
    static func sourceLines(_ text: String) -> String {
        text.replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
    }

    static func blankCommentsAndStrings(_ text: String, lent: NameSet = []) throws -> String {
        do { return try lexicalReading(text, lent: lent, carrying: false).blanked }
        catch let error as LexicalFailure {
            try fail("cannot read line \(error.line): \(error.description)")
        }
    }

    // The names a read text declares as a result builder or a property
    // wrapper, with other attributes and modifiers allowed between the
    // declaring attribute and the type. An attribute of such a name adds no
    // conformance, so it is a form this court reads, in the text that
    // declares it and in a world that text is lent to.
    static func stripComments(_ text: String, lent: NameSet = []) throws -> String {
        try strippedReading(text, lent: lent).clean
    }

    static func strippedReading(_ text: String, lent: NameSet = [], notating: Bool = false)
        throws -> (clean: String, notation: [NotationToken]) {
        let reading: LexicalReading
        do { reading = try lexicalReading(text, lent: lent, carrying: false, notating: notating) }
        catch let error as LexicalFailure {
            try fail("cannot read line \(error.line): \(error.description)")
        }
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
        var notation: [NotationToken] = []
        var token = 0, oldOffset = 0, newOffset = 0
        func keepLine(_ line: Substring, included: Bool) {
            let length = line.utf16.count
            kept.append(included ? String(line) : "")
            while token < reading.notation.count, reading.notation[token].range.location < oldOffset + length {
                if included {
                    var value = reading.notation[token]
                    value.range.location += newOffset - oldOffset
                    notation.append(value)
                }
                token += 1
            }
            oldOffset += length + 1
            newOffset += (included ? length : 0) + 1
        }
        for (index, line) in reading.blanked
            .split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
            let bare = line.trimmingCharacters(in: .whitespaces)
            if bare.range(of: #"^#if\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0,
                   bare.range(of: #"^#if\s+(?!true$)[A-Za-z_][A-Za-z0-9_]*$"#, options: .regularExpression) == nil {
                    try fail("cannot read line \(index + 1): '\(bare)' is not a plain compilation flag, "
                        + "and this court omits only a block a compilation without its flag skips")
                }
                flaggedDepth += 1
                keepLine(line, included: false)
                continue
            }
            if bare.range(of: #"^#endif\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { try fail("unmatched #endif") }
                flaggedDepth -= 1
                keepLine(line, included: false)
                continue
            }
            if bare.range(of: #"^#(?:else|elseif)\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { try fail("conditional branch outside #if") }
                if flaggedDepth == 1 {
                    try fail("cannot read line \(index + 1): '\(bare)' opens a branch a compilation without "
                        + "the flag reads, and this court omits only a block that compilation skips")
                }
                keepLine(line, included: false)
                continue
            }
            keepLine(line, included: flaggedDepth == 0)
        }
        if flaggedDepth != 0 { try fail("unterminated #if block") }
        return (kept.joined(separator: "\n"), notation)
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

    // The original selected-application profile keeps its file-scope boundary.
    // The CLI's v0.4 notation additionally reads the bounded nested enum fragment
    // through NotationScope. Qualified declarations never rebind a file name.
    // Other local bindings and repeated identities remain conservative refusals.

    /// The brace depth and the line before each UTF-16 offset of the read
    /// text, the coordinates a regular expression match is reported in.
    struct Scope {
        var depth: [Int] = [0]
        var line: [Int] = [1]
        var qualified: [Int: String] = [:]
        var namespaces: NameSet = []

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
        let typeKeywords: NameSet = ["extension", "enum", "struct", "class", "actor", "protocol"]
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
            var groups: [String] = (1..<match.numberOfRanges).map { index in
                guard let bounds = Range(match.range(at: index), in: text) else { return "" }
                return String(text[bounds])
            }
            let start = match.range.location
            if let qualified = scope.qualified[start] { groups[0] = qualified }
            else if scope.depth[start] > 0 {
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
    static func declaredNames(_ text: String, _ scope: Scope, owners: NotationScope? = nil, source: String? = nil, lent: NameSet = []) throws
        -> (lines: NameMap<[Int]>, file: NameSet, parameters: NameMap<[Int]>) {
        let syntax = try NameDeclarationSyntax(text, lent: lent)
        let paths = syntax.ownerPaths()
        var lines = NameMap<[Int]>(), file = NameSet(), parameters = NameMap<[Int]>()
        for head in syntax.heads {
            let tape = syntax.tape
            let start = text.utf8.index(text.utf8.startIndex, offsetBy: tape.starts[head.keyword]).utf16Offset(in: text)
            let nominal = ["enum", "struct", "class", "actor", "protocol", "typealias", "associatedtype"].containsName(head.kind)
            if nominal {
                let spelled = tape.words[head.name]
                let lexical = owners == nil ? nil : paths.last { $0.open < head.keyword && head.keyword < $0.end }
                let name = scope.qualified[start] ?? lexical.map { ($0.names + [spelled]).joined(separator: ".") } ?? spelled
                lines[name, default: []].append(tape.lines[head.keyword])
                if scope.qualified[start] != nil || (scope.depth[start] == 0 && ["enum", "protocol", "typealias"].containsName(head.kind)) { file.insert(name) }
            }
            for token in head.parameters
            where !sameName(head.kind, "protocol") {
                let bare = tape.words[token]
                parameters[bare, default: []].append(tape.lines[token])
                if WhereJudge.sameName(head.kind, "enum"), scope.depth[start] == 0, scope.namespaces.contains(bare) { continue }
                // Function parameters belong to the function, not its nominal
                // container. The binding index uses these same lexical heads.
                let parent = paths.last { $0.open < head.keyword && head.keyword < $0.end }?.names.joined(separator: ".")
                let owner = [parent, head.spelling].compactMap { $0 }.joined(separator: ".")
                let name = owners == nil ? bare : owner + "." + bare
                lines[name, default: []].append(tape.lines[token])
            }
        }
        return (lines.mapValues { $0.sorted() }, file, parameters)
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
    static func readAliases(_ text: String, lent: NameSet = []) throws -> [[String]] {
        try readAliasSpans(text, lent: lent).map(\.fields)
    }

    // The same aliases, each with the range of its right side in the read
    // text's UTF-16 coordinates.
    static func readAliasSpans(_ text: String, lent: NameSet = []) throws -> [(fields: [String], body: NSRange, declaration: NSRange)] {
        try NameDeclarationSyntax(text, lent: lent).aliases(in: text)
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
        var contextual = false
        var reservedParameters: NameMap<[Int]> = [:]
        var contextSpellings: NameMap<String> = [:]
        var contextNameBindings: ContextNameBinding.Index?
        var contextNameBindingCertificate: ContextNameBinding.Certificate?
        var contextVersion = 1
        var contextSource = ""
        var contextUnresolved: [String] = []
        var excludedDefinitions: [String] = []
        var addresses: NameMap<String> = [:]
        var contextConformers: NameSet = []
        var namespaces: NameSet = []
        var nestedNames: NameSet = []
        var intrinsicSwift = false
        var conformers: NameMap<Conformer> = [:]
        var aliases: NameMap<AliasRule> = [:]
        var gates: [GatedExtension] = []
        var gatedProtocols: NameMap<GatedProtocol> = [:]
        var protocolParents: NameMap<[String]> = [:]
        var protocolAxes: NameMap<NameSet> = [:]
        var parameters: NameMap<[String]> = [:]
        var genericRequirements: NameMap<[StructuralSource.Requirement]> = [:]
        var genericUnsupported: NameMap<[String]> = [:]
        var conditionalDeclarations: NameSet = []
        var presentedBodies: NameSet = []
        var uses: [String] = []
        var useLines: [Int] = []
        var certificateLines: NameMap<Int> = [:]
        /// Uses and parameterless certificates are judged at their root.
        /// A parsed range does not discharge a gate nested inside that root.
        var rootApplicationSpans: [NSRange] = []
        /// the lines each name of this file is declared at, in any scope
        var declared: NameMap<[Int]> = [:]
        /// the lines at which this file extends each name, in any form
        var extensions: NameMap<[Int]> = [:]
        /// the names this file declares at file scope as a type, a protocol
        /// or a typealias: the names another file's extension can reach
        var fileTypes: NameSet = []
        /// every name this file's code spells
        var names: NameSet = []
        /// the read text, the line before each of its UTF-16 offsets, the
        /// ranges this court reads as uses, certificates and gate clauses,
        /// and the right sides of the typealiases at file scope
        var clean = ""
        var notation: [NotationToken] = []
        var lineAt: [Int] = []
        var readSpans: [NSRange] = []
        var aliasSpans: [NSRange] = []
    }

    static func read(_ text: String, lent: NameSet = [], notationV2: Bool = true,
                     contextV2: Bool = false, source: String? = nil,
                     bindingView: Bool = false) throws -> World {
        let reading = try strippedReading(text, lent: lent, notating: true)
        let clean = reading.clean
        var scope = Scope(clean)
        let notation = try NotationScope(clean, enabled: notationV2)
        scope.qualified = notation.nested
        scope.namespaces = notation.namespaces
        var world = World()
        world.namespaces = notation.namespaces
        world.nestedNames = NameSet(notation.nested.values)
        world.intrinsicSwift = notationV2 ? try NotationScope.intrinsic(clean, version: contextV2 ? 2 : 1) : false

        // Use the same Unicode word class as the declaration reader. A name
        // it reads cannot disappear when checking which gates reach the file.
        world.names = NameSet(captures(#"\b(\w+)\b"#, clean).map { $0[0] })
        let names = try declaredNames(clean, scope, owners: notationV2 ? notation : nil, source: source, lent: lent)
        world.declared = names.lines
        world.reservedParameters = names.parameters
        if world.intrinsicSwift {
            for name in ["Swift", "Never"] + (contextV2 ? ["String"] : []) {
                if let line = (names.lines[name] ?? names.parameters[name])?.first {
                    try fail("cannot read line \(line): declaration '\(name)' conflicts with intrinsic Swift/\(contextV2 ? 2 : 1)")
                }
            }
        }
        for name in names.file.sorted(by: { (names.lines[$0]![0], $0) < (names.lines[$1]![0], $1) })
        where !notationV2 && names.lines[name]!.count > 1 {
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
            var table: NameMap<String> = [:]
            for aliasHit in try readAliases(hit[3], lent: lent)
            where aliasHit[1].isEmpty {
                guard table[aliasHit[0]] == nil else {
                    try fail("duplicate definition of '\(name).\(aliasHit[0])'")
                }
                table[aliasHit[0]] = try notation.resolve(aliasHit[2], in: name, excluding: NameSet(parameters + ["Self"] + (try readAliases(hit[3], lent: lent)).map { $0[0] }))
            }
            world.conformers[name] = Conformer(
                name: name, parameters: parameters, protocols: protocols, table: table
            )
        }

        for hit in try declarations(#"enum\s+(\w+)\s*<([^>]*)>"#, clean, scope) {
            world.parameters[hit[0]] = parameterNames(hit[1])
        }

        if contextV2 {
            for declaration in try notation.structural(clean, origin: "source", lent: lent) {
                guard declaration.kind == "enum", !notation.namespaces.contains(declaration.name) else { continue }
                world.genericRequirements[declaration.name] = declaration.requirements
                world.genericUnsupported[declaration.name] = declaration.unsupported
                if declaration.unsupported.isEmpty {
                    world.conformers[declaration.name] = Conformer(name: declaration.name,
                        parameters: declaration.parameters, protocols: declaration.parents, table: declaration.fields)
                    world.parameters[declaration.name] = declaration.parameters
                    world.conditionalDeclarations.remove(declaration.name)
                }
            }
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
                for aliasHit in try readAliases(hit[1], lent: lent)
                where aliasHit[1].isEmpty {
                    guard world.conformers[name]!.table[aliasHit[0]] == nil else {
                        try fail("duplicate definition of '\(name).\(aliasHit[0])'")
                    }
                    world.conformers[name]!.table[aliasHit[0]] = aliasHit[2]
                }
            }
        }

        let fileType = try! NSRegularExpression(pattern: #"\b(?:enum|struct|class|actor|protocol|typealias)\s+(\w+)"#)
        for match in fileType.matches(in: clean, range: NSRange(clean.startIndex..., in: clean))
        where scope.depth[match.range.location] == 0 || scope.qualified[match.range.location] != nil {
            if let bounds = Range(match.range(at: 1), in: clean) { world.fileTypes.insert(notation.name(String(clean[bounds]), at: match.range.location)) }
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
                // This preliminary view supplies declaration places to the
                // context binder. The replayed binding, not this scan, selects
                // the extension owner before the bound view is read again.
                if bindingView {
                    world.extensions[spelled, default: []].append(line)
                    continue
                }
                // A context/2 definition may lend an empty implementation
                // extension of a declared nested type. Declaration-bearing or
                // constrained extensions still require their existing reader.
                var end = cursor
                while end < cleanUnits.count, isSpaceUnit(cleanUnits[end]) { end += 1 }
                if contextV2, world.nestedNames.contains(spelled), end < cleanUnits.count, cleanUnits[end] == 0x7B {
                    end += 1
                    while end < cleanUnits.count, isSpaceUnit(cleanUnits[end]) { end += 1 }
                    if end < cleanUnits.count, cleanUnits[end] == 0x7D {
                        world.extensions[spelled, default: []].append(line)
                        continue
                    }
                }
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

        for hit in try readAliases(try outsideBodies(clean), lent: lent) {
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
            .sorted()
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
            world.protocolAxes[hit[0]] = NameSet(captures(#"associatedtype\s+(\w+)"#, hit[1]).map { $0[0] })
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
        for span in try readAliasSpans(try outsideBodies(clean), lent: lent) {
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
            for span in try readAliasSpans(String(clean[bounds]), lent: lent)
            where span.fields[1].isEmpty {
                world.certificateLines[notation.name(String(clean[owner]), at: spans[0].location) + "." + span.fields[0]] = scope.line[table.location + span.declaration.location]
                read.append(NSRange(location: table.location + span.body.location, length: span.body.length))
                world.rootApplicationSpans.append(NSRange(location: table.location + span.body.location, length: span.body.length))
            }
        }
        for spans in try declarationSpans(
            #"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}"#, clean, scope
        ) {
            guard let owner = Range(spans[0], in: clean), world.conformers[String(clean[owner])] != nil,
                  let bounds = Range(spans[1], in: clean) else { continue }
            for span in try readAliasSpans(String(clean[bounds]), lent: lent)
            where span.fields[1].isEmpty {
                world.certificateLines[notation.name(String(clean[owner]), at: spans[0].location) + "." + span.fields[0]] = scope.line[spans[1].location + span.declaration.location]
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
        world.notation = reading.notation
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

    static func substitute(_ term: Term, _ bindings: NameMap<Term>) throws -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let values = try bindings.mapValues {
                try DefinitionReduction.parse(Press.serialize($0), allowRigidNames: true)
            }
            return try expression.substituting(values).legacy
        } catch { try fail("cannot substitute term: \(error)") }
    }

    static func normalize(_ term: Term, _ world: World, rigid: NameSet = []) throws -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            return try DefinitionReduction.normalForm(expression, source: source).output.legacy
        } catch { try fail("unresolved definition reduction: \(error)") }
    }

    static func canon(_ text: String, _ world: World) throws -> String {
        Press.serialize(try normalize(try parseTerm(Substring(text)), world))
    }

    /// Same nominal equations, with the count reader's shared derivations.
    /// Neither a count nor identical input spelling is an equality proof.
    static func compared(_ left: Term, _ right: Term, _ world: World,
                         rigid: NameSet = []) throws -> (equal: Bool, left: String, right: String) {
        if world.contextVersion != 2 {
            let l = Press.serialize(try normalize(left, world, rigid: rigid))
            let r = Press.serialize(try normalize(right, world, rigid: rigid))
            return (sameName(l, r), l, r)
        }
        do {
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            let work = DefinitionReduction.Work(10_000, phase: "definition construction")
            let builder = DefinitionReduction.SharedBuilder(source: source, work: work, depthLimit: 64)
            let l = try builder.arena.read(DefinitionReduction.parse(Press.serialize(left), allowRigidNames: true))
            let r = try builder.arena.read(DefinitionReduction.parse(Press.serialize(right), allowRigidNames: true))
            let lp = try builder.derive(l)
            let rp = try builder.derive(r)
            let replay = try DefinitionReduction.replayShared(builder.proof, source: source,
                work: DefinitionReduction.Work(20_000, phase: "definition replay"))
            guard replay.ends[lp].input == replay.terms[l], replay.ends[rp].input == replay.terms[r] else {
                try fail("definition equality changes its original question")
            }
            let lo = replay.ends[lp].output, ro = replay.ends[rp].output
            if lo == ro { return (true, "", "") }
            return (false, replay.arena.text(lo), replay.arena.text(ro))
        } catch { try fail("unresolved definition reduction: \(error)") }
    }

    // A claim meets the gate its definition names. A head spelled through an
    // alias or a member alias is unfolded before the gate is looked up, so an
    // intermediate name cannot carry a claim past its gate. A nominal head is
    // already the name a gate is looked up by, and a world that presents no
    // gate has no lookup to prepare. The gate itself reads the arguments.
    static func gatedForm(_ term: Term, _ world: World, rigid: NameSet = []) throws -> Term {
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

    static func inheritedProtocols(_ protocols: [String], _ world: World) -> NameSet {
        var seen = NameSet()
        var pile = protocols
        while let name = pile.popLast() {
            if seen.insert(name).inserted {
                pile.append(contentsOf: world.protocolParents[name] ?? [])
            }
        }
        return seen
    }

    static func conformerContext(_ conformer: Conformer, _ world: World) throws
        -> (bindings: NameMap<Term>, rigid: NameSet) {
        guard NameSet(conformer.parameters).count == conformer.parameters.count else {
            try fail("cannot bind conformer '\(conformer.name)': duplicate generic parameters")
        }
        // Alpha-rename bound parameters outside the source identifier grammar.
        // No nominal declaration or alias may supply a value for a free
        // parameter merely by sharing its spelling.
        let variables = conformer.parameters.indices.map {
            Term(head: "$free_\(conformer.name)_\($0)", args: [])
        }
        let owner = Term(head: conformer.name, args: variables)
        let rigid = NameSet(variables.map { $0.head })
        var bindings = NameMap(uniqueKeysWithValues: zip(conformer.parameters, variables))
        bindings["Self"] = owner
        var axes = NameSet(conformer.table.keys)
        for proto in inheritedProtocols(conformer.protocols, world) {
            axes.formUnion(world.protocolAxes[proto] ?? [])
        }
        for axis in axes
        where !conformer.parameters.containsName(axis) {
            bindings[axis] = Term(head: Press.serialize(owner) + "." + axis, args: [])
        }
        return (bindings, rigid)
    }

    // A question's formal parameters must be bound by this actual application.
    // zip alone would leave missing parameters free to resolve as global names.
    // A declaration with zero parameters still has obligations to discharge.
    static func gateBindings(_ term: Term, _ world: World) throws -> NameMap<Term> {
        guard let parameters = world.parameters[term.head] ?? world.conformers[term.head]?.parameters else {
            try fail("cannot bind gate '\(term.head)': no declaration parameters were read")
        }
        guard parameters.count == term.args.count, NameSet(parameters).count == parameters.count else {
            try fail("cannot bind gate '\(term.head)': expected \(parameters.count) distinct arguments, received \(term.args.count)")
        }
        var bindings = NameMap(uniqueKeysWithValues: zip(parameters, term.args))
        bindings["Self"] = term
        if let owner = world.conformers[term.head] {
            var axes = NameSet(owner.table.keys)
            for proto in inheritedProtocols(owner.protocols, world) {
                axes.formUnion(world.protocolAxes[proto] ?? [])
            }
            for axis in axes
            where bindings[axis] == nil {
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
        bindings: NameMap<Term>, world: World,
        counted: inout Int, refusals: inout [String], rigid: NameSet = [],
        requireGrounds: Bool = false
    ) throws {
        let mark = tag.map { " [\($0)]" } ?? ""
        for (lhs, proto) in memberships {
            if requireGrounds { try requireProtocolGrounds([proto], world) }
            counted += 1
            let lhsTerm = try substitute(try parseTerm(Substring(lhs)), bindings)
            let resolved = world.contextVersion == 2
                ? try GenericMembership.head(lhsTerm, world: world, rigid: rigid)
                : try normalize(lhsTerm, world, rigid: rigid)
            let spelled = Press.serialize(resolved)
            if world.contextVersion == 2 && (!resolved.args.isEmpty || resolved.head.contains("$free_")) {
                refusals += try GenericMembership.check(resolved, proto: proto, site: site,
                    world: world, rigid: rigid, counted: &counted)
                continue
            }
            if world.conformers[resolved.head] == nil, world.presentedBodies.contains(resolved.head) {
                try fail("cannot read declaration '\(resolved.head)': its body is outside this court's flat-definition fragment")
            }
            guard resolved.args.isEmpty else {
                try fail("cannot judge membership of '\(spelled)' in '\(proto)' required by '\(site)': "
                    + "generic applicability is not established by this membership reader")
            }
            guard let wearer = world.conformers[resolved.head] else {
                if world.contextual {
                    let root = site.components(separatedBy: ": ").first ?? site
                    try fail("\(world.addresses[root] ?? world.contextSource + ":1"): no declared conformance grounds for '\(spelled)' required by '\(site)'")
                }
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
                if let gated = inherited.sorted().first(
                where: { world.gatedProtocols[$0] != nil }) {
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
        var excludedDefinitions: [String] = []
    }

    /// The original text/exit interface is retained at this single boundary.
    static func run(_ arguments: [String]) {
        do {
            let result = try judge(arguments)
            if result.refusals.isEmpty {
                if result.excludesConditional {
                    print("THE WHERE scope: conditional compilation blocks are excluded.")
                }
                if !result.excludedDefinitions.isEmpty {
                    print("THE WHERE scope: borrowed value declarations are outside this reading: " + result.excludedDefinitions.joined(separator: ", ") + ".")
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
        } catch let failure as StructuralSource.AddressedFailure {
            FileHandle.standardError.write(Data("✗ THE WHERE: \(failure.description)\n".utf8))
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
        let ownAliases: NameMap<AliasRule>
        let excludesConditional: Bool
        // The context's replayed binding projection, shared with numerical IR.
        var boundFiles: [CourtNotation.File] = []
    }

    enum Selection: Equatable {
        case certificate(String)
        case use(Int)
        case conformer(String)
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.certificate(a), .certificate(b)), let (.conformer(a), .conformer(b)): return sameName(a, b)
            case let (.use(a), .use(b)): return a == b
            default: return false
            }
        }
    }

    static func fileText(_ path: String) throws -> String {
        guard let bytes = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            throw Failure.input(["cannot read \(path)"])
        }
        // Foundation's text-file initializer consumes a UTF-8 BOM. The context
        // binds the original bytes, before the notation reader takes its view.
        let text = String(decoding: bytes, as: UTF8.self)
        guard Data(text.utf8) == bytes else {
            throw Failure.input(["cannot read \(path)"])
        }
        return text
    }

    static func judge(_ arguments: [String]) throws -> Judgment {
        try evaluate(prepare(arguments))
    }

    static func prepare(_ arguments: [String],
                        notationV2: Bool = true, load: (String) throws -> String = fileText) throws -> Prepared {
        if let at = arguments.firstIndex(of: "--context") {
            guard notationV2, at + 1 < arguments.count, arguments.filter({ $0 == "--context" }).count == 1 else {
                throw Failure.input(["unsupported, duplicate or incomplete --context argument"])
            }
            var paths = arguments
            let contextPath = paths.remove(at: at + 1)
            paths.remove(at: at)
            return try WhereContext.prepare(paths, contextPath: contextPath, load: load)
        }
        guard let path = arguments.first else {
            throw Failure.input(["usage: judge where <world.swift> [definitions.swift ...]"])
        }
        let original = try arguments.map { ($0, try load($0)) }
        try checkWordSpellings(original)
        let text = original[0].1
        // A definitions file that declares a result builder or a property
        // wrapper lends that attribute to the world the way it lends its
        // typealiases: the declaration supplies the premise that the
        // attribute adds no conformance. A definitions file this scan cannot
        // read lends nothing here; it is refused below, in its turn.
        let lentBuilders = NameSet(original.dropFirst().flatMap { _, more -> NameSet in
            guard let clean = try? stripComments(more) else { return [] }
            return (try? declaredBuilders(clean)) ?? []
        })
        var world = try read(text, lent: lentBuilders, notationV2: notationV2)
        var excludesConditional = sourceLines(text).range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
        // Extra files supply alias definitions, not a second version of the
        // same source. This flat reader has no module-resolution rule with
        // which to choose between duplicates, so a collision is unresolved.
        var aliasOrigins = NameMap(uniqueKeysWithValues: world.aliases.keys.map { ($0, path) })
        var extras: [(path: String, text: String, world: World)] = try original.dropFirst().map { extra, more in
            return (extra, more, try read(more, notationV2: notationV2))
        }
        var nameFiles: [CourtNotation.File] = []
        if notationV2 {
            let inputs = [(path: path, text: text, world: world)] + extras
            let builders = try inputs.reduce(into: NameSet()) {
                $0.formUnion(try declaredBuilders($1.world.clean))
            }
            for input in inputs {
                let tape = try lexicalReading(input.world.clean, scope: .notation,
                    lent: builders, carrying: true).tape
                for i in tape.words.indices
                where sameName(tape.words[i], "import") {
                    let target = tape.words.indices.dropFirst(i + 1).first { !sameName(tape.words[$0], "\n") }
                    guard let target, sameName(tape.words[target], "Swift") else {
                        try fail("\(input.path):\(tape.lines[i]): a non-intrinsic import requires a declared source context")
                    }
                }
            }
            let files = try inputs.map { value -> CourtNotation.File in
                let source = CourtContext.Source(input: value.path, source: value.path,
                    sha256: courtSHA256(Data(value.text.utf8)), namespace: "", module: "", role: "own",
                    imports: [], at: [:], importAddresses: [])
                return CourtNotation.File(context: source, text: value.text, view: value.world.clean, world: value.world,
                    notation: try NotationScope(value.world.clean), excluded: nil, unchecked: [])
            }
            let resolution = try WhereContextNames.resolve(files, selected: path, version: 1)
            nameFiles = resolution.files
            world = resolution.files[0].world
            for file in resolution.files {
                for name in file.world.fileTypes {
                    world.addresses[name] = file.context.source + ":\(file.world.declared[name]?.first ?? 1)"
                }
                for (name, line) in file.world.certificateLines { world.addresses[name] = file.context.source + ":\(line)" }
            }
            world.contextNameBindings = resolution.nameBindings
            world.contextNameBindingCertificate = resolution.nameBindings?.certificate
            extras = zip(extras, resolution.files.dropFirst()).map { old, new in (old.path, old.text, new.world) }
        }
        let ownAliases = world.aliases
        if notationV2, world.intrinsicSwift || extras.contains(
        where: { $0.world.intrinsicSwift }) {
            for file in [(path: path, world: world)] + extras.map({ (path: $0.path, world: $0.world) }) {
                for name in ["Swift", "Never"] {
                    if let line = (file.world.declared[name] ?? file.world.reservedParameters[name])?.first {
                        try fail("cannot read line \(line) of '\(file.path)': declaration '\(name)' conflicts with intrinsic Swift/1")
                    }
                }
            }
            world.intrinsicSwift = true
        }
        // A typealias of any file may be extended from another, and such an
        // extension extends the alias's type, through the alias, as well.
        var anyAlias = NameSet(world.aliases.keys)
        for extra in extras { anyAlias.formUnion(extra.world.aliases.keys) }
        let worldThroughAlias = world.extensions
            .filter { anyAlias.contains($0.key) }
            .sorted()
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
            for gate in extra.world.gates
            where world.names.contains(gate.head) {
                try fail("cannot read the gate '\(gate.head): \(gate.proto)' in '\(extra.path)': this court judges "
                    + "the gates of the world it reads, and '\(path)' names '\(gate.head)'")
            }
            let gated = NameSet(extra.world.gatedProtocols.keys)
            guard !gated.isEmpty else { continue }
            for name in world.names.sorted() {
                var reached: NameSet = []
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
                || sourceLines(more).range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
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
                .sorted()
            if let first = extendsWorld.first {
                try fail("cannot read '\(first.key)': '\(extra)' extends it at \(spelledLines(first.value)), and this court "
                    + "cannot tell that the extension is this world's type, or that its members reach this file")
            }
            for (name, rule) in lent.aliases.sorted() {
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
        if notationV2 {
            for extra in extras {
                for name in extra.world.nestedNames.sorted() {
                    guard !world.nestedNames.contains(name), world.conformers[name] == nil else {
                        try fail("ambiguous definition of '\(name)' in '\(path)' and '\(extra.path)'")
                    }
                    if let value = extra.world.conformers[name] { world.conformers[name] = value }
                    if extra.world.presentedBodies.contains(name) { world.presentedBodies.insert(name) }
                    world.nestedNames.insert(name)
                }
                world.namespaces.formUnion(extra.world.namespaces)
            }
            try WhereContextNames.members(nameFiles, in: world)
            try WhereContextNames.closedNames(nameFiles, in: world)
        }
        return try finish(path: path, world: world, ownAliases: ownAliases,
                          excludesConditional: excludesConditional, extras: extras)
    }

    static func finish(path: String, world: World, ownAliases: NameMap<AliasRule>,
                       excludesConditional: Bool, extras: [(path: String, text: String, world: World)]) throws -> Prepared {
        if !world.contextual {
            try WhereContextNames.aliasCycles(world, names: NameSet(world.aliases.keys), source: path)
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
        var gatedNames = NameSet(world.gates.map(\.head))
        var grown = true
        while grown {
            grown = false
            for (name, rule) in world.aliases.sorted()
            where !gatedNames.contains(name) {
                let spelled = NameSet(captures(#"\b(\w+)\b"#, rule.body).map { $0[0] })
                if !spelled.isDisjoint(with: gatedNames) {
                    gatedNames.insert(name)
                    grown = true
                }
            }
        }
        for extra in extras {
            for (name, rule) in extra.world.aliases.sorted()
            where rule.parameters.isEmpty {
                if gatedNames.contains(name), !world.contextual {
                    try fail("cannot read '\(name)': '\(extra.path)' defines it as an application of a gated head, and "
                        + "this court judges certificates in the world it reads")
                }
            }
        }
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
            let names = NameSet(captures(#"\b(\w+)\b"#, spelled).map { $0[0] })
            guard !names.isDisjoint(with: gatedNames) else { continue }
            let term = try parseTerm(Substring(spelled))
            let claim = try gatedForm(term, world)
            let arguments = (term.args + claim.args).map(Press.serialize).joined(separator: ",")
            let nested = NameSet(captures(#"\b(\w+)\b"#, arguments).map { $0[0] }).intersection(gatedNames)
            if !nested.isEmpty || !world.gates.contains(
            where: { sameName($0.head, claim.head) }) {
                let line = world.lineAt[span.location]
                unreadPlaces.append((line, "cannot read line \(line) of '\(path)': '\(spelled)' contains "
                    + "a gated application outside the root this court judges"))
            }
        }
        let unreadHeads = UnreadHeads(gatedNames)
        func unread(_ file: World, _ spans: [NSRange], _ spelledPath: String) {
            let result = unreadApplications(file, spans: spans, heads: unreadHeads)
            let places = result.applications.map { application in
                let reason = application.multilineMetatype
                    ? "a use written across lines, which this court reads on one line"
                    : "a place where this court reads no use and no certificate"
                let line = file.lineAt[application.at]
                return (line: line, message: "cannot read line \(line) of '\(spelledPath)': '\(application.name)' "
                    + "applies a gated head in \(reason)")
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
        func written(_ text: String) -> String {
            prepared.world.contextSpellings.sorted { $0.key.utf8.count > $1.key.utf8.count }
                .reduce(text) { result, entry in
                    entry.key.hasPrefix("__courtContext")
                        ? result.replacingOccurrences(of: entry.key, with: entry.value)
                        : result.replacingOccurrences(of: "'" + entry.key + "'", with: "'" + entry.value + "'")
                }
        }
        do {
            let result = try evaluateBound(prepared, selection: selection, requireGrounds: requireGrounds)
            return Judgment(equalities: result.equalities, memberships: result.memberships, uses: result.uses,
                excludesConditional: result.excludesConditional, refusals: result.refusals.map(written),
                excludedDefinitions: result.excludedDefinitions)
        } catch let failure as Failure {
            let messages = failure.messages.map(written)
            switch failure {
            case .unsupported: throw Failure.unsupported(messages)
            case .input: throw Failure.input(messages)
            case .open: throw Failure.open(messages)
            case .refused: throw Failure.refused(messages)
            case .empty: throw Failure.empty(messages)
            }
        }
    }

    private static func evaluateBound(_ prepared: Prepared, selection: Selection?,
                                      requireGrounds: Bool) throws -> Judgment {
        let world = prepared.world
        if let proof = world.contextNameBindings {
            guard let certificate = world.contextNameBindingCertificate else {
                try fail("name binding certificate is missing")
            }
            try proof.replay(certificate)
        }
        let ownAliases = prepared.ownAliases
        let excludesConditional = prepared.excludesConditional
        var refusals: [String] = []
        var judged = 0
        var members = 0

        // a gate that carries what no court here judges is named at once:
        // the defect is the law's own spelling, not any use of it
        for gate in world.gates {
            for part in gate.writtenUnjudged ?? gate.unjudged {
                refusals.append(
                    "the gate '\(gate.head): \(gate.proto)' carries '\(part)', "
                        + "a conjunct this court does not judge"
                )
            }
        }
        for gated in world.gatedProtocols.values.sorted(by: { $0.name < $1.name }) {
            for part in gated.writtenUnjudged ?? gated.unjudged {
                refusals.append(
                    "the gated protocol '\(gated.name)' carries '\(part)', "
                        + "a conjunct this court does not judge"
                )
            }
        }

        // A typealias certificate is a judged point: a parameterless alias in the
        // world whose right side names a gated head states the gate's equalities
        // for those arguments, and the refusal names the certificate.
        var certificates: [(name: String, term: Term, rigid: NameSet)] = try ownAliases
            .filter { $0.value.parameters.isEmpty }
            .map { ($0.key, try parseTerm(Substring($0.value.body)), []) }
        // A local certificate is still checked, but in its actual owner.
        // Removing it from the global namespace must not remove its obligation.
        for conformer in world.conformers.values
        where !world.contextual || world.contextConformers.contains(conformer.name) {
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
            let matching = world.gates.filter { sameName($0.head, claim.head) }
            guard !matching.isEmpty else { continue }
            let bindings = try gateBindings(claim, world)
            for gate in matching {
                if requireGrounds { try requireProtocolGrounds([gate.proto], world) }
                for (equation, pair) in gate.equalities.enumerated() {
                    let (left, right) = pair
                    let (writtenLeft, writtenRight) = gate.writtenEqualities?[equation] ?? pair
                    judged += 1
                    let leftTerm = try substitute(try parseTerm(Substring(left)), bindings)
                    let rightTerm = try substitute(try parseTerm(Substring(right)), bindings)
                    let comparison = try compared(leftTerm, rightTerm, world, rigid: certificate.rigid)
                    let leftCanon = comparison.left, rightCanon = comparison.right
                    if !comparison.equal {
                        refusals.append(
                            "'\(name) = \(body)' requires the types '\(writtenLeft)' (aka '\(leftCanon)') and "
                                + "'\(writtenRight)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
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
            let matching = world.gates.filter { sameName($0.head, claim.head) }
            guard !matching.isEmpty else { continue }
            let bindings = try gateBindings(claim, world)
            for gate in matching {
                if requireGrounds { try requireProtocolGrounds([gate.proto], world) }
                for (equation, pair) in gate.equalities.enumerated() {
                    let (left, right) = pair
                    let (writtenLeft, writtenRight) = gate.writtenEqualities?[equation] ?? pair
                    judged += 1
                    let leftTerm = try substitute(try parseTerm(Substring(left)), bindings)
                    let rightTerm = try substitute(try parseTerm(Substring(right)), bindings)
                    let comparison = try compared(leftTerm, rightTerm, world)
                    let leftCanon = comparison.left, rightCanon = comparison.right
                    if !comparison.equal {
                        refusals.append(
                            "'\(use)' requires the types '\(writtenLeft)' (aka '\(leftCanon)') and "
                                + "'\(writtenRight)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
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
            guard !world.contextual || world.contextConformers.contains(conformer.name) else { continue }
            guard selection == nil || selection == .conformer(conformer.name) else { continue }
            if requireGrounds { try requireProtocolGrounds(conformer.protocols, world) }
            let protocols = inheritedProtocols(conformer.protocols, world)
            let (bindings, rigid) = try conformerContext(conformer, world)
            // Membership inheritance and equality inheritance are the same
            // dependency closure. A child cannot discard a parent's gate.
            for protoName in protocols.sorted() {
                guard let gated = world.gatedProtocols[protoName] else { continue }
                for (equation, pair) in gated.equalities.enumerated() {
                    let (left, right) = pair
                    let (writtenLeft, writtenRight) = gated.writtenEqualities?[equation] ?? pair
                    judged += 1
                    let leftTerm = try substitute(try parseTerm(Substring(left)), bindings)
                    let rightTerm = try substitute(try parseTerm(Substring(right)), bindings)
                    let comparison = try compared(leftTerm, rightTerm, world, rigid: rigid)
                    let leftCanon = comparison.left, rightCanon = comparison.right
                    if !comparison.equal {
                        refusals.append(
                            "'\(conformer.name): \(protoName)' requires the types '\(writtenLeft)' "
                                + "(aka '\(leftCanon)') and '\(writtenRight)' (aka '\(rightCanon)') be equivalent"
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

        if refusals.isEmpty && world.contextual && !world.contextUnresolved.isEmpty {
            try failAll(world.contextUnresolved)
        }
        if refusals.isEmpty && judged == 0 && members == 0 {
            if requireGrounds { throw Failure.open(["no equality or membership grounds for the selected application"]) }
            if world.contextVersion == 2 { throw Failure.empty([]) }
            try fail("no equalities or memberships were judged; no certificate established")
        }
        return Judgment(equalities: judged, memberships: members, uses: world.uses.count,
                        excludesConditional: excludesConditional, refusals: refusals, excludedDefinitions: world.excludedDefinitions)
    }
}
