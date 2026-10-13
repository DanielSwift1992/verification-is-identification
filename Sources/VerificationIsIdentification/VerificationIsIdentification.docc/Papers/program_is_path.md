# Program Is Path (Path)

A string, a numeral, a PIN code and a program can each be represented by a finite chain of tokens. This paper calls their emission order a **path**, itself represented in Σ. It studies finite path construction over an open reach. A membership check certifies an admissible choice. Identification additionally establishes which sole candidate satisfies the question. These are different obligations, and neither the number of proposals nor an interface name decides whether a language model's answer is correct. Path.swift records the corresponding interfaces, whose mathematical interpretations need the constructions stated here and in V=I U1–U2b.

Basis Is Residue's horn uses a finite basis with an unbounded generated reach. A finite path representation names one member without enumerating that reach. This interpretation can represent strings, numbers, keypads and programs, with different admissibility conditions.

## §0. Derivation

The path represents an emission order as an object. The finite path grammar, retaining record constructor, permitted transitions and chosen cost model are explicit premises below. They connect the horn of Basis Is Residue, proposal and checking in GD, represented reading order, and the metric of Distance Is Cost. A static interface alone does not choose these process laws.

## §1. The Reach Is a Path — the Horn, Expressed

**PiP1 (Finite members of an open reach).** Choose a finite token basis and a grammar of finite lists ending at a declared terminal. Each list has a natural-number length by structural induction, while unbounded admitted lengths give an infinite reach when the basis is nonempty. This does not require enumerating the reach to name one list. IntegerValued alone supplies no terminal or finite-depth proof (EiF EF7, EF10). HollowReach supplies selected numeral coordinates, without establishing a path's token membership, an infinite physical capacity or a bound on compiler work. The finite-list interpretation is the premise connecting represented paths to B8b.

## §2. Emission Accumulates, and Cost Is Length

**PiP2 (Retaining emission).** Let an admitted emission construct h'=PAIR(h,e), as in RetainedWhole<h,e>. Its first projection recovers h. Iterating this construction a finite number of times retains each earlier record at its corresponding finite prefix address. This models retained emission. Arbitrary editing need not use this update, and Permanent alone also admits a self-related terminal (EiF EF9). Fresh occurrence and a decreasing traversal budget require the explicit constructor and finite grammar.

**PiP2a (Transport a question through retained history).** If p(h')=h and a reading q applies to h, define q'(h')=q(p(h')). Then q'(h')=q(h). For a finite sequence of retaining steps, compose their actual prefix projections in reverse order and then apply q. Induction proves preservation of the old answer at every such extension. No equality between h' and h, or between the new event and an old event, is needed.

The existing PrefixMemoryAnswer<R,M> now exposes Application as SequentialReading of the actual first projection of M followed by R. Its seam is M.Left=R.Left, and its answer follows from this composition. RetainTraceAnswer already supplies the corresponding factorization for source-bound observation traces. Repeated retention therefore uses the existing constructor rather than a new invariant marker. JoinedTransition and QuestionAlongTransition supply the separate composition law for questions transported through changing source and image states (Verdict VC51–VC52).

