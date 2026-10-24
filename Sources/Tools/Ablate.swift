import Foundation

// ═══════════════════════════════════════════════════════
// Ablate answers one question: which premises the build needs.
//
// The premise list comes from the compiler's own symbol graph, the same
// file tree-sort reads, so there is one reader of the lattice and no
// second parse. For each conformsTo edge between two protocols of the
// core module: cut the parent from the child's declaration line (the
// graph carries the file and the line), rebuild the core module, record
// the result, restore the file. `build fails` lists what the compiler
// refused; `builds green` means the module compiles without the premise —
// the premise still carries meaning for a reader, and the papers, not
// this table, argue it.
//
// Usage: Tools ablate <VerificationIsIdentification.symbols.json> [N]
// Writes Research/ablation/current.md as an optional experiment record.
// The mathematical corpus does not depend on this report. Restores every cut.
// ═══════════════════════════════════════════════════════

enum Ablate {
    struct Premise {
        let child: String
        let parent: String
        let file: String
        let line: Int
    }

    static func run(_ args: [String]) {
        if args == ["--self-test"] {
            checkCuts()
            return
        }
        guard let graphPath = args.first,
              let data = FileManager.default.contents(atPath: graphPath),
              let graph = try? JSONDecoder().decode(Graph.self, from: data) else {
            FileHandle.standardError.write(Data("usage: Tools ablate <symbols.json> [N]\n".utf8))
            exit(2)
        }
        let limit = args.count > 1 ? Int(args[1]) : nil   // a number, or --check
        let root = URL(fileURLWithPath: graphPath)
        let packageRoot = findPackageRoot(from: root)

        var byId: [String: Symbol] = [:]
        for s in graph.symbols { byId[s.identifier.precise] = s }
        var premises: [Premise] = []
        for r in graph.relationships
        where r.kind == "conformsTo" {
            guard let child = byId[r.source], let parent = byId[r.target],
                  child.kind.identifier.hasSuffix("protocol"),
                  parent.kind.identifier.hasSuffix("protocol"),
                  let uri = child.location?.uri,
                  let line = child.location?.position?.line else { continue }
            premises.append(Premise(child: child.names.title,
                                    parent: parent.names.title,
                                    file: uri.replacingOccurrences(of: "file://", with: ""),
                                    line: line))
        }
        premises.sort { ($0.file, $0.line, $0.parent) < ($1.file, $1.line, $1.parent) }
        if let limit { premises = Array(premises.prefix(limit)) }

        if args.contains("--check") {
            check(premises, packageRoot.appendingPathComponent(
                "Research/ablation/current.md").path)
        }

        // Snapshot every measured source before any mutation. A hard interruption
        // can bypass restoration, so the recovery copy must already exist on disk.
        let recovery = packageRoot.appendingPathComponent(".build/ablation-recovery/" + UUID().uuidString)
        var originals: [String: String] = [:]
        do {
            try FileManager.default.createDirectory(at: recovery, withIntermediateDirectories: true)
            for path in Set(premises.map { $0.file }).sorted() {
                let original = try String(contentsOfFile: path, encoding: .utf8)
                originals[path] = original
                try original.write(to: recovery.appendingPathComponent(URL(fileURLWithPath: path).lastPathComponent),
                                   atomically: true, encoding: .utf8)
            }
            let manifest = try JSONSerialization.data(withJSONObject: Array(originals.keys).sorted())
            try manifest.write(to: recovery.appendingPathComponent("sources.json"), options: .atomic)
        } catch {
            abort("cannot prepare recovery snapshot: \(error)")
        }
        let baseline = build(at: packageRoot)
        guard baseline.green else {
            abort("the module does not build before any cut:\n\(baseline.err)")
        }

        var rows: [(Premise, String, [String])] = []
        let started = Date()
        for p in premises {
            guard let kept = originals[p.file],
                  (try? String(contentsOfFile: p.file, encoding: .utf8)) == kept else {
                abort("source changed outside the probe: \(p.file). Snapshot: \(recovery.path)")
            }
            var lines = kept.components(separatedBy: "\n")
            guard p.line < lines.count else {
                abort("stale source location for \(p.child). Regenerate the symbol graph.")
            }
            var end = p.line
            while end + 1 < lines.count && !lines[end].contains("{") { end += 1 }
            let declaration = lines[p.line...end].joined(separator: "\n")
            guard let cut = cutParent(declaration, p.parent) else {
                rows.append((p, "inherited, no line to cut", []))
                continue
            }
            lines.replaceSubrange(p.line...end, with: cut.components(separatedBy: "\n"))
            let result: (green: Bool, err: String)
            do {
                result = try withCut(path: p.file, original: kept,
                                     cut: lines.joined(separator: "\n")) { build(at: packageRoot) }
            } catch {
                abort("probe or restoration failed: \(error). Recovery snapshot: \(recovery.path)")
            }
            guard result.green || isTypeRefusal(result.err) else {
                abort("build failed without a reliable type refusal. No report published. "
                      + "Sources restored, snapshot: \(recovery.path)\n\(result.err)")
            }
            let refused = result.green ? [] : refusedNames(result.err)
            rows.append((p, result.green ? "still builds" : "fails", refused))
            print("\(p.child): \(p.parent) -> \(result.green ? "still builds" : "fails (\(refused.count) names)")")
        }

        guard originals.allSatisfy({ path, original in
            (try? String(contentsOfFile: path, encoding: .utf8)) == original
        }) else {
            abort("source verification failed after restoration. Snapshot: \(recovery.path)")
        }
        let restoredBuild = build(at: packageRoot)
        guard restoredBuild.green else {
            abort("restored module does not build. No report published.\n\(restoredBuild.err)")
        }
        let greenRows = rows.filter { $0.1 == "still builds" }.count
        let failing = rows.filter { $0.1 == "fails" }
        let inherited = rows.filter { $0.1.hasPrefix("inherited") }.count
        let seconds = Int(-started.timeIntervalSinceNow)
        let shown = { (p: Premise) in
            p.file.replacingOccurrences(
                of: packageRoot.path + "/Sources/VerificationIsIdentification/", with: "") }
        let bullets = failing.map {
            "- ``\($0.0.child)`` needs ``\($0.0.parent)``, at \(shown($0.0)):\($0.0.line + 1)" }
        var out = headLines(total: rows.count, needs: failing.count, green: greenRows,
                            inherited: inherited, bullets: bullets,
                            seconds: "\(seconds)", revision: latticeRevision())
        out.append("| claim | premise | declared at | the module without it | what stops compiling |")
        out.append("|---|---|---|---|---|")
        for (p, verdict, refused) in rows {
            out.append("| ``\(p.child)`` | ``\(p.parent)`` | \(shown(p)):\(p.line + 1) "
                       + "| \(verdict) | \(refused.joined(separator: ", ")) |")
        }
        out.append("")
        out.append("Every file was put back after its cut, and the module builds.")
        let target = packageRoot.appendingPathComponent(
            "Research/ablation/current.md")
        do {
            try FileManager.default.createDirectory(at: target.deletingLastPathComponent(),
                                                    withIntermediateDirectories: true)
            try (out.joined(separator: "\n") + "\n").write(to: target, atomically: true, encoding: .utf8)
        } catch {
            abort("cannot publish ablation report: \(error)")
        }
        try? FileManager.default.removeItem(at: recovery)
        print("wrote Research/ablation/current.md, source bytes verified and module green after restore")
    }


