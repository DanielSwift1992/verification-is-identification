import Foundation

// ═══════════════════════════════════════════════════════
// LawLint — the lattice's build-time self-check, in Swift.
//
// Run by the LawCheck plugin on every build of the VerificationIsIdentification target. Two layers,
// both enforced by a non-zero exit (so a violation makes the build refuse):
//
//   THE LAW (Sources/VerificationIsIdentification/Law.swift), the checkable subset:
//     §0′ PURE TYPES : no runtime, no values — types only.        (per line)
//     §1  NO RENAME  : no single-parent, empty-body protocol.     (per line)
//     §2  OPEN AXIS  : every axis opened by expand is closed by    (whole module)
//                      compress somewhere — Σ alone stays free.
//
//   PROVENANCE (the [Tag] addresses in /// comments), porting provenance.py:
//     every trailing [Tag] resolves to a paper in the Sources.md legend, and
//     every paper in the legend is connected — routed (carries a Topics route),
//     cited (a tag points to it), or below the floor (EiF, the ground).
//
// The .docc catalog is prose (it may quote forbidden forms); only the legend and
// the per-paper Topics footers are read, never scanned for law violations.
// This is "the compiler IS the verifier" turned on the law and its addresses; it
// replaces both lint-law.sh and provenance.py. §4 (the floor) and §5 (nothing
// floats), and the Topics-tree induction (tree-sort), need the symbol graph and
// live in the TreeSort command plugin. [Law; provenance.py]
// ═══════════════════════════════════════════════════════

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
    pattern: #"^\s*(public\s+)?protocol\s+[A-Za-z_]\w*\s*:\s*[A-Za-z_]\w*\s*\{\s*\}\s*$"#)
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

struct OpenedAxis { let name: String; let file: String; let line: Int }

var lineViolations: [Violation] = []
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
        for t in tags { tagToPaper[t] = paper; legendTags.insert(t) }
    }
}

func scan(file path: String, checkProvenance: Bool) {
    let name = (path as NSString).lastPathComponent
    guard let contents = try? String(contentsOfFile: path, encoding: .utf8) else {
        lineViolations.append(Violation(file: name, line: 0, rule: "IO", detail: "cannot read file"))
        return
    }
    for (index, raw) in contents.components(separatedBy: "\n").enumerated() {
        let number = index + 1
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        let source = code(of: raw)

        if matches(purityRegex, source) {
            lineViolations.append(Violation(file: name, line: number, rule: "§0′ PURE TYPES", detail: trimmed))
        }
        if matches(renameRegex, raw) {
            lineViolations.append(Violation(file: name, line: number, rule: "§1 RENAME", detail: trimmed))
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
        for entry in entries where entry.hasSuffix(".md") {
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

// ── arguments: .swift files, `--stamp PATH`, `--docc DIR` ──
func collect(_ arguments: [String]) -> (files: [String], stamp: String?, docc: String?) {
    let fm = FileManager.default
    var files: [String] = []
    var stamp: String?
    var docc: String?
    var iterator = arguments.makeIterator()
    while let argument = iterator.next() {
        switch argument {
        case "--stamp": stamp = iterator.next()
        case "--docc": docc = iterator.next()
        default:
            var isDirectory: ObjCBool = false
            if fm.fileExists(atPath: argument, isDirectory: &isDirectory), isDirectory.boolValue {
                let entries = (try? fm.contentsOfDirectory(atPath: argument)) ?? []
                for entry in entries where entry.hasSuffix(".swift") {
                    files.append((argument as NSString).appendingPathComponent(entry))
                }
            } else if argument.hasSuffix(".swift") {
                files.append(argument)
            }
        }
    }
    return (files.sorted(), stamp, docc)
}

enum Lint {
static func run(_ args: [String]) {
let (files, stamp, docc) = collect(args)
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

let violations = lineViolations + axisViolations + provenanceViolations

// the sentinel lets the build graph skip the check when nothing changed
if let stamp { try? Data().write(to: URL(fileURLWithPath: stamp)) }

if violations.isEmpty {
    let prov = runProvenance ? ", \(legendTags.count) tags resolve, every paper connected" : ""
    print("✓ THE LAW holds: pure types (§0′), no renames (§1), every axis closed (§2)\(prov). \(files.count) files.")
    exit(0)
}

var report = "✗ THE LAW / PROVENANCE violated:\n"
for violation in violations {
    report += "    \(violation.file):\(violation.line)  \(violation.rule) — \(violation.detail)\n"
}
FileHandle.standardError.write(Data(report.utf8))
exit(1)
}
}
