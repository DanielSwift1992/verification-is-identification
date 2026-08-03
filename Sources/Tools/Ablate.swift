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
// Writes AtlasAblation.md into the docc catalog, a page of the site
// beside the Atlas, with claim and premise as symbol links. Restores every cut.
// ═══════════════════════════════════════════════════════

enum Ablate {
    struct Premise {
        let child: String
        let parent: String
        let file: String
        let line: Int
    }

    static func run(_ args: [String]) {
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
        let total = premises.count
        if let limit { premises = Array(premises.prefix(limit)) }

        if args.contains("--check") {
            check(premises, packageRoot.appendingPathComponent(
                "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/AtlasAblation.md").path)
        }

        guard build(at: packageRoot).green else {
            FileHandle.standardError.write(Data("the module does not build before any cut; fix that first\n".utf8))
            exit(1)
        }

        var rows: [(Premise, String, [String])] = []
        let started = Date()
        for p in premises {
            guard let kept = try? String(contentsOfFile: p.file, encoding: .utf8) else {
                rows.append((p, "unread", []))
                continue
            }
            var lines = kept.components(separatedBy: "\n")
            guard p.line < lines.count, let cutLine = cutParent(lines[p.line], p.parent) else {
                rows.append((p, "inherited, no line to cut", []))
                continue
            }
            lines[p.line] = cutLine
            try? lines.joined(separator: "\n").write(toFile: p.file, atomically: true, encoding: .utf8)
            let result = build(at: packageRoot)
            try? kept.write(toFile: p.file, atomically: true, encoding: .utf8)
            let refused = result.green ? [] : refusedNames(result.err)
            rows.append((p, result.green ? "still builds" : "fails", refused))
            print("\(p.child): \(p.parent) -> \(result.green ? "still builds" : "fails (\(refused.count) names)")")
        }

        let restored = build(at: packageRoot).green
        let greenRows = rows.filter { $0.1 == "still builds" }.count
        let failing = rows.filter { $0.1 == "fails" }
        let inherited = rows.filter { $0.1.hasPrefix("inherited") }.count
        let seconds = Int(-started.timeIntervalSinceNow)
        let shown = { (p: Premise) in
            p.file.replacingOccurrences(of: packageRoot.path + "/", with: "") }
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
        out.append(restored
            ? "Every file was put back after its cut, and the module builds."
            : "THE RESTORE FAILED: a file did not go back. Fix the tree before committing this page.")
        let target = packageRoot.appendingPathComponent(
            "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/AtlasAblation.md")
        try? (out.joined(separator: "\n") + "\n").write(to: target, atomically: true, encoding: .utf8)
        print("wrote docc/AtlasAblation.md, module green after restore: \(restored)")
    }


    // THE HEAD IS ONE TEXT. The page carried a head written by hand while this
    // file wrote another, so the next hour-long run would have replaced the
    // page's words with the generator's. Both now ask here, and `--check`
    // rebuilds this head from the page's own rows and refuses a difference.
    static func headLines(total: Int, needs: Int, green: Int, inherited: Int,
                          bullets: [String], seconds: String, revision: String) -> [String] {
        var out = ["# Which premises the build needs", ""]
        out.append("Each claim declares premises. This page records which of them the")
        out.append("compiler needs. Each premise was removed from its declaration, the")
        out.append("module was rebuilt, and the file was restored.")
        out.append("")
        out.append("Of \(total) premises the module needs \(needs). It builds without the other \(green),")
        out.append("and \(inherited) name a premise the compiler inherits, so they have no line to cut.")
        out.append("")
        out.append("Row format: the claim, the premise, the line where the premise is")
        out.append("declared, whether the module builds without it, and, when the build")
        out.append("fails, the symbols the compiler reports. A premise the build does not")
        out.append("need is not therefore redundant: its justification is in the papers.")
        out.append("")
        out.append("The premises the module needs:")
        out.append("")
        out += bullets
        out.append("")
        out.append("The map behind this table is <doc:Atlas>, and the cone behind every count")
        out.append("there is <doc:AtlasUnfolded>.")
        out.append("")
        out.append("The premise list is the compiler's own symbol graph, the file tree-sort")
        out.append("reads, so the lattice has one reader. The run took \(seconds)s over the")
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
                       "Sources/VerificationIsIdentification/*.swift"]
        let pipe = Pipe()
        p.standardOutput = pipe
        p.standardError = Pipe()
        try? p.run()
        let out = String(data: pipe.fileHandleForReading.readDataToEndOfFile(),
                         encoding: .utf8) ?? ""
        p.waitUntilExit()
        return out.trimmingCharacters(in: .whitespacesAndNewlines)
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

    // the declaration line names its parents after the colon; remove one,
    // keep the rest, drop the colon when the last parent goes
    static func cutParent(_ line: String, _ parent: String) -> String? {
        guard let colon = line.range(of: ": ") else { return nil }
        let head = String(line[..<colon.lowerBound])
        let tailStart = line[colon.upperBound...]
        guard let brace = tailStart.range(of: " {") ?? tailStart.range(of: "{") else { return nil }
        let list = String(tailStart[..<brace.lowerBound])
        let rest = String(tailStart[brace.lowerBound...])
        let parents = list.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && $0 != parent }
        if parents.isEmpty { return rest.hasPrefix(" ") ? head + rest : head + " " + rest }
        return head + ": " + parents.joined(separator: ", ") + rest
    }

    static func build(at root: URL) -> (green: Bool, err: String) {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        p.arguments = ["swift", "build", "--target", "VerificationIsIdentification"]
        p.currentDirectoryURL = root
        let pipe = Pipe()
        p.standardError = pipe
        p.standardOutput = pipe
        try? p.run()
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
