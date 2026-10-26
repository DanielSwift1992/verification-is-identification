import Foundation

// The record's one addressed-tree/edge/family transport, shared by all schemas.
enum RecordStructure {
    typealias C = ContinuationCore
    static func shapeText(_ shape: C.Shape, sorts: inout [String]) -> String {
        var nodes: [String] = []
        func walk(_ shape: C.Shape) -> Int {
            let index = nodes.count
            nodes.append("")
            switch shape {
            case let .leaf(sort):
                let number: Int
                if let prior = sorts.firstIndex(
                where: { C.sameSort($0,sort) }) { number = prior }
                else { number = sorts.count
                    sorts.append(sort) }
                nodes[index] = "{\"sort\":\(number)}"
            case let .pair(l,r):
                let a = walk(l), b = walk(r)
                nodes[index] = "{\"pair\":[\(a),\(b)]}"
            }
            return index
        }
        _ = walk(shape)
        return "[" + nodes.joined(separator: ",") + "]"
    }
    static func edgesText(_ edges: [C.SourceEdge]) -> String {
        let ordered = edges.sorted { a,b in
            a.address.map { $0 == .left ? 0 : 1 }.lexicographicallyPrecedes(b.address.map { $0 == .left ? 0 : 1 })
        }
        return "[" + ordered.map { e in
            "{\"at\":" + RecordContinuation.wire(e.address) + ",\"left\":" + RecordContinuation.wire(e.left)
                + ",\"right\":" + RecordContinuation.wire(e.right) + ",\"basis\":\"declared\"}"
        }.joined(separator: ",") + "]"
    }
    static func familyText(_ members: [C.ActionMember]) -> String {
        "[" + members.map { m in
            "{\"at\":" + RecordContinuation.wire(m.address) + ",\"image\":["
                + m.image.leaves.map { RecordContinuation.wire($0.source) }.joined(separator: ",") + "]}"
        }.joined(separator: ",") + "]"
    }
    static func shape(_ value: RecordJSON.Value, at: String) throws -> C.Shape {
        let nodes = try value.array(at)
        guard !nodes.isEmpty, nodes.count <= 10_000 else { throw C.Failure(at + ": expected a nonempty bounded pair tree") }
        var active: Set<Int> = [], visited: Set<Int> = []
        func walk(_ index: Int, _ here: String, _ depth: Int) throws -> C.Shape {
            guard nodes.indices.contains(index) else { throw C.Failure(here + ": unknown source node") }
            guard !active.contains(index) else { throw C.Failure(here + ": cycle in pair tree") }
            guard depth < 128 else { throw C.Failure(here + ": source depth limit") }
            guard visited.insert(index).inserted else { throw C.Failure(here + ": repeated tree node") }
            active.insert(index)
            defer { active.remove(index) }
            let loc = at + "[\(index)]"
            let node = try nodes[index].object(loc, keys: [], optional: ["pair","sort"])
            guard node.count == 1 else { throw C.Failure(loc + ": expected pair or sort") }
            if let sort = node["sort"] { return try .leaf(String(sort.integer(loc + ".sort"))) }
            let pair = try node["pair"]!.array(loc + ".pair")
            guard pair.count == 2 else { throw C.Failure(loc + ".pair: expected two roles") }
            return try .pair(walk(pair[0].integer(loc + ".pair[0]"),loc + ".pair[0]",depth+1),
                             walk(pair[1].integer(loc + ".pair[1]"),loc + ".pair[1]",depth+1))
        }
        let tree = try walk(0,at + "[0]",0)
        if let unused = nodes.indices.first(
                where: { !visited.contains($0) }) {
            throw C.Failure(at + "[\(unused)]: unreachable source node")
        }
        return tree
    }
    static func leaf(_ value: RecordJSON.Value, whole: C.WholeReading, at: String) throws -> C.Path {
        let p = try RecordContinuation.path(value,at)
        do { _ = try whole.sort(p) } catch { throw C.Failure(at + ": unknown or nonleaf source address") }
        return p
    }
    static func view(_ value: RecordJSON.Value, whole: C.WholeReading, at: String, depth: Int = 0) throws -> C.Places {
        guard depth < 128 else { throw C.Failure(at + ": view depth limit") }
        let node = try value.object(at, keys: [], optional: ["pair","place"])
        guard node.count == 1 else { throw C.Failure(at + ": expected pair or place") }
        if let p = node["place"] { return try .leaf(leaf(p,whole:whole,at:at + ".place")) }
        let children = try node["pair"]!.array(at + ".pair")
        guard children.count == 2 else { throw C.Failure(at + ".pair: expected two roles") }
        return try .pair(view(children[0],whole:whole,at:at + ".pair[0]",depth:depth+1),
                         view(children[1],whole:whole,at:at + ".pair[1]",depth:depth+1))
    }
    static func edges(_ value: RecordJSON.Value, whole: C.WholeReading, at: String) throws -> [C.SourceEdge] {
        var addresses: Set<C.Path> = [], result: [C.SourceEdge] = []
        for (index,value) in try value.array(at).enumerated() {
            let here = at + "[\(index)]"
            let fields = try value.object(here,keys:["at","left","right","basis"])
            guard case .string("declared") = fields["basis"]! else {
                throw C.Failure(here + ".basis: expected declared source premise; observed values are not equality")
            }
            let address = try RecordContinuation.path(fields["at"]!,here + ".at")
            guard addresses.insert(address).inserted else { throw C.Failure(here + ".at: repeated E-edge address") }
            let l = try leaf(fields["left"]!,whole:whole,at:here + ".left")
            let r = try leaf(fields["right"]!,whole:whole,at:here + ".right")
            guard try C.sameSort(whole.sort(l),whole.sort(r)) else { throw C.Failure(here + ": equality endpoints have different sorts") }
            result.append(.init(address:address,left:l,right:r))
        }
        return result
    }
    static func family(_ value: RecordJSON.Value, target: C.Shape, whole: C.WholeReading,
                       at: String, nonempty: Bool) throws -> [C.ActionMember] {
        let values = try value.array(at)
        guard !nonempty || !values.isEmpty else { throw C.Failure(at + ": expected a nonempty hidden family") }
        var prior: C.Path?, result: [C.ActionMember] = []
        let leaves = target.leaves
        for (index,value) in values.enumerated() {
            let here = at + "[\(index)]"
            let fields = try value.object(here,keys:["at","image"])
            let address = try RecordContinuation.path(fields["at"]!,here + ".at")
            if let previous = prior {
                guard previous.map({$0 == .left ? 0 : 1}).lexicographicallyPrecedes(address.map({$0 == .left ? 0 : 1})) else {
                    throw C.Failure(here + ".at: repeated or noncanonical member order")
                }
            }
            prior = address
            let image = try fields["image"]!.array(here + ".image")
            guard image.count == leaves.count else { throw C.Failure(here + ".image: expected one source place per Source leaf") }
            let inputs = try image.enumerated().map { offset,value -> C.Path in
                let loc = here + ".image[\(offset)]"
                let p = try leaf(value,whole:whole,at:loc)
                guard try C.sameSort(whole.sort(p),leaves[offset].1) else { throw C.Failure(loc + ": action image has another sort") }
                return p
            }
            var cursor = 0
            func fill(_ s: C.Shape) -> C.Places {
                switch s {
                case .leaf:
                    defer { cursor += 1 }
                    return .leaf(inputs[cursor])
                case let .pair(l,r): return .pair(fill(l),fill(r))
                }
            }
            result.append(.init(address:address,image:fill(target)))
        }
        return result
    }
}
