# V=I Framework

A Swift package that turns `swift build` into a checker for any system you can state in exact terms: write the rules as protocols and the states as types, and a state that breaks a rule becomes a compile error that names the rule. For Swift developers first — nothing new to install, the checker is the compiler you already run; the theory and the papers behind it are in the documentation, for anyone going deeper.

**Software with no runtime. The only move is a link.**

*Write a system as types. If it compiles, it cannot be wrong.*

**What you get.** Take any system you need to get right — a config, a schedule, a protocol, a physics model — and write its structure in this notation. The compiler then catches a whole class of bugs for free: every way that structure could contradict itself becomes a build error, before anything runs. What it costs you: you pin the system down in exact, finite terms, and the fuzzy or continuous parts stay yours. In return, where it compiles, it cannot be wrong — and you can do it one part at a time, each part trustworthy for the price of a build.

**Why it works.** One game runs under every determinate system: draw a distinction, or close one, until a single structure survives. To check that survivor is to identify it — verification and identification are one act. Formally, it is one operation, binary comparison over finite structures, and the consequences that follow.

📖 **[Read the documentation →](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — every protocol and every paper, browsable.

## See it

Here is that collapse as code — a scheduler, from `Sources/Playground/Coloring.swift`. Tasks run on two machines, and each conflict forces a task onto the opposite one. The compiler propagates the assignment and checks it, with nothing run:

```swift
typealias T0 = Pinned<MachineA>   // pin the first task to machine A
typealias T1 = Conflicts<T0>      // conflicts with T0  → forced to B
typealias T2 = Conflicts<T1>      // conflicts with T1  → forced to A
typealias T3 = Conflicts<T2>      // conflicts with T2  → forced to B

machineName(T3.self)              // "B" — the compiler derived the assignment, nothing ran

Require<Conflict<T3, T0>>.self    // ✅ compiles: B vs A is consistent — the schedule is proved
// Require<Conflict<T0, T2>>.self // ❌ will not compile: A vs A, an impossible schedule
```

Checking the schedule and finding it are one act: the compiler propagated the single assignment and certified it. Uncomment the last line — or build with `-DSHOW_UNSAT` — and it fails, reporting that `MachineA` would have to equal `MachineB`. A false schedule is one you cannot write down.

## Try it

A Swift package — the framework as pure types, where **a green build is the proof**. You write a claim as a protocol, and if it compiles, the claim holds. Nothing runs.

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification
cd verification-is-identification

swift build   # the type checker verifies the lattice; a plugin enforces the construction law
swift test    # the worked demos — ice's residual entropy, hydrogen's spectrum, the scheduler

swift build -Xswiftc -DSHOW_UNSAT       # watch it reject an impossible schedule
swift build -Xswiftc -DSHOW_FORBIDDEN   # and a forbidden spectral line, by name
```

`swift test` runs two harnesses back to back. Look for "Executed 17 tests, with 0
failures" first, that's the real suite (XCTest). The line after it, "0 tests in 0
suites," is the newer Swift Testing harness finding no `@Test` functions. Expected,
not a failure.

The system itself compiles with zero functions, zero classes, and zero stored
state — the law forbids them — and CI counts the declarations on every build
(`swift run Tools census`).

## The same program, three ways

| | OOP | Functional | Here |
| --- | --- | --- | --- |
| Data lives in | a class instance | an immutable value | a type: an empty `enum` |
| Behavior lives in | methods | functions | conformances |
| A decision is | an `if`, a dispatch | a pattern match | a `where` clause, resolved at compile time |
| Repetition is | a loop | a `map`, a `fold` | a builder body, folded by the compiler |
| State changes by | mutation | making a new value | making a new type — never at runtime |
| A wrong program is | caught by tests | narrowed by types, caught by tests | not compiled: it cannot be written |
| The program runs | at runtime | at runtime | never — the build is the run |

`swift run Tools census` prints the live counts behind the last column, target
by target: the columns for `struct`, `class`, and runtime `func` hold zeros
across the system's rows, and everything that executes sits in the tooling row,
counted beside the system it serves.

`swift package --allow-writing-to-package-directory generate` — the roster, the login walk, and
the card art are all regenerable, in Swift, in-repo.

The repository checks itself: `swift run Tools grammar Sources Plugins`
re-states every source file in a typed vocabulary and lets the compiler judge
it — a style violation is a compile error that names its own rule,
`swift package tree-sort check` holds the docs' topic tree equal to the type
lattice, and `swift run Tools census` counts what the laws forbid. Green across
the board is the review.

## Why Swift

Swift's type system expresses the notation directly: an `associatedtype` introduces a type, a `where` clause constrains it, and a protocol that compiles is a claim that holds. So the proof checker is just `swift build` — there is no separate prover to install, learn, or trust. The compiler is mainstream and LLVM-based, the same one millions already run, and DocC generates this documentation from those same types, so it cannot drift from the code.

It is not niche, either. Swift is open source on macOS, Linux, and Windows, speaks C and C++, and has a runtime-free embedded subset — so the checker runs anywhere, and a system built on it ships from servers to bare metal.

## How far it goes

The idea does not stay a checking trick. The same one operation, pushed further, forces real consequences — a system that only checks eventually holds every answer in memory and stops computing, and the difference between two such systems becomes a measurable distance. None of it is bolted on: it is derived, step by step across twenty papers, from that one operation. The documentation walks the whole chain.

## See it at scale

The same notation runs a whole company. The `Organization` target writes two hundred
people, their roles, documents, and the access policy as pure types, and renders the
company's own site — dashboard, directories, reports, audit — from those types at
build time. An access rule that contradicts the policy does not compile, and every
page is re-proved by every build. The rendering engine, `DocumentKit`, is itself
written in the notation it renders: a page is a type, and its markdown is the type's
name. Even finding your way is proved: the site carries walks — your page in four
choices, any of 204 people in eight (a phone book of types), or four doors that form a
(department, rank) pair whose own page reads the access verdicts — and every door names
exactly what it holds, read off the same types.

## Documentation

The full theory — every protocol and every paper, woven by the dependency lattice — renders as a browsable DocC site, generated from this package and published with GitHub Pages:

- **[VerificationIsIdentification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — the framework: the protocols and the papers.
- **[Playground](https://danielswift1992.github.io/verification-is-identification/documentation/playground)** — the framework applied: the physics demos and a working solver.
- **[Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization)** — the framework at scale: a whole company as types, its site proved by the build.
- **[DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit)** — the rendering engine, written in the notation it renders.

## License

MIT
