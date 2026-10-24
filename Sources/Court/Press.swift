import Foundation

// Linear triples are declarations, read by the court's structural grammar.
// apply proposes a finite certificate; replay checks every chord member, the
// two substitution equations, and the declared bounds before publication.
// Literal edits retain the v0.1 behavior pending the explicit T0083 step-B design.

public enum Press {

    typealias E = DefinitionReduction.Expression
    typealias R = DefinitionReduction

    struct Rule {
        let declaration: StructuralSource.Declaration
        let slot: String
        let slotAt: WhereJudge.WordOccurrence
        let from: E
        let into: E
        var name: String { declaration.name }
        var variables: [String] { declaration.parameters }
    }
    public struct Input: Codable {
        public let path: String
        public let text: String
        public init(path: String, text: String) {
            self.path = path
            self.text = text
        }
    }
    public struct Failure: Error, CustomStringConvertible {
        public let description: String
        public let address: String
    }
    public struct Certificate: Codable {
        let version: String
        let arguments: [String]
        let inputs: [String]
        let readings: [StructuralSource.ReadingCertificate]
        let slot: String
        let lowerByte: Int
        let upperByte: Int
        let candidates: [Candidate]
        let selected: Int?
    }
    struct Candidate: Codable {
        let rule: String
        let substitution: NameMap<String>
        // A path to a constructor disagreement; nil denotes a complete match.
        let mismatch: [Int]?
        let bounds: ApplicationCourt.Derivation?
    }
    public struct Substitution {
        public let state: String
        public let changed: Bool
        public let message: String
        // Literal operations are the explicit T0083 step-B debt, not triple proofs.
        public let certificate: Certificate?
        init(state: String, changed: Bool, message: String, certificate: Certificate? = nil) {
            self.state = state
            self.changed = changed
            self.message = message
            self.certificate = certificate
        }
    }
    static func fail(_ message: String, at address: String = "arguments") throws -> Never {
        throw Failure(description: message, address: address)
    }
    static func addressed<T>(_ address: String, _ action: () throws -> T) throws -> T {
        do { return try action() }
        catch let error as Failure { throw error }
        catch let error as StructuralSource.AddressedFailure {
            if case let .duplicateDeclaration(name)? = error.issue {
                try fail("\(error.description); \(name) appears twice", at: address)
            }
            try fail(error.description, at: address)
        }
        catch { try fail(String(describing: error), at: address) }
    }

    /// The grammar and declaration production are StructuralSource's, shared
    /// with ApplicationCourt. The Press question restricts a selected body to
    /// exactly three ordinary aliases; it does not search line substrings.
    static func readRule(named name: String, read: StructuralSource.FileReading, path: String) throws -> Rule {
        try addressed("\(path)#\(name)") {
            let found = read.regions.filter { WhereJudge.sameName($0.declaration.name, name) && $0.declaration.kind != "extension" }
            guard let region = found.first else { try fail("no rule named \(name) in \(path)", at: "\(path)#\(name)") }
            guard found.count == 1 else { throw R.Failure("duplicate rule \(name)") }
            let d = region.declaration
            guard d.kind == "enum", d.unsupported.isEmpty else { throw R.Failure("unsupported rule \(name): \(d.unsupported)") }
            var i = 0, aliases: [StructuralSource.Declaration] = []
            while i < region.body.count {
                if ["\n", ";", "public", "internal", "private", "fileprivate", "package"].contains(region.body[i]) {
                    i += 1
                    continue
                }
                guard region.body[i] == "typealias" else { throw R.Failure("\(name) is not a triple: \(region.body[i])") }
                aliases.append(try StructuralSource.readDeclaration(region.body, index: &i, origin: path).declaration)
            }
            guard aliases.count == 3, NameSet(aliases.map(\.name)) == NameSet(["Slot", "From", "Into"]),
                aliases.allSatisfy({ $0.parameters.isEmpty && $0.requirements.isEmpty && $0.unsupported.isEmpty }) else {
                throw R.Failure("\(name) states no full Slot/From/Into triple")
            }
            let slot = try R.parse(d.fields["Slot"]!)
            guard case let .application(slotName, args) = slot, args.isEmpty, !d.parameters.containsName(slotName) else {
                throw R.Failure("Slot must be a constant name")
            }
            let from = try R.parse(d.fields["From"]!), into = try R.parse(d.fields["Into"]!)
            var counts: NameMap<Int> = [:]
            try variables(from, d.parameters, counts: &counts)
            for variable in d.parameters
            where counts[variable, default: 0] > 1 {
                throw R.Failure("\(name) repeats \(variable) in its pattern: linearity is the premise of the unique match")
            }
            var outputCounts: NameMap<Int> = [:]
            try variables(into, d.parameters, counts: &outputCounts)
            let indices = region.tokenRange.filter { read.tokens[$0].word != "\n" }
            guard let position = indices.indices.first(where: { j in
                j >= 3 && WhereJudge.sameName(read.tokens[indices[j]].word, slotName)
                    && read.tokens[indices[j - 1]].word == "="
                    && WhereJudge.sameName(read.tokens[indices[j - 2]].word, "Slot")
                    && read.tokens[indices[j - 3]].word == "typealias"
            }) else { throw R.Failure("Slot has no source token") }
            let at = indices[position]
            return Rule(declaration: d, slot: slotName,
                slotAt: .init(spelling: slotName, line: read.lexed.lines[at], byte: read.tokens[at].bytes.lowerBound), from: from, into: into)
        }
    }
    static func variables(_ e: E, _ parameters: [String], counts: inout NameMap<Int>) throws {
        switch e {
        case let .application(name, args):
            if parameters.containsName(name) {
                guard args.isEmpty else { throw R.Failure("variable used as a constructor: \(name)") }
                counts[name, default: 0] += 1
            } else { for a in args { try variables(a, parameters, counts: &counts) } }
        case let .field(owner, _): try variables(owner, parameters, counts: &counts)
        }
    }

