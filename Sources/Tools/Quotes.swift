import Foundation

// ═══════════════════════════════════════════════════════
// Quotes answers one question: does a quote of a sibling paper say what
// that paper says?
//
// A quoted span attributed to a sibling is a record about that sibling,
// and a record nobody judges drifts: the theory audit of 2026-08-03
// found spliced and compressed quotes presented as verbatim. This
// reader walks every paper, takes each quoted span whose OWN SENTENCE
// names a sibling paper, splits the quote at its ellipses, and requires
// every part of five or more words to stand verbatim, normalized, in
// the named paper. A quote whose sentence names nobody is the paper's
// own phrase and nobody's record: the court steps over it. The reader
// proves its own walk on a planted pair before it reads anything.
//
// Usage: Tools quotes [papersDir]
// ═══════════════════════════════════════════════════════

enum Quotes {

    // the sibling names a sentence may carry, and the file each one is
    static let tokens: [(pattern: String, file: String)] = [
        ("V=I|Verification Is Identification", "verification_is_identification.md"),
        ("\\bPiR\\b|Permanence Is Resistance", "permanence_is_resistance.md"),
        ("\\bIiI\\b|Intelligence Is Inevitable", "intelligence_is_inevitable.md"),
        ("\\bInI\\b|Interference Is Intelligence", "interference_is_intelligence.md"),
        ("\\bDiD\\b|Difference Is Distance", "difference_is_distance.md"),
        ("\\bDiC\\b|Distance Is Cost", "distance_is_cost.md"),
        ("Reading Is Order", "reading_is_order.md"),
        ("Record Is System", "record_is_system.md"),
        ("Dynamics Is Substitution", "dynamics_is_substitution.md"),
        ("\\bEiF\\b|Existence Is Finite", "existence_is_finite.md"),
        ("Basis Is Residue", "basis_is_residue.md"),
        ("Play Is Proof", "play_is_proof.md"),
        ("\\bOiO\\b|Order Is Object", "order_is_object.md"),
        ("\\bLiT\\b|Law Is Target", "law_is_target.md"),
        ("Halt Is Ignition", "halt_is_ignition.md"),
        ("\\bE2\\b|Solvability Criterion", "solvability_criterion.md"),
        ("Proposal Is Order", "proposal_is_order.md"),
        ("Gradient Is Alignment", "gradient_is_alignment.md"),
        ("Learning Is Liquid", "learning_is_liquid.md"),
        ("\\bNiG\\b|Navigation Is Geometry", "navigation_is_geometry.md"),
        ("Seeing Is Encoding", "seeing_is_encoding.md"),
        ("Colour Is a Quotient", "colour_is_a_quotient.md"),
        ("Light Is a Ruler", "light_is_a_ruler.md"),
        ("Form Is Gauge", "form_is_gauge.md"),
        ("Program Is Path", "program_is_path.md"),
        ("A Verb Is an Act", "a_verb_is_an_act.md"),
        ("Merge Is Commutation", "merge_is_commutation.md"),
        ("Seam Is Game", "seam_is_game.md"),
        ("Permission Is Existence", "permission_is_existence.md"),
        ("Architecture of Learning Machines", "architecture_of_learning_machines.md"),
    ]

    struct Violation {
        let paper: String
        let line: Int
        let target: String
        let head: String
    }

    // one spelling for both sides: case folded, typography folded, every
    // other mark a space, whitespace collapsed
    static func normalize(_ s: String) -> String {
        var t = s.lowercased()
        for (a, b) in [("—", "-"), ("–", "-"), ("’", "'"), ("‘", "'"),
                       ("“", "\""), ("”", "\""), ("\\", "")] {
            t = t.replacingOccurrences(of: a, with: b)
        }
        var out = ""
        for ch in t { out.append(ch.isLetter || ch.isNumber ? ch : " ") }
        return out.split(separator: " ").joined(separator: " ")
    }

    // the start of the sentence the position stands in: back to the
    // nearest boundary a paper's prose uses
    static func sentenceStart(_ s: String) -> String.Index {
        var best = s.startIndex
        for mark in [". ", ".** ", "\n\n", "\n#", "\n- ", "\n| "] {
            if let r = s.range(of: mark, options: .backwards), r.upperBound > best {
                best = r.upperBound
            }
        }
        return best
    }

