# Verification Is Identification

You work with something you do not fully know. You see part of it, and you have a task. So two questions come first: what that part lets you conclude, and what you can do with it before you know the rest.

You do not need to know everything. An answer is determined when every case compatible with what you have gives that answer. Identifying the whole source is one question among others, the one that asks for the whole source. That is the name: to verify an answer is to identify it, and the question decides how much of the source this takes.

The research goal is wider than a verdict. The content a task concerns has to be preserved or transformed, the actual result has to reach the next participant, and further work has to remain possible. Unknown content can take part in that work before anyone identifies it.

The arguments are in 35 papers. The part that can be checked is written as Swift types: the compiler checks it, and separate readers check specified parts of it. A 204-person company written the same way shows the notation at work.

Start with [Verification Is Identification](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/verification_is_identification/): the criterion, the constructions, and how they connect to the source being studied.

## The question determines what must be known

One construction from the corpus. A family has exactly three symbolic sources. You are given their visible reading and never told which source produced it.

![Three declared sources share the same visible record. That record determines their visible pair while leaving their hidden coordinate open.](Documentation/Figures/beam-questions.svg)

That one record settles the visible pair. It leaves the hidden coordinate open. The grounds are the same, and one question is closed while the other is open. So the question is part of the claim: a check always checks an answer to some question.

Compatible cases are the cases your grounds permit. An answer is determined when compatible cases exist and all of them give it. Identifying the entire source is the special case where the question asks for the entire source.

<details>
<summary>The criterion: compatible cases and a determined answer</summary>

![The compatible cases can determine one answer, permit several answers, or be empty. A check that has not established which case holds is a separate state.](Documentation/Figures/answer-determination.svg)

</details>

[Verification Is Identification, U2c](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/verification_is_identification/) states this criterion. Its constructions go further, down to new relations derived among fields that are still unknown. Each construction states what it uses and what follows.

## A result must support the next action

Knowing an answer and being able to act on it are two different facts, with different obligations.

Take the same three sources. A supplied symbolic swap keeps the hidden coordinate where it was, so the next visible answer can be computed from the old record. An operation that exposes the coordinate breaks this. After it, the permitted sources give different visible answers. The old record is still true about the old state, and it is too little for the new answer.

![The symbolic swap commutes with the visible reading. Exposing the hidden coordinate instead gives different future answers from the same old record. Neither picture supplies a physical execution.](Documentation/Figures/beam-continuation.svg)

The construction is `ThreeBeamVerdict` with `SwapFactors` and `ExposeHidden`. The [source map](Documentation/Figures/beam-study-sources.md) gives, for each frame, the definitions, the general argument and the positive and negative checks. These relations are symbolic and checked. A physical system gets them only through the matching operation and a connection to the source.

What makes the swap usable is a rule, and the rule covers any operation. A supplied operation may act on unknown contents when its laws establish the required effect. To choose it you need grounds that it works in every case compatible with the input you chose it on. Its actual output has to preserve what the task requires and give the continuation the access it needs. If the task has to finish, you also need an argument that it finishes.

<details>
<summary>The action criterion: one adequate continuation across compatible reached states</summary>

![An adequate continuation must work at every actual source–residue pair compatible with the complete input to its choice. Its operation, availability and realization must be supplied.](Documentation/Figures/adequate-continuation.svg)

</details>

Then things move. The source changes. Access is withdrawn, or another participant takes over. To go on, you need a justified link from the original requirement, through the answer you kept, to the state actually reached.

[Acquisition Keeps Its Question](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/acquisition_keeps_its_question/) works this condition out with examples and keeps the original requirement attached to the continuation. It tells you when a continuation is adequate. Supplying the action and carrying it out is separate work, and completing the task needs both.

Whoever continues reads a [result form](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/results/): question, source, premises, derivation, reach, actual result, next use. Whether a claim is proved and whether an action was carried out are separate entries. When a premise loses support, the uses that depended on it go back for review. Other valid grounds may still carry them.

In an agent workflow this comes up at every handoff. An agent checked a document, and then the document changed. Does the old check still give grounds for the next action? To answer it, the research asks for grounds twice: once for the source relation, once for the execution.

## From a claim to a checked construction

A protocol states a relation, and that proves nothing yet. A proof is a construction that derives the conclusion from supplied premises. [Law.swift](Sources/VerificationIsIdentification/Law.swift) demands one for the typed proofs, and the compiler checks it against the relations it encodes. A failed construction is a problem with that attempt. A claim without a construction keeps its open proof obligation.

The working cycle is:

```text
question and grounds → proposed construction → check
                                               → established consequence
                                               → addressed refusal
                                               → open proof obligation
```

