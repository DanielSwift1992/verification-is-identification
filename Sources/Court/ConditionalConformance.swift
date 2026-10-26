import Foundation

extension WhereJudge {
    /// A comma list declares independent conformances with one shared where
    /// clause. This consumes the common lexer's notation tape; it performs no
    /// name resolution. ContextNameBinding binds each protocol in the usual way.
    static func conditionalConformances(_ clean: String, tokens: [NotationToken],
                                       scope: Scope, bindingView: Bool)
        throws -> (gates: [GatedExtension], clauses: [NSRange]) {
        var gates: [GatedExtension] = [], clauses: [NSRange] = []
        var extensionIndex = 0
        func isToken(_ i: Int, _ spelling: String) -> Bool {
            i < tokens.count && sameName(tokens[i].spelling, spelling)
        }
        func path(_ cursor: inout Int) -> String? {
            guard cursor < tokens.count, tokens[cursor].word else { return nil }
            var parts = [tokens[cursor].spelling.text]
            cursor += 1
            while isToken(cursor, "."), cursor + 1 < tokens.count, tokens[cursor + 1].word {
                parts.append(tokens[cursor + 1].spelling.text); cursor += 2
            }
            return parts.joined(separator: ".")
        }
        for i in tokens.indices
        where isToken(i, "extension") && (i == 0 || !isToken(i - 1, ".")) {
            let ordinal = extensionIndex
            extensionIndex += 1
            var cursor = i + 1
            guard let head = path(&cursor), isToken(cursor, ":") else { continue }
            cursor += 1
            let listStart = cursor
            var whereIndex: Int?, open: Int?
            while cursor < tokens.count {
                if isToken(cursor, "{") { open = cursor; break }
                if isToken(cursor, "}") || isToken(cursor, ";") { break }
                if whereIndex == nil, isToken(cursor, "where") { whereIndex = cursor }
                cursor += 1
            }
            let line = scope.line[tokens[i].range.location]
            guard let whereIndex else { continue }
            guard let open else {
                try fail("cannot read line \(line): conditional conformance has no opening body brace")
            }
            guard scope.depth[tokens[i].range.location] == 0 else {
                try fail("cannot read line \(line): the extension '\(head)' is declared inside a body, and this court reads declarations at file scope")
            }
            var protocols: [(String, Int)] = []
            cursor = listStart
            while cursor < whereIndex {
                let start = cursor
                guard let proto = path(&cursor), cursor <= whereIndex,
                      bindingView || !proto.contains(".") else {
                    try fail("cannot read line \(scope.line[tokens[start].range.location]): conditional conformance protocols must be comma-separated names bound by the source context")
                }
                protocols.append((proto, start))
                if cursor == whereIndex { break }
                guard isToken(cursor, ","), cursor + 1 < whereIndex else {
                    try fail("cannot read line \(scope.line[tokens[cursor].range.location]): conditional conformance protocols must be comma-separated names bound by the source context")
                }
                cursor += 1
            }
            guard !protocols.isEmpty else {
                try fail("cannot read line \(line): conditional conformance needs a declared protocol")
            }
            let start = NSMaxRange(tokens[whereIndex].range)
            let clause = NSRange(location: start, length: tokens[open].range.location - start)
            guard let bounds = Range(clause, in: clean) else { try fail("cannot read line \(line): conditional conformance clause has no source range") }
            let condition = String(clean[bounds])
            guard !condition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                try fail("cannot read line \(line): conditional conformance has an empty where clause")
            }
            let conjuncts = try splitConjuncts(condition)
            clauses.append(clause)
            for (index, entry) in protocols.enumerated() {
                gates.append(GatedExtension(head: head, proto: entry.0,
                    equalities: conjuncts.equalities, memberships: conjuncts.memberships,
                    unjudged: conjuncts.unjudged,
                    protocolLocation: protocols.count > 1
                        ? "\(scope.line[tokens[entry.1].range.location]):extension[\(ordinal)].conformances[\(index)]" : nil))
            }
        }
        return (gates, clauses)
    }
}
