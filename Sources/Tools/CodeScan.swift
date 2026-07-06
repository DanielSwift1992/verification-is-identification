import Foundation

// CodeScan — the one text-scanning utility Census still needs after AnglesLint/LayoutLint/
// SurfaceLint's retire (DESIGN17 §5): strip comments and string-literal interiors (including
// multi-line `"""` blocks) so a line count reads only real code. Relocated verbatim from
// AnglesLint.swift, which owned the reporting rules built on top of it — those rules retired
// with the file; this reader did not, since Census's own counts still depend on it.
enum CodeScan {
    private enum Mode { case code, lineComment, blockComment, stringLiteral, tripleString }

    // One pass over the whole file, not per line: an unterminated `"""` or `/*` has to carry
    // its mode across the newline that ends the line it opened on. Output has exactly one
    // entry per input line, so line numbers still line up with the source.
    static func cleanedLines(of content: String) -> [String] {
        var mode: Mode = .code
        var lines: [String] = []
        var current = ""
        let chars = Array(content)
        var i = 0
        while i < chars.count {
            let c = chars[i]
            if c == "\n" {
                lines.append(current)
                current = ""
                if mode == .lineComment { mode = .code }
                i += 1
                continue
            }
            switch mode {
            case .lineComment:
                i += 1
            case .blockComment:
                if c == "*", i + 1 < chars.count, chars[i + 1] == "/" {
                    mode = .code
                    i += 2
                } else {
                    i += 1
                }
            case .stringLiteral:
                if c == "\\", i + 1 < chars.count {
                    i += 2   // an escaped character (\" included) never closes the literal
                } else if c == "\"" {
                    mode = .code
                    i += 1
                } else {
                    i += 1
                }
            case .tripleString:
                if c == "\"", i + 2 < chars.count, chars[i + 1] == "\"", chars[i + 2] == "\"" {
                    mode = .code
                    i += 3
                } else {
                    i += 1
                }
            case .code:
                if c == "\"", i + 2 < chars.count, chars[i + 1] == "\"", chars[i + 2] == "\"" {
                    mode = .tripleString
                    i += 3
                } else if c == "\"" {
                    mode = .stringLiteral
                    i += 1
                } else if c == "/", i + 1 < chars.count, chars[i + 1] == "/" {
                    mode = .lineComment
                    i += 2
                } else if c == "/", i + 1 < chars.count, chars[i + 1] == "*" {
                    mode = .blockComment
                    i += 2
                } else {
                    current.append(c)
                    i += 1
                }
            }
        }
        lines.append(current)
        return lines
    }
}
