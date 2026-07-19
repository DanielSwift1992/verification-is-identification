// WHERE JUDGE — the second judge learns the conditional grammar. A world file
// states enums with typealias tables, top-level and generic typealiases,
// extensions gated by `where` equalities, and protocols gated the same way.
// This judge reads those statements, normalizes every term to one canon —
// aliases unfolded, generic parameters substituted, dotted axes resolved
// through the conformer's own table, Twice opened into Plus — and then judges
// each use of a gated head and each conformer of a gated protocol. On top of
// the structural canon the judge carries the counting canon: a Plus tree is
// flattened to its leaves, the counted leaves (Unit is one, Never is nothing)
// fold into one numeral, a Times of two numerals is their product, and the
// symbolic leaves are sorted, so two spellings of one number are one term and
// an arithmetic equality like 7 + 20 == 27 is judged where the nominal
// compiler sees two different types. A refusal
// speaks in the compiler's own voice: the two sides that had to be equivalent,
// named with their canons. The port's judge and this one must always agree,
// and the compiler stays the standard both answer to.

import Foundation

enum WhereJudge {
    typealias Term = Press.Term

    struct Conformer {
        let name: String
        let parameters: [String]
        let protocols: [String]
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
    }

    struct GatedProtocol {
        let name: String
        let equalities: [(String, String)]
    }

    static func fail(_ message: String) -> Never {
        FileHandle.standardError.write(Data("✗ THE WHERE: \(message)\n".utf8))
        exit(2)
    }

    // ── reading the world ──

