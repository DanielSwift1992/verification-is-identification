// VOICE CHECK — the prose's defect count is pinned, not remembered.
//
// The voice law (Papers/a_verb_is_an_act.md) fixes the grammar of a faithful record,
// and the corpus is audited to its fixed point: what remains of each scanned class is
// the law's own residue (table cells, rubricator headings, instrument contracts, the
// terms of the machine). This gate re-counts that residue per scope and compares it to
// the pinned number. A rise fails the gate by scope and by class: a new defect, or a
// new legal use whose pin the author must move deliberately. The numbers expire the
// way every vote here expires: re-count with `voice --counts`, then move the pin.

import Foundation

enum VoiceTool {
    static let root = FileManager.default.currentDirectoryPath

    // The mechanical classes of A Verb Is an Act, as the audit scans them.
    static let classes: [(name: String, pattern: String)] = [
        ("SEMI", ";"),
        ("DASH", "—"),
        ("HOLD", "\\bholds?\\b"),
        ("LIVE", "\\blives?\\b"),
        ("POSE", "\\bsits?\\b|\\bstands?\\b|\\bstays?\\b|\\brides?\\b|\\bdwells?\\b"),
        ("FILLER", "\\bhonest|\\bmerely\\b|\\bsimply\\b|\\belegant|\\bcrucial|\\bseamless"),
    ]

    // The pinned residue per scope: the audited fixed point of 2026-07-18.
    // The papers' prose is clean outside fences and tables, the lattice keeps its
    // instrument holds and name dashes, the kit its law terms and quoted code, the
    // pages the generats' own residue, the README its live playground and its one
    // instrument hold. A rise is a regression or a pin to move.
    static let pins: [(scope: String, count: Int)] = [
        ("papers", 0),
        ("lattice", 6),
        ("kit", 18),
        ("pages", 308),
        ("readme", 2),
    ]

    static func run(_ args: [String]) {
        let counts = [
            ("papers", scanMarkdown(under: "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers")),
            ("lattice", scanDocComments(under: "Sources/VerificationIsIdentification")),
            ("kit", scanDocComments(under: "Sources/DocumentKit")),
            ("pages", scanMarkdown(under: "Sources", excluding: "Papers")),
            ("readme", scanMarkdownFile(root + "/README.md")),
        ]
        if args.first == "--counts" {
            for (scope, n) in counts { print("\(scope): \(n)") }
            return
        }
        var risen = false
        for ((scope, n), pin) in zip(counts, pins) {
            if n > pin.count {
                print("✗ VOICE rises in \(scope): \(n) hits against the pinned \(pin.count).")
                risen = true
            }
        }
        if risen {
            print("✗ THE VOICE drifts: audit the new prose under A Verb Is an Act, or move the pin with the count from `voice --counts`.")
            exit(1)
        }
        let total = counts.reduce(0) { $0 + $1.1 }
        print("✓ THE VOICE holds: \(total) residual hits across five scopes, every one at or under its pin.")
    }

    // Prose lines of `///` doc-comments, code spans stripped, fenced blocks skipped.
    static func scanDocComments(under directory: String) -> Int {
        var total = 0
        let base = root + "/" + directory
        let paths = (FileManager.default.enumerator(atPath: base)?.allObjects as? [String]) ?? []
        for path in paths
        where path.hasSuffix(".swift") {
            let text = (try? String(contentsOfFile: base + "/" + path, encoding: .utf8)) ?? ""
            var fenced = false
            for raw in text.split(separator: "\n", omittingEmptySubsequences: false) {
                let line = raw.trimmingCharacters(in: .whitespaces)
                guard line.hasPrefix("///") else { continue }
                let body = String(line.dropFirst(3)).trimmingCharacters(in: .whitespaces)
                if body.hasPrefix("```") { fenced.toggle(); continue }
                if fenced { continue }
                total += hits(in: stripCode(body))
            }
        }
        return total
    }

    static func scanMarkdown(under directory: String, excluding: String? = nil) -> Int {
        var total = 0
        let base = root + "/" + directory
        let paths = (FileManager.default.enumerator(atPath: base)?.allObjects as? [String]) ?? []
        for path in paths
        where path.hasSuffix(".md") && path.contains(".docc") {
            if let ex = excluding, path.contains(ex) { continue }
            total += scanMarkdownFile(base + "/" + path)
        }
        return total
    }

    // Prose lines of a markdown page: fences skipped, table rows and headings
    // skipped (their dashes are cells and rubricators, the law's own residue).
    static func scanMarkdownFile(_ path: String) -> Int {
        let text = (try? String(contentsOfFile: path, encoding: .utf8)) ?? ""
        var total = 0
        var fenced = false
        for raw in text.split(separator: "\n", omittingEmptySubsequences: false) {
            let line = raw.trimmingCharacters(in: .whitespaces)
            if line.hasPrefix("```") { fenced.toggle(); continue }
            if fenced { continue }
            if line.hasPrefix("|") || line.hasPrefix("#") { continue }
            total += hits(in: stripCode(String(line)))
        }
        return total
    }

    static func stripCode(_ line: String) -> String {
        line.replacingOccurrences(of: "`[^`]*`", with: "", options: .regularExpression)
    }

    static func hits(in prose: String) -> Int {
        classes.reduce(0) { sum, cls in
            let regex = try! NSRegularExpression(pattern: cls.pattern)
            return sum + regex.numberOfMatches(in: prose, range: NSRange(prose.startIndex..., in: prose))
        }
    }
}
