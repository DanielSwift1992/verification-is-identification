import Foundation
import ContinuationRecord

// U9 derives the relation of the declared Image; a source completion is existential.
// Paired<Source, P> gives the joint graph. A marginal cut neither adds identity
// nor passes its relation to a continuation, and acquires no omitted field.
extension ContinuationCourt {
    typealias ImagePromise = ContinuationCore.ImagePromise
    typealias InducedImage = ContinuationCore.InducedImage
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
    typealias ImageReading = ContinuationCore.ImageReading
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
        let judgment = try ContinuationCore.constructImage(r)
        certificate.classes = judgment.classes
        certificate.connections = judgment.connections
        certificate.images = judgment.images
        _ = try verifyImage(request, certificate: certificate, source: source, constructor: constructor)
        return certificate
    }
    // Replay checks supplied partitions, addressed origins and E paths. There
    // is no equivalence closure, orbit search or source completion here.

    static func verifyImage(_ request: String, certificate: ImageCertificate, source: StructuralSource,
                             constructor: String = "Paired") throws -> Bool {
        let r = try imageReading(request, certificate: certificate, source: source, constructor: constructor)
        return try ContinuationCore.verifyImage(.init(classes: certificate.classes,
            connections: certificate.connections, images: certificate.images), reading: r)
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
