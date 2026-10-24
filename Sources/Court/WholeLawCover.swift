import Foundation

// R = join(projections R), for the whole X_E of U3. The input is interpreted
// by ContinuationCourt's Source anchor and RouteProof, including family leaves.
// Graph construction is separate from replay; no payload is inspected.
extension ContinuationCourt {
    struct LocalLink: Codable {
        var domain: Path
        var from: Path
        var to: Path
    }
    struct LocalTree: Codable {
        var root: Path
        var links: [LocalLink]
    }
    struct CoverCountermodel: Codable {
        var block: Int
        // x is 1 on these source occurrences and 0 elsewhere in their sort.
        // Other sorts are singleton. Each domain extends by making this entire
        // E-class 1 iff that domain meets one, and every other class 0.
        var one: [Path]
        var crossing: Path
    }
    enum LawCoverConclusion: Codable {
        case holds([LocalTree])
        case refused(CoverCountermodel)
    }
    struct LawCoverCertificate: Codable {
        var request: String
        var constructor: String
        var source: ReadProof
        var equalities: RouteProof?
        var coverage: RouteProof
        var classes: [PartitionClass]
        var connections: [[EqualityStep]]
        var conclusion: LawCoverConclusion
    }
    struct LawCoverArchive: Codable {
        let format: Int
        let question: String
        let certificate: LawCoverCertificate
    }
    struct LawCoverReading {
        let whole: WholeReading
        let domains: [(address: Path, places: Places)]
    }
    static func lawCoverReading(_ request: String, certificate p: LawCoverCertificate,
                                source: StructuralSource, constructor: String = "Paired") throws -> LawCoverReading {
        guard p.request == request, p.constructor == constructor else {
            throw Failure("certificate: request or constructor substituted")
        }
        let c = try Context(request, source: source, constructor: constructor, requiredFields: ["Source", "Coverage"])
        let whole = try readWhole(p.source, equalities: p.equalities, context: c)
        let family: Domains
        do {
            let result = try replayRouting(p.coverage, context: c, source: whole.source, form: .family)
            guard result.0 == .field(c.root, "Coverage"), case let .family(domains) = result.1 else {
                throw Failure("family endpoint substituted")
            }
            family = domains
        } catch { throw Failure(request + ".Coverage: " + String(describing: error)) }
        try checkWholeAxes(p.source, routes: [p.coverage] + (p.equalities.map { [$0] } ?? []), context: c)
        let all = whole.source.leaves
        let domains = family.leaves
        guard all.count <= 10_000, domains.count <= 10_000,
            domains.reduce(0, { $0 + $1.places.leaves.count }) <= 100_000 else {
            throw Failure(request + ".Coverage: finite input work limit; no obstruction inferred")
        }
        let covered = Set(domains.flatMap { $0.places.leaves.map(\.source) })
        for (path, _) in all
        where !covered.contains(path) {
            throw Failure(pathText(request + ".Source", path) + ": uncovered leaf is outside this coverage question")
        }
        return LawCoverReading(whole: whole, domains: domains)
    }

