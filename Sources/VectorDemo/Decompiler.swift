import Foundation
import VerificationIsIdentification
import DocumentKit
import Organization

// DESIGN12 §2: "show your own code," with zero duplication BY CONSTRUCTION. A `SelfShowing`
// canvas's composition already lives in its own type: `@StructureBuilder` folds a `body`'s
// statements into a left-nested `Paired<...>` cons chain, and `String(reflecting: Body.self)`
// exposes that chain's full nested-generic name as one string, checked directly against the
// compiler (a probe reading `PulseDashboard.Body.self` back a `Paired<Paired<Paired<Paired<Paired
// <SoftShadow, SurfaceCardShadow>, HoverStyle>, KpiRow>, DepartmentBars>, WorkplaceColumn>`
// string, module-qualified). Every generic argument anywhere in that chain, including a card's
// own `TaskCardCore<OnboardNewHire, ToDoChip>` or a link's `NextArrow<SitePath<WhatIf...>>`, is
// ALREADY fully expanded by Swift's own type-metadata printer in that ONE string; there is
// nothing further to fetch per named type, only this string to parse and pretty-print. This
// file is deliberately value-level Swift string manipulation, living in the driver (VectorDemo),
// not in DocumentKit or Organization, the same lawful edge the keypad's own generated name
// pools already stand on (SurfaceLaw §S23).

/// One parsed node of a reflected type name: a bare leaf (`KpiRow`), a generic instantiation
/// with already-expanded arguments (`TaskCardCore<OnboardNewHire, ToDoChip>`), or,
/// only if the parser meets a shape it does not recognize, the original text, quoted verbatim
/// rather than guessed at (§S3 sanctions a raw fallback over a confident wrong one).
indirect enum DecompiledNode {
    case leaf(String)
    case generic(String, [DecompiledNode])
    case raw(String)
}

enum Decompiler {
    private static let modulePrefixes = [
        "VerificationIsIdentification.", "DocumentKit.", "Organization.", "VectorDemo.", "Examples.",
    ]

    private static func stripModules(_ text: String) -> String {
        var result = text
        for prefix in modulePrefixes { result = result.replacingOccurrences(of: prefix, with: "") }
        return result
    }

    /// Recursive-descent over an already module-stripped type name. An identifier runs until
    /// `<`, `,`, or `>`. A `<` opens a comma-separated argument list read by the same rule,
    /// closed by ITS matching `>` (depth-tracked, since an argument can itself be generic).
    private static func parse(_ text: String) -> DecompiledNode {
        var chars = Array(text)[...]
        guard let node = parseNode(&chars), chars.isEmpty else { return .raw(text) }
        return node
    }

