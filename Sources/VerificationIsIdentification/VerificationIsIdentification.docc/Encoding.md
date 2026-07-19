# Encoding patterns

How to write a part of your own system as types, where a green build is the proof.

## Overview

The framework checks structure for free. Turning your problem into that structure is the one thing it leaves to you (Law §0′). The patterns here come from the lattice: two moves, and the few shapes a property can take.

**The two moves.** *Expand* opens an axis for each quantity (`associatedtype`). *Compress* pins its relations with `where`. Then ask the compiler. If it compiles, the part is proved, and a version that contradicts itself will not build.

## The shapes are the markers

Each shape a property can take is one of the lattice's markers. Conform to the one that fits.

| Your property | The marker | What is true once it compiles |
| --- | --- | --- |
| a yes/no test | ``Decidable`` | every case lands in or out |
| one determined value | ``Measurable`` | one value, settled |
| a bounded count | ``IntegerValued`` | a count that cannot run forever |
| something that only narrows | ``Monotone`` | it can only shrink |
| something that only accumulates | ``Permanent`` | it can only grow |
| exactly one survivor | ``Unique`` | exactly one candidate is left |
| a distance between two | ``MetricProperty`` | the two are a stated distance apart |

The landing groups these as the medium. To turn a full claim into a protocol, follow the translation in ``Law`` (§T): quantity to an axis, premise to a parent, conclusion to a `where` at the fixpoint.

## A worked example

A scheduler, in three steps. Tasks run on two machines, and two conflicting tasks must land on opposite ones.

```swift
// 1. Pin one task to a machine — the seed the rest grows from.
typealias T0 = Pinned<MachineA>

// 2. Declare the conflicts. The compiler propagates the forced assignment.
typealias T1 = Conflicts<T0>   // forced to B
typealias T2 = Conflicts<T1>   // forced to A
typealias T3 = Conflicts<T2>   // forced to B
machineName(T3.self)           // "B" — decided at compile time, this reader only prints it

// 3. Require a conflict. It compiles only if the schedule is consistent.
Require<Conflict<T3, T0>>.self      // ✅ B vs A — the schedule is proved
// Require<Conflict<T0, T2>>.self   // ❌ A vs A — will not compile
```

Checking the schedule and finding it are one act: the compiler derived the single assignment and certified it. A false schedule is one you cannot write down. The full source is in [Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples), beside ice's residual entropy and hydrogen's spectrum.

## The one caveat

The compiler proves your encoding is self-consistent, never that it matches what you meant. A wrong encoding compiles into a confident proof of the wrong thing (V=I §6: correctness is relative to the relation you wrote). The framework clears the structural bugs and hands back exactly one job: write the relation that says what you mean. That job is the craft, and it remains yours.

## In your own package

The lattice is one SPM dependency, and the proof checker is the compiler you already run. This manifest builds as written:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YourSystem",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/DanielSwift1992/verification-is-identification", branch: "main"),
    ],
    targets: [
        .target(name: "YourSystem", dependencies: [
            .product(name: "VerificationIsIdentification", package: "verification-is-identification"),
        ]),
    ]
)
```

Then `import VerificationIsIdentification`, state the part you must be sure of, and read the build.

Two worked encodings of one physical sense are in the papers: the sensor is derived in <doc:seeing_is_encoding>, and the measure in <doc:light_is_a_ruler>.

## Showing the part you encoded

The surface is the same discipline: a page is a type, and its markdown is the type's name. [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit) builds a page in five steps, and [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization) is that surface run at scale: the encoded company and its site, one build.