    /// Only checked partitions, input edges and the presented finite steps are
    /// replayed here. No component constructor or transitive closure is called.
    static func verifyLawCover(_ request: String, certificate p: LawCoverCertificate,
                               source: StructuralSource, constructor: String = "Paired") throws -> Bool {
        let r = try lawCoverReading(request, certificate: p, source: source, constructor: constructor)
        let edges = Dictionary(uniqueKeysWithValues: r.whole.edges.map { ($0.address, $0) })
        let blocks = try verifyPartition(p.classes, whole: r.whole)
        try verifyEForests(p.connections, classes: p.classes, edges: edges, at: "certificate.connections")
        let domains = Dictionary(uniqueKeysWithValues: r.domains.map {
            ($0.address, Set($0.places.leaves.map(\.source)))
        })
        switch p.conclusion {
        case let .holds(trees):
            guard trees.count == p.classes.count else { throw Failure("certificate.holds: incomplete class coverage") }
            for (index, tree) in trees.enumerated() {
                let at = "certificate.holds[\(index)]"
                let members = Set(p.classes[index].leaves)
                guard members.contains(tree.root), tree.links.count == members.count - 1 else {
                    throw Failure(at + ": wrong root or incomplete local tree")
                }
                var connected: Set<Path> = [tree.root]
                for (i, link) in tree.links.enumerated() {
                    let here = at + ".links[\(i)]"
                    guard connected.contains(link.from), members.contains(link.to), !connected.contains(link.to) else {
                        throw Failure(here + ": local link does not attach a new member of this E-class")
                    }
                    guard let domain = domains[link.domain], domain.contains(link.from), domain.contains(link.to) else {
                        throw Failure(here + ": local link is not visible in the declared domain")
                    }
                    connected.insert(link.to)
                }
                guard connected == members else { throw Failure(at + ": local tree misses class members") }
            }
            return true
        case let .refused(model):
            let at = "certificate.refused"
            guard p.classes.indices.contains(model.block) else { throw Failure(at + ".block: no such E-class") }
            let members = Set(p.classes[model.block].leaves)
            let one = Set(model.one)
            guard one.count == model.one.count else { throw Failure(at + ".one: repeated source address") }
            guard one.isSubset(of: members) else { throw Failure(at + ".one: S is not a subset of K") }
            guard !one.isEmpty, one.count < members.count else {
                throw Failure(at + ".one: S must be a nonempty proper subset of K")
            }
            guard let edge = edges[model.crossing] else { throw Failure(at + ".crossing: no declared E-edge at this address") }
            guard blocks[edge.left] == model.block, blocks[edge.right] == model.block,
                one.contains(edge.left) != one.contains(edge.right) else {
                throw Failure(at + ".crossing: E-edge does not cross S within K")
            }
            for domain in r.domains {
                let intersection = domain.places.leaves.map(\.source).filter { members.contains($0) }
                if let first = intersection.first {
                    guard intersection.allSatisfy({ one.contains($0) == one.contains(first) }) else {
                        throw Failure(pathText(at + ".domains", domain.address) + ": domain splits S; witness is not locally admitted")
                    }
                }
            }
            // The crossing proves x notin X_E. Monochromatic intersections give
            // each y^d in X_E with y^d|C_d = x|C_d.
            return false
        }
    }

