import Foundation

// ═══════════════════════════════════════════════════════════════
// JUDGE DIFF — the differential seat (§5.4): the two arbiters read one corpus and
// their verdicts are compared, clean and under planted lies. Agreement is the
// expected reading. A lie must be refused by BOTH, and both refusals must name the
// same facts — the person, the coordinate values in conflict — so the comparison is
// over named premises, never over exit codes alone. The gate lie is the one check
// with the opposite expectation: the normative layer itself is edited, the compiler
// holds the loosened gate, and only the second record refuses — the seat's signal
// that the law moved, not the data (Play Is Proof PP15: the human read of the
// policy file is the floor beneath both records).
//
// `Tools judge diff [N]`   — generate a company of N in a disposable worktree, run
//                            both judges clean, then under each planted lie.
// `Tools judge chain [N] [--swift]` — rewrite every hire's rank as a derivation from
//                            the previous hire (`EmpK.Rank.Next`), the spelling whose
//                            depth killed the standing arbiter's deserializer, and
//                            show the second judge settles it link by link with the
//                            same values the direct spelling carries. `--swift` also
//                            asks the standing arbiter, at the caller's own risk.
// ═══════════════════════════════════════════════════════════════

enum JudgeDiff {

    static func shell(_ arguments: [String], cwd: String? = nil) -> (status: Int32, output: String) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = arguments
        if let cwd { process.currentDirectoryURL = URL(fileURLWithPath: cwd) }
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        do { try process.run() } catch { return (127, "\(error)") }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        return (process.terminationStatus, String(data: data, encoding: .utf8) ?? "")
    }

    static func makeWorktree(prefix: String) -> String? {
        let dirty = shell(["git", "status", "--porcelain"]).output
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if dirty.isEmpty == false {
            FileHandle.standardError.write(Data(
                "judge: the tree is dirty, commit first (the worktree checks out HEAD)\n".utf8))
            return nil
        }
        let worktree = NSTemporaryDirectory() + prefix + "-\(ProcessInfo.processInfo.processIdentifier)"
        guard shell(["git", "worktree", "add", "-f", worktree, "HEAD"]).status == 0 else {
            FileHandle.standardError.write(Data("judge: git worktree add failed\n".utf8))
            return nil
        }
        return worktree
    }

    static func removeWorktree(_ worktree: String) {
        _ = shell(["git", "worktree", "remove", "-f", worktree])
        _ = shell(["git", "worktree", "prune"])
    }

    static func generate(_ count: Int, in worktree: String) -> Bool {
        print("warming the tools in a disposable worktree...")
        guard shell(["swift", "build", "--product", "Tools"], cwd: worktree).status == 0 else {
            FileHandle.standardError.write(Data("judge: the Tools build failed\n".utf8))
            return false
        }
        let generated = shell(
            [worktree + "/.build/debug/Tools", "generate", "org", String(count)],
            cwd: worktree)
        return generated.status == 0
    }

    // ── the planted lies ──

    struct Lie {
        let name: String
        let apply: (String, Judge.Judgment) -> (text: String, tokens: [String])?
    }

    static func lastSegment(of marker: String, in text: String) -> Range<String.Index>? {
        guard let head = text.range(of: marker, options: .backwards) else { return nil }
        guard let tail = text.range(of: ".self", range: head.lowerBound..<text.endIndex) else {
            return nil
        }
        return head.lowerBound..<tail.lowerBound
    }

    static let otherShare: [String: String] = [
        "FinanceShare": "SalesShare", "EngineeringShare": "FinanceShare",
        "SalesShare": "EngineeringShare", "PeopleShare": "FinanceShare",
    ]

    static let lies: [Lie] = [
        Lie(name: "a cross-department access, planted in the ledger's last entry") { text, clean in
            guard let range = lastSegment(of: "VerifiedView<", in: text) else { return nil }
            let segment = String(text[range])
            let inner = segment.split(separator: "<", maxSplits: 1)[1]
            let person = inner.split(separator: ",")[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let share = inner.split(separator: ",")[1]
                .trimmingCharacters(in: CharacterSet(charactersIn: " \n\t>"))
            guard let planted = otherShare[share] else { return nil }
            let home = clean.coordinates[person]?["Home"] ?? "?"
            let plantedHome = Judge.shareHomes[planted] ?? "?"
            let mutated = text.replacingCharacters(in: range,
                with: segment.replacingOccurrences(of: share, with: planted))
            return (mutated, [person, home, plantedHome])
        },
        Lie(name: "a rank spelled to nothing") { text, _ in
            let anchor = "public enum Emp0042: Employee, Person {\n    public typealias Rank = "
            guard let head = text.range(of: anchor) else { return nil }
            let mutated = text.replacingCharacters(in: head, with: anchor + "Misspelled")
            return (mutated, ["Misspelled"])
        },
        Lie(name: "a site pointing at a department") { text, _ in
            let anchor = "public enum Emp0001: Employee, Person {"
            guard let head = text.range(of: anchor) else { return nil }
            guard let site = text.range(of: "public typealias Site = ",
                range: head.upperBound..<text.endIndex) else { return nil }
            guard let lineEnd = text.range(of: "\n",
                range: site.upperBound..<text.endIndex) else { return nil }
            let mutated = text.replacingCharacters(in: site.upperBound..<lineEnd.lowerBound,
                with: "Finance")
            return (mutated, ["Emp0001", "Finance"])
        },
        Lie(name: "a team claiming a foreign rank, in its last entry") { text, clean in
            guard let range = lastSegment(of: "VerifiedAtRank<", in: text) else { return nil }
            let segment = String(text[range])
            let inner = segment.split(separator: "<", maxSplits: 1)[1]
            let person = inner.split(separator: ",")[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let claimed = inner.split(separator: ",")[1]
                .trimmingCharacters(in: CharacterSet(charactersIn: " \n\t>"))
            let held = clean.coordinates[person]?["Rank"] ?? "?"
            let foreign = Judge.nextInCycle[claimed] ?? "Lead"
            let mutated = text.replacingCharacters(in: range,
                with: segment.replacingOccurrences(of: claimed, with: foreign))
            return (mutated, [person, held, foreign])
        },
    ]

    // ── the two seats ──

    static func standingArbiter(in worktree: String) -> (passed: Bool, seconds: Double, output: String) {
        let started = DispatchTime.now()
        let build = shell(["swift", "build", "--target", "Organization"], cwd: worktree)
        let seconds = Double(DispatchTime.now().uptimeNanoseconds
            - started.uptimeNanoseconds) / 1_000_000_000
        return (build.status == 0, seconds, build.output)
    }

    static func runDiff(count: Int) {
        guard let worktree = makeWorktree(prefix: "vi-judge") else { exit(2) }
        defer { removeWorktree(worktree) }
        guard generate(count, in: worktree) else { exit(2) }
        let corpus = worktree + "/Sources/Organization/System/GeneratedTeam.swift"
        guard let original = try? String(contentsOfFile: corpus, encoding: .utf8) else {
            FileHandle.standardError.write(Data("judge: cannot read the corpus\n".utf8))
            exit(2)
        }

        print("\n  the corpus: a company of \(count), one file, two judges\n")
        guard let clean = Judge.judge(paths: [corpus]) else { exit(2) }
        let cleanSwift = standingArbiter(in: worktree)
        let judgeVerdict = clean.refusals.isEmpty ? "holds" : "refuses"
        let swiftVerdict = cleanSwift.passed ? "holds" : "refuses"
        let agreementClean = (clean.refusals.isEmpty == cleanSwift.passed) ? "✓ agree" : "✗ DISAGREE"
        print("  clean: judge \(judgeVerdict) in \(String(format: "%.0f", clean.milliseconds)) ms · "
            + "swift \(swiftVerdict) in \(String(format: "%.0f", cleanSwift.seconds)) s · \(agreementClean)")

        var disagreements = 0
        for lie in lies {
            guard let planted = lie.apply(original, clean) else {
                print("  \(lie.name): the lie found no place to stand, skipped")
                continue
            }
            try? planted.text.write(toFile: corpus, atomically: true, encoding: .utf8)
            let judged = Judge.judge(paths: [corpus])!
            let swifted = standingArbiter(in: worktree)
            try? original.write(toFile: corpus, atomically: true, encoding: .utf8)

            let premises = judged.refusals.map { $0.premise }.joined(separator: " ")
            var judgeNames = judged.refusals.isEmpty == false
            var swiftNames = swifted.passed == false
            for token in planted.tokens {
                if premises.contains(token) == false { judgeNames = false }
                if swifted.output.contains(token) == false { swiftNames = false }
            }
            let agree = judgeNames && swiftNames
            if agree == false { disagreements += 1 }
            let verdict = agree ? "✓ both refuse, same names" : "✗ DISAGREE"
            print("  \(lie.name):")
            print("      judge \(judged.refusals.count) refusal(s) in "
                + "\(String(format: "%.0f", judged.milliseconds)) ms · swift "
                + "\(swifted.passed ? "HOLDS" : "refuses") in "
                + "\(String(format: "%.0f", swifted.seconds)) s · \(verdict)")
            if agree == false {
                print("      tokens wanted: \(planted.tokens.joined(separator: ", "))")
                print("      judge said: \(premises.prefix(160))")
                let tail = swifted.output.split(separator: "\n").suffix(6).joined(separator: "\n        ")
                print("      swift said: \(tail.prefix(400))")
            }
        }
        // ── the gate lie: the law is edited, and only the second record objects ──
        // Loosening `VerifiedView`'s `where` makes the cross-department entry legal
        // Swift, so the compiler holds. The second record does not move with the
        // edit, so the judge still refuses by name. The expected verdict is
        // DIVERGENCE, and aligning the two records takes two edits in two
        // encodings — the price the seat puts on touching the law.
        let filtering = worktree + "/Sources/Organization/System/Filtering.swift"
        let gateWhole = ">: Close\nwhere Who.Home == Of.Home {}"
        let gateLoose = ">: Close {}"
        if let law = try? String(contentsOfFile: filtering, encoding: .utf8),
           law.contains(gateWhole),
           let planted = lies[0].apply(original, clean) {
            try? law.replacingOccurrences(of: gateWhole, with: gateLoose)
                .write(toFile: filtering, atomically: true, encoding: .utf8)
            try? planted.text.write(toFile: corpus, atomically: true, encoding: .utf8)
            let judged = Judge.judge(paths: [corpus])!
            let swifted = standingArbiter(in: worktree)
            try? law.write(toFile: filtering, atomically: true, encoding: .utf8)
            try? original.write(toFile: corpus, atomically: true, encoding: .utf8)

            let premises = judged.refusals.map { $0.premise }.joined(separator: " ")
            var judgeNames = judged.refusals.isEmpty == false
            for token in planted.tokens
            where premises.contains(token) == false {
                judgeNames = false
            }
            let diverged = swifted.passed && judgeNames
            if diverged == false { disagreements += 1 }
            print("  the gate loosened, the same cross-department entry planted:")
            print("      judge \(judged.refusals.count) refusal(s) in "
                + "\(String(format: "%.0f", judged.milliseconds)) ms · swift "
                + "\(swifted.passed ? "holds" : "REFUSES") in "
                + "\(String(format: "%.0f", swifted.seconds)) s · "
                + (diverged
                    ? "✓ diverges by design: the law moved, the second record did not"
                    : "✗ NO DIVERGENCE"))
            if diverged == false {
                print("      tokens wanted: \(planted.tokens.joined(separator: ", "))")
                print("      judge said: \(premises.prefix(160))")
            }
        } else {
            print("  the gate lie found no gate to loosen, skipped")
            disagreements += 1
        }

        if disagreements == 0 {
            print("\n✓ THE SEAT holds: every verdict agreed, every refusal named the same facts, and the loosened gate diverged by design.")
            return
        }
        print("\n✗ THE SEAT found \(disagreements) disagreement(s): a defect in one judge or the other.")
        exit(1)
    }

    // ── the chain: the spelling that killed the deserializer ──

    static func chained(_ text: String) -> String {
        var people: [String] = []
        var searchFrom = text.startIndex
        while let found = text.range(of: "public enum Emp", range: searchFrom..<text.endIndex) {
            let tail = text[found.upperBound...]
            let digits = tail.prefix { $0.isNumber }
            if digits.isEmpty == false, tail.dropFirst(digits.count).hasPrefix(": Employee") {
                people.append("Emp" + digits)
            }
            searchFrom = found.upperBound
        }
        var mutated = text
        for index in stride(from: people.count - 1, through: 1, by: -1) {
            let person = people[index]
            let previous = people[index - 1]
            let anchor = "public enum \(person): Employee, Person {\n    public typealias Rank = "
            guard let head = mutated.range(of: anchor) else { continue }
            guard let lineEnd = mutated.range(of: "\n",
                range: head.upperBound..<mutated.endIndex) else { continue }
            mutated = mutated.replacingCharacters(in: head.upperBound..<lineEnd.lowerBound,
                with: "\(previous).Rank.Next")
        }
        return mutated
    }

    static func runChain(count: Int, askSwift: Bool) {
        guard let worktree = makeWorktree(prefix: "vi-chain") else { exit(2) }
        defer { removeWorktree(worktree) }
        guard generate(count, in: worktree) else { exit(2) }
        let corpus = worktree + "/Sources/Organization/System/GeneratedTeam.swift"
        guard let original = try? String(contentsOfFile: corpus, encoding: .utf8) else { exit(2) }

        guard let direct = Judge.judge(paths: [corpus]) else { exit(2) }
        let chainedText = chained(original)
        try? chainedText.write(toFile: corpus, atomically: true, encoding: .utf8)
        guard let derived = Judge.judge(paths: [corpus]) else { exit(2) }

        print("\n  the chain at N = \(count): every hire's rank derives from the previous hire\n")
        print("  direct spelling:  judge \(direct.refusals.isEmpty ? "holds" : "refuses") in "
            + "\(String(format: "%.0f", direct.milliseconds)) ms")
        print("  chained spelling: judge \(derived.refusals.isEmpty ? "holds" : "refuses") in "
            + "\(String(format: "%.0f", derived.milliseconds)) ms")
        if derived.refusals.isEmpty == false {
            Judge.report(derived)
            exit(1)
        }
        let identical = direct.coordinates == derived.coordinates
        print("  the two spellings settle identical coordinates: \(identical ? "✓" : "✗")")
        if identical == false { exit(1) }
        if askSwift {
            print("  asking the standing arbiter (its deserializer meets the chain)...")
            let swifted = standingArbiter(in: worktree)
            print("  swift: \(swifted.passed ? "holds" : "REFUSES OR DIES") in "
                + "\(String(format: "%.0f", swifted.seconds)) s")
        }
        print("\n✓ THE CHAIN is one spelling of the same content, and the judge prices it by the link.")
    }

    // ── the door ──

    static func run(_ arguments: [String]) {
        let mode = arguments.first ?? "diff"
        let numbers = arguments.dropFirst().compactMap { Int($0) }
        let count = numbers.first ?? 200
        if mode == "chain" {
            runChain(count: count, askSwift: arguments.contains("--swift"))
            return
        }
        runDiff(count: count)
    }
}