    struct Reading {
        let members: [(Rule, [E])]
        let slot: String
        let bytes: Range<Int>
        let current: E
        let source: StructuralSource?
        let readings: [StructuralSource.ReadingCertificate]
    }
    static func reading(_ arguments: [String], state: String, dictionary: String, definitions: [Input], statePath: String, dictionaryPath: String, certificates: [StructuralSource.ReadingCertificate]? = nil) throws -> Reading {
        guard arguments.count == 1, let invocation = arguments.first else { try fail("usage: Tools press <Rule>[,<Rule>…] --file <state file> --rules <rule file>") }
        let inputs = [Input(path: statePath, text: state), Input(path: dictionaryPath, text: dictionary)] + definitions
        if let certificates, certificates.count != inputs.count { try fail("reading certificate changes input coverage", at: "certificate") }
        let lexical = WhereJudge.lexicalReadingsResults(inputs.map { ($0.path, $0.text) }, scope: .declarations, arguments: [("arguments", invocation)])
        // Dictionary first so an absent rule still names the dictionary. The slot
        // address is established below before judging the state production.
        func readInput(_ index: Int) throws -> StructuralSource.FileReading {
            let input = inputs[index]
            let validated = try lexical[index].get()
            if let certificates { return try StructuralSource.replayReading(certificates[index], source: input.text, origin: input.path, lexical: validated) }
            return try StructuralSource.regions(input.text, origin: input.path, lexical: validated)
        }
        let dictionaryRead = try addressed("\(dictionaryPath)#\(invocation)") { try readInput(1) }
        let members: [(Rule, [E])] = try addressed("arguments") {
            let tokens = try StructuralSource.tokens(invocation)
            return try StructuralSource.split(tokens, at: ",").map { part in
                let e = try R.parse(StructuralSource.text(part))
                guard case let .application(name, args) = e else { throw R.Failure("rule invocation must name a declaration") }
                return (try readRule(named: name, read: dictionaryRead, path: dictionaryPath), args)
            }
        }
        guard let slot = members.first?.0.slot, members.allSatisfy({ WhereJudge.sameName($0.0.slot, slot) }) else {
            try fail("a chord holds one slot: \(invocation) mixes \(NameSet(members.map { $0.0.slot }).sorted().joined(separator: ", "))", at: "\(dictionaryPath)#\(invocation)")
        }
        let alias = slot.hasSuffix("Slot") ? String(slot.dropLast(4)) : slot
        return try addressed("\(statePath)#\(alias)") {
            let read = try readInput(0)
            // Slot's declared suffix denotes a state name. Guard that derived name
            // too for the collision diagnostic; stripping Slot must not erase a
            // distinct scalar spelling of the actual state declaration (U4).
            try addressed("\(dictionaryPath)#\(invocation)") {
                try WhereJudge.checkWordSpellings(inputs.map { ($0.path, $0.text) },
                    arguments: [("arguments", invocation)],
                    locatedNames: members.map { member in
                        (dictionaryPath, .init(spelling: alias, line: member.0.slotAt.line, byte: member.0.slotAt.byte))
                    })
            }
            let found = read.regions.filter { $0.declaration.kind == "typealias" && WhereJudge.sameName($0.declaration.name, alias) }
            guard let region = found.first else { try fail("no slot \(alias) in \(statePath)", at: "\(statePath)#\(alias)") }
            guard found.count == 1 else { try fail("slot \(alias) appears twice in \(statePath)", at: "\(statePath)#\(alias)") }
            let d = region.declaration
            guard d.parameters.isEmpty, d.requirements.isEmpty, d.unsupported.isEmpty, let body = d.alias else { throw R.Failure("unsupported slot declaration") }
            let current = try R.parse(body)
            let header = Array(read.tokens[region.headerRange])
            guard let equal = (header.firstIndex { $0.word == "=" }) else { throw R.Failure("missing slot equation") }
            let term = header.dropFirst(equal + 1).filter { $0.word != "\n" }
            guard let first = term.first, let last = term.last else { throw R.Failure("empty slot term") }
            let extraReads = try inputs.indices.dropFirst(2).map { index in
                try addressed(inputs[index].path) { try readInput(index) }
            }
            let all = [read, dictionaryRead] + extraReads
            // A place is established by its declaration across the complete
            // input, independently of whether this rule needs bound proofs.
            for other in [dictionaryRead] + extraReads {
                if let duplicate = (other.regions.first { WhereJudge.sameName($0.declaration.name, alias) && $0.declaration.kind != "extension" }) {
                    let line = other.lexed.lines[duplicate.tokenRange.lowerBound]
                    try fail("slot \(alias) has another declaration", at: "\(other.origin):\(line)")
                }
            }
            let needsSource = members.contains { !$0.0.declaration.requirements.isEmpty }
            let source = try needsSource ? addressed("\(dictionaryPath)#\(invocation)") {
                try StructuralSource(files: [], readings: all)
            } : nil
            return Reading(members: members, slot: alias, bytes: first.bytes.lowerBound..<last.bytes.upperBound,
                current: current, source: source, readings: all.map(\.certificate))
        }
    }
    static func prebindings(_ rule: Rule, _ instance: [E], dictionaryPath: String) throws -> NameMap<E> {
        try addressed("\(dictionaryPath)#\(rule.name)") {
            var counts: NameMap<Int> = [:]
            try variables(rule.from, rule.variables, counts: &counts)
            let names = rule.variables.filter { counts[$0] == nil }
            guard instance.count <= names.count else { throw R.Failure("\(rule.name) takes \(names.count) instance argument(s), \(instance.count) given") }
            guard instance.count == names.count else { throw R.Failure("\(rule.name) needs its instance argument(s) \(names.joined(separator: ", ")): press \(rule.name)<…>") }
            return NameMap(uniqueKeysWithValues: zip(names, instance))
        }
    }
    /// Search returns either a complete substitution or one constructor
    /// disagreement. Replay below follows the supplied path, without matching.
    static func match(_ pattern: E, _ term: E, variables: [String], bindings: inout NameMap<E>, path: [Int] = []) -> [Int]? {
        if case let .application(name, args) = pattern, args.isEmpty, variables.containsName(name) {
            bindings[name] = term
            return nil
        }
        switch (pattern, term) {
        case let (.application(a, xs), .application(b, ys))
        where WhereJudge.sameName(a, b) && xs.count == ys.count:
            for i in xs.indices { if let no = match(xs[i], ys[i], variables: variables, bindings: &bindings, path: path + [i]) { return no } }
            return nil
        case let (.field(a, x), .field(b, y))
        where WhereJudge.sameName(x, y):
            return match(a, b, variables: variables, bindings: &bindings, path: path + [-1])
        default: return path
        }
    }
    static func disagreement(_ path: [Int], _ pattern: E, _ term: E, variables: [String]) -> Bool {
        if case let .application(name, args) = pattern, args.isEmpty, variables.containsName(name) { return false }
        if let first = path.first {
            switch (pattern, term) {
            case let (.application(a, xs), .application(b, ys))
            where WhereJudge.sameName(a, b) && xs.count == ys.count && xs.indices.contains(first):
                return disagreement(Array(path.dropFirst()), xs[first], ys[first], variables: variables)
            case let (.field(a, x), .field(b, y))
            where WhereJudge.sameName(x, y) && first == -1:
                return disagreement(Array(path.dropFirst()), a, b, variables: variables)
            default: return false
            }
        }
        switch (pattern, term) {
        case let (.application(a, xs), .application(b, ys)): return !WhereJudge.sameName(a, b) || xs.count != ys.count
        case let (.field(_, x), .field(_, y)): return !WhereJudge.sameName(x, y)
        default: return true
        }
    }
    static func obligations(_ rule: Rule, _ bindings: NameMap<E>) throws -> Set<ApplicationCourt.Goal> {
        var environment = bindings
        environment["Self"] = .application(rule.name, try rule.variables.map {
            guard let value = bindings[$0] else { throw R.Failure("missing binding \($0)") }
            return value
        })
        return try Set(rule.declaration.requirements.map { requirement in
            let left = try R.parse(requirement.left).substituting(environment)
            switch requirement.kind {
            case .member: return .member(left, requirement.right)
            case .equal: return .equal(left, try R.parse(requirement.right).substituting(environment))
            }
        })
    }
    static func inputDigests(_ state: String, _ dictionary: String, _ definitions: [Input], _ statePath: String, _ dictionaryPath: String) -> [String] {
        ([Input(path: statePath, text: state), Input(path: dictionaryPath, text: dictionary)] + definitions).map {
            var bytes = Data()
            for field in [$0.path, $0.text] {
                let value = Array(field.utf8), count = UInt64(value.count)
                for shift in (0..<8).reversed() { bytes.append(UInt8((count >> (shift * 8)) & 255)) }
                bytes.append(contentsOf: value)
            }
            return courtSHA256(bytes)
        }
    }

