# Verification Is Identification

**Zero-runtime programming.** The result is browsable: **[the documentation site](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)**.

The compiler enumerates every state a system can reach, proves each one, and a renderer writes each one to disk as a page. An action is a link. Nothing is left to run: **the build is the run**.

## One rule, three positions

Take a company policy: *only a manager may administer a department's documents.* Alice is a manager in Finance. Carol is an individual contributor in Finance. The rule is the same three times below. What changes is how much of the program lives at build time.

**Dynamic.** Everything lives at run time. The rule, the shapes, even the field names are checked only when this line executes: in production, unless a test got there first.

```python
def administer(document, user):
    if user.rank != "manager" or user.department != document.department:
        raise AccessDenied()               # found out when this line runs
```

**Statically typed.** The shapes moved to build time: `rank` is an enum, so a misspelled rank cannot be written, and the compiler proves every shape before anything runs. The rule itself still lives at run time: the guard runs in production, and a test samples it.

```swift
func administer(_ document: Document, as user: Employee) throws {
    guard user.rank == .manager, user.department == document.department
    else { throw AccessDenied() }          // the rule still waits for this line to run
}

#expect(throws: AccessDenied.self) {
    try administer(financeShare, as: carol)   // holds for the cases you wrote
}
```

**This notation.** The rule moved too: it is a `where` clause on a type. People and documents are types, so an access request is also a type: you ask by writing it, and the compiler answers by compiling it or rejecting it with the reason. This is the shipped policy from `Sources/Organization`, trimmed to the rule:

```swift
public enum Carol: Employee {                     // a person is a type
    public typealias Rank = IndividualContributor
    public typealias Home = Finance
    // ...name, birth year, workplace: more of the same
}

public enum Administer<Who: Employee, Of: Doc> {}
extension Administer: Authorized                  // the rule is a `where` clause
where Who.Rank: CanAdmin, Who.Home == Of.Home {}

Granted<Administer<Alice, FinanceShare>>.self     // ✅ compiles: the access is proved
Granted<Administer<Carol, FinanceShare>>.self     // ❌ error: type 'Carol.Rank' (aka
                                                  //    'IndividualContributor') does not
                                                  //    conform to protocol 'CanAdmin'
```

No test mentions Carol, and none is needed. The compiler checks every access the code states, on every build. A denied access fails to compile, and the error names the premise that failed: Carol's rank.

The concepts you already use map one to one:

| Concept | Dynamic | Statically typed | This notation |
| --- | --- | --- | --- |
| Data | a dict, shaped at runtime | a struct, shaped by the compiler | an empty `enum`: a pure type |
| Behavior | functions | functions | conformances |
| A rule | an `if` | a guard over typed values | a `where` clause |
| A question | a call | a call | a type instantiation |
| A change of state | mutation | mutation, or a new value | a new type |
| Repetition | a loop | a loop, a `map` | a builder body, folded by the compiler |
| A decision | at runtime | at runtime | at compile time |

## What is happening

A program lives in two times: build time, when the compiler constructs the artifact, and run time, when the artifact executes. Languages spread along this line, and the spread is not a split into camps: Python decides nearly everything at run time yet carries typed libraries, Rust decides much at build time. Object-oriented and functional sit off this line entirely: they organize code, and say nothing about when it is decided.

The two times give one property: a function can execute at build time and generate a structure that is static at run time. Generics already do this. `List<T>` is a template. The source contains no `List<Int>`: the compiler creates it from the constraints you wrote, and it can create every other form the same way. SwiftUI made this a paradigm with result builders. A result builder is a build-time function: it assembles a screen's structure while the compiler compiles, and it does not exist in the running app. Apple changed the language for this mechanism: result builders entered Swift for SwiftUI's sake.

## What this package does

It takes the same mechanism to its end. SwiftUI generates the static shape of one screen. Here, build-time functions generate the complete tree of the program from the stated constraints: every state the system can reach, each one proved. Nothing is left to run: **the build is the run**. At run time only the user acts, choosing the next link.

## The state explosion

Generating every state should blow up the memory. In ordinary code it would: a single 32-byte `var s: String` ranges over 2²⁵⁶ possible values, about as many as there are atoms in the observable universe. The type `String` constrains what the value is, not how many values are possible. And values are the easy half: where would the dynamics come from — memory, interaction, everything a runtime function does?

