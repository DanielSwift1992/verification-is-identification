# Verification Is Identification (System)

A finite structure exists. It is not nothing: there is a distinction. Equality on finite structures is decidable (finitely many components, finitely many comparisons). A decidable test halts, reads finite data, and is over a finite space. If exactly one candidate passes, verification is identification.

One postulate. One loop. 26 proven properties plus information-theoretic bounds. Five theorems (compilation, safety, identifiability, universality, completeness), and the author derives all five from the postulate. The inner pipeline is total on valid finite encodings, deterministic under fixed features and protocol, with an append-only comparison cache. The author formalizes the system over finite binary trees with decidable equality, and implements it twice: in Python (runtime solver, ARC-AGI tasks) and in Swift (compile-time proof: the type checker verifies encoded constraints).


## §0. Derivation

**Postulate.** A finite structure exists.

1. A finite structure exists. *[postulate]*
2. A finite structure is not nothing. *[from 1: if structure = nothing, "a finite structure exists" = "nothing exists" = no postulate. The reading is self-refuting.]*
3. Structure ≠ nothing → a distinction exists between them. *[from 2: "not" IS the distinction.]*
4. Structural equality on finite structures is decidable. *[from 1 + 3: distinction has two sides (step 3). The structure is finite (step 1) → binary distinctions recurse to finite depth → finitely many components. Comparing two finite structures = finitely many component comparisons → terminates → decidable.]* Decidability follows from the inductive structure of finite distinction itself: two sides (step 3) with finite termination (step 1) yield an inductive type, traversable by structural recursion. The author assumes no external representation: traversability is a consequence of the structure, and no premise.
5. The test halts. *[from 4: decidable ⊂ halting.]*
6. A halting test examines finite data. *[from 1 + 5: finite structure → finite data.]*
7. Finite data of bounded size is in a finite space F. *[from 1 + 6: the structure has finite size n over its finite set of distinct components. All structures over those components up to size n form a finite set by combinatorics.]*
8. S = {y ∈ F : COMPARE(y, target) = EQUAL} is computable. *[from 4 + 7: structural equality is decidable (step 4) + finite space (step 7) = enumerate F and check each.]*
9. The structure is representable in F. *[from 1 + 7: it is finite (step 1) and F contains all finite structures up to its size (step 7) → it is in F.]* Under an encoding whose test recognizes it, it passes and enters S.
10. |S| is computable. *[from 8: counting a computed finite set.]*
11. If |S| = 1: the representation that passes IS the structure. *[from 9 + 10: y\* ∈ S, |S| = 1, S = {y\*}. Any y passing = y\*.]*

**Step 11: if |S| = 1, verification is identification.**

**On |S| > 1.** Multiple representations pass. The distinction is insufficient, and the remedy is finer distinctions. |S| = 1 is checkable (step 10), and if the check fails, the system returns |S| > 1.

**On search.** The derivation has no word on how y is found. Whether you find a passing representation is the search's question. Whether a passing representation is y* is step 11's, and search is not among its premises.

**On encoding.** By step 9 the structure is representable in F (it is finite, and F contains all finite structures up to its size). Whether it enters S is the encoding's question: the agent must supply an encoding under which the target passes verification. The theorem is true for any encoding under which |S| = 1.

The verification question is whether a candidate passes. The identification question is which candidate it is. When exactly one candidate passes, passing IS identification: the two predicates are one. The collapse is computable by three means, each derived from the postulate: finite space, decidable test, append-only cache. Once the agent fixes the encoding, one freedom is left: the order in which the system checks the facts. Correctness is order-invariant, and only efficiency varies (§5.25). An additional degree of freedom is the loss of a step: with a mutable test step 4 fails, with a growing space step 7, with a retractable record step 8, and |S| is undetermined.


## §1. The Loop

The system operates as a cycle between two participants:

```
AGENT ──> ENCODING ──> VERIFY ──> PASS: solution identified (Theorem 2)
  ↑                        │
  └── REJECT(where, why) ──┘
```

The agent proposes, and the system certifies. The system's guarantees (Theorems 1–5, §5) are unconditional: if PASS, the output is correct, regardless of how the agent chose the encoding. The agent's responsibility is an encoding under which the task is representable and R4 (§3.5) is true. Every condition the system requires (finite space, decidable test, basis-selectability) is within the agent's reach for any finite deterministic task (Theorem 4, §5). The question is never whether the conditions can be met, but whether the agent meets them. Encoding is the agent's contribution, and correctness is the system's guarantee.

1. **AGENT** provides an encoding: how to represent the task as finite binary trees. Under the encoding the system's preconditions are true: finite F, decidable verification. The agent transforms the task into a form the system can certify.
2. **SYSTEM** runs the inner pipeline (§2–§4): encode → extract → compile → execute.
3. **SYSTEM** returns one of:
   - **PASS(f\*)**: solution identified. f' = f\* by Theorem 2 (§5).
   - **REJECT(basis, position P)**: value at P not in input basis. Agent: change encoding or extend basis.
   - **REJECT(compile, example k)**: rule fails on example k. Agent: add features or change representation.
   - **MISMATCH**: rule compiles but fails on test. Agent: add training examples or change features.
4. **AGENT** reads the diagnostic, modifies the encoding, and re-enters at step 1.

**Inner half** (steps 2–3): total. Always halts. Always returns a definite answer. If PASS: output = f*. If REJECT: no output. The proofs are in §5.

**Outer half** (steps 1, 4): the agent's domain. The loop halts when:
- PASS → agent accepts the certified solution. Done.
- Agent exhausts grammar → REJECT. No encoding in the grammar produces PASS.

**Totality.** The inner half is a total function on finite inputs: every path terminates at a definite state. The proof is in §5.

**Diagnostics.** Each REJECT names a structural address: not "failed" but "failed HERE, because THIS." The agent reads the address, finds where the system's information is insufficient, and modifies exactly that.

The rest of the paper is the inner half: the author defines the building blocks in §2 (what the agent provides), the workspace in §3 (what the system constructs), the pipeline in §4, and proves the guarantees in §5.


## §2. Representation

```
IN:   ∅
OUT:  Σ, COMPARE, Graph
      Invariants: I1 (finite), I2 (closed), I3 (permanent)
```

**2.1. Structures.** A finite structure has parts (distinctions) and ends (boundaries). Each distinction has two sides and a boundary: write it PAIR(A, B). The point where distinction self-terminates is NULL:

- If A, B ∈ Σ then PAIR(A, B) ∈ Σ.
- Finite distinction requires a base: without one, Σ is empty, against the postulate. NULL is this base: the point where structure ends.
- Nothing else ∈ Σ. (Finite distinction exhausts all possible finite structures.)

