// Surface-history citations are historical scope, not current SDK contracts.
// Source: vi@f95b6c69d5ad49ede6cf953b8be42e725bde6ba6 Sources/DocumentKit/SurfaceLaw.swift; SHA-256 d51b07d4195eddee64d0a3e7daf91dc6667bc4c79665c53249222b8350dc4881.
import Foundation

// ═══════════════════════════════════════════════════════
// Census counts declarations per target, so "almost no functions" is a number, not a claim.
//
// Reads comment- and string-literal-stripped source (`CodeScan.cleanedLines`, so a `func`
// spelled inside a Landing.swift CodeSample string does not count as a real declaration) and
// counts, per line, how many of the nine declaration kinds appear: protocol / enum /
// typealias / extension / struct / class / func / var / init.
//
// Usage: Tools census [--target <Name>[:<Atom>]=<path>[,<path>…]]… [--emit <path>]
//
// Without --target the census counts this repository's own targets, as it always has.
// With one or more, it counts exactly the named paths, and a path that does not exist is
// refused: a dependent package (the showcase, T-0015) counts its own targets and the
// theory's checkout by name instead of carrying a second census.
// ═══════════════════════════════════════════════════════

enum Census {
    private struct Target {
        let name: String
        let paths: [String]
    }

    private static let targets: [Target] = [
        Target(name: "Notation", paths: ["Sources/Notation"]),
        Target(name: "Alphabet", paths: ["Sources/Alphabet"]),
        Target(name: "DocumentKit", paths: ["Sources/DocumentKit"]),
        Target(name: "DocumentKitCertificates", paths: ["Sources/DocumentKitCertificates"]),
        Target(name: "DocumentKitDemo", paths: ["Sources/DocumentKitDemo"]),
        Target(name: "FontMetrics", paths: ["Sources/FontMetrics"]),
        Target(name: "VerificationIsIdentification", paths: ["Sources/VerificationIsIdentification"]),
        Target(name: "Examples", paths: ["Sources/Examples"]),
        Target(name: "Court", paths: ["Sources/Court"]),
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
    // primitives, not called on a `body` that is only ever read as a type, [Surface history S7](https://github.com/DanielSwift1992/verification-is-identification/blob/f95b6c69d5ad49ede6cf953b8be42e725bde6ba6/Sources/DocumentKit/SurfaceLaw.swift#L113)); (b) its
    // body is exactly `fatalError()` (a call-syntax door, [Surface history S7](https://github.com/DanielSwift1992/verification-is-identification/blob/f95b6c69d5ad49ede6cf953b8be42e725bde6ba6/Sources/DocumentKit/SurfaceLaw.swift#L113)); or (c) its signature carries
    // `.Type` and its return is a metatype/`some Content` (a type-door, [Surface history S4](https://github.com/DanielSwift1992/verification-is-identification/blob/f95b6c69d5ad49ede6cf953b8be42e725bde6ba6/Sources/DocumentKit/SurfaceLaw.swift#L65)'s `Tally` exception).
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
        "Court": "Court",
        "Tools+Plugins": "Tooling",
    ]

    // The targets and atom names this run counts: the repository's own table, or exactly
    // the `--target` flags, which the rest of the arguments no longer carry.
    private static func selection(_ args: [String]) -> (targets: [Target], atoms: [String: String], rest: [String]) {
        var chosen: [Target] = []
        var atoms: [String: String] = [:]
        var rest: [String] = []
        var index = 0
        while index < args.count {
            guard args[index] == "--target" else {
                rest.append(args[index])
                index += 1
                continue
            }
            guard index + 1 < args.count, let equals = args[index + 1].firstIndex(of: "=") else {
                FileHandle.standardError.write(Data("census: --target needs <Name>[:<Atom>]=<path>[,<path>…]\n".utf8))
                exit(2)
            }
            let label = args[index + 1][..<equals].split(separator: ":", maxSplits: 1).map(String.init)
            let paths = args[index + 1][args[index + 1].index(after: equals)...].split(separator: ",").map(String.init)
            guard label.isEmpty == false, label[0].isEmpty == false, paths.isEmpty == false else {
                FileHandle.standardError.write(Data("census: --target needs a name and at least one path\n".utf8))
                exit(2)
            }
            for path in paths
            where FileManager.default.fileExists(atPath: path) == false {
                FileHandle.standardError.write(Data("census: cannot read \(path) for target \(label[0])\n".utf8))
                exit(2)
            }
            chosen.append(Target(name: label[0], paths: paths))
            if label.count == 2 { atoms[label[0]] = label[1] }
            index += 2
        }
        return chosen.isEmpty ? (targets, atomTarget, rest) : (chosen, atoms, rest)
    }

    private static func emit(to path: String, targets: [Target], atoms: [String: String]) {
        var o = [
            "import VerificationIsIdentification", "",
            "// GENERATED at build by the CensusGen plugin: the census, spelled as atoms, so a",
            "// page wears the numbers the build just counted and a claim cannot go stale.", "",
        ]
        for target in targets {
            guard let short = atoms[target.name] else { continue }
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

    static func run(_ arguments: [String]) {
        let (targets, atoms, args) = selection(arguments)
        if args.first == "--emit", args.count > 1 {
            emit(to: args[1], targets: targets, atoms: atoms)
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
        lines.append("body exists to be read as a type, never run ([Surface history S7](https://github.com/DanielSwift1992/verification-is-identification/blob/f95b6c69d5ad49ede6cf953b8be42e725bde6ba6/Sources/DocumentKit/SurfaceLaw.swift#L113)). What executes lives in the")
        lines.append("Court, tooling and driver rows, beside the system for scale. The one in")
        lines.append("Examples is `machineName`, the scheduler demo's own reader — the value the Encoding")
        lines.append("page prints — beside its ordinary-Swift witnesses. Zero structs and zero classes")
        lines.append("are the law itself (Law §0′, SurfaceLaw [Surface history S2](https://github.com/DanielSwift1992/verification-is-identification/blob/f95b6c69d5ad49ede6cf953b8be42e725bde6ba6/Sources/DocumentKit/SurfaceLaw.swift#L37)).")

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
