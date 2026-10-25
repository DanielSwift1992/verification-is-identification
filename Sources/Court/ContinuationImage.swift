import Foundation

// U9 derives the relation of the declared Image; a source completion is existential.
// Paired<Source, P> gives the joint graph. A marginal cut neither adds identity
// nor passes its relation to a continuation, and acquires no omitted field.
extension ContinuationCourt {
    enum ImagePromise: Codable {
        case holds([EqualityBasis])
        case violated(edge: Path)
    }
    struct InducedImage: Codable {
        var member: Path
        var classes: [PartitionClass]
        // An injective list of exact Source E-class indices, one per output block.
        var sourceClassIndices: [Int]
        // Source paths from each block's first output origin to its other origins.
        var connections: [[EqualityBasis]]
        var promise: ImagePromise
    }
    struct ImageCertificate: Codable {
        var request: ScalarName
        var constructor: ScalarName
        var source: ReadProof
        var equalities: RouteProof?
        var image: RouteProof
        var promise: RouteProof?
        var hiddenActions: RouteProof?
        var classes: [PartitionClass]
        var connections: [[EqualityStep]]
        var images: [InducedImage]
    }
    struct ImageArchive: Codable {
        var format: Int
        var certificate: ImageCertificate
    }
    struct ImageReading {
        var whole: WholeReading
        var image: Places
        var output: Shape
        var promise: [SourceEdge]
        var members: [ActionMember]
        var relation: RelatedReading {
            RelatedReading(whole: whole, observation: image, question: image)
        }
    }
    static func imageReading(_ request: String, certificate: ImageCertificate,
                              source: StructuralSource, constructor: String = "Paired") throws -> ImageReading {
        guard WhereJudge.sameName(certificate.request, request), WhereJudge.sameName(certificate.constructor, constructor) else {
            throw Failure("certificate: request or constructor substituted")
        }
        let c = try Context(request, source: source, constructor: constructor,
                            requiredFields: ["Source", "Image"])
        let whole = try readWhole(certificate.source, equalities: certificate.equalities, context: c)
        let image = try readCut(certificate.image, field: "Image", whole: whole, context: c)
        let output = try shapeOfPlaces(image, source: whole.source, address: request + ".Image")
        let fields = source.declarations[request]?.fields ?? [:]
        guard (fields["Promise"] != nil) == (certificate.promise != nil) else {
            throw Failure(request + ".Promise: changed relation coverage")
        }
        var promise: [SourceEdge] = []
        if let proof = certificate.promise {
            let target = WholeReading(source: output, edges: [])
            let ends = try readCut(proof, field: "Promise", whole: target, context: c, anchor: "Image")
            promise = try equalityEdges(ends, source: output, address: request + ".Promise")
        }
        guard (fields["HiddenActions"] != nil) == (certificate.hiddenActions != nil) else {
            throw Failure(request + ".HiddenActions: changed family coverage")
        }
        var members = [ActionMember(address: [], image: image)]
        if let proof = certificate.hiddenActions {
            let family = try readCut(proof, field: "HiddenActions", whole: whole, context: c)
            members = try actionMembers(family, source: whole.source,
                                        address: request + ".HiddenActions", output: output)
            guard (members.contains { $0.image == image }) else {
                throw Failure(request + ".Image: expected the same source places as a HiddenActions member")
            }
        }
        try checkWholeAxes(certificate.source,
            routes: [certificate.image] + (certificate.equalities.map { [$0] } ?? [])
                + (certificate.promise.map { [$0] } ?? [])
                + (certificate.hiddenActions.map { [$0] } ?? []), context: c)
        return ImageReading(whole: whole, image: image, output: output, promise: promise,
                            members: members)
    }
    static func constructInducedImage(_ member: ActionMember, reading r: ImageReading,
                                       blocks: [Path: Int], budget: inout ActionBudget) throws -> InducedImage {
        var classes: [PartitionClass] = [], sourceClassIndices: [Int] = [], indices: [Int: Int] = [:]
        for leaf in member.image.leaves {
            try budget.spend(at: "construction.image.partition")
            guard let sourceClass = blocks[leaf.source] else { throw Failure("construction.image: missing source class") }
            if let block = indices[sourceClass] {
                classes[block].leaves.append(leaf.output)
            } else {
                indices[sourceClass] = classes.count
                sourceClassIndices.append(sourceClass)
                classes.append(.init(sort: try r.whole.sort(leaf.source), leaves: [leaf.output]))
            }
        }
        let connections = try classes.map { block in
            let root = try member.imageOf(block.leaves[0])
            return try block.leaves.dropFirst().map { leaf in
                try budget.spend(at: "construction.image.connection")
                return try constructionBasis(root, member.imageOf(leaf), reading: r.relation, budget: &budget)
            }
        }
        var bases: [EqualityBasis] = []
        for edge in r.promise {
            try budget.spend(at: "construction.image.promise")
            let a = try member.imageOf(edge.left), b = try member.imageOf(edge.right)
            if blocks[a] != blocks[b] {
                return .init(member: member.address, classes: classes, sourceClassIndices: sourceClassIndices,
                             connections: connections, promise: .violated(edge: edge.address))
            }
            bases.append(try constructionBasis(a, b, reading: r.relation, budget: &budget))
        }
        return .init(member: member.address, classes: classes, sourceClassIndices: sourceClassIndices,
                     connections: connections, promise: .holds(bases))
    }
    static func deriveImage(_ request: String, source: StructuralSource,
                             constructor: String = "Paired") throws -> ImageCertificate {
        let c = try Context(request, source: source, constructor: constructor,
                            requiredFields: ["Source", "Image"])
        let fields = source.declarations[request]?.fields ?? [:]
        func route(_ field: String, anchor: String = "Source") throws -> RouteProof {
            do { return try deriveRoute(.field(c.root, field), context: c, anchor: anchor) }
            catch { throw Failure(request + "." + field + ": " + String(describing: error)) }
        }
        let s: ReadProof
        do { s = try c.derive(.field(c.root, "Source")) }
        catch { throw Failure(request + ".Source: " + String(describing: error)) }
        var certificate = try ImageCertificate(request: request, constructor: constructor,
            source: s, equalities: fields["Equalities"] == nil ? nil : route("Equalities"),
            image: route("Image"), promise: fields["Promise"] == nil ? nil : route("Promise", anchor: "Image"),
            hiddenActions: fields["HiddenActions"] == nil ? nil : route("HiddenActions"),
            classes: [], connections: [], images: [])
        let r = try imageReading(request, certificate: certificate, source: source, constructor: constructor)
        var budget = ActionBudget()
        try budget.spend(r.whole.source.leaves.count + r.whole.edges.count, at: "construction.image")
        let (classes, connections, blocks) = constructPartition(r.relation)
        certificate.classes = classes
        certificate.connections = connections
        certificate.images = try r.members.map {
            try constructInducedImage($0, reading: r, blocks: blocks, budget: &budget)
        }
        _ = try verifyImage(request, certificate: certificate, source: source, constructor: constructor)
        return certificate
    }
    // Replay checks supplied partitions, addressed origins and E paths. There
    // is no equivalence closure, orbit search or source completion here.
    static func verifyInducedImage(_ proof: InducedImage, member: ActionMember, reading r: ImageReading,
                                    sourceBlocks: [Path: Int], edges: [Path: SourceEdge], at: String,
                                    budget: inout ActionBudget) throws -> Bool {
        guard proof.member == member.address else { throw Failure(at + ".member: different declared member") }
        let output = WholeReading(source: r.output, edges: [])
        _ = try verifyPartition(proof.classes, whole: output, at: at + ".classes")
        guard proof.sourceClassIndices.count == proof.classes.count,
              Set(proof.sourceClassIndices).count == proof.sourceClassIndices.count else {
            throw Failure(at + ".sourceClassIndices: expected distinct source classes for different output blocks")
        }
        guard proof.connections.count == proof.classes.count else {
            throw Failure(at + ".connections: incomplete output class coverage")
        }
        for (index, block) in proof.classes.enumerated() {
            let here = at + ".classes[\(index)]"
            let bases = proof.connections[index]
            guard bases.count == block.leaves.count - 1 else {
                throw Failure(at + ".connections[\(index)]: incomplete equality coverage")
            }
            let root = try member.imageOf(block.leaves[0])
            for (offset, leaf) in block.leaves.enumerated() {
                try budget.spend(at: here)
                let origin = try member.imageOf(leaf)
                guard sourceBlocks[origin] == proof.sourceClassIndices[index] else {
                    throw Failure(here + ": block is not the induced source class")
                }
                if offset > 0 {
                    try checkActionBasis(bases[offset - 1], from: root, to: origin,
                        reading: r.relation, edges: edges,
                        at: at + ".connections[\(index)][\(offset - 1)]", budget: &budget)
                }
            }
        }
        switch proof.promise {
        case let .holds(bases):
            guard bases.count == r.promise.count else { throw Failure(at + ".promise: incomplete C-edge coverage") }
            for (index, edge) in r.promise.enumerated() {
                let a = try member.imageOf(edge.left), b = try member.imageOf(edge.right)
                try checkActionBasis(bases[index], from: a, to: b, reading: r.relation, edges: edges,
                                     at: at + ".promise[\(index)]", budget: &budget)
            }
            return true
        case let .violated(address):
            try budget.spend(at: at + ".promise")
            guard let edge = (r.promise.first { $0.address == address }) else {
                throw Failure(at + ".promise: no declared C-edge at this address")
            }
            let a = try member.imageOf(edge.left), b = try member.imageOf(edge.right)
            guard sourceBlocks[a] != sourceBlocks[b] else {
                throw Failure(at + ".promise: C-edge does not separate source classes")
            }
            return false
        }
    }
    static func verifyImage(_ request: String, certificate: ImageCertificate, source: StructuralSource,
                             constructor: String = "Paired") throws -> Bool {
        let r = try imageReading(request, certificate: certificate, source: source, constructor: constructor)
        var budget = ActionBudget()
        try budget.spend(r.whole.source.leaves.count + r.whole.edges.count, at: "certificate")
        let blocks = try verifyPartition(certificate.classes, whole: r.whole, at: "certificate.classes")
        let edges = Dictionary(uniqueKeysWithValues: r.whole.edges.map { ($0.address, $0) })
        try verifyEForests(certificate.connections, classes: certificate.classes,
                          edges: edges, at: "certificate.connections")
        guard certificate.images.count == r.members.count else {
            throw Failure("certificate.images: incomplete member coverage")
        }
        var holds = true
        for (index, pair) in zip(certificate.images, r.members).enumerated() {
            let result = try verifyInducedImage(pair.0, member: pair.1, reading: r,
                sourceBlocks: blocks, edges: edges, at: "certificate.images[\(index)]", budget: &budget)
            holds = result && holds
        }
        return holds
    }
    static func encodeImage(_ certificate: ImageCertificate) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(ImageArchive(format: 6, certificate: certificate))
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: output limit") }
        return data
    }
    static func decodeImage(_ data: Data) throws -> ImageCertificate {
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: input limit") }
        let archive = try CourtJSON.decoder().decode(ImageArchive.self, from: data)
        guard archive.format == 6 else { throw Failure("certificate: expected format 6 for an image judgment") }
        return archive.certificate
    }
}
