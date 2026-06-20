// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VerificationIsIdentification",
    products: [
        // Compile-time proof (Appendix C)
        .library(name: "Engine", targets: ["Engine"]),
        .library(name: "Atom", targets: ["Atom"]),
        .library(name: "Compose", targets: ["Compose"]),
        // .executable(name: "Proof", targets: ["Proof"]),
        // .executable(name: "SelfTest", targets: ["SelfTest"]),

        // V=I Theory: all papers as type-level protocols
        .library(name: "Theory", targets: ["Theory"]),

        // Domains: concrete instances plugged into the lattice — compile = certified
        .library(name: "Domains", targets: ["Domains"]),
    ],
    dependencies: [
        // Docs only — Swift-DocC renders the lattice's doc-comments + protocol
        // hierarchy into a browsable site. NOT a target dependency: nothing
        // links it into Theory, so §0′ PURE TYPES is untouched.
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Engine"),
        .target(name: "Atom", dependencies: ["Engine"]),
        .target(name: "Compose", dependencies: ["Engine", "Atom"]),
        // .executableTarget(name: "Proof", dependencies: ["Engine", "Atom", "Compose"]),
        // .executableTarget(name: "SelfTest", dependencies: ["Theory"]),

        // Theory is standalone — all papers, primitives, axes, markers, witness.
        // The LawCheck plugin runs lint-law.sh on every build (pure types, no renames).
        .target(name: "Theory", plugins: ["LawCheck"]),

        // Structural enforcement of THE LAW, wired into the build itself.
        .plugin(name: "LawCheck", capability: .buildTool()),

        // A user of the lattice: physical/abstract domains conforming to V=I.
        // Application code, not the law — so no LawCheck plugin here.
        .target(name: "Domains", dependencies: ["Theory"]),
    ]
)