This preserves a question about the retained source. It does not freeze the current state or assert q(h')=q(h) for an unchanged current-state reading. All the sources and records belong to one represented whole. Accessibility of the old address and applicability of its decoder remain necessary for an actual participant to use the retained answer. Raw retention alone does not supply every local reader with that answer (V=I GC3).

**PiP3 (Length and cost need an identified unit).** A finite path of n emissions has length n. In a model charging one unit per emission its accumulated charge is n by addition. This is different from Distance Is Cost's W, whose unit is one valid tree-node edit. CostIsPathLength equates two associated coordinates but does not connect them to actual emitted tokens or charged edits.

For a concrete counterexample, let h=PAIR(NULL,PAIR(NULL,NULL)) and append a NULL event to obtain h'=PAIR(h,NULL). Then D(h)={ε,R}, D(h')={ε,L,LR}, so W(h,h')=3 although there was one retaining append. The old record is recoverable at L, while its addresses relative to the new root differ. AppendPartition in Checks/Distance.swift is built from the existing tree partition constructors and tied to the actual RetainedWhole transition. It locates the three changed addresses R, L and LR. Retention is compatible with such address changes.

There is nevertheless an exact preservation law. For finite s,t,e, G2a gives W(PAIR(s,e),PAIR(t,e))=W(s,t): the new roots agree, the common event contributes zero, and prefixing old difference addresses by L preserves their cardinality. More generally W(PAIR(s,e),PAIR(t,f))=W(s,t)+W(e,f). The existing TreePartition111 constructor realizes this decomposition. With a ZeroTreeDifference event partition, its two direct masks carry the original masks below L and empty event masks below R. The generic CommonAppendPreservesDirectMasks check verifies that transport on the actual types. Thus extension by a common context preserves pairwise structural distinctions, without fixing the distance between an old state and its own extension. PiP2a transports the old reader along the same prefix embedding.

More generally, for a finite sequence h₀,…,hₙ, its sum of edge distances is at least W(h₀,hₙ) by G2. Equality additionally requires the route to be shortest. G2d identifies the exact detour residual for two legs. Physical time, energy and storage costs require their own implementation model (G2c), rather than a renamed path coordinate.

## §3. Prefix-Conditioned Emission

**PiP4 (The next question can depend on the prefix).** An emission rule may take the current prefix as its input and define admissible next tokens from it. Such applications compose in prefix order when their actual inputs match preceding outputs. This is the chosen sequential representation. EmissionIsAutoregressive only requires a Permanent Encoding beside the inherited interfaces. It does not identify Encoding with Path, specify a next-token rule or prevent a whole path from being prepared by another construction. Prefix dependence does not alone prove an unavoidable physical execution order or prohibit parallel preparation. SequentialReading supplies the actual composition seam when the represented operations do form a chain.

## §4. Construction Is Reading Run Forward

**PiP5 (Read the represented construction).** A retained emission trace can be traversed to recover its previous records, as PiP2a establishes. Recovering that trace is a relation between a construction and a reader. It does not make every reading the inverse of emission: a reading may return only a coarse property. ConstructionIsReading joins interfaces without an inverse equation between a writer and reader. Particular inverse relations must use the actual source and output addresses, as in the existing recovery constructions of EiF EF9.

## §5. An Invalid Step Folds Onto the Path

**PiP6 (An explicit refusal policy).** A rejected construction supplies no instance of that attempted construction. The enclosing system's response is a separate choice: a system can preserve its previous path, append a failure record or expose another admitted outcome if its declared rules provide it. InvalidStepFolds requires Left=Right=Path, without an attempted transition, failure condition or execution rule. It names a stationary path coordinate. It does not prove that all refusals return to it or that this is the only total response. Matter M58 already distinguishes an explicit return relation from a return supposedly inferred from closure alone. A keypad's chosen failure representation needs its own construction to establish its sharing and size.

## §6. The Gate Decides Soundness

**PiP7 (Validity and identification are separate).** Fix a task's admissible domain S. A construction is valid for that task when its actual output belongs to S. If S has one member, this membership also identifies the output with that member (V=I Theorem 2). If S has several members, any of them can still be a correct output for the task of producing an admissible member.

| Evidence | Established conclusion |
|---|---|
| An actual membership witness for x in S | x is admissible for this task |
| Membership plus a supported singleton S | x equals the identified member |
| Several admissible members | The task permits a choice, without implying an erroneous choice |
| A proposal without a membership witness | This evidence does not yet establish admissibility or its failure |

*Counterexample to requiring uniqueness for correctness.* The unpinned four-cycle in Coloring has two two-machine assignments, (A,B,A,B) and (B,A,B,A). Both satisfy every edge. The existing Conflicts constructions and their closing checks certify both. Thus a correct schedule need not be the sole schedule. Adding a pin forces one assignment by PinnedScheduleIsForced (V=I U2b), which changes the question. The distinction between admissibility and uniqueness also appears in V=I §3.7 and Verdict's question-specific agreement results.

For a sequence of steps, admissibility at each step gives a path guarantee when the actual transition preserves the required invariant from an admitted initial state. Induction then establishes that invariant along the finite path. A syntactic token check alone need not establish a program's intended behavior. GatedConstruction currently joins named crystallization and retention interfaces. It does not encode this entire transition proof. FreeGeneration does not forbid a verifier. The HALLUCINATE fixture rejects the incompatible projections of TwoSurvivors under Unique. That diagnostic proves no behavioral claim about language models. The finite grammar checks establish their stated source grammar conditions.

## §7. Program Is Path

**PiP8 (The capstone interface).** ProgramIsPath joins ReachIsPath, EmissionIsAutoregressive and GatedConstruction. Under their intended finite path interpretation, a construction records a sequence that can be read back. Checking its construction establishes the properties expressed by the actual checks. It does not identify every token uniquely or equate writing arbitrary text with proving it. PiP7 states the additional invariant argument needed for path validity.

## §8. Completion Is the Solution Set

**PiP9 (Completion reads admissible continuations).** An editor can present the candidates its checks admit at the current prefix. Equating its displayed list with that domain requires both admissibility of listed entries and coverage of the declared domain. V=I U2a gives membership paths through a finite covered support. More than one admissible continuation can remain. Selection need not wait for uniqueness. After a step, the next token's candidates belong to a new prefix context, so their list is not automatically a subset of the previous token's list. Monotone elimination applies to a fixed candidate domain under added constraints (V=I §5.22). CompletionIsSolutionSet's associated types alone do not prove a displayed list complete or its continuations semantically valid.

## §9. Erasure Is Head Recession

**PiP10 (Undo through a retained predecessor).** For the record update of PiP2, a reader can move to the actual predecessor projection. PiP2a then transports questions about that predecessor through the newer record. A separately stored history can keep a discarded edit even when the editing head moves back. The head, retained history and reachable objects must be distinguished: what is unreachable from one head need not be unreachable from every root. This construction permits an undo representation without deleting the retained record. It does not establish zero traversal, allocation or physical cost. ErasureIsRecession names retention interfaces but does not itself specify the head or a reclamation policy. Closure of the whole alone supplies neither an unlimited archive nor every participant's recovery path.

## §10. Recorded, Not Pinned

Three interpretation and implementation questions remain separate from the path interfaces:

- **Length and decoded value.** A finite token list has a length in its chosen tokenization. A positional numeral decoder assigns a value to paths in its admitted digit grammar. A letter path is outside that particular grammar, but another declared reading can assign it a number. The open Path coordinate alone supplies neither token membership nor a value decoder. This construction is missing, and its impossibility as a type-level grammar is not established.
- **Number and word.** The paths `1` and `o·n·e` can denote the same number under specified readers while differing as token structures. A conversion between admitted representations needs its own domain and recovery laws. Agreement on the number question does not identify the paths or make every conversion invertible.
- **Navigation and checking.** A persistent trie can navigate recorded paths with work depending on path depth. A lookup establishes the recorded path's presence. Authorization additionally needs a checked relation to the current action and context. A small checker is a possible implementation, but the number of marker names does not bound the work of their constraint system. PiP7 separates the necessary evidence from the choice of generator or checking engine.

## §11. Statement

1. A finite-list grammar gives finite paths without enumerating their open reach (PiP1).
2. Retaining constructors preserve earlier answers through actual prefix projections. Token length and tree-edit distance have different units (PiP2–PiP3).
3. Prefix-conditioned applications compose at their actual intermediate source, without proving a unique physical execution order (PiP4).
4. Reading a retained construction recovers its addressed history, while coarse readings need not invert it (PiP5).
5. A refused construction does not specify its enclosing system's response (PiP6).
6. Membership establishes admissibility. A supported singleton additionally establishes identification. Preserved invariants give a finite path guarantee (PiP7).
7. ProgramIsPath joins the proposed construction interfaces. Writing and checking agree only on the properties those checks establish (PiP8).
8. Completion needs admissibility and coverage at the current prefix. Erasure is modeled separately by head recession over retained history (PiP9–PiP10).

> A recorded construction can be read as a path. Its proof concerns the relations checked along that path. The question at a step is what establishes that choice's admissibility in its actual context. Uniqueness is required when the task asks for identification of one candidate.

## §12. Dependency

| Source | Used |
|---|---|
| B | B8b (the horn, the reach no finite axis expresses), B5 (atoms), B6–B7 (derive above the basis) |
| GD | GD1 (proposal and checking), GD9 (infinite reach does not eliminate lookup or compilation) |
| Reading | R2 (unfold and fold require their respective structures), R3 (an order-invariant answer within a fixed reading contract) |
| DiC | G2 (the tree-edit metric W), G2a (its recursion), G2d (the triangle residual), G2c (physical cost needs an implementation model) |
| V=I | §5.22 (S monotone), Theorem 2 (the cut), §5.24 (scope bounded by the encoding) |
| IiI | §2 (permanence, erasure has no inverse), §5 (SystemCrystallizes idiom) |
| NiG | N6 (a failure carries an address, the folded invalid step) |
| OiO | the order-as-object move, applied to the write-order |

Basis Is Residue supplies the finite-basis interpretation, and Proposal Is Order separates proposal from checking. This paper connects them through represented paths. Interface conformance records constraints. The associated mathematical claims must follow from those constraints and their stated interpretation, as the correction in PiP7 illustrates.

## Topics

### Related type declarations

- ``CostIsPathLength``
- ``ReachIsPath``
- ``EmissionIsAutoregressive``
- ``ConstructionIsReading``
- ``GatedConstruction``
- ``FreeGeneration``
- ``ProgramIsPath``
- ``CompletionIsSolutionSet``
- ``ErasureIsRecession``
