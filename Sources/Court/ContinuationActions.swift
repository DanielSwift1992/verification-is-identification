import Foundation
import ContinuationRecord

// The Swift entrance admits families; the shared core constructs and replays U7/U8.
extension ContinuationCourt {
    typealias ActionMember = ContinuationCore.ActionMember
    typealias Preservation = ContinuationCore.Preservation
    typealias ActionEvidence = ContinuationCore.ActionEvidence
    typealias ReachableClass = ContinuationCore.ReachableClass
    typealias ImageAction = ContinuationCore.ImageAction
    typealias StableView = ContinuationCore.StableView
    typealias HiddenConclusion = ContinuationCore.HiddenConclusion
    typealias HiddenJudgment = ContinuationCore.HiddenJudgment
    typealias Dynamics = ContinuationCore.Dynamics
    typealias ActionBudget = ContinuationCore.ActionBudget
    // Split an already interpreted product, never source text.
    static func actionMembers(_ places: Places, source: Shape, address: String,
                              output: Shape? = nil) throws -> [ActionMember] {
        var members: [ActionMember] = []
        var budget = ActionBudget()
        func split(_ p: Places, _ s: Shape, _ path: Path) throws {
            try budget.spend(at: address)
            if s == (output ?? source) {
                members.append(ActionMember(address: path, image: p))
                return
            }
            guard case let .pair(l, r) = p, case let .pair(a, b) = s else {
                let expected = output == nil ? "Source-shaped action" : "Image-shaped step"
                throw Failure(pathText(address, path) + ": expected a complete " + expected)
            }
            try split(l, a, path + [.left])
            try split(r, b, path + [.right])
        }
        try split(places, shapeOfPlaces(places, source: source, address: address), [])
        return members
    }
    static func equalityGraph(_ r: RelatedReading) -> [Path: [(Path, EqualityStep)]] {
        equalityGraph(r.whole)
    }
    static func equalityGraph(_ whole: WholeReading) -> [Path: [(Path, EqualityStep)]] {
        ContinuationCore.equalityGraph(whole)
    }
    // Construction only. Replay checks the closed partition and these forests.
    static func constructPartition(_ r: RelatedReading) ->
        (classes: [PartitionClass], connections: [[EqualityStep]], blocks: [Path: Int]) {
        constructPartition(r.whole)
    }
    static func constructPartition(_ whole: WholeReading) ->
        (classes: [PartitionClass], connections: [[EqualityStep]], blocks: [Path: Int]) {
        ContinuationCore.constructPartition(whole)
    }
    static func constructionBasis(_ from: Path, _ to: Path, reading r: RelatedReading,
                                  budget: inout ActionBudget) throws -> EqualityBasis {
        try ContinuationCore.constructionBasis(from, to, reading: r.core, budget: &budget)
    }
    static func checkActionBasis(_ basis: EqualityBasis, from: Path, to: Path,
                                 reading r: RelatedReading, edges: [Path: SourceEdge], at: String,
                                 budget: inout ActionBudget) throws {
        try ContinuationCore.checkActionBasis(basis, from: from, to: to, reading: r.core,
                                             edges: edges, at: at, budget: &budget)
    }
    static func classImage(_ action: ActionMember, block: Int, classes: [PartitionClass],
                           blocks: [Path: Int]) throws -> Int {
        try ContinuationCore.classImage(action, block: block, classes: classes, blocks: blocks)
    }
    static func evidenceHolds(_ evidence: [ActionEvidence]) -> Bool {
        ContinuationCore.evidenceHolds(evidence)
    }
    static func imageAction(_ action: ActionMember, view: Places, classList: [Int],
                            classes: [PartitionClass], blocks: [Path: Int], reading r: RelatedReading) throws -> ImageAction {
        try ContinuationCore.imageAction(action, view: view, classList: classList, classes: classes,
                                         blocks: blocks, reading: r.core)
    }
    static func constructEvidence(_ members: [ActionMember], reading r: ContinuationCore.Reading,
                                  blocks: [Path: Int], budget: inout ActionBudget) throws -> [ActionEvidence] {
        try ContinuationCore.constructEvidence(members, reading: r, blocks: blocks, budget: &budget)
    }
    static func constructDynamics(_ r: RelatedReading) throws -> Dynamics {
        try ContinuationCore.constructDynamics(r.core)
    }
    static func verifyDynamics(_ proof: Dynamics, reading r: RelatedReading) throws {
        try ContinuationCore.verifyDynamics(proof, reading: r.core)
    }
    static func distinctClasses(_ places: Places, blocks: [Path: Int]) -> [Int] {
        ContinuationCore.distinctClasses(places, blocks: blocks)
    }
    static func constructEvidence(_ members: [ActionMember], reading r: RelatedReading,
                                  blocks: [Path: Int], budget: inout ActionBudget) throws -> [ActionEvidence] {
        try ContinuationCore.constructEvidence(members, reading: r.core, blocks: blocks, budget: &budget)
    }
    static func verifyEvidence(_ evidence: [ActionEvidence], members: [ActionMember],
                               reading r: RelatedReading, blocks: [Path: Int], edges: [Path: SourceEdge], at: String,
                               budget: inout ActionBudget) throws -> Bool {
        try ContinuationCore.verifyEvidence(evidence, members: members, reading: r.core, blocks: blocks,
                                            edges: edges, at: at, budget: &budget)
    }
    static func verifyRelatedActions(_ request: String, certificate: RelatedCertificate,
                                     source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
        guard let proof = certificate.dynamics else { throw Failure("certificate.dynamics: no U7/U8 judgment was presented") }
        return ContinuationCore.dynamicsHolds(proof)
    }
}
