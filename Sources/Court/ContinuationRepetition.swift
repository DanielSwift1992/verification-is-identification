import Foundation
import ContinuationRecord

// Swift admission delegates to the common U11 rules.
extension ContinuationCourt {
    typealias ReturnCycle = ContinuationCore.ReturnCycle
    typealias ReturnArithmetic = ContinuationCore.ReturnArithmetic
    typealias ReturnBlock = ContinuationCore.ReturnBlock
    typealias ReturnTail = ContinuationCore.ReturnTail
    typealias ReturnConclusion = ContinuationCore.ReturnConclusion
    typealias Repetition = ContinuationCore.Repetition
    typealias ReturnCount = ContinuationCore.ReturnCount
    static func returnGCD(_ count: ReturnCount, length: Int, at: String, budget: inout ActionBudget) throws -> Int {
        try ContinuationCore.returnGCD(count, length: length, at: at, budget: &budget)
    }
    static func repetitionMembers(_ r: RelatedReading, at: String) throws -> [ActionMember] {
        try ContinuationCore.repetitionMembers(r.core, at: at)
    }
    static func constructRepetition(_ r: RelatedReading, request: String) throws -> Repetition {
        try ContinuationCore.constructRepetition(r.core, request: request)
    }
    static func verifyReturnWalk(_ vertices: [Int], member: ActionMember, classes: [PartitionClass], blocks: [Path: Int], at: String, budget: inout ActionBudget) throws {
        try ContinuationCore.verifyReturnWalk(vertices, member: member, classes: classes, blocks: blocks, at: at, budget: &budget)
    }
    static func verifyReturnBlock(_ proof: ReturnBlock, members: [ActionMember], required: [Int], classes: [PartitionClass], blocks: [Path: Int], budget: inout ActionBudget) throws {
        try ContinuationCore.verifyReturnBlock(proof, members: members, required: required, classes: classes, blocks: blocks, budget: &budget)
    }
    static func verifyRepetition(_ proof: Repetition, reading r: RelatedReading, request: String) throws -> Bool {
        try ContinuationCore.verifyRepetition(proof, reading: r.core, request: request)
    }
    static func verifyRelatedRepetition(_ request: String, certificate: RelatedCertificate,
                                        source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        _ = try verifyRelated(request, certificate: certificate, source: source, constructor: constructor)
        guard let repetition = certificate.repetition else {
            throw Failure("certificate.repetition: no U11 judgment was presented")
        }
        // The common verifier above already checked this same proof once.
        if case .returned? = repetition.conclusion { return true }
        return false
    }}
