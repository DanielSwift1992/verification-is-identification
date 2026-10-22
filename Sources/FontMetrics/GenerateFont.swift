import Foundation
#if canImport(CoreText)
import CoreText
#endif

// GenerateFont reads the stated font file itself (Assets/InterVariable.ttf, the primary
// voice of `FontStack`) and spells its metrics into atoms — the same generation pattern as
// the roster and the prose: a source in the repository, a parser in FontMetrics, checked-in
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
        let outlines = args.first == "--outlines"
        let coverage = args.first == "--coverage"
        if (outlines || coverage) && (args.count < 4 || (args.count - 4) % 2 != 0) {
            fputs("usage: FontMetrics --outlines|--coverage <font> <utf8-corpus> <output> [--name <atom>] [--source <atom>] [--weight <wght>]\n", stderr)
            exit(2)
        }
        let fontPath = (outlines || coverage) ? args[1] : (args.first ?? "Assets/InterVariable.ttf")
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
        let capHeight = tables["OS/2"].map { font.u16($0) >= 2 ? font.u16($0 + 88) : 0 } ?? 0

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

        if coverage {
            do {
                let corpus = try String(contentsOfFile: args[2], encoding: .utf8)
                let codes = Set(corpus.unicodeScalars.filter { !CharacterSet.newlines.contains($0) }.map { Int($0.value) }).sorted()
                let report: [String: Any] = ["unitsPerEm": unitsPerEm, "glyphs": codes.map { ["codepoint": $0, "glyph": glyph(for: $0)] }]
                try JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys]).write(to: URL(fileURLWithPath: args[3]), options: .atomic)
            } catch {
                fputs("FontMetrics: \(error.localizedDescription)\n", stderr)
                exit(2)
            }
            return
        }

        if outlines {
            #if canImport(CoreText)
            do {
                let corpus = try String(contentsOfFile: args[2], encoding: .utf8)
                let codes = Set(corpus.unicodeScalars.filter { !CharacterSet.newlines.contains($0) }.map { Int($0.value) }).sorted()
                guard !codes.isEmpty, let provider = CGDataProvider(data: data as CFData),
                      let graphics = CGFont(provider) else {
                    throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "empty corpus or invalid font: \(fontPath)"])
                }
                var name = "FigureFont"
                var source = "FontFile"
                var requestedWeight: Double?
                for index in stride(from: 4, to: args.count, by: 2) {
                    switch args[index] {
                    case "--name": name = args[index + 1]
                    case "--source": source = args[index + 1]
                    case "--weight":
                        guard let value = Double(args[index + 1]), value.isFinite else {
                            throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "invalid wght value: \(args[index + 1])"])
                        }
                        requestedWeight = value
                    default: throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "unknown outline option: \(args[index])"])
                    }
                }
                guard [name, source].allSatisfy({ $0.range(of: "^[A-Za-z][A-Za-z0-9]*$", options: .regularExpression) != nil }) else {
                    throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "invalid outline atom: \(name)"])
                }
                let base = CTFontCreateWithGraphicsFont(graphics, CGFloat(unitsPerEm), nil, nil)
                let axes = (CTFontCopyVariationAxes(base) as? [[String: Any]]) ?? []
                var coordinates: [NSNumber: NSNumber] = [:]
                var axisReport: [[String: Any]] = []
                for axis in axes {
                    let identifier = axis[kCTFontVariationAxisIdentifierKey as String] as! NSNumber
                    let minimum = axis[kCTFontVariationAxisMinimumValueKey as String] as! NSNumber
                    let maximum = axis[kCTFontVariationAxisMaximumValueKey as String] as! NSNumber
                    let standard = axis[kCTFontVariationAxisDefaultValueKey as String] as! NSNumber
                    let value = identifier.intValue == 0x77676874 ? (requestedWeight ?? standard.doubleValue) : standard.doubleValue
                    guard value >= minimum.doubleValue && value <= maximum.doubleValue else {
                        throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "\(fontPath): variation outside declared axis range"])
                    }
                    coordinates[identifier] = NSNumber(value: value)
                    axisReport.append(["identifier": identifier, "minimum": minimum, "maximum": maximum, "default": standard, "selected": value])
                }
                if requestedWeight != nil && coordinates[NSNumber(value: 0x77676874)] == nil {
                    throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "\(fontPath): no wght axis"])
                }
                let descriptor = CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute: coordinates] as CFDictionary)
                let face = CTFontCreateCopyWithAttributes(base, CGFloat(unitsPerEm), nil, descriptor)
                let actual = (CTFontCopyVariation(face) as? [NSNumber: NSNumber]) ?? [:]
                for (key, value) in coordinates {
                    let standard = axes.first { ($0[kCTFontVariationAxisIdentifierKey as String] as? NSNumber) == key }?[kCTFontVariationAxisDefaultValueKey as String] as? NSNumber
                    guard (actual[key] ?? standard)?.doubleValue == value.doubleValue else {
                        throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "\(fontPath): requested variation was not applied: \(key)"])
                    }
                }
                func number(_ value: CGFloat) -> String {
                    let n = Double(value)
                    return n == n.rounded() ? String(Int(n)) : String(n)
                }
                let weight = coordinates[NSNumber(value: 0x77676874)]?.doubleValue ?? tables["OS/2"].map { Double(font.u16($0 + 4)) } ?? 400
                var rows: [String] = []
                var measurements: [[String: Any]] = []
                for code in codes {
                    let identifier = glyph(for: code)
                    guard identifier > 0 else {
                        throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "\(fontPath): missing glyph U+\(String(code, radix: 16).uppercased()) in \(args[2])"])
                    }
                    var commands: [String] = []
                    if let path = CTFontCreatePathForGlyph(face, CGGlyph(identifier), nil) {
                        path.applyWithBlock { pointer in
                            let element = pointer.pointee
                            func point(_ index: Int) -> String {
                                number(element.points[index].x) + " " + number(element.points[index].y)
                            }
                            switch element.type {
                            case .moveToPoint: commands.append("M" + point(0))
                            case .addLineToPoint: commands.append("L" + point(0))
                            case .addQuadCurveToPoint: commands.append("Q" + point(0) + " " + point(1))
                            case .addCurveToPoint: commands.append("C" + point(0) + " " + point(1) + " " + point(2))
                            case .closeSubpath: commands.append("Z")
                            @unknown default: fatalError("FontMetrics: unsupported outline command")
                            }
                        }
                    } else if code != 32 {
                        throw NSError(domain: "FontMetrics", code: 2, userInfo: [NSLocalizedDescriptionKey: "\(fontPath): glyph U+\(String(code, radix: 16).uppercased()) has no outline"])
                    }
                    var measuredGlyph = CGGlyph(identifier)
                    var measuredAdvance = CGSize.zero
                    CTFontGetAdvancesForGlyphs(face, .horizontal, &measuredGlyph, &measuredAdvance, 1)
                    let width = Double(measuredAdvance.width)
                    rows.append("\(code)|\(width)|\(source)|\(number(CGFloat(weight)))|\(commands.joined())")
                    measurements.append(["codepoint": code, "glyph": identifier, "advance": width])
                }
                let text = "import Notation\nimport DocumentKit\n\n// GENERATED by FontMetrics --outlines from the declared font and corpus.\n"
                    + "public enum \(name)Units: Close {}\nextension \(name)Units { public static var typeName: String { \"\(unitsPerEm)\" } }\n"
                    + "public enum \(name)Glyphs: Close {}\nextension \(name)Glyphs { public static var typeName: String {\n    \"\"\"\n"
                    + rows.map { "    " + $0 }.joined(separator: "\n") + "\n    \"\"\"\n} }\n"
                    + "public enum \(name): OutlineFontFace {\n    public typealias Units = \(name)Units\n    public typealias Glyphs = \(name)Glyphs\n}\n"
                try text.write(toFile: args[3], atomically: true, encoding: .utf8)
                let capitalH = CTFontCreatePathForGlyph(face, CGGlyph(glyph(for: 72)), nil)?.boundingBoxOfPath.height ?? 0
                let report: [String: Any] = ["unitsPerEm": unitsPerEm, "capHeight": capHeight,
                    "capHeightSource": capHeight > 0 ? "OS/2" : "not supplied by OS/2",
                    "capitalHOutlineHeight": Double(capitalH), "variationAxes": axisReport, "source": fontPath, "glyphs": measurements]
                let bytes = try JSONSerialization.data(withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
                try bytes.write(to: URL(fileURLWithPath: args[3] + ".json"), options: .atomic)
                print("outlined \(rows.count) glyphs from \(fontPath): cap \(capHeight), units \(unitsPerEm); \(args[3])")
            } catch {
                fputs("FontMetrics: \(error.localizedDescription)\n", stderr)
                exit(2)
            }
            #else
            fputs("FontMetrics: --outlines requires CoreText; no alternate font reader\n", stderr)
            exit(2)
            #endif
            return
        }

        // ── the atoms ──
        var pairs: [String] = []
        for codepoint in codepoints {
            let glyphId = glyph(for: codepoint)
            guard glyphId != 0 || codepoint == 0x20 else { continue }
            pairs.append("\(codepoint):\(advance(forGlyph: glyphId))")
        }
        let o = [
            "import Notation", "",
            "// GENERATED by `swift run FontMetrics` from \(fontPath): the stated",
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
