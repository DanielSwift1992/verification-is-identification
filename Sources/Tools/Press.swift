import Foundation

// ═══════════════════════════════════════════════════════
// Press applies one rewrite triple to one state file: `swift run Tools press <Rule>
// [--file <path>]`. This is the whole applier the dynamics medium ever needs, for
// every domain at once: find the rule's slot alias, compare the slot's term with the
// rule's pattern, substitute the template. One match or none, never a search; a
// mismatch is a lawful no-op that leaves the file byte-identical. No domain logic
// stands here or ever will: a system's behaviour is its triples
// (Sources/DynamicsDemo/Rules.swift), and the judge already admitted every press
// when it compiled the rule's generic declaration.
// ═══════════════════════════════════════════════════════

enum Press {
    static let dictionaryPath = "Sources/DynamicsDemo/Rules.swift"
    static let defaultStatePath = "Sources/DynamicsDemo/WorldState.swift"

    struct Rule {
        let name: String
        let variables: [String]
        let slot: String
        let from: String
        let into: String
    }

    static func fail(_ message: String) -> Never {
        FileHandle.standardError.write(Data(("press: " + message + "\n").utf8))
        exit(1)
    }

    /// Reads one rule's triple out of the dictionary's text: the enum's generic
    /// parameter names, and its Slot/From/Into aliases.
    static func readRule(named name: String, from text: String) -> Rule {
        var variables: [String] = []
        var slot = ""
        var from = ""
        var into = ""
        var inside = false
        for raw in text.split(separator: "\n", omittingEmptySubsequences: false) {
            let line = raw.trimmingCharacters(in: .whitespaces)
            if !inside {
                guard line.hasPrefix("public enum \(name)") || line.hasPrefix("enum \(name)") else { continue }
                let head = line
                if let open = head.firstIndex(of: "<"), let close = head.firstIndex(of: ">") {
                    let inner = head[head.index(after: open)..<close]
                    for piece in inner.split(separator: ",") {
                        let variable = piece.split(separator: ":").first.map {
                            $0.trimmingCharacters(in: .whitespaces)
                        } ?? ""
                        if !variable.isEmpty {
                            variables.append(variable)
                        }
                    }
                }
                inside = true
                continue
            }
            if line.hasPrefix("}") {
                break
            }
            var carried = line.isEmpty || line.hasPrefix("//")
            for (key, sink) in [("Slot", 0), ("From", 1), ("Into", 2)] {
                let marker = "typealias \(key) = "
                guard let range = line.range(of: marker) else { continue }
                let value = String(line[range.upperBound...])
                switch sink {
                case 0: slot = value
                case 1: from = value
                default: into = value
                }
                carried = true
            }
            // §S28's edge at the point of use: a rule is one substitution, so a body
            // line that is not one of the three aliases refuses the whole press.
            guard carried else {
                fail("\(name) is not a triple: \(line)")
            }
        }
        guard inside else { fail("no rule named \(name) in \(dictionaryPath)") }
        guard !slot.isEmpty, !from.isEmpty, !into.isEmpty else {
            fail("\(name) states no full Slot/From/Into triple")
        }
        return Rule(name: name, variables: variables, slot: slot, from: from, into: into)
    }

    /// Substitutes bound variables into a template by whole-word replacement.
    static func fill(_ template: String, _ bindings: [String: String]) -> String {
        var out = ""
        var word = ""
        for ch in template + " " {
            if ch.isLetter || ch.isNumber {
                word.append(ch)
            } else {
                out += bindings[word] ?? word
                word = ""
                if ch != " " || out.last == "," {
                    out.append(ch)
                }
            }
        }
        return String(out.dropLast(out.hasSuffix(" ") ? 1 : 0))
    }

    /// A term as its head and arguments: the one shape every pattern, every slot
    /// term, and every instance argument shares.
    struct Term {
        let head: String
        let args: [Term]
    }

    static func parseTerm(_ text: Substring) -> Term {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard let open = trimmed.firstIndex(of: "<"), trimmed.hasSuffix(">") else {
            return Term(head: trimmed, args: [])
        }
        let head = String(trimmed[trimmed.startIndex..<open])
        let inner = trimmed[trimmed.index(after: open)...].dropLast()
        var args: [Term] = []
        var depth = 0
        var piece = ""
        for ch in inner {
            if ch == "<" { depth += 1 }
            if ch == ">" { depth -= 1 }
            if ch == ",", depth == 0 {
                args.append(parseTerm(Substring(piece)))
                piece = ""
            } else {
                piece.append(ch)
            }
        }
        if !piece.trimmingCharacters(in: .whitespaces).isEmpty {
            args.append(parseTerm(Substring(piece)))
        }
        return Term(head: head, args: args)
    }

