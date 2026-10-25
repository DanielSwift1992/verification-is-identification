import Foundation

/// Declaration heads and alias ranges on the Court's common lexical tape.
/// Ownership and visibility are supplied by ContextNameBinding, not spelling.
struct NameDeclarationSyntax {
    struct Head {
        let kind: String
        let keyword: Int
        let name: Int
        let parameters: [Int]
        let genericEnd: Int
    }
    let tape: WhereJudge.Lexed
    let heads: [Head]

    /// Lexical nominal paths for the flat reader's address table. Contextual
    /// ownership, duplicate admission and visibility belong to the binding index.
    func ownerPaths() -> [(open: Int, end: Int, names: [String])] {
        var closes: [Int: Int] = [:], stack: [Int] = []
        for i in tape.words.indices {
            if WhereJudge.sameName(tape.words[i], "{") { stack.append(i) }
            if WhereJudge.sameName(tape.words[i], "}"), let open = stack.popLast() { closes[open] = i }
        }
        let nominal: NameSet = ["enum", "struct", "class", "actor", "protocol"]
        let byKeyword = Dictionary(uniqueKeysWithValues: heads.map { ($0.keyword, $0) })
        var result: [(open: Int, end: Int, names: [String])] = []
        for i in tape.words.indices {
            var cursor: Int, names: [String]
            if let head = byKeyword[i], nominal.contains(head.kind) {
                names = (result.last { $0.open < i && i < $0.end }?.names ?? []) + [tape.words[head.name]]
                cursor = head.genericEnd
            } else if WhereJudge.sameName(tape.words[i], "extension"), i + 1 < tape.words.count {
                names = [tape.words[i + 1]]; cursor = i + 2
                while cursor + 1 < tape.words.count && WhereJudge.sameName(tape.words[cursor], ".") {
                    names.append(tape.words[cursor + 1]); cursor += 2
                }
            } else { continue }
            while cursor < tape.words.count && !WhereJudge.sameName(tape.words[cursor], "{") { cursor += 1 }
            if let end = closes[cursor] { result.append((cursor, end, names)) }
        }
        return result
    }

    init(_ text: String, lent: NameSet = []) throws {
        let read = try WhereJudge.lexicalReading(text, scope: .notation, lent: lent, carrying: true)
        let indices = read.tape.words.indices.filter { !WhereJudge.sameName(read.tape.words[$0], "\n") }
        var tape = WhereJudge.Lexed()
        tape.words = indices.map { read.tape.words[$0] }
        tape.starts = indices.map { read.tape.starts[$0] }
        tape.ends = indices.map { read.tape.ends[$0] }
        tape.lines = indices.map { read.tape.lines[$0] }
        self.tape = tape
        let words = Set(read.words.map(\.byte))
        let kinds: NameSet = ["enum", "struct", "class", "actor", "protocol", "typealias", "associatedtype", "func", "init", "subscript"]
        let modifiers: NameSet = ["func", "var", "let", "subscript", "init", "deinit", "static", "final", "override", "required", "convenience", "dynamic", "nonisolated", "public", "private", "fileprivate", "internal", "package", "open"]
        var result: [Head] = []
        for i in tape.words.indices {
            let kind = tape.words[i]
            guard kinds.contains(kind), i == 0 || ![".", "import"].containsName(tape.words[i - 1]) else { continue }
            let unnamed = ["init", "subscript"].containsName(kind)
            let name = unnamed ? i : i + 1
            guard name < tape.words.count else { continue }
            if WhereJudge.sameName(kind, "class"), modifiers.contains(tape.words[name]) { continue }
            if !unnamed && !WhereJudge.sameName(kind, "func"), !words.contains(tape.starts[name]) { continue }
            var cursor = name + 1
            if unnamed, cursor < tape.words.count, ["?", "!"].containsName(tape.words[cursor]) { cursor += 1 }
            // Operators are tokens too; an operator function's generic opener
            // is the following '<', never an ICU word-class match.
            if WhereJudge.sameName(kind, "func"), !words.contains(tape.starts[name]) {
                while cursor < tape.words.count && !["<", "("].containsName(tape.words[cursor]) { cursor += 1 }
            }
            var parameters: [Int] = []
            if cursor < tape.words.count, WhereJudge.sameName(tape.words[cursor], "<") {
                var depth = 1, expect = true
                cursor += 1
                while cursor < tape.words.count && depth > 0 {
                    let word = tape.words[cursor]
                    if ["{", "}", ";"].containsName(word) { break }
                    if depth == 1 && expect && words.contains(tape.starts[cursor]) {
                        if !["each", "let"].containsName(word) { parameters.append(cursor); expect = false }
                    }
                    if WhereJudge.sameName(word, "<") { depth += 1 }
                    if WhereJudge.sameName(word, ">"), cursor == 0 || !WhereJudge.sameName(tape.words[cursor - 1], "-") { depth -= 1 }
                    if depth == 1 && WhereJudge.sameName(word, ",") { expect = true }
                    cursor += 1
                }
                guard depth == 0 else { try WhereJudge.fail("cannot read line \(tape.lines[i]): its generic parameter list does not close where this court can read it") }
            }
            result.append(Head(kind: kind, keyword: i, name: name, parameters: parameters, genericEnd: cursor))
        }
        heads = result
    }

