import Foundation

/// The remaining questions use the same addressed record and the shared rules.
public enum RecordExtension {
    public typealias C = ContinuationCore
    public enum Mode: String { case image = "--image", agreement = "--agreement", repeats = "--repeat" }
    public enum Question {
        case image(C.ImageReading)
        case agreement(C.AgreementReading)
        case repeats(RecordContinuation.World)
    }
    public struct World {
        public let question: Question
        public let canonical: Data
    }
    public struct Certificate: Codable {
        public var format: Int
        public var record: String
        public var image: C.ImageJudgment?
        public var agreement: C.AgreementJudgment?
        public var repetition: C.Repetition?
        public init(record: String, image: C.ImageJudgment? = nil, agreement: C.AgreementJudgment? = nil, repetition: C.Repetition? = nil) {
            self.format = 9
            self.record = record
            self.image = image
            self.agreement = agreement
            self.repetition = repetition
        }
    }
    static func prefix(_ schema: Int, _ whole: C.WholeReading, sorts: inout [String]) -> String {
        "{\"schema\":\(schema),\"source\":" + RecordStructure.shapeText(whole.source,sorts:&sorts)
            + ",\"equalities\":" + RecordStructure.edgesText(whole.edges)
    }
    public static func encodeImage(whole: C.WholeReading, image: C.Places,
        promise: [C.SourceEdge]? = nil, hiddenActions: [C.ActionMember]? = nil) -> Data {
        var sorts: [String] = []
        var text = prefix(3,whole,sorts:&sorts) + ",\"image\":" + RecordContinuation.viewText(image)
        if let promise { text += ",\"promise\":" + RecordStructure.edgesText(promise) }
        if let hiddenActions { text += ",\"hiddenActions\":" + RecordStructure.familyText(hiddenActions) }
        return Data((text + "}").utf8)
    }
    public static func encodeAgreement(whole: C.WholeReading, output: C.WholeReading, question: C.Places,
        promiseDeclared: Bool = true, boundOutputs: C.Places? = nil, boundSources: C.Places? = nil) throws -> Data {
        guard promiseDeclared || output.edges.isEmpty else { throw C.Failure("record.promise: an existing obligation cannot be omitted") }
        var sorts: [String] = []
        var text = prefix(4,whole,sorts:&sorts) + ",\"output\":" + RecordStructure.shapeText(output.source,sorts:&sorts)
            + ",\"question\":" + RecordContinuation.viewText(question)
        if promiseDeclared { text += ",\"promise\":" + RecordStructure.edgesText(output.edges) }
        if let boundOutputs { text += ",\"boundOutputs\":" + RecordContinuation.viewText(boundOutputs) }
        if let boundSources { text += ",\"boundSources\":" + RecordContinuation.viewText(boundSources) }
        return Data((text + "}").utf8)
    }
    public static func read(_ data: Data, mode: Mode) throws -> World {
        if mode == .repeats {
            let world = try RecordContinuation.read(data)
            guard world.schema == 2 else { throw C.Failure("record.schema: U11 asks schema 2") }
            guard let hidden = world.reading.hiddenActions, !hidden.isEmpty else { throw C.Failure("record.hiddenActions: U11 requires a nonempty family") }
            return World(question:.repeats(world),canonical:data)
        }
        let isImage = mode == .image
        let fields = try RecordJSON.read(data,at:"record").object("record",
            keys:isImage ? ["schema","source","equalities","image"] : ["schema","source","equalities","output","question"],
            optional:isImage ? ["promise","hiddenActions"] : ["promise","boundOutputs","boundSources"])
        guard try fields["schema"]!.integer("record.schema") == (isImage ? 3 : 4) else {
            throw C.Failure("record.schema: question and schema differ")
        }
        let tree = try RecordStructure.shape(fields["source"]!,at:"record.source")
        let bare = C.WholeReading(source:tree,edges:[])
        let whole = try C.WholeReading(source:tree,edges:RecordStructure.edges(fields["equalities"]!,whole:bare,at:"record.equalities"))
        let canonical: Data, question: Question
        if isImage {
            let image = try RecordStructure.view(fields["image"]!,whole:whole,at:"record.image")
            let output = try C.shapeOfPlaces(image,source:tree,address:"record.image")
            let target = C.WholeReading(source:output,edges:[])
            let promise = try fields["promise"].map { try RecordStructure.edges($0,whole:target,at:"record.promise") }
            let hidden = try fields["hiddenActions"].map { try RecordStructure.family($0,target:output,whole:whole,at:"record.hiddenActions",nonempty:true) }
            if let hidden, !hidden.contains(
                where: { $0.image == image }) {
                throw C.Failure("record.image: expected the same source places as a hiddenActions member")
            }
            let r = C.ImageReading(whole:whole,image:image,output:output,promise:promise ?? [],members:hidden ?? [.init(address:[],image:image)])
            question = .image(r)
            canonical = encodeImage(whole:whole,image:image,promise:promise,hiddenActions:hidden)
        } else {
            let outShape = try RecordStructure.shape(fields["output"]!,at:"record.output")
            let bareOutput = C.WholeReading(source:outShape,edges:[])
            let promise = try fields["promise"].map { try RecordStructure.edges($0,whole:bareOutput,at:"record.promise") }
            let output = C.WholeReading(source:outShape,edges:promise ?? [])
            let q = try RecordStructure.view(fields["question"]!,whole:whole,at:"record.question")
            guard (fields["boundOutputs"] != nil) == (fields["boundSources"] != nil) else {
                throw C.Failure("record." + (fields["boundOutputs"] == nil ? "boundOutputs" : "boundSources") + ": both binding endpoint fields are required together")
            }
            let bo = try fields["boundOutputs"].map { try RecordStructure.view($0,whole:output,at:"record.boundOutputs") }
            let bs = try fields["boundSources"].map { try RecordStructure.view($0,whole:whole,at:"record.boundSources") }
            var bindings: [C.LeafBinding] = []
            if let bo, let bs {
                bindings = try C.pairedPlaces(bo,bs,address:"record.boundSources").map { .init(address:$0.address,output:$0.left,source:$0.right) }
            }
            question = .agreement(.init(whole:whole,output:output,question:q,bindings:bindings))
            canonical = try encodeAgreement(whole:whole,output:output,question:q,promiseDeclared:promise != nil,boundOutputs:bo,boundSources:bs)
        }
        guard canonical == data else {
            let offset = zip(canonical,data).enumerated().first { $0.element.0 != $0.element.1 }?.offset ?? min(canonical.count,data.count)
            throw C.Failure("record: noncanonical serialization (byte \(offset))")
        }
        return World(question:question,canonical:canonical)
    }
    public static func derive(_ w: World) throws -> Certificate {
        let record = String(decoding:w.canonical,as:UTF8.self)
        let c: Certificate
        switch w.question {
        case let .image(r): c = try .init(record:record,image:C.constructImage(r))
        case let .agreement(r): c = try .init(record:record,agreement:C.constructAgreementJudgment(r))
        case let .repeats(w): c = try .init(record:record,repetition:C.constructRepetition(w.reading,request:"record"))
        }
        _ = try verify(c,world:w)
        return c
    }
    static func located(_ axis: String, _ body: () throws -> Bool) throws -> Bool {
        do { return try body() }
        catch let failure as C.Failure {
            var message = failure.description
            if !axis.isEmpty && message.hasPrefix("certificate.") {
                message = "certificate." + axis + "." + message.dropFirst("certificate.".count)
            }
            message = message.replacingOccurrences(of: "record.BoundSources", with: "record.boundSources")
            message = message.replacingOccurrences(of: "certificate.repetition.conclusion.returned.", with: "certificate.repetition.conclusion.returned._0.")
            message = message.replacingOccurrences(of: "certificate.repetition.conclusion.obstructed.", with: "certificate.repetition.conclusion.obstructed._0.")
            throw C.Failure(message)
        }
    }
    public static func verify(_ c: Certificate, world w: World) throws -> Bool {
        guard c.format == 9 else { throw C.Failure("certificate.format: expected record format 9") }
        guard Data(c.record.utf8) == w.canonical else { throw C.Failure("certificate.record: source record substituted") }
        switch w.question {
        case let .image(r):
            guard let proof=c.image, c.agreement == nil, c.repetition == nil else { throw C.Failure("certificate.image: expected only the declared U9 judgment") }
            return try located("image") { try C.verifyImage(proof,reading:r) }
        case let .agreement(r):
            guard let proof=c.agreement, c.image == nil, c.repetition == nil else { throw C.Failure("certificate.agreement: expected only the declared U10 judgment") }
            return try located("agreement") { try C.verifyAgreement(proof,reading:r,request:"record") }
        case let .repeats(w):
            guard let proof=c.repetition, c.image == nil, c.agreement == nil else { throw C.Failure("certificate.repetition: expected only the declared U11 judgment") }
            return try located("") { try C.verifyRepetition(proof,reading:w.reading,request:"record") }
        }
    }
    public static func encodeCertificate(_ c: Certificate) throws -> Data {
        let encoder=JSONEncoder()
        encoder.outputFormatting=[.prettyPrinted,.sortedKeys]
        let data=try encoder.encode(c)
        guard data.count<=8_000_000 else { throw C.Failure("certificate: output limit") }
        return data
    }
    public static func decodeCertificate(_ data: Data) throws -> Certificate {
        _ = try RecordJSON.read(data,at:"certificate",depthLimit:256,workLimit:data.count)
            .object("certificate",keys:["format","record"],optional:["image","agreement","repetition"])
        let proof: Certificate
        do { proof = try JSONDecoder().decode(Certificate.self,from:data) }
        catch { throw C.Failure("certificate: " + String(describing:error)) }
        let before=try JSONSerialization.jsonObject(with:data), after=try JSONSerialization.jsonObject(with:encodeCertificate(proof))
        guard try JSONSerialization.data(withJSONObject:before,options:[.sortedKeys]) == JSONSerialization.data(withJSONObject:after,options:[.sortedKeys]) else {
            throw C.Failure("certificate: unread fields or changed transport")
        }
        return proof
    }
    public static func run(_ arguments: [String], replay: Bool) {
        do {
            var args=arguments
            guard !args.isEmpty, let mode=Mode(rawValue:args.removeFirst()) else { throw C.Failure("record: expected --image, --agreement or --repeat") }
            var output: String?, saved: Certificate?, savedBytes: Data?
            if replay {
                guard !args.isEmpty else { throw C.Failure("certificate: missing file") }
                let bytes=try Data(contentsOf:URL(fileURLWithPath:args.removeFirst()))
                saved=try decodeCertificate(bytes)
                savedBytes=bytes
            } else if args.first == "--certificate" {
                args.removeFirst()
                guard !args.isEmpty else { throw C.Failure("certificate: missing output") }
                output=args.removeFirst()
            }
            guard args.count==1 else { throw C.Failure("usage: --record [--image|--agreement|--repeat] [--certificate proof.json] world.json") }
            let w=try read(Data(contentsOf:URL(fileURLWithPath:args[0])),mode:mode)
            let c=try saved ?? derive(w), holds=try verify(c,world:w)
            let bytes=try savedBytes ?? encodeCertificate(c)
            if let output { try bytes.write(to:URL(fileURLWithPath:output),options:.atomic) }
            FileHandle.standardOutput.write(bytes + (bytes.last == 10 ? Data() : Data("\n".utf8)))
            if !holds { exit(1) }
        } catch {
            FileHandle.standardError.write(Data(("Continuation record unresolved: " + String(describing:error) + "\n").utf8))
            exit(2)
        }
    }
}