    /// A term as its head and arguments: the one shape every pattern, every slot
    /// term, and every instance argument shares.
    struct Term {
        let head: String
        let args: [Term]
    }

    static func serialize(_ term: Term) -> String {
        term.args.isEmpty
            ? term.head
            : term.head + "<" + term.args.map(serialize).joined(separator: ", ") + ">"
    }

    /// Legacy literal alphabet, pending the declared step-B relation. This
    /// character filter does not prove that the line-based editor selects an
    /// active literal: a commented typeName can still be edited (T0083, L1).
    static func vetLiteral(_ text: String, address: String) throws {
        for ch in text {
            let allowed = ch.isLetter || ch.isNumber || ch == " " || ch == "."
                || ch == "," || ch == "!" || ch == "?" || ch == "-"
            guard allowed else {
                try fail("\"\(ch)\" is outside the literal's alphabet (letters, digits, space, .,!?-)", at: address)
            }
        }
    }

    /// The literal slot's three movements: append, rubout, clear. Free text lives
    /// in a typeName (the prose genre), a label draws it with no reader between,
    /// and the judge vets the file's form, never the words.
    static func pressLiteral(_ operation: String, _ arguments: [String], state: String, statePath: String) throws -> Substitution {
        guard let slotName = arguments.first else {
            try fail("usage: Tools press \(operation) <Slot> \(operation == "append" ? "<text> " : "")[--file <state file>]")
        }
        var lines = state.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        var insideExtension = false
        for (number, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            // This historical line reader remains the step-B debt. Its name
            // lookup nevertheless uses the court's one scalar identity.
            let prefixes = ["extension \(slotName) ", "extension \(slotName){"]
            if prefixes.contains(where: {
                WhereJudge.sameName(String(trimmed.unicodeScalars.prefix($0.unicodeScalars.count)), $0)
            }) {
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
                try vetLiteral(text, address: "\(statePath)#\(slotName)")
                next = current + text
            case "rubout":
                next = String(current.dropLast())
            default:
                next = ""
            }
            lines[number] = line.replacingOccurrences(of: "{ \"\(current)\" }", with: "{ \"\(next)\" }")
            let nextState = lines.joined(separator: "\n")
            return Substitution(state: nextState, changed: !nextState.utf8.elementsEqual(state.utf8), message: "pressed \(operation) \(slotName): \"\(current)\" -> \"\(next)\"")
        }
        try fail("no literal slot \(slotName) in \(statePath)", at: "\(statePath)#\(slotName)")
    }