    // the core, fed by the walk and by its own self-test
    static func check(paper: String, text: String,
                      corpus: [String: String]) -> (bad: [Violation], seen: Int) {
        var bad: [Violation] = []
        var seen = 0
        let ns = text as NSString
        let quoteRe = try! NSRegularExpression(pattern: "[\"“]([^\"“”]{25,400})[\"”]")
        for m in quoteRe.matches(in: text, range: NSRange(location: 0, length: ns.length)) {
            let q = ns.substring(with: m.range(at: 1))
            if q.contains("\n\n") { continue }
            if q.components(separatedBy: "\n").count > 3 { continue }
            if q.components(separatedBy: "|").count > 2 { continue }
            if normalize(q).split(separator: " ").count < 5 { continue }
            let upTo = ns.substring(to: m.range.location)
            let sentence = String(upTo[sentenceStart(upTo)...])
            var target: String? = nil
            var best = -1
            for (pattern, file) in tokens
            where file != paper {
                let re = try! NSRegularExpression(pattern: pattern)
                let sns = sentence as NSString
                for tm in re.matches(in: sentence,
                                     range: NSRange(location: 0, length: sns.length))
                where tm.range.location > best {
                    best = tm.range.location
                    target = file
                }
            }
            guard let t = target, let body = corpus[t] else { continue }
            seen += 1
            let normBody = normalize(body)
            let parts = q.replacingOccurrences(of: "...", with: "…")
                .components(separatedBy: "…")
                .map(normalize)
                .filter { $0.split(separator: " ").count >= 5 }
            let drifted = parts.filter { normBody.contains($0) == false }
            if drifted.isEmpty == false {
                let line = upTo.components(separatedBy: "\n").count
                bad.append(Violation(paper: paper, line: line, target: t,
                                     head: String(q.prefix(60))))
            }
        }
        return (bad, seen)
    }

    // the reader is proven before it reads: a standing quote passes, a
    // reworded one refuses, an unattributed one is stepped over
    static func quotesWalkFires() -> Bool {
        let corpus = ["basis_is_residue.md":
            "The residue stands alone and the sieve keeps what composition cannot reach today."]
        let good = "As Basis Is Residue says: \"the sieve keeps what composition cannot reach\". So."
        let bad = "As Basis Is Residue says: \"the sieve keeps what composition happily reaches\". So."
        let own = "Its own phrase stands here: \"a sieve of a phrase nobody attributed to anybody\". So."
        return check(paper: "x.md", text: good, corpus: corpus).bad.isEmpty
            && check(paper: "x.md", text: bad, corpus: corpus).bad.count == 1
            && check(paper: "x.md", text: own, corpus: corpus).bad.isEmpty
    }

    static func run(_ args: [String]) {
        guard quotesWalkFires() else {
            print("✗ THE QUOTES reader's own walk does not fire")
            exit(2)
        }
        let dir = args.first
            ?? "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers"
        let names = ((try? FileManager.default.contentsOfDirectory(atPath: dir)) ?? [])
            .filter { $0.hasSuffix(".md") }.sorted()
        guard names.isEmpty == false else {
            print("✗ THE QUOTES reader finds no papers under \(dir)")
            exit(2)
        }
        var corpus: [String: String] = [:]
        for n in names {
            corpus[n] = (try? String(contentsOfFile:
                (dir as NSString).appendingPathComponent(n), encoding: .utf8)) ?? ""
        }
        var bad: [Violation] = []
        var seen = 0
        for n in names {
            let r = check(paper: n, text: corpus[n] ?? "", corpus: corpus)
            bad.append(contentsOf: r.bad)
            seen += r.seen
        }
        if bad.isEmpty {
            print("✓ THE QUOTES hold: \(seen) spans attributed to a sibling, every part standing in it.")
            return
        }
        print("✗ THE QUOTES drift, \(bad.count) span(s) of \(seen):")
        for v in bad {
            print("    \(v.paper):\(v.line)  a quote of \(v.target): \"\(v.head)…\"")
        }
        exit(1)
    }
}