    static func serialize(_ term: Term) -> String {
        term.args.isEmpty
            ? term.head
            : term.head + "<" + term.args.map(serialize).joined(separator: ", ") + ">"
    }

    /// Collects each variable's occurrence count across a pattern: linearity is
    /// the theorem's premise (one occurrence keeps the match unique), so a
    /// repeated variable refuses the rule before any state is touched.
    static func occurrences(in pattern: Term, of variables: [String], into counts: inout [String: Int]) {
        if pattern.args.isEmpty, variables.contains(pattern.head) {
            counts[pattern.head, default: 0] += 1
            return
        }
        for argument in pattern.args {
            occurrences(in: argument, of: variables, into: &counts)
        }
    }

    /// Structural unification of a linear pattern against a term: a variable node
    /// binds whole (or agrees with its instance pre-binding), a constant node
    /// demands the same head and unifies its arguments. One match or none.
    static func unify(_ pattern: Term, _ term: Term, variables: [String], bindings: inout [String: String]) -> Bool {
        if pattern.args.isEmpty, variables.contains(pattern.head) {
            let value = serialize(term)
            if let bound = bindings[pattern.head] {
                return bound == value
            }
            bindings[pattern.head] = value
            return true
        }
        guard pattern.head == term.head, pattern.args.count == term.args.count else {
            return false
        }
        for (patternArgument, termArgument) in zip(pattern.args, term.args) {
            guard unify(patternArgument, termArgument, variables: variables, bindings: &bindings) else {
                return false
            }
        }
        return true
    }

    /// The literal alphabet: what free text may carry into a typeName. Everything
    /// that could escape the literal (quotes, slashes, angles) is outside it, so
    /// the literal's FORM survives every press and the judge only ever sees a
    /// well-formed file. The refusal names the character.
    static func vetLiteral(_ text: String) {
        for ch in text {
            let allowed = ch.isLetter || ch.isNumber || ch == " " || ch == "."
                || ch == "," || ch == "!" || ch == "?" || ch == "-"
            guard allowed else {
                fail("\"\(ch)\" is outside the literal's alphabet (letters, digits, space, .,!?-)")
            }
        }
    }

    /// The literal slot's three movements: append, rubout, clear. Free text lives
    /// in a typeName (the prose genre), a label draws it with no reader between,
    /// and the judge vets the file's form, never the words.
    static func pressLiteral(_ operation: String, _ arguments: [String], statePath: String) {
        guard let slotName = arguments.first else {
            fail("usage: Tools press \(operation) <Slot> \(operation == "append" ? "<text> " : "")[--file <state file>]")
        }
        guard let state = try? String(contentsOfFile: statePath, encoding: .utf8) else {
            fail("cannot read \(statePath)")
        }
        var lines = state.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        var insideExtension = false
        for (number, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("extension \(slotName) ") || trimmed.hasPrefix("extension \(slotName){") {
                insideExtension = true
                continue
            }
            guard insideExtension else { continue }
            if trimmed.hasPrefix("}") { break }
            guard let open = line.range(of: "{ \""), let close = line.range(of: "\" }") else { continue }
            let current = String(line[open.upperBound..<close.lowerBound])
            var next = current
            switch operation {
            case "append":
                let text = arguments.dropFirst().joined(separator: " ")
                vetLiteral(text)
                next = current + text
            case "rubout":
                next = String(current.dropLast())
            default:
                next = ""
            }
            lines[number] = line.replacingOccurrences(of: "{ \"\(current)\" }", with: "{ \"\(next)\" }")
            try? lines.joined(separator: "\n").write(toFile: statePath, atomically: true, encoding: .utf8)
            print("pressed \(operation) \(slotName): \"\(current)\" -> \"\(next)\"")
            return
        }
        fail("no literal slot \(slotName) in \(statePath)")
    }