Every element of Σ is a finite binary tree. PAIR is distinction. NULL is its boundary. These are what structure is, never operations applied to it. Σ is the initial algebra of F(X) = 1 + X²: the inductive type of finite binary trees. Any finite structure has an encoding into it. Here the author posits nothing: Σ is what finite distinction produces (steps 1–3). The type is unbounded, and each element is finite. The sets a given encoding puts in play (atoms, F, S, G) are finite fragments of it (I1).

**2.2. Equality.** Two structures are either structurally identical or not. This is a fact about the structures, never an operation on them. Write the fact COMPARE : Σ × Σ → {equal, not_equal}:

```
COMPARE(NULL, NULL) = equal
COMPARE(PAIR(A₁,B₁), PAIR(A₂,B₂)) = equal  iff  COMPARE(A₁,A₂) = COMPARE(B₁,B₂) = equal
All other cases → not_equal
```

Structural identity is decidable on finite structures: finitely many components, finitely many comparisons. Projection (accessing parts of a pair) and recursion are traversal of existing structure. All derived operations (ordering, arithmetic, counting) are compositions of COMPARE and projection via Peano encoding.

**2.3. Graph.** A set G ⊆ Σ × Σ × {equal, not_equal} of recorded comparisons.

**2.4. System invariants.** Each invariant follows from the postulate and representation:

| ID | Invariant | Derivation |
|----|-----------|------------|
| I1 | Every structure, and every set in play (atoms, F, S, G), is finite | From the postulate: a finite structure has finitely many components, and a bounded encoding generates finitely many structures (§0 step 7). |
| I2 | All operations reduce to distinction, boundary, identity, access | Distinction (PAIR), boundary (NULL), identity (COMPARE), access (projection). These are structural aspects of finite distinction. No other structural aspect exists. |
| I3 | G is append-only: G' ⊇ G for all future states | From finiteness + I2 (COMPARE is a pure function of its inputs): finite structures are fixed, COMPARE is a pure function of fixed inputs, results cannot change. Retraction is not prohibited: it is impossible. |

The author derives I1–I3 from the postulate and the representation. Any finite structure is encodable as a finite binary tree, and any system that identifies finite structures satisfies I1–I3 under that encoding.

**2.5. Unity.** PAIR is the sole structural primitive: the act of distinction.

- **NULL** is its fixpoint: the pair where left(x) = right(x) = x. Boundary is where distinction self-terminates, never a separate symbol. Base case detection: left(x) = x (self-reference), not x = ⊥ (external symbol).
- **COMPARE** is structural recursion over pairs: two trees are identical iff their components are identical at every level, terminating at the fixpoint. Identity is what simultaneous traversal of two structures already is, never an external operation.
- **Projection** is destructuring: left(PAIR(A,B)) = A. A direct consequence of distinction having two sides.

One act: distinction. Three derived aspects: where it ends (boundary), whether two histories match (identity), which side you examine (access). The author keeps NULL and COMPARE as notation: they name structural properties of distinction, never independent entities.


## §3. Problem

```
IN:   Σ, COMPARE, Graph (from §2)
OUT:  Game, F, S, f*
      Encoding adequacy: R4
```

**3.1. Game.** A pair:

- Example pairs: {(I₁, O₁), ..., (Iₜ, Oₜ)} where each Iₖ, Oₖ ⊂ Σ, finite.
- Test input: I_test ⊂ Σ, finite.

**3.2. Encoding strategy (finite basis selection).** The system selects every output value from a finite basis present in the input. The system does not create new values: it identifies which basis elements belong in which output positions.

The agent makes any finite deterministic task basis-selectable by embedding the codomain into the input as a lookup basis. The selection logic is in the rule, expressed through features.

**3.3. Functions.** Let F = {f : f maps output positions to decoded output values for game G}. Two source-atom selections that produce identical decoded outputs on every input are the same element of F. F is finite (at most |V|^|O| elements, where V = distinct input values) and extensional by construction.

**3.4. Example consistency.** S = {f ∈ F : f(Iₖ) = Oₖ for all k}.

**3.5. Encoding adequacy (R4).** |S| = 1. A decidable property of the encoding: the system computes |S| and reports the result (§3.6). Denote the unique element f*.

|S| > 1: encoding insufficient, and the system returns this as a diagnostic (§1). Each additional example can only drop candidates from S, never add one. |S| = 1: the encoding resolves the task.

**3.6. R4 is decidable.** F is finite (3.3). S is computable by exhaustive check. |S| is therefore computable. (Cost: O(|F| · T · N²), exponential in |O| but finite.)

**3.7. Applicability.** Consider a task as a relation R(x, y): "y is a valid solution of x". The derivation (§0) is from one postulate: a finite structure exists. From this, decidable structural equality follows as a theorem (§0 step 4), and the author derives three conditions:

1. **Finite basis.** The solution y is an assembly of elements from a finite basis. *[from §0 steps 1, 6: finite structure → finite data → finite representation]*
2. **Computable verifier.** R(x, y) is decidable: given x and candidate y, verification terminates with PASS/REJECT. *[from §0 step 4: decidable structural equality → decidable check]*
3. **Finite candidate space.** The set F of all basis-assembled candidates is finite. *[from §0 step 7: bounded finite representations form a finite set]*

These follow from the postulate and the derived decidability (§0 steps 1–7). The additional condition, the one that turns verification into identification, is:

4. **Uniqueness (R4).** Exactly one candidate in F passes verification: |S| = 1.

**When |S| > 1.** Many tasks have multiple valid solutions (e.g., "write any correct sort"). The system returns |S| > 1: multiple candidates pass, and the system identifies no unique solution. To recover uniqueness, add a selection criterion (shortest, cheapest, lexicographically first). The new relation R'(x, y) = R(x, y) ∧ y = argmin Cost(y) may yield |S'| = 1. Theorem 2 is then about R', not R.

**When |S| = 0.** No candidate passes verification. The system rejects and produces no output.

**Real boundary.** The system requires decidable verification and finite F. These are non-negotiable for the inner half. But meeting them is the agent's responsibility (§1): the agent chooses an encoding that MAKES F finite and verification decidable. A task with undecidable verification (e.g., Halting Problem) can be reframed by the agent into a decidable bounded version ("halts within N steps?"). The system's guarantees are true of whatever bounded encoding the agent provides. The real boundary question is "does the agent's encoding make the task finite", never "is the task inherently finite".

**Naturally basis-selectable tasks** (require no codomain embedding):

| Task type | Why naturally selectable |
|-----------|------------------------|
| Permutations (sort, shuffle, rotate) | Output = input elements in new positions |
| Spatial transforms (mirror, flip, translate) | Values preserved, positions change |
| Selection / filtering | Output ⊂ input values |
| Pattern completion | Fill values drawn from existing input |
| Routing / assignment | Items reassigned, not created |
| Constraint satisfaction (sudoku, scheduling) | Solution = input values in valid positions |

