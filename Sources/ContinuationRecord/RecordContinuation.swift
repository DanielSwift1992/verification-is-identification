import Foundation

/// The addressed U5/U6 world and its admission, with no source-language context.
public enum RecordContinuation {
    public typealias Core = ContinuationCore
    public struct World {
        public let reading: Core.Reading
        public let canonical: Data
    }
    public struct Certificate: Codable {
        public var format: Int
        public var record: String
        public var conclusion: Core.RelatedConclusion
        public var retention: Core.RelatedRetention?
        public init(record: String, conclusion: Core.RelatedConclusion, retention: Core.RelatedRetention?) {
            self.format = 8
            self.record = record
            self.conclusion = conclusion
            self.retention = retention
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
        var nodes: [String] = [], sorts: [String] = []
        func source(_ shape: Core.Shape) -> Int {
            let index = nodes.count
            nodes.append("")
            switch shape {
            case let .leaf(sort):
                let number: Int
                let prior = sorts.firstIndex { Core.sameSort($0, sort) }
                if let prior = prior { number = prior }
                else {
                    number = sorts.count
                    sorts.append(sort)
                }
                nodes[index] = "{\"sort\":\(number)}"
            case let .pair(l, r):
                let a = source(l), b = source(r)
                nodes[index] = "{\"pair\":[\(a),\(b)]}"
            }
            return index
        }
        _ = source(reading.source)
        let ordered = reading.edges.sorted { a, b in
            a.address.map { $0 == .left ? 0 : 1 }.lexicographicallyPrecedes(b.address.map { $0 == .left ? 0 : 1 })
        }
        let edges = ordered.map { edge in
            "{\"at\":" + wire(edge.address) + ",\"left\":" + wire(edge.left) + ",\"right\":" + wire(edge.right) + ",\"basis\":\"declared\"}"
        }
        return Data(("{\"schema\":1,\"source\":[" + nodes.joined(separator: ",")
            + "],\"equalities\":[" + edges.joined(separator: ",") + "],\"observation\":" + viewText(reading.observation)
            + ",\"question\":" + viewText(reading.question) + "}").utf8)
    }
    public static func read(_ data: Data) throws -> World {
        let fields = try RecordJSON.read(data, at: "record").object("record", keys: ["schema", "source", "equalities", "observation", "question"])
        guard try fields["schema"]!.integer("record.schema") == 1 else { throw Core.Failure("record.schema: expected version 1") }
        let nodes = try fields["source"]!.array("record.source")
        guard !nodes.isEmpty, nodes.count <= 10_000 else { throw Core.Failure("record.source: expected a nonempty bounded pair tree") }
        var active: Set<Int> = [], visited: Set<Int> = []
        func shape(_ index: Int, _ at: String, _ depth: Int) throws -> Core.Shape {
            guard nodes.indices.contains(index) else { throw Core.Failure(at + ": unknown source node") }
            guard !active.contains(index) else { throw Core.Failure(at + ": cycle in pair tree") }
            guard depth < 128, visited.insert(index).inserted else { throw Core.Failure(at + ": repeated tree node or depth limit") }
            active.insert(index)
            defer { active.remove(index) }
            let node = try nodes[index].object("record.source[\(index)]", keys: [], optional: ["pair", "sort"])
            guard node.count == 1 else { throw Core.Failure("record.source[\(index)]: expected pair or sort") }
            if let sort = node["sort"] { return try .leaf(String(sort.integer("record.source[\(index)].sort"))) }
            let pair = try node["pair"]!.array("record.source[\(index)].pair")
            guard pair.count == 2 else { throw Core.Failure("record.source[\(index)].pair: expected two roles") }
            return try .pair(shape(pair[0].integer("record.source[\(index)].pair[0]"), "record.source[\(index)].pair[0]", depth + 1),
                             shape(pair[1].integer("record.source[\(index)].pair[1]"), "record.source[\(index)].pair[1]", depth + 1))
        }
        let tree = try shape(0, "record.source[0]", 0)
        let unused = nodes.indices.first { !visited.contains($0) }
        if let unused = unused {
            throw Core.Failure("record.source[\(unused)]: unreachable source node")
        }
        let whole = Core.WholeReading(source: tree, edges: [])
        func leaf(_ value: RecordJSON.Value, _ at: String) throws -> Core.Path {
            let address = try path(value, at)
            do { _ = try whole.sort(address) }
            catch { throw Core.Failure(at + ": unknown or nonleaf source address") }
            return address
        }
        func view(_ value: RecordJSON.Value, _ at: String, _ depth: Int = 0) throws -> Core.Places {
            guard depth < 128 else { throw Core.Failure(at + ": view depth limit") }
            let node = try value.object(at, keys: [], optional: ["pair", "place"])
            guard node.count == 1 else { throw Core.Failure(at + ": expected pair or place") }
            if let place = node["place"] { return try .leaf(leaf(place, at + ".place")) }
            let children = try node["pair"]!.array(at + ".pair")
            guard children.count == 2 else { throw Core.Failure(at + ".pair: expected two roles") }
            return try .pair(view(children[0], at + ".pair[0]", depth + 1), view(children[1], at + ".pair[1]", depth + 1))
        }
        var addresses: Set<Core.Path> = [], edges: [Core.SourceEdge] = []
        for (index, value) in try fields["equalities"]!.array("record.equalities").enumerated() {
            let at = "record.equalities[\(index)]"
            let edge = try value.object(at, keys: ["at", "left", "right", "basis"])
            guard case .string("declared") = edge["basis"]! else { throw Core.Failure(at + ".basis: expected declared source premise; observed values are not equality") }
            let address = try path(edge["at"]!, at + ".at")
            guard addresses.insert(address).inserted else { throw Core.Failure(at + ".at: repeated E-edge address") }
            let l = try leaf(edge["left"]!, at + ".left"), r = try leaf(edge["right"]!, at + ".right")
            guard try Core.sameSort(whole.sort(l), whole.sort(r)) else { throw Core.Failure(at + ": equality endpoints have different sorts") }
            edges.append(.init(address: address, left: l, right: r))
        }
        let reading = try Core.Reading(whole: .init(source: tree, edges: edges),
            observation: view(fields["observation"]!, "record.observation"), question: view(fields["question"]!, "record.question"))
        let canonical = try encode(reading)
        guard canonical == data else {
            let difference = zip(canonical, data).enumerated().first { $0.element.0 != $0.element.1 }
            let offset = difference?.offset ?? min(canonical.count, data.count)
            throw Core.Failure("record: noncanonical serialization (byte \(offset))")
        }
        return World(reading: reading, canonical: canonical)
    }
    public static func derive(_ world: World, retain: Bool = false) throws -> Certificate {
        let conclusion = try Core.constructRelated(world.reading)
        let retention = try retain ? Core.retention(conclusion, reading: world.reading) : nil
        let proof = Certificate(record: String(decoding: world.canonical, as: UTF8.self), conclusion: conclusion, retention: retention)
        _ = try verify(proof, world: world, retain: retain)
        return proof
    }
    public static func verify(_ proof: Certificate, world: World, retain: Bool = false) throws -> Bool {
        guard proof.format == 8 else { throw Core.Failure("certificate.format: expected record format 8") }
        guard Data(proof.record.utf8) == world.canonical else { throw Core.Failure("certificate.record: source record substituted") }
        let holds = try Core.verify(proof.conclusion, retention: proof.retention, reading: world.reading)
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
            .object("certificate", keys: ["format", "record", "conclusion"], optional: ["retention"])
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
        do {
            var args = arguments
            let retain = args.first == "--retain"
            if retain { args.removeFirst() }
            var output: String?, saved: Certificate?
            if replay {
                guard !args.isEmpty else { throw Core.Failure("certificate: missing file") }
                saved = try decodeCertificate(Data(contentsOf: URL(fileURLWithPath: args.removeFirst())))
            } else if args.first == "--certificate" {
                args.removeFirst()
                guard !args.isEmpty else { throw Core.Failure("certificate: missing output") }
                output = args.removeFirst()
            }
            guard args.count == 1 else { throw Core.Failure("usage: continue --record [--retain] [--certificate proof.json] world.json; replay-continuation --record [--retain] proof.json world.json") }
            let path = args[0]
            let world: World
            do { world = try read(Data(contentsOf: URL(fileURLWithPath: path))) }
            catch { throw Core.Failure(path + ": " + String(describing: error)) }
            let proof = try saved ?? derive(world, retain: retain)
            let holds = try verify(proof, world: world, retain: retain)
            let bytes = try encodeCertificate(proof)
            if let output { try bytes.write(to: URL(fileURLWithPath: output), options: .atomic) }
            FileHandle.standardOutput.write(bytes + Data("\n".utf8))
            if !holds { exit(1) }
        } catch {
            FileHandle.standardError.write(Data(("Continuation record unresolved: " + String(describing: error) + "\n").utf8))
            exit(2)
        }
    }
}
