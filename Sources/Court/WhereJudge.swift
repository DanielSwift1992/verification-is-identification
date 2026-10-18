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

    static func fail(_ message: String) -> Never {
        FileHandle.standardError.write(Data("✗ THE WHERE: \(message)\n".utf8))
        exit(2)
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

    static func blankCommentsAndStrings(_ text: String) -> String {
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
        func refuse(_ reason: String) -> Never {
            fail("cannot read line \(line): \(reason)")
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
                    fail("unterminated string literal")
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
                        refuse("a slash with no whitespace after it may open a regular "
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
                        refuse("a regular expression literal is not among the forms this court reads")
                    } else {
                        let spelled = name(after: 1)
                        if !directives.contains(spelled) {
                            refuse("the macro '#\(spelled)' is not among the forms this court reads")
                        }
                        keep(1)
                    }
                } else if current == "@" {
                    let spelled = name(after: 1)
                    if !attributes.contains(spelled) { unreadAttributes.append((spelled, line)) }
                    keep(1)
                } else if current == "`" {
                    refuse("a backquoted identifier is not among the forms this court reads")
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
        case .comment: fail("unterminated block comment")
        case .string: fail("unterminated string literal")
        case let .code(interpolated, _):
            if interpolated { fail("unterminated string interpolation") }
        }
        let read = String(kept)
        let declared = Set(captures(
            #"@(?:resultBuilder|propertyWrapper)\s+(?:(?:@\w+(?:\([^()]*\))?|public|internal|fileprivate"#
                + #"|private|package|open|final|indirect)\s+)*(?:struct|enum|class|actor)\s+(\w+)"#, read
        ).map { $0[0] })
        let undeclared = unreadAttributes.filter { declared.contains($0.name) == false }
        if let use = undeclared.first {
            fail("cannot read line \(use.line): the attribute '@\(use.name)' "
                + "is not among the forms this court reads")
        }
        return read
    }

    static func stripComments(_ text: String) -> String {
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
        for (index, line) in blankCommentsAndStrings(text)
            .split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
            let bare = line.trimmingCharacters(in: .whitespaces)
            if bare.range(of: #"^#if\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0,
                   bare.range(of: #"^#if\s+(?!true$)[A-Za-z_][A-Za-z0-9_]*$"#, options: .regularExpression) == nil {
                    fail("cannot read line \(index + 1): '\(bare)' is not a plain compilation flag, "
                        + "and this court omits only a block a compilation without its flag skips")
                }
                flaggedDepth += 1
                kept.append("")
                continue
            }
            if bare.range(of: #"^#endif\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { fail("unmatched #endif") }
                flaggedDepth -= 1
                kept.append("")
                continue
            }
            if bare.range(of: #"^#(?:else|elseif)\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { fail("conditional branch outside #if") }
                if flaggedDepth == 1 {
                    fail("cannot read line \(index + 1): '\(bare)' opens a branch a compilation without "
                        + "the flag reads, and this court omits only a block that compilation skips")
                }
                kept.append("")
                continue
            }
            kept.append(flaggedDepth > 0 ? "" : String(line))
        }
        if flaggedDepth != 0 { fail("unterminated #if block") }
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
    // around it: a brace opens one when the last declaring keyword before it,
    // since the previous brace or semicolon, names a type or an extension.
    static func typeBodies(_ text: String) -> [Int] {
        let keyword = try! NSRegularExpression(
            pattern: #"\b(extension|enum|struct|class|actor|protocol|func|init|deinit|subscript|var|let"#
                + #"|get|set|willSet|didSet|if|else|for|while|repeat|switch|case|default|do|catch|guard|defer)\b"#
        )
        let units = Array(text.utf16)
        var depth: [Int] = [0]
        var opened: [Bool] = []
        var segmentStart = 0
        for (offset, unit) in units.enumerated() {
            var current = depth[depth.count - 1]
            if unit == 0x7B {
                let segment = String(utf16CodeUnits: Array(units[segmentStart..<offset]), count: offset - segmentStart)
                let range = NSRange(segment.startIndex..., in: segment)
                let last = keyword.matches(in: segment, range: range).last
                    .flatMap { Range($0.range(at: 1), in: segment) }
                    .map { String(segment[$0]) }
                let isType = ["extension", "enum", "struct", "class", "actor", "protocol"].contains(last ?? "")
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

    static func spelledLines(_ lines: [Int]) -> String {
        let spelled = lines.map(String.init)
        guard spelled.count > 1 else { return "line \(spelled[0])" }
        return "lines " + spelled.dropLast().joined(separator: ", ") + " and " + spelled[spelled.count - 1]
    }

    // The captures of a declaration this reader reads as file-scope: the
    // pattern begins at the declaring keyword, and its first group is the
    // declared name.
    static func declarations(_ pattern: String, _ text: String, _ scope: Scope) -> [[String]] {
        let regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).map { match in
            let groups: [String] = (1..<match.numberOfRanges).map { index in
                guard let bounds = Range(match.range(at: index), in: text) else { return "" }
                return String(text[bounds])
            }
            let start = match.range.location
            if scope.depth[start] > 0 {
                let spelled = Range(match.range, in: text).map { String(text[$0]) } ?? ""
                let keyword = spelled.prefix { !$0.isWhitespace }
                fail("cannot read line \(scope.line[start]): the \(keyword) '\(groups[0])' is declared "
                    + "inside a body, and this court reads declarations at file scope")
            }
            return groups
        }
    }

    // Every declaration of a name, in any scope and of any form: a nominal
    // type, a protocol, a typealias, an associated type, a generic parameter.
    // `file` holds the names this reader reads at file scope: an enum, a
    // protocol or a typealias outside every body.
    static func declaredNames(_ text: String, _ scope: Scope)
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
        let generic = try! NSRegularExpression(
            pattern: #"\b(?:func\s+[^\s(<]+|(?:enum|struct|class|actor|typealias)\s+\w+|init[?!]?|subscript)"#
                + #"\s*<([^<>]*(?:<[^<>]*>[^<>]*)*)>"#
        )
        for match in generic.matches(in: text, range: range) {
            guard let list = Range(match.range(at: 1), in: text).map({ String(text[$0]) }) else { continue }
            for parameter in parameterNames(list) {
                // a parameter pack is spelled `each T`
                let name = parameter.split(whereSeparator: \.isWhitespace).last.map(String.init) ?? parameter
                lines[name, default: []].append(scope.line[match.range(at: 1).location])
            }
        }
        return (lines.mapValues { $0.sorted() }, file)
    }

    static func parameterNames(_ list: String) -> [String] {
        guard !list.isEmpty else { return [] }
        var names: [String] = []
        var depth = 0
        var piece = ""
        for character in list {
            if character == "<" { depth += 1 }
            if character == ">" { depth -= 1 }
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
    static func readAliases(_ text: String) -> [[String]] {
        let header = try! NSRegularExpression(
            pattern: #"typealias\s+(\w+)\s*(?:<([^>]*)>)?\s*=\s*"#,
            options: [.dotMatchesLineSeparators]
        )
        var result: [[String]] = []
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
                    if depth < 0 { fail("cannot read typealias '\(name)': unbalanced generic arguments") }
                }
                if character == "{" || character == "}" || character == ";" { break }
                if character == "\n", depth == 0 {
                    let following = text[text.index(after: end)...]
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    if !following.hasPrefix(".") { break }
                }
                end = text.index(after: end)
            }
            if depth != 0 { fail("cannot read typealias '\(name)': unbalanced generic arguments") }
            let body = String(text[start..<end])
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: #"\s*\.\s*"#, with: ".", options: .regularExpression)
                .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            if body.isEmpty { fail("cannot read typealias '\(name)': empty right side") }
            let tail = text[end...].trimmingCharacters(in: .whitespacesAndNewlines)
            let conditional = body.range(of: #"\bwhere\b"#, options: .regularExpression) != nil
                || tail.range(of: #"^where\b"#, options: .regularExpression) != nil
            result.append([name, parameters, body, conditional ? "where" : ""])
            cursor = end
        }
        return result
    }

    // Member aliases belong to their declaration. Exporting them into the
    // world's namespace can turn an unrelated alias into a false equality.
    // Keep line boundaries so multiline top-level aliases remain readable.
    static func outsideBodies(_ text: String) -> String {
        var depth = 0
        var result = ""
        for character in text {
            if character == "{" { depth += 1 }
            if depth == 0 || character == "\n" { result.append(character) }
            else { result.append(" ") }
            if character == "}" { depth -= 1 }
            if depth < 0 { fail("unmatched declaration brace") }
        }
        if depth != 0 { fail("unterminated declaration body") }
        return result
    }

    // A gate's where carries three kinds of conjunct. An equality is judged
    // against the canon. A membership, a colon and a bare protocol name, is
    // judged against the protocols the conformer's declaration and extensions
    // list, closed over the refinements the file presents. Anything else used
    // to be dropped in silence, and a court may not drop a condition in
    // silence: it is named at its gate instead, so a half-read law is a
    // refusal, never a verdict that counts what it never read.
    static func splitConjuncts(_ clause: String)
        -> (equalities: [(String, String)], memberships: [(String, String)], unjudged: [String]) {
        var parts: [String] = []
        var depth = 0
        var piece = ""
        for character in clause {
            if character == "<" { depth += 1 }
            if character == ">" { depth -= 1 }
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
        /// the lines each name of this file is declared at, in any scope
        var declared: [String: [Int]] = [:]
        /// the lines at which this file extends each name, in any form
        var extensions: [String: [Int]] = [:]
        /// the names this file declares at file scope as a type, a protocol
        /// or a typealias: the names another file's extension can reach
        var fileTypes: Set<String> = []
    }

    static func read(_ text: String) -> World {
        let clean = stripComments(text)
        let scope = Scope(clean)
        var world = World()

        let names = declaredNames(clean, scope)
        world.declared = names.lines
        for name in names.file.sorted(by: { (names.lines[$0]![0], $0) < (names.lines[$1]![0], $1) })
        where names.lines[name]!.count > 1 {
            fail("cannot read '\(name)': it is declared at \(spelledLines(names.lines[name]!)), "
                + "and this court has no scope rule to choose between them")
        }

        // A presented declaration can have a body this flat reader cannot read.
        // Such a body does not license reflexivity of an unestablished field.
        for hit in declarations(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\s*\{"#, clean, scope
        ) {
            world.presentedBodies.insert(hit[0])
        }

        for hit in declarations(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\bwhere\s+[^{}]+\{"#, clean, scope
        ) {
            world.conditionalDeclarations.insert(hit[0])
        }

        for hit in declarations(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*([\w,\s]+?)\s*\{([^{}]*)\}"#, clean, scope
        ) {
            let name = hit[0]
            let parameters = parameterNames(hit[1])
            let protocols = hit[2]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            var table: [String: String] = [:]
            for aliasHit in readAliases(hit[3]) where aliasHit[1].isEmpty {
                guard table[aliasHit[0]] == nil else {
                    fail("duplicate definition of '\(name).\(aliasHit[0])'")
                }
                table[aliasHit[0]] = aliasHit[2]
            }
            world.conformers[name] = Conformer(
                name: name, parameters: parameters, protocols: protocols, table: table
            )
        }

        for hit in declarations(#"enum\s+(\w+)\s*<([^>]*)>"#, clean, scope) {
            world.parameters[hit[0]] = parameterNames(hit[1])
        }

        // An unconditional extension of a presented conformer adds the
        // protocols its header lists, whatever its body holds: the header
        // states the conformance, so a body this reader cannot read does not
        // drop the obligation. A where clause always carries ':' or '==', so
        // the list cannot swallow one, and a gated extension stays a gate. A
        // type with no inheritance list (`enum Foo {}`) is not presented, so
        // its extensions add nothing.
        for hit in declarations(#"extension\s+(\w+)\s*:\s*([\w,\s]+?)\s*\{"#, clean, scope) {
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
        for hit in declarations(
            #"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}"#, clean, scope
        ) {
            let name = hit[0]
            if world.conformers[name] != nil {
                for aliasHit in readAliases(hit[1]) where aliasHit[1].isEmpty {
                    guard world.conformers[name]!.table[aliasHit[0]] == nil else {
                        fail("duplicate definition of '\(name).\(aliasHit[0])'")
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
        let extended = try! NSRegularExpression(pattern: #"\bextension\s+(\w+)"#)
        for match in extended.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            guard let bounds = Range(match.range(at: 1), in: clean) else { continue }
            world.extensions[String(clean[bounds]), default: []].append(scope.line[match.range.location])
        }

        for hit in readAliases(outsideBodies(clean)) {
            guard world.aliases[hit[0]] == nil else {
                fail("duplicate definition of typealias '\(hit[0])'")
            }
            if !hit[3].isEmpty { world.conditionalDeclarations.insert(hit[0]) }
            world.aliases[hit[0]] = AliasRule(
                parameters: parameterNames(hit[1]),
                body: hit[2]
            )
        }

        // A where clause this reader cannot read as a gate is refused by name,
        // never passed over: an unread condition would leave every claim
        // over it unjudged, and a neighbour that holds would pass the file.
        // A conditional conformance is read with one protocol before its
        // where clause, a conditional protocol with an inheritance list.
        for hit in declarations(#"extension\s+(\w+)\s*:\s*([^{}]*?)\bwhere\b"#, clean, scope)
        where hit[1].range(of: #"^\w+\s+$"#, options: .regularExpression) == nil {
            let listed = hit[1].split(whereSeparator: \.isWhitespace).joined(separator: " ")
            fail("cannot read conditional conformance '\(hit[0]): \(listed)': "
                + "this court reads one protocol per conditional extension")
        }
        for hit in declarations(#"protocol\s+(\w+)\b([^{}]*?)\bwhere\b"#, clean, scope)
        where hit[1].range(of: #"^\s*:\s*[\w,\s]+?\s+$"#, options: .regularExpression) == nil {
            fail("cannot read conditional protocol '\(hit[0])': "
                + "this court reads a where clause after an inheritance list of plain names")
        }

        for hit in declarations(
            #"extension\s+(\w+)\s*:\s*(\w+)\s+where\s+([^{]+)\{"#, clean, scope
        ) {
            let conjuncts = splitConjuncts(hit[2])
            world.gates.append(GatedExtension(
                head: hit[0], proto: hit[1],
                equalities: conjuncts.equalities,
                memberships: conjuncts.memberships,
                unjudged: conjuncts.unjudged
            ))
        }

        for hit in declarations(
            #"protocol\s+(\w+)\s*:\s*[\w,\s]+?\s+where\s+([^{]+)\{"#, clean, scope
        ) {
            let conjuncts = splitConjuncts(hit[1])
            world.gatedProtocols[hit[0]] = GatedProtocol(
                name: hit[0],
                equalities: conjuncts.equalities,
                memberships: conjuncts.memberships,
                unjudged: conjuncts.unjudged
            )
        }

        // the refinement ladder, read from what is presented: a protocol's
        // parents are the material the membership walk closes over
        for hit in declarations(
            #"protocol\s+(\w+)\s*:\s*([\w,\s]+?)\s*(?:\s+where|\{)"#, clean, scope
        ) {
            world.protocolParents[hit[0]] = hit[1]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
        }
        for hit in declarations(#"protocol\s+(\w+)\s*\{"#, clean, scope)
        where world.protocolParents[hit[0]] == nil {
            world.protocolParents[hit[0]] = []
        }

        for hit in declarations(#"protocol\s+(\w+)[^{}]*\{([^{}]*)\}"#, clean, scope) {
            world.protocolAxes[hit[0]] = Set(captures(#"associatedtype\s+(\w+)"#, hit[1]).map { $0[0] })
        }

        // A use is read at file scope. One inside a type or an extension body
        // may name a member this court does not read, so it is refused there.
        let bodies = typeBodies(clean)
        let usePattern = try! NSRegularExpression(
            pattern: #"([\w<>,\. ]+?)\s*\.self"#, options: [.dotMatchesLineSeparators]
        )
        for match in usePattern.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            guard let bounds = Range(match.range(at: 1), in: clean) else { continue }
            let use = String(clean[bounds]).trimmingCharacters(in: .whitespaces)
            guard use.contains("<") else { continue }
            let start = match.range.location
            if bodies[start] > 0 {
                fail("cannot read line \(scope.line[start]): the use '\(use)' sits in the body of a type "
                    + "or an extension, whose members this court does not read")
            }
            world.uses.append(use)
        }
        return world
    }

    // ── source-relative reduction, with replayed derivations ──

    // The term reader consumes the whole expression. An unread suffix cannot
    // be turned into an opaque atom and then accepted by reflexivity.
    static func parseTerm(_ text: Substring) -> Term {
        do { return try DefinitionReduction.parse(String(text)).legacy }
        catch { fail("cannot read term: \(error)") }
    }

    static func substitute(_ term: Term, _ bindings: [String: Term]) -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let values = try bindings.mapValues {
                try DefinitionReduction.parse(Press.serialize($0), allowRigidNames: true)
            }
            return try expression.substituting(values).legacy
        } catch { fail("cannot substitute term: \(error)") }
    }

    static func normalize(_ term: Term, _ world: World, rigid: Set<String> = []) -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            return try DefinitionReduction.normalForm(expression, source: source).output.legacy
        } catch { fail("unresolved definition reduction: \(error)") }
    }

    static func canon(_ text: String, _ world: World) -> String {
        Press.serialize(normalize(parseTerm(Substring(text)), world))
    }

    // A claim meets the gate its definition names. A head spelled through an
    // alias or a member alias is unfolded before the gate is looked up, so an
    // intermediate name cannot carry a claim past its gate. A nominal head is
    // already the name a gate is looked up by, and a world that presents no
    // gate has no lookup to prepare. The gate itself reads the arguments.
    static func gatedForm(_ term: Term, _ world: World, rigid: Set<String> = []) -> Term {
        guard !world.gates.isEmpty,
              world.aliases[term.head] != nil || term.head.contains(".") else { return term }
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            return try DefinitionReduction.headForm(expression, source: source).output.legacy
        } catch { fail("unresolved definition reduction: \(error)") }
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

    static func conformerContext(_ conformer: Conformer, _ world: World)
        -> (bindings: [String: Term], rigid: Set<String>) {
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
    static func gateBindings(_ term: Term, _ world: World) -> [String: Term] {
        guard let parameters = world.parameters[term.head] ?? world.conformers[term.head]?.parameters else {
            fail("cannot bind gate '\(term.head)': no declaration parameters were read")
        }
        guard parameters.count == term.args.count, Set(parameters).count == parameters.count else {
            fail("cannot bind gate '\(term.head)': expected \(parameters.count) distinct arguments, received \(term.args.count)")
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

    // one membership judged: the left side resolves through the same canon
    // the equalities use, the resolved name must be a presented conformer,
    // and the conformer must wear the protocol through the ladder. Either
    // failure is a refusal in this court's own voice, at the site that
    // required it.
    static func judgeMemberships(
        _ memberships: [(String, String)], site: String, tag: String?,
        bindings: [String: Term], world: World,
        counted: inout Int, refusals: inout [String], rigid: Set<String> = []
    ) {
        let mark = tag.map { " [\($0)]" } ?? ""
        for (lhs, proto) in memberships {
            counted += 1
            let lhsTerm = substitute(parseTerm(Substring(lhs)), bindings)
            let resolved = normalize(lhsTerm, world, rigid: rigid)
            let spelled = Press.serialize(resolved)
            if world.conformers[resolved.head] == nil, world.presentedBodies.contains(resolved.head) {
                fail("cannot read declaration '\(resolved.head)': its body is outside this court's flat-definition fragment")
            }
            guard resolved.args.isEmpty, let wearer = world.conformers[resolved.head] else {
                refusals.append(
                    "'\(site)' requires the type '\(lhs)' (aka '\(spelled)') conform to "
                        + "'\(proto)', and no conformer of that name is presented\(mark)"
                )
                continue
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

    static func run(_ arguments: [String]) {
        guard let path = arguments.first else {
            fail("usage: judge where <world.swift> [definitions.swift ...]")
        }
        guard let text = try? String(contentsOfFile: path, encoding: .utf8) else {
            fail("cannot read \(path)")
        }
        var world = read(text)
        var excludesConditional = text.range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
        let ownAliases = world.aliases
        // Extra files supply alias definitions, not a second version of the
        // same source. This flat reader has no module-resolution rule with
        // which to choose between duplicates, so a collision is unresolved.
        var aliasOrigins = Dictionary(uniqueKeysWithValues: world.aliases.keys.map { ($0, path) })
        for extra in arguments.dropFirst() {
            guard let more = try? String(contentsOfFile: extra, encoding: .utf8) else {
                fail("cannot read \(extra)")
            }
            excludesConditional = excludesConditional
                || more.range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
            let lent = read(more)
            // A definitions file that extends a type, a protocol or a typealias
            // this world declares at file scope may add a member that binds a
            // name inside the world's type, a conformance, or a gate. Whether
            // that extension is the world's type at all (the definitions file
            // may declare its own type of the name, privately, or sit in
            // another module) and whether its members reach this file (a
            // private or fileprivate member does not) are facts this flat
            // reader does not establish, so such an extension is refused rather
            // than read or passed over.
            let extendsWorld = lent.extensions
                .filter { world.fileTypes.contains($0.key) }
                .sorted(by: { $0.key < $1.key })
            if let first = extendsWorld.first {
                fail("cannot read '\(first.key)': '\(extra)' extends it at \(spelledLines(first.value)), and this court "
                    + "cannot tell that the extension is this world's type, or that its members reach this file")
            }
            for (name, rule) in lent.aliases.sorted(by: { $0.key < $1.key }) {
                guard aliasOrigins[name] == nil else {
                    fail("ambiguous definition of '\(name)' in '\(aliasOrigins[name]!)' and '\(extra)'")
                }
                if let lines = world.declared[name] {
                    fail("cannot read '\(name)': it is a typealias in '\(extra)' and is declared at "
                        + "\(spelledLines(lines)) of '\(path)', and this court has no scope rule to choose between them")
                }
                world.aliases[name] = rule
                aliasOrigins[name] = extra
            }
        }
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
        var certificates: [(name: String, term: Term, rigid: Set<String>)] = ownAliases
            .filter { $0.value.parameters.isEmpty }
            .map { ($0.key, parseTerm(Substring($0.value.body)), []) }
        // A local certificate is still checked, but in its actual owner.
        // Removing it from the global namespace must not remove its obligation.
        for conformer in world.conformers.values {
            let context = conformerContext(conformer, world)
            for (name, body) in conformer.table {
                certificates.append((conformer.name + "." + name,
                    substitute(parseTerm(Substring(body)), context.bindings), context.rigid))
            }
        }
        for certificate in certificates.sorted(by: { $0.name < $1.name }) {
            let name = certificate.name
            let term = certificate.term
            let body = Press.serialize(term)
            let claim = gatedForm(term, world, rigid: certificate.rigid)
            let matching = world.gates.filter { $0.head == claim.head }
            guard !matching.isEmpty else { continue }
            let bindings = gateBindings(claim, world)
            for gate in matching {
                for (left, right) in gate.equalities {
                    judged += 1
                    let leftTerm = substitute(parseTerm(Substring(left)), bindings)
                    let rightTerm = substitute(parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(normalize(leftTerm, world, rigid: certificate.rigid))
                    let rightCanon = Press.serialize(normalize(rightTerm, world, rigid: certificate.rigid))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(name) = \(body)' requires the types '\(left)' (aka '\(leftCanon)') and "
                                + "'\(right)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
                        )
                    }
                }
                judgeMemberships(
                    gate.memberships, site: "\(name) = \(body)", tag: gate.proto,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals, rigid: certificate.rigid
                )
            }
        }

        for use in world.uses {
            let claim = gatedForm(parseTerm(Substring(use)), world)
            let matching = world.gates.filter { $0.head == claim.head }
            guard !matching.isEmpty else { continue }
            let bindings = gateBindings(claim, world)
            for gate in matching {
                for (left, right) in gate.equalities {
                    judged += 1
                    let leftTerm = substitute(parseTerm(Substring(left)), bindings)
                    let rightTerm = substitute(parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(normalize(leftTerm, world))
                    let rightCanon = Press.serialize(normalize(rightTerm, world))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(use)' requires the types '\(left)' (aka '\(leftCanon)') and "
                                + "'\(right)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
                        )
                    }
                }
                judgeMemberships(
                    gate.memberships, site: use, tag: gate.proto,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals
                )
            }
        }

        for conformer in world.conformers.values.sorted(by: { $0.name < $1.name }) {
            let protocols = inheritedProtocols(conformer.protocols, world)
            let (bindings, rigid) = conformerContext(conformer, world)
            // Membership inheritance and equality inheritance are the same
            // dependency closure. A child cannot discard a parent's gate.
            for protoName in protocols.sorted() {
                guard let gated = world.gatedProtocols[protoName] else { continue }
                for (left, right) in gated.equalities {
                    judged += 1
                    let leftTerm = substitute(parseTerm(Substring(left)), bindings)
                    let rightTerm = substitute(parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(normalize(leftTerm, world, rigid: rigid))
                    let rightCanon = Press.serialize(normalize(rightTerm, world, rigid: rigid))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(conformer.name): \(protoName)' requires the types '\(left)' "
                                + "(aka '\(leftCanon)') and '\(right)' (aka '\(rightCanon)') be equivalent"
                        )
                    }
                }
                judgeMemberships(
                    gated.memberships, site: "\(conformer.name): \(protoName)", tag: nil,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals, rigid: rigid
                )
            }
        }

        if refusals.isEmpty {
            if judged == 0 && members == 0 {
                fail("no equalities or memberships were judged; no certificate established")
            }
            if excludesConditional {
                print("THE WHERE scope: conditional compilation blocks are excluded.")
            }
            print("✓ THE WHERE holds: \(judged) equalities and \(members) memberships judged across \(world.uses.count) uses, the certificates, and the gated conformers, source-replayed definition reductions (canon v\(canonVersion)).")
        } else {
            for refusal in refusals { print("✗ \(refusal)") }
            exit(1)
        }
    }
}
