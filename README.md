# Verification Is Identification

Work starts with something you do not fully know. You have some access to it and a task to carry out. What can you conclude from that access? What can you change? What must the result leave for someone else to continue?

Verification Is Identification studies these questions together. The research goal is to preserve or transform the content a task concerns, make the actual result accessible to the next participant and enable further work. Unknown content can participate in that work before it is fully identified.

The papers give the arguments and their premises. Swift types express relations and constructions that can be checked. The tools check specified parts of those records. A company and its website provide a worked application of the notation.

Start with [Verification Is Identification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/verification_is_identification/) for the criterion, constructions and connection to the source being studied.

## The question determines what must be known

The question is part of the claim being checked. The same grounds can determine an answer to one question while leaving another open.

The same distinction applies to verification. Compatible cases are the cases the given grounds permit. An answer is determined when compatible cases exist and every one gives that answer. Identifying the entire source is the special case where the question asks for the entire source. The criterion concerns the question actually asked.

The sequence below follows one construction already expressed and checked in the corpus. The family contains exactly three symbolic sources. The visible reading is supplied, and the actual source remains unspecified.

![Three declared sources share the same visible record. That record determines their visible pair while leaving their hidden coordinate open.](Documentation/Figures/beam-questions.svg)

<details>
<summary>The criterion: compatible cases and a determined answer</summary>

![The compatible cases can determine one answer, permit several answers, or be empty. A check that has not established which case holds is a separate state.](Documentation/Figures/answer-determination.svg)

</details>

[Verification Is Identification, U2c](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/verification_is_identification/) states this criterion. Its constructions include a forced task assignment, agreement on a visible reading while the sources differ, and new relations derived among still-unknown fields. Each construction states what it uses and what follows.

## A result must support the next action

An answer and an available action have different obligations. A supplied operation may act on unknown contents when its laws establish the required effect. Choosing it requires grounds that it works in every case compatible with the input used to make that choice. Its actual output must preserve what the task requires and provide the access needed for the continuation. A task that requires completion also needs a completion argument.

Continue with the same sources. A supplied symbolic swap preserves the hidden coordinate and lets the next visible answer be computed from the old record. A different operation exposes that coordinate and loses this particular ground for reuse. The old reading remains a fact about its original state.

![The symbolic swap commutes with the visible reading. Exposing the hidden coordinate instead gives different future answers from the same old record. Neither picture supplies a physical execution.](Documentation/Figures/beam-continuation.svg)

The construction is `ThreeBeamVerdict` with `SwapFactors` and `ExposeHidden`. The [source map](Documentation/Figures/beam-study-sources.md) identifies the definitions, general argument and positive and negative checks for each frame. These are checked symbolic relations. Applying them to a physical system requires the corresponding operation and source connection.

<details>
<summary>The action criterion: one adequate continuation across compatible reached states</summary>

![An adequate continuation must work at every actual source–residue pair compatible with the complete input to its choice. Its operation, availability and realization must be supplied.](Documentation/Figures/adequate-continuation.svg)

</details>

The source may change, an experiment may alter it, access may be withdrawn or another participant may take over. Continued use needs a justified connection between the original requirement, the retained answer and the state actually reached.

[Acquisition Keeps Its Question](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/acquisition_keeps_its_question/) develops this condition and its examples. It keeps the original requirement attached to the continuation. The law describes when a continuation is adequate. Completing the task also requires supplying and carrying out the action.

The [result form](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/results/) records what another reader needs: the question, source, premises, derivation, reach, actual result and next use. Proof status and execution status are recorded separately. If a premise loses support, dependent uses need review. Other valid grounds may still suffice.

For an agent workflow, these are concrete questions: which source was checked, what changed, which action remains available and what the next participant can actually use. The research treats the source relation and execution as obligations that need their own grounds.

## From a claim to a checked construction

A protocol states a relation. A proof needs a construction deriving the conclusion from supplied premises. [Law.swift](Sources/VerificationIsIdentification/Law.swift) states that requirement for the typed proofs. The compiler checks the construction against its encoded relations. A failed construction identifies a problem with that attempt, and an unestablished claim keeps its open proof obligation.

The working cycle is:

```text
question and grounds → proposed construction → check
                                               → established consequence
                                               → addressed refusal
                                               → open proof obligation
```

The next move uses that result with its grounds. A changed representation must carry the question back to the intended source. An action must supply the actual result required for the continuation. A successful type check establishes its encoded consequences under its premises. Applying those consequences to an actual system requires the source connection as well.