    static func stripComments(_ text: String) -> String {
        var inFlagged = false
        var kept: [String] = []
        for line in text.split(separator: "\n", omittingEmptySubsequences: false) {
            let bare = line.trimmingCharacters(in: .whitespaces)
            if bare.hasPrefix("#if") {
                inFlagged = true
                continue
            }
            if bare.hasPrefix("#endif") {
                inFlagged = false
                continue
            }
            if inFlagged { continue }
            if let cut = line.range(of: "//") {
                kept.append(String(line[line.startIndex..<cut.lowerBound]))
            } else {
                kept.append(String(line))
            }
        }
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

    static func splitEqualities(_ clause: String) -> [(String, String)] {
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
        var pairs: [(String, String)] = []
        for part in parts {
            let sides = part.components(separatedBy: "==")
            if sides.count == 2 {
                pairs.append((
                    sides[0].trimmingCharacters(in: .whitespacesAndNewlines),
                    sides[1].trimmingCharacters(in: .whitespacesAndNewlines)
                ))
            }
        }
        return pairs
    }

    struct World {
        var conformers: [String: Conformer] = [:]
        var aliases: [String: AliasRule] = [:]
        var gates: [GatedExtension] = []
        var gatedProtocols: [String: GatedProtocol] = [:]
        var parameters: [String: [String]] = [:]
        var uses: [String] = []
    }

    static func read(_ text: String) -> World {
        let clean = stripComments(text)
        var world = World()

        for hit in captures(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*([\w,\s]+?)\s*\{([^{}]*)\}"#, clean
        ) {
            let name = hit[0]
            let parameters = parameterNames(hit[1])
            let protocols = hit[2]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            var table: [String: String] = [:]
            for aliasHit in captures(#"typealias\s+(\w+)\s*=\s*([^\n]+)"#, hit[3]) {
                table[aliasHit[0]] = aliasHit[1].trimmingCharacters(in: .whitespaces)
            }
            world.conformers[name] = Conformer(
                name: name, parameters: parameters, protocols: protocols, table: table
            )
        }

        for hit in captures(#"enum\s+(\w+)\s*<([^>]*)>"#, clean) {
            world.parameters[hit[0]] = parameterNames(hit[1])
        }

        for hit in captures(
            #"extension\s+(\w+)\s*\{[^{}]*?typealias\s+(\w+)\s*=\s*([^\n]+)"#, clean
        ) {
            let name = hit[0]
            if world.conformers[name] != nil {
                world.conformers[name]!.table[hit[1]] = hit[2].trimmingCharacters(in: .whitespaces)
            }
        }

        for hit in captures(
            #"typealias\s+(\w+)\s*(?:<([^>]*)>)?\s*=\s*([^\n]+)"#, clean
        ) {
            world.aliases[hit[0]] = AliasRule(
                parameters: parameterNames(hit[1]),
                body: hit[2].trimmingCharacters(in: .whitespaces)
            )
        }

        for hit in captures(
            #"extension\s+(\w+)\s*:\s*(\w+)\s*\n\s*where\s+([^{]+)\{"#, clean
        ) {
            world.gates.append(GatedExtension(
                head: hit[0], proto: hit[1], equalities: splitEqualities(hit[2])
            ))
        }

        for hit in captures(
            #"protocol\s+(\w+)\s*:\s*[\w,\s]+?\n\s*where\s+([^{]+)\{"#, clean
        ) {
            world.gatedProtocols[hit[0]] = GatedProtocol(
                name: hit[0], equalities: splitEqualities(hit[1])
            )
        }

        for hit in captures(#"([\w<>,\. ]+?)\s*\.self"#, clean) {
            let use = hit[0].trimmingCharacters(in: .whitespaces)
            if use.contains("<") { world.uses.append(use) }
        }
        return world
    }

    // ── the canon: one normal form for every term ──

    static func substitute(_ term: Term, _ bindings: [String: Term]) -> Term {
        if term.args.isEmpty, let bound = bindings[term.head] { return bound }
        if let dot = term.head.firstIndex(of: "."), term.args.isEmpty {
            let owner = String(term.head[term.head.startIndex..<dot])
            let axis = String(term.head[term.head.index(after: dot)...])
            if let bound = bindings[owner] {
                return Term(head: Press.serialize(bound) + "." + axis, args: [])
            }
        }
        return Term(head: term.head, args: term.args.map { substitute($0, bindings) })
    }

    static func normalize(_ term: Term, _ world: World, depth: Int = 0) -> Term {
        if depth > 64 { fail("normalization runs away on '\(Press.serialize(term))'") }

        if term.head == "Twice", term.args.count == 1 {
            let inner = term.args[0]
            return normalize(Term(head: "Plus", args: [inner, inner]), world, depth: depth + 1)
        }

        if let dot = term.head.firstIndex(of: "."), term.args.isEmpty {
            let ownerText = String(term.head[term.head.startIndex..<dot])
            let tail = String(term.head[term.head.index(after: dot)...])
            let segments = tail.split(separator: ".", maxSplits: 1).map(String.init)
            let axis = segments[0]
            let rest = segments.count > 1 ? segments[1] : ""
            let owner = normalize(Press.parseTerm(Substring(ownerText)), world, depth: depth + 1)
            if let conformer = world.conformers[owner.head], let stated = conformer.table[axis] {
                var bindings: [String: Term] = [:]
                for (name, argument) in zip(world.parameters[owner.head] ?? [], owner.args) {
                    bindings[name] = argument
                }
                let body = substitute(Press.parseTerm(Substring(stated)), bindings)
                let resolved = normalize(body, world, depth: depth + 1)
                if rest.isEmpty { return resolved }
                return normalize(
                    Term(head: Press.serialize(resolved) + "." + rest, args: []),
                    world, depth: depth + 1
                )
            }
            let stuck = Press.serialize(owner) + "." + axis
            if rest.isEmpty { return Term(head: stuck, args: []) }
            return Term(head: stuck + "." + rest, args: [])
        }

        if let alias = world.aliases[term.head], alias.parameters.count == term.args.count {
            var bindings: [String: Term] = [:]
            for (name, argument) in zip(alias.parameters, term.args) {
                bindings[name] = argument
            }
            let body = substitute(Press.parseTerm(Substring(alias.body)), bindings)
            return normalize(body, world, depth: depth + 1)
        }

        return Term(head: term.head, args: term.args.map { normalize($0, world, depth: depth + 1) })
    }

    // ── the counting canon: two spellings of one number are one term ──
    // Twice is already open by the time this pass reads a term, so a number is a
    // tree of Plus over counted leaves. The pass flattens every Plus into its
    // leaves, folds the counted leaves into one numeral, multiplies a Times whose
    // two sides are both numerals, and sorts the symbolic leaves, so the spelling
    // of a number cannot tell two equal numbers apart. The port's judge mirrors
    // this pass, the same law as the structural canon above.

    static func counted(_ term: Term) -> Int? {
        guard term.args.isEmpty else { return nil }
        if term.head == "Unit" { return 1 }
        if term.head == "Never" { return 0 }
        if term.head.hasPrefix("#") { return Int(term.head.dropFirst()) }
        return nil
    }

    static func numeral(_ count: Int) -> Term { Term(head: "#\(count)", args: []) }

    static func arithmetic(_ term: Term) -> Term {
        let folded = Term(head: term.head, args: term.args.map { arithmetic($0) })
        if let count = counted(folded) { return numeral(count) }
        if folded.head == "Times", folded.args.count == 2,
           let left = counted(folded.args[0]), let right = counted(folded.args[1]) {
            return numeral(left * right)
        }
        guard folded.head == "Plus", folded.args.count == 2 else { return folded }
        var leaves: [Term] = []
        var count = 0
        var pile = folded.args
        while let piece = pile.popLast() {
            if piece.head == "Plus", piece.args.count == 2 {
                pile.append(contentsOf: piece.args)
                continue
            }
            if let n = counted(piece) { count += n } else { leaves.append(piece) }
        }
        leaves.sort { Press.serialize($0) < Press.serialize($1) }
        if leaves.isEmpty { return numeral(count) }
        if count > 0 { leaves.append(numeral(count)) }
        var result = leaves.removeLast()
        while let next = leaves.popLast() {
            result = Term(head: "Plus", args: [next, result])
        }
        return result
    }

    static func canon(_ text: String, _ world: World) -> String {
        Press.serialize(arithmetic(normalize(Press.parseTerm(Substring(text)), world)))
    }

    // ── the judgement ──

    static func run(_ arguments: [String]) {
        guard let path = arguments.first else {
            fail("usage: judge where <world.swift>")
        }
        guard let text = try? String(contentsOfFile: path, encoding: .utf8) else {
            fail("cannot read \(path)")
        }
        let world = read(text)
        var refusals: [String] = []
        var judged = 0

        for use in world.uses {
            let term = Press.parseTerm(Substring(use))
            let matching = world.gates.filter { $0.head == term.head }
            guard !matching.isEmpty else { continue }
            guard let parameters = world.parameters[term.head] else { continue }
            var bindings: [String: Term] = [:]
            for (name, argument) in zip(parameters, term.args) {
                bindings[name] = argument
            }
            for gate in matching {
                for (left, right) in gate.equalities {
                    judged += 1
                    let leftTerm = substitute(Press.parseTerm(Substring(left)), bindings)
                    let rightTerm = substitute(Press.parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(arithmetic(normalize(leftTerm, world)))
                    let rightCanon = Press.serialize(arithmetic(normalize(rightTerm, world)))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(use)' requires the types '\(left)' (aka '\(leftCanon)') and "
                                + "'\(right)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
                        )
                    }
                }
            }
        }

        for conformer in world.conformers.values {
            for protoName in conformer.protocols {
                guard let gated = world.gatedProtocols[protoName] else { continue }
                for (left, right) in gated.equalities {
                    judged += 1
                    let leftText = left.contains(".") ? left : conformer.name + "." + left
                    let rightText = right.contains(".") || world.conformers[right] != nil || right == "Never"
                        ? right
                        : conformer.name + "." + right
                    let leftCanon = canon(leftText, world)
                    let rightCanon = canon(rightText, world)
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(conformer.name): \(protoName)' requires the types '\(left)' "
                                + "(aka '\(leftCanon)') and '\(right)' (aka '\(rightCanon)') be equivalent"
                        )
                    }
                }
            }
        }

        if refusals.isEmpty {
            print("✓ THE WHERE holds: \(judged) equalities judged across \(world.uses.count) uses and the gated conformers, one canon each side.")
        } else {
            for refusal in refusals { print("✗ \(refusal)") }
            exit(1)
        }
    }
}
