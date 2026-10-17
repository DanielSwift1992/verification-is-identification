// WHERE JUDGE — the second judge learns the conditional grammar. A world file
// states enums with typealias tables, top-level and generic typealiases,
// extensions gated by `where` equalities, and protocols gated the same way. A
// parameterless typealias whose right side names a gated head is a certificate,
// judged like a use, and extra definition files lend their typealiases so a
// name's meaning is its one written definition wherever that definition is.
// This judge reads a fragment of those statements and normalizes its terms —
// aliases unfolded, generic parameters substituted, dotted axes resolved
// through the conformer's own table — and then judges each use of a gated
// head and each conformer of a gated protocol. A rewrite comes from the
// supplied definitions. Names such as Plus, Times and Twice have no built-in
// equations here. Equal readings of two types (including their counts) do not
// establish type identity or license substitution in arbitrary contexts.
// Each successful normalization constructs and replays a DefinitionReduction
// derivation against the read source. Distinct resulting forms mean this court
// has not established the required equality, not a proof of general inequality.
// Declaration reading, generic applicability and membership remain separate
// obligations; this is not a complete Swift checker. Other ports do not acquire
// these properties by sharing the same canon version label.

import Foundation

enum WhereJudge {
    typealias Term = Press.Term

    /// Identifies the normalization rules, not evidence that a separate port
    /// implements them. Version four replays source-defined reduction derivations.
    static let canonVersion = 4

    struct Conformer {
        let name: String
        let parameters: [String]
        var protocols: [String]
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
        let memberships: [(String, String)]
        let unjudged: [String]
    }

    struct GatedProtocol {
        let name: String
        let equalities: [(String, String)]
        let memberships: [(String, String)]
        let unjudged: [String]
    }

    static func fail(_ message: String) -> Never {
        FileHandle.standardError.write(Data("✗ THE WHERE: \(message)\n".utf8))
        exit(2)
    }

    // ── reading the world ──

