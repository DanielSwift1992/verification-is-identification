# Permission Is Existence (Grammar)

A law can be written two ways: as a list of prohibitions patrolled by a judge, or as a finite vocabulary in which the illegal cannot be said. Here the author pins the second way, on a running exhibit: the framework's own linter. A linter is a program that checks source code against a house style. The usual one is a bundle of pattern-matchers, each patrolling for a shape someone remembered to forbid. The claim here, pinned and claiming nothing broader: when the checked artifact is transliterated into a finite typed vocabulary, **permission is existence**: an act is legal exactly when the declaration granting it exists, illegality is the absence of a name, and the whole check is one compilation. "System" names a finite V=I system under I1–I3. The linter is an instance, and every claim below is exhibited by its build.

This site's own source is the miniature. The stream re-spells every Swift file in the repository as objects in a small vocabulary (a semicolon becomes `SemicolonAtom.self`, the word `func` becomes `FuncWord.self`) and hands the spelling to the compiler. A semicolon outside a builder body fails with "SemicolonAtom does not conform to PlainToken": the grant it would need does not exist. A character nobody declared fails with "cannot find type": it has no name at all. The law never says *no*: it runs out of *yes*.

## §0. Derivation

No new postulate. The author proves the pieces elsewhere and assembles them here: the loop and its verdicts (V=I §1), finiteness of the space (Existence Is Finite), the record (I3), and the reading of a terminal state (Halt Is Ignition). The contribution is a classification of how law can be carried by a lattice, and the observation that the carrier is already total.

## §1. A Check Is a Spelling

**PE1 (Verification of a foreign artifact is compilation of its transliteration).** Let the artifact be a finite string. A total, decision-free map carries it into vocabulary references: each character is looked up in a finite registry. A registered character maps to its atom's name, an unregistered one to a name derived from its code point: a name the vocabulary demonstrably never declared. The image is a program whose only content is the spelling. Then the artifact passes the law iff the image compiles. The map adds nothing (it is a lookup), the judge is total (the compiler halts on finite input), so the check is decidable. And it is exactly the V=I loop: the transliteration is the agent's encoding, the vocabulary is the test, a compiler error is REJECT(where, why) with the atom and the rule both named, and the build fact is PASS. **[solid: exhibited by 110 files, one build]**

## §2. Permission Is Existence

**PE2 (Positive grants define admission in this vocabulary).** The vocabulary declares atoms, conformances and builders whose constraints require those conformances. An atom is admitted at a place when its declared relations satisfy that place's requirements. A missing grant or incompatible equality prevents the proposed construction. No separate blacklist entry for that failed construction is needed. A finite set of declarations can generate an unbounded family of type expressions, as Existence Is Finite distinguishes. The refusal comes from name resolution and conformance constraints, without a premise that every possible declaration has already been enumerated. **[solid: exhibited, undeclared `Char167Atom` fails as "cannot find type" though no author wrote a rule specifically forbidding `§`]**

**PE3 (A recorded fact becomes a name, and the law reads names only).** Position, context, scope (facts the stream records without interpreting) are spelled into the reference itself: a `where` that does not head its line is carried as `Midline<WhereWord>`, and a block's directory names which builder judges it. `Midline` has no grant, so the compiler rejects a construction that requires one. `PERejectedMidline` in `Checks/Admission.swift` is the negative control for `Midline<WhereWord>`. One mechanism (name resolution) carries every axis. **[solid: exhibited across three axes]**

## §3. The Verdict Is the Floor

**PE4 (Checked settles the encoded conformance).** The spelling's checked statements fold to the same verdict form, `Never`, whose sides agree. This identifies the answer to the declared conformance question. It does not identify all passing artifacts with each other or settle their other properties. Different artifacts can satisfy the same constraints, just as different candidates can share zero mismatch in Play PP13. A unique source or implementation requires the corresponding separation result. The verdict's common form cannot supply that result by discarding the distinctions among its sources. **[solid: the encoded conformance is checked]**

**PE5 (Self-application within the stated check).** The vocabulary is built on the lattice, and the lattice's own seed enters the mirror as source, spelled by that vocabulary. Its files can be checked against the same declared grammar. The compiler is another component inside the physical whole. This successful compilation exhibits the particular conformance, without certifying every aspect of the compiler or its machine. PP15 restricts representation of a transformed diagonal when its answer transformation has no fixed point. That stronger demand is absent from checking these files. PP21 states the premises for relative internal inspection. **[solid: exhibited, the linter's own three files pass their own mirror]**

## §4. An Exception Is a Citizen

**PE6 (The law is closed under its own reading).** A comment is no channel for an exemption: the stream folds a comment into one opaque atom, and no channel is left for a directive. The only door out of a rule is a declaration (a conformance naming a reason as a type), and it compiles in the real build like any other code. So exceptions are counted by the same census that counts everything else, and an audit of the law's holes is a read, never an investigation. **[solid: exhibited, `GrammarExempt` with `Because: ExemptionReason`]**

## §5. Position

Against V=I: the linter is a small system, and the mapping is exact: finite space (the registry), decidable test (the schema's constraints), append-only record (the emitted mirror), agent/system split (stream proposes, compiler certifies). Against the series: PE2 is grounded in Existence Is Finite (finiteness is what makes absence enforceable), and PE4 reads the terminal state the way Halt Is Ignition reads a halt: by what it opens, which here is nothing, and that nothing is the verdict. The general lesson, stated once: **to govern a domain, do not police it. Give it a vocabulary in which only the lawful can be said, and let existence do the judging.**

## Topics

### Related type declarations

- ``CheckedSpellingAdmission``
