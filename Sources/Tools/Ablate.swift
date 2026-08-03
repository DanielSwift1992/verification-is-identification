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
        let limit = args.count > 1 ? Int(args[1]) : nil
        let root = URL(fileURLWithPath: graphPath)
        let packageRoot = findPackageRoot(from: root)

        var byId: [String: Symbol] = [:]
        for s in graph.symbols { byId[s.identifier.precise] = s }
        var premises: [Premise] = []
        for r in graph.relationships where r.kind == "conformsTo" {
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

        guard build(at: packageRoot).green else {
            FileHandle.standardError.write(Data("the module does not build before any cut; fix that first\n".utf8))
            exit(1)
        }

        var rows: [(Premise, String, [String])] = []
        let started = Date()
        for p in premises {
            guard let kept = try? String(contentsOfFile: p.file, encoding: .utf8) else {
                rows.append((p, "unread", [])); continue
            }
            var lines = kept.components(separatedBy: "\n")
            guard p.line < lines.count, let cutLine = cutParent(lines[p.line], p.parent) else {
                rows.append((p, "nothing to cut: inherited, not written", [])); continue
            }
            lines[p.line] = cutLine
            try? lines.joined(separator: "\n").write(toFile: p.file, atomically: true, encoding: .utf8)
            let result = build(at: packageRoot)
            try? kept.write(toFile: p.file, atomically: true, encoding: .utf8)
            let refused = result.green ? [] : refusedNames(result.err)
            rows.append((p, result.green ? "builds green" : "build fails", refused))
            print("\(p.child): \(p.parent) -> \(result.green ? "builds green" : "build fails (\(refused.count) names)")")
        }

        let restored = build(at: packageRoot).green
        var out = ["# Which premises the build needs", ""]
        out.append("Cut \(rows.count) of \(total) premises, one at a time, in "
                   + "\(Int(-started.timeIntervalSinceNow))s. "
                   + "Rerun it yourself: `swift build --product Tools && .build/debug/Tools "
                   + "ablate <symbols.json>`; the graph file sits under "
                   + "`.build/*/extracted-symbols/`. "
                   + "The premise list is the compiler's own symbol graph, the file tree-sort")
        out.append("reads, so the lattice has one reader. Each row cuts one declared premise,")
        out.append("rebuilds the core module, and restores the file. `build fails` lists the")
        out.append("names the compiler refused without the premise. `builds green` says the")
        out.append("module compiles without it: the premise still carries meaning for a")
        out.append("reader, and the papers, not this table, argue it.")
        out.append("")
        out.append("| claim | premise | declared at | build without it | names refused |")
        out.append("|---|---|---|---|---|")
        for (p, verdict, refused) in rows {
            let rel = p.file.replacingOccurrences(of: packageRoot.path + "/", with: "")
            out.append("| ``\(p.child)`` | ``\(p.parent)`` | \(rel):\(p.line + 1) "
                       + "| \(verdict) | \(refused.joined(separator: ", ")) |")
        }
        out.append("")
        out.append("The module builds green after the last restoration: \(restored).")
        let target = packageRoot.appendingPathComponent(
            "Sources/VerificationIsIdentification/VerificationIsIdentification.docc/AtlasAblation.md")
        try? (out.joined(separator: "\n") + "\n").write(to: target, atomically: true, encoding: .utf8)
        print("wrote docc/AtlasAblation.md, module green after restore: \(restored)")
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
        for line in err.components(separatedBy: "\n") where line.contains("error:") {
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
