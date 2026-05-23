// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VerificationIsIdentification",
    products: [
        .library(name: "Engine", targets: ["Engine"]),
        .library(name: "Atom", targets: ["Atom"]),
        .library(name: "Compose", targets: ["Compose"]),
        .library(name: "Agent", targets: ["Agent"]),
        .executable(name: "Proof", targets: ["Proof"]),
        .executable(name: "SelfTest", targets: ["SelfTest"]),
    ],
    targets: [
        .target(name: "Engine"),
        .target(name: "Atom", dependencies: ["Engine"]),
        .target(name: "Compose", dependencies: ["Engine", "Atom"]),
        .target(name: "Agent"),
        .executableTarget(name: "Proof", dependencies: ["Engine", "Atom", "Compose"]),
        .executableTarget(name: "SelfTest", dependencies: ["Agent"]),
    ]
)