**Tasks requiring codomain embedding** (need explicit basis in input):

| Task type | Basis to embed |
|-----------|---------------|
| Bounded arithmetic | Result values as lookup table |
| Classification | Label set {A, B, C, ...} |
| Bounded program synthesis | Grammar tokens / AST constructors |
| Bounded proof generation | Axioms + inference rules + symbols |
| Structured prediction (parsing, routing) | Finite output vocabulary |
| Translation (bounded vocabulary) | Target language tokens |

These are representative categories. The criterion is structural: does the output consist of values already present in the input (naturally selectable), or must the agent provide the output vocabulary explicitly (requires embedding)?


## §4. Algorithm

```
IN:   Game, Σ, COMPARE (from §2, §3)
OUT:  f' : candidate function
      result ∈ {PASS, REJECT}
      Invariant: PASS → f' ∈ S
```

**4.1. Encoding.** Represent each game element as a binary tree:

```
encode(0) = NULL
encode(n) = PAIR(encode(n-1), NULL)     for n > 0
atom(r, c, v) = PAIR(PAIR(encode(r), encode(c)), encode(v))
```

Under the encoding, all game properties must be derivable from atoms via COMPARE and projection. No external metadata.

**4.2. Validation.** Verify: ∀ o ∈ O, ∃ i ∈ I such that COMPARE(val(o), val(i)) = equal. If not → not representable in this encoding → REJECT(basis). This is the first diagnostic back to the agent (§1).

**4.3. Equations.** For each example pair, match each output atom to input atoms by value:

```
For each o ∈ O:
    candidates ← {i ∈ I : COMPARE(val(o), val(i)) = equal}
    |candidates| = 1 → unambiguous equation: o ← i
    |candidates| > 1 → ambiguous: hold for resolution
```

Each equation is one fact: the value at this output atom is the value at this input atom. Ambiguity is a diagnostic signal, never a branch. The system returns WHICH atoms are ambiguous and HOW MANY candidates each has.

**4.4. Features.** A feature is a structural predicate over (output position, input position), computable from COMPARE and projection. Examples:

```
same_row(o, i)   = COMPARE(row(o), row(i))
col_mirror(o, i) = COMPARE(col(o), subtract(max_c, col(i)))
rank(i, I)       = count_less(val(i), vals(I))
```

The agent defines the features per domain, in advance. The feature set fixes what mappings the system can express.

**4.5. Rule extraction.** From unambiguous equations, extract features that are:

- **Consistent**: same value across all unambiguous equations.
- **Informative**: not trivially true for all atom pairs.

The conjunction of consistent, informative features is the preliminary rule. This extraction method is one possible strategy. Theorems 1–2 (§5) are true of any candidate at the compilation gate (§4.7).

**4.6. Ambiguity resolution.** For ambiguous equations, score each candidate by match count against the preliminary rule. Select highest. Ties broken by fixed ordering. Rebuild rule from all equations.

The pipeline is linear: EXTRACT(unambiguous) → RESOLVE(ambiguous, preliminary) → REBUILD(all). Ambiguity resolution is a subroutine inside extraction, never a branch.

**4.7. Compilation.** The verification gate:

```
For each example pair (I, O):
    If apply(rule, I) ≠ O → REJECT(compile, example k)
```

No candidate passes compilation unless it reproduces all example outputs. The REJECT names the example index: the structural address for the agent.

**4.8. Execution.** If compilation passes, apply rule to I_test:

```
For each output position p:
    select input atom with highest feature-match score
    output[p] ← value of selected atom
```

Output shape must be derivable from input encoding or game definition. Scoring is a heuristic, and compilation (4.7) is the guarantee.


## §5. Guarantees

```
IN:   f', result, S, R4 (from §3, §4)
OUT:  Theorems 1–5, Properties, Totality
```

### Theorems

**Theorem 1 (Compilation).** If result = PASS for candidate f', then f' ∈ S.

*Proof.* PASS is f'(Iₖ) = Oₖ for all k (§4.7), and that is the membership condition of S. QED

**Theorem 2 (Safety).** If |S| = 1 and result = PASS, then f' = f*.

*Proof.* f' ∈ S (Theorem 1). S = {f*} (R4). f' ∈ {f*} → f' = f*. QED

**Corollary.** Given R4: any compiling output equals f*. Without R4: compilation guarantees example consistency, not uniqueness. Compilation failure: no output.

**Remark (identification is a fixpoint collapse).** R4, that is |S| = 1, is the condition under which the pass-set is a single point, S = {f*}, and there the verifier and the namer are one: to pass *is* to be f*. The three outcomes are three fixpoint counts of one operator: |S| = 1 a unique fixpoint (identification), |S| > 1 several (encoding insufficient), |S| = 0 none (REJECT, with nothing to name). Identification is verification collapsed to a point, the least-fixpoint reading of *Existence Is Finite* one scale up: Σ is the rule closed on itself, and the lone survivor is the check closed on itself.

Safety is from compilation (§4.7) and R4 alone, however the agent found f'. The feature search (§4.5–4.6) is one strategy among many: random sampling, exhaustive enumeration, neural network output, and manual construction all produce the same safety guarantee. The strategies differ in how quickly they find a passing candidate, and the guarantee is the same whenever they do. Safety is from verification, never from search.

**Theorem 3 (Identifiability).** If R4 is true and output values ⊆ input values, then under an exhaustive pair-enumeration schedule, at most N² COMPARE operations (N = atom count) classify all atom-pair equalities. With all pairs classified, f* is distinguishable from every other candidate via cached verification.

*Proof.* Every function in F maps output positions to input atoms (§3.2). If f ≠ g, they differ on some position p, selecting atoms i₁ ≠ i₂, so COMPARE(i₁, i₂) = not_equal. I1: N atoms → ≤ N² pairs. Each COMPARE classifies one pair. I3: classifications are permanent. After N² COMPAREs, all pairs classified. F is finite (§3.3). Any candidate verifiable against examples via cached results. |S| = 1 → exactly one passes → f* distinguished. QED

**Theorem 4 (Universality).** For any finite deterministic task under a semantics-preserving encoding, there exists an encoding and example set producing an R4-valid game. The framework requires decidable verification over the encoding, and the agent must choose the encoding so that verification reduces to structural comparisons.