    static func run(_ args: [String]) {
        var arguments = args
        var statePath = defaultStatePath
        if let flag = arguments.firstIndex(of: "--file"), flag + 1 < arguments.count {
            statePath = arguments[flag + 1]
            arguments.removeSubrange(flag...flag + 1)
        }
        if let first = arguments.first, first == "append" || first == "rubout" || first == "clear" {
            pressLiteral(first, Array(arguments.dropFirst()), statePath: statePath)
            return
        }
        guard let ruleArgument = arguments.first else {
            fail("usage: Tools press <Rule>[,<Rule>…] [--file <state file>]")
        }
        guard let dictionary = try? String(contentsOfFile: dictionaryPath, encoding: .utf8) else {
            fail("cannot read \(dictionaryPath)")
        }
        guard let state = try? String(contentsOfFile: statePath, encoding: .utf8) else {
            fail("cannot read \(statePath)")
        }
        // A comma at depth zero spells a chord: several rules of ONE slot behind one
        // face (§S30). An angle bracket spells an instance: `Rule<Atom>` hands the rule
        // the arguments its pattern cannot bind (§S28's typed input). At any
        // state at most one member may match; two matches name an unlawful chord.
        var memberTexts: [String] = []
        var depth = 0
        var piece = ""
        for ch in ruleArgument {
            if ch == "<" { depth += 1 }
            if ch == ">" { depth -= 1 }
            if ch == ",", depth == 0 {
                memberTexts.append(piece)
                piece = ""
            } else {
                piece.append(ch)
            }
        }
        memberTexts.append(piece)
        let members = memberTexts.map { text -> (rule: Rule, instance: [Term]) in
            let spelled = parseTerm(Substring(text))
            return (readRule(named: spelled.head, from: dictionary), spelled.args)
        }
        let rules = members.map(\.rule)
        guard let firstSlot = rules.first?.slot, rules.allSatisfy({ $0.slot == firstSlot }) else {
            fail("a chord holds one slot: \(ruleArgument) mixes \(Set(rules.map(\.slot)).sorted().joined(separator: ", "))")
        }

        // The slot marker drops its `Slot` suffix to name the alias in the state file.
        var aliasName = firstSlot
        if aliasName.hasSuffix("Slot") {
            aliasName = String(aliasName.dropLast(4))
        }
        let marker = "typealias \(aliasName) = "
        var lines = state.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        var slotLine: Int?
        for (number, line) in lines.enumerated() {
            if line.trimmingCharacters(in: .whitespaces).hasPrefix(marker) {
                guard slotLine == nil else { fail("slot \(aliasName) appears twice in \(statePath)") }
                slotLine = number
            }
        }
        guard let found = slotLine else {
            fail("no slot \(aliasName) in \(statePath)")
        }
        let current = String(
            lines[found][lines[found].range(of: marker)!.upperBound...]
        ).trimmingCharacters(in: .whitespaces)

        // The match: a variable node binds whole, a constant node demands its head,
        // and the pattern is LINEAR (each variable once) so the match is unique or
        // absent (T1). A parameter the pattern never mentions is instance-bound: it
        // must arrive with the press, and the judge of the NEXT state is what vets
        // it — an atom outside the alphabet refuses to build, so typed input never
        // widens the judged world. One match or none, across the whole chord.
        let currentTerm = parseTerm(Substring(current))
        var matched: (rule: Rule, bindings: [String: String])?
        for (rule, instance) in members {
            let pattern = parseTerm(Substring(rule.from))
            var counts: [String: Int] = [:]
            occurrences(in: pattern, of: rule.variables, into: &counts)
            for (variable, count) in counts {
                if count > 1 {
                    fail("\(rule.name) repeats \(variable) in its pattern: linearity is the premise of the unique match")
                }
            }
            var bindings: [String: String] = [:]
            let instanceBound = rule.variables.filter { counts[$0] == nil }
            guard instance.count <= instanceBound.count else {
                fail("\(rule.name) takes \(instanceBound.count) instance argument(s), \(instance.count) given")
            }
            guard instance.count == instanceBound.count else {
                fail("\(rule.name) needs its instance argument(s) \(instanceBound.joined(separator: ", ")): press \(rule.name)<…>")
            }
            for (variable, argument) in zip(instanceBound, instance) {
                bindings[variable] = serialize(argument)
            }
            guard unify(pattern, currentTerm, variables: rule.variables, bindings: &bindings) else {
                continue
            }
            guard matched == nil else {
                fail("ambiguous chord: \(matched!.rule.name) and \(rule.name) both match \(aliasName) = \(current)")
            }
            matched = (rule, bindings)
        }
        guard let (rule, bindings) = matched else {
            let expected = rules.map(\.from).joined(separator: " or ")
            print("no-op: \(aliasName) is \(current), \(ruleArgument) expects \(expected)")
            return
        }
        let next = fill(rule.into, bindings)
        let indent = lines[found].prefix(while: { $0 == " " })
        lines[found] = indent + marker + next
        try? lines.joined(separator: "\n").write(toFile: statePath, atomically: true, encoding: .utf8)
        print("pressed \(rule.name): \(aliasName) \(current) -> \(next)")
    }
}
