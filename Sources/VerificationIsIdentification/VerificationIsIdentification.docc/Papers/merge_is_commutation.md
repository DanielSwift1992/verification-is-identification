# Merge Is Commutation (Record)

A record changes by edits, and Record Is System left the edits unpriced: the collapse is per position, and no verdict was promised across positions. Here the author prices the one case that pays for everything else. Two edits of one record are independent when no entry and no law is inside both reaches. The claim: independent edits commute, and the verdict of the merged position is the conjunction of the parts' verdicts, carried whole. So a record accepts any number of writers at once wherever their reaches are apart, and the judge of the merged position re-reads exactly the touched laws and nothing else. The claim is recorded beside the lattice's edge judgement (``EdgesCarryTheJudgement``), and the reason it is not pinned is stated in Scope.

In Dynamics Is Substitution the author priced one move on one slot. This paper lifts that price to whole edits of a record with many laws over it: the same commutation, one level up.

## §0. Derivation

No new postulate. From Record Is System: the record, its positions, and the collapse per position. From Dynamics Is Substitution: an edit is a finite chain of moves, one actor per move, judged, and rules over disjoint slots commute. From V=I §5.12: a conjunction is judged component-wise. From V=I §5.24: a reading reads exactly what its encoding carries, and nothing outside it. The definitions below are those four, assembled by the author.

## §1. Definitions

**Definition 1 (the support).** A law over a record reads a finite set of entries, and that set is written in the law itself: the names its premise binds. The support of a law is that set. A law with an unwritten support is not a law of the record, and the judge refuses it before any edit exists.

**Definition 2 (the reach).** An edit writes a finite set of entries and may add laws. The reach of an edit is the union of the entries it writes and the supports of the laws it adds.

**Definition 3 (independence).** Two edits of one position are independent when two intersections are empty at once: the written entries are disjoint, so the merged text exists, and the touched laws are disjoint, so no law reads both reaches. A law is touched by an edit when its support meets the edit's reach.

## §2. The locality lemma

**MiC1 (a verdict is a function of the support).** A law's verdict at a position is determined by the entries of its support and by nothing else. An edit whose reach misses the support moves no letter the law reads, so the verdict at the new position is the verdict at the old one.

*Proof.* The judge reads a law by binding its premise to the entries the premise names (Definition 1), and the reading reads exactly what the binding carries (V=I §5.24). Entries outside the support enter no binding, so two positions equal on the support are one position to the law. ∎

## §3. The commutation theorem

**MiC2 (independent edits commute).** Two independent edits applied in either order reach one merged position.

*Proof.* Each edit is a finite chain of moves on its own written entries (Dynamics Is Substitution), and the two entry sets are disjoint by Definition 3. Moves on disjoint slots commute, move by move, so the two chains interleave into one position whatever the order. The added laws land beside the entries and collide with nothing, because their supports are inside their own edit's reach. ∎

## §4. The transport theorem

**MiC3 (the merged verdict is the conjunction, carried).** Both edits are green on their own position exactly when the merged position is green. Every verdict of the merged position is a verdict one of the three parties already earned: the base for every untouched law, the first edit for the laws it touched, the second for its own.

*Proof.* The verdict of a position is the conjunction of its laws' verdicts, judged component-wise (V=I §5.12). Partition the merged position's laws into untouched, touched by the first edit alone, and touched by the second alone: Definition 3 leaves no fourth class. For each class, MiC1 carries the verdict from the position where that party earned it, because the other edit's reach misses the support. The conjunction of carried greens is green, and a carried refusal keeps its address. ∎

## §5. The incremental corollary

**MiC4 (the exact re-judgement).** After an edit, the judge re-reads exactly the touched laws. V=I §5.18 already bounds the re-judgement from above: cached comparisons are kept, so the work is at most the new work. MiC1 closes the bound from below: an untouched law's verdict is the cached verdict, so the exact price of an edit is the touched set, no more and no less. The cost of a change is a count over its reach, the same count Distance Is Cost reads as a metric.

## §6. Three ways, one base

A merge of two histories over one base is the instance every version record plays. Write the base position b and the two edited positions o and t. The two edits are the two symmetric differences of distinction sets, D(o) △ D(b) and D(t) △ D(b), and Difference Is Distance already prices each as a distance (DiC G2). Independence is read on those differences: the merged position exists and inherits both verdicts exactly when the two differences are disjoint on entries and touch disjoint laws (Definition 3). Where the differences overlap, the overlap is the conflict, and its members are the addresses the frontier names (DiC): the merge does not fail somewhere, it fails at a listed set of entries and laws. A safe textual merge is the empty overlap, stated, never guessed.

## §7. Statement

1. A law's verdict is a function of its written support: edits outside the support move nothing (MiC1).
2. Independent edits commute into one merged position, in any order (MiC2).
3. The merged position is green exactly when both parts are green, and every merged verdict is a carried verdict with its address intact (MiC3).
4. The judge of an edit re-reads exactly the touched laws: the cache bounds the work from above, locality closes it from below (MiC4).
5. A three-way merge is safe exactly when the two differences over the base are disjoint on entries and laws, and the conflict otherwise is a listed set of addresses (§6).

> **A record bears any number of hands at once where their reaches are apart. The order of independent edits is spelling, not content: one merged position, its verdicts carried from the positions that earned them, and the price of every change counted over its reach. What overlaps is not a failure but an address, and what a merge cannot decide was never the merge's question: it belongs to the laws the writers share.**

## Scope

Claimed: the three definitions, the locality lemma, the commutation and transport theorems, the exact re-judgement, and the three-way reading over a base. Not pinned: commutation is a statement about two trajectories of one record, and the lattice's law admits no trajectory as a value on an axis, so the claim is recorded beside ``EdgesCarryTheJudgement`` rather than pinned as a conformance. Not claimed: the enforcement of who may edit, which is the transport's affair outside the record, and the match of any law to its writer's intention, which V=I §6 leaves with the writer.

## §8. Dependency

| Source | Used |
|---|---|
| Record Is System | the record, the collapse per position, the four artifacts as readings |
| Dynamics Is Substitution | an edit as a chain of judged moves, commutation over disjoint slots |
| V=I | §5.12 (component-wise conjunction), §5.18 (the cache carries), §5.24 (a reading reads its encoding) |
| Difference Is Distance, Distance Is Cost | the edit as a symmetric difference, the overlap as addressed frontier, the price as a count |
| Permanence Is Resistance | I3: a carried verdict is not retracted by an edit that missed it |

In Record Is System the author collapsed four artifacts into one record and stopped at the edit: every position was its own proof, and nothing crossed. Here the author lets verdicts cross exactly where crossing is free, and the freedom is written, not assumed: disjoint reaches, disjoint supports, and the judge re-reading only what an edit touched. The projection of this theorem onto any versioned store is that projection's affair, and the theorem does not name one.