    // THE HEAD IS ONE TEXT. The page carried a head written by hand while this
    // file wrote another, so the next hour-long run would have replaced the
    // page's words with the generator's. Both now ask here, and `--check`
    // rebuilds this head from the page's own rows and refuses a difference.
    static func headLines(total: Int, needs: Int, green: Int, inherited: Int,
                          bullets: [String], seconds: String, revision: String) -> [String] {
        var out = ["# Which premises the build needs", ""]
        out.append("Each claim declares premises, and this page records which of them")
        out.append("the core module's build enforces: each explicit premise was removed from its")
        out.append("declaration, the core module was rebuilt, and the file was put back.")
        out.append("")
        out.append("Of \(total) premises the module needs \(needs). It builds without the other \(green),")
        out.append("and \(inherited) come from a premise the compiler inherits: an inherited premise")
        out.append("is not written on a line of its own, so there is nothing to remove.")
        out.append("")
        out.append("The cut rebuilds the core module alone: witnesses, examples and the")
        out.append("modules downstream are outside this measure. Builds without it is a")
        out.append("fact about the core build, not a verdict that the premise is")
        out.append("unnecessary: the failures are a lower bound on necessity, and what")
        out.append("the argument needs is a different question, answered in the papers.")
        out.append("")
        out.append("Row format: the claim, the premise, the line where the premise is")
        out.append("declared, whether the core module builds without it, and, when the")
        out.append("build fails, the symbols the compiler reports.")
        out.append("")
        out.append("The premises the core build enforces:")
        out.append("")
        out += bullets
        out.append("")
        out.append("<doc:Atlas> ranks these claims by how many others depend on them, and")
        out.append("<doc:AtlasUnfolded> expands every such count into its list.")
        out.append("")
        out.append("The premise list comes from the symbol graph the compiler emits, and")
        out.append("tree-sort reads the same file, so the lattice has one reader.")
        out.append("The run took \(seconds)s over the")
        out.append("lattice at revision \(revision). Rerun it")
        out.append("yourself: `swift build --product Tools && .build/debug/Tools ablate")
        out.append("<symbols.json>`. The build writes the graph file under")
        out.append("`.build/*/extracted-symbols/`.")
        out.append("")
        return out
    }

