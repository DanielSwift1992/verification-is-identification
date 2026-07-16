# Verification Is Identification

A Swift package where a system is written as pure types and `swift build` is the proof. The compiler enumerates every state the system can reach and proves each one, a renderer writes each one to disk as a page, and an action is a link. Nothing is left to run: **the build is the run**.

[![The playground: Swift types on the left, the judged and drawn page on the right.](https://raw.githubusercontent.com/DanielSwift1992/typed-playground/main/screenshot.png)](https://danielswift1992.github.io/typed-playground/)

**[Open the playground →](https://danielswift1992.github.io/typed-playground/)**. Swift types on the left, the page they draw on the right, and the judge names every broken claim as you type, on one static page. Every tab there is a real Swift file, and this repository re-checks the same files.

## Run the proof

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification && cd verification-is-identification && swift build
```

Green means every stated claim is proved: the theory, the access policy, the 204-person company, and every page of its site. A clean build takes 27 seconds on a laptop, and an incremental build takes seconds. Five things to try:

- Break a rule in [`Sources/Organization/System/Policy.swift`](Sources/Organization/System/Policy.swift), rebuild: the error names what you broke.
- `swift test` runs the worked demos: ice's residual entropy, hydrogen's spectrum, a scheduler. It prints "Executed 17 tests". The trailing "0 tests" line is expected: the newer Swift Testing harness finds no `@Test` functions there.
- `swift build -Xswiftc -DSHOW_UNSAT` rejects an impossible schedule by name, and `-DSHOW_FORBIDDEN` rejects a forbidden spectral line.
- `swift run Tools site` builds and serves the whole documentation site locally.
- The login keypad on any person's card works with no runtime: a key press follows a link, the URL fragment holds the state, and a wrong digit at any depth lands in one shared dead state, so 6561 possible sequences need five states. The last correct digit is a link to the unlocked page, and that page's type compiles only because the code matches: reaching it is the proof.

## One rule, three positions

The policy is one sentence: *only a manager may administer a department's documents.* In a dynamic language the rule is an `if` that runs in production, and a test finds the bug or nothing does. With static types the shapes are proved at build time, but the rule itself still waits for a guard to run. Here the rule moves to build time too. People and documents are types, the rule is a `where` clause, so an access request is a type as well: the compiler answers it by compiling it, or refuses it with the reason. This is the shipped policy from `Sources/Organization`, trimmed to the rule:

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

No test mentions Carol, and none is needed. The compiler checks every access the code states, on every build. A denied access fails to compile, and the error names the premise that failed. The playground's **Plant a lie** button does the same live, and its At scale tab judges a 12,800-person file on every keystroke.

| Concept | Dynamic | Statically typed | This notation |
| --- | --- | --- | --- |
| Data | a dict, shaped at runtime | a struct, shaped by the compiler | an empty `enum`: a pure type |
| A rule | an `if` | a guard over typed values | a `where` clause |
| A question | a call | a call | a type instantiation |
| A change of state | mutation | mutation, or a new value | a new type |
| A decision lands | at runtime | at runtime | at compile time |
| A green build means | it parsed | the types line up | every stated claim is proved |
| In production | everything runs | everything runs | nothing runs: the build already was the run |

## A company as types

The `Organization` target is the showcase. Every build re-proves and re-renders the 204 people, the access policy, and the company's whole site: dashboard, catalogs, reports, personal cards, keypad logins. Navigation is proved too: guided walks reach any page in four choices and any of the 204 people in eight.

[![The package, top down: the V=I type lattice, the DocumentKit engine that renders and walks it, the Organization written in both, and the two outputs of every build, the rendered site and the console audit.](Sources/Organization/Organization.docc/Resources/architecture.svg)](https://danielswift1992.github.io/verification-is-identification/documentation/organization)

The diagram is generated by the build it describes: the layout is computed from the same types the pages use, every label is fitted by its measured width, and the census on each box comes from this build.

## The map

[`Sources/VerificationIsIdentification`](Sources/VerificationIsIdentification) is the theory: 164 protocols, one per claim, and the compiler is the proof checker. The theory prints its own dependency map, [the atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/): one row per claim, heaviest first.

[`Sources/Organization`](Sources/Organization) is the showcase: 204 people, the access policy, and the whole site as types. Files named `Generated*` there are build products: read the policy, not the generated people. [`Sources/DocumentKit`](Sources/DocumentKit) is the engine: pages, tables, SVG, and text metrics, written in the notation it renders.

The 23 papers that derive the chain live in [`Papers`](Sources/VerificationIsIdentification/VerificationIsIdentification.docc/Papers) and render into [the documentation site](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification). The [Curve](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/curve) page holds the measurement: build time against company size, to 12,800 employees.

## The gates

The repository checks itself. Each command is a gate, and green means passed:

- `swift build` type-checks the whole system, and the LawCheck plugin lints the engine and the company as it builds: a violation refuses the build by name.
- `swift run Tools grammar` re-states every source file in a typed vocabulary for the compiler to judge: a style violation is a compile error naming its own rule.
- `swift run Tools census` counts declarations per target: zero structs, zero classes, zero runtime functions across the theory, engine, and company rows.
- `swift run Tools judge diff 200` sets a second, linear checker beside the compiler: four lies are planted in the generated company, and both checkers must refuse each one, naming the same facts.
- `swift package --allow-writing-to-package-directory tree-sort check` holds the docs' topic tree, and the atlas, equal to the type structure.
- `swift package --allow-writing-to-package-directory generate` regenerates the employees, the walks, the logins, and the card art: in Swift, in-repo.

## Where this came from

Generics already compute at build time: the source contains no `List<Int>`, the compiler creates it from the constraints. SwiftUI made that a paradigm: a result builder assembles the screen while the compiler compiles, and Apple changed the language for its sake. This package takes the same mechanism to its end: build-time functions generate the complete tree of the program, every state proved, and at run time the user only chooses the next link.

The state space does not explode, because state exists only as a written type. A 32-byte `var s: String` already ranges over 2²⁵⁶ values. A stated type ranges over exactly what you stated: small enough to enumerate, prove, and render. Only the exact, finite, determinate part of a system fits this notation, and whether you stated the right rule stays yours to judge. [Purpose](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/purpose) draws that boundary in full.

*Write a system as types. If it compiles, it cannot disagree with its own claims.*

## Documentation

The whole site is generated from this package. The chain is derived in 23 papers, two of them its furthest consequences: a system that only checks eventually holds every answer and stops computing, and the distance between two such systems is measurable.

- **[VerificationIsIdentification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification)** holds the framework: the protocols, the papers, [the atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/).
- **[Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples)** applies it: the physics demos and a working solver.
- **[Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization)** scales it: a whole company as types, its site proved by the build.
- **[DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit)** carries the rendering engine and the guided walks, written in the notation they render.
- **[GrammarLexicon](https://danielswift1992.github.io/verification-is-identification/documentation/grammarlexicon)** is the style linter's vocabulary: the words, scopes, and grants sources are judged in.
- **[Alphabet](https://danielswift1992.github.io/verification-is-identification/documentation/alphabet)** holds one atom per character, shared by the renderer and the linter.

## License

MIT
