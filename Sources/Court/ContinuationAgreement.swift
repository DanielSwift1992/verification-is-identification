import Foundation
import ContinuationRecord

// U10/U10a choose a structural image under declared output obligations.
// Reading is Context/RouteProof; replay checks finite addressed certificates.
// Leaf minimality is not an information order between different chosen images.
extension ContinuationCourt {
    typealias LeafBinding = ContinuationCore.LeafBinding
    typealias AgreementCapacity = ContinuationCore.AgreementCapacity
    typealias AgreementPlan = ContinuationCore.AgreementPlan
    typealias AgreementConclusion = ContinuationCore.AgreementConclusion
    struct AgreementCertificate: Codable {
        var request: ScalarName
        var constructor: ScalarName
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
    typealias AgreementReading = ContinuationCore.AgreementReading
    static func agreementReading(_ request: String, certificate p: AgreementCertificate,
                                  source: StructuralSource, constructor: String = "Paired") throws -> AgreementReading {
        guard WhereJudge.sameName(p.request, request), WhereJudge.sameName(p.constructor, constructor) else {
            throw Failure("certificate: request or constructor substituted")
        }
        let c = try Context(request, source: source, constructor: constructor,
                            requiredFields: ["Source", "Output", "Question"])
        let whole = try readWhole(p.source, equalities: p.equalities, context: c)
        let out: (E, Shape)
        do { out = try c.replay(p.output) }
        catch { throw Failure(request + ".Output: " + String(describing: error)) }
        guard out.0 == .field(c.root, "Output") else { throw Failure(request + ".Output: endpoint substituted") }
        guard case let .definition(_, arguments, body) = p.output,
              c.fieldsRead(body).isEmpty,
              arguments.allSatisfy({ c.fieldsRead($0).isEmpty }) else {
            throw Failure(request + ".Output: the target shape is written with sorts; source places are prescribed by BoundOutputs/BoundSources")
        }
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




    static func agreementPlaces(_ r: AgreementReading, assignments: [Path], outputBlocks: [Path: Int], at: String) throws -> Places {
        try ContinuationCore.agreementPlaces(r, assignments: assignments, outputBlocks: outputBlocks, at: at)
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
        let judgment = try ContinuationCore.constructAgreementJudgment(r)
        p.classes = judgment.classes; p.connections = judgment.connections
        p.outputClasses = judgment.outputClasses; p.outputConnections = judgment.outputConnections
        p.conclusion = judgment.conclusion
        _ = try verifyAgreement(request, certificate: p, source: source, constructor: constructor)
        return p
    }

    static func verifyAgreement(_ request: String, certificate p: AgreementCertificate,
                                 source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        let r = try agreementReading(request, certificate: p, source: source, constructor: constructor)
        return try ContinuationCore.verifyAgreement(.init(classes: p.classes, connections: p.connections,
            outputClasses: p.outputClasses, outputConnections: p.outputConnections, conclusion: p.conclusion), reading: r, request: request)
    }

    static func encodeAgreement(_ certificate: AgreementCertificate) throws -> Data {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(AgreementArchive(format: 7, certificate: certificate))
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: output limit") }
        return data
    }
    static func decodeAgreement(_ data: Data) throws -> AgreementCertificate {
        guard data.count <= relatedArchiveLimit else { throw Failure("certificate: input limit") }
        let archive = try CourtJSON.decoder().decode(AgreementArchive.self, from: data)
        guard archive.format == 7 else { throw Failure("certificate: expected format 7 for an agreement judgment") }
        return archive.certificate
    }
}