The 35 papers develop the arguments. The theory contains 199 protocols, one per claim, with worked constructions in [`Sources/Examples`](Sources/Examples) and positive witnesses and expected refusals in [`Checks`](Checks). The [atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/) maps dependencies between claims.

To check a construction locally:

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification
cd verification-is-identification
swift build --target Examples
bash Checks/verdict.sh acquisition
bash Checks/verdict.sh knowledgeclosure
```

The acquisition checks exercise a family of generic consequences and nearby incompatible constructions. [When does a new question require a new observation?](https://danielswift1992.github.io/verification-is-identification/documentation/examples/knowledgeclosure/) gives a worked acquisition chain, reuse of old memory and a case requiring a new reading.

## A second reader checks a stated relation

[`Sources/Court`](Sources/Court) contains readers for specified declaration fragments. They read supported relations separately from the Swift compiler. Check the supported fragment and the obligations actually examined before using a verdict. A form the reader cannot interpret needs an addressed refusal. The company `judge` check compares its reader with the compiler on selected planted changes and checks the names in their refusals.

[gate](https://github.com/DanielSwift1992/gate) applies checking tools to records in other repositories and builds its judge from a pinned revision of this corpus. The papers state arguments and premises, the readers check specified relations, and gate supplies an interface for using checks. Their contracts determine what a result means.

![Target package responsibilities: vi owns the research and where/count semantics, showcase owns its constructed world and policy, and gate supplies an implementation under a versioned contract. The package split is planned.](Documentation/Figures/framework-architecture.svg)

The diagram shows the intended division of responsibilities. The showcase targets remain in this package. Gate currently pins an earlier judge. The existing [package diagram](Sources/Organization/Organization.docc/Resources/architecture.svg) shows the worked application and its generated representations.

## A worked application

The package also contains a 204-person company, an access policy and an intranet website written as types. Its declarations describe the 204 people, their documents and access requests. A conditional conformance expresses a policy rule, and the compiler checks the declared requests against it.

[Open the playground](https://danielswift1992.github.io/typed-playground/) to edit declarations and see the page they describe. **Plant a lie** changes a declaration for its checker to read. The At scale tab judges a 12,800-person file. The playground documents its supported subset of Swift in [its checks](https://github.com/DanielSwift1992/typed-playground#the-checks).

The application demonstrates the notation on a declared world. Its checked access assertions concern those declarations. Connecting them to a running organisation and enforcing access would require the corresponding source relation and operations.

<details>
<summary>The website, navigation and local commands</summary>

The [company site](https://danielswift1992.github.io/verification-is-identification/documentation/organization/) presents dashboards, catalogs, reports and personal cards. Within their declared directories, the guided walks reach any page in four choices and any of the people in eight. The reader chooses each branch. [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit/) renders the pages, tables and SVG from types.

Four of the employee cards carry a login keypad. A key follows a link to a declared state. The 6561 possible input sequences share a small state graph because each wrong digit reaches the same dead state. The compiler checks the supplied secret type against the page's declared secret. The page prints the password, and the unlocked address can be opened directly. This is a static navigation demonstration.

`swift build` checks the whole package. `swift test` exercises the worked demos and prints "Executed 24 tests". `swift run Tools site` builds and serves the documentation locally. The [Curve](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/curve/) page reports measurements as the company grows to 12,800 employees.

In a recorded local measurement on a 14-core Apple M4 Pro, a clean build took about eight minutes. A rebuild after a comment-only policy edit took about ten seconds. These are measurements of that setup.

</details>

## Read and work in the repository

| Part | Read | Work with the source |
| --- | --- | --- |
| Research and notation | [Framework and papers](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/), [dependency atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/) | [`VerificationIsIdentification`](Sources/VerificationIsIdentification), [`Examples`](Sources/Examples), [`Checks`](Checks) |
| Worked constructions | [Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples/) | [`Sources/Examples`](Sources/Examples) |
| Readers | Contracts stated by each reader | [`Sources/Court`](Sources/Court), [gate](https://github.com/DanielSwift1992/gate) |
| Company and rendering | [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization/), [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit/) | [`Sources/Organization`](Sources/Organization), [`Sources/DocumentKit`](Sources/DocumentKit) |

[`check.sh`](check.sh) lists the repository's checks. `./check.sh --only verdict` runs the registered proof and refusal fixtures. `./check.sh` runs the integration checks. `swift run Tools readme` compares the registered counts on this page with their source artifacts. Optional research experiments run separately with `./check.sh --research-only`. The checked-in roster, walk sources, font metrics and SVG artwork are regenerated with `swift package --allow-writing-to-package-directory generate`.

## License

MIT
