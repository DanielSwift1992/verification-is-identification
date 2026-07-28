# Seam Is Game (Cross-Encoding Agreement)

V=I proves what it proves inside one encoding and says where that stops. Cross-encoding agreement needs a premise — that both encodings are semantics-preserving — and that premise is external to the formal system (V=I §5.4). Every integration between two parties lives exactly there: a contract and a client, a schema and a consumer, a sensor and whatever reads it, each side internally certified and saying nothing whatever about the other.

The boundary is drawn correctly and this document does not move it. It asks the narrower question the boundary leaves open: the premise is external, but is it *formless*?

It is not. A **seam** — a pair of declarations about one boundary, one from each side — makes the premise a V=I game one level up, licensed by V=I §5.13 and §5.15, inheriting I1–I3. The author postulates nothing new.

Three results follow that were design questions before they were corollaries. The seam vocabulary is complete at three states, because {0, 1, >1} partitions ℕ (SG1). A pinned revision is a *precondition* for a seam having any state at all, not hygiene — from which dependency ranges create the resolution problem rather than encounter it (SG2). And a held seam certifies agreement between declarations only, never behaviour (SG3). A closing section reports V=I §5.26 run as a differential test on an implementation, where it failed twice before holding, both failures invisible to any single-agent check.

## §0. Derivation

No new postulate. The author reads everything below off the V=I invariants (I1–I3), the outcome classification (V=I §5), revelation-not-creation (V=I §5.20), and the two recursion licences (V=I §5.13, §5.15). The premise V=I §5.4 places outside the system is given a form. It is not given a proof it lacked.

## §1. The Premise Is a Game

Two statements draw the edge.

**V=I §5.4 (Encoding independence).** "Each encoding defines its own function space F and its own f*. … Cross-encoding agreement (that two encodings of the same task produce the same decoded test output) requires an additional premise: both encodings must be semantics-preserving (they represent the same target function on the same domain). This premise is external to the formal system."

**V=I §5.24 (Encoding-bounded scope).** "Two different encodings of the same task create two separate, non-communicating pipeline executions."

Two licences allow building on it.

**V=I §5.13 (Sub-game spawn).** "At any node in the pipeline, the agent can create a new V=I game to solve a sub-problem … The sub-game is a valid V=I instance."

**V=I §5.15 (Structural recurrence across levels).** "The system at level N and level N+1 share the same triple structure: (finite space, decidable check, unique solution). The spaces, checks, and solutions differ in content, and the structural pattern is identical."

So construct the game. Fix a boundary and the finite set of **addresses** the two sides may speak about. At an address, side A *states* a declaration and side B *claims* one; either may be silent.

- **Space.** F is the set of correspondences between A's declaration and B's at that address. Finite: both declarations are finite structures (I1), so the correspondences between them are finitely many.
- **Check.** Whether a correspondence is consistent with both declarations. Decidable: it reduces to structural comparison (V=I §2.2).
- **S.** The correspondences that pass.

I1–I3 hold by inheritance rather than by assumption. The declarations are finite (I1). The operations reduce to COMPARE and projection (I2). A comparison of two *fixed* declarations cannot be retracted (I3) — a proviso §3 shows to be the load-bearing one.

## §2. The Vocabulary Is Complete, and Not Chosen

**V=I §5, Corollary (Outcome classification).** "Every V=I game terminates in one of three states: |S| = 1 (identification, Theorem 2), |S| = 0 (no solution under this encoding), or |S| > 1 (encoding insufficient). *Proof.* |S| ∈ ℕ (§0 step 10). {0, 1, >1} partitions ℕ. QED"

Read at an address:

| \|S\| | the seam | what has happened |
| --- | --- | --- |
| 1 | **holds** | both spoke; exactly one correspondence passes — the agreement is *identified*, not assumed |
| 0 | **parted** | both spoke; nothing passes |
| >1 | **open** | one is silent, so every correspondence is still consistent |

**SG1 (Completeness of the seam vocabulary).** An address is in exactly one of three states, and there is no fourth.

*Proof.* The outcome classification, applied to the game of §1. QED

Three consequences, each a design question before it was a corollary.

**(a) Waiting is |S| > 1, not a fourth thing.** V=I reads |S| > 1 as "The distinction is insufficient, and the remedy is finer distinctions". At a seam the needed distinction has a name: the silent side's sentence. This matters because *waiting* reads like a process state and is not one. It is an information state, and the missing information is identified rather than merely absent.

