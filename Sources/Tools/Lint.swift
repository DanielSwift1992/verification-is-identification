import Foundation

// ═══════════════════════════════════════════════════════
// LawLint names the lattice's build-time self-check, in Swift.
//
// Interim (DESIGN17 §5): the grammar mirror (`Tools grammar`) now enforces §0′ per file, per
// scope, more precisely than this tool's regexes ever did, but §1 RENAME, §2 OPEN AXIS, and
// PROVENANCE are cross-file/whole-module checks the mirror's per-file design has no way to
// express yet, so this tool stays alive to cover them
// (`swift run Tools lint <dir>… [--strict] [--docc <path>]`). The LawCheck plugin runs it on
// every build: `--strict` on the library targets (Organization, DocumentKit), where a
// violation refuses the build, and report mode on VectorDemo, whose drivers are the
// sanctioned value edge (the plugin header argues the split).
//
//   THE LAW (Sources/VerificationIsIdentification/Law.swift), the checkable subset:
//     §0′ PURE TYPES : no runtime, no values, types only.        (per line)
//     §1  NO RENAME  : no single-parent, empty-body protocol.     (per line)
//     §2  OPEN AXIS  : every axis opened by expand is closed by    (whole module)
//                      compress somewhere, Σ alone stays free.
//
//   PROVENANCE (the [Tag] addresses in /// comments), porting provenance.py:
//     every trailing [Tag] resolves to a paper in the Sources.md legend, and
//     every paper in the legend is connected, routed (carries a Topics route),
//     cited (a tag points to it), or below the floor (EiF, the ground).
//
// A line that IS the exception, not a lazy rename, argued in a comment on the same line,
// carries the marker `law:allow` there. It is not a rubber stamp: it is a claim, in the code,
// that the reviewer can see and dispute, the same way a `where` clause is a claim the compiler
// checks. Used for the canon's own irreducible primitives (`Close: Structure {}`, the seal
// half of Open/Close, not a rename of Structure), not for the ordinary case.
//
// The .docc catalog is prose (it may quote forbidden forms); only the legend and
// the per-paper Topics footers are read, never scanned for law violations.
// This is "the compiler IS the verifier" turned on the law and its addresses; it
// replaces both lint-law.sh and provenance.py. §4 (the floor) and §5 (nothing
// floats), and the Topics-tree induction (tree-sort), need the symbol graph and
// live in the TreeSort command plugin. [Law; provenance.py]
// ═══════════════════════════════════════════════════════

let allowMarker = "law:allow"
let stringFence = "\"\"\""

struct Violation {
    let file: String
    let line: Int
    let rule: String
    let detail: String
}

