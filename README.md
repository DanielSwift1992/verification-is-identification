# Verification Is Identification

**Zero-runtime programming.** The compiler enumerates every state a system can reach. It proves each one. A renderer writes each one to disk as a page. An action is a link. Nothing is left to run: **the build is the run**.

[![The playground: Swift types on the left, the judged and drawn page on the right.](https://raw.githubusercontent.com/DanielSwift1992/typed-playground/main/screenshot.png)](https://danielswift1992.github.io/typed-playground/)

**[Open the playground →](https://danielswift1992.github.io/typed-playground/)**: Swift types on the left, the page they draw on the right. The judge names every broken claim as you type. It is one static page: no install, no server. Every tab is a real Swift file. This repository re-checks the same files.

## Run the proof

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification && cd verification-is-identification && swift build
```

Green means every stated claim is proved: the theory, the access policy, the 204-person company, and every page of its site. A clean build takes 27 seconds on a laptop. An incremental build takes seconds. Four things to try:

- Break a rule in [`Sources/Organization/System/Policy.swift`](Sources/Organization/System/Policy.swift) and rebuild. The error names what you broke.
- `swift test` runs the worked demos: ice's residual entropy, hydrogen's spectrum, a scheduler. It prints "Executed 17 tests". The trailing "0 tests" line is expected: the newer Swift Testing harness finds no `@Test` functions there.
- `swift build -Xswiftc -DSHOW_UNSAT` rejects an impossible schedule by name. `-DSHOW_FORBIDDEN` rejects a forbidden spectral line.
- `swift run Tools site` builds and serves the whole documentation site locally.

## One rule, three positions

The policy is one sentence: *only a manager may administer a department's documents.*

In a dynamic language the rule is an `if`. It runs in production. A test finds the bug, or nothing does. With static types the shapes are proved at build time. The rule itself still waits for a guard to run. Here the rule moves to build time too. People and documents are types. The rule is a `where` clause. An access request is a type as well: the compiler compiles it, or refuses it and names the reason. This is the shipped policy from `Sources/Organization`, trimmed to the rule:

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

No test mentions Carol. None is needed. The compiler checks every access the code states, on every build. A denied access fails to compile. The error names the premise that failed. The playground's **Plant a lie** button does the same live. Its At scale tab judges a 12,800-person file on every keystroke.

| Concept | Dynamic | Statically typed | This notation |
| --- | --- | --- | --- |
| Data | a dict, shaped at runtime | a struct, shaped by the compiler | an empty `enum`: a pure type |
| A rule | an `if` | a guard over typed values | a `where` clause |
| A question | a call | a call | a type instantiation |
| A change of state | mutation | mutation, or a new value | a new type |
| A decision lands | at runtime | at runtime | at compile time |
| A green build means | it parsed | the types line up | every stated claim is proved |
| In production | everything runs | everything runs | nothing runs: the build already was the run |

## What is happening

A program lives in two times. At build time the compiler constructs the artifact. At run time the artifact executes. Object-oriented and functional organize code. They say nothing about when a decision lands.

The two times give one property: a function can execute at build time and generate a structure that is static at run time. Generics already do this. The source contains no `List<Int>`. The compiler creates it from the constraints you wrote. SwiftUI made this a paradigm: a result builder assembles the screen while the compiler compiles. Apple changed the language for its sake.

This package takes the mechanism to its end. Build-time functions generate the complete tree of the program. Every state is proved. At run time the user only chooses the next link.

## The state explosion

Generating every state should blow up the memory. In ordinary code it would. A single 32-byte `var s: String` ranges over 2²⁵⁶ possible values, about as many as atoms in the observable universe. The type `String` constrains what the value is, not how many values are possible. And values are the easy half. Memory, interaction, everything a runtime function does still needs a home.

Two moves close both gaps.

First, state exists only as a written type. Every degree of freedom is typed and finite. The state space is exactly what you stated: small enough to enumerate, prove, and render on every build. When exactly one structure passes every stated check, verifying it and identifying it are the same act: **verification is identification**. The package is named for this theorem. The papers derive it.

Second, the dynamics are navigation. A renderer writes every proved state to disk as an address: a page, or a fragment inside a page. An action is a link. Navigation is the only operation. Every transition was proved at build time. The current state is the current address. No variable holds it: the URL does.

## Interaction without a runtime

A site rendered ahead of time sounds limited: no interaction, no memory, no animation. The login keypad on any person's card refutes all three.

- A key press follows a link to the next state. That is interaction.
- The state `k2` means two correct digits so far. The URL fragment holds it. That is memory.
- The states switch with CSS transitions, declared from the same types. That is animation.

A wrong digit at any depth lands in one shared dead state. So the 9⁴ = 6561 possible input sequences need five states. The last correct digit is a link out of the keypad, to the unlocked page. That page's type compiles only because the code matches. Reaching it is the proof.

The result is login with no server, no session, and no JavaScript. It demonstrates the mechanism, and it keeps no secrets: the pages are static files, and the site prints each password on its card. What the build proves is agreement: the walk, the secret, and the unlocked address name the same person. The same merge holds across the system. States with identical continuations become one state. The access policy covers the 204 people with four certified rules the same way.

## Computing less, on purpose

A language that runs code is Turing-complete: it can compute anything. That power has a price. Almost no property of an arbitrary program is decidable in advance. The tooling samples what it can. The rest ships unverified.

Functional programming removed side effects from evaluation. Total languages like Agda go further: every program provably terminates. Both still run, because the input arrives at run time.

Here the input is finite and stated. Every question you can write down is decidable. The type checker answers yes by compiling. It answers no with a refusal that names its reason. The parts of the world you cannot state exactly stay outside, still handled by you. Checked means consistent with what you stated. Whether you stated the right rule stays yours to judge. No build, here or anywhere, answers that for you. [Purpose](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/purpose) draws the boundary in full.

*Write a system as types. If it compiles, it cannot disagree with its own claims.*

## A company as types

The `Organization` target is the showcase. Every build re-proves and re-renders the 204 people, the access policy, and the company's whole site: dashboard, catalogs, reports, personal cards, keypad logins. Navigation is proved too. Guided walks reach any page in four choices, and any of the 204 people in eight.

[![The package, top down: the V=I type lattice, the DocumentKit engine that renders and walks it, the Organization written in both, and the two outputs of every build, the rendered site and the console audit.](Sources/Organization/Organization.docc/Resources/architecture.svg)](https://danielswift1992.github.io/verification-is-identification/documentation/organization)

The diagram is generated by the build it describes. The layout is computed from the same types the pages use. Every label is fitted by its measured width. The census on each box comes from this build.

## The map

[`Sources/VerificationIsIdentification`](Sources/VerificationIsIdentification) is the theory: 164 protocols, one per claim. The compiler is the proof checker. The theory prints its dependency map, [the atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/): one row per claim, heaviest first.

[`Sources/Organization`](Sources/Organization) is the showcase: 204 people, the access policy, and the whole site as types. Files named `Generated*` are build products. Read the policy, not the generated people. [`Sources/DocumentKit`](Sources/DocumentKit) is the engine: pages, tables, SVG, and text metrics, written in the notation it renders.

The 23 papers that derive the chain live in [`Papers`](Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers). They render into [the documentation site](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification). The [Curve](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/curve) page holds the measurement: build time against company size, to 12,800 employees.

## The gates

The repository checks itself. Each command is a gate. Green means passed:

- `swift build` type-checks the whole system. The LawCheck plugin lints the engine and the company as it builds. A violation refuses the build by name.
- `swift run Tools grammar` re-states every source file in a typed vocabulary for the compiler to judge. A style violation is a compile error that names its rule.
- `swift run Tools readme` re-counts every number this page states, from the artifact that owns it. The gate refuses a drifted claim by name.
- `swift run Tools census` counts declarations per target: zero structs, zero classes, zero runtime functions across the theory, engine, and company rows.
- `swift run Tools judge diff 200` sets a second, linear checker beside the compiler. Four lies are planted in the generated company. Both checkers must refuse each one and name the same facts.
- `swift package --allow-writing-to-package-directory tree-sort check` holds the docs' topic tree, and the atlas, equal to the type structure.
- `swift package --allow-writing-to-package-directory generate` regenerates the employees, the walks, the logins, and the card art: in Swift, in-repo.

## Documentation

The whole site is generated from this package. The 23 papers derive the chain. The two furthest state where it lands: a system that only checks eventually holds every answer and stops computing, and the distance between two such systems is measurable.

- **[VerificationIsIdentification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** holds the framework: the protocols, the papers, [the atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/).
- **[Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples)** applies it: the physics demos and a working solver.
- **[Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization)** scales it: a whole company as types, its site proved by the build.
- **[DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit)** carries the rendering engine and the guided walks, written in the notation they render.
- **[GrammarLexicon](https://danielswift1992.github.io/verification-is-identification/documentation/grammarlexicon)** is the style linter's vocabulary: the words, scopes, and grants sources are judged in.
- **[Alphabet](https://danielswift1992.github.io/verification-is-identification/documentation/alphabet)** holds one atom per character, shared by the renderer and the linter.

## License

MIT
