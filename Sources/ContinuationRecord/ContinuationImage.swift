import Foundation

// U9 rules on addressed cuts; both entrances call this same implementation.
extension ContinuationCore {
    public enum ImagePromise: Codable {
        case holds([EqualityBasis])
        case violated(edge: Path)
    }
    public struct InducedImage: Codable {
        public init(member: Path, classes: [PartitionClass], sourceClassIndices: [Int], connections: [[EqualityBasis]], promise: ImagePromise) { self.member = member; self.classes = classes; self.sourceClassIndices = sourceClassIndices; self.connections = connections; self.promise = promise }
        public var member: Path
        public var classes: [PartitionClass]
        // An injective list of exact Source E-class indices, one per output block.
        public var sourceClassIndices: [Int]
        // Source paths from each block's first output origin to its other origins.
        public var connections: [[EqualityBasis]]
        public var promise: ImagePromise
    }
    public struct ImageReading {
        public init(whole: WholeReading, image: Places, output: Shape, promise: [SourceEdge], members: [ActionMember]) { self.whole = whole; self.image = image; self.output = output; self.promise = promise; self.members = members }
        public var whole: WholeReading
        public var image: Places
        public var output: Shape
        public var promise: [SourceEdge]
        public var members: [ActionMember]
        public var relation: Reading {
            Reading(whole: whole, observation: image, question: image)
        }
    }
    public static func constructInducedImage(_ member: ActionMember, reading r: ImageReading,
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
    public static func verifyInducedImage(_ proof: InducedImage, member: ActionMember, reading r: ImageReading,
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

    public struct ImageJudgment: Codable {
        public var classes: [PartitionClass]
        public var connections: [[EqualityStep]]
        public var images: [InducedImage]
        public init(classes: [PartitionClass], connections: [[EqualityStep]], images: [InducedImage]) {
            self.classes = classes; self.connections = connections; self.images = images
        }
    }
    public static func constructImage(_ r: ImageReading) throws -> ImageJudgment {
        var budget = ActionBudget()
        try budget.spend(r.whole.source.leaves.count + r.whole.edges.count, at: "construction.image")
        let (classes, connections, blocks) = constructPartition(r.whole)
        let images = try r.members.map { try constructInducedImage($0, reading: r, blocks: blocks, budget: &budget) }
        return .init(classes: classes, connections: connections, images: images)
    }
    public static func verifyImage(_ proof: ImageJudgment, reading r: ImageReading) throws -> Bool {
        var budget = ActionBudget()
        try budget.spend(r.whole.source.leaves.count + r.whole.edges.count, at: "certificate")
        let blocks = try verifyPartition(proof.classes, whole: r.whole, at: "certificate.classes")
        let edges = Dictionary(uniqueKeysWithValues: r.whole.edges.map { ($0.address, $0) })
        try verifyEForests(proof.connections, classes: proof.classes, edges: edges, at: "certificate.connections")
        guard proof.images.count == r.members.count else { throw Failure("certificate.images: incomplete member coverage") }
        var holds = true
        for (index, pair) in zip(proof.images, r.members).enumerated() {
            let result = try verifyInducedImage(pair.0, member: pair.1, reading: r,
                sourceBlocks: blocks, edges: edges, at: "certificate.images[\(index)]", budget: &budget)
            holds = result && holds
        }
        return holds
    }
}
