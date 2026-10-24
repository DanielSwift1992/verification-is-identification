# Continuation with source equalities

In the U3 carrier with declared equalities this court judges the §12 question form: one continuation for every filling, or an obstruction certificate. The physical carrier of §12 (LG28d) is not advanced. This is U5 and structural U6 of VI §1c in the existing ContinuationCourt. The legacy type-field question, archive format 1 and its pre-loss retention mode keep their meanings. Formats 2 and 3 below do not implement U7–U10a.

The legacy command without --relations identifies occurrences by their opaque type field. On SameSortDifferentPlaces it constructs a result with no additional leaf, while format 2 certifies an obstruction for the same written request. The legacy verdict is a type-field judgment (the singleton-carrier interpretation of that comparison), not the universal U5 judgment over independently filled source occurrences.

The declared whole is (T, E): Source declares the finite product shape T, whose opaque sorts are the request's generic Structure parameters; Equalities declares E, with omission meaning the empty relation. Every leaf occurrence has its own Source path. Reusing a sort parameter does not equate independently filled occurrences. All fillings satisfying the declared E are considered under every interpretation of the sorts by nonempty sets. Declaring E describes that conditional domain; applying this result to an actual source still requires those source relations.

## The written relation

The existing StructuralSource reader reads Source, Observation, Question and the optional Equalities typealias. The existing DefinitionReduction expression grammar resolves parameters and aliases. No additional lexer, regular expression reader, value getter or parser of Swift is added. The old ReadProof leaf records a generic sort parameter; normalizing a view to that leaf loses its Source occurrence. RouteProof therefore adds a Source anchor while reusing Context, its checked constructor, DefinitionReduction expansion and the same argument-proof replay. Format 1 has residual witnesses rather than E-path or obstruction witnesses; format 2 represents this distinct question instead of reinterpreting an old archive. The shared reader's own admission remains an explicit dependency of T0084/T0083; the proofs here are conditional on that reading and on the checked fixed foundation signatures.

Every type axis of the request record must occur in a replayed source or cut derivation. An unread axis, including an unused misspelling Equality, refuses at Request.Axis instead of silently meaning empty E. Construction and replay both enforce this coverage on the live record. Source, Observation, Question and optional Equalities have the fixed roles above; additional structural helper aliases are allowed when their live definitions are actually read. Coverage is a projection of the validated read proofs, not a second parser or a search for how to use an unread field. Value implementations do not supply type axes or source equalities.

Observation and Question declare cuts of this whole: U3 operations using Source, its Left/Right projections, paired views, and supported structural aliases of such expressions. Their leaf maps go from visible addresses to Source addresses. Each visible leaf has exactly one origin by construction; two visible leaves can refer to the same origin. Pairing creates two visible branches and cannot merge two source occurrences into one visible leaf. Only a declared E-path licenses equality between distinct source occurrences. A bare sort parameter, a detached shape alias or another whole's field does not supply an origin in this Source and refuses at Request.Observation or Request.Question. The required Question is read before any candidate program is constructed.

