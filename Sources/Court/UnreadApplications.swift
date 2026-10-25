import Foundation

extension WhereJudge {
    /// A reversed index of gated names. A name may itself be qualified. The
    /// written name is exact; whitespace is allowed only in its qualification
    /// prefix, as in the existing notation. This index is shared by all files.
    struct UnreadHeads {
        struct Node {
            var next: [ScalarName: Int] = [:]
            var name: ScalarName? = nil
        }
        var nodes = [Node()]
        init(_ names: NameSet) {
            for name in names {
                var at = 0
                for part in name.unicodeScalars.split(separator: ".", omittingEmptySubsequences: false).reversed() {
                    let key = ScalarName(String(String.UnicodeScalarView(part)))
                    if let next = nodes[at].next[key] { at = next }
                    else {
                        let next = nodes.count
                        nodes[at].next[key] = next
                        nodes.append(Node())
                        at = next
                    }
                }
                nodes[at].name = ScalarName(name)
            }
        }
    }
    struct UnreadApplication {
        let name: ScalarName
        let at: Int
        var multilineMetatype = false
    }
    struct UnreadReading {
        var applications: [UnreadApplication] = []
        // Work witnesses, not elapsed-time claims. Each bounded loop below
        // advances one cursor or removes a previously pushed angle frame.
        var tokens = 0
        var qualificationSteps = 0
        var spanAdvances = 0
        var openedAngles = 0
        var closedAngles = 0
    }

    static func unreadApplications(_ file: World, spans: [NSRange], heads: UnreadHeads) -> UnreadReading {
        let tape = file.notation
        let units = Array(file.clean.utf16)
        // Prefix counts make the legacy ASCII-space tests constant-time. The
        // tape itself omits the notation's Unicode whitespace; these are two
        // different predicates in the existing notation, deliberately kept.
        var nonSpace = [Int](repeating: 0, count: units.count + 1)
        for i in units.indices { nonSpace[i + 1] = nonSpace[i] + (isSpaceUnit(units[i]) ? 0 : 1) }
        func asciiSpace(_ a: Int, _ b: Int) -> Bool { nonSpace[a] == nonSpace[b] }
        func end(_ i: Int) -> Int { NSMaxRange(tape[i].range) }
        let declaring: NameSet = ["enum", "struct", "class", "actor", "typealias", "protocol"]
        let covered = spans.filter { $0.length > 0 }.sorted { $0.location < $1.location }
        var span = 0, coverEnd = 0
        var result = UnreadReading()
        var starts = [Int?](repeating: nil, count: tape.count)
        struct Angle {
            let token: Int
            let candidates: [UnreadApplication]
        }
        var angles: [Angle] = []

        func finish(_ frame: Angle, at close: Int?) {
            var multiline = false
            if let close, close + 2 < tape.count,
               tape[close + 1].spelling == ".", tape[close + 2].word,
               end(close + 1) == tape[close + 2].range.location,
               tape[close + 2].spelling.text.utf8.starts(with: "self".utf8),
               asciiSpace(end(close), tape[close + 1].range.location) {
                multiline = file.lineAt[end(frame.token)] < file.lineAt[end(close)]
            }
            for candidate in frame.candidates {
                var application = candidate
                application.multilineMetatype = multiline
                result.applications.append(application)
            }
            result.closedAngles += 1
        }
        for i in tape.indices {
            result.tokens += 1
            let token = tape[i]
            if token.word {
                // The earliest admissible qualification prefix. If a leading
                // dot blocks a prefix, whitespace can admit a later start.
                if i >= 2, tape[i - 1].spelling == ".", tape[i - 2].word,
                   let first = starts[i - 2] { starts[i] = first }
                else if i == 0 || end(i - 1) < token.range.location
                    || (!tape[i - 1].word && tape[i - 1].spelling != ".") { starts[i] = i }
                continue
            }
            if token.spelling == "<" {
                var candidates: [UnreadApplication] = []
                if i > 0, tape[i - 1].word, let first = starts[i - 1] {
                    let at = tape[first].range.location
                    while span < covered.count, covered[span].location <= at {
                        coverEnd = max(coverEnd, NSMaxRange(covered[span]))
                        span += 1
                        result.spanAdvances += 1
                    }
                    let declaration: Bool
                    if first > 0, declaring.contains(tape[first - 1].spelling),
                       asciiSpace(end(first - 1), at) {
                        let before = tape[first - 1].range.location
                        declaration = before == 0 || !isWordUnit(units[before - 1])
                    } else { declaration = false }
                    if at >= coverEnd && !declaration {
                        var part = i - 1, node = 0
                        // A dotted word chain can end at only one '<'. Thus
                        // these backwards steps, across the whole tape, are
                        // bounded by its word count, not by names × text.
                        while true {
                            result.qualificationSteps += 1
                            guard let next = heads.nodes[node].next[tape[part].spelling] else { break }
                            node = next
                            if let name = heads.nodes[node].name {
                                candidates.append(UnreadApplication(name: name, at: at))
                            }
                            guard part >= first + 2, tape[part - 1].spelling == ".",
                                  tape[part - 2].word, end(part - 2) == tape[part - 1].range.location,
                                  end(part - 1) == tape[part].range.location else { break }
                            part -= 2
                        }
                    }
                }
                angles.append(Angle(token: i, candidates: candidates))
                result.openedAngles += 1
            } else if token.spelling == ">" {
                if token.range.location > 0, units[token.range.location - 1] == 0x2D { continue }
                if let frame = angles.popLast() { finish(frame, at: i) }
            } else if token.spelling == "{" || token.spelling == "}" || token.spelling == ";" {
                while let frame = angles.popLast() { finish(frame, at: nil) }
            }
        }
        while let frame = angles.popLast() { finish(frame, at: nil) }
        return result
    }
}
