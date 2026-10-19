# Verification Is Identification

This repository studies what a given access to an unknown source determines, and what can be done with the result. The arguments are in 35 papers. The relations written as Swift types are checked by the compiler. A 204-person company written as types is the worked application.

The name states the criterion. To verify an answer to a question is to identify that answer. The whole source has to be identified only when the question asks for the whole source.

The research goal: preserve or transform the content a task concerns, make the actual result available to the next participant, and keep further work possible. Unknown content can take part in the work before it is identified.

Start with [Verification Is Identification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/verification_is_identification/): the criterion, the constructions, and their connection to the source being studied.

## The question determines what must be known

[`Light.swift`](Sources/Examples/Light.swift) and [`Verdict.swift`](Sources/Examples/Verdict.swift) declare three symbolic light sources: `RedBeam`, `RedBeamWithIR` and `RedBeamWithMoreIR`. Each has two visible coordinates and one hidden coordinate, the infrared. The three differ only in the infrared. All three have the same `EyeImage`. The eye image is given, and which of the three sources produced it is not.

![Three declared sources share the same visible record. That record determines their visible pair while leaving their hidden coordinate open.](Documentation/Figures/beam-questions.svg)

The eye image determines the visible pair. It does not determine the infrared, because the three sources differ there. The same record answers one question and does not answer the other. A check is therefore a check of an answer to a stated question.

A compatible case is a case the given grounds permit. An answer is determined when compatible cases exist and every one of them gives that answer. Identifying the whole source is the case where the question asks for the whole source.

<details>
<summary>The criterion: compatible cases and a determined answer</summary>

![The compatible cases can determine one answer, permit several answers, or be empty. A check that has not established which case holds is a separate state.](Documentation/Figures/answer-determination.svg)

</details>

[Verification Is Identification, U2c](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/verification_is_identification/) states this criterion. Its constructions include new relations derived among fields that are still unknown. Each construction states what it uses and what follows.

## A result must support the next action

An operation on the source needs its own grounds, separate from the answer.

The same three sources. `SwapVisible` exchanges the two visible coordinates and keeps the infrared. The eye image after the swap is the swap of the old eye image, so it is computed from the old record. `ExposeHidden` moves the infrared into a visible coordinate. After it the three sources give different eye images, and the old record does not determine the new one. The old record is still correct about the state it was taken from.

![The symbolic swap commutes with the visible reading. Exposing the hidden coordinate instead gives different future answers from the same old record. Neither picture supplies a physical execution.](Documentation/Figures/beam-continuation.svg)

The construction is `ThreeBeamVerdict` with `SwapVisible`, `SwapFactors` and `ExposeHidden`. The [source map](Documentation/Figures/beam-study-sources.md) lists, for each frame, the definitions, the general argument and the positive and negative checks. These operations are symbolic. Applying them to light requires a physical operation and a connection to the source.

The general condition. A supplied operation may act on unknown contents when its laws establish the required effect. Choosing it requires grounds that it works in every case compatible with the input used for the choice. Its actual output must preserve what the task requires and give the continuation the access it needs. A task that must finish also needs a completion argument.

<details>
<summary>The action criterion: one adequate continuation across compatible reached states</summary>

![An adequate continuation must work at every actual source–residue pair compatible with the complete input to its choice. Its operation, availability and realization must be supplied.](Documentation/Figures/adequate-continuation.svg)

</details>

The source can change after a check. Access can be withdrawn, and another participant can take over. Continued use then needs a justified connection between the original requirement, the retained answer and the state actually reached.

[Acquisition Keeps Its Question](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/acquisition_keeps_its_question/) states this condition, with examples, and attaches the original requirement to the continuation. It gives the condition for an adequate continuation. Supplying the action and carrying it out are separate steps.

The [result form](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/results/) records the question, source, premises, derivation, reach, actual result and next use. Proof status and execution status are separate fields. When a premise loses support, the uses that depend on it are reviewed. Other valid grounds may still support them.

In an agent workflow the case looks like this. An agent checked a document, and the document changed. Whether the old check still supports the next action needs grounds for the source relation and grounds for the execution.

## From a claim to a checked construction

A protocol states a relation. A proof is a construction that derives the conclusion from supplied premises. [Law.swift](Sources/VerificationIsIdentification/Law.swift) requires such a construction for the typed proofs. The compiler checks it against the encoded relations. A failed construction is a defect of that attempt. A claim without a construction has an open proof obligation.

The working cycle is:

```text
question and grounds → proposed construction → check
                                               → established consequence
                                               → addressed refusal
                                               → open proof obligation
```