The whole-origin admission requirement in T0088 item 6 is a task premise (the user's words on 23 October at 10:3x, “все начинается из его разреза”), not a consequence of U5. The desk summary Materials/T0089/result.md corrects the earlier derivation in claude.md: U3 itself can start from a declared form without a parent. This court admits cuts of the explicitly declared whole under that task premise; rejection of an unrooted form is not a U5 impossibility judgment.

Equalities is a pair of endpoint trees of the same product shape. Corresponding leaves form the edges of E; each endpoint must be a leaf of Source of the same sort as its partner. The path in the first endpoint tree is the stable address of that edge. An absent Equalities field means empty E; an existing field cannot be omitted from the certificate.

For example, this source relation allows either observed leaf to answer the other without identifying its contents:

```swift
enum SameSourceContents<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Equalities = Paired<Source.Left, Source.Right>
}
```

Multiple equalities use matching endpoint trees; the EqualityChain case declares Source.Left = Source.Right.Left and Source.Right.Left = Source.Right.Right. They are relations of source contents, not Swift same-type requirements between stored values.

## Construction and replay

Construction propagates paths through the undirected E graph from the observed source occurrences. If every required leaf is reached, it projects the selected observation occurrence and assembles the required product. It reads no contents and enumerates no candidate programs.

The finite certificate contains live-source read derivations, rooted view derivations, each required output path, its selected observation path, and its equality ground. The three grounds are structural alternatives: address identity; a nonempty path of addressed E-edges with orientation; observed value coincidence. The third is always rejected. Different addresses alone imply neither equal nor different contents.

Replay checks live-source endpoints, exact output coverage, every selected leaf's sort, equality path continuity and endpoint, and the assembled pick/pair term. It does not call derive, normalize, matching or equivalence closure. The source and route read proofs are replayed against the supplied current declarations. Hash equality is not used as a substitute for that semantic check.

If a required leaf is absent, construction returns an obstruction certificate: the missing Question path and a complete sort-respecting partition of Source leaves. Replay checks that each source leaf occurs exactly once, every E-edge stays inside a block, and the requested leaf's block contains no same-sort observation leaf. It need not find connected components or search for a decoder. Blocks may be coarser than E-components if these conditions hold.

Newly constructed obstructions additionally name the residue needed by this Question. The residue extension supplies an ordered E-forest inside every partition block and a list of the unobserved blocks addressed by Question, with all their Question leaf paths. Each forest edge must connect an already justified member to the next member at the declared E-address. Together with the closed partition this certifies the exact E-classes, without repeating graph search during replay. The needed list must cover exactly the Question addresses in classes absent from Observation; repeated appearances of one class share its entry. The block supplies the source addresses and opaque sort. A coarser counterexample partition alone never licenses identification of its distinct places as one E-class.

The needed list has canonical Question order: depth-first, left before right, with a class inserted at its first Question occurrence and its Question paths retained in encounter order. Replay intentionally rejects a permuted list even if it names the same classes and paths.

The residue extension is optional for compatibility with the original format-2 obstruction judgment. A saved obstruction without it proves only that continuation fails, and makes no claim to name the full question residue. All current constructor obstructions include the checked extension. Omitting or changing a class or Question address inside a presented extension refuses. Without --retain this remains the U5 question from Observation alone. Naming classes without a retained view and joint decoder is not a U6 plan.

## Same-source retention and U6

The --retain mode selects one Source leaf from each required E-class absent from Observation. The missing classes are those of the checked residue extension. Construction uses their Question order and chooses the first Source member of each class. Replay allows another member of the same class and a permutation of the M leaves when the view and decoder agree with that order. A balanced product of the presented leaves is the retained view M. Its view term selects the declared Source paths. The joint view is exactly Paired<Observation, M> of the same Source: Left addresses Observation and Right addresses M. No independently acquired value or second source is admitted.

Construction invokes the same U5 constructor on that joint view to obtain R. The certificate carries M's source addresses and assembled view term, the joint input selections with E-paths, and the assembled term of R. Replay first checks the original U5 obstruction, the exact class proof and all required Question occurrences; it then checks exactly one M leaf per missing class, the view term and the same U5 selection/program rules on the joint view. It performs no graph search, closure or decoder construction. An omitted class, a source path outside a leaf, a leaf of another class, an extra leaf, an invalid E-path or a changed view/decoder term refuses with its certificate address. Extra leaves are rejected because this mode claims a minimal plan, rather than merely an adequate plan.

For each missing class, U5 necessity applied to an arbitrary structural residual D requires some D leaf in that class: otherwise two fillings of a two-element interpretation agree on P and D but differ on Q. Exact classes are certified by the closed partition and its connecting forests. Hence the number of missing classes is a lower bound on added leaves, and this construction attains it. Every adequate structural D also supplies a same-class leaf for every M leaf. This is the structural minimum of U6, not a bound in bits or physical memory units.

The information claim is relative: M ≼_P D means M(x) = f(P(x), D(x)) on X_E. M factors through Q by selecting the corresponding Q occurrences up to E; composing with any adequate decoder Q = d∘⟨P,D⟩ gives this relative factorization. It does not assert an absolutely least standalone residual among arbitrary deterministic encodings; the XOR example of VI §1c forbids that assertion. The court constructs M and R in the declared U3 grammar, not a decoder for an unpresented arbitrary D.

M must still be available in that same x, or be retained as part of P's actual action. A plan does not recover an absent independent field from P alone and does not implement physical copying or acquisition. When no class is missing, M has no carrier: P alone is used, no paired empty object or opaque constant is introduced, and the original format-2 result remains byte-identical. Preservation under a family G and U7 are outside this step.

Nonempty retention plans use archive format 3. They preserve the original conclusion (an obstruction from P alone) and add retention with leaves, view, selections and program. A new number prevents an old format-2 reader from silently accepting a different claim about an augmented input. A format-3 archive must contain retention; a format-2 archive must not. Older format-2 archives, including obstructions without the residue extension, keep their original meaning. Replay never synthesizes a missing plan from an old obstruction. A zero-residual construction stays in format 2 with no new field, so its bytes remain unchanged.

## Conditional justification

The source-rooted route rules preserve occurrence addresses by induction: the source anchor supplies all occurrences, projection selects a child, pairing combines disjoint output branches, and definition replay substitutes the actual source body with its declared argument guards. Leaves retain their sorts.

For a constructed result, address identity gives reflexivity, each E-step uses exactly its declared source relation or its symmetry, and a path composes those equalities. Each selected input therefore equals its independently required output on every filling in X_E. Product assembly proves the full required equality. This is U5 sufficiency for the stated grammar; fixtures are observations of the implementation, not this argument.

For an obstruction, use a two-element interpretation of the missing sort. Two fillings constant on the partition blocks differ only on the separated block. They satisfy every E-edge and have identical Observation images but different Question images. Hence no function of that observation alone answers both; in particular there is no universal U3 continuation. All other sorts can be interpreted by nonempty singleton sets. This is a certified refusal of the universal U5 question, not a refusal for every narrower preparation or every singleton interpretation.

For the optional class names, induction along each supplied forest proves that every member of a block is E-related to its root. Closure of every declared E-edge in the partition proves the reverse inclusion: an E-path cannot leave its block. Thus these blocks are exactly the E-classes. Direct lookup through the certified maps of Observation and Question proves the stated list of missing classes and their Question addresses. This proof concerns a fixed declared Question, not preservation of every possible future question or a least residual carrier.

The correctness of these replay rules and of their implementation remains a named premise. These rules do not prove the physical establishment of E, execution of a returned program, arbitrary Swift semantics, or equivalence with a separate port.

## Command and outcomes

```sh
Tools judge continue --relations --certificate proof.json Request sources.swift ...
Tools judge replay-continuation --relations proof.json Request sources.swift ...
Tools judge continue --relations --retain --certificate plan.json Request sources.swift ...
Tools judge replay-continuation --relations --retain plan.json Request sources.swift ...
```

All commands print the canonical archive. Without --retain, exit 0 means a constructed universal continuation from P; exit 1 means a verified obstruction from P, also with an archive. With --retain, exit 0 means a verified minimal same-source retention plan, including the zero-residual case. Replay with --retain refuses an old obstruction which presents no plan. Replaying a valid format-3 plan without --retain checks its additional proof but still reports the P-only obstruction, exit 1. Exit 2 means unresolved input, malformed proof or a resource boundary and is not an impossibility judgment. Construction and replay disclose their existing depth/node boundaries, a 100,000-step total E-path budget per U5 construction/replay and an 8 MB archive boundary as unresolved rather than as obstruction. The old command without --relations remains the format-1 question.

Input-policy debt shared with T0083 finding 2: ContinuationCourt.runRelations (in ContinuationRelations.swift) and ContinuationCourt.run read source files through String(contentsOfFile:encoding:), which consumes a leading UTF-8 BOM. This differs from the byte-preserving WhereJudge.fileText input policy. Format 2 has no byte coordinates, but these entry points still need a common input-policy repair with T0083; this revision does not make that repair.

## Named observations

contract.json pins cases.swift and names the expected outcomes. ContinuationRelationsTests uses the real Primitive.swift foundation, constructs and serializes certificates, and replays them. Cases include one edge, chained and reversed equality, independent joint outputs, alias views, a disconnected class, same sort at different places, equal displayed values, distinct sorts, crossed-sort E, mismatched endpoint trees and an unrooted sort.

The whole/cut cases add repeated observation of one origin, the whole as observation, three unrooted or foreign forms, multiple missing classes, an E-connected missing class, and a partially answered Question. Named hostile certificates change an E-path, its endpoint or edge, replace E by address identity or display coincidence, break an E-edge in a partition, fail to separate the missing leaf, omit source leaves, change sorts, retarget Question or E, omit the declared E, drop an output selection, or replace the assembled term. Further residue controls omit a needed class or Question occurrence, omit a forest connection, substitute its edge, reverse its origin, or merge independent places without an E-path. Each refusal has a certificate-field or request-field address. CRLF and a generic-parameter rename exercise the reading boundary. These observations qualify regressions only; they are not proof of the entire reader or a cross-platform port.

The retention section of the same contract.json additionally pins retention-cases.swift: one missing class, two missing sorts, a repeated requested class using one M leaf, a representative outside both views connected by E, and no missing class. ContinuationRetentionTests exercises those plans, an alternative representative, omitted/extra/wrong/unavailable M leaves, an absent exact-class proof, a broken forest, altered E-path/view/decoder terms, live Source/E changes and archive-format substitution. These finite observations do not replace the conditional U5/U6 argument or the common-reader premise.
