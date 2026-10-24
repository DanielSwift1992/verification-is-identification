import Foundation

// U10/U10a choose a structural image under declared output obligations.
// Reading is Context/RouteProof; replay checks finite addressed certificates.
// Leaf minimality is not an information order between different chosen images.
extension ContinuationCourt {
    struct LeafBinding {
        let address: Path
        let output: Path
        let source: Path
    }
    struct AgreementCapacity: Codable, Equatable {
        var sort: String
        var required: Int
        var output: Int
        var fixedRequired: Int
        var free: Int
        var minimum: Int
    }
    struct AgreementPlan: Codable {
        // One Source leaf for each exact output C-class.
        var assignments: [Path]
        var step: Program
        var bindingBases: [EqualityBasis]
        var needed: [RequiredClass]
        var residualLeaves: [Path]
        var residual: Program?
        var selections: [Selection]
        var decoder: Program
        var capacities: [AgreementCapacity]
    }
    enum AgreementConclusion: Codable {
        case constructed(AgreementPlan)
        case unavailable(output: Path)
        case wrongSort(binding: Path)
        case incompatible(left: Path, right: Path)
    }
    struct AgreementCertificate: Codable {
        var request: String
        var constructor: String
        var source: ReadProof
        var equalities: RouteProof?
        var output: ReadProof
        var question: RouteProof
        var promise: RouteProof?
        var boundOutputs: RouteProof?
        var boundSources: RouteProof?
        var classes: [PartitionClass]
        var connections: [[EqualityStep]]
        var outputClasses: [PartitionClass]
        var outputConnections: [[EqualityStep]]
        var conclusion: AgreementConclusion
    }
    struct AgreementArchive: Codable {
        var format: Int
        var certificate: AgreementCertificate
    }
    struct AgreementReading {
        let whole: WholeReading
        let output: WholeReading
        let question: Places
        let bindings: [LeafBinding]
        var sourceReading: RelatedReading {
            RelatedReading(whole: whole, observation: sourcePlaces(whole.source), question: question)
        }
    }
    static func agreementReading(_ request: String, certificate p: AgreementCertificate,
                                  source: StructuralSource, constructor: String = "Paired") throws -> AgreementReading {
        guard p.request == request, p.constructor == constructor else {
            throw Failure("certificate: request or constructor substituted")
        }
        let c = try Context(request, source: source, constructor: constructor,
                            requiredFields: ["Source", "Output", "Question"])
        let whole = try readWhole(p.source, equalities: p.equalities, context: c)
        let out: (E, Shape)
        do { out = try c.replay(p.output) }
        catch { throw Failure(request + ".Output: " + String(describing: error)) }
        guard out.0 == .field(c.root, "Output") else { throw Failure(request + ".Output: endpoint substituted") }
        let target = WholeReading(source: out.1, edges: [])
        let question = try readCut(p.question, field: "Question", whole: whole, context: c)
        let fields = source.declarations[request]?.fields ?? [:]
        for (name, proof) in [("Promise", p.promise), ("BoundOutputs", p.boundOutputs), ("BoundSources", p.boundSources)] {
            guard (fields[name] != nil) == (proof != nil) else {
                throw Failure(request + "." + name + ": changed obligation coverage")
            }
        }
        var edges: [SourceEdge] = []
        if let proof = p.promise {
            let ends = try readCut(proof, field: "Promise", whole: target, context: c, anchor: "Output")
            edges = try equalityEdges(ends, source: target.source, address: request + ".Promise")
        }
        guard (p.boundOutputs != nil) == (p.boundSources != nil) else {
            let missing = p.boundOutputs == nil ? "BoundOutputs" : "BoundSources"
            throw Failure(request + "." + missing + ": both binding endpoint fields are required together")
        }
        var bindings: [LeafBinding] = []
        if let outputProof = p.boundOutputs, let sourceProof = p.boundSources {
            let a = try readCut(outputProof, field: "BoundOutputs", whole: target, context: c, anchor: "Output")
            let b = try readCut(sourceProof, field: "BoundSources", whole: whole, context: c)
            bindings = try pairedPlaces(a, b, address: request + ".BoundSources").map {
                LeafBinding(address: $0.address, output: $0.left, source: $0.right)
            }
        }
        var routes: [RouteProof] = [p.question]
        for proof in [p.equalities, p.promise, p.boundOutputs, p.boundSources] {
            if let proof = proof { routes.append(proof) }
        }
        try checkWholeAxes(p.source, routes: routes, context: c, shapes: [p.output])
        return AgreementReading(whole: whole, output: .init(source: target.source, edges: edges),
                                question: question, bindings: bindings)
    }
    // Construction uses the first issue; replay checks a presented witness.
    static func agreementBindings(_ r: AgreementReading, sourceBlocks: [Path: Int],
                                   outputBlocks: [Path: Int]) throws -> (fixed: [Int: Int], issue: AgreementConclusion?) {
        var fixed: [Int: Int] = [:], first: [Int: Path] = [:]
        for binding in r.bindings {
            guard try r.output.sort(binding.output) == r.whole.sort(binding.source) else {
                return (fixed, .wrongSort(binding: binding.address))
            }
            guard let target = outputBlocks[binding.output], let origin = sourceBlocks[binding.source] else {
                throw Failure("binding: missing exact class")
            }
            if let previous = fixed[target], previous != origin {
                return (fixed, .incompatible(left: first[target]!, right: binding.address))
            }
            fixed[target] = origin
            if first[target] == nil { first[target] = binding.address }
        }
        return (fixed, nil)
    }
    static func agreementCapacities(_ r: AgreementReading, sourceClasses: [PartitionClass],
                                    sourceBlocks: [Path: Int], outputClasses: [PartitionClass],
                                    fixed: [Int: Int]) -> [AgreementCapacity] {
        let required = Set(distinctClasses(r.question, blocks: sourceBlocks))
        let supplied = Set(fixed.values)
        let sorts = Set(outputClasses.map(\.sort) + required.map { sourceClasses[$0].sort }).sorted()
        return sorts.map { sort in
            let n = required.filter { sourceClasses[$0].sort == sort }.count
            let m = outputClasses.filter { $0.sort == sort }.count
            let bound = required.intersection(supplied).filter { sourceClasses[$0].sort == sort }.count
            let free = outputClasses.indices.filter { outputClasses[$0].sort == sort && fixed[$0] == nil }.count
            return AgreementCapacity(sort: sort, required: n, output: m, fixedRequired: bound,
                                     free: free, minimum: max(n - bound - free, 0))
        }
    }
    static func agreementPlaces(_ r: AgreementReading, assignments: [Path],
                                 outputBlocks: [Path: Int], at: String) throws -> Places {
        guard assignments.count == Set(outputBlocks.values).count else {
            throw Failure(at + ".assignments: incomplete output C-class coverage")
        }
        let places = sourcePlaces(r.output.source)
        let origins = try places.leaves.map { leaf -> Path in
            guard let block = outputBlocks[leaf.source], assignments.indices.contains(block) else {
                throw Failure(at + ".assignments: missing output class")
            }
            let origin = assignments[block]
            do {
                guard try r.whole.sort(origin) == r.output.sort(leaf.source) else { throw Failure("different sort") }
            } catch { throw Failure(at + ".assignments[\(block)]: " + String(describing: error)) }
            return origin
        }
        var index = 0
        func fill(_ node: Places) -> Places {
            switch node {
            case .leaf:
                defer { index += 1 }
                return .leaf(origins[index])
            case let .pair(l, r): return .pair(fill(l), fill(r))
            }
        }
        return fill(places)
    }
    static func constructAgreement(_ r: AgreementReading, classes: [PartitionClass],
                                    blocks: [Path: Int], outputClasses: [PartitionClass],
                                    outputBlocks: [Path: Int]) throws -> AgreementConclusion {
        let available = Set(classes.map(\.sort))
        for leaf in r.output.source.leaves {
            if !available.contains(leaf.1) { return .unavailable(output: leaf.0) }
        }
        let bindings = try agreementBindings(r, sourceBlocks: blocks, outputBlocks: outputBlocks)
        if let issue = bindings.issue { return issue }
        let required = distinctClasses(r.question, blocks: blocks)
        // Count all fixed classes before free classes choose new requested ones.
        var covered = Set(bindings.fixed.values), assignments: [Path] = []
        for (index, target) in outputClasses.enumerated() {
            let origin: Int
            if let fixed = bindings.fixed[index] { origin = fixed }
            else if let next = (required.first { classes[$0].sort == target.sort && !covered.contains($0) }) { origin = next }
            else if let fallback = (classes.firstIndex { $0.sort == target.sort }) { origin = fallback }
            else { throw Failure("construction.agreement: unavailable output sort") }
            assignments.append(classes[origin].leaves[0])
            covered.insert(origin)
        }
        let p = try agreementPlaces(r, assignments: assignments, outputBlocks: outputBlocks, at: "construction.agreement")
        let reading = RelatedReading(whole: r.whole, observation: p, question: r.question)
        let needed = try requiredClasses(reading, blocks: blocks)
        let leaves = needed.map { classes[$0.block].leaves[0] }
        let m = retainedPlaces(leaves)
        let joint = RelatedReading(whole: r.whole, observation: m.map { .pair(p, $0) } ?? p, question: r.question)
        guard case let .constructed(selections, decoder) = try constructRelated(joint) else {
            throw Failure("construction.agreement: joint view does not cover Question")
        }
        var budget = ActionBudget()
        let bases = try r.bindings.map { binding -> EqualityBasis in
            try budget.spend(at: "construction.agreement.binding")
            guard case let .leaf(origin) = try p.at(binding.output) else { throw Failure("binding output is not a leaf") }
            return try constructionBasis(origin, binding.source, reading: r.sourceReading, budget: &budget)
        }
        let plan = try AgreementPlan(assignments: assignments,
            step: assembledProgram(p, inputs: p.leaves.map(\.source)), bindingBases: bases,
            needed: needed, residualLeaves: leaves, residual: m.map { try assembledProgram($0, inputs: leaves) },
            selections: selections, decoder: decoder,
            capacities: agreementCapacities(r, sourceClasses: classes, sourceBlocks: blocks,
                                           outputClasses: outputClasses, fixed: bindings.fixed))
        return .constructed(plan)
    }
    static func deriveAgreement(_ request: String, source: StructuralSource,
                                 constructor: String = "Paired") throws -> AgreementCertificate {
        let c = try Context(request, source: source, constructor: constructor,
                            requiredFields: ["Source", "Output", "Question"])
        let fields = source.declarations[request]?.fields ?? [:]
        func shape(_ field: String) throws -> ReadProof {
            do { return try c.derive(.field(c.root, field)) }
            catch { throw Failure(request + "." + field + ": " + String(describing: error)) }
        }
        func route(_ field: String, anchor: String = "Source") throws -> RouteProof {
            do { return try deriveRoute(.field(c.root, field), context: c, anchor: anchor) }
            catch { throw Failure(request + "." + field + ": " + String(describing: error)) }
        }
        var p = try AgreementCertificate(request: request, constructor: constructor,
            source: shape("Source"), equalities: fields["Equalities"] == nil ? nil : route("Equalities"),
            output: shape("Output"), question: route("Question"),
            promise: fields["Promise"] == nil ? nil : route("Promise", anchor: "Output"),
            boundOutputs: fields["BoundOutputs"] == nil ? nil : route("BoundOutputs", anchor: "Output"),
            boundSources: fields["BoundSources"] == nil ? nil : route("BoundSources"),
            classes: [], connections: [], outputClasses: [], outputConnections: [],
            conclusion: .unavailable(output: []))
        let r = try agreementReading(request, certificate: p, source: source, constructor: constructor)
        let (classes, connections, blocks) = constructPartition(r.whole)
        let (outputClasses, outputConnections, outputBlocks) = constructPartition(r.output)
        p.classes = classes; p.connections = connections
        p.outputClasses = outputClasses; p.outputConnections = outputConnections
        p.conclusion = try constructAgreement(r, classes: classes, blocks: blocks,
                                             outputClasses: outputClasses, outputBlocks: outputBlocks)
        _ = try verifyAgreement(request, certificate: p, source: source, constructor: constructor)
        return p
    }
    static func verifyAgreementPlan(_ plan: AgreementPlan, reading r: AgreementReading,
                                     classes: [PartitionClass], blocks: [Path: Int],
                                     outputClasses: [PartitionClass], outputBlocks: [Path: Int],
                                     edges: [Path: SourceEdge], budget: inout ActionBudget) throws {
        let at = "certificate.agreement.plan"
        let binding = try agreementBindings(r, sourceBlocks: blocks, outputBlocks: outputBlocks)
        guard binding.issue == nil else { throw Failure(at + ": incompatible declared bindings") }
        let capacities = agreementCapacities(r, sourceClasses: classes, sourceBlocks: blocks,
                                             outputClasses: outputClasses, fixed: binding.fixed)
        guard plan.capacities == capacities else { throw Failure(at + ".capacities: counts differ from exact classes and fixed bindings") }
        let p = try agreementPlaces(r, assignments: plan.assignments, outputBlocks: outputBlocks, at: at)
        try budget.spend(plan.assignments.count + plan.residualLeaves.count, at: at)
        guard plan.step == (try assembledProgram(p, inputs: p.leaves.map(\.source))) else {
            throw Failure(at + ".step: term differs from C-class assignments")
        }
        guard plan.bindingBases.count == r.bindings.count else { throw Failure(at + ".bindingBases: incomplete binding coverage") }
        for (index, pair) in zip(plan.bindingBases, r.bindings).enumerated() {
            guard case let .leaf(origin) = try p.at(pair.1.output) else { throw Failure(at + ".binding: nonleaf output") }
            try checkActionBasis(pair.0, from: origin, to: pair.1.source, reading: r.sourceReading,
                edges: edges, at: at + ".bindingBases[\(index)]", budget: &budget)
        }
        let reading = RelatedReading(whole: r.whole, observation: p, question: r.question)
        let needed = try requiredClasses(reading, blocks: blocks)
        guard plan.needed == needed else { throw Failure(at + ".needed: required classes or Question addresses differ") }
        let lower = capacities.reduce(0) { $0 + $1.minimum }
        guard plan.residualLeaves.count == needed.count, needed.count == lower else {
            throw Failure(at + ".residualLeaves: leaf count does not attain the global lower bound")
        }
        var supplied: Set<Int> = []
        let missing = Set(needed.map(\.block))
        for (index, leaf) in plan.residualLeaves.enumerated() {
            guard let block = blocks[leaf], missing.contains(block), supplied.insert(block).inserted else {
                throw Failure(at + ".residualLeaves[\(index)]: not a distinct required missing E-class")
            }
        }
        let m = retainedPlaces(plan.residualLeaves)
        let residual = try m.map { try assembledProgram($0, inputs: plan.residualLeaves) }
        guard plan.residual == residual else { throw Failure(at + ".residual: source term differs from retained addresses") }
        let joint = RelatedReading(whole: r.whole, observation: m.map { .pair(p, $0) } ?? p, question: r.question)
        for selection in plan.selections {
            if case let .sourceRelation(path) = selection.basis { try budget.spend(path.count, at: at + ".decoder") }
            else { try budget.spend(at: at + ".decoder") }
        }
        try verifyRelatedProgram(plan.selections, program: plan.decoder, reading: joint,
                                 address: at + ".decoder", edgeIndex: edges)
    }
    // No equivalence closure, assignment search or plan construction in replay.
    static func verifyAgreement(_ request: String, certificate p: AgreementCertificate,
                                 source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        let r = try agreementReading(request, certificate: p, source: source, constructor: constructor)
        var budget = ActionBudget()
        try budget.spend(r.whole.source.leaves.count + r.whole.edges.count
            + r.output.source.leaves.count + r.output.edges.count + r.bindings.count,
            at: "certificate.agreement")
        let blocks = try verifyPartition(p.classes, whole: r.whole, at: "certificate.agreement.sourceClasses")
        let edges = Dictionary(uniqueKeysWithValues: r.whole.edges.map { ($0.address, $0) })
        try verifyEForests(p.connections, classes: p.classes, edges: edges, at: "certificate.agreement.sourceConnections")
        let outputs = try verifyPartition(p.outputClasses, whole: r.output, at: "certificate.agreement.outputClasses")
        let cEdges = Dictionary(uniqueKeysWithValues: r.output.edges.map { ($0.address, $0) })
        try verifyEForests(p.outputConnections, classes: p.outputClasses, edges: cEdges, at: "certificate.agreement.outputConnections")
        switch p.conclusion {
        case let .constructed(plan):
            try verifyAgreementPlan(plan, reading: r, classes: p.classes, blocks: blocks,
                outputClasses: p.outputClasses, outputBlocks: outputs, edges: edges, budget: &budget)
            return true
        case let .unavailable(path):
            let sort: String
            do { sort = try r.output.sort(path) }
            catch { throw Failure("certificate.agreement.unavailable.output: " + String(describing: error)) }
            guard !(p.classes.contains { $0.sort == sort }) else {
                throw Failure("certificate.agreement.unavailable: the sort is available at Source")
            }
        case let .wrongSort(address):
            guard let binding = (r.bindings.first { $0.address == address }) else {
                throw Failure("certificate.agreement.wrongSort.binding: no declared binding at this address")
            }
            guard try r.output.sort(binding.output) != r.whole.sort(binding.source) else {
                throw Failure("certificate.agreement.wrongSort: binding sorts agree")
            }
        case let .incompatible(left, right):
            let bindings = Dictionary(uniqueKeysWithValues: r.bindings.map { ($0.address, $0) })
            guard let a = bindings[left], let b = bindings[right] else {
                throw Failure("certificate.agreement.incompatible: no declared bindings at these addresses")
            }
            guard try r.output.sort(a.output) == r.whole.sort(a.source),
                  try r.output.sort(b.output) == r.whole.sort(b.source),
                  outputs[a.output] == outputs[b.output], blocks[a.source] != blocks[b.source] else {
                throw Failure("certificate.agreement.incompatible: bindings do not separate source classes in one output C-class")
            }
        }
        return false
    }
    static func encodeAgreement(_ certificate: AgreementCertificate) throws -> Data {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(AgreementArchive(format: 7, certificate: certificate))
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: output limit") }
        return data
    }
    static func decodeAgreement(_ data: Data) throws -> AgreementCertificate {
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: input limit") }
        let archive = try JSONDecoder().decode(AgreementArchive.self, from: data)
        guard archive.format == 7 else { throw Failure("certificate: expected format 7 for an agreement judgment") }
        return archive.certificate
    }
}
