# Program Is Path (Path)

A string, a numeral, a PIN code, a program: each is a finite chain of tokens, laid down one at a time. Here the author names that chain the **path** (the order in which a structure is emitted, itself a structure in Σ) and derives what a construction is from it. The claim, pinned: a *program* is a finite, gated, autoregressive path over a hollow space, and the differences between a proof-carrying construction and a language model's emission are two coordinates on the same path: whether each step is cut to one survivor, and nothing else. The author pinned every statement below in the lattice (`Path.swift`) and wrote this paper against that encoding.

Basis Is Residue named the HORN (finite basis, infinite reach, "one atom, every numeral") and left its reach as prose: an unbounded space no finite axis expresses (B8b). The path expresses it. Every element of the reach is finite (a path has a length) while the closure is open (the alphabet is a hollow space). One mechanism carries strings, numbers, keypads, and programs.

## §0. Derivation

No new postulate. The path is the write-order made an object (the same move Order Is Object performs on the read-order), and the document is a capstone over four prior results: the horn (B B8b), the two organs (GD), the reading (Reading Is Order), and the step-count metric (DiC). Emission is reading run forward, and the gate is V=I's, unchanged.

## §1. The Reach Is a Path — the Horn, Expressed

**PiP1 (Hollow space).** A horn's closure is infinite, yet every member is finite: a counted chain over a finite basis (`Path: IntegerValued`, `Basis: IntegerValued`). The closure is never there whole: what exists at any moment is the set of paths actually walked, and the realized cost is the length walked, linear in use, never the cardinality of the space. The space is large in potential and cheap in fact: its members enter by declaration, never by enumeration. This settles B8b's open point: the reach the basis could not pin as an axis is the path itself. **[solid: pinned in the lattice, and the compiled witness is a type-level string space that does not explode the compiler]**

## §2. Emission Accumulates, and Cost Is Length

**PiP2 (The path only grows).** To emit a token is to extend the path, never to revise it: the prefix already written is kept (`Path: Permanent`, after ⊇ before). The path is its own history: with the last token dropped, the prior state is exactly there. The write-order is monotone, the mirror of the discriminator's shrinking candidate set (V=I §5.22). **[solid]**

**PiP3 (One distinction per token).** Distance Is Cost names distance an integer count of steps. On a path the steps are the tokens, so the cost of a construction *is* its length: the two axes close onto one (`Distance == Path`). A short path is a cheap object, a long one dear, and nothing else enters the price. **[solid: DiC G2c, pinned]**

## §3. Autoregression Is Forced, Not Conventional

**PiP4 (The next token's space is the prefix's scope).** The space of step n+1 is bounded by the encoding (ScopeBoundedByEncoding), and the encoding *is* the prefix already emitted, growing with each token (`Encoding: Permanent`). So the space of the next step is not there until the current step is in the encoding: emission is sequential by construction. The generator's Y-axis (which candidate next, GD1) is here fed its own output. Autoregression, the shape of every language model, is not a modeling choice: it is what emission over a hollow space *is*. **[solid for the forcing, and naming the industry shape is the projection]**

## §4. Construction Is Reading Run Forward

**PiP5 (One navigation, two directions).** Reading Is Order reads a standing structure: the order is the agent, the zipper's walk. Emission writes one: the order is the generator, the same walk the other way. Fold and unfold are dual (Reading R2), and the path is what both move along, so to write a program and to read it back are not two acts. The trace the construction leaves IS the object read. **[solid: the duality is R2, and the path is the shared carrier, pinned]**

## §5. An Invalid Step Folds Onto the Path