**(b) The two ends are one state.** "A owes B a word" and "B owes A a word" are one |S| > 1 read from the two ends of an edge. Not an analogy: G is a set of comparison records over Σ × Σ (V=I §2.3) and structural equality is symmetric, so an edge is one fact with two readings. An accounting that gives the two ends separate machinery has duplicated one object.

**(c) A declared exception is not a state.** Two sides sometimes know they differ and mean to, and the temptation is a fourth state. It is not one. Declaring "we differ here on purpose" is precisely **supplying V=I §5.4's external premise by hand**, and whatever the declaration cites — a ticket, a milestone, a date — is its *term*. When the cited thing closes, the supplied premise is withdrawn and the address stands at whichever of the three states it was always in. The vocabulary stays at three. What varies is whether the premise was derived or supplied.

## §3. Pinning Is a Precondition

**SG2 (Pinning).** A seam's state is a function of the two revisions its sides were taken at. Where either side is named by a range or a moving reference, the seam has no determinate state.

*Proof.* V=I §5.20 (Revelation, not creation): "COMPARE(a, b) does not create a fact. The result (equal/not_equal) is structurally determined before the call: the trees are already equal or not. … The comparison result is a pre-existing structural fact made explicit." The game of §1 compares two declarations. A range or a moving reference does not denote a fixed declaration, so there is no pre-existing structure for the comparison to reveal, and the premise of V=I §5.20 fails. I3 fails with it: a result recorded today can be contradicted tomorrow with no retraction having occurred, because the compared object changed underneath. Retraction was impossible only because the compared structures were fixed (V=I I3); unfix them and the impossibility goes. QED

**Corollary (resolution is created, not encountered).** A dependency range does not make agreement *harder to compute*. It removes the condition under which the question has an answer, and the machinery that follows — solving, backtracking, lock files — is the cost of having removed it. The familiar difficulty is therefore not a hard problem in the space of dependency questions. It is an artefact of asking after the premise was broken. Pinning is not hygiene. It is what makes the question well-formed.

## §4. What a Seam Certifies

**SG3 (Scope).** A held seam certifies agreement between two *declarations*. It certifies nothing about either side's behaviour.

*Proof.* The game's atoms are declarations, and V=I §5.24 bars a pipeline from information not present in its input. QED

This is the honest half, and it bounds the result. A held seam says: what one side said and what the other said agree, at these two revisions. Whether either does what it said remains that side's own V=I game, in its own encoding, where V=I's theorems already apply. The level above was only ever needed for the agreement.

## §5. Order-Invariance as a Differential Test

V=I §5.25 — "Correctness is order-invariant, and efficiency is order-determined" — and V=I §5.26 — "Two agents processing the same domain under the same encoding produce libraries with identical entries, differing only in the order the agents added them. … The library's content is fixed by the domain, never by the agent" — make a prediction about any system built on this corpus, and the prediction is testable in one extra run.

It was run on an implementation of the seam machinery above: two agents, one domain, identical content, the constituent files declared in opposite orders, everything judged or emitted compared byte for byte. **The first run failed**, on two counts, and neither is visible to a single-agent check however careful.

1. Declarations belonging to one presented encoding were carried into *every* other — two encodings communicating, which V=I §5.24 forbids outright.
2. They were carried in declaration order, so two agents with identical content received different line numbers for the same refusal. Order had leaked into an *address*, and an address is part of what a refusal is.

Both fell to one correction: an encoding takes a foreign declaration only where its own declaration stood, and a name it never spoke is not an addition to it. The re-run is byte-identical across opposite orders while the overrides still take effect.

The methodological point outlives the defects. **A differential test is the only kind that can see order at all.** A single agent has one order and is order-blind by construction: every internal consistency check it can run, it passes. V=I §5.26 is therefore not only a statement about libraries. It is the one available instrument for a class of defect that is otherwise silent permanently, and it costs one additional run.

## §6. What Is Claimed

**Claimed.** The premise V=I §5.4 places outside the system has a form: a V=I game one level up, licensed by V=I §5.13 and §5.15 and inheriting I1–I3. Given that form, the three-state vocabulary is a corollary rather than a choice (SG1), pinning is a precondition rather than a convention (SG2), and a seam's certificate covers declarations only (SG3). V=I §5.26 is a differential test that finds order-leaks nothing else finds (§5).

**Not claimed.** That seams inherit Theorem 2. They do not, and V=I §5.4 says why; this document does not overturn it. What is offered is that the external premise can be *structured* as a game, and that structuring it is what would bring the theorems within reach — not that they already apply.

**Also not claimed.** Anything about behaviour. A seam gives V=I §5.4's premise a shape, a term and an address. It gives it no teeth against a side that lies about what it does, and no arrangement of declarations could.
