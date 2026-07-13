import Foundation

// ═══════════════════════════════════════════════════════════════
// JUDGE — the second arbiter: a linear checker over the generated System fragment,
// seated beside the Swift type checker as a second encoding of one verdict (§5.4,
// the gauge paper's witness, FiG6). Its whole work is two passes: a dictionary of
// declarations, then one lookup per reference and one table row per premise. No
// solver, no inference, no scope-sized term: the price is the token count.
//
// THE FRAGMENT it reads (GeneratedTeam.swift's shapes, stated so a foreign line is
// refused with an address rather than absorbed):
//   · `public enum Name: Conf, Conf {`  — a declaration, possibly nested (slices)
//   · `public typealias Key = Target`  — a coordinate; Target is a dotted path of
//     names, own aliases, members, and `Next` steps (`Lead`, `Given.Sex`,
//     `Emp0041.Rank.Next` are all one grammar)
//   · `@StructureBuilder` + `public static var body: some Structure {` — a body of
//     entries `Name.self;` / `Gate<A, B>.self;`, one or many per line, multiline legal
//   · `}` closes a body or a declaration
//   · comments, blank lines, `import` — carried, never judged
//
// THE TABLE it carries (the policy stated a second time, on purpose: the differential
// seat checks the two encodings against each other, and a disagreement bisects to a
// minimal witness):
//   ranks, departments, workplaces, genders, the four shares and their homes, the
//   premises of Employee/Person/the cycles, and the four gates' equalities.
//
// VALUES resolve iteratively: an explicit worklist and a memo, one lookup per link,
// each coordinate settled once. The standing arbiter's deserializer unwound a
// derivation chain one stack frame per link and died at depth; the judge walks the
// same chain flat, so depth is priced like everything else — by the token.
// ═══════════════════════════════════════════════════════════════

enum Judge {

    // ── the verdict ──

    struct Refusal {
        let file: String
        let line: Int
        let premise: String
    }

    // ── the parsed record ──

    final class Declaration {
        let name: String
        let qualified: String
        let parent: String?
        let conformances: [String]
        let line: Int
        var aliases: [String: (target: String, line: Int)] = [:]
        var entries: [(head: String, arguments: [String], line: Int)] = []

        init(name: String, qualified: String, parent: String?, conformances: [String], line: Int) {
            self.name = name
            self.qualified = qualified
            self.parent = parent
            self.conformances = conformances
            self.line = line
        }
    }

    // ── the table: the policy, stated a second time ──

    static let rankCapabilities: [String: Set<String>] = [
        "IndividualContributor": ["CanView"],
        "Lead": ["CanView", "CanEdit"],
        "Manager": ["CanView", "CanEdit", "CanAdmin"],
    ]
    static let departments: Set<String> = ["Finance", "Engineering", "Sales", "People"]
    static let workplaces: Set<String> = ["OnSite", "Hybrid", "Remote"]
    static let genders: Set<String> = ["Male", "Female"]
    static let shareHomes: [String: String] = [
        "FinanceShare": "Finance", "EngineeringShare": "Engineering",
        "SalesShare": "Sales", "PeopleShare": "People",
    ]

    /// The table states each seeded cycle's rotation: one `Next` step costs one row,
    /// whatever the depth of the chain that asks for it.
    static let nextInCycle: [String: String] = [
        "IndividualContributor": "Lead", "Lead": "Manager",
        "Manager": "IndividualContributor",
        "Finance": "Engineering", "Engineering": "Sales",
        "Sales": "People", "People": "Finance",
        "OnSite": "Hybrid", "Hybrid": "Remote", "Remote": "OnSite",
    ]

    /// A conformance imposes these requirements on the declaration's aliases: the key
    /// must exist, and its resolved value must land in the named category.
    static let conformanceRequirements: [String: [(key: String, category: String)]] = [
        "Employee": [("Rank", "rank"), ("Home", "department")],
        "Person": [
            ("Given", "givenName"), ("Family", "familyName"), ("Sex", "gender"),
            ("Born", "birthYear"), ("Site", "workplace"),
        ],
        "GivenNameCycle": [("Next", "givenName"), ("Sex", "gender")],
        "FamilyNameCycle": [("Next", "familyName")],
        "BirthYearCycle": [("Next", "birthYear")],
    ]

