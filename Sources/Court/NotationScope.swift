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
    private
    var ownerStarts: [Int] = []
    private
    var ownerIndices: [Int?] = []
    private
    var subtreeEnds: [Int] = []

    init(_ clean: String, enabled: Bool = true) throws {
        try self.init(clean, enabled: enabled, refusing: { try WhereJudge.fail($0) })
    }

    /// Inventory every locally decidable declaration-shape refusal using the
    /// same admission guards. No partially admitted scope leaves this method.
    /// A fatal brace/lexical obstruction still ends this phase.
    static func unreadDeclarations(_ clean: String) -> [String] {
        var messages: [String] = []
        do { _ = try NotationScope(clean, enabled: true, refusing: { messages.append($0) }) }
        catch let failure as WhereJudge.Failure { messages += failure.messages }
        catch { messages.append(String(describing: error)) }
        return messages
    }

    private init(_ clean: String, enabled: Bool, refusing: (String) throws -> Void) throws {
        guard enabled else { return }
        let scope = WhereJudge.Scope(clean)
        let units = Array(clean.utf16)
        // Pair braces once. A declaration's body is not rescanned when a
        // nested declaration is reached. Unmatched non-declaration braces
        // retain the old admission: only a matched header needs a close.
        var closing: [Int: Int] = [:]
        var braces: [Int] = []
        for (offset, unit) in units.enumerated() {
            if unit == 0x7B { braces.append(offset) }
            else if unit == 0x7D, let open = braces.popLast() { closing[open] = offset + 1 }
        }
        let regex = try! NSRegularExpression(pattern: #"\b(enum|struct|class|actor|protocol)\s+(\w+)[^{}]*\{"#)
        let ignoredPrefix = try! NSRegularExpression(pattern: #"(?:\bimport\s*|\.\s*)$"#)
        var prefixStart = 0
        var active: [Int] = []
        var unsupportedParents = 0
        // Plain ancestors become namespaces only when an admitted child is
        // encountered. Each pending ancestor is consumed or closed once.
        var pendingNamespaces: [Int] = []
        for hit in regex.matches(in: clean, range: NSRange(clean.startIndex..., in: clean)) {
            let start = hit.range.location, open = NSMaxRange(hit.range) - 1
            let prefixRange = NSRange(location: prefixStart, length: start - prefixStart)
            prefixStart = start
            let kindRange = hit.range(at: 1), nameRange = hit.range(at: 2)
            let kind = String(decoding: units[kindRange.location..<NSMaxRange(kindRange)], as: UTF16.self)
            let name = String(decoding: units[nameRange.location..<NSMaxRange(nameRange)], as: UTF16.self)
            // The previous hit starts with a nominal keyword, so an import
            // or dotted suffix cannot begin before it. These disjoint gaps
            // preserve the old suffix expression without copying a prefix.
            let gap = String(decoding: units[prefixRange.location..<NSMaxRange(prefixRange)], as: UTF16.self)
            if ignoredPrefix.firstMatch(in: gap, range: NSRange(location: 0, length: prefixRange.length)) != nil { continue }
            let headerText = String(decoding: units[start..<open], as: UTF16.self)
            if kind == "class", headerText.range(of: #"^class(?:\s+(?:public|private|fileprivate|internal|package|open|final|override|required|convenience|dynamic|nonisolated))*\s+(?:func|var|let|subscript|init)\b"#, options: .regularExpression) != nil { continue }
            guard let close = closing[open] else { try WhereJudge.fail("unterminated declaration body") }
            while let last = active.last, declarations[last].close <= start {
                active.removeLast()
                subtreeEnds[last] = declarations.count
                recordOwner(at: declarations[last].close, index: active.last)
                let parent = declarations[last]
                if parent.kind != "enum" || parent.header.contains("<") { unsupportedParents -= 1 }
                if pendingNamespaces.last == last { pendingNamespaces.removeLast() }
            }
            var qualified = name
            if !active.isEmpty && active.count == scope.depth[start] {
                // Conformances do not change a child's lexical owner. Generic
                // containers still require bindings outside this fragment.
                if unsupportedParents != 0 {
                    try refusing("cannot read line \(scope.line[start]): nested declaration '\(name)' has an unsupported enclosing type")
                } else {
                    qualified = declarations[active.last!].qualified + "." + name
                    if kind != "enum" {
                        try refusing("cannot read line \(scope.line[start]): nested \(kind) '\(qualified)' is outside the declared notation fragment")
                    } else if headerText.contains("<") {
                        try refusing("cannot read line \(scope.line[start]): nested declaration '\(name)' has an unsupported enclosing type")
                    } else {
                        nested[start] = qualified
                        for index in pendingNamespaces { namespaces.insert(declarations[index].qualified) }
                        pendingNamespaces.removeAll(keepingCapacity: true)
                    }
                }
            }
            let header = headerText.split(whereSeparator: \.isWhitespace).joined(separator: " ")
            let index = declarations.count
            declarations.append(Declaration(kind: kind, name: name, qualified: qualified,
                start: start, open: open, close: close, header: header))
            subtreeEnds.append(0)
            active.append(index)
            recordOwner(at: start, index: index)
            if kind != "enum" || header.contains("<") { unsupportedParents += 1 }
            if WhereJudge.sameName(header, "enum " + name) { pendingNamespaces.append(index) }
        }
        while let last = active.popLast() {
            subtreeEnds[last] = declarations.count
            recordOwner(at: declarations[last].close, index: active.last)
        }
    }

    private mutating func recordOwner(at offset: Int, index: Int?) {
        if ownerStarts.last == offset { ownerIndices[ownerIndices.count - 1] = index }
        else {
            ownerStarts.append(offset)
            ownerIndices.append(index)
        }
    }

    func name(_ spelling: String, at start: Int) -> String { nested[start] ?? spelling }

    /// The innermost nominal declaration owns its header and body. A header's
    /// where clause has the same associated-type scope as its protocol body.
    func owner(at offset: Int) -> Declaration? {
        // The sweep records only owner changes; header and body have the
        // same owner. Repeated references do not scan every declaration.
        var low = 0, high = ownerStarts.count
        while low < high {
            let middle = low + (high - low) / 2
            if ownerStarts[middle] <= offset { low = middle + 1 }
            else { high = middle }
        }
        guard low > 0, let index = ownerIndices[low - 1] else { return nil }
        return declarations[index]
    }

    /// Both questions obtain nested declaration headers and fields from these
    /// lexical owners. A child keeps its qualified identity; it is not emitted
    /// as a new top-level source declaration.
    func structural(_ clean: String, origin: String, lent: NameSet) throws -> [StructuralSource.Declaration] {
        let units = Array(clean.utf16)
        let builders = try lent.union(WhereJudge.declaredBuilders(clean))
        var result: [StructuralSource.Declaration] = []
        for (index, declaration) in declarations.enumerated() {
            guard ["enum", "struct", "protocol"].contains(declaration.kind) else { continue }
            let header = Array(try StructuralSource.tokens(declaration.header).dropFirst())
            let body = String(decoding: units[(declaration.open + 1)..<(declaration.close - 1)], as: UTF16.self)
            let words = try WhereJudge.lexicalReading(body, scope: .projection,
                lent: builders, carrying: false).tape.words
            // A preorder subtree is contiguous. Flat siblings add no scan;
            // nested bodies retain exactly the previous descendant set.
            let children = NameSet(declarations[(index + 1)..<subtreeEnds[index]]
                .filter { nested[$0.start] != nil }.map(\.name))
            let read = try StructuralSource.declaration(kind: declaration.kind, header: header,
                body: words, origin: origin, nestedEnums: children)
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
        // ContextNameBinding supplies the selected full place before this
        // view is reduced. This transport makes no nearest-owner choice.
        body
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
