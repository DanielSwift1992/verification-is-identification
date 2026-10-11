# When does a new question require a new observation?

This demonstration answers that question with one resident acquisition chain. Its mathematics is in type relations and the corpus claims VC80–VC81, M55–M56 and AI18. No runtime model computes the answers.

From the repository root:

```sh
bash Checks/verdict.sh knowledgeclosure
```

The command builds Examples, checks the positive constructions and rejects nine deliberately broken constructions. The shell invokes the compiler and checks diagnostics. It does not decide the mathematical cases.

## The question and the supplied world

The symbolic source has three coordinates `(a,b,h)`. The first-coordinate question reads `a`. Two allowed interactions exchange coordinates:

| Interaction | Result |
|---|---|
| S | `(b,a,h)` |
| G | `(a,h,b)` |
| G, then S | `(h,a,b)` |

These operations already exist in `Saturation.swift`. Their coordinate laws are premises supplied by those constructors. The source uses `BeamShape` as an existing three-coordinate grammar. This demonstration asserts no physical transformation of light.

Three prepared instruments are present in the initial represented whole. Two acquire `a` and `b` while the third remains quiet. The next step can acquire `h`. The source is retained unchanged during these declared readings. A fixed command tape is also resident before acquisition. Once all three instruments have recorded, its commands execute G and S on the source while the instrument bank remains in place. Consumed command heads move into the internal past.

The whole contains the source even while the learner's fact interface omits `h`. The omitted value is neither an external input nor a value created by the third reading. The channel law, its availability and its finite preparation are specified, not inferred from the learner's need.

## Three different uses of knowledge

| Question | Sufficient evidence | Construction |
|---|---|---|
| What is the first coordinate now? | First fact in the old memory | `KnowledgeCurrent` |
| What is the first coordinate after S? | Second fact in the same old memory | `KnowledgeSwapFromTwo` |
| What is the first coordinate after G then S? | The additional `h` fact | `KnowledgeMixedFromThree` |

The first two decoders use the same acquired fact pair. No third fact is appended to derive the S answer. The third question cannot be answered from that pair over the unrestricted binary family.

To verify necessity, compare sources `000` and `001`. Their complete old fact interfaces, quiet third instruments and command tapes coincide. The mixed question has answers `0` and `1`. One decoder on identical available evidence cannot recover both. `KnowledgeNeedThird` is the positive zero/successor separator, and `KnowledgeAllOldFactsCannotDistinguishThird` checks the common evidence.

The third instrument provides an actual declared way to acquire the missing distinction. `KnowledgeAcquisition` composes its preparation and reading at the exact resident addresses. `KnowledgeFromThree` derives full-coordinate recovery from those actual facts. `KnowledgeRetainsOld` recovers the old fact pair from the new memory, preserving earlier uses.

## What makes this a derivation?

The direct mixed question is fixed independently:

```swift
public typealias KnowledgeMixedQuestion<B: BeamShape> = SequentialReading<
    KnowledgeMixedPath<B>.SourceStep,
    SpectrumAlphaSource<SwapVisible<SwapBetaHidden<B>>>
>
```

The acquired path uses existing composition:

```swift
public typealias KnowledgeMixedFromThree<B: BeamShape & Structure> = FutureOnEvidence<
    KnowledgeMixedPath<B>,
    SpectrumAlphaFactors<SwapVisible<SwapBetaHidden<B>>>,
    KnowledgeFromThree<B>
>
```

`KnowledgeFromThree` derives its answer from the resident fact addresses. Its caller supplies no final answer equality. The check `KnowledgeIndependentMixedQuestion` identifies the direct path of the composed factor with the independently stated question. The memory decoder receives the fact representation, with no extra source argument. Equal-valued facts from a different source cannot replace the actual acquisition relation.

`KnowledgeResidentRun` additionally realizes the fixed word as a relation on the represented whole. Checks identify its actual endpoint with the source question's endpoint and its final fact view with the prediction decoder's input. The predicted answer and the actual final first-coordinate reading agree.

## Why this is a closed family of questions

On binary coordinate contents there are eight possible triples. The least number of distinguishable classes needed for every first-coordinate question is:

