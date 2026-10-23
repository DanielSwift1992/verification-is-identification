# Continuation with source equalities

This is the U5 question of VI §1c, in the existing ContinuationCourt. It does not advance §12. The legacy type-field question, archive format 1 and pre-loss retention mode keep their meanings. This question uses archive format 2 and does not extend U6–U10a.

The declared whole is (T, E): Source declares the finite product shape T, whose opaque sorts are the request's generic Structure parameters; Equalities declares E, with omission meaning the empty relation. Every leaf occurrence has its own Source path. Reusing a sort parameter does not equate independently filled occurrences. All fillings satisfying the declared E are considered under every interpretation of the sorts by nonempty sets. Declaring E describes that conditional domain; applying this result to an actual source still requires those source relations.

## The written relation

The existing StructuralSource reader reads Source, Observation, Question and the optional Equalities typealias. The existing DefinitionReduction expression grammar resolves parameters and aliases. No additional lexer, regular expression reader, value getter or parser of Swift is added. The old ReadProof leaf records a generic sort parameter; normalizing a view to that leaf loses its Source occurrence. RouteProof therefore adds a Source anchor while reusing Context, its checked constructor, DefinitionReduction expansion and the same argument-proof replay. Format 1 has residual witnesses rather than E-path or obstruction witnesses; format 2 represents this distinct question instead of reinterpreting an old archive. The shared reader's own admission remains an explicit dependency of T0084/T0083; the proofs here are conditional on that reading and on the checked fixed foundation signatures.

Observation and Question declare cuts of this whole: U3 operations using Source, its Left/Right projections, paired views, and supported structural aliases of such expressions. Their leaf maps go from visible addresses to Source addresses. Each visible leaf has exactly one origin by construction; two visible leaves can refer to the same origin. Pairing creates two visible branches and cannot merge two source occurrences into one visible leaf. Only a declared E-path licenses equality between distinct source occurrences. A bare sort parameter, a detached shape alias or another whole's field does not supply an origin in this Source and refuses at Request.Observation or Request.Question. The required Question is read before any candidate program is constructed.

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

The residue extension is optional for compatibility with the original format-2 obstruction judgment. A saved obstruction without it proves only that continuation fails, and makes no claim to name the full question residue. All current constructor obstructions include the checked extension. Omitting or changing a class or Question address inside a presented extension refuses. This step names required classes; it constructs no retained view M or decoder from an augmented observation and claims no U6 minimality.

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
```

Both commands print the canonical archive. Exit 0 means a constructed universal continuation; exit 1 means a verified obstruction, also with an archive; exit 2 means unresolved input, malformed proof or a resource boundary and is not an impossibility judgment. Construction and replay disclose their existing depth/node boundaries, a 100,000-step total E-path budget and an 8 MB archive boundary as unresolved rather than as obstruction. There is no related --retain mode. The old command without --relations remains the format-1 question.

## Named observations

contract.json pins cases.swift and names the expected outcomes. ContinuationRelationsTests uses the real Primitive.swift foundation, constructs and serializes certificates, and replays them. Cases include one edge, chained and reversed equality, independent joint outputs, alias views, a disconnected class, same sort at different places, equal displayed values, distinct sorts, crossed-sort E, mismatched endpoint trees and an unrooted sort.

The whole/cut cases add repeated observation of one origin, the whole as observation, three unrooted or foreign forms, multiple missing classes, an E-connected missing class, and a partially answered Question. Named hostile certificates change an E-path, its endpoint or edge, replace E by address identity or display coincidence, break an E-edge in a partition, fail to separate the missing leaf, omit source leaves, change sorts, retarget Question or E, omit the declared E, drop an output selection, or replace the assembled term. Further residue controls omit a needed class or Question occurrence, omit a forest connection, substitute its edge, reverse its origin, or merge independent places without an E-path. Each refusal has a certificate-field or request-field address. CRLF and a generic-parameter rename exercise the reading boundary. These observations qualify regressions only; they are not proof of the entire reader or a cross-platform port.