    static func deriveLawCover(_ request: String, source: StructuralSource,
                               constructor: String = "Paired") throws -> LawCoverCertificate {
        let c = try Context(request, source: source, constructor: constructor, requiredFields: ["Source", "Coverage"])
        func route(_ field: String, form: RouteForm = .cut) throws -> RouteProof {
            do { return try deriveRoute(.field(c.root, field), context: c, form: form) }
            catch { throw Failure(request + "." + field + ": " + String(describing: error)) }
        }
        let sourceProof: ReadProof
        do { sourceProof = try c.derive(.field(c.root, "Source")) }
        catch { throw Failure(request + ".Source: " + String(describing: error)) }
        var p = try LawCoverCertificate(request: request, constructor: constructor, source: sourceProof,
            equalities: source.declarations[request]?.fields["Equalities"] == nil ? nil : route("Equalities"),
            coverage: route("Coverage", form: .family), classes: [], connections: [], conclusion: .holds([]))
        let r = try lawCoverReading(request, certificate: p, source: source, constructor: constructor)
        var adjacent: [Path: [(Path, EqualityStep)]] = [:]
        for edge in r.whole.edges {
            adjacent[edge.left, default: []].append((edge.right, .init(edge: edge.address, reversed: false)))
            adjacent[edge.right, default: []].append((edge.left, .init(edge: edge.address, reversed: true)))
        }
        var blocks: [Path: Int] = [:]
        for (root, sort) in r.whole.source.leaves
        where blocks[root] == nil {
            let index = p.classes.count
            var members = [root], forest: [EqualityStep] = []
            blocks[root] = index
            var cursor = 0
            while cursor < members.count {
                for (next, step) in adjacent[members[cursor]] ?? []
                where blocks[next] == nil {
                    blocks[next] = index
                    members.append(next)
                    forest.append(step)
                }
                cursor += 1
            }
            p.classes.append(.init(sort: sort, leaves: members))
            p.connections.append(forest)
        }
        // Each C_d intersects an exact E-class in a clique. A star has the same
        // components, without a quadratic list of pairs or any payload search.
        var local: [Path: [(next: Path, domain: Path)]] = [:]
        for domain in r.domains {
            var roots: [Int: Path] = [:]
            var seen: Set<Path> = []
            for leaf in domain.places.leaves
            where seen.insert(leaf.source).inserted {
                let block = blocks[leaf.source]!
                if let root = roots[block] {
                    local[root, default: []].append((leaf.source, domain.address))
                    local[leaf.source, default: []].append((root, domain.address))
                } else { roots[block] = leaf.source }
            }
        }
        var trees: [LocalTree] = []
        for (index, block) in p.classes.enumerated() {
            let root = block.leaves[0]
            var reached: Set<Path> = [root], pending = [root]
            var links: [LocalLink] = []
            var cursor = 0
            while cursor < pending.count {
                let here = pending[cursor]
                for link in local[here] ?? []
                where reached.insert(link.next).inserted {
                    pending.append(link.next)
                    links.append(.init(domain: link.domain, from: here, to: link.next))
                }
                cursor += 1
            }
            if reached.count != block.leaves.count {
                guard let crossing = r.whole.edges.first(
                    where: {
                    blocks[$0.left] == index && reached.contains($0.left) != reached.contains($0.right)
                }) else { throw Failure("construction: disconnected E-class has no crossing E-edge") }
                p.conclusion = .refused(.init(block: index, one: block.leaves.filter { reached.contains($0) }, crossing: crossing.address))
                _ = try verifyLawCover(request, certificate: p, source: source, constructor: constructor)
                return p
            }
            trees.append(.init(root: root, links: links))
        }
        p.conclusion = .holds(trees)
        _ = try verifyLawCover(request, certificate: p, source: source, constructor: constructor)
        return p
    }
    static func encodeLawCover(_ proof: LawCoverCertificate) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let data = try encoder.encode(LawCoverArchive(format: 1, question: "whole-law-cover", certificate: proof))
        guard data.count <= 8_000_000 else {
            throw Failure("certificate: output limit; no obstruction inferred")
        }
        return data
    }
    static func decodeLawCover(_ data: Data) throws -> LawCoverCertificate {
        guard data.count <= 8_000_000 else { throw Failure("certificate: archive byte limit") }
        let archive = try JSONDecoder().decode(LawCoverArchive.self, from: data)
        guard archive.format == 1, archive.question == "whole-law-cover" else {
            throw Failure("certificate: unsupported format or different question")
        }
        return archive.certificate
    }
    static func runLawCover(_ arguments: [String], replay: Bool) {
        do {
            var args = arguments
            var output: String?
            var saved: LawCoverCertificate?
            if replay {
                guard !args.isEmpty else { throw Failure("certificate: missing file") }
                saved = try decodeLawCover(Data(contentsOf: URL(fileURLWithPath: args.removeFirst())))
            } else if args.first == "--certificate" {
                args.removeFirst()
                guard !args.isEmpty else { throw Failure("certificate: missing output path") }
                output = args.removeFirst()
            }
            guard args.count >= 2 else {
                throw Failure("usage: judge cover-law [--certificate proof.json] Request sources.swift ...; replay-cover-law proof.json Request sources.swift ...")
            }
            let request = args.removeFirst()
            let source = try StructuralSource(files: args.map { ($0, try String(contentsOfFile: $0, encoding: .utf8)) }, arguments: [("request", request)])
            let proof = try saved ?? deriveLawCover(request, source: source)
            let holds = try verifyLawCover(request, certificate: proof, source: source)
            let bytes = try encodeLawCover(proof)
            if let output { try bytes.write(to: URL(fileURLWithPath: output), options: .atomic) }
            FileHandle.standardOutput.write(bytes + Data("\n".utf8))
            if !holds { exit(1) }
        } catch {
            FileHandle.standardError.write(Data(("Whole-law coverage unresolved: " + String(describing: error) + "\n").utf8))
            exit(2)
        }
    }
}