The next step starts from the result and its grounds. A changed representation must connect the question back to the intended source. An action must produce the actual result the continuation requires. A successful type check establishes the encoded consequences under their premises. Applying them to an actual system also requires the source connection.

The theory is 199 protocols, one per claim. Worked constructions are in [`Sources/Examples`](Sources/Examples). Positive witnesses and expected refusals are in [`Checks`](Checks). The [atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/) maps the dependencies between claims.

To check a construction locally:

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification
cd verification-is-identification
swift build --target Examples
bash Checks/verdict.sh acquisition
bash Checks/verdict.sh knowledgeclosure
```

The acquisition checks run a family of generic consequences and nearby constructions that must fail. [When does a new question require a new observation?](https://danielswift1992.github.io/verification-is-identification/documentation/examples/knowledgeclosure/) is a worked chain: old memory answers one question, and the next question requires a new reading.

## A second reader checks a stated relation

[`Sources/Court`](Sources/Court) is a second reader, separate from the Swift compiler, for specified fragments of declarations. A verdict applies to the fragment the reader supports and to the obligations it examined. A form outside that fragment must receive a refusal that names it. The company `judge` check plants selected changes and compares the reader with the compiler, including the names in their refusals.

[gate](https://github.com/DanielSwift1992/gate) applies these checks to records in other repositories. Its judge is built from a pinned revision of this corpus. The contract of each check defines what its result means.

![Target package responsibilities: vi owns the research and where/count semantics, showcase owns its constructed world and policy, and gate supplies an implementation under a versioned contract. The package split is planned.](Documentation/Figures/framework-architecture.svg)

The package split in the diagram is planned. The showcase targets are still in this package, and gate pins an earlier judge. The current [package diagram](Sources/Organization/Organization.docc/Resources/architecture.svg) shows the worked application and its generated representations.

## A worked application

The package contains a 204-person company written as types, with an access policy and an intranet website. Declarations describe the 204 people, their documents and their access requests. A policy rule is a conditional conformance, and the compiler checks the declared requests against it.

[Open the playground](https://danielswift1992.github.io/typed-playground/) to edit declarations and see the page they describe. **Plant a lie** changes a declaration for its checker to read. The At scale tab judges a 12,800-person file. [Its checks](https://github.com/DanielSwift1992/typed-playground#the-checks) document the supported subset of Swift.

The company is a declared world. The checked access assertions are about its declarations. A running organisation would need its own source relation and operations to enforce access.

<details>
<summary>The website, navigation and local commands</summary>

The [company site](https://danielswift1992.github.io/verification-is-identification/documentation/organization/) presents dashboards, reports and personal cards. Within their declared directories, the guided walks reach any page in four choices and any of the people in eight. The reader chooses each branch. [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit/) renders the pages and the SVG from types.

Four of the employee cards have a login keypad. A key is a link to a declared state. The 6561 possible input sequences share a small state graph, because every wrong digit leads to the same dead state. The compiler checks the supplied secret type against the page's declared secret. The page prints the password, and the unlocked address can be opened directly. This is a static navigation demonstration.

`swift build` checks the whole package. `swift test` runs the worked demos and prints "Executed 24 tests". `swift run Tools site` builds and serves the documentation locally. The [Curve](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/curve/) page reports measurements as the company grows to 12,800 employees.

A recorded local measurement on a 14-core Apple M4 Pro: a clean build in about eight minutes, a rebuild after a comment-only policy edit in about ten seconds. These numbers describe that setup.

</details>

## Read and work in the repository

| Part | Read | Work with the source |
| --- | --- | --- |
| Research and notation | [Framework and papers](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/), [dependency atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/) | [`VerificationIsIdentification`](Sources/VerificationIsIdentification), [`Examples`](Sources/Examples), [`Checks`](Checks) |
| Worked constructions | [Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples/) | [`Sources/Examples`](Sources/Examples) |
| Readers | Contracts stated by each reader | [`Sources/Court`](Sources/Court), [gate](https://github.com/DanielSwift1992/gate) |
| Company and rendering | [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization/), [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit/) | [`Sources/Organization`](Sources/Organization), [`Sources/DocumentKit`](Sources/DocumentKit) |

[`check.sh`](check.sh) lists the repository's checks. `./check.sh --only verdict` runs the registered proof and refusal fixtures. `./check.sh` runs the integration checks. `swift run Tools readme` compares the counts on this page with their source artifacts. Optional research experiments run separately with `./check.sh --research-only`. `swift package --allow-writing-to-package-directory generate` regenerates the checked-in roster, walk sources, font metrics and SVG artwork.

## License

MIT