**PiP6 (Totality without bloat).** A continuation either forms (the cons type-checks) or it has no inhabitant to branch into. The total option for the failed step is to fold onto the path already there (`Path == Left`, a ``Null`` on the path), sharing one length node instead of opening a subtree. Invalid paths self-reference, and they do not multiply. The keypad is the compiled witness: every wrong combination folds onto one length line rather than a 9⁴ tree. **[solid: pinned, NiG N6's addressed hole, carried to emission]**

## §6. The Gate Decides Soundness

**PiP7 (Gated construction against free generation).** Two ways to walk the same path:

| | each step | the emitted path | the instance |
|---|---|---|---|
| **gated construction** | a crystallizing cut: the candidate set narrows to one (SystemCrystallizes) | valid by construction: an invalid step never passed | a compiler-checked program, this repository's every page |
| **free generation** | a proposal, accumulated uncut: SolutionSet is wide throughout | total, never sound: the path commits to candidates it never cut | a language model's emission |

Hallucination is generation with the discriminator removed: the organ that carries every identification bit (GD1) is the absent one, so what is left is order with no information to make it true. The missing coordinate is named, never hidden: a free generation cannot conform to the gated protocol without proving the uniqueness it does not have, and the compiler says so by name. **[solid: both protocols pinned, and the refusal is a compile error read directly]** The repository exhibits the contrast at scale: its grammar (Permission Is Existence) walks every source file as a gated path (each token a cut against a finite vocabulary), so the two rows above are separated on a hundred files at every build, not on one keypad.

## §7. Program Is Path

**PiP8 (The capstone).** A program is a finite, gated, autoregressive path over a hollow space: the reach is a path (PiP1), the emission is sequential (PiP4), and each step is cut to one survivor (PiP7). A program is then nothing but the path its construction walked, read back: act ≡ write ≡ prove, at the level of the token. Without the gate the same object is a free generation, and without the finiteness the reach is the open horn. This is where the three close at once. **[solid: the capstone protocol intersects exactly these three, pinned]**

## §8. Completion Is the Solution Set

**PiP9 (The editor's list is the proof state).** Typing a token is a COMPARE (a cut), so the candidate set only shrinks (`SolutionSet: Monotone`), and the list an editor shows at the cursor IS that set at the current prefix. Authoring is verifying: the suggestion list is the proof state, never a second index built beside it. When the set reaches one, the segment crystallizes and the next node opens its own set, conditioned on the prefix. A model shows the same list ungated, and a gated editor shows it cut to the survivors, so a suggested path is always valid. **[solid for the identity, and the editor reading is the projection]**

## §9. Erasure Is Head Recession

**PiP10 (Undo is free, and garbage is unreachable, never removed).** The record is append-only (NoInverse): an edit cannot delete at the system level. "Erasing" is a recession of the head: with the focus dropped, the prior state is exactly there, kept by the monotone history (PiP2). The object is then unreachable from the head, never gone, and so undo costs nothing. Garbage is what no path reaches from the head, so collecting it is a reachability sweep that trades kept history for space, deliberate, never the default. **[solid: pinned, IiI §2's permanence, read on the editing loop]**

## §10. Recorded, Not Pinned

Three corollaries the type system cannot pin as an axis, kept as prose the way B8b and GD7 are:

- **Two integers.** Every path has a LENGTH: the token count, read off any path. A path has a VALUE (the place-value fold) only when its tokens are themselves numerals. Length is universal. Value is gated on the alphabet, and that gate is the user-visible fact that a letter-path has no integer reading while a digit-path does. Swift cannot quantify "every token is a numeral" over an open Path, so the author keeps the Value fold as prose.
- **Number and word.** The numeral `1` and the word `o·n·e` are two paths over two alphabets, joined by a determined coercion each way, never an identity: the numeral has the Value fold, the word does not, and identifying them would erase the gate.
- **The small prover.** Walking the trie of realized paths (insert at a boundary, recede on erasure, offer children as completions) is a persistent-trie operation: constant, pure, no compiler needed. The GATE is not droppable the same way: a lookup says "this path exists," never "this step is authorized." Without the prover, a gated editor decays into the ungated walk that is a language model (PiP7). But the proof is small (the handful of markers, each a simple relation on ``Pair``), so the engineering optimum is exact: own the navigation, keep a tiny prover, never a full compiler and never none.

## §11. Statement

1. The horn's reach is a path: closure open, every member finite, cost linear in the length walked (PiP1).
2. Emission accumulates, and the cost of a construction is its length: one distinction per token (PiP2–PiP3).
3. Autoregression is forced: the next token's space is the prefix's scope, so emission is sequential by construction (PiP4).
4. Construction is reading run forward: one navigation, two directions, one carrier (PiP5).
5. An invalid step folds onto the path, and invalid continuations share a length node instead of multiplying (PiP6).
6. The gate decides soundness: with each step cut to one survivor the path is valid by construction, and with the set uncut the emission is total, never sound, the language model with its missing coordinate named (PiP7).
7. A program is a finite, gated, autoregressive path over a hollow space: act ≡ write ≡ prove at the token (PiP8).
8. Completion is the solution set at the prefix, and erasure is the head receding over a record that keeps everything (PiP9–PiP10).

> **A construction and its object are one chain read in two directions. Its space is hollow (vast in potential, priced by the step), and the only question that separates a proof from a guess is asked at every token: did this step cut the candidates to one, or did it only continue? Gate the step and the path cannot be wrong. Free the step and the path cannot be trusted. Everything else (strings, numerals, keypads, programs, the editor's suggestion list) is the same path, walked.**

## §12. Dependency

| Source | Used |
|---|---|
| B | B8b (the horn, the reach no finite axis expresses), B5 (atoms), B6–B7 (derive above the basis) |
| GD | GD1 (the two organs, the Y-axis), GD9 (on a horn the generator is the only mode) |
| Reading | R2 (fold/unfold duality), R3 (order adds no facts) |
| DiC | G2c (distance is cost, the step-count metric) |
| V=I | §5.22 (S monotone), Theorem 2 (the cut), §5.24 (scope bounded by the encoding) |
| IiI | §2 (permanence, erasure has no inverse), §5 (SystemCrystallizes idiom) |
| NiG | N6 (a failure carries an address, the folded invalid step) |
| OiO | the order-as-object move, applied to the write-order |

In Basis Is Residue the author proved the basis finite and left the reach as prose. In Proposal Is Order the author split the organs and left the emission abstract. Here the author gives both their carrier: the path, finite in every instance, open in closure, priced by the step, sound exactly where gated. The author pinned each claim in the lattice before stating it in prose, the compiled file is the older of the two documents, and this one exists so the record and its theory are one.

## Topics

### Theorems this paper proves

- ``CostIsPathLength``
- ``ReachIsPath``
- ``EmissionIsAutoregressive``
- ``ConstructionIsReading``
- ``GatedConstruction``
- ``FreeGeneration``
- ``ProgramIsPath``
- ``CompletionIsSolutionSet``
- ``ErasureIsRecession``
