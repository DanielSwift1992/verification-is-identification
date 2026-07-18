# Dynamics Is Substitution (Presentation)

A written system is a text: named slots, one term per slot. Change is one move: find a stated pattern in one slot, put a stated template in its place. From that single move the author derives the dynamics of written systems: determinism, judged trajectories, races, undo, input, and the exact boundary where the move ends. The claim, pinned: in a written world, change is substitution, and a run is a chain of judgements. What an interface calls a button is this rule under a picture, and nothing below needs the picture. The author pinned the load-bearing claims in the lattice first (`Dynamics.swift`, the presented half) and wrote this paper against that encoding.

In Law Is Target the author reached the transition law from observed examples: the identified half, the search paid by a solver. Here the author writes the law whole and a judge checks the written claims: the presented half. Presentation is identification with the search already spent.

## §0. Derivation

No new postulate. A press is V=I's Theorem 2 applied to one slot: the pattern identifies its term, or nothing fires. A file is a finite structure (Existence Is Finite), so every question about a state is a question about a finite tree. Everything below is bookkeeping over that cut.

## §1. The objects

**DiS1 (A system is a file).** A file F = (K, σ) is a constant form K with named slots, and an assignment σ of one term per slot. A rule is a triple r = (Slot, From, Into): the one slot it may touch, the pattern it must find there, the template it writes. From is linear: each variable occurs once. A press applies one rule: if σ(Slot) matches From under a binding θ, the slot's term becomes Into[θ], and otherwise the press is a no-op and the file is unchanged. A system is a form, a finite dictionary of rules, and a start state. The dictionary is the whole of the law: no second text is its implementation. **[solid: the axis is ``PresentedLaw``]**

## §2. A press identifies

**DiS2 (|S| ≤ 1 per press).** A linear pattern matches a closed term in at most one way: induction on the pattern, and by linearity there are no binding conflicts. The candidate set of a press has at most one member, so matching is a comparison, never a search. A chord (several rules on one slot with pairwise distinct patterns) keeps the bound: at most one pattern matches any given term, and a chord whose patterns overlap is refused when it is written, never when it fires. **[solid: ``PressIsIdentification``]**

## §3. One word, one file

**DiS3 (Determinism).** The rule fired is named by the press, the binding is unique (DiS2), and the template is a function of the binding. So the file after any word of presses is unique. A trajectory is replayable from its word alone, and a log of presses is a complete history.

## §4. The form never moves

**DiS4 (Form invariance).** A press rewrites one slot's term and nothing else. The form (the slots and the rules) is identical in every reachable state, and the difference between neighbouring states is inside one term. The set of available moves never changes along a trajectory. **[solid: ``FormIsInvariant``, the form is itself a structure]**

## §5. The judgement is on the edges

**DiS5 (Edges, not states).** A rule with a variable is a universally quantified claim: one check covers every binding at once. A judged start state and judged rules give judged reachable states, by induction on the press word. Finitely many checks cover infinitely many trajectories. Per-state checking cannot reach this bound, because the reachable states may be infinite while the rules are finite. **[solid: ``EdgesCarryTheJudgement``]**

## §6. Races and reversal

**DiS6 (Races are no-ops).** Rules over distinct slots commute: each reads and writes only its own slot. Two systems over disjoint slots therefore compose by concatenating their forms and their dictionaries, and every theorem above is true of the union. Two presses over one slot resolve as compare-and-swap: the later press finds a term its pattern no longer matches, and it lands as a no-op. A stale expectation is no loss, because nothing it expected exists.

**DiS7 (Undo is a rule).** A rule that erases no variable reverses by swapping From and Into. The reverse is again a rule, judged like any other. A history is one level-1 rule: cons the last term onto a list slot.

## §7. The class boundary

**DiS8 (The boundary is syntactic).** Rules without variables enumerate a finite automaton: the whole table is written down. Rules with variables reach counters, stacks, and histories: infinite state spaces crossed by edges of constant size. Outside the class is case analysis over an unbounded term: a board-wide shift, a sort, arithmetic on unbounded values. Such a transition is not a triple, and the refusal is decidable by reading the rule alone: a triple is three names, and anything more is visible in the rule's own text. What is outside is not lost. It belongs to an encoder outside the judge, and the encoder's product returns as a file, judged whole.

## §8. Input does not widen the world

**DiS9 (Two genres of input).** Typed input: a rule may leave a variable unbound in its pattern. The press supplies the atom, a stated finite alphabet bounds its kind, and the next state's own judgement vets the concrete member. No validator exists beside the judge the system already has. Prose: free text is whole in one slot as a single term, with three moves (append one character, remove the last, clear), and the judge vets the file's form, never the words. A text field is an interface reading of these two genres, never a primitive. Neither genre brings an unjudged value into the system.

## §9. Completeness is per act

**DiS10 (Per act, never per reach).** One step of any machine is a triple: the tape is a term, the head is a marker inside it. A counted chain of steps is a written object. The iteration is not: "repeat until done" names no structure, and a run with no stated end may have no final state at all (Existence Is Finite). The loop therefore belongs to the encoder, and the halting question is the encoder's too. It was never a question about a file before a judge.

## §10. The run is a chain of judgements

**DiS11 (Two schedules, one invariant).** The invariant of a judged world: no one is on an unjudged state. Two schedules satisfy it. Judged ahead: every reachable state is generated and judged before use, an act selects among judged states, and the schedule is exact when the state graph is small and closed. Judged per act: each press creates one state and that state is judged whole, the only schedule left when any text is a state and the graph cannot be built ahead. The two differ in when the judging is paid, and in nothing else. A judge fast enough to answer within the act leaves nothing to execute between acts: the run is the chain of judgements itself, and the judged-ahead world is the special case in which the whole chain ran before it was needed.

## §11. Statement

Dynamics is substitution. A written system moves by one act: find the pattern in one slot, put the template in its place. The act identifies (DiS2), the form is invariant under it (DiS4), the judgement is on the rules instead of the states (DiS5), and the run is a chain of judgements (DiS11). The boundary is named with the move: unbounded case analysis and unbounded iteration are outside, with the encoder, and their products return as files. One move, judged, is all the dynamics a written world has.

## §12. Dependency

| Source | Used |
|---|---|
| V=I | Theorem 2 (the cut), §5.22 (the candidate set shrinks): a match is the cut at one slot |
| Law Is Target | LT1–LT2 (the law is a finite structure with norm and distance), the identified half mirrored here |
| Existence Is Finite | the actual is finite, and an unbounded run has no final structure to ask about |
| Program Is Path | a press word is a path: finite, permanent, priced by its length |
| Distance Is Cost | the cost of dynamics is the written rules, never the size of the reached space |
| Play Is Proof | PP15 (the gate is given, not self-certified): the encoder's product is judged at the door |

In Law Is Target the author proved the law identifiable from examples, with the writing side left open. Here the author closes it: a law can be written whole and judged, and every consequence of identification is inherited, with the search already spent. The author pinned the claims in the lattice before stating them in prose, and this document exists so the presented half of the axis is one in prose and in types.

## Topics

### Theorems this paper proves

- ``PresentedLaw``
- ``PressIsIdentification``
- ``EdgesCarryTheJudgement``
- ``FormIsInvariant``
