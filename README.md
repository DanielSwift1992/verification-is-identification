# Verification Is Identification

**Zero-runtime programming.** The compiler enumerates every state a system can reach, proves each one, and a renderer writes each one to disk as a page. An action is a link. Nothing is left to run: **the build is the run**.

[![The playground: Swift types on the left, the judged and drawn page on the right.](https://raw.githubusercontent.com/DanielSwift1992/typed-playground/main/screenshot.png)](https://danielswift1992.github.io/typed-playground/)

**[Open the playground →](https://danielswift1992.github.io/typed-playground/)** — Swift types on the left, the page they draw on the right, and the judge names every broken claim as you type: no install, no server. Every tab there is a real Swift file, and this repository re-checks the same files.

## Run the proof

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification && cd verification-is-identification && swift build
```

A clean build takes 27 seconds on a laptop, and incremental builds take seconds. Green means every stated claim is proved: the theory, the access policy, the 200-person company, and every page of its site. Break a rule in [`Sources/Organization/System/Policy.swift`](Sources/Organization/System/Policy.swift), rebuild, and the refusal names what you broke.

```sh
swift test                              # the worked demos: ice's residual entropy, hydrogen's spectrum, a scheduler
swift build -Xswiftc -DSHOW_UNSAT       # watch it reject an impossible schedule
swift build -Xswiftc -DSHOW_FORBIDDEN   # and a forbidden spectral line, by name
swift run Tools site                    # build and serve the whole documentation site locally
```

(`swift test` prints "Executed 17 tests" for the real suite. The "0 tests" line after it is the newer Swift Testing harness finding no `@Test` functions, expected and not a failure.)

## The map

- [`Sources/VerificationIsIdentification`](Sources/VerificationIsIdentification) — the theory: 164 protocols, one per claim, with the compiler as the proof checker. It prints its own dependency map: [the atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/), one row per claim, heaviest first.
- [`Sources/Organization`](Sources/Organization) — the showcase: 200 people, the access policy, the whole site as types. Files named `Generated*` are build products: read the policy, not the generated people.
- [`Sources/DocumentKit`](Sources/DocumentKit) — the engine: pages, tables, SVG, and text metrics, written in the notation it renders.
- [`Papers`](Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers) — the 23 papers that derive the chain, rendered into [the documentation site](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification).
- [`Curve`](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/curve) — the measurement: build time against company size, to 12800 employees.

## The gates

The repository checks itself. Each command below is a gate, and green means passed:

- `swift build` — type-checks the whole system, and the LawCheck plugin lints the engine and the company as it builds: a violation refuses the build by name.
- `swift run Tools grammar` — every source file re-stated in a typed vocabulary and judged by the compiler: a style violation is a compile error naming its own rule.
- `swift run Tools census` — declarations counted per target: zero structs, zero classes, zero runtime functions across the theory, engine, and company rows. The demos' plain Swift and the tooling sit in their own rows, counted beside them.
- `swift run Tools judge diff 200` — a second, linear checker reads the generated company beside the compiler: four lies are planted, and both checkers must refuse each one, naming the same facts.
- `swift package --allow-writing-to-package-directory tree-sort check` — checks that the docs' topic tree matches the type structure.
- `swift package --allow-writing-to-package-directory generate` — regenerates the employees, the walks, the login pictures, and the card art: in Swift, in-repo.

## One rule, three positions

Take a company policy: *only a manager may administer a department's documents.* In a dynamic language the rule is an `if` that runs in production, and a test finds the bug or nothing does. With static types the shapes are proved at build time, but the rule itself still waits for a guard to run. Here the rule moves to build time too: it is a `where` clause on a type, people and documents are types, so an access request is also a type — the compiler answers it by compiling it or refusing it with the reason. This is the shipped policy from `Sources/Organization`, trimmed to the rule:

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

No test mentions Carol, and none is needed. The compiler checks every access the code states, on every build. A denied access fails to compile, and the error names the premise that failed: Carol's rank. The playground's **Plant a lie** button does the same live: one alias flips deep in a 200-person file, and the judge refuses it by line and by name.

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

A program lives in two times: build time, when the compiler constructs the artifact, and run time, when the artifact executes. Generics already compute at build time: the source contains no `List<Int>`, the compiler creates it from the constraints you wrote. SwiftUI made this a paradigm — a result builder assembles a screen's structure while the compiler compiles, and it does not exist in the running app. Apple changed the language for its sake. This package takes the same mechanism to its end: build-time functions generate the complete tree of the program, every state the system can reach, each one proved. At run time only the user acts, choosing the next link.

## The state explosion

Generating every state should blow up the memory. In ordinary code it would: a single 32-byte `var s: String` ranges over 2²⁵⁶ possible values, about as many as there are atoms in the observable universe. The type `String` constrains what the value is, not how many values are possible. And values are the easy half: where would the dynamics come from — memory, interaction, everything a runtime function does?

Two moves make it possible. First, state exists only as a written type, so every degree of freedom is typed and finite. The state space is exactly what you stated: small enough to enumerate, prove, and render on every build. And when exactly one structure passes every stated check, verifying it and identifying it are the same act: verification is identification.

Second, the dynamics are navigation. A renderer writes every proved state to disk as an address: a page, or a fragment inside a page. An action is a link, so navigation is the only operation, and every transition was proved at build time. The current state is the current address, so no variable holds it: it is in the URL.

## The proof in this repository

The package is a stack of layers. Each layer is built from the same types, and each adds one capability:

| Layer | What it holds | What it gives |
| --- | --- | --- |
| `VerificationIsIdentification` | the theory: 164 protocols, derived across 23 papers | compiling a claim is checking it: no separate prover runs |
| `DocumentKit` | the render engine: pages, tables, SVG, a vector pen, text metrics parsed from the font's TTF, the guided walks | a page is a type, a drawing is a type, and a label wider than its slot refuses the build |
| `Organization` | the company: 200 people, the policy, the site | access, logins, search walks, reports, re-proved by every build |
| `Alphabet` | one type per character | the renderer and the linter share one vocabulary |
| `GrammarLexicon` | the style law: scopes and grants for every source region | even the linter is this mechanism: a source file is re-stated as one typed object, and the compiler judges it |
| `Tools` | the only code that executes | generators and the census: they write files, and the census prints its counts onto the diagram the build drew |

None of this uses `Int`, `String`, or Foundation in the system code. In the engine, a number is a type and a text is a type: coordinates, sizes, and glyph widths are named types the checker composes, and strings exist only as rendered output. The company alone counts 989 types, 0 structs, 0 classes, 0 runtime functions, and the engine and the theory count 0 runtime functions the same way. Every function that does execute belongs to the build tooling, counted separately, beside the system it serves.

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

**[Read the documentation →](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — every protocol and every paper, browsable.

## Interaction without a runtime

A site rendered ahead of time sounds limited: no interaction, no memory, no animation. The login keypad on any person's card refutes all three at once:

- You enter a four-digit code by pressing keys, and a key press follows a link to the next state. That is interaction.
- The state `k2` means "two correct digits so far", and the URL fragment holds it. That is memory.
- The states switch with CSS transitions, declared from the same types. That is animation.

A wrong digit, at any depth, leads to one shared `dead` state, so the 9⁴ = 6561 possible sequences on its nine keys need five states instead of a tree of branches. The last correct digit is a real link out of the keypad, to the unlocked page. That page's type compiles only because the code matches the page's secret, so reaching it is the proof. The result is login with no server, no session, and no code that checks a digit: the state machine is prerendered links. It demonstrates the mechanism, not secrecy: the pages are static files, and the site prints each password on the card it belongs to. What the build proves is agreement: the walk, the secret, and the unlocked address name the same person. The same merge holds across the system: states with identical continuations become one state, and the access policy covers 200 people with four certified rules the same way.

## Computing less, on purpose

A language that runs code is Turing-complete: it can compute anything, and pays for it — almost no property of an arbitrary program is decidable in advance, so tests cover the cases someone wrote and the remainder ships unverified. Here the input is finite and stated, so every question you can write down is decided on every build: the type checker answers yes by compiling, and no by a refusal that names its reason. The parts of the world you cannot state exactly stay outside, still handled by you. And checked means consistent with what you stated: whether you stated the right rule is yours to judge, and no build, here or anywhere, answers that for you.

## A company as types

The company lives in the `Organization` target. Every build re-proves the access policy and renders the site from the same types: dashboard, catalogs, reports, personal cards, keypad logins. Navigation is proved too: the site carries guided walks that reach any page in four choices, and any of the 204 people — the 200 generated plus the four named — in eight.

[![The package, top down: the V=I type lattice, the DocumentKit engine that renders and walks it, the Organization written in both, and the two outputs of every build, the rendered site and the console audit.](Sources/Organization/Organization.docc/Resources/architecture.svg)](https://danielswift1992.github.io/verification-is-identification/documentation/organization)

The diagram above is generated by the build it describes. `DocumentKit` computes the layout from the same types the pages use, the type checker fits every label by its measured width, and the census on each box (types, runtime functions) comes from this build.

**[Browse the company →](https://danielswift1992.github.io/verification-is-identification/documentation/organization)**

## Why Swift

The notation is not Swift-specific. In principle it fits any language whose compiler solves constraints over types: Haskell's type classes, Rust's traits, and Scala's givens carry the same mechanism. Swift is where this package states it, and the fit is direct: an `associatedtype` introduces a type, a `where` clause constrains it, and a protocol that compiles is a claim that holds. So the proof checker is `swift build`: no separate prover to install, learn, or trust. The compiler is mainstream and LLVM-based, and DocC generates the documentation from the same types, so it cannot drift from the code. Swift is open source on macOS, Linux, and Windows, speaks C and C++, and has a runtime-free embedded subset, so the checker runs anywhere and a system built on it ships from servers to bare metal.

## How far it goes

The same operation extends beyond checking. Two of its consequences: a system that only checks eventually holds every answer in memory and stops computing, and the difference between two such systems is a measurable distance. Twenty-three papers derive the chain step by step, and the documentation covers all of it.

## Documentation

The full theory and every application, one site, generated from this package and published with GitHub Pages:

- **[VerificationIsIdentification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** — the framework: the protocols and the papers.
- **[Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples)** — the framework applied: the physics demos and a working solver.
- **[Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization)** — the framework at scale: a whole company as types, its site proved by the build.
- **[DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit)** — the rendering engine and the guided walks, written in the notation they render.
- **[GrammarLexicon](https://danielswift1992.github.io/verification-is-identification/documentation/grammarlexicon)** — the style linter's vocabulary: the words, scopes, and grants sources are judged in.
- **[Alphabet](https://danielswift1992.github.io/verification-is-identification/documentation/alphabet)** — one atom per character, shared by the renderer and the linter.

## License

MIT