    /// Replay is a decision on a supplied finite witness. It does not discover
    /// a rule, match a pattern, normalize a bound, or search for a derivation.
    public static func replay(_ certificate: Certificate, arguments: [String], state: String, dictionary: String,
        definitions: [Input] = [], output: String, statePath: String = "state.swift", dictionaryPath: String = "rules.swift") throws {
        try addressed("certificate") {
            guard certificate.version == "vi.press.linear-certificate/1", WhereJudge.sameNames(certificate.arguments, arguments),
                certificate.inputs == inputDigests(state, dictionary, definitions, statePath, dictionaryPath) else {
                throw R.Failure("certificate belongs to different input")
            }
            let read = try reading(arguments, state: state, dictionary: dictionary, definitions: definitions, statePath: statePath, dictionaryPath: dictionaryPath, certificates: certificate.readings)
            guard WhereJudge.sameName(certificate.slot, read.slot), certificate.lowerByte == read.bytes.lowerBound,
                certificate.upperByte == read.bytes.upperBound, certificate.candidates.count == read.members.count else {
                throw R.Failure("certificate changes the slot or chord coverage")
            }
            var matches: [Int] = []
            for (i, member) in read.members.enumerated() {
                let (rule, instance) = member, proposed = certificate.candidates[i]
                guard WhereJudge.sameName(proposed.rule, rule.name) else { throw R.Failure("certificate changes the rule") }
                let prebound = try prebindings(rule, instance, dictionaryPath: dictionaryPath)
                let bindings = try proposed.substitution.mapValues { try R.parse($0) }
                if let path = proposed.mismatch {
                    guard bindings == prebound, proposed.bounds == nil,
                        disagreement(path, rule.from, read.current, variables: rule.variables) else {
                        throw R.Failure("invalid no-match witness")
                    }
                    continue
                }
                guard NameSet(bindings.keys) == NameSet(rule.variables), prebound.allSatisfy({ bindings[$0.key] == $0.value }),
                    try rule.from.substituting(bindings) == read.current else { throw R.Failure("old slot is not From[sigma]") }
                let goals = try obligations(rule, bindings)
                if goals.isEmpty {
                    guard proposed.bounds == nil else { throw R.Failure("unrelated bound proof") }
                } else {
                    guard let source = read.source, let proof = proposed.bounds else { throw R.Failure("missing bound proof") }
                    try ApplicationCourt.verify(goals, derivation: proof, source: source)
                }
                matches.append(i)
            }
            guard matches.count <= 1, certificate.selected == matches.first else { throw R.Failure("ambiguous or changed selection") }
            let expected: String
            if let i = matches.first {
                let candidate = certificate.candidates[i], rule = read.members[i].0
                let bindings = try candidate.substitution.mapValues { try R.parse($0) }
                expected = replace(state, bytes: read.bytes, with: try rule.into.substituting(bindings).text)
            } else { expected = state }
            guard output.utf8.elementsEqual(expected.utf8) else { throw R.Failure("new slot is not Into[sigma], or carried bytes changed") }
        }
    }
    static func replace(_ text: String, bytes: Range<Int>, with replacement: String) -> String {
        let raw = Array(text.utf8)
        return String(decoding: raw[..<bytes.lowerBound] + Array(replacement.utf8) + raw[bytes.upperBound...], as: UTF8.self)
    }

