import Foundation

// GenerateFont reads the stated font file itself (Assets/InterVariable.ttf, the primary
// voice of `FontStack`) and spells its metrics into atoms — the same generation pattern as
// the roster and the prose: a source in the repository, a parser in Tools, checked-in
// Swift whose reader is a type. What is read is the sfnt truth, not an estimate: the
// character-to-glyph map (`cmap`) and the horizontal advances (`hmtx`), in the font's own
// units (`head`). A variable font's `hmtx` carries its default instance, which for Inter
// is Regular — the weight the canvases set.
enum GenerateFont {
    private struct Reader {
        let data: Data
        func u16(_ offset: Int) -> Int {
            Int(data[offset]) << 8 | Int(data[offset + 1])
        }
        func u32(_ offset: Int) -> Int {
            u16(offset) << 16 | u16(offset + 2)
        }
        func tag(_ offset: Int) -> String {
            String(bytes: data[offset..<offset + 4], encoding: .ascii) ?? ""
        }
    }

    // The codepoints the canvases actually speak: printable ASCII, the Latin-1 supplement,
    // and the handful of punctuation the pages use (dashes, quotes, the ellipsis, the
    // interpunct, the arrow). A character outside the set measures as an "m".
    private static let codepoints: [Int] =
        Array(0x20...0x7E) + Array(0xA0...0xFF)
            + [0x2013, 0x2014, 0x2018, 0x2019, 0x201C, 0x201D, 0x2026, 0x2192]

    static func run(_ args: [String]) {
        let fontPath = args.first ?? "Assets/InterVariable.ttf"
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: fontPath)) else {
            FileHandle.standardError.write(Data("cannot read \(fontPath)\n".utf8))
            exit(2)
        }
        let font = Reader(data: data)

        // ── the table directory ──
        var tables: [String: Int] = [:]
        let numTables = font.u16(4)
        for index in 0..<numTables {
            let record = 12 + 16 * index
            tables[font.tag(record)] = font.u32(record + 8)
        }
        guard let head = tables["head"], let hhea = tables["hhea"],
              let hmtx = tables["hmtx"], let cmap = tables["cmap"] else {
            FileHandle.standardError.write(Data("\(fontPath) is missing a required table\n".utf8))
            exit(2)
        }
        let unitsPerEm = font.u16(head + 18)
        let numberOfHMetrics = font.u16(hhea + 34)
        // OS/2 carries the capital height (version 2 and later), the one vertical the
        // centred baseline derives from.
        let capHeight = tables["OS/2"].map { font.u16($0 + 88) } ?? 0

        // ── cmap: prefer the full-repertoire format 12 subtable, fall back to format 4 ──
        var subtable = 0
        var preferred = -1
        let cmapCount = font.u16(cmap + 2)
        for index in 0..<cmapCount {
            let record = cmap + 4 + 8 * index
            let platform = font.u16(record)
            let encoding = font.u16(record + 2)
            let offset = cmap + font.u32(record + 4)
            let format = font.u16(offset)
            let rank: Int
            switch (platform, encoding, format) {
            case (3, 10, 12): rank = 3
            case (0, _, 12): rank = 2
            case (3, 1, 4): rank = 1
            case (0, _, 4): rank = 0
            default: rank = -1
            }
            if rank > preferred {
                preferred = rank
                subtable = offset
            }
        }
        guard preferred >= 0 else {
            FileHandle.standardError.write(Data("\(fontPath): no usable cmap subtable\n".utf8))
            exit(2)
        }

        func glyph(for codepoint: Int) -> Int {
            let format = font.u16(subtable)
            if format == 12 {
                let groups = font.u32(subtable + 12)
                for group in 0..<groups {
                    let record = subtable + 16 + 12 * group
                    let start = font.u32(record)
                    let end = font.u32(record + 4)
                    if codepoint >= start && codepoint <= end {
                        return font.u32(record + 8) + (codepoint - start)
                    }
                }
                return 0
            }
            // format 4: segment arrays, the classic sixteen-bit map
            let segCountX2 = font.u16(subtable + 6)
            let endCodes = subtable + 14
            let startCodes = endCodes + segCountX2 + 2
            let idDeltas = startCodes + segCountX2
            let idRangeOffsets = idDeltas + segCountX2
            for segment in stride(from: 0, to: segCountX2, by: 2) {
                let end = font.u16(endCodes + segment)
                guard codepoint <= end else { continue }
                let start = font.u16(startCodes + segment)
                guard codepoint >= start else { return 0 }
                let rangeOffset = font.u16(idRangeOffsets + segment)
                if rangeOffset == 0 {
                    return (codepoint + font.u16(idDeltas + segment)) & 0xFFFF
                }
                let glyphAt = idRangeOffsets + segment + rangeOffset + 2 * (codepoint - start)
                let raw = font.u16(glyphAt)
                return raw == 0 ? 0 : (raw + font.u16(idDeltas + segment)) & 0xFFFF
            }
            return 0
        }

        func advance(forGlyph glyphId: Int) -> Int {
            let index = min(glyphId, numberOfHMetrics - 1)
            return font.u16(hmtx + 4 * index)
        }

        // ── the atoms ──
        var pairs: [String] = []
        for codepoint in codepoints {
            let glyphId = glyph(for: codepoint)
            guard glyphId != 0 || codepoint == 0x20 else { continue }
            pairs.append("\(codepoint):\(advance(forGlyph: glyphId))")
        }
        let o = [
            "import VerificationIsIdentification", "",
            "// GENERATED by `swift run Tools generate font` from \(fontPath): the stated",
            "// font's own metrics, spelled as atoms. `FontAdvanceTable` is codepoint:advance",
            "// pairs in font units; `TextWidth` (Vector.swift) is the one reader.", "",
            "public enum FontUnitsPerEm: Close {}",
            "extension FontUnitsPerEm {",
            "    public static var typeName: String { \"\(unitsPerEm)\" }",
            "}",
            "public enum FontCapHeight: Close {}",
            "extension FontCapHeight {",
            "    public static var typeName: String { \"\(capHeight)\" }",
            "}",
            "public enum FontAdvanceTable: Close {}",
            "extension FontAdvanceTable {",
            "    public static var typeName: String {",
            "        \"\(pairs.joined(separator: " "))\"",
            "    }",
            "}",
        ]
        try? (o.joined(separator: "\n") + "\n").write(
            toFile: "Sources/DocumentKit/GeneratedFontMetrics.swift", atomically: true, encoding: .utf8)
        print("generated font metrics: \(pairs.count) advances, cap \(capHeight) of \(unitsPerEm) units per em (\(fontPath))")
    }
}
