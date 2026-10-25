import Foundation

/// Source coordinates and lexical owners for the bounded nested-enum fragment.
/// This is reader state, not another source format or a source of equations.
struct NotationScope {
    struct Member: Hashable {
        let owner: ScalarName?
        let name: ScalarName
    }
    struct Declaration {
        let kind: String
        let name: String
        let qualified: String
        let start: Int
        let open: Int
        let close: Int
        let header: String
    }
    var declarations: [Declaration] = []
    var nested: [Int: String] = [:]
    var namespaces: NameSet = []

    init(_ clean: String, enabled: Bool = true) throws {
        guard enabled else { return }
        let scope = WhereJudge.Scope(clean)
        let units = Array(clean.utf16)
        let regex = try! NSRegularExpression(pattern: #"\b(enum|struct|class|actor|protocol)\s+(\w+)[^{}]*\{"#)
        for hit in regex.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            let start = hit.range.location, open = NSMaxRange(hit.range) - 1
            guard let kindRange = Range(hit.range(at: 1), in: clean),
                  let nameRange = Range(hit.range(at: 2), in: clean) else { continue }
            let kind = String(clean[kindRange]), name = String(clean[nameRange])
            let prefix = String(decoding: units[..<start], as: UTF16.self)
            if prefix.range(of: #"(?:\bimport\s*|\.\s*)$"#, options: .regularExpression) != nil { continue }
            let headerText = String(decoding: units[start..<open], as: UTF16.self)
            if kind == "class", headerText.range(of: #"^class(?:\s+(?:public|private|fileprivate|internal|package|open|final|override|required|convenience|dynamic|nonisolated))*\s+(?:func|var|let|subscript|init)\b"#, options: .regularExpression) != nil { continue }
            var close = open + 1, depth = 1
            while close < units.count, depth > 0 {
                if units[close] == 0x7B { depth += 1 }
                if units[close] == 0x7D { depth -= 1 }
                close += 1
            }
            guard depth == 0 else { try WhereJudge.fail("unterminated declaration body") }
            let parents = declarations.filter { $0.open < start && start < $0.close }
            var qualified = name
            if !parents.isEmpty && parents.count == scope.depth[start] {
                // A generic or inherited container has additional lexical bindings.
                // They are not silently resolved as file-scope names.
                guard parents.allSatisfy({ $0.kind == "enum" && WhereJudge.sameName($0.header.trimmingCharacters(in: .whitespacesAndNewlines), "enum " + $0.name) }) else {
                    try WhereJudge.fail("cannot read line \(scope.line[start]): nested declaration '\(name)' has an unsupported enclosing type")
                }
                qualified = parents.last!.qualified + "." + name
                guard kind == "enum" else {
                    try WhereJudge.fail("cannot read line \(scope.line[start]): nested \(kind) '\(qualified)' is outside the declared notation fragment")
                }
                let header = String(decoding: units[start..<open], as: UTF16.self)
                guard !header.contains("<") else {
                    try WhereJudge.fail("cannot read line \(scope.line[start]): nested declaration '\(name)' has an unsupported enclosing type")
                }
                nested[start] = qualified
                namespaces.formUnion(parents.map(\.qualified))
            }
            declarations.append(Declaration(kind: kind, name: name, qualified: qualified,
                start: start, open: open, close: close,
                header: String(decoding: units[start..<open], as: UTF16.self)
                    .split(whereSeparator: \.isWhitespace).joined(separator: " ")))
        }
    }

    func name(_ spelling: String, at start: Int) -> String { nested[start] ?? spelling }

    /// The innermost nominal declaration owns its header and body. A header's
    /// where clause has the same associated-type scope as its protocol body.
    func owner(at offset: Int) -> Declaration? {
        declarations.last { $0.start <= offset && offset < $0.close }
    }

    /// Both questions obtain nested declaration headers and fields from these
    /// lexical owners. A child keeps its qualified identity; it is not emitted
    /// as a new top-level source declaration.
    func structural(_ clean: String, origin: String, lent: NameSet) throws -> [StructuralSource.Declaration] {
        let units = Array(clean.utf16)
        let builders = try lent.union(WhereJudge.declaredBuilders(clean))
        var result: [StructuralSource.Declaration] = []
        for declaration in declarations {
            guard ["enum", "struct", "protocol"].contains(declaration.kind) else { continue }
            let header = Array(try StructuralSource.tokens(declaration.header).dropFirst())
            let body = String(decoding: units[(declaration.open + 1)..<(declaration.close - 1)], as: UTF16.self)
            let words = try WhereJudge.lexicalReading(body, scope: .projection,
                lent: builders, carrying: false).tape.words
            let read = try StructuralSource.declaration(kind: declaration.kind, header: header,
                body: words, origin: origin)
            let excluded = NameSet(read.parameters + Array(read.fields.keys) + ["Self"])
            result.append(StructuralSource.Declaration(name: declaration.qualified, kind: read.kind,
                parameters: read.parameters, parents: read.parents, requirements: read.requirements,
                fields: try read.fields.mapValues { try resolve($0, in: declaration.qualified, excluding: excluded) },
                fieldAccess: read.fieldAccess, axes: read.axes, alias: read.alias,
                unsupported: read.unsupported, bodyWitness: read.bodyWitness, origin: origin))
        }
        return result
    }

    func resolve(_ body: String, in owner: String, excluding: NameSet = []) throws -> String {
        let known = NameSet(nested.values)
        let reading = try WhereJudge.lexicalReading(body, scope: .projection, carrying: true)
        let tape = reading.tape
        let words = Set(reading.words.map(\.byte))
        var replacements: [(Int, Int, String)] = []
        for i in tape.words.indices {
            let word = tape.words[i]
            guard words.contains(tape.starts[i]), !excluding.contains(word),
                  i == 0 || !WhereJudge.sameName(tape.words[i - 1], ".") else { continue }
            var parent = owner.split(separator: ".").map(String.init)
            while !parent.isEmpty {
                let candidate = (parent + [word]).joined(separator: ".")
                if known.contains(candidate) {
                    replacements.append((tape.starts[i], tape.ends[i], candidate))
                    break
                }
                parent.removeLast()
            }
        }
        var bytes = Array(body.utf8)
        for (start, end, value) in replacements.reversed() {
            bytes.replaceSubrange(start..<end, with: value.utf8)
        }
        return String(decoding: bytes, as: UTF8.self)
    }

    static func intrinsic(_ clean: String, version: Int = 1) throws -> Bool {
        let exports = version == 2 ? ["Never", "String"] : ["Never"]
        let scope = WhereJudge.Scope(clean)
        let imports = try! NSRegularExpression(pattern: #"\bimport\s+([^\n;]+)"#)
        var hasSwift = false
        for hit in imports.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            guard let range = Range(hit.range(at: 1), in: clean) else { continue }
            let spelled = clean[range].trimmingCharacters(in: .whitespaces)
            if WhereJudge.sameName(spelled, "Swift"), scope.depth[hit.range.location] == 0 { hasSwift = true }
            else if WhereJudge.captures(#"\b(Swift)\b"#, spelled).count > 0 {
                try WhereJudge.fail("cannot read line \(scope.line[hit.range.location]): this court reads only the plain intrinsic import 'Swift'")
            }
        }
        let uses = try! NSRegularExpression(pattern: #"\bSwift\s*\.\s*(\w+)"#)
        for hit in uses.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            let export = Range(hit.range(at: 1), in: clean).map { String(clean[$0]) } ?? ""
            guard hasSwift else {
                try WhereJudge.fail("cannot read line \(scope.line[hit.range.location]): 'Swift.\(export)' requires the declared intrinsic import 'Swift'")
            }
            guard exports.containsName(export) else {
                try WhereJudge.fail("cannot read line \(scope.line[hit.range.location]): 'Swift.\(export)' is not exported by intrinsic Swift/\(version)")
            }
        }
        if hasSwift {
            let declares = try! NSRegularExpression(pattern: #"\b(?:enum|struct|class|actor|protocol|typealias|associatedtype)\s+("# + (["Swift"] + exports).joined(separator: "|") + #")\b"#)
            if let hit = declares.firstMatch(in: clean, range: NSRange(clean.startIndex..., in: clean)),
               let name = Range(hit.range(at: 1), in: clean) {
                try WhereJudge.fail("cannot read line \(scope.line[hit.range.location]): declaration '\(clean[name])' conflicts with intrinsic Swift/\(version)")
            }
        }
        return hasSwift
    }
}