*Proof.* Task finite → encoding yields finite atoms (I1). Basis-selectability: embed codomain into input (§3.2). NULL/PAIR encoding satisfies I2. Graph append-only by I3. Target representable in F (§0 step 9). F is extensional (§3.3): distinct members produce distinct decoded outputs on some input. With all possible inputs as examples: any g ≠ f_T differs on ≥1 decoded output → g ∉ S → |S| = 1 → R4. QED. Theorem 4 is an existence result: R4 is within the agent's reach for any finite deterministic task, and the cost of reaching it is outside the theorem. The construction in the proof is exhaustive supervision: a brute-force strategy. Its value is structural: the answer to "are there finite deterministic tasks where R4 is impossible?" is a definitive no (under adequate encoding). Practical efficiency is a question of encoding choice (§6).

By Theorem 4, R4 is within reach for any finite deterministic task. By Theorem 5 (below), when R4 is true, the system certifies f*. Together: any finite deterministic task has a certified solution. Practical identification with fewer examples is a question of the encoding (§6).

**Corollary (Normal form).** Any finite deterministic task with a computable verifier, a finite basis, and a semantics-preserving encoding whose target is representable in F is a V=I game. Theorem 2 (PASS → f' = f*) is in force once the system verifies R4. A given implementation's feature set may be too narrow to find a rule for every task in this class, and that is an implementation limitation (coverage), never a theoretical one (soundness). From theoretical representability it does not follow that a fixed feature extractor finds the rule.

**Theorem 5 (Completeness).** If F is finite, S is decidable, and |S| = 1, then certification yields PASS with f' = f*.

*Proof.* F finite → enumerable (§0 step 7). S computable: enumerate F, check each candidate (§0 step 8). |S| = 1 → sole member is f*. Certification: submit f* to compilation (§4.7). f* satisfies all examples (definition of S) → PASS. Theorem 2: PASS + |S| = 1 → f' = f*. QED

Theorems 1–2: soundness (PASS → correct). Theorem 5: completeness (preconditions → PASS). Extraction failure (§4.5–4.6) is a coverage limitation, and f* is still certifiable.

**Corollary (Outcome classification).** Every V=I game terminates in one of three states: |S| = 1 (identification, Theorem 2), |S| = 0 (no solution under this encoding), or |S| > 1 (encoding insufficient). *Proof.* |S| ∈ ℕ (§0 step 10). {0, 1, >1} partitions ℕ. QED

### Inner Properties

**5.1. Termination.** Every algorithm step operates on a finite domain (I1). No step contains unbounded loops. The algorithm terminates for any valid input. QED

**5.2. Complexity.** The algorithm terminates on all finite inputs (5.1). Each step processes a finite domain bounded by atoms, features, and example count. For the reference implementation with T <= 5, N <= 30, F = 5 and bounded-depth Peano encoding, the formal guarantee is termination, and empirically the execution completes in negligible time for these bounds.

**5.3. Cache monotonicity.** I3 → G_n ⊆ G_{n+1}. A cached comparison is permanent. `work(game, G) = |needed| − |cached|` is an estimate of the uncached comparison work. Monotonically decreasing for overlapping domains.

**5.4. Encoding independence.** Each encoding defines its own function space F and its own f*. Under R4, compilation yields f* for that encoding (Theorem 2). Cross-encoding agreement (that two encodings of the same task produce the same decoded test output) requires an additional premise: both encodings must be semantics-preserving (they represent the same target function on the same domain). This premise is external to the formal system.

**5.5. Totality.** The inner pipeline is linear: ENCODE → VALIDATE → EXTRACT → COMPILE → EXECUTE. Two binary gates (basis validation, compilation) are the only conditional transitions. Every path terminates at one of four states: PASS, REJECT(basis), REJECT(compile), MISMATCH. No execution path diverges, hangs, or reaches an undefined state. *Proof.* Each step operates on finite data (I1, §2). Each comparison is decidable (I2, §2). Ambiguity is resolved by deterministic scoring. QED

### Loop Properties

The following properties are true of the full loop (agent + system). §5.6–§5.7 and §5.9–§5.10 are unconditional (they follow from I3 and I1). §5.8 additionally requires a fixed agent protocol:

**5.6. Monotone information order.** By I3 (append-only graph), the system never retracts a cached comparison result. Each loop iteration may add comparisons to G, and no iteration removes them. The sequence G_0, G_1, ... is monotonically non-decreasing and bounded (finite domain). From this a total order over system states follows. *Proof.* G_n ⊆ G_{n+1} by I3. Strict inclusion when new comparisons occur. QED

**5.7. Monotonicity of information.** Each REJECT adds diagnostic information: which encoding failed, at which gate, at which position. The agent's knowledge of "what doesn't work" strictly grows, and no loop iteration reduces available information. With I3: both the system's comparison cache and the agent's rejection history are monotonically non-decreasing.

**5.8. Full loop determinism.** If the agent follows a fixed protocol (enumeration order over E), then: same task + same grammar + same protocol → same sequence of iterations → same result. The full loop is a deterministic function from (task, grammar, protocol) to {PASS(f*), REJECT}.

**5.9. Loop termination.** E finite (grammar bounded) + inner half terminates (§5.1) → outer loop terminates. At most |E| iterations, each finite. *Proof.* |E| is finite. Each iteration terminates (§5.1). Finite sum of finite steps is finite. QED

**5.10. Convergence.** The loop tries every encoding in E (finite enumeration). If any encoding's inner run produces PASS, the loop terminates with PASS. If no encoding produces PASS, the loop exhausts E and reports REJECT. The loop skips no encoding. An encoding may satisfy R4 yet produce REJECT if the extraction heuristic (§4.5–4.6) fails to find f*. An exhausted E without PASS proves only that the extractor failed on every encoding in E, and an R4-valid encoding may still be among them. This is an extraction limitation, never a soundness failure. Soundness (Theorem 2) is unconditional: any PASS is correct.

### Compositional Properties

**5.11. Games compose.** Output of game A = input encoding for game B. The composition is a V=I game. *Proof.* Game A output is finite (I1). Game B input is finite. Composition = two total functions in sequence (§5.5). Total ∘ Total = Total. Each game has its own S, its own R4. If both |S_A| = 1 and |S_B| = 1, the two gates verify the composition. QED

**5.12. Games decompose.** If task T = T₁ ∧ T₂ (conjunction of independent sub-tasks), then F_T ⊆ F₁ × F₂. Each sub-game is independently verifiable. *Proof.* If |S₁| = 1 and |S₂| = 1, then any candidate passing both checks is unique in the product space. Joint PASS = component-wise PASS. QED

**5.13. Sub-game spawn.** At any node in the pipeline, the agent can create a new V=I game to solve a sub-problem (e.g., "which features to try next?"). *Proof.* Sub-problem has finite candidate space (derived from finite parent space). Decidable check (is this candidate valid in the parent context?). I1–I3 inherited. The sub-game is a valid V=I instance. Its solution = the encoding for the parent game's next iteration (§1 step 1). QED

### Structural Properties

**5.14. Graph equivalence at every node.** At any point in the computation, the remaining sub-graph from that node to any terminal state has the same V=I structure: finite remaining space, decidable check, append-only cache. *Proof.* I1 is true at every node (finite data processed → finite remaining). I2 is true (COMPARE unchanged). I3 is true (G at this node ⊇ G at start). All three invariants are intact. QED

**5.15. Structural recurrence across levels.** The system at level N and level N+1 share the same triple structure: (finite space, decidable check, unique solution). The spaces, checks, and solutions differ in content, and the structural pattern is identical. *Proof.* Level N: space = F_N (finite), check = compilation (decidable), solution = f\*_N. Level N+1: space = E_N (finite), check = run(task, e).status (decidable, §5.5), solution = e\*. Both are instances of the V=I triple. QED


**5.16. Finite tower (conditional).** If each meta-level is itself encoded as a finite V=I game, the hierarchy terminates. *Proof.* Level 0: |F| finite. Level 1: |E| finite. Level 2: |grammars over E| = 2^|E|, finite. Each level's space is derived from the previous level's finite space. Finite operations on finite sets produce finite sets. QED

**5.17. Agent-system role duality.** The system at level N has the same functional role as the agent's tool T2 at level N+1. *Proof.* System at level N: takes candidate, returns PASS/REJECT. This is what an agent at level N+1 calls (T2). The agent's encoding-selection process: takes encoding candidate, returns PASS/REJECT via run(). Same functional interface, different level. QED

### Extended Cache Properties

**5.18. Cache transferability.** With the graph G after game A, game B is cheaper when the two games share structures. *Proof.* COMPARE(a, b) = structural equality, context-independent. A comparison cached during game A is valid during game B (same structures → same result). I3 → G only grows. work(B, G_after_A) ≤ work(B, G_empty). QED

**5.19. Idempotency.** A second run of the same encoding on the same task returns the same result, with zero new comparisons. *Proof.* I2 (fixed operations): same input → same output. I3: the second run finds every comparison cached. Same result, zero new work. QED

### Information Properties

**5.20. Revelation, not creation.** COMPARE(a, b) does not create a fact. The result (equal/not_equal) is structurally determined before the call: the trees are already equal or not. COMPARE reveals what is already the case. *Proof.* COMPARE is a pure function of its inputs (I2). Its output is determined by the structure of a and b, which exist before the call. No randomness, no side effects. The comparison result is a pre-existing structural fact made explicit. QED

**5.21. COMPARE is the sole source of equality-classification facts inside the pipeline.** NULL and PAIR create structure but produce no information about existing structures. Projection (left/right) decomposes structure but produces no equality information. Only COMPARE produces a new equality fact: equal or not_equal. The encoding and feature set carry prior structural information into the pipeline, and COMPARE is the sole source of new equality classifications during execution. *Proof.* I2: all operations reduce to NULL, PAIR, COMPARE, projection. NULL and PAIR are deterministic (no input-dependent output). Projection selects a sub-structure (no new information about equality). Only COMPARE takes two inputs and produces a classification. QED

**5.22. S is monotonically non-increasing.** Each COMPARE call can only eliminate candidates from S or leave S unchanged. No COMPARE call adds a candidate. *Proof.* S = {f ∈ F : f matches all examples}. A new COMPARE result adds to G (I3). A new fact in G can only witness that some f fails on some example → f leaves S. A previously failing f fails still: the example it failed on is unchanged. |S_{n+1}| ≤ |S_n|. QED

**5.23. No self-reference.** The system's operations (I2) do not include any operation that takes the pipeline, the graph G, or the system's state as input. The system cannot inspect its own structure, configuration, or execution history from within the inner pipeline. *Proof.* I2 is the list of all operations: NULL, PAIR, COMPARE, projection. None takes the pipeline or G as an argument. The inner pipeline processes encoded data (finite binary trees) and nothing else. QED

**5.24. Encoding-bounded scope.** The inner pipeline receives only the encoded representation. It has no access to the original task, the agent, the grammar, or any information not present in the encoding. Two different encodings of the same task create two separate, non-communicating pipeline executions. *Proof.* The pipeline's input is (encoded game, feature set). All pipeline operations (§4.1–4.8) reference only this input. No step references the agent, the grammar, or any external state. The pipeline is a pure function of its encoded input. QED

**5.25. Order as sole dynamic variable.** For a fixed encoding, task, and feature set, the system's facts are pre-existing (§5.20), operations are fixed (I2), the cache is append-only (I3), the space is finite (I1), and correctness is determined (Theorem 2). The only free parameter is the order in which the agent reveals facts via COMPARE calls. Different orders produce different path lengths through the comparison lattice but reach the same endpoint. Correctness is order-invariant, and efficiency is order-determined. I3 is what makes order matter: with irreversibility, each ordering commits to a path. Diagnostics (§6) are order guidance: each REJECT prunes branches the agent need not revisit. *Proof.* §5.20: facts are pre-existing. I2: operations fixed. I3: cache append-only. I1: space finite. Theorem 2: correctness is from R4 and PASS, not from traversal order. §5.8: same order → same result. §5.10: all complete traversals of E reach the same outcome. The traversal order σ determines iteration count T(σ), which ranges from 1 (valid encoding tried first) to |E| (tried last). QED. *Remark:* The ratio T_min / T_max defines an intrinsic task complexity within the framework. At T_min = 1 the task is trivially distinguishable, and at T_min = N² every atom-pair comparison is needed. This measure is derivable from §5.22 (S-shrinkage rate per COMPARE) and Theorem 3 (N² upper bound).

*Remark (information-theoretic interpretation).* Identifying f\* from F requires log₂(|F|) bits of information (Shannon). Each COMPARE produces a binary outcome: at most 1 bit of information about f* under independence. In practice comparisons are generally correlated with prior results, so many outcomes are worth less than 1 bit. The bound is met with equality when the outcome bisects the remaining candidate space, and with less when the outcome is predictable from prior comparisons. N atoms yield N² perspectives (§5.2), which always exceeds log₂(|F|): the comparison space is redundant. When candidates differ across d independent dimensions and d > log₂(|F|), the foundation (minimum claims for identification) is bounded by d, not log₂(|F|): with any dimension skipped, some candidates are indistinguishable. The optimal claim order (§5.25) achieves ⌈log₂(|F|)⌉ claims when d ≤ log₂(|F|), and when d > log₂(|F|) the dimensional bound dominates.

*Remark (axis alignment).* The monotone properties (§5.6, §5.7, §5.20, §5.22) are simultaneously monotone in the same direction: information grows, rejections accumulate, candidates only leave S, and facts are pre-existing. No execution step can advance one axis while reversing another. This global co-orientation follows from I3 alone: without append-only, the cache admits retraction, a retraction re-admits eliminated candidates, §5.22 is broken, and the axes are misaligned. I3 is thus the alignment generator: the single derived property that forces all monotone axes to co-orient. A consequence: saturation (1 − |S|/|F|) is an incorruptible progress metric. It cannot increase without genuine elimination and cannot decrease at all. At saturation = 1, identification is complete (Theorem 2).

**5.26. Cross-task saturation.** A finite domain D under a fixed encoding E contains K ≤ |F| distinct rule classes (equivalence classes of tasks that share the same f\*). Define the library L as the set of certified pairs (features, f\*) accumulated across tasks via PASS. L inherits I3: the system adds entries and never removes one (each entry is a cached identification result, and I3 is true of identification facts as of comparison facts). Each PASS adds at most one entry (Theorem 2: f\* is unique for that task). |L| ≤ K (I1: finitely many rule classes). After K distinct PASSes, the system resolves every future task whose rule class is in D from the cache: it matches features against L, verifies via the compilation gate (§4.7), and returns PASS if the cached f\* compiles on the new examples.

*Proof.* I1: D finite → K finite. Theorem 2: each entry correct (f' = f\*). I3: entries permanent. §5.18: cached identifications are valid across tasks (COMPARE is context-independent). §5.19: same rule class → same f\* → compilation succeeds on new examples of that class. After K entries, every rule class has a cached f\*. Any new task in D matches some entry. Compilation gate verifies. PASS. QED

The saturated library is unique up to insertion order. *Proof.* Each entry is the unique f\* for its rule class (Theorem 2). §5.25: correctness is order-invariant. Two agents processing the same domain under the same encoding produce libraries with identical entries, differing only in the order the agents added them. The library's content is fixed by the domain, never by the agent.

*Remark (saturation levels).* Saturation within a single task (§5.22: 1 − |S|/|F|) and saturation across tasks (|L|/K) are distinct measures at different levels. The first tracks identification progress for one f\*, and the second tracks coverage of the domain. Both are monotonically non-decreasing and bounded. Cross-task saturation converges to 1 when L covers all rule classes in D. At that point the system produces no new comparisons: it resolves every task from cached results.

## §6. Interface

The loop (§1) has two participants with distinct functions, guarantees, and boundaries.

### System (inner half)

**Function:** Given an encoding, produce a certified answer or a structural diagnostic.

**Guarantees:** Output equals f* under R4 + PASS (Theorem 2). Compilation failure → no output produced (REJECT). Termination, determinism, and cache correctness are unconditional. Full proofs in §5.

**System boundaries** (non-negotiable: the agent must ensure they are true):

| Boundary | Why | Agent's role |
|----------|-----|-------------|
| Verification must be computable | Undecidable R(x,y) → no sound gate | Agent chooses a decidable bounded version |
| Candidate space must be finite | Infinite F → R4 undecidable in general | Agent's encoding MAKES F finite |
| f* is encoding-local | Cross-encoding agreement needs external premise (§5.4) | Agent selects semantics-preserving encodings |
| Correctness is relative to R(x,y) | If verifier doesn't capture semantics, f* may not match intent | Agent designs the verifier |

The system never chooses. It computes. Every output is determined by the encoding. The agent is responsible for an encoding that meets the system's requirements.

### Agent (outer half)

**Function:** Provide encodings. Read diagnostics. Modify and re-submit.

**Agent responsibilities** (the system cannot do these):

| Responsibility | Why the system can't |
|----------------|---------------------|
| Bound the unbounded | Transform infinite/undecidable tasks into finite/decidable ones by choosing bounds |
| Select encoding grammar E | Requires domain knowledge: what features are relevant |
| Design features | Requires knowing what "same row" or "mirror" names in this domain |
| Decide when to stop | The loop halts when the agent says so |
| Interpret \|S\| > 1 | Multiple valid solutions = agent must add selection criterion or accept ambiguity |

**Agent boundaries** (what limits the agent's effectiveness):

| Boundary | Consequence |
|----------|------------|
| Grammar E is finite | Agent can only try encodings in E: if none compiles, the task is beyond E |
| Features are predefined per domain | REJECT(compile) is possibly "features too narrow", never proof of "task unsolvable" |
| No meta-learning | Agent must design features manually, with no automatic feature adaptation |

### Agent Toolset

Five operations, each derived from the system's structure:

| Tool | Derived from | Function |
|------|-------------|----------|
| T1: ENUMERATE | §5.8 (finite grammar) | List all encodings in E |
| T2: RUN | §1 step 2 (call system) | Execute inner pipeline on one encoding |
| T3: READ | §1 step 4 (parse diagnostic) | Extract gate and structural address from REJECT |
| T4: MAP | §6 REJECT table (above) | Convert address to encoding component |
| T5: MODIFY | Grammar structure (finite components) | Replace component value with alternative |

T1 + T2 = sufficient for correctness (brute enumeration finds f*). T3 + T4 + T5 = sufficient for directed search (diagnostic = gradient). All five = minimal complete agent. T2 IS the system (§5.17): the agent does not contain the system, the agent calls it.

### What REJECT carries

Each REJECT is a message FROM the system TO the agent with a structural address:

| REJECT type | Structural address | Agent action |
|-------------|-------------------|--------------|
| REJECT(basis, value V at position P) | V ∉ input basis | Extend basis or change encoding |
| REJECT(compile, example k) | Rule fails on example k | Add features or change representation |
| MISMATCH | Compiles but wrong on test | Add training examples or refine features |
| \|S\| > 1 (if checked) | Multiple candidates pass | Add selection criterion |

### Encoding Selection

Given a bounded encoding grammar E = {e₁, ..., eₘ}:

```
For each e ∈ E:
    Run Algorithm(encode(task, e))
    If PASS → accept e; stop
If no e passes → REJECT
```

This terminates (E finite, each run terminates by §5.1). Each compiling encoding yields its own encoding-local f* under R4.

**What the grammar captures.** The grammar E defines HOW to represent task elements as binary trees. For grid tasks: which positional attributes to encode, what depth, which Peano mapping. Grammar design is per-domain (grids, sequences, trees), never per-task.

**The separation.** The agent provides the encoding. The system certifies the result. Once the agent fixes the encoding, everything the system does is proven (§5), and the one free parameter left is the order of verification (§5.25). Everything the agent does is engineering.

## Appendix A: Proof Chain

Every claim in the paper has an explicit dependency path to the postulate. The complete dependency map is below: each line is one claim with the prior lines it follows from. No unsupported claims.

```
DERIVATION (§0):
  A1:  A finite structure exists.                                        [postulate]
  A2:  A finite structure is not nothing.                                 [from A1: else postulate is vacuous]
  A3:  Structure ≠ nothing → a distinction exists.                        [from A2: "not" IS the distinction]
  A4:  Structural equality on finite structures is decidable.             [from A1 + A3: finite components → finite comparisons → terminates]
  A5:  The test halts.                                                   [from A4: non-halting = never distinguishes]
  A6:  A halting test examines finite data.                              [from A5: finite time → finite data]
  A7:  Finite data of bounded size → finite space F.                     [from A6: combinatorics]
  A8:  S = {y ∈ F : COMPARE(y, target) = EQUAL} is computable.           [from A4 + A7: decidable equality + finite space]
  A9:  The structure is representable in F.                               [from A1 + A7; S-membership requires encoding's test]
  A10: |S| is computable.                                                [from A8]
  A11: |S|=1 → verification = identification.                            [from A9 + A10]
  A12: Order of verification is the sole degree of freedom.               [from A4 + A7 + A8: test fixed, space fixed, facts permanent → only sequence varies]
       Mutable test breaks A4; growing space breaks A7;                   [contrapositive: extra DOF → specific step fails → |S| undetermined]
       retractable record breaks A8.

SYSTEM (§2):
  I1: All structures finite.                              [from postulate: finite components]
  I2: Distinction (PAIR) sole primitive; NULL, COMPARE, proj derived. [NULL from finite base case; COMPARE from structural recursion; proj from destructuring]
  I3: G append-only.                                      [from finiteness + purity: results cannot change]

PROBLEM (§3):
  P1: F = functions from output positions to decoded values. [§3.2 + extensional]
  P2: |F| ≤ |V|^|O|, finite. F extensional by construction. [I1, P1]
  P3: S = {f ∈ F : f matches all examples}.               [definition]
  P4: R4: |S| = 1. Encoding adequacy measure.              [§0 step 9]

IDENTIFIABILITY (§5):
  D1: N atoms → ≤ N² pairs.                               [I1]
  D2: Each COMPARE classifies one pair.                    [I2]
  D3: Classifications permanent.                           [I3]
  D4: Under exhaustive pair schedule, N² COMPAREs classify all. [D1, D2, D3]
  D5: Any f ∈ F verifiable via cached COMPAREs.            [D4, P1]
  D6: |S| = 1 → exactly one passes → f* distinguished.    [P4, D5]

COMPILATION (§4.7):
  C1: Checks f'(Iₖ) = Oₖ for all k.                      [§4.7]
  C2: Fail → REJECT.                                      [§4.7]
  C3: Pass → f' ∈ S.                                      [C1, P3]

ENCODING INDEPENDENCE:
  E1: Each encoding defines its own F, S, f*.              [encoding-local]
  E2: R4 + PASS → f' = f* for that encoding.              [S3]
  E3: Cross-encoding decoded agreement requires             [external premise]
      semantics-preservation (external to proof chain).

SAFETY (§5):
  S1: Output produced only if PASS.                        [C2]
  S2: PASS → f' ∈ S.                                      [C3]
  S3: |S| = 1 → f' = f*.                                  [S2, P4]
  S4: R4 + PASS → output equals f*.                       [S1, S2, S3]

UNIVERSALITY (§5):
  U1: Finite task → finite atoms.                          [I1]
  U2: NULL/PAIR encoding → I2 holds.                       [I2]
  U3: Append-only → I3 holds.                              [I3]
  U4: F extensional → distinct g ≠ f_T differs on ≥1 output. [P2]
      All inputs as examples → g ∉ S → |S| = 1 → R4.       [P2, finite domain]
  U5: Requires: f_T representable, computable verifier,      [external premises]
      finite basis.

COMPLETENESS (§5):
  CM1: F enumerable.                                        [A7, I1]
  CM2: S computable by enumeration + membership check.      [A8, P3]
  CM3: |S| = 1 → f* found.                                 [CM2, P4]
  CM4: f* satisfies all examples → compilation succeeds.    [CM3, C1]
  CM5: PASS + |S| = 1 → f' = f*.                           [CM4, S3]
  CM6: Outcome ∈ {|S|=0, |S|=1, |S|>1}. Exhaustive.        [A10: |S| ∈ ℕ]

INCOMPLETENESS:
  L1: Feature search may fail to find f' ∈ S.
  L2: Compilation rejects.                                 [C2]
  L3: Rejection produces no output.                         [S1]
  L4: Exhaustive enumeration of P2 would be complete.      [P2, D5]

TERMINATION:
  T1: Each step domain finite.                             [I1]
  T2: No unbounded loops.                                  [§4]
  T3: Terminates.                                          [T1, T2]

LOOP (§1):
  G1: Grammar E finite.                                    [bounded grammar premise]
  G2: Each encoding run terminates.                        [T3]
  G3: Search terminates.                                   [G1, G2]
  G4: Compiling encoding yields encoding-local f* under R4. [S3]
  G5: Per-task enumeration is finite; grammar adequacy is external. [G1, G3]

TOTALITY (§1):
  TOT1: Inner pipeline is linear: ENCODE → VALIDATE → EXTRACT → COMPILE → EXECUTE.  [§4]
  TOT2: Two binary gates (basis, compilation) are the only conditionals.              [§4.2, §4.7]
  TOT3: Every path terminates at {PASS, REJECT(basis), REJECT(compile), MISMATCH}.   [T3, TOT2]
  TOT4: No execution path diverges, hangs, or reaches an undefined state.             [TOT1, TOT2, TOT3]

LOOP PROPERTIES (§5.6–5.10):
  LP1: G_n ⊆ G_{n+1} (arrow of time).                     [I3]
  LP2: Diagnostic information monotonically non-decreasing. [LP1, C2]
  LP3: Full loop deterministic (given fixed protocol).      [TOT4, G1]
  LP4: Loop terminates in at most |E| iterations.           [G1, T3]
  LP5: If valid encoding exists in E, loop finds it.        [LP4, finite enumeration]

COMPOSITIONAL (§5.11–5.13):
  CO1: Output of game A = valid input for game B.            [I1]
  CO2: Total ∘ Total = Total.                                [TOT4, CO1]
  CO3: Games decompose: T = T1 ∧ T2 → verify independently. [CO2, P4]
  CO4: Sub-game spawn: any node can create V=I sub-game.     [I1, I2, I3 inherited]
  CO5: Sub-game solution = parent's next encoding.           [CO4, CO1]

STRUCTURAL (§5.14–5.17):
  ST1: I1, I2, I3 hold at every node in computation graph.   [invariant preservation]
  ST2: Sub-graph from any node = V=I instance.               [ST1]
  ST3: Level N and N+1 share same triple structure.          [ST2, G1; structural recurrence]
  ST4: Tower terminates when each level explicitly encoded.  [I1: finite at each level; conditional]
  ST5: Agent at level N = candidate at level N+1.            [ST3; same role, not identity]
  ST6: System at level N = agent tool T2 at level N+1.       [ST5; functional duality]

CACHE (§5.18–5.19):
  CA1: COMPARE is context-independent.                       [I2]
  CA2: G from game A valid for game B.                       [CA1, I3]
  CA3: work(B, G_after_A) ≤ work(B, G_empty).               [CA2]
  CA4: Same encoding twice → same result, zero new work.     [LP3, I3]

INFORMATION (§5.20–5.25):
  IN1: COMPARE reveals pre-existing facts (revelation).      [I2: pure function]
  IN2: COMPARE is sole source of equality facts.             [I2: only COMPARE classifies]
  IN3: S monotonically non-increasing.                       [I3: new facts only eliminate]
  IN4: No self-reference in pipeline.                        [I2: ops don't take pipeline as arg]
  IN5: Pipeline sees only encoded representation.            [pure function of input]
  IN6: ORDER is sole dynamic variable.                       [IN1, I1, I2, I3, Thm 2]

INFORMATION-THEORETIC (remark):
  IT1: Identification requires log₂(|F|) bits.              [I1, Shannon]
  IT2: Optimal order: ⌈log₂(|F|)⌉ claims.                  [IN6, IT1]
  IT3: N atoms → N² perspectives.                           [D1, D2]
  IT4: N² ≥ log₂(|F|) (comparison redundancy).             [IT3, IT1]
  IT5: f* at level N = substrate at level N+1.              [CO1, ST3, ST6]
  IT6: Foundation ≥ separating dimensions d.                 [I1, A4: skip d → |S|>1]

AXIS ALIGNMENT (remark):
  AX1: All monotone properties co-oriented.                  [I3 → §5.6, §5.7, §5.22; I2 → §5.20]
  AX2: Saturation = incorruptible progress metric.           [AX1, §5.22]
  AX3: I3 is the alignment generator.                        [without I3 → §5.22 breaks → axes misalign]

CROSS-TASK SATURATION (§5.26):
  SAT1: Domain D has K ≤ |F| distinct rule classes.          [I1, P2]
  SAT2: Each PASS adds ≤1 certified entry to library L.      [S3, I3]
  SAT3: |L| monotonically non-decreasing, bounded by K.      [I3, SAT1]
  SAT4: After K PASSes, all tasks in D resolve via lookup.    [SAT2, SAT3, CA2, §5.19]
  SAT5: L unique up to insertion order.                       [S3, §5.25: each entry = f*;
                                                               correctness order-invariant]
  SAT6: L invariant across agents.                            [I2: COMPARE pure; SAT5]
```


## Appendix B: Reference Implementation

> Note: Appendices B and C are the paper's record of its own reference artifacts, kept as
> they were when the author first proved the result: a Python runtime solver and an early
> Swift sketch. The package around this page is that sketch grown into a construction of its
> own, with its own grammar, ``Law``, which the sketch predates (`struct`, for one, is a form
> the grammar now forbids, §0″). Read the appendices as the paper's record, and read the
> package as the current form, applied in the `Examples` and `Organization` modules.

The implementation is in modules, one per formal concern:

1.  **`primitives.py` (§2):** Peano encoding and structural equality. Domain-agnostic foundation.
2.  **`engine.py` (§4 core):** Rule extraction, ambiguity resolution, match scoring. Operates solely on structural predicates, and never reads cells, grids, or Peano.
3.  **`representation.py` (§3–§4 domain):** Grid cells, grids, features, equations, execution, and compilation.
4.  **`tasks.py` (Data):** Task definitions in ARC-AGI format.
5.  **`main.py` (Pipeline):** Connects representation, engine, and data.

```
Encoding:    Peano (0 -> NULL, n -> PAIR(n-1, NULL))
Atoms:       PAIR(PAIR(row, col), value)
COMPARE:     Python == on nested tuples
Features:    5 (same_row, same_col, row_mirror, col_mirror, rank)
Compilation: full example verification before test execution
```

Verified tasks: fill minority, fill majority, horizontal flip, vertical flip, identity. 5/5 compiled and solved. These are demonstrations, with no claim of coverage of the full task class. The task format is ARC-AGI's (Abstraction and Reasoning Corpus): input-output grid pairs, where the agent infers the transformation rule from the examples.


## Appendix C: Type-Level Proof

The Python implementation (Appendix B) verifies at runtime. In a stronger form the compiler itself is the verifier for the encoded type constraints: if the program compiles, the encoded rule constraints are proven. For those constraints no runtime check is needed.

In Swift, Peano naturals are types (`Z`, `S<N>`). Grid features are type constraints:

```swift
// SameRow requires: In.Row == Out.Row  (compile-time check)
enum SameRow<In: CellType, Out: CellType>: Rule
    where In.Row == Out.Row { ... }

// ShiftRight requires: S<In.Col> == Out.Col
enum ShiftRight<In: CellType, Out: CellType>: Rule
    where In.Row == Out.Row, S<In.Col> == Out.Col { ... }
```

The compilation gate (§4.7) is literal here:

```swift
// CompilationGate<R> compiles iff R's constraints are satisfiable.
// If it compiles, the rule is verified. If not, the compiler rejects.
struct CompilationGate<R: Rule>: Gate {
    // Compilation of this struct IS the verification.
    static func verify() {}

    // Type inference determines the output. No search needed.
    static func identify(input: R.Input.Type) -> R.Output.Type {
        return R.Output.self
    }
}
```

Demonstration:

```swift
typealias In  = Cell<N1, N1, N5>  // row=1, col=1, val=5
typealias Out = Cell<N1, N2, N5>  // row=1, col=2, val=5

// This line compiles iff ShiftRight AND SameValue holds for In -> Out.
typealias Mapping = And<ShiftRight<In, Out>, SameValue<In, Out>>
let gate = CompilationGate<Mapping>.self  // Compilation = PASS
```

With `Out` as `Cell<N1, N3, N5>`, the program does not compile: the compiler rejects the rule. `PASS = compilation success`. `REJECT = compilation error`.

For the encoded constraints, verification and identification are one operation: the compiler checks the constraints (verification) and determines the unique satisfying type assignment (identification). This is §0 step 11 executed by the compiler for the specific constraints encoded as types. Full identification of the task's target function additionally requires R4 (§3.5) and a semantics-preserving encoding (§5.4).

Source: Python (runtime solver, ARC-AGI tasks) and Swift (compile-time proof). Successful compilation confirms all encoded constraints are verified.

## Topics

### Theorems this paper proves

- ``CandidatesOnlyLeave``
- ``Universality``
- ``OrderIsOnlyFreedom``