    /// A substitution is computed from explicit bytes. Publication is the host's
    /// act; bounded rules require declarations in dictionary/state/definitions.
    public static func apply(_ arguments: [String], state: String, dictionary: String,
        definitions: [Input] = [], statePath: String = "state.swift", dictionaryPath: String = "rules.swift") throws -> Substitution {
        if let first = arguments.first, ["append", "rubout", "clear"].contains(first) {
            return try pressLiteral(first, Array(arguments.dropFirst()), state: state, statePath: statePath)
        }
        let read = try reading(arguments, state: state, dictionary: dictionary, definitions: definitions, statePath: statePath, dictionaryPath: dictionaryPath)
        var candidates: [Candidate] = [], selected: Int?, nextState = state
        for (i, member) in read.members.enumerated() {
            let (rule, instance) = member
            let prebound = try prebindings(rule, instance, dictionaryPath: dictionaryPath)
            var bindings = prebound
            if let path = match(rule.from, read.current, variables: rule.variables, bindings: &bindings) {
                candidates.append(Candidate(rule: rule.name, substitution: prebound.mapValues(\.text), mismatch: path, bounds: nil))
                continue
            }
            let proof: ApplicationCourt.Derivation? = try addressed("\(dictionaryPath)#\(rule.name)") {
                let goals = try obligations(rule, bindings)
                if goals.isEmpty { return nil }
                guard let source = read.source else { throw R.Failure("missing definitions for bound") }
                return try ApplicationCourt.derive(goals, source: source)
            }
            guard selected == nil else {
                try fail("ambiguous chord: \(read.members[selected!].0.name) and \(rule.name) both match \(read.slot) = \(read.current.text)", at: "\(statePath)#\(read.slot)")
            }
            candidates.append(Candidate(rule: rule.name, substitution: bindings.mapValues(\.text), mismatch: nil, bounds: proof))
            selected = i
            nextState = try addressed("\(dictionaryPath)#\(rule.name)") { replace(state, bytes: read.bytes, with: try rule.into.substituting(bindings).text) }
        }
        let certificate = Certificate(version: "vi.press.linear-certificate/1", arguments: arguments,
            inputs: inputDigests(state, dictionary, definitions, statePath, dictionaryPath), readings: read.readings, slot: read.slot,
            lowerByte: read.bytes.lowerBound, upperByte: read.bytes.upperBound, candidates: candidates, selected: selected)
        try replay(certificate, arguments: arguments, state: state, dictionary: dictionary, definitions: definitions, output: nextState, statePath: statePath, dictionaryPath: dictionaryPath)
        return Substitution(state: nextState, changed: !nextState.utf8.elementsEqual(state.utf8),
            message: selected.map { "pressed \(read.members[$0].0.name): \(read.slot) \(read.current.text)" } ?? "no-op: \(read.slot) is \(read.current.text)", certificate: certificate)
    }
    public static func run(_ args: [String]) {
        do {
            var arguments = args
            guard let f = arguments.firstIndex(of: "--file"), f + 1 < arguments.count else {
                try fail("usage: Tools press <Rule>[,<Rule>…] --file <state file> --rules <rule file>")
            }
            let statePath = arguments[f + 1]
            arguments.removeSubrange(f...f + 1)
            guard let r = arguments.firstIndex(of: "--rules"), r + 1 < arguments.count else {
                try fail("usage: Tools press <Rule>[,<Rule>…] --file <state file> --rules <rule file>")
            }
            let dictionaryPath = arguments[r + 1]
            arguments.removeSubrange(r...r + 1)
            var definitions: [Input] = []
            while let d = arguments.firstIndex(of: "--definitions") {
                guard d + 1 < arguments.count else { try fail("--definitions needs a path") }
                let path = arguments[d + 1]
                definitions.append(Input(path: path, text: try addressed(path) { try WhereJudge.fileText(path) }))
                arguments.removeSubrange(d...d + 1)
            }
            let dictionary: String
            if let operation = arguments.first, ["append", "rubout", "clear"].contains(operation) {
                // Literal editing never reads the triple dictionary.
                dictionary = ""
            } else {
                dictionary = try addressed(dictionaryPath) { try WhereJudge.fileText(dictionaryPath) }
            }
            let state = try addressed(statePath) { try WhereJudge.fileText(statePath) }
            let result = try apply(arguments, state: state, dictionary: dictionary,
                definitions: definitions, statePath: statePath, dictionaryPath: dictionaryPath)
            if result.changed {
                try result.state.write(toFile: statePath, atomically: true, encoding: .utf8)
            }
            print(result.message)
            if let certificate = result.certificate {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.sortedKeys]
                print(String(decoding: try encoder.encode(certificate), as: UTF8.self))
            }
        } catch let failure as Failure {
            FileHandle.standardError.write(Data(("press: " + failure.address + ": " + failure.description + "\n").utf8))
            exit(1)
        } catch {
            FileHandle.standardError.write(Data(("press: " + String(describing: error) + "\n").utf8))
            exit(1)
        }
    }

}
