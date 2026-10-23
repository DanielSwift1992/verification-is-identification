import Foundation

// U5 on all fillings satisfying the source's declared leaf equalities.
// Generic parameters are opaque sorts; Source leaf occurrences are places.
// This interprets the existing StructuralSource grammar, without a new lexer.
// A source relation is a conditional premise, not a physical witness.
extension ContinuationCourt {
    indirect enum Places: Equatable {
        case leaf(Path), pair(Places, Places)
        func at(_ path: Path) throws -> Places {
            var node = self
            for side in path {
                guard case let .pair(l, r) = node else {
                    throw Failure("route projects an opaque source place")
                }
                node = side == .left ? l : r
            }
            return node
        }
        var leaves: [(output: Path, source: Path)] {
            switch self {
            case let .leaf(path): return [([], path)]
            case let .pair(l, r):
                return l.leaves.map { ([.left] + $0.output, $0.source) }
                    + r.leaves.map { ([.right] + $0.output, $0.source) }
            }
        }
    }
    indirect enum RouteProof: Codable {
        case source
        case pair(RouteProof, RouteProof)
        case projection(Side, RouteProof)
        case definition(E, [ReadProof], RouteProof)
    }
    struct SourceEdge {
        let address: Path
        let left: Path
        let right: Path
    }
    struct EqualityStep: Codable {
        var edge: Path
        var reversed: Bool
    }
    enum EqualityBasis: Codable {
        case address
        case sourceRelation([EqualityStep])
        // This ground is represented distinctly and always rejected.
        case observedValues
    }
    struct Selection: Codable {
        var output: Path
        var input: Path
        var basis: EqualityBasis
    }
    struct PartitionClass: Codable {
        var sort: String
        var leaves: [Path]
    }
    struct RequiredClass: Codable, Equatable {
        var block: Int
        var questions: [Path]
    }
    struct QuestionResidue: Codable {
        // One incoming E-edge for every non-root member, in block order.
        // Together with the closed partition these forests certify exact E-classes.
        var connections: [[EqualityStep]]
        var needed: [RequiredClass]
    }
    struct Obstruction: Codable {
        var question: Path
        var classes: [PartitionClass]
        // Format-2 certificates without this extension retain only the original
        // obstruction judgment. They make no claim to name the question's residue.
        var residue: QuestionResidue? = nil
    }
    enum RelatedConclusion: Codable {
        case constructed([Selection], Program)
        case obstructed(Obstruction)
    }
    struct RelatedCertificate: Codable {
        var request: String
        var constructor: String
        var source: ReadProof
        var observation: RouteProof
        var question: RouteProof
        var equalities: RouteProof?
        var conclusion: RelatedConclusion
    }
    struct RelatedArchive: Codable {
        let format: Int
        var certificate: RelatedCertificate
    }
    struct RelatedReading {
        let source: Shape
        let observation: Places
        let question: Places
        let edges: [SourceEdge]
        func sort(_ path: Path) throws -> String {
            guard case let .leaf(sort) = try source.at(path) else {
                throw Failure(pathText("Source", path) + ": expected a leaf occurrence")
            }
            return sort
        }
    }
    static func sourcePlaces(_ shape: Shape, path: Path = []) -> Places {
        switch shape {
        case .leaf: return .leaf(path)
        case let .pair(l, r):
            return .pair(sourcePlaces(l, path: path + [.left]), sourcePlaces(r, path: path + [.right]))
        }
    }