Two moves make it possible. First, state exists only as a written type, so every degree of freedom is typed and finite. The state space is exactly what you stated: small enough to enumerate, prove, and render on every build. And when exactly one structure passes every stated check, verifying it and identifying it are the same act: verification is identification.

Second, the dynamics are navigation. A renderer writes every proved state to disk as an address: a page, or a fragment inside a page. An action is a link, so navigation is the only operation, and every transition was proved at build time. The current state is the current address, so no variable holds it: it is in the URL.

## The proof in this repository

The package is a stack of layers. Each layer is built from the same types, and each adds one capability:

| Layer | What it holds | What it gives |
| --- | --- | --- |
| `VerificationIsIdentification` | the theory: 154 protocols, derived across 22 papers | compiling a claim is checking it: no separate prover runs |
| `DocumentKit` | the render engine: pages, tables, SVG, a vector pen, text metrics parsed from the font's TTF, the guided walks | a page is a type, a drawing is a type, and a label wider than its slot refuses the build |
| `Organization` | the company: 200 people, the policy, the site | access, logins, search walks, reports, re-proved by every build |
| `Alphabet` | one type per character | the renderer and the linter share one vocabulary |
| `GrammarLexicon` | the style law: scopes and grants for every source region | even the linter is this mechanism: a source file is re-stated as one typed object, and the compiler judges it |
| `Tools` | the only code that executes | generators and the census: they write files, and the census prints its counts onto the diagram the build drew |

None of this uses `Int`, `String`, or Foundation in the system code. In the engine, a number is a type and a text is a type: coordinates, sizes, and glyph widths are named types the checker composes, and strings exist only as rendered output. The company alone counts 1059 types, 0 structs, 0 classes, 0 runtime functions, and the engine and the theory count 0 runtime functions the same way. Every function that does execute belongs to the build tooling, counted separately, beside the system it serves.

## The comparison

|  | Dynamic | Statically typed | This notation |
| --- | --- | --- | --- |
| The compiler sees | the syntax | the shape of every value | every state of the system |
| A wrong program | crashes at runtime | wrong shapes refuse the build, wrong logic waits for a test | cannot be written: the build refuses and names the broken rule |
| A bug surfaces | when that line runs, maybe in production | shape bugs at build, logic bugs at test time or later | at the next build, always |
| Checked for you | nothing before the run | the types you declared | every claim the code states |
| A green build means | it parsed | the types line up | every stated claim is proved |
| In production | everything runs | everything runs | nothing runs: the build already was the run |
| Documentation | written by hand, drifts | written by hand, drifts | generated from the same types, cannot drift |
| The power | Turing-complete: computes anything, proves nothing in advance | Turing-complete: computes anything, proves the shapes | computes less on purpose: every stated question is decided |
| The price | bugs found late | tests for the logic the types cannot see | the system stated in exact, finite terms |

*Write a system as types. If it compiles, it cannot be wrong.*

