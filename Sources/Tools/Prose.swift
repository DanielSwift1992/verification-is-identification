import Alphabet
import Foundation
import RegexBuilder

// ═══════════════════════════════════════════════════════
// PROSE names spelling text from atoms, generated at build time by the ProseGen plugin.
//
// Reads Sources/Organization/Prose.json (a flat {key: template} object, tracked in source
// control, the actual content, the same shape as a Swift string catalog) and writes two Swift
// files into the plugin's work directory (not committed, regenerated every build, the SPM
// way, the same shape as LawCheck/TreeSort): the alphabet (one `Glyph` atom per Unicode scalar
// actually used, so it is always exactly as big as the content needs) and the prose types (one
// `Open` type per entry, its `body` spelling the template in glyphs; a `{hole}` becomes a
// generic parameter, filled at the call site through the type's `init`:
// `OwnersLine { A.self; B.self; C.self; D.self }`, the same `init`-is-the-door convention every
// DocumentKit combinator uses (Markup.swift)). Entries are sorted by key before being written,
// so the generated file's order does not depend on the JSON object's (unspecified) decoding
// order.
// ═══════════════════════════════════════════════════════

enum Segment {
    case text(Substring)
    case hole(Substring)
}

private let holeName = Reference(Substring.self)
private let holeRegex = Regex {
    "{"
    Capture(as: holeName) { OneOrMore(.word) }
    "}"
}

func segments(of template: String) -> [Segment] {
    var result: [Segment] = []
    var cursor = template.startIndex
    for match in template.matches(of: holeRegex) {
        if match.range.lowerBound > cursor {
            result.append(.text(template[cursor..<match.range.lowerBound]))
        }
        result.append(.hole(match[holeName]))
        cursor = match.range.upperBound
    }
    if cursor < template.endIndex {
        result.append(.text(template[cursor...]))
    }
    return result
}

func holes(of template: String) -> [String] {
    var seen: [String] = []
    for segment in segments(of: template) {
        if case .hole(let name) = segment, !seen.contains(String(name)) { seen.append(String(name)) }
    }
    return seen
}

// The common alphabet: letters/digits named by hand (DocumentKit/Alphabet.swift, the stream
// never needs them one at a time); punctuation and medium READ from the shared `Alphabet`
// registry, the same declarations GrammarLexicon's mirror classifies
// by, so a name cannot drift into a silent, unnoticed typo the way a second hand-written
// copy of this table once could. A scalar outside both (an em dash, …) is not an error, it
// falls back to a code-point atom, generated on demand (below), only readability is traded
// away for the rare case, not coverage.
let baseAlphabet: [Unicode.Scalar: String] = {
    var table: [Unicode.Scalar: String] = [:]
    for c in "abcdefghijklmnopqrstuvwxyz" { table[c.unicodeScalars.first!] = "Letter.\(c)" }
    for c in "abcdefghijklmnopqrstuvwxyz" {
        table[Unicode.Scalar(String(c).uppercased())!] = "Cap<Letter.\(c)>"
    }
    for (i, c) in "0123456789".enumerated() { table[c.unicodeScalars.first!] = "TextDigit._\(i)" }
    for lexeme in Alphabet.lexemes
    where lexeme is any Glyph.Type {
        table[lexeme.glyph.unicodeScalars.first!] = String(describing: lexeme)
    }
    return table
}()

func glyphName(_ scalar: Unicode.Scalar) -> String { "Char\(scalar.value)" }

/// This gives a hole's name, capitalized: the generic parameter a hole becomes (`ratio` ->
/// `Ratio`), so a door function's lowercase parameter name does not collide with its type.
func capitalizeFirst(_ s: String) -> String { s.prefix(1).uppercased() + s.dropFirst() }

/// This names the reference a leaf uses for one scalar: the hand-named base atom if it is
/// common, else the generated code-point atom.
func glyphReference(_ scalar: Unicode.Scalar) -> String { baseAlphabet[scalar] ?? glyphName(scalar) }