The next move starts from that result and its grounds. If you change the representation, the question has to travel back to the source you meant. If you act, the action has to deliver the actual result the continuation needs. A green type check establishes what it encodes, under its premises. To apply that to a real system you also need the connection to the source.

The theory itself is 199 protocols, one per claim. Worked constructions are in [`Sources/Examples`](Sources/Examples), positive witnesses and expected refusals in [`Checks`](Checks), and the [atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/) maps which claim depends on which.

To check a construction locally:

```sh
git clone https://github.com/DanielSwift1992/verification-is-identification
cd verification-is-identification
swift build --target Examples
bash Checks/verdict.sh acquisition
bash Checks/verdict.sh knowledgeclosure
```

The acquisition checks run a family of generic consequences against nearby constructions that must fail. For a worked chain, read [When does a new question require a new observation?](https://danielswift1992.github.io/verification-is-identification/documentation/examples/knowledgeclosure/): old memory answers one question, and the next question needs a new reading.

## A second reader checks a stated relation

The compiler is one reader. [`Sources/Court`](Sources/Court) is another, written separately, for specified fragments of declarations. Before you use its verdict, look at which fragment it supports and which obligations it actually examined. A form it cannot read must get a refusal that names it. The company `judge` check plants selected changes and compares this reader with the compiler, down to the names in their refusals.

[gate](https://github.com/DanielSwift1992/gate) takes these checks to records in other repositories. It builds its judge from a pinned revision of this corpus. What a gate result means is fixed by the contract of the check behind it.

![Target package responsibilities: vi owns the research and where/count semantics, showcase owns its constructed world and policy, and gate supplies an implementation under a versioned contract. The package split is planned.](Documentation/Figures/framework-architecture.svg)

The split is a plan. Today the showcase targets are still in this package, and gate pins an earlier judge. The [package diagram](Sources/Organization/Organization.docc/Resources/architecture.svg) shows what exists now: the worked application and the representations generated from it.

## A worked application

The package also has a 204-person company written as types, with an access policy and an intranet website. Each of the 204 people is a declaration, and so is every document and access request. A policy rule is a conditional conformance, and the compiler checks the declared requests against it.

[Open the playground](https://danielswift1992.github.io/typed-playground/), edit a declaration and see the page it describes. **Plant a lie** changes a declaration for its checker to read. The At scale tab judges a 12,800-person file. The playground reads a subset of Swift, documented in [its checks](https://github.com/DanielSwift1992/typed-playground#the-checks).

All of this is a declared world. The access assertions are checked about those declarations. A running organisation would need its own source relation and its own operations before anything is enforced.

<details>
<summary>The website, navigation and local commands</summary>

The [company site](https://danielswift1992.github.io/verification-is-identification/documentation/organization/) has dashboards and reports, and a card for each person. Within their declared directories, the guided walks reach any page in four choices and any of the people in eight. The reader chooses each branch. [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit/) renders the pages and the SVG from types.

Four of the employee cards carry a login keypad. Each key is a link to a declared state. All 6561 possible input sequences fit in a small state graph, because every wrong digit leads to the same dead state. The compiler checks the supplied secret type against the page's declared secret. The page prints the password, and the unlocked address opens directly. This is a static navigation demo.

`swift build` checks the whole package. `swift test` runs the worked demos and prints "Executed 24 tests". `swift run Tools site` builds the documentation and serves it locally. The [Curve](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/curve/) page reports measurements as the company grows to 12,800 employees.

In one recorded local measurement on a 14-core Apple M4 Pro, a clean build took about eight minutes, and a rebuild after a comment-only policy edit about ten seconds. Those numbers belong to that setup.

</details>

## Read and work in the repository

| Part | Read | Work with the source |
| --- | --- | --- |
| Research and notation | [Framework and papers](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/), [dependency atlas](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification/atlas/) | [`VerificationIsIdentification`](Sources/VerificationIsIdentification), [`Examples`](Sources/Examples), [`Checks`](Checks) |
| Worked constructions | [Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples/) | [`Sources/Examples`](Sources/Examples) |
| Readers | Contracts stated by each reader | [`Sources/Court`](Sources/Court), [gate](https://github.com/DanielSwift1992/gate) |
| Company and rendering | [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization/), [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit/) | [`Sources/Organization`](Sources/Organization), [`Sources/DocumentKit`](Sources/DocumentKit) |

[`check.sh`](check.sh) lists the repository's checks. `./check.sh --only verdict` runs the registered proof and refusal fixtures, and `./check.sh` runs the integration checks. `swift run Tools readme` compares the counts on this page with the artifacts they come from. Optional research experiments run separately with `./check.sh --research-only`. To regenerate the checked-in roster, walk sources, font metrics and SVG artwork, run `swift package --allow-writing-to-package-directory generate`.

## License

MIT
