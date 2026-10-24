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
        // Output-relative cuts use the same route interpreter, rooted at the
        // already checked Image shape instead of the original Source places.
        case image
        case output
        case pair(RouteProof, RouteProof)
        case projection(Side, RouteProof)
        case definition(E, [ReadProof], RouteProof)
        // A family leaf names a cut field of this same request. Its child is
        // interpreted by these same rules in cut mode, not by another reader.
        case domain(RouteProof)
    }
    enum RouteForm { case cut, family }
    indirect enum Domains {
        case leaf(Places), pair(Domains, Domains)
        var leaves: [(address: Path, places: Places)] {
            switch self {
            case let .leaf(p): return [([], p)]
            case let .pair(l, r):
                return l.leaves.map { ([.left] + $0.address, $0.places) }
                    + r.leaves.map { ([.right] + $0.address, $0.places) }
            }
        }
    }
    enum Routed {
        case cut(Places), family(Domains)
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
    struct RelatedRetention: Codable {
        // One same-source leaf per required class; construction uses Question order.
        var leaves: [Path]
        var view: Program
        // U5 on the joint view: Left is Observation, Right is the retained view.
        var selections: [Selection]
        var program: Program
    }
    struct RelatedCertificate: Codable {
        var request: String
        var constructor: String
        var source: ReadProof
        var observation: RouteProof
        var question: RouteProof
        var equalities: RouteProof?
        var conclusion: RelatedConclusion
        var retention: RelatedRetention? = nil
        var actions: RouteProof? = nil
        var hiddenActions: RouteProof? = nil
        var dynamics: Dynamics? = nil
        var repetition: Repetition? = nil
    }
    struct RelatedArchive: Codable {
        let format: Int
        var certificate: RelatedCertificate
    }
    static let relatedArchiveLimit = 8_000_000
    struct WholeReading {
        let source: Shape
        let edges: [SourceEdge]
        func sort(_ path: Path) throws -> String {
            guard case let .leaf(sort) = try source.at(path) else {
                throw Failure(pathText("Source", path) + ": expected a leaf occurrence")
            }
            return sort
        }
    }
    struct RelatedReading {
        let whole: WholeReading
        let observation: Places
        let question: Places
        var actions: [ActionMember] = []
        var hiddenActions: [ActionMember]? = nil
        var source: Shape { whole.source }
        var edges: [SourceEdge] { whole.edges }
        func sort(_ path: Path) throws -> String { try whole.sort(path) }
    }
    static func sourcePlaces(_ shape: Shape, path: Path = []) -> Places {
        switch shape {
        case .leaf: return .leaf(path)
        case let .pair(l, r):
            return .pair(sourcePlaces(l, path: path + [.left]), sourcePlaces(r, path: path + [.right]))
        }
    }
    static func shapeOfPlaces(_ places: Places, source: Shape, address: String) throws -> Shape {
        switch places {
        case let .leaf(path):
            guard case let .leaf(sort) = try source.at(path) else { throw Failure(address + ": nonleaf origin") }
            return .leaf(sort)
        case let .pair(l, r):
            return try .pair(shapeOfPlaces(l, source: source, address: address),
                             shapeOfPlaces(r, source: source, address: address))
        }
    }
    // Endpoint trees have already been interpreted by RouteProof. This only
    // addresses their paired leaves; it does not parse another record syntax.
    static func pairedPlaces(_ left: Places, _ right: Places, address: String,
                              accept: ((Path, Path, Path) throws -> Void)? = nil) throws -> [SourceEdge] {
        var edges: [SourceEdge] = []
        func walk(_ l: Places, _ r: Places, _ path: Path) throws {
            switch (l, r) {
            case let (.leaf(a), .leaf(b)):
                try accept?(a, b, path)
                edges.append(SourceEdge(address: path, left: a, right: b))
            case let (.pair(a, b), .pair(x, y)):
                try walk(a, x, path + [.left])
                try walk(b, y, path + [.right])
            default: throw Failure(pathText(address, path) + ": endpoint shapes differ")
            }
        }
        try walk(left, right, [])
        return edges
    }
    static func equalityEdges(_ endpoints: Places, source: Shape, address: String) throws -> [SourceEdge] {
        guard case let .pair(left, right) = endpoints else {
            throw Failure(address + ": expected paired endpoint trees")
        }
        return try pairedPlaces(left, right, address: address) { a, b, path in
            guard case let .leaf(sa) = try source.at(a), case let .leaf(sb) = try source.at(b), sa == sb else {
                throw Failure(pathText(address, path) + ": endpoints have different sorts")
            }
        }
    }

    static func deriveRoute(_ expression: E, context c: Context,
                            form: RouteForm = .cut, anchor: String = "Source") throws -> RouteProof {
        var remaining = 50_000
        func build(_ e: E, _ mode: RouteForm, _ depth: Int) throws -> RouteProof {
            guard remaining > 0, depth < 128 else {
                throw Failure("route reading limit; no impossibility inferred")
            }
            remaining -= 1
            if mode == .family, case let .field(owner, axis) = e,
                owner == c.root, axis != "Coverage" {
                return try .domain(build(e, .cut, depth + 1))
            }
            if mode == .cut, e == .field(c.root, anchor) {
                if anchor == "Source" { return .source }
                if anchor == "Image" { return .image }
                if anchor == "Output" { return .output }
                throw Failure("unsupported route anchor")
            }
            switch e {
            case let .application(name, args)
            where name == c.constructor && args.count == 2:
                return try .pair(build(args[0], mode, depth + 1), build(args[1], mode, depth + 1))
            case let .field(owner, axis)
            where owner != c.root:
                guard mode == .cut else {
                    throw Failure("family leaves must name cut fields")
                }
                guard let side = Side(rawValue: axis) else {
                    throw Failure("route uses an unsupported axis: " + axis)
                }
                return try .projection(side, build(owner, .cut, depth + 1))
            default:
                let owner = try c.owner(of: e)
                guard case let .application(_, args) = owner, let body = try c.raw.expansion(e) else {
                    throw Failure("route must originate at Source; a sort or displayed value is not a place")
                }
                return try .definition(e, args.map { try c.derive($0) }, build(body, mode, depth + 1))
            }
        }
        return try build(expression, form, 0)
    }
    static func replayRoute(_ proof: RouteProof, context c: Context, source: Shape,
                            anchor: String = "Source") throws -> (E, Places) {
        let result = try replayRouting(proof, context: c, source: source, form: .cut, anchor: anchor)
        guard case let .cut(places) = result.1 else { throw Failure("expected a source cut") }
        return (result.0, places)
    }
    static func replayRouting(_ proof: RouteProof, context c: Context, source: Shape,
                              form: RouteForm, anchor field: String = "Source") throws -> (E, Routed) {
        var remaining = 100_000
        let anchor = sourcePlaces(source)
        func walk(_ p: RouteProof, _ mode: RouteForm, _ depth: Int) throws -> (E, Routed) {
            guard remaining > 0, depth < 256 else { throw Failure("route replay limit") }
            remaining -= 1
            switch p {
            case .source:
                guard mode == .cut else { throw Failure("family leaf needs its cut-field boundary") }
                guard field == "Source" else { throw Failure("Source anchor outside its declared domain") }
                return (.field(c.root, "Source"), .cut(anchor))
            case .image:
                guard mode == .cut, field == "Image" else { throw Failure("Image anchor outside its declared output") }
                return (.field(c.root, "Image"), .cut(anchor))
            case .output:
                guard mode == .cut, field == "Output" else { throw Failure("Output anchor outside its declared shape") }
                return (.field(c.root, "Output"), .cut(anchor))
            case let .pair(l, r):
                let a = try walk(l, mode, depth + 1)
                let b = try walk(r, mode, depth + 1)
                // The fixed constructor's full type-field signature is checked
                // by Context. Children are Structure products of source leaves.
                let input = E.application(c.constructor, [a.0, b.0])
                switch (a.1, b.1) {
                case let (.cut(x), .cut(y)): return (input, .cut(.pair(x, y)))
                case let (.family(x), .family(y)): return (input, .family(.pair(x, y)))
                default: throw Failure("mixed cut and family branches")
                }
            case let .projection(side, child):
                guard mode == .cut else { throw Failure("a family branch is not a cut projection") }
                let end = try walk(child, .cut, depth + 1)
                guard case let .cut(places) = end.1 else { throw Failure("expected a source cut") }
                return (.field(end.0, side.rawValue), .cut(try places.at([side])))
            case let .domain(child):
                guard mode == .family else { throw Failure("domain boundary outside a family") }
                let end = try walk(child, .cut, depth + 1)
                guard case let .field(owner, axis) = end.0, owner == c.root, axis != "Coverage",
                    case let .cut(places) = end.1
                else { throw Failure("domain must be a cut field of this same whole") }
                return (end.0, .family(.leaf(places)))
            case let .definition(input, arguments, child):
                let owner = try c.owner(of: input)
                let args = try arguments.map { try c.replay($0) }
                try c.checkArguments(owner, args)
                guard let body = try c.raw.expansion(input) else { throw Failure("route no longer unfolds") }
                let end = try walk(child, mode, depth + 1)
                guard body == end.0 else { throw Failure("route body differs from the live source") }
                return (input, end.1)
            }
        }
        return try walk(proof, form, 0)
    }
    static func checkWholeAxes(_ certificate: RelatedCertificate, context c: Context,
                               source: StructuralSource) throws {
        try checkWholeAxes(certificate.source,
                           routes: [certificate.observation, certificate.question]
                               + (certificate.equalities.map { [$0] } ?? [])
                               + (certificate.actions.map { [$0] } ?? [])
                               + (certificate.hiddenActions.map { [$0] } ?? []),
                           context: c)
    }
    static func checkWholeAxes(_ sourceProof: ReadProof, routes: [RouteProof], context c: Context,
                               shapes: [ReadProof] = []) throws {
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
            case .image: read.insert("Image")
            case .output: read.insert("Output")
            case let .pair(l, r):
                route(l)
                route(r)
            case let .projection(_, child), let .domain(child): route(child)
            case let .definition(input, arguments, child):
                mark(input)
                for argument in arguments { shape(argument) }
                route(child)
            }
        }
        shape(sourceProof)
        for proof in shapes { shape(proof) }
        for proof in routes { route(proof) }
        for axis in (c.source.declarations[c.request]?.fields.keys.sorted() ?? [])
        where !read.contains(axis) {
            throw Failure(c.request + "." + axis + ": unread axis in the declared whole")
        }
    }
    static func readCut(_ proof: RouteProof, field: String, whole: WholeReading, context c: Context,
                        anchor: String = "Source") throws -> Places {
        do {
            let result = try replayRoute(proof, context: c, source: whole.source, anchor: anchor)
            guard result.0 == .field(c.root, field) else { throw Failure("endpoint substituted") }
            return result.1
        } catch { throw Failure(c.request + "." + field + ": " + String(describing: error)) }
    }
    /// Both questions receive this one source-relative interpretation of T/E.
    /// No observation, domain or candidate program is needed to read a whole.
    static func readWhole(_ proof: ReadProof, equalities: RouteProof?, context c: Context) throws -> WholeReading {
        let s: (E, Shape)
        do { s = try c.replay(proof) }
        catch { throw Failure(c.request + ".Source: " + String(describing: error)) }
        guard s.0 == .field(c.root, "Source") else { throw Failure(c.request + ".Source: endpoint substituted") }
        let hasEqualities = c.source.declarations[c.request]?.fields["Equalities"] != nil
        guard hasEqualities == (equalities != nil) else {
            throw Failure(c.request + ".Equalities: changed relation coverage")
        }
        var edges: [SourceEdge] = []
        if let proof = equalities {
            let unconnected = WholeReading(source: s.1, edges: [])
            edges = try equalityEdges(readCut(proof, field: "Equalities", whole: unconnected, context: c),
                                      source: s.1, address: c.request + ".Equalities")
        }
        return WholeReading(source: s.1, edges: edges)
    }
    static func relatedReading(_ request: String, certificate: RelatedCertificate,
                               source: StructuralSource, constructor: String = "Paired") throws -> RelatedReading {
        guard certificate.request == request, certificate.constructor == constructor else {
            throw Failure("certificate: request or constructor substituted")
        }
        let c = try Context(request, source: source, constructor: constructor)
        let whole = try readWhole(certificate.source, equalities: certificate.equalities, context: c)
        let p = try readCut(certificate.observation, field: "Observation", whole: whole, context: c)
        let q = try readCut(certificate.question, field: "Question", whole: whole, context: c)
        func family(_ field: String, _ proof: RouteProof?) throws -> [ActionMember]? {
            guard (source.declarations[request]?.fields[field] != nil) == (proof != nil) else {
                throw Failure(request + "." + field + ": changed family coverage")
            }
            guard let proof else { return nil }
            return try actionMembers(readCut(proof, field: field, whole: whole, context: c),
                                     source: whole.source, address: request + "." + field)
        }
        let actions = try family("Actions", certificate.actions) ?? []
        let hidden = try family("HiddenActions", certificate.hiddenActions)
        try checkWholeAxes(certificate, context: c, source: source)
        return RelatedReading(whole: whole, observation: p, question: q, actions: actions, hiddenActions: hidden)
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
    /// A closed partition can be coarser than E. A checked E-forest in every
    /// block additionally proves that its blocks are exactly the E-classes.
    static func verifyPartition(_ classes: [PartitionClass], whole: WholeReading,
                                at: String = "certificate.partition") throws -> [Path: Int] {
        let all = whole.source.leaves
        var blocks: [Path: Int] = [:]
        guard classes.count <= all.count else { throw Failure("\(at): too many classes") }
        for (index, block) in classes.enumerated() {
            guard !block.leaves.isEmpty else { throw Failure("\(at)[\(index)]: empty class") }
            for path in block.leaves {
                do {
                    guard try whole.sort(path) == block.sort, blocks.updateValue(index, forKey: path) == nil else {
                        throw Failure("repeated leaf or different sort")
                    }
                } catch { throw Failure("\(at)[\(index)]: " + String(describing: error)) }
            }
        }
        guard Set(blocks.keys) == Set(all.map { $0.0 }) else { throw Failure("\(at): incomplete source coverage") }
        for edge in whole.edges {
            guard blocks[edge.left] == blocks[edge.right] else {
                throw Failure(pathText(at + ".E", edge.address) + ": partition breaks a declared E-edge")
            }
        }
        return blocks
    }
    static func verifyEForests(_ connections: [[EqualityStep]], classes: [PartitionClass],
                               edges: [Path: SourceEdge], at: String) throws {
        guard connections.count == classes.count else { throw Failure(at + ": incomplete class coverage") }
        for (index, block) in classes.enumerated() {
            let at = "\(at)[\(index)]"
            let steps = connections[index]
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
    }
    static func verifyResidue(_ residue: QuestionResidue, classes: [PartitionClass],
                              blocks: [Path: Int], reading r: RelatedReading,
                              edges: [Path: SourceEdge]) throws {
        try verifyEForests(residue.connections, classes: classes, edges: edges, at: "certificate.residue.connections")
        guard residue.needed == (try requiredClasses(r, blocks: blocks)) else {
            throw Failure("certificate.residue.needed: required classes or Question addresses differ")
        }
    }
    static func verifyRelatedProgram(_ selections: [Selection], program: Program,
                                     reading r: RelatedReading, address: String,
                                     edgeIndex: [Path: SourceEdge]? = nil) throws {
        let edges = edgeIndex ?? Dictionary(uniqueKeysWithValues: r.edges.map { ($0.address, $0) })
        let required = r.question.leaves
        var remainingSteps = 100_000
        guard selections.count == required.count else { throw Failure(address + ".selections: incomplete output coverage") }
        for (index, pair) in zip(selections, required).enumerated() {
            let (selection, target) = pair
            let at = address + ".selections[\(index)]"
            let input: Places
            do { input = try r.observation.at(selection.input) }
            catch { throw Failure(at + ".input: " + String(describing: error)) }
            guard selection.output == target.output,
                case let .leaf(from) = input
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
            throw Failure(address + ".program: assembled term differs from the selected addresses")
        }
    }
    static func verifyRelated(_ request: String, certificate: RelatedCertificate,
                              source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        let r = try relatedReading(request, certificate: certificate, source: source, constructor: constructor)
        if let repetition = certificate.repetition {
            guard certificate.retention == nil, certificate.dynamics == nil else {
                throw Failure("certificate.repetition: retention and dynamics are separate questions")
            }
            _ = try verifyRepetition(repetition, reading: r, request: request)
        } else if let dynamics = certificate.dynamics {
            guard certificate.retention == nil else { throw Failure("certificate.dynamics: retention is a separate question") }
            try verifyDynamics(dynamics, reading: r)
        } else if certificate.actions != nil || certificate.hiddenActions != nil {
            throw Failure("certificate.dynamics: declared families require an action judgment")
        }
        let edges = Dictionary(uniqueKeysWithValues: r.edges.map { ($0.address, $0) })
        switch certificate.conclusion {
        case let .constructed(selections, program):
            guard certificate.retention == nil else {
                throw Failure("certificate.retention: no residual is needed by a constructed continuation")
            }
            try verifyRelatedProgram(selections, program: program, reading: r, address: "certificate")
            return true
        case let .obstructed(obstruction):
            let blocks = try verifyPartition(obstruction.classes, whole: r.whole)
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
            if let retention = certificate.retention {
                try verifyRelatedRetentionPlan(retention, obstruction: obstruction, blocks: blocks, reading: r)
            }
            return false
        }
    }
    // A balanced product gives a declared shape without a unit or opaque constant.
    // Nil denotes no additional carrier; it is not a leaf of any sort.
    static func retainedPlaces(_ leaves: [Path]) -> Places? {
        guard !leaves.isEmpty else { return nil }
        func build(_ lower: Int, _ upper: Int) -> Places {
            if upper - lower == 1 { return .leaf(leaves[lower]) }
            let middle = lower + (upper - lower) / 2
            return .pair(build(lower, middle), build(middle, upper))
        }
        return build(0, leaves.count)
    }
    // Called only after the original obstruction and its exact class proof hold.
    static func verifyRelatedRetentionPlan(_ retention: RelatedRetention, obstruction: Obstruction,
                                          blocks: [Path: Int], reading r: RelatedReading) throws {
        guard let residue = obstruction.residue else {
            throw Failure("certificate.retention: exact residue proof is required for minimality")
        }
        guard retention.leaves.count == residue.needed.count else {
            throw Failure("certificate.retention.leaves: expected exactly one leaf per missing class")
        }
        let required = Set(residue.needed.map(\.block))
        var supplied: Set<Int> = []
        for (index, path) in retention.leaves.enumerated() {
            do {
                _ = try r.sort(path)
                guard let block = blocks[path], required.contains(block), supplied.insert(block).inserted else {
                    throw Failure("not a distinct required missing E-class")
                }
            } catch { throw Failure("certificate.retention.leaves[\(index)]: " + String(describing: error)) }
        }
        guard let m = retainedPlaces(retention.leaves) else {
            throw Failure("certificate.retention: an empty residual has no additional carrier")
        }
        guard retention.view == (try assembledProgram(m, inputs: retention.leaves)) else {
            throw Failure("certificate.retention.view: assembled source view differs from its addresses")
        }
        let joint = RelatedReading(whole: r.whole, observation: .pair(r.observation, m),
                                       question: r.question)
        try verifyRelatedProgram(retention.selections, program: retention.program,
                                 reading: joint, address: "certificate.retention")
    }
    static func verifyRelatedRetention(_ request: String, certificate: RelatedCertificate,
                                      source: StructuralSource, constructor: String = "Paired") throws -> Int {
        if try verifyRelated(request, certificate: certificate, source: source, constructor: constructor) { return 0 }
        guard let retention = certificate.retention else {
            throw Failure("certificate.retention: no retained view and decoder were presented")
        }
        return retention.leaves.count
    }
    static func deriveRelated(_ request: String, source: StructuralSource,
                              constructor: String = "Paired", retain: Bool = false,
                              actions: Bool = false, repeats: Bool = false) throws -> RelatedCertificate {
        guard !(retain && actions) else { throw Failure("--actions and --retain ask separate questions") }
        guard !(repeats && (retain || actions)) else { throw Failure("--repeat asks a separate U11 question") }
        let c = try Context(request, source: source, constructor: constructor)
        func route(_ field: String) throws -> RouteProof {
            do { return try deriveRoute(.field(c.root, field), context: c) }
            catch { throw Failure(request + "." + field + ": " + String(describing: error)) }
        }
        let sourceProof: ReadProof
        do { sourceProof = try c.derive(.field(c.root, "Source")) }
        catch { throw Failure(request + ".Source: " + String(describing: error)) }
        var certificate = try RelatedCertificate(
            request: request, constructor: constructor,
            source: sourceProof,
            observation: route("Observation"),
            question: route("Question"),
            equalities: source.declarations[request]?.fields["Equalities"] == nil ? nil
                : route("Equalities"),
            conclusion: .constructed([], .pick([])))
        if actions || repeats {
            if source.declarations[request]?.fields["Actions"] != nil { certificate.actions = try route("Actions") }
            if source.declarations[request]?.fields["HiddenActions"] != nil { certificate.hiddenActions = try route("HiddenActions") }
        }
        let r = try relatedReading(request, certificate: certificate, source: source, constructor: constructor)
        certificate.conclusion = try constructRelated(r)
        if actions { certificate.dynamics = try constructDynamics(r) }
        if repeats { certificate.repetition = try constructRepetition(r, request: request) }
        if retain, case let .obstructed(obstruction) = certificate.conclusion,
            let residue = obstruction.residue {
            let leaves = residue.needed.map { obstruction.classes[$0.block].leaves[0] }
            guard let m = retainedPlaces(leaves) else { throw Failure("certificate.retention: missing source classes") }
            let joint = RelatedReading(whole: r.whole, observation: .pair(r.observation, m),
                                       question: r.question)
            guard case let .constructed(selections, program) = try constructRelated(joint) else {
                throw Failure("certificate.retention: joint view does not cover Question")
            }
            certificate.retention = try RelatedRetention(leaves: leaves,
                view: assembledProgram(m, inputs: leaves), selections: selections, program: program)
        }
        _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
        return certificate
    }
    static func constructRelated(_ r: RelatedReading) throws -> RelatedConclusion {
        let adjacent = equalityGraph(r)
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
                let (classes, connections, blocks) = constructPartition(r)
                let residue = try QuestionResidue(connections: connections, needed: requiredClasses(r, blocks: blocks))
                return .obstructed(Obstruction(question: target.output, classes: classes, residue: residue))
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
        return try .constructed(selections, assembledProgram(r.question, inputs: selections.map(\.input)))
    }
    static func encodeRelated(_ certificate: RelatedCertificate) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let format = certificate.repetition != nil ? 5 : (certificate.dynamics != nil ? 4 : (certificate.retention == nil ? 2 : 3))
        let data = try encoder.encode(RelatedArchive(format: format, certificate: certificate))
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: output limit") }
        return data
    }
    static func decodeRelated(_ data: Data) throws -> RelatedCertificate {
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: input limit") }
        let archive = try JSONDecoder().decode(RelatedArchive.self, from: data)
        let c = archive.certificate
        let old = c.repetition == nil && c.dynamics == nil && c.actions == nil && c.hiddenActions == nil
        guard (old && archive.format == 2 && c.retention == nil)
                || (old && archive.format == 3 && c.retention != nil)
                || (archive.format == 4 && c.dynamics != nil && c.retention == nil && c.repetition == nil)
                || (archive.format == 5 && c.repetition != nil && c.retention == nil && c.dynamics == nil) else {
            throw Failure("certificate: expected format 2 without retention, format 3 with retention, format 4 with dynamics, or format 5 with repetition")
        }
        return archive.certificate
    }
    static func runRelations(_ arguments: [String], replay: Bool) {
        do {
            var args = arguments
            let retain = args.first == "--retain"
            if retain { args.removeFirst() }
            let actions = args.first == "--actions"
            if actions { args.removeFirst() }
            let repeats = args.first == "--repeat"
            if repeats { args.removeFirst() }
            let images = args.first == "--image"
            if images { args.removeFirst() }
            let agreement = args.first == "--agreement"
            if agreement { args.removeFirst() }
            guard !(retain && actions) else { throw Failure("--actions and --retain ask separate questions") }
            guard !(repeats && (retain || actions)) else { throw Failure("--repeat asks a separate U11 question") }
            guard !(images && (retain || actions || repeats)) else { throw Failure("--image asks a separate U9 question") }
            guard !(agreement && (retain || actions || repeats || images)) else { throw Failure("--agreement asks a separate U10/U10a question") }
            var output: String?
            var saved: RelatedCertificate?
            var savedImage: ImageCertificate?
            var savedAgreement: AgreementCertificate?
            if replay {
                guard !args.isEmpty else { throw Failure("certificate: missing file") }
                let data = try Data(contentsOf: URL(fileURLWithPath: args.removeFirst()))
                if agreement { savedAgreement = try decodeAgreement(data) }
                else if images { savedImage = try decodeImage(data) }
                else { saved = try decodeRelated(data) }
            } else if args.first == "--certificate" {
                args.removeFirst()
                guard !args.isEmpty else { throw Failure("certificate: missing output path") }
                output = args.removeFirst()
            }
            guard args.count >= 2 else {
                throw Failure("usage: judge continue --relations [--retain|--actions|--repeat|--image|--agreement] [--certificate output.json] Request source.swift ...; replay-continuation --relations [--retain|--actions|--repeat|--image|--agreement] certificate.json Request source.swift ...")
            }
            let request = args.removeFirst()
            let source = try StructuralSource(files: args.map { ($0, try String(contentsOfFile: $0, encoding: .utf8)) })
            let holds: Bool
            let bytes: Data
            if agreement {
                let certificate = try savedAgreement ?? deriveAgreement(request, source: source)
                holds = try verifyAgreement(request, certificate: certificate, source: source)
                bytes = try encodeAgreement(certificate)
            } else if images {
                let certificate = try savedImage ?? deriveImage(request, source: source)
                holds = try verifyImage(request, certificate: certificate, source: source)
                bytes = try encodeImage(certificate)
            } else {
                let certificate = try saved ?? deriveRelated(request, source: source, retain: retain, actions: actions, repeats: repeats)
                if repeats {
                    holds = try verifyRelatedRepetition(request, certificate: certificate, source: source)
                } else if certificate.repetition != nil {
                    throw Failure("certificate.repetition: replay format 5 with --repeat")
                } else if actions {
                    holds = try verifyRelatedActions(request, certificate: certificate, source: source)
                } else if certificate.dynamics != nil {
                    throw Failure("certificate.dynamics: replay format 4 with --actions")
                } else if retain {
                    _ = try verifyRelatedRetention(request, certificate: certificate, source: source)
                    holds = true
                } else {
                    holds = try verifyRelated(request, certificate: certificate, source: source)
                }
                bytes = try encodeRelated(certificate)
            }
            if let output { try bytes.write(to: URL(fileURLWithPath: output), options: .atomic) }
            FileHandle.standardOutput.write(bytes + Data("\n".utf8))
            if !holds { exit(1) }
        } catch {
            FileHandle.standardError.write(Data(("Continuation related unresolved: " + String(describing: error) + "\n").utf8))
            exit(2)
        }
    }
}
