import Alphabet
import Foundation
import GrammarLexicon

// This is an export of type facts, not a second list of grants. Keep the
// portable census equal to the schema at every grammar gate.
enum GrammarPolicyCensus {
    static let scopes = ["LatticeScope", "EngineScope", "SurfaceScope", "SystemScope", "ToolsScope", "DemoScope"]

    private static func grants(_ atom: any LintAtom.Type) -> [String] {
        let admitted = [atom is any LatticeToken.Type, atom is any EngineToken.Type,
                        atom is any SurfaceToken.Type, atom is any SystemToken.Type,
                        atom is any ToolsToken.Type, atom is any DemoToken.Type]
        var out: [String] = []
        for (scope, yes) in zip(scopes, admitted)
        where yes {
            if atom is any PlainToken.Type { out.append(scope + "/Plain") }
            if atom is any BuilderToken.Type { out.append(scope + "/Builder") }
        }
        return out.sorted()
    }

    private static func paired<A: LintAtom, B: LintAtom>(_ a: A.Type, _ b: B.Type) -> (String, [String]) {
        (String(describing: Declares<A, B>.self), grants(Declares<A, B>.self))
    }

    static func policy() -> GrammarPolicy {
        var types: [String: any LintAtom.Type] = [:]
        for atom in Alphabet.lexemes { types[String(describing: atom)] = atom }
        for atom in Schema.spellings { types[String(describing: atom)] = atom }
        types[String(describing: Alphabet.defaultWord)] = Alphabet.defaultWord
        let all = types.keys.sorted().compactMap { types[$0] }
        func text(_ atom: any LintAtom.Type) -> String {
            if let word = atom as? any Spelled.Type { return word.spelling }
            if let glyph = atom as? any Lexeme.Type { return String(glyph.glyph) }
            return ""
        }
        let atoms = all.map { atom -> GrammarPolicy.Atom in
            let spelling = text(atom)
            return GrammarPolicy.Atom(name: String(describing: atom), spelling: spelling,
                word: (atom is any Spelled.Type) && (spelling.first.map { $0.isLetter || $0.isNumber || $0 == "_" } ?? false),
                medium: atom is any MediumAtom.Type, opening: atom is any OpeningAtom.Type,
                closes: (atom as? any ClosingAtom.Type).map { String(describing: $0.opensType) },
                pairs: atom is any AlwaysPairs.Type,
                foreign: (atom as? any ForeignOpener.Type).map { String(describing: $0.closerType) },
                escapes: atom is any Escapes.Type, declaration: atom is any DeclarationHead.Type,
                builder: atom is any OpensBuilder.Type, exempt: atom is any OpensExempt.Type,
                modifier: atom is any LineModifier.Type, line: atom is any LineSensitive.Type,
                pair: atom is any PairSensitive.Type, grants: grants(atom))
        }
        var pairs: [String: [String]] = [:]
        for a in all
        where a is any PairSensitive.Type {
            for b in all { let (name, allowed) = paired(a, b)
             pairs[name] = allowed }
        }
        return GrammarPolicy(format: "vi-grammar-policy/1", scopes: scopes,
            defaultAtom: String(describing: Alphabet.defaultWord), atoms: atoms, pairs: pairs)
    }

    static func data() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return try encoder.encode(policy()) + Data([10])
    }
}