/// This gives a Swift string-literal spelling of one scalar: explicit, not `debugDescription`
/// (whose escaping format is not a documented contract), so the generated `typeName` always
/// compiles to exactly the character asked for.
func swiftLiteral(_ scalar: Unicode.Scalar) -> String {
    switch scalar {
    case "\\": return "\"\\\\\""
    case "\"": return "\"\\\"\""
    case "\n": return "\"\\n\""
    case "\t": return "\"\\t\""
    case "\r": return "\"\\r\""
    default: return "\"\(String(scalar))\""
    }
}

/// `holeRefs` maps each hole's original name to the Swift expression that reads it: the bare
/// (capitalized) generic parameter name for a single-hole entry, or a `Whole.Left...` path for a
/// multi-hole one (see `holePath(_:of:)` below).
func leaves(of template: String, holeRefs: [String: String]) -> [String] {
    segments(of: template).flatMap { segment -> [String] in
        switch segment {
        case .text(let run): return run.unicodeScalars.map { glyphReference($0) + ".self" }
        case .hole(let name): return ["\(holeRefs[String(name)]!).self"]
        }
    }
}

/// This appends a `body`'s leaves, 8 to a line: the shared chunking every entry's `body` uses.
func appendLeaves(_ ls: [String], to o: inout [String]) {
    for chunk in stride(from: 0, to: ls.count, by: 8) {
        let line = ls[chunk..<min(chunk + 8, ls.count)].map { "\($0);" }.joined(separator: " ")
        o.append("        " + line)
    }
}

// ── Multi-hole types: one `@StructureBuilder` init parameter, not a multi-parameter one. ──
//
// The builder folds N statements left-associatively into nested `Paired`s (`buildPartialBlock`,
// VerificationIsIdentification/Primitive.swift): for holes s1…sN, the fold is
// `Paired<Paired<…Paired<s1,s2>…,s(N-1)>,sN>`. A single generic parameter `Whole` captures
// whatever the builder produces; each hole is read back off `Whole` by a `.Left`/`.Right` path.

/// This gives the `.Left`/`.Right` path from `Whole` down to the `k`-th (1-indexed) hole of `n`.
func holePath(_ k: Int, of n: Int) -> [String] {
    if k == 1 { return Array(repeating: "Left", count: n - 1) }
    return Array(repeating: "Left", count: n - k) + ["Right"]
}

/// This gives the `: Pair` constraints keeping every intermediate node's `.Left`/`.Right`
/// accessible, down to the second-to-last nesting level (the leaves below need only `: Structure`).
func pairConstraints(_ n: Int) -> [String] {
    (0...(n - 2)).map { depth in
        (["Whole"] + Array(repeating: "Left", count: depth)).joined(separator: ".") + ": Pair"
    }
}

/// This gives the `: Structure` constraint for each of the `n` holes, at its `Whole`-relative path.
func structureConstraints(_ n: Int) -> [String] {
    (1...n).map { k in (["Whole"] + holePath(k, of: n)).joined(separator: ".") + ": Structure" }
}

