// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VerificationIsIdentification",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "Notation", targets: ["Notation"]),
        .library(name: "DocumentKit", targets: ["DocumentKit"]),
        .library(name: "DocumentKitCertificates", targets: ["DocumentKitCertificates"]),
        .executable(name: "DocumentKitDemo", targets: ["DocumentKitDemo"]),
        .executable(name: "FontMetrics", targets: ["FontMetrics"]),

        // VerificationIsIdentification: all papers as type-level protocols + operations.
        .library(name: "VerificationIsIdentification", targets: ["VerificationIsIdentification"]),

        // Examples: the law applied — physics reproduced as types, the concrete
        // witnesses, and a working solver. The concrete layer beside VerificationIsIdentification.
        .library(name: "Examples", targets: ["Examples"]),

        // GrammarLexicon: the linter's own vocabulary (DESIGN15) — atoms, formations, grants,
        // nothing else. Exposed as a product so the disposable "mirror" package (generated and
        // built in scratch by `Tools grammar`, Sources/GrammarLexicon/Mirror.swift) can import it
        // via a local path dependency back onto this repo — the mirror's own compiler IS the
        // check; this target only supplies the types it checks against.
        .library(name: "GrammarLexicon", targets: ["GrammarLexicon"]),

        // Alphabet: one atom, one symbol, both axes (ROUND-UNIFY.md Phase 1) — the character
        // vocabulary the showcase's DocumentKit prose and GrammarLexicon's stream both need,
        // unified so a name can never drift between the two the way three separate copies once did.
        .library(name: "Alphabet", targets: ["Alphabet"]),

        // Court: the second arbiter as a linkable library: the plain judge, the where
        // judge, and the term language they share (Press). A
        // consumer links the same judge this repository runs instead of mirroring it:
        // one source of judgement, and executables are views of it.
        .library(name: "Court", targets: ["Court"]),
        .library(name: "ContinuationRecord", targets: ["ContinuationRecord"]),
        .executable(name: "RecordCourt", targets: ["RecordCourt"]),

        // Tools and LawCheck as products: the showcase package, which depends on this one,
        // runs the same lint, grammar, census, voice and judge, and attaches the same surface
        // law to its targets, instead of carrying a copy.
        .executable(name: "Tools", targets: ["Tools"]),
        .plugin(name: "LawCheck", targets: ["LawCheck"]),

    ],
    dependencies: [
        // Docs only — Swift-DocC renders the lattice's doc-comments + protocol
        // hierarchy into a browsable site. NOT a target dependency.
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Notation carries the shared constructors without dependencies. The theory adds laws.
        // Notation and the theory are strict-checked by the renames law: attaching LawCheck
        // would cycle through Tools, which reads both modules.
        // VerificationIsIdentification — papers, axes, markers and operations.
        // §0′ (pure types, no renames) is now enforced by THE GRAMMAR's scope axis — the six
        // words carry no LatticeToken, Primitive.swift alone is the engine room — so the old
        // LawCheck plugin is off this target (it also closed a dependency cycle once
        // GrammarLexicon started depending on the lattice for real: Close atoms, Never floor).
        .target(name: "Notation"),
        .target(name: "VerificationIsIdentification", dependencies: ["Notation"]),
        .target(name: "DocumentKit", dependencies: ["Notation", "Alphabet"],
                exclude: ["Resources"],
                plugins: ["LawCheck"]),
        .target(name: "DocumentKitCertificates", dependencies: ["DocumentKit", "VerificationIsIdentification"],
                exclude: ["LawCheck.strict"],
                plugins: ["LawCheck"]),
        .executableTarget(name: "DocumentKitDemo", dependencies: ["VerificationIsIdentification", "DocumentKit", "DocumentKitCertificates", "Examples"]),
        .executableTarget(name: "FontMetrics"),

        // `lint` (the construction-law check) and `tree-sort` (the Topics inducer). Depends on
        // GrammarLexicon and Alphabet: Linter.swift (DESIGN15) reads the `Alphabet` registry at
        // runtime — the mechanism's only way to know what atoms exist without naming any of
        // them itself.
        // The addressed U5/U6 calculus and record reader have no Swift-reader
        // dependency. Court's source adapters and other judgements depend on it.
        // Both use Foundation, without the package's tooling or theory targets.
        .target(name: "ContinuationRecord"),
        .executableTarget(name: "RecordCourt", dependencies: ["ContinuationRecord"]),
        .target(name: "Court", dependencies: ["ContinuationRecord"]),

        .executableTarget(name: "Tools", dependencies: ["GrammarLexicon", "Alphabet", "VerificationIsIdentification", "Court"]),

        // The linter's own vocabulary (DESIGN15) — protocols, empty enums, conformances, the
        // LawCheck spirit (§0′ pure types) applied to the linter itself, checked BY HAND
        // (`swift run Tools lint Sources/GrammarLexicon`) rather than the plugin: LawCheck
        // depends on Tools, so Tools depending back on GrammarLexicon (to read its registry at
        // runtime) would cycle if this target also carried the plugin.
        .target(name: "GrammarLexicon", dependencies: ["Alphabet", "VerificationIsIdentification"]),

        // The character vocabulary the showcase's DocumentKit and GrammarLexicon's stream both read —
        // depends on Notation only (Open/Close/LintAtom's floor), never on
        // either of its two consumers, so neither can cycle importing it.
        .target(name: "Alphabet", dependencies: ["Notation"]),

        // Structural enforcement of THE LAW, wired into the build itself.
        .plugin(name: "LawCheck", capability: .buildTool(), dependencies: ["Tools"]),

        // `swift package tree-sort [check|write]` — induce/check the Topics tree.
        .plugin(name: "TreeSortCommand",
                capability: .command(
                    intent: .custom(verb: "tree-sort",
                                    description: "Induce or check the Topics tree from the type lattice"),
                    permissions: [.writeToPackageDirectory(
                        reason: "regenerate VerificationIsIdentification.md and the paper Topics from the type lattice")]),
                dependencies: ["Tools"]),

        // The law applied: physical instances, concrete witnesses, type-level demos.
        .target(name: "Examples", dependencies: ["VerificationIsIdentification"]),

        .testTarget(name: "NotationTests", dependencies: ["VerificationIsIdentification"]),

        .testTarget(name: "CourtTests", dependencies: ["Court", "ContinuationRecord"]),
        .testTarget(name: "ContinuationRecordTests", dependencies: ["ContinuationRecord"]),

        // The demos as proofs.
        .testTarget(name: "ExamplesTests", dependencies: ["Examples"]),
    ]
)