    static func stripComments(_ text: String) -> String {
        // Conditional compilation is outside this court's scope. Omit the
        // complete block, including nested alternatives; never expose a tail
        // merely because an inner #endif was encountered.
        var flaggedDepth = 0
        var kept: [String] = []
        for line in text.split(separator: "\n", omittingEmptySubsequences: false) {
            let bare = line.trimmingCharacters(in: .whitespaces)
            if bare.range(of: #"^#if\b"#, options: .regularExpression) != nil {
                flaggedDepth += 1
                continue
            }
            if bare.range(of: #"^#endif\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { fail("unmatched #endif") }
                flaggedDepth -= 1
                continue
            }
            if bare.range(of: #"^#(?:else|elseif)\b"#, options: .regularExpression) != nil {
                if flaggedDepth == 0 { fail("conditional branch outside #if") }
                continue
            }
            if flaggedDepth > 0 { continue }
            if let cut = line.range(of: "//") {
                kept.append(String(line[line.startIndex..<cut.lowerBound]))
            } else {
                kept.append(String(line))
            }
        }
        if flaggedDepth != 0 { fail("unterminated #if block") }
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

    // A line break inside generic arguments does not end a typealias. Keep
    // projected continuations too; reject an unbalanced RHS as a reader
    // failure rather than judging its truncated prefix as a different type.
    static func readAliases(_ text: String) -> [[String]] {
        let header = try! NSRegularExpression(
            pattern: #"typealias\s+(\w+)\s*(?:<([^>]*)>)?\s*=\s*"#,
            options: [.dotMatchesLineSeparators]
        )
        var result: [[String]] = []
        var cursor = text.startIndex
        while cursor < text.endIndex,
              let match = header.firstMatch(in: text, range: NSRange(cursor..., in: text)),
              let bounds = Range(match.range, in: text),
              let nameBounds = Range(match.range(at: 1), in: text) {
            let name = String(text[nameBounds])
            let parameters = Range(match.range(at: 2), in: text).map { String(text[$0]) } ?? ""
            let start = bounds.upperBound
            var end = start
            var depth = 0
            while end < text.endIndex {
                let character = text[end]
                if character == "<" { depth += 1 }
                if character == ">" {
                    depth -= 1
                    if depth < 0 { fail("cannot read typealias '\(name)': unbalanced generic arguments") }
                }
                if character == "{" || character == "}" || character == ";" { break }
                if character == "\n", depth == 0 {
                    let following = text[text.index(after: end)...]
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    if !following.hasPrefix(".") { break }
                }
                end = text.index(after: end)
            }
            if depth != 0 { fail("cannot read typealias '\(name)': unbalanced generic arguments") }
            let body = String(text[start..<end])
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: #"\s*\.\s*"#, with: ".", options: .regularExpression)
                .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            if body.isEmpty { fail("cannot read typealias '\(name)': empty right side") }
            let tail = text[end...].trimmingCharacters(in: .whitespacesAndNewlines)
            let conditional = body.range(of: #"\bwhere\b"#, options: .regularExpression) != nil
                || tail.range(of: #"^where\b"#, options: .regularExpression) != nil
            result.append([name, parameters, body, conditional ? "where" : ""])
            cursor = end
        }
        return result
    }

    // Member aliases belong to their declaration. Exporting them into the
    // world's namespace can turn an unrelated alias into a false equality.
    // Keep line boundaries so multiline top-level aliases remain readable.
    static func outsideBodies(_ text: String) -> String {
        var depth = 0
        var result = ""
        for character in text {
            if character == "{" { depth += 1 }
            if depth == 0 || character == "\n" { result.append(character) }
            else { result.append(" ") }
            if character == "}" { depth -= 1 }
            if depth < 0 { fail("unmatched declaration brace") }
        }
        if depth != 0 { fail("unterminated declaration body") }
        return result
    }

    // A gate's where carries three kinds of conjunct. An equality is judged
    // against the canon. A membership, a colon and a bare protocol name, is
    // judged against the protocols the conformer's declaration and extensions
    // list, closed over the refinements the file presents. Anything else used
    // to be dropped in silence, and a court may not drop a condition in
    // silence: it is named at its gate instead, so a half-read law is a
    // refusal, never a verdict that counts what it never read.
    static func splitConjuncts(_ clause: String)
        -> (equalities: [(String, String)], memberships: [(String, String)], unjudged: [String]) {
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
        var equalities: [(String, String)] = []
        var memberships: [(String, String)] = []
        var unjudged: [String] = []
        for part in parts {
            let bare = part.trimmingCharacters(in: .whitespacesAndNewlines)
            if bare.isEmpty { continue }
            let sides = part.components(separatedBy: "==")
            if sides.count == 2 {
                equalities.append((
                    sides[0].trimmingCharacters(in: .whitespacesAndNewlines),
                    sides[1].trimmingCharacters(in: .whitespacesAndNewlines)
                ))
                continue
            }
            let claim = bare.components(separatedBy: ":")
            if claim.count == 2 {
                let lhs = claim[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let proto = claim[1].trimmingCharacters(in: .whitespacesAndNewlines)
                if lhs.isEmpty == false,
                   proto.range(of: #"^\w+$"#, options: .regularExpression) != nil {
                    memberships.append((lhs, proto))
                    continue
                }
            }
            unjudged.append(bare)
        }
        return (equalities, memberships, unjudged)
    }

    struct World {
        var conformers: [String: Conformer] = [:]
        var aliases: [String: AliasRule] = [:]
        var gates: [GatedExtension] = []
        var gatedProtocols: [String: GatedProtocol] = [:]
        var protocolParents: [String: [String]] = [:]
        var protocolAxes: [String: Set<String>] = [:]
        var parameters: [String: [String]] = [:]
        var conditionalDeclarations: Set<String> = []
        var presentedBodies: Set<String> = []
        var uses: [String] = []
    }

    static func read(_ text: String) -> World {
        let clean = stripComments(text)
        var world = World()

        // A presented declaration can have a body this flat reader cannot read.
        // Such a body does not license reflexivity of an unestablished field.
        for hit in captures(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\s*\{"#, clean
        ) {
            world.presentedBodies.insert(hit[0])
        }

        for hit in captures(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*[\w,\s]+?\bwhere\s+[^{}]+\{"#, clean
        ) {
            world.conditionalDeclarations.insert(hit[0])
        }

        for hit in captures(
            #"enum\s+(\w+)\s*(?:<([^>]*)>)?\s*:\s*([\w,\s]+?)\s*\{([^{}]*)\}"#, clean
        ) {
            let name = hit[0]
            let parameters = parameterNames(hit[1])
            let protocols = hit[2]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            var table: [String: String] = [:]
            for aliasHit in readAliases(hit[3]) where aliasHit[1].isEmpty {
                guard table[aliasHit[0]] == nil else {
                    fail("duplicate definition of '\(name).\(aliasHit[0])'")
                }
                table[aliasHit[0]] = aliasHit[2]
            }
            world.conformers[name] = Conformer(
                name: name, parameters: parameters, protocols: protocols, table: table
            )
        }

        for hit in captures(#"enum\s+(\w+)\s*<([^>]*)>"#, clean) {
            world.parameters[hit[0]] = parameterNames(hit[1])
        }

        // An unconditional extension of a presented conformer adds the
        // protocols its header lists, whatever its body holds: the header
        // states the conformance, so a body this reader cannot read does not
        // drop the obligation. A where clause always carries ':' or '==', so
        // the list cannot swallow one, and a gated extension stays a gate. A
        // type with no inheritance list (`enum Foo {}`) is not presented, so
        // its extensions add nothing.
        for hit in captures(#"extension\s+(\w+)\s*:\s*([\w,\s]+?)\s*\{"#, clean) {
            let name = hit[0]
            if world.conformers[name] != nil {
                world.conformers[name]!.protocols += hit[1]
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            }
        }

        // An extension body inside the flat fragment lends its parameterless
        // aliases to a presented conformer. A body outside it is not read, so
        // an axis only that body defines has no definition here, and its
        // projection is unread rather than opaque.
        for hit in captures(
            #"extension\s+(\w+)\s*(?::\s*[\w,\s]+?)?\s*\{([^{}]*)\}"#, clean
        ) {
            let name = hit[0]
            if world.conformers[name] != nil {
                for aliasHit in readAliases(hit[1]) where aliasHit[1].isEmpty {
                    guard world.conformers[name]!.table[aliasHit[0]] == nil else {
                        fail("duplicate definition of '\(name).\(aliasHit[0])'")
                    }
                    world.conformers[name]!.table[aliasHit[0]] = aliasHit[2]
                }
            }
        }

        for hit in readAliases(outsideBodies(clean)) {
            guard world.aliases[hit[0]] == nil else {
                fail("duplicate definition of typealias '\(hit[0])'")
            }
            if !hit[3].isEmpty { world.conditionalDeclarations.insert(hit[0]) }
            world.aliases[hit[0]] = AliasRule(
                parameters: parameterNames(hit[1]),
                body: hit[2]
            )
        }

        for hit in captures(
            #"extension\s+(\w+)\s*:\s*(\w+)\s+where\s+([^{]+)\{"#, clean
        ) {
            let conjuncts = splitConjuncts(hit[2])
            world.gates.append(GatedExtension(
                head: hit[0], proto: hit[1],
                equalities: conjuncts.equalities,
                memberships: conjuncts.memberships,
                unjudged: conjuncts.unjudged
            ))
        }

        for hit in captures(
            #"protocol\s+(\w+)\s*:\s*[\w,\s]+?\s+where\s+([^{]+)\{"#, clean
        ) {
            let conjuncts = splitConjuncts(hit[1])
            world.gatedProtocols[hit[0]] = GatedProtocol(
                name: hit[0],
                equalities: conjuncts.equalities,
                memberships: conjuncts.memberships,
                unjudged: conjuncts.unjudged
            )
        }

        // the refinement ladder, read from what is presented: a protocol's
        // parents are the material the membership walk closes over
        for hit in captures(
            #"protocol\s+(\w+)\s*:\s*([\w,\s]+?)\s*(?:\s+where|\{)"#, clean
        ) {
            world.protocolParents[hit[0]] = hit[1]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
        }
        for hit in captures(#"protocol\s+(\w+)\s*\{"#, clean)
        where world.protocolParents[hit[0]] == nil {
            world.protocolParents[hit[0]] = []
        }

        for hit in captures(#"protocol\s+(\w+)[^{}]*\{([^{}]*)\}"#, clean) {
            world.protocolAxes[hit[0]] = Set(captures(#"associatedtype\s+(\w+)"#, hit[1]).map { $0[0] })
        }

        for hit in captures(#"([\w<>,\. ]+?)\s*\.self"#, clean) {
            let use = hit[0].trimmingCharacters(in: .whitespaces)
            if use.contains("<") { world.uses.append(use) }
        }
        return world
    }

    // ── source-relative reduction, with replayed derivations ──

    // The term reader consumes the whole expression. An unread suffix cannot
    // be turned into an opaque atom and then accepted by reflexivity.
    static func parseTerm(_ text: Substring) -> Term {
        do { return try DefinitionReduction.parse(String(text)).legacy }
        catch { fail("cannot read term: \(error)") }
    }

    static func substitute(_ term: Term, _ bindings: [String: Term]) -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let values = try bindings.mapValues {
                try DefinitionReduction.parse(Press.serialize($0), allowRigidNames: true)
            }
            return try expression.substituting(values).legacy
        } catch { fail("cannot substitute term: \(error)") }
    }

    static func normalize(_ term: Term, _ world: World, rigid: Set<String> = []) -> Term {
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            return try DefinitionReduction.normalForm(expression, source: source).output.legacy
        } catch { fail("unresolved definition reduction: \(error)") }
    }

    static func canon(_ text: String, _ world: World) -> String {
        Press.serialize(normalize(parseTerm(Substring(text)), world))
    }

    // A claim meets the gate its definition names. A head spelled through an
    // alias or a member alias is unfolded before the gate is looked up, so an
    // intermediate name cannot carry a claim past its gate. A nominal head is
    // already the name a gate is looked up by, and a world that presents no
    // gate has no lookup to prepare. The gate itself reads the arguments.
    static func gatedForm(_ term: Term, _ world: World, rigid: Set<String> = []) -> Term {
        guard !world.gates.isEmpty,
              world.aliases[term.head] != nil || term.head.contains(".") else { return term }
        do {
            let expression = try DefinitionReduction.parse(Press.serialize(term), allowRigidNames: true)
            let source = DefinitionReduction.Source(world: world, rigid: rigid)
            return try DefinitionReduction.headForm(expression, source: source).output.legacy
        } catch { fail("unresolved definition reduction: \(error)") }
    }

    // does the conformer wear the protocol: the lists of its declaration and
    // its extensions, closed over the refinement ladder the file presents
    static func wears(_ conformer: Conformer, _ proto: String, _ world: World) -> Bool {
        inheritedProtocols(conformer.protocols, world).contains(proto)
    }

    static func inheritedProtocols(_ protocols: [String], _ world: World) -> Set<String> {
        var seen = Set<String>()
        var pile = protocols
        while let name = pile.popLast() {
            if seen.insert(name).inserted {
                pile.append(contentsOf: world.protocolParents[name] ?? [])
            }
        }
        return seen
    }

    static func conformerContext(_ conformer: Conformer, _ world: World)
        -> (bindings: [String: Term], rigid: Set<String>) {
        // Alpha-rename bound parameters outside the source identifier grammar.
        // No nominal declaration or alias may supply a value for a free
        // parameter merely by sharing its spelling.
        let variables = conformer.parameters.indices.map {
            Term(head: "$free_\(conformer.name)_\($0)", args: [])
        }
        let owner = Term(head: conformer.name, args: variables)
        let rigid = Set(variables.map { $0.head })
        var bindings = Dictionary(uniqueKeysWithValues: zip(conformer.parameters, variables))
        bindings["Self"] = owner
        var axes = Set(conformer.table.keys)
        for proto in inheritedProtocols(conformer.protocols, world) {
            axes.formUnion(world.protocolAxes[proto] ?? [])
        }
        for axis in axes where !conformer.parameters.contains(axis) {
            bindings[axis] = Term(head: Press.serialize(owner) + "." + axis, args: [])
        }
        return (bindings, rigid)
    }

    // A question's formal parameters must be bound by this actual application.
    // zip alone would leave missing parameters free to resolve as global names.
    // A declaration with zero parameters still has obligations to discharge.
    static func gateBindings(_ term: Term, _ world: World) -> [String: Term] {
        guard let parameters = world.parameters[term.head] ?? world.conformers[term.head]?.parameters else {
            fail("cannot bind gate '\(term.head)': no declaration parameters were read")
        }
        guard parameters.count == term.args.count, Set(parameters).count == parameters.count else {
            fail("cannot bind gate '\(term.head)': expected \(parameters.count) distinct arguments, received \(term.args.count)")
        }
        var bindings = Dictionary(uniqueKeysWithValues: zip(parameters, term.args))
        bindings["Self"] = term
        if let owner = world.conformers[term.head] {
            var axes = Set(owner.table.keys)
            for proto in inheritedProtocols(owner.protocols, world) {
                axes.formUnion(world.protocolAxes[proto] ?? [])
            }
            for axis in axes where bindings[axis] == nil {
                bindings[axis] = Term(head: Press.serialize(term) + "." + axis, args: [])
            }
        }
        return bindings
    }

    // one membership judged: the left side resolves through the same canon
    // the equalities use, the resolved name must be a presented conformer,
    // and the conformer must wear the protocol through the ladder. Either
    // failure is a refusal in this court's own voice, at the site that
    // required it.
    static func judgeMemberships(
        _ memberships: [(String, String)], site: String, tag: String?,
        bindings: [String: Term], world: World,
        counted: inout Int, refusals: inout [String], rigid: Set<String> = []
    ) {
        let mark = tag.map { " [\($0)]" } ?? ""
        for (lhs, proto) in memberships {
            counted += 1
            let lhsTerm = substitute(parseTerm(Substring(lhs)), bindings)
            let resolved = normalize(lhsTerm, world, rigid: rigid)
            let spelled = Press.serialize(resolved)
            if world.conformers[resolved.head] == nil, world.presentedBodies.contains(resolved.head) {
                fail("cannot read declaration '\(resolved.head)': its body is outside this court's flat-definition fragment")
            }
            guard resolved.args.isEmpty, let wearer = world.conformers[resolved.head] else {
                refusals.append(
                    "'\(site)' requires the type '\(lhs)' (aka '\(spelled)') conform to "
                        + "'\(proto)', and no conformer of that name is presented\(mark)"
                )
                continue
            }
            if wears(wearer, proto, world) == false {
                let worn = wearer.protocols.joined(separator: ", ")
                refusals.append(
                    "'\(site)' requires the type '\(lhs)' (aka '\(resolved.head)') conform to "
                        + "'\(proto)', and '\(resolved.head): \(worn)' does not carry it\(mark)"
                )
            }
        }
    }

    // ── the judgement ──

    static func run(_ arguments: [String]) {
        guard let path = arguments.first else {
            fail("usage: judge where <world.swift> [definitions.swift ...]")
        }
        guard let text = try? String(contentsOfFile: path, encoding: .utf8) else {
            fail("cannot read \(path)")
        }
        var world = read(text)
        var excludesConditional = text.range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
        let ownAliases = world.aliases
        // Extra files supply alias definitions, not a second version of the
        // same source. This flat reader has no module-resolution rule with
        // which to choose between duplicates, so a collision is unresolved.
        var aliasOrigins = Dictionary(uniqueKeysWithValues: world.aliases.keys.map { ($0, path) })
        for extra in arguments.dropFirst() {
            guard let more = try? String(contentsOfFile: extra, encoding: .utf8) else {
                fail("cannot read \(extra)")
            }
            excludesConditional = excludesConditional
                || more.range(of: #"(?m)^\s*#if\b"#, options: .regularExpression) != nil
            for (name, rule) in read(more).aliases.sorted(by: { $0.key < $1.key }) {
                guard aliasOrigins[name] == nil else {
                    fail("ambiguous definition of '\(name)' in '\(aliasOrigins[name]!)' and '\(extra)'")
                }
                world.aliases[name] = rule
                aliasOrigins[name] = extra
            }
        }
        var refusals: [String] = []
        var judged = 0
        var members = 0

        // a gate that carries what no court here judges is named at once:
        // the defect is the law's own spelling, not any use of it
        for gate in world.gates {
            for part in gate.unjudged {
                refusals.append(
                    "the gate '\(gate.head): \(gate.proto)' carries '\(part)', "
                        + "a conjunct this court does not judge"
                )
            }
        }
        for gated in world.gatedProtocols.values.sorted(by: { $0.name < $1.name }) {
            for part in gated.unjudged {
                refusals.append(
                    "the gated protocol '\(gated.name)' carries '\(part)', "
                        + "a conjunct this court does not judge"
                )
            }
        }

        // A typealias certificate is a judged point: a parameterless alias in the
        // world whose right side names a gated head states the gate's equalities
        // for those arguments, and the refusal names the certificate.
        var certificates: [(name: String, term: Term, rigid: Set<String>)] = ownAliases
            .filter { $0.value.parameters.isEmpty }
            .map { ($0.key, parseTerm(Substring($0.value.body)), []) }
        // A local certificate is still checked, but in its actual owner.
        // Removing it from the global namespace must not remove its obligation.
        for conformer in world.conformers.values {
            let context = conformerContext(conformer, world)
            for (name, body) in conformer.table {
                certificates.append((conformer.name + "." + name,
                    substitute(parseTerm(Substring(body)), context.bindings), context.rigid))
            }
        }
        for certificate in certificates.sorted(by: { $0.name < $1.name }) {
            let name = certificate.name
            let term = certificate.term
            let body = Press.serialize(term)
            let claim = gatedForm(term, world, rigid: certificate.rigid)
            let matching = world.gates.filter { $0.head == claim.head }
            guard !matching.isEmpty else { continue }
            let bindings = gateBindings(claim, world)
            for gate in matching {
                for (left, right) in gate.equalities {
                    judged += 1
                    let leftTerm = substitute(parseTerm(Substring(left)), bindings)
                    let rightTerm = substitute(parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(normalize(leftTerm, world, rigid: certificate.rigid))
                    let rightCanon = Press.serialize(normalize(rightTerm, world, rigid: certificate.rigid))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(name) = \(body)' requires the types '\(left)' (aka '\(leftCanon)') and "
                                + "'\(right)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
                        )
                    }
                }
                judgeMemberships(
                    gate.memberships, site: "\(name) = \(body)", tag: gate.proto,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals, rigid: certificate.rigid
                )
            }
        }

        for use in world.uses {
            let claim = gatedForm(parseTerm(Substring(use)), world)
            let matching = world.gates.filter { $0.head == claim.head }
            guard !matching.isEmpty else { continue }
            let bindings = gateBindings(claim, world)
            for gate in matching {
                for (left, right) in gate.equalities {
                    judged += 1
                    let leftTerm = substitute(parseTerm(Substring(left)), bindings)
                    let rightTerm = substitute(parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(normalize(leftTerm, world))
                    let rightCanon = Press.serialize(normalize(rightTerm, world))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(use)' requires the types '\(left)' (aka '\(leftCanon)') and "
                                + "'\(right)' (aka '\(rightCanon)') be equivalent [\(gate.proto)]"
                        )
                    }
                }
                judgeMemberships(
                    gate.memberships, site: use, tag: gate.proto,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals
                )
            }
        }

        for conformer in world.conformers.values.sorted(by: { $0.name < $1.name }) {
            let protocols = inheritedProtocols(conformer.protocols, world)
            let (bindings, rigid) = conformerContext(conformer, world)
            // Membership inheritance and equality inheritance are the same
            // dependency closure. A child cannot discard a parent's gate.
            for protoName in protocols.sorted() {
                guard let gated = world.gatedProtocols[protoName] else { continue }
                for (left, right) in gated.equalities {
                    judged += 1
                    let leftTerm = substitute(parseTerm(Substring(left)), bindings)
                    let rightTerm = substitute(parseTerm(Substring(right)), bindings)
                    let leftCanon = Press.serialize(normalize(leftTerm, world, rigid: rigid))
                    let rightCanon = Press.serialize(normalize(rightTerm, world, rigid: rigid))
                    if leftCanon != rightCanon {
                        refusals.append(
                            "'\(conformer.name): \(protoName)' requires the types '\(left)' "
                                + "(aka '\(leftCanon)') and '\(right)' (aka '\(rightCanon)') be equivalent"
                        )
                    }
                }
                judgeMemberships(
                    gated.memberships, site: "\(conformer.name): \(protoName)", tag: nil,
                    bindings: bindings, world: world,
                    counted: &members, refusals: &refusals, rigid: rigid
                )
            }
        }

        if refusals.isEmpty {
            if judged == 0 && members == 0 {
                fail("no equalities or memberships were judged; no certificate established")
            }
            if excludesConditional {
                print("THE WHERE scope: conditional compilation blocks are excluded.")
            }
            print("✓ THE WHERE holds: \(judged) equalities and \(members) memberships judged across \(world.uses.count) uses, the certificates, and the gated conformers, source-replayed definition reductions (canon v\(canonVersion)).")
        } else {
            for refusal in refusals { print("✗ \(refusal)") }
            exit(1)
        }
    }
}