    static func deriveRoute(_ expression: E, context c: Context) throws -> RouteProof {
        var remaining = 50_000
        func build(_ e: E, _ depth: Int) throws -> RouteProof {
            guard remaining > 0, depth < 128 else {
                throw Failure("route reading limit; no impossibility inferred")
            }
            remaining -= 1
            if e == .field(c.root, "Source") { return .source }
            switch e {
            case let .application(name, args)
            where name == c.constructor && args.count == 2:
                return try .pair(build(args[0], depth + 1), build(args[1], depth + 1))
            case let .field(owner, axis)
            where owner != c.root:
                guard let side = Side(rawValue: axis) else { throw Failure("route uses an unsupported axis: " + axis) }
                return try .projection(side, build(owner, depth + 1))
            default:
                let owner = try c.owner(of: e)
                guard case let .application(_, args) = owner, let body = try c.raw.expansion(e) else {
                    throw Failure("route must originate at Source; a sort or displayed value is not a place")
                }
                return try .definition(e, args.map { try c.derive($0) }, build(body, depth + 1))
            }
        }
        return try build(expression, 0)
    }
    static func replayRoute(_ proof: RouteProof, context c: Context, source: Shape) throws -> (E, Places) {
        var remaining = 100_000
        let anchor = sourcePlaces(source)
        func walk(_ p: RouteProof, _ depth: Int) throws -> (E, Places) {
            guard remaining > 0, depth < 256 else { throw Failure("route replay limit") }
            remaining -= 1
            switch p {
            case .source: return (.field(c.root, "Source"), anchor)
            case let .pair(l, r):
                let a = try walk(l, depth + 1)
                let b = try walk(r, depth + 1)
                // The fixed constructor's full type-field signature is checked
                // by Context. Children are Structure products of source leaves.
                return (.application(c.constructor, [a.0, b.0]), .pair(a.1, b.1))
            case let .projection(side, child):
                let end = try walk(child, depth + 1)
                return (.field(end.0, side.rawValue), try end.1.at([side]))
            case let .definition(input, arguments, child):
                let owner = try c.owner(of: input)
                let args = try arguments.map { try c.replay($0) }
                try c.checkArguments(owner, args)
                guard let body = try c.raw.expansion(input) else { throw Failure("route no longer unfolds") }
                let end = try walk(child, depth + 1)
                guard body == end.0 else { throw Failure("route body differs from the live source") }
                return (input, end.1)
            }
        }
        return try walk(proof, 0)
    }
    static func checkWholeAxes(_ certificate: RelatedCertificate, context c: Context,
                               source: StructuralSource) throws {
        var read: Set<String> = []
        func mark(_ expression: E) {
            if case let .field(owner, axis) = expression, owner == c.root { read.insert(axis) }
        }
        func shape(_ proof: ReadProof) {
            switch proof {
            case .leaf: break
            case let .pair(l, r):
                shape(l)
                shape(r)
            case let .projection(_, child): shape(child)
            case let .definition(input, arguments, child):
                mark(input)
                for argument in arguments { shape(argument) }
                shape(child)
            }
        }
        func route(_ proof: RouteProof) {
            switch proof {
            case .source: read.insert("Source")
            case let .pair(l, r):
                route(l)
                route(r)
            case let .projection(_, child): route(child)
            case let .definition(input, arguments, child):
                mark(input)
                for argument in arguments { shape(argument) }
                route(child)
            }
        }
        shape(certificate.source)
        route(certificate.observation)
        route(certificate.question)
        if let equalities = certificate.equalities { route(equalities) }
        for axis in (source.declarations[c.request]?.fields.keys.sorted() ?? [])
        where !read.contains(axis) {
            throw Failure(c.request + "." + axis + ": unread axis in the declared whole")
        }
    }
    static func relatedReading(_ request: String, certificate: RelatedCertificate,
                               source: StructuralSource, constructor: String = "Paired") throws -> RelatedReading {
        guard certificate.request == request, certificate.constructor == constructor else {
            throw Failure("certificate: request or constructor substituted")
        }
        let c = try Context(request, source: source, constructor: constructor)
        let s = try c.replay(certificate.source)
        guard s.0 == .field(c.root, "Source") else { throw Failure(request + ".Source: endpoint substituted") }
        func read(_ proof: RouteProof, _ field: String) throws -> Places {
            do {
                let result = try replayRoute(proof, context: c, source: s.1)
                guard result.0 == .field(c.root, field) else { throw Failure("endpoint substituted") }
                return result.1
            } catch { throw Failure(request + "." + field + ": " + String(describing: error)) }
        }
        let p = try read(certificate.observation, "Observation")
        let q = try read(certificate.question, "Question")
        let hasEqualities = source.declarations[request]?.fields["Equalities"] != nil
        guard hasEqualities == (certificate.equalities != nil) else {
            throw Failure(request + ".Equalities: changed relation coverage")
        }
        var edges: [SourceEdge] = []
        if let proof = certificate.equalities {
            guard case let .pair(left, right) = try read(proof, "Equalities") else {
                throw Failure(request + ".Equalities: expected paired endpoint trees")
            }
            func zipEdges(_ l: Places, _ r: Places, _ address: Path) throws {
                switch (l, r) {
                case let (.leaf(a), .leaf(b)):
                    guard case let .leaf(sa) = try s.1.at(a), case let .leaf(sb) = try s.1.at(b), sa == sb else {
                        throw Failure(pathText(request + ".Equalities", address) + ": endpoints have different sorts")
                    }
                    edges.append(SourceEdge(address: address, left: a, right: b))
                case let (.pair(a, b), .pair(x, y)):
                    try zipEdges(a, x, address + [.left])
                    try zipEdges(b, y, address + [.right])
                default: throw Failure(pathText(request + ".Equalities", address) + ": endpoint shapes differ")
                }
            }
            try zipEdges(left, right, [])
        }
        try checkWholeAxes(certificate, context: c, source: source)
        return RelatedReading(source: s.1, observation: p, question: q, edges: edges)
    }
    static func assembledProgram(_ shape: Places, inputs: [Path]) throws -> Program {
        var index = 0
        func walk(_ node: Places) throws -> Program {
            switch node {
            case .leaf:
                guard index < inputs.count else { throw Failure("certificate: missing output selection") }
                let path = inputs[index]
                index += 1
                return .pick(path)
            case let .pair(l, r): return try .pair(walk(l), walk(r))
            }
        }
        let result = try walk(shape)
        guard index == inputs.count else { throw Failure("certificate: extra output selections") }
        return result
    }
    static func requiredClasses(_ r: RelatedReading, blocks: [Path: Int]) throws -> [RequiredClass] {
        let observed = Set(r.observation.leaves.compactMap { blocks[$0.source] })
        var needed: [RequiredClass] = []
        var indices: [Int: Int] = [:]
        for leaf in r.question.leaves {
            guard let block = blocks[leaf.source] else { throw Failure("certificate.residue: missing source class") }
            if observed.contains(block) { continue }
            if let index = indices[block] {
                needed[index].questions.append(leaf.output)
            } else {
                indices[block] = needed.count
                needed.append(RequiredClass(block: block, questions: [leaf.output]))
            }
        }
        return needed
    }
    static func verifyResidue(_ residue: QuestionResidue, classes: [PartitionClass],
                              blocks: [Path: Int], reading r: RelatedReading,
                              edges: [Path: SourceEdge]) throws {
        guard residue.connections.count == classes.count else {
            throw Failure("certificate.residue.connections: incomplete class coverage")
        }
        for (index, block) in classes.enumerated() {
            let at = "certificate.residue.connections[\(index)]"
            let steps = residue.connections[index]
            guard steps.count == block.leaves.count - 1 else { throw Failure(at + ": incomplete class forest") }
            var connected: Set<Path> = [block.leaves[0]]
            for (offset, step) in steps.enumerated() {
                let here = at + "[\(offset)]"
                guard let edge = edges[step.edge] else { throw Failure(here + ": no declared E-edge at this address") }
                let from = step.reversed ? edge.right : edge.left
                let to = step.reversed ? edge.left : edge.right
                guard connected.contains(from), to == block.leaves[offset + 1] else {
                    throw Failure(here + ": E-edge does not connect the next class member")
                }
                connected.insert(to)
            }
        }
        guard residue.needed == (try requiredClasses(r, blocks: blocks)) else {
            throw Failure("certificate.residue.needed: required classes or Question addresses differ")
        }
    }
    static func verifyRelated(_ request: String, certificate: RelatedCertificate,
                              source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        let r = try relatedReading(request, certificate: certificate, source: source, constructor: constructor)
        let edges = Dictionary(uniqueKeysWithValues: r.edges.map { ($0.address, $0) })
        switch certificate.conclusion {
        case let .constructed(selections, program):
            let required = r.question.leaves
            var remainingSteps = 100_000
            guard selections.count == required.count else { throw Failure("certificate.selections: incomplete output coverage") }
            for (index, pair) in zip(selections, required).enumerated() {
                let (selection, target) = pair
                let at = "certificate.selections[\(index)]"
                guard selection.output == target.output,
                    case let .leaf(from) = try r.observation.at(selection.input)
                else { throw Failure(at + ": output or input is not the required leaf address") }
                guard try r.sort(from) == r.sort(target.source) else { throw Failure(at + ": selected sort differs") }
                switch selection.basis {
                case .address:
                    guard from == target.source else { throw Failure(at + ".basis: different source addresses are not identical") }
                case let .sourceRelation(steps):
                    guard !steps.isEmpty, steps.count <= 100_000 else { throw Failure(at + ".basis: expected a finite E-path") }
                    var current = from
                    for (stepIndex, step) in steps.enumerated() {
                        let here = at + ".basis.path[\(stepIndex)]"
                        guard remainingSteps > 0 else { throw Failure(here + ": replay work limit") }
                        remainingSteps -= 1
                        guard let edge = edges[step.edge] else { throw Failure(here + ": no declared E-edge at this address") }
                        let a = step.reversed ? edge.right : edge.left
                        let b = step.reversed ? edge.left : edge.right
                        guard current == a else { throw Failure(here + ": discontinuous E-path") }
                        current = b
                    }
                    guard current == target.source else { throw Failure(at + ".basis: E-path ends at another source leaf") }
                case .observedValues:
                    throw Failure(at + ".basis: observed value coincidence is not source equality")
                }
            }
            guard program == (try assembledProgram(r.question, inputs: selections.map(\.input))) else {
                throw Failure("certificate.program: assembled term differs from the selected addresses")
            }
            return true
        case let .obstructed(obstruction):
            let all = r.source.leaves
            var blocks: [Path: Int] = [:]
            guard obstruction.classes.count <= all.count else { throw Failure("certificate.partition: too many classes") }
            for (index, block) in obstruction.classes.enumerated() {
                guard !block.leaves.isEmpty else { throw Failure("certificate.partition[\(index)]: empty class") }
                for path in block.leaves {
                    do {
                        guard try r.sort(path) == block.sort, blocks.updateValue(index, forKey: path) == nil else {
                            throw Failure("repeated leaf or different sort")
                        }
                    } catch { throw Failure("certificate.partition[\(index)]: " + String(describing: error)) }
                }
            }
            guard Set(blocks.keys) == Set(all.map { $0.0 }) else { throw Failure("certificate.partition: incomplete source coverage") }
            for edge in r.edges {
                guard blocks[edge.left] == blocks[edge.right] else {
                    throw Failure(pathText("certificate.partition.E", edge.address) + ": partition breaks a declared E-edge")
                }
            }
            guard case let .leaf(missing) = try r.question.at(obstruction.question), let block = blocks[missing] else {
                throw Failure("certificate.partition.question: missing required leaf address")
            }
            let sort = try r.sort(missing)
            for leaf in r.observation.leaves
            where try r.sort(leaf.source) == sort {
                guard blocks[leaf.source] != block else {
                    throw Failure("certificate.partition.question: partition does not separate the required class from Observation")
                }
            }
            if let residue = obstruction.residue {
                try verifyResidue(residue, classes: obstruction.classes, blocks: blocks, reading: r, edges: edges)
            }
            return false
        }
    }
    static func deriveRelated(_ request: String, source: StructuralSource,
                              constructor: String = "Paired") throws -> RelatedCertificate {
        let c = try Context(request, source: source, constructor: constructor)
        func route(_ field: String) throws -> RouteProof {
            do { return try deriveRoute(.field(c.root, field), context: c) }
            catch { throw Failure(request + "." + field + ": " + String(describing: error)) }
        }
        var certificate = try RelatedCertificate(
            request: request, constructor: constructor,
            source: c.derive(.field(c.root, "Source")),
            observation: route("Observation"),
            question: route("Question"),
            equalities: source.declarations[request]?.fields["Equalities"] == nil ? nil
                : route("Equalities"),
            conclusion: .constructed([], .pick([])))
        let r = try relatedReading(request, certificate: certificate, source: source, constructor: constructor)
        var adjacent: [Path: [(Path, EqualityStep)]] = [:]
        for edge in r.edges {
            adjacent[edge.left, default: []].append((edge.right, EqualityStep(edge: edge.address, reversed: false)))
            adjacent[edge.right, default: []].append((edge.left, EqualityStep(edge: edge.address, reversed: true)))
        }
        // Equivalence closure retains a path from an observed occurrence.
        // No payloads or candidate programs are inspected.
        var reached: [Path: (input: Path, previous: Path?, step: EqualityStep?)] = [:]
        var pending: [Path] = []
        for leaf in r.observation.leaves
        where reached[leaf.source] == nil {
            reached[leaf.source] = (leaf.output, nil, nil)
            pending.append(leaf.source)
        }
        var cursor = 0
        while cursor < pending.count {
            let here = pending[cursor]
            cursor += 1
            for (next, step) in adjacent[here] ?? []
            where reached[next] == nil {
                let prior = reached[here]!
                reached[next] = (prior.input, here, step)
                pending.append(next)
            }
        }
        var selections: [Selection] = []
        var remainingSteps = 100_000
        for target in r.question.leaves {
            guard let route = reached[target.source] else {
                var seen: Set<Path> = []
                var classes: [PartitionClass] = []
                var connections: [[EqualityStep]] = []
                var blocks: [Path: Int] = [:]
                for (path, sort) in r.source.leaves
                where !seen.contains(path) {
                    var component = [path]
                    var forest: [EqualityStep] = []
                    seen.insert(path)
                    var i = 0
                    while i < component.count {
                        for (next, step) in adjacent[component[i]] ?? []
                        where seen.insert(next).inserted {
                            component.append(next)
                            forest.append(step)
                        }
                        i += 1
                    }
                    for member in component { blocks[member] = classes.count }
                    classes.append(PartitionClass(sort: sort, leaves: component))
                    connections.append(forest)
                }
                let residue = try QuestionResidue(connections: connections, needed: requiredClasses(r, blocks: blocks))
                certificate.conclusion = .obstructed(Obstruction(question: target.output, classes: classes, residue: residue))
                _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
                return certificate
            }
            var steps: [EqualityStep] = []
            var endpoint = target.source
            while let link = reached[endpoint], let previous = link.previous, let step = link.step {
                guard remainingSteps > 0 else { throw Failure("construction equality-path work limit") }
                remainingSteps -= 1
                steps.append(step)
                endpoint = previous
            }
            selections.append(Selection(output: target.output, input: route.input,
                                        basis: steps.isEmpty ? .address : .sourceRelation(Array(steps.reversed()))))
        }
        certificate.conclusion = try .constructed(selections, assembledProgram(r.question, inputs: selections.map(\.input)))
        _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
        return certificate
    }
    static func encodeRelated(_ certificate: RelatedCertificate) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(RelatedArchive(format: 2, certificate: certificate))
        guard data.count <= 8_000_000 else { throw Failure("certificate: output limit") }
        return data
    }
    static func decodeRelated(_ data: Data) throws -> RelatedCertificate {
        guard data.count <= 8_000_000 else { throw Failure("certificate: input limit") }
        let archive = try JSONDecoder().decode(RelatedArchive.self, from: data)
        guard archive.format == 2 else { throw Failure("certificate: expected related continuation format 2") }
        return archive.certificate
    }
    static func runRelations(_ arguments: [String], replay: Bool) {
        do {
            var args = arguments
            var output: String?
            var saved: RelatedCertificate?
            if replay {
                guard !args.isEmpty else { throw Failure("certificate: missing file") }
                saved = try decodeRelated(Data(contentsOf: URL(fileURLWithPath: args.removeFirst())))
            } else if args.first == "--certificate" {
                args.removeFirst()
                guard !args.isEmpty else { throw Failure("certificate: missing output path") }
                output = args.removeFirst()
            }
            guard args.count >= 2 else {
                throw Failure("usage: judge continue --relations [--certificate output.json] Request source.swift ...; replay-continuation --relations certificate.json Request source.swift ...")
            }
            let request = args.removeFirst()
            let source = try StructuralSource(files: args.map { ($0, try String(contentsOfFile: $0, encoding: .utf8)) })
            let certificate = try saved ?? deriveRelated(request, source: source)
            let holds = try verifyRelated(request, certificate: certificate, source: source)
            let bytes = try encodeRelated(certificate)
            if let output { try bytes.write(to: URL(fileURLWithPath: output), options: .atomic) }
            FileHandle.standardOutput.write(bytes + Data("\n".utf8))
            if !holds { exit(1) }
        } catch {
            FileHandle.standardError.write(Data(("Continuation related unresolved: " + String(describing: error) + "\n").utf8))
            exit(2)
        }
    }
}