// ── THE LAW ──
let purityRegex = try! NSRegularExpression(
    pattern: #"\b(func|var|let|init|subscript|deinit|operator)\b"#)
let renameRegex = try! NSRegularExpression(
    pattern: #"^\s*(?:public\s+)?protocol\s+([A-Za-z_]\w*)\s*:\s*([A-Za-z_]\w*)\s*\{\s*\}\s*$"#)
// §1 tells a SYNONYM from a CATEGORY GATE by duty: an empty refinement whose name is consumed
// as a constraint (right of `:` in an associatedtype pin, a `where` clause, or a generic
// parameter list) is a gate: its content is its conformance set, and the constraint is where
// that content is read (`Fg: LegibleOnSurfaceCard`, `EnforcedBy.Rank: CanAdmin`). A rename
// that only ever renames carries no such duty anywhere, and stays caught.
let constraintUseRegex = try! NSRegularExpression(
    pattern: #":\s*([A-Za-z_][\w.]*)"#)
let bareBoundLineRegex = try! NSRegularExpression(
    pattern: #"^\s*[A-Za-z_]\w*\s*:\s*[A-Za-z_][\w.]*(\s*&\s*[A-Za-z_][\w.]*)*\s*[,>]?\s*$"#)
// `Open` and `Close` are the lattice's two irreducible modes (Primitive.swift), not ordinary
// domain protocols: naming a category under one of them (`Secret: Open {}`, so a concrete enum
// not have to write `enum X: Open` directly, its own §2) is the sanctioned move the whole
// codebase uses, not a rename of Open/Close into a pointless synonym. Renaming an ORDINARY
// protocol this way (`CanEdit: CanView {}`) is still caught, the exemption is narrow, keyed to
// these two names specifically.
let primitiveModes: Set<String> = ["Open", "Close"]
// The one §0′ exemption that is not file-scoped: every `Structure` conformer supplies one or
// more of its four witnesses (`typeName`, `count`, `labels`, `body`) as a `static var`, in
// whichever file it lives in. Each is the generator primitive itself: a pure function of the
// type it is declared on, read by the type checker, not a stored value, not a runtime
// property, however it reads syntactically to the purity regex.
// `spelled` joined the witness set with the login walk (Login.swift): the grammar's own
// lexicon already carries it as a WitnessName (SpelledWord), and the two lists must agree.
let witnessDeclarationRegex = try! NSRegularExpression(
    pattern: #"\bstatic\s+(var|let)\s+(typeName|count|labels|body|spelled)\b"#)
// The layout era added a second witness FORM: `Spanning`/`Divides`/`DividesY` read a leaf
// through `static func rendered<…>`, a `typeName` with type holes (Vector.swift names the wall:
// a static requirement cannot take a type parameter, so a generic func is the only spelling
// the medium allows). Same generator primitive, same exemption.
let renderedWitnessRegex = try! NSRegularExpression(
    pattern: #"\bstatic\s+func\s+rendered\s*<"#)
// The `{ }` door: a combinator's `init(@StructureBuilder …) { fatalError() }` shell is a
// type-level door the checker walks and no program runs (the landing's own law text names the
// idiom). Admitted whole, as spelled. An `init` that builds anything falls back under §0′.
let builderDoorRegex = try! NSRegularExpression(
    pattern: #"\binit\s*\(@StructureBuilder.*\{\s*fatalError\(\)\s*\}\s*$"#)
// The metatype door, §S17's other spelling: a Type-cased free function (`Tally`, `Link`) that
// hands back `Something.self` so a builder can read it. The codebase's own naming law is the
// key: a door is Type-cased because it NAMES a combinator, and value code is lowercase,
// staying under §0′.
let metatypeDoorRegex = try! NSRegularExpression(
    pattern: #"\bfunc\s+[A-Z]"#)
let bareAxisRegex = try! NSRegularExpression(
    pattern: #"^\s*associatedtype\s+([A-Za-z_]\w*)\s*$"#)
let pinnedAxisRegex = try! NSRegularExpression(
    pattern: #"^\s*associatedtype\s+([A-Za-z_]\w*)\s*:"#)
let constraintSubjectRegex = try! NSRegularExpression(
    pattern: #"([A-Za-z_]\w*)(?:\.[A-Za-z_]\w*)*\s*(?:==|:)"#)
let constraintObjectRegex = try! NSRegularExpression(
    pattern: #"==\s*([A-Za-z_]\w*)"#)
let freeAxes: Set<String> = ["Sigma"]   // Σ, the carrier root (Law §2, §5)

// ── PROVENANCE ──
// a legend row: | `Tag` · `Tag2` | [Title](doc:paper) |
let legendRegex = try! NSRegularExpression(
    pattern: #"^\|\s*(.+?)\s*\|\s*\[[^\]]+\]\(doc:([^)]+)\)"#)
let backtickRegex = try! NSRegularExpression(pattern: #"`([^`]+)`"#)
// a provenance tag: the trailing bracket of a /// line (math like E[τ] is mid-line)
let trailingTagRegex = try! NSRegularExpression(pattern: #"(?:^|\s)\[([^\]]+)\]$"#)
let belowFloor: Set<String> = ["EiF"]   // the ground, argued below the protocol floor

func matches(_ regex: NSRegularExpression, _ text: String) -> Bool {
    regex.firstMatch(in: text, range: NSRange(location: 0, length: (text as NSString).length)) != nil
}
func captures(_ regex: NSRegularExpression, _ text: String, group: Int = 1) -> [String] {
    let ns = text as NSString
    return regex.matches(in: text, range: NSRange(location: 0, length: ns.length)).compactMap {
        let range = $0.range(at: group)
        return range.location == NSNotFound ? nil : ns.substring(with: range)
    }
}
func firstCapture(_ regex: NSRegularExpression, _ text: String, group: Int) -> String? {
    let ns = text as NSString
    guard let m = regex.firstMatch(in: text, range: NSRange(location: 0, length: ns.length)) else { return nil }
    let r = m.range(at: group)
    return r.location == NSNotFound ? nil : ns.substring(with: r)
}
// §0′ reads code, never comments: strip from the first `//` to end of line.
func code(of line: String) -> String {
    guard let marker = line.range(of: "//") else { return line }
    return String(line[line.startIndex..<marker.lowerBound])
}
// §0′ reads code, never a single-line literal's content either: "rank everyone and let the
// bottom share go" carries `let` the way prose does, not the way a binding does.
func stripQuoted(_ line: String) -> String {
    var out = ""
    var inside = false
    for character in line {
        if character == "\"" {
            inside.toggle()
            continue
        }
        if !inside { out.append(character) }
    }
    return out
}
func braceBalance(_ line: String) -> Int {
    line.reduce(0) { $0 + ($1 == "{" ? 1 : $1 == "}" ? -1 : 0) }
}

struct OpenedAxis {
    let name: String
    let file: String
    let line: Int
}

var lineViolations: [Violation] = []
var renameCandidates: [(name: String, violation: Violation)] = []
var consumedAsConstraint: Set<String> = []
var openedAxes: [OpenedAxis] = []
var closedAxes: Set<String> = []
// provenance bookkeeping, filled while scanning the same source lines
var citedPapers: [String: Int] = [:]
var danglingTags: [Violation] = []
var legendTags: Set<String> = []
var tagToPaper: [String: String] = [:]
var paperTags: [String: [String]] = [:]

func loadLegend(_ sourcesMD: String) {
    guard let contents = try? String(contentsOfFile: sourcesMD, encoding: .utf8) else { return }
    for raw in contents.components(separatedBy: "\n") {
        guard let cell = firstCapture(legendRegex, raw, group: 1),
              let paper = firstCapture(legendRegex, raw, group: 2) else { continue }
        let tags = captures(backtickRegex, cell)
        guard !tags.isEmpty else { continue }
        paperTags[paper] = tags
        for t in tags {
            tagToPaper[t] = paper
            legendTags.insert(t)
        }
    }
}

func scan(file path: String, checkProvenance: Bool) {
    let name = (path as NSString).lastPathComponent
    guard let contents = try? String(contentsOfFile: path, encoding: .utf8) else {
        lineViolations.append(Violation(file: name, line: 0, rule: "IO", detail: "cannot read file"))
        return
    }
    // The generator primitive: `Structure`'s `body` is the build-time generator (§0′ / Canon §3),
    // not shipped runtime, so its `var`/`some` are admitted, the one §0′ exemption, like .docc prose.
    let generatorPrimitive = name == "Primitive.swift" || name == "Construction.swift"

    // §0′ reads code, never a string literal's content: a multiline literal's lines are data
    // the type carries (a CSS rule, a prose paragraph that quotes `init`), however they read
    // to the purity regex. Tracked by the `"""` fence, toggled per line.
    var insideStringLiteral = false
    // The witness exemption covers the BODY, not just the head: a multi-line `typeName` (or
    // `rendered`) is still one pure function of the type, and its internal bindings are that
    // function's spelling, not shipped runtime. Tracked by brace balance from the head line.
    var witnessDepth = 0
    // A `rendered<…>` head opens its `{` lines later, after the generic signature closes; the
    // signature rides with the head.
    var witnessSignature = false

    for (index, raw) in contents.components(separatedBy: "\n").enumerated() {
        let number = index + 1
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        var source = code(of: raw)
        if insideStringLiteral {
            if raw.contains(stringFence) { insideStringLiteral = false }
            continue
        }
        if let fence = source.range(of: stringFence) {
            let fences = source.components(separatedBy: stringFence).count - 1
            if fences % 2 == 1 { insideStringLiteral = true }
            source = String(source[source.startIndex..<fence.lowerBound])
        }
        let bare = stripQuoted(source)
        if witnessDepth > 0 {
            witnessDepth += braceBalance(bare)
            continue
        }
        if witnessSignature {
            if bare.contains("{") {
                witnessSignature = false
                witnessDepth = max(braceBalance(bare), 0)
            }
            continue
        }
        if matches(witnessDeclarationRegex, source) || matches(renderedWitnessRegex, source) {
            if bare.contains("{") {
                witnessDepth = max(braceBalance(bare), 0)
            } else {
                witnessSignature = true
            }
        }

        if !generatorPrimitive,
           !matches(witnessDeclarationRegex, source),
           !matches(renderedWitnessRegex, source),
           !matches(builderDoorRegex, source),
           !matches(metatypeDoorRegex, source),
           matches(purityRegex, bare) {
            lineViolations.append(Violation(file: name, line: number, rule: "§0′ PURE TYPES", detail: trimmed))
        }
        // Matched against the comment-stripped line: a trailing `// law:allow` comment must not
        // hide a bare rename by occupying the end-of-line the regex anchors on.
        if let declared = firstCapture(renameRegex, source, group: 1),
           let parent = firstCapture(renameRegex, source, group: 2),
           !primitiveModes.contains(parent), !raw.contains(allowMarker) {
            renameCandidates.append((name: declared,
                violation: Violation(file: name, line: number, rule: "§1 RENAME", detail: trimmed)))
        }
        // Constraint positions: an associatedtype pin, a `where` clause, a generic parameter
        // list, including one spread across lines, where a `X: Bound,` line stands alone. A
        // plain conformance (`enum Ink: Paint`) is NOT consumption: conforming to a name is
        // what a synonym invites too; gate duty means someone DEMANDS the name of a hole.
        if source.contains("associatedtype") || source.contains("where ") || source.contains("<")
            || matches(bareBoundLineRegex, bare) {
            for used in captures(constraintUseRegex, bare) {
                consumedAsConstraint.insert(String(used.split(separator: ".").last ?? ""))
            }
        }
        if let axis = captures(bareAxisRegex, source).first {
            openedAxes.append(OpenedAxis(name: axis, file: name, line: number))
        }
        if let axis = captures(pinnedAxisRegex, source).first {
            closedAxes.insert(axis)
        }
        if let whereRange = source.range(of: "where ") {
            let clause = String(source[whereRange.upperBound...])
            captures(constraintSubjectRegex, clause).forEach { closedAxes.insert($0) }
            captures(constraintObjectRegex, clause).forEach { closedAxes.insert($0) }
        }

        // provenance: a /// line ending in [Tag]
        if checkProvenance, trimmed.hasPrefix("///") {
            let body = String(trimmed.dropFirst(3)).trimmingCharacters(in: .whitespaces)
            if let tag = firstCapture(trailingTagRegex, body, group: 1) {
                let first = tag.split(whereSeparator: { " ,;".contains($0) }).first.map(String.init) ?? tag
                if let paper = tagToPaper[first] {
                    citedPapers[paper, default: 0] += 1
                } else {
                    danglingTags.append(Violation(file: name, line: number, rule: "PROVENANCE — dangling tag", detail: "[\(tag)]"))
                }
            }
        }
    }
}

func disconnectedPapers(routedPaperDir: String) -> [Violation] {
    let fm = FileManager.default
    var routed: Set<String> = []
    if let entries = try? fm.contentsOfDirectory(atPath: routedPaperDir) {
        for entry in entries
        where entry.hasSuffix(".md") {
            let path = (routedPaperDir as NSString).appendingPathComponent(entry)
            if let body = try? String(contentsOfFile: path, encoding: .utf8),
               body.contains("### Theorems this paper proves") {
                routed.insert(String(entry.dropLast(3)))   // drop ".md"
            }
        }
    }
    var out: [Violation] = []
    for paper in Set(tagToPaper.values).sorted() {
        let isRouted = routed.contains(paper)
        let isCited = (citedPapers[paper] ?? 0) > 0
        let isBelowFloor = !(Set(paperTags[paper] ?? []).isDisjoint(with: belowFloor))
        if !(isRouted || isCited || isBelowFloor) {
            out.append(Violation(file: "Sources.md", line: 0, rule: "PROVENANCE — disconnected paper",
                                 detail: "\(paper) — in legend, no route and not cited"))
        }
    }
    return out
}

// ── arguments: .swift files, `--stamp PATH`, `--docc DIR`, `--strict` ──
func collect(_ arguments: [String]) -> (files: [String], stamp: String?, docc: String?, strict: Bool) {
    let fm = FileManager.default
    var files: [String] = []
    var stamp: String?
    var docc: String?
    var strict = false
    var iterator = arguments.makeIterator()
    while let argument = iterator.next() {
        switch argument {
        case "--stamp": stamp = iterator.next()
        case "--docc": docc = iterator.next()
        case "--strict": strict = true
        default:
            var isDirectory: ObjCBool = false
            if fm.fileExists(atPath: argument, isDirectory: &isDirectory), isDirectory.boolValue {
                let entries = (try? fm.contentsOfDirectory(atPath: argument)) ?? []
                for entry in entries
                where entry.hasSuffix(".swift") {
                    files.append((argument as NSString).appendingPathComponent(entry))
                }
            } else if argument.hasSuffix(".swift") {
                files.append(argument)
            }
        }
    }
    return (files.sorted(), stamp, docc, strict)
}

enum Lint {
static func run(_ args: [String]) {
let (files, stamp, docc, strict) = collect(args)
let runProvenance = docc != nil
if let docc { loadLegend((docc as NSString).appendingPathComponent("Sources.md")) }
files.forEach { scan(file: $0, checkProvenance: runProvenance) }

let axisViolations = openedAxes
    .filter { !closedAxes.contains($0.name) && !freeAxes.contains($0.name) }
    .map { Violation(file: $0.file, line: $0.line, rule: "§2 OPEN AXIS",
                     detail: "associatedtype \($0.name) — opened (expand), never closed (compress) anywhere") }

var provenanceViolations: [Violation] = []
if let docc {
    provenanceViolations = danglingTags
        + disconnectedPapers(routedPaperDir: (docc as NSString).appendingPathComponent("Papers"))
}

let renameViolations = renameCandidates
    .filter { !consumedAsConstraint.contains($0.name) }
    .map(\.violation)

let violations = lineViolations + renameViolations + axisViolations + provenanceViolations

// the sentinel lets the build graph skip the check when nothing changed
if let stamp { try? Data().write(to: URL(fileURLWithPath: stamp)) }

if violations.isEmpty {
    let prov = runProvenance ? ", \(legendTags.count) tags resolve, every paper connected" : ""
    print("✓ THE LAW holds: pure types (§0′), no renames (§1), every axis closed (§2)\(prov). \(files.count) files.")
    exit(0)
}

var report = "\(strict ? "✗" : "△") THE LAW / PROVENANCE violated:\n"
for violation in violations {
    report += "    \(violation.file):\(violation.line)  \(violation.rule) — \(violation.detail)\n"
}

// `--strict` refuses the build outright; without it, this prints the same report, a migration
// list, and exits clean regardless of what it found.
if strict {
    FileHandle.standardError.write(Data(report.utf8))
    exit(1)
}
print(report)
exit(0)
}
}