    // the revision of the lattice the run measured, so a reader can tell a
    // fresh page from one the theory has moved past
    static func latticeRevision() -> String {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        p.arguments = ["git", "log", "-1", "--format=%h", "--",
                       "Sources/VerificationIsIdentification/*.swift", "Sources/Notation/*.swift"]
        let pipe = Pipe()
        p.standardOutput = pipe
        p.standardError = Pipe()
        try? p.run()
        let out = String(data: pipe.fileHandleForReading.readDataToEndOfFile(),
                         encoding: .utf8) ?? ""
        p.waitUntilExit()
        let revision = out.trimmingCharacters(in: .whitespacesAndNewlines)
        let status = Process()
        status.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        status.arguments = ["git", "status", "--porcelain", "--",
                            "Sources/VerificationIsIdentification/*.swift", "Sources/Notation/*.swift"]
        let changes = Pipe()
        status.standardOutput = changes
        status.standardError = Pipe()
        try? status.run()
        let dirty = changes.fileHandleForReading.readDataToEndOfFile()
        status.waitUntilExit()
        return dirty.isEmpty ? revision : revision + "+working-tree"
    }

    // `ablate --check` asks one question: does the page still name the premises
    // the lattice declares? The run itself takes an hour, the question takes a
    // moment, so the page cannot go stale in silence between runs.
    static func numbers(_ s: String) -> [Int] {
        var out: [Int] = []
        var digits = ""
        for ch in s {
            if ch.isNumber {
                digits.append(ch)
            } else if !digits.isEmpty {
                out.append(Int(digits) ?? 0)
                digits = ""
            }
        }
        if !digits.isEmpty { out.append(Int(digits) ?? 0) }
        return out
    }

