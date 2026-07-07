import Foundation

// ═══════════════════════════════════════════════════════
// Census counts declarations per target, so "almost no functions" is a number, not a claim.
//
// Reads comment- and string-literal-stripped source (`CodeScan.cleanedLines`, so a `func`
// spelled inside a Landing.swift CodeSample string does not count as a real declaration) and
// counts, per line, how many of the nine declaration kinds appear: protocol / enum /
// typealias / extension / struct / class / func / var / init.
//
// Usage: Tools census
// ═══════════════════════════════════════════════════════

enum Census {
    private struct Target {
        let name: String
        let paths: [String]
    }

    private static let targets: [Target] = [
        Target(name: "VerificationIsIdentification", paths: ["Sources/VerificationIsIdentification"]),
        Target(name: "DocumentKit", paths: ["Sources/DocumentKit"]),
        Target(name: "Organization", paths: ["Sources/Organization"]),
        Target(name: "Playground", paths: ["Sources/Playground"]),
        Target(name: "Tools+Plugins", paths: ["Sources/Tools", "Plugins"]),
    ]

    private static let kinds = ["protocol", "enum", "typealias", "extension", "struct", "class", "func", "var", "init"]

    private static let patterns: [String: NSRegularExpression] = [
        "protocol": try! NSRegularExpression(pattern: #"\bprotocol\s+\w"#),
        "enum": try! NSRegularExpression(pattern: #"\benum\s+\w"#),
        "typealias": try! NSRegularExpression(pattern: #"\btypealias\s+\w"#),
        "extension": try! NSRegularExpression(pattern: #"\bextension\s+\w"#),
        "struct": try! NSRegularExpression(pattern: #"\bstruct\s+\w"#),
        "class": try! NSRegularExpression(pattern: #"\bclass\s+\w"#),
        "func": try! NSRegularExpression(pattern: #"\bfunc\s+\w"#),
        "var": try! NSRegularExpression(pattern: #"\bvar\s+\w"#),
        "init": try! NSRegularExpression(pattern: #"\binit\s*[\(<]"#),
    ]

    private static func count(_ regex: NSRegularExpression, in text: String) -> Int {
        regex.numberOfMatches(in: text, range: NSRange(location: 0, length: (text as NSString).length))
    }

    // ── runtime vs non-runtime `func`. A `func` line does not execute when: (a) it
    // is a `build*` method inside a `@resultBuilder` type or an extension of one (the builder's
    // primitives, not called on a `body` that is only ever read as a type, §S7); (b) its
    // body is exactly `fatalError()` (a call-syntax door, §S7); or (c) its signature carries
    // `.Type` and its return is a metatype/`some Content` (a type-door, §S4's `Tally` exception).
    // Everything else counts as runtime: this is the one column that would flag a real leak.
    private static let typeDeclRegex = try! NSRegularExpression(
        pattern: #"^\s*(?:public\s+|private\s+|internal\s+|fileprivate\s+)?(?:final\s+)?(?:enum|struct|class|protocol|extension)\s+([A-Za-z_]\w*)"#)
    private static let funcNameRegex = try! NSRegularExpression(pattern: #"\bfunc\s+([A-Za-z_]\w*)"#)

    private static func firstCapture(_ regex: NSRegularExpression, _ text: String) -> String? {
        let ns = text as NSString
        guard let m = regex.firstMatch(in: text, range: NSRange(location: 0, length: ns.length)) else { return nil }
        let r = m.range(at: 1)
        return r.location == NSNotFound ? nil : ns.substring(with: r)
    }

    // For every `func`-matching line, is it inside a `@resultBuilder` type (or an extension of
    // one)? Tracked by net brace depth: a type declaration is pushed at the depth it opens on
    // (whichever line among its (possibly angle-expanded) declaration lines carries the `{`),
    // popped when depth returns there. `@resultBuilder` is always the line immediately above the
    // type it attaches to (checked directly across this file's own use).
    private static func resultBuilderContextByLine(_ lines: [String]) -> [Bool] {
        var context = [Bool](repeating: false, count: lines.count)
        var resultBuilderNames: Set<String> = []
        var sawAttribute = false
        var stack: [(name: String, popAtDepth: Int)] = []
        var depth = 0
        for (idx, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if let name = firstCapture(typeDeclRegex, line) {
                if sawAttribute { resultBuilderNames.insert(name) }
                stack.append((name, depth))
            }
            if !trimmed.isEmpty { sawAttribute = (trimmed == "@resultBuilder") }
            context[idx] = stack.last.map { resultBuilderNames.contains($0.name) } ?? false
            depth += line.filter { $0 == "{" }.count
            depth -= line.filter { $0 == "}" }.count
            while let top = stack.last, depth <= top.popAtDepth { stack.removeLast() }
        }
        return context
    }

    // A func-matching line's window: the rest of its (possibly angle-expanded) signature
    // and body, joined, to read `.Type`/`fatalError()`/`some ` past whichever line the closing
    // `{` actually falls on (SurfaceLint's `isTypeDoor` fix, the same reason).
    private static func window(_ lines: [String], from idx: Int, span: Int = 10) -> String {
        lines[idx..<min(idx + span, lines.count)].joined(separator: " ")
    }

    private static func isNonRuntime(_ lines: [String], idx: Int, builderContext: [Bool]) -> Bool {
        let name = firstCapture(funcNameRegex, lines[idx]) ?? ""
        if builderContext[idx], name.hasPrefix("build") { return true }
        // (d) the layout era's second witness form: `static func rendered<…>` is `typeName`
        // with type holes (Spanning/Divides, Vector.swift), read at generation like every
        // witness, never shipped. The lint's renderedWitnessRegex names the same exemption.
        if name == "rendered", lines[idx].contains("static func rendered") { return true }
        let w = window(lines, from: idx)
        if w.contains("{ fatalError() }") { return true }
        // (c) a type-door: `.Type` somewhere in the signature (a metatype parameter), AND the
        // return, after the LAST `->` before the body's `{`, is itself a metatype or `some `.
        if w.contains(".Type"), let arrow = w.range(of: "-> ", options: .backwards) {
            let afterArrow = w[arrow.upperBound...]
            let returnType = afterArrow.prefix(while: { $0 != "{" })
            if returnType.hasPrefix("some ") || returnType.contains(".Type") { return true }
        }
        return false
    }

    private static func swiftFiles(under path: String) -> [String] {
        let fm = FileManager.default
        var isDirectory: ObjCBool = false
        guard fm.fileExists(atPath: path, isDirectory: &isDirectory) else { return [] }
        guard isDirectory.boolValue else { return path.hasSuffix(".swift") ? [path] : [] }
        var files: [String] = []
        let enumerator = fm.enumerator(atPath: path)
        while let relative = enumerator?.nextObject() as? String {
            if relative.hasSuffix(".swift") {
                files.append((path as NSString).appendingPathComponent(relative))
            }
        }
        return files
    }

    private static func tally(_ target: Target) -> (counts: [String: Int], runtimeFunc: Int) {
        var counts: [String: Int] = [:]
        for kind in kinds { counts[kind] = 0 }
        var runtimeFunc = 0
        for path in target.paths.flatMap(swiftFiles) {
            guard let contents = try? String(contentsOfFile: path, encoding: .utf8) else { continue }
            let lines = CodeScan.cleanedLines(of: contents)
            for line in lines {
                for kind in kinds {
                    counts[kind]! += count(patterns[kind]!, in: line)
                }
            }
            let builderContext = resultBuilderContextByLine(lines)
            for idx in lines.indices
            where matches(patterns["func"]!, lines[idx]) {
                if !isNonRuntime(lines, idx: idx, builderContext: builderContext) { runtimeFunc += 1 }
            }
        }
        return (counts, runtimeFunc)
    }

    private static func matches(_ regex: NSRegularExpression, _ text: String) -> Bool {
        regex.firstMatch(in: text, range: NSRange(location: 0, length: (text as NSString).length)) != nil
    }

    // ── `--emit <path>`: the census as atoms, regenerated by the CensusGen plugin on every
    // build, so a page can wear the numbers and "counted at build" is literal. The same
    // generation pattern as the roster and the prose: a source is read, Swift is written,
    // the reader is a type. ──
    private static let atomTarget: [String: String] = [
        "VerificationIsIdentification": "Lattice",
        "DocumentKit": "Engine",
        "Organization": "Company",
        "Tools+Plugins": "Tooling",
    ]

    static func emit(to path: String) {
        var o = [
            "import VerificationIsIdentification", "",
            "// GENERATED at build by the CensusGen plugin: the census, spelled as atoms, so a",
            "// page wears the numbers the build just counted and a claim cannot go stale.", "",
        ]
        for target in targets {
            guard let short = atomTarget[target.name] else { continue }
            let (counts, runtimeFunc) = tally(target)
            let types = (counts["protocol"] ?? 0) + (counts["enum"] ?? 0)
            for (word, value) in [
                ("Types", types),
                ("RuntimeFunctions", runtimeFunc),
                ("Structs", counts["struct"] ?? 0),
                ("Classes", counts["class"] ?? 0),
            ] {
                o += ["public enum Census\(short)\(word): Close {}",
                      "extension Census\(short)\(word) {",
                      "    public static var typeName: String { \"\(value)\" }",
                      "}"]
            }
        }
        try? (o.joined(separator: "\n") + "\n").write(toFile: path, atomically: true, encoding: .utf8)
        print("census: emitted atoms to \(path)")
    }

    static func run(_ args: [String]) {
        if args.first == "--emit", args.count > 1 {
            emit(to: args[1])
            return
        }
        var lines: [String] = []
        lines.append("| Target | protocol | enum | typealias | extension | struct | class | func | runtime func | var | init |")
        lines.append("| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |")
        for target in targets {
            let (counts, runtimeFunc) = tally(target)
            let before = kinds.prefix(while: { $0 != "var" }).map { String(counts[$0]!) }
            let after = kinds.drop(while: { $0 != "var" }).map { String(counts[$0]!) }
            let cells = (before + [String(runtimeFunc)] + after).joined(separator: " | ")
            lines.append("| \(target.name) | \(cells) |")
        }
        lines.append("")
        lines.append("Zero RUNTIME functions in the law's rows is the point: every `func` they carry")
        lines.append("is builder machinery or a call-syntax door, and none of it ever executes — a")
        lines.append("body exists to be read as a type, never run (§S7). What executes lives in the")
        lines.append("tooling row, and the census keeps it beside the system for scale. Playground's")
        lines.append("one is `machineName`, the scheduler demo's own reader — the value the README")
        lines.append("prints — beside its ordinary-Swift witnesses. Zero structs and zero classes")
        lines.append("are the law itself (Law §0′, SurfaceLaw §S2).")

        let output = lines.joined(separator: "\n")
        print(output)
        if let summaryPath = ProcessInfo.processInfo.environment["GITHUB_STEP_SUMMARY"], !summaryPath.isEmpty {
            let data = Data((output + "\n").utf8)
            if let handle = FileHandle(forWritingAtPath: summaryPath) {
                handle.seekToEndOfFile()
                handle.write(data)
                handle.closeFile()
            } else {
                try? data.write(to: URL(fileURLWithPath: summaryPath))
            }
        }
    }
}
