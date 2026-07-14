// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VerificationIsIdentification",
    platforms: [.macOS(.v13)],   // RegexBuilder (Tools/Prose.swift, the ProseGen plugin)
    products: [
        // VerificationIsIdentification: all papers as type-level protocols + operations.
        .library(name: "VerificationIsIdentification", targets: ["VerificationIsIdentification"]),

        // Examples: the law applied — physics reproduced as types, the concrete
        // witnesses, and a working solver. The concrete layer beside VerificationIsIdentification.
        .library(name: "Examples", targets: ["Examples"]),

        // Organization: a scaled showcase — a whole company's access model as types,
        // every access proved at build. The framework applied to business logic.
        .library(name: "Organization", targets: ["Organization"]),

        // DocumentKit: atoms (Close) and combinators (Open) that compose into documents.
        // Rendering is typeName walking the Paired chain.
        .library(name: "DocumentKit", targets: ["DocumentKit"]),

        // GrammarLexicon: the linter's own vocabulary (DESIGN15) — atoms, formations, grants,
        // nothing else. Exposed as a product so the disposable "mirror" package (generated and
        // built in scratch by `Tools grammar`, Sources/GrammarLexicon/Mirror.swift) can import it
        // via a local path dependency back onto this repo — the mirror's own compiler IS the
        // check; this target only supplies the types it checks against.
        .library(name: "GrammarLexicon", targets: ["GrammarLexicon"]),

        // Alphabet: one atom, one symbol, both axes (ROUND-UNIFY.md Phase 1) — the character
        // vocabulary DocumentKit's prose and GrammarLexicon's stream both need, unified so a
        // name can never drift between the two the way three separate copies once did.
        .library(name: "Alphabet", targets: ["Alphabet"]),

    ],
    dependencies: [
        // Docs only — Swift-DocC renders the lattice's doc-comments + protocol
        // hierarchy into a browsable site. NOT a target dependency.
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // VerificationIsIdentification — all papers, primitives, axes, markers, builder, operations.
        // §0′ (pure types, no renames) is now enforced by THE GRAMMAR's scope axis — the six
        // words carry no LatticeToken, Primitive.swift alone is the engine room — so the old
        // LawCheck plugin is off this target (it also closed a dependency cycle once
        // GrammarLexicon started depending on the lattice for real: Close atoms, Never floor).
        .target(name: "VerificationIsIdentification"),

        // `lint` (the construction-law check) and `tree-sort` (the Topics inducer). Depends on
        // GrammarLexicon and Alphabet: Linter.swift (DESIGN15) reads the `Alphabet` registry at
        // runtime — the mechanism's only way to know what atoms exist without naming any of
        // them itself.
        .executableTarget(name: "Tools", dependencies: ["GrammarLexicon", "Alphabet", "VerificationIsIdentification"]),

        // The linter's own vocabulary (DESIGN15) — protocols, empty enums, conformances, the
        // LawCheck spirit (§0′ pure types) applied to the linter itself, checked BY HAND
        // (`swift run Tools lint Sources/GrammarLexicon`) rather than the plugin: LawCheck
        // depends on Tools, so Tools depending back on GrammarLexicon (to read its registry at
        // runtime) would cycle if this target also carried the plugin — the same wall Tools'
        // other dependencies (DocumentKit, Organization) already stand behind.
        .target(name: "GrammarLexicon", dependencies: ["Alphabet", "VerificationIsIdentification"]),

        // The character vocabulary DocumentKit's prose and GrammarLexicon's stream both read —
        // depends on VerificationIsIdentification only (Open/Close/LintAtom's floor), never on
        // either of its two consumers, so neither can cycle importing it.
        .target(name: "Alphabet", dependencies: ["VerificationIsIdentification"]),

        // Structural enforcement of THE LAW, wired into the build itself.
        .plugin(name: "LawCheck", capability: .buildTool(), dependencies: ["Tools"]),

        // Spells Organization/Prose.json into Glyph atoms + Open types on every build —
        // generated, never a script a human has to remember to run.
        .plugin(name: "ProseGen", capability: .buildTool(), dependencies: ["Tools"]),
        .plugin(name: "CensusGen", capability: .buildTool(), dependencies: ["Tools"]),

        // `swift package tree-sort [check|write]` — induce/check the Topics tree.
        .plugin(name: "TreeSortCommand",
                capability: .command(
                    intent: .custom(verb: "tree-sort",
                                    description: "Induce or check the Topics tree from the type lattice"),
                    permissions: [.writeToPackageDirectory(
                        reason: "regenerate VerificationIsIdentification.md and the paper Topics from the type lattice")]),
                dependencies: ["Tools"]),

        // `swift package generate [org|login|cards|diagram|all] [N]` — regenerate the roster,
        // the login walk, the card art, and the architecture diagram (DESIGN5 §1 / DESIGN7 §1-3).
        // Two tools behind one verb: `org`/`login` need no framework (Tools, dependency-free);
        // `cards`/`diagram` compose real `Vector` atoms (DESIGN7's SVG medium), which live in
        // DocumentKit — and DocumentKit's own LawCheck plugin depends ON Tools, so Tools itself
        // cannot depend back on DocumentKit without a cycle. `VectorDemo` is the same shape
        // `OrgDemo`/`DocumentKitDemo` already are: an executable that CAN hold that dependency,
        // so the wall is where it belongs (a second driver), not worked around.
        .plugin(name: "GenerateCommand",
                capability: .command(
                    intent: .custom(verb: "generate",
                                    description: "Regenerate the roster, the login walk, the card art, and the architecture diagram"),
                    permissions: [.writeToPackageDirectory(
                        reason: "regenerate GeneratedTeam/GeneratedRoster/GeneratedLogin/GeneratedEmployeeCards.swift, the card SVGs, and architecture.svg")]),
                dependencies: ["Tools", "VectorDemo"]),

        // The law applied: physical instances, concrete witnesses, type-level demos.
        .target(name: "Examples", dependencies: ["VerificationIsIdentification"]),

        // The dynamics world: one state file whose slots move by rewrite triples
        // (Examples/Dynamics.swift), pressed by `swift run Tools press <Rule>`. The
        // executable only reads the compiled state back; nothing here computes.
        .executableTarget(name: "DynamicsDemo", dependencies: ["VerificationIsIdentification", "DocumentKit", "Examples"]),


        // DocumentKit: atoms + combinators → documents via typeName. Vector.swift is the same
        // mechanism turned on a second medium, SVG (DESIGN7 §1). Alphabet supplies the shared
        // punctuation/medium glyphs (ROUND-UNIFY.md Phase 1); Letter/Cap/TextDigit stay here —
        // the stream never needs letters one at a time.
        .target(name: "DocumentKit", dependencies: ["VerificationIsIdentification", "Alphabet"],
                plugins: ["LawCheck"]),

        // `swift run DocumentKitDemo render-doc` — writes Gallery.typeName into DocumentKit's
        // own .docc catalog: the engine documents itself, scoped entirely to DocumentKit, no
        // Organization dependency.
        .executableTarget(name: "DocumentKitDemo", dependencies: ["VerificationIsIdentification", "DocumentKit"]),

        // `swift run VectorDemo cards|diagram|chart|all` — the card art, the architecture
        // diagram, and the headcount chart, composed from real `Vector` atoms (DESIGN7). The
        // driver `GenerateCommand` invokes for the subcommands Tools itself cannot depend on
        // DocumentKit to produce. Depends on Organization too (DESIGN7 §4) — `chart` reads the
        // same team-chain `count` the console audit already prints; Organization does not
        // depend back on VectorDemo, so this is one direction, no cycle.
        .executableTarget(name: "VectorDemo", dependencies: ["VerificationIsIdentification", "DocumentKit", "Organization"]),

        // Organization: the domain model (System/, Query/) and its rendering (View/) — the
        // showcase applied end to end. Depends on Alphabet directly (not just transitively
        // through DocumentKit) — several View files spell shared punctuation atoms themselves.
        .target(name: "Organization",
                dependencies: ["VerificationIsIdentification", "DocumentKit", "Alphabet"],
                plugins: ["ProseGen", "CensusGen", "LawCheck"]),

        // The generated walk page types, as their own module: one emit job and one
        // lookup scope grow with the declarations inside, so the biggest generated
        // family stands apart (the form move above file sharding, DESIGN21 v38).
        .target(name: "OrgWalkPages", dependencies: ["VerificationIsIdentification", "DocumentKit", "Organization"]),

        // `swift run OrgDemo render-doc` — writes every generated page's rendered markdown
        // into the real .docc catalog, so a doc: link resolves to that content instead of
        // DocC's own bare auto-generated symbol page.
        .executableTarget(name: "OrgDemo", dependencies: ["Organization", "DocumentKit", "OrgWalkPages"]),

        // The demos as proofs.
        .testTarget(name: "ExamplesTests", dependencies: ["Examples"]),

        // count pins the numbers the showcase's body-composed types settle to.
        .testTarget(name: "OrganizationTests", dependencies: ["Organization"]),
    ]
)
