import Foundation

/// A definition lends declarations, not executions of its stored values or
/// methods. This bounded source view is made by the owner after byte binding.
/// The first excluded declaration is reported for each supplied definition.
enum DefinitionView {
    static func read(_ text: String, path: String, lent: Set<String>) throws -> (text: String, first: Int?) {
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
}