    static func check(_ premises: [Premise], _ pagePath: String) -> Never {
        let text = (try? String(contentsOfFile: pagePath, encoding: .utf8)) ?? ""
        var onPage: Set<String> = []
        var said: [Int] = []
        var counted = ["fails": 0, "still builds": 0, "inherited": 0]
        var bulletsOnPage: [String] = []
        for line in text.components(separatedBy: "\n") {
            if line.hasPrefix("Of ") && line.contains("the module needs") { said += numbers(line) }
            if line.hasPrefix("and ") && line.contains("compiler inherits") { said += numbers(line) }
            if line.hasPrefix("- ``") { bulletsOnPage.append(line) }
            guard line.hasPrefix("| ``") else { continue }
            let cells = line.components(separatedBy: "|").map {
                $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "`", with: "") }
            if cells.count > 2 { onPage.insert(cells[1] + " " + cells[2]) }
            if cells.count > 4 {
                let verdict = cells[4].hasPrefix("inherited") ? "inherited" : cells[4]
                counted[verdict, default: 0] += 1
            }
        }
        let now = Set(premises.map { $0.child + " " + $0.parent })
        let gone = onPage.subtracting(now).sorted()
        let fresh = now.subtracting(onPage).sorted()
        // the head states four numbers, and the rows below it are where those
        // numbers come from, so the page is asked to agree with itself
        let fromRows = [onPage.count, counted["fails"]!, counted["still builds"]!,
                        counted["inherited"]!]
        if said != fromRows {
            print("✗ THE ABLATION page counts one way and says another. "
                  + "The head says \(said), the rows give \(fromRows) "
                  + "for premises, fails, still builds, inherited.")
            exit(1)
        }
        // and the head itself is rebuilt from those rows, so the words on the
        // page and the words this file writes cannot part between runs
        let pageLines = text.components(separatedBy: "\n")
        let tableAt = pageLines.firstIndex { $0.hasPrefix("| claim |") } ?? pageLines.count
        let onHead = Array(pageLines[0..<tableAt])
        var seconds = ""
        var revision = ""
        for line in onHead
        where line.contains("The run took") {
            let words = line.components(separatedBy: " ")
            seconds = (words.first { $0.hasSuffix("s") && Int($0.dropLast()) != nil }
                       ?? "").replacingOccurrences(of: "s", with: "")
        }
        for line in onHead
        where line.hasPrefix("lattice at revision ") {
            revision = line.replacingOccurrences(of: "lattice at revision ", with: "")
                .components(separatedBy: ".").first ?? ""
        }
        let asWritten = headLines(total: fromRows[0], needs: fromRows[1], green: fromRows[2],
                                  inherited: fromRows[3], bullets: bulletsOnPage,
                                  seconds: seconds, revision: revision)
        if asWritten != onHead {
            var n = min(asWritten.count, onHead.count)
            for i in 0..<min(asWritten.count, onHead.count)
            where asWritten[i] != onHead[i] {
                n = i
                break
            }
            print("✗ THE ABLATION page and this generator write different heads, from line \(n + 1).")
            print("    page:      \(n < onHead.count ? onHead[n] : "(nothing)")")
            print("    generator: \(n < asWritten.count ? asWritten[n] : "(nothing)")")
            exit(1)
        }
        // the tail after the table is the run's own attestation: a committed
        // page comes from a green run, so the page must say the restore held,
        // in words, with no printed Bool for a reader to decode
        let greenTail = "Every file was put back after its cut, and the module builds."
        if !pageLines.contains(greenTail) {
            print("✗ THE ABLATION page does not attest its restore: the line after "
                  + "the table must read: \(greenTail)")
            exit(1)
        }
        if gone.isEmpty && fresh.isEmpty {
            print("✓ THE ABLATION page names the \(now.count) premises the lattice "
                  + "declares, and its head counts what its rows hold.")
            exit(0)
        }
        print("✗ THE ABLATION page and the lattice part: \(fresh.count) premise(s) "
              + "the page misses, \(gone.count) it keeps after the lattice dropped them.")
        for x in (fresh + gone).prefix(6) { print("    \(x)") }
        print("    rerun: .build/debug/Tools ablate <symbols.json>")
        exit(1)
    }

    // Only an explicitly written parent can be cut. Symbol graphs also emit
    // inherited conformances: returning an unchanged declaration for one used
    // to count a successful build as an ablation without removing anything.
    // Stop before `where`, whose constraints must survive the cut unchanged.
    static func cutParent(_ line: String, _ parent: String) -> String? {
        guard let colon = line.range(of: ": ") else { return nil }
        let head = String(line[..<colon.lowerBound])
        let tailStart = line[colon.upperBound...]
        guard let brace = tailStart.firstIndex(of: "{") else { return nil }
        let whereStart = tailStart.range(of: #"\bwhere\b"#, options: .regularExpression)?.lowerBound
        let boundary = whereStart.map { min($0, brace) } ?? brace
        let list = String(tailStart[..<boundary])
        let rest = String(tailStart[boundary...])
        let original = list.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        guard original.contains(parent) else { return nil }
        let parents = original.filter { $0 != parent }
        if parents.isEmpty { return head + " " + rest }
        return head + ": " + parents.joined(separator: ", ") + " " + rest
    }

    static func checkCuts() {
        let cases: [(String, String, String?)] = [
            ("public protocol P: A, B {}", "A", "public protocol P: B {}"),
            ("public protocol P: A, B {}", "Ancestor", nil),
            ("public protocol P: A\nwhere X: B, X.Y == Y {}", "A",
             "public protocol P where X: B, X.Y == Y {}"),
            ("public protocol P: A\nwhere X: B, X.Y == Y {}", "B", nil),
            ("public protocol P: A,\n    B\nwhere X == Y {}", "A",
             "public protocol P: B where X == Y {}"),
            ("public protocol P {}", "A", nil),
        ]
        for (declaration, parent, expected) in cases {
            guard cutParent(declaration, parent) == expected else {
                print("ablation: incorrect cut of \(parent) in \(declaration)")
                exit(1)
            }
        }
        let typeError = "Core.swift:4:1: error: cannot find type 'Pair' in scope"
        let faults = ["error: no space left on device", "error: emit-module command failed",
                      typeError + "\nerror: unable to write output", "failed to launch build"]
        guard isTypeRefusal(typeError), faults.allSatisfy({ !isTypeRefusal($0) }) else {
            abort("infrastructure failure was confused with a type refusal")
        }
        let scratch = FileManager.default.temporaryDirectory.appendingPathComponent("ablation-test-" + UUID().uuidString)
        do {
            try "original".write(to: scratch, atomically: true, encoding: .utf8)
            defer { try? FileManager.default.removeItem(at: scratch) }
            let result = try withCut(path: scratch.path, original: "original", cut: "cut") {
                guard (try? String(contentsOf: scratch, encoding: .utf8)) == "cut" else {
                    abort("probe did not read the cut")
                }
                return (false, "error: no space left on device")
            }
            guard !result.green, !isTypeRefusal(result.err),
                  try String(contentsOf: scratch, encoding: .utf8) == "original" else {
                abort("failed probe did not restore its source")
            }
        } catch {
            abort("restoration self-test failed: \(error)")
        }
        print("ablation: cuts, infrastructure rejection and restoration checked")
    }

    static func abort(_ message: String) -> Never {
        FileHandle.standardError.write(Data(("ablation: " + message + "\n").utf8))
        exit(1)
    }

    static func withCut(path: String, original: String, cut: String,
                        probe: () -> (green: Bool, err: String)) throws -> (green: Bool, err: String) {
        // Atomic writes preserve the last complete file if allocation fails.
        // Never begin another probe before this one has restored its source.
        try cut.write(toFile: path, atomically: true, encoding: .utf8)
        let result = probe()
        try original.write(toFile: path, atomically: true, encoding: .utf8)
        guard try String(contentsOfFile: path, encoding: .utf8) == original else {
            throw NSError(domain: "AblationRestore", code: 1)
        }
        return result
    }

    static func isTypeRefusal(_ diagnostic: String) -> Bool {
        let lower = diagnostic.lowercased()
        let infrastructure = ["no space left", "disk quota", "unable to write", "cannot write",
                              "permission denied", "please submit a bug report", "stack dump",
                              "segmentation fault", "failed to launch"]
        guard infrastructure.allSatisfy({ !lower.contains($0) }) else { return false }
        return diagnostic.range(of: #"\.swift:\d+:\d+: error:"#, options: .regularExpression) != nil
    }

    static func build(at root: URL) -> (green: Bool, err: String) {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        p.arguments = ["swift", "build", "--target", "VerificationIsIdentification"]
        p.currentDirectoryURL = root
        let pipe = Pipe()
        p.standardError = pipe
        p.standardOutput = pipe
        do {
            try p.run()
        } catch {
            return (false, "failed to launch build: \(error)")
        }
        let err = String(data: pipe.fileHandleForReading.readDataToEndOfFile(),
                         encoding: .utf8) ?? ""
        p.waitUntilExit()
        return (p.terminationStatus == 0, err)
    }

    static func refusedNames(_ err: String) -> [String] {
        var names = Set<String>()
        for line in err.components(separatedBy: "\n")
        where line.contains("error:") {
            for m in line.components(separatedBy: "'").enumerated()
            where m.offset % 2 == 1 && !m.element.isEmpty {
                names.insert(m.element)
            }
        }
        return Array(names).sorted().prefix(12).map { $0 }
    }

    static func findPackageRoot(from url: URL) -> URL {
        var dir = url.deletingLastPathComponent()
        while dir.path != "/" {
            if FileManager.default.fileExists(atPath: dir.appendingPathComponent("Package.swift").path) {
                return dir
            }
            dir = dir.deletingLastPathComponent()
        }
        return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    }
}
