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
        func family(_ members: [Core.ActionMember]) -> String {
            "[" + members.map { member in
                "{\"at\":" + wire(member.address) + ",\"image\":[" + member.image.leaves.map { wire($0.source) }.joined(separator: ",") + "]}"
            }.joined(separator: ",") + "]"
        }
        var text = "{\"schema\":\(schema),\"source\":[" + nodes.joined(separator: ",")
            + "],\"equalities\":[" + edges.joined(separator: ",") + "],\"observation\":" + viewText(reading.observation)
            + ",\"question\":" + viewText(reading.question)
        if actionsDeclared { text += ",\"actions\":" + family(reading.actions) }
        if let hidden = reading.hiddenActions { text += ",\"hiddenActions\":" + family(hidden) }
        return Data((text + "}").utf8)
    }
    public static func read(_ data: Data) throws -> World {
        let fields = try RecordJSON.read(data, at: "record").object("record", keys: ["schema", "source", "equalities", "observation", "question"], optional: ["actions", "hiddenActions"])
        let schema = try fields["schema"]!.integer("record.schema")
        guard schema == 1 || schema == 2 else { throw Core.Failure("record.schema: expected version 1 or 2") }
        if schema == 1, fields["actions"] != nil || fields["hiddenActions"] != nil {
            throw Core.Failure("record.schema: schema 1 has no action axes")
        }
        let nodes = try fields["source"]!.array("record.source")
        guard !nodes.isEmpty, nodes.count <= 10_000 else { throw Core.Failure("record.source: expected a nonempty bounded pair tree") }
        var active: Set<Int> = [], visited: Set<Int> = []
        func shape(_ index: Int, _ at: String, _ depth: Int) throws -> Core.Shape {
            guard nodes.indices.contains(index) else { throw Core.Failure(at + ": unknown source node") }
            guard !active.contains(index) else { throw Core.Failure(at + ": cycle in pair tree") }
            guard depth < 128 else { throw Core.Failure(at + ": source depth limit") }
            guard visited.insert(index).inserted else { throw Core.Failure(at + ": repeated tree node") }
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
        func family(_ key: String, nonempty: Bool) throws -> [Core.ActionMember]? {
            guard let value = fields[key] else { return nil }
            let values = try value.array("record." + key)
            guard !nonempty || !values.isEmpty else { throw Core.Failure("record." + key + ": expected a nonempty hidden family") }
            var prior: Core.Path?, result: [Core.ActionMember] = []
            let leaves = tree.leaves
            for (index, value) in values.enumerated() {
                let at = "record." + key + "[\(index)]"
                let fields = try value.object(at, keys: ["at", "image"])
                let address = try path(fields["at"]!, at + ".at")
                if let previous = prior {
                    guard previous.map({ $0 == .left ? 0 : 1 }).lexicographicallyPrecedes(address.map({ $0 == .left ? 0 : 1 })) else {
                        throw Core.Failure(at + ".at: repeated or noncanonical member order")
                    }
                }
                prior = address
                let image = try fields["image"]!.array(at + ".image")
                guard image.count == leaves.count else { throw Core.Failure(at + ".image: expected one source place per Source leaf") }
                let inputs = try image.enumerated().map { offset, value -> Core.Path in
                    let here = at + ".image[\(offset)]"
                    let p = try leaf(value, here)
                    guard try Core.sameSort(whole.sort(p), leaves[offset].1) else { throw Core.Failure(here + ": action image has another sort") }
                    return p
                }
                var cursor = 0
                func fill(_ shape: Core.Shape) -> Core.Places {
                    switch shape {
                    case .leaf:
                        let p = inputs[cursor]
                        cursor += 1
                        return .leaf(p)
                    case let .pair(l, r): return .pair(fill(l), fill(r))
                    }
                }
                result.append(.init(address: address, image: fill(tree)))
            }
            return result
        }
        let reading = try Core.Reading(whole: .init(source: tree, edges: edges),
            observation: view(fields["observation"]!, "record.observation"), question: view(fields["question"]!, "record.question"),
            actions: family("actions", nonempty: false) ?? [], hiddenActions: family("hiddenActions", nonempty: true))
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
