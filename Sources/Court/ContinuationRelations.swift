import Foundation
import ContinuationRecord

// U5 on all fillings satisfying the source's declared leaf equalities.
// Generic parameters are opaque sorts; Source leaf occurrences are places.
// This interprets the existing StructuralSource grammar, without a new lexer.
// A source relation is a conditional premise, not a physical witness.
extension ContinuationCourt {
    typealias Places = ContinuationCore.Places
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
    typealias SourceEdge = ContinuationCore.SourceEdge
    typealias EqualityStep = ContinuationCore.EqualityStep
    typealias EqualityBasis = ContinuationCore.EqualityBasis
    typealias Selection = ContinuationCore.Selection
    typealias PartitionClass = ContinuationCore.PartitionClass
    typealias RequiredClass = ContinuationCore.RequiredClass
    typealias QuestionResidue = ContinuationCore.QuestionResidue
    typealias Obstruction = ContinuationCore.Obstruction
    typealias RelatedConclusion = ContinuationCore.RelatedConclusion
    typealias RelatedRetention = ContinuationCore.RelatedRetention
    struct RelatedCertificate: Codable {
        var request: ScalarName
        var constructor: ScalarName
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
    typealias WholeReading = ContinuationCore.WholeReading
    struct RelatedReading {
        let whole: WholeReading
        let observation: Places
        let question: Places
        var actions: [ActionMember] = []
        var hiddenActions: [ActionMember]? = nil
        var core: ContinuationCore.Reading { .init(whole: whole, observation: observation, question: question, actions: actions, hiddenActions: hiddenActions) }
        var source: Shape { whole.source }
        var edges: [SourceEdge] { whole.edges }
        func sort(_ path: Path) throws -> String { try whole.sort(path) }
    }
    static func sourcePlaces(_ shape: Shape, path: Path = []) -> Places {
        ContinuationCore.sourcePlaces(shape, path: path)
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
            guard case let .leaf(sa) = try source.at(a), case let .leaf(sb) = try source.at(b), WhereJudge.sameName(sa, sb) else {
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
                owner == c.root, !WhereJudge.sameName(axis, "Coverage") {
                return try .domain(build(e, .cut, depth + 1))
            }
            if mode == .cut, e == .field(c.root, anchor) {
                if WhereJudge.sameName(anchor, "Source") { return .source }
                if WhereJudge.sameName(anchor, "Image") { return .image }
                if WhereJudge.sameName(anchor, "Output") { return .output }
                throw Failure("unsupported route anchor")
            }
            switch e {
            case let .application(name, args)
            where WhereJudge.sameName(name, c.constructor) && args.count == 2:
                return try .pair(build(args[0], mode, depth + 1), build(args[1], mode, depth + 1))
            case let .field(owner, axis)
            where owner != c.root:
                guard mode == .cut else {
                    throw Failure("family leaves must name cut fields")
                }
                guard let side = Side(name: axis.text) else {
                    throw Failure("route uses an unsupported axis: " + axis.text)
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
                guard WhereJudge.sameName(field, "Source") else { throw Failure("Source anchor outside its declared domain") }
                return (.field(c.root, "Source"), .cut(anchor))
            case .image:
                guard mode == .cut, WhereJudge.sameName(field, "Image") else { throw Failure("Image anchor outside its declared output") }
                return (.field(c.root, "Image"), .cut(anchor))
            case .output:
                guard mode == .cut, WhereJudge.sameName(field, "Output") else { throw Failure("Output anchor outside its declared shape") }
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
                guard case let .field(owner, axis) = end.0, owner == c.root, !WhereJudge.sameName(axis, "Coverage"),
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
        var read: NameSet = []
        func mark(_ expression: E) {
            if case let .field(owner, axis) = expression, owner == c.root { read.insert(axis) }
        }
        func shape(_ proof: ReadProof) {
            read.formUnion(c.fieldsRead(proof))
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
        guard WhereJudge.sameName(certificate.request, request), WhereJudge.sameName(certificate.constructor, constructor) else {
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
        try ContinuationCore.assembledProgram(shape, inputs: inputs)
    }
    static func requiredClasses(_ r: RelatedReading, blocks: [Path: Int]) throws -> [RequiredClass] {
        try ContinuationCore.requiredClasses(r.core, blocks: blocks)
    }
    /// A closed partition can be coarser than E. A checked E-forest in every
    /// block additionally proves that its blocks are exactly the E-classes.
    static func verifyPartition(_ classes: [PartitionClass], whole: WholeReading,
                                at: String = "certificate.partition") throws -> [Path: Int] {
        try ContinuationCore.verifyPartition(classes, whole: whole, at: at)
    }
    static func verifyEForests(_ connections: [[EqualityStep]], classes: [PartitionClass],
                               edges: [Path: SourceEdge], at: String) throws {
        try ContinuationCore.verifyEForests(connections, classes: classes, edges: edges, at: at)
    }
    static func verifyResidue(_ residue: QuestionResidue, classes: [PartitionClass],
                              blocks: [Path: Int], reading r: RelatedReading,
                              edges: [Path: SourceEdge]) throws {
        try ContinuationCore.verifyResidue(residue, classes: classes, blocks: blocks, reading: r.core, edges: edges)
    }
    static func verifyEqualityBasis(_ basis: EqualityBasis, from: Path, to: Path,
                                     edges: [Path: SourceEdge], at: String, stepField: String = "path",
                                     remainingSteps: inout Int) throws {
        try ContinuationCore.verifyEqualityBasis(basis, from: from, to: to, edges: edges, at: at, stepField: stepField, remainingSteps: &remainingSteps)
    }
    static func verifyRelatedProgram(_ selections: [Selection], program: Program,
                                     reading r: RelatedReading, address: String,
                                     edgeIndex: [Path: SourceEdge]? = nil,
                                     programField: String = "program",
                                     basisStepField: String = "path") throws {
        try ContinuationCore.verifyRelatedProgram(selections, program: program, reading: r.core, address: address, edgeIndex: edgeIndex, programField: programField, basisStepField: basisStepField)
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
        return try ContinuationCore.verify(certificate.conclusion, retention: certificate.retention, reading: r.core)
    }
    // A balanced product gives a declared shape without a unit or opaque constant.
    // Nil denotes no additional carrier; it is not a leaf of any sort.
    static func retainedPlaces(_ leaves: [Path]) -> Places? {
        ContinuationCore.retainedPlaces(leaves)
    }
    // Called only after the original obstruction and its exact class proof hold.
    static func verifyRelatedRetentionPlan(_ retention: RelatedRetention, obstruction: Obstruction,
                                          blocks: [Path: Int], reading r: RelatedReading) throws {
        try ContinuationCore.verifyRelatedRetentionPlan(retention, obstruction: obstruction, blocks: blocks, reading: r.core)
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
        if retain { certificate.retention = try ContinuationCore.retention(certificate.conclusion, reading: r.core) }
        _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
        return certificate
    }
    static func constructRelated(_ r: RelatedReading) throws -> RelatedConclusion {
        try ContinuationCore.constructRelated(r.core)
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
        let archive = try CourtJSON.decoder().decode(RelatedArchive.self, from: data)
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
            let source = try StructuralSource(files: args.map { ($0, try WhereJudge.fileText($0)) }, arguments: [("request", request)])
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
