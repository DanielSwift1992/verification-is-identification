# Verification Is Identification

**Zero-runtime programming.** The compiler enumerates every state a system can reach. It checks each one against every stated rule. A renderer writes each one to disk as a web page. An action is a link. Nothing is left to run: **the build is the run**.

[![The playground: Swift types on the left, the judged and drawn page on the right.](https://raw.githubusercontent.com/DanielSwift1992/typed-playground/main/screenshot.png)](https://danielswift1992.github.io/typed-playground/)

**[Open the playground →](https://danielswift1992.github.io/typed-playground/)**: Swift types on the left, the page they draw on the right. A checker called the judge names every broken claim as you type. It is one static page: no install, no server. Every tab is a real Swift file. This repository re-checks the same files.

## Run the proof

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification && cd verification-is-identification && swift build
```

The package ships a worked system: a 204-person company, its access policy, and its whole intranet site, all written as types. Green means every stated claim is proved: the theory the package is built on, the policy, the company, and every page of the site. A clean build takes 27 seconds on a laptop. An incremental build takes seconds. Four things to try:

- Break a rule in [`Sources/Organization/System/Policy.swift`](Sources/Organization/System/Policy.swift) and rebuild. The error names what you broke.
- `swift test` runs the worked demos: two from physics (ice's residual entropy, hydrogen's spectrum) and a task scheduler. It prints "Executed 17 tests". The trailing "0 tests" line is expected: the newer Swift Testing harness finds no `@Test` functions there.
- `swift build -Xswiftc -DSHOW_UNSAT` rejects an impossible schedule by name. `-DSHOW_FORBIDDEN` rejects a forbidden spectral line. `-DSHOW_METAMER_SPLIT` splits a metameric pair of lights: the refusal names the infrared slot no eye reads.
- `swift run Tools site` builds and serves the whole documentation site locally.

## One rule, three positions

The company's policy is one sentence: *only a manager may administer a department's documents.*

In a dynamic language the rule is an `if`. It runs in production. A test finds the bug, or nothing does. With static types the data shapes are checked at build time. The rule itself still waits for a guard to run. Here the rule moves to build time too. People and documents are types. The rule is a `where` clause. An access request is a type as well: the compiler compiles it, or refuses it and names the reason. This is the shipped policy from `Sources/Organization`, trimmed to the rule:

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
| A decision | at runtime | at runtime | at compile time |
| A green build means | it parsed | the types line up | every stated claim is proved |
| In production | everything runs | everything runs | nothing runs: the build already was the run |

## What is happening

A program lives in two times. At build time the compiler constructs the artifact. At run time the artifact executes. Object-oriented and functional organize code. They say nothing about when a decision is made.

The two times allow one trick: a function can run at build time and generate a structure that is already fixed at run time. Generics do this today. The source contains no `List<Int>`. The compiler creates it from the constraints you wrote. SwiftUI made this a paradigm: a result builder assembles the screen while the compiler compiles. Apple changed the language for this: result builders entered Swift for SwiftUI.

This package takes the trick to its end. Build-time functions generate the complete tree of the program. Every state is checked. At run time the user only chooses the next link.

## The state explosion

Generating every state should blow up the memory. In ordinary code it would. A single 32-byte `var s: String` ranges over 2²⁵⁶ possible values, about as many as atoms in the observable universe. The type `String` constrains what the value is, not how many values are possible. And values are only half the problem. Memory, interaction, everything a runtime function does must come from somewhere too.

Two moves solve both.

First, state exists only as a written type. Everything that can vary is declared as a type, so it is finite. The state space is exactly what you stated: small enough to enumerate, check, and render on every build. When exactly one candidate can pass every check, the check does two jobs at once: it approves, and it picks out. Verifying and identifying are the same act: **verification is identification**. The package is named for this theorem. The papers derive it.

Second, change is navigation. A renderer writes every checked state to disk as an address: a page, or a fragment inside a page. An action is a link. Navigation is the only operation. Every transition was checked at build time. The current state is the current address. No variable holds it: the URL does.

## Interaction without a runtime

The company site is rendered ahead of time, every page of it. That sounds limited: no interaction, no memory, no animation. Four of the employee cards carry a login keypad, as the demonstration. The keypad refutes all three.

- A key press follows a link to the next state. That is interaction.
- The state `k2` means two correct digits so far. The URL fragment holds it. That is memory.
- The states switch with CSS transitions, declared from the same types. That is animation.

A wrong digit at any position lands in one shared dead state. So the 9⁴ = 6561 possible input sequences need five states. The last correct digit is a link out of the keypad, to the unlocked page. That page's type compiles only because the entered code matches. Reaching it is the proof.

The result is login with no server, no session, and no JavaScript. It demonstrates the mechanism, and it keeps no secrets: the pages are static files, and the site prints each password on its card. What the build proves is agreement: the key sequence, the secret, and the unlocked address name the same person. The same merge holds across the system. States with the same future become one state. The access policy covers the 204 people with four rules the same way.

## What cannot be written

An ordinary language is Turing-complete. It can compute anything. The cost: almost nothing about an arbitrary program can be proved in advance. Tests check the cases someone wrote. The rest ships unchecked.

Here one step of computation is a find-and-replace. A rule says: find this pattern in the state, put that in its place. One step of any program can be written this way, and the compiler proves that step. A thousand steps can be written: the count is part of what you write. "Repeat until done" cannot be written. A run with no stated end may have no end. Its final state may simply not exist, and this language only writes things that exist. So the halting question cannot even be asked here.

Loops therefore live outside. A generator runs the loop and writes each result down. Every result is a file. The build checks the whole file.

So everything you can write down, the compiler can decide. It says yes by compiling, or no with the reason. Proof languages like Agda prove a program will terminate, and then the program still runs, on input that arrives later. Here the input is already written, so the answer arrives at build time.

What you cannot write exactly stays outside, yours to handle. The build checks one thing: the system agrees with what you wrote. Whether you wrote the right rule is still your judgment. [Purpose](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/purpose) draws the boundary in full.

*Write a system as types. If it compiles, it cannot disagree with its own claims.*

## A company as types

The `Organization` target is the showcase. Every build re-proves and re-renders the 204 people, the access policy, and the company's whole site: dashboard, catalogs, reports, personal cards, keypad logins. Navigation is proved too. The site carries guided walks: a page asks a question, and each answer is a link. The walks reach any page in four choices, and any of the 204 people in eight.

[![The package, top down: the V=I type lattice, the DocumentKit engine that renders, walks, and rewrites it, the Organization written in both over a shared alphabet, and the two outputs of every build, the rendered site and the console audit.](Sources/Organization/Organization.docc/Resources/architecture.svg)](https://danielswift1992.github.io/verification-is-identification/documentation/organization)

The diagram is generated by the build it describes. The layout is computed from the same types the pages use. Every label is fitted by its measured width. The counts on each box come from this build.

## The map

[`Sources/VerificationIsIdentification`](Sources/VerificationIsIdentification) is the theory: 168 protocols, one per claim. The compiler is the proof checker. The theory prints its dependency map, [the atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/): one row per claim, the most depended-on first.

[`Sources/Organization`](Sources/Organization) is the showcase: 204 people, the access policy, and the whole site as types. Files named `Generated*` are build products. Read the policy, not the generated people. [`Sources/DocumentKit`](Sources/DocumentKit) is the engine: pages, tables, SVG, and text metrics, written in the notation it renders.

The 26 papers derive the theory step by step. They live in [`Papers`](Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers) and render into [the documentation site](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification). The [Curve](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/curve) page holds the measurement: build time against company size, to 12,800 employees.

## The gates

The repository checks itself. Each command is a gate. Green means passed:

- `swift build` type-checks the whole system. The LawCheck plugin lints the engine and the company as it builds. A violation refuses the build by name.
- `swift run Tools grammar` re-states every source file in a typed vocabulary for the compiler to judge. A style violation is a compile error that names its rule.
- `swift run Tools readme` re-counts every number this page states, from the artifact that owns it. The gate refuses a drifted claim by name.
- `swift run Tools census` counts declarations per target: zero structs, zero classes, zero runtime functions across the theory, engine, and company rows.
- `swift run Tools judge diff 200` sets a second, independent checker beside the compiler. Four lies are planted in the generated company. Both checkers must refuse each one and name the same facts.
- `swift package --allow-writing-to-package-directory tree-sort check` holds the docs' topic tree, and the atlas, equal to the type structure.
- `swift package --allow-writing-to-package-directory generate` regenerates the employees, the walks, the logins, and the card art: in Swift, in-repo.

## Documentation

The whole site is generated from this package. The 26 papers build the theory step by step. The last two say where it ends: a system that only checks will eventually hold every answer and stop computing, and the distance between two such systems is measurable.

- **[VerificationIsIdentification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** holds the framework: the protocols, the papers, [the atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/).
- **[Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples)** applies it: the physics demos and a working solver.
- **[Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization)** scales it: a whole company as types, its site proved by the build.
- **[DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit)** carries the rendering engine and the guided walks, written in the notation they render.
- **[GrammarLexicon](https://danielswift1992.github.io/verification-is-identification/documentation/grammarlexicon)** is the style linter's vocabulary: the words, scopes, and grants sources are judged in.
- **[Alphabet](https://danielswift1992.github.io/verification-is-identification/documentation/alphabet)** holds one atom per character, shared by the renderer and the linter.

## License

MIT