enum ProseGenTool {
    static func run(_ args: [String]) {
        guard args.count == 3 else {
            FileHandle.standardError.write(Data("usage: Tools prose <Prose.json> <GeneratedProse.swift out> <GeneratedAlphabet.swift out>\n".utf8))
            exit(2)
        }
        let (jsonPath, proseOut, alphabetOut) = (args[0], args[1], args[2])
        guard let data = FileManager.default.contents(atPath: jsonPath) else {
            FileHandle.standardError.write(Data("cannot read \(jsonPath)\n".utf8))
            exit(1)
        }
        let table: [String: String]
        do {
            table = try JSONDecoder().decode([String: String].self, from: data)
        } catch {
            FileHandle.standardError.write(Data("cannot parse \(jsonPath): \(error)\n".utf8))
            exit(1)
        }
        let entries = table.sorted { $0.key < $1.key }.map { (key: $0.key, template: $0.value) }

        // ── The alphabet: one atom per Unicode scalar actually used AND not already named by
        //    hand (DocumentKit/Alphabet.swift), the overflow only, in scalar order. ──
        var used = Set<Unicode.Scalar>()
        for entry in entries {
            for segment in segments(of: entry.template) {
                if case .text(let run) = segment {
                    used.formUnion(run.unicodeScalars.filter { baseAlphabet[$0] == nil })
                }
            }
        }
        var a = ["import Alphabet", "import VerificationIsIdentification", "import DocumentKit", "",
                 "// GENERATED by the ProseGen plugin from Sources/Organization/Prose.json: do not edit.",
                 "// One atom per Unicode scalar actually used in prose, named by its scalar value.", ""]
        for scalar in used.sorted(by: { $0.value < $1.value }) {
            let name = glyphName(scalar)
            a.append("enum \(name): Glyph {}")
            a.append("extension \(name) { static var typeName: String { \(swiftLiteral(scalar)) } }")
        }
        try? a.joined(separator: "\n").appending("\n").write(toFile: alphabetOut, atomically: true, encoding: .utf8)

        // ── The prose types, spelled from the alphabet above. A hole becomes a generic
        //    parameter; the type's `init` is the door: a call site fills holes via `{ }`,
        //    not `<>`, the same convention DocumentKit's combinators use (Markup.swift). ──
        var o = ["import Alphabet", "import VerificationIsIdentification", "import DocumentKit", "",
                 "// GENERATED by the ProseGen plugin from Sources/Organization/Prose.json: do not edit.",
                 "// Every character is a real Glyph atom (GeneratedAlphabet.swift); a hole ({name} in",
                 "// the template) is a generic parameter, filled by a real Structure at the call site.", ""]
        for entry in entries {
            let hs = holes(of: entry.template)
            switch hs.count {
            case 0:
                o.append("enum \(entry.key): Prose {")
                o.append("    @StructureBuilder static var body: some Structure {")
                appendLeaves(leaves(of: entry.template, holeRefs: [:]), to: &o)
                o.append("    }")
                o.append("}")
            case 1:
                // One hole: a plain `@StructureBuilder` init parameter, the same shape every
                // DocumentKit combinator's `init` uses.
                let typeParam = capitalizeFirst(hs[0])
                o.append("enum \(entry.key)<\(typeParam): Structure>: Prose {")
                o.append("    init(@StructureBuilder _ \(hs[0]): () -> \(typeParam)) { fatalError() }")
                o.append("    @StructureBuilder static var body: some Structure {")
                appendLeaves(leaves(of: entry.template, holeRefs: [hs[0]: typeParam]), to: &o)
                o.append("    }")
                o.append("}")
            default:
                // N holes (N >= 2): ONE `@StructureBuilder` init parameter listing them as N
                // statements; the builder folds them into nested `Paired`s, and each hole is read
                // back off the single `Whole` generic parameter by its `.Left`/`.Right` path.
                let n = hs.count
                var holeRefs: [String: String] = [:]
                for (k, hole) in hs.enumerated() {
                    holeRefs[hole] = (["Whole"] + holePath(k + 1, of: n)).joined(separator: ".")
                }
                let constraints = (pairConstraints(n) + structureConstraints(n)).joined(separator: ", ")
                o.append("enum \(entry.key)<Whole: Pair>: Prose where \(constraints) {")
                o.append("    init(@StructureBuilder _ content: () -> Whole) { fatalError() }")
                o.append("    @StructureBuilder static var body: some Structure {")
                appendLeaves(leaves(of: entry.template, holeRefs: holeRefs), to: &o)
                o.append("    }")
                o.append("}")
            }
            o.append("")
        }
        try? o.joined(separator: "\n").write(toFile: proseOut, atomically: true, encoding: .utf8)

        print("prose: \(used.count) alphabet atoms + \(entries.count) prose strings")
    }
}