    func aliases(in text: String) throws -> [(fields: [String], body: NSRange, declaration: NSRange)] {
        let bytes = Array(text.utf8)
        func range(_ start: Int, _ end: Int) -> NSRange {
            let a = text.utf8.index(text.utf8.startIndex, offsetBy: start)
            let b = text.utf8.index(text.utf8.startIndex, offsetBy: end)
            return NSRange(a..<b, in: text)
        }
        var result: [(fields: [String], body: NSRange, declaration: NSRange)] = []
        for head in heads where WhereJudge.sameName(head.kind, "typealias") {
            var cursor = head.genericEnd
            guard cursor < tape.words.count, WhereJudge.sameName(tape.words[cursor], "=") else { continue }
            let start = tape.ends[cursor]
            cursor += 1
            var depth = 0, end = start
            while cursor < tape.words.count {
                let word = tape.words[cursor]
                if ["{", "}", ";"].containsName(word) { break }
                if cursor > head.genericEnd + 1, depth == 0, tape.lines[cursor] > tape.lines[cursor - 1],
                   !WhereJudge.sameName(word, ".") { break }
                if WhereJudge.sameName(word, "<") { depth += 1 }
                if WhereJudge.sameName(word, ">") { depth -= 1 }
                if depth < 0 { break }
                end = tape.ends[cursor]
                cursor += 1
            }
            let name = tape.words[head.name]
            guard depth == 0 else { try WhereJudge.fail("cannot read typealias '\(name)': unbalanced generic arguments") }
            let bodyWords = tape.words[(head.genericEnd + 1)..<cursor]
            guard !bodyWords.isEmpty else { try WhereJudge.fail("cannot read typealias '\(name)': empty right side") }
            var body = "", previous = ""
            for word in bodyWords {
                if !body.isEmpty && !WhereJudge.sameName(word, ".") && !WhereJudge.sameName(previous, ".") { body += " " }
                body += word
                previous = word
            }
            let parameterText: String
            if head.parameters.isEmpty { parameterText = "" }
            else {
                let a = tape.ends[head.name + 1], b = tape.starts[head.genericEnd - 1]
                parameterText = String(decoding: bytes[a..<b], as: UTF8.self)
            }
            let conditional = bodyWords.containsName("where") || (cursor < tape.words.count && WhereJudge.sameName(tape.words[cursor], "where"))
            result.append(([name, parameterText, body, conditional ? "where" : ""], range(start, end), range(tape.starts[head.keyword], start)))
        }
        return result
    }
}
