// VOICE CHECK — a lexical baseline, with its scope and limits recorded.
//
// The voice law (Papers/a_verb_is_an_act.md) defines source and actor obligations.
// These regex classes count candidate occurrences, not that semantic defect count.
// A semicolon, a mathematical truth predicate and a duration-free label can match
// without establishing a violation of the law. This gate compares the lexical count
// with an authored baseline. A rise requires review; a passing count proves neither
// source recovery nor faithfulness. The 2026-10-11 paper rebase and the complete hit
// inventory are in Research/Desk/theory-dark/voice-audit/decision-codex.md.

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

    // The pinned lexical count per scope. The papers scope was unexercised until
    // 2026-08-28: the filter asked the relative path for a ".docc" its own base
    // had already consumed, so the scan carried nothing and its zero verified
    // nothing. The filter now reads the full path. The old paper pin was 275.
    // On 2026-10-11 the author removed 131 FILLER/POSE/LIVE occurrences from
    // the current corpus, then measured the 35-paper residue at 1393:
    // SEMI 1288, HOLD 87, DASH 18. FILLER, POSE and LIVE are each zero.
    // This records the expanded corpus as the review baseline. It does not
    // certify every residual match or claim a completed semantic audit.
    // Other scope pins are unchanged. A rise still fails until explicitly reviewed.
    // On 2026-10-12 every paper paragraph was joined onto one line; cmark and
    // pandoc render each paper identically before and after. Two wrapped
    // continuation lines had begun with |z| and |C|, and the table-row filter
    // skipped them. Their sentences now count: one semicolon, one "holds".
    // The same prose measures 1395.
    static let pins: [(scope: String, count: Int)] = [
        ("papers", 1395),
        ("lattice", 6),
        ("kit", 18),
        ("pages", 308),
        ("readme", 2),
    ]

    // `--scope <name>=<kind>:<path>[!<excluded>]@<pin>`, kind `markdown`, `docs` or `file`:
    // a dependent package (the showcase, T-0015) scans its own prose against its own pins.
    // With one or more flags only the named scopes are scanned, and a path that does not
    // exist is refused, so a moved directory cannot pass as a scope of zero hits. Without
    // them the scopes and pins are this repository's own, as above.
    static func scopes(_ args: [String]) -> (counts: [(String, Int)], pins: [(scope: String, count: Int)], rest: [String]) {
        var counts: [(String, Int)] = []
        var chosen: [(scope: String, count: Int)] = []
        var rest: [String] = []
        var index = 0
        while index < args.count {
            guard args[index] == "--scope" else {
                rest.append(args[index])
                index += 1
                continue
            }
            let spec = index + 1 < args.count ? args[index + 1] : ""
            guard let equals = spec.firstIndex(of: "="), let colon = spec.firstIndex(of: ":"),
                  let at = spec.lastIndex(of: "@"), equals < colon, colon < at,
                  let pin = Int(spec[spec.index(after: at)...]) else {
                FileHandle.standardError.write(Data("voice: --scope needs <name>=<kind>:<path>[!<excluded>]@<pin>\n".utf8))
                exit(2)
            }
            let name = String(spec[..<equals])
            let kind = String(spec[spec.index(after: equals)..<colon])
            let target = spec[spec.index(after: colon)..<at].split(separator: "!", maxSplits: 1).map(String.init)
            guard FileManager.default.fileExists(atPath: root + "/" + target[0]) else {
                FileHandle.standardError.write(Data("voice: cannot read \(target[0]) for scope \(name)\n".utf8))
                exit(2)
            }
            let n: Int
            switch kind {
            case "markdown": n = scanMarkdown(under: target[0], excluding: target.count == 2 ? target[1] : nil)
            case "docs": n = scanDocComments(under: target[0])
            case "file": n = scanMarkdownFile(root + "/" + target[0])
            default:
                FileHandle.standardError.write(Data("voice: scope kind \(kind) is not markdown, docs or file\n".utf8))
                exit(2)
            }
            counts.append((name, n))
            chosen.append((scope: name, count: pin))
            index += 2
        }
        if chosen.isEmpty == false { return (counts, chosen, rest) }
        return ([
            ("papers", scanMarkdown(under: "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers")),
            ("lattice", scanDocComments(under: "Sources/VerificationIsIdentification")),
            ("kit", scanDocComments(under: "Sources/DocumentKit")),
            ("pages", scanMarkdown(under: "Sources", excluding: "Papers")),
            ("readme", scanMarkdownFile(root + "/README.md")),
        ], pins, rest)
    }

    static func run(_ arguments: [String]) {
        let (counts, pins, args) = scopes(arguments)
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
        let words = ["no", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        let spelled = counts.count < words.count ? words[counts.count] : String(counts.count)
        print("✓ VOICE BASELINE: \(total) lexical hits across \(spelled) scope\(counts.count == 1 ? "" : "s"), every one at or under its pin. Semantic faithfulness is not certified.")
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
        where path.hasSuffix(".md") && (base + "/" + path).contains(".docc") {
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