    /// Each gate demands one equality between its two arguments' coordinates.
    /// `nil` on the right reads the argument itself as the value.
    static let gatePremises: [String: (left: String, right: String?)] = [
        "VerifiedView": ("Home", "Home"),
        "VerifiedInDepartment": ("Home", nil),
        "VerifiedAtRank": ("Rank", nil),
        "VerifiedAtWorkplace": ("Site", nil),
    ]

    // ── pass 1: the dictionary ──

    static func parse(
        file: String, text: String,
        into declarations: inout [String: Declaration],
        order: inout [String],
        refusals: inout [Refusal]
    ) {
        var stack: [Declaration] = []
        var bodyOwner: Declaration?
        var buffer = ""
        var bufferLine = 0

        func drainEntries(upTo lineNumber: Int, final: Bool) {
            var depth = 0
            var current = ""
            var closed: [String] = []
            for character in buffer {
                current.append(character)
                if character == "<" { depth += 1 }
                if character == ">" { depth -= 1 }
                if depth == 0, current.hasSuffix(".self") {
                    closed.append(current)
                    current = ""
                }
                if depth == 0, character == ";" || character == " ",
                    current.trimmingCharacters(in: .whitespaces).isEmpty {
                    current = ""
                }
            }
            let rest = current
            for closedEntry in closed {
                var entry = String(closedEntry.dropLast(5))
                entry = entry.trimmingCharacters(in: CharacterSet(charactersIn: "; \n\t"))
                let head: String
                var arguments: [String] = []
                if let open = entry.firstIndex(of: "<") {
                    head = String(entry[entry.startIndex..<open])
                    let inner = String(entry[entry.index(after: open)..<entry.index(before: entry.endIndex)])
                    var argumentDepth = 0
                    var piece = ""
                    for character in inner {
                        if character == "<" { argumentDepth += 1 }
                        if character == ">" { argumentDepth -= 1 }
                        if character == ",", argumentDepth == 0 {
                            arguments.append(piece.trimmingCharacters(in: .whitespacesAndNewlines))
                            piece = ""
                        } else {
                            piece.append(character)
                        }
                    }
                    arguments.append(piece.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    head = entry
                }
                bodyOwner?.entries.append((head: head, arguments: arguments, line: bufferLine))
            }
            buffer = final ? "" : rest
            if closed.isEmpty == false { bufferLine = lineNumber }
        }

        let lines = text.components(separatedBy: "\n")
        for (index, raw) in lines.enumerated() {
            let number = index + 1
            let line = raw.trimmingCharacters(in: .whitespaces)
            if line.isEmpty { continue }
            if line.hasPrefix("//") { continue }
            if line.hasPrefix("import ") { continue }
            if line.hasPrefix("@StructureBuilder") { continue }

            if bodyOwner != nil {
                if line == "}" {
                    drainEntries(upTo: number, final: true)
                    let leftover = buffer.trimmingCharacters(in: .whitespacesAndNewlines)
                    if leftover.isEmpty == false {
                        refusals.append(Refusal(file: file, line: number,
                            premise: "a body entry did not close: `\(leftover.prefix(60))`"))
                    }
                    bodyOwner = nil
                    continue
                }
                if buffer.isEmpty { bufferLine = number }
                buffer += line + " "
                drainEntries(upTo: number, final: false)
                continue
            }

            if line.hasPrefix("public enum ") || line.hasPrefix("enum ") {
                let afterKeyword = line.replacingOccurrences(of: "public enum ", with: "")
                    .replacingOccurrences(of: "enum ", with: "")
                let head = afterKeyword.replacingOccurrences(of: " {", with: "")
                let pieces = head.split(separator: ":", maxSplits: 1)
                let name = pieces[0].trimmingCharacters(in: .whitespaces)
                var conformances: [String] = []
                if pieces.count == 2 {
                    conformances = pieces[1].split(separator: ",").map {
                        $0.trimmingCharacters(in: .whitespaces)
                    }
                }
                let parent = stack.last?.qualified
                let qualified = parent.map { "\($0).\(name)" } ?? name
                let declaration = Declaration(name: name, qualified: qualified,
                    parent: parent, conformances: conformances, line: number)
                declarations[qualified] = declaration
                order.append(qualified)
                stack.append(declaration)
                continue
            }

            if line.hasPrefix("public typealias ") {
                let body = line.replacingOccurrences(of: "public typealias ", with: "")
                let sides = body.split(separator: "=", maxSplits: 1)
                if sides.count == 2, let owner = stack.last {
                    let key = sides[0].trimmingCharacters(in: .whitespaces)
                    let target = sides[1].trimmingCharacters(in: .whitespaces)
                    owner.aliases[key] = (target: target, line: number)
                } else {
                    refusals.append(Refusal(file: file, line: number,
                        premise: "a typealias stands outside every declaration"))
                }
                continue
            }

            if line.hasPrefix("public static var body: some Structure {") {
                bodyOwner = stack.last
                buffer = ""
                continue
            }

            if line == "}" {
                if stack.isEmpty {
                    refusals.append(Refusal(file: file, line: number,
                        premise: "a closing brace with nothing open"))
                } else {
                    stack.removeLast()
                }
                continue
            }

            refusals.append(Refusal(file: file, line: number,
                premise: "outside the fragment: `\(line.prefix(60))`"))
        }
    }

    // ── the values: an explicit worklist and a memo, no call recursion ──

    struct Slot: Hashable {
        let owner: String
        let key: String
    }

    final class Values {
        var settled: [Slot: String] = [:]
        var refused: [Slot: String] = [:]
        var lookups = 0
    }

    static func isSeed(_ name: String) -> Bool {
        if rankCapabilities[name] != nil { return true }
        if departments.contains(name) { return true }
        if workplaces.contains(name) { return true }
        if genders.contains(name) { return true }
        if shareHomes[name] != nil { return true }
        return false
    }

    /// Settles one coordinate by walking its alias path left to right, one lookup per
    /// segment. A segment that depends on another coordinate pushes it and returns to
    /// it later, so a chain of any depth settles link by link on an explicit
    /// worklist, each link once. A coordinate that reaches itself is refused by name.
    static func value(
        of start: Slot, declarations: [String: Declaration], values: Values
    ) -> String? {
        if let known = values.settled[start] { return known }
        if values.refused[start] != nil { return nil }
        var pending: [Slot] = [start]
        var inFlight: Set<Slot> = [start]
        while let top = pending.last {
            if values.settled[top] != nil || values.refused[top] != nil {
                pending.removeLast()
                inFlight.remove(top)
                continue
            }
            guard let owner = declarations[top.owner] else {
                values.refused[top] = "\(top.owner) resolves to nothing"
                continue
            }
            guard let alias = owner.aliases[top.key] else {
                values.refused[top] = "\(top.owner) states no \(top.key)"
                continue
            }
            let segments = alias.target.split(separator: ".").map(String.init)
            var cursor: String?
            var waiting: Slot?
            var reason: String?
            var index = 0
            let headSegment = segments[0]
            values.lookups += 1
            if owner.aliases[headSegment] != nil, segments.count > 1 || headSegment != top.key {
                waiting = Slot(owner: top.owner, key: headSegment)
            } else if declarations[headSegment] != nil || isSeed(headSegment) {
                cursor = headSegment
                index = 1
            } else {
                reason = "the name \(headSegment) resolves to nothing"
            }
            if let dependency = waiting, let known = values.settled[dependency] {
                cursor = known
                waiting = nil
                index = 1
            }
            if let dependency = waiting, let failed = values.refused[dependency] {
                reason = failed
                waiting = nil
            }
            while reason == nil, waiting == nil, index < segments.count {
                let member = segments[index]
                let base = cursor!
                values.lookups += 1
                if member == "Next", let follower = nextInCycle[base] {
                    cursor = follower
                    index += 1
                    continue
                }
                if let carrier = declarations[base], carrier.aliases[member] != nil {
                    let dependency = Slot(owner: base, key: member)
                    if let known = values.settled[dependency] {
                        cursor = known
                        index += 1
                        continue
                    }
                    if let failed = values.refused[dependency] {
                        reason = failed
                        continue
                    }
                    waiting = dependency
                    continue
                }
                reason = "\(base) carries no \(member)"
            }
            if let stated = reason {
                values.refused[top] = stated
                continue
            }
            if let dependency = waiting {
                if inFlight.contains(dependency) {
                    values.refused[top] = "\(top.owner).\(top.key) derives from itself"
                    continue
                }
                pending.append(dependency)
                inFlight.insert(dependency)
                continue
            }
            values.settled[top] = cursor!
        }
        return values.settled[start]
    }

    /// Names the category a value lands in: a seeded fact of the table, or a parsed
    /// declaration read by its conformances.
    static func category(of name: String, declarations: [String: Declaration]) -> String? {
        if rankCapabilities[name] != nil { return "rank" }
        if departments.contains(name) { return "department" }
        if workplaces.contains(name) { return "workplace" }
        if genders.contains(name) { return "gender" }
        if shareHomes[name] != nil { return "share" }
        guard let declaration = declarations[name] else { return nil }
        if declaration.conformances.contains("GivenNameCycle") { return "givenName" }
        if declaration.conformances.contains("FamilyNameCycle") { return "familyName" }
        if declaration.conformances.contains("BirthYearCycle") { return "birthYear" }
        if declaration.conformances.contains("Employee") { return "person" }
        return "declaration"
    }

    /// Reads a subject's coordinate: a share's home comes from the table, anything
    /// else settles as a value.
    static func coordinate(
        _ key: String, of name: String,
        declarations: [String: Declaration], values: Values
    ) -> String? {
        if key == "Home", let home = shareHomes[name] { return home }
        return value(of: Slot(owner: name, key: key), declarations: declarations,
            values: values)
    }

    // ── pass 2: premises against the table ──

    static func check(
        file: String,
        declarations: [String: Declaration],
        order: [String],
        values: Values,
        refusals: inout [Refusal]
    ) -> Int {
        var premises = 0

        for qualified in order {
            let declaration = declarations[qualified]!

            for conformance in declaration.conformances {
                guard let requirements = conformanceRequirements[conformance] else { continue }
                for requirement in requirements {
                    premises += 1
                    guard let alias = declaration.aliases[requirement.key] else {
                        refusals.append(Refusal(file: file, line: declaration.line,
                            premise: "\(conformance) requires \(requirement.key): "
                                + "\(declaration.name) states none"))
                        continue
                    }
                    let slot = Slot(owner: qualified, key: requirement.key)
                    guard let settled = value(of: slot, declarations: declarations,
                        values: values) else {
                        let reason = values.refused[slot] ?? "unresolved"
                        refusals.append(Refusal(file: file, line: alias.line,
                            premise: "\(declaration.name).\(requirement.key): \(reason)"))
                        continue
                    }
                    let landed = category(of: settled, declarations: declarations)
                    if landed != requirement.category {
                        refusals.append(Refusal(file: file, line: alias.line,
                            premise: "\(conformance) requires \(requirement.key) in "
                                + "\(requirement.category): \(declaration.name).\(requirement.key) "
                                + "= \(settled) lands in \(landed ?? "nothing")"))
                    }
                }
            }

            for entry in declaration.entries {
                if let premise = gatePremises[entry.head] {
                    premises += 1
                    guard entry.arguments.count == 2 else {
                        refusals.append(Refusal(file: file, line: entry.line,
                            premise: "\(entry.head) wants two arguments, "
                                + "\(entry.arguments.count) stand"))
                        continue
                    }
                    let subject = entry.arguments[0]
                    let object = entry.arguments[1]
                    guard let left = coordinate(premise.left, of: subject,
                        declarations: declarations, values: values) else {
                        refusals.append(Refusal(file: file, line: entry.line,
                            premise: "\(entry.head): \(subject).\(premise.left) "
                                + "resolves to nothing"))
                        continue
                    }
                    var right = object
                    if let rightKey = premise.right {
                        guard let resolved = coordinate(rightKey, of: object,
                            declarations: declarations, values: values) else {
                            refusals.append(Refusal(file: file, line: entry.line,
                                premise: "\(entry.head): \(object).\(rightKey) "
                                    + "resolves to nothing"))
                            continue
                        }
                        right = resolved
                    }
                    if left != right {
                        let rightSpelled = premise.right.map { "\(object).\($0)" } ?? object
                        refusals.append(Refusal(file: file, line: entry.line,
                            premise: "\(entry.head) requires \(subject).\(premise.left) == "
                                + "\(rightSpelled): \(left) against \(right)"))
                    }
                    continue
                }
                if entry.arguments.isEmpty {
                    values.lookups += 1
                    let near = declaration
                    var found = declarations[entry.head] != nil
                    if found == false, near.parent != nil {
                        found = declarations["\(near.parent!).\(entry.head)"] != nil
                    }
                    if found == false {
                        found = declarations["\(near.qualified).\(entry.head)"] != nil
                    }
                    if found == false {
                        found = isSeed(entry.head)
                    }
                    if found == false {
                        refusals.append(Refusal(file: file, line: entry.line,
                            premise: "the entry \(entry.head) resolves to nothing"))
                    }
                    continue
                }
                refusals.append(Refusal(file: file, line: entry.line,
                    premise: "an unknown gate: \(entry.head)"))
            }
        }
        return premises
    }

    // ── one full judgment, reusable by the differential harness ──

    struct Judgment {
        let declarations: Int
        let lookups: Int
        let premises: Int
        let milliseconds: Double
        let refusals: [Refusal]
        let coordinates: [String: [String: String]]
    }

    static func judge(paths: [String]) -> Judgment? {
        let started = DispatchTime.now()
        var declarations: [String: Declaration] = [:]
        var order: [String] = []
        var refusals: [Refusal] = []
        var premises = 0
        let values = Values()
        for path in paths {
            guard let text = try? String(contentsOfFile: path, encoding: .utf8) else {
                return nil
            }
            let file = (path as NSString).lastPathComponent
            parse(file: file, text: text, into: &declarations, order: &order,
                refusals: &refusals)
            premises += check(file: file, declarations: declarations, order: order,
                values: values, refusals: &refusals)
        }
        var coordinates: [String: [String: String]] = [:]
        for qualified in order {
            let declaration = declarations[qualified]!
            if declaration.conformances.contains("Employee") == false { continue }
            var person: [String: String] = [:]
            for key in ["Rank", "Home", "Site"] {
                let slot = Slot(owner: qualified, key: key)
                if let settled = values.settled[slot] { person[key] = settled }
            }
            coordinates[qualified] = person
        }
        let elapsed = Double(DispatchTime.now().uptimeNanoseconds
            - started.uptimeNanoseconds) / 1_000_000
        return Judgment(declarations: order.count, lookups: values.lookups,
            premises: premises, milliseconds: elapsed, refusals: refusals,
            coordinates: coordinates)
    }

    // ── the door ──

    static func run(_ arguments: [String]) {
        if arguments.first == "diff" || arguments.first == "chain" {
            JudgeDiff.run(arguments)
            return
        }
        let paths = arguments.isEmpty
            ? ["Sources/Organization/System/GeneratedTeam.swift"]
            : arguments
        guard let judgment = judge(paths: paths) else {
            FileHandle.standardError.write(Data("✗ THE JUDGE cannot read the corpus\n".utf8))
            exit(2)
        }
        report(judgment)
        if judgment.refusals.isEmpty == false { exit(1) }
    }

    static func report(_ judgment: Judgment) {
        let clock = String(format: "%.1f", judgment.milliseconds)
        if judgment.refusals.isEmpty {
            print("✓ THE JUDGE holds: \(judgment.declarations) declarations · "
                + "\(judgment.lookups) lookups · \(judgment.premises) premises · \(clock) ms")
            return
        }
        print("✗ THE JUDGE refuses \(judgment.refusals.count) claim(s) in \(clock) ms:")
        for refusal in judgment.refusals.prefix(20) {
            print("    \(refusal.file):\(refusal.line)  \(refusal.premise)")
        }
    }
}
