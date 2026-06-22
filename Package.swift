// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VerificationIsIdentification",
    products: [
        // VerificationIsIdentification: all papers as type-level protocols
        .library(name: "VerificationIsIdentification", targets: ["VerificationIsIdentification"]),

        // Playground: the law applied — physics reproduced as types, the concrete
        // witnesses, and a working solver. The concrete layer beside VerificationIsIdentification.
        .library(name: "Playground", targets: ["Playground"]),
    ],
    dependencies: [
        // Docs only — Swift-DocC renders the lattice's doc-comments + protocol
        // hierarchy into a browsable site. NOT a target dependency: nothing
        // links it into VerificationIsIdentification, so §0′ PURE TYPES is untouched.
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // VerificationIsIdentification is standalone — all papers, primitives, axes, markers, witness.
        // The LawCheck plugin runs LawLint on every build (pure types, no renames).
        .target(name: "VerificationIsIdentification", plugins: ["LawCheck"]),

        // Tools — the build-time helpers as one executable with two subcommands:
        // `lint` (the construction-law check) and `tree-sort` (the Topics inducer).
        // Depends on nothing: it reads VerificationIsIdentification's sources and the symbol graph, so §0′
        // PURE TYPES stays untouched and the LawCheck build plugin forms no cycle.
        .executableTarget(name: "Tools"),

        // Structural enforcement of THE LAW, wired into the build itself. Runs
        // `Tools lint` as a build command over the VerificationIsIdentification target's sources.
        .plugin(name: "LawCheck", capability: .buildTool(), dependencies: ["Tools"]),

        // `swift package tree-sort [check|write]` — induce/check the Topics tree
        // from the type lattice via the compiler's symbol graph. A command plugin
        // (build-tool plugins cannot read the symbol graph). Runs `Tools tree-sort`.
        .plugin(name: "TreeSortCommand",
                capability: .command(
                    intent: .custom(verb: "tree-sort",
                                    description: "Induce or check the Topics tree from the type lattice"),
                    permissions: [.writeToPackageDirectory(
                        reason: "regenerate VerificationIsIdentification.md and the paper Topics from the type lattice")]),
                dependencies: ["Tools"]),

        // The law applied: physical instances (Matter §5 gates), the concrete
        // witnesses (non-trivial models of the markers), and the type-level demos —
        // count, select, propagate, conserve. The concrete layer, no LawCheck.
        .target(name: "Playground", dependencies: ["VerificationIsIdentification"]),

        // The demos as proofs: `swift test` runs them and pins the numbers. Not a
        // documented module — the proof is the build, the presentation is the docs.
        .testTarget(name: "PlaygroundTests", dependencies: ["Playground"]),
    ]
)
