import Foundation

/// Addressed U5–U8 worlds and their admission, with no source-language context.
public enum RecordContinuation {
    public typealias Core = ContinuationCore
    public struct World {
        public let reading: Core.Reading
        public let canonical: Data
        public let schema: Int
    }
    public struct Certificate: Codable {
        public var format: Int
        public var record: String
        public var conclusion: Core.RelatedConclusion
        public var retention: Core.RelatedRetention?
        public var dynamics: Core.Dynamics?
        public init(record: String, conclusion: Core.RelatedConclusion, retention: Core.RelatedRetention?, dynamics: Core.Dynamics? = nil) {
            self.format = 8
            self.record = record
            self.conclusion = conclusion
            self.retention = retention
            self.dynamics = dynamics
        }
    }
    static func path(_ value: RecordJSON.Value, _ at: String) throws -> Core.Path {
        let values = try value.array(at)
        guard values.count < 128 else { throw Core.Failure(at + ": address depth limit") }
        return try values.enumerated().map { index, value in
            switch try value.integer(at + "[\(index)]") {
            case 0: return .left
            case 1: return .right
            default: throw Core.Failure(at + "[\(index)]: address side must be 0 or 1")
            }
        }
    }
    static func wire(_ path: Core.Path) -> String { "[" + path.map { $0 == .left ? "0" : "1" }.joined(separator: ",") + "]" }
    static func viewText(_ places: Core.Places) -> String {
        switch places {
        case let .leaf(path): return "{\"place\":" + wire(path) + "}"
        case let .pair(l, r): return "{\"pair\":[" + viewText(l) + "," + viewText(r) + "]}"
        }
    }
    /// A common encoder for Swift's already admitted reading and direct authoring.
    /// Sort identifiers are assigned by first occurrence, never by their spelling.
    public static func encode(_ reading: Core.Reading) throws -> Data {
        guard reading.actions.isEmpty, reading.hiddenActions == nil else {
            throw Core.Failure("record.schema: actions require schema 2")
        }
        return try encodeWorld(reading, schema: 1, actionsDeclared: false)
    }
    public static func encodeActions(_ reading: Core.Reading, actionsDeclared: Bool = true) throws -> Data {
        guard actionsDeclared || reading.actions.isEmpty else { throw Core.Failure("record.actions: a declared nonempty family cannot be omitted") }
        guard reading.hiddenActions?.isEmpty != true else { throw Core.Failure("record.hiddenActions: expected a nonempty hidden family") }
        return try encodeWorld(reading, schema: 2, actionsDeclared: actionsDeclared)
    }
    static func encodeWorld(_ reading: Core.Reading, schema: Int, actionsDeclared: Bool) throws -> Data {
        var sorts: [String] = []
        let source = RecordStructure.shapeText(reading.source, sorts: &sorts)
        var text = "{\"schema\":\(schema),\"source\":" + source
            + ",\"equalities\":" + RecordStructure.edgesText(reading.edges)
            + ",\"observation\":" + viewText(reading.observation) + ",\"question\":" + viewText(reading.question)
        if actionsDeclared { text += ",\"actions\":" + RecordStructure.familyText(reading.actions) }
        if let hidden = reading.hiddenActions { text += ",\"hiddenActions\":" + RecordStructure.familyText(hidden) }
        return Data((text + "}").utf8)
    }
    public static func read(_ data: Data) throws -> World {
        let fields = try RecordJSON.read(data, at: "record").object("record", keys: ["schema", "source", "equalities", "observation", "question"], optional: ["actions", "hiddenActions"])
        let schema = try fields["schema"]!.integer("record.schema")
        guard schema == 1 || schema == 2 else { throw Core.Failure("record.schema: expected version 1 or 2") }
        if schema == 1, fields["actions"] != nil || fields["hiddenActions"] != nil {
            throw Core.Failure("record.schema: schema 1 has no action axes")
        }
        let tree = try RecordStructure.shape(fields["source"]!, at: "record.source")
        let whole = Core.WholeReading(source: tree, edges: [])
        let edges = try RecordStructure.edges(fields["equalities"]!, whole: whole, at: "record.equalities")
        let actions = try fields["actions"].map { try RecordStructure.family($0, target: tree, whole: whole, at: "record.actions", nonempty: false) } ?? []
        let hidden = try fields["hiddenActions"].map { try RecordStructure.family($0, target: tree, whole: whole, at: "record.hiddenActions", nonempty: true) }
        let reading = try Core.Reading(whole: .init(source: tree, edges: edges),
            observation: RecordStructure.view(fields["observation"]!, whole: whole, at: "record.observation"),
            question: RecordStructure.view(fields["question"]!, whole: whole, at: "record.question"),
            actions: actions, hiddenActions: hidden)
        let canonical = try encodeWorld(reading, schema: schema, actionsDeclared: fields["actions"] != nil)
        guard canonical == data else {
            let difference = zip(canonical, data).enumerated().first { $0.element.0 != $0.element.1 }
            let offset = difference?.offset ?? min(canonical.count, data.count)
            throw Core.Failure("record: noncanonical serialization (byte \(offset))")
        }
        return World(reading: reading, canonical: canonical, schema: schema)
    }
    public static func derive(_ world: World, retain: Bool = false, actions: Bool = false) throws -> Certificate {
        let conclusion = try Core.constructRelated(world.reading)
        let retention = try retain ? Core.retention(conclusion, reading: world.reading) : nil
        let dynamics = try actions ? Core.constructDynamics(world.reading) : nil
        let proof = Certificate(record: String(decoding: world.canonical, as: UTF8.self), conclusion: conclusion, retention: retention, dynamics: dynamics)
        _ = try verify(proof, world: world, retain: retain, actions: actions)
        return proof
    }
    public static func verify(_ proof: Certificate, world: World, retain: Bool = false, actions: Bool = false) throws -> Bool {
        guard proof.format == 8 else { throw Core.Failure("certificate.format: expected record format 8") }
        guard Data(proof.record.utf8) == world.canonical else { throw Core.Failure("certificate.record: source record substituted") }
        guard !(retain && actions), actions == (world.schema == 2) else { throw Core.Failure("record.schema: schema 2 asks --actions; schema 1 asks U5/U6") }
        let holds = try Core.verify(proof.conclusion, retention: proof.retention, reading: world.reading)
        if actions {
            guard proof.retention == nil, let dynamics = proof.dynamics else { throw Core.Failure("certificate.dynamics: expected U7/U8 without retention") }
            try Core.verifyDynamics(dynamics, reading: world.reading)
            return Core.dynamicsHolds(dynamics)
        }
        guard proof.dynamics == nil else { throw Core.Failure("certificate.dynamics: schema 1 has no action question") }
        if retain && !holds && proof.retention == nil { throw Core.Failure("certificate.retention: no retained view and decoder were presented") }
        return retain || holds
    }
    public static func encodeCertificate(_ proof: Certificate) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(proof)
        guard data.count <= 8_000_000 else { throw Core.Failure("certificate: output limit") }
        return data
    }
    public static func decodeCertificate(_ data: Data) throws -> Certificate {
        // The proof envelope is deeper than its admitted view. Each JSON value
        // consumes at least one byte, so the byte bound supplies a finite fuel.
        _ = try RecordJSON.read(data, at: "certificate", depthLimit: 256, workLimit: data.count)
            .object("certificate", keys: ["format", "record", "conclusion"], optional: ["retention", "dynamics"])
        let proof: Certificate
        do { proof = try JSONDecoder().decode(Certificate.self, from: data) }
        catch { throw Core.Failure("certificate: " + String(describing: error)) }
        let before = try JSONSerialization.jsonObject(with: data)
        let after = try JSONSerialization.jsonObject(with: encodeCertificate(proof))
        guard try JSONSerialization.data(withJSONObject: before, options: [.sortedKeys]) == JSONSerialization.data(withJSONObject: after, options: [.sortedKeys]) else {
            throw Core.Failure("certificate: unread fields or changed transport")
        }
        return proof
    }
    public static func run(_ arguments: [String], replay: Bool = false) {
        if let first = arguments.first, RecordExtension.Mode(rawValue: first) != nil {
            RecordExtension.run(arguments, replay: replay)
            return
        }
        do {
            var args = arguments
            let retain = args.first == "--retain"
            if retain { args.removeFirst() }
            let actions = args.first == "--actions"
            if actions { args.removeFirst() }
            var output: String?, saved: Certificate?, savedBytes: Data?
            if replay {
                guard !args.isEmpty else { throw Core.Failure("certificate: missing file") }
                let bytes = try Data(contentsOf: URL(fileURLWithPath: args.removeFirst()))
                saved = try decodeCertificate(bytes)
                savedBytes = bytes
            } else if args.first == "--certificate" {
                args.removeFirst()
                guard !args.isEmpty else { throw Core.Failure("certificate: missing output") }
                output = args.removeFirst()
            }
            guard args.count == 1 else { throw Core.Failure("usage: continue --record [--retain|--actions] [--certificate proof.json] world.json; replay-continuation --record [--retain|--actions] proof.json world.json") }
            let path = args[0]
            let world: World
            do { world = try read(Data(contentsOf: URL(fileURLWithPath: path))) }
            catch { throw Core.Failure(path + ": " + String(describing: error)) }
            let proof = try saved ?? derive(world, retain: retain, actions: actions)
            let holds = try verify(proof, world: world, retain: retain, actions: actions)
            let bytes = try savedBytes ?? encodeCertificate(proof)
            if let output { try bytes.write(to: URL(fileURLWithPath: output), options: .atomic) }
            FileHandle.standardOutput.write(bytes + (bytes.last == 10 ? Data() : Data("\n".utf8)))
            if !holds { exit(1) }
        } catch {
            FileHandle.standardError.write(Data(("Continuation record unresolved: " + String(describing: error) + "\n").utf8))
            exit(2)
        }
    }
}
