import Foundation

// ═══════════════════════════════════════════════════════
// Press applies one rewrite triple to one state file: `swift run Tools press <Rule>
// [--file <path>]`. This is the whole applier the dynamics medium ever needs, for
// every domain at once: find the rule's slot alias, compare the slot's term with the
// rule's pattern, substitute the template. One match or none, never a search; a
// mismatch is a lawful no-op that leaves the file byte-identical. No domain logic
// stands here or ever will: a system's behaviour is its triples
// (Sources/Examples/Dynamics.swift), and the judge already admitted every press
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

    static func run(_ args: [String]) {
        var arguments = args
        var statePath = defaultStatePath
        if let flag = arguments.firstIndex(of: "--file"), flag + 1 < arguments.count {
            statePath = arguments[flag + 1]
            arguments.removeSubrange(flag...flag + 1)
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
        // A comma spells a chord: several rules of ONE slot behind one face (§S30). At any
        // state at most one may match; two matches name an unlawful chord and refuse.
        let rules = ruleArgument.split(separator: ",").map {
            readRule(named: String($0), from: dictionary)
        }
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

        // The match: a bare-variable pattern binds the whole term, a literal pattern
        // must be the term verbatim. One match or none, across the whole chord.
        var matched: (rule: Rule, bindings: [String: String])?
        for rule in rules {
            var bindings: [String: String] = [:]
            if rule.variables.contains(rule.from) {
                bindings[rule.from] = current
            } else if rule.from != current {
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