📖 **[Read the documentation →](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — every protocol and every paper, browsable.

## Interaction without a runtime

A site rendered ahead of time sounds limited: no interaction, no memory, no animation. The login keypad on any person's card refutes all three at once:

- You enter a four-digit code by pressing keys, and a key press follows a link to the next state. That is interaction.
- The state `k2` means "two correct digits so far", and the URL fragment holds it. That is memory.
- The states switch with CSS transitions, declared from the same types. That is animation.

A wrong digit, at any depth, leads to one shared `dead` state, so the 9⁴ = 6561 possible input sequences need five states instead of a tree of branches. The last correct digit is a real link out of the keypad, to the unlocked page. That page's type compiles only because the code matches the page's secret, so reaching it is the proof. The result is login with no server, no session, and no JavaScript. It demonstrates the mechanism, not secrecy: the pages are static files, and the site prints each password on the card it belongs to. What the build proves is agreement: the walk, the secret, and the unlocked address name the same person. The same merge holds across the system: states with identical continuations become one state, and the access policy covers two hundred people with four certified rules the same way.

## Computing less, on purpose

A language that runs code is Turing-complete: it can compute anything. That power has a price. For an arbitrary program, almost no property is decidable in advance, so the tooling approximates: tests cover the cases someone wrote, analyzers catch some of the rest, and the remainder ships unverified.

Functional programming removed side effects from evaluation. Total languages like Agda went further: every program provably terminates. Both still run, because the input arrives at run time. Here the input is finite and stated, so every question you can write down is decidable: the type checker answers yes by compiling, and no by a refusal that names its reason. The parts of the world you cannot state exactly stay outside the system, still handled by you. The parts you can state go inside, where every claim is checked on every build. Checked means consistent with what you stated: whether you stated the right rule is yours to judge, and no build, here or anywhere, can answer that for you.

## A company as types

The company lives in the `Organization` target. Every build re-proves the access policy and renders the site from the same types: dashboard, catalogs, reports, personal cards, keypad logins. Navigation is proved too: the site carries guided walks that reach your page in four choices, and any of 204 people in eight.

[![The package, top down: the V=I type lattice, the DocumentKit engine that renders and walks it, the Organization written in both, and the two outputs of every build, the rendered site and the console audit.](Sources/Organization/Organization.docc/Resources/architecture.svg)](https://danielswift1992.github.io/verification-is-identification/documentation/organization)

The diagram above is generated by the build it describes. `DocumentKit` computes the layout from the same types the pages use, the type checker fits every label by its measured width, and the census on each box (types, runtime functions) comes from this build.

**[Browse the company →](https://danielswift1992.github.io/verification-is-identification/documentation/organization)**

## Try it

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification
cd verification-is-identification

swift build   # type-checks the whole system and runs the law lint
swift test    # the worked demos — ice's residual entropy, hydrogen's spectrum, a scheduler

swift build -Xswiftc -DSHOW_UNSAT       # watch it reject an impossible schedule
swift build -Xswiftc -DSHOW_FORBIDDEN   # and a forbidden spectral line, by name

swift run Tools site   # build and serve the whole documentation site locally
```

A clean build of all of it, 154 theory protocols and the whole company included, takes 23 seconds on a laptop. Incremental builds take seconds.

`swift test` runs two harnesses back to back: "Executed 17 tests, with 0 failures" is
the real suite. The "0 tests" line after it is the newer Swift Testing harness finding
no `@Test` functions, expected and not a failure.

The repository checks itself. Each command below is a gate, and green means passed:

- `swift build` — strict law lint on the library targets: a violation refuses the build by name.
- `swift run Tools grammar` — every source file re-stated in a typed vocabulary and judged by the compiler: a style violation is a compile error naming its own rule.
- `swift run Tools census` — declarations counted per target: zero structs, zero classes, zero runtime functions across the system rows. What executes sits in the tooling row.
- `swift package tree-sort check` — checks that the docs' topic tree matches the type structure.
- `swift package --allow-writing-to-package-directory generate` — regenerates the roster, the walks, the login pictures, and the card art: in Swift, in-repo.

## Why Swift

The notation is not Swift-specific. In principle it fits any language whose compiler solves constraints over types: Haskell's type classes, Rust's traits, and Scala's givens carry the same mechanism. Swift is where this package states it, and the fit is direct: an `associatedtype` introduces a type, a `where` clause constrains it, and a protocol that compiles is a claim that holds. So the proof checker is `swift build`: no separate prover to install, learn, or trust. The compiler is mainstream and LLVM-based, and DocC generates the documentation from the same types, so it cannot drift from the code. Swift is open source on macOS, Linux, and Windows, speaks C and C++, and has a runtime-free embedded subset, so the checker runs anywhere and a system built on it ships from servers to bare metal.

## How far it goes

The same operation extends beyond checking. Two of its consequences: a system that only checks eventually holds every answer in memory and stops computing, and the difference between two such systems is a measurable distance. Twenty-two papers derive the chain step by step, and the documentation covers all of it.

## Documentation

The full theory and every application, one site, generated from this package and published with GitHub Pages:

- **[VerificationIsIdentification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — the framework: the protocols and the papers.
- **[Playground](https://danielswift1992.github.io/verification-is-identification/documentation/playground)** — the framework applied: the physics demos and a working solver.
- **[Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization)** — the framework at scale: a whole company as types, its site proved by the build.
- **[DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit)** — the rendering engine and the guided walks, written in the notation they render.
- **[GrammarLexicon](https://danielswift1992.github.io/verification-is-identification/documentation/grammarlexicon)** — the style linter's vocabulary: the words, scopes, and grants sources are judged in.
- **[Alphabet](https://danielswift1992.github.io/verification-is-identification/documentation/alphabet)** — one atom per character, shared by the renderer and the linter.

## Start

One command runs the whole proof on your machine:

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification && cd verification-is-identification && swift build
```

A green build has just proved the theory, the policy, the company, and every page of its site. Break a rule in `Sources/Organization/System/Policy.swift`, rebuild, and read the refusal: it names what you broke.

## License

MIT