    private static func parseNode(_ chars: inout ArraySlice<Character>) -> DecompiledNode? {
        var name = ""
        while let c = chars.first, c != "<", c != ",", c != ">" {
            name.append(c)
            chars.removeFirst()
        }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }
        guard chars.first == "<" else { return .leaf(trimmed) }
        chars.removeFirst()
        var args: [DecompiledNode] = []
        while true {
            guard let arg = parseNode(&chars) else { return nil }
            args.append(arg)
            if chars.first == "," {
                chars.removeFirst()
                if chars.first == " " { chars.removeFirst() }
                continue
            }
            break
        }
        guard chars.first == ">" else { return nil }
        chars.removeFirst()
        return .generic(trimmed, args)
    }

    /// `Paired` is the builder's own fold, not real content: flatten its LEFT-nested chain back
    /// into the original statement order (`Paired<Paired<S1,S2>,S3>` reads as `[S1, S2, S3]`,
    /// the same left-nesting the builder itself produces) rather than showing it as a combinator.
    private static func statements(of node: DecompiledNode) -> [DecompiledNode] {
        guard case .generic("Paired", let args) = node, args.count == 2 else { return [node] }
        return statements(of: args[0]) + [args[1]]
    }

    /// A subtree spelled only in the magnitude ladder (`Plus`, `Twice`, `Half`, `Unit`,
    /// `Never`) is a number the build already folded: the aliases the source named
    /// (`U16`, `EdgeMargin`) are expanded away in the reflected string, and printing
    /// their Unit trees would bury the composition. The count is that subtree's one
    /// reading, so the page prints the count. Any other name below keeps the subtree.
    private static func magnitudeCount(_ node: DecompiledNode) -> Int? {
        switch node {
        case .leaf("Unit"): return 1
        case .leaf("Never"): return 0
        case .generic("Plus", let args)
        where args.count == 2:
            guard let left = magnitudeCount(args[0]), let right = magnitudeCount(args[1]) else { return nil }
            return left + right
        case .generic("Twice", let args)
        where args.count == 1:
            guard let side = magnitudeCount(args[0]) else { return nil }
            return 2 * side
        case .generic("Times", let args)
        where args.count == 2:
            guard let left = magnitudeCount(args[0]), let right = magnitudeCount(args[1]) else { return nil }
            return left * right
        case .generic("Half", let args)
        where args.count == 1:
            guard let side = magnitudeCount(args[0]) else { return nil }
            return side / 2
        default: return nil
        }
    }

    private static func render(_ node: DecompiledNode, indent: Int) -> String {
        let pad = String(repeating: " ", count: indent * 4)
        if case .generic = node, let count = magnitudeCount(node) {
            return "\(pad)\(count)"
        }
        switch node {
        case .leaf(let name):
            return "\(pad)\(name).self"
        case .raw(let text):
            return "\(pad)<\(text)>"
        case .generic("Paired", let args)
        where args.count == 2:
            return statements(of: node).map { render($0, indent: indent) }.joined(separator: "\n")
        case .generic(let name, let args):
            let inner = args.map { render($0, indent: indent + 1) }.joined(separator: "\n")
            return "\(pad)\(name) {\n\(inner)\n\(pad)}"
        }
    }

    /// The one entry point: `Name`, the canvas's own bare Swift name, plus `Body`'s reflected
    /// type name, read back as the humanized, indented, depth-complete Swift a person would
    /// have written, module prefixes stripped, `Paired` unrolled into a plain statement list.
    static func decompile(name: String, reflectedBody: String) -> String {
        let node = parse(stripModules(reflectedBody))
        let body = statements(of: node).map { render($0, indent: 1) }.joined(separator: "\n")
        return "\(name) {\n\(body)\n}"
    }

    private static let honestyBanner =
        "> Note: Read back from the compiled type, the structure the build actually proved, "
            + "not the file a human formatted. Comments and spacing live in the source file; "
            + "the shape lives here, and the two cannot disagree."

    /// A `<Name>Source.md` page: three parts, a flat H1, the honesty banner
    /// (verbatim), the decompiled body fenced as Swift, then one link back to the canvas's
    /// page. Written straight into the catalog (not through `Structure`/`typeName`, since the
    /// body text is a runtime `String(reflecting:)` read, not a compile-time composition).
    static func writeSourcePage(title: String, fileStem: String, name: String, reflectedBody: String, backText: String, backPage: String) {
        let code = decompile(name: name, reflectedBody: reflectedBody)
        let page = """
        # \(title)

        \(honestyBanner)

        ```swift
        \(code)
        ```

        [\(backText)](doc:\(backPage))

        """
        try? page.write(toFile: "Sources/Organization/Organization.docc/\(fileStem)Source.md", atomically: true, encoding: .utf8)
    }
}

func runSelfShowing() {
    Decompiler.writeSourcePage(
        title: "How the dashboard is written",
        fileStem: "Pulse",
        name: "PulseDashboard",
        reflectedBody: String(reflecting: PulseDashboard.Body.self),
        backText: "back to the dashboard",
        backPage: "CompanyDashboard"
    )
    Decompiler.writeSourcePage(
        title: "How the board is written",
        fileStem: "Board",
        name: "BoardContent",
        reflectedBody: String(reflecting: BoardContent.Body.self),
        backText: "back to the board",
        backPage: "Board"
    )
    Decompiler.writeSourcePage(
        title: "How the review-cycle timeline is written",
        fileStem: "CyclesHero",
        name: "CyclesHeroStrip",
        reflectedBody: String(reflecting: CyclesHeroStrip.Body.self),
        backText: "back to review cycles",
        backPage: "Cycles"
    )
    print("generated 3 self-showing source pages (Pulse, Board, CyclesHero, read from the compiled type)")
}
