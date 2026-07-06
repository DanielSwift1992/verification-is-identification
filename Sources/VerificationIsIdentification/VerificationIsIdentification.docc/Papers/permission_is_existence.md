# Permission Is Existence (Grammar)

A law can be written two ways: as a list of prohibitions patrolled by a judge, or as a finite vocabulary in which the illegal cannot be said. This paper pins the second way, on a running exhibit: the framework's own linter. A linter is a program that checks source code against a house style; the usual one is a bundle of pattern-matchers, each patrolling for a shape someone remembered to forbid. The claim here, pinned and claiming nothing broader: when the checked artifact is transliterated into a finite typed vocabulary, **permission becomes existence** — an act is legal exactly when the declaration granting it exists, illegality is the absence of a name, and the whole check is one compilation. "System" means a finite V=I system under I1–I3; the linter is an instance, and every claim below is exhibited by its build.

This site's own source is the miniature. Every Swift file in the repository is re-spelled as objects in a small vocabulary — a semicolon becomes `SemicolonAtom.self`, the word `func` becomes `FuncWord.self` — and the spelling is handed to the compiler. A semicolon outside a builder body fails with "SemicolonAtom does not conform to PlainToken": the grant it would need does not exist. A character nobody declared fails with "cannot find type": it has no name at all. The law never says *no*; it runs out of *yes*.

## §0. Derivation

No new postulate. The pieces are proved elsewhere and assembled: the loop and its verdicts (V=I §1), finiteness of the space (Existence Is Finite), the record (I3), and the reading of a terminal state (Halt Is Ignition). The contribution is a classification of how law can be carried by a lattice, and the observation that the carrier is already total.

## §1. A Check Is a Spelling

**PE1 (Verification of a foreign artifact is compilation of its transliteration).** Let the artifact be a finite string. A total, decision-free map carries it into vocabulary references: each character is looked up in a finite registry; a registered character contributes its atom's name, an unregistered one contributes a name derived from its code point — a name the vocabulary demonstrably never declared. The image is a program whose only content is the spelling. Then the artifact passes the law iff the image compiles. The map adds nothing (it is a lookup), the judge is total (the compiler halts on finite input), so the check is decidable — and it is exactly the V=I loop: the transliteration is the agent's encoding, the vocabulary is the test, a compiler error is REJECT(where, why) with the atom and the rule both named, and the build fact is PASS. **[solid — exhibited: 110 files, one build]**

## §2. Permission Is Existence

**PE2 (The law contains no prohibitions).** Every rule in the vocabulary is a declaration: an atom exists; a grant (a conformance) exists; a builder whose constraint names the grant exists. Legality of atom A in place P = existence of A's grant for P. There is no rule anywhere whose content is "forbidden" — prohibition is arithmetic, not text: the space of declarations is finite (Existence Is Finite), whatever lies outside it has no name, and the unnamed cannot compile. A forbidden act is not an act the judge catches; it is a sentence the language cannot say. *Corollary: a pattern-matcher can only catch shapes someone thought to write a pattern for; a finite vocabulary refuses everything it was never taught, by default, with no author having considered the case.* **[solid — exhibited: `Char167Atom` fails as "cannot find type" though no rule about `§` was ever written]**

**PE3 (A recorded fact becomes a name, and the law reads names only).** Position, context, scope — facts the stream records without interpreting — are spelled into the reference itself: a `where` that does not head its line is carried as `Midline<WhereWord>`, a block's directory picks which builder judges it. The law then needs no eyes: `Midline` holds no grant, so the fact refuses itself. One mechanism — name resolution — carries every axis. **[solid — exhibited across three axes]**

## §3. The Verdict Is the Floor

**PE4 (Checked means nothing left to distinguish).** Each statement of the spelling, once judged, folds to the same value: `Never` — the lattice's floor, where `Left == Right` and no distinction remains (V=I §0, step 11's shape). A whole codebase folds to it. This is not economy of implementation but the content of the verdict: verification that succeeds IS identification, and what has been identified holds no further question — the theorem "this artifact = a legal artifact" is Null at that level. Holding the verdict object is holding \|S\| = 1. **[solid]**

**PE5 (Self-application without paradox).** The vocabulary is built on the lattice; the lattice's own seed rides into the mirror as source and is spelled by the vocabulary it grounds. No fixed-point trouble follows, because the system never pronounces on itself: judgment is delegated to an external total judge, and the system's only claim is an exhibit — *this compilation exists*. The verifier is verified the way everything else is: by being spelled and built. **[solid — exhibited: the linter's own three files pass their own mirror]**

## §4. An Exception Is a Citizen

**PE6 (The law is closed under its own reading).** A comment cannot carry an exemption: the stream folds a comment into one opaque atom, so there is no channel for a directive to hide in. The only door out of a rule is a declaration — a conformance naming a reason as a type — which compiles in the real build like any other code. So exceptions are counted by the same census that counts everything else, and an audit of the law's holes is a read, not an investigation. **[solid — exhibited: `GrammarExempt` with `Because: ExemptionReason`]**

## §5. Position

Against V=I: the linter is a small system, and the mapping is exact — finite space (the registry), decidable test (the schema's constraints), append-only record (the emitted mirror), agent/system split (stream proposes, compiler certifies). Against the series: PE2 stands on Existence Is Finite (finiteness is what makes absence enforceable); PE4 reads the terminal state the way Halt Is Ignition reads a halt — by what it opens, which here is nothing, and that nothing is the verdict. The general lesson, stated once: **to govern a domain, do not police it — give it a vocabulary in which only the lawful can be said, and let existence do the judging.**
