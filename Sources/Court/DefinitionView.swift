import Foundation

/// A definition lends declarations, not executions of its stored values or
/// methods. This bounded source view is made by the owner after byte binding.
/// The first excluded declaration is reported for each supplied definition.
enum DefinitionView {
    static func read(_ text: String, path: String, lent: NameSet, contextV2: Bool = false) throws -> (text: String, first: Int?) {
        if contextV2 { return try scoped(text, path: path, lent: lent) }
        let clean = try WhereJudge.stripComments(text, lent: lent).components(separatedBy: "\n")
        var lines = WhereJudge.sourceLines(text).components(separatedBy: "\n")
        let value = #"^\s*(?:(?:public|private|fileprivate|internal|static|final|override|mutating)\s+)*(?:func|var|let)\b"#
        var i = 0, first: Int?
        while i < clean.count {
            guard clean[i].range(of: value, options: .regularExpression) != nil else {
                i += 1
                continue
            }
            let start = i
            var depth = 0, opened = false
            if first == nil { first = i + 1 }
            repeat {
                if clean[i].range(of: #"(?<!\.)\b(?:enum|struct|class|actor|protocol|extension|typealias|associatedtype)\s+\w+"#, options: .regularExpression) != nil {
                    try WhereJudge.fail("cannot read line \(i + 1) of '\(path)': a value declaration contains a type declaration outside the supported binding scope")
                }
                for at in clean[i].indices {
                    let c = clean[i][at]
                    if c == "{" {
                        depth += 1
                        opened = true
                    }
                    if c == "}" {
                        depth -= 1
                        if opened && depth == 0 && !clean[i][clean[i].index(after: at)...].trimmingCharacters(in: .whitespaces).isEmpty {
                            try WhereJudge.fail("cannot read line \(i + 1) of '\(path)': declaration after an implementation body")
                        }
                    }
                }
                guard depth >= 0 else { try WhereJudge.fail("cannot read line \(i + 1) of '\(path)': declaration boundary") }
                lines[i] = ""
                i += 1
                if opened && depth == 0 { break }
                if !opened && i < clean.count && clean[i].range(of:
                    #"^\s*(?:(?:public|private|fileprivate|internal|static)\s+)*(?:enum|struct|class|protocol|extension|typealias|associatedtype|func|var|let)\b"#,
                    options: .regularExpression) != nil { break }
                if !opened && (!clean[start].contains("func") || i == clean.count || clean[i].trimmingCharacters(in: .whitespaces) == "}") { break }
            } while i < clean.count
            if depth != 0 { try WhereJudge.fail("cannot read line \(start + 1) of '\(path)': unclosed implementation body") }
        }
        return (lines.joined(separator: "\n"), first)
    }

    /// Exclude balanced value declarations wherever the declaration occurs,
    /// including an inline member. Type declarations inside that region are
    /// refused rather than promoted into the surrounding lexical owner.
    static func scoped(_ text: String, path: String, lent: NameSet) throws -> (text: String, first: Int?) {
        let clean = try WhereJudge.stripComments(text, lent: lent)
        let units = Array(clean.utf16)
        var view = units, consumed = 0, first: Int?
        let pattern = #"\b(?:(?:public|private|fileprivate|internal|static|final|override|mutating)\s+)*(func|var|let)\b"#
        let regex = try NSRegularExpression(pattern: pattern)
        let scope = WhereJudge.Scope(clean)
        for hit in regex.matches(in: clean, range: NSRange(location: 0, length: units.count)) {
            let start = hit.range.location
            guard start >= consumed, start == 0 || units[start - 1] != 46 else { continue }
            let function = (clean as NSString).substring(with: hit.range(at: 1)) == "func"
            var end = NSMaxRange(hit.range), opened = false, braces = 0, brackets = 0
            while end < units.count {
                let c = units[end]
                if c == 123 { opened = true
                 braces += 1 }
                if c == 125 {
                    if !opened { break }
                    braces -= 1
                    if braces == 0 { end += 1
                     break }
                }
                if !opened {
                    if c == 40 || c == 91 { brackets += 1 }
                    if c == 41 || c == 93 { brackets -= 1 }
                    if brackets == 0 && c == 59 { break }
                    if brackets == 0 && c == 10 {
                        let tail = String(decoding: units[(end + 1)...], as: UTF16.self)
                        if !function || tail.range(of: #"^\s*(?:(?:public|private|static)\s+)*(?:enum|struct|class|protocol|extension|typealias|associatedtype|func|var|let|\})\b"#, options: .regularExpression) != nil { break }
                    }
                }
                end += 1
            }
            guard braces == 0 else { try WhereJudge.fail("cannot read line \(scope.line[start]) of '\(path)': unclosed implementation body") }
            let part = String(decoding: units[start..<end], as: UTF16.self)
            if part.range(of: #"(?<!\.)\b(?:enum|struct|class|actor|protocol|extension|typealias|associatedtype)\s+\w+"#, options: .regularExpression) != nil {
                try WhereJudge.fail("cannot read line \(scope.line[start]) of '\(path)': a value declaration contains a type declaration outside the supported binding scope")
            }
            first = first ?? scope.line[start]
            for i in start..<end
            where view[i] != 10 { view[i] = 32 }
            consumed = end
        }
        return (String(decoding: view, as: UTF16.self), first)
    }
}
