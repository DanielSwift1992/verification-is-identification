import Foundation

// ═══════════════════════════════════════════════════════
// TreeSort induces the documentation tree from the type lattice, in Swift.
//
// A faithful port of tree-sort.py. THE BRANCHING LAW (Law.swift §1+§T, lifted to
// the node, guaranteed by §6): a node's place is the MOVE it makes, read off the
// types, not assigned by hand.
//   opens an associatedtype, axis-only lineage  -> AXIS    (the spine)
//   touches exactly one sub-axis                 -> THEOREM (hangs on that axis)
//   touches >= 2 sub-axes (intersect)            -> BRIDGE  (the web)
//   Pair/Σ-rooted, no sub-axis                   -> MARKER | KERNEL
//   one act and its fixpoint                      -> SEED
//
//   LANDING (VerificationIsIdentification.md ## Topics) = the SPINE (seed, markers, kernel, the axes
//     and their private theorems, the generators, the floor, the projection,
//     witnesses). EACH PAPER PAGE (Papers/*.md ## Topics) = a ROUTE: the WEB
//     bridges it proves. Σ (HasSigma) is the trunk, excluded from intersect counts.
//
// Reads the compiler's own symbol graph (swift package dump-symbol-graph): the
// type lattice describing itself. No Python, no SwiftSyntax, just the JSON the
// compiler emits. Replaces tree-sort.py.
//
// Usage: TreeSort <VerificationIsIdentification.symbols.json> <VerificationIsIdentification.docc dir> [audit|emit|check|write]
// ═══════════════════════════════════════════════════════

// ── symbol graph model (only the fields tree-sort reads) ──
struct Graph: Decodable {
    let symbols: [Symbol]
    let relationships: [Relationship]
}
struct Symbol: Decodable {
    struct Identifier: Decodable { let precise: String }
    struct Names: Decodable { let title: String }
    struct Kind: Decodable { let identifier: String }
    struct Fragment: Decodable {
        let kind: String
        let spelling: String
        let preciseIdentifier: String?
    }
    struct Location: Decodable {
        struct Position: Decodable { let line: Int }
        let uri: String?
        let position: Position?
    }
    let identifier: Identifier
    let names: Names
    let kind: Kind
    let declarationFragments: [Fragment]?
    let location: Location?
}
struct Relationship: Decodable {
    let kind: String
    let source: String
    let target: String
}

