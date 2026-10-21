import Foundation

/// Reads the declared type-relation fragment. Value/member-function bodies are
/// retained only as balanced regions; they are not claims proved by this reader.
struct StructuralSource {
    typealias Failure = DefinitionReduction.Failure
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

    static func tokens(_ source: String) throws -> [String] {
        let chars = Array(WhereJudge.sourceLines(source))
        var result: [String] = [], i = 0
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
                    while i < chars.count, chars[i] != "\n" { i += 1 }
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
            if c == "\n" {
                result.append("\n")
                i += 1
                continue
            }
            if c.isWhitespace {
                i += 1
                continue
            }
            if c == "/", i + 1 < chars.count, chars[i + 1] == "/" {
                i += 2
                while i < chars.count, chars[i] != "\n" { i += 1 }
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
                        if chars[i] == "\n" { result.append("\n") }
                        i += 1
                    }
                }
                if depth != 0 { throw Failure("unterminated block comment") }
                continue
            }
            if rawStringBegins() {
                throw Failure("raw string literals are outside structural reader scope")
            }
            if c == "\"" {
                try skipString()
                result.append("@literal")
                continue
            }
            if c.isLetter || c == "_" {
                let start = i
                i += 1
                while i < chars.count, chars[i].isLetter || chars[i].isNumber || chars[i] == "_" {
                    i += 1
                }
                result.append(String(chars[start..<i]))
                continue
            }
            if c == "=", i + 1 < chars.count, chars[i + 1] == "=" {
                result.append("==")
                i += 2
                continue
            }
            result.append(String(c))
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

    init(files: [(String, String)]) throws {
        for (origin, source) in files {
            let ts = try Self.tokens(source)
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
                    i += 1
                    var header: [String] = [], body: [String] = []
                    if kind == "typealias" {
                        header = Self.statement(ts, index: &i)
                    } else {
                        let begin = i
                        while i < ts.count, ts[i] != "{" { i += 1 }
                        header = Array(ts[begin..<i])
                        body = try Self.balanced(ts, index: &i, open: "{", close: "}")
                    }
                    let d = try Self.declaration(
                        kind: kind, header: header, body: body, origin: origin)
                    if kind == "extension" {
                        extensions[d.name, default: []].append(d)
                    } else {
                        guard declarations[d.name] == nil else {
                            throw Failure("duplicate declaration \(d.name)")
                        }
                        declarations[d.name] = d
                        access[d.name] = pendingAccess
                    }
                    pendingAccess = "internal"
                } else if ts[i] == "{" {
                    _ = try Self.balanced(ts, index: &i, open: "{", close: "}")
                    pendingAccess = "internal"
                } else {
                    i += 1
                }
            }
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
        }
        for name in conditionalSubjects
        where declarations[name] != nil {
            declarations[name]!.unsupported.append(
                "conditional compilation can alter this declaration")
        }
        try buildSyntax()
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
