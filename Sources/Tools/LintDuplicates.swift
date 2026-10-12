import Foundation

// §1's cross-file check for repeated empty intersections. The key is the set of named
// ancestors, not just the written parents: A: Cache, Result and B: Finite, Cache, Closed,
// Result repeat one intersection when Cache already inherits Finite and Closed.
// This is a sufficient syntactic check, not general equivalence of Swift requirements.
// Single-parent category gates keep the existing rename rule and its duty exemptions.
// Named ancestors, including markers with empty bodies, remain in the key. Unknown
// parents remain opaque names; no imported ancestry, aliases or where clauses are inferred.

private struct IntersectionDeclaration {
    let name: String
    let parents: Set<String>
    let file: String
    let line: Int
    let candidate: Bool
}

// Preserve UTF-16 offsets and line numbers for regexes, while hiding comments and literals.
// Literals retain a non-whitespace sentinel: a body containing one is never called empty.
// Swift block comments nest; raw and multiline strings may contain fake declarations/braces.
private func intersectionCode(_ text: String) -> String {
    let source = Array(text.utf16)
    var result = source
    var i = 0
    func starts(_ spelling: [UInt16], at index: Int) -> Bool {
        index + spelling.count <= source.count
            && source[index..<(index + spelling.count)].elementsEqual(spelling)
    }
    func hide(_ start: Int, _ end: Int, literal: Bool = false) {
        for index in start..<end
        where source[index] != 10 { result[index] = 32 }
        if literal { result[start] = 126 }
    }
    while i < source.count {
        let start = i
        if starts([47, 47], at: i) {
            while i < source.count, source[i] != 10 { i += 1 }
            hide(start, i)
        } else if starts([47, 42], at: i) {
            var depth = 1
            i += 2
            while i < source.count, depth > 0 {
                if starts([47, 42], at: i) {
                    depth += 1
                    i += 2
                }
                else if starts([42, 47], at: i) {
                    depth -= 1
                    i += 2
                }
                else { i += 1 }
            }
            hide(start, i)
        } else {
            var quote = i
            while quote < source.count, source[quote] == 35 { quote += 1 }
            guard quote < source.count, source[quote] == 34 else {
                i += 1
                continue
            }
            let hashes = quote - i
            let width = starts([34, 34, 34], at: quote) ? 3 : 1
            let closing = Array(repeating: UInt16(34), count: width)
                + Array(repeating: UInt16(35), count: hashes)
            let escape = [UInt16(92)] + Array(repeating: UInt16(35), count: hashes)
            i = quote + width
            while i < source.count {
                if starts(escape, at: i) { i = min(i + escape.count + 1, source.count) }
                else if starts(closing, at: i) {
                    i += closing.count
                    break
                }
                else { i += 1 }
            }
            hide(start, i, literal: true)
        }
    }
    return String(decoding: result, as: UTF16.self)
}

private let intersectionHead = try! NSRegularExpression(
    pattern: #"\bprotocol\s+([A-Za-z_]\w*)\s*([^{}]*)\{"#)
private let intersectionParents = try! NSRegularExpression(
    pattern: #"^\s*(?::\s*([A-Za-z_]\w*(?:\s*\.\s*[A-Za-z_]\w*)*(?:\s*,\s*[A-Za-z_]\w*(?:\s*\.\s*[A-Za-z_]\w*)*)*))?\s*(?:where\b[\s\S]*)?$"#)

private func intersectionDeclarations(_ contents: String, file: String) -> [IntersectionDeclaration] {
    let masked = intersectionCode(contents)
    let source = masked as NSString
    let units = Array(masked.utf16)
    // Nested names have a different scope. Only top-level declarations participate.
    var depths = [Int](repeating: 0, count: units.count + 1)
    for index in units.indices {
        depths[index + 1] = depths[index] + (units[index] == 123 ? 1 : units[index] == 125 ? -1 : 0)
    }
    // Conditional branches cannot be assumed simultaneously active without compiler flags.
    // The present lattice has none. Keep conditional-file ancestry opaque in this check.
    if masked.range(of: #"(?m)^\s*#(?:if|elseif|else|endif)\b"#, options: .regularExpression) != nil {
        return []
    }
    let lines = contents.components(separatedBy: "\n")
    return intersectionHead.matches(in: masked, range: NSRange(location: 0, length: source.length)).compactMap { match in
        guard depths[match.range.location] == 0 else { return nil }
        let name = source.substring(with: match.range(at: 1))
        let header = source.substring(with: match.range(at: 2))
        guard matches(intersectionParents, header) else { return nil }
        let parents = Set((firstCapture(intersectionParents, header, group: 1) ?? "")
            .split(separator: ",").map { $0.filter { !$0.isWhitespace } })
        let brace = NSMaxRange(match.range) - 1
        var end = brace + 1
        while end < units.count, depths[end] > 0 { end += 1 }
        guard end <= units.count, end > brace + 1, depths[end] == 0 else { return nil }
        let body = source.substring(with: NSRange(location: brace + 1, length: end - brace - 2))
        let line = units[..<match.range.location].filter { $0 == 10 }.count + 1
        let allowed = lines[line - 1].contains(allowMarker)
        let candidate = parents.count >= 2 && !allowed
            && header.range(of: #"\bwhere\b"#, options: .regularExpression) == nil
            && body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return IntersectionDeclaration(name: name, parents: parents,
            file: (file as NSString).lastPathComponent, line: line, candidate: candidate)
    }
}

func duplicateIntersectionViolations(files: [String]) -> [Violation] {
    let declarations = Set(files).sorted().flatMap { file -> [IntersectionDeclaration] in
        guard let contents = try? String(contentsOfFile: file, encoding: .utf8) else { return [] }
        return intersectionDeclarations(contents, file: file)
    }
    let named = Dictionary(grouping: declarations, by: \.name)
    func ancestry(_ declaration: IntersectionDeclaration) -> [String]? {
        var seen: Set<String> = []
        var visiting: Set<String> = [declaration.name]
        func visit(_ parent: String) -> Bool {
            // Cyclic or multiply declared local names are not a basis for this claim.
            guard !visiting.contains(parent) else { return false }
            if seen.contains(parent) { return true }
            visiting.insert(parent)
            if let inherited = named[parent] {
                guard inherited.count == 1 else { return false }
                for ancestor in inherited[0].parents
                where !visit(ancestor) { return false }
            }
            visiting.remove(parent)
            seen.insert(parent)
            return true
        }
        for parent in declaration.parents
        where !visit(parent) { return nil }
        return seen.sorted()
    }
    var groups: [[String]: [IntersectionDeclaration]] = [:]
    for declaration in declarations
    where declaration.candidate && named[declaration.name]?.count == 1 {
        guard let key = ancestry(declaration) else { continue }
        groups[key, default: []].append(declaration)
    }
    return groups.values.flatMap { group -> [Violation] in
        let ordered = group.sorted { ($0.name, $0.file, $0.line) < ($1.name, $1.file, $1.line) }
        guard let first = ordered.first else { return [] }
        return ordered.dropFirst().map { duplicate in
            Violation(file: duplicate.file, line: duplicate.line, rule: "§1 DUPLICATE INTERSECTION",
                detail: "\(duplicate.name) repeats \(first.name) (\(first.file):\(first.line)); empty body, same named-parent closure")
        }
    }.sorted { ($0.file, $0.line, $0.detail) < ($1.file, $1.line, $1.detail) }
}