enum TreeSortTool {
static func run(_ args: [String]) {
guard args.count >= 2 else {
    FileHandle.standardError.write(Data("usage: TreeSort <symbols.json> <docc-dir> [mode]\n".utf8))
    exit(2)
}
let graphPath = args[0]
let docc = args[1]
let mode = args.count >= 3 ? args[2].replacingOccurrences(of: "--", with: "") : "audit"

guard let data = FileManager.default.contents(atPath: graphPath),
      let G = try? JSONDecoder().decode(Graph.self, from: data) else {
    FileHandle.standardError.write(Data("✗ cannot read symbol graph: \(graphPath)\n".utf8))
    exit(2)
}

// ── indexed tables (index = order in G.symbols, to emulate Python's stable sort) ──
var sym: [String: Symbol] = [:]
var index: [String: Int] = [:]
for (i, s) in G.symbols.enumerated() {
    sym[s.identifier.precise] = s
    index[s.identifier.precise] = i
}
func title(_ p: String) -> String { sym[p]!.names.title }
func kind(_ p: String) -> String { sym[p]!.kind.identifier }
var pidOf: [String: String] = [:]
for s in G.symbols { pidOf[s.names.title] = s.identifier.precise }
func line(_ p: String) -> Int { sym[p]?.location?.position?.line ?? Int.max }
func file(_ p: String) -> String {
    guard let uri = sym[p]?.location?.uri else { return "" }
    return (uri as NSString).lastPathComponent
}
func frags(_ p: String) -> [Symbol.Fragment] { sym[p]?.declarationFragments ?? [] }

let protos = G.symbols.filter { $0.kind.identifier == "swift.protocol" }.map { $0.identifier.precise }
let SEED = Set(protos.filter { title($0) == "Pair" || title($0) == "Null" })

// opens an axis: target of a requirementOf edge from an associatedtype
let opens = Set(G.relationships
    .filter { $0.kind == "requirementOf" && kind($0.source) == "swift.associatedtype" }
    .map { $0.target })

// direct parents: typeIdentifiers before the first `where`
func parents(_ p: String) -> [String] {
    var out: [String] = []
    for f in frags(p) {
        if f.kind == "keyword" && f.spelling == "where" { break }
        if f.kind == "typeIdentifier", let pid = f.preciseIdentifier, sym[pid] != nil { out.append(pid) }
    }
    return out
}
var par: [String: [String]] = [:]
for p in protos { par[p] = parents(p) }

// axes: declares an associatedtype, lineage axis-only (rooted, not seed)
var axis = Set<String>()
var changed = true
while changed {
    changed = false
    for p in protos
    where !axis.contains(p) && !SEED.contains(p) && opens.contains(p) {
        if par[p]!.isEmpty || par[p]!.allSatisfy({ axis.contains($0) }) {
            axis.insert(p)
            changed = true
        }
    }
}

var ancCache: [String: Set<String>] = [:]
func anc(_ p: String) -> Set<String> {
    if let c = ancCache[p] { return c }
    var out = Set<String>()
    for q in par[p] ?? [] {
        out.insert(q)
        out.formUnion(anc(q))
    }
    ancCache[p] = out
    return out
}
let ROOT = pidOf["HasSigma"]!
func realClosure(_ p: String) -> Set<String> { anc(p).filter { axis.contains($0) }.subtracting([ROOT]) }

var depthCache: [String: Int] = [:]
func depth(_ p: String) -> Int {
    if let d = depthCache[p] { return d }
    let d = (par[p] ?? []).isEmpty ? 0 : 1 + (par[p]!.map { depth($0) }.max() ?? 0)
    depthCache[p] = d
    return d
}

// markers: a type used as a constraint (where-clause, or inline associatedtype pin)
var constraint = Set<String>()
for s in G.symbols {
    var seen = false
    for f in s.declarationFragments ?? [] {
        if f.kind == "keyword" && f.spelling == "where" { seen = true }
        if s.kind.identifier == "swift.associatedtype" && f.kind == "text" && f.spelling.contains(":") { seen = true }
        if seen && f.kind == "typeIdentifier", let pid = f.preciseIdentifier { constraint.insert(pid) }
    }
}

func classify(_ p: String) -> String {
    if SEED.contains(p) { return "seed" }
    if axis.contains(p) { return "axis" }
    let n = realClosure(p).count
    if n >= 2 { return "bridge" }
    if n == 1 { return "theorem" }
    return constraint.contains(p) ? "marker" : "kernel"
}
var cls: [String: String] = [:]
for p in protos { cls[p] = classify(p) }

var theoremsOn: [String: [String]] = [:]
for a in axis { theoremsOn[a] = [] }
for p in protos
where cls[p] == "theorem" { theoremsOn[realClosure(p).first!]!.append(p) }

// file -> paper doc page (the route). Foundation files (Primitive/Core/Identification)
// map to verification_is_identification; Witness/Law have no paper; Spec/Projection live on the landing.
let PAPER: [String: String] = [
    "Primitive.swift": "verification_is_identification", "Core.swift": "verification_is_identification",
    "Identification.swift": "verification_is_identification", "Intelligence.swift": "intelligence_is_inevitable",
    "Matter.swift": "permanence_is_resistance", "Space.swift": "difference_is_distance",
    "Interference.swift": "interference_is_intelligence",
    "Gradient.swift": "distance_is_cost", "Map.swift": "navigation_is_geometry",
    "Strategy.swift": "order_is_object", "Dynamics.swift": "law_is_target",
    "Play.swift": "play_is_proof", "Basis.swift": "basis_is_residue",
    "Search.swift": "gradient_is_alignment", "Generation.swift": "proposal_is_order",
    "Liquid.swift": "learning_is_liquid", "Reading.swift": "reading_is_order",
    "Path.swift": "program_is_path",
    "Projection.swift": "architecture_of_learning_machines",
]
let FLOOR_FILES: Set<String> = ["Spec.swift"]        // -> landing "The floor"
let PROJ_FILES: Set<String> = ["Projection.swift"]   // -> landing "Projection"

func names(_ ps: [String]) -> [String] { ps.map { title($0) } }
// One symbol per bullet, in code voice: the items a `Bullets` block lists.
func symbols(_ ns: [String]) -> [String] { ns.map { "``\($0)``" } }
// stable sort by depth (ties keep symbol-graph order, like Python's sorted)
func byDepth(_ ps: [String]) -> [String] { ps.sorted { (depth($0), index[$0]!) < (depth($1), index[$1]!) } }

// A group is a level-3 heading over a bulleted list, plain markdown.
func group(_ heading: String, _ items: [String]) -> String {
    "### \(heading)\n\n" + items.map { "- \($0)" }.joined(separator: "\n") + "\n"
}

// ── the landing (spine) ──
func landingTopics(_ trailheads: [String]) -> String {
    var topics = "## Topics\n\n"
    topics += group("Why it exists", ["<doc:Purpose>"])
    topics += group("Encode your own", ["<doc:Encoding>"])
    topics += group("How these pages read", ["<doc:Reading>"])
    topics += group("Start here", symbols(trailheads))
    topics += group("The seed: one act and its fixpoint", symbols(names(SEED.sorted { title($0) < title($1) })))
    topics += group("The medium: markers, the functions on Pair",
                    symbols(names(byDepth(protos.filter { cls[$0] == "marker" }))))
    topics += group("The kernel: the V=I core (Pair / Σ-rooted)",
                    symbols(names(byDepth(protos.filter { cls[$0] == "kernel" }))))
    for (aname, role) in [("HasSolutions", "Identification"), ("HasCache", "The cache"),
                          ("HasDistance", "The metric"), ("HasEncoding", "The lens")] {
        let a = pidOf[aname]!
        let members = [aname] + names(byDepth(theoremsOn[a] ?? []))
        topics += group("\(role): the \(aname) axis", symbols(members))
    }
    let gen = axis.filter { (theoremsOn[$0] ?? []).isEmpty }
        .sorted { ($0 == ROOT ? 0 : 1, title($0)) < ($1 == ROOT ? 0 : 1, title($1)) }
    topics += group("The axes: pure generators", symbols(names(gen)))
    let floor = byDepth(protos.filter { FLOOR_FILES.contains(file($0)) })
    topics += group("The floor: what it delegates, where it stops", symbols(names(floor)))
    let proj = byDepth(protos.filter { PROJ_FILES.contains(file($0)) })
    topics += group("Projection: the framework instantiated on machines", symbols(names(proj)))
    topics += group("The papers: the routes", ["<doc:Sources>"])
    return topics
}

// ── per-paper web routes ──
func paperTopics() -> [String: String] {
    var by: [String: [String]] = [:]
    for p in protos
    where cls[p] == "bridge" {
        if let doc = PAPER[file(p)] { by[doc, default: []].append(p) }
    }
    var out: [String: String] = [:]
    for (doc, ps) in by {
        let ordered = ps.sorted { line($0) < line($1) }
        out[doc] = "## Topics\n\n" + group("Theorems this paper proves", symbols(names(ordered)))
    }
    return out
}

let orphan = protos.filter { cls[$0] == "bridge" && PAPER[file($0)] == nil
    && !FLOOR_FILES.contains(file($0)) && !PROJ_FILES.contains(file($0)) }.map { title($0) }

// ── read current curation (trailheads + witnesses are preserved manual) ──
func parseGroups(_ md: String) -> [String: [String]] {
    var groups: [String: [String]] = [:]
    var cur: String?
    let body = md.components(separatedBy: "## Topics").last ?? md
    let headRe = try! NSRegularExpression(pattern: #"^###\s+(.*)"#)
    let bulRe = try! NSRegularExpression(pattern: #"^-\s+``([A-Za-z0-9_]+)``"#)
    for raw in body.components(separatedBy: "\n") {
        let ns = raw as NSString
        if let m = headRe.firstMatch(in: raw, range: NSRange(location: 0, length: ns.length)) {
            cur = ns.substring(with: m.range(at: 1)).trimmingCharacters(in: .whitespaces)
            groups[cur!] = []
        } else if let cur, let m = bulRe.firstMatch(in: raw, range: NSRange(location: 0, length: ns.length)) {
            groups[cur, default: []].append(ns.substring(with: m.range(at: 1)))
        }
    }
    return groups
}

let theoryMD = (docc as NSString).appendingPathComponent("VerificationIsIdentification.md")
let curGroups = parseGroups((try? String(contentsOfFile: theoryMD, encoding: .utf8)) ?? "")
let trailheads = curGroups["Start here"] ?? ["PassIsIdentification", "SystemCrystallizes", "Matter", "PlayIsProof"]

let LAND = landingTopics(trailheads)
let PAPERS = paperTopics()

// ── apply / emit / check / audit ──
func target(_ path: String, _ block: String) -> String {
    let txt = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
    let head: String
    if let r = txt.range(of: "\n## Topics", options: .backwards) {
        head = String(txt[txt.startIndex..<r.lowerBound])
    } else { head = txt }
    let trimmedHead = head.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedHead.isEmpty {
        FileHandle.standardError.write(Data("refusing to write empty-prose file: \(path)\n".utf8))
        exit(2)
    }
    return trimmedHead + "\n\n" + block.trimmingCharacters(in: .whitespacesAndNewlines) + "\n"
}
func eachFile() -> [(String, String)] {
    var out = [(theoryMD, LAND)]
    for (doc, block) in PAPERS { out.append(((docc as NSString).appendingPathComponent("Papers/\(doc).md"), block)) }
    return out
}

switch mode {
case "write":
    for (path, block) in eachFile() {
        let new = target(path, block)
        try? new.write(toFile: path, atomically: true, encoding: .utf8)
    }
    print("wrote landing + \(PAPERS.count) paper routes." + (orphan.isEmpty ? "  (no orphans)" : "  ORPHANS: \(orphan)"))

case "check":
    let drift = eachFile().filter { (path, block) in
        ((try? String(contentsOfFile: path, encoding: .utf8)) ?? "") != target(path, block)
    }.map { ($0.0 as NSString).lastPathComponent }
    if !drift.isEmpty || !orphan.isEmpty {
        print("✗ Topics DRIFT from the type lattice:", drift, orphan.isEmpty ? "" : "ORPHANS: \(orphan)")
        exit(1)
    }
    print("✓ Topics in sync with the type lattice (spine + routes induced, no orphans).")

case "emit":
    print("════════ LANDING (VerificationIsIdentification.md) ════════\n")
    print(LAND)
    for (doc, block) in PAPERS.sorted(by: { $0.key < $1.key }) {
        print("\n════════ Papers/\(doc).md ════════\n")
        print(block)
    }
    print("orphan web bridges:", orphan.isEmpty ? "NONE" : "\(orphan)")

default: // audit
    var counts: [String: Int] = [:]
    for p in protos { counts[cls[p]!, default: 0] += 1 }
    print("CLASSIFICATION:", counts, "| total", protos.count)
    print("PER-PAPER ROUTE SIZES:")
    for (doc, block) in PAPERS.sorted(by: { $0.key < $1.key }) {
        print("  \(doc): \(block.components(separatedBy: "- ``").count - 1) bridges")
    }
    print("orphan web bridges:", orphan.isEmpty ? "NONE" : "\(orphan)")
}
    }
}