| Allowed continuations | Required coordinates | Classes |
|---|---|---:|
| No operation | `a` | 2 |
| G alone | `a` | 2 |
| S alone | `a,b` | 4 |
| Arbitrary finite words over S and G | `a,b,h` | 8 |

S alone only interchanges the first two coordinates. G alone leaves the first unchanged. Together their mixed word exposes the third. The zero-length word, S and G/S distinguish all three coordinates. Conversely the complete triple updates under each generator, so the existing commuting squares and their exact composition cover every finite word.

`KnowledgeAnyCertifiedContinuation` checks reuse of the same acquired memory through an arbitrary supplied compatible path and endpoint factor. The induction concerns the declared generator grammar. It does not assert that Swift discovers every possible path or proves arbitrary physical interactions admissible.

The concrete resident run contains two command slots and executes G/S. The all-word proof describes the family of supplied finite paths. It does not grant that two-slot tape an unlimited execution budget.

## Change one relation

Allow G in addition to S. The old a/b representation becomes insufficient, and the positive pair `000`/`001` shows why. Acquire h through the declared instrument, and the complete representation restores sufficiency for the enlarged family.

Alternatively reverse the particular word to S/G. Its first-coordinate answer is b, already in old memory. `KnowledgeWordOrderMatters` gives both answers for `001`. `KCLOSURE_REVERSED_WORD` checks the rejected attempt to identify them. The operation is part of the question type.

Other negative controls target a wrong tape head, a skipped resident readdressing, a fabricated third fact, a foreign acquisition and omission of the operation from the question. A rejection checks its named broken construction. The positive separators carry the stronger insufficiency argument.

## What this establishes for the theory

The demonstration separates changing the question from acquiring new source information. It also separates information retained in the whole from information available through a chosen interface. M56 gives the corresponding finite entropy accounting: the old fact pair leaves one bit of conditional uncertainty about h, while the third fact resolves it. The eight source alternatives remain distinguished in the complete represented run.

The time question has a separate boundary. `StationaryRetention` is an admitted recursive record with equal endpoints satisfying `Permanent`. Retention alone therefore supplies no strict temporal order. Proper extension in a well-founded finite record grammar does supply an internal strict order, as M55 states. Whether all actual events have the required representation remains a question about the world.

The result establishes answer derivation, evidence sufficiency, necessary additional acquisition and scope propagation in one declared model. Performance advantages, autonomous discovery of the channel laws and universal physical conservation need their own evidence.

## When the law is also observed

The next demonstration asks how much law evidence the supplied data requires. Run `bash Checks/verdict.sh scopedlaw`. The admitted law selects one of four input coordinates. For data `(a,a,b,b)`, a binary probe locating the row determines the answer while leaving the selecting column unknown. For constant data no law probe is needed. Unrestricted data can require both existing binary probes.

An actual replacement of route 00 by 01 also preserves the repeated-row answer through the old probe record. `ScopedLawResidentRun` acquires that record before the change and retains both it and the displaced law. Changing to route 10 can invalidate reuse. This demonstrates that known data can reduce required law knowledge, and that preservation of the requested consequence can be weaker than preservation of the whole law. See VC82–VC83 and AI19.

## Source map

- [KnowledgeClosure.swift](../KnowledgeClosure.swift): resident acquisition, memory factors and the complete fixed run.
- [KnowledgeClosure checks](../../../Checks/KnowledgeClosure.swift): generic equalities, positive separators and nine negative controls.
- [QuestionScopedLaw.swift](../QuestionScopedLaw.swift): sufficient law evidence and its resident acquisition before a law change.
- [QuestionScopedLaw checks](../../../Checks/QuestionScopedLaw.swift): shared decoders, necessary law distinctions and seven negative controls.
- [Verdict VC80–VC83](../../VerificationIsIdentification/VerificationIsIdentification.docc/Papers/verdict_is_invariant.md): sufficiency, closure and the required law evidence.
- [Matter M55–M57](../../VerificationIsIdentification/VerificationIsIdentification.docc/Papers/permanence_is_resistance.md): order and information accounting.
